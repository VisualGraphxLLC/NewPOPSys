# Stakeholder Q&A Gates - SOW Completion

**Date:** 2025-12-18
**Project:** NewPOPSys v1
**Status:** ✅ ALL GATES DOCUMENTED - Ready for Development

---

## Executive Summary

All 5 Q&A gates have been **answered and documented** in the existing SOW and SUPP documents. This document serves as a **quick reference** pointing to where each answer is located.

**Status:** ✅ **UNBLOCKED** - Development can proceed.

---

## Q&A Gate 1: Pilot Scale Parameters

**Status:** ✅ DOCUMENTED
**Source:** [MASTER_SOW_COMPILED_v1_35.md](../01_Main_SOW/MASTER_SOW_COMPILED_v1_35.md) Section 4.2, Table (lines 184-217)

### Answers

| Dimension | Pilot Target | Reference |
|-----------|-------------|-----------|
| **Pilot PSPs** | 2 (Visual Graphx; Speedy CPS / Alpha Graphics) | Section 4.2 |
| **Pilot Brands** | 2-3 (Good2Go confirmed for Speedy/AG) | Section 4.2 |
| **Stores per Brand** | Up to 1,000 | Section 4.2 |
| **Media Volume** | ≥1 photo per item per location per campaign | Section 4.2 |

### Staging Seed Phases (SUPP-025)

| Phase | Stores | Campaigns | Purpose |
|-------|--------|-----------|---------|
| P0 - Smoke | 1 | 1 tiny | End-to-end validation |
| P1 - Basic | 10 | 1 small + 1 medium | Selection, batching, queues |
| P2 - Pilot-ish | 100 | 1 medium + 10 small | Pagination, performance |
| P3 - Scale | 1,000 | 1 huge + 5 medium + 20 small | Stress testing |

**Load Target:** 50 concurrent store users + 10 concurrent admin/PSP users

---

## Q&A Gate 2: Store Execution Truth Table

**Status:** ✅ DOCUMENTED
**Source:** [SUPP-017](../02_SUPPs/Store_Execution_Module/SUPP-017%20-%20Store%20Execution%20Module%20-%20Store%20Execution%20Proof%20Capture%20-%20v0.3.md)

### Mobile Journey (Two-Stage Workflow)

| Stage | Trigger | Goal |
|-------|---------|------|
| **1. Receipt Survey** | Shipment In Transit/Delivered | Confirm inventory before install |
| **2. Install Survey** | Campaign Start | Prove correct installation via photos |

### Stage 1: Receipt Survey UX
- **View:** Checklist of all items in StoreOrder
- **Interaction:** "Select All" to confirm, tap item to report exception
- **Exceptions:** Missing/Damaged triggers Issue Report (SUPP-019), Damaged requires photo
- **Outcome:** ReceiveVerification record saved

### Stage 2: Install Survey UX
- **View:** Items grouped by Location Slot (from Store Layout)
- **Photo Capture:** Camera with ghost image overlay, validation warnings
- **Progress:** Visual bar (e.g., "3/5 Slots Complete")
- **Sync:** Upload as you go, full offline support
- **Attestation:** Final signature/checkbox required

### State Machine (SUPP-002)

```
StoreAssignment:
IN_PROGRESS → SUBMITTED_FOR_REVIEW → COMPLETE
                     ↓
              REWORK_REQUESTED ←─┘

PhotoReview:
PENDING → APPROVED
    ↓
REJECTED → PENDING (retake) → SUPERSEDED
```

---

## Q&A Gate 3: PSP Fulfillment Rules

**Status:** ✅ DOCUMENTED
**Source:** [SUPP-016](../02_SUPPs/PSP_Operations_Module/SUPP-016%20-%20PSP%20Operations%20Module%20-%20Orders%20Shipments%20Batches%20PSP%20Ops%20-%20v0.4.md), [SUPP-019](../02_SUPPs/PSP_Operations_Module/SUPP-019%20-%20PSP%20Operations%20Module%20-%20Issues%20Reorders%20Expiration%20Deinstall%20-%20v0.3.md)

### Order Model
- **Hierarchy:** Campaign (1) → StoreOrder (N)
- **Granularity:** 1 order per store per campaign
- **Reorders:** Separate StoreOrder with type=REORDER
- **Identity:** System generates orderNumber, PSP assigns pspOrderRef

### Shipments (Split & Partial)
- **Many-to-One:** StoreOrder can have multiple Shipments
- **Partial Logic:** ShipmentLine tracks what's in each box
- **Multi-box:** Single shipment can have multiple tracking numbers

### Batching
- PSPs batch orders internally (by region, etc.)
- **v1 Scope:** System does NOT manage batch logic
- **Support:** Optional batchLabel field if PSP wants to tag via API

### Issue Types & Reorders (SUPP-019)

| Type | Evidence | Action |
|------|----------|--------|
| MISSING | No | 1:1 Replacement |
| DAMAGED | Photo Required | 1:1 Replacement |
| INCORRECT | Photo optional | 1:1 Replacement |
| PACKAGING | Photo Required | Bulk Replacement (PSP discretion) |

### Automated Reorder Workflow
1. Store submits IssueRequest
2. Policy Check: Auto-approve if < threshold, else manual review
3. On Approval: System creates StoreOrder (type=REORDER)
4. Pushed to PSP via API, distinct tracking sent to store

---

## Q&A Gate 4: Integration Requirements

**Status:** ✅ DOCUMENTED
**Source:** [SUPP-006](../02_SUPPs/Shared_Foundations/SUPP-006%20-%20Shared%20Foundations%20-%20Webhooks%20and%20Inbound%20API%20Event%20Contract%20-%20v0.5.md)

