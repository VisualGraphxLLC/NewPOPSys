Date: 2025-12-17

Purpose: Definitive rules for store completion, campaign completion, expiring vs non-expiring campaigns, deinstall workflows, brand-optional case creation, and administrative overrides.

# Campaign Types (v1)

  ---------------------------------------------------------------------------------------
  Type                                Expiration Behavior
  ----------------------------------- ---------------------------------------------------
  Promotional (Expiring)              Has end date; triggers deinstall workflow

  Core Branding (Non-expiring)        No end date; deinstall only if manually triggered
  ---------------------------------------------------------------------------------------

# Store Completion States (v1)

  -----------------------------------------------------------------------------------------------------
  State                   Meaning                                          Typical Actor
  ----------------------- ------------------------------------------------ ----------------------------
  IN_PROGRESS             Work not certified yet                           STORE_USER

  SUBMITTED_FOR_REVIEW    Submitted; awaiting admin review (STRICT mode)   STORE_USER

  REWORK_REQUESTED        Rejected proof; retake required                  REGIONAL/BRAND

  COMPLETE                Certified complete; proofs satisfied or waived   STORE_USER or ADMIN waiver
  -----------------------------------------------------------------------------------------------------

# Verification Mode (Per Campaign)

- STRICT: store submission goes to SUBMITTED_FOR_REVIEW and is not COMPLETE until proofs satisfied or waiver applied.

- FAST: store becomes COMPLETE immediately on submission; if proofs later rejected, store auto-reopens to REWORK_REQUESTED.

- Both modes require audit events for waiver/reopen and preserve review outcomes for reporting.

# Store Completion Definition (Normal Path)

- Receive/verify completed (or documented exceptions).

- Install completed for required items/locations.

- Completion survey submitted.

- Required photo slots submitted per brand rules.

- Signature/attestation checkbox recorded (userId + timestamp).

# Completion Waivers (Allowed)

- BRAND_ADMIN or REGIONAL_ADMIN may waive missing required proofs and mark store COMPLETE.

- Waiver requires reason; emit audit event store.completion_waived; record which requirements were waived.

# Reopen Rules

- BRAND_ADMIN and REGIONAL_ADMIN may reopen a completed store (reason required; emit store.reopened).

- In FAST mode, photo rejection automatically reopens the store into REWORK_REQUESTED.

# Campaign Completion Definition

- A\) All assigned stores reach COMPLETE; OR

- B\) BRAND_ADMIN force-completes campaign (reason required; emit campaign.force_completed); OR

- C\) For expiring campaigns: end date reached AND required deinstall workflow completed (if enabled).

# Expiration & Deinstall (Expiring Campaigns)

- On end date: deinstall task created; notify store + brand + PSP.

- Deinstall survey + attestation required; photo proof optional by default and configurable per campaign.

- Deinstall overdue triggers escalation after grace period (per campaign config).

- Brand/campaign may enable NonComplianceCase creation for overdue deinstall (see SUPP-019).

# Retention Clock Trigger

- Retention clock (proof media purge) starts at campaign completion timestamp.

- If campaign is force-completed, retention still starts and records the incomplete stores snapshot.

# Config Fields (Draft)

  -------------------------------------------------------------------------------------
  Field                               Meaning
  ----------------------------------- -------------------------------------------------
  verificationMode                    STRICT \| FAST

  verificationSlaHours                hours until review overdue triggers escalations

  deinstallProofRequired              true/false (default false)

  deinstallGraceDays                  grace period before overdue escalation

  nonComplianceCaseEnabled            true/false (brand optional)
  -------------------------------------------------------------------------------------

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
