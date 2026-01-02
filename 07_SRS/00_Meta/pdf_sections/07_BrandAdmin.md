

---

# B001 - Brand Admin Dashboard

> **SRS Section**: 7.1.1 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Brand Admin Dashboard serves as the primary landing page for brand-level users, providing at-a-glance visibility into campaign performance, store compliance, and pending actions requiring attention.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access |
| CAMPAIGN_MANAGER | Full access (scoped to assigned campaigns) |
| REGIONAL_MANAGER | Read-only (scoped to assigned regions) |

### 1.3 Navigation Path

- **Route**: `/admin/dashboard`
- **Entry Points**:
  - Direct URL navigation
  - Post-login redirect (default landing)
  - Brand logo/home link in navigation

### 1.4 Screenshot Reference

![Dashboard](../../screenshots/Admin_Portal/admin_portal_dashboard.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| View all KPIs | Y | Y* | Y* |
| View all campaigns | Y | Y* | Y* |
| Access quick actions | Y | Y* | N |
| View pending reviews count | Y | Y* | Y* |
| Click-through to Campaign Builder | Y | Y | N |
| Click-through to Verification Queue | Y | Y* | Y* |

**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Data Scoping Rules

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B001-SEC-001 | Campaign Managers SHALL only see metrics for campaigns explicitly assigned to them |
| REQ-B001-SEC-002 | Regional Managers SHALL only see metrics for stores within their assigned region scope |
| REQ-B001-SEC-003 | All dashboard data SHALL be filtered by the authenticated user's `brand_id` from JWT |

---

## 3. UI Components

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│ [Logo] Brand Admin Portal          [User Menu ▼] [Logout]   │
├─────────────────────────────────────────────────────────────┤
│ Dashboard                                                   │
├─────────────────────────────────────────────────────────────┤
│ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │
│ │ Active   │ │ Total    │ │ Pending  │ │ Compliance│        │
│ │ Campaigns│ │ Stores   │ │ Reviews  │ │ Rate     │        │
│ │    12    │ │   847    │ │    23    │ │   94.2%  │        │
│ └──────────┘ └──────────┘ └──────────┘ └──────────┘        │
│                                                             │
│ Quick Actions                                               │
│ [+ New Campaign]  [Review Photos]  [View All Stores]       │
│                                                             │
│ Recent Campaigns                                            │
│ ┌─────────────────────────────────────────────────────────┐│
│ │ Campaign Name        Status    Stores   Progress        ││
│ │ Summer Promo 2025    Active    234      ████████░░ 80%  ││
│ │ Holiday Display      Draft      --      Not started     ││
│ │ Q4 End Caps          Active    156      ██████████ 100% ││
│ └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| KPI Cards | Stat card grid | 4-column grid of primary metrics |
| Quick Actions | Button group | Primary action shortcuts |
| Recent Campaigns | Data table | Top 5 campaigns by activity |
| Campaign Progress | Progress bar | Visual completion indicator |

### 3.3 KPI Card Definitions

| Card | Metric | Calculation | Click Action |
|------|--------|-------------|--------------|
| Active Campaigns | Count | `campaigns WHERE status = 'PUBLISHED'` | Navigate to Campaign List (Active tab) |
| Total Stores | Count | `stores WHERE deleted_at IS NULL` | Navigate to Store List |
| Pending Reviews | Count | `photo_uploads WHERE review_status = 'PENDING'` | Navigate to Verification Queue |
| Compliance Rate | Percentage | `(completed_assignments / total_assignments) * 100` | Navigate to Compliance Report |

### 3.4 Component States

| State | KPI Cards | Quick Actions | Recent Campaigns |
|-------|-----------|---------------|------------------|
| Loading | Skeleton placeholders | Disabled | Skeleton rows |
| Empty | "0" with muted styling | Enabled | "No campaigns yet" message |
| Error | Error icon + retry | Enabled | Error message + retry |
| Loaded | Formatted values | Enabled | Campaign rows |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `campaigns` | id, name, status, install_start, install_end | Read |
| `store_assignments` | id, campaign_id, status, store_id | Read |
| `stores` | id, name, region_id | Read |
| `photo_uploads` | id, review_status, created_at | Read |
| `brands` | id, name, logo_url | Read |

### 4.2 Aggregation Queries

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B001-DATA-001 | Active campaign count SHALL be computed as `COUNT(*) FROM campaigns WHERE brand_id = ? AND status = 'PUBLISHED' AND deleted_at IS NULL` |
| REQ-B001-DATA-002 | Pending review count SHALL be computed by joining photo_uploads to store_assignments to campaigns filtered by brand_id |
| REQ-B001-DATA-003 | Compliance rate SHALL be calculated as percentage of store_assignments with status = 'COMPLETE' |
| REQ-B001-DATA-004 | Recent campaigns list SHALL return top 5 campaigns ordered by updated_at DESC |

### 4.3 Data Refresh

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B001-DATA-005 | Dashboard data SHALL refresh automatically every 60 seconds via polling |
| REQ-B001-DATA-006 | Manual refresh SHALL be available via pull-to-refresh on mobile or refresh button |

---

## 5. Business Rules & Validation

### 5.1 Display Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B001-BR-001 | Compliance Rate SHALL display as percentage with one decimal place (e.g., "94.2%") |
| REQ-B001-BR-002 | Campaign progress bars SHALL use color coding: Green (>=80%), Yellow (50-79%), Red (<50%) |
| REQ-B001-BR-003 | Draft campaigns SHALL NOT be included in Active Campaigns count |
| REQ-B001-BR-004 | Archived and Cancelled campaigns SHALL NOT appear in Recent Campaigns list |

### 5.2 Scoping Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B001-BR-005 | All metrics SHALL respect multi-tenant isolation via brand_id |
| REQ-B001-BR-006 | Campaign Manager view SHALL filter by campaign_ids from memberships table |
| REQ-B001-BR-007 | Regional Manager view SHALL filter by region_scope_id from memberships table |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/dashboard/summary` | GET | Retrieve all KPI metrics |
| `/api/v1/campaigns` | GET | List recent campaigns |
| `/api/v1/photos/pending/count` | GET | Get pending review count |

### 6.2 Request/Response Specifications

**GET /api/v1/dashboard/summary**

```json
// Response 200 OK
{
  "activeCampaigns": 12,
  "totalStores": 847,
  "pendingReviews": 23,
  "complianceRate": 94.2,
  "lastUpdated": "2026-01-01T10:30:00Z"
}
```

**GET /api/v1/campaigns?limit=5&sort=-updated_at&status[]=PUBLISHED&status[]=DRAFT**

```json
// Response 200 OK
{
  "data": [
    {
      "id": "uuid",
      "name": "Summer Promo 2025",
      "status": "PUBLISHED",
      "storeCount": 234,
      "completionRate": 80.0,
      "installStart": "2025-12-01",
      "installEnd": "2025-12-31"
    }
  ],
  "meta": {
    "total": 5,
    "limit": 5,
    "offset": 0
  }
}
```

### 6.3 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B001-API-001 | Dashboard summary endpoint SHALL respond within 500ms for brands with up to 10,000 stores |
| REQ-B001-API-002 | All API responses SHALL include ETag headers for cache validation |
| REQ-B001-API-003 | API SHALL return 403 Forbidden if user lacks brand-level access |

---

## 7. State Transitions

### 7.1 Page Load State Machine

```
[Initial] → [Loading] → [Loaded]
                ↓
            [Error] → [Retry] → [Loading]
```

### 7.2 State Definitions

| State | Trigger | UI Behavior |
|-------|---------|-------------|
| Initial | Page mount | Show loading state |
| Loading | API request in flight | Display skeleton UI |
| Loaded | API success | Render data |
| Error | API failure | Show error message with retry option |
| Stale | 60 seconds elapsed | Background refresh, keep current data visible |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| Network failure | - | "Unable to load dashboard. Check your connection." | Retry button |
| Server error | 500 | "Something went wrong. Please try again." | Retry button |
| Unauthorized | 401 | Redirect to login | Auto-redirect |
| Forbidden | 403 | "You don't have access to this brand." | Contact admin link |
| Timeout | 504 | "Request timed out. Please try again." | Retry button |

### 8.2 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B001-ERR-001 | Partial failures SHALL NOT block entire dashboard; failed sections SHALL show individual error states |
| REQ-B001-ERR-002 | All errors SHALL be logged to monitoring system with correlation ID |
| REQ-B001-ERR-003 | Error messages SHALL NOT expose internal system details |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B001-A11Y-001 | All KPI values SHALL be announced by screen readers with context (e.g., "Active Campaigns: 12") | 1.3.1 Info and Relationships |
| REQ-B001-A11Y-002 | KPI cards SHALL be keyboard navigable with Enter/Space to activate | 2.1.1 Keyboard |
| REQ-B001-A11Y-003 | Progress bars SHALL have aria-valuenow, aria-valuemin, aria-valuemax attributes | 4.1.2 Name, Role, Value |
| REQ-B001-A11Y-004 | Color-coded elements SHALL have additional non-color indicators | 1.4.1 Use of Color |
| REQ-B001-A11Y-005 | Loading states SHALL announce "Loading dashboard" to screen readers | 4.1.3 Status Messages |
| REQ-B001-A11Y-006 | Focus order SHALL follow visual layout: KPIs → Quick Actions → Recent Campaigns | 2.4.3 Focus Order |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B001-FR-001 | Dashboard SHALL display Active Campaigns count accurately | Must |
| REQ-B001-FR-002 | Dashboard SHALL display Total Stores count for the brand | Must |
| REQ-B001-FR-003 | Dashboard SHALL display Pending Reviews count with real-time accuracy | Must |
| REQ-B001-FR-004 | Dashboard SHALL display Compliance Rate as percentage | Must |
| REQ-B001-FR-005 | Clicking KPI card SHALL navigate to corresponding detail view | Must |
| REQ-B001-FR-006 | Quick Actions SHALL navigate to correct destinations | Must |
| REQ-B001-FR-007 | Recent Campaigns table SHALL show top 5 campaigns by activity | Should |
| REQ-B001-FR-008 | Campaign progress bars SHALL reflect actual completion percentage | Must |
| REQ-B001-FR-009 | Dashboard SHALL auto-refresh every 60 seconds | Should |
| REQ-B001-FR-010 | Dashboard SHALL load within 2 seconds under normal conditions | Must |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B001-01 | Brand Admin loads dashboard | All 4 KPIs display with correct values |
| TC-B001-02 | Campaign Manager loads dashboard | KPIs filtered to assigned campaigns only |
| TC-B001-03 | Click Active Campaigns KPI | Navigate to Campaign List with Active filter |
| TC-B001-04 | Network disconnected | Error state with retry button |
| TC-B001-05 | Brand with 0 campaigns | Empty state message displayed |
| TC-B001-06 | Keyboard navigation | Tab order follows logical sequence |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B002 Campaign List](B002_Campaign_List.md) | KPI click-through destination |
| [B006 Store List](B006_Store_List.md) | Quick action destination |
| [B007 Verification](B007_Verification.md) | Pending reviews click-through |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---

# B002 - Campaign List

> **SRS Section**: 7.1.2 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Campaign List screen provides brand administrators with a comprehensive view of all campaigns across their lifecycle states. It serves as the primary campaign management hub for creating, monitoring, and administering promotional campaigns.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access (all campaigns) |
| CAMPAIGN_MANAGER | Scoped access (assigned campaigns only) |
| REGIONAL_MANAGER | Read-only (campaigns with stores in assigned regions) |

### 1.3 Navigation Path

- **Route**: `/admin/campaigns`
- **Entry Points**:
  - Main navigation: "Campaigns" menu item
  - Dashboard: Active Campaigns KPI click-through
  - Quick Actions: "New Campaign" redirects here after creation

### 1.4 Screenshot Reference

![Campaign List](../../screenshots/Admin_Portal/admin_portal_campaigns.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| View all campaigns | Y | N | N |
| View assigned campaigns | Y | Y | Y* |
| Create new campaign | Y | Y | N |
| Edit draft campaign | Y | Y* | N |
| Publish campaign | Y | Y* | N |
| Complete campaign | Y | N | N |
| Archive campaign | Y | N | N |
| Duplicate campaign | Y | Y | N |
| Delete draft campaign | Y | Y* | N |
| Export campaign data | Y | Y* | Y* |

**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Scoping Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B002-SEC-001 | Campaign Managers SHALL only view campaigns where they are explicitly assigned via `memberships.campaign_id` |
| REQ-B002-SEC-002 | Regional Managers SHALL only view campaigns that include stores within their `region_scope_id` |
| REQ-B002-SEC-003 | All campaign data SHALL be isolated by `brand_id` from authenticated user's JWT |

---

## 3. UI Components

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│ Campaigns                              [+ New Campaign]     │
├─────────────────────────────────────────────────────────────┤
│ [All] [Active] [Completed] [Draft] [Archived]               │
├─────────────────────────────────────────────────────────────┤
│ 🔍 Search campaigns...          [Filter ▼]  [Export ▼]      │
├─────────────────────────────────────────────────────────────┤
│ □ Campaign Name      Status    Stores  Progress   Actions   │
│ ─────────────────────────────────────────────────────────── │
│ □ Summer Promo 2025  ●Active   234     ████░░ 80%  [•••]   │
│ □ Holiday Display    ○Draft     --     --          [•••]   │
│ □ Q4 End Caps        ●Active   156     ██████ 100% [•••]   │
│ □ Back to School     ✓Complete 892     ██████ 100% [•••]   │
│ □ Spring Refresh     ○Draft     --     --          [•••]   │
├─────────────────────────────────────────────────────────────┤
│ Showing 1-5 of 47              [<] [1] [2] [3] [>]         │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| Page Header | Header bar | Title + primary action button |
| Status Tabs | Tab bar | Filter by campaign status |
| Search Bar | Text input | Full-text campaign search |
| Filter Dropdown | Multi-select | Date range, store group filters |
| Campaign Table | Data table | Sortable, selectable rows |
| Action Menu | Dropdown menu | Row-level actions |
| Pagination | Page controls | Navigate result pages |
| Bulk Actions | Toolbar | Actions for selected rows |

### 3.3 Status Tab Definitions

| Tab | Filter Criteria | Badge Count |
|-----|-----------------|-------------|
| All | No status filter | Total count |
| Active | `status IN ('PUBLISHED', 'SCHEDULED')` | Active count |
| Completed | `status = 'COMPLETED'` | Completed count |
| Draft | `status = 'DRAFT'` | Draft count |
| Archived | `status IN ('ARCHIVED', 'CANCELLED')` | Archived count |

### 3.4 Campaign Status Badges

| Status | Color | Icon | Description |
|--------|-------|------|-------------|
| DRAFT | Gray | ○ | Campaign in creation |
| SCHEDULED | Blue | ◐ | Published, awaiting start date |
| PUBLISHED | Green | ● | Active campaign |
| COMPLETED | Green | ✓ | All stores finished |
| CANCELLED | Red | ✕ | Terminated early |
| ARCHIVED | Gray | ▢ | Historical record |

### 3.5 Row Action Menu

| Action | Visibility Condition | Effect |
|--------|---------------------|--------|
| View | Always | Navigate to Campaign Detail |
| Edit | `status = 'DRAFT'` | Navigate to Campaign Builder |
| Duplicate | Always | Create copy with "Copy of" prefix |
| Publish | `status = 'DRAFT'` | Transition to SCHEDULED/PUBLISHED |
| Complete | `status = 'PUBLISHED'` | Transition to COMPLETED |
| Archive | `status IN ('COMPLETED', 'CANCELLED')` | Transition to ARCHIVED |
| Cancel | `status = 'PUBLISHED'` | Transition to CANCELLED |
| Delete | `status = 'DRAFT'` | Soft delete with confirmation |
| Export | Always | Download campaign data |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `campaigns` | id, name, status, install_start, install_end, created_at, updated_at | Read |
| `store_assignments` | campaign_id, status (aggregated) | Read |
| `kit_definitions` | campaign_id (count) | Read |
| `users` | id, name (created_by reference) | Read |

### 4.2 List Query Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B002-DATA-001 | Campaign list SHALL return paginated results with default page size of 20 |
| REQ-B002-DATA-002 | Each campaign row SHALL include aggregated store count from store_assignments |
| REQ-B002-DATA-003 | Progress percentage SHALL be calculated as `(completed_assignments / total_assignments) * 100` |
| REQ-B002-DATA-004 | Search SHALL support partial matching on campaign name (case-insensitive) |
| REQ-B002-DATA-005 | Results SHALL be sortable by name, status, install_start, created_at |

### 4.3 Default Sort Order

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B002-DATA-006 | Default sort SHALL be `updated_at DESC` (most recently modified first) |
| REQ-B002-DATA-007 | Active campaigns SHALL be prioritized over archived in default view |

---

## 5. Business Rules & Validation

### 5.1 Status Transition Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B002-BR-001 | DRAFT → PUBLISHED requires at least one store assignment |
| REQ-B002-BR-002 | DRAFT → PUBLISHED requires at least one kit item defined |
| REQ-B002-BR-003 | PUBLISHED → COMPLETED requires all store_assignments to be COMPLETE or WAIVED |
| REQ-B002-BR-004 | Only BRAND_ADMIN may force-complete a campaign with incomplete stores |
| REQ-B002-BR-005 | ARCHIVED campaigns cannot be modified or transitioned |

### 5.2 Delete Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B002-BR-006 | Only DRAFT campaigns may be deleted |
| REQ-B002-BR-007 | Delete operation SHALL be soft-delete (set deleted_at timestamp) |
| REQ-B002-BR-008 | Delete SHALL require confirmation dialog |

### 5.3 Duplicate Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B002-BR-009 | Duplicate SHALL create new campaign with status = DRAFT |
| REQ-B002-BR-010 | Duplicate SHALL copy kit_definitions and kit_items |
| REQ-B002-BR-011 | Duplicate SHALL NOT copy store_assignments |
| REQ-B002-BR-012 | Duplicate name SHALL be "Copy of {original_name}" |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/campaigns` | GET | List campaigns with filters |
| `/api/v1/campaigns` | POST | Create new campaign |
| `/api/v1/campaigns/{id}` | GET | Get campaign details |
| `/api/v1/campaigns/{id}` | PATCH | Update campaign |
| `/api/v1/campaigns/{id}` | DELETE | Soft delete campaign |
| `/api/v1/campaigns/{id}/duplicate` | POST | Create campaign copy |
| `/api/v1/campaigns/{id}/publish` | POST | Publish campaign |
| `/api/v1/campaigns/{id}/complete` | POST | Complete campaign |
| `/api/v1/campaigns/{id}/archive` | POST | Archive campaign |

### 6.2 List Request Parameters

```
GET /api/v1/campaigns
  ?status[]=PUBLISHED&status[]=DRAFT
  &search=summer
  &sort=-updated_at
  &page=1
  &limit=20
```

### 6.3 List Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Summer Promo 2025",
      "status": "PUBLISHED",
      "installStart": "2025-12-01",
      "installEnd": "2025-12-31",
      "storeCount": 234,
      "completedCount": 187,
      "completionRate": 79.9,
      "createdAt": "2025-11-01T10:00:00Z",
      "updatedAt": "2025-12-15T14:30:00Z",
      "createdBy": {
        "id": "uuid",
        "name": "John Smith"
      }
    }
  ],
  "meta": {
    "total": 47,
    "page": 1,
    "limit": 20,
    "totalPages": 3
  }
}
```

### 6.4 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B002-API-001 | List endpoint SHALL support cursor-based pagination for large datasets |
| REQ-B002-API-002 | All write operations SHALL return updated campaign object |
| REQ-B002-API-003 | Status transitions SHALL be atomic and emit audit events |
| REQ-B002-API-004 | Bulk operations SHALL support up to 50 campaigns per request |

---

## 7. State Transitions

### 7.1 Campaign Lifecycle State Machine

```
┌─────────┐    publish     ┌───────────┐
│  DRAFT  │ ─────────────→ │ SCHEDULED │
└────┬────┘                └─────┬─────┘
     │                           │ start_date reached
     │ delete                    ↓
     ↓                     ┌───────────┐    complete    ┌───────────┐
  [Deleted]                │ PUBLISHED │ ─────────────→ │ COMPLETED │
                           └─────┬─────┘                └─────┬─────┘
                                 │                             │
                                 │ cancel                      │ archive
                                 ↓                             ↓
                           ┌───────────┐    archive     ┌───────────┐
                           │ CANCELLED │ ─────────────→ │ ARCHIVED  │
                           └───────────┘                └───────────┘
