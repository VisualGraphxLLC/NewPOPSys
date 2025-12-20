# NewPOPSys v1 — Process & Flow Chart Index

> **Version**: v1.0
> **Updated**: 2025-12-19
> **Purpose**: Central index of all process flows, state machines, and architecture diagrams

---

## Quick Links

- [Mermaid Charts (all diagrams)](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md)
- [ERD (entity relationships)](../04_Reference/NewPOPSys_v1_ERD.md)
- [Glossary (terminology)](./GLOSSARY.md)

---

## 1. State Machine Diagrams

Status lifecycles showing valid state transitions.

| Status | Chart | Description | Owner |
|--------|-------|-------------|-------|
| **CampaignStatus** | [Campaign lifecycle](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#8-campaign-lifecycle-state-diagram) | DRAFT → SCHEDULED → PUBLISHED → COMPLETED → ARCHIVED | Brand |
| **StoreAssignmentStatus** | [StoreAssignmentStatus](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#7-storeassignmentstatus-state-diagram) | ASSIGNED → READY → IN_PROGRESS → SUBMITTED → COMPLETE | System/Brand |
| **FulfillmentStatus** | [FulfillmentStatus](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#2-fulfillmentstatus-state-diagram-qty-derived) | NOT_SHIPPED → SHIPPED → DELIVERED (qty-derived) | PSP |
| **AssignmentItemStatus** | [AssignmentItemStatus](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#5-assignmentitemstatus-state-diagram) | PLANNED → ORDERED → SHIPPED → DELIVERED → RECEIVED → INSTALLED → SATISFIED | System |
| **IssueRequestStatus** | [IssueRequestStatus](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#6-issuerequestatus-state-diagram) | OPEN → TRIAGED → APPROVED → IN_FULFILLMENT → RESOLVED | Store/PSP |
| **PhotoReviewStatus** | [PhotoReviewStatus](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#11-photoreviewstatus-state-diagram) | PENDING → APPROVED/REJECTED → SUPERSEDED | Brand |

---

## 2. Architecture & Data Flow Diagrams

How data and quantities flow through the system.

| Diagram | Chart | Description |
|---------|-------|-------------|
| **Qty Rollup Architecture** | [Roll-up architecture](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#1-roll-up-architecture-qty--item--store--campaign) | PSP OrderLine → AssignmentItem → StoreAssignment → Campaign |
| **StorePhase Derivation** | [StorePhase derivation](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#4-storephase-derivation-parallel-lanes) | How 4 status columns compute single StorePhase |
| **Status Interrelation** | [Status Interrelation](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#13-status-interrelation-across-modules) | Which module owns which status |
| **Promo Item - Slot Binding** | [Promo Item - Slot](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#14-promo-item---slot-status-interrelation) | KitItem + LocationSlot → AssignmentItem |

---

## 3. End-to-End Process Flows

Complete workflows across modules.

| Process | Chart | Source SUPP | Description |
|---------|-------|-------------|-------------|
| **Campaign Flow** | [Campaign Flow](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#9-campaign-flow-end-to-end) | SUPP-015 | Draft → Publish → Ship → Receive → Install → Review → Complete |
| **Store Selection** | [Store Selection Flow](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#15-store-selection-flow) | SUPP-015 | Include/exclude criteria → Preview → Save recipe |
| **Module Hand-offs** | [Module Responsibility](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#10-module-responsibility--hand-offs) | SUPP-001 | Brand → PSP → Store → Brand data handoffs |

---

## 4. Sequence Diagrams

Multi-actor workflows with timing.

| Sequence | Chart | Description |
|----------|-------|-------------|
| **Partial Shipment + Receipt Exception** | [Partial shipment](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#3-partial-shipment--receipt-exception-sequence) | Brand publishes → PSP ships partial → Store receives → Reports damage → Reorder flows |

---

## 5. Entity Relationship Diagrams

Data model structure.

| ERD | Chart | Description |
|-----|-------|-------------|
| **Full ERD** | [Full ERD](../04_Reference/NewPOPSys_v1_ERD.md#full-erd-all-entities) | All 30+ entities with relationships |
| **Core Loop** | [Simplified Core Loop](../04_Reference/NewPOPSys_v1_ERD.md#simplified-core-loop-erd) | Brand → Campaign → StoreAssignment → Order → Shipment |
| **Module Ownership** | [Module Ownership](../04_Reference/NewPOPSys_v1_ERD.md#module-ownership) | Which module owns which entities |

---

## 6. Persona & Role Diagrams

Access and responsibility mapping.

| Diagram | Chart | Description |
|---------|-------|-------------|
| **Personas by Module** | [Personas by Module](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md#12-personas-by-module) | PSP_ADMIN, BRAND_ADMIN, STORE_USER etc. |

---

## 7. Process Flows by Module

### Brand Admin Module
| Process | Location | Description |
|---------|----------|-------------|
| Campaign Creation | [SUPP-015](../02_SUPPs/Brand_Admin_Module/SUPP-015%20-%20Brand%20Admin%20Module%20-%20Campaigns%20Kits%20Assignment%20-%20v0.4.md) | Draft → configure → select stores → publish |
| Store Selection | [SUPP-015 §1](../02_SUPPs/Brand_Admin_Module/SUPP-015%20-%20Brand%20Admin%20Module%20-%20Campaigns%20Kits%20Assignment%20-%20v0.4.md#1-store-selection-ux) | Include/exclude logic, preview, save recipe |
| Photo Review | [SUPP-018](../02_SUPPs/Brand_Admin_Module/) | Review queue → approve/reject → retake loop |
| Waiver/Reopen | [SUPP-018](../02_SUPPs/Brand_Admin_Module/) | Admin override workflows |

### PSP Operations Module
| Process | Location | Description |
|---------|----------|-------------|
| Order Acknowledgment | [SUPP-016](../02_SUPPs/PSP_Operations_Module/) | Receive orders → acknowledge → route to production |
| Shipment Creation | [SUPP-016](../02_SUPPs/PSP_Operations_Module/) | Batch → produce → ship → tracking |
| Reorder Flow | [SUPP-019](../02_SUPPs/Store_Execution_Module/) | Issue approved → reorder generated → ship replacement |

### Store Execution Module
| Process | Location | Description |
|---------|----------|-------------|
| Receipt Verification | [SUPP-017](../02_SUPPs/Store_Execution_Module/) | Shipment delivered → verify items → report issues |
| Installation | [SUPP-017](../02_SUPPs/Store_Execution_Module/) | Install at slots → capture photos → attestation |
| Issue Reporting | [SUPP-019](../02_SUPPs/Store_Execution_Module/) | Missing/damaged → submit issue → await resolution |
| Retake Flow | [SUPP-018](../02_SUPPs/Brand_Admin_Module/) | Rejection received → retake photo → resubmit |

---

## 8. Chart Types Reference

| Type | Mermaid Syntax | Use For |
|------|----------------|---------|
| State Machine | `stateDiagram-v2` | Status lifecycles, valid transitions |
| Flowchart | `flowchart TD/LR/TB` | Process flows, decision trees, architecture |
| Sequence | `sequenceDiagram` | Multi-actor workflows with timing |
| ERD | `erDiagram` | Entity relationships, data model |

---

## Cross-References

| Document | Purpose |
|----------|---------|
| [GLOSSARY.md](./GLOSSARY.md) | Terminology definitions |
| [SOW_FRAMEWORK.md](./SOW_FRAMEWORK.md) | Documentation maintenance rules |
| [00_DOC_INDEX.md](./00_DOC_INDEX.md) | All SUPP documents |
| [OpenAPI Spec](../../API/openapi.yaml) | API contract |

---

*End of Process Flow Index*
