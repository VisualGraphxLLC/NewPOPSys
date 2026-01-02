# Acceptance Criteria Guide

## Overview

Acceptance Criteria (AC) define the conditions that must be met for a user story to be considered complete. Well-written ACs are testable, specific, and provide clear guidance for development and QA.

---

## Given/When/Then Format

The **Given/When/Then** format (also known as Gherkin syntax) provides a structured way to write acceptance criteria that is:
- Easy to understand for all stakeholders
- Directly translatable to automated tests
- Focused on behavior rather than implementation

### Structure

```
Given [precondition/context]
When [action/trigger]
Then [expected outcome]
```

### Optional Additions

```
And [additional condition or action]
But [exception or negative case]
```

---

## Examples by Scenario Type

### UI Examples

#### Example 1: Login Form Validation
```gherkin
Scenario: User submits login form with invalid email

Given the user is on the login page
And the user has entered "invalid-email" in the email field
And the user has entered "password123" in the password field
When the user clicks the "Sign In" button
Then an error message "Please enter a valid email address" is displayed
And the email field is highlighted in red
And the form is not submitted
```

#### Example 2: Responsive Navigation
```gherkin
Scenario: Mobile navigation menu toggle

Given the user is viewing the site on a mobile device (viewport < 768px)
And the navigation menu is collapsed
When the user taps the hamburger menu icon
Then the navigation menu expands to show all menu items
And the hamburger icon changes to an X (close) icon
And the page content is overlaid with a semi-transparent backdrop
```

#### Example 3: Form Auto-save
```gherkin
Scenario: Draft is automatically saved while editing

Given the user is editing a document
When the user stops typing for 3 seconds
Then the document is automatically saved
And a "Saved" indicator appears near the title
And the last saved timestamp is updated
```

---

### API Examples

#### Example 1: Successful Resource Creation
```gherkin
Scenario: Create a new order via API

Given the user is authenticated with a valid API token
And the request body contains valid order data:
  | field        | value           |
  | customer_id  | 12345           |
  | items        | [{"sku": "ABC"}]|
  | total        | 99.99           |
When a POST request is sent to /api/v1/orders
Then the response status code is 201 Created
And the response body contains the new order ID
And the response includes a Location header with the order URL
And the order is persisted in the database
```

#### Example 2: Validation Error Handling
```gherkin
Scenario: API returns validation error for missing required field

Given the user is authenticated with a valid API token
And the request body is missing the required "customer_id" field
When a POST request is sent to /api/v1/orders
Then the response status code is 400 Bad Request
And the response body contains:
  | field   | value                              |
  | error   | VALIDATION_ERROR                   |
  | message | customer_id is a required field    |
```

#### Example 3: Rate Limiting
```gherkin
Scenario: API enforces rate limiting

Given the user has made 100 requests in the last minute
When the user makes another API request
Then the response status code is 429 Too Many Requests
And the response includes a Retry-After header
And the response body contains a message explaining the rate limit
```

---

### Integration Examples

#### Example 1: Third-Party Payment Processing
```gherkin
Scenario: Successful payment via Stripe integration

Given the user has items in their cart totaling $50.00
And the user has entered valid payment information
When the user clicks "Complete Purchase"
Then a payment intent is created with Stripe
And upon Stripe confirmation, the order status is set to "Paid"
And the user receives an order confirmation email
And the inventory is updated to reflect the purchase
```

#### Example 2: Single Sign-On (SSO)
```gherkin
Scenario: User authenticates via Google SSO

Given the user is on the login page
And the user has a valid Google account
When the user clicks "Sign in with Google"
Then the user is redirected to Google's authentication page
And upon successful Google authentication, the user is redirected back
And a user account is created if one doesn't exist
And the user is logged in and redirected to the dashboard
```

#### Example 3: Webhook Processing
```gherkin
Scenario: Process incoming shipping webhook

Given the system is configured to receive webhooks from ShipStation
When a webhook is received with event type "SHIPMENT_CREATED"
And the payload contains valid tracking information
Then the corresponding order is updated with tracking details
And the order status is changed to "Shipped"
And the customer is notified via email with tracking link
```

---

## Best Practices

### Do's ✅

1. **Be specific** - Use exact values, not vague terms
   - ✅ "Error message displays within 200ms"
   - ❌ "Error message displays quickly"

2. **Focus on behavior** - Describe what, not how
   - ✅ "User sees their order history"
   - ❌ "System queries database and renders React component"

3. **Make it testable** - Each AC should be verifiable
   - ✅ "Email is sent within 5 minutes"
   - ❌ "Email is sent in a timely manner"

4. **Cover edge cases** - Include error states and boundaries
5. **Keep it independent** - Each scenario should stand alone

### Don'ts ❌

1. **Don't describe implementation** - Focus on outcomes
2. **Don't be ambiguous** - Avoid "should," "might," "usually"
3. **Don't combine scenarios** - One scenario per behavior
4. **Don't skip negative cases** - Test what shouldn't happen
5. **Don't assume context** - State all preconditions explicitly

---

## Template

```gherkin
Feature: [Feature Name]

  Scenario: [Brief description of the scenario]
    Given [initial context]
    And [additional context if needed]
    When [action is taken]
    And [additional action if needed]
    Then [expected outcome]
    And [additional outcome if needed]
    But [exception if applicable]
```

---

*Last Updated: 2026-01-01*
