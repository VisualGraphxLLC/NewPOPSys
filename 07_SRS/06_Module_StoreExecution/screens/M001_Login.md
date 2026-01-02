# M001 - Login Screen

> **Module**: MobilePWA (Store Execution)
> **Screen ID**: M001
> **Route**: `/app/login`
> **IEEE 830 Section**: 3.2.1 - User Interface Requirements
> **Version**: 1.0
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Login screen provides secure authentication for store personnel accessing the NewPOPSys mobile PWA. It implements a simplified store-centric authentication flow using store number and personal PIN, optimized for retail environments where users may share devices but require individual accountability.

### 1.2 Scope

This specification covers:
- Store number input and validation
- PIN-based authentication
- Session token management
- Rate limiting and security controls
- Offline authentication fallback

### 1.3 Screenshot Reference

![Login Screen](../../screenshots/Mobile_App/mobile_app.png)

### 1.4 Source Documents

| Document | Reference |
|----------|-----------|
| Screen Spec | [M01_Login.md](../../../../06_Screen_Specs/M01_Login.md) |
| SUPP Reference | SUPP-036 (Onboarding and Store Foundation) |
| Authentication | [4.3_Authentication_Flows.md](../../04_User_Personas_RBAC/4.3_Authentication_Flows.md) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Description |
|------|--------------|-------------|
| Store Manager (P07) | Full | Can authenticate and access all store features |
| Store Operator (P08) | Execute | Can authenticate and execute assigned tasks |

### 2.2 Role Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-ROLE-001 | System SHALL authenticate users with STORE_MANAGER or STORE_OPERATOR roles | Must |
| REQ-M001-ROLE-002 | System SHALL deny authentication to non-store-level roles | Must |
| REQ-M001-ROLE-003 | System SHALL load user's active store memberships upon successful login | Must |

### 2.3 Permission Constraints

- Only users with active `Membership` records for a store may authenticate
- User must have `is_active = true` status
- Store must have `status = ACTIVE`

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description | Required |
|--------------|------|-------------|----------|
| COMP-M001-001 | Header | Brand logo, "Welcome" text | Yes |
| COMP-M001-002 | Text Input | Store number field (alphanumeric) | Yes |
| COMP-M001-003 | PIN Input | Masked 4-6 digit PIN field | Yes |
| COMP-M001-004 | Button | Primary "Login" button | Yes |
| COMP-M001-005 | Link | "Forgot PIN?" help link | Yes |
| COMP-M001-006 | Text | Error message display area | Conditional |
| COMP-M001-007 | Spinner | Loading indicator during auth | Conditional |

### 3.2 Component Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-UI-001 | Store number input SHALL accept alphanumeric characters up to 20 chars | Must |
| REQ-M001-UI-002 | PIN input SHALL mask entered digits with bullets/asterisks | Must |
| REQ-M001-UI-003 | PIN input SHALL accept 4-6 numeric digits | Must |
| REQ-M001-UI-004 | Login button SHALL be disabled until both fields have valid input | Must |
| REQ-M001-UI-005 | Error messages SHALL display below the PIN field in red text | Must |
| REQ-M001-UI-006 | Loading spinner SHALL replace button text during authentication | Should |

### 3.3 Layout Specification

```
+---------------------------------------+
|                                       |
|            [Brand Logo]               |
|                                       |
|           Welcome Back                |
|                                       |
|  +-------------------------------+    |
|  | Store Number                  |    |
|  | [STR-001________________]     |    |
|  +-------------------------------+    |
|                                       |
|  +-------------------------------+    |
|  | PIN                           |    |
|  | [****__]                      |    |
|  +-------------------------------+    |
|                                       |
|  [!] Invalid store number or PIN      |
|                                       |
|  +-------------------------------+    |
|  |          [Login]              |    |
|  +-------------------------------+    |
|                                       |
|         Forgot PIN?                   |
|                                       |
+---------------------------------------+
```

---

## 4. Data Requirements

### 4.1 Input Data

| Field | Type | Validation | Source |
|-------|------|------------|--------|
| `store_number` | String | Required, 1-20 chars, alphanumeric | User input |
| `pin` | String | Required, 4-6 numeric digits | User input |

### 4.2 Output Data

| Field | Type | Description | Destination |
|-------|------|-------------|-------------|
| `access_token` | JWT | Bearer token for API calls | Secure storage |
| `refresh_token` | String | Token for session renewal | Secure storage |
| `user` | Object | User profile data | App state |
| `store` | Object | Active store context | App state |
| `expires_at` | Timestamp | Token expiration time | App state |

### 4.3 Data Model References

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `Store` | id, store_number, name, status, brand_id | Read |
| `User` | id, name, email, is_active, pin_hash | Read |
| `Membership` | user_id, store_id, role | Read |

### 4.4 Data Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-DATA-001 | System SHALL validate store_number against active stores | Must |
| REQ-M001-DATA-002 | System SHALL hash PIN before transmission | Must |
| REQ-M001-DATA-003 | System SHALL store tokens in secure keychain/keystore | Must |
| REQ-M001-DATA-004 | System SHALL cache user and store data for offline access | Should |

