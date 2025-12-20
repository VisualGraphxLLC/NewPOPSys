Date: 2025-12-17

Purpose: Define the post‑v1 "Takeout" capability at a brand scope: what it includes, how it's delivered, and how it interacts with retention policies. This is a scaffold for future production enhancements (no shadow storage).

# Locked Decisions

  --------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- --------------------------------------------------------------------------------
  Takeout scope                       1B --- Brand-only by default

  Include media                       2C --- Optional per request (metadata-only or full bundle)

  Delivery method                     3C --- Both: download link and push to customer S3

  Retention interaction               4C --- Admin chooses at export time; deleted means deleted (no shadow storage)
  --------------------------------------------------------------------------------------------------------------------

# Principle: No Shadow Storage

- Takeout does NOT resurrect deleted media or records.

- If retention has deleted a blob, takeout can only include the metadata record and note it as deleted/unavailable.

- No hidden backup copies solely for takeout.

# 1) Package Contents (Brand Scope)

- Brand configuration: roles/users (metadata), stores, regions/groups, survey templates, product templates/mockups.

- Campaign records: campaigns, kits, assignments, orders, shipments, proofs, reviews, issues/reorders, completion/deinstall records.

- Audit exports: audit_event (brand-scoped), webhook_delivery logs (optional), export_job history (optional).

- Artifacts: generated exports/reports (CSV/XLSX/PDF/JSON/XML) as available and not expired.

# 2) Media Options (2C)

  -----------------------------------------------------------------------------------------------------------------------
  Option                              What's included
  ----------------------------------- -----------------------------------------------------------------------------------
  Metadata-only                       media_asset rows + URLs (signed) where still present; missing flagged

  Full bundle                         zip/object pack of media still available within retention window; missing flagged
  -----------------------------------------------------------------------------------------------------------------------

Admin selects media mode per takeout request. If full bundle selected, system warns about size/time/cost.

# 3) Delivery Options (3C)

- Download link: async export job generates package and provides time-limited download URL.

- Push to customer S3: brand/tenant supplies bucket + role/credentials; system uploads package and writes manifest.

- Both can be enabled for the same takeout request.

# 4) Retention Choice at Export Time (4C)

- Admin chooses one of: (a) respect retention (default), (b) include all currently-available data regardless of classification, (c) include only "business permanent" classes.

- Regardless of selection: anything already deleted remains deleted/unavailable.

- Export manifest includes counts: included, missing, deleted, suppressed-by-policy.

# Data Contracts

- Takeout produces a manifest.json with versions, schema hashes, and file list.

- Each dataset is exported in stable formats (JSON lines + CSV) to support ingestion.

- Schemas reference OpenAPI/Zod contracts to keep parsing consistent across versions.

# Security Controls

- Only PSP Admin can initiate takeout by default (scaffold delegation later).

- Takeout requests are audited with reason, scope, and delivery method.

- Packages are encrypted at rest (S3 SSE) and optionally encrypted with customer PGP key (future).

# Acceptance Criteria (Scaffold)

1.  A brand-scoped takeout request can be created and run as an async export job (even if post‑v1).

2.  Manifest lists included datasets and flags missing/deleted media clearly.

3.  Delivery supports both download link and push-to-S3 modes.

4.  No shadow storage: exports only include what currently exists.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
