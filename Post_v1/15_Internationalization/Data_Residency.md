# Data Residency Strategy

## Overview

This document outlines PopSystem's data residency and sovereignty strategy to support international expansion while meeting regional compliance requirements. As we expand into the EU, UK, Canada, Brazil, and other regions, we must ensure customer data is stored, processed, and transferred in compliance with local data protection laws while maintaining system performance and operational efficiency.

## Data Residency Requirements by Region

### European Union (EU)

#### GDPR Requirements
- **Regulation**: General Data Protection Regulation (EU 2016/679)
- **Data Residency**: EU data must remain within EU/EEA or adequacy countries
- **Legal Basis**: Data transfers outside EU require:
  - Adequacy decision from EU Commission, OR
  - Standard Contractual Clauses (SCCs), OR
  - Binding Corporate Rules (BCRs), OR
  - Explicit user consent

#### Implementation Requirements
- **Primary Storage**: Frankfurt, Paris, or Amsterdam cloud regions
- **Backup Storage**: Must remain within EU/EEA
- **Data Processing**: All processing must occur within EU or under approved transfer mechanisms
- **Vendor Requirements**: All subprocessors must comply with GDPR
- **Documentation**: Maintain Records of Processing Activities (ROPA)

#### Penalties for Non-Compliance
- Up to €20 million or 4% of annual global turnover (whichever is higher)
- Potential business suspension in EU markets
- Reputational damage

### United Kingdom

#### UK GDPR & Data Protection Act 2018
- **Post-Brexit Status**: UK has its own version of GDPR
- **Current Adequacy**: EU-UK adequacy decision allows free data flow (monitor for changes)
- **Data Residency**: UK businesses increasingly prefer UK data storage
- **Legal Transfers**: Similar to EU GDPR (UK SCCs for transfers outside UK)

#### Implementation Requirements
- **Primary Storage**: London cloud region
- **Backup Storage**: UK or EU (under adequacy decision)
- **Data Processing**: Preferred in UK, acceptable in EU
- **ICO Registration**: Required for data controllers
- **UK Representative**: Required for non-UK companies processing UK data

### Canada

#### PIPEDA & Provincial Laws
- **Federal Law**: Personal Information Protection and Electronic Documents Act (PIPEDA)
- **Quebec Specifics**: Law 25 (enhanced privacy law, effective Sept 2023)
- **Data Residency**: Not explicitly required but:
  - Organizations must inform users if data is stored outside Canada
  - Must ensure same level of protection outside Canada
  - Quebec Law 25 has stricter requirements

#### Implementation Requirements
- **Phase 1-2**: US storage acceptable with:
  - User notification and consent
  - Contractual protections with cloud provider
  - Equivalent security measures
- **Phase 3**: Toronto cloud region for:
  - Quebec customers (Law 25 preference)
  - Enterprise customers requiring Canadian residency
  - Government/regulated sectors
- **Backup Storage**: Can be in US with proper safeguards
- **Data Transfers**: Require consent and contractual protection

### Brazil

#### LGPD (Lei Geral de Proteção de Dados)
- **Regulation**: Brazil's comprehensive data protection law (effective Aug 2020)
- **Data Residency**: Not explicitly required, but:
  - Market preference for local storage
  - Government/enterprise often require Brazilian residency
  - Simplified compliance with local storage
- **Legal Transfers**: International transfers require:
  - Adequacy decision from ANPD, OR
  - Standard contractual clauses, OR
  - User consent

#### Implementation Requirements
- **Phase 1-2**: US storage acceptable with:
  - User consent for international transfer
  - Standard contractual clauses
  - LGPD compliance (regardless of location)
- **Phase 3**: São Paulo cloud region for:
  - Full market penetration
  - Enterprise customers
  - Government sector
  - Competitive advantage
- **Backup Storage**: Can be outside Brazil with proper transfer mechanisms
- **Data Processing**: Encarregado (DPO) required for oversight

### Mexico

#### LFPDPPP (Federal Law on Protection of Personal Data)
- **Regulation**: Mexico's privacy law
- **Data Residency**: Not required
- **Legal Transfers**: Transfers allowed with:
  - User consent, OR
  - Data transfer agreement, OR
  - Adequacy determination

#### Implementation Requirements
- **Storage**: US cloud acceptable (geographical proximity, cost-effective)
- **Future Consideration**: Mexico City region if:
  - Market size justifies investment
  - Enterprise customers demand it
  - Competitive differentiation needed
- **Backup Storage**: US acceptable
- **Compliance**: LFPDPPP applies regardless of data location

### Australia & New Zealand