```

### 7.2 UI State Management

| State | Trigger | UI Behavior |
|-------|---------|-------------|
| Loading | Page mount / filter change | Show skeleton rows |
| Empty | API returns 0 results | Show empty state with CTA |
| Loaded | API success | Render campaign rows |
| Error | API failure | Show error with retry |
| Selecting | Checkbox clicked | Enable bulk action toolbar |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| List fetch failed | 500 | "Unable to load campaigns" | Retry button |
| Publish validation failed | 422 | "Campaign missing required items" | Show validation errors |
| Delete failed | 409 | "Cannot delete active campaign" | Explain status requirement |
| Concurrent edit | 409 | "Campaign was modified by another user" | Refresh and retry |
| Permission denied | 403 | "You don't have permission to {action}" | Contact admin |

### 8.2 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B002-ERR-001 | Validation errors SHALL highlight specific missing requirements |
| REQ-B002-ERR-002 | Failed bulk operations SHALL report individual success/failure status |
| REQ-B002-ERR-003 | Network errors SHALL preserve form state for retry |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B002-A11Y-001 | Data table SHALL use proper `<table>`, `<th>`, `<td>` markup | 1.3.1 Info and Relationships |
| REQ-B002-A11Y-002 | Status tabs SHALL use `role="tablist"` with proper ARIA attributes | 4.1.2 Name, Role, Value |
| REQ-B002-A11Y-003 | Row selection checkboxes SHALL have accessible labels | 1.3.1 Info and Relationships |
| REQ-B002-A11Y-004 | Status badges SHALL have text alternatives (not just color) | 1.4.1 Use of Color |
| REQ-B002-A11Y-005 | Sort controls SHALL announce current sort state | 4.1.2 Name, Role, Value |
| REQ-B002-A11Y-006 | Pagination controls SHALL indicate current page and total | 2.4.8 Location |
| REQ-B002-A11Y-007 | Action menu SHALL be keyboard accessible with Escape to close | 2.1.1 Keyboard |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B002-FR-001 | Campaign list SHALL display all campaigns for brand | Must |
| REQ-B002-FR-002 | Status tabs SHALL filter campaigns by lifecycle state | Must |
| REQ-B002-FR-003 | Search SHALL filter campaigns by name in real-time | Must |
| REQ-B002-FR-004 | Table columns SHALL be sortable | Should |
| REQ-B002-FR-005 | Row actions SHALL reflect campaign state (conditional visibility) | Must |
| REQ-B002-FR-006 | "New Campaign" button SHALL navigate to Campaign Builder | Must |
| REQ-B002-FR-007 | Pagination SHALL navigate between result pages | Must |
| REQ-B002-FR-008 | Bulk selection SHALL enable bulk action toolbar | Should |
| REQ-B002-FR-009 | Duplicate action SHALL create copy with correct naming | Must |
| REQ-B002-FR-010 | Delete action SHALL require confirmation dialog | Must |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B002-01 | Brand Admin views all campaigns | All campaigns for brand displayed |
| TC-B002-02 | Campaign Manager views campaigns | Only assigned campaigns shown |
| TC-B002-03 | Click Active tab | Only PUBLISHED/SCHEDULED campaigns shown |
| TC-B002-04 | Search for "summer" | Matching campaigns filtered |
| TC-B002-05 | Sort by install date | Campaigns reordered correctly |
| TC-B002-06 | Attempt to publish incomplete draft | Validation errors displayed |
| TC-B002-07 | Duplicate campaign | New draft created with "Copy of" prefix |
| TC-B002-08 | Delete draft campaign | Confirmation shown, campaign removed |
| TC-B002-09 | Select 3 campaigns, bulk archive | All 3 archived successfully |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B001 Dashboard](B001_Dashboard.md) | Entry point via KPI click |
| [B003 Store Selection](B003_Store_Selection.md) | Campaign Builder Step 1 |
| [B004 Kit Definition](B004_Kit_Definition.md) | Campaign Builder Step 2 |
| [B005 Campaign Review](B005_Campaign_Review.md) | Campaign Builder Step 3 |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---

# B003 - Store Selection

> **SRS Section**: 7.1.3 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Store Selection screen is the first step in the Campaign Builder wizard. It allows campaign creators to define which stores will participate in a campaign using a rule-based "Selection Recipe" system that supports both inclusion and exclusion criteria.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access |
| CAMPAIGN_MANAGER | Full access (for assigned campaigns) |
| REGIONAL_MANAGER | No access |

### 1.3 Navigation Path

- **Route**: `/admin/campaigns/create/stores` (new campaign)
- **Route**: `/admin/campaigns/:id/edit/stores` (edit existing)
- **Entry Points**:
  - Campaign List: "New Campaign" button
  - Campaign Detail: "Edit" action (draft only)
- **Wizard Position**: Step 1 of 3

### 1.4 Screenshot Reference

![Store Selection](../../screenshots/Admin_Portal/admin_portal_stores_tab.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| Access store selection wizard | Y | Y* | N |
| View all regions | Y | Y | N |
| View all store groups | Y | Y | N |
| Add inclusion rules | Y | Y | N |
| Add exclusion rules | Y | Y | N |
| Preview store list | Y | Y | N |
| Save and continue | Y | Y | N |

**Legend**: Y = Full access | Y* = Only for assigned campaigns | N = No access

### 2.2 Data Scoping Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B003-SEC-001 | Store options SHALL be limited to stores within the authenticated user's brand |
| REQ-B003-SEC-002 | Region hierarchy SHALL only display regions belonging to the brand |
| REQ-B003-SEC-003 | Campaign edits SHALL only be allowed when campaign status = DRAFT |

---

## 3. UI Components

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│ Create Campaign                                             │
├─────────────────────────────────────────────────────────────┤
│ Step 1: Select Stores  ───●───────────────────────────────  │
│ Step 2: Define Kit     ────○──────────────────────────────  │
│ Step 3: Review         ────○──────────────────────────────  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Campaign Name *                                             │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Summer Promo 2025                                       │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Store Selection Recipe                                      │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ INCLUDE stores where:                                   │ │
│ │ ┌───────────────────────────────────────────────────┐   │ │
│ │ │ Region    [=]  [Northeast        ▼]  [×]          │   │ │
│ │ └───────────────────────────────────────────────────┘   │ │
│ │ ┌───────────────────────────────────────────────────┐   │ │
│ │ │ Group     [=]  [Premium Locations ▼]  [×]         │   │ │
│ │ └───────────────────────────────────────────────────┘   │ │
│ │ [+ Add Rule]                                            │ │
│ │                                                         │ │
│ │ EXCLUDE stores where:                                   │ │
│ │ ┌───────────────────────────────────────────────────┐   │ │
│ │ │ Status    [=]  [Inactive          ▼]  [×]         │   │ │
│ │ └───────────────────────────────────────────────────┘   │ │
│ │ [+ Add Exclusion]                                       │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Preview: 234 stores selected              [View Store List] │
│                                                             │
│ [Cancel]                            [Save & Continue →]     │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| Wizard Progress | Stepper | Visual step indicator (1/3) |
| Campaign Name | Text input | Required campaign identifier |
| Include Rules | Rule builder | Additive selection criteria |
| Exclude Rules | Rule builder | Subtractive selection criteria |
| Preview Count | Dynamic counter | Real-time store count |
| Store List Modal | Data table modal | Preview selected stores |
| Navigation Buttons | Button group | Cancel, Save & Continue |

### 3.3 Rule Builder Fields

| Field | Operators | Value Options |
|-------|-----------|---------------|
| Region | =, IN | Dropdown of brand regions |
| District | =, IN | Dropdown (filtered by region) |
| Territory | =, IN | Dropdown (filtered by district) |
| Store Group | =, IN | Dropdown of store groups |
| Store Status | =, != | ACTIVE, INACTIVE, ONBOARDING |
| Store Type | =, IN | Multi-select of store types |
| Custom Attribute | =, !=, CONTAINS | Text/value input |

### 3.4 Component States

| State | Campaign Name | Rule Builder | Preview | Actions |
|-------|---------------|--------------|---------|---------|
| Initial | Empty, focused | Empty, hint text | "0 stores" | Disabled |
| Building | Valid input | Rules added | Calculating... | Disabled |
| Ready | Valid input | Valid rules | "234 stores" | Enabled |
| Error | Invalid (red border) | Invalid rule | Error message | Disabled |
| Saving | Readonly | Readonly | Unchanged | Loading spinner |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `campaigns` | id, name, selection_recipe_json, brand_id | Read/Write |
| `regions` | id, name, parent_region_id | Read |
| `districts` | id, name, region_id | Read |
| `territories` | id, name, district_id | Read |
| `stores` | id, name, store_number, region_id, status | Read |
| `store_groups` | id, name, selection_criteria_json | Read |
| `store_group_memberships` | store_id, group_id | Read |

### 4.2 Selection Recipe Schema

```json
{
  "version": 1,
  "include": [
    {
      "field": "region_id",
      "operator": "IN",
      "values": ["uuid1", "uuid2"]
    },
    {
      "field": "group_id",
      "operator": "=",
      "value": "uuid3"
    }
  ],
  "exclude": [
    {
      "field": "status",
      "operator": "=",
      "value": "INACTIVE"
    }
  ],
  "logic": "AND"
}
```

### 4.3 Data Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B003-DATA-001 | Selection recipe SHALL be stored as JSONB in `campaigns.selection_recipe_json` |
| REQ-B003-DATA-002 | Store preview count SHALL be calculated server-side for accuracy |
| REQ-B003-DATA-003 | Region hierarchy SHALL support unlimited nesting depth |
| REQ-B003-DATA-004 | Store groups SHALL resolve membership at query time (dynamic) |

---

## 5. Business Rules & Validation

### 5.1 Campaign Name Validation

| REQ-ID | Rule |
|--------|------|
| REQ-B003-BR-001 | Campaign name SHALL be required (minimum 3 characters) |
| REQ-B003-BR-002 | Campaign name SHALL be unique within brand (case-insensitive) |
| REQ-B003-BR-003 | Campaign name SHALL not exceed 100 characters |

### 5.2 Selection Recipe Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B003-BR-004 | At least one inclusion rule SHALL be required |
| REQ-B003-BR-005 | Exclusion rules SHALL be optional |
| REQ-B003-BR-006 | Inclusion rules SHALL be combined with AND logic |
| REQ-B003-BR-007 | Selection SHALL result in at least one store to proceed |
| REQ-B003-BR-008 | Empty selection SHALL display warning but allow save as draft |

### 5.3 Rule Hierarchy

| REQ-ID | Rule |
|--------|------|
| REQ-B003-BR-009 | Exclusions SHALL be applied after inclusions |
| REQ-B003-BR-010 | District filter SHALL cascade to parent region |
| REQ-B003-BR-011 | Duplicate rules (same field+operator+value) SHALL be prevented |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/campaigns` | POST | Create new campaign |
| `/api/v1/campaigns/{id}` | PATCH | Update campaign |
| `/api/v1/campaigns/{id}/preview-stores` | POST | Preview store count |
| `/api/v1/campaigns/{id}/stores` | GET | List selected stores |
| `/api/v1/regions` | GET | List brand regions |
| `/api/v1/store-groups` | GET | List store groups |

