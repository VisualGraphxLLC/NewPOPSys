# NewPOPSys v1 Status Glossary (Concise)

> **Converted from**: NewPOPSys_v1_Status_Glossary_Concise.docx
> **Converted**: 2025-12-19
> **Note**: This content has been merged into [GLOSSARY.md](../../00_Index/GLOSSARY.md)

---

## Purpose

Define enum-friendly statuses, ownership, and primary transitions for Campaigns, Fulfillment, Store Execution, Proof Review, and Exceptions.

## Conventions

- **Owner** = module/persona allowed to change status (system may auto-advance based on events)
- Statuses move only via auditable events (webhook/API/UI actions)
- Prefer reopen/retake over editing history

---

## CampaignStatus

**Owner**: Brand Admin (manual) + System (auto)

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `DRAFT` | Editable; not live | → SCHEDULED (set start) / PUBLISHED (publish now) / CANCELLED |
| `SCHEDULED` | Will auto-publish at start_time | → PUBLISHED (time reached) / DRAFT (unschedule) / CANCELLED |
| `PUBLISHED` | Assignments + orders generated; execution active | → COMPLETED (rollup satisfied) / CANCELLED (terminate) |
| `COMPLETED` | Closed normally | → ARCHIVED |
| `CANCELLED` | Terminated early | → ARCHIVED |
| `ARCHIVED` | Read-only historical | Terminal |

---

## StoreAssignmentStatus

**Owner**: System (auto) + Brand/Regional (overrides)

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `ASSIGNED` | Store targeted; waiting on readiness | → READY (inventory delivered OR manual allow) |
| `READY` | Store can execute | → IN_PROGRESS (store starts) |
| `IN_PROGRESS` | Store actively working | → SUBMITTED (proof package submitted) |
| `SUBMITTED` | Awaiting review | → COMPLETE (approved/waived) / REWORK_REQUIRED (rejected) |
| `REWORK_REQUIRED` | Retake requested | → IN_PROGRESS (retake started) / SUBMITTED (resubmitted) |
| `COMPLETE` | Counts toward campaign completion | → REOPENED (admin reopen) |
| `REOPENED` | Admin reopened after complete | → IN_PROGRESS |
| `WAIVED` | Complete by exception/waiver | Treated as COMPLETE (audit reason required) |

---

## AssignmentItemStatus

**Owner**: System + Store + Verification

> One promo item @ one store slot

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `PLANNED` | Requirement exists from publish | → ORDERED (orderline created) |
| `ORDERED` | Ordered for this store | → SHIPPED (shipmentline created) |
| `SHIPPED` | In transit | → DELIVERED (carrier delivered) |
| `DELIVERED` | Delivered to store | → RECEIVED (store receive/verify) |
| `RECEIVED` | Store confirmed receipt | → INSTALLED (install recorded) / EXCEPTION (issue) |
| `INSTALLED` | Installed at slot | → PROOF_SUBMITTED (submission) |
| `PROOF_SUBMITTED` | Proof submitted for review | → SATISFIED (approved) / RETAKE_REQUIRED (rejected) |
| `RETAKE_REQUIRED` | Retake needed | → PROOF_SUBMITTED (retake resubmitted) |
| `SATISFIED` | Meets rules; counts toward completion | Terminal unless reopened |
| `EXCEPTION` | Waived/alternate accepted/removal | Terminal (audit reason required) |

---

## OrderStatus

**Owner**: PSP Ops / Integration

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `GENERATED` | Created on publish (or manual generate) | → IN_PRODUCTION (batched) / CANCELLED |
| `IN_PRODUCTION` | Being produced/picked | → READY_TO_SHIP |
| `READY_TO_SHIP` | Packed/label pending | → SHIPPED |
| `SHIPPED` | At least one shipment out | → PARTIALLY_DELIVERED / DELIVERED |
| `PARTIALLY_DELIVERED` | Some shipments delivered | → DELIVERED |
| `DELIVERED` | All shipments delivered | → CLOSED |
| `CLOSED` | Operationally done | Terminal |
| `CANCELLED` | Stopped | Terminal |

