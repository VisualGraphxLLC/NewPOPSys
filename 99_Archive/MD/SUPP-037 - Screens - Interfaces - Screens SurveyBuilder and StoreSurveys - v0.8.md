Date: 2025-12-18

v0.8 locks override policy toggles and export behavior for computed/overridden fields.

# Locked Policy Toggles (v1)

  -------------------------------------------------------------------------------------------------
  Topic                               Locked
  ----------------------------------- -------------------------------------------------------------
  Brand can disable overrides         A --- Yes (brand setting: allow_computed_overrides=false)

  Campaign override tightening        B --- No (brand-only policy; campaign cannot tighten in v1)

  Exports include values              B --- Include final + computed + override metadata
  -------------------------------------------------------------------------------------------------

# Settings & Data Model Notes

- brand.settings_json.allow_computed_overrides (default true) controls whether store-side override UI is available.

- Field-level allow_override must also be true AND user role eligible (Store Manager/Brand Admin) for override control to appear.

- No campaign-level tightening in v1 to avoid conflicting policy sources; scaffold for post-v1 if needed.

# Export Contract (v1)

  -------------------------------------------------------------------------------------------------------------------
  Column/Field                        Description
  ----------------------------------- -------------------------------------------------------------------------------
  value_final                         Final value used for reporting and downstream ops (after override if present)

  value_computed                      The computed value at time of submission (if computed field)

  is_overridden                       Boolean flag

  override_value                      Value entered by user (if overridden)

  override_user_id                    User who overrode (if overridden)

  override_timestamp                  When override occurred

  override_reason                     Optional reason text
  -------------------------------------------------------------------------------------------------------------------

# Scaffold for later

- Add campaign-level tightening (allow_overrides_override=false) under feature flag if brands demand it.

- Add admin review UI (post-v1) to filter by is_overridden and reason.
