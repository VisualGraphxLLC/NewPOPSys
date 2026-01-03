# S002 - Campaign History Screen Specification

> **Module**: StorePortal
> **Screen ID**: S002
> **Route**: `/store/campaigns`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

---

## 1. Screen Overview

### 1.1 Purpose

The Campaign History screen provides store personnel with a comprehensive view of all campaign assignments, both active and completed. Users can filter by status, view detailed campaign information, track execution progress, and access historical campaign data for compliance and audit purposes.

### 1.2 Screenshot Reference

![Store Portal Campaigns](../../screenshots/Store_Manager_Portal/manager_campaigns.png)

### 1.3 Source References

| Document | Section |
|----------|---------|
| SUPP-001 | Persona Workflows - Store Level |
| Screen Spec | SOW/06_Screen_Specs/S02_Campaign_History.md |
| Database Model | Section 3.1 - Campaign & Assignment Tables |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Persona ID |
|------|--------------|------------|
| STORE_MANAGER | Full Access | P07 |
| STORE_OPERATOR | View + Execute | P08 |

### 2.2 Role-Based Capabilities

| Capability | STORE_MANAGER | STORE_OPERATOR |
|------------|---------------|----------------|
| View all store campaigns | Yes | Yes (assigned only) |
| View campaign details | Yes | Yes |
| Export campaign list | Yes | No |
| View all team submissions | Yes | Own submissions only |
| Access campaign analytics | Yes | No |

### 2.3 Permission Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-SEC-001 | User must have active store membership | Must |
| REQ-S002-SEC-002 | Campaign list scoped to user's assigned store | Must |
| REQ-S002-SEC-003 | STORE_OPERATOR limited to assigned campaigns only | Should |
| REQ-S002-SEC-004 | Export functionality restricted to STORE_MANAGER | Must |

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Component Name | Type | Description |
|--------------|----------------|------|-------------|
| S002-C001 | Page Header | Header | "Campaigns" with filter controls |
| S002-C002 | Status Tabs | Tab Bar | Active, Completed, All filters |
| S002-C003 | Campaign List | Data Table | Sortable campaign entries |
| S002-C004 | Search Bar | Input | Campaign name/ID search |
| S002-C005 | Detail Panel | Slide Panel | Expandable campaign details |
| S002-C006 | Phase Badge | Status Badge | StorePhase indicator |
| S002-C007 | Progress Bar | Progress | Visual completion indicator |
| S002-C008 | Export Button | Button | CSV download trigger |
| S002-C009 | Empty State | Message | No campaigns message |

### 3.2 Layout Structure


![Campaign History](../../screenshots/Store_Portal/store_portal_campaigns.png)


### 3.3 Component Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-UI-001 | Campaign list supports column sorting | Must |
| REQ-S002-UI-002 | Status tabs filter list dynamically without page reload | Must |
| REQ-S002-UI-003 | Detail panel slides in from right on row click | Must |
| REQ-S002-UI-004 | Progress bar reflects actual task completion percentage | Must |
| REQ-S002-UI-005 | Search filters by campaign name or external ID | Should |
| REQ-S002-UI-006 | List displays 20 items per page with pagination | Must |

---

## 4. Data Requirements

### 4.1 Entity Dependencies

| Entity | Table Name | Fields Required | Relationship |
|--------|------------|-----------------|--------------|
| StoreAssignment | store_assignments | id, campaign_id, store_id, status, pinned_layout_id, completed_at | Primary |
| Campaign | campaigns | id, name, code, install_start, install_end, status | Many-to-One |
| AssignmentItem | assignment_items | id, assignment_id, kit_item_id, slot_id | One-to-Many |
| KitItem | kit_items | id, name, sku, quantity | Via AssignmentItem |
| PhotoUpload | photo_uploads | id, assignment_item_id, review_status | Via AssignmentItem |
| ReceiveVerification | receive_verifications | id, assignment_id, verified_at | One-to-One |
| CompletionAttestation | completion_attestations | id, assignment_id, attested_by | One-to-One |

### 4.2 Data Query Specification


![Campaign History](../../screenshots/Store_Portal/store_portal_campaigns.png)


### 4.3 Data Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-DATA-001 | Campaigns ordered by install_end date descending | Must |
| REQ-S002-DATA-002 | Include item counts and photo statistics per assignment | Must |
| REQ-S002-DATA-003 | Soft-deleted records excluded from all queries | Must |
| REQ-S002-DATA-004 | Completed campaigns retained for 2 years | Should |

---

## 5. Business Rules & Validation

### 5.1 Status Tab Filtering

| Tab | Filter Condition | StorePhase Values Included |
|-----|------------------|---------------------------|
| Active | status NOT IN ('COMPLETE', 'WAIVED') | AWAITING_SHIPMENT, SHIPMENT_IN_TRANSIT, READY_TO_RECEIVE, RECEIVING, READY_TO_INSTALL, INSTALLING, PENDING_REVIEW, NEEDS_ATTENTION, REOPENED |
| Completed | status IN ('COMPLETE', 'WAIVED') | COMPLETE, WAIVED |
| All | No filter | All values |