---

## ShipmentStatus

**Owner**: PSP Ops / Integration

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `LABEL_CREATED` | Tracking exists; not handed to carrier | → IN_TRANSIT |
| `IN_TRANSIT` | Carrier has it | → DELIVERED / EXCEPTION |
| `DELIVERED` | Delivered to store | → CLOSED (optional) |
| `EXCEPTION` | Lost/damaged/return/etc | → IN_TRANSIT (resolved) / CLOSED |
| `CLOSED` | Finalized | Terminal |

---

## StoreTaskStatus

**Owner**: Store User (primary) + System

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `NOT_READY` | Blocked (no inventory/disabled) | → READY |
| `READY` | Can be worked | → IN_PROGRESS |
| `IN_PROGRESS` | Being worked | → SUBMITTED / BLOCKED |
| `SUBMITTED` | Sent for review/processing | → COMPLETE / REWORK_REQUIRED |
| `REWORK_REQUIRED` | Redo/retake needed | → IN_PROGRESS |
| `BLOCKED` | Cannot proceed (missing item, etc.) | → READY |
| `COMPLETE` | Done | → REOPENED (admin) |
| `REOPENED` | Admin reopened | → IN_PROGRESS |

---

## PhotoReviewStatus

**Owner**: Brand/Regional Reviewer

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `PENDING` | Awaiting review | → APPROVED / REJECTED |
| `APPROVED` | Photo accepted | Terminal unless reopened |
| `REJECTED` | Photo rejected with reason | → PENDING (retake uploaded) |

---

## SlotVerificationStatus

**Owner**: System (rollup) + Brand/Regional (override)

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `PENDING` | Waiting on required proofs | → SATISFIED / REWORK / WAIVED |
| `SATISFIED` | Meets all rules | Terminal unless reopened |
| `REWORK` | Needs retake | → PENDING (retake submitted) |
| `WAIVED` | Accepted by exception | Terminal (audit reason required) |

---

## IssueStatus

**Owner**: Store (create) + PSP/Brand (resolve)

| Status | Meaning | Primary Transitions (event) |
|--------|---------|----------------------------|
| `OPEN` | Reported by store | → TRIAGED |
| `TRIAGED` | Classified + routed | → AWAITING_APPROVAL / APPROVED / DENIED |
| `AWAITING_APPROVAL` | Brand approval required by policy | → APPROVED / DENIED |
| `APPROVED` | Allowed to fulfill fix | → IN_FULFILLMENT |
| `IN_FULFILLMENT` | PSP producing/shipping replacement | → RESOLVED |
| `DENIED` | No action | Terminal |
| `RESOLVED` | Fixed | Terminal |

---

## Primary Event Triggers

> Keep stable for webhook/API contracts

| Event | Description |
|-------|-------------|
| `campaign.publish` | Campaign published |
| `orders.generated` | Orders created for stores |
| `shipment.created` | Shipment record created |
| `shipment.in_transit` | Shipment picked up by carrier |
| `shipment.delivered` | Shipment delivered |
| `store.receive_verified` | Store verified receipt |
| `install.recorded` | Installation recorded |
| `proof.submitted` | Proof photos submitted |
| `review.approved` | Photo approved |
| `review.rejected` | Photo rejected |
| `retake.requested` | Retake requested |
| `retake.submitted` | Retake photo submitted |
| `issue.created` | Issue reported |
| `issue.triaged` | Issue classified |
| `issue.approved` | Issue approved for reorder |
| `issue.denied` | Issue denied |
| `reorder.created` | Reorder generated |
| `replacement.shipped` | Replacement shipment sent |
| `assignment.waived` | Assignment waived |
| `assignment.reopened` | Assignment reopened |
| `deinstall.scheduled` | Deinstall scheduled |
| `deinstall.completed` | Deinstall completed |

---

*End of converted document*
