# Currency Handling Technical Specification

## Overview

This document provides a comprehensive technical specification for implementing multi-currency support in PopSystem. As we expand internationally, robust currency handling becomes critical for user experience, accurate billing, financial reporting, and compliance.

## Currency Architecture

### Three-Currency Model

PopSystem implements a three-currency architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  USER PREFERENCES                                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Display Currency: What user wants to see (USD)       │  │
│  │ Billing Currency: What they're actually charged (EUR)│  │
│  │ Base Currency: Company reporting currency (USD)      │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ Display Currency│────>│Billing Currency  │────>│  Base Currency   │
│  (User Pref)    │     │  (Transaction)   │     │  (Reporting)     │
│                 │     │                  │     │                  │
│  Show: $100     │     │  Charge: €92.50  │     │  Report: $100    │
│  (Convenience)  │     │  (Actual billing)│     │  (Finance/CFO)   │
└─────────────────┘     └──────────────────┘     └──────────────────┘
```

**Display Currency**
- User's preferred viewing currency
- Used throughout UI for convenience
- Can differ from billing currency
- Example: US expat in Germany may want to see USD but be billed in EUR

**Billing Currency**
- Currency in which transaction actually occurs
- Determined by user's billing address/country
- Used for invoices and payment processing
- Legal/tax implications based on this currency

**Base Currency**
- Company's reporting currency (USD for PopSystem)
- All financial reports, ARR, metrics in base currency
- Internal accounting and finance
- Exchange rate tracking relative to this currency

## Data Model

### Currency Table

```sql
CREATE TABLE currencies (
    code CHAR(3) PRIMARY KEY,              -- ISO 4217 code (USD, EUR, GBP, etc.)
    name VARCHAR(100) NOT NULL,            -- United States Dollar
    symbol VARCHAR(10) NOT NULL,           -- $
    decimal_places SMALLINT DEFAULT 2,     -- Number of decimal places (0 for JPY, 2 for USD, 3 for some)
    active BOOLEAN DEFAULT true,           -- Whether we support this currency
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Supported currencies
INSERT INTO currencies (code, name, symbol, decimal_places) VALUES
('USD', 'United States Dollar', '$', 2),
('EUR', 'Euro', '€', 2),
('GBP', 'British Pound', '£', 2),
('CAD', 'Canadian Dollar', 'CA$', 2),
('MXN', 'Mexican Peso', 'MX$', 2),
('BRL', 'Brazilian Real', 'R$', 2),
('JPY', 'Japanese Yen', '¥', 0),
('CNY', 'Chinese Yuan', '¥', 2),
('AUD', 'Australian Dollar', 'A$', 2);
```

### Exchange Rates Table

```sql
CREATE TABLE exchange_rates (
    id BIGSERIAL PRIMARY KEY,
    from_currency CHAR(3) NOT NULL REFERENCES currencies(code),
    to_currency CHAR(3) NOT NULL REFERENCES currencies(code),
    rate DECIMAL(20, 10) NOT NULL,         -- High precision for accuracy
    rate_date DATE NOT NULL,                -- Date this rate is effective
    source VARCHAR(50) NOT NULL,            -- API source (e.g., 'openexchangerates')
    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(from_currency, to_currency, rate_date),
    CHECK (from_currency != to_currency),
    CHECK (rate > 0)
);

CREATE INDEX idx_exchange_rates_lookup
ON exchange_rates(from_currency, to_currency, rate_date DESC);

-- Example rates (1 USD to other currencies)
INSERT INTO exchange_rates (from_currency, to_currency, rate, rate_date, source) VALUES
('USD', 'EUR', 0.9250, '2025-12-21', 'openexchangerates'),
('USD', 'GBP', 0.7950, '2025-12-21', 'openexchangerates'),
('USD', 'CAD', 1.3500, '2025-12-21', 'openexchangerates'),
('USD', 'MXN', 18.5000, '2025-12-21', 'openexchangerates'),
('USD', 'BRL', 5.2500, '2025-12-21', 'openexchangerates'),
('USD', 'JPY', 148.5000, '2025-12-21', 'openexchangerates');
```

### User Currency Preferences

```sql
CREATE TABLE user_currency_preferences (
    user_id BIGINT PRIMARY KEY REFERENCES users(id),
    display_currency CHAR(3) REFERENCES currencies(code),
    billing_currency CHAR(3) NOT NULL REFERENCES currencies(code),
    billing_country CHAR(2) NOT NULL,       -- ISO 3166-1 alpha-2
    auto_detect BOOLEAN DEFAULT true,       -- Auto-detect from location
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- User preferences example
INSERT INTO user_currency_preferences
(user_id, display_currency, billing_currency, billing_country) VALUES
(1001, 'USD', 'USD', 'US'),                -- US user, everything in USD
(1002, 'EUR', 'EUR', 'DE'),                -- German user, everything in EUR
(1003, 'USD', 'EUR', 'DE'),                -- US expat in Germany, displays USD, billed EUR
(1004, 'EUR', 'GBP', 'GB');                -- UK user who prefers EUR display
```

### Pricing Tables

```sql
-- Base pricing in USD (our base currency)
CREATE TABLE price_tiers (
    id BIGSERIAL PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    base_price_usd DECIMAL(10, 2) NOT NULL,
    billing_period VARCHAR(20) NOT NULL,   -- 'monthly', 'annual'
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Regional pricing adjustments
CREATE TABLE regional_pricing (
    id BIGSERIAL PRIMARY KEY,
    price_tier_id BIGINT REFERENCES price_tiers(id),
    currency CHAR(3) REFERENCES currencies(code),
    price DECIMAL(10, 2) NOT NULL,
    adjustment_type VARCHAR(20),            -- 'market_adjusted', 'exchange_rate', 'promotional'
    effective_date DATE NOT NULL,
    expiry_date DATE,
    created_at TIMESTAMP DEFAULT NOW(),

    UNIQUE(price_tier_id, currency, effective_date)
);

-- Example pricing
INSERT INTO price_tiers (plan_name, base_price_usd, billing_period) VALUES
('Starter', 99.00, 'monthly'),
('Professional', 199.00, 'monthly'),
('Enterprise', 499.00, 'monthly');

-- Regional pricing (market-adjusted, not just currency conversion)
INSERT INTO regional_pricing (price_tier_id, currency, price, adjustment_type, effective_date) VALUES
-- Starter plan
(1, 'USD', 99.00, 'exchange_rate', '2025-01-01'),
(1, 'EUR', 92.00, 'market_adjusted', '2025-01-01'),  -- €92 vs direct conversion €91.58
(1, 'GBP', 79.00, 'market_adjusted', '2025-01-01'),  -- £79 vs direct conversion £78.71
(1, 'MXN', 1499.00, 'market_adjusted', '2025-01-01'), -- Adjusted for market (vs 1831.50 direct)

-- Professional plan
(2, 'USD', 199.00, 'exchange_rate', '2025-01-01'),
(2, 'EUR', 185.00, 'market_adjusted', '2025-01-01'),
(2, 'GBP', 159.00, 'market_adjusted', '2025-01-01'),
(2, 'MXN', 2999.00, 'market_adjusted', '2025-01-01');
```

### Transaction Tables

```sql
CREATE TABLE transactions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),

    -- Amount in billing currency (what was actually charged)
    amount DECIMAL(10, 2) NOT NULL,
    currency CHAR(3) NOT NULL REFERENCES currencies(code),

    -- Amount in base currency (for reporting)
    amount_usd DECIMAL(10, 2) NOT NULL,
    exchange_rate DECIMAL(20, 10) NOT NULL,
    exchange_rate_date DATE NOT NULL,

    -- Transaction details
    type VARCHAR(50) NOT NULL,              -- 'subscription', 'invoice', 'refund', etc.
    status VARCHAR(50) NOT NULL,            -- 'pending', 'completed', 'failed', 'refunded'
    description TEXT,

    -- External references
    stripe_payment_intent_id VARCHAR(100),
    invoice_id BIGINT REFERENCES invoices(id),

    -- Timestamps
    transaction_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_transactions_user ON transactions(user_id, transaction_date DESC);
CREATE INDEX idx_transactions_currency ON transactions(currency, transaction_date DESC);
```

### Invoice Tables

```sql
CREATE TABLE invoices (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    invoice_number VARCHAR(50) UNIQUE NOT NULL,

    -- Currency details
    currency CHAR(3) NOT NULL REFERENCES currencies(code),
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    total DECIMAL(10, 2) NOT NULL,

    -- Base currency equivalent (for reporting)
    subtotal_usd DECIMAL(10, 2) NOT NULL,
    tax_amount_usd DECIMAL(10, 2) DEFAULT 0,
    total_usd DECIMAL(10, 2) NOT NULL,
    exchange_rate DECIMAL(20, 10) NOT NULL,
    exchange_rate_date DATE NOT NULL,

    -- Invoice details
    status VARCHAR(50) NOT NULL,            -- 'draft', 'sent', 'paid', 'void', 'refunded'
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE,

    -- Display preferences (what currency user saw when invoice was generated)
    display_currency CHAR(3) REFERENCES currencies(code),

    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_invoices_user ON invoices(user_id, issue_date DESC);
CREATE INDEX idx_invoices_status ON invoices(status, issue_date DESC);
```

## Exchange Rate Management

### Exchange Rate Providers

| Provider | Pros | Cons | Cost | Update Frequency |
|----------|------|------|------|------------------|
| **Open Exchange Rates** | Reliable, 170+ currencies, Good API | Paid for commercial use | $12/mo (1k/req/mo) | Hourly |
| **Fixer.io** | EU-based, Good for EUR | Limited free tier | $10/mo | Daily (paid), Hourly (premium) |
| **CurrencyLayer** | Free tier available | Rate limits | Free - $10/mo | Daily |
| **XE.com API** | Very accurate, Trusted brand | Expensive | $79/mo+ | Real-time |
| **European Central Bank** | Free, Official EU rates | EUR-centric, Daily only | Free | Daily |
| **Federal Reserve** | Free, Official US rates | USD-centric, Daily only | Free | Daily |

**Recommended**: Open Exchange Rates
- Good balance of cost, reliability, and features
- Covers all our initial markets
- Hourly updates sufficient for our use case
- Simple API integration

### Rate Update Strategy

```javascript
// Exchange rate service
class ExchangeRateService {
  constructor() {
    this.baseCurrency = 'USD'; // PopSystem's base currency
    this.provider = 'openexchangerates';
    this.apiKey = process.env.OXR_API_KEY;
  }

  /**
   * Fetch latest rates from provider
   * Runs on schedule (every hour)
   */
  async updateRates() {
    try {
      const response = await fetch(
        `https://openexchangerates.org/api/latest.json?app_id=${this.apiKey}&base=${this.baseCurrency}`
      );

      const data = await response.json();
      const rateDate = new Date(data.timestamp * 1000);

      // Store rates in database
      for (const [currency, rate] of Object.entries(data.rates)) {
        await this.saveRate({
          fromCurrency: this.baseCurrency,
          toCurrency: currency,
          rate: rate,
          rateDate: rateDate,
          source: this.provider
        });
      }

      // Also store inverse rates (for direct lookups)
      for (const [currency, rate] of Object.entries(data.rates)) {
        await this.saveRate({
          fromCurrency: currency,
          toCurrency: this.baseCurrency,
          rate: 1 / rate,
          rateDate: rateDate,
          source: this.provider
        });
      }

      console.log(`Updated ${Object.keys(data.rates).length} exchange rates`);
    } catch (error) {
      console.error('Failed to update exchange rates:', error);
      // Alert monitoring system - stale rates are critical
      await this.alertStaleRates();
    }
  }

  /**
   * Get exchange rate for a specific date
   * Uses historical data if date is in the past
   */
  async getRate(fromCurrency, toCurrency, date = new Date()) {
    // Same currency, rate is 1
    if (fromCurrency === toCurrency) return 1.0;

    // Look up rate from database
    const rate = await db.query(`
      SELECT rate
      FROM exchange_rates
      WHERE from_currency = $1
        AND to_currency = $2
        AND rate_date <= $3
      ORDER BY rate_date DESC
      LIMIT 1
    `, [fromCurrency, toCurrency, date]);

    if (!rate.rows[0]) {
      throw new Error(`No exchange rate found for ${fromCurrency} to ${toCurrency}`);
    }

    return rate.rows[0].rate;
  }

  /**
   * Convert amount from one currency to another
   */
  async convert(amount, fromCurrency, toCurrency, date = new Date()) {
    const rate = await this.getRate(fromCurrency, toCurrency, date);
    const currency = await this.getCurrency(toCurrency);

    // Round to appropriate decimal places for target currency
    const converted = amount * rate;
    return this.round(converted, currency.decimal_places);
  }

  /**
   * Round to currency-specific decimal places
   */
  round(amount, decimalPlaces) {
    const factor = Math.pow(10, decimalPlaces);
    return Math.round(amount * factor) / factor;
  }
}

// Scheduled job to update rates
// Run every hour
cron.schedule('0 * * * *', async () => {
  const exchangeRateService = new ExchangeRateService();
  await exchangeRateService.updateRates();
});
```

### Historical Rate Tracking

**Why Track Historical Rates?**
- Accurate revenue recognition
- Invoice regeneration (if needed)
- Financial audits
- Dispute resolution
- Analytics and reporting

```sql
-- Query historical rate
SELECT rate
FROM exchange_rates
WHERE from_currency = 'USD'
  AND to_currency = 'EUR'
  AND rate_date <= '2025-06-15'
ORDER BY rate_date DESC
LIMIT 1;

-- Analyze rate volatility
SELECT
    from_currency,
    to_currency,
    DATE_TRUNC('month', rate_date) as month,
    AVG(rate) as avg_rate,
    MIN(rate) as min_rate,
    MAX(rate) as max_rate,
    STDDEV(rate) as volatility
FROM exchange_rates
WHERE rate_date >= NOW() - INTERVAL '1 year'
GROUP BY from_currency, to_currency, DATE_TRUNC('month', rate_date)
ORDER BY volatility DESC;
```

## Currency-Specific Formatting

### Formatting Rules by Currency

```javascript
class CurrencyFormatter {
  /**
   * Format amount according to currency and locale
   */
  static format(amount, currency, locale = 'en-US') {
    return new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currency,
      minimumFractionDigits: this.getDecimalPlaces(currency),
      maximumFractionDigits: this.getDecimalPlaces(currency)
    }).format(amount);
  }

  /**
   * Get decimal places for currency
   */
  static getDecimalPlaces(currency) {
    // Zero decimal place currencies
    const zeroDecimal = ['JPY', 'KRW', 'VND', 'CLP', 'TWD'];
    if (zeroDecimal.includes(currency)) return 0;

    // Three decimal place currencies (rare)
    const threeDecimal = ['BHD', 'JOD', 'KWD', 'OMR', 'TND'];
    if (threeDecimal.includes(currency)) return 3;

    // Most currencies use 2 decimal places
    return 2;
  }

  /**
   * Format examples
   */
  static examples() {
    console.log(this.format(1234.56, 'USD', 'en-US'));  // $1,234.56
    console.log(this.format(1234.56, 'EUR', 'de-DE'));  // 1.234,56 €
    console.log(this.format(1234.56, 'GBP', 'en-GB'));  // £1,234.56
    console.log(this.format(1234.56, 'JPY', 'ja-JP'));  // ¥1,235 (no decimals)
    console.log(this.format(1234.56, 'BRL', 'pt-BR'));  // R$ 1.234,56
  }
}
```

### Compact Currency Display

```javascript
/**
 * Format large numbers in compact notation
 * Useful for dashboards, charts
 */
function formatCompact(amount, currency, locale = 'en-US') {
  return new Intl.NumberFormat(locale, {
    style: 'currency',
    currency: currency,
    notation: 'compact',
    minimumFractionDigits: 0,
    maximumFractionDigits: 1
  }).format(amount);
}

// Examples
formatCompact(1234, 'USD', 'en-US');      // $1.2K
formatCompact(1234567, 'USD', 'en-US');   // $1.2M
formatCompact(1234567, 'EUR', 'de-DE');   // 1,2 Mio. €
formatCompact(1234567, 'JPY', 'ja-JP');   // ¥123万
```

## Pricing by Region

### Regional Price Adjustment Strategies

**1. Exchange Rate Only**
- Simply convert base USD price to local currency
- No market adjustment
- Pros: Simple, consistent
- Cons: May be too expensive or cheap for local market

**2. Market-Adjusted Pricing**
- Adjust for local purchasing power
- Competitive positioning
- Psychological price points
- Pros: Optimized for each market
- Cons: Complex, may create arbitrage opportunities

**3. Hybrid Approach** (Recommended)
- Base conversion with minor adjustments
- Round to psychological price points
- Adjust for outlier markets only

### Price Point Psychology

```javascript
/**
 * Round to psychological price points
 */
function getPsychologicalPrice(amount, currency) {
  // Round to nearest "nice" number based on currency
  const rules = {
    'USD': { roundTo: 1, endings: [9, 49, 99] },       // $99, $149, $199
    'EUR': { roundTo: 1, endings: [0, 50] },            // €100, €150, €200
    'GBP': { roundTo: 1, endings: [9, 49, 99] },       // £99, £149, £199
    'MXN': { roundTo: 10, endings: [0, 50] },          // 100, 1500, 2000
    'BRL': { roundTo: 10, endings: [0, 90] },          // 490, 990, 1990
    'JPY': { roundTo: 100, endings: [0, 800, 900] }    // 10000, 19800, 29900
  };

  const rule = rules[currency] || { roundTo: 1, endings: [0] };

  // Round to nearest multiple
  let rounded = Math.round(amount / rule.roundTo) * rule.roundTo;

  // Apply psychological ending
  const lastDigits = rounded % 100;
  const base = rounded - lastDigits;

  // Find closest psychological ending
  const ending = rule.endings.reduce((prev, curr) =>
    Math.abs(curr - lastDigits) < Math.abs(prev - lastDigits) ? curr : prev
  );

  return base + ending;
}

// Examples
getPsychologicalPrice(103.45, 'USD');  // 99
getPsychologicalPrice(201.23, 'EUR');  // 200
getPsychologicalPrice(1543.00, 'MXN'); // 1500
```

### Price Calculation Service

```javascript
class PricingService {
  /**
   * Get price for a plan in user's currency
   */
  async getPrice(planId, currency, effectiveDate = new Date()) {
    // Try to get regional pricing first
    let regionalPrice = await db.query(`
      SELECT price
      FROM regional_pricing
      WHERE price_tier_id = $1
        AND currency = $2
        AND effective_date <= $3
        AND (expiry_date IS NULL OR expiry_date > $3)
      ORDER BY effective_date DESC
      LIMIT 1
    `, [planId, currency, effectiveDate]);

    if (regionalPrice.rows[0]) {
      return regionalPrice.rows[0].price;
    }

    // Fall back to base price with currency conversion
    const basePlan = await db.query(`
      SELECT base_price_usd
      FROM price_tiers
      WHERE id = $1
    `, [planId]);

    if (!basePlan.rows[0]) {
      throw new Error(`Plan ${planId} not found`);
    }

    const basePrice = basePlan.rows[0].base_price_usd;

    // Convert to target currency
    const exchangeRateService = new ExchangeRateService();
    const convertedPrice = await exchangeRateService.convert(
      basePrice,
      'USD',
      currency,
      effectiveDate
    );

    // Round to psychological price point
    return getPsychologicalPrice(convertedPrice, currency);
  }

  /**
   * Get all available prices for a plan (for display/comparison)
   */
  async getAllPrices(planId) {
    const prices = await db.query(`
      SELECT
        rp.currency,
        rp.price,
        c.symbol,
        rp.adjustment_type
      FROM regional_pricing rp
      JOIN currencies c ON rp.currency = c.code
      WHERE rp.price_tier_id = $1
        AND rp.effective_date <= NOW()
        AND (rp.expiry_date IS NULL OR rp.expiry_date > NOW())
      ORDER BY rp.currency
    `, [planId]);

    return prices.rows;
  }
}
```

## Multi-Currency Invoicing

### Invoice Generation

```javascript
class InvoiceService {
  /**
   * Generate invoice for user
   */
  async generateInvoice(userId, items, dueDate) {
    const user = await this.getUser(userId);
    const preferences = await this.getUserCurrencyPreferences(userId);

    // Calculate totals in billing currency
    const subtotal = items.reduce((sum, item) => sum + item.amount, 0);
    const taxAmount = await this.calculateTax(userId, subtotal, preferences.billing_currency);
    const total = subtotal + taxAmount;

    // Get exchange rate for reporting
    const exchangeRateService = new ExchangeRateService();
    const today = new Date();
    const exchangeRate = await exchangeRateService.getRate(
      preferences.billing_currency,
      'USD',
      today
    );

    // Convert to base currency for reporting
    const subtotalUsd = await exchangeRateService.convert(subtotal, preferences.billing_currency, 'USD');
    const taxAmountUsd = await exchangeRateService.convert(taxAmount, preferences.billing_currency, 'USD');
    const totalUsd = await exchangeRateService.convert(total, preferences.billing_currency, 'USD');

    // Create invoice
    const invoice = await db.query(`
      INSERT INTO invoices (
        user_id,
        invoice_number,
        currency,
        subtotal,
        tax_amount,
        total,
        subtotal_usd,
        tax_amount_usd,
        total_usd,
        exchange_rate,
        exchange_rate_date,
        display_currency,
        status,
        issue_date,
        due_date
      ) VALUES (
        $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15
      )
      RETURNING *
    `, [
      userId,
      await this.generateInvoiceNumber(),
      preferences.billing_currency,
      subtotal,
      taxAmount,
      total,
      subtotalUsd,
      taxAmountUsd,
      totalUsd,
      exchangeRate,
      today,
      preferences.display_currency,
      'sent',
      today,
      dueDate
    ]);

    return invoice.rows[0];
  }

  /**
   * Display invoice to user
   * Shows in their display currency if different from billing
   */
  async displayInvoice(invoiceId, userId) {
    const invoice = await this.getInvoice(invoiceId);
    const preferences = await this.getUserCurrencyPreferences(userId);

    // If display currency matches billing currency, show as-is
    if (invoice.currency === invoice.display_currency) {
      return {
        ...invoice,
        displayNote: null
      };
    }

    // If different, show both
    const exchangeRateService = new ExchangeRateService();
    const displayTotal = await exchangeRateService.convert(
      invoice.total,
      invoice.currency,
      invoice.display_currency,
      invoice.issue_date
    );

    return {
      ...invoice,
      displayTotal,
      displayCurrency: invoice.display_currency,
      displayNote: `Approximately ${CurrencyFormatter.format(displayTotal, invoice.display_currency)}. You will be charged ${CurrencyFormatter.format(invoice.total, invoice.currency)}.`
    };
  }
}
```

### Invoice Display Example

```
┌─────────────────────────────────────────────────────────┐
│                      INVOICE #INV-2025-001234            │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Issue Date: December 21, 2025                          │
│  Due Date: January 20, 2026                             │
│                                                          │
│  Bill To:                                               │
│  Acme GmbH                                              │
│  Berlin, Germany                                        │
│                                                          │
├─────────────────────────────────────────────────────────┤
│  Description                              Amount        │
├─────────────────────────────────────────────────────────┤
│  Professional Plan (Monthly)              €185.00       │
│  Additional Users (3 × €25)               €75.00        │
│                                                          │
│  Subtotal                                 €260.00       │
│  VAT (19%)                                €49.40        │
│                                                          │
│  TOTAL DUE (EUR)                          €309.40       │
│                                                          │
│  ------------------------------------------------        │
│  Display Amount (USD)*                    $336.22       │
│                                                          │
│  * Informational only. You will be charged €309.40     │
│    Exchange rate: 1 EUR = 1.0866 USD (Dec 21, 2025)   │
└─────────────────────────────────────────────────────────┘
```

## Financial Reporting in Base Currency

### Revenue Recognition

```sql
-- Monthly recurring revenue in base currency (USD)
SELECT
    DATE_TRUNC('month', transaction_date) as month,
    SUM(amount_usd) as mrr_usd,
    COUNT(DISTINCT user_id) as paying_customers,
    SUM(amount_usd) / COUNT(DISTINCT user_id) as arpu_usd
FROM transactions
WHERE type = 'subscription'
  AND status = 'completed'
  AND transaction_date >= DATE_TRUNC('year', NOW())
GROUP BY DATE_TRUNC('month', transaction_date)
ORDER BY month DESC;
```

### Currency Breakdown

```sql
-- Revenue by currency
SELECT
    currency,
    SUM(amount) as revenue_local,
    SUM(amount_usd) as revenue_usd,
    COUNT(*) as transaction_count,
    AVG(amount) as avg_transaction_local,
    AVG(amount_usd) as avg_transaction_usd
FROM transactions
WHERE status = 'completed'
  AND transaction_date >= NOW() - INTERVAL '30 days'
GROUP BY currency
ORDER BY revenue_usd DESC;
```

### Exchange Rate Impact Analysis

```sql
-- Analyze currency volatility impact on revenue
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', transaction_date) as month,
        currency,
        SUM(amount) as total_local,
        AVG(exchange_rate) as avg_exchange_rate
    FROM transactions
    WHERE status = 'completed'
      AND transaction_date >= NOW() - INTERVAL '1 year'
    GROUP BY DATE_TRUNC('month', transaction_date), currency
),
rate_impact AS (
    SELECT
        month,
        currency,
        total_local,
        avg_exchange_rate,
        LAG(avg_exchange_rate) OVER (PARTITION BY currency ORDER BY month) as prev_rate,
        total_local * avg_exchange_rate as revenue_usd,
        total_local * LAG(avg_exchange_rate) OVER (PARTITION BY currency ORDER BY month) as revenue_usd_prev_rate
    FROM monthly_revenue
)
SELECT
    month,
    currency,
    total_local,
    avg_exchange_rate,
    prev_rate,
    revenue_usd,
    revenue_usd - revenue_usd_prev_rate as exchange_rate_impact_usd,
    ROUND(((avg_exchange_rate - prev_rate) / prev_rate * 100), 2) as rate_change_pct
