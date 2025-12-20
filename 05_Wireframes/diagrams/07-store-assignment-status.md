# StoreAssignmentStatus State Diagram

Shows store execution states from assignment through completion.

```mermaid
stateDiagram-v2
  [*] --> ASSIGNED

  ASSIGNED --> READY : inventory delivered / manual allow
  READY --> IN_PROGRESS : store starts
  IN_PROGRESS --> SUBMITTED : proofs submitted

  SUBMITTED --> COMPLETE : approved
  SUBMITTED --> WAIVED : admin waives compliance
  SUBMITTED --> REWORK_REQUIRED : rejected

  REWORK_REQUIRED --> IN_PROGRESS : retake started
  REWORK_REQUIRED --> SUBMITTED : resubmitted

  COMPLETE --> REOPENED : admin reopen
  REOPENED --> IN_PROGRESS : work continues

  WAIVED --> [*]
  COMPLETE --> [*]
```

## States

| State | Description |
|-------|-------------|
| ASSIGNED | Store selected for campaign |
| READY | Materials delivered, can start |
| IN_PROGRESS | Store actively executing |
| SUBMITTED | Photos submitted for review |
| COMPLETE | All items satisfied/waived |
| REWORK_REQUIRED | Photos rejected, needs retry |
| REOPENED | Admin reopened completed work |
| WAIVED | Admin waived approval review (execution completed) |
