# NewPOPSys v1 — Roll-up Algorithm (Qty-Normalized)

## Data primitives (normalize everything to quantities)
Track per `(campaignId, storeId, skuId[, slotId])`:

- `requiredQty` — planned requirement (AssignmentItem)
- `shippedQty` — total shipped (Σ ShipmentLine shipped)
- `deliveredQty` — total delivered (Σ ShipmentLine delivered)
- `receivedGoodQty` — store accepted usable qty
- `receivedDamagedQty` — store marked damaged qty
- `installedQty` — store marked installed qty
- `satisfiedQty` — verification satisfied qty (approved/waived)
- `hasCarrierException` — any unresolved carrier exception for related shipment(s)
- `hasOpenIssue` — any open IssueLine for sku/qty

Policy per campaign (or per kit item):
- `executionBlockingPolicy ∈ { ALL_ITEMS_REQUIRED_BEFORE_START, ALLOW_PARTIAL_EXECUTION, ALLOW_PARTIAL_EXECUTION_BUT_BLOCK_COMPLETION }`
- Optional per item: `isBlocking = true|false`

---

## Step 1 — OrderLine rollups (PSP truth)
Aggregate at the OrderLine:

```text
OrderLine.shippedQty   = Σ ShipmentLine.shippedQty
OrderLine.deliveredQty = Σ ShipmentLine.deliveredQty
OrderLine.hasCarrierException = any(Shipment.status == EXCEPTION and not resolved)
```

### FulfillmentStatus (qty-derived)
```pseudo
function fulfillmentStatus(requiredQty, shippedQty, deliveredQty, hasCarrierException, cancelled=false):
  if cancelled: return CANCELLED
  if hasCarrierException: return EXCEPTION

  if shippedQty <= 0: return NOT_SHIPPED
  if shippedQty < requiredQty: return PARTIALLY_SHIPPED

  // shippedQty >= requiredQty
  if deliveredQty <= 0: return SHIPPED
  if deliveredQty < requiredQty: return PARTIALLY_DELIVERED
  return DELIVERED
```

---

## Step 2 — Receipt rollups (Store truth)
Compute discrepancies (line/qty-level):

```pseudo
receivedTotalQty = receivedGoodQty + receivedDamagedQty
missingQty = max(0, deliveredQty - receivedTotalQty)
hasReceiptDiscrepancy = (missingQty > 0) OR (receivedDamagedQty > 0)
```

### ReceiptStatus (qty-derived)
```pseudo
function receiptStatus(deliveredQty, receivedGoodQty, receivedDamagedQty):
  receivedTotal = receivedGoodQty + receivedDamagedQty

  if deliveredQty <= 0: return NOT_DELIVERED
  if receivedTotal <= 0: return NOT_RECEIVED
  if receivedTotal < deliveredQty: return PARTIALLY_RECEIVED
  if receivedDamagedQty > 0: return RECEIVED_WITH_DAMAGE
  return RECEIVED
```

---

## Step 3 — StoreAssignment rollups (Brand/Store truth)
Compute store totals:

```pseudo
store.requiredQty      = Σ item.requiredQty
store.deliveredQty     = Σ item.deliveredQty
store.receivedGoodQty  = Σ item.receivedGoodQty
store.installedQty     = Σ item.installedQty
store.satisfiedQty     = Σ item.satisfiedQty

store.fulfillmentPct = clamp(store.deliveredQty / store.requiredQty, 0..1)
store.receiptPct     = clamp(store.receivedGoodQty / store.requiredQty, 0..1)
store.installPct     = clamp(store.installedQty / store.requiredQty, 0..1)
store.verifyPct      = clamp(store.satisfiedQty / store.requiredQty, 0..1)

store.hasBlockingInventory =
  any(item.isBlocking == true AND item.receivedGoodQty < item.requiredQty AND item.waived == false)

store.hasOpenIssues = any(item.hasOpenIssue)
```

### Execution readiness (READY vs NOT_READY)
```pseudo
function isReady(policy, items):
  if policy == ALL_ITEMS_REQUIRED_BEFORE_START:
    return all(items.receivedGoodQty >= items.requiredQty OR items.waived)
  else:
    // partial execution allowed
    return any(items.receivedGoodQty > 0 OR items.waived)
```

### Completion allowed (can store “Complete”)
```pseudo
function canComplete(policy, items):
  if policy == ALLOW_PARTIAL_EXECUTION:
    return true

  // default best practice:
  // allow partial execution but require all requirements satisfied (or waived) to complete
  return all(items.satisfiedQty >= items.requiredQty OR items.waived)
```

---

## Step 4 — Campaign rollups (portfolio truth)
```pseudo
campaign.storesTotal     = count(StoreAssignments)
campaign.storesDelivered = count(store where store.fulfillmentPct == 1)
campaign.storesExecuting = count(store where store.installPct > 0 and store.verifyPct < 1)
campaign.storesInReview  = count(store where store.submitted == true and store.verifyPct < 1)
campaign.storesComplete  = count(store where store.verifyPct == 1 OR store.waived)

campaign.fulfillmentPct = average(store.fulfillmentPct)
campaign.verifyPct      = average(store.verifyPct)
```