FROM rate_impact
WHERE prev_rate IS NOT NULL
ORDER BY month DESC, ABS(exchange_rate_impact_usd) DESC;
```

## Tax Implications

### VAT/GST Handling by Currency

Different countries have different tax requirements that interact with currency:

```javascript
class TaxService {
  /**
   * Calculate tax for an amount
   */
  async calculateTax(userId, amount, currency) {
    const user = await this.getUser(userId);
    const taxRate = await this.getTaxRate(user.country, user.region);

    if (!taxRate) return 0;

    const taxAmount = amount * taxRate.rate;

    // Round to currency-specific decimal places
    const currencyInfo = await this.getCurrency(currency);
    return this.round(taxAmount, currencyInfo.decimal_places);
  }

  /**
   * Get tax rate for user's location
   */
  async getTaxRate(country, region = null) {
    // Example tax rates
    const taxRates = {
      'US': {}, // No federal VAT, state sales tax handled separately
      'CA': { rate: 0.05, name: 'GST' }, // Federal GST, provinces add PST
      'GB': { rate: 0.20, name: 'VAT' },
      'DE': { rate: 0.19, name: 'VAT' },
      'FR': { rate: 0.20, name: 'TVA' },
      'NL': { rate: 0.21, name: 'BTW' },
      'ES': { rate: 0.21, name: 'IVA' },
      'MX': { rate: 0.16, name: 'IVA' },
      'BR': { rate: 0.00, name: 'ICMS/ISS' }, // Complex, handled separately
      'AU': { rate: 0.10, name: 'GST' }
    };

    return taxRates[country] || null;
  }

