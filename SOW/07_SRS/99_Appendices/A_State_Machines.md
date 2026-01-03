# Appendix A: State Machine Diagrams

## A.1 Overview

This appendix consolidates all state machine diagrams used throughout the NewPOPSys platform. These diagrams define the valid states, transitions, and triggers for key business entities.

### State Machine Categories

| Category | Entities | Owner |
|----------|----------|-------|
| Campaign Lifecycle | Campaign | Brand Portal |
| Store Execution | StoreAssignment, AssignmentItem | Store App / Brand Portal |
| Fulfillment | StoreOrder, Shipment, FulfillmentStatus | PSP Portal |
| Verification | PhotoReview, IssueRequest | Brand Portal |

---

## A.2 Campaign Lifecycle States

The campaign progresses through a defined lifecycle from creation to archival.

### A.2.1 Campaign Status State Diagram

![99_Appendices_A_State_Machines_diagram_0](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_0.png)

### A.2.2 Campaign State Definitions

| State | Description | Allowed Actions |
|-------|-------------|-----------------|
| **DRAFT** | Campaign being configured; not visible to stores | Edit all fields, delete, schedule, publish |
| **SCHEDULED** | Set to publish at a future date | Edit until publish time, unschedule, cancel |
| **PUBLISHED** | Active campaign; stores can execute | Add stores, monitor, terminate |
| **COMPLETED** | All stores satisfied or end date passed | View reports, archive |
| **CANCELLED** | Terminated before natural completion | View history, archive |
| **ARCHIVED** | Historical record; read-only | View only |

### A.2.3 Campaign Transition Triggers

| From | To | Trigger | Actor |
|------|-----|---------|-------|
| DRAFT | SCHEDULED | `campaign.schedule(startDate)` | Brand Admin |
| DRAFT | PUBLISHED | `campaign.publish()` | Brand Admin |
| SCHEDULED | PUBLISHED | System scheduler (cron) | System |
| PUBLISHED | COMPLETED | Rollup satisfies threshold OR `endDate <= now` | System |
| PUBLISHED | CANCELLED | `campaign.terminate(reason)` | Brand Admin |
| * | ARCHIVED | `campaign.archive()` | Brand Admin |

---

## A.3 Store Assignment States

Tracks each store's progress through a campaign from assignment to completion.

### A.3.1 StoreAssignment Status State Diagram

![99_Appendices_A_State_Machines_diagram_1](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_1.png)

### A.3.2 StoreAssignment State Definitions

| State | Description | Store Can... | Admin Can... |
|-------|-------------|--------------|--------------|
| **ASSIGNED** | Store selected for campaign | View campaign details | Edit assignment |
| **READY** | Materials delivered; execution allowed | Begin installation | Force ready status |
| **IN_PROGRESS** | Store actively working | Capture photos, report issues | Monitor progress |
| **SUBMITTED** | All photos submitted for review | Wait for review | Review photos |
| **COMPLETE** | All requirements satisfied | View completion | Reopen if needed |
| **REWORK_REQUIRED** | Photos rejected; needs retry | View feedback, retake | Send reminders |
| **REOPENED** | Admin reopened for additional work | Continue execution | Close again |
| **WAIVED** | Admin bypassed verification | N/A | View waiver reason |

---

## A.4 Assignment Item States

Tracks individual kit items at a store through the fulfillment and execution lifecycle.

### A.4.1 AssignmentItem Status State Diagram

![99_Appendices_A_State_Machines_diagram_2](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_2.png)

### A.4.2 AssignmentItem State Definitions

| State | Description | Next Expected Action |
|-------|-------------|---------------------|
| **PLANNED** | Item assigned to store, not yet ordered | PSP creates order |
| **ORDERED** | Order line exists in PSP system | PSP ships item |
| **SHIPPED** | Item in transit to store | Carrier delivers |
| **DELIVERED** | Carrier confirmed delivery | Store verifies receipt |
| **RECEIVED** | Store verified item received | Store installs |
| **INSTALLED** | Installation recorded | Store uploads photo |
| **PROOF_SUBMITTED** | Photo pending review | Admin reviews |
| **SATISFIED** | Photo approved; item complete | None |
| **RETAKE_REQUIRED** | Photo rejected; needs retry | Store retakes photo |
| **EXCEPTION** | Issue reported (escalated) | Issue resolution flow |

---

## A.5 Fulfillment States

Tracks order and shipment progress from PSP perspective.

### A.5.1 FulfillmentStatus State Diagram (Computed)

![99_Appendices_A_State_Machines_diagram_3](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_3.png)

### A.5.2 FulfillmentStatus Computation Logic