### 5.2 StorePhase Status Display

| StorePhase | Display Label | Badge Color | Icon |
|------------|---------------|-------------|------|
| AWAITING_SHIPMENT | Awaiting Shipment | Gray | clock |
| SHIPMENT_IN_TRANSIT | In Transit | Blue | truck |
| READY_TO_RECEIVE | Ready to Receive | Yellow | package |
| RECEIVING | Receiving | Yellow | package-open |
| READY_TO_INSTALL | Ready to Install | Orange | tools |
| INSTALLING | Installing | Orange | hammer |
| PENDING_REVIEW | Pending Review | Purple | eye |
| COMPLETE | Complete | Green | check-circle |
| NEEDS_ATTENTION | Needs Attention | Red | alert-triangle |
| WAIVED | Waived | Gray | skip-forward |
| REOPENED | Reopened | Orange | refresh |

### 5.3 Progress Calculation

| Component | Weight | Calculation |
|-----------|--------|-------------|
| Shipment Received | 10% | receive_verification EXISTS |
| Pre-install Survey | 10% | survey_response EXISTS WHERE type='PRE_INSTALL' |
| All Items Installed | 50% | all assignment_items have status='INSTALLED' |
| All Photos Approved | 20% | all required photos have review_status='APPROVED' |
| Completion Survey | 10% | completion_attestation EXISTS |

### 5.4 Business Rule Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-BR-001 | NEEDS_ATTENTION campaigns highlighted with alert icon | Must |
| REQ-S002-BR-002 | Overdue campaigns (past install_end) show warning indicator | Must |
| REQ-S002-BR-003 | Progress percentage rounds to nearest whole number | Should |
| REQ-S002-BR-004 | WAIVED campaigns show reason in detail panel | Should |

---

## 6. API Integration Points

### 6.1 API Endpoints

| Endpoint | Method | Purpose | Response |
|----------|--------|---------|----------|
| `/api/stores/{storeId}/assignments` | GET | List campaign assignments | Assignment[] |
| `/api/assignments/{id}` | GET | Get assignment details | AssignmentDetail |
| `/api/stores/{storeId}/assignments/export` | GET | Export campaign list as CSV | File download |

### 6.2 Request/Response Specifications

#### GET /api/stores/{storeId}/assignments

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter: active, completed, all |
| search | string | No | Search by name/code |
| page | number | No | Page number (default: 1) |
| limit | number | No | Items per page (default: 20) |

**Response Schema:**
```json
{
  "data": [
    {
      "id": "uuid",
      "campaignId": "uuid",
      "campaignName": "string",
      "campaignCode": "string",
      "phase": "StorePhase",
      "installStart": "ISO8601",
      "installEnd": "ISO8601",
      "progress": "number",
      "itemCount": "number",
      "photoStats": {
        "required": "number",
        "uploaded": "number",
        "approved": "number"
      },
      "completedAt": "ISO8601 | null"
    }
  ],
  "pagination": {
    "page": "number",
    "limit": "number",
    "total": "number",
    "pages": "number"
  }
}
```

#### GET /api/assignments/{id}

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| include | string | No | Comma-separated: items,photos,tasks |

**Response Schema:**
```json
{
  "id": "uuid",
  "campaign": {
    "id": "uuid",
    "name": "string",
    "code": "string",
    "installStart": "ISO8601",
    "installEnd": "ISO8601"
  },
  "phase": "StorePhase",
  "progress": "number",
  "tasks": [
    {
      "name": "string",
      "status": "pending | complete",
      "completedAt": "ISO8601 | null"
    }
  ],
  "items": [
    {
      "id": "uuid",
      "name": "string",
      "sku": "string",
      "quantity": "number",
      "slotCode": "string",
      "photoCount": "number",
      "photoApproved": "boolean"
    }
  ],
  "receiveVerification": {
    "verifiedAt": "ISO8601",
    "verifiedBy": "string"
  },
  "completionAttestation": {
    "attestedAt": "ISO8601",
    "attestedBy": "string"
  }
}
```

### 6.3 API Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-API-001 | List endpoint returns within 500ms | Must |
| REQ-S002-API-002 | Detail endpoint returns within 300ms | Must |
| REQ-S002-API-003 | Export generates CSV within 10 seconds | Should |
| REQ-S002-API-004 | Pagination required for lists > 20 items | Must |

---

## 7. State Transitions

### 7.1 Page States

![History](../../screenshots/Store_Portal/store_portal_campaigns.png)

### 7.2 State Descriptions

| State | Description | UI Behavior |
|-------|-------------|-------------|
| LOADING | Initial data fetch | Show skeleton loader |
| LOADED | Data displayed | Full list visible |
| FILTERING | Tab or search change | Update list, maintain position |
| DETAIL_OPEN | Row expanded | Slide panel visible |
| EXPORTING | CSV generation | Show progress, disable export button |
| ERROR | API failure | Show error message, retry option |