  /**
   * Determine if price should be displayed tax-inclusive or exclusive
   */
  isTaxInclusive(country) {
    // Most countries display prices with tax included
    // US is main exception
    const taxExclusiveCountries = ['US'];
    return !taxExclusiveCountries.includes(country);
  }
}
```

### Tax Reporting

```sql
-- Tax collected by country and currency
SELECT
    u.country,
    i.currency,
    SUM(i.tax_amount) as tax_collected_local,
    SUM(i.tax_amount_usd) as tax_collected_usd,
    COUNT(*) as invoice_count
FROM invoices i
JOIN users u ON i.user_id = u.id
WHERE i.status = 'paid'
  AND i.issue_date >= DATE_TRUNC('quarter', NOW())
GROUP BY u.country, i.currency
ORDER BY tax_collected_usd DESC;
```

## Currency Conversion in UI

### React Component Example

```typescript
// CurrencyAmount.tsx
import React from 'react';
import { useCurrency } from '@/hooks/useCurrency';

interface CurrencyAmountProps {
  amount: number;
  currency: string;
  showOriginal?: boolean;  // If true, show both display and billing currency
}

export const CurrencyAmount: React.FC<CurrencyAmountProps> = ({
  amount,
  currency,
  showOriginal = false
}) => {
  const { displayCurrency, billingCurrency, convert, format } = useCurrency();

  // If currency matches user's display preference, show as-is
  if (currency === displayCurrency) {
    return <span className="currency-amount">{format(amount, currency)}</span>;
  }

  // Convert to display currency
  const convertedAmount = convert(amount, currency, displayCurrency);

  if (!showOriginal) {
    return <span className="currency-amount">{format(convertedAmount, displayCurrency)}</span>;
  }

  // Show both currencies
  return (
    <span className="currency-amount">
      <span className="primary">{format(convertedAmount, displayCurrency)}</span>
      <span className="secondary">({format(amount, currency)})</span>
    </span>
  );
};

