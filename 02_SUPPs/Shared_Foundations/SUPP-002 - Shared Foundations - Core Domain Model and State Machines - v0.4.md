# SUPP-002 — Core Domain Model and State Machines

> **Version**: v0.4
> **Status**: Locked
> **Updated**: 2025-12-20
> **Dependencies**: SUPP-001 (Personas)

---

## Purpose

Canonical domain model and state machines for v1. Anchors data modeling, API contracts, reporting, and agentic development.

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
| Entity | Purpose |
|--------|---------|
| `SurveyTemplate` | Reusable survey definition |
| `SurveyVersion` | Immutable snapshot of template |
| `StoreLayout` | Store's physical ad locations |
| `LocationSlot` | Specific placement in store |
| `PhotoRule` | Photo requirements per location |
| `StoreSurveyResponse` | Store's answers to survey |

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