### 6.2 Preview Request

```json
// POST /api/v1/campaigns/{id}/preview-stores
{
  "selectionRecipe": {
    "include": [
      {"field": "region_id", "operator": "IN", "values": ["uuid1"]}
    ],
    "exclude": [
      {"field": "status", "operator": "=", "value": "INACTIVE"}
    ]
  }
}
```

### 6.3 Preview Response

```json
{
  "count": 234,
  "breakdown": {
    "byRegion": [
      {"regionId": "uuid1", "name": "Northeast", "count": 156},
      {"regionId": "uuid2", "name": "Midwest", "count": 78}
    ],
    "byStatus": [
      {"status": "ACTIVE", "count": 234}
    ]
  }
}
```

### 6.4 Save Campaign Request

```json
// PATCH /api/v1/campaigns/{id}
{
  "name": "Summer Promo 2025",
  "selectionRecipe": {
    "version": 1,
    "include": [...],
    "exclude": [...],
    "logic": "AND"
  }
}
```

### 6.5 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B003-API-001 | Preview endpoint SHALL respond within 2 seconds for up to 50,000 stores |
| REQ-B003-API-002 | Preview SHALL be debounced on client (300ms delay) |
| REQ-B003-API-003 | Store list endpoint SHALL support pagination |
| REQ-B003-API-004 | Save SHALL validate recipe before persisting |

---

## 7. State Transitions

### 7.1 Wizard Navigation State Machine

```
[Step 1: Stores] ──save──→ [Step 2: Kit] ──save──→ [Step 3: Review]
       ↑                         │                        │
       └─────────back────────────┘                        │
       └──────────────────back────────────────────────────┘
```

### 7.2 Form State Machine

```
[Empty] → [Editing] → [Validating] → [Valid] → [Saving] → [Saved]
              ↓              ↓                      ↓
          [Invalid]     [Invalid]              [Error]
```

### 7.3 Preview State

| State | Trigger | Display |
|-------|---------|---------|
| Idle | Initial load | "0 stores selected" |
| Loading | Rule change | "Calculating..." with spinner |
| Ready | Preview success | "{count} stores selected" |
| Warning | Count = 0 | "No stores match criteria" (yellow) |
| Error | Preview failed | "Unable to preview" with retry |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| Duplicate name | 422 | "Campaign name already exists" | Edit name |
| Invalid recipe | 422 | "Selection rules are invalid" | Fix highlighted rules |
| No stores selected | 422 | "At least one store required to publish" | Add inclusion rules |
| Region not found | 404 | "Selected region no longer exists" | Remove rule |
| Save failed | 500 | "Unable to save campaign" | Retry |
| Session expired | 401 | Redirect to login | Re-authenticate |

### 8.2 Validation Messages

