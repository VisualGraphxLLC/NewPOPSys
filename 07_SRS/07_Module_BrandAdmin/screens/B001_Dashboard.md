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