// Usage
<CurrencyAmount amount={199} currency="USD" />
// User with EUR display preference sees: €185.00

<CurrencyAmount amount={199} currency="USD" showOriginal={true} />
// User with EUR display preference sees: €185.00 ($199.00)
```

### Currency Switcher Component

```typescript
// CurrencySwitcher.tsx
import React from 'react';
import { useCurrency } from '@/hooks/useCurrency';

export const CurrencySwitcher: React.FC = () => {
  const { displayCurrency, availableCurrencies, setDisplayCurrency } = useCurrency();

  return (
    <div className="currency-switcher">
      <label>Display Currency:</label>
      <select
        value={displayCurrency}
        onChange={(e) => setDisplayCurrency(e.target.value)}
      >
        {availableCurrencies.map(currency => (
          <option key={currency.code} value={currency.code}>
            {currency.symbol} {currency.code} - {currency.name}
          </option>
        ))}
      </select>
      <p className="help-text">
        This only affects how amounts are displayed.
        You will be billed in {billingCurrency}.
      </p>
    </div>
  );
};
```

## Payment Processing

### Stripe Multi-Currency

```javascript
class PaymentService {
  /**
   * Create payment intent in user's billing currency
   */
  async createPaymentIntent(userId, amount, currency, metadata = {}) {
    const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

    // Stripe requires amounts in smallest currency unit
    // For USD, EUR, GBP: cents (multiply by 100)
    // For JPY, KRW: yen (no multiplication, already whole units)
    const currencyInfo = await this.getCurrency(currency);
    const multiplier = Math.pow(10, currencyInfo.decimal_places);
    const amountInSmallestUnit = Math.round(amount * multiplier);

    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInSmallestUnit,
      currency: currency.toLowerCase(),
      metadata: {
        userId,
        ...metadata
      },
      // Enable automatic payment methods for currency
      automatic_payment_methods: {
        enabled: true
      }
    });

    return paymentIntent;
  }

  /**
   * Handle successful payment
   */
  async handlePaymentSuccess(paymentIntentId) {
    const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
    const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId);

    // Get exchange rate for the payment date
    const exchangeRateService = new ExchangeRateService();
    const paymentDate = new Date(paymentIntent.created * 1000);
    const exchangeRate = await exchangeRateService.getRate(
      paymentIntent.currency.toUpperCase(),
      'USD',
      paymentDate
    );

    // Convert to base currency
    const currencyInfo = await this.getCurrency(paymentIntent.currency.toUpperCase());
    const divisor = Math.pow(10, currencyInfo.decimal_places);
    const amount = paymentIntent.amount / divisor;
    const amountUsd = await exchangeRateService.convert(
      amount,
      paymentIntent.currency.toUpperCase(),
      'USD',
      paymentDate
    );

    // Record transaction
    await db.query(`
      INSERT INTO transactions (
        user_id,
        amount,
        currency,
        amount_usd,
        exchange_rate,
        exchange_rate_date,
        type,
        status,
        stripe_payment_intent_id,
        transaction_date
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    `, [
      paymentIntent.metadata.userId,
      amount,
      paymentIntent.currency.toUpperCase(),
      amountUsd,
      exchangeRate,
      paymentDate,
      'subscription',
      'completed',
      paymentIntentId,
      paymentDate
    ]);
  }
}
```

### Currency-Specific Payment Methods

Different regions prefer different payment methods:

```javascript
const paymentMethodsByCurrency = {
  'USD': ['card', 'ach_debit', 'us_bank_account'],
  'EUR': ['card', 'sepa_debit', 'giropay', 'ideal', 'bancontact'],
  'GBP': ['card', 'bacs_debit'],
  'CAD': ['card', 'acss_debit'],
  'MXN': ['card', 'oxxo'],
  'BRL': ['card', 'boleto'],
  'JPY': ['card', 'konbini'],
  'AUD': ['card', 'au_becs_debit']
};