#### Australian Privacy Act & NZ Privacy Act
- **Data Residency**: Not explicitly required
- **Legal Transfers**: Permitted with reasonable steps to ensure protection
- **Market Preference**: Increasing preference for local storage

#### Implementation Requirements
- **Phase 1-2**: US cloud acceptable
- **Phase 3**: Sydney cloud region for:
  - Market preference
  - Performance (latency)
  - Competitive positioning
- **Backup Storage**: Can be outside region with safeguards

### United States

#### State Privacy Laws
- **CPRA (California)**: No data residency requirements
- **Other State Laws**: Generally no residency mandates
- **Federal Sector**: Government contracts may require US-only storage

#### Implementation Requirements
- **Storage**: US regions (multiple for redundancy)
- **Compliance**: State-specific privacy law features
- **Government Sector**: US-only deployment option

## Multi-Region Database Architecture

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    GLOBAL ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌──────────────┐   ┌──────────────┐   ┌──────────────┐      │
│   │ North America│   │   Europe     │   │  APAC        │      │
│   │ (US/CA/MX)   │   │  (EU/UK)     │   │  (AU/NZ)     │      │
│   ├──────────────┤   ├──────────────┤   ├──────────────┤      │
│   │ Primary DB   │   │ Primary DB   │   │ Primary DB   │      │
│   │ US-East      │   │ Frankfurt    │   │ Sydney       │      │
│   │              │   │ London       │   │              │      │
│   ├──────────────┤   ├──────────────┤   ├──────────────┤      │
│   │ Replica      │   │ Replica      │   │ Replica      │      │
│   │ US-West      │   │ Paris        │   │              │      │
│   └──────────────┘   └──────────────┘   └──────────────┘      │
│          │                   │                   │             │
│          └───────────────────┴───────────────────┘             │
│                              │                                 │
│                    ┌─────────┴─────────┐                       │
│                    │  Global Control   │                       │
│                    │  Plane (Metadata) │                       │
│                    │  US-East          │                       │
│                    └───────────────────┘                       │
└─────────────────────────────────────────────────────────────────┘
```

### Regional Isolation Model

**Principle**: Customer data stays in the region where the customer is located

```sql
-- User assignment to region
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    -- User's assigned region based on billing address
    data_region VARCHAR(20) NOT NULL,  -- 'us', 'eu', 'uk', 'ca', 'br', 'au'
    billing_country CHAR(2) NOT NULL,   -- ISO 3166-1 alpha-2
    created_at TIMESTAMP DEFAULT NOW()
);

