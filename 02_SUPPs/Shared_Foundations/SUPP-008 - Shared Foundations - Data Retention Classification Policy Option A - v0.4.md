Date: 2025-12-17

Purpose: Enforce v1 90-day retention for heavy campaign artifacts while retaining master data, reusable definitions, and an asset registry to support reprints/inventory/repeat campaigns without becoming an archive/DAM.

# Locked Decisions (v1)

  --------------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- --------------------------------------------------------------------------------------------------------------
  Option A selected                   Asset Registry (metadata + pointers), not an asset vault

  Heavy proof media retention         90 days after campaign completion (default)

  Binary storage                      External pointers and/or PSP-managed S3 bucket (tenant configurable)

  Keep forever-ish                    Campaign records (light), audit events, store surveys/templates/kit definitions (while active or referenced)

  Exports                             Offer export bundle prior to purge; exports are regeneratable (avoid sprawl)
  --------------------------------------------------------------------------------------------------------------------------------------------------

# Retention Principle

- Delete heavy artifacts on a clock; keep lightweight accountability.

- Never lose the 'how we decided' records (audit, selection recipe, review outcomes).

- Keep what enables repeatability: templates, kit/item definitions, photo rule presets, and asset registry pointers.

# Data Classes & Retention

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Class                             Examples                                                                  Retention                     Notes
  --------------------------------- ------------------------------------------------------------------------- ----------------------------- ----------------------------------------------------
  A. Campaign Proof Media (Heavy)   Install photos, receipt photos, deinstall photos, optional videos         90 days post completion       Lifecycle job purge; export bundle first

  B. Campaign Records (Light)       Campaign metadata, assignments, statuses, review outcomes, audit events   Long horizon (configurable)   Default recommended: 2--5 years; can be indefinite

  C. Store Master Data              Stores, regions/groups, store layout/survey responses                     While active                  Not tied to campaign completion

  D. Reusable Definitions           Survey templates/versions, kit/item templates, photo rule presets         While referenced              Supports repeat campaigns

  E. Asset Registry                 Asset metadata, checksum, version, tags, pointer URI                      While referenced              Binary external or tenant storage

  F. Exports                        Generated CSV/XLSX/XML/JSON/PDF                                           Short-lived                   Regenerate on demand; avoid storing forever
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Asset Registry Behavior (Option A)

- Asset record stores: filename, type/MIME, checksum, version, tags, createdBy/createdAt, and pointer URI.

- Pointer targets may be tenant-configured:

- \- PSP-managed S3 object (tenant bucket), OR

- \- Brand-provided external link (validated allowlist).

- v1 may cache thumbnails/previews for UX but does not guarantee long-term binary hosting.

# Purge Workflow (v1)

1.  At campaign completion, schedule purge of Class A media at +90 days (default).

2.  Generate and notify export bundle availability before purge (configurable lead time).

3.  Purge job deletes binaries (or marks for delete if external is PSP bucket) and scrubs direct URLs; keep mediaAssetId + manifest records.

4.  Retain audit trail of purge action (actor=system).

# Export Bundle Requirement

- Bundle includes: campaign summary, store completion status, verification outcomes, issues/reorders, audit events, and media manifest.

- If binaries still within retention: optional ZIP download; otherwise manifest only (IDs + pointers if allowed).

# Open Decisions / TODOs (Need Inputs)

- Default long-horizon setting for Class B (recommend 5 years unless customer requires indefinite).

- External link validation policy (allowed domains/filetypes; HEAD check; expiry handling).

- Whether any v1 campaigns include video (cost driver).
