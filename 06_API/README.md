# NewPOPSys API Documentation

> **Version**: 1.0.0
> **Generated**: 2025-12-19
> **Source**: SUPP-006 (Webhooks & Inbound API Event Contract)

---

## Quick Start

### View the API Spec
- Open `openapi.yaml` in any OpenAPI viewer
- Use [Swagger Editor](https://editor.swagger.io) online
- Use VS Code with the OpenAPI (Swagger) extension

### Generate Client Code
```bash
# TypeScript client
npx @openapitools/openapi-generator-cli generate \
  -i openapi.yaml \
  -g typescript-fetch \
  -o ./generated/ts-client

# Python client
openapi-generator generate \
  -i openapi.yaml \
  -g python \
  -o ./generated/python-client
```

---

## API Overview

### Inbound API (PSP → NewPOPSys)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/orders/{orderId}/acknowledge` | POST | Acknowledge order receipt |
| `/orders/{orderId}/status` | PATCH | Update order status |
| `/orders/{orderId}/shipments` | POST | Create shipment |
| `/shipments/{shipmentId}/delivered` | POST | Confirm delivery |
| `/shipments/{shipmentId}/status` | PATCH | Update tracking status |

### Outbound Webhooks (NewPOPSys → PSP)

| Event | Trigger |
|-------|---------|
| `campaign.published` | Campaign goes live with store assignments |
| `order.generated` | New order created for a store |
| `issue.created` | Store reports missing/damaged items |
| `issue.approved` | Issue approved, may trigger reorder |
| `submission.receipt_verified` | Store confirms kit receipt |
| `submission.install_completed` | Store completes installation |
| `photo.rejected` | Photo rejected, retake needed |

---

## Authentication

All API requests require an API key in the `X-API-Key` header:

```bash
curl -X POST https://api.newpopsys.com/v1/orders/abc-123/acknowledge \
  -H "X-API-Key: vg_live_xxxxxxxxxxxx" \
  -H "Content-Type: application/json" \
  -H "Idempotency-Key: ack-abc-123-001" \
  -d '{"pspOrderRef": "MIS-2024-123456"}'
```

---

## Webhook Security

Webhooks are signed with HMAC-SHA256. Verify using:

1. Extract `X-VG-Signature` and `X-VG-Timestamp` headers
2. Compute: `HMAC-SHA256(secret, timestamp + "." + body)`
3. Compare signatures (constant-time)
4. Verify timestamp within 5 minutes

See `openapi.yaml` x-webhook-security section for code examples.

---

## Files

| File | Description |
|------|-------------|
| `openapi.yaml` | Full OpenAPI 3.1 specification |
| `README.md` | This file |

---

## References

- [SUPP-006](../SOW/02_SUPPs/Shared_Foundations/SUPP-006%20-%20Shared%20Foundations%20-%20Webhooks%20and%20Inbound%20API%20Event%20Contract%20-%20v0.5.md) - Webhooks & Inbound API Event Contract
- [SUPP-035](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-035%20-%20Platform%20Ops%20-%20Agent%20Harness%20-%20Field%20Level%20Data%20Model%20Tables%20Fields%20Enums%20-%20v1.0.md) - Field-Level Data Model
