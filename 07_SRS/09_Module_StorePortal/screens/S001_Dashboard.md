# S001 - Store Dashboard Screen Specification

> **Module**: StorePortal
> **Screen ID**: S001
> **Route**: `/store/dashboard`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

---

## 1. Screen Overview

### 1.1 Purpose

The Store Dashboard serves as the primary landing page for store personnel, providing a consolidated view of campaign status, pending actions, and key performance metrics. It enables store managers and operators to quickly assess their workload and navigate to priority tasks.

### 1.2 Screenshot Reference

![Store Portal Dashboard](../../screenshots/Store_Portal/store_portal_dashboard.png)

### 1.3 Source References

| Document | Section |
|----------|---------|
| SUPP-001 | Persona Workflows - Store Level |
| Screen Spec | SOW/06_Screen_Specs/S01_Dashboard.md |
| Database Model | Section 3.1 - Store & Assignment Tables |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Persona ID |
|------|--------------|------------|
| STORE_MANAGER | Full Access | P07 |
| STORE_OPERATOR | Limited Access | P08 |

### 2.2 Role-Based Display Rules

| Feature | STORE_MANAGER | STORE_OPERATOR |
|---------|---------------|----------------|
| View all store campaigns | Yes | Yes (assigned only) |
| View team activity section | Yes | No |
| Access team management link | Yes | No |
| View store reports link | Yes | No |
| View compliance rate KPI | Yes | No |
| Execute campaign tasks | Yes | Yes |

### 2.3 Permission Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-SEC-001 | User must have active membership with store to access dashboard | Must |
| REQ-S001-SEC-002 | Dashboard data scoped to user's assigned store only | Must |
| REQ-S001-SEC-003 | STORE_OPERATOR sees only their own pending actions | Must |
| REQ-S001-SEC-004 | STORE_MANAGER sees all team members' pending actions | Must |

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Component Name | Type | Description |
|--------------|----------------|------|-------------|
| S001-C001 | Page Header | Header | "Dashboard" title with store name |
| S001-C002 | KPI Cards Row | Card Grid | 4 key performance indicator cards |
| S001-C003 | Active Campaigns List | Data List | Expandable campaign entries |
| S001-C004 | Pending Actions Panel | Action List | Priority-sorted task list |
| S001-C005 | Recent Activity Feed | Timeline | Chronological activity stream |
| S001-C006 | Team Status Card | Summary Card | Team member overview (Manager only) |
| S001-C007 | Quick Actions Bar | Button Group | Primary navigation shortcuts |

### 3.2 KPI Cards Specification

| Card ID | Metric | Calculation | Visual |
|---------|--------|-------------|--------|
| KPI-001 | Active Campaigns | COUNT(assignments WHERE status NOT IN ['COMPLETE', 'WAIVED']) | Number badge |
| KPI-002 | Pending Actions | COUNT(actions WHERE status = 'PENDING') | Number with urgency color |
| KPI-003 | Completed This Month | COUNT(assignments WHERE completed_at >= first_of_month) | Number with trend arrow |
| KPI-004 | Compliance Rate | (on_time_completions / total_completions) * 100 | Percentage gauge |

### 3.3 Layout Structure


![Store Dashboard](../../screenshots/Store_Portal/store_portal_dashboard.png)


### 3.4 Component Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-UI-001 | KPI cards must display loading skeleton during data fetch | Must |
| REQ-S001-UI-002 | Active campaigns list supports expand/collapse interaction | Must |
| REQ-S001-UI-003 | Pending actions sorted by urgency (due date ascending) | Must |
| REQ-S001-UI-004 | Recent activity shows last 10 events with relative timestamps | Should |
| REQ-S001-UI-005 | Team status card hidden for STORE_OPERATOR role | Must |
| REQ-S001-UI-006 | Dashboard auto-refreshes every 5 minutes | Should |

---

## 4. Data Requirements

### 4.1 Entity Dependencies

| Entity | Table Name | Fields Required | Relationship |
|--------|------------|-----------------|--------------|
| Store | stores | id, name, external_store_guid, status | Primary |
| StoreAssignment | store_assignments | id, campaign_id, store_id, status, pinned_layout_id | Many-to-One |
| Campaign | campaigns | id, name, install_start, install_end, status | Via Assignment |
| PhotoUpload | photo_uploads | id, assignment_item_id, review_status, created_at | Via Assignment |
| IssueRequest | issue_requests | id, store_assignment_id, status, created_at | Via Assignment |
| User | users | id, name, email, is_active | Via Membership |
| Membership | memberships | user_id, store_id, role | Join Table |

### 4.2 Data Query Specification


