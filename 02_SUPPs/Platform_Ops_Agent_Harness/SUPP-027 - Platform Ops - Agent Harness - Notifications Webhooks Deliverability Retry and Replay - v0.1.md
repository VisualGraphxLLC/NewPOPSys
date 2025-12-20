Date: 2025-12-17

Purpose: Define safe notification behavior across dev/staging/prod, including email deliverability controls, webhook endpoint allowlists, channel priorities, retry rules, and manual replay mechanics for eventual delivery.

# Locked Decisions

  ------------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- ------------------------------------------------------------------------------------
  Staging email safety                1A --- Allow real emails ONLY to whitelisted domains/addresses

  Staging webhooks                    2A --- Allow ONLY whitelisted URLs/hosts

  Channel priority (v1)               3C --- Both email + webhooks (when configured)

  Retry rules (webhooks)              4A --- Exponential backoff + dead-letter after N attempts; unlimited MANUAL replay
  ------------------------------------------------------------------------------------------------------------------------

# 1) Notification Channels (v1)

- Email: default channel for human-facing alerts (Brand Admins, PSP staff, Stores).

- Webhooks: event delivery for PSP automation and external systems; configured per tenant/brand.

- Both can be enabled simultaneously; behavior is event-specific (see SUPP-004 + SUPP-006).

# 2) Staging Safety Controls

## 2.1 Email Allowlist (1A)

- Staging only sends to recipients in allowlist (domains and/or explicit addresses).

- Non-allowlisted recipients are suppressed and logged (audit trail).

- Local dev continues using MailHog (SUPP-026).

## 2.2 Webhook Allowlist (2A)

- Staging only dispatches webhooks to allowlisted hosts/URLs.

- Requests to non-allowlisted endpoints are blocked and recorded as \'blocked_by_policy\' (no retries).

- Production allowlist is optional; recommended for higher security tenants.

# 3) Webhook Retry + Dead-Letter + Manual Replay (4A + manual unlimited)

- Automatic retries use exponential backoff with jitter.

- After N attempts (default 10), delivery is marked DEAD_LETTER with last_error retained.

- Manual replay is unlimited: an admin can re-queue a dead-letter or failed delivery at any time.

- Manual replay requires a reason/comment and is audited (who/when/why).

## Default Retry Schedule (Draft)

  -----------------------------------------------------------------------
  Attempt                             Delay (approx)
  ----------------------------------- -----------------------------------
  1                                   1 min

  2                                   5 min

  3                                   15 min

  4                                   1 hr

  5                                   3 hr

  6                                   6 hr

  7                                   12 hr

  8                                   24 hr

  9                                   48 hr

  10                                  72 hr
  -----------------------------------------------------------------------

After attempt 10, delivery enters DEAD_LETTER unless manually replayed.

# 4) Delivery Records (Data Model Hooks)

- webhook_delivery records: eventId, endpointId, status, http_status, attempt_count, next_attempt_at, last_attempt_at, last_error, request_id, correlation_id.

- email_delivery (optional): messageId, recipient_hash, template_key, status, suppressed_reason? (for allowlist blocks), correlation_id.

# 5) Admin UX (Minimum)

- PSP Admin: Notification Settings includes webhook endpoints + allowlists + test send.

- Delivery Log screen: filter by status (FAILED/DEAD_LETTER/BLOCKED), event type, campaign, store.

- Replay action: requeue delivery; requires reason; emits audit_event.

# Acceptance Criteria

1.  Staging suppresses non-allowlisted emails and logs suppression.

2.  Staging blocks non-allowlisted webhook URLs and logs blockage without retry.

3.  Webhook retries execute with exponential backoff and stop at N attempts.

4.  Dead-letter deliveries are replayable manually without limit and are audited.

5.  Email + webhook can both fire for the same event when configured.
