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
[PENDING] â”€â”€approveâ”€â”€> [APPROVED]
    â”‚
    â”‚ reject
    v
[REJECTED] â”€â”€new submissionâ”€â”€> [SUPERSEDED]
                                     â”‚
                                     â”‚ new photo
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
                          â”‚
                          v (if all items complete)
                     assignment.status = 'SUBMITTED'
                          â”‚
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
