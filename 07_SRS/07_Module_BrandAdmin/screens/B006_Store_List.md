# B006 - Store List

> **SRS Section**: 7.1.6 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Store List screen provides brand administrators with a comprehensive view of all stores within their brand. It enables store management, status monitoring, group assignments, and quick access to individual store details and campaign participation.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access (all stores) |
| CAMPAIGN_MANAGER | Read-only (stores in assigned campaigns) |
| REGIONAL_MANAGER | Full access (stores in assigned regions) |

### 1.3 Navigation Path

- **Route**: `/admin/stores`
- **Entry Points**:
  - Main navigation: "Stores" menu item
  - Dashboard: "Total Stores" KPI click-through
  - Campaign Detail: Store list link

### 1.4 Screenshot Reference

![Store List](../../screenshots/Admin_Portal/admin_portal_stores_tab.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| View all stores | Y | N | N |
| View scoped stores | Y | Y* | Y* |
| Search and filter stores | Y | Y* | Y* |
| View store details | Y | Y* | Y* |
| Edit store information | Y | N | Y* |
| Change store status | Y | N | Y* |
| Assign to store groups | Y | N | N |
| Invite new store | Y | N | N |
| Export store data | Y | Y* | Y* |
| Bulk update stores | Y | N | Y* |

**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Data Scoping Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B006-SEC-001 | Store list SHALL be filtered by authenticated user's brand_id |
| REQ-B006-SEC-002 | Campaign Managers SHALL only see stores participating in their assigned campaigns |
| REQ-B006-SEC-003 | Regional Managers SHALL only see stores within their region_scope_id hierarchy |
| REQ-B006-SEC-004 | Store edits SHALL be logged to audit_events with actor_id |

---

## 3. UI Components

### 3.1 Layout Structure

```
+-------------------------------------------------------------+
| Stores                                      [+ Invite Store] |
+-------------------------------------------------------------+
| [All] [Active] [Inactive] [Onboarding] [Suspended]          |
+-------------------------------------------------------------+
| Search stores...          [Region v] [Group v] [Export v]    |
+-------------------------------------------------------------+
| [ ] Store              Region     Status    Campaigns  [...]  |
| ----------------------------------------------------------------|
| [ ] Store #1234        Northeast  Active    3          [...]  |
|     789 Main Street, Boston, MA 02101                         |
| [ ] Store #5678        Midwest    Active    2          [...]  |
|     456 Oak Ave, Chicago, IL 60601                            |
| [ ] Store #9012        Southeast  Onboard   0          [...]  |
|     123 Palm Dr, Miami, FL 33101                              |
| [ ] Store #3456        Northeast  Inactive  1          [...]  |
|     321 Elm St, New York, NY 10001                            |
+-------------------------------------------------------------+
| Showing 1-20 of 847             [<] [1] [2] [3] ... [43] [>] |
+-------------------------------------------------------------+
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| Page Header | Header bar | Title + primary action button |
| Status Tabs | Tab bar | Filter by store status |
| Search Bar | Text input | Full-text store search |
| Filter Dropdowns | Multi-select | Region and group filters |
| Export Menu | Dropdown menu | Export options |
| Store Table | Data table | Expandable rows with details |
| Row Checkbox | Selection | Enable bulk actions |
| Action Menu | Dropdown menu | Row-level actions |
| Pagination | Page controls | Navigate result pages |
| Bulk Action Bar | Toolbar | Actions for selected rows |

### 3.3 Status Tab Definitions

| Tab | Filter Criteria | Badge Count |
|-----|-----------------|-------------|
| All | No status filter | Total count |
| Active | `status = 'ACTIVE'` | Active count |
| Inactive | `status = 'INACTIVE'` | Inactive count |
| Onboarding | `status = 'ONBOARDING'` | Onboarding count |
| Suspended | `status = 'SUSPENDED'` | Suspended count |

### 3.4 Store Status Badges

| Status | Color | Icon | Description |
|--------|-------|------|-------------|
| ACTIVE | Green | Checkmark | Fully operational store |
| INACTIVE | Gray | Dash | Temporarily not participating |
| ONBOARDING | Blue | Clock | New store being set up |
| SUSPENDED | Red | X | Account issues, blocked |

### 3.5 Store Row Information

| Field | Source | Display |
|-------|--------|---------|
| Store Number | stores.store_number | "#1234" |
| Store Name | stores.name | "Downtown Location" |
| Address | stores.address_line_1, city, state, zip | Full address |
| Region | regions.name | "Northeast" |
| Status | stores.status | Badge with icon |
| Campaign Count | store_assignments.count | "3 campaigns" |

### 3.6 Row Action Menu

| Action | Visibility Condition | Effect |
|--------|---------------------|--------|
| View Details | Always | Navigate to Store Detail |
| Edit Store | BRAND_ADMIN or REGIONAL_MANAGER | Navigate to Store Edit |
| View Campaigns | Always | Navigate to Store Campaigns |
| Manage Groups | BRAND_ADMIN | Open group assignment modal |
| Change Status | BRAND_ADMIN or REGIONAL_MANAGER | Open status change dialog |
| Resend Invitation | `status = 'ONBOARDING'` | Resend onboarding email |
| View History | Always | Navigate to Store Audit Log |

### 3.7 Component States

| State | Status Tabs | Store Table | Bulk Actions | Export |
|-------|-------------|-------------|--------------|--------|
| Loading | Badge counts loading | Skeleton rows | Hidden | Disabled |
| Empty | Zero counts | Empty state message | Hidden | Disabled |
| Loaded | Badge counts shown | Store rows | Hidden (no selection) | Enabled |
| Selecting | Unchanged | Checkboxes visible | Visible | Enabled |
| Filtering | Unchanged | Filtered results | Reset | Enabled |
| Error | Error indicator | Error message | Hidden | Disabled |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `stores` | id, store_number, name, address_*, status, region_id, created_at | Read/Write |
| `regions` | id, name, parent_region_id | Read |
| `districts` | id, name, region_id | Read |
| `territories` | id, name, district_id | Read |
| `store_groups` | id, name | Read |
| `store_group_memberships` | store_id, group_id | Read/Write |
| `store_assignments` | store_id, campaign_id (aggregated) | Read |
| `store_invitations` | store_id, status, expires_at | Read |

### 4.2 List Query Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B006-DATA-001 | Store list SHALL return paginated results with default page size of 20 |
| REQ-B006-DATA-002 | Each store row SHALL include active campaign count from store_assignments |
| REQ-B006-DATA-003 | Search SHALL support partial matching on store_number, name, address (case-insensitive) |
| REQ-B006-DATA-004 | Results SHALL be sortable by store_number, name, region, status, created_at |
| REQ-B006-DATA-005 | Region filter SHALL include child regions when parent selected |

### 4.3 Default Sort Order

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B006-DATA-006 | Default sort SHALL be `store_number ASC` |
| REQ-B006-DATA-007 | Active stores SHALL be prioritized in default view |

---

## 5. Business Rules & Validation

### 5.1 Store Status Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B006-BR-001 | ONBOARDING stores SHALL not be assigned to campaigns |
| REQ-B006-BR-002 | SUSPENDED stores SHALL not receive new campaign assignments |
| REQ-B006-BR-003 | INACTIVE status SHALL pause all active campaign participation |
| REQ-B006-BR-004 | Status change SHALL require confirmation dialog |

### 5.2 Store Group Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B006-BR-005 | Stores MAY belong to multiple store groups |
| REQ-B006-BR-006 | Group membership changes SHALL be effective immediately |
| REQ-B006-BR-007 | Removing from group SHALL NOT affect active campaign assignments |

### 5.3 Invitation Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B006-BR-008 | Store invitations SHALL expire after 7 days by default |
| REQ-B006-BR-009 | Expired invitations MAY be resent with new expiration |
| REQ-B006-BR-010 | Accepted invitations SHALL transition store to ACTIVE status |

### 5.4 Bulk Operation Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B006-BR-011 | Bulk status change SHALL be limited to 100 stores per operation |
| REQ-B006-BR-012 | Bulk operations SHALL display confirmation with affected count |
| REQ-B006-BR-013 | Bulk group assignment SHALL support add/remove actions |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/stores` | GET | List stores with filters |
| `/api/v1/stores` | POST | Create new store |
| `/api/v1/stores/{id}` | GET | Get store details |
| `/api/v1/stores/{id}` | PATCH | Update store |
| `/api/v1/stores/{id}/status` | PATCH | Change store status |
| `/api/v1/stores/{id}/groups` | PUT | Update group memberships |
| `/api/v1/stores/bulk/status` | PATCH | Bulk status change |
| `/api/v1/stores/bulk/groups` | PATCH | Bulk group assignment |
| `/api/v1/stores/export` | POST | Export store data |
| `/api/v1/store-invitations` | POST | Create store invitation |
| `/api/v1/store-invitations/{id}/resend` | POST | Resend invitation |

### 6.2 List Request Parameters

```
GET /api/v1/stores
  ?status[]=ACTIVE&status[]=ONBOARDING
  &region_id=uuid
  &group_id=uuid
  &search=downtown
  &sort=store_number
  &page=1
  &limit=20
```

### 6.3 List Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "storeNumber": "1234",
      "name": "Downtown Location",
      "addressLine1": "789 Main Street",
      "city": "Boston",
      "state": "MA",
      "zipCode": "02101",
      "status": "ACTIVE",
      "region": {
        "id": "uuid",
        "name": "Northeast"
      },
      "district": {
        "id": "uuid",
        "name": "New England"
      },
      "activeCampaigns": 3,
      "groups": [
        {"id": "uuid", "name": "Premium Locations"}
      ],
      "createdAt": "2025-01-15T10:00:00Z",
      "updatedAt": "2025-12-01T14:30:00Z"
    }
  ],
  "meta": {
    "total": 847,
    "page": 1,
    "limit": 20,
    "totalPages": 43
  },
  "statusCounts": {
    "ACTIVE": 780,
    "INACTIVE": 45,
    "ONBOARDING": 20,
    "SUSPENDED": 2
  }
}
```

### 6.4 Status Change Request

```json
// PATCH /api/v1/stores/{id}/status
{
  "status": "INACTIVE",
  "reason": "Temporary closure for renovation",
  "effectiveDate": "2025-12-15"
}
```

### 6.5 Bulk Status Change Request

```json
// PATCH /api/v1/stores/bulk/status
{
  "storeIds": ["uuid1", "uuid2", "uuid3"],
  "status": "INACTIVE",
  "reason": "Seasonal closure"
}
```

### 6.6 Export Request

```json
// POST /api/v1/stores/export
{
  "format": "csv",
  "filters": {
    "status": ["ACTIVE"],
    "regionId": "uuid"
  },
  "fields": ["storeNumber", "name", "address", "region", "status", "campaigns"]
}
```

### 6.7 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B006-API-001 | List endpoint SHALL respond within 500ms for up to 10,000 stores |
| REQ-B006-API-002 | Search SHALL use full-text index for performance |
| REQ-B006-API-003 | Export SHALL use background job for >1,000 stores |
| REQ-B006-API-004 | Status changes SHALL emit audit events |
| REQ-B006-API-005 | Bulk operations SHALL return individual success/failure status |

---

## 7. State Transitions

### 7.1 Store Status State Machine

```
[ONBOARDING] â”€â”€accept invitationâ”€â”€> [ACTIVE]
                                       |
                        +--------------+---------------+
                        |              |               |
                        v              v               v
                   [INACTIVE]    [SUSPENDED]    (stays ACTIVE)
                        |              |
                        |              |
                        +------+-------+
                               |
                               v
                           [ACTIVE]  <-- reactivate