---

## 5. Business Rules & Validation

### 5.1 Authentication Rules

| Rule ID | Rule | Implementation |
|---------|------|----------------|
| BR-M001-001 | Store number must match an active store | Query `stores` WHERE `store_number` = input AND `status` = 'ACTIVE' |
| BR-M001-002 | User must have membership at the store | Query `memberships` WHERE `store_id` = store.id AND `user_id` = user.id |
| BR-M001-003 | User account must be active | Check `users.is_active = true` |
| BR-M001-004 | PIN must match hashed value | Compare bcrypt hash of input with `users.pin_hash` |

### 5.2 Rate Limiting Rules

| Rule ID | Rule | Parameters |
|---------|------|------------|
| BR-M001-005 | Failed attempts before lockout | 5 attempts |
| BR-M001-006 | Lockout duration | 15 minutes |
| BR-M001-007 | Lockout scope | Per store number + device combination |
| BR-M001-008 | Attempts counter reset | After successful login or lockout expiry |

### 5.3 Session Rules

| Rule ID | Rule | Value |
|---------|------|-------|
| BR-M001-009 | Access token lifetime | 1 hour |
| BR-M001-010 | Refresh token lifetime | 8 hours |
| BR-M001-011 | Session inactivity timeout | 8 hours |
| BR-M001-012 | Maximum concurrent sessions | 1 per user per store |

### 5.4 Validation Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-VAL-001 | System SHALL validate store number format before API call | Must |
| REQ-M001-VAL-002 | System SHALL validate PIN is 4-6 numeric digits | Must |
| REQ-M001-VAL-003 | System SHALL enforce rate limiting after 5 failed attempts | Must |
| REQ-M001-VAL-004 | System SHALL block authentication during lockout period | Must |
| REQ-M001-VAL-005 | System SHALL display remaining lockout time to user | Should |

---

## 6. API Integration Points

### 6.1 Authentication Endpoint

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/auth/store-login` |
| **Auth Required** | No |
| **Rate Limited** | Yes |

#### Request Schema

```json
{
  "store_number": "STR-001",
  "pin": "1234",
  "device_id": "uuid-v4"
}
```

#### Response Schema (Success - 200)

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "expires_at": "2026-01-01T09:00:00Z",
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@store.com",
    "role": "STORE_OPERATOR"
  },
  "store": {
    "id": "uuid",
    "store_number": "STR-001",
    "name": "Downtown Location",
    "brand_id": "uuid"
  }
}
```

#### Error Responses

| Status | Code | Message |
|--------|------|---------|
| 401 | `INVALID_CREDENTIALS` | Invalid store number or PIN |
| 403 | `ACCOUNT_INACTIVE` | User account is deactivated |
| 403 | `STORE_INACTIVE` | Store is not active |
| 429 | `RATE_LIMITED` | Too many attempts. Try again in {minutes} minutes |

### 6.2 Token Refresh Endpoint

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/auth/refresh` |
| **Auth Required** | Refresh token |

#### Request Schema

```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

### 6.3 API Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-API-001 | System SHALL send device_id with authentication request | Must |
| REQ-M001-API-002 | System SHALL use HTTPS for all authentication requests | Must |
| REQ-M001-API-003 | System SHALL refresh token before expiration | Must |
| REQ-M001-API-004 | System SHALL retry failed requests with exponential backoff | Should |

---

## 7. State Transitions

### 7.1 Authentication State Machine

```
[IDLE] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                    â”‚
   â”‚ User enters        â”‚ Credentials cleared
   â”‚ credentials        â”‚
   â–¼                    â”‚
[VALIDATING] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
   â”‚                    â”‚
   â”‚ Local validation   â”‚
   â”‚ passed             â”‚
   â–¼                    â”‚
[AUTHENTICATING] â”€â”€â”€â”€â”€â”€â”¤
   â”‚         â”‚          â”‚
   â”‚ Success â”‚ Failure  â”‚
   â–¼         â–¼          â”‚
[AUTHENTICATED] [ERROR]â”€â”˜
   â”‚
   â”‚ Navigate to Dashboard
   â–¼
[COMPLETE]
```

### 7.2 Rate Limit State Machine

```
[UNLOCKED] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                     â”‚
   â”‚ Failed attempt      â”‚ Timer expires
   â”‚ (count < 5)         â”‚ OR success
   â–¼                     â”‚
[WARNING] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
   â”‚                     â”‚
   â”‚ 5th failed          â”‚
   â”‚ attempt             â”‚
   â–¼                     â”‚
[LOCKED] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
   â”‚
   â”‚ 15 min timer
   â–¼
[UNLOCKED]
```

### 7.3 State Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-STATE-001 | System SHALL persist authentication state across app restarts | Must |
| REQ-M001-STATE-002 | System SHALL clear authentication state on logout | Must |
| REQ-M001-STATE-003 | System SHALL track failed attempt count in local storage | Must |
| REQ-M001-STATE-004 | System SHALL navigate to Dashboard (M002) on successful auth | Must |

---

## 8. Error Handling

### 8.1 Error Categories

