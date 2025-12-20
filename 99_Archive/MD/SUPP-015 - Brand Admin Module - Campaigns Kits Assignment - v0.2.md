Date: 2025-12-17

Purpose: Define campaign creation, store selection/inclusion-exclusion, kit modeling, version pinning, and order-generation triggers. This is the core engine that drives fulfillment and execution.

# Locked Decisions (Module 4)

  --------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- --------------------------------------------------------------------------------------------
  Campaign assignment versioning      Pin SurveyVersion + LayoutVersion at assignment time (default)

  Version flexibility                 Allow controlled \'Rebase to Latest\' with admin approval + audit + verification tasks

  Kit modeling                        Kit includes items + required location slot mappings (per store layout slots)

  Order generation trigger            Generate orders on campaign publish (default); manual \'Generate Orders\' backup if needed

  Store selection precedence          Start with \'All\' → subtract exclusions; inclusions add to base selection as needed

  Install instructions/assets         Both campaign-level and item-level instructions

  Campaign type default               Default = Expiring promotional campaign unless marked Core Branding (non-expiring)
  --------------------------------------------------------------------------------------------------------------------------------

# 1) Campaign Types (v1)

  ------------------------------------------------------------------------------------------------------
  Type                           Default?          Has End Date?     Deinstall Workflow
  ------------------------------ ----------------- ----------------- -----------------------------------
  Promotional (Expiring)         Yes               Yes               Enabled by default (configurable)

  Core Branding (Non-expiring)   No (opt-in)       No                Manual only (future options)
  ------------------------------------------------------------------------------------------------------

# 2) Store Selection Model (Inclusions/Exclusions)

- Selection sources: individual stores, by group, by region/district/territory, all stores.

- Evaluation precedence (v1):

- 1\) Base set = ALL stores (if selected) OR explicit inclusions (if not).

- 2\) Apply include filters (add stores): specific stores, groups, regions.

- 3\) Apply exclusions (subtract stores): specific stores, groups, regions.

- All selection operations must be deterministic and stored as a selection \'recipe\' for reproducibility (exportable JSON).

## Selection Recipe (Draft Schema)

Example JSON (draft):\
{\
\"mode\": \"ALL\",\
\"include\": \[{\"type\":\"group\",\"id\":\"grp\_\...\"},{\"type\":\"store\",\"id\":\"sto\_\...\"}\],\
\"exclude\": \[{\"type\":\"region\",\"id\":\"reg\_\...\"}\]\
}

# 3) Version Pinning Strategy (Survey + Layout)

- Default: when a store is assigned to a campaign, the system pins:

- \- surveyVersionId (immutable schema/UI for that campaign)

- \- layoutVersionId (store layout/location slots as of assignment)

- Rationale: prevents moving targets during execution and ensures proofs map to stable location slots.

- 

- Flexibility (\'Reality happens\'): allow controlled \'Rebase to Latest\' when store survey/layout updates are unavoidable.

- Rebase rules (v1):

- \- Only BRAND_ADMIN or REGIONAL_ADMIN may initiate.

- \- System creates verification tasks for BRAND_ADMIN + PSP_OPS if fulfillment already started.

- \- System records a diff summary + emits audit event campaign.assignment_rebased.

- \- Execution tasks and photo requirements must be recalculated after rebase.

# 4) Kit Model (Items + Location Slot Mappings)

- KitDefinition: reusable kit template for a campaign (can be copied per campaign).

- KitItemDefinition: item template containing SKU/name, quantities, mockups, and photo rules references.

- Location mapping: items may specify required location slots (by slot type/tag) OR specific slots per store (resolved at assignment time).

- Because stores vary, final item→slot mapping is resolved per StoreAssignment using that store\'s pinned layout.

## Entities (Draft)

  ----------------------------------------------------------------------------------------------------------------------------------------
  Entity                              Key Fields / Notes
  ----------------------------------- ----------------------------------------------------------------------------------------------------
  Campaign                            campaignId, brandId, name, type, startDate, shipByDate, installByDate, endDate?, status, createdBy

  CampaignSelectionRecipe             campaignId, recipeJson (JSONB), computedStoreCount, computedAt

  StoreAssignment                     assignmentId, campaignId, storeId, surveyVersionId, layoutVersionId, status, createdAt

  KitDefinition                       kitId, campaignId (or templateId), name, notes

  KitItemDefinition                   itemId, kitId, name/SKU, qty, mockupAssetRef, defaultPhotoRuleId, instructionsText/assetRefs

  AssignmentItem                      assignmentItemId, assignmentId, itemId, qty, resolvedSlotBindings (JSONB), status
  ----------------------------------------------------------------------------------------------------------------------------------------

# 5) Order Generation (Default + Backup)

- Default: when campaign is published, system generates:

- \- campaign order totals

- \- per-store orders (one per store assignment unless overridden)

- \- line items mapped from assignment items

- Backup: manual \'Generate Orders\' action exists to recover from integration/API failure or to gate generation in edge cases.

- Every generation run emits audit event order.generation_run and is idempotent (does not duplicate).

# 6) Install Instructions & Assets

- Campaign-level instructions: general rollout guidance, timelines, contact info, FAQs.

- Item-level instructions: location-specific install notes, mockups, required photos, safety guidance.

- Assets are referenced via Asset Registry pointers (Option A).

# 7) APIs (Draft Endpoint List)

- POST /campaigns (create)

- PATCH /campaigns/{id} (edit)

- POST /campaigns/{id}/publish (generates assignments + orders by default)

- POST /campaigns/{id}/computeSelection (preview store count)

- POST /campaigns/{id}/generateOrders (manual backup; idempotent)

- POST /campaigns/{id}/rebaseAssignments (admin-only; triggers verification tasks)

- GET /campaigns/{id}/assignments and /assignments/{id}

- GET/POST/PATCH /kits and /kits/{id}/items

# 8) Acceptance Criteria (Module 4)

1.  Admin can create an expiring campaign with ship/install dates and optional end date.

2.  Admin can select stores using all/region/group/custom includes + exclusions; system previews and persists the selection recipe.

3.  On publish, system creates store assignments and pins survey/layout versions; orders are generated automatically.

4.  If store survey/layout updates occur, admin can rebase assignments to latest with reason; verification tasks are created if fulfillment has started.

5.  Kit items can specify required slot mappings; per-store mapping resolves against pinned store layout.

6.  Campaign instructions and item instructions are both supported; referenced assets use Option A pointers.

# Open Decisions

7.  Define what constitutes \'fulfillment has started\' (order generated vs shipment created) for rebase verification gating.

8.  Define default behavior when a pinned slot no longer exists after rebase (map by tag/type? require manual remap?).

9.  Define whether one store can have multiple orders per campaign in v1 (usually no; future optional).
