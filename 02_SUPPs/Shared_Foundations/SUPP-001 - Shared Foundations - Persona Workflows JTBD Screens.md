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

## PSP Level (Platform & Print Service Provider)

| Persona | Primary Responsibility | Permission Level |
|---------|------------------------|------------------|
| Platform Admin | Full system configuration, tenant management, user impersonation for support, security & audit access | All Privileged + Impersonate |
| PSP Admin | Brand onboarding, PSP-level settings, user management, reporting & exports | PSP All Privileged |
| Production Operator | Update order statuses, create shipments & tracking, process batches, view fulfillment queues | Status & Shipping Updates |

## Brand Level (Brand & Campaign Management)

| Persona | Primary Responsibility | Permission Level |
|---------|------------------------|------------------|
| Brand Admin | Full brand configuration, all campaigns access, store management, user permissions | Brand Level Privileged |
| Campaign Manager | Build new campaigns, manage assigned campaigns, define kits & photo rules, review proofs & approve | Must be assigned to campaigns |
| Regional Manager | Oversee assigned stores, exception queue management, approve/reject proofs, escalate to Brand Admin | Store Compliance for segment |

## Store Level (Store Execution)

| Persona | Primary Responsibility | Permission Level |
|---------|------------------------|------------------|
| Store Manager | Manage store team, approve replacement requests, view all store campaigns, full execution permissions | Full Store Privileges |
| Store Operator | Complete surveys, update status, request replacements (needs Store Manager approval), view assigned campaigns | View Only + Execution |

## System (Integration)

| Persona | Primary Responsibility | Permission Level |
|---------|------------------------|------------------|
| Integration User | Inbound API writes, webhook consumption, export triggers, MIS integration | API & Webhook Service Account |

# Production Operator --- Canonical Workflow

1.  Campaign published → system generates assignments + store orders → PSP notified (email/webhook/in-app).

2.  Production Operator reviews campaign totals + store orders; confirms production/kitting plan.

3.  Production Operator assigns batches (PRODUCTION / PICK_PACK / SHIP_WAVE / CUSTOM) and progresses order statuses.

4.  Production Operator creates shipments (partial allowed), adds tracking, updates shipment/order status (UI or API).

5.  Production Operator processes issues/reorders: approve/fulfill per campaign approval policy; ship replacements.

6.  Production Operator exports required packages (orders/shipments/execution/reorders) and closes fulfillment as needed.

# Brand Admin / Campaign Manager --- Canonical Workflow

7.  Define campaign: type (expiring vs core branding), timeline, instructions, verificationMode (STRICT/FAST), verification SLA, deinstall rules.

8.  Define kit: items + required location slot mappings; attach mockups/reference images; set photo rules (defaults + overrides).

9.  Select stores using all/region/group/custom includes + exclusions; preview selection recipe; publish campaign.

10. Monitor dashboard: completion %, late shipping, anomalies, issue counts, rejection counts.

11. Review proofs (photo + slot packet). Reject specific photos with reason codes; store retakes; approve when satisfied.

12. Apply waivers or force-complete when allowed (requires reason + audit).

Note: Campaign Manager can only manage campaigns they are assigned to. Brand Admin has access to all campaigns.

# Regional Manager --- Exception-first Workflow

- Work from exception queue for assigned stores: overdue, missing proofs, rejected proofs, deinstall overdue (if enabled), severe anomalies.

- Approve/reject proofs; request retakes; reopen stores; apply completion waivers where policy allows (reason required).

- Escalate to Brand Admin/PSP via in-app comment + notification triggers.

# Store Manager / Store Operator --- Execution Workflow (v1)

13. Receive campaign notification and review instructions + mockups and due dates.

14. Receive/Verify: confirm order-level receipt; record item-level anomalies (missing/damaged/incorrect) with photos/evidence as required.

15. Optional: Submit major packaging damage as a single request (PSP may expand into item lines).

16. Pre-install checklist: safety + old campaign removal + readiness acknowledgements.

17. Install per item + location slot; upload proof photos as-you-go; meet brand's required minimums and suggested angles.

18. Completion survey + attestation checkbox (userId + timestamp). Submission goes to review if STRICT, or completes immediately if FAST.

19. If photos rejected: retake only rejected photos; resubmit until satisfied/waived.

20. If campaign expires: complete deinstall task and end survey; proof optional/required per campaign.

Note: Store Operator can complete surveys and request replacements, but replacement requests require Store Manager approval.

# Minimum Screens/Modules (v1)

## PSP Module

| Persona | Screens/Modules |
|---------|-----------------|
| Platform Admin | Tenant config; System settings; User impersonation; Security dashboard; Full audit log |
| PSP Admin | Brand onboarding; PSP settings; User management; Campaign list/totals; Exports center; Webhook/API logs |
| Production Operator | Store order list+filters; Order detail; Batch manager; Shipments+tracking; Issues/Reorders queue |

## Brand Module

| Persona | Screens/Modules |
|---------|-----------------|
| Brand Admin | All Campaign Manager screens + Brand config; Store management; User permissions; Full brand reporting |
| Campaign Manager | Campaign builder; Store selector; Kit/items editor; Photo rules; Dashboard; Store detail; Review queue; Retake queue; Exports/reports |
| Regional Manager | Exception queue (assigned stores); Store compliance dashboard; Review queue; Retake queue; Waivers/Reopen; Escalation tools |

## Store Module

| Persona | Screens/Modules |
|---------|-----------------|
| Store Manager | All Store Operator screens + Team management; Replacement approvals; Store analytics; Full store campaign history |
| Store Operator | My tasks; Campaign detail; Receive/verify; Issue/reorder request; Pre-install checklist; Install + proof capture; Completion survey + attestation; Retake queue; Deinstall task |

# Edge Cases (Must Support)

- Store layout/survey updates mid-campaign: default pinning + controlled Rebase to Latest with verification tasks if fulfillment started.

- Partial shipments and backorders; multiple tracking numbers per shipment.

- STRICT vs FAST verification behavior (brand optional per campaign) with auto-reopen on rejection in FAST.

- Asset substitution for reprints/reorders with audit trail.

- Late shipping thresholds configurable per campaign; escalations routed per notifications matrix.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.1 | 2025-12-20 | Stable filename adopted; version tracked in file |
