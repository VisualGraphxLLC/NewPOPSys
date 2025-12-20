# NewPOPSys v1 — Mermaid Charts (Verified Syntax)

> **Updated**: 2025-12-19
> Paste these into [Mermaid Live](https://mermaid.live) to render.

## Chart Index

### State Diagrams
1. [FulfillmentStatus](#2-fulfillmentstatus-state-diagram-qty-derived) - Shipment/delivery states
2. [AssignmentItemStatus](#5-assignmentitemstatus-state-diagram) - Item lifecycle at store
3. [IssueRequestStatus](#6-issuerequestatus-state-diagram) - Issue/reorder workflow
4. [StoreAssignmentStatus](#7-storeassignmentstatus-state-diagram) - Store execution states
5. [Campaign lifecycle](#8-campaign-lifecycle-state-diagram) - Campaign states
6. [PhotoReviewStatus](#11-photoreviewstatus-state-diagram) - Photo review states

### Flow & Architecture Diagrams
7. [Roll-up architecture](#1-roll-up-architecture-qty--item--store--campaign) - Qty flow from PSP to Campaign
8. [StorePhase derivation](#4-storephase-derivation-parallel-lanes) - How StorePhase is computed
9. [Campaign Flow](#9-campaign-flow-end-to-end) - End-to-end campaign flow
10. [Module Responsibility + Hand-offs](#10-module-responsibility--hand-offs) - Portal ownership & handoffs
11. [Personas by Module](#12-personas-by-module) - Role assignments
12. [Status Interrelation](#13-status-interrelation-across-modules) - Status ownership
13. [Promo Item - Slot Interrelation](#14-promo-item---slot-status-interrelation) - Item/slot binding
14. [Store Selection Flow](#15-store-selection-flow) - Campaign store targeting UX

### Sequence Diagrams
15. [Partial shipment + receipt exception](#3-partial-shipment--receipt-exception-sequence) - Exception handling flow

---

## 1) Roll-up architecture (qty → item → store → campaign)
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

---

## 2) FulfillmentStatus state diagram (qty-derived)
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

---

## 3) Partial shipment + receipt exception (sequence)
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

---

## 4) StorePhase derivation (parallel lanes)
```mermaid
flowchart TB
  F["FulfillmentStatus"] --> P["StorePhase (derived)"]
  R["ReceiptStatus"] --> P
  E["ExecutionStatus"] --> P
  V["VerificationStatus"] --> P
  I["Open Issues + Policy"] --> P
  P --> UI["Brand Store Row<br/>(phase + 4 columns + % bars)"]
```

---

## 5) AssignmentItemStatus state diagram
```mermaid
stateDiagram-v2
  [*] --> PLANNED

  PLANNED --> ORDERED : orderline created
  ORDERED --> SHIPPED : shipmentline created
  SHIPPED --> DELIVERED : carrier delivered
  DELIVERED --> RECEIVED : store verify

  RECEIVED --> INSTALLED : install recorded
  RECEIVED --> EXCEPTION : issue reported

  INSTALLED --> PROOF_SUBMITTED : photo submitted
  PROOF_SUBMITTED --> SATISFIED : approved
  PROOF_SUBMITTED --> RETAKE_REQUIRED : rejected

  RETAKE_REQUIRED --> PROOF_SUBMITTED : retake resubmitted

  SATISFIED --> [*]
  EXCEPTION --> [*]
```

---

## 6) IssueRequestStatus state diagram
```mermaid
stateDiagram-v2
  [*] --> OPEN

  OPEN --> TRIAGED : classified + routed
  TRIAGED --> AWAITING_APPROVAL : needs brand approval
  TRIAGED --> APPROVED : auto-approved by policy
  TRIAGED --> DENIED : rejected

  AWAITING_APPROVAL --> APPROVED : brand approved
  AWAITING_APPROVAL --> DENIED : brand denied

  APPROVED --> IN_FULFILLMENT : reorder created
  IN_FULFILLMENT --> RESOLVED : replacement shipped + received

  DENIED --> [*]
  RESOLVED --> [*]
```

---

## 7) StoreAssignmentStatus state diagram
```mermaid
stateDiagram-v2
  [*] --> ASSIGNED

  ASSIGNED --> READY : inventory delivered / manual allow
  READY --> IN_PROGRESS : store starts
  IN_PROGRESS --> SUBMITTED : proofs submitted

  SUBMITTED --> COMPLETE : approved / waived
  SUBMITTED --> REWORK_REQUIRED : rejected

  REWORK_REQUIRED --> IN_PROGRESS : retake started
  REWORK_REQUIRED --> SUBMITTED : resubmitted

  COMPLETE --> REOPENED : admin reopen
  REOPENED --> IN_PROGRESS : work continues

  ASSIGNED --> WAIVED : admin waiver
  WAIVED --> [*]
  COMPLETE --> [*]
```

---

## 8) Campaign lifecycle state diagram
```mermaid
stateDiagram-v2
  [*] --> DRAFT

  DRAFT --> SCHEDULED : set start date
  DRAFT --> PUBLISHED : publish now
  DRAFT --> CANCELLED : cancel

  SCHEDULED --> PUBLISHED : start time reached
  SCHEDULED --> DRAFT : unschedule
  SCHEDULED --> CANCELLED : cancel

  PUBLISHED --> COMPLETED : rollup satisfied / end date
  PUBLISHED --> CANCELLED : terminate

  COMPLETED --> ARCHIVED : archive
  CANCELLED --> ARCHIVED : archive

  ARCHIVED --> [*]
```

---

## 9) Campaign Flow (end-to-end)
```mermaid
flowchart TB
  subgraph BRAND["Brand Portal"]
    B1["Draft campaign<br/>(kit + rules + stores)"]
    B2["Publish<br/>(generate orders)"]
    B3["Review proofs<br/>(approve/reject)"]
    B4["Rollups + reporting/exports"]
  end

  subgraph PSP["PSP Portal"]
    P1["Create orders/lines"]
    P2["Batch + produce + ship"]
    P3["Reorder/replacement ship"]
  end

  subgraph STORE["Store App"]
    S1["Receive/verify"]
    S2["Install"]
    S3["Proof capture + attestation"]
    S4["Retake proofs"]
    S5["Complete store task"]
  end

  B1 --> B2
  B2 --> P1
  P1 --> P2
  P2 --> S1
  S1 --> S2
  S2 --> S3
  S3 --> B3
  B3 -->|approved| S5
  B3 -->|rejected| S4
  S4 --> S3
  S5 --> B4
  S2 -->|issue/reorder| P3
  P3 --> S1
```

---

## 10) Module Responsibility + Hand-offs
```mermaid
flowchart LR
  subgraph BRAND["Brand Portal<br/>(BRAND / REGIONAL)"]
    BC["Owns configuration + approvals<br/>• Stores/Regions/Groups<br/>• Surveys + Layout + Photo Rules<br/>• Campaigns/Kits/Assignments<br/>• Verification/Retakes/Waivers<br/>• Reporting/Exports"]
  end

  subgraph PSP["PSP Portal<br/>(PSP_ADMIN / PSP_OPS / INTEGRATION)"]
    PC["Owns production + logistics<br/>• Tenant settings (admin)<br/>• Orders/Shipments/Batches<br/>• Tracking + exceptions<br/>• Reorders/replacements<br/>• API + Webhooks"]
  end

  subgraph STORE["Store App<br/>(STORE_USER)"]
    SC["Owns execution<br/>• Receive/Verify<br/>• Install<br/>• Proof Capture<br/>• Attestation/Complete<br/>• Issues/Retakes/Deinstall"]
  end

  BC -->|"Publish → Orders Created"| PC
  PC -->|"Shipments + Tracking"| SC
  SC -->|"Issue / Reorder Request"| PC
  PC -->|"Replacement Shipped"| SC
  SC -->|"Proofs Submitted"| BC
  BC -->|"Retake Requested"| SC
```

---

## 11) PhotoReviewStatus state diagram
```mermaid
stateDiagram-v2
  [*] --> PENDING

  PENDING --> APPROVED : reviewer approves
  PENDING --> REJECTED : reviewer rejects

  REJECTED --> SUPERSEDED : retake uploaded
  SUPERSEDED --> [*]

  APPROVED --> [*]
```

---

## 12) Personas by Module
```mermaid
flowchart TB
  subgraph SHARED["Shared Foundations"]
    SF["All personas access shared data<br/>based on role permissions"]
  end

  subgraph BRAND_MODULE["Brand Admin Module"]
    BA["BRAND_ADMIN<br/>Full brand access"]
    RA["REGIONAL_ADMIN<br/>Scoped to region"]
  end

  subgraph PSP_MODULE["PSP Operations Module"]
    PA["PSP_ADMIN<br/>Tenant config + security"]
    PO["PSP_OPS<br/>Orders + shipments"]
    IU["INTEGRATION_USER<br/>API automation"]
  end

  subgraph STORE_MODULE["Store Execution Module"]
    SU["STORE_USER<br/>Mobile execution"]
  end

  SF --> BRAND_MODULE
  SF --> PSP_MODULE
  SF --> STORE_MODULE
```

---

## 13) Status Interrelation Across Modules
```mermaid
flowchart LR
  subgraph PSP_STATUS["PSP-Owned"]
    OS["StoreOrderStatus"]
    SS["ShipmentStatus"]
  end

  subgraph STORE_STATUS["Store-Owned"]
    RS["ReceiptStatus"]
    ES["ExecutionStatus"]
  end

  subgraph BRAND_STATUS["Brand-Owned"]
    VS["VerificationStatus"]
    PRS["PhotoReviewStatus"]
  end

  subgraph DERIVED["Derived (Computed)"]
    FS["FulfillmentStatus"]
    SP["StorePhase"]
  end

  OS --> FS
  SS --> FS
  FS --> SP
  RS --> SP
  ES --> SP
  VS --> SP
  PRS --> VS
```

---

## 14) Promo Item - Slot Status Interrelation
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

---

## 15) Store Selection Flow
```mermaid
flowchart TD
    START([Start Selection]) --> BASE{Base Set?}
    BASE -->|All Stores| ALL[Load all active stores]
    BASE -->|Start Empty| EMPTY[Empty set]

    ALL --> INCL
    EMPTY --> INCL

    INCL[Add Inclusions] --> INCL_TYPE{Add by?}
    INCL_TYPE -->|Region| ADD_REG[Select regions]
    INCL_TYPE -->|District| ADD_DIST[Select districts]
    INCL_TYPE -->|Group| ADD_GRP[Select groups]
    INCL_TYPE -->|Store| ADD_STORE[Search stores]

    ADD_REG --> PREVIEW
    ADD_DIST --> PREVIEW
    ADD_GRP --> PREVIEW
    ADD_STORE --> PREVIEW

    PREVIEW[Update Preview Counter] --> MORE{More changes?}
    MORE -->|Yes| INCL
    MORE -->|Add Exclusion| EXCL[Add Exclusions]

    EXCL --> EXCL_TYPE{Exclude by?}
    EXCL_TYPE -->|Region| REM_REG[Select regions]
    EXCL_TYPE -->|Store| REM_STORE[Select stores]

    REM_REG --> PREVIEW
    REM_STORE --> PREVIEW

    MORE -->|Done| REVIEW[Review Store List]
    REVIEW --> SAVE[Save SelectionRecipe]
    SAVE --> DONE([Selection Complete])
```
