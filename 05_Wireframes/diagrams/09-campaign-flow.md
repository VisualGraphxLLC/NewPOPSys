# Campaign Flow (End-to-End)

Shows the complete end-to-end campaign workflow across all three portals.

```mermaid
flowchart TB
  subgraph BRAND["Brand Portal"]
    B1["Draft campaign<br/>(kit + rules + stores)"]
    B2["Publish<br/>(generate orders)"]
    B3["Review proofs<br/>(approve/reject)"]
    B4["Rollups + reporting/exports"]
  end

  subgraph PSP["PSP Portal"]
    P1["Create orders/lines"]
    P2["Batch + produce + ship"]
    P3["Reorder/replacement ship"]
  end

  subgraph STORE["Store App"]
    S1["Receive/verify"]
    S2["Install"]
    S3["Proof capture + attestation"]
    S4["Retake proofs"]
    S5["Complete store task"]
  end

  B1 --> B2
  B2 --> P1
  P1 --> P2
  P2 --> S1
  S1 --> S2
  S2 --> S3
  S3 --> B3
  B3 -->|approved| S5
  B3 -->|rejected| S4
  S4 --> S3
  S5 --> B4
  S2 -->|issue/reorder| P3
  P3 --> S1
```

## Workflow Phases

| Phase | Portal | Actions |
|-------|--------|---------|
| **Configure** | Brand | Draft campaign, define kit, select stores |
| **Publish** | Brand | Activate campaign, generate orders |
| **Fulfill** | PSP | Batch, produce, ship materials |
| **Execute** | Store | Receive, install, capture photos |
| **Verify** | Brand | Review photos, approve/reject |
| **Complete** | All | Rollups, reporting, exports |
