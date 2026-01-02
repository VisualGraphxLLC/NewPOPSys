# S004 Team Management - Screen Specification

> **SRS Section**: 5.9.4 | **Module**: Store Portal | **Version**: 1.0
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **Source Documents**:
> - [S04 Team Management Screen Spec](../../../../06_Screen_Specs/S04_Team_Management.md)
> - [SUPP-001 Personas](../../../../02_SUPPs/Shared_Foundations/SUPP-001_Personas.md)
> - [SUPP-003 RBAC](../../../../02_SUPPs/Shared_Foundations/SUPP-003_RBAC.md)
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Team Management screen enables Store Managers to administer their store's team members, including inviting new users, managing roles, tracking activity metrics, and removing access. This screen is restricted to Store Manager role only.

### 1.2 Route Configuration

| Attribute | Value |
|-----------|-------|
| **Route Path** | `/store/team` |
| **Route Type** | Protected (Authentication Required) |
| **Role Restriction** | STORE_MANAGER only |
| **Lazy Loading** | Yes |
| **Mobile Support** | Full Responsive |

### 1.3 Screen Context

| Attribute | Description |
|-----------|-------------|
| **Primary Purpose** | Manage store team membership and permissions |
| **Entry Points** | Store Dashboard navigation, Dashboard team widget |
| **Exit Points** | Dashboard, Reports |
| **Session Scope** | Store context from authenticated membership |

### 1.4 Screenshot Reference

![Team Management Screen](../../screenshots/Store_Portal/store_portal_team.png)

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Restrictions |
|------|--------------|--------------|
| STORE_MANAGER (P07) | Full Access | Own store team only |
| STORE_OPERATOR (P08) | No Access | Screen not visible |

### 2.2 Permission Requirements

| Permission | STORE_MANAGER | STORE_OPERATOR |
|------------|:-------------:|:--------------:|
| View team list | Y | N |
| Invite team members | Y | N |
| Edit member role | Y | N |
| Deactivate members | Y | N |
| Remove members | Y | N |
| View activity metrics | Y | N |
| Resend invitations | Y | N |
| Cancel invitations | Y | N |

### 2.3 Data Scoping Rules

| Rule ID | Description |
|---------|-------------|
| REQ-S004-SEC-001 | Team members filtered to authenticated user's store via memberships.store_id |
| REQ-S004-SEC-002 | Store Manager role validated before screen access |
| REQ-S004-SEC-003 | Cross-store membership modification prevented at API layer |
| REQ-S004-SEC-004 | Self-removal prevented to maintain store manager continuity |

---

## 3. UI Components

### 3.1 Component Hierarchy

```
TeamManagementPage
â”œâ”€â”€ PageHeader
â”‚   â”œâ”€â”€ TitleSection ("Team Management")
â”‚   â””â”€â”€ InviteMemberButton
â”œâ”€â”€ ActiveMembersSection
â”‚   â”œâ”€â”€ SectionHeader ("Active Members ({count})")
â”‚   â””â”€â”€ MemberTable
â”‚       â””â”€â”€ MemberRow[] (repeating)
â”‚           â”œâ”€â”€ AvatarWithName
â”‚           â”œâ”€â”€ EmailAddress
â”‚           â”œâ”€â”€ RoleBadge
â”‚           â”œâ”€â”€ StatusBadge
â”‚           â”œâ”€â”€ LastActiveDate
â”‚           â””â”€â”€ ActionMenu
â”œâ”€â”€ PendingInvitationsSection
â”‚   â”œâ”€â”€ SectionHeader ("Pending Invitations ({count})")
â”‚   â””â”€â”€ InvitationTable
â”‚       â””â”€â”€ InvitationRow[] (repeating)
â”‚           â”œâ”€â”€ EmailAddress
â”‚           â”œâ”€â”€ RoleBadge
â”‚           â”œâ”€â”€ InvitedDate
â”‚           â”œâ”€â”€ ExpiresDate
â”‚           â””â”€â”€ ActionButtons (Resend, Cancel)
â”œâ”€â”€ ActivitySummarySection
â”‚   â”œâ”€â”€ SectionHeader ("Team Activity (Last 30 Days)")
â”‚   â””â”€â”€ ActivityTable
â”‚       â””â”€â”€ ActivityRow[] (repeating)
â”œâ”€â”€ InviteMemberModal
â”‚   â”œâ”€â”€ EmailInput
â”‚   â”œâ”€â”€ RoleSelector
â”‚   â”œâ”€â”€ PersonalMessageInput
â”‚   â””â”€â”€ ActionButtons (Cancel, Send Invitation)
â””â”€â”€ EditMemberModal
    â”œâ”€â”€ MemberInfo
    â”œâ”€â”€ RoleDropdown
    â”œâ”€â”€ StatusToggle
    â”œâ”€â”€ ActivitySummary
    â”œâ”€â”€ RemoveButton
    â””â”€â”€ ActionButtons (Cancel, Save)
```