| Status | Condition |
|--------|-----------|
| NOT_SHIPPED | `shippedQty = 0` |
| PARTIALLY_SHIPPED | `0 < shippedQty < requiredQty` |
| SHIPPED | `shippedQty >= requiredQty` |
| PARTIALLY_DELIVERED | `0 < deliveredQty < shippedQty` |
| DELIVERED | `deliveredQty >= requiredQty` |
| EXCEPTION | Carrier reports exception flag |
| CANCELLED | Order marked cancelled |

---

## A.6 Photo Review States

Tracks individual photo review workflow.

### A.6.1 PhotoReview Status State Diagram

![99_Appendices_A_State_Machines_diagram_4](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_4.png)

### A.6.2 PhotoReview State Definitions

| State | Description | Next Action |
|-------|-------------|-------------|
| **PENDING** | Photo submitted, awaiting review | Reviewer approves/rejects |
| **APPROVED** | Photo meets requirements | None (terminal) |
| **REJECTED** | Photo fails requirements | Store uploads retake |
| **SUPERSEDED** | Original replaced by retake | New photo reviewed |

### A.6.3 Rejection Reason Codes

| Code | Description |
|------|-------------|
| `BLURRY` | Image not in focus |
| `WRONG_ANGLE` | Incorrect camera angle |
| `OBSTRUCTED` | Item partially blocked |
| `WRONG_ITEM` | Incorrect item photographed |
| `NOT_INSTALLED` | Item not properly installed |
| `POOR_LIGHTING` | Insufficient lighting |
| `OTHER` | Free-text reason required |

---

## A.7 Issue Request States

Tracks issue reporting, triage, and resolution workflow.

### A.7.1 IssueRequest Status State Diagram

![99_Appendices_A_State_Machines_diagram_5](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_5.png)

### A.7.2 IssueRequest State Definitions

| State | Description | Responsible Party |
|-------|-------------|-------------------|
| **OPEN** | Issue reported by store | System (auto-triage) |
| **TRIAGED** | Classified and routed | System / PSP Admin |
| **AWAITING_APPROVAL** | Requires brand approval | Brand Admin |
| **APPROVED** | Approved for reorder | PSP Operations |
| **DENIED** | Issue rejected | None (closed) |
| **IN_FULFILLMENT** | Replacement being shipped | PSP Operations |
| **RESOLVED** | Replacement received | None (closed) |

### A.7.3 Issue Type Classifications

| Type | Description | Auto-Approve Eligible |
|------|-------------|----------------------|
| MISSING | Item not in shipment | Yes (if < threshold) |
| DAMAGED | Item arrived damaged | Yes (with photo) |
| INCORRECT | Wrong item shipped | No (requires review) |
| PACKAGING | Packaging issue only | No |

---

## A.8 Deinstall Task States

Tracks end-of-campaign material removal workflow.

### A.8.1 DeinstallTask Status State Diagram

![99_Appendices_A_State_Machines_diagram_6](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_6.png)

### A.8.2 DeinstallTask State Definitions

| State | Description |
|-------|-------------|
| **PENDING** | Task created when campaign ends |
| **IN_PROGRESS** | Store actively removing materials |
| **SUBMITTED** | Store marked removal complete |
| **VERIFIED** | Admin confirmed removal (optional) |
| **REJECTED** | Removal not complete; rework needed |

---

## A.9 Store Order States

Tracks PSP order processing workflow.

### A.9.1 StoreOrder Status State Diagram

![99_Appendices_A_State_Machines_diagram_7](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_7.png)

### A.9.2 StoreOrder State Definitions

| State | PSP Action | Store Visibility |
|-------|------------|------------------|
| **PENDING** | Review order details | "Order Placed" |
| **CONFIRMED** | Acknowledge receipt | "Order Confirmed" |
| **IN_PRODUCTION** | Produce materials | "In Production" |
| **READY_TO_SHIP** | Pick, pack, ship | "Ready to Ship" |
| **SHIPPED** | Tracking provided | "Shipped" with tracking |
| **DELIVERED** | Carrier confirmed | "Delivered" |
| **ON_HOLD** | Resolve issue | "Delayed" |
| **CANCELLED** | Order cancelled | "Cancelled" |

---

## A.10 State Interrelationships

### A.10.1 Status Ownership by Module

![99_Appendices_A_State_Machines_diagram_8](../diagrams_rendered/99_Appendices_A_State_Machines_diagram_8.png)

### A.10.2 StorePhase Computation

The `StorePhase` is a computed rollup representing overall store progress:

| Phase | Criteria |
|-------|----------|
| **PENDING** | Assigned but materials not shipped |
| **SHIPPING** | Materials shipped, not delivered |
| **RECEIVING** | Delivered, receipt not complete |
| **EXECUTING** | Receipt complete, installation in progress |
| **VERIFYING** | Photos submitted, awaiting review |
| **COMPLETE** | All items satisfied or waived |
| **EXCEPTION** | Has unresolved issues |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SOW Diagram Collection, SUPP-001, SUPP-002*
