Date: 2025-12-17

Purpose: Define export/report outputs (schemas and minimum fields) for deterministic pipelines across CSV/XLSX, PDF, JSON, XML. Supports retention-aware media handling.

# Formats & Priority (v1)

- Primary: CSV/XLSX

- Secondary: PDF (summaries + proof packets)

- Tertiary: JSON

- Quaternary: XML

# Required Export Packages (v1)

  ------------------------------------------------------------------------------------------------------------------------------------------------------
  Package                             Purpose                                                      Formats
  ----------------------------------- ------------------------------------------------------------ -----------------------------------------------------
  Campaign Summary                    Progress + exceptions + policy settings                      CSV/XLSX + PDF + JSON + XML

  Store Orders (Line-level)           Fulfillment-ready per-store order lines                      CSV/XLSX + JSON + XML

  Shipments & Tracking                Partial shipments, tracking numbers, delivery confirmation   CSV/XLSX + PDF + JSON + XML

  Execution & Proof                   Per item/location status + proof references + outcomes       CSV/XLSX + PDF + JSON + XML

  Verification & Retakes              Review decisions + reason codes + retake tasks               CSV/XLSX + JSON + XML

  Issues & Reorders                   Requests, approvals, evidence refs, substitutions            CSV/XLSX + PDF + JSON + XML

  Non-Compliance Cases (if enabled)   Deinstall overdue cases and resolution                       CSV/XLSX + JSON + XML

  Retention Export Bundle             Pre-purge archive bundle                                     ZIP manifest + CSV/XLSX + PDF + JSON/XML (optional)
  ------------------------------------------------------------------------------------------------------------------------------------------------------

# Minimum Fields (Additions)

- All exports include stable IDs plus business keys (storeNumber + storeGuidAlias).

- Media fields: include mediaAssetId and (if within retention) a short-lived URL; do not assume permanence.

- Include campaign policy fields: verificationMode (STRICT/FAST), verificationSlaHours, approvalMode, deinstallProofRequired, nonComplianceCaseEnabled.

## Key Field Sets (Draft)

Campaign Summary: campaignId, name, brandId, pspId, type, startDate, shipByDate, installByDate, endDate, verificationMode, verificationSlaHours, approvalMode, deinstallProofRequired, storeCountAssigned, storeCountComplete, completionPercent, lateShippingCount, anomalyCount, reorderCount, photoRejectionCount, reviewOverdueCount.

Execution & Proof (line): campaignId, storeId, storeNumber, itemId, locationSlotId, executionStatus, installedAt, submittedAt, slotVerificationStatus, requiredMinCount, approvedCount, waivedCount, attestationUserId, attestationAt.

Verification & Retakes: photoLinkId, mediaAssetId, reviewStatus, reasonCode, comments, reviewerId, reviewedAt, retakeTaskId, retakeStatus, dueAt.

Issues & Reorders: issueRequestId, issueLineId, itemId, qty, reasonCode, evidenceAssetIds, approvalStatus, approverId, decidedAt, reorderId, replacementShipmentIds, assetSubstitutionId(optional).

# PDF Guidance (v1)

- Default PDF uses thumbnails + links (full-res optional toggle).

- Proof packets grouped by store; rejected items called out with reason codes.

- Include policy summary page (verificationMode, SLA, deinstall requirements).

# Open Decisions

- Confirm required columns after reviewing 1--2 historical Good2Go campaigns.

- If XML needs a specific partner schema vs generic export in v1.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
