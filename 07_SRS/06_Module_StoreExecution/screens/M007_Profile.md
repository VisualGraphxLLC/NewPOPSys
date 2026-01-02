# M007 - Profile Screen

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M007
> **Route**: `/app/profile`
> **IEEE 830 Section**: 3.2.7 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

---

## 1. Screen Overview

### 1.1 Purpose

The Profile screen provides user account management capabilities including personal information display and editing, notification preference configuration, PIN change functionality, and secure logout. It serves as the central hub for user-specific settings within the mobile PWA.

### 1.2 Scope

This specification covers:
- User profile display (name, email, phone, store)
- Profile editing (name, phone - email read-only)
- Notification preference toggles (email/push per type)
- PIN change workflow with current PIN verification
- Secure logout with session clearing
- App version display for support

### 1.3 Screenshot Reference

![Profile Screen](../../screenshots/Store_Execution/mobile_profile.png)
*(Note: Tablet and Desktop views follow standard responsive scaling)*

### 1.4 Source Documents

| Document | Reference |
|----------|-----------|
| Screen Spec | [M07_Profile.md](../../../../06_Screen_Specs/M07_Profile.md) |
| SUPP Reference | SUPP-036 (Onboarding and Store Foundation) |
| Authentication | [4.3_Authentication_Flows.md](../../04_User_Personas_RBAC/4.3_Authentication_Flows.md) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Description |
|------|--------------|-------------|
| Store Manager (P07) | Full | Can view and edit own profile |
| Store Operator (P08) | Full | Can view and edit own profile |

### 2.2 Role Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-ROLE-001 | System SHALL display profile for authenticated user only | Must |
| REQ-M007-ROLE-002 | System SHALL allow users to edit their own profile only | Must |
| REQ-M007-ROLE-003 | System SHALL display store membership information from user's Membership record | Must |

### 2.3 Permission Constraints

- Users can only view/edit their own profile
- Email address is read-only (managed by admin)
- Store assignment displayed but not editable

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description | Required |
|--------------|------|-------------|----------|
| COMP-M007-001 | Header | App bar with "Profile" title and back button | Yes |
| COMP-M007-002 | Avatar | User photo or initials circle | Yes |
| COMP-M007-003 | User Info Card | Name, email, phone, store display | Yes |
| COMP-M007-004 | Edit Button | Icon button to open edit modal | Yes |
| COMP-M007-005 | Notification Toggles | Per-type email/push toggle switches | Yes |
| COMP-M007-006 | Change PIN Item | List item linking to PIN change flow | Yes |
| COMP-M007-007 | Logout Button | Destructive button for sign out | Yes |
| COMP-M007-008 | App Version | Text displaying version and build number | Yes |
| COMP-M007-009 | Edit Modal | Name and phone input form | Conditional |
| COMP-M007-010 | PIN Change Modal | Current/new/confirm PIN inputs | Conditional |

### 3.2 Component Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-UI-001 | Avatar SHALL display user photo or initials fallback | Must |
| REQ-M007-UI-002 | Email field SHALL be displayed as read-only | Must |
| REQ-M007-UI-003 | Notification toggles SHALL save immediately on change | Must |
| REQ-M007-UI-004 | Logout button SHALL use destructive styling (red) | Must |
| REQ-M007-UI-005 | App version SHALL display version and build number | Must |
| REQ-M007-UI-006 | PIN input fields SHALL mask entered digits | Must |

### 3.3 Profile Layout