![Store Dashboard](../../screenshots/Store_Portal/store_portal_dashboard.png)


### 4.3 Data Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-DATA-001 | All queries must filter by tenant_id from JWT | Must |
| REQ-S001-DATA-002 | Soft-deleted records excluded from all counts | Must |
| REQ-S001-DATA-003 | Campaign dates displayed in store's local timezone | Must |
| REQ-S001-DATA-004 | Activity feed limited to last 30 days | Should |

---

## 5. Business Rules & Validation

### 5.1 Display Rules

| Rule ID | Rule Description | Condition | Action |
|---------|------------------|-----------|--------|
| BR-S001-001 | Urgent action highlighting | Due date <= today | Display red badge |
| BR-S001-002 | Campaign phase badge | Based on StorePhase enum | Show appropriate status color |
| BR-S001-003 | Compliance rate threshold | Rate < 75% | Display warning indicator |
| BR-S001-004 | Empty state handling | No active campaigns | Show "No active campaigns" message |

### 5.2 StorePhase Display Mapping

| StorePhase | Display Label | Badge Color |
|------------|---------------|-------------|
| AWAITING_SHIPMENT | Awaiting Shipment | Gray |
| SHIPMENT_IN_TRANSIT | In Transit | Blue |
| READY_TO_RECEIVE | Ready to Receive | Yellow |
| RECEIVING | Receiving | Yellow |
| READY_TO_INSTALL | Ready to Install | Orange |
| INSTALLING | Installing | Orange |
| PENDING_REVIEW | Pending Review | Purple |
| COMPLETE | Complete | Green |
| NEEDS_ATTENTION | Needs Attention | Red |
| WAIVED | Waived | Gray |

### 5.3 Business Rule Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-BR-001 | Campaigns sorted by install_end date (earliest first) | Must |
| REQ-S001-BR-002 | NEEDS_ATTENTION status triggers visual alert | Must |
| REQ-S001-BR-003 | Pending actions derive from incomplete workflow steps | Must |
| REQ-S001-BR-004 | Completed campaigns remain visible for 30 days post-completion | Should |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose | Response |
|----------|--------|---------|----------|
| `/api/stores/{storeId}/dashboard` | GET | Fetch dashboard aggregate data | DashboardDTO |
| `/api/stores/{storeId}/assignments` | GET | List active assignments | Assignment[] |
| `/api/stores/{storeId}/activity` | GET | Recent activity feed | ActivityEvent[] |

### 6.2 Request/Response Specifications

#### GET /api/stores/{storeId}/dashboard

**Request Headers:**
```
Authorization: Bearer {jwt_token}
X-Tenant-ID: {tenant_uuid}
```

**Response Schema:**
```json
{
  "store": {
    "id": "uuid",
    "name": "string",
    "externalGuid": "string"
  },
  "metrics": {
    "activeCampaigns": "number",
    "pendingActions": "number",
    "completedThisMonth": "number",
    "complianceRate": "number"
  },
  "campaigns": [
    {
      "id": "uuid",
      "name": "string",
      "phase": "StorePhase",
      "installStart": "ISO8601",
      "installEnd": "ISO8601",
      "pendingTasks": ["string"]
    }
  ],
  "recentActivity": [
    {
      "id": "uuid",
      "type": "string",
      "actor": "string",
      "description": "string",
      "timestamp": "ISO8601"
    }
  ],
  "teamStatus": {
    "activeMembers": "number",
    "pendingInvitations": "number"
  }
}
```

### 6.3 API Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-API-001 | Dashboard endpoint returns within 500ms | Must |
| REQ-S001-API-002 | Response includes cache headers (max-age: 60) | Should |
| REQ-S001-API-003 | 404 returned if store not found or user lacks access | Must |
| REQ-S001-API-004 | teamStatus omitted from response for STORE_OPERATOR | Must |

---

## 7. State Transitions

### 7.1 Dashboard Load States

![Dashboard](../../screenshots/Store_Portal/store_portal_dashboard.png)

### 7.2 State Descriptions

| State | Description | UI Behavior |
|-------|-------------|-------------|
| INITIAL | Component mounted | Show loading skeleton |
| LOADING | API request in flight | Display skeleton, disable interactions |
| LOADED | Data successfully retrieved | Render dashboard components |
| ERROR | API request failed | Show error message with retry button |
| REFRESHING | Background data refresh | Subtle loading indicator, data remains visible |