### Outbound Events (System → PSP/Brand)

| Topic | Event | Payload Keys |
|-------|-------|--------------|
| campaign | campaign.published | id, pspCampaignRef, storeCount, kitId |
| order | order.generated | id, orderNumber, storeId, pspOrderRef |
| issue | issue.created | id, type, description, photoUrl |
| issue | issue.approved | id, reorderId |
| submission | submission.receipt_verified | id, storeId, status |
| submission | submission.install_completed | id, storeId |
| photo | photo.rejected | id, assignmentItemId, reason |

### Inbound Events (PSP → System)

| Topic | Event | Required Payload |
|-------|-------|------------------|
| order | order.acknowledged | orderId, pspOrderRef, status |
| shipment | shipment.created | orderId, trackingNumbers[] |
| shipment | shipment.delivered | orderId, deliveredAt |

### Webhook Security
- **Signing:** HMAC-SHA256 (Header: X-VG-Signature)
- **Idempotency:** Idempotency-Key required for inbound
- **Retry:** Exponential backoff (max 72h)

### Integration Points (SUPP-002)

| Direction | Mechanism | Data |
|-----------|-----------|------|
| PSP → System | API / Webhook | Order ack, shipment, tracking, delivery |
| System → PSP | Webhook | Campaign published, orders generated |
| System → Brand | Webhook | Completion, photo review, issues |
| System → Store | Email | Campaign notifications |

---

## Q&A Gate 5: Retention Policy

**Status:** ✅ DOCUMENTED
**Source:** [SUPP-008](../99_Archive_MD_Converted/02_SUPPs/Shared_Foundations/SUPP-008%20-%20Shared%20Foundations%20-%20Data%20Retention%20Classification%20Policy%20Option%20A%20-%20v0.4.md), [SUPP-005](../99_Archive_MD_Converted/02_SUPPs/Shared_Foundations/SUPP-005%20-%20Shared%20Foundations%20-%20Exports%20Reports%20Output%20Contracts%20-%20v0.3.md)

### Locked Decisions (SUPP-008)

| Topic | Decision |
|-------|----------|
| Architecture | Asset Registry (metadata + pointers), not vault |
| Heavy Media Retention | **90 days** after campaign completion |
| Binary Storage | External pointers / PSP-managed S3 (tenant configurable) |
| Keep Forever | Campaign records, audit events, templates, definitions |
| Exports | Offer export bundle before purge; regeneratable |

### Data Classes & Retention

| Class | Examples | Retention |
|-------|----------|-----------|
| A. Campaign Proof Media | Install/receipt photos, videos | 90 days post-completion |
| B. Campaign Records | Metadata, assignments, statuses, audit | 2-5 years (configurable) |
| C. Store Master Data | Stores, regions, layouts | While active |
| D. Reusable Definitions | Templates, presets | While referenced |
| E. Asset Registry | Metadata, pointers | While referenced |
| F. Exports | Generated reports | Short-lived, regenerate on demand |

### Purge Workflow
1. At campaign completion, schedule purge of Class A media at +90 days
2. Generate and notify export bundle availability before purge
3. Purge job deletes binaries, keeps manifest records
4. Retain audit trail of purge action

### Export Formats (SUPP-005)

| Priority | Format |
|----------|--------|
| Primary | CSV/XLSX |
| Secondary | PDF (summaries + proof packets) |
| Tertiary | JSON |
| Quaternary | XML |

### Export Packages

| Package | Purpose |
|---------|---------|
| Campaign Summary | Progress + exceptions + policy |
| Store Orders | Fulfillment-ready line-level |
| Shipments & Tracking | Partials, tracking, delivery |
| Execution & Proof | Per item status + proof refs |
| Verification & Retakes | Review decisions + reason codes |
| Issues & Reorders | Requests, approvals, evidence |
| Retention Export Bundle | Pre-purge archive (ZIP + manifest) |

---

## Summary: All Gates Complete

| Q&A Gate | Status | Primary Source |
|----------|--------|----------------|
| **1. Pilot Scale Parameters** | ✅ Documented | MASTER_SOW Section 4.2, SUPP-025 |
| **2. Store Execution Truth Table** | ✅ Documented | SUPP-017, SUPP-002 |
| **3. PSP Fulfillment Rules** | ✅ Documented | SUPP-016, SUPP-019 |
| **4. Integration Requirements** | ✅ Documented | SUPP-006, SUPP-002 |
| **5. Retention Policy** | ✅ Documented | SUPP-008, SUPP-005 |

---

## Development Can Proceed

**All blockers removed.** The SOW documentation is sufficient to begin implementation:

- ✅ Pilot scale defined (2 PSPs, 2-3 brands, up to 1,000 stores)
- ✅ Store execution workflow documented (two-stage: Receipt + Install)
- ✅ PSP fulfillment rules specified (orders, shipments, reorders)
- ✅ Integration events defined (inbound + outbound webhooks)
- ✅ Retention policy locked (90 days for media, exports before purge)

**Next Steps:**
1. Begin multi-agent harness implementation (see [IMPLEMENTATION_ROADMAP.md](../../AutoCoder_Harness/IMPLEMENTATION_ROADMAP.md))
2. Start with Module Priority Layer 1: Core Foundation (SUPP-002, SUPP-003, SUPP-035)
3. Follow build order in [SOW_FRAMEWORK.md](./SOW_FRAMEWORK.md)

---

## Document History

| Version | Date | Changes |
|---------|------|---------|
| v1.0 | 2025-12-18 | Initial creation with open questions |
| v1.1 | 2025-12-18 | Updated to reflect all gates already documented in SOW |

---

*All Q&A gates verified as documented - Development unblocked*