### 3.2 Component Specifications

| Component | Type | Description | Requirements |
|-----------|------|-------------|--------------|
| PageHeader | Container | Title and invite button | REQ-S004-UI-001 |
| MemberTable | Data Table | Active team members | REQ-S004-UI-002 |
| InvitationTable | Data Table | Pending invitations | REQ-S004-UI-003 |
| ActivityTable | Data Table | 30-day activity metrics | REQ-S004-UI-004 |
| InviteMemberModal | Modal Dialog | New member invitation form | REQ-S004-UI-005 |
| EditMemberModal | Modal Dialog | Member role/status editor | REQ-S004-UI-006 |
| RoleBadge | Badge | Manager/User role indicator | REQ-S004-UI-007 |
| StatusBadge | Badge | Active/Invited/Inactive status | REQ-S004-UI-008 |

### 3.3 Role Badge Specifications

| Role | Label | Color |
|------|-------|-------|
| STORE_MANAGER | "Manager" | `blue-100` / `blue-800` |
| STORE_OPERATOR | "User" | `gray-100` / `gray-700` |

### 3.4 Status Badge Specifications

| Status | Label | Color | Description |
|--------|-------|-------|-------------|
| Active | "Active" | `green-100` / `green-800` | Registered and active |
| Invited | "Invited" | `amber-100` / `amber-800` | Pending registration |
| Inactive | "Inactive" | `gray-100` / `gray-600` | Deactivated by manager |

---

## 4. Data Requirements

### 4.1 API Endpoints

| Endpoint | Method | Purpose | Authorization |
|----------|--------|---------|---------------|
| `/stores/{storeId}/members` | GET | List team members | STORE_MANAGER |
| `/stores/{storeId}/invitations` | GET | List pending invitations | STORE_MANAGER |
| `/stores/{storeId}/invitations` | POST | Create invitation | STORE_MANAGER |
| `/stores/{storeId}/invitations/{id}/resend` | POST | Resend invitation email | STORE_MANAGER |
| `/stores/{storeId}/invitations/{id}` | DELETE | Cancel invitation | STORE_MANAGER |
| `/memberships/{id}` | PATCH | Update member role/status | STORE_MANAGER |
| `/memberships/{id}` | DELETE | Remove member from store | STORE_MANAGER |
| `/stores/{storeId}/activity` | GET | Team activity summary | STORE_MANAGER |

### 4.2 Request/Response Schemas

**GET /stores/{storeId}/members Response**

```typescript
interface TeamMembersResponse {
  members: TeamMemberDTO[];
  meta: {
    total: number;
    managerCount: number;
    operatorCount: number;
  };
}

interface TeamMemberDTO {
  id: string;                    // Membership ID
  user_id: string;               // User ID
  name: string;                  // User full name
  email: string;                 // User email
  phone?: string;                // User phone
  avatar_url?: string;           // Profile picture URL
  role: 'STORE_MANAGER' | 'STORE_OPERATOR';
  status: 'active' | 'inactive';
  joined_at: string;             // ISO 8601
  last_active_at?: string;       // ISO 8601
  photo_count: number;           // Total photos uploaded
  is_current_user: boolean;      // Flag for self
}
```

**GET /stores/{storeId}/invitations Response**

```typescript
interface InvitationsResponse {
  invitations: InvitationDTO[];
}

interface InvitationDTO {
  id: string;                    // Invitation ID
  email: string;                 // Invited email
  role: 'STORE_MANAGER' | 'STORE_OPERATOR';
  invited_at: string;            // ISO 8601
  expires_at: string;            // ISO 8601
  invited_by: string;            // Inviter user name
  status: 'pending' | 'expired';
}
```

**POST /stores/{storeId}/invitations Request**

```typescript
interface CreateInvitationRequest {
  email: string;                 // Required
  role: 'STORE_MANAGER' | 'STORE_OPERATOR';  // Required
  message?: string;              // Optional personal message
}
```

