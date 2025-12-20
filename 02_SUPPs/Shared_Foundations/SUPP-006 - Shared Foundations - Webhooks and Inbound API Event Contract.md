# SUPP-006 — Webhooks and Inbound API Event Contract

> **Version**: v0.6
> **Status**: Locked
> **Updated**: 2025-12-20
> **Dependencies**: SUPP-004 (Notifications), SUPP-027 (Message Delivery), SUPP-035 (Data Model)

---

## Purpose

Integration contract for outbound webhooks (system → PSP/brand) and inbound API writes (PSP automation → system) including signing, idempotency, retries, schema versioning, and required event types.

---

## 1. Outbound Webhooks (v1)

- **Delivery**: At-least-once with retries; consumers must dedupe by `eventId`
- **Security**: HMAC signature + timestamp header; secret rotation supported
- **Operational**: Delivery logs, retry schedule, dead-letter after N failures, manual replay UI

### Headers

| Header | Description |
|--------|-------------|
| `X-NewPOPSys-Event` | Event type (e.g., `order.created`) |
| `X-NewPOPSys-Event-Id` | Unique event ID (UUIDv7) |
| `X-NewPOPSys-Timestamp` | Unix timestamp (milliseconds) |
| `X-NewPOPSys-Signature-256` | HMAC-SHA256 signature |
| `X-NewPOPSys-Schema-Version` | Schema version (e.g., `1.0`) |

### Signature Calculation

```
String to sign: <timestamp>.<raw_body_bytes>
Signature: HMAC_SHA256(secret, string_to_sign)
Header: X-NewPOPSys-Signature-256: sha256=<hex>
```

---

## 2. Required Webhook Events (v1 Minimum)

| Event Type | When Fired | Primary Recipients |
|------------|------------|-------------------|
| `order.created` | Orders generated for campaign publish | PSP |
| `order.updated` | Order status/fields updated | PSP (+ Brand optional) |
| `shipment.created` | Shipment created (partial allowed) | PSP (+ Brand) |
| `shipment.updated` | Tracking/status updated; multi-tracking allowed | PSP + Brand (+ Store optional) |
| `batch.updated` | Batch created/updated or membership changed | PSP |
| `alert.late_shipping` | Late shipping threshold breached (per campaign) | PSP + Brand |
| `alert.execution_anomaly` | Receive/verify or completion anomaly detected | Brand |
| `proof.submitted` | Store submits completion (STRICT/FAST) | Brand/Regional |
| `photo.rejected` | Admin rejects photo(s) with comments/reason | Store |
| `review.overdue` | Verification SLA breached | Brand/Regional |
| `issue.submitted` | Issue/reorder submitted | PSP (+ Brand policy-based) |
| `issue.approval_required` | Approval needed by brand/regional | Brand/Regional |
| `issue.decided` | Issue approved/rejected | PSP (+ Store optional) |
| `reorder.shipment.updated` | Replacement shipment status/tracking updated | PSP + Brand |
| `campaign.expired.deinstall_required` | Campaign end triggers deinstall | Store + Brand/PSP |
| `deinstall.overdue` | Deinstall overdue (grace exceeded) | Brand/Regional |
| `noncompliance.case_created` | Case created when enabled | Brand/Regional |

---

## 3. Event Envelope

All webhook deliveries use this envelope (payload varies by type/version):

```json
{
  "eventId": "evt_01HXYZ...",
  "eventType": "order.created",
  "occurredAt": "2025-12-17T18:00:00Z",
  "schemaVersion": "1.0",
  "pspId": "psp_...",
  "brandId": "br_...",
  "campaignId": "cmp_...",
  "storeId": "sto_...",
  "correlationId": "corr_...",
  "actor": {
    "type": "system|human|integration",
    "id": "usr_..."
  },
  "data": {
    // Event-specific payload
  }
}
```

---

## 4. Inbound API Writes (v1)

- All write endpoints require `Idempotency-Key` header
- **Auth**: API keys per PSP tenant; least-privilege scopes per key; rotate/revoke supported
- **Minimum write scopes**: update order status; create/update shipments + tracking; manage batches; trigger exports
- **Optional v1**: store bulk upsert (if enabled for PSP integration user)

### Inbound Events (From PSP)

| Event | Required Payload |
|-------|------------------|
| `order.acknowledged` | `orderId`, `pspOrderRef`, `status` |
| `shipment.created` | `orderId`, `trackingNumbers[]` |
| `shipment.delivered` | `orderId`, `deliveredAt` |

---

## 5. Replay Protection

- Receiver validates timestamp is within allowed window (default ±5 minutes)
- Receiver validates nonce/eventId not seen before within window
- If timestamp outside window: reject with 401/403 and log as `replay_window_violation`

---

## 6. Idempotency

- Inbound: `Idempotency-Key` + stable request hash; store key for replay window
- Server stores: `{tenantId, key, method, path, request_hash, response_hash, created_at, expires_at}`
- If duplicate key received: return original response (same status code + body)
- If key reused with different `request_hash`: return 409 Conflict
- Outbound: `eventId` is globally unique; consumers dedupe by `eventId`

---

## 7. Correlation

`correlationId` links campaign → orders → shipments → execution → exports for end-to-end tracing.

---

## 8. Schema Versioning

- Events include `schemaVersion` (e.g., `1.0`)
- Breaking changes increment major; additive changes increment minor
- Consumers should ignore unknown fields and handle `eventType` + `schemaVersion` explicitly

---

## 9. Response Codes

| Scenario | Code |
|----------|------|
| Signature invalid | 401 Unauthorized |
| Timestamp/nonce replay | 403 Forbidden |
| Webhook accepted | 2xx (200/202) |
| Receiver temporarily failing | 5xx (will retry per SUPP-027) |
| Idempotency key missing | 400 Bad Request |
| Idempotency key reuse with different payload | 409 Conflict |

---

## 10. Retry Schedule

- Exponential backoff with jitter
- Max retry window: 72 hours
- Dead-letter after max failures
- Manual replay available via admin UI

---

## 11. Implementation Notes

- Webhooks are at-least-once delivery; consumers must be idempotent
- Prefer responding quickly (200/202) and doing heavy work async on consumer side
- Keep secrets rotated: store current + previous secret for grace period; support key rotation in UI

---

## Open Decisions

- Whether PSP webhook registration requires IP allowlists in pilots
- Exact dead-letter thresholds (recommend: exponential backoff + max 72h)

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| v0.3 | 2025-12-17 | Initial event list with basic webhook contract |
| v0.4 | 2025-12-18 | Comprehensive specification: 17 event types, HMAC signing, replay protection, event envelope, idempotency, response codes. Integrated SUPP-028 (Webhook Security) as appendix. |
| v0.5 | 2025-12-19 | Simplified format; removed implementation details |
| v0.6 | 2025-12-20 | Restored comprehensive specification from v0.4; added headers table, replay protection, idempotency details, response codes, retry schedule; stable filename adopted |
