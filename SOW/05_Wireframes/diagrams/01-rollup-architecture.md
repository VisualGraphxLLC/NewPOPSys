# Roll-up Architecture

Shows how quantities flow from PSP fulfillment through store execution to campaign rollups.

```mermaid
flowchart LR
  subgraph PSP["PSP (Fulfillment)"]
    OL["OrderLine<br/>requiredQty / shippedQty / deliveredQty"]
    SL["ShipmentLine(s)<br/>partial qty"]
    OL --> SL
  end

  subgraph STORE["Store (Receipt + Execution)"]
    RC["Receipt Lines<br/>accepted / damaged / missing"]
    IR["InstallRecord(s)<br/>installedQty"]
    RC --> IR
  end

  subgraph BRAND["Brand (Verification)"]
    PR["PhotoReview(s)<br/>approved / rejected"]
    SV["Satisfied Rollup<br/>satisfiedQty / waived"]
    PR --> SV
  end

  SL -->|"deliveredQty"| RC
  OL --> AI["AssignmentItem Rollup<br/>qty + statuses"]
  RC --> AI
  IR --> AI
  SV --> AI

  AI --> SA["StoreAssignment Rollup<br/>% delivered / received / installed / satisfied"]
  SA --> CP["Campaign Rollup<br/>store counts + averages"]
```

## Data Flow

| Source | Aggregates To | Metrics |
|--------|---------------|---------|
| OrderLine | AssignmentItem | Required, shipped, delivered qty |
| ReceiptLine | AssignmentItem | Accepted, damaged, missing |
| InstallRecord | AssignmentItem | Installed qty |
| PhotoReview | AssignmentItem | Satisfied, waived |
| AssignmentItem | StoreAssignment | % complete per phase |
| StoreAssignment | Campaign | Store counts, averages |
