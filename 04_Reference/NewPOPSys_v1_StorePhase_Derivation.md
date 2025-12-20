# NewPOPSys v1 — Derived StorePhase (What Brand Sees)

StorePhase is a **single display value** computed from the parallel columns:
- FulfillmentStatus
- ReceiptStatus
- ExecutionStatus
- VerificationStatus
- Open Issues + Policy flags

**Important:** Keep the raw columns visible; StorePhase is the headline.

## StorePhase derivation precedence (top-down)
| Priority | If… | StorePhase |
|---:|---|---|
| 1 | `VerificationStatus == REJECTED` OR `ExecutionStatus == REWORK_REQUIRED` | REWORK |
| 2 | `ExecutionStatus == COMPLETE` AND (`VerificationStatus == APPROVED` OR `VerificationStatus == WAIVED`) | COMPLETE |
| 3 | `ExecutionStatus == SUBMITTED` OR `VerificationStatus in {PENDING, PARTIALLY_APPROVED}` | IN_REVIEW |
| 4 | `ExecutionStatus == IN_PROGRESS` | EXECUTING |
| 5 | `ExecutionStatus == READY` | READY_TO_EXECUTE |
| 6 | `hasOpenIssues == true` AND policy blocks execution | BLOCKED_BY_EXCEPTION |
| 7 | `FulfillmentStatus in {NOT_SHIPPED, PARTIALLY_SHIPPED}` | WAITING_FOR_SHIPMENT |
| 8 | `FulfillmentStatus in {SHIPPED, PARTIALLY_DELIVERED}` | IN_TRANSIT |
| 9 | `FulfillmentStatus == DELIVERED` AND `ReceiptStatus in {NOT_RECEIVED, PARTIALLY_RECEIVED}` | AWAITING_RECEIPT |
| 10 | else | UNKNOWN (signals data inconsistency) |

## Exception handling rule (receipt)
Default is **split by line + qty**:
- Store receives what arrived (accepted/damaged)
- System computes missing qty
- System creates Issue + IssueLines for affected sku/qty
- System generates Reorder/replacement shipment for affected sku/qty
- Original order remains historical truth (no rewriting)
