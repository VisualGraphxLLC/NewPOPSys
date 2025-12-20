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