**GET /stores/{storeId}/activity Response**

```typescript
interface TeamActivityResponse {
  activity: TeamMemberActivityDTO[];
  period: {
    from: string;               // ISO 8601
    to: string;                 // ISO 8601
    days: number;               // Default 30
  };
}

interface TeamMemberActivityDTO {
  user_id: string;
  user_name: string;
  photos: number;               // Photos uploaded
  receipts: number;             // Receipt surveys completed
  installs: number;             // Install surveys completed
  issues: number;               // Issues reported
}
```

### 4.3 Database Query - Team Members

```sql
SELECT
  m.id as membership_id,
  u.id as user_id,
  u.name,
  u.email,
  u.phone,
  u.avatar_url,
  m.role,
  CASE WHEN u.is_active THEN 'active' ELSE 'inactive' END as status,
  m.created_at as joined_at,
  u.last_active_at,
  COUNT(pu.id) as photo_count
FROM memberships m
JOIN users u ON m.user_id = u.id
LEFT JOIN photo_uploads pu ON pu.uploaded_by = u.id
WHERE m.store_id = :storeId
  AND m.deleted_at IS NULL
  AND u.deleted_at IS NULL
GROUP BY m.id, u.id
ORDER BY
  CASE m.role WHEN 'STORE_MANAGER' THEN 0 ELSE 1 END,
  u.name
```

### 4.4 Database Query - Team Activity

```sql
WITH activity_period AS (
  SELECT
    CURRENT_DATE - INTERVAL '30 days' as start_date,
    CURRENT_DATE as end_date
)
SELECT
  u.id as user_id,
  u.name as user_name,
  COUNT(DISTINCT pu.id) as photos,
  COUNT(DISTINCT CASE WHEN ssr.survey_type = 'receipt' THEN ssr.id END) as receipts,
  COUNT(DISTINCT CASE WHEN ssr.survey_type = 'install' THEN ssr.id END) as installs,
  COUNT(DISTINCT ir.id) as issues
FROM memberships m
JOIN users u ON m.user_id = u.id
CROSS JOIN activity_period ap
LEFT JOIN photo_uploads pu ON pu.uploaded_by = u.id
  AND pu.created_at BETWEEN ap.start_date AND ap.end_date
LEFT JOIN store_survey_responses ssr ON ssr.submitted_by = u.id
  AND ssr.submitted_at BETWEEN ap.start_date AND ap.end_date
LEFT JOIN issue_requests ir ON ir.reported_by = u.id
  AND ir.created_at BETWEEN ap.start_date AND ap.end_date
WHERE m.store_id = :storeId
  AND m.deleted_at IS NULL
GROUP BY u.id, u.name
ORDER BY u.name
```

---

## 5. Business Rules & Validation

### 5.1 Invitation Rules

| Rule ID | Rule Description |
|---------|------------------|
| REQ-S004-BR-001 | Email must be valid format and not already a member of this store |
| REQ-S004-BR-002 | Email must not have pending invitation for this store |
| REQ-S004-BR-003 | Invitations expire after 7 days |
| REQ-S004-BR-004 | Maximum 5 pending invitations per store at a time |
| REQ-S004-BR-005 | Resend resets expiration date to 7 days from now |
| REQ-S004-BR-006 | Personal message limited to 500 characters |

### 5.2 Role Management Rules

| Rule ID | Rule Description |
|---------|------------------|
| REQ-S004-BR-007 | Store must always have at least one active STORE_MANAGER |
| REQ-S004-BR-008 | Cannot demote last active manager to STORE_OPERATOR |
| REQ-S004-BR-009 | Cannot deactivate or remove last active manager |
| REQ-S004-BR-010 | Cannot remove self (current user) from store |
| REQ-S004-BR-011 | Role changes take effect immediately |

### 5.3 Status Management Rules

| Rule ID | Rule Description |
|---------|------------------|
| REQ-S004-BR-012 | Deactivating user revokes API access immediately |
| REQ-S004-BR-013 | Deactivated users retain data but cannot log in |
| REQ-S004-BR-014 | Reactivation restores all previous permissions |
| REQ-S004-BR-015 | Removed users are soft-deleted from membership |

### 5.4 Activity Calculation Rules

