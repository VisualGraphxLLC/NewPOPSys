Date: 2025-12-18

Purpose: Integration contract for outbound webhooks (system → PSP/brand) and inbound API writes (PSP automation → system) including signing, idempotency, retries, schema versioning, and required event types.

Revision note: This SUPP is a full replacement. It incorporates overlapping material from SUPP-028_Webhook_Security_Event_Envelope_and_Idempotency_v0_1.docx as an appendix for traceability; where conflicts exist, the main body of this SUPP is authoritative.

# Outbound Webhooks (v1)

- Delivery: at-least-once with retries; consumers must dedupe by eventId.

- Security: HMAC signature + timestamp header; secret rotation supported.

- Headers (draft): X-NewPOPSys-Event, X-NewPOPSys-Event-Id, X-NewPOPSys-Timestamp, X-NewPOPSys-Signature-256, X-NewPOPSys-Schema-Version

- Envelope: {eventId, eventType, occurredAt, schemaVersion, pspId, brandId?, campaignId?, storeId?, correlationId?, data:{\...}}

- Operational: delivery logs, retry schedule, dead-letter after N failures, manual replay UI.

# Required Webhook Events (v1 Minimum)

  ------------------------------------------------------------------------------------------------------------------------
  Event Type                            When Fired                                        Primary Recipients
  ------------------------------------- ------------------------------------------------- --------------------------------
  order.created                         Orders generated for campaign publish             PSP

  order.updated                         Order status/fields updated                       PSP (+ Brand optional)

  shipment.created                      Shipment created (partial allowed)                PSP (+ Brand)

  shipment.updated                      Tracking/status updated; multi-tracking allowed   PSP + Brand (+ Store optional)

  batch.updated                         Batch created/updated or membership changed       PSP

  alert.late_shipping                   Late shipping threshold breached (per campaign)   PSP + Brand

  alert.execution_anomaly               Receive/verify or completion anomaly detected     Brand

  proof.submitted                       Store submits completion (STRICT/FAST)            Brand/Regional

  photo.rejected                        Admin rejects photo(s) with comments/reason       Store

  review.overdue                        Verification SLA breached                         Brand/Regional

  issue.submitted                       Issue/reorder submitted                           PSP (+ Brand policy-based)

  issue.approval_required               Approval needed by brand/regional                 Brand/Regional

  issue.decided                         Issue approved/rejected                           PSP (+ Store optional)

  reorder.shipment.updated              Replacement shipment status/tracking updated      PSP + Brand

  campaign.expired.deinstall_required   Campaign end triggers deinstall                   Store + Brand/PSP

  deinstall.overdue                     Deinstall overdue (grace exceeded)                Brand/Regional

  noncompliance.case_created            Case created when enabled                         Brand/Regional
  ------------------------------------------------------------------------------------------------------------------------

# Inbound API Writes (v1)

- All write endpoints require Idempotency-Key header; server returns same response for duplicates.

- Auth: API keys per PSP tenant; least-privilege scopes per key; rotate/revoke supported.

- Minimum write scopes: update order status; create/update shipments + tracking; manage batches; trigger exports.

- Optional v1: store bulk upsert (if enabled for PSP integration user).

# Idempotency & Correlation

- Inbound: Idempotency-Key + stable request hash; store key for replay window.

- Outbound: eventId is globally unique; consumers dedupe by eventId.

- Correlation: correlationId links campaign → orders → shipments → execution → exports.

# Schema Versioning

- Events include schemaVersion (e.g., 1.0). Breaking changes increment major; additive changes increment minor.

- Consumers should ignore unknown fields and handle eventType + schemaVersion explicitly.

# Sample Event (order.created)