| Field | Validation | Message |
|-------|------------|---------|
| Campaign Name | Required | "Campaign name is required" |
| Campaign Name | Min length | "Name must be at least 3 characters" |
| Campaign Name | Max length | "Name cannot exceed 100 characters" |
| Campaign Name | Unique | "A campaign with this name already exists" |
| Include Rules | Required | "Add at least one inclusion rule" |
| Rule Value | Required | "Select a value for this rule" |

### 8.3 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B003-ERR-001 | Form validation SHALL occur on blur and on submit |
| REQ-B003-ERR-002 | Inline errors SHALL appear adjacent to invalid fields |
| REQ-B003-ERR-003 | Save errors SHALL preserve all form data |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B003-A11Y-001 | Wizard stepper SHALL announce current step to screen readers | 1.3.1 Info and Relationships |
| REQ-B003-A11Y-002 | Rule builder SHALL support keyboard navigation (Tab, Enter, Escape) | 2.1.1 Keyboard |
| REQ-B003-A11Y-003 | Dropdown options SHALL be filterable via keyboard typing | 2.1.1 Keyboard |
| REQ-B003-A11Y-004 | Form errors SHALL be announced via aria-live regions | 4.1.3 Status Messages |
| REQ-B003-A11Y-005 | Remove rule button SHALL have descriptive aria-label | 4.1.2 Name, Role, Value |
| REQ-B003-A11Y-006 | Preview count SHALL be announced when updated | 4.1.3 Status Messages |
| REQ-B003-A11Y-007 | Focus SHALL move to first error field on validation failure | 2.4.3 Focus Order |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B003-FR-001 | User SHALL be able to enter campaign name | Must |
| REQ-B003-FR-002 | User SHALL be able to add inclusion rules | Must |
| REQ-B003-FR-003 | User SHALL be able to add exclusion rules | Must |
| REQ-B003-FR-004 | Rules SHALL support Region, District, Group, Status fields | Must |
| REQ-B003-FR-005 | Preview count SHALL update as rules are modified | Must |
| REQ-B003-FR-006 | User SHALL be able to view full store list | Should |
| REQ-B003-FR-007 | User SHALL be able to remove individual rules | Must |
| REQ-B003-FR-008 | Save SHALL persist campaign and selection recipe | Must |
| REQ-B003-FR-009 | Continue SHALL navigate to Kit Definition step | Must |
| REQ-B003-FR-010 | Cancel SHALL return to Campaign List with confirmation | Should |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B003-01 | Enter valid campaign name | Name accepted, no errors |
| TC-B003-02 | Enter duplicate campaign name | Error displayed inline |
| TC-B003-03 | Add region inclusion rule | Preview count updates |
| TC-B003-04 | Add status exclusion rule | Preview count reduces |
| TC-B003-05 | Remove all inclusion rules | Warning: "Add at least one rule" |
| TC-B003-06 | Create rules selecting 0 stores | Warning displayed, save allowed |
| TC-B003-07 | Click View Store List | Modal shows matching stores |
| TC-B003-08 | Save & Continue | Navigate to Step 2 |
| TC-B003-09 | Click Cancel with unsaved changes | Confirmation dialog shown |
| TC-B003-10 | Keyboard navigate rule builder | All controls accessible |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B002 Campaign List](B002_Campaign_List.md) | Entry point, cancel destination |
| [B004 Kit Definition](B004_Kit_Definition.md) | Next wizard step |
| [B006 Store List](B006_Store_List.md) | Store data source |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---

# B004 - Kit Definition

> **SRS Section**: 7.1.4 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Kit Definition screen is the second step in the Campaign Builder wizard. It allows campaign creators to define the promotional materials (kit items) that will be distributed to stores, including item specifications, quantities, and optional placement requirements.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access |
| CAMPAIGN_MANAGER | Full access (for assigned campaigns) |
| REGIONAL_MANAGER | No access |

### 1.3 Navigation Path

- **Route**: `/admin/campaigns/:id/edit/kit`
- **Entry Points**:
  - Campaign Builder Step 1: "Save & Continue" button
  - Campaign Detail: "Edit" action (draft only)
- **Wizard Position**: Step 2 of 3

### 1.4 Screenshot Reference

