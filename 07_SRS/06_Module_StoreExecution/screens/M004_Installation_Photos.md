# M004 - Installation Photos

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M004
> **Route**: `/app/campaign/:id/install`
> **IEEE 830 Section**: 3.2.1 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

---

## 1. Screen Overview

### 1.1 Purpose

The Installation Photos screen guides store personnel through the physical installation of POP materials at designated locations within the store. Users navigate a location-based checklist, viewing where each item should be placed and capturing proof photos. The screen supports the store's layout with slot assignments and ghost image overlays for precise placement.

### 1.2 Scope

This specification covers:
- Location slot accordion navigation
- Item placement guidance with ghost images
- Pre-install condition verification
- Photo capture workflow integration
- Auto-save progress with debounce
- Installation completion tracking

### 1.3 Screenshot Reference

| Mobile View | Tablet View | Desktop View |
| :--- | :--- | :--- |
| ![Mobile Install](../../screenshots/Store_Execution/mobile_install_photos.png) | ![Tablet Install](../../screenshots/Store_Execution/tablet_install_photos.png) | ![Desktop Install](../../screenshots/Store_Execution/desktop_install_photos.png) |

### 1.4 Source Documents

| Document | Reference |
|----------|-----------|
| Screen Spec | [M04_Install_Survey.md](../../../../06_Screen_Specs/M04_Install_Survey.md) |
| SUPP Reference | SUPP-037 (Store Surveys), SUPP-018 (Photo Review) |
| Database Model | [3.1_Database_Model.md](../../03_System_Architecture/3.1_Database_Model.md) |

---

## 2. User Roles & Permissions

### 2.1 Authorized Roles

| Role | Access Level | Capabilities |
|------|--------------|--------------|
| Store Manager (P07) | Full | Install items, capture photos, complete survey |
| Store Operator (P08) | Execute | Install items, capture photos, complete survey |

### 2.2 Role Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-ROLE-001 | Both Store Manager and Store Operator SHALL execute installations | Must |
| REQ-M004-ROLE-002 | System SHALL track which user completes each installation | Must |
| REQ-M004-ROLE-003 | System SHALL allow handoff between users during installation | Should |

### 2.3 Permission Matrix

| Action | Store Manager | Store Operator |
|--------|---------------|----------------|
| View install survey | Yes | Yes |
| Mark item installed | Yes | Yes |
| Capture proof photos | Yes | Yes |
| Complete installation | Yes | Yes |
| Skip location | Yes | No |

---

## 3. UI Components

### 3.1 Component Inventory

| Component ID | Type | Description | Required |
|--------------|------|-------------|----------|
| COMP-M004-001 | Header | Campaign name, progress, back button | Yes |
| COMP-M004-002 | Progress Ring | Overall completion percentage | Yes |
| COMP-M004-003 | Location Accordion | Expandable location slots | Yes |
| COMP-M004-004 | Item Card | Item details within location | Yes |
| COMP-M004-005 | Ghost Image | Placement guide overlay | Conditional |
| COMP-M004-006 | Condition Checklist | Pre-install verification | Conditional |
| COMP-M004-007 | Photo Button | Launch camera capture | Yes |
| COMP-M004-008 | Status Badge | Item installation status | Yes |
| COMP-M004-009 | Complete Button | Finish installation | Yes |

### 3.2 Component Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-UI-001 | Location accordion SHALL group items by LocationSlot | Must |
| REQ-M004-UI-002 | Each location SHALL show completion status | Must |
| REQ-M004-UI-003 | Item cards SHALL display placement instructions | Must |
| REQ-M004-UI-004 | Ghost image SHALL appear at 50% opacity when available | Should |
| REQ-M004-UI-005 | Progress ring SHALL update in real-time | Must |
| REQ-M004-UI-006 | Auto-save SHALL trigger after 500ms of inactivity | Must |

### 3.3 Layout Specification

```
+---------------------------------------+
| â† Install: Summer Promo    [75%]     |
+---------------------------------------+
| Locations: 4 of 6 complete            |
+---------------------------------------+
|                                       |
| â–¼ Front Window                [2/2] âœ“|
| â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   |
| â”‚ Window Poster (24x36)      [âœ“] â”‚   |
| â”‚ Position: Left side of door    â”‚   |
| â”‚ [Photo captured]           ðŸ“·  â”‚   |
| â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   |
| â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   |
| â”‚ Window Cling                [âœ“] â”‚   |
| â”‚ Position: Eye level, center    â”‚   |
| â”‚ [Photo captured]           ðŸ“·  â”‚   |
| â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   |
|                                       |
| â–¶ End Cap Display            [0/1]   |
|                                       |
| â–¶ Checkout Counter           [1/2]   |
|                                       |
| â–¼ Floor Stand                [0/1]   |
| â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   |
| â”‚ Display Stand               [ ] â”‚   |
| â”‚ Position: Near entrance        â”‚   |
| â”‚ Pre-install check:             â”‚   |
| â”‚ [ ] Area clear                 â”‚   |
| â”‚ [ ] Surface clean              â”‚   |
| â”‚ [Capture Photo]            ðŸ“·  â”‚   |
| â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   |
|                                       |
+---------------------------------------+
|        [Complete Installation]        |
+---------------------------------------+
```

