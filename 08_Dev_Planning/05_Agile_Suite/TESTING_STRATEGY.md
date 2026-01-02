# Testing Strategy

## Overview

This document outlines the testing approach for the project, including test types, tools, coverage targets, and best practices. Our goal is to maintain high quality through a balanced testing pyramid.

---

## Testing Pyramid

```
                    ┌─────────┐
                    │   E2E   │  ← Fewer, slower, higher confidence
                    │  Tests  │
                   ─┴─────────┴─
                  ┌─────────────┐
                  │ Integration │  ← Medium coverage
                  │    Tests    │
                 ─┴─────────────┴─
                ┌─────────────────┐
                │   Unit Tests    │  ← Many, fast, focused
                │                 │
                └─────────────────┘
```

---

## Unit Tests

### Tool: Vitest

**Why Vitest?**
- Fast execution with native ESM support
- Jest-compatible API for easy migration
- Built-in TypeScript support
- Excellent DX with watch mode and UI

### Coverage Target: 80%

| Metric | Target | Minimum |
|--------|--------|---------|
| Line Coverage | 80% | 70% |
| Branch Coverage | 80% | 70% |
| Function Coverage | 80% | 75% |
| Statement Coverage | 80% | 70% |

### Configuration

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    globals: true,
    environment: 'jsdom',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      thresholds: {
        lines: 80,
        branches: 80,
        functions: 80,
        statements: 80
      },
      exclude: [
        'node_modules/',
        'tests/',
        '**/*.d.ts',
        '**/*.config.*'
      ]
    }
  }
})
```

### Best Practices

- **Test one thing per test** - Each test should verify a single behavior
- **Use descriptive names** - `describe('UserService.createUser')` + `it('should throw error when email is invalid')`
- **Arrange-Act-Assert** - Structure tests clearly
- **Mock external dependencies** - Isolate the unit under test
- **Avoid testing implementation details** - Focus on inputs and outputs

### Example

```typescript
import { describe, it, expect, vi } from 'vitest'
import { UserService } from './user.service'

describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      // Arrange
      const userData = { email: 'test@example.com', name: 'Test User' }
      const mockRepo = { save: vi.fn().mockResolvedValue({ id: 1, ...userData }) }
      const service = new UserService(mockRepo)

      // Act
      const result = await service.createUser(userData)

      // Assert
      expect(result.id).toBe(1)
      expect(mockRepo.save).toHaveBeenCalledWith(userData)
    })

    it('should throw error when email is invalid', async () => {
      // Arrange
      const userData = { email: 'invalid', name: 'Test User' }
      const service = new UserService({})

      // Act & Assert
      await expect(service.createUser(userData)).rejects.toThrow('Invalid email')
    })
  })
})
```

---

## Integration Tests

### Focus: API Endpoint Testing

Integration tests verify that different parts of the system work together correctly, with a focus on API endpoints and service integrations.

### What to Test

- **API endpoints** - Request/response validation
- **Database operations** - CRUD operations with real database
- **External service integrations** - Third-party API calls (mocked)
- **Authentication/authorization** - Security flows

### Tools

- **Vitest** - Test runner
- **Supertest** - HTTP assertions
- **Test containers** - Isolated database instances

### Configuration

```typescript
// integration.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    include: ['tests/integration/**/*.test.ts'],
    setupFiles: ['tests/integration/setup.ts'],
    testTimeout: 30000,
    hookTimeout: 30000
  }
})
```

### Example

```typescript
import { describe, it, expect, beforeAll, afterAll } from 'vitest'
import request from 'supertest'
import { app } from '../src/app'
import { setupTestDatabase, teardownTestDatabase } from './helpers'