### 7.3 State Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-STATE-001 | Tab changes update URL query parameter | Should |
| REQ-S002-STATE-002 | Detail panel state preserved on tab change | Should |
| REQ-S002-STATE-003 | Export state shows progress indicator | Must |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error Code | Scenario | User Message | Recovery Action |
|------------|----------|--------------|-----------------|
| 401 | Unauthorized | "Session expired" | Redirect to login |
| 403 | No access | "You don't have access to this store" | Redirect to store selector |
| 404 | Campaign not found | "Campaign not found" | Remove from list, show toast |
| 500 | Server error | "Unable to load campaigns" | Retry button |
| EXPORT_FAIL | Export generation failed | "Export failed. Please try again." | Retry button |

### 8.2 Validation Errors

| Scenario | Handling |
|----------|----------|
| Invalid date range | Show inline error, reset to defaults |
| Search no results | Show "No campaigns found" empty state |
| Page out of bounds | Redirect to last valid page |

### 8.3 Error Requirements

| Requirement ID | Description | Priority |
|----------------|-------------|----------|
| REQ-S002-ERR-001 | Failed export shows error toast | Must |
| REQ-S002-ERR-002 | Network errors display retry option | Must |
| REQ-S002-ERR-003 | Invalid campaign removed from list gracefully | Should |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Requirement ID | WCAG Criterion | Implementation |
|----------------|----------------|----------------|
| REQ-S002-A11Y-001 | 1.3.1 Info and Relationships | Table uses proper th/td structure |
| REQ-S002-A11Y-002 | 1.4.1 Use of Color | Status not conveyed by color alone |
| REQ-S002-A11Y-003 | 2.1.1 Keyboard | Tab navigation through all controls |
| REQ-S002-A11Y-004 | 2.4.3 Focus Order | Logical focus order in detail panel |
| REQ-S002-A11Y-005 | 4.1.1 Parsing | Valid HTML, no duplicate IDs |
| REQ-S002-A11Y-006 | 4.1.2 Name, Role, Value | ARIA labels for status badges |

### 9.2 Screen Reader Support

| Component | ARIA Implementation |
|-----------|---------------------|
| Campaign Table | role="grid" with sortable column headers |
| Status Badge | aria-label="Status: {phase}" |
| Progress Bar | role="progressbar", aria-valuenow, aria-valuemin, aria-valuemax |
| Detail Panel | role="dialog", aria-modal="true" |
| Tabs | role="tablist" with aria-selected |

### 9.3 Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Move between interactive elements |
| Enter | Open campaign detail / activate button |
| Escape | Close detail panel |
| Arrow Left/Right | Switch between status tabs |
| Arrow Up/Down | Navigate table rows |

---

## 10. Acceptance Criteria

### 10.1 Functional Requirements

| Requirement ID | Description | Test Criteria | Priority |
|----------------|-------------|---------------|----------|
| REQ-S002-FR-001 | Campaign list displays all store assignments | List matches database records | Must |
| REQ-S002-FR-002 | Active tab shows only in-progress campaigns | Filter excludes COMPLETE/WAIVED | Must |
| REQ-S002-FR-003 | Completed tab shows finished campaigns | Filter includes only COMPLETE/WAIVED | Must |
| REQ-S002-FR-004 | Search filters by campaign name | Real-time filtering as user types | Must |
| REQ-S002-FR-005 | Row click opens detail panel | Panel slides in from right | Must |
| REQ-S002-FR-006 | Detail panel shows all tasks | Checklist with completion status | Must |
| REQ-S002-FR-007 | Progress bar reflects actual completion | Percentage matches calculation | Must |
| REQ-S002-FR-008 | Export generates CSV file | File downloads with correct data | Must |
| REQ-S002-FR-009 | Status badges use correct colors | Colors match StorePhase mapping | Must |
| REQ-S002-FR-010 | Pagination works for large lists | Previous/next navigate correctly | Must |
| REQ-S002-FR-011 | Overdue campaigns show warning | Visual indicator for past install_end | Should |
| REQ-S002-FR-012 | Empty state shown when no campaigns | Message displayed for empty list | Must |

### 10.2 Non-Functional Requirements

| Requirement ID | Description | Metric | Priority |
|----------------|-------------|--------|----------|
| REQ-S002-NFR-001 | Page load time | < 2 seconds | Must |
| REQ-S002-NFR-002 | Search response time | < 300ms | Must |
| REQ-S002-NFR-003 | Export completion | < 10 seconds for 1000 campaigns | Should |
| REQ-S002-NFR-004 | Mobile responsive | Works on 320px viewport | Must |

### 10.3 Traceability Matrix

| Requirement | Source Document | Section |
|-------------|-----------------|---------|
| REQ-S002-FR-001 | S02_Campaign_History.md | Data Model Map |
| REQ-S002-FR-005 | S02_Campaign_History.md | Expanded Detail Panel |
| REQ-S002-SEC-001 | SUPP-003 | Store Level Permissions |
| REQ-S002-DATA-001 | 3.1_Database_Model.md | Store Assignments |

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial SRS specification |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*
