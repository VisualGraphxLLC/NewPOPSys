Date: 2025-12-17

Purpose: Define notification triggers, recipients, channels, and escalation rules to keep v1 operations disciplined (PSP + brand + store) and automation-friendly.

# Channels (v1)

- In-app notifications (required)

- Email (required for PSP + brand admins; optional for store for non-critical)

- Outbound webhooks (required for PSP automation and downstream systems)

# Event → Recipients → Channels (v1 Minimum)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Event                                 Trigger                                       Recipients                                       Channels
  ------------------------------------- --------------------------------------------- ------------------------------------------------ -------------------------------------
  order.created                         Campaign publish generates store orders       PSP_OPS, PSP_ADMIN                               Email + Webhook + In-app

  alert.late_shipping                   Late rule threshold breached (per campaign)   PSP_OPS, PSP_ADMIN, BRAND_ADMIN                  Email + Webhook + In-app

  shipment.updated                      Tracking/status change                        BRAND_ADMIN, REGIONAL_ADMIN; Store (optional)    Webhook + In-app (Email optional)

  execution.anomaly                     Receive/verify or completion anomaly          BRAND_ADMIN, REGIONAL_ADMIN                      Webhook + In-app (Email optional)

  proof.submitted                       Store submits completion (STRICT or FAST)     BRAND_ADMIN, REGIONAL_ADMIN                      Webhook + In-app

  photo.rejected                        Photo rejected w/ reason code                 STORE_USER                                       In-app + (Email optional)

  review.overdue                        Verification SLA missed (per campaign)        REGIONAL_ADMIN, BRAND_ADMIN                      In-app + Email

  issue.submitted                       Issue/reorder submitted                       PSP_OPS, PSP_ADMIN; BRAND_ADMIN (policy-based)   Email + In-app + Webhook

  issue.approval_required               ApprovalMode requires admin decision          BRAND_ADMIN/REGIONAL_ADMIN (as configured)       In-app + Email

  issue.approved_or_rejected            Decision recorded                             PSP_OPS (+ Store optional)                       Webhook + In-app

  campaign.expired.deinstall_required   End date reached (expiring)                   STORE_USER, BRAND_ADMIN, PSP_OPS                 In-app + Email + Webhook

  deinstall.overdue                     Grace period exceeded                         REGIONAL_ADMIN, BRAND_ADMIN                      In-app + Email

  noncompliance.case_created            Case toggle enabled and overdue               REGIONAL_ADMIN, BRAND_ADMIN                      In-app + Email + Webhook (optional)

  store.reopened_or_waived              Admin reopens store or waives proof           STORE_USER (+ Brand/Regional)                    In-app + (Email optional)
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Preferences (v1)

- Users can opt out of non-critical emails per category.

- Critical alerts (late shipping, overdue deinstall, approval required, review overdue) are not fully disableable.

- Store email defaults to minimal: proof rejection + deinstall required + critical reminders (configurable).

# Escalation Rules (Defaults)

- Late shipping: evaluate per campaign rule; escalate to PSP + brand.

- Verification SLA: overdue escalates to Regional → Brand (schedule configurable per campaign).

- Deinstall overdue: brand optional case creation; otherwise escalation only.