describe('POST /api/orders', () => {
  beforeAll(async () => {
    await setupTestDatabase()
  })

  afterAll(async () => {
    await teardownTestDatabase()
  })

  it('should create an order and return 201', async () => {
    const orderData = {
      customerId: 1,
      items: [{ sku: 'ABC123', quantity: 2 }]
    }

    const response = await request(app)
      .post('/api/orders')
      .set('Authorization', 'Bearer valid-token')
      .send(orderData)

    expect(response.status).toBe(201)
    expect(response.body.orderId).toBeDefined()
    expect(response.headers.location).toMatch(/\/api\/orders\/\d+/)
  })

  it('should return 400 for invalid order data', async () => {
    const response = await request(app)
      .post('/api/orders')
      .set('Authorization', 'Bearer valid-token')
      .send({})

    expect(response.status).toBe(400)
    expect(response.body.error).toBe('VALIDATION_ERROR')
  })
})
```

---

## E2E Tests

### Tool: Playwright

**Why Playwright?**
- Cross-browser support (Chromium, Firefox, WebKit)
- Auto-wait capabilities reduce flakiness
- Powerful debugging with trace viewer
- Parallel execution for speed

### Configuration

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test'

export default defineConfig({
  testDir: './tests/e2e',
  timeout: 30000,
  retries: 2,
  workers: 4,
  reporter: [['html'], ['junit', { outputFile: 'results.xml' }]],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure'
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
    { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    { name: 'mobile', use: { ...devices['iPhone 13'] } }
  ]
})
```

### Critical User Flows to Test

1. **User Registration & Login**
2. **Product Search & Browse**
3. **Add to Cart & Checkout**
4. **Order Management**
5. **Account Settings**

### Example

```typescript
import { test, expect } from '@playwright/test'

test.describe('Checkout Flow', () => {
  test('user can complete purchase', async ({ page }) => {
    // Login
    await page.goto('/login')
    await page.fill('[data-testid="email"]', 'test@example.com')
    await page.fill('[data-testid="password"]', 'password123')
    await page.click('[data-testid="login-button"]')

    // Add item to cart
    await page.goto('/products/123')
    await page.click('[data-testid="add-to-cart"]')

    // Checkout
    await page.goto('/cart')
    await page.click('[data-testid="checkout-button"]')

    // Fill shipping info
    await page.fill('[data-testid="address"]', '123 Test St')
    await page.click('[data-testid="continue-to-payment"]')

    // Complete order
    await page.click('[data-testid="place-order"]')

    // Verify success
    await expect(page.locator('[data-testid="order-confirmation"]')).toBeVisible()
    await expect(page.locator('[data-testid="order-number"]')).toHaveText(/ORD-\d+/)
  })
})
```

---

## Manual Testing

### Exploratory Testing

Exploratory testing complements automated tests by finding issues that scripted tests might miss.

**When to Perform:**
- Before major releases
- After significant feature additions
- When investigating reported issues

**Focus Areas:**
- Edge cases and unusual workflows
- Error handling and recovery
- Performance under stress
- Usability and user experience

**Documentation:**
- Use session-based test management
- Document findings immediately
- Create bugs or test cases from discoveries

### Accessibility Testing

Ensure WCAG 2.1 AA compliance for all user-facing features.

**Tools:**
- **axe DevTools** - Browser extension for automated checks
- **WAVE** - Web accessibility evaluation tool
- **Screen readers** - NVDA (Windows), VoiceOver (Mac)

**Checklist:**
- [ ] Keyboard navigation works for all interactive elements
- [ ] Focus indicators are visible
- [ ] Color contrast meets 4.5:1 ratio
- [ ] Images have alt text
- [ ] Forms have proper labels
- [ ] Error messages are announced to screen readers
- [ ] Page structure uses semantic HTML

---

## Test Execution Schedule

| Test Type | When to Run | Duration |
|-----------|-------------|----------|
| Unit Tests | Every commit, PR | ~1-2 min |
| Integration Tests | Every PR | ~5-10 min |
| E2E Tests (smoke) | Every PR | ~10-15 min |
| E2E Tests (full) | Nightly, pre-release | ~30-60 min |
| Manual/Exploratory | Weekly, pre-release | 2-4 hours |
| Accessibility | Per feature, pre-release | 1-2 hours |

---

## Reporting & Metrics

### Key Metrics
- Test pass rate
- Code coverage percentage
- Test execution time
- Flaky test rate

### CI Integration
- Tests run on every pull request
- Coverage reports published as PR comments
- Test failures block merge

---

*Last Updated: 2026-01-01*