| Rule ID | Rule Description |
|---------|------------------|
| REQ-S004-BR-016 | Activity period is rolling 30 days from current date |
| REQ-S004-BR-017 | Photo count includes all statuses (pending, approved, rejected) |
| REQ-S004-BR-018 | Survey counts based on submitted_at timestamp |
| REQ-S004-BR-019 | Issue count includes all issue statuses |

---

## 6. API Integration Points

### 6.1 Load Team Data Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_0](../../diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_0.png)

### 6.2 Invite Member Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_1](../../diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_1.png)

### 6.3 Edit Member Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_2](../../diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_2.png)

### 6.4 Remove Member Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_3](../../diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_3.png)

### 6.5 Integration Dependencies

| System | Integration | Purpose |
|--------|-------------|---------|
| Email Service | SMTP/SendGrid | Invitation delivery |
| Auth Service | JWT Validation | Permission verification |
| Audit Service | Event logging | Track team changes |

---

## 7. State Transitions

### 7.1 Invitation Status States

```
     â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
     â”‚ PENDING  â”‚
     â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜
          â”‚
    â”Œâ”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”
    â–¼           â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ACCEPTEDâ”‚  â”‚ EXPIRED â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
    â”‚
    â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ MEMBERSHIP  â”‚
â”‚  CREATED    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 7.2 Member Status States

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  ACTIVE  â”‚â—„â”€â”€â”€â”€â”€â–ºâ”‚ INACTIVE â”‚
â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
     â”‚
     â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ REMOVED  â”‚
â”‚(soft del)â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 7.3 State Transition Actions

| From | To | Action | Actor |
|------|-----|--------|-------|
| - | PENDING | Create invitation | Store Manager |
| PENDING | ACCEPTED | User accepts invite | Invited User |
| PENDING | EXPIRED | Time passes 7 days | System |
| PENDING | CANCELLED | Cancel invitation | Store Manager |
| ACTIVE | INACTIVE | Deactivate member | Store Manager |
| INACTIVE | ACTIVE | Reactivate member | Store Manager |
| ACTIVE/INACTIVE | REMOVED | Remove member | Store Manager |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error Code | Scenario | User Message | Recovery Action |
|------------|----------|--------------|-----------------|
| ERR-S004-001 | Team API failure | "Unable to load team members. Please try again." | Retry button |
| ERR-S004-002 | Email already member | "This email is already a member of your store." | Clear email field |
| ERR-S004-003 | Email has pending invite | "An invitation has already been sent to this email." | Offer resend |
| ERR-S004-004 | Invalid email format | "Please enter a valid email address." | Inline validation |
| ERR-S004-005 | Last manager removal | "Cannot remove the last manager. Promote another member first." | Dismiss dialog |
| ERR-S004-006 | Self-removal attempt | "You cannot remove yourself from the store." | Dismiss dialog |
| ERR-S004-007 | Invitation send failed | "Unable to send invitation. Please try again." | Retry button |
| ERR-S004-008 | Invitation limit reached | "Maximum pending invitations reached. Cancel existing invites first." | Show pending list |
| ERR-S004-009 | Role update failed | "Unable to update role. Please try again." | Retry button |
| ERR-S004-010 | Member not found | "Team member no longer exists." | Refresh table |

### 8.2 Validation Messages

| Field | Validation | Message |
|-------|------------|---------|
| Email | Required | "Email address is required" |
| Email | Format | "Please enter a valid email address" |
| Email | Duplicate | "This email is already on your team" |
| Role | Required | "Please select a role" |
| Message | Max length | "Message cannot exceed 500 characters" |

### 8.3 Loading States

| State | Display |
|-------|---------|
| Initial load | Skeleton table with 5 rows |
| Invite submitting | "Sending invitation..." with spinner |
| Role updating | Inline spinner on affected row |
| Member removing | Confirmation dialog with spinner |

### 8.4 Empty States

| Condition | Message | Action |
|-----------|---------|--------|
| No team members (impossible) | N/A | Current user always shown |
| No pending invitations | "No pending invitations" | Invite button |
| No activity in 30 days | "No activity recorded in the last 30 days" | None |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Requirement ID | Requirement | Implementation |
|----------------|-------------|----------------|
| REQ-S004-A11Y-001 | Keyboard navigation | Full table navigation with Tab/Arrow keys |
| REQ-S004-A11Y-002 | Focus management | Modal focus trap, return focus on close |
| REQ-S004-A11Y-003 | Screen reader support | ARIA labels, role announcements |
| REQ-S004-A11Y-004 | Form accessibility | Associated labels, error announcements |
| REQ-S004-A11Y-005 | Confirmation dialogs | Focus on primary action, Escape to close |
| REQ-S004-A11Y-006 | Status announcements | Live region for success/error toasts |

### 9.2 Keyboard Shortcuts

| Key | Action | Context |
|-----|--------|---------|
| `Tab` | Move focus between elements | Page |
| `Enter` | Open edit modal | Table row focus |
| `Escape` | Close modal | Modal open |
| `Delete` | Open remove confirmation | Table row focus |

### 9.3 Screen Reader Announcements

| Trigger | Announcement |
|---------|--------------|
| Page load | "Team Management. {count} active members, {count} pending invitations." |
| Invite success | "Invitation sent to {email}." |
| Role updated | "{name} role changed to {role}." |
| Member removed | "{name} has been removed from the team." |
| Error | Error message content |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| ID | Requirement | Priority | Verification |
|----|-------------|----------|--------------|
| REQ-S004-FR-001 | Screen restricted to STORE_MANAGER role | Must | Test |
| REQ-S004-FR-002 | Team list displays all active members with roles | Must | Test |
| REQ-S004-FR-003 | Pending invitations displayed in separate section | Must | Test |
| REQ-S004-FR-004 | Invite modal captures email and role selection | Must | Test |
| REQ-S004-FR-005 | Invitation email sent upon invite creation | Must | Test |
| REQ-S004-FR-006 | Manager can change member role | Must | Test |
| REQ-S004-FR-007 | Manager can deactivate member | Must | Test |
| REQ-S004-FR-008 | Manager can remove member from store | Must | Test |
| REQ-S004-FR-009 | Cannot remove last active manager | Must | Test |
| REQ-S004-FR-010 | Cannot remove self from store | Must | Test |
| REQ-S004-FR-011 | Activity summary shows 30-day metrics | Should | Test |
| REQ-S004-FR-012 | Resend option for pending invitations | Should | Test |
| REQ-S004-FR-013 | Cancel option for pending invitations | Should | Test |
| REQ-S004-FR-014 | Last active date shown for each member | Should | Test |

### 10.2 Non-Functional Requirements

| ID | Requirement | Target | Verification |
|----|-------------|--------|--------------|
| REQ-S004-NFR-001 | Page load < 2 seconds | P95 | Performance test |
| REQ-S004-NFR-002 | Invite creation < 3 seconds | P95 | Performance test |
| REQ-S004-NFR-003 | Role update < 1 second | P95 | Performance test |
| REQ-S004-NFR-004 | Support teams up to 50 members | Required | Load test |
| REQ-S004-NFR-005 | Email delivery within 5 minutes | P95 | Integration test |

### 10.3 Security Requirements

| ID | Requirement | Verification |
|----|-------------|--------------|
| REQ-S004-SEC-001 | Only STORE_MANAGER can access screen | Authorization test |
| REQ-S004-SEC-002 | Cross-store member manipulation prevented | Security test |
| REQ-S004-SEC-003 | All team changes logged to audit trail | Audit test |
| REQ-S004-SEC-004 | Email invitation tokens expire after 7 days | Configuration test |
| REQ-S004-SEC-005 | Invitation tokens are single-use | Security test |

---

## 11. Traceability Matrix

| Requirement | Source | SUPP Reference | Test Case |
|-------------|--------|----------------|-----------|
| REQ-S004-FR-001 | S04 Screen Spec | SUPP-003 | TC-S004-001 |
| REQ-S004-FR-002 | S04 Screen Spec | SUPP-001 | TC-S004-002 |
| REQ-S004-FR-005 | S04 Screen Spec | SUPP-003 | TC-S004-005 |
| REQ-S004-FR-009 | S04 Screen Spec | SUPP-003 | TC-S004-009 |
| REQ-S004-SEC-001 | Permission Matrix | SUPP-003 | TC-S004-SEC-001 |

---

## 12. Related Screens

| Screen | Relationship | Navigation |
|--------|--------------|------------|
| [S001 Dashboard](S001_Dashboard.md) | Parent | Team widget shows summary |
| [S005 Reports](S005_Reports.md) | Sibling | Detailed team analytics |
| [M07 Profile](../../../10_Module_MobileApp/screens/M007_Profile.md) | Related | User self-service |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Specific Requirements / Functional Requirements*
