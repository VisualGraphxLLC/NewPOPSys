# NewPOPSys v1 — Architecture Diagrams

Interactive Mermaid diagrams covering all system aspects. Click any diagram to view.

---

## State Diagrams

State machines showing entity lifecycles and transitions.

| Diagram | Description |
|---------|-------------|
| [FulfillmentStatus](02-fulfillment-status.md) | Shipment and delivery states |
| [AssignmentItemStatus](05-assignment-item-status.md) | Item lifecycle at store |
| [IssueRequestStatus](06-issue-request-status.md) | Issue and reorder workflow |
| [StoreAssignmentStatus](07-store-assignment-status.md) | Store execution states |
| [Campaign Lifecycle](08-campaign-lifecycle.md) | Campaign states from draft to archive |
| [PhotoReviewStatus](11-photo-review-status.md) | Photo review states |

---

## Flow Charts

Process flows and data movement between modules.

| Diagram | Description |
|---------|-------------|
| [Roll-up Architecture](01-rollup-architecture.md) | Qty flow from PSP to Campaign |
| [StorePhase Derivation](04-storephase-derivation.md) | How StorePhase is computed |
| [Campaign Flow](09-campaign-flow.md) | End-to-end campaign flow |
| [Module Responsibilities](10-module-handoffs.md) | Portal ownership and hand-offs |
| [Store Selection Flow](15-store-selection-flow.md) | Campaign store targeting UX |
| [NewPOPSys v1 Flow](16-newpopsys-v1-flow.md) | End-to-end system orchestration |

---

## Architecture Diagrams

System structure and relationships.

| Diagram | Description |
|---------|-------------|
| [Personas by Module](12-personas-by-module.md) | Role assignments per module |
| [Status Interrelation](13-status-interrelation.md) | Status ownership across modules |
| [Promo Item - Slot](14-promo-item-slot.md) | Item and slot binding |
| [Core Data Model](17-core-data-model.md) | Entity relationships (ERD) |

---

## Sequence Diagrams

Interaction flows between system components.

| Diagram | Description |
|---------|-------------|
| [Partial Shipment Exception](03-partial-shipment-sequence.md) | Exception handling flow |

---

*Source: Individual diagram files derived from SUPP-002 and reference documentation.*
