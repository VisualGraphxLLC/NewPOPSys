Date: 2025-12-18

Purpose: Deterministic specification for store-based surveys, store layout/location slots, repeatable sections, conditional logic, and brand-owned photo requirements (defaults + overrides).

Revision note: This SUPP is a full replacement. It incorporates overlapping material from SUPP-009_Survey_Builder_and_Photo_Rules_v0_3.docx as an appendix for traceability; where conflicts exist, the main body of this SUPP is authoritative.

# Locked Decisions (Module 3)

  ----------------------------------------------------------------------------------------------------------------------
  Topic                                Decision
  ------------------------------------ ---------------------------------------------------------------------------------
  Conditional logic (v1)               YES --- basic show/hide + required-if rules

  Repeatable sections (v1)             YES --- repeatable blocks (e.g., Cooler #1..#N, Door #1..#N)

  Location slots architecture          Store Layout section (separate) referenced by surveys

  Photo rules granularity              Both: campaign-wide defaults + per-item/per-location overrides

  Asset Registry pointers (Option A)   Both: PSP-managed storage + Brand-provided links (tenant configurable)

  Survey response edits                Store user + Regional/Brand admins can edit on behalf of store (audit required)
  ----------------------------------------------------------------------------------------------------------------------

# 1) Conceptual Data Model

- SurveyTemplate → SurveyVersion (immutable) defines schema and UI layout for responses.

- StoreLayout defines reusable location slots for a store; surveys reference locationSlotId values.

- RepeatableSection definitions allow multiple instances of the same block (e.g., Cooler instances).

- StoreSurveyResponse stores answers + references to location slots and media assets.

## Entities (Draft)

  -------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- -------------------------------------------------------------------------------------------
  SurveyTemplate                      templateId, brandId, name, description, createdBy

  SurveyVersion                       versionId, templateId, versionNumber, schemaJson (JSONB), uiJson, createdAt

  StoreLayout                         layoutId, storeId, versionNumber, createdAt, createdBy

  LocationSlot                        slotId, layoutId, name, type, order, tags, referenceMediaAssetId(optional)

  RepeatableSection                   sectionId, surveyVersionId, name, minInstances, maxInstances, instanceLabelPattern

  StoreSurveyResponse                 responseId, storeId, surveyVersionId, layoutId, answersJson (JSONB), updatedAt, updatedBy

  ResponseEditAudit                   editId, responseId, actorId, actorRole, reason, beforeHash, afterHash
  -------------------------------------------------------------------------------------------------------------------------------

# 2) Store Layout (Location Slots)

- Store Layout is a dedicated module/section where admins define the store's physical placement slots.

- Slots are reusable across campaigns and surveys; campaigns bind proof photos to these slots.

- Slot types (v1 baseline): signage location, fixture, window, door, pump, cooler, aisle/endcap, custom.

- Slots may include reference imagery/mockups to guide capture.

# 3) Survey Builder (Store-Based)

- Survey builder supports templating/duplication and immutable versioning.

- Survey schema stored as JSON Schema (or equivalent) in SurveyVersion.schemaJson (Postgres JSONB).

- Survey references store layout slots via fields that bind to locationSlotId values.

- Regional/Brand admins can edit responses on behalf of store; edits require reason + audit.

# 4) Conditional Logic (v1)

- Logic types:

- \- show/hide field based on answer

- \- required-if based on answer

- \- enable/disable based on answer

- Rule storage: logicRules\[\] inside schemaJson with predicate + effect.

- At minimum, logic must be evaluated client-side for UX and server-side for validation.

# 5) Repeatable Sections (v1)

- Repeatable blocks allow N instances (e.g., Cooler #1..#N).

- Each instance may create new LocationSlots or bind to existing slots depending on configuration.

- Constraints: minInstances/maxInstances; instance naming convention for UI and exports.

# 6) Photo Requirements Model (Brand-Owned)

- Brand defines photo requirements because it benefits the brand, not PSP.

- Photo rules exist at two levels:

- \- Campaign-wide defaults (e.g., 1 photo per item/location, suggested angles)

- \- Overrides per KitItemDefinition and per LocationSlot (e.g., 3 angles required for Front Door decal)

- Photos are stored as MediaAsset records; PhotoLink binds asset → campaign/store/item/locationSlot requirement.

## PhotoRule Entity (Draft)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------
  PhotoRule                           ruleId, scopeType(campaignDefault\|itemOverride\|slotOverride\|item+slot), campaignId, itemId?, slotId?, minCount, requiredAngles\[\], suggestedAngles\[\], notes

  PhotoLink                           linkId, campaignId, storeId, itemId, slotId, ruleId, mediaAssetId, createdAt, createdBy

  PhotoReview                         reviewId, photoLinkId, status(approved\|rejected), reviewerId, comments, rejectedReasonCode, createdAt
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 7) Inputs → Outputs (Build Guide)

  ------------------------------------------------------------------------------------------------------------------------------------
  User Input                                                          Expected Output
  ------------------------------------------------------------------- ----------------------------------------------------------------
  Admin defines/updates Store Layout slots                            LocationSlots created; version incremented; audit logged

  Admin builds/duplicates a SurveyTemplate; publishes SurveyVersion   Version locked; schemaJson stored; available for stores

  Store (or admin) completes survey response                          StoreSurveyResponse saved; validation enforced; audit logged

  Brand sets campaign default photo rules + item/slot overrides       PhotoRule records created; enforced on completion requirements
  ------------------------------------------------------------------------------------------------------------------------------------

# 8) APIs (Draft Endpoint List)

- GET/POST/PATCH /storeLayouts and /storeLayouts/{layoutId}/slots

- GET/POST /surveyTemplates; POST /surveyTemplates/{id}/duplicate

- POST /surveyTemplates/{id}/publish (creates SurveyVersion)

- GET/POST/PATCH /stores/{storeId}/surveyResponses

- POST /surveyResponses/{id}/editOnBehalf (requires reason; admin only)

- GET/POST/PATCH /campaigns/{id}/photoRules (defaults + overrides)

# 9) Acceptance Criteria (Module 3)

1.  Admins can define store layout slots in a dedicated module and reference them from surveys.

2.  Survey builder supports templates, duplication, and immutable version publishing.

3.  Conditional logic works for show/hide + required-if and is validated server-side.

4.  Repeatable sections support multiple instances with min/max constraints.

5.  Brand can set campaign-wide photo defaults and override per item and per slot.

6.  Regional/Brand admins can edit store survey responses on behalf of store with a required reason and audit trail.

# Open Decisions

7.  Whether repeatable section instances automatically create new location slots (recommended: configurable per section).

8.  Whether layout changes require campaign verification prompts when a store is mid-campaign (likely yes for critical slot changes).

9.  Whether survey version pinning is per campaign or always latest (recommended: campaigns pin SurveyVersion at assignment time).

# Appendix --- Integrated Material (for traceability)

SUPP-009 --- Survey Builder & Photo Rules (v0.3)

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

10. Brand can create a survey template, publish a version, duplicate it, and assign to stores.

11. Store/layout slots exist and can be referenced in campaign kits/assignments.

12. Campaigns pin survey versions; rebase creates audit + verification tasks when fulfillment started.

13. Photo rules bind to item+slot; required minimums enforced at submission; admins can reject with reason codes; store can retake only rejected photos.

14. Attestation checkbox is captured on completion and on issue/reorder submissions where required.

# Open Decisions / TODOs (Need Inputs)

- Conditional logic v1 scope (examples from 1--2 historical campaigns).

- Repeatable sections v1 scope (how common in Good2Go and VG campaigns).

- Validation rules: required-if, min/max photos per slot, range constraints.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
