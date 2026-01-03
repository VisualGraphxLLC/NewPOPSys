# PhotoReviewStatus State Diagram

Shows the states for individual photo review items.

```mermaid
stateDiagram-v2
  [*] --> PENDING

  PENDING --> APPROVED : reviewer approves
  PENDING --> REJECTED : reviewer rejects

  REJECTED --> SUPERSEDED : retake uploaded
  SUPERSEDED --> PENDING : new photo enters review

  APPROVED --> [*]
```

## States

| State | Description |
|-------|-------------|
| PENDING | Photo submitted, awaiting review |
| APPROVED | Photo accepted |
| REJECTED | Photo rejected with reason |
| SUPERSEDED | Original replaced by retake (new photo enters review) |

## Review Actions

- **Approve**: Photo meets requirements
- **Reject**: Photo fails requirements (with reason code)
- **Supersede**: Automatically when retake uploaded; new photo starts at PENDING