![Kit Definition](../../screenshots/Admin_Portal/admin_portal_new_campaign_wizard.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| Access kit definition wizard | Y | Y* | N |
| Add kit items | Y | Y | N |
| Edit kit items | Y | Y | N |
| Remove kit items | Y | Y | N |
| Configure photo requirements | Y | Y | N |
| Assign location slots | Y | Y | N |
| Reorder items (drag-drop) | Y | Y | N |
| Save and continue | Y | Y | N |
| Navigate back to stores | Y | Y | N |

**Legend**: Y = Full access | Y* = Only for assigned campaigns | N = No access

### 2.2 Data Scoping Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B004-SEC-001 | Kit definitions SHALL be limited to campaigns within the authenticated user's brand |
| REQ-B004-SEC-002 | Location slots SHALL only display slots from store layouts belonging to the brand |
| REQ-B004-SEC-003 | Kit edits SHALL only be allowed when campaign status = DRAFT |
| REQ-B004-SEC-004 | Photo rules SHALL be configurable only by users with kit management permissions |

---

## 3. UI Components

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│ Create Campaign                                             │
├─────────────────────────────────────────────────────────────┤
│ Step 1: Select Stores  ───✓───────────────────────────────  │
│ Step 2: Define Kit     ───●───────────────────────────────  │
│ Step 3: Review         ────○──────────────────────────────  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Kit Items                                    [+ Add Item]   │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ ≡  1. Summer Poster (24x36)                             │ │
│ │     Type: POSTER  │  Qty: 2  │  Location: FRONT_WINDOW  │ │
│ │     📷 Photo Required: Front view                [Edit] │ │
│ │                                                   [×]   │ │
│ ├─────────────────────────────────────────────────────────┤ │
│ │ ≡  2. Counter Display Stand                             │ │
│ │     Type: COUNTER_DISPLAY  │  Qty: 1  │  Location: --   │ │
│ │     📷 No photo required                         [Edit] │ │
│ │                                                   [×]   │ │
│ ├─────────────────────────────────────────────────────────┤ │
│ │ ≡  3. Window Cling Set                                  │ │
│ │     Type: WINDOW_CLING  │  Qty: 4  │  Location: ENTRY   │ │
│ │     📷 Photo Required: Installed view            [Edit] │ │
│ │                                                   [×]   │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Kit Summary: 3 items, 7 total units                         │
│                                                             │
│ [← Back]                              [Save & Continue →]   │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| Wizard Progress | Stepper | Visual step indicator (2/3) with Step 1 checkmark |
| Kit Items List | Sortable list | Drag-drop reorderable item cards |
| Add Item Button | Primary button | Opens item creation modal |
| Item Card | Card component | Displays item details with edit/delete actions |
| Drag Handle | Icon button | Enables drag-drop reordering |
| Item Edit Modal | Modal dialog | Full item configuration form |
| Kit Summary | Summary bar | Aggregated item/unit counts |
| Navigation Buttons | Button group | Back, Save & Continue |

### 3.3 Kit Item Types

| Item Type | Code | Description |
|-----------|------|-------------|
| Poster | POSTER | Wall-mounted promotional poster |
| Standee | STANDEE | Free-standing display |
| Banner | BANNER | Hanging or mounted banner |
| Shelf Talker | SHELF_TALKER | Shelf-edge promotional tag |
| Window Cling | WINDOW_CLING | Adhesive window decoration |
| Counter Display | COUNTER_DISPLAY | Point-of-sale counter unit |

### 3.4 Location Slot Options

| Slot Code | Display Name | Description |
|-----------|--------------|-------------|
| FRONT_WINDOW | Front Window | Primary storefront window |
| END_CAP_A | End Cap A | First aisle end cap |
| END_CAP_B | End Cap B | Second aisle end cap |
| CHECKOUT | Checkout Area | Near registers |
| ENTRY_DOOR | Entry Door | Store entrance |
| BACK_WALL | Back Wall | Rear wall display area |

### 3.5 Component States

| State | Kit Items List | Add Button | Actions | Navigation |
|-------|----------------|------------|---------|------------|
| Initial | Empty, hint text | Enabled | -- | Back enabled, Continue disabled |
| Has Items | Item cards displayed | Enabled | Edit/Delete visible | Both enabled |
| Editing | Item highlighted | Disabled | Modal open | Disabled |
| Dragging | Drop zones visible | Disabled | Hidden | Disabled |
| Saving | Readonly | Disabled | Disabled | Loading spinner |
| Error | Unchanged | Enabled | Enabled | Retry available |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `kit_definitions` | id, campaign_id, name, is_template | Read/Write |
| `kit_items` | id, kit_definition_id, sku, name, item_type, quantity, sort_order | Read/Write |
| `location_slots` | id, slot_code, name | Read |
| `photo_rules` | id, kit_item_id, min_photos, required_angles[], instructions | Read/Write |
| `campaigns` | id, status | Read |

### 4.2 Kit Item Schema

```json
{
  "id": "uuid",
  "kitDefinitionId": "uuid",
  "name": "Summer Poster (24x36)",
  "sku": "POSTER-SUM-2436",
  "itemType": "POSTER",
  "quantity": 2,
  "locationSlotId": "uuid|null",
  "sortOrder": 1,
  "photoRule": {
    "minPhotos": 1,
    "requiredAngles": ["front"],
    "instructions": "Capture full poster with surrounding context"
  }
}
```

### 4.3 Data Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B004-DATA-001 | Kit definition SHALL be automatically created when campaign is created |
| REQ-B004-DATA-002 | Kit items SHALL maintain sort_order for consistent display ordering |
| REQ-B004-DATA-003 | Location slot assignment SHALL be optional (nullable foreign key) |
| REQ-B004-DATA-004 | Photo rules SHALL be stored as separate entity linked to kit_item |
| REQ-B004-DATA-005 | Item SKU SHALL be auto-generated if not provided (format: {TYPE}-{CAMPAIGN_CODE}-{SEQ}) |

---

## 5. Business Rules & Validation

### 5.1 Kit Item Validation

| REQ-ID | Rule |
|--------|------|
| REQ-B004-BR-001 | Item name SHALL be required (minimum 3 characters, maximum 100 characters) |
| REQ-B004-BR-002 | Item type SHALL be required and selected from predefined enum |
| REQ-B004-BR-003 | Quantity SHALL be required and between 1 and 999 |
| REQ-B004-BR-004 | SKU SHALL be unique within the kit definition |

### 5.2 Kit Definition Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B004-BR-005 | At least one kit item SHALL be required to proceed to Review step |
| REQ-B004-BR-006 | Maximum of 50 kit items SHALL be allowed per campaign |
| REQ-B004-BR-007 | Total unit count (sum of quantities) SHALL be displayed in summary |
| REQ-B004-BR-008 | Item sort order SHALL be preserved when saving |

### 5.3 Photo Rule Configuration

| REQ-ID | Rule |
|--------|------|
| REQ-B004-BR-009 | Photo requirements SHALL be optional per item |
| REQ-B004-BR-010 | When enabled, minimum photos SHALL default to 1 |
| REQ-B004-BR-011 | Required angles SHALL support: front, left, right, top, detail |
| REQ-B004-BR-012 | Photo instructions SHALL be optional free text (max 500 characters) |

### 5.4 Location Slot Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B004-BR-013 | Same location slot MAY be assigned to multiple items |
| REQ-B004-BR-014 | Location slots SHALL only show slots defined in brand's store layouts |
| REQ-B004-BR-015 | Unassigned slot SHALL be valid (item not location-specific) |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/campaigns/{id}/kit` | GET | Get kit definition with items |
| `/api/v1/campaigns/{id}/kit/items` | POST | Add kit item |
| `/api/v1/campaigns/{id}/kit/items/{itemId}` | PATCH | Update kit item |
| `/api/v1/campaigns/{id}/kit/items/{itemId}` | DELETE | Remove kit item |
| `/api/v1/campaigns/{id}/kit/items/reorder` | POST | Update item sort order |
| `/api/v1/location-slots` | GET | List available location slots |

### 6.2 Get Kit Definition Response

```json
// GET /api/v1/campaigns/{id}/kit
{
  "id": "uuid",
  "campaignId": "uuid",
  "name": "Summer Promo 2025 Kit",
  "items": [
    {
      "id": "uuid",
      "name": "Summer Poster (24x36)",
      "sku": "POSTER-SUM-001",
      "itemType": "POSTER",
      "quantity": 2,
      "sortOrder": 1,
      "locationSlot": {
        "id": "uuid",
        "code": "FRONT_WINDOW",
        "name": "Front Window"
      },
      "photoRule": {
        "minPhotos": 1,
        "requiredAngles": ["front"],
        "instructions": "Capture full poster"
      }
    }
  ],
  "summary": {
    "itemCount": 3,
    "totalUnits": 7
  }
}
```

### 6.3 Add Item Request

```json
// POST /api/v1/campaigns/{id}/kit/items
{
  "name": "Counter Display Stand",
  "itemType": "COUNTER_DISPLAY",
  "quantity": 1,
  "locationSlotId": null,
  "photoRule": {
    "enabled": false
  }
}
```

### 6.4 Reorder Items Request

```json
// POST /api/v1/campaigns/{id}/kit/items/reorder
{
  "itemOrder": [
    { "itemId": "uuid1", "sortOrder": 1 },
    { "itemId": "uuid2", "sortOrder": 2 },
    { "itemId": "uuid3", "sortOrder": 3 }
  ]
}
```

### 6.5 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B004-API-001 | Kit endpoints SHALL validate campaign ownership before any operation |
| REQ-B004-API-002 | Add/Update operations SHALL return the complete updated item object |
| REQ-B004-API-003 | Reorder operation SHALL be atomic (all-or-nothing) |
| REQ-B004-API-004 | Delete operation SHALL return 204 No Content on success |

---

## 7. State Transitions

### 7.1 Wizard Navigation State Machine

```
[Step 1: Stores] ←─back─┐
       ↓ save           │
[Step 2: Kit] ──────────┘
       ↓ save
[Step 3: Review] ←─back─ [Step 2: Kit]
```

### 7.2 Item Edit State Machine

```
[List View] → [Add Modal] → [Saving] → [List View]
     ↓              ↓           ↓
[Edit Modal] → [Saving] → [List View]
     ↓
[Delete Confirm] → [Deleting] → [List View]
```

### 7.3 Drag-Drop State Machine

```
[Idle] → [Dragging] → [Over Drop Zone] → [Dropped] → [Reordering] → [Idle]
              ↓                               ↓
          [Cancelled] ──────────────────→ [Idle]
```

### 7.4 Item Card States

| State | Trigger | UI Behavior |
|-------|---------|-------------|
| Default | Normal display | Card with actions visible on hover |
| Hover | Mouse enter | Highlight, show all actions |
| Dragging | Drag start | Elevated shadow, placeholder in list |
| Editing | Edit click | Modal open, card dimmed |
| Deleting | Delete confirm | Fade out animation |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| Duplicate SKU | 422 | "An item with this SKU already exists" | Edit SKU |
| Max items exceeded | 422 | "Maximum of 50 items per campaign" | Remove items |
| Invalid quantity | 422 | "Quantity must be between 1 and 999" | Correct quantity |
| Campaign not draft | 403 | "Cannot modify published campaign" | Return to list |
| Save failed | 500 | "Unable to save item" | Retry |
| Reorder failed | 500 | "Unable to update order" | Refresh list |

### 8.2 Validation Messages

| Field | Validation | Message |
|-------|------------|---------|
| Item Name | Required | "Item name is required" |
| Item Name | Min length | "Name must be at least 3 characters" |
| Item Name | Max length | "Name cannot exceed 100 characters" |
| Item Type | Required | "Select an item type" |
| Quantity | Required | "Quantity is required" |
| Quantity | Range | "Quantity must be between 1 and 999" |
| SKU | Unique | "SKU is already in use" |
| Photo Instructions | Max length | "Instructions cannot exceed 500 characters" |

### 8.3 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B004-ERR-001 | Form validation SHALL occur on blur and on submit |
| REQ-B004-ERR-002 | Modal SHALL remain open on validation error with fields highlighted |
| REQ-B004-ERR-003 | Failed drag-drop SHALL revert to original order |
| REQ-B004-ERR-004 | Network errors SHALL preserve unsaved modal data |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B004-A11Y-001 | Wizard stepper SHALL announce current step and completion status | 1.3.1 Info and Relationships |
| REQ-B004-A11Y-002 | Drag-drop SHALL have keyboard alternative (move up/down buttons) | 2.1.1 Keyboard |
| REQ-B004-A11Y-003 | Item cards SHALL be keyboard navigable with Enter to edit | 2.1.1 Keyboard |
| REQ-B004-A11Y-004 | Modal dialogs SHALL trap focus until dismissed | 2.4.3 Focus Order |
| REQ-B004-A11Y-005 | Delete confirmation SHALL be announced to screen readers | 4.1.3 Status Messages |
| REQ-B004-A11Y-006 | Item type icons SHALL have text alternatives | 1.1.1 Non-text Content |
| REQ-B004-A11Y-007 | Sort order changes SHALL be announced via aria-live | 4.1.3 Status Messages |
| REQ-B004-A11Y-008 | Form errors SHALL move focus to first invalid field | 2.4.3 Focus Order |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B004-FR-001 | User SHALL be able to add kit items with name, type, quantity | Must |
| REQ-B004-FR-002 | User SHALL be able to edit existing kit items | Must |
| REQ-B004-FR-003 | User SHALL be able to delete kit items with confirmation | Must |
| REQ-B004-FR-004 | User SHALL be able to reorder items via drag-drop | Should |
| REQ-B004-FR-005 | User SHALL be able to assign location slots to items | Should |
| REQ-B004-FR-006 | User SHALL be able to configure photo requirements per item | Must |
| REQ-B004-FR-007 | Kit summary SHALL display item count and total units | Must |
| REQ-B004-FR-008 | Save SHALL persist all items and navigate to Review step | Must |
| REQ-B004-FR-009 | Back button SHALL return to Store Selection step | Must |
| REQ-B004-FR-010 | Empty kit SHALL prevent navigation to Review step | Must |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B004-01 | Add first kit item | Item appears in list, summary shows "1 item" |
| TC-B004-02 | Add item with photo requirement | Photo rule saved and displayed |
| TC-B004-03 | Edit existing item | Changes reflected immediately |
| TC-B004-04 | Delete item with confirmation | Item removed, summary updated |
| TC-B004-05 | Drag item to new position | Order updated, sort_order persisted |
| TC-B004-06 | Assign location slot | Slot displayed on item card |
| TC-B004-07 | Add item with duplicate SKU | Validation error shown |
| TC-B004-08 | Attempt to proceed with empty kit | Continue button disabled, message shown |
| TC-B004-09 | Save and continue | Navigate to Review step |
| TC-B004-10 | Keyboard reorder via move buttons | Items reordered without mouse |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B003 Store Selection](B003_Store_Selection.md) | Previous wizard step |
| [B005 Campaign Review](B005_Campaign_Review.md) | Next wizard step |
| [B002 Campaign List](B002_Campaign_List.md) | Cancel destination |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---

# B005 - Campaign Review & Launch

> **SRS Section**: 7.1.5 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Campaign Review screen is the final step in the Campaign Builder wizard. It presents a comprehensive summary of the campaign configuration including selected stores, kit definitions, and scheduling details. Upon approval, the publish action creates store assignments and triggers initial order generation.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access |
| CAMPAIGN_MANAGER | Full access (for assigned campaigns) |
| REGIONAL_MANAGER | No access |

### 1.3 Navigation Path

- **Route**: `/admin/campaigns/:id/edit/review` (wizard step 3)
- **Route**: `/admin/campaigns/:id/review` (standalone review)
- **Entry Points**:
  - Campaign Builder: "Continue" from Kit Definition step
  - Campaign Detail: "Review" action (draft only)
- **Wizard Position**: Step 3 of 3

### 1.4 Screenshot Reference

![Campaign Review](../../screenshots/Admin_Portal/admin_portal_verification.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| Access review screen | Y | Y* | N |
| View campaign summary | Y | Y* | N |
| Edit install dates | Y | Y* | N |
| Modify scheduling | Y | Y* | N |
| Publish campaign | Y | Y* | N |
| Schedule campaign | Y | Y* | N |
| Save as draft | Y | Y* | N |
| Navigate back to edit | Y | Y* | N |

**Legend**: Y = Full access | Y* = Only for assigned campaigns | N = No access

### 2.2 Data Scoping Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B005-SEC-001 | Campaign data SHALL be restricted to the authenticated user's brand_id |
| REQ-B005-SEC-002 | Campaign Manager access SHALL be validated against memberships table |
| REQ-B005-SEC-003 | Publish action SHALL only be available when campaign status = DRAFT |

---

## 3. UI Components

### 3.1 Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│ Create Campaign                                             │
├─────────────────────────────────────────────────────────────┤
│ Step 1: Select Stores  ───────────────────●─────────────    │
│ Step 2: Define Kit     ───────────────────●─────────────    │
│ Step 3: Review         ───────────────────●─────────────    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Campaign Summary                                            │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Campaign Name: Summer Promo 2025                   [✎]  │ │
│ │ Status: Draft                                           │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ ┌───────────────────────┐ ┌───────────────────────┐        │
│ │ 📍 Store Selection    │ │ 📦 Kit Definition     │        │
│ │                       │ │                       │        │
│ │ 234 stores selected   │ │ 5 items defined       │        │
│ │ 3 regions             │ │ 12 total pieces       │        │
│ │ 0 exclusions          │ │ 3 photo requirements  │        │
│ │                       │ │                       │        │
│ │ [View Details]        │ │ [View Details]        │        │
│ └───────────────────────┘ └───────────────────────┘        │
│                                                             │
│ Installation Schedule                                       │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ Install Start *           Install End *                 │ │
│ │ ┌─────────────────┐       ┌─────────────────┐          │ │
│ │ │ 📅 Dec 1, 2025  │       │ 📅 Dec 31, 2025 │          │ │
│ │ └─────────────────┘       └─────────────────┘          │ │
│ │                                                         │ │
│ │ ☑ Allow late installations (extend by 7 days)          │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ Pre-Launch Checklist                                        │
│ ┌─────────────────────────────────────────────────────────┐ │
│ │ ✓ Campaign name defined                                 │ │
│ │ ✓ At least one store selected (234 stores)             │ │
│ │ ✓ Kit items defined (5 items)                          │ │
│ │ ✓ Photo requirements configured                        │ │
│ │ ✓ Install dates set                                    │ │
│ │ ○ All items have SKUs (2 missing)                [Fix] │ │
│ └─────────────────────────────────────────────────────────┘ │
│                                                             │
│ [← Back]         [Save Draft]         [Publish Campaign]    │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| Wizard Progress | Stepper | Visual step indicator (3/3) |
| Campaign Summary Card | Info card | Name, status, quick edit link |
| Store Selection Summary | Summary card | Store count, region breakdown |
| Kit Definition Summary | Summary card | Item count, piece count, photo rules |
| Installation Schedule | Date range picker | Start and end date selection |
| Late Installation Toggle | Checkbox | Optional grace period extension |
| Pre-Launch Checklist | Validation list | Real-time publish readiness |
| Action Buttons | Button group | Back, Save Draft, Publish |

### 3.3 Summary Card Details

#### 3.3.1 Store Selection Summary

| Metric | Source | Display |
|--------|--------|---------|
| Total Stores | Selection recipe evaluation | "234 stores selected" |
| Region Count | Distinct regions in selection | "3 regions" |
| Exclusion Count | Exclusion rules applied | "0 exclusions" |

#### 3.3.2 Kit Definition Summary

| Metric | Source | Display |
|--------|--------|---------|
| Item Count | kit_items.count | "5 items defined" |
| Total Pieces | SUM(kit_items.quantity) | "12 total pieces" |
| Photo Requirements | kit_items with photo_rule_id | "3 photo requirements" |

### 3.4 Pre-Launch Checklist Items

| Item | Validation | Pass Condition |
|------|------------|----------------|
| Campaign name | Required field | name.length >= 3 |
| Store selection | Selection recipe | store_count > 0 |
| Kit items | Kit definition | kit_items.length > 0 |
| Photo requirements | Photo rules | All items with requires_photo have rules |
| Install dates | Date range | install_start < install_end |
| Item SKUs | Optional warning | All items have SKU defined |

### 3.5 Component States

| State | Summary Cards | Schedule | Checklist | Publish Button |
|-------|---------------|----------|-----------|----------------|
| Loading | Skeleton | Skeleton | Skeleton | Disabled |
| Incomplete | Data shown | Editable | Shows failures | Disabled |
| Ready | Data shown | Editable | All passed | Enabled |
| Publishing | Readonly | Readonly | Readonly | Loading spinner |
| Error | Data shown | Editable | Shows failures | Retry enabled |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `campaigns` | id, name, status, install_start, install_end, selection_recipe_json | Read/Write |
| `kit_definitions` | id, campaign_id, name | Read |
| `kit_items` | id, kit_definition_id, sku, quantity, photo_rule_id | Read |
| `stores` | id, region_id (aggregated) | Read |
| `regions` | id, name | Read |
| `store_assignments` | (created on publish) | Write |
| `store_orders` | (created on publish) | Write |

### 4.2 Campaign Summary Query

```sql
SELECT
  c.id,
  c.name,
  c.status,
  c.install_start,
  c.install_end,
  c.selection_recipe_json,
  COUNT(DISTINCT ki.id) as item_count,
  SUM(ki.quantity) as total_pieces,
  COUNT(DISTINCT ki.photo_rule_id) FILTER (WHERE ki.photo_rule_id IS NOT NULL) as photo_rule_count
FROM campaigns c
LEFT JOIN kit_definitions kd ON kd.campaign_id = c.id
LEFT JOIN kit_items ki ON ki.kit_definition_id = kd.id
WHERE c.id = :campaign_id
  AND c.deleted_at IS NULL
GROUP BY c.id;
```

### 4.3 Data Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B005-DATA-001 | Summary data SHALL be fetched in a single optimized query |
| REQ-B005-DATA-002 | Store count SHALL be calculated from selection recipe at query time |
| REQ-B005-DATA-003 | Checklist validation SHALL be performed server-side before publish |
| REQ-B005-DATA-004 | Publish operation SHALL be atomic (all-or-nothing transaction) |

---

## 5. Business Rules & Validation

### 5.1 Date Validation Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B005-BR-001 | Install start date SHALL be required for publish |
| REQ-B005-BR-002 | Install end date SHALL be required for publish |
| REQ-B005-BR-003 | Install start SHALL be >= current date |
| REQ-B005-BR-004 | Install end SHALL be > install start |
| REQ-B005-BR-005 | Date range SHALL not exceed 90 days without admin approval |

### 5.2 Publish Prerequisites

| REQ-ID | Rule |
|--------|------|
| REQ-B005-BR-006 | Campaign name SHALL be at least 3 characters |
| REQ-B005-BR-007 | At least one store SHALL be selected |
| REQ-B005-BR-008 | At least one kit item SHALL be defined |
| REQ-B005-BR-009 | All kit items requiring photos SHALL have photo rules assigned |
| REQ-B005-BR-010 | Campaign status SHALL be DRAFT to allow publish |

### 5.3 Publish Actions

| REQ-ID | Rule |
|--------|------|
| REQ-B005-BR-011 | Publish SHALL create store_assignments for each selected store |
| REQ-B005-BR-012 | Publish SHALL create assignment_items for each kit_item per store |
| REQ-B005-BR-013 | Publish SHALL generate initial store_orders with status GENERATED |
| REQ-B005-BR-014 | Campaign status SHALL transition to SCHEDULED if start_date > today |
| REQ-B005-BR-015 | Campaign status SHALL transition to PUBLISHED if start_date <= today |

### 5.4 Late Installation Option

| REQ-ID | Rule |
|--------|------|
| REQ-B005-BR-016 | Late installation grace period SHALL default to 7 days |
| REQ-B005-BR-017 | Grace period SHALL be configurable at brand level (1-30 days) |
| REQ-B005-BR-018 | Stores MAY submit installations after end_date if grace period enabled |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/campaigns/{id}` | GET | Get campaign with summary |
| `/api/v1/campaigns/{id}` | PATCH | Update install dates |
| `/api/v1/campaigns/{id}/summary` | GET | Get detailed summary |
| `/api/v1/campaigns/{id}/validate` | POST | Validate publish readiness |
| `/api/v1/campaigns/{id}/publish` | POST | Execute publish workflow |

### 6.2 Summary Request

```json
// GET /api/v1/campaigns/{id}/summary
// Response 200 OK
{
  "campaign": {
    "id": "uuid",
    "name": "Summer Promo 2025",
    "status": "DRAFT",
    "installStart": "2025-12-01",
    "installEnd": "2025-12-31",
    "allowLateInstallation": true,
    "gracePeriodDays": 7
  },
  "storeSelection": {
    "totalStores": 234,
    "regions": [
      {"id": "uuid", "name": "Northeast", "storeCount": 156},
      {"id": "uuid", "name": "Midwest", "storeCount": 78}
    ],
    "exclusionCount": 0
  },
  "kitDefinition": {
    "itemCount": 5,
    "totalPieces": 12,
    "photoRequirements": 3,
    "items": [
      {"id": "uuid", "name": "Window Banner", "quantity": 2, "hasSku": true},
      {"id": "uuid", "name": "Counter Display", "quantity": 1, "hasSku": false}
    ]
  },
  "checklist": {
    "campaignName": {"passed": true, "message": "Campaign name defined"},
    "storeSelection": {"passed": true, "message": "234 stores selected"},
    "kitItems": {"passed": true, "message": "5 items defined"},
    "photoRules": {"passed": true, "message": "Photo requirements configured"},
    "installDates": {"passed": true, "message": "Install dates set"},
    "itemSkus": {"passed": false, "message": "2 items missing SKUs", "fixable": true}
  },
  "readyToPublish": false
}
```

### 6.3 Validate Request

```json
// POST /api/v1/campaigns/{id}/validate
// Response 200 OK
{
  "valid": false,
  "errors": [
    {
      "code": "MISSING_SKU",
      "field": "kit_items",
      "message": "2 items are missing SKUs",
      "itemIds": ["uuid1", "uuid2"]
    }
  ],
  "warnings": [
    {
      "code": "LARGE_CAMPAIGN",
      "message": "This campaign will create 234 store assignments"
    }
  ]
}
```

### 6.4 Publish Request

```json
// POST /api/v1/campaigns/{id}/publish
{
  "installStart": "2025-12-01",
  "installEnd": "2025-12-31",
  "allowLateInstallation": true,
  "gracePeriodDays": 7,
  "notifyStores": true
}
```

### 6.5 Publish Response

```json
// Response 200 OK
{
  "campaign": {
    "id": "uuid",
    "status": "SCHEDULED",
    "publishedAt": "2025-11-15T10:30:00Z",
    "publishedBy": "uuid"
  },
  "assignments": {
    "created": 234,
    "storeOrders": 234
  },
  "notifications": {
    "scheduled": 234,
    "method": "email"
  }
}
```

### 6.6 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B005-API-001 | Publish endpoint SHALL complete within 30 seconds for up to 10,000 stores |
| REQ-B005-API-002 | Publish SHALL use background job for >1,000 stores |
| REQ-B005-API-003 | Publish progress SHALL be trackable via SSE or polling |
| REQ-B005-API-004 | Failed publish SHALL rollback all created records |
| REQ-B005-API-005 | Publish SHALL emit webhook event to registered endpoints |

---

## 7. State Transitions

### 7.1 Campaign Status Transition (Publish)

```
                                  publish (start > today)
[DRAFT] ────────────────────────────────────────────────→ [SCHEDULED]
    │                                                          │
    │ publish (start <= today)                    start_date   │
    └─────────────────→ [PUBLISHED] ←──────────────────────────┘
```

### 7.2 Wizard Navigation State Machine

```
[Step 1: Stores] ←───────back───────── [Step 2: Kit]
                                              │
                                              │ continue
                                              ↓
                           [Step 3: Review]
                                  │
                    ┌─────────────┼─────────────┐
                    ↓             ↓             ↓
              [Save Draft]   [Publish]    [Back to Kit]
                    │             │
                    ↓             ↓
            [Campaign List]  [Campaign Detail]
```

### 7.3 Publish State Machine

```
[Ready] → [Validating] → [Publishing] → [Success] → [Redirect]
              │                │
              ↓                ↓
          [Invalid]        [Failed]
              │                │
              ↓                ↓
          [Fix Issues]    [Retry]
```

### 7.4 UI State Transitions

| State | Trigger | Next State |
|-------|---------|------------|
| Loading | Page mount | Ready / Error |
| Ready | All validations pass | Ready |
| Invalid | Validation failure | Invalid (show errors) |
| Validating | Publish clicked | Publishing / Invalid |
| Publishing | Validation passed | Success / Failed |
| Success | Publish complete | Redirect to detail |
| Failed | Publish error | Failed (retry enabled) |

---

## 8. Error Handling

### 8.1 Validation Errors

| Error | Display Location | User Message |
|-------|------------------|--------------|
| Missing campaign name | Checklist + inline | "Campaign name is required" |
| No stores selected | Checklist | "Add at least one store to publish" |
| No kit items | Checklist | "Add at least one kit item" |
| Missing photo rules | Checklist | "Configure photo requirements for all items" |
| Invalid dates | Date inputs | "Install end must be after start date" |
| Past start date | Date input | "Start date must be today or later" |

### 8.2 Publish Errors

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| Validation failed | 422 | "Please fix the issues in the checklist" | Show validation errors |
| Concurrent edit | 409 | "Campaign was modified. Please refresh." | Refresh page |
| Publish timeout | 504 | "Publishing is taking longer than expected" | Show progress / retry |
| Order generation failed | 500 | "Unable to create store orders" | Contact support |
| Partial failure | 207 | "Some assignments could not be created" | Show failure details |

### 8.3 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B005-ERR-001 | Validation errors SHALL be displayed inline in the checklist |
| REQ-B005-ERR-002 | Publish failures SHALL preserve all form data |
| REQ-B005-ERR-003 | Partial failures SHALL allow retry for failed items only |
| REQ-B005-ERR-004 | Error messages SHALL include actionable next steps |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B005-A11Y-001 | Wizard stepper SHALL announce "Step 3 of 3: Review" to screen readers | 1.3.1 Info and Relationships |
| REQ-B005-A11Y-002 | Summary cards SHALL be navigable with keyboard (Tab) | 2.1.1 Keyboard |
| REQ-B005-A11Y-003 | Date pickers SHALL support keyboard date entry | 2.1.1 Keyboard |
| REQ-B005-A11Y-004 | Checklist status SHALL be announced (passed/failed) | 4.1.3 Status Messages |
| REQ-B005-A11Y-005 | Publish button state change SHALL be announced | 4.1.2 Name, Role, Value |
| REQ-B005-A11Y-006 | Publishing progress SHALL be announced via aria-live | 4.1.3 Status Messages |
| REQ-B005-A11Y-007 | Validation errors SHALL receive focus on submit | 2.4.3 Focus Order |
| REQ-B005-A11Y-008 | Color indicators SHALL have text alternatives | 1.4.1 Use of Color |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B005-FR-001 | User SHALL see campaign summary with store and kit counts | Must |
| REQ-B005-FR-002 | User SHALL be able to set install start and end dates | Must |
| REQ-B005-FR-003 | User SHALL see pre-launch validation checklist | Must |
| REQ-B005-FR-004 | Publish button SHALL be disabled until all required validations pass | Must |
| REQ-B005-FR-005 | Publish action SHALL create store_assignments for all selected stores | Must |
| REQ-B005-FR-006 | Publish action SHALL generate initial store_orders | Must |
| REQ-B005-FR-007 | User SHALL be able to navigate back to previous wizard steps | Must |
| REQ-B005-FR-008 | User SHALL be able to save as draft without publishing | Should |
| REQ-B005-FR-009 | User SHALL see publish progress for large campaigns | Should |
| REQ-B005-FR-010 | User SHALL be redirected to campaign detail after successful publish | Must |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B005-01 | View campaign summary | All sections display correct counts |
| TC-B005-02 | Set valid install date range | Dates accepted, checklist updated |
| TC-B005-03 | Set invalid date range (end < start) | Error displayed, publish disabled |
| TC-B005-04 | Publish with all validations passed | Campaign publishes, redirects to detail |
| TC-B005-05 | Publish with missing photo rules | Validation error, publish blocked |
| TC-B005-06 | Navigate back to Kit Definition | Previous step loads with data intact |
| TC-B005-07 | Save as draft | Campaign saved, status remains DRAFT |
| TC-B005-08 | Publish large campaign (1000+ stores) | Progress indicator shown, completes |
| TC-B005-09 | Network failure during publish | Error shown, retry available |
| TC-B005-10 | Keyboard navigation through review | All elements accessible via keyboard |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B002 Campaign List](B002_Campaign_List.md) | Post-publish destination option |
| [B003 Store Selection](B003_Store_Selection.md) | Wizard Step 1, back navigation |
| [B004 Kit Definition](B004_Kit_Definition.md) | Wizard Step 2, back navigation |
| [B006 Store List](B006_Store_List.md) | Store assignment destination |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---

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
[ONBOARDING] ──accept invitation──> [ACTIVE]
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


