Date: 2025-12-17

Purpose: Define v1 personas, jobs-to-be-done, canonical workflows (happy + exceptions), and the minimum screens/modules required for the pilot vertical slice at scale.

# Locked Inputs (Current)

  ----------------------------------------------------------------------------------------------------------------------------------
  Decision                            Value
  ----------------------------------- ----------------------------------------------------------------------------------------------
  Pilot PSPs                          Visual Graphx; Speedy CPS / Alpha Graphics

  Pilot Brand (confirmed)             Good2Go (Speedy/AG pilot)

  Auth (v1)                           Email + password

  Execution platform                  Mobile-first web app + PWA scaffold; best-effort offline drafts + sync-on-open

  Photos                              Bound to item + store location slot; brand-owned requirements (defaults + overrides)

  Verification                        Photo-level + slot-level review; retake only rejected photos; STRICT/FAST mode per campaign

  Fulfillment                         Orders generated on publish; partial shipments supported; batch tracking with enums + CUSTOM
  ----------------------------------------------------------------------------------------------------------------------------------

# Personas (v1)

  ----------------------------------------------------------------------------------------------------------------------------------------
  Persona                             Primary Responsibility
  ----------------------------------- ----------------------------------------------------------------------------------------------------
  PSP_ADMIN                           Tenant config, brand onboarding, security, permissions, system settings

  PSP_OPS                             Fulfillment ops: orders, production/batches, shipments, reorders; updates via UI/API

  BRAND_ADMIN / Campaign Admin        Campaign creation, store selection, kit definitions, verification mode/SLA, reporting

  REGIONAL_ADMIN                      Exception-first oversight, photo review, store reopen/waivers, escalations

  STORE_USER                          Receive/verify, report issues, install, proof capture, completion + attestation, retakes/deinstall

  INTEGRATION_USER                    PSP automation service account: inbound API writes; webhook consumption; export triggers
  ----------------------------------------------------------------------------------------------------------------------------------------

# PSP_OPS --- Canonical Workflow

1.  Campaign published → system generates assignments + store orders → PSP notified (email/webhook/in-app).

2.  PSP reviews campaign totals + store orders; confirms production/kitting plan.

3.  PSP assigns batches (PRODUCTION / PICK_PACK / SHIP_WAVE / CUSTOM) and progresses order statuses.

4.  PSP creates shipments (partial allowed), adds tracking, updates shipment/order status (UI or API).

5.  PSP processes issues/reorders: approve/fulfill per campaign approval policy; ship replacements.

6.  PSP exports required packages (orders/shipments/execution/reorders) and closes fulfillment as needed.

# Brand Admin --- Canonical Workflow

7.  Define campaign: type (expiring vs core branding), timeline, instructions, verificationMode (STRICT/FAST), verification SLA, deinstall rules.

8.  Define kit: items + required location slot mappings; attach mockups/reference images; set photo rules (defaults + overrides).

9.  Select stores using all/region/group/custom includes + exclusions; preview selection recipe; publish campaign.

10. Monitor dashboard: completion %, late shipping, anomalies, issue counts, rejection counts.

11. Review proofs (photo + slot packet). Reject specific photos with reason codes; store retakes; approve when satisfied.

12. Apply waivers or force-complete when allowed (requires reason + audit).

# Regional Admin --- Exception-first Workflow

- Work from exception queue: overdue, missing proofs, rejected proofs, deinstall overdue (if enabled), severe anomalies.

- Approve/reject proofs; request retakes; reopen stores; apply completion waivers where policy allows (reason required).

- Escalate to Brand Admin/PSP Ops via in-app comment + notification triggers.

# Store User --- Execution Workflow (v1)

13. Receive campaign notification and review instructions + mockups and due dates.

14. Receive/Verify: confirm order-level receipt; record item-level anomalies (missing/damaged/incorrect) with photos/evidence as required.

15. Optional: Submit major packaging damage as a single request (PSP may expand into item lines).

16. Pre-install checklist: safety + old campaign removal + readiness acknowledgements.

17. Install per item + location slot; upload proof photos as-you-go; meet brand's required minimums and suggested angles.

18. Completion survey + attestation checkbox (userId + timestamp). Submission goes to review if STRICT, or completes immediately if FAST.

19. If photos rejected: retake only rejected photos; resubmit until satisfied/waived.

20. If campaign expires: complete deinstall task and end survey; proof optional/required per campaign.

# Minimum Screens/Modules (v1)

  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Persona                             Screens/Modules
  ----------------------------------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  PSP                                 Campaign list/totals; Store order list+filters; Order detail; Batch manager; Shipments+tracking; Issues/Reorders queue; Exports center; Webhook/API logs; Audit log

  Brand/Regional                      Campaign builder; Store selector; Kit/items editor; Photo rules; Dashboard; Store detail; Review queue; Retake queue; Waivers/Reopen; Exports/reports

  Store                               My tasks; Campaign detail; Receive/verify; Issue/reorder; Pre-install checklist; Install + proof capture; Completion survey + attestation; Retake queue; Deinstall task
  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Edge Cases (Must Support)

- Store layout/survey updates mid-campaign: default pinning + controlled Rebase to Latest with verification tasks if fulfillment started.

- Partial shipments and backorders; multiple tracking numbers per shipment.

- STRICT vs FAST verification behavior (brand optional per campaign) with auto-reopen on rejection in FAST.

- Asset substitution for reprints/reorders with audit trail.

- Late shipping thresholds configurable per campaign; escalations routed per notifications matrix.