-- Regional database assignment
CREATE TABLE regional_databases (
    region VARCHAR(20) PRIMARY KEY,
    primary_db_endpoint VARCHAR(255) NOT NULL,
    replica_db_endpoint VARCHAR(255),
    cloud_provider VARCHAR(50) NOT NULL,  -- 'aws', 'gcp', 'azure'
    geographic_location VARCHAR(100) NOT NULL,
    compliance_zones TEXT[],  -- ['eu', 'gdpr', 'schrems-ii-compliant']
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO regional_databases (region, primary_db_endpoint, cloud_provider, geographic_location, compliance_zones) VALUES
('us', 'us-east-1.rds.amazonaws.com', 'aws', 'US East (N. Virginia)', ARRAY['us']),
('eu', 'eu-central-1.rds.amazonaws.com', 'aws', 'EU (Frankfurt)', ARRAY['eu', 'gdpr', 'schrems-ii-compliant']),
('uk', 'eu-west-2.rds.amazonaws.com', 'aws', 'EU (London)', ARRAY['uk', 'uk-gdpr']),
('ca', 'ca-central-1.rds.amazonaws.com', 'aws', 'Canada (Central)', ARRAY['ca', 'pipeda']),
('br', 'sa-east-1.rds.amazonaws.com', 'aws', 'South America (São Paulo)', ARRAY['br', 'lgpd']),
('au', 'ap-southeast-2.rds.amazonaws.com', 'aws', 'Asia Pacific (Sydney)', ARRAY['au']);
```

### Database Routing

```javascript
// Regional database router
class RegionalDatabaseRouter {
  constructor() {
    this.connectionPools = new Map();
    this.initializeRegionalConnections();
  }

  /**
   * Initialize connection pools for each region
   */
  async initializeRegionalConnections() {
    const regions = await this.getActiveRegions();

    for (const region of regions) {
      this.connectionPools.set(region.region, {
        primary: this.createConnectionPool(region.primary_db_endpoint),
        replica: region.replica_db_endpoint
          ? this.createConnectionPool(region.replica_db_endpoint)
          : null,
        region: region.region,
        complianceZones: region.compliance_zones
      });
    }
  }

  /**
   * Get database connection for user
   */
  async getConnectionForUser(userId) {
    const user = await this.getUserRegion(userId);
    return this.getConnectionForRegion(user.data_region);
  }

  /**
   * Get database connection for region
   */
  getConnectionForRegion(region, readOnly = false) {
    const pool = this.connectionPools.get(region);

    if (!pool) {
      throw new Error(`No database configured for region: ${region}`);
    }

    // Use replica for read-only queries if available
    if (readOnly && pool.replica) {
      return pool.replica;
    }

    return pool.primary;
  }

  /**
   * Determine region for new user based on billing country
   */
  determineRegion(billingCountry) {
    const regionMap = {
      // Europe
      'DE': 'eu', 'FR': 'eu', 'IT': 'eu', 'ES': 'eu', 'NL': 'eu',
      'BE': 'eu', 'AT': 'eu', 'SE': 'eu', 'DK': 'eu', 'FI': 'eu',
      'NO': 'eu', 'PL': 'eu', 'IE': 'eu', 'PT': 'eu', 'GR': 'eu',

      // UK
      'GB': 'uk',

      // North America
      'US': 'us',
      'CA': 'ca',
      'MX': 'us',  // Mexico uses US region (Phase 1-2)

      // Latin America
      'BR': 'br',
      'AR': 'us', 'CO': 'us', 'CL': 'us', 'PE': 'us',  // Use US for now

      // APAC
      'AU': 'au',
      'NZ': 'au',
      'SG': 'au',  // Use AU for SEA initially

      // Default
      'default': 'us'
    };

    return regionMap[billingCountry] || regionMap.default;
  }
}

// Middleware to set regional context
async function regionalContextMiddleware(req, res, next) {
  const userId = req.user?.id;

  if (userId) {
    const router = new RegionalDatabaseRouter();
    req.dbConnection = await router.getConnectionForUser(userId);
    req.userRegion = await router.getUserRegion(userId);
  }

  next();
}
```

## Data Replication Policies

### Replication Scenarios

#### Within-Region Replication (High Availability)
- **Purpose**: Availability, disaster recovery, performance
- **Scope**: Within same compliance zone
- **Example**: US-East → US-West (both in US)
- **Compliance**: No cross-border transfer

```yaml
# Within-region replication configuration
us_region:
  primary:
    location: us-east-1
    type: postgres-14
    instance: db.r6g.2xlarge
  replicas:
    - location: us-east-1 (different AZ)
      type: synchronous
      purpose: high_availability
    - location: us-west-2
      type: asynchronous
      purpose: disaster_recovery
      lag_tolerance: 30_seconds
```

#### Cross-Region Replication (Limited)
- **Purpose**: Global admin features, analytics
- **Scope**: Metadata only (NOT personal data)
- **Example**: Aggregate statistics, system configuration
- **Compliance**: Must exclude personal/sensitive data

```sql
-- Data classification for replication
CREATE TABLE data_classification (
    table_name VARCHAR(100) PRIMARY KEY,
    classification VARCHAR(50) NOT NULL,  -- 'personal', 'sensitive', 'metadata', 'public'
    cross_region_replication BOOLEAN DEFAULT false,
    retention_period_days INTEGER,
    notes TEXT
);

INSERT INTO data_classification (table_name, classification, cross_region_replication) VALUES
-- No cross-region replication for personal data
('users', 'personal', false),
('transactions', 'sensitive', false),
('invoices', 'sensitive', false),
('payment_methods', 'sensitive', false),

-- Metadata can replicate globally
('currencies', 'metadata', true),
('exchange_rates', 'metadata', true),
('system_config', 'metadata', true),
('feature_flags', 'metadata', true),

-- Aggregated analytics (anonymized)
('revenue_metrics', 'metadata', true),
('usage_stats', 'metadata', true);
```

### Backup Policies by Region

```javascript
const backupPolicies = {
  us: {
    primary_location: 'us-east-1',
    backup_locations: ['us-west-2'],
    retention_daily: 7,
    retention_weekly: 4,
    retention_monthly: 12,
    encryption: 'AES-256',
    cross_region_backup: true,
    compliance_zones: ['us']
  },

  eu: {
    primary_location: 'eu-central-1',
    backup_locations: ['eu-west-3'],  // Must stay in EU
    retention_daily: 7,
    retention_weekly: 4,
    retention_monthly: 12,
    retention_yearly: 7,  // GDPR may require longer retention for audit
    encryption: 'AES-256',
    cross_region_backup: true,  // But only within EU
    compliance_zones: ['eu', 'gdpr'],
    restrictions: 'Backups must not leave EU/EEA'
  },

  uk: {
    primary_location: 'eu-west-2',
    backup_locations: ['eu-west-1'],  // Ireland (EU adequacy)
    retention_daily: 7,
    retention_weekly: 4,
    retention_monthly: 12,
    encryption: 'AES-256',
    cross_region_backup: true,  // UK-EU only (monitor adequacy status)
    compliance_zones: ['uk', 'uk-gdpr']
  },

  br: {
    primary_location: 'sa-east-1',
    backup_locations: ['us-east-1'],  // With proper LGPD controls
    retention_daily: 7,
    retention_weekly: 4,
    retention_monthly: 12,
    encryption: 'AES-256',
    cross_region_backup: true,
    compliance_zones: ['br', 'lgpd'],
    transfer_mechanism: 'standard_contractual_clauses'
  }
};
```

## Cross-Border Data Transfer Mechanisms

### Standard Contractual Clauses (SCCs)

**When Required**: Transfers outside adequacy countries (e.g., EU to US, Brazil to US)

**Implementation**:
1. Execute SCCs with all cloud providers and subprocessors
2. Maintain Data Processing Agreements (DPAs)
3. Document all international data transfers
4. Conduct Transfer Impact Assessments (TIAs)

```javascript
// Data transfer tracking
CREATE TABLE data_transfers (
    id BIGSERIAL PRIMARY KEY,
    transfer_type VARCHAR(50) NOT NULL,  -- 'backup', 'processing', 'analytics'
    source_region VARCHAR(20) NOT NULL,
    destination_region VARCHAR(20) NOT NULL,
    legal_basis VARCHAR(100) NOT NULL,   -- 'scc', 'adequacy', 'consent'
    data_classification VARCHAR(50) NOT NULL,
    purpose TEXT NOT NULL,
    frequency VARCHAR(50),                -- 'continuous', 'daily', 'on-demand'
    volume_estimate VARCHAR(100),
    safeguards_applied TEXT[],
    dpa_reference VARCHAR(100),
    approved_by VARCHAR(100),
    approval_date DATE,
    review_date DATE,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Example transfers
INSERT INTO data_transfers (
    transfer_type,
    source_region,
    destination_region,
    legal_basis,
    data_classification,
    purpose,
    frequency,
    safeguards_applied,
    dpa_reference
) VALUES (
    'backup',
    'eu',
    'eu',
    'adequacy',
    'personal',
    'Disaster recovery backup within EU',
    'continuous',
    ARRAY['encryption-at-rest', 'encryption-in-transit', 'access-controls'],
    'DPA-AWS-EU-001'
);
```

### EU-US Data Privacy Framework (DPF)

**Status**: Replaced Privacy Shield (invalidated in Schrems II)

**Applicability**: US companies can self-certify for EU-US data transfers

**PopSystem Approach**:
1. Consider DPF certification (if US operations)
2. Continue using SCCs as primary mechanism (more robust)
3. Implement supplementary measures:
   - End-to-end encryption
   - Data minimization
   - Access controls
   - Regular audits

### Consent-Based Transfers

**When Used**: When SCCs or adequacy not available/preferred

**Implementation**:
```javascript
// User consent for data transfer
CREATE TABLE user_data_transfer_consents (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    consent_type VARCHAR(50) NOT NULL,  -- 'cross_border_transfer'
    source_region VARCHAR(20) NOT NULL,
    destination_region VARCHAR(20) NOT NULL,
    purpose TEXT NOT NULL,
    consent_given BOOLEAN NOT NULL,
    consent_date TIMESTAMP,
    consent_ip_address INET,
    consent_method VARCHAR(50),  -- 'explicit_checkbox', 'terms_acceptance'
    withdrawn BOOLEAN DEFAULT false,
    withdrawal_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

// Consent tracking in UI
async function requestTransferConsent(userId, sourceRegion, destRegion, purpose) {
  return {
    title: 'Data Transfer Consent Required',
    message: `To provide you with our services, we need to transfer your data from ${sourceRegion} to ${destRegion} for ${purpose}. Your data will be protected with Standard Contractual Clauses and encryption.`,
    options: {
      accept: 'I consent to this data transfer',
      decline: 'I do not consent',
      learnMore: '/privacy/data-transfers'
    }
  };
}
```

## Data Classification by Sensitivity

### Classification Levels

```javascript
const dataClassification = {
  // LEVEL 1: Public
  public: {
    description: 'Information that can be freely shared',
    examples: ['Product features', 'Marketing content', 'Public documentation'],
    encryption_required: false,
    cross_region_transfer: true,
    retention: 'indefinite'
  },

  // LEVEL 2: Internal
  internal: {
    description: 'Information for internal use only',
    examples: ['System configurations', 'Feature flags', 'Aggregate metrics'],
    encryption_required: true,
    cross_region_transfer: true,
    retention: '7 years'
  },

  // LEVEL 3: Confidential
  confidential: {
    description: 'Sensitive business information',
    examples: ['User data', 'Transaction records', 'Invoices', 'Contracts'],
    encryption_required: true,
    cross_region_transfer: false,
    retention: 'varies_by_regulation',
    access_controls: 'strict',
    audit_logging: true
  },

  // LEVEL 4: Highly Sensitive
  highly_sensitive: {
    description: 'Regulated or highly sensitive data',
    examples: ['Payment credentials', 'Government IDs', 'Health data', 'Biometric data'],
    encryption_required: true,
    encryption_type: 'field_level',
    cross_region_transfer: false,
    retention: 'minimum_necessary',
    access_controls: 'very_strict',
    audit_logging: true,
    tokenization: true,
    additional_protections: ['PCI-DSS', 'SOC2']
  }
};
```

### Field-Level Classification

```sql
-- Data field classification
CREATE TABLE field_classifications (
    table_name VARCHAR(100) NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    classification VARCHAR(50) NOT NULL,
    contains_pii BOOLEAN DEFAULT false,
    contains_financial BOOLEAN DEFAULT false,
    encryption_method VARCHAR(50),  -- 'at-rest', 'field-level', 'tokenized'
    masking_required BOOLEAN DEFAULT false,
    PRIMARY KEY (table_name, field_name)
);

INSERT INTO field_classifications (table_name, field_name, classification, contains_pii, encryption_method, masking_required) VALUES
-- Users table
('users', 'email', 'confidential', true, 'at-rest', true),
('users', 'first_name', 'confidential', true, 'at-rest', false),
('users', 'last_name', 'confidential', true, 'at-rest', false),
('users', 'phone', 'confidential', true, 'at-rest', true),
('users', 'billing_address', 'confidential', true, 'at-rest', false),

-- Payment methods (highly sensitive)
('payment_methods', 'card_number', 'highly_sensitive', true, 'tokenized', true),
('payment_methods', 'cvv', 'highly_sensitive', true, 'never_stored', true),
('payment_methods', 'bank_account', 'highly_sensitive', true, 'tokenized', true),

-- Transactions
('transactions', 'amount', 'confidential', false, 'at-rest', false),
('transactions', 'user_id', 'confidential', true, 'at-rest', false),
('transactions', 'ip_address', 'confidential', true, 'at-rest', true),

-- Public/Internal
('currencies', 'code', 'public', false, null, false),
('system_config', 'setting_value', 'internal', false, 'at-rest', false);
```

## Vendor Data Residency Requirements

### Cloud Provider Selection

```javascript
const cloudProviderCompliance = {
  aws: {
    regions: {
      us: ['us-east-1', 'us-east-2', 'us-west-1', 'us-west-2'],
      eu: ['eu-central-1', 'eu-west-1', 'eu-west-2', 'eu-west-3', 'eu-north-1'],
      uk: ['eu-west-2'],
      ca: ['ca-central-1'],
      br: ['sa-east-1'],
      au: ['ap-southeast-2']
    },
    certifications: ['ISO 27001', 'SOC 2', 'GDPR', 'PCI DSS'],
    dpa_available: true,
    scc_available: true,
    data_residency_guarantees: true,
    schrems_ii_compliant: true
  },

  gcp: {
    regions: {
      us: ['us-central1', 'us-east1', 'us-west1'],
      eu: ['europe-west1', 'europe-west3', 'europe-west4'],
      uk: ['europe-west2'],
      ca: ['northamerica-northeast1'],
      br: ['southamerica-east1'],
      au: ['australia-southeast1']
    },
    certifications: ['ISO 27001', 'SOC 2', 'GDPR', 'PCI DSS'],
    dpa_available: true,
    scc_available: true,
    data_residency_guarantees: true
  },

  azure: {
    regions: {
      us: ['East US', 'West US', 'Central US'],
      eu: ['Germany West Central', 'France Central', 'North Europe'],
      uk: ['UK South', 'UK West'],
      ca: ['Canada Central'],
      br: ['Brazil South'],
      au: ['Australia East']
    },
    certifications: ['ISO 27001', 'SOC 2', 'GDPR', 'PCI DSS'],
    dpa_available: true,
    scc_available: true,
    data_residency_guarantees: true
  }
};
```

### Subprocessor Management

```javascript
// Track all subprocessors for GDPR compliance
CREATE TABLE subprocessors (
    id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(200) NOT NULL,
    service_type VARCHAR(100) NOT NULL,  -- 'cloud_hosting', 'payment_processing', 'email', etc.
    data_access_level VARCHAR(50) NOT NULL,  -- 'full', 'limited', 'metadata_only'
    data_classification VARCHAR(50) NOT NULL,
    processing_location VARCHAR(100) NOT NULL,
    dpa_signed BOOLEAN DEFAULT false,
    dpa_date DATE,
    dpa_document_url VARCHAR(500),
    scc_executed BOOLEAN DEFAULT false,
    certifications TEXT[],
    gdpr_compliant BOOLEAN DEFAULT false,
    privacy_shield_certified BOOLEAN DEFAULT false,
    dpf_certified BOOLEAN DEFAULT false,
    last_audit_date DATE,
    next_audit_date DATE,
    status VARCHAR(50) DEFAULT 'active',  -- 'active', 'pending', 'deprecated'
    added_date DATE NOT NULL,
    notes TEXT
);

-- Example subprocessors
INSERT INTO subprocessors (vendor_name, service_type, data_access_level, data_classification, processing_location, dpa_signed, gdpr_compliant, certifications) VALUES
('Amazon Web Services', 'cloud_hosting', 'full', 'confidential', 'Regional (US, EU, UK, CA, BR, AU)', true, true, ARRAY['ISO 27001', 'SOC 2', 'PCI DSS']),
('Stripe', 'payment_processing', 'limited', 'highly_sensitive', 'Regional', true, true, ARRAY['PCI DSS Level 1', 'ISO 27001']),
('SendGrid', 'email_delivery', 'limited', 'confidential', 'Global', true, true, ARRAY['ISO 27001', 'SOC 2']),
('Lokalise', 'translation_management', 'metadata_only', 'internal', 'EU', true, true, ARRAY['ISO 27001', 'GDPR']);
```

## Customer Data Sovereignty Options

### Self-Service Region Selection

```javascript
// Allow customers to choose their data region
async function selectDataRegion(userId, preferredRegion, billingCountry) {
  const router = new RegionalDatabaseRouter();
  const recommendedRegion = router.determineRegion(billingCountry);

  // Validate region choice
  const availableRegions = await getAvailableRegions(billingCountry);

  if (!availableRegions.includes(preferredRegion)) {
    throw new Error(`Region ${preferredRegion} not available for ${billingCountry}`);
  }

  // Update user's data region
  await db.query(`
    UPDATE users
    SET data_region = $1,
        region_updated_at = NOW(),
        region_change_reason = 'user_preference'
    WHERE id = $2
  `, [preferredRegion, userId]);

  return {
    success: true,
    selectedRegion: preferredRegion,
    recommendedRegion: recommendedRegion,
    message: preferredRegion !== recommendedRegion
      ? `You selected ${preferredRegion}. We recommend ${recommendedRegion} for optimal performance and compliance.`
      : `Data region set to ${preferredRegion}`
  };
}
```

### Enterprise Data Residency SLA

```markdown
## Enterprise Data Residency Guarantee

For Enterprise customers, PopSystem guarantees:

1. **Region Selection**: Choose your data residency region
2. **Contractual Commitment**: Data will not leave chosen region without consent
3. **Compliance Alignment**: Region selection aligned with your compliance needs
4. **Audit Rights**: Annual audit reports on data location
5. **Migration Support**: Assisted migration if changing regions
6. **Backup Transparency**: Full visibility into backup locations
7. **Vendor Management**: Subprocessor list with data locations

### Available Regions:
- United States (US-East)
- European Union (Frankfurt)
- United Kingdom (London)
- Canada (Toronto)
- Brazil (São Paulo)
- Australia (Sydney)

### SLA Commitments:
- 99.99% uptime per region
- < 50ms in-region latency
- Daily backup verification
- Quarterly compliance audits
- Immediate breach notification
```

## Compliance Audit Trails

### Audit Logging Requirements

```sql
-- Comprehensive audit log for data access and transfers
CREATE TABLE data_access_audit_log (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id BIGINT,
    admin_user_id BIGINT,
    action VARCHAR(100) NOT NULL,  -- 'read', 'write', 'delete', 'export', 'transfer'
    table_name VARCHAR(100),
    record_id BIGINT,
    data_classification VARCHAR(50),
    source_region VARCHAR(20),
    destination_region VARCHAR(20),
    ip_address INET,
    user_agent TEXT,
    request_id VARCHAR(100),
    success BOOLEAN DEFAULT true,
    failure_reason TEXT,
    data_snapshot JSONB,  -- For high-sensitivity changes
    legal_basis VARCHAR(100),  -- GDPR: legal basis for processing
    retention_until DATE
);

CREATE INDEX idx_audit_timestamp ON data_access_audit_log(timestamp DESC);
CREATE INDEX idx_audit_user ON data_access_audit_log(user_id, timestamp DESC);
CREATE INDEX idx_audit_action ON data_access_audit_log(action, timestamp DESC);
CREATE INDEX idx_audit_region_transfer ON data_access_audit_log(source_region, destination_region, timestamp DESC);

-- Trigger for automatic audit logging
CREATE OR REPLACE FUNCTION audit_data_access()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO data_access_audit_log (
        user_id,
        action,
        table_name,
        record_id,
        data_classification,
        source_region
    ) VALUES (
        current_setting('app.current_user_id')::BIGINT,
        TG_OP,
        TG_TABLE_NAME,
        NEW.id,
        get_table_classification(TG_TABLE_NAME),
        get_user_region(current_setting('app.current_user_id')::BIGINT)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to sensitive tables
CREATE TRIGGER audit_users_access
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_data_access();

CREATE TRIGGER audit_transactions_access
AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION audit_data_access();
```

### GDPR Data Processing Records (ROPA)

```javascript
// Records of Processing Activities
const processingActivities = [
  {
    activity_name: 'User Account Management',
    purpose: 'Provide SaaS platform services to customers',
    legal_basis: 'Contract',
    data_categories: ['Contact details', 'Account information', 'Usage data'],
    data_subjects: ['Customers', 'End users'],
    recipients: ['Internal staff', 'Cloud hosting provider (AWS)', 'Email provider (SendGrid)'],
    international_transfers: [
      {
        destination: 'United States',
        safeguards: 'Standard Contractual Clauses',
        dpa_reference: 'DPA-AWS-2025-001'
      }
    ],
    retention_period: '7 years after account closure',
    security_measures: ['Encryption at rest', 'Encryption in transit', 'Access controls', 'MFA'],
    dpo_contact: 'dpo@popsystem.com'
  },

  {
    activity_name: 'Payment Processing',
    purpose: 'Process subscription payments',
    legal_basis: 'Contract',
    data_categories: ['Payment card data (tokenized)', 'Billing address', 'Transaction history'],
    data_subjects: ['Customers'],
    recipients: ['Payment processor (Stripe)', 'Banking partners'],
    international_transfers: [
      {
        destination: 'United States',
        safeguards: 'Standard Contractual Clauses + PCI DSS',
        dpa_reference: 'DPA-Stripe-2025-001'
      }
    ],
    retention_period: '7 years (tax/accounting requirements)',
    security_measures: ['Tokenization', 'PCI DSS compliance', 'Encryption', 'Limited access'],
    dpo_contact: 'dpo@popsystem.com'
  },

  {
    activity_name: 'Customer Support',
    purpose: 'Provide technical support and resolve issues',
    legal_basis: 'Legitimate interest',
    data_categories: ['Contact details', 'Support tickets', 'Communication history'],
    data_subjects: ['Customers'],
    recipients: ['Support team', 'Ticketing system provider'],
    international_transfers: [],
    retention_period: '3 years after ticket closure',
    security_measures: ['Access controls', 'Encryption', 'Training'],
    dpo_contact: 'dpo@popsystem.com'
  }
];
```

### Compliance Reporting Dashboard

```javascript
// Generate compliance report for auditors
async function generateComplianceReport(region, reportType, startDate, endDate) {
  const report = {
    report_type: reportType,  // 'gdpr', 'lgpd', 'pipeda', 'audit'
    region: region,
    period: { start: startDate, end: endDate },
    generated_at: new Date(),

    sections: {
      // Data residency verification
      data_residency: await verifyDataResidency(region, startDate, endDate),

      // Access logs
      access_logs: await getAccessLogs(region, startDate, endDate),

      // Data transfers
      data_transfers: await getDataTransfers(region, startDate, endDate),

      // Security incidents
      security_incidents: await getSecurityIncidents(region, startDate, endDate),

      // User rights requests (GDPR)
      user_rights_requests: await getUserRightsRequests(region, startDate, endDate),

      // Subprocessor changes
      subprocessor_changes: await getSubprocessorChanges(startDate, endDate),

      // Compliance attestations
      certifications: await getCurrentCertifications(),

      // Breach notifications
      breach_notifications: await getBreachNotifications(region, startDate, endDate)
    }
  };

  return report;
}

// Verify all data is in correct region
async function verifyDataResidency(region, startDate, endDate) {
  const verification = await db.query(`
    SELECT
      table_name,
      COUNT(*) as record_count,
      data_region,
      COUNT(*) FILTER (WHERE data_region != $1) as misplaced_records
    FROM (
      SELECT 'users' as table_name, data_region FROM users WHERE created_at BETWEEN $2 AND $3
      UNION ALL
      SELECT 'transactions', u.data_region FROM transactions t
      JOIN users u ON t.user_id = u.id
      WHERE t.created_at BETWEEN $2 AND $3
    ) regional_data
    GROUP BY table_name, data_region
  `, [region, startDate, endDate]);

  return {
    status: verification.rows.every(r => r.misplaced_records === 0) ? 'PASS' : 'FAIL',
    details: verification.rows
  };
}
```

## Implementation Roadmap

### Phase 1: Foundation (v2 - 2025)
- [ ] Design multi-region architecture
- [ ] Implement regional database routing
- [ ] Set up US region (primary)
- [ ] Create data classification framework
- [ ] Implement audit logging
- [ ] Execute DPAs with AWS, Stripe, SendGrid
- [ ] Document data flows and processing activities (ROPA)

### Phase 2: EU Launch (Q1 2027)
- [ ] Deploy Frankfurt and London database regions
- [ ] Implement GDPR-specific features:
  - [ ] User consent management
  - [ ] Data export (portability)
  - [ ] Data deletion (right to erasure)
  - [ ] Data processing records
- [ ] Execute Standard Contractual Clauses for EU-US transfers
- [ ] Appoint Data Protection Officer (DPO)
- [ ] Complete GDPR compliance audit
- [ ] Set up EU backup infrastructure (Paris)
- [ ] Implement cookie consent and tracking controls

### Phase 3: Canada & Brazil (2027)
- [ ] Deploy Toronto region (Canada)
- [ ] Deploy São Paulo region (Brazil)
- [ ] Implement PIPEDA compliance features
- [ ] Implement LGPD compliance features (similar to GDPR)
- [ ] Appoint Brazilian Encarregado (DPO equivalent)
- [ ] Update privacy policies for Canadian and Brazilian laws
- [ ] Execute SCCs for Brazil-US backup transfers

### Phase 4: APAC (2028+)
- [ ] Deploy Sydney region (Australia/NZ)
- [ ] Implement Australian Privacy Act compliance
- [ ] Plan for additional APAC regions based on market needs
- [ ] Evaluate China requirements (separate planning)

### Phase 5: Ongoing Compliance
- [ ] Quarterly compliance reviews
- [ ] Annual GDPR/LGPD audits
- [ ] Continuous subprocessor monitoring
- [ ] Regular penetration testing
- [ ] Employee privacy training (annual)
- [ ] Incident response drills (bi-annual)
- [ ] Privacy policy updates (as needed)
- [ ] Regulatory change monitoring

## Best Practices & Recommendations

### Design Principles

1. **Data Minimization**: Only collect and store data necessary for business purpose
2. **Purpose Limitation**: Use data only for stated purposes
3. **Storage Limitation**: Retain data only as long as necessary
4. **Privacy by Design**: Build privacy into architecture from start
5. **Privacy by Default**: Most privacy-protective settings as default
6. **Transparency**: Clear communication about data practices
7. **Security**: Appropriate technical and organizational measures

### Operational Guidelines

1. **Regular Audits**: Quarterly internal, annual external
2. **Incident Response**: 72-hour breach notification (GDPR)
3. **Vendor Management**: Annual subprocessor reviews
4. **Employee Training**: Privacy training for all staff
5. **Documentation**: Maintain detailed records of processing
6. **User Rights**: Respond to requests within 30 days
7. **Change Management**: Privacy impact assessment for new features

### Technical Safeguards

1. **Encryption**: At rest and in transit (TLS 1.3, AES-256)
2. **Access Controls**: Role-based access, least privilege
3. **Authentication**: MFA for admin access
4. **Network Security**: Firewalls, VPNs, network segmentation
5. **Monitoring**: Real-time security monitoring and alerting
6. **Backups**: Encrypted, tested regularly, geographically appropriate
7. **Data Masking**: Mask sensitive data in non-production environments

## Conclusion

PopSystem's data residency strategy balances compliance requirements, customer preferences, and operational efficiency. By implementing regional data isolation, robust transfer mechanisms, comprehensive audit trails, and customer sovereignty options, we ensure:

- **Regulatory Compliance**: Full compliance with GDPR, UK GDPR, PIPEDA, LGPD, and other regional laws
- **Customer Trust**: Transparent data practices with customer control
- **Operational Excellence**: Efficient multi-region architecture
- **Competitive Advantage**: Enterprise-grade data residency guarantees
- **Future-Proof**: Scalable architecture for new regions and regulations

This strategy enables PopSystem to confidently expand into international markets while maintaining the highest standards of data protection and privacy.