---

# B007 - Photo Verification Queue

> **SRS Section**: 7.1.7 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Photo Verification Queue provides brand administrators with a streamlined interface for reviewing store-submitted installation photos. It enables efficient approval or rejection of photos, management of retake requests, and tracking of verification progress across campaigns.

### 1.2 Access Control

| Role | Access Level |
|------|--------------|
| BRAND_ADMIN | Full access (all photos) |
| CAMPAIGN_MANAGER | Full access (photos for assigned campaigns) |
| REGIONAL_MANAGER | Read-only (photos for stores in assigned regions) |

### 1.3 Navigation Path

- **Route**: `/admin/verification`
- **Route**: `/admin/verification?campaign={id}` (campaign-filtered)
- **Entry Points**:
  - Main navigation: "Verification" menu item
  - Dashboard: "Pending Reviews" KPI click-through
  - Campaign Detail: "Review Photos" action

### 1.4 Screenshot Reference

![Verification Queue](../../screenshots/Admin_Portal/admin_portal_verification.png)

---

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix

| Capability | BRAND_ADMIN | CAMPAIGN_MANAGER | REGIONAL_MANAGER |
|------------|:-----------:|:----------------:|:----------------:|
| View all pending photos | Y | N | N |
| View scoped pending photos | Y | Y* | Y* |
| Approve photo | Y | Y* | N |
| Reject photo | Y | Y* | N |
| Request retake | Y | Y* | N |
| Add review comment | Y | Y* | Y* |
| View review history | Y | Y* | Y* |
| Bulk approve/reject | Y | Y* | N |
| Export verification report | Y | Y* | Y* |
| Override previous decision | Y | N | N |

