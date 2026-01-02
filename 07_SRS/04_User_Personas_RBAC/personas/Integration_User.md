# Integration User Persona Specification

**Document ID:** SRS-PERSONA-SYS-INT
**Version:** 1.0
**Date:** 2026-01-01
**System:** NewPOPSys v1.38
**Classification:** System Level

---

## 1. Persona Overview

### 1.1 Role Definition

The Integration User is a system-level service account persona designed for automated machine-to-machine communication, enabling external systems to interact with NewPOPSys via APIs and webhooks.

### 1.2 Primary Responsibility

Inbound API writes, webhook consumption, export triggers, and MIS (Management Information System) integration.

### 1.3 Permission Level

**API & Webhook Service Account** - Programmatic access for system integration operations without interactive UI access.

---

## 2. Jobs to be Done (JTBD)

| Job ID | Job Statement | Priority |
|--------|---------------|----------|
| JTBD-INT-01 | Receive and process inbound data from external MIS systems | High |
| JTBD-INT-02 | Consume webhook events for real-time system synchronization | High |
| JTBD-INT-03 | Trigger and retrieve bulk data exports | Medium |
| JTBD-INT-04 | Write order and shipment updates from fulfillment systems | High |
| JTBD-INT-05 | Synchronize store and campaign data with external platforms | Medium |
| JTBD-INT-06 | Provide audit trail for all automated operations | High |

---

## 3. Primary Workflows

### 3.1 Inbound Data Synchronization Workflow

1. External system authenticates via API credentials (service account token)
2. System validates request payload against schema
3. Data written to appropriate NewPOPSys entities
4. Validation and business rule checks applied
5. Success/failure response returned with transaction ID
6. Operation logged to audit trail

### 3.2 Webhook Consumption Workflow

1. NewPOPSys event triggers webhook dispatch
2. External system endpoint receives webhook payload
3. Integration User credentials validate origin
4. External system processes event data
5. Acknowledgment returned to NewPOPSys
6. Retry logic applied for failed deliveries

### 3.3 Export Trigger Workflow

1. Integration User initiates export request via API
2. System validates export scope and permissions
3. Export job queued for processing
4. Completion webhook dispatched when ready
5. Export package retrieved via secure download URL
6. Export logged with access audit

### 3.4 Order/Shipment Update Workflow

1. Fulfillment system authenticates as Integration User
2. Order status update or shipment creation submitted
3. System validates against existing order records
4. Status progression rules enforced
5. Affected records updated with timestamps
6. Downstream notifications triggered (stores, brands)

---

## 4. Key Screens/APIs Accessed

### 4.1 Screens

The Integration User persona does not access interactive UI screens. All operations are conducted via programmatic API interfaces.

| Screen | Purpose | Access Level |
|--------|---------|--------------|
| N/A | Service account - no UI access | None |

### 4.2 API Endpoints

| Endpoint Category | Operations | Access |
|-------------------|------------|--------|
| `/api/v1/orders` | GET, POST, PUT | Full |
| `/api/v1/shipments` | GET, POST, PUT | Full |
| `/api/v1/tracking` | POST, PUT | Full |
| `/api/v1/stores` | GET | Read |
| `/api/v1/campaigns` | GET | Read |
| `/api/v1/exports` | POST, GET | Full |
| `/api/v1/webhooks` | GET, POST (registration) | Full |
| `/api/v1/status` | PUT | Update |
| `/api/v1/batches` | GET, POST, PUT | Full |

### 4.3 Webhook Events

| Event Category | Direction | Description |
|----------------|-----------|-------------|
| `order.created` | Outbound | New order generated |
| `order.status_changed` | Outbound | Order status transition |
| `shipment.created` | Outbound | Shipment record created |
| `shipment.tracking_updated` | Outbound | Tracking information added |
| `campaign.published` | Outbound | Campaign activated |
| `export.completed` | Outbound | Export package ready |
| `store.data_sync` | Inbound | Store data from external system |
| `fulfillment.update` | Inbound | Status from fulfillment system |

---

## 5. Permission Scope

### 5.1 Permission Matrix

| Permission | Granted | Notes |
|------------|---------|-------|
| API authentication | Yes | Service account tokens |
| Inbound data writes | Yes | Validated payloads only |
| Webhook registration | Yes | Own endpoints only |
| Export initiation | Yes | Scoped by tenant |
| Order status updates | Yes | Valid transitions only |
| Shipment creation | Yes | Linked to valid orders |
| Interactive UI access | No | API only |
| User management | No | System operations only |
| Configuration changes | No | Data operations only |
| Impersonation | No | Own identity only |

### 5.2 Data Scope

- **Tenant Scope:** Configured per service account
- **Operation Scope:** API and webhook operations only
- **Audit Scope:** All operations logged with service account identity
- **Rate Limiting:** Subject to API rate limits per account

### 5.3 Security Requirements

| Requirement | Specification |
|-------------|---------------|
| Authentication | Bearer token (OAuth 2.0 client credentials) |
| Token Expiry | Configurable, default 1 hour |
| IP Allowlisting | Optional per service account |
| Request Signing | HMAC-SHA256 for webhook payloads |
| TLS | Required (TLS 1.2+) |
| Audit Logging | All operations with timestamp, IP, payload hash |

---

## 6. Success Metrics

| Metric ID | Metric | Target | Measurement |
|-----------|--------|--------|-------------|
| INT-M01 | API availability | >= 99.9% | Uptime percentage |
| INT-M02 | API response time (p95) | < 500ms | 95th percentile latency |
| INT-M03 | Webhook delivery rate | >= 99.5% | Successful / Attempted |
| INT-M04 | Data validation pass rate | >= 99% | Valid payloads / Total |
| INT-M05 | Export completion rate | 100% | Completed / Initiated |
| INT-M06 | Authentication failure rate | < 0.1% | Failed auth / Total requests |
| INT-M07 | Rate limit compliance | 100% | Requests within limits |

---

## 7. Integration Patterns

### 7.1 Supported Integration Types

| Pattern | Description | Use Case |
|---------|-------------|----------|
| REST API | Synchronous request/response | Real-time data operations |
| Webhooks | Event-driven push notifications | Status change notifications |
| Batch Export | Scheduled bulk data extraction | Reporting, analytics |
| Batch Import | Bulk data ingestion | Store/campaign sync |

### 7.2 Error Handling

| Scenario | Behavior |
|----------|----------|
| Invalid payload | 400 Bad Request with validation errors |
| Authentication failure | 401 Unauthorized |
| Rate limit exceeded | 429 Too Many Requests with Retry-After |
| Server error | 500 with correlation ID for support |
| Webhook delivery failure | Exponential backoff retry (max 5 attempts) |

---

## 8. References

- SUPP-001: Shared Foundations - Persona Workflows JTBD Screens
- SRS 4.1: Persona Matrix
- SRS 4.2: Permission Matrix
- API Specification Documentation

---

**Document Control**

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-01-01 | System | Initial persona specification |
