# FulfillmentStatus State Diagram

Shows the quantity-derived states for shipment and delivery tracking.

```mermaid
stateDiagram-v2
  [*] --> NOT_SHIPPED

  NOT_SHIPPED --> PARTIALLY_SHIPPED : shippedQty > 0
  PARTIALLY_SHIPPED --> SHIPPED : shippedQty >= requiredQty

  SHIPPED --> PARTIALLY_DELIVERED : deliveredQty > 0
  PARTIALLY_DELIVERED --> DELIVERED : deliveredQty >= requiredQty

  NOT_SHIPPED --> EXCEPTION : carrier exception
  PARTIALLY_SHIPPED --> EXCEPTION : carrier exception
  SHIPPED --> EXCEPTION : carrier exception
  PARTIALLY_DELIVERED --> EXCEPTION : carrier exception

  EXCEPTION --> NOT_SHIPPED : resolved + no shipments
  EXCEPTION --> PARTIALLY_SHIPPED : resolved + some shipped
  EXCEPTION --> SHIPPED : resolved + fully shipped

  NOT_SHIPPED --> CANCELLED : order cancelled
  PARTIALLY_SHIPPED --> CANCELLED : order cancelled
  CANCELLED --> [*]
  DELIVERED --> [*]
```

## States

| State | Trigger |
|-------|---------|
| NOT_SHIPPED | Initial state |
| PARTIALLY_SHIPPED | Some qty shipped |
| SHIPPED | All required qty shipped |
| PARTIALLY_DELIVERED | Some qty delivered |
| DELIVERED | All required qty delivered |
| EXCEPTION | Carrier exception reported |
| CANCELLED | Order cancelled |