**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Data Scoping Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B007-SEC-001 | Photo queue SHALL be filtered by authenticated user's brand_id |
| REQ-B007-SEC-002 | Campaign Managers SHALL only see photos for campaigns in their memberships |
| REQ-B007-SEC-003 | Regional Managers SHALL only see photos from stores in their region_scope_id |
| REQ-B007-SEC-004 | All review decisions SHALL be logged with reviewer_id and timestamp |

---

## 3. UI Components

### 3.1 Layout Structure

```
+-------------------------------------------------------------+
| Photo Verification                      Pending: 23          |
+-------------------------------------------------------------+
| [All] [Pending] [Approved] [Rejected] [Retake Requested]    |
+-------------------------------------------------------------+
| Campaign [All Campaigns v]  Store [All Stores v]  [Export]   |
+-------------------------------------------------------------+
|                                                              |
| +-------------------+  +-------------------+                 |
| | [Photo]           |  | [Photo]           |                 |
| |                   |  |                   |                 |
| | Store #1234       |  | Store #5678       |                 |
| | Summer Promo      |  | Summer Promo      |                 |
| | Window Banner     |  | Counter Display   |                 |
| | Submitted 2h ago  |  | Submitted 1h ago  |                 |
| |                   |  |                   |                 |
| | [Approve] [Reject]|  | [Approve] [Reject]|                 |
| +-------------------+  +-------------------+                 |
|                                                              |
| +-------------------+  +-------------------+                 |
| | [Photo]           |  | [Photo]           |                 |
| |                   |  |                   |                 |
| | Store #9012       |  | Store #3456       |                 |
| | Holiday Display   |  | Summer Promo      |                 |
| | End Cap A         |  | Entry Door        |                 |
| | Submitted 30m ago |  | Submitted 15m ago |                 |
| |                   |  |                   |                 |
| | [Approve] [Reject]|  | [Approve] [Reject]|                 |
| +-------------------+  +-------------------+                 |
|                                                              |
+-------------------------------------------------------------+
| Showing 1-20 of 23 pending       [<] [1] [2] [>]            |
+-------------------------------------------------------------+
```

### 3.2 Component Specifications

| Component | Type | Description |
|-----------|------|-------------|
| Page Header | Header bar | Title + pending count badge |
| Status Tabs | Tab bar | Filter by review status |
| Campaign Filter | Dropdown | Filter by campaign |
| Store Filter | Dropdown | Filter by store |
| Photo Grid | Card grid | Responsive photo card layout |
| Photo Card | Interactive card | Photo, metadata, actions |
| Photo Viewer | Modal | Full-size photo with zoom |
| Bulk Select | Checkbox overlay | Enable bulk actions |
| Bulk Action Bar | Toolbar | Approve/Reject selected |
| Pagination | Page controls | Navigate result pages |

### 3.3 Status Tab Definitions

| Tab | Filter Criteria | Badge Count |
|-----|-----------------|-------------|
| All | No status filter | Total count |
| Pending | `review_status = 'PENDING'` | Pending count |
| Approved | `review_status = 'APPROVED'` | Approved count |
| Rejected | `review_status = 'REJECTED'` | Rejected count |
| Retake Requested | Has active retake_request | Retake count |

### 3.4 Photo Review Status Badges

| Status | Color | Icon | Description |
|--------|-------|------|-------------|
| PENDING | Yellow | Clock | Awaiting review |
| APPROVED | Green | Checkmark | Verified correct |
| REJECTED | Red | X | Does not meet requirements |
| SUPERSEDED | Gray | Archive | Replaced by newer submission |

### 3.5 Photo Card Information

| Field | Source | Display |
|-------|--------|---------|
| Photo Thumbnail | S3 presigned URL | 200x200 crop |
| Store Number | stores.store_number | "#1234" |
| Campaign Name | campaigns.name | "Summer Promo" |
| Item Name | kit_items.name | "Window Banner" |
| Location Slot | location_slots.slot_code | "Front Window" |
| Submitted Time | photo_uploads.created_at | Relative time |
| Submission Count | photo_uploads count for item | "Attempt 2" |

### 3.6 Photo Card Actions

| Action | Visibility | Effect |
|--------|------------|--------|
| Approve | `status = 'PENDING'` | Mark as approved |
| Reject | `status = 'PENDING'` | Open rejection dialog |
| View Full Size | Always | Open photo modal |
| View History | Has previous reviews | Show review timeline |
| Override | `status != 'PENDING'` AND BRAND_ADMIN | Change previous decision |

### 3.7 Rejection Reason Codes

| Code | Display Text | Description |
|------|--------------|-------------|
| WRONG_ANGLE | Wrong Angle | Photo taken from incorrect perspective |
| TOO_DARK | Too Dark | Insufficient lighting |
| BLURRY | Blurry/Out of Focus | Image quality issue |
| WRONG_ITEM | Wrong Item Shown | Incorrect POP material |
| INCOMPLETE | Incomplete Installation | Installation not finished |
| OBSTRUCTED | View Obstructed | Item blocked by objects |
| OTHER | Other | Custom reason required |

### 3.8 Component States

| State | Photo Grid | Bulk Actions | Filters | Pagination |
|-------|------------|--------------|---------|------------|
| Loading | Skeleton cards | Hidden | Disabled | Hidden |
| Empty | Empty state message | Hidden | Enabled | Hidden |
| Loaded | Photo cards | Hidden | Enabled | Visible |
| Selecting | Checkbox overlays | Visible | Enabled | Visible |
| Processing | Cards disabled | Loading | Disabled | Disabled |
| Error | Error message | Hidden | Enabled | Hidden |

---

## 4. Data Requirements

### 4.1 Entities & Fields

| Entity | Fields Used | Access |
|--------|-------------|--------|
| `photo_uploads` | id, s3_key, review_status, created_at, assignment_item_id | Read/Write |
| `photo_reviews` | id, photo_id, decision, reason_code, comment, reviewer_id, created_at | Write |
| `retake_requests` | id, photo_id, reason, resolved_at | Read/Write |
| `assignment_items` | id, assignment_id, kit_item_id, slot_id | Read |
| `store_assignments` | id, campaign_id, store_id | Read |
| `kit_items` | id, name | Read |
| `location_slots` | id, slot_code | Read |
| `stores` | id, store_number | Read |
| `campaigns` | id, name | Read |

### 4.2 Queue Query Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B007-DATA-001 | Photo queue SHALL return paginated results with default page size of 20 |
| REQ-B007-DATA-002 | Photos SHALL be ordered by created_at DESC (newest first) by default |
| REQ-B007-DATA-003 | Photo thumbnails SHALL use optimized S3 presigned URLs with 1-hour expiry |
| REQ-B007-DATA-004 | Campaign filter SHALL only show campaigns with pending photos |
| REQ-B007-DATA-005 | Store filter SHALL only show stores with photos in current filter |

### 4.3 Photo URL Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B007-DATA-006 | Thumbnail URLs SHALL use CloudFront for CDN delivery |
| REQ-B007-DATA-007 | Full-size photo URLs SHALL be generated on-demand |
| REQ-B007-DATA-008 | URLs SHALL be signed to prevent unauthorized access |

---

## 5. Business Rules & Validation