```
+---------------------------------------+
| <- Profile                            |
+---------------------------------------+
|                                       |
|            +-------+                  |
|            |  JD   |                  |
|            +-------+                  |
|          John Doe              [Edit] |
|       john@store.com                  |
|       (555) 123-4567                  |
|                                       |
|       Store: STR-001                  |
|       Acme Retail - Downtown          |
|                                       |
+---------------------------------------+
| Notifications                         |
|                                       |
| Shipment Updates                      |
|   Email [ON]  Push [ON]               |
|                                       |
| Photo Reviews                         |
|   Email [OFF] Push [ON]               |
|                                       |
| Campaign Reminders                    |
|   Email [ON]  Push [ON]               |
|                                       |
| Issue Updates                         |
|   Email [ON]  Push [OFF]              |
|                                       |
+---------------------------------------+
| Security                              |
|                                       |
| Change PIN                        [>] |
|                                       |
+---------------------------------------+
|                                       |
|          [Logout]                     |
|                                       |
|       Version 1.0.0 (build 42)        |
+---------------------------------------+
```

### 3.4 Edit Modal Layout

```
+---------------------------------------+
| Edit Profile                      [X] |
+---------------------------------------+
|                                       |
| Name                                  |
| +-----------------------------------+ |
| | John Doe                          | |
| +-----------------------------------+ |
|                                       |
| Phone                                 |
| +-----------------------------------+ |
| | (555) 123-4567                    | |
| +-----------------------------------+ |
|                                       |
| Email (read-only)                     |
| john@store.com                        |
|                                       |
| [Cancel]              [Save]          |
+---------------------------------------+
```

---

## 4. Data Requirements

### 4.1 Input Data

| Field | Type | Validation | Source |
|-------|------|------------|--------|
| `name` | String | Required, 2-100 chars | User input |
| `phone` | String | Optional, valid phone format | User input |
| `current_pin` | String | Required for PIN change, 4-6 digits | User input |
| `new_pin` | String | Required for PIN change, 4-6 digits | User input |
| `confirm_pin` | String | Must match new_pin | User input |

### 4.2 Output Data

| Field | Type | Description | Destination |
|-------|------|-------------|-------------|
| `user` | Object | Updated user profile | API |
| `preferences` | Object | Notification settings | API |
| `pin_hash` | String | Hashed new PIN | Database |

### 4.3 User Settings Structure

```typescript
interface UserSettings {
  notifications: {
    shipment_updates: { email: boolean, push: boolean },
    photo_reviews: { email: boolean, push: boolean },
    campaign_reminders: { email: boolean, push: boolean },
    issue_updates: { email: boolean, push: boolean }
  },
  display: {
    theme: 'light' | 'dark' | 'system'
  }
}
```

### 4.4 Data Model References

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `User` | name, email, phone, avatar_url | Read/Write |
| `Membership` | store_id, role | Read |
| `Store` | store_number, name | Read |
| `NotificationPreference` | type, email_enabled, push_enabled | Read/Write |

### 4.5 Data Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-DATA-001 | System SHALL display user's current store from Membership | Must |
| REQ-M007-DATA-002 | System SHALL persist notification preferences per user | Must |
| REQ-M007-DATA-003 | System SHALL hash PIN before storage | Must |
| REQ-M007-DATA-004 | System SHALL NOT store or transmit PIN in plaintext | Must |

---

## 5. Business Rules & Validation

### 5.1 Profile Edit Rules

| Rule ID | Rule | Implementation |
|---------|------|----------------|
| BR-M007-001 | Name is required | Validate non-empty, 2-100 chars |
| BR-M007-002 | Phone format validation | Accept common formats, store normalized |
| BR-M007-003 | Email is read-only | Display only, no edit capability |
| BR-M007-004 | Changes saved immediately | API call on modal save |

### 5.2 PIN Change Rules

| Rule ID | Rule | Validation |
|---------|------|------------|
| BR-M007-005 | PIN length | 4-6 digits |
| BR-M007-006 | Current PIN verification | Must match existing |
| BR-M007-007 | New PIN differs | Cannot match current |
| BR-M007-008 | Confirmation match | New and confirm must match |
| BR-M007-009 | PIN history | Cannot reuse last 3 PINs |

### 5.3 Notification Type Defaults