\`\`\`json\
{\
\"eventId\": \"evt_123\",\
\"eventType\": \"order.created\",\
\"occurredAt\": \"2025-12-17T18:00:00Z\",\
\"schemaVersion\": \"1.0\",\
\"pspId\": \"psp\_\...\",\
\"brandId\": \"br\_\...\",\
\"campaignId\": \"cmp\_\...\",\
\"correlationId\": \"corr\_\...\",\
\"data\": {\
\"orderId\": \"ord\_\...\",\
\"orderNumber\": \"G2G-000123\",\
\"storeId\": \"sto\_\...\",\
\"status\": \"GENERATED\"\
}\
}\
\`\`\`

# Open Decisions

- Whether PSP webhook registration requires IP allowlists in pilots.

- Exact retry schedule and dead-letter thresholds (recommend: exponential backoff + max 24h).

# Appendix --- Integrated Material (for traceability)

SUPP-028 --- Webhook Security, Event Envelope & Idempotency (v0.1)

Date: 2025-12-17

Purpose: Define webhook security and delivery contracts: signing, replay protection, envelope format, and idempotency requirements for inbound integration writes. This closes the gap between SUPP-006 (events) and Module 20 physical schema (outbox/idempotency).

# Locked Decisions

  -----------------------------------------------------------------------------------------------------------------------
  Area                                Choice
  ----------------------------------- -----------------------------------------------------------------------------------
  Webhook signing                     1A --- HMAC SHA-256 signature header (Prod/Staging). Dev may disable signing (1C)

  Replay protection                   2A --- Timestamp + nonce window

  Payload format                      3A --- Standard event envelope

  Inbound idempotency                 4A --- Require Idempotency-Key header on integration writes
  -----------------------------------------------------------------------------------------------------------------------

# 1) Webhook Signature (HMAC SHA-256)

- Header: X-NewPOPSys-Signature: sha256=\<hex\>

- Header: X-NewPOPSys-Timestamp: \<unix_ms\>

- String to sign: \<timestamp\>.\<raw_body_bytes\>

- Signature: HMAC_SHA256(secret, string_to_sign)

- Dev mode: signing can be disabled for localhost testing, but should be on in staging/prod.

# 2) Replay Protection (2A)

- Receiver validates timestamp is within allowed window (default ±5 minutes).

- Receiver validates nonce/eventId not seen before within window (store nonce/eventId hash).

- If timestamp outside window: reject with 401/403 and log as \'replay_window_violation\'.

# 3) Event Envelope (3A)

All webhook deliveries use this envelope (payload varies by type/version):

\`\`\`json\
{\
\"eventId\": \"uuidv7\",\
\"type\": \"campaign.order.created\",\
\"version\": 1,\
\"occurredAt\": \"2025-12-17T00:00:00.000Z\",\
\"tenantId\": \"uuidv7\",\
\"brandId\": \"uuidv7\",\
\"correlationId\": \"uuidv7\",\
\"actor\": { \"type\": \"system\|human\|integration\", \"id\": \"uuidv7\" },\
\"payload\": { }\
}\
\`\`\`

- type is namespaced and stable; version increments on breaking changes.

- payload schemas are defined in shared Zod + OpenAPI (SUPP-020 + Module 21).

# 4) Inbound Integration Writes --- Idempotency (4A)

- All integration write endpoints require Idempotency-Key for POST/PUT that mutate state.

- Server stores {tenantId, key, method, path, request_hash, response_hash, created_at, expires_at}.

- If duplicate key is received: return original response (same status code + body).

- If key reused with different request_hash: return 409 conflict (idempotency_key_reuse).

# 5) Response Codes (Recommended)

  ----------------------------------------------------------------------------------
  Scenario                                       Code
  ---------------------------------------------- -----------------------------------
  Signature invalid                              401 Unauthorized

  Timestamp/nonce replay                         403 Forbidden

  Webhook accepted                               2xx (200/202)

  Receiver temporarily failing                   5xx (will retry per SUPP-027)

  Idempotency key missing                        400 Bad Request

  Idempotency key reuse with different payload   409 Conflict
  ----------------------------------------------------------------------------------

# 6) Implementation Notes

- Webhooks are at-least-once delivery; consumers must be idempotent.

- Prefer responding quickly (200/202) and doing heavy work async on consumer side.

- Keep secrets rotated: store current + previous secret for grace period; support key rotation in UI.

# Acceptance Criteria

1.  Staging/prod webhook signatures validate and reject tampered bodies.

2.  Replay protection blocks old timestamps and duplicate eventIds within window.

3.  Event envelope is emitted consistently for all webhook types.

4.  Integration endpoints enforce Idempotency-Key and return consistent responses on repeats.

5.  Dev can disable signing only for localhost and only when configured explicitly.