### 7.3 State Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-STATE-001 | Loading state displays within 100ms of navigation | Must |
| REQ-S001-STATE-002 | Error state provides actionable retry option | Must |
| REQ-S001-STATE-003 | Refreshing state does not interrupt user interaction | Must |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error Code | Scenario | User Message | Recovery Action |
|------------|----------|--------------|-----------------|
| 401 | Unauthorized/expired token | "Session expired. Please log in again." | Redirect to login |
| 403 | No store access | "You don't have access to this store." | Redirect to store selector |
| 404 | Store not found | "Store not found." | Redirect to store selector |
| 500 | Server error | "Unable to load dashboard. Please try again." | Show retry button |
| NETWORK | Connection failed | "Connection lost. Check your internet." | Show retry with offline indicator |

### 8.2 Partial Load Handling

| Component | Failure Behavior |
|-----------|------------------|
| KPI Cards | Show "--" placeholder, log error |
| Campaign List | Show empty state with error message |
| Activity Feed | Show "Unable to load activity" |
| Team Status | Hide component, log error |

### 8.3 Error Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S001-ERR-001 | All API errors logged with correlation ID | Must |
| REQ-S001-ERR-002 | User-facing errors do not expose technical details | Must |
| REQ-S001-ERR-003 | Retry attempts use exponential backoff | Should |
| REQ-S001-ERR-004 | Partial failures do not block entire dashboard | Should |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Requirement ID | WCAG Criterion | Implementation |
|----------------|----------------|----------------|
| REQ-S001-A11Y-001 | 1.1.1 Non-text Content | Alt text for all status icons and badges |
| REQ-S001-A11Y-002 | 1.3.1 Info and Relationships | Semantic HTML structure with proper headings |
| REQ-S001-A11Y-003 | 1.4.3 Contrast | Minimum 4.5:1 contrast for all text |
| REQ-S001-A11Y-004 | 2.1.1 Keyboard | All interactive elements keyboard accessible |
| REQ-S001-A11Y-005 | 2.4.4 Link Purpose | Descriptive link text for all navigation |
| REQ-S001-A11Y-006 | 4.1.2 Name, Role, Value | ARIA labels for dynamic content regions |

### 9.2 Screen Reader Support

| Component | ARIA Implementation |
|-----------|---------------------|
| KPI Cards | role="status", aria-live="polite" for updates |
| Campaign List | role="list", aria-expanded for expandable items |
| Pending Actions | role="list", aria-describedby for urgency |
| Activity Feed | role="feed", aria-busy during refresh |

### 9.3 Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Move between interactive elements |
| Enter/Space | Activate focused element |
| Arrow Down | Expand campaign details |
| Arrow Up | Collapse campaign details |
| Escape | Close any open panels |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| Requirement ID | Description | Test Criteria | Priority |
|----------------|-------------|---------------|----------|
| REQ-S001-FR-001 | Dashboard displays 4 KPI cards | All 4 metrics visible with correct values | Must |
| REQ-S001-FR-002 | Active campaigns list shows current assignments | List matches database query results | Must |
| REQ-S001-FR-003 | Pending actions sorted by urgency | Earliest due date appears first | Must |
| REQ-S001-FR-004 | Campaign cards expand to show details | Click expands, shows tasks and dates | Must |
| REQ-S001-FR-005 | Recent activity shows last 10 events | Events display with relative timestamps | Should |
| REQ-S001-FR-006 | Team status visible to STORE_MANAGER only | Component hidden for STORE_OPERATOR | Must |
| REQ-S001-FR-007 | Dashboard auto-refreshes every 5 minutes | Data updates without page reload | Should |
| REQ-S001-FR-008 | Quick actions navigate to correct screens | Each action links to proper route | Must |
| REQ-S001-FR-009 | Campaign click navigates to campaign detail | Route: /store/campaigns/{id} | Must |
| REQ-S001-FR-010 | Empty state displayed when no campaigns | Message shown when list is empty | Must |

### 10.2 Non-Functional Requirements

| Requirement ID | Description | Metric | Priority |
|----------------|-------------|--------|----------|
| REQ-S001-NFR-001 | Page load time | < 2 seconds on 3G connection | Must |
| REQ-S001-NFR-002 | API response time | < 500ms for dashboard endpoint | Must |
| REQ-S001-NFR-003 | Mobile responsiveness | Renders correctly on 320px viewport | Must |
| REQ-S001-NFR-004 | Offline indicator | Displays when connection lost | Should |

### 10.3 Traceability Matrix

| Requirement | Source Document | Section |
|-------------|-----------------|---------|
| REQ-S001-FR-001 | S01_Dashboard.md | UI Components |
| REQ-S001-FR-002 | S01_Dashboard.md | Active Campaigns |
| REQ-S001-SEC-001 | SUPP-003 | Store Level Permissions |
| REQ-S001-DATA-001 | 3.1_Database_Model.md | Multi-Tenancy Model |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial SRS specification |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*