| Type | Description | Default |
|------|-------------|---------|
| Shipment Updates | Tracking status changes | Email + Push |
| Photo Reviews | Approval/rejection notifications | Push only |
| Campaign Reminders | Due date reminders | Email + Push |
| Issue Updates | Issue resolution status | Email only |

### 5.4 Security Rules

| Rule ID | Rule | Value |
|---------|------|-------|
| BR-M007-010 | Session timeout | 8 hours inactivity |
| BR-M007-011 | Token storage | Secure keychain/keystore |
| BR-M007-012 | PIN attempts | 5 max, then 15-min lockout |
| BR-M007-013 | Logout behavior | Clears all local data |

### 5.5 Validation Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-VAL-001 | System SHALL validate name is 2-100 characters | Must |
| REQ-M007-VAL-002 | System SHALL validate phone format if provided | Should |
| REQ-M007-VAL-003 | System SHALL verify current PIN before allowing change | Must |
| REQ-M007-VAL-004 | System SHALL prevent reuse of last 3 PINs | Should |
| REQ-M007-VAL-005 | System SHALL require new PIN differs from current | Must |

---

## 6. API Integration Points

### 6.1 Get User Profile

| Property | Value |
|----------|-------|
| **Endpoint** | `GET /api/v1/users/me` |
| **Auth Required** | Yes (Bearer token) |

#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "name": "John Doe",
  "email": "john@store.com",
  "phone": "(555) 123-4567",
  "avatar_url": "https://cdn.example.com/avatars/uuid.jpg",
  "memberships": [
    {
      "store_id": "uuid",
      "store_number": "STR-001",
      "store_name": "Acme Retail - Downtown",
      "role": "STORE_OPERATOR"
    }
  ],
  "notification_preferences": {
    "shipment_updates": { "email": true, "push": true },
    "photo_reviews": { "email": false, "push": true },
    "campaign_reminders": { "email": true, "push": true },
    "issue_updates": { "email": true, "push": false }
  }
}
```

### 6.2 Update User Profile

| Property | Value |
|----------|-------|
| **Endpoint** | `PATCH /api/v1/users/me` |
| **Auth Required** | Yes (Bearer token) |

#### Request Schema

```json
{
  "name": "John Doe Updated",
  "phone": "(555) 987-6543"
}
```

### 6.3 Update Notification Preferences

| Property | Value |
|----------|-------|
| **Endpoint** | `PATCH /api/v1/users/me/preferences` |
| **Auth Required** | Yes (Bearer token) |

#### Request Schema

```json
{
  "notification_type": "photo_reviews",
  "email_enabled": true,
  "push_enabled": true
}
```

### 6.4 Verify Current PIN

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/auth/verify-pin` |
| **Auth Required** | Yes (Bearer token) |

#### Request Schema

```json
{
  "pin": "1234"
}
```

### 6.5 Change PIN

| Property | Value |
|----------|-------|
| **Endpoint** | `PATCH /api/v1/users/me/pin` |
| **Auth Required** | Yes (Bearer token) |

#### Request Schema

```json
{
  "current_pin": "1234",
  "new_pin": "5678"
}
```

### 6.6 Logout

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/auth/logout` |
| **Auth Required** | Yes (Bearer token) |

### 6.7 API Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-API-001 | System SHALL use PATCH for partial profile updates | Must |
| REQ-M007-API-002 | System SHALL verify current PIN before accepting new | Must |
| REQ-M007-API-003 | System SHALL invalidate all tokens on logout | Must |
| REQ-M007-API-004 | System SHALL save notification preferences immediately | Must |

---

## 7. State Transitions

### 7.1 Profile Edit State Machine

```
[VIEWING] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                       â”‚
   â”‚ Tap edit button       â”‚
   â–¼                       â”‚
[EDITING]                  â”‚
   â”‚         â”‚             â”‚
   â”‚ Cancel  â”‚ Save        â”‚
   â–¼         â–¼             â”‚
[VIEWING] [SAVING]         â”‚
             â”‚             â”‚
             â”‚ Success     â”‚
             â–¼             â”‚
         [VIEWING] â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 7.2 PIN Change State Machine

