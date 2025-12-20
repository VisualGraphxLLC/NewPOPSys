Date: 2025-12-17

Purpose: Define issue reporting, reorder approvals, reorder constraints, expiring campaign deinstall flow, non-compliance handling, and asset/version substitution rules.

# Locked Decisions (Module 8)

  ----------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- ----------------------------------------------------------------------------------------------------------
  Reorder approvals                   Rules-based: brand can require approval per campaign/item; PSP can fulfill without approval when allowed

  Reorder limits                      No caps enforced in v1 (scaffold for future configurable caps)

  Deinstall proof (default)           Optional by default; brand may require per campaign

  Expiration non-compliance cases     Auto-create non-compliance case record when enabled; this behavior is brand/campaign optional

  Asset version substitution          PSP may substitute updated asset version for reprints/reorders with audit + traceability
  ----------------------------------------------------------------------------------------------------------------------------------------------

# 1) Issue & Reorder Overview

- Issues originate from store execution (missing/damaged/incorrect/etc.) and create structured IssueRequests.

- Default handling is per-item IssueLines for granular fulfillment tracking.

- Major packaging damage can be captured at order/shipment level and expanded by PSP ops if needed.

# 2) Approval Model (Rules-Based)

- ApprovalPolicy is configured per campaign and can be overridden per item.

- Modes:

- \- AUTO_APPROVE: issue lines automatically become reorder-ready for PSP.

- \- BRAND_APPROVAL_REQUIRED: brand/regional must approve before PSP produces/ships.

- \- PSP_APPROVAL_ONLY: PSP decides (useful when brand wants speed or trusts PSP).

- All approvals/rejections require actor + timestamp; rejections require reason code + comment.

## Approval Policy Fields (Draft)

  --------------------------------------------------------------------------------------------------
  Field                               Notes
  ----------------------------------- --------------------------------------------------------------
  approvalMode                        AUTO_APPROVE \| BRAND_APPROVAL_REQUIRED \| PSP_APPROVAL_ONLY

  defaultMode                         campaign-level default

  itemOverrides                       optional per KitItemDefinition

  notifyOnSubmit                      routing to PSP + brand per SUPP-004
  --------------------------------------------------------------------------------------------------

# 3) Reorder Constraints (v1 + Scaffold)

- v1 does not enforce numeric caps to avoid blocking operations during pilots.

- System MUST still capture reorder metrics to enable future caps: requestedQty, approvedQty, fulfilledQty, reason codes.

- Future scaffold: per-campaign caps (absolute qty or % of original) + approval escalation.

# 4) Expiration & Deinstall Workflow

- Expiring campaign reaches endDate (or end window) → system creates deinstall tasks for stores.

- Deinstall proof requirements are brand-configurable per campaign:

- \- Optional by default

- \- Brand can require min photo count and/or specific angles per location slot

- Deinstall completion can be reviewed with the same verification/retake mechanism (SUPP-018) if enabled.

# 5) Non-Compliance Case Record (Brand Optional)

- When enabled, overdue deinstall creates a NonComplianceCase record for reporting and follow-up.

- Case includes: store, campaign, due date, days overdue, last activity, and escalation history.

- If disabled, system only escalates via notifications without creating a formal case object.

# Entities (Draft)

  ---------------------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ---------------------------------------------------------------------------------------------------------------------------
  IssueRequest                        issueRequestId, orderId, storeId, campaignId, type, status, createdAt

  IssueLine                           issueLineId, issueRequestId, itemId, qty, reasonCode, description, evidenceAssetIds\[\], attestationUserId, attestationAt

  ApprovalDecision                    decisionId, issueLineId (or requestId), status(approved\|rejected), actorId, reasonCode?, comment?, decidedAt

  Reorder                             reorderId, issueRequestId, status, createdAt; may produce 1..N replacement shipments

  NonComplianceCase                   caseId, campaignId, storeId, type(deinstall_overdue), status, createdAt, closedAt?, notes

  AssetSubstitution                   subId, originalAssetRef, substitutedAssetRef, actorId, reason, createdAt
  ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 6) Asset Substitution Rules (Reprints/Reorders)

- Default behavior is to reference the item's asset pointer used in the original order generation run.

- PSP can substitute an updated asset version when required (e.g., corrected artwork, reprint, inventory standardization).

- Substitution must:

- \- record who/when/why

- \- preserve original reference

- \- update downstream reorder shipment docs/exports

- \- emit webhook event asset.substituted (future-ready; optional v1)

# 7) Notifications & Webhooks

- Submitting issues notifies PSP; brand notified based on approval policy and anomaly rules (SUPP-004).

- Approval-required issues generate review tasks in brand/admin queue.

- Deinstall overdue triggers escalation per campaign rule; optional case creation per brand/campaign.

# 8) APIs (Draft Endpoint List)

- POST /issues (create IssueRequest + IssueLines)

- GET /issues (filters: campaign, store, status, overdue)

- POST /issues/{issueLineId}/approve \| /reject (reasonCode + comment)

- POST /issues/{issueRequestId}/createReorder (PSP)

- GET/POST /campaigns/{id}/approvalPolicy (configure)

- POST /campaigns/{id}/deinstallConfig (proof requirements + case toggle)

- GET /nonComplianceCases (if enabled)

- POST /assets/substitute (records substitution with audit)

# 9) Acceptance Criteria (Module 8)

1.  Store can submit missing/damaged issues with per-item issue lines including qty, reason, evidence, and attestation.

2.  Campaign can require brand approval for reorders by policy; PSP can fulfill automatically when allowed.

3.  PSP can convert approved issues into reorders and manage replacement shipments.

4.  Expiring campaigns create deinstall tasks at end date; deinstall proof can be optional or required per campaign.

5.  When enabled, overdue deinstall creates a NonComplianceCase record; otherwise only escalations are sent.

6.  PSP can substitute an updated asset version for reorders with full audit and traceability.