### 3.4 Item Card Expanded View

```
+---------------------------------------+
| Window Poster (24x36)                 |
| SKU: POS-001                          |
+---------------------------------------+
| Location: Front Window - Left         |
| Instructions:                         |
| "Place at eye level, ensure all       |
|  corners are secure and no bubbles"   |
+---------------------------------------+
| Reference Image:                      |
| â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   |
| â”‚                                 â”‚   |
| â”‚   [Ghost Image Preview]        â”‚   |
| â”‚   (tap to enlarge)             â”‚   |
| â”‚                                 â”‚   |
| â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   |
+---------------------------------------+
| Pre-Install Checklist:                |
| [âœ“] Surface is clean and dry          |
| [âœ“] Previous materials removed        |
| [ ] Positioning matches reference     |
+---------------------------------------+
| Status: Ready to photograph           |
| [Capture Proof Photo]             ðŸ“·  |
+---------------------------------------+
```

---

## 4. Data Requirements

### 4.1 Data Sources

| Entity | Fields | Access |
|--------|--------|--------|
| `StoreAssignment` | id, campaign_id, store_id, pinned_layout_id | Read |
| `StoreLayout` | id, store_id, is_current | Read |
| `LocationSlot` | id, layout_id, slot_code, name, position_hints | Read |
| `AssignmentItem` | id, kit_item_id, slot_id, item_status | Read/Write |
| `KitItem` | id, name, sku, description, photo_rule_id | Read |
| `PhotoRule` | id, ghost_image_url, instructions, min_photos | Read |
| `PhotoUpload` | id, assignment_item_id, s3_key, review_status | Read/Write |

### 4.2 Computed Fields

| Field | Derivation Logic |
|-------|------------------|
| `location_completion` | (installed_items / total_items) per slot |
| `overall_progress` | (all_installed_items / all_items) * 100 |
| `photos_pending` | COUNT(items WHERE status = INSTALLED AND photo_count < required) |
| `ready_for_complete` | all items have status IN (INSTALLED, WAIVED) |

### 4.3 Data Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-DATA-001 | System SHALL load LocationSlots for pinned layout | Must |
| REQ-M004-DATA-002 | System SHALL group AssignmentItems by slot_id | Must |
| REQ-M004-DATA-003 | System SHALL load PhotoRule for each kit item | Must |
| REQ-M004-DATA-004 | System SHALL cache ghost images for offline access | Should |
| REQ-M004-DATA-005 | System SHALL persist checklist state locally | Must |

---

## 5. Business Rules & Validation

### 5.1 Installation Workflow Rules

| Rule ID | Rule | Implementation |
|---------|------|----------------|
| BR-M004-001 | Items must be received before installation | Check `item_status != NOT_RECEIVED` |
| BR-M004-002 | Pre-install checklist must be completed if defined | All checklist items checked |
| BR-M004-003 | Photo must be captured before marking installed | Check `photo_uploads.length >= photo_rule.min_photos` |
| BR-M004-004 | Items can be installed in any order | No sequence enforcement |

### 5.2 Photo Requirements

| Rule ID | Rule | Implementation |
|---------|------|----------------|
| BR-M004-005 | Minimum photos per item from PhotoRule | `min_photos` field (default: 1) |
| BR-M004-006 | Required angles must be captured | `required_angles[]` array |
| BR-M004-007 | Ghost image overlay at 50% opacity | CSS opacity: 0.5 |
| BR-M004-008 | Photo must show item in final position | Review process validates |

### 5.3 Completion Rules

| Rule ID | Rule | Effect |
|---------|------|--------|
| BR-M004-009 | All items must be INSTALLED or WAIVED | Completion button enabled |
| BR-M004-010 | Completion updates assignment status | Set to `SUBMITTED` |
| BR-M004-011 | Completion triggers verification workflow | Photos enter review queue |
| BR-M004-012 | Cannot complete with pending retakes | Block if `RETAKE_REQUIRED` items exist |

### 5.4 Auto-Save Rules

| Rule ID | Rule | Parameters |
|---------|------|------------|
| BR-M004-013 | Debounce delay before save | 500ms |
| BR-M004-014 | Save on accordion collapse | Immediate |
| BR-M004-015 | Save on navigation away | Immediate |
| BR-M004-016 | Conflict resolution | Server wins, notify user |

