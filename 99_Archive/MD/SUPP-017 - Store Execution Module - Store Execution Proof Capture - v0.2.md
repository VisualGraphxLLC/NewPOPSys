Date: 2025-12-17

Purpose: Define the store-facing execution workflow (mobile-first web), receiving/verification, install confirmation, proof capture, replacements, offline behavior, and rollups to store/order/campaign completion.

# Locked Decisions (Module 6)

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- ----------------------------------------------------------------------------------------------------------------------------------
  Execution steps (v1)                Notify → Receive/Verify → Pre-install checklist → Install → Completion Survey + Proof + Attestation

  Receiving verification              Hybrid: order-level confirm + item-level anomaly classification (missing/damaged/incorrect)

  Replacement request model           Hybrid: per-item issue lines by default; allow \'major packaging damage\' single request that can fan-out into item lines by PSP

  Install confirmation                Item-level per location slot; rolls up to order/store completion

  Proof upload timing                 Upload-as-you-go per item/location slot (preferred)

  Offline expectation                 Best-effort offline drafts + sync-on-open (v1)
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1) Store Journey (Step-by-Step)

1.  Campaign Notification: store sees upcoming campaign + due dates + quick summary of required actions.

2.  Receive/Verify: store confirms delivery status; records anomalies (missing/damaged/incorrect) at item level.

3.  Pre-Install Checklist: guided checklist (safety, remove old campaign materials, confirm tools/space, confirm mockups).

4.  Install: store marks install for each item/location slot; uploads proof photos as required/suggested.

5.  Completion Survey: collect final confirmation questions + attestation checkbox signature.

6.  Submit: transitions to SUBMITTED_FOR_REVIEW if admin verification required; otherwise COMPLETE when proofs satisfied or waived.

# 2) Receive/Verify Model (Hybrid)

- Order-level confirmation: store answers \'Did you receive the kit/order?\' (Yes/No/Partial).

- Item-level anomaly capture: for each item (and optionally per shipment) store can report:

- \- reasonCode: MISSING, DAMAGED, INCORRECT_ITEM, INCORRECT_QTY, OTHER

- \- qtyAffected

- \- description

- \- evidence photos (optional/required per policy)

- \- attestation checkbox + timestamp (required for reorder submission)

- If \'major packaging damage\' is selected, store can submit a single request referencing the order; PSP may expand into item lines later.

# 3) Replacement Requests (Issues/Reorders)

- Default: each affected item becomes its own IssueLine (granular tracking).

- Exception: major packaging damage can be captured once, tied to order/shipment; PSP can resolve by creating one or many replacement shipments.

- All requests generate alerts to PSP Ops and (optionally) brand admins (per notifications matrix).

## Entities (Draft)

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ---------------------------------------------------------------------------------------------------------------------------
  StoreTask                           taskId, storeId, campaignId, type(receive\|install\|complete\|deinstall), status, dueAt

  ReceiveVerification                 verificationId, orderId, receivedStatus(yes/no/partial), notes, createdAt

  IssueRequest                        issueRequestId, orderId, storeId, campaignId, type(itemIssues\|packagingDamage), status

  IssueLine                           issueLineId, issueRequestId, itemId, qty, reasonCode, description, evidenceAssetIds\[\], attestationUserId, attestationAt

  InstallRecord                       installId, assignmentItemId, slotId, installedAt, installedBy, status

  ProofCapture                        proofId, installId (or assignmentItemId+slotId), mediaAssetId, ruleId, createdAt

  CompletionSubmission                submissionId, storeId, campaignId, status(submitted\|verified\|rework), attestationUserId, attestationAt
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4) Install + Proof Capture (Upload-as-you-go)

- Store completes install per item/location slot (resolved in assignment).

- Required photo rules enforced by brand defaults + overrides (SUPP-014).

- Capture guidance: show mockup/reference image; show recommended angles; show minimum required count.

- Proof photos are linked to item + location slot; admins can later approve/reject.

- Store can submit completion only when required proof minimums are met OR an admin waiver is applied.

# 5) Completion & Rollups

- Item/location completion rolls up to StoreAssignment completion.

- Store completion transitions: IN_PROGRESS → SUBMITTED_FOR_REVIEW → (REWORK_REQUESTED \| COMPLETE).

- Order rollup: order is \'execution complete\' when all required assignment items are complete (or waived).

- Campaign rollup is defined in SUPP-007 (all stores complete or force-complete).

# 6) Offline & Sync (Best-Effort v1)

- Support saving drafts offline: checklist status, survey answers, install progress.

- Photos may be queued locally; uploads occur when the app is open and connectivity exists.

- Provide Sync Status screen: queued uploads, failed uploads, retry action.

- Server-side validation still required on submission; client warns user when offline might block final submission.

# 7) UI Screens (v1 Minimum)

- Store Home: list of active campaigns + tasks + due dates.

- Campaign Detail: kit overview, instructions, due dates, contact info.

- Receive/Verify: order-level confirm + item anomaly capture.

- Pre-install Checklist: guided steps + acknowledgment.

- Install Task: per item/location slot checklist + photo capture UI.

- Completion Survey: final questions + attestation checkbox.

- Retake Queue: list of rejected proofs with comments and resubmit actions.

- Sync Status: queued uploads and retry.

# 8) APIs (Draft Endpoint List)

- GET /storeApp/campaigns (store-scoped list)

- GET /storeApp/campaigns/{id} (details + tasks + required proofs)

- POST /storeApp/orders/{orderId}/receiveVerification

- POST /storeApp/issues (create IssueRequest + IssueLines)

- POST /storeApp/installRecords (create/update install per item+slot)

- POST /storeApp/proofs (register proof + presigned upload handshake)

- POST /storeApp/completionSubmissions

- GET /storeApp/reworkQueue

# 9) Acceptance Criteria (Module 6)

7.  Store can complete Receive/Verify with order-level received status and item-level anomaly classification.

8.  Store can submit per-item issue lines; major packaging damage can be submitted as a single request.

9.  Store can complete pre-install checklist prior to install tasks.

10. Store installs items per location slot; uploads proof photos as they go; rules enforced per campaign defaults + overrides.

11. Store completion requires completion survey + attestation; transitions to submitted/rework/complete states accordingly.

12. Admins can reject proofs; store sees rejection comments and can resubmit.

13. Offline drafts work; queued uploads sync when app is open and online; sync status visible.

# Future Scaffold Notes

- AI proof analysis and auto-rejection is future scope; v1 supports manual rejection workflow with structured reason codes.

- Native apps can add true background sync and better media handling later.

- Barcode/QR scanning for receiving verification can be added later without changing the core entities.
