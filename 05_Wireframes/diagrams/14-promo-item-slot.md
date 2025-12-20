# Promo Item - Slot Status Interrelation

Shows how kit items bind to location slots and track status.

```mermaid
flowchart TB
  subgraph ITEM["AssignmentItem (per store)"]
    KI["KitItem<br/>(SKU + qty)"]
    LS["LocationSlot<br/>(where to install)"]
    AI["AssignmentItem<br/>binds item to slot"]
  end

  subgraph STATUS["Status Tracking"]
    AIS["AssignmentItemStatus<br/>PLANNED → ... → SATISFIED"]
    SVS["SlotVerificationStatus<br/>PENDING → SATISFIED/WAIVED"]
  end

  KI --> AI
  LS --> AI
  AI --> AIS
  AIS --> SVS
```

## Relationships

| Entity | Purpose |
|--------|---------|
| **KitItem** | What to install (SKU, quantity) |
| **LocationSlot** | Where to install (position in store) |
| **AssignmentItem** | Links item to slot for specific store |
| **AssignmentItemStatus** | Tracks execution progress |
| **SlotVerificationStatus** | Tracks verification completion |

## Status Flow

1. KitItem + LocationSlot → AssignmentItem created
2. AssignmentItem progresses through states
3. SlotVerificationStatus updated when photo approved/waived