### 5.5 Validation Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-VAL-001 | System SHALL enforce photo capture before installation mark | Must |
| REQ-M004-VAL-002 | System SHALL validate pre-install checklist completion | Should |
| REQ-M004-VAL-003 | System SHALL prevent completion with missing photos | Must |
| REQ-M004-VAL-004 | System SHALL auto-save with 500ms debounce | Must |

---

## 6. API Integration Points

### 6.1 Get Assignment with Layout

| Property | Value |
|----------|-------|
| **Endpoint** | `GET /api/v1/assignments/{assignmentId}?include=layout,items,photos` |
| **Auth Required** | Bearer token |

#### Response Schema

```json
{
  "id": "uuid",
  "campaign_id": "uuid",
  "status": "IN_PROGRESS",
  "layout": {
    "id": "uuid",
    "slots": [
      {
        "id": "uuid",
        "slot_code": "FW-01",
        "name": "Front Window",
        "position_hints": "Left of main entrance",
        "items": [
          {
            "id": "uuid",
            "kit_item": {
              "id": "uuid",
              "name": "Window Poster (24x36)",
              "sku": "POS-001",
              "photo_rule": {
                "ghost_image_url": "https://...",
                "instructions": "Capture straight-on...",
                "min_photos": 1,
                "required_angles": ["front"]
              }
            },
            "item_status": "INSTALLED",
            "photos": [
              {
                "id": "uuid",
                "thumbnail_url": "https://...",
                "review_status": "PENDING"
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### 6.2 Update Item Status

| Property | Value |
|----------|-------|
| **Endpoint** | `PATCH /api/v1/assignment-items/{itemId}` |
| **Auth Required** | Bearer token |

#### Request Schema

```json
{
  "item_status": "INSTALLED",
  "checklist_state": {
    "surface_clean": true,
    "previous_removed": true,
    "position_matches": true
  }
}
```

### 6.3 Complete Installation

| Property | Value |
|----------|-------|
| **Endpoint** | `POST /api/v1/assignments/{assignmentId}/install/complete` |
| **Auth Required** | Bearer token |

#### Request Schema

```json
{
  "attestation": true,
  "notes": "All items installed as specified"
}
```

### 6.4 API Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-API-001 | System SHALL include nested layout and items in response | Must |
| REQ-M004-API-002 | System SHALL batch item status updates | Should |
| REQ-M004-API-003 | System SHALL support offline queue for updates | Must |
| REQ-M004-API-004 | System SHALL pre-cache ghost images on assignment load | Should |

---

## 7. State Transitions

### 7.1 AssignmentItem.item_status Transitions

```
[RECEIVED]
     â”‚
     â”‚ Start installation
     â–¼
[INSTALLING]
     â”‚
     â”‚ Photo captured
     â–¼
[PROOF_SUBMITTED]
     â”‚
     â”‚ Mark complete
     â–¼
[INSTALLED]
     â”‚
     â”œâ”€â”€â–º [RETAKE_REQUIRED] â”€â”€â–º [PROOF_SUBMITTED]
     â”‚
     â–¼
[VERIFIED] (after approval)
```

### 7.2 Location Slot States

```
[NOT_STARTED] â”€â”€â–º [IN_PROGRESS] â”€â”€â–º [COMPLETE]
                       â”‚
                       â””â”€â”€â–º [PARTIAL] (some items waived)
```

### 7.3 Install Survey View States

```
[LOADING]
    â”‚
    â”‚ Data loaded
    â–¼
[INTERACTIVE]
    â”‚
    â”œâ”€â”€â–º [SAVING] â”€â”€â–º [INTERACTIVE]
    â”‚
    â”œâ”€â”€â–º [CAMERA_OPEN] â”€â”€â–º [INTERACTIVE]
    â”‚
    â”‚ All complete
    â–¼
[READY_TO_COMPLETE]
    â”‚
    â”‚ Submit
    â–¼
