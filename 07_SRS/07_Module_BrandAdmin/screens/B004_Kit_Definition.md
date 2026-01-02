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
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Create Campaign                                             â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ Step 1: Select Stores  â”€â”€â”€âœ“â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€  â”‚
â”‚ Step 2: Define Kit     â”€â”€â”€â—â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€  â”‚
â”‚ Step 3: Review         â”€â”€â”€â”€â—‹â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                             â”‚
â”‚ Kit Items                                    [+ Add Item]   â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”‚
â”‚ â”‚ â‰¡  1. Summer Poster (24x36)                             â”‚ â”‚
â”‚ â”‚     Type: POSTER  â”‚  Qty: 2  â”‚  Location: FRONT_WINDOW  â”‚ â”‚
â”‚ â”‚     ðŸ“· Photo Required: Front view                [Edit] â”‚ â”‚
â”‚ â”‚                                                   [Ã—]   â”‚ â”‚
â”‚ â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â”‚
â”‚ â”‚ â‰¡  2. Counter Display Stand                             â”‚ â”‚
â”‚ â”‚     Type: COUNTER_DISPLAY  â”‚  Qty: 1  â”‚  Location: --   â”‚ â”‚
â”‚ â”‚     ðŸ“· No photo required                         [Edit] â”‚ â”‚
â”‚ â”‚                                                   [Ã—]   â”‚ â”‚
â”‚ â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤ â”‚
â”‚ â”‚ â‰¡  3. Window Cling Set                                  â”‚ â”‚
â”‚ â”‚     Type: WINDOW_CLING  â”‚  Qty: 4  â”‚  Location: ENTRY   â”‚ â”‚
â”‚ â”‚     ðŸ“· Photo Required: Installed view            [Edit] â”‚ â”‚
â”‚ â”‚                                                   [Ã—]   â”‚ â”‚
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â”‚
â”‚                                                             â”‚
â”‚ Kit Summary: 3 items, 7 total units                         â”‚
â”‚                                                             â”‚
â”‚ [â† Back]                              [Save & Continue â†’]   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
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
[Step 1: Stores] â†â”€backâ”€â”
       â†“ save           â”‚
[Step 2: Kit] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
       â†“ save
[Step 3: Review] â†â”€backâ”€ [Step 2: Kit]
```

### 7.2 Item Edit State Machine

```
[List View] â†’ [Add Modal] â†’ [Saving] â†’ [List View]
     â†“              â†“           â†“
[Edit Modal] â†’ [Saving] â†’ [List View]
     â†“
[Delete Confirm] â†’ [Deleting] â†’ [List View]
```

### 7.3 Drag-Drop State Machine

```
[Idle] â†’ [Dragging] â†’ [Over Drop Zone] â†’ [Dropped] â†’ [Reordering] â†’ [Idle]
              â†“                               â†“
          [Cancelled] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â†’ [Idle]
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
