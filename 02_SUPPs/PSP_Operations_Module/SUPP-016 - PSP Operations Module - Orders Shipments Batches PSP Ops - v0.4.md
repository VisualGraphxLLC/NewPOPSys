# SUPP-016 — PSP Operations Module — Orders Shipments Batches

> **Version**: v0.4  
> **Status**: Locked  
> **Updated**: 2025-12-18  
> **Dependencies**: SUPP-015 (Campaigns)

---

## Purpose
Define the PSP operational backbone: order generation, split shipments, MIS integration, and reorder handling.

---

## 1. Order Model (Campaign → Store Order)
- **Hierarchy**: `Campaign` (1) → `StoreOrder` (N).
- **Granularity**: 1 order per store per campaign (default).
- **Reorders**: Handled as **separate** `StoreOrder` records linked to the same assignment, with `type=REORDER`.
- **Identity**: System generates `orderNumber` (e.g. `ORD-1001`). PSP assigns their own `pspOrderRef` (MIS ID).

### Entities (Draft)
| Entity | Key Fields |
|--------|------------|
| `StoreOrder` | `orderId`, `campaignId`, `storeId`, `type` (INITIAL/REORDER), `orderNumber`, `pspOrderRef` (MIS ID), `status`, `shippingSnapshotJson` |
| `OrderLine` | `lineId`, `orderId`, `itemId`, `sku`, `qty` |

---

## 2. Inbound Integration (MIS Mapping)
The PSP will push data back to the system via API/Webhooks.
- **Order Acknowledgment**: PSP receives order, creates it in MIS, pushes back `pspOrderRef` + `status=ACKNOWLEDGED`.
- **Shipment Creation**: PSP pushes shipment details + tracking.
- **Status Updates**: PSP pushes status changes (e.g. `IN_PRODUCTION`).

---

## 3. Shipments (Split & Partial)
- **Many-to-One**: A `StoreOrder` can have multiple `Shipment` records.
- **Partial Logic**: `ShipmentLine` table tracks exactly what was in *this* box.
- **Tracking**: A single shipment can have multiple tracking numbers (multi-box).

### Entities (Draft)
| Entity | Key Fields |
|--------|------------|
| `Shipment` | `shipmentId`, `orderId`, `status`, `carrier`, `shippedAt` |
| `ShipmentTracking` | `trackingNumber` |
| `ShipmentLine` | `shipmentId`, `orderLineId`, `qtyShipped` |

---

## 4. Batching (Out of Scope v1)
- PSPs *do* batch orders internally (e.g. by region).
- **v1 Scope**: System does *not* manage batch logic.
- **Support**: `StoreOrder` has an optional `batchLabel` field if PSP wants to tag it via API, but no "Batch Management" UI is built.

---

## 5. Reorder Handling
- **Trigger**: Approved `IssueRequest` (SUPP-019).
- **Action**: System generates a new `StoreOrder` with `type=REORDER`.
- **Content**: Only contains the replacement items.
- **Process**: Follows standard fulfillment flow (Ack -> Ship -> Track).
- **Reporting**: Rolled up to Campaign totals but tracked distinctly.

---

## 6. Acceptance Criteria
1.  **Generation**: Publishing creates `StoreOrders`.
2.  **MIS Integration**: Can update `pspOrderRef` and status via API.
3.  **Split Shipments**: Can create Shipment with subset of line items.
4.  **Reorders**: Approved issue creates new `StoreOrder` of type REORDER.
5.  **Tracking**: Multiple tracking numbers per shipment supported.