```

### 7.2 Store Status Transitions

| From | To | Trigger | Conditions |
|------|-----|---------|------------|
| ONBOARDING | ACTIVE | Accept invitation | Valid invitation token |
| ACTIVE | INACTIVE | Admin action | Confirmation required |
| ACTIVE | SUSPENDED | Admin action | Reason required |
| INACTIVE | ACTIVE | Admin action | None |
| SUSPENDED | ACTIVE | Admin action | Resolution documented |
| SUSPENDED | INACTIVE | Admin action | Reason required |

### 7.3 UI State Machine

```
[Loading] --> [Loaded] --> [Selecting] --> [Bulk Action]
    |             |                              |
    v             v                              v
 [Error]     [Filtering]                    [Loaded]
                  |
                  v
              [Loaded]
```

### 7.4 Page State Definitions

| State | Trigger | UI Behavior |
|-------|---------|-------------|
| Loading | Page mount / filter change | Show skeleton rows |
| Empty | API returns 0 results | Show empty state with CTA |
| Loaded | API success | Render store rows |
| Error | API failure | Show error with retry |
| Selecting | Checkbox clicked | Show bulk action bar |
| Filtering | Filter applied | Show filtered results |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| List fetch failed | 500 | "Unable to load stores" | Retry button |
| Store not found | 404 | "Store no longer exists" | Refresh list |
| Status change failed | 422 | "Cannot change status: active campaigns" | Show affected campaigns |
| Bulk operation partial | 207 | "X of Y stores updated" | Show failure details |
| Permission denied | 403 | "You don't have permission to edit this store" | Contact admin |
| Export failed | 500 | "Unable to generate export" | Retry button |

### 8.2 Validation Messages

| Field | Validation | Message |
|-------|------------|---------|
| Status Change | Has active campaigns | "Complete or reassign X active campaigns first" |
| Bulk Select | Exceeds limit | "Maximum 100 stores can be selected" |
| Group Assignment | Invalid group | "Selected group no longer exists" |
| Invitation | Already accepted | "This store has already been onboarded" |

### 8.3 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B006-ERR-001 | Failed bulk operations SHALL report individual failures |
| REQ-B006-ERR-002 | Status change blocks SHALL explain reason with link to details |
| REQ-B006-ERR-003 | Network errors SHALL preserve filter state for retry |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B006-A11Y-001 | Data table SHALL use proper `<table>`, `<th>`, `<td>` markup | 1.3.1 Info and Relationships |
| REQ-B006-A11Y-002 | Status tabs SHALL use `role="tablist"` with proper ARIA attributes | 4.1.2 Name, Role, Value |
| REQ-B006-A11Y-003 | Row selection checkboxes SHALL have accessible labels | 1.3.1 Info and Relationships |
| REQ-B006-A11Y-004 | Status badges SHALL have text alternatives (not just color) | 1.4.1 Use of Color |
| REQ-B006-A11Y-005 | Sort controls SHALL announce current sort state | 4.1.2 Name, Role, Value |
| REQ-B006-A11Y-006 | Pagination controls SHALL indicate current page and total | 2.4.8 Location |
| REQ-B006-A11Y-007 | Action menu SHALL be keyboard accessible with Escape to close | 2.1.1 Keyboard |
| REQ-B006-A11Y-008 | Bulk action bar SHALL announce selection count | 4.1.3 Status Messages |
| REQ-B006-A11Y-009 | Filter changes SHALL announce result count | 4.1.3 Status Messages |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B006-FR-001 | Store list SHALL display all stores for brand | Must |
| REQ-B006-FR-002 | Status tabs SHALL filter stores by status | Must |
| REQ-B006-FR-003 | Search SHALL filter stores by number, name, address | Must |
| REQ-B006-FR-004 | Region filter SHALL include hierarchical regions | Must |
| REQ-B006-FR-005 | Group filter SHALL filter by store group membership | Should |
| REQ-B006-FR-006 | Table columns SHALL be sortable | Should |
| REQ-B006-FR-007 | Row actions SHALL be accessible via action menu | Must |
| REQ-B006-FR-008 | Bulk selection SHALL enable bulk status change | Should |
| REQ-B006-FR-009 | Bulk selection SHALL enable bulk group assignment | Should |
| REQ-B006-FR-010 | Export SHALL generate CSV/Excel of filtered stores | Should |
| REQ-B006-FR-011 | Pagination SHALL navigate between result pages | Must |
| REQ-B006-FR-012 | Store invitation SHALL be creatable from this screen | Should |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B006-01 | Brand Admin views all stores | All stores for brand displayed |
| TC-B006-02 | Regional Manager views stores | Only stores in assigned region shown |
| TC-B006-03 | Click Active tab | Only ACTIVE stores shown |
| TC-B006-04 | Search for store number "1234" | Matching stores filtered |
| TC-B006-05 | Filter by Northeast region | Only Northeast stores shown |
| TC-B006-06 | Sort by status | Stores reordered by status |
| TC-B006-07 | Change store status to Inactive | Confirmation dialog, status updated |
| TC-B006-08 | Bulk select 5 stores, change status | All 5 stores updated |
| TC-B006-09 | Assign store to group | Group membership updated |
| TC-B006-10 | Export active stores as CSV | CSV file downloaded |
| TC-B006-11 | Resend store invitation | New invitation email sent |
| TC-B006-12 | Keyboard navigate store list | All controls accessible via keyboard |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B001 Dashboard](B001_Dashboard.md) | KPI click-through destination |
| [B003 Store Selection](B003_Store_Selection.md) | Store selection for campaigns |
| B008 Store Detail | Row click destination |
| B009 Store Groups | Group management |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*
