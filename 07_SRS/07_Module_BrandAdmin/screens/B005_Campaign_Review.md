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
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Create Campaign                                             â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ Step 1: Select Stores  â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â—â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€    â”‚
â”‚ Step 2: Define Kit     â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â—â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€    â”‚
â”‚ Step 3: Review         â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â—â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€    â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                             â”‚
â”‚ Campaign Summary                                            â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”‚
â”‚ â”‚ Campaign Name: Summer Promo 2025                   [âœŽ]  â”‚ â”‚
â”‚ â”‚ Status: Draft                                           â”‚ â”‚
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â”‚
â”‚                                                             â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”        â”‚
â”‚ â”‚ ðŸ“ Store Selection    â”‚ â”‚ ðŸ“¦ Kit Definition     â”‚        â”‚
â”‚ â”‚                       â”‚ â”‚                       â”‚        â”‚
â”‚ â”‚ 234 stores selected   â”‚ â”‚ 5 items defined       â”‚        â”‚
â”‚ â”‚ 3 regions             â”‚ â”‚ 12 total pieces       â”‚        â”‚
â”‚ â”‚ 0 exclusions          â”‚ â”‚ 3 photo requirements  â”‚        â”‚
â”‚ â”‚                       â”‚ â”‚                       â”‚        â”‚
â”‚ â”‚ [View Details]        â”‚ â”‚ [View Details]        â”‚        â”‚
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜        â”‚
â”‚                                                             â”‚
â”‚ Installation Schedule                                       â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”‚
â”‚ â”‚ Install Start *           Install End *                 â”‚ â”‚
â”‚ â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”‚ â”‚
â”‚ â”‚ â”‚ ðŸ“… Dec 1, 2025  â”‚       â”‚ ðŸ“… Dec 31, 2025 â”‚          â”‚ â”‚
â”‚ â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜          â”‚ â”‚
â”‚ â”‚                                                         â”‚ â”‚
â”‚ â”‚ â˜‘ Allow late installations (extend by 7 days)          â”‚ â”‚
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â”‚
â”‚                                                             â”‚
â”‚ Pre-Launch Checklist                                        â”‚
â”‚ â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â” â”‚
â”‚ â”‚ âœ“ Campaign name defined                                 â”‚ â”‚
â”‚ â”‚ âœ“ At least one store selected (234 stores)             â”‚ â”‚
â”‚ â”‚ âœ“ Kit items defined (5 items)                          â”‚ â”‚
â”‚ â”‚ âœ“ Photo requirements configured                        â”‚ â”‚
â”‚ â”‚ âœ“ Install dates set                                    â”‚ â”‚
â”‚ â”‚ â—‹ All items have SKUs (2 missing)                [Fix] â”‚ â”‚
â”‚ â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜ â”‚
â”‚                                                             â”‚
â”‚ [â† Back]         [Save Draft]         [Publish Campaign]    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
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
[DRAFT] â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â†’ [SCHEDULED]
    â”‚                                                          â”‚
    â”‚ publish (start <= today)                    start_date   â”‚
    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â†’ [PUBLISHED] â†â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 7.2 Wizard Navigation State Machine

```
[Step 1: Stores] â†â”€â”€â”€â”€â”€â”€â”€backâ”€â”€â”€â”€â”€â”€â”€â”€â”€ [Step 2: Kit]
                                              â”‚
                                              â”‚ continue
                                              â†“
                           [Step 3: Review]
                                  â”‚
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â†“             â†“             â†“
              [Save Draft]   [Publish]    [Back to Kit]
                    â”‚             â”‚
                    â†“             â†“
            [Campaign List]  [Campaign Detail]
```

### 7.3 Publish State Machine

```
[Ready] â†’ [Validating] â†’ [Publishing] â†’ [Success] â†’ [Redirect]
              â”‚                â”‚
              â†“                â†“
          [Invalid]        [Failed]
              â”‚                â”‚
              â†“                â†“
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