### 5.1 Review Decision Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B007-BR-001 | Each photo SHALL have exactly one active review decision |
| REQ-B007-BR-002 | REJECTED photos SHALL require a reason_code |
| REQ-B007-BR-003 | OTHER rejection reason SHALL require a custom comment |
| REQ-B007-BR-004 | Review decisions SHALL be immutable except for BRAND_ADMIN override |

### 5.2 Retake Request Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B007-BR-005 | Rejection SHALL automatically create a retake_request |
| REQ-B007-BR-006 | Retake requests SHALL trigger store notification |
| REQ-B007-BR-007 | New photo submission SHALL supersede previous REJECTED photo |
| REQ-B007-BR-008 | Maximum retake attempts SHALL be configurable at brand level (default: 3) |

### 5.3 Assignment Completion Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B007-BR-009 | Assignment item SHALL be marked COMPLETE when photo is APPROVED |
| REQ-B007-BR-010 | All assignment items APPROVED SHALL mark assignment as SUBMITTED_VERIFIED |
| REQ-B007-BR-011 | Any REJECTED photo SHALL keep assignment in IN_PROGRESS or REWORK_REQUIRED |

### 5.4 Bulk Operation Rules

| REQ-ID | Rule |
|--------|------|
| REQ-B007-BR-012 | Bulk approve SHALL be limited to 50 photos per operation |
| REQ-B007-BR-013 | Bulk reject SHALL require single reason_code for all selections |
| REQ-B007-BR-014 | Bulk operations SHALL display confirmation with count |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/photos` | GET | List photos with filters |
| `/api/v1/photos/{id}` | GET | Get photo details |
| `/api/v1/photos/{id}/review` | POST | Submit review decision |
| `/api/v1/photos/{id}/override` | POST | Override previous decision |
| `/api/v1/photos/bulk/approve` | POST | Bulk approve photos |
| `/api/v1/photos/bulk/reject` | POST | Bulk reject photos |
| `/api/v1/photos/pending/count` | GET | Get pending count |
| `/api/v1/photos/export` | POST | Export verification report |

### 6.2 List Request Parameters

```
GET /api/v1/photos
  ?status=PENDING
  &campaign_id=uuid
  &store_id=uuid
  &sort=-created_at
  &page=1
  &limit=20
```

### 6.3 List Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "thumbnailUrl": "https://cdn.example.com/photos/thumb/...",
      "fullSizeUrl": "https://cdn.example.com/photos/full/...",
      "reviewStatus": "PENDING",
      "createdAt": "2025-12-15T14:30:00Z",
      "submissionNumber": 1,
      "store": {
        "id": "uuid",
        "storeNumber": "1234"
      },
      "campaign": {
        "id": "uuid",
        "name": "Summer Promo 2025"
      },
      "kitItem": {
        "id": "uuid",
        "name": "Window Banner"
      },
      "locationSlot": {
        "id": "uuid",
        "slotCode": "FRONT_WINDOW",
        "displayName": "Front Window"
      },
      "assignmentItem": {
        "id": "uuid",
        "status": "SUBMITTED"
      }
    }
  ],
  "meta": {
    "total": 23,
    "page": 1,
    "limit": 20,
    "totalPages": 2
  },
  "statusCounts": {
    "PENDING": 23,
    "APPROVED": 456,
    "REJECTED": 34,
    "SUPERSEDED": 12
  }
}
```

### 6.4 Review Request

```json
// POST /api/v1/photos/{id}/review
{
  "decision": "REJECTED",
  "reasonCode": "WRONG_ANGLE",
  "comment": "Please retake photo from the front of the store"
}
```

### 6.5 Review Response

```json
{
  "photoReview": {
    "id": "uuid",
    "photoId": "uuid",
    "decision": "REJECTED",
    "reasonCode": "WRONG_ANGLE",
    "comment": "Please retake photo from the front of the store",
    "reviewerId": "uuid",
    "createdAt": "2025-12-15T15:00:00Z"
  },
  "retakeRequest": {
    "id": "uuid",
    "photoId": "uuid",
    "reason": "WRONG_ANGLE",
    "createdAt": "2025-12-15T15:00:00Z"
  },
  "notification": {
    "sent": true,
    "method": "push",
    "recipient": "store_manager@store1234.com"
  }
}
```

### 6.6 Bulk Approve Request

```json
// POST /api/v1/photos/bulk/approve
{
  "photoIds": ["uuid1", "uuid2", "uuid3"],
  "comment": "Batch approval for verified installations"
}
```

### 6.7 Bulk Reject Request

```json
// POST /api/v1/photos/bulk/reject
{
  "photoIds": ["uuid1", "uuid2"],
  "reasonCode": "TOO_DARK",
  "comment": "Please retake with better lighting"
}
```

### 6.8 API Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B007-API-001 | Photo list SHALL respond within 500ms for up to 1,000 photos |
| REQ-B007-API-002 | Review decision SHALL be processed within 100ms |
| REQ-B007-API-003 | Bulk operations SHALL return individual success/failure status |
| REQ-B007-API-004 | Photo URLs SHALL be cached for 1 hour |
| REQ-B007-API-005 | Review SHALL emit webhook event for integrations |

---

## 7. State Transitions

### 7.1 Photo Review Status State Machine

```
[PENDING] ──approve──> [APPROVED]
    │
    │ reject
    v
[REJECTED] ──new submission──> [SUPERSEDED]
                                     │
                                     │ new photo
                                     v
                                [PENDING]
```

### 7.2 Photo Review Transitions

| From | To | Trigger | Conditions |
|------|-----|---------|------------|
| PENDING | APPROVED | Review decision | Valid reviewer permissions |
| PENDING | REJECTED | Review decision | Reason code required |
| REJECTED | SUPERSEDED | New photo uploaded | Same assignment_item_id |
| APPROVED | REJECTED | Override | BRAND_ADMIN only |
| REJECTED | APPROVED | Override | BRAND_ADMIN only |

### 7.3 Assignment Item Status Updates

```
[Photo APPROVED] --> assignment_item.status = 'COMPLETE'
                          │
                          v (if all items complete)
                     assignment.status = 'SUBMITTED'
                          │
                          v (if all photos verified)
                     assignment.status = 'COMPLETE'
```

### 7.4 UI State Machine

```
[Loading] --> [Loaded] --> [Selecting] --> [Processing]
    |             |                              |
    v             v                              v
 [Error]     [Filtering]                    [Loaded]
                  |
                  v
              [Loaded]
```

### 7.5 Photo Modal States

| State | Trigger | UI Behavior |
|-------|---------|-------------|
| Loading | Card click | Show loading spinner |
| Viewing | Image loaded | Display full-size photo |
| Zooming | Zoom control | Enable pan/zoom |
| Reviewing | Action clicked | Show decision form |
| Submitting | Form submitted | Show loading state |
| Complete | Decision saved | Close modal, update card |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error | HTTP Code | User Message | Recovery Action |
|-------|-----------|--------------|-----------------|
| List fetch failed | 500 | "Unable to load photos" | Retry button |
| Photo load failed | 404 | "Photo no longer available" | Remove from grid |
| Review failed | 422 | "Unable to save review" | Retry |
| Already reviewed | 409 | "Photo was reviewed by another user" | Refresh |
| Permission denied | 403 | "You don't have permission to review" | Contact admin |
| Bulk partial failure | 207 | "X of Y photos reviewed" | Show failures |

### 8.2 Validation Messages

| Field | Validation | Message |
|-------|------------|---------|
| Rejection Reason | Required | "Select a reason for rejection" |
| Custom Comment | Required for OTHER | "Provide a comment for 'Other' reason" |
| Photo Selection | Exceeds limit | "Maximum 50 photos can be selected" |

### 8.3 Error Requirements

| REQ-ID | Requirement |
|--------|-------------|
| REQ-B007-ERR-001 | Concurrent review conflicts SHALL refresh photo status |
| REQ-B007-ERR-002 | Failed bulk operations SHALL report individual failures |
| REQ-B007-ERR-003 | Image load failures SHALL show placeholder with retry |

---

## 9. Accessibility Requirements

| REQ-ID | Requirement | WCAG Criterion |
|--------|-------------|----------------|
| REQ-B007-A11Y-001 | Photo grid SHALL use proper grid ARIA roles | 1.3.1 Info and Relationships |
| REQ-B007-A11Y-002 | Photo cards SHALL be keyboard navigable with arrow keys | 2.1.1 Keyboard |
| REQ-B007-A11Y-003 | Photos SHALL have alt text describing content | 1.1.1 Non-text Content |
| REQ-B007-A11Y-004 | Status badges SHALL have text alternatives | 1.4.1 Use of Color |
| REQ-B007-A11Y-005 | Photo modal SHALL trap focus when open | 2.4.3 Focus Order |
| REQ-B007-A11Y-006 | Escape key SHALL close photo modal | 2.1.1 Keyboard |
| REQ-B007-A11Y-007 | Approval/rejection SHALL announce result | 4.1.3 Status Messages |
| REQ-B007-A11Y-008 | Pending count changes SHALL be announced | 4.1.3 Status Messages |
| REQ-B007-A11Y-009 | Rejection reason selector SHALL be keyboard accessible | 2.1.1 Keyboard |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| REQ-ID | Criterion | Priority |
|--------|-----------|----------|
| REQ-B007-FR-001 | User SHALL see pending photos in card grid layout | Must |
| REQ-B007-FR-002 | User SHALL be able to filter by status | Must |
| REQ-B007-FR-003 | User SHALL be able to filter by campaign | Must |
| REQ-B007-FR-004 | User SHALL be able to filter by store | Should |
| REQ-B007-FR-005 | User SHALL be able to approve photos | Must |
| REQ-B007-FR-006 | User SHALL be able to reject photos with reason | Must |
| REQ-B007-FR-007 | Rejection SHALL trigger retake request | Must |
| REQ-B007-FR-008 | User SHALL be able to view full-size photo | Must |
| REQ-B007-FR-009 | User SHALL be able to bulk approve photos | Should |
| REQ-B007-FR-010 | User SHALL be able to bulk reject photos | Should |
| REQ-B007-FR-011 | Pending count SHALL update in real-time | Should |
| REQ-B007-FR-012 | Export SHALL generate verification report | Should |

### 10.2 Test Scenarios

| Test ID | Scenario | Expected Result |
|---------|----------|-----------------|
| TC-B007-01 | View pending photos | All pending photos displayed in grid |
| TC-B007-02 | Filter by campaign | Only photos for selected campaign shown |
| TC-B007-03 | Approve photo | Photo marked approved, removed from pending |
| TC-B007-04 | Reject photo with reason | Photo rejected, retake request created |
| TC-B007-05 | Reject with OTHER reason | Custom comment required |
| TC-B007-06 | View full-size photo | Modal opens with zoomable image |
| TC-B007-07 | Bulk select and approve | All selected photos approved |
| TC-B007-08 | Bulk reject exceeds limit | Error: maximum 50 photos |
| TC-B007-09 | Concurrent review conflict | Refresh notification shown |
| TC-B007-10 | Keyboard navigate grid | All cards accessible via keyboard |
| TC-B007-11 | Store resubmits after rejection | New photo in queue, old superseded |
| TC-B007-12 | Export verification report | CSV/PDF downloaded |

---

## 11. Related Screens

| Screen | Relationship |
|--------|--------------|
| [B001 Dashboard](B001_Dashboard.md) | KPI click-through destination |
| [B002 Campaign List](B002_Campaign_List.md) | Campaign filter source |
| S005 Photo Upload | Store-side photo submission |
| S006 Retake Notification | Store retake request display |

---

## 12. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial specification |

---

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*