```
[PROFILE] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                       â”‚
   â”‚ Tap Change PIN        â”‚
   â–¼                       â”‚
[ENTER_CURRENT] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
   â”‚                       â”‚ Invalid
   â”‚ Valid                 â–¼
   â–¼                   [ERROR]
[ENTER_NEW]                â”‚
   â”‚                       â”‚
   â”‚ Enter new PIN         â”‚
   â–¼                       â”‚
[CONFIRM_NEW]              â”‚
   â”‚                       â”‚
   â”‚ Match                 â”‚ Mismatch
   â–¼                       â–¼
[SAVING]               [ERROR]
   â”‚
   â”‚ Success
   â–¼
[SUCCESS] â”€â”€â”€â”€â”€â”€â”€â”€ Return to Profile
```

### 7.3 Logout State Machine

```
[PROFILE] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
   â”‚                       â”‚
   â”‚ Tap Logout            â”‚
   â–¼                       â”‚
[CONFIRM_DIALOG]           â”‚
   â”‚         â”‚             â”‚
   â”‚ Cancel  â”‚ Confirm     â”‚
   â–¼         â–¼             â”‚
[PROFILE] [LOGGING_OUT]    â”‚
             â”‚             â”‚
             â”‚ Clear data  â”‚
             â–¼             â”‚
         [LOGIN_SCREEN] â”€â”€â”€â”˜
```

### 7.4 State Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-STATE-001 | System SHALL preserve edit modal state on validation error | Must |
| REQ-M007-STATE-002 | System SHALL clear all local data on logout | Must |
| REQ-M007-STATE-003 | System SHALL navigate to Login screen after logout | Must |
| REQ-M007-STATE-004 | System SHALL show success feedback after PIN change | Must |

---

## 8. Error Handling

### 8.1 Error Categories

| Category | Handling Approach |
|----------|-------------------|
| Validation Errors | Inline field errors |
| PIN Verification Failure | Display error, allow retry |
| Network Errors | Retry with offline indicator |
| Session Expired | Redirect to login |

### 8.2 Error Messages

| Error Code | User Message | Technical Action |
|------------|--------------|------------------|
| `INVALID_NAME` | "Name must be 2-100 characters." | Highlight field |
| `INVALID_PHONE` | "Please enter a valid phone number." | Highlight field |
| `WRONG_PIN` | "Current PIN is incorrect." | Clear field, focus |
| `PIN_TOO_SHORT` | "PIN must be 4-6 digits." | Highlight field |
| `PIN_MISMATCH` | "PINs do not match." | Clear confirm field |
| `PIN_REUSED` | "Cannot reuse recent PINs." | Clear new PIN field |
| `NETWORK_ERROR` | "Unable to save. Check your connection." | Retry button |
| `SESSION_EXPIRED` | "Session expired. Please log in again." | Redirect to login |

### 8.3 PIN Change Error States

| State | Error Display |
|-------|---------------|
| Wrong current PIN | "Current PIN is incorrect. {X} attempts remaining." |
| PIN too short | "PIN must be 4-6 digits." |
| PIN same as current | "New PIN must be different from current." |
| Confirmation mismatch | "PINs do not match." |
| PIN in history | "Cannot reuse your last 3 PINs." |

### 8.4 Error Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M007-ERR-001 | System SHALL display validation errors inline | Must |
| REQ-M007-ERR-002 | System SHALL show remaining PIN attempts on failure | Should |
| REQ-M007-ERR-003 | System SHALL handle session expiry gracefully | Must |
| REQ-M007-ERR-004 | System SHALL preserve form data on network error | Should |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Req ID | Requirement | WCAG Criterion | Priority |
|--------|-------------|----------------|----------|
| REQ-M007-A11Y-001 | Form fields SHALL have associated labels | 1.3.1 Info and Relationships | Must |
| REQ-M007-A11Y-002 | Toggle switches SHALL announce state changes | 4.1.3 Status Messages | Must |
| REQ-M007-A11Y-003 | Error messages SHALL be announced by screen readers | 4.1.3 Status Messages | Must |
| REQ-M007-A11Y-004 | Touch targets SHALL be minimum 44x44 pixels | 2.5.5 Target Size | Must |
| REQ-M007-A11Y-005 | Color SHALL NOT be sole indicator of toggle state | 1.4.1 Use of Color | Must |