/**
 * Get available payment methods for currency
 */
function getPaymentMethods(currency) {
  return paymentMethodsByCurrency[currency] || ['card'];
}
```

## Implementation Checklist

### Phase 1: Foundation (v2)
- [ ] Create currency and exchange rate tables
- [ ] Implement exchange rate service (Open Exchange Rates)
- [ ] Set up hourly rate update cron job
- [ ] Build currency conversion utilities
- [ ] Add currency formatting helpers
- [ ] Update user preferences to include currency settings
- [ ] Implement base currency conversion for all transactions

### Phase 2: Multi-Currency Display (v3)
- [ ] Add display currency preference to user settings
- [ ] Build currency switcher UI component
- [ ] Update all price displays to use CurrencyAmount component
- [ ] Show currency conversion notes on checkout/billing pages
- [ ] Add currency selector to signup flow

### Phase 3: Multi-Currency Billing (v3-v4)
- [ ] Implement regional pricing table and logic
- [ ] Set up Stripe multi-currency payments
- [ ] Update invoice generation for multi-currency
- [ ] Add exchange rate to invoices
- [ ] Build price calculation service with regional adjustments
- [ ] Implement psychological pricing algorithm

### Phase 4: Reporting & Analytics (v4)
- [ ] Build revenue reports in base currency
- [ ] Create currency breakdown analytics
- [ ] Implement exchange rate impact analysis
- [ ] Add currency filters to financial dashboards
- [ ] Set up alerts for significant exchange rate movements
- [ ] Build currency volatility monitoring

### Phase 5: Advanced Features (v4+)
- [ ] Automatic price updates based on exchange rate changes
- [ ] Currency hedging strategy implementation
- [ ] Multi-currency refund handling
- [ ] Currency-specific discount and promotion engine
- [ ] A/B testing framework for regional pricing
- [ ] Predictive analytics for currency impact on revenue

## Monitoring & Alerts

### Critical Monitoring

```javascript
// Monitor exchange rate staleness
async function checkExchangeRateFreshness() {
  const latestRate = await db.query(`
    SELECT MAX(rate_date) as latest_date
    FROM exchange_rates
  `);

  const hoursSinceUpdate = (new Date() - latestRate.rows[0].latest_date) / (1000 * 60 * 60);

  if (hoursSinceUpdate > 3) {
    // Alert: Exchange rates are stale
    await alertTeam('Exchange rates have not updated in 3+ hours');
  }
}