| Category | Handling Approach |
|----------|-------------------|
| Validation Errors | Display inline error messages |
| Network Errors | Retry with offline fallback |
| Authentication Errors | Display generic "invalid credentials" |
| Rate Limit Errors | Display lockout countdown |
| Server Errors | Display generic error with retry option |

### 8.2 Error Messages

| Error Code | User Message | Technical Action |
|------------|--------------|------------------|
| `INVALID_CREDENTIALS` | "Invalid store number or PIN. Please try again." | Log attempt, increment counter |
| `ACCOUNT_INACTIVE` | "Your account has been deactivated. Contact your manager." | No retry allowed |
| `STORE_INACTIVE` | "This store is not active. Contact support." | No retry allowed |
| `RATE_LIMITED` | "Too many attempts. Please wait {X} minutes." | Show countdown timer |
| `NETWORK_ERROR` | "Unable to connect. Check your connection and try again." | Retry button |
| `SERVER_ERROR` | "Something went wrong. Please try again." | Retry with backoff |

### 8.3 Offline Authentication

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M001-ERR-001 | System SHALL allow offline login if user has cached credentials | Should |
| REQ-M001-ERR-002 | System SHALL validate PIN locally against cached hash when offline | Should |
| REQ-M001-ERR-003 | System SHALL sync with server when connection is restored | Should |
| REQ-M001-ERR-004 | System SHALL NOT display specific error for security (store vs PIN) | Must |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Req ID | Requirement | WCAG Criterion | Priority |
|--------|-------------|----------------|----------|
| REQ-M001-A11Y-001 | All form fields SHALL have associated labels | 1.3.1 Info and Relationships | Must |
| REQ-M001-A11Y-002 | Error messages SHALL be announced by screen readers | 4.1.3 Status Messages | Must |
| REQ-M001-A11Y-003 | Color SHALL NOT be sole indicator of errors | 1.4.1 Use of Color | Must |
| REQ-M001-A11Y-004 | Touch targets SHALL be minimum 44x44 pixels | 2.5.5 Target Size | Must |
| REQ-M001-A11Y-005 | Form SHALL be navigable via keyboard/switch | 2.1.1 Keyboard | Must |

### 9.2 Assistive Technology Support

| Feature | Implementation |
|---------|----------------|
| Screen Reader | ARIA labels on all interactive elements |
| Voice Control | Named buttons and inputs |
| Large Text | Responsive font scaling up to 200% |
| High Contrast | Respects system high contrast mode |

### 9.3 ARIA Implementation

```html
<form role="form" aria-labelledby="login-heading">
  <h1 id="login-heading">Welcome Back</h1>

  <label for="store-number">Store Number</label>
  <input id="store-number" type="text"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="store-error" />
  <span id="store-error" role="alert"></span>

  <label for="pin">PIN</label>
  <input id="pin" type="password" inputmode="numeric"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="pin-error" />
  <span id="pin-error" role="alert"></span>

  <button type="submit" aria-busy="false">Login</button>
</form>
```

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| AC ID | Criterion | Verification Method |
|-------|-----------|---------------------|
| AC-M001-001 | User can enter store number and PIN | Manual test |
| AC-M001-002 | Valid credentials result in successful authentication | API integration test |
| AC-M001-003 | Invalid credentials display error message | Manual test |
| AC-M001-004 | 5 failed attempts trigger 15-minute lockout | Automated test |
| AC-M001-005 | Successful login navigates to Dashboard | E2E test |
| AC-M001-006 | JWT tokens are stored securely | Security audit |
| AC-M001-007 | Session persists across app restarts | Manual test |
| AC-M001-008 | Forgot PIN link is accessible | Manual test |

### 10.2 Non-Functional Acceptance

| AC ID | Criterion | Target | Verification |
|-------|-----------|--------|--------------|
| AC-M001-NF-001 | Authentication response time | < 2 seconds | Performance test |
| AC-M001-NF-002 | Offline login capability | Yes, with cached credentials | Offline test |
| AC-M001-NF-003 | Screen loads within | < 1 second | Lighthouse audit |
| AC-M001-NF-004 | Accessibility score | 100% WCAG 2.1 AA | axe-core audit |

### 10.3 Security Acceptance

| AC ID | Criterion | Verification |
|-------|-----------|--------------|
| AC-M001-SEC-001 | PIN is never logged or stored in plaintext | Code review |
| AC-M001-SEC-002 | Tokens stored in secure keychain/keystore | Security audit |
| AC-M001-SEC-003 | Rate limiting prevents brute force | Penetration test |
| AC-M001-SEC-004 | No credentials in error messages | Manual review |

---

## 11. Traceability Matrix

| Requirement | Source | Test Case |
|-------------|--------|-----------|
| REQ-M001-ROLE-001 | SUPP-003 | TC-M001-001 |
| REQ-M001-UI-002 | SUPP-036 | TC-M001-002 |
| REQ-M001-VAL-003 | Security Policy | TC-M001-003 |
| REQ-M001-API-002 | Security Policy | TC-M001-004 |
| REQ-M001-A11Y-001 | WCAG 2.1 | TC-M001-005 |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.1 - User Interface Requirements*