### 9.2 Assistive Technology Support

| Feature | Implementation |
|---------|----------------|
| Screen Reader | ARIA labels on all controls, live regions for updates |
| Voice Control | Named buttons and inputs |
| Large Text | Responsive font scaling up to 200% |
| High Contrast | Respects system high contrast mode |

### 9.3 ARIA Implementation

```html
<main role="main" aria-labelledby="profile-heading">
  <h1 id="profile-heading">Profile</h1>

  <section aria-labelledby="user-info-heading">
    <h2 id="user-info-heading">User Information</h2>
    <dl>
      <dt>Name</dt>
      <dd>John Doe</dd>
      <dt>Email</dt>
      <dd>john@store.com</dd>
    </dl>
    <button aria-label="Edit profile">Edit</button>
  </section>

  <section aria-labelledby="notifications-heading">
    <h2 id="notifications-heading">Notifications</h2>
    <div role="group" aria-labelledby="shipment-label">
      <span id="shipment-label">Shipment Updates</span>
      <label>
        Email
        <input type="checkbox" role="switch" aria-checked="true" />
      </label>
      <label>
        Push
        <input type="checkbox" role="switch" aria-checked="true" />
      </label>
    </div>
  </section>

  <button aria-label="Log out of application">Logout</button>
</main>
```

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| AC ID | Criterion | Verification Method |
|-------|-----------|---------------------|
| AC-M007-001 | Profile displays user name, email, phone | Manual test |
| AC-M007-002 | Store information shown (number and name) | Manual test |
| AC-M007-003 | Edit modal allows name/phone updates | Manual test |
| AC-M007-004 | Email is read-only (cannot be changed) | Manual test |
| AC-M007-005 | Notification toggles save immediately | API integration test |
| AC-M007-006 | PIN change requires current PIN verification | E2E test |
| AC-M007-007 | Logout clears session and navigates to login | E2E test |
| AC-M007-008 | App version displayed for support reference | Manual test |

### 10.2 Non-Functional Acceptance

| AC ID | Criterion | Target | Verification |
|-------|-----------|--------|--------------|
| AC-M007-NF-001 | Profile load time | < 1 second | Performance test |
| AC-M007-NF-002 | Preference save time | < 500ms | Performance test |
| AC-M007-NF-003 | PIN change completion | < 2 seconds | Performance test |
| AC-M007-NF-004 | Accessibility score | 100% WCAG 2.1 AA | axe-core audit |

### 10.3 Security Acceptance

| AC ID | Criterion | Verification |
|-------|-----------|--------------|
| AC-M007-SEC-001 | PIN never logged or stored in plaintext | Code review |
| AC-M007-SEC-002 | Tokens cleared from secure storage on logout | Security audit |
| AC-M007-SEC-003 | PIN rate limiting enforced | Penetration test |
| AC-M007-SEC-004 | Session invalidated on logout | API test |

---

## 11. Traceability Matrix

| Requirement | Source | Test Case |
|-------------|--------|-----------|
| REQ-M007-ROLE-001 | SUPP-036 | TC-M007-001 |
| REQ-M007-UI-003 | SUPP-036 | TC-M007-002 |
| REQ-M007-VAL-003 | Security Policy | TC-M007-003 |
| REQ-M007-API-003 | Security Policy | TC-M007-004 |
| REQ-M007-A11Y-001 | WCAG 2.1 | TC-M007-005 |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.7 - User Interface Requirements*