// Monitor payment failures by currency
async function checkPaymentSuccessRates() {
  const rates = await db.query(`
    SELECT
      currency,
      COUNT(*) as total_attempts,
      SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as successful,
      ROUND(
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END)::NUMERIC / COUNT(*) * 100,
        2
      ) as success_rate
    FROM transactions
    WHERE transaction_date >= NOW() - INTERVAL '7 days'
    GROUP BY currency
    HAVING COUNT(*) > 10
  `);

  for (const rate of rates.rows) {
    if (rate.success_rate < 85) {
      // Alert: Low payment success rate for this currency
      await alertTeam(`Payment success rate for ${rate.currency} is ${rate.success_rate}% (below 85% threshold)`);
    }
  }
}

// Monitor for large exchange rate movements
async function checkExchangeRateVolatility() {
  const movements = await db.query(`
    WITH rate_changes AS (
      SELECT
        from_currency,
        to_currency,
        rate,
        LAG(rate) OVER (PARTITION BY from_currency, to_currency ORDER BY rate_date) as prev_rate,
        rate_date
      FROM exchange_rates
      WHERE rate_date >= NOW() - INTERVAL '7 days'
    )
    SELECT
      from_currency,
      to_currency,
      rate,
      prev_rate,
      ABS((rate - prev_rate) / prev_rate * 100) as change_pct,
      rate_date
    FROM rate_changes
    WHERE prev_rate IS NOT NULL
      AND ABS((rate - prev_rate) / prev_rate * 100) > 5
    ORDER BY change_pct DESC
  `);

  if (movements.rows.length > 0) {
    // Alert: Significant exchange rate movements detected
    for (const movement of movements.rows) {
      await alertTeam(
        `Significant exchange rate movement: ${movement.from_currency}/${movement.to_currency} changed ${movement.change_pct}% to ${movement.rate}`
      );
    }
  }
}
```

## Best Practices

### Do's
1. **Always store amounts in the transaction currency** - This is the source of truth
2. **Always convert to base currency at time of transaction** - For accurate reporting
3. **Use high-precision decimals for exchange rates** - DECIMAL(20,10) minimum
4. **Round to currency-specific decimal places** - Different currencies have different rules
5. **Store exchange rate and date with transactions** - For auditability
6. **Update exchange rates frequently** - Hourly minimum for active trading hours
7. **Show users what currency they'll be charged in** - Transparency is critical
8. **Use psychological pricing** - Round to natural price points
9. **Monitor for stale rates and payment failures** - Set up alerts
10. **Test with multiple currencies** - Don't assume all currencies behave like USD

### Don'ts
1. **Don't store only converted amounts** - Always keep original transaction currency
2. **Don't use FLOAT for currency** - Always use DECIMAL for precision
3. **Don't assume all currencies have 2 decimal places** - JPY has 0, KWD has 3
4. **Don't do live conversions without historical tracking** - Use snapshot of rate at transaction time
5. **Don't forget about rounding** - Small errors compound
6. **Don't ignore currency-specific payment methods** - Boleto in Brazil, iDEAL in Netherlands
7. **Don't price solely by exchange rate** - Consider local market dynamics
8. **Don't forget tax implications** - VAT handling varies by currency/country
9. **Don't assume currency symbols are unique** - $ is used by USD, CAD, MXN, AUD, etc.
10. **Don't hardcode currency logic** - Use database-driven configuration

## Conclusion

Robust multi-currency support is essential for PopSystem's international expansion. This specification provides:

- **Three-currency model** for display, billing, and reporting
- **Comprehensive data model** for currencies, rates, pricing, and transactions
- **Exchange rate management** with automated updates and historical tracking
- **Regional pricing strategies** with psychological price point optimization
- **Multi-currency invoicing** with clear communication to users
- **Financial reporting** in base currency (USD) for consistent metrics
- **Payment processing** integration with currency-specific methods
- **Monitoring and alerting** for rate staleness and payment issues

By following this specification, PopSystem will provide a seamless experience for international customers while maintaining accurate financial reporting and compliance with regional requirements.
