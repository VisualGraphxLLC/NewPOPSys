# SUPP-002 — Core Domain Model and State Machines

> **Version**: v0.5
> **Status**: Locked
> **Updated**: 2025-12-20
> **Dependencies**: SUPP-001 (Personas)

---

## Purpose

Canonical domain model and state machines for v1. Anchors data modeling, API contracts, reporting, and agentic development.
**Update v0.6:** Refactored for "Master vs Instance" inheritance model (PSP Assist / Brand Owner).

---

## Core Loop

```
Campaign → Store Assignment → Orders/Shipments (PSP) → Store Execution → Verification/Retakes → Visibility/Exports → Retention
```

---

## Primary Entities

### Tenancy & Identity
| Entity | Purpose |
|--------|---------|
| `PspTenant` | Root tenant (paying customer) |
| `Brand` | Brand within PSP tenant |
| `User` | Human user with auth |
| `Membership` | User ↔ Brand/Role binding |
| `Role` | Permission set |
| `ApiKey` | Integration authentication |
| `AuditEvent` | Immutable action log |

### Stores & Grouping
| Entity | Purpose |
|--------|---------|
| `Store` | Physical location |
| `Region` | Geographic hierarchy (required) |
| `District` | Geographic sub-level (optional) |
| `Territory` | Geographic sub-level (optional) |
| `StoreGroup` | Custom grouping for selection |
| `GroupMembership` | Store ↔ Group binding |
| `StoreIdAlias` | External ID mapping (brand's store #) |

### Surveys & Layouts
### Surveys & Layouts
| Entity | Purpose |
|--------|---------|
| `MasterSurveyTemplate` | **PSP Owned:** Standard survey definition (e.g., "Standard Retail Audit") |
| `BrandSurveyTemplate` | **Brand Owned:** Campaign-specific survey. Can sync from Master or be custom. |
| `SurveyVersion` | Immutable snapshot of a BrandSurveyTemplate |
| `MasterStoreLayout` | **PSP Owned:** Standard layout definition (e.g., "Mall Kiosk", "Flagship") |
| `StoreLayout` | **Brand Owned:** Actual layout assigned to a specific store. Inherits from Master. |
| `LocationSlot` | Specific placement in store. Includes spatial data (`x`, `y`, `z`, `width`, `depth`, `shape`). |
| `PhotoRule` | Photo requirements per location |
| `StoreSurveyResponse` | Store's answers to survey (linked to BrandSurveyTemplate) |

### Campaigns & Kits
| Entity | Purpose |
|--------|---------|
| `Campaign` | Brand's promotional program |
| `SelectionRecipe` | Store selection criteria |
| `StoreAssignment` | Store's participation in campaign |
| `KitDefinition` | Items to be installed |
| `KitItem` | Single item in kit |
| `AssignmentItem` | Item assigned to store |

### Fulfillment
| Entity | Purpose |
|--------|---------|
| `StoreOrder` | Order to PSP for store's kit |
| `OrderLine` | Line item in order |
| `Shipment` | Physical shipment |
| `ShipmentLine` | Items in shipment (supports partials) |
| `ShipmentTracking` | Tracking number(s) |

**PSP Integration Fields:**
- `Campaign.pspCampaignRef` — PSP's MIS ID for campaign
- `StoreOrder.pspOrderRef` — PSP's MIS ID for store order
- `StoreOrder.pspAcknowledgedAt` — When PSP acknowledged

### Execution & Verification
| Entity | Purpose |
|--------|---------|
| `ReceiveVerification` | Store confirms receipt |
| `IssueReport` | Missing/damaged items |
| `CompletionSubmission` | Store submits completion |
| `PhotoUpload` | Proof photo for location |
| `PhotoReview` | Admin review of photo |
| `RetakeRequest` | Request for new photo |

### Issues & Reorders
| Entity | Purpose |
|--------|---------|
| `IssueRequest` | Store reports problem |
| `IssueLine` | Specific item with issue |
| `Reorder` | Separate order for replacement |
| `ReorderLine` | Items in reorder |

---

## Key Relationships

```
PspTenant
└── Brand (1:N)
    └── Campaign (1:N)
        └── StoreAssignment (1:N) ──→ Store
            └── StoreOrder (1:1)
                └── Shipment (1:N)
                    └── ShipmentLine (1:N)
                └── OrderLine (1:N)
            └── CompletionSubmission (1:1)
                └── PhotoUpload (1:N)
                    └── PhotoReview (1:1)
```

---

## Status Enumerations

### Campaign
```
DRAFT → SCHEDULED → ACTIVE → COMPLETED → ARCHIVED
```
![Campaign Status](../04_Reference/Campaign%20status.png)

### StoreAssignment
```
IN_PROGRESS → SUBMITTED_FOR_REVIEW → COMPLETE
                     ↓
              REWORK_REQUESTED ←─┘ (on rejection)
```
![StoreAssignment Status](../04_Reference/StoreAssignment%20execution%20status.png)

### StoreOrder
```
GENERATED → ACKNOWLEDGED → IN_PRODUCTION → KITTING → READY_TO_SHIP
    ↓                                                      ↓
CANCELLED                              PARTIALLY_SHIPPED → SHIPPED → DELIVERED → CLOSED
```

### Shipment
```
LABEL_CREATED → IN_TRANSIT → DELIVERED
                     ↓
                 EXCEPTION → RETURNED
```

### PhotoReview
```
PENDING → APPROVED
    ↓
REJECTED → PENDING (retake) → SUPERSEDED
```
![Photo Review Status](../04_Reference/Photo%20review%20status.png)

### IssueRequest
```
OPEN → TRIAGED → AWAITING_APPROVAL → APPROVED → IN_FULFILLMENT → RESOLVED
                                   ↘ DENIED → CLOSED
```

**State Definitions:**
| State | Description | Next States |
|-------|-------------|-------------|
| OPEN | Issue just reported by store | TRIAGED |
| TRIAGED | PSP reviewed, categorized, assigned | AWAITING_APPROVAL |
| AWAITING_APPROVAL | Pending approval decision | APPROVED, DENIED |
| APPROVED | Approved, reorder will be created | IN_FULFILLMENT |
| DENIED | Rejected with reason | CLOSED |
| IN_FULFILLMENT | Reorder created and being fulfilled | RESOLVED |
| RESOLVED | Replacement delivered, issue closed | (terminal) |
| CLOSED | Denied issue, no action taken | (terminal) |

> **Note:** Canonical state machine aligned with SUPP-035 (D16).

---

## Reporting Dimensions

![Status Interrelation](../04_Reference/Status%20interrelation%20across%20modules.png)

- Query chain: `Campaign → Store → Item → LocationSlot → Photo → Review`
- All transitions emit `AuditEvent` with `actorType: HUMAN | INTEGRATION`
- Exports include stable IDs + human-readable keys
- Retention-aware: proof URLs may expire

---

## Integration Points

| Direction | Mechanism | Data |
|-----------|-----------|------|
| PSP → System | API / Webhook | Order ack, shipment, tracking, delivery |
| System → PSP | Webhook | Campaign published, orders generated |
| System → Brand | Webhook | Completion, photo review, issues |
| System → Store | Email | Campaign notifications |

---

## Rollup & Derivation Logic

This section defines the quantity-normalized rollup algorithms used to derive statuses and calculate progress percentages across the system.

### Data Primitives

Track per `(campaignId, storeId, skuId[, slotId])`:

| Field | Source | Description |
|-------|--------|-------------|
| `requiredQty` | AssignmentItem | Planned requirement |
| `shippedQty` | Σ ShipmentLine | Total shipped quantity |
| `deliveredQty` | Σ ShipmentLine | Total delivered quantity |
| `receivedGoodQty` | Store input | Store accepted usable qty |
| `receivedDamagedQty` | Store input | Store marked damaged qty |
| `installedQty` | Store input | Store marked installed qty |
| `satisfiedQty` | Verification | Approved/waived qty |
| `hasCarrierException` | Shipment | Unresolved carrier exception |
| `hasOpenIssue` | IssueLine | Open issue for sku/qty |

**Execution Policy** (per campaign or kit item):
- `ALL_ITEMS_REQUIRED_BEFORE_START` — Store cannot start until all items received
- `ALLOW_PARTIAL_EXECUTION` — Store can execute and complete with partial items
- `ALLOW_PARTIAL_EXECUTION_BUT_BLOCK_COMPLETION` — Store can start but must satisfy all requirements to complete
- Optional per item: `isBlocking = true|false`

### Step 1: OrderLine Rollups (PSP Truth)

```text
OrderLine.shippedQty   = Σ ShipmentLine.shippedQty
OrderLine.deliveredQty = Σ ShipmentLine.deliveredQty
OrderLine.hasCarrierException = any(Shipment.status == EXCEPTION and not resolved)
```

**FulfillmentStatus Derivation:**
```pseudo
function fulfillmentStatus(requiredQty, shippedQty, deliveredQty, hasCarrierException, cancelled=false):
  if cancelled: return CANCELLED
  if hasCarrierException: return EXCEPTION

  if shippedQty <= 0: return NOT_SHIPPED
  if shippedQty < requiredQty: return PARTIALLY_SHIPPED

  // shippedQty >= requiredQty
  if deliveredQty <= 0: return SHIPPED
  if deliveredQty < requiredQty: return PARTIALLY_DELIVERED
  return DELIVERED
```

### Step 2: Receipt Rollups (Store Truth)

```pseudo
receivedTotalQty = receivedGoodQty + receivedDamagedQty
missingQty = max(0, deliveredQty - receivedTotalQty)
hasReceiptDiscrepancy = (missingQty > 0) OR (receivedDamagedQty > 0)
```

**ReceiptStatus Derivation:**
```pseudo
function receiptStatus(deliveredQty, receivedGoodQty, receivedDamagedQty):
  receivedTotal = receivedGoodQty + receivedDamagedQty

  if deliveredQty <= 0: return NOT_DELIVERED
  if receivedTotal <= 0: return NOT_RECEIVED
  if receivedTotal < deliveredQty: return PARTIALLY_RECEIVED
  if receivedDamagedQty > 0: return RECEIVED_WITH_DAMAGE
  return RECEIVED
```

### Step 3: StoreAssignment Rollups (Brand/Store Truth)

```pseudo
store.requiredQty      = Σ item.requiredQty
store.deliveredQty     = Σ item.deliveredQty
store.receivedGoodQty  = Σ item.receivedGoodQty
store.installedQty     = Σ item.installedQty
store.satisfiedQty     = Σ item.satisfiedQty

store.fulfillmentPct = clamp(store.deliveredQty / store.requiredQty, 0..1)
store.receiptPct     = clamp(store.receivedGoodQty / store.requiredQty, 0..1)
store.installPct     = clamp(store.installedQty / store.requiredQty, 0..1)
store.verifyPct      = clamp(store.satisfiedQty / store.requiredQty, 0..1)

store.hasBlockingInventory =
  any(item.isBlocking == true AND item.receivedGoodQty < item.requiredQty AND item.waived == false)

store.hasOpenIssues = any(item.hasOpenIssue)
```

**Execution Readiness:**
```pseudo
function isReady(policy, items):
  if policy == ALL_ITEMS_REQUIRED_BEFORE_START:
    return all(items.receivedGoodQty >= items.requiredQty OR items.waived)
  else:
    // partial execution allowed
    return any(items.receivedGoodQty > 0 OR items.waived)
```

**Completion Allowed:**
```pseudo
function canComplete(policy, items):
  if policy == ALLOW_PARTIAL_EXECUTION:
    return true

  // default best practice:
  // allow partial execution but require all requirements satisfied (or waived) to complete
  return all(items.satisfiedQty >= items.requiredQty OR items.waived)
```

### Step 4: Campaign Rollups (Portfolio Truth)

```pseudo
campaign.storesTotal     = count(StoreAssignments)
campaign.storesDelivered = count(store where store.fulfillmentPct == 1)
campaign.storesExecuting = count(store where store.installPct > 0 and store.verifyPct < 1)
campaign.storesInReview  = count(store where store.submitted == true and store.verifyPct < 1)
campaign.storesComplete  = count(store where store.verifyPct == 1 OR store.waived)

campaign.fulfillmentPct = average(store.fulfillmentPct)
campaign.verifyPct      = average(store.verifyPct)
```

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.5 | 2025-12-20 | Added Rollup & Derivation Logic section (merged from Reference) |
| v0.4 | 2025-12-20 | Stable filename adopted; version tracked in file |
