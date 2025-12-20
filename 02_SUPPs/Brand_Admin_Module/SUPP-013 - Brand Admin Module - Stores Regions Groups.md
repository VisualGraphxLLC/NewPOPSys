Date: 2025-12-17

Purpose: Define store master data, hierarchical geography, custom groupings, import/update flows, and how changes interact with active campaigns and fulfillment.

# Locked Decisions (Module 2)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Topic                               Decision
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------
  Canonical Store Identifiers         Store Number + external GUID alias (both stored; one primary key strategy)

  Hierarchy Depth                     Region → District → Territory → Store (District/Territory optional layers)

  Custom Groups Ownership             Regional Admin + Brand Admin can create/edit groups

  Store Address Changes               Prefer always reflect latest store record; add verification prompt before fulfillment; freeze shipping snapshot on generated orders

  Import & Integration                CSV/XLSX import + API import endpoint (v1)

  Integration User Scope              Platform/PSP-level service account; permitted across all brands within the PSP tenant
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 1) Data Model (Conceptual)

- Store identifiers:

- \- storeId (ULID/UUID PK)

- \- storeNumber (brand-facing unique identifier; required)

- \- externalStoreGuid (optional; for brand/PSP system mapping)

- Geography:

- \- Region (required)

- \- District (optional; belongs to Region)

- \- Territory (optional; belongs to District or Region depending on model)

- Store belongs to exactly one Region. District/Territory are nullable references to support optional layers.

- Groups: StoreGroup (custom grouping) with many-to-many StoreGroupMembership(storeId, groupId).

# 2) Store Import & Update Flows (Inputs → Outputs)

  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  Flow                    User/Input                              System Output
  ----------------------- --------------------------------------- ------------------------------------------------------------------------------------------------
  CSV/XLSX Import         Brand Admin uploads store file          Creates/updates stores; validates duplicates; logs audit events; returns import report

  API Import              Integration user posts store payloads   Upserts stores; returns per-row results; emits audit events; supports idempotency

  Manual Edit             Admin edits store fields                Updates store; triggers verification prompts for active campaigns (if critical fields changed)
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------

# 3) Required Store Fields (v1 Minimum)

- storeNumber (required), storeName, address1, address2, city, state/province, postalCode, country

- regionId (required), districtId (optional), territoryId (optional)

- primaryContactName/email/phone (optional), storeManagerName (optional)

- status (active/inactive), notes

- externalStoreGuid (optional)

# 4) How Store Changes Interact with Active Campaigns

- Master record: store master data always reflects latest known truth (preferred).

- Fulfillment safety: if a critical shipping field changes (address fields, storeNumber, region), and the store is assigned to an active campaign before orders are shipped:

- \- System creates a \'Store Change Verification\' task for Brand Admin + PSP Ops to acknowledge/approve.

- \- Until verified, fulfillment for that store may be paused (configurable).

- Shipping snapshot: once an Order/Shipment is created, the order record stores a snapshot of shipping fields used for that fulfillment run (immutable for audit).

# 5) Custom Groups (v1)

- Group types: custom (user-defined) groups used for store selection and reporting.

- Creators/editors: Regional Admin + Brand Admin (within their scope).

- Group membership: store can belong to multiple groups; membership changes are audit-logged.

- Campaign selection supports: include/exclude by groups and by hierarchy filters (region/district/territory).

# 6) APIs (Draft Endpoint List)

- GET /stores (filter by region/district/territory/group, search, pagination)

- POST /stores/import (CSV/XLSX upload)

- POST /stores/bulkUpsert (API import; integration user)

- PATCH /stores/{storeId} (manual edit)

- GET/POST/PATCH /storeGroups and /storeGroups/{id}/members

- GET /regions, /districts, /territories (hierarchy management; optional admin endpoints)

- POST /storeChanges/{changeId}/verify (Brand + PSP acknowledgement)

# 7) Acceptance Criteria (Module 2)

1.  Admin can import stores via CSV/XLSX and receive an import report with created/updated/skipped rows.

2.  Integration user can upsert stores via API with idempotency support.

3.  Geography filters support optional layers (Region only; Region+District; Region+District+Territory).

4.  Admins can create custom groups and assign stores; store can belong to multiple groups.

5.  Campaign store selection can include/exclude by group and by hierarchy.

6.  Critical store changes for active campaigns create verification tasks and preserve order shipping snapshots.

# Open Decisions

7.  Define which fields are \'critical\' to trigger verification (address, storeNumber, region, contacts?).

8.  Decide whether verification blocks fulfillment automatically or only warns (default: blocks for address changes).

9.  Confirm whether territory belongs to district only (strict) or can be directly under region (flex).

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