[SUBMITTING] â”€â”€â–º [COMPLETE]
```

### 7.4 State Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-STATE-001 | System SHALL track item_status per AssignmentItem | Must |
| REQ-M004-STATE-002 | System SHALL compute location completion from items | Must |
| REQ-M004-STATE-003 | System SHALL persist expanded/collapsed accordion state | Should |
| REQ-M004-STATE-004 | System SHALL block completion if items need retake | Must |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Scenario | User Message | Recovery Action |
|----------|--------------|-----------------|
| Ghost image failed to load | "Reference image unavailable" | Show placeholder |
| Photo upload failed | "Photo saved locally, will upload later" | Queue for retry |
| Save failed | "Changes saved locally" | Retry on reconnection |
| Camera permission denied | "Camera access required for photos" | Link to settings |
| Layout data missing | "Store layout not configured" | Contact support |

### 8.2 Offline Support

| Action | Offline Behavior |
|--------|------------------|
| View survey | From cache |
| View ghost images | From cache (if pre-loaded) |
| Mark checklist | Saved locally |
| Capture photo | Saved locally |
| Complete installation | Queued for sync |

### 8.3 Error Requirements

| Req ID | Requirement | Priority |
|--------|-------------|----------|
| REQ-M004-ERR-001 | System SHALL cache ghost images for offline use | Should |
| REQ-M004-ERR-002 | System SHALL queue all updates when offline | Must |
| REQ-M004-ERR-003 | System SHALL handle camera permission gracefully | Must |
| REQ-M004-ERR-004 | System SHALL show clear error for missing layout | Must |

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Req ID | Requirement | WCAG Criterion | Priority |
|--------|-------------|----------------|----------|
| REQ-M004-A11Y-001 | Accordion headers SHALL be keyboard activatable | 2.1.1 Keyboard | Must |
| REQ-M004-A11Y-002 | Accordion expansion state SHALL be announced | 4.1.2 Name, Role, Value | Must |
| REQ-M004-A11Y-003 | Progress ring SHALL have text alternative | 1.1.1 Non-text Content | Must |
| REQ-M004-A11Y-004 | Ghost images SHALL have alt text | 1.1.1 Non-text Content | Must |
| REQ-M004-A11Y-005 | Checklist items SHALL use proper checkbox semantics | 1.3.1 Info and Relationships | Must |

### 9.2 Screen Reader Announcements

| Element | Announcement |
|---------|--------------|
| Accordion expand | "Front Window expanded, 2 items, 2 complete" |
| Item status change | "Window Poster marked as installed" |
| Photo captured | "Photo captured for Window Poster, 1 of 1 required" |
| Progress update | "Installation progress 75 percent, 6 of 8 items complete" |
| Completion | "Installation survey submitted successfully" |

### 9.3 ARIA Implementation

```html
<div role="region" aria-label="Installation survey">
  <div role="progressbar" aria-valuenow="75"
       aria-valuemin="0" aria-valuemax="100"
       aria-label="Overall progress">
    75%
  </div>

  <div class="accordion">
    <button aria-expanded="true" aria-controls="slot-1-content"
            id="slot-1-header">
      Front Window (2 of 2 complete)
    </button>
    <div id="slot-1-content" role="region"
         aria-labelledby="slot-1-header">
      <!-- Item cards -->
    </div>
  </div>
</div>
```

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| AC ID | Criterion | Verification Method |
|-------|-----------|---------------------|
| AC-M004-001 | Survey displays locations grouped by slot | Manual test |
| AC-M004-002 | Accordion expands/collapses locations | Manual test |
| AC-M004-003 | Ghost image displays at 50% opacity | Visual test |
| AC-M004-004 | Pre-install checklist required before photo | E2E test |
| AC-M004-005 | Photo button launches camera with overlay | Manual test |
| AC-M004-006 | Progress ring updates on item completion | Automated test |
| AC-M004-007 | Auto-save triggers after 500ms delay | Timing test |
| AC-M004-008 | Completion blocked if items need retake | E2E test |

### 10.2 Non-Functional Acceptance

| AC ID | Criterion | Target | Verification |
|-------|-----------|--------|--------------|
| AC-M004-NF-001 | Accordion animation | < 300ms | Animation test |
| AC-M004-NF-002 | Auto-save response | < 1 second | Performance test |
| AC-M004-NF-003 | Ghost image load | < 2 seconds | Performance test |
| AC-M004-NF-004 | Handle 20+ locations smoothly | 60 FPS | Performance test |

### 10.3 Edge Cases

| AC ID | Criterion | Verification |
|-------|-----------|--------------|
| AC-M004-EC-001 | Handle location with 0 items | Edge case test |
| AC-M004-EC-002 | Handle missing ghost image | Fallback test |
| AC-M004-EC-003 | Handle camera failure | Error handling test |
| AC-M004-EC-004 | Handle layout change mid-campaign | State test |

---

## 11. Traceability Matrix

| Requirement | Source | Test Case |
|-------------|--------|-----------|
| REQ-M004-ROLE-001 | SUPP-003 | TC-M004-001 |
| REQ-M004-UI-004 | SUPP-018 | TC-M004-002 |
| REQ-M004-VAL-001 | SUPP-018 | TC-M004-003 |
| REQ-M004-VAL-004 | Offline Requirements | TC-M004-004 |
| REQ-M004-A11Y-001 | WCAG 2.1 | TC-M004-005 |

---

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.1 - User Interface Requirements*
