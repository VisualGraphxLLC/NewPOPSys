Date: 2025-12-17

Purpose: Lock onboarding screens and store foundation workflows. v0.4 locks conflict bulk-apply controls for store import.

# Screen Map (Visual)

![](media/image1.png){width="6.8in" height="2.8333333333333335in"}

# Locked Import Semantics

  ---------------------------------------------------------------------------------------------------------------------
  Area                                Locked
  ----------------------------------- ---------------------------------------------------------------------------------
  Import truth-set                    Partial update (missing stores unaffected; never deactivate)

  Match behavior                      Conflict requiring explicit action (Keep/Update/Skip)

  Bulk apply                          ALLOWED: user can bulk-apply UPDATE/KEEP to selected conflicts (still explicit)
  ---------------------------------------------------------------------------------------------------------------------

# Conflict Resolution UX (Bulk Apply)

- Conflicts grid includes checkboxes + filter/sort (by region, city, etc.).

- Bulk actions: APPLY_UPDATE, APPLY_KEEP, APPLY_SKIP to selected rows.

- Before apply: show summary counts and require confirm.

- Per-row override remains available even after bulk apply (edit before final apply).

# Audit & Safety

- Bulk apply writes an audit_event recording: selection criteria, row ids selected, and action applied.

- Applying UPDATE_EXISTING produces audit_event per store updated with before/after snapshots.

- Hard deletion never occurs via import.
