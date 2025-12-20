# NewPOPSys v1 — Status Tables (Split Shipping vs Progress)

## FulfillmentStatus (PSP-owned)
| Status | Definition (qty-based) |
|---|---|
| NOT_SHIPPED | `shippedQty = 0` |
| PARTIALLY_SHIPPED | `0 < shippedQty < requiredQty` |
| SHIPPED | `shippedQty >= requiredQty AND deliveredQty = 0` |
| PARTIALLY_DELIVERED | `0 < deliveredQty < requiredQty` |
| DELIVERED | `deliveredQty >= requiredQty` |
| EXCEPTION | unresolved carrier exception (overrides) |
| CANCELLED | cancelled/terminated (terminal) |

## ReceiptStatus (Store-owned)
| Status | Definition |
|---|---|
| NOT_DELIVERED | `deliveredQty = 0` |
| NOT_RECEIVED | delivered but `receivedGoodQty + receivedDamagedQty = 0` |
| PARTIALLY_RECEIVED | `0 < receivedTotal < deliveredQty` |
| RECEIVED_WITH_DAMAGE | `receivedTotal >= deliveredQty AND receivedDamagedQty > 0` |
| RECEIVED | `receivedTotal >= deliveredQty AND receivedDamagedQty = 0` |

## ExecutionStatus (Store-owned)
| Status | Definition |
|---|---|
| NOT_READY | readiness false (blocked by policy/inventory) |
| READY | readiness true, not started |
| IN_PROGRESS | installs started (`installedQty > 0`) |
| SUBMITTED | proofs submitted (awaiting review) |
| REWORK_REQUIRED | retake requested |
| COMPLETE | completion allowed + store marked complete |
| REOPENED | admin reopened after complete |
| BLOCKED | explicit blocking (open issues + policy says stop) |

## VerificationStatus (Brand/Regional-owned)
| Status | Definition |
|---|---|
| NA | nothing submitted yet |
| PENDING | submission exists, not fully reviewed |
| PARTIALLY_APPROVED | some satisfied, not all |
| APPROVED | `satisfiedQty >= requiredQty` (or waived) |
| REJECTED | any required proof rejected (retake required) |
| WAIVED | waived to satisfied (audit reason required) |
