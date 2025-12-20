Date: 2025-12-17

Purpose: Define the admin verification system (brand/regional), approval/rejection granularity, retake behavior, review SLAs with campaign-level overrides, and how verification interacts with store/campaign completion.

# Locked Decisions (Module 7)

  -------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -------------------------------------------------------------------------------------------
  Approval granularity                Both: approve/reject per photo AND per location-slot proof packet

  Rejection behavior                  Photo-level retake only (reject specific photo; others remain)

  Verification SLA                    Yes: SLA is configurable per campaign; campaign-level override allowed

  Submission status behavior          Brand optional: choose whether completion waits for verification or completes immediately

  Rejection reasons                   Fixed reason codes + optional comments (structured + freeform)
  -------------------------------------------------------------------------------------------------------------------------------

# 1) Roles Allowed to Review

- Reviewers: Regional Admin and above (Brand Admin included).

- Review permissions are scoped to assigned regions/brands per RBAC spec (SUPP-003).

# 2) Review Objects (What gets reviewed)

- Proof photos are linked to Item + LocationSlot + PhotoRule requirement.

- Admins review:

- \- individual photos (photo-level) AND/OR

- \- the full proof packet for a location slot (slot-level)

- Slot-level review is useful when a slot requires multiple angles; photo-level review is used for targeted rejections.

# 3) States & Transitions (v1)

  ----------------------------------------------------------------------------------------------------
  Object                  State                   Meaning
  ----------------------- ----------------------- ----------------------------------------------------
  PhotoReview             PENDING                 Awaiting admin review

  PhotoReview             APPROVED                Accepted as valid proof

  PhotoReview             REJECTED                Invalid; retake required

  SlotVerification        PENDING                 At least one required proof pending

  SlotVerification        SATISFIED               All required proofs satisfied (approved or waived)

  SlotVerification        REWORK                  One or more proofs rejected; retake required
  ----------------------------------------------------------------------------------------------------

# 4) Brand-Optional Completion Mode

- Per campaign setting: verificationMode controls how store status behaves at submission time.

- Mode A (STRICT): store status becomes SUBMITTED_FOR_REVIEW; store is not COMPLETE until proofs are satisfied/waived.

- Mode B (FAST): store status becomes COMPLETE immediately upon submission; if proofs are later rejected, store is automatically REOPENED and moved to REWORK_REQUESTED.

- Both modes preserve audit events and export visibility.

## VerificationMode (Draft Fields)

  ----------------------------------------------------------------------------------------
  Field                               Values
  ----------------------------------- ----------------------------------------------------
  verificationMode                    STRICT \| FAST

  autoReopenOnRejection               true (required when FAST)

  allowWaivers                        true/false (default true; requires reason + audit)
  ----------------------------------------------------------------------------------------

# 5) Rejection Model (Photo-level Retake)

- Rejecting a specific photo triggers a retake task for the store user tied to the same item + slot + ruleId.

- Previously approved photos remain approved; only rejected photos require replacement.

- If a slot has a minimum count requirement, the slot remains unsatisfied until enough approved photos exist.

## Rejection Reason Codes (v1 Draft)

- WRONG_LOCATION

- WRONG_ANGLE

- BLURRY_OR_UNREADABLE

- INSUFFICIENT_LIGHTING

- INCOMPLETE_INSTALL

- OLD_CAMPAIGN_NOT_REMOVED

- WRONG_QUANTITY_INSTALLED

- OTHER (requires comment)

# 6) Verification SLA & Escalations

- SLA is configured per campaign (e.g., review within 48 hours of submission).

- Escalation schedule is configurable per campaign and can be overridden by Brand Admin for that campaign.

- Overdue reviews trigger alerts to Regional Admin + Brand Admin and may appear in an exception queue.

# 7) Data Model (Draft)

  --------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- --------------------------------------------------------------------------------------------------
  PhotoReview                         reviewId, photoLinkId, status, reviewerId, reasonCode, comments, reviewedAt

  SlotVerification                    slotVerificationId, campaignId, storeId, itemId, slotId, status, requiredMinCount, approvedCount

  RetakeTask                          taskId, storeId, campaignId, itemId, slotId, photoLinkId?, dueAt?, status, createdBySystem=true

  VerificationSlaConfig               campaignId, slaHours, escalationStepsJson, overrideEnabled
  --------------------------------------------------------------------------------------------------------------------------------------

# 8) APIs (Draft Endpoint List)

- GET /reviewQueue (filters: campaign, region, store, overdue, status)

- POST /photoReviews/{photoLinkId}/approve

- POST /photoReviews/{photoLinkId}/reject (reasonCode + comments)

- POST /slotVerifications/{slotId}/approveAll (optional bulk)

- POST /campaigns/{id}/verificationConfig (verificationMode + SLA)

- GET /storeApp/reworkQueue (store sees retake tasks and comments)

# 9) Acceptance Criteria (Module 7)

1.  Admins can review proofs by photo and by location slot proof packet.

2.  Admins can reject individual photos with reason code + optional comments; store receives retake task for only rejected photos.

3.  Campaign supports STRICT and FAST verification modes; behavior matches mode definitions including auto-reopen on rejection.

4.  Verification SLA is configurable per campaign; overdue items trigger alerts and appear in exception queue.

5.  Waivers (if enabled) require reason and emit audit events; waived proofs count as satisfied for slot verification.

# Future Scaffold Notes

- AI-assisted proof analysis can map onto structured reason codes and slot verification states later.

- Role-based review routing (e.g., regional first, brand escalation) can be layered onto reviewQueue logic.

- Bulk approval workflows (approve all for store/campaign) can be added with audit safeguards.
