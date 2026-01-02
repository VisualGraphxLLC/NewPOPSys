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
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Campaigns                              [+ New Campaign]     â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ [All] [Active] [Completed] [Draft] [Archived]               â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ ðŸ” Search campaigns...          [Filter â–¼]  [Export â–¼]      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ â–¡ Campaign Name      Status    Stores  Progress   Actions   â”‚
â”‚ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ â”‚
â”‚ â–¡ Summer Promo 2025  â—Active   234     â–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘ 80%  [â€¢â€¢â€¢]   â”‚
â”‚ â–¡ Holiday Display    â—‹Draft     --     --          [â€¢â€¢â€¢]   â”‚
â”‚ â–¡ Q4 End Caps        â—Active   156     â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 100% [â€¢â€¢â€¢]   â”‚
â”‚ â–¡ Back to School     âœ“Complete 892     â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 100% [â€¢â€¢â€¢]   â”‚
â”‚ â–¡ Spring Refresh     â—‹Draft     --     --          [â€¢â€¢â€¢]   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ Showing 1-5 of 47              [<] [1] [2] [3] [>]         â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
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
| DRAFT | Gray | â—‹ | Campaign in creation |
| SCHEDULED | Blue | â— | Published, awaiting start date |
| PUBLISHED | Green | â— | Active campaign |
| COMPLETED | Green | âœ“ | All stores finished |
| CANCELLED | Red | âœ• | Terminated early |
| ARCHIVED | Gray | â–¢ | Historical record |

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
| REQ-B002-BR-001 | DRAFT â†’ PUBLISHED requires at least one store assignment |
| REQ-B002-BR-002 | DRAFT â†’ PUBLISHED requires at least one kit item defined |
| REQ-B002-BR-003 | PUBLISHED â†’ COMPLETED requires all store_assignments to be COMPLETE or WAIVED |
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
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”    publish     â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  DRAFT  â”‚ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â†’ â”‚ SCHEDULED â”‚
â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜                â””â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜
     â”‚                           â”‚ start_date reached
     â”‚ delete                    â†“
     â†“                     â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    complete    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
  [Deleted]                â”‚ PUBLISHED â”‚ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â†’ â”‚ COMPLETED â”‚
                           â””â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜                â””â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜
                                 â”‚                             â”‚
                                 â”‚ cancel                      â”‚ archive
                                 â†“                             â†“
                           â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    archive     â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                           â”‚ CANCELLED â”‚ â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â†’ â”‚ ARCHIVED  â”‚
                           â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
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
