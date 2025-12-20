# IssueRequestStatus State Diagram

Shows the workflow for issue reporting, triage, and resolution.

```mermaid
stateDiagram-v2
  [*] --> OPEN

  OPEN --> TRIAGED : classified + routed
  TRIAGED --> AWAITING_APPROVAL : needs brand approval
  TRIAGED --> APPROVED : auto-approved by policy
  TRIAGED --> DENIED : rejected

  AWAITING_APPROVAL --> APPROVED : brand approved
  AWAITING_APPROVAL --> DENIED : brand denied

  APPROVED --> IN_FULFILLMENT : reorder created
  IN_FULFILLMENT --> RESOLVED : replacement shipped + received

  DENIED --> [*]
  RESOLVED --> [*]
```

## States

| State | Description |
|-------|-------------|
| OPEN | Issue reported by store |
| TRIAGED | Classified and routed for approval |
| AWAITING_APPROVAL | Requires brand approval |
| APPROVED | Approved for reorder |
| DENIED | Issue rejected |
| IN_FULFILLMENT | Replacement being produced/shipped |
| RESOLVED | Replacement received |

## Approval Policies

- **Auto-approve**: Below threshold (qty/value)
- **Manual**: Above threshold → brand review
