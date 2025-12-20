# AssignmentItemStatus State Diagram

Shows the complete lifecycle of an item at a store from planning through satisfaction.

```mermaid
stateDiagram-v2
  [*] --> PLANNED

  PLANNED --> ORDERED : orderline created
  ORDERED --> SHIPPED : shipmentline created
  SHIPPED --> DELIVERED : carrier delivered
  DELIVERED --> RECEIVED : store verify

  RECEIVED --> INSTALLED : install recorded
  RECEIVED --> EXCEPTION : issue reported

  INSTALLED --> PROOF_SUBMITTED : photo submitted
  PROOF_SUBMITTED --> SATISFIED : approved
  PROOF_SUBMITTED --> RETAKE_REQUIRED : rejected

  RETAKE_REQUIRED --> PROOF_SUBMITTED : retake resubmitted

  SATISFIED --> [*]
  EXCEPTION --> [*]
```

## States

| State | Description |
|-------|-------------|
| PLANNED | Item assigned, not yet ordered |
| ORDERED | Order line created for PSP |
| SHIPPED | Item in transit |
| DELIVERED | Carrier confirmed delivery |
| RECEIVED | Store verified receipt |
| INSTALLED | Installation recorded |
| PROOF_SUBMITTED | Photo uploaded for review |
| SATISFIED | Photo approved, item complete |
| RETAKE_REQUIRED | Photo rejected, needs retry |
| EXCEPTION | Issue reported (missing/damaged) |
