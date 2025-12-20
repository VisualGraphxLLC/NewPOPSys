Date: 2025-12-17

Purpose: Implement a deterministic, brand-configurable survey + location-slot model so campaigns conform to each store's realities, proofs attach to the right placements, and future AI compliance is possible.

# Locked Requirements

- Surveys are store-based and updated when stores change (remodels, new ad areas, etc.).

- Stores are not identical; campaigns conform to store survey + layout.

- Surveys must be templatable/duplicable with immutable versioning.

- Brands need flexible field types (schema-driven forms).

- Image-driven UX: product templates, mockups, and artwork accelerate decisions and accuracy.

- Photos are tied to item + location slot dictated by store survey; brand defines requirements (defaults + overrides).

- Signature/attestation is a checkbox capturing user identity + timestamp (completion + reorder certification).

# Survey Builder --- Field Types (v1 Minimum)

  --------------------------------------------------------------------------------------------------
  Category                            Types
  ----------------------------------- --------------------------------------------------------------
  Text & choices                      text, textarea, number, single-select, multi-select, boolean

  Time & structure                    date

  Files/media                         file upload, photo upload

  Certification                       attestation checkbox (signature-like)
  --------------------------------------------------------------------------------------------------

# Strongly Recommended v1 (Scaffold if not full)

- Conditional logic (show/hide) and validations: scaffold data model even if UI is basic.

- Repeatable sections: scaffold for multi-cooler/endcap scenarios (store-specific).

- Template import/export (JSON) for rapid iteration and portability.

# Versioning & Binding

- SurveyTemplate → immutable SurveyVersion (published) → StoreSurveyResponse (answers).

- Campaigns pin SurveyVersion by default at assignment time; controlled \'Rebase to Latest\' creates verification tasks when fulfillment started.

- Optional snapshot at campaign publish for audit/reporting (recommended).

# Location Slots & Layout Model

- Store survey defines LocationSlots (named placements).

- Each LocationSlot can include: name, category, notes, reference images, and optional geometry metadata (future).

- Campaign kit items map to one or more LocationSlots per store assignment.

# Photo Rules

- Rules are brand-owned (benefit of the brand), applied per campaign and can override per item and per location slot.

- Rules include: requiredMinCount, suggestedAngles, reference mockups, and capture guidance text.

- Admins (Regional and above) approve/reject; rejection triggers retake workflow.

- v1 supports brand rejection of photos (manual); future scope: AI analysis and automatic rejection suggestions.

# Data Storage Approach (Deterministic)

- Store schemas as JSON schema (or equivalent) + typed response JSON.

- Index selected fields (storeNumber, region path, slot names/categories) to support filtering and store selection UX.

# APIs (Draft)

- POST /surveyTemplates; POST /surveyTemplates/{id}/publishVersion

- GET/PUT /stores/{storeId}/surveyResponses (store or admin edits per RBAC)

- GET /stores/{storeId}/locationSlots

- POST /campaigns/{id}/photoRules (defaults + overrides)

# Acceptance Criteria

1.  Brand can create a survey template, publish a version, duplicate it, and assign to stores.

2.  Store/layout slots exist and can be referenced in campaign kits/assignments.

3.  Campaigns pin survey versions; rebase creates audit + verification tasks when fulfillment started.

4.  Photo rules bind to item+slot; required minimums enforced at submission; admins can reject with reason codes; store can retake only rejected photos.

5.  Attestation checkbox is captured on completion and on issue/reorder submissions where required.

# Open Decisions / TODOs (Need Inputs)

- Conditional logic v1 scope (examples from 1--2 historical campaigns).

- Repeatable sections v1 scope (how common in Good2Go and VG campaigns).

- Validation rules: required-if, min/max photos per slot, range constraints.
