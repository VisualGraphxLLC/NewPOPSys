# Partial Shipment & Receipt Exception

Sequence diagram showing exception handling for partial shipments and damaged items.

```mermaid
sequenceDiagram
autonumber
participant Brand as Brand Portal
participant PSP as PSP Ops
participant Store as Store App
participant Sys as System

Brand->>Sys: Publish campaign (assignments + orderlines)
Sys->>PSP: Orders generated

PSP->>Sys: Shipment #1 ships (partial lines/qty)
Sys-->>Store: Tracking + items expected
PSP->>Sys: Shipment #1 delivered

Store->>Sys: Receive shipment (accept some, mark missing/damaged)
Sys->>Sys: Compute missing/damaged per line
Sys->>Sys: Create Issue + IssueLines (affected qty only)
Sys->>PSP: Create Reorder for IssueLines
PSP->>Sys: Replacement shipment ships/delivers
Store->>Sys: Receive replacement
Sys-->>Brand: Rollups update (store % bars + phases)
```

## Flow Summary

1. Brand publishes campaign → orders auto-generated
2. PSP ships partial order
3. Store receives and reports issues
4. System creates issue + reorder automatically
5. PSP ships replacement
6. Rollups update for brand visibility
