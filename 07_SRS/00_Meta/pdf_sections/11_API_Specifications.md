

---

# 11.1 API Overview

## Document Information
| Field | Value |
|-------|-------|
| Document ID | SRS-11.1 |
| Version | 1.0 |
| Last Updated | 2025-01-13 |
| Status | Draft |
| Parent Document | SRS-11 API Specifications |

---

## 1. Introduction

### 1.1 Purpose
This document provides a comprehensive overview of the NewPOPSys API architecture, including authentication mechanisms, versioning strategies, rate limiting policies, and error handling conventions. It serves as the foundational reference for all API consumers and integrators.

### 1.2 Scope
The NewPOPSys API enables:
- **Inbound Operations**: PSP systems acknowledging orders, updating statuses, and creating shipments
- **Outbound Webhooks**: Event-driven notifications to integrated systems
- **Internal Services**: Survey management, store layouts, photo rules, and health monitoring

### 1.3 API Version
| Attribute | Value |
|-----------|-------|
| Current Version | 1.0.0 |
| OpenAPI Specification | 3.1.0 |
| Base Path | `/api/v1` |

---

## 2. Server Environments

### 2.1 Environment Configuration

| Environment | Base URL | Purpose |
|-------------|----------|---------|
| Production | `https://api.newpopsys.com/v1` | Live production traffic |
| Staging | `https://staging-api.newpopsys.com/v1` | Pre-production testing |
| Development | `http://localhost:3000/v1` | Local development |

### 2.2 Environment Identification
API keys are prefixed to identify their environment:

| Prefix | Environment | Example |
|--------|-------------|---------|
| `vg_live_` | Production | `vg_live_abc123def456` |
| `vg_test_` | Staging/Development | `vg_test_xyz789ghi012` |

---

## 3. Authentication

### 3.1 API Key Authentication
NewPOPSys uses API Key authentication for all API requests.

#### 3.1.1 Request Header Format
```http
X-API-Key: vg_live_your_api_key_here
```

#### 3.1.2 Authentication Flow
```
┌─────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Client    │────▶│  API Gateway     │────▶│  Auth Service   │
│             │     │                  │     │                 │
│             │◀────│  X-API-Key       │◀────│  Validate Key   │
│             │     │  Header Check    │     │  & Permissions  │
└─────────────┘     └──────────────────┘     └─────────────────┘
```

### 3.2 API Key Security Requirements

| Requirement | Description |
|-------------|-------------|
| Transmission | HTTPS/TLS 1.3 required |
| Storage | Encrypted at rest, never in logs |
| Rotation | Minimum every 90 days |
| Revocation | Immediate effect upon deletion |
| Scope | Tenant-specific permissions |

### 3.3 Authentication Errors

| HTTP Code | Error | Description |
|-----------|-------|-------------|
| 401 | `UNAUTHORIZED` | Missing or invalid API key |
| 403 | `FORBIDDEN` | Valid key but insufficient permissions |

**Example Error Response:**
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or missing API key",
    "timestamp": "2025-01-13T10:30:00Z",
    "requestId": "req_abc123def456"
  }
}
```

---

## 4. API Versioning

### 4.1 Versioning Strategy
NewPOPSys employs **URL Path Versioning** for explicit version control.

| Strategy | Format | Example |
|----------|--------|---------|
| URL Path | `/v{major}` | `/v1/orders` |

### 4.2 Version Lifecycle

| Phase | Duration | Description |
|-------|----------|-------------|
| Current | Active | Full support and new features |
| Deprecated | 6 months | Security updates only, migration recommended |
| Sunset | 3 months | Read-only, then decommissioned |

### 4.3 Breaking vs Non-Breaking Changes

**Non-Breaking Changes (No Version Bump):**
- Adding new optional request parameters
- Adding new response fields
- Adding new endpoints
- Adding new webhook event types

**Breaking Changes (Major Version Bump):**
- Removing or renaming fields
- Changing field types
- Modifying required parameters
- Changing endpoint paths
- Altering authentication mechanisms

### 4.4 Deprecation Headers
When endpoints are deprecated, responses include:

```http
Deprecation: true
Sunset: Sat, 01 Jul 2025 00:00:00 GMT
Link: <https://docs.newpopsys.com/migration>; rel="deprecation"
```

---

## 5. Rate Limiting

### 5.1 Rate Limit Tiers

| Category | Limit | Window | Scope |
|----------|-------|--------|-------|
| Authentication | 20 requests | 1 minute | Per IP |
| General API | 300 requests | 1 minute | Per API Key |
| File Uploads | 60 requests | 1 minute | Per API Key |
| Data Exports | 10 requests | 1 minute | Per Tenant |
| Webhooks | 1000 events | 1 minute | Per Endpoint |

### 5.2 Rate Limit Response Headers

| Header | Description | Example |
|--------|-------------|---------|
| `X-RateLimit-Limit` | Maximum requests allowed | `300` |
| `X-RateLimit-Remaining` | Requests remaining in window | `247` |
| `X-RateLimit-Reset` | Unix timestamp when limit resets | `1705142400` |

**Example Response Headers:**
```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 300
X-RateLimit-Remaining: 247
X-RateLimit-Reset: 1705142400
Content-Type: application/json
```

### 5.3 Rate Limit Exceeded Response
When rate limits are exceeded, the API returns HTTP 429:

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please retry after 45 seconds.",
    "retryAfter": 45,
    "timestamp": "2025-01-13T10:30:00Z",
    "requestId": "req_abc123def456"
  }
}
```

**Response Headers:**
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 45
X-RateLimit-Limit: 300
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1705142445
```

### 5.4 Rate Limit Best Practices

| Practice | Description |
|----------|-------------|
| Exponential Backoff | Double wait time on each 429 response |
| Request Batching | Combine multiple operations where possible |
| Caching | Cache responses to reduce API calls |
| Queue Management | Implement client-side request queuing |

---

## 6. Request Standards

### 6.1 Content Types

| Operation | Content-Type | Accept |
|-----------|--------------|--------|
| JSON Requests | `application/json` | `application/json` |
| File Uploads | `multipart/form-data` | `application/json` |
| Binary Downloads | N/A | `application/octet-stream` |

### 6.2 Request Headers

| Header | Required | Description |
|--------|----------|-------------|
| `X-API-Key` | Yes | API authentication key |
| `Content-Type` | Yes* | Request body format (*for POST/PUT/PATCH) |
| `Accept` | No | Preferred response format |
| `Idempotency-Key` | Recommended | Prevents duplicate operations |
| `X-Request-ID` | No | Client-provided correlation ID |

### 6.3 Idempotency

For POST, PUT, and PATCH requests, use the `Idempotency-Key` header to ensure exactly-once semantics:

```http
POST /v1/orders/ORD-001/shipments HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Idempotency-Key: idem_7f8e9d0c-1a2b-3c4d-5e6f-7a8b9c0d1e2f
Content-Type: application/json

{
  "carrier": "UPS",
  "trackingNumber": "1Z999AA10123456784"
}
```

**Idempotency Behavior:**

| Scenario | Response |
|----------|----------|
| First request | Normal processing, result cached for 24 hours |
| Duplicate key (same body) | Return cached response (HTTP 200) |
| Duplicate key (different body) | Return HTTP 409 Conflict |

---

## 7. Response Standards

### 7.1 HTTP Status Codes

#### Success Codes

| Code | Status | Usage |
|------|--------|-------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST creating resource |
| 202 | Accepted | Async operation queued |
| 204 | No Content | Successful DELETE |

#### Client Error Codes

| Code | Status | Usage |
|------|--------|-------|
| 400 | Bad Request | Invalid request body or parameters |
| 401 | Unauthorized | Missing or invalid API key |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Resource state conflict |
| 422 | Unprocessable Entity | Validation failed |
| 429 | Too Many Requests | Rate limit exceeded |

#### Server Error Codes

| Code | Status | Usage |
|------|--------|-------|
| 500 | Internal Server Error | Unexpected server error |
| 502 | Bad Gateway | Upstream service failure |
| 503 | Service Unavailable | Temporary maintenance |
| 504 | Gateway Timeout | Upstream service timeout |

### 7.2 Standard Response Format

#### Success Response
```json
{
  "data": {
    "id": "ORD-2025-001234",
    "status": "acknowledged",
    "updatedAt": "2025-01-13T10:30:00Z"
  },
  "meta": {
    "requestId": "req_abc123def456",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

#### Collection Response (with Pagination)
```json
{
  "data": [
    { "id": "ORD-001", "status": "pending" },
    { "id": "ORD-002", "status": "shipped" }
  ],
  "meta": {
    "requestId": "req_abc123def456",
    "timestamp": "2025-01-13T10:30:00Z"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 156,
    "totalPages": 8,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
```

### 7.3 Error Response Format

All error responses follow a consistent structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "trackingNumber",
        "message": "Tracking number is required",
        "code": "REQUIRED_FIELD"
      },
      {
        "field": "carrier",
        "message": "Invalid carrier code",
        "code": "INVALID_VALUE",
        "allowedValues": ["UPS", "FEDEX", "USPS", "DHL"]
      }
    ],
    "timestamp": "2025-01-13T10:30:00Z",
    "requestId": "req_abc123def456",
    "documentationUrl": "https://docs.newpopsys.com/errors/VALIDATION_ERROR"
  }
}
```

### 7.4 Error Code Reference

| Error Code | HTTP Status | Description |
|------------|-------------|-------------|
| `UNAUTHORIZED` | 401 | Invalid or missing API key |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `NOT_FOUND` | 404 | Resource not found |
| `VALIDATION_ERROR` | 400/422 | Request validation failed |
| `CONFLICT` | 409 | Resource state conflict |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |
| `INTERNAL_ERROR` | 500 | Unexpected server error |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |
| `IDEMPOTENCY_CONFLICT` | 409 | Idempotency key reused with different payload |

---

## 8. Pagination

### 8.1 Pagination Parameters

| Parameter | Type | Default | Max | Description |
|-----------|------|---------|-----|-------------|
| `page` | integer | 1 | - | Page number (1-indexed) |
| `pageSize` | integer | 20 | 100 | Items per page |
| `sort` | string | varies | - | Sort field and direction |

### 8.2 Example Request
```http
GET /v1/orders?page=2&pageSize=50&sort=-createdAt HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

### 8.3 Sort Direction
| Prefix | Direction | Example |
|--------|-----------|---------|
| (none) | Ascending | `sort=createdAt` |
| `-` | Descending | `sort=-createdAt` |

---

## 9. Health Check Endpoints

### 9.1 Endpoint Summary

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Basic health check |
| `/health/ready` | GET | Readiness probe (all dependencies) |
| `/health/live` | GET | Liveness probe (service running) |

### 9.2 Health Response

```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2025-01-13T10:30:00Z",
  "checks": {
    "database": "healthy",
    "redis": "healthy",
    "queue": "healthy"
  }
}
```

### 9.3 Health Status Values

| Status | Description |
|--------|-------------|
| `healthy` | All systems operational |
| `degraded` | Some non-critical services impaired |
| `unhealthy` | Critical services unavailable |

---

## 10. Security Considerations

### 10.1 Transport Security

| Requirement | Specification |
|-------------|---------------|
| Protocol | HTTPS only (HTTP redirected) |
| TLS Version | 1.2 minimum, 1.3 preferred |
| Certificate | Valid, non-expired, trusted CA |
| HSTS | Enabled with 1-year max-age |

### 10.2 Request Validation

| Check | Description |
|-------|-------------|
| Input Sanitization | All inputs validated and sanitized |
| Size Limits | Request body max 10MB |
| Content-Type | Strict matching required |
| SQL Injection | Parameterized queries only |
| XSS Prevention | Output encoding applied |

### 10.3 Audit Logging

All API requests are logged with:
- Request timestamp
- API key (masked)
- Request ID
- Endpoint and method
- Response status code
- Response time
- Client IP (anonymized for GDPR)

---

## 11. SDK and Client Libraries

### 11.1 Official SDKs

| Language | Package | Repository |
|----------|---------|------------|
| JavaScript/TypeScript | `@newpopsys/sdk` | GitHub |
| Python | `newpopsys-python` | PyPI |
| C# | `NewPOPSys.SDK` | NuGet |

### 11.2 API Client Generation
OpenAPI specification available for generating custom clients:
```
https://api.newpopsys.com/v1/openapi.json
https://api.newpopsys.com/v1/openapi.yaml
```

---

## 12. Related Documents

| Document ID | Title | Description |
|-------------|-------|-------------|
| SRS-11.2 | Internal APIs | Detailed endpoint specifications |
| SRS-11.3 | External Integrations | Third-party integration details |
| SRS-11.4 | Webhooks | Event-driven notification system |
| SRS-3.4 | Integration Architecture | Technical integration patterns |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-01-13 | System | Initial version |


---

# 11.2 Internal APIs

## Document Information
| Field | Value |
|-------|-------|
| Document ID | SRS-11.2 |
| Version | 1.0 |
| Last Updated | 2025-01-13 |
| Status | Draft |
| Parent Document | SRS-11 API Specifications |

---

## 1. Introduction

### 1.1 Purpose
This document specifies all internal RESTful API endpoints for the NewPOPSys platform. These APIs enable PSP (Print Service Provider) systems and internal services to interact with the NewPOPSys platform for order management, shipment tracking, and related operations.

### 1.2 Base URL
All endpoints are relative to the base URL:
- **Production**: `https://api.newpopsys.com/v1`
- **Staging**: `https://staging-api.newpopsys.com/v1`
- **Development**: `http://localhost:3000/v1`

### 1.3 Authentication
All endpoints require API key authentication via the `X-API-Key` header unless otherwise specified.

---

## 2. Orders API

### 2.1 Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/orders/{orderId}/acknowledge` | Acknowledge order receipt |
| PUT | `/orders/{orderId}/status` | Update order status |
| POST | `/orders/{orderId}/shipments` | Create shipment for order |

---

### 2.2 Acknowledge Order

Acknowledges receipt of an order from NewPOPSys, confirming the PSP has received and will process the order.

#### Request

```http
POST /v1/orders/{orderId}/acknowledge HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "acknowledgedAt": "2025-01-13T10:30:00Z",
  "estimatedShipDate": "2025-01-15",
  "notes": "Order received and queued for production"
}
```

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `orderId` | string | Yes | Unique order identifier (e.g., `ORD-2025-001234`) |

#### Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `acknowledgedAt` | string (ISO 8601) | Yes | Timestamp of acknowledgment |
| `estimatedShipDate` | string (date) | No | Expected ship date (YYYY-MM-DD) |
| `notes` | string | No | Optional notes (max 500 chars) |

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "orderId": "ORD-2025-001234",
    "status": "acknowledged",
    "acknowledgedAt": "2025-01-13T10:30:00Z",
    "estimatedShipDate": "2025-01-15"
  },
  "meta": {
    "requestId": "req_abc123def456",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

**Error Responses**

| Code | Error | Description |
|------|-------|-------------|
| 400 | `VALIDATION_ERROR` | Invalid request body |
| 401 | `UNAUTHORIZED` | Invalid API key |
| 404 | `ORDER_NOT_FOUND` | Order does not exist |
| 409 | `ALREADY_ACKNOWLEDGED` | Order already acknowledged |

---

### 2.3 Update Order Status

Updates the current status of an order in the fulfillment workflow.

#### Request

```http
PUT /v1/orders/{orderId}/status HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "status": "in_production",
  "statusDetails": "Printing in progress - 50% complete",
  "updatedAt": "2025-01-13T14:30:00Z"
}
```

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `orderId` | string | Yes | Unique order identifier |

#### Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status` | string | Yes | New order status |
| `statusDetails` | string | No | Additional status information |
| `updatedAt` | string (ISO 8601) | Yes | Timestamp of status change |

#### Valid Status Values

| Status | Description |
|--------|-------------|
| `acknowledged` | Order received by PSP |
| `in_production` | Order being manufactured |
| `quality_check` | Quality inspection in progress |
| `ready_to_ship` | Production complete, awaiting shipment |
| `shipped` | Order shipped (use shipment endpoint) |
| `on_hold` | Order temporarily paused |
| `cancelled` | Order cancelled |

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "orderId": "ORD-2025-001234",
    "previousStatus": "acknowledged",
    "currentStatus": "in_production",
    "statusDetails": "Printing in progress - 50% complete",
    "updatedAt": "2025-01-13T14:30:00Z"
  },
  "meta": {
    "requestId": "req_def456ghi789",
    "timestamp": "2025-01-13T14:30:00Z"
  }
}
```

**Error Responses**

| Code | Error | Description |
|------|-------|-------------|
| 400 | `INVALID_STATUS` | Invalid status value |
| 400 | `INVALID_TRANSITION` | Status transition not allowed |
| 404 | `ORDER_NOT_FOUND` | Order does not exist |

---

## 3. Shipments API

### 3.1 Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/orders/{orderId}/shipments` | Create new shipment |
| PUT | `/shipments/{shipmentId}/delivered` | Confirm delivery |

---

### 3.2 Create Shipment

Creates a shipment record for an order with tracking information.

#### Request

```http
POST /v1/orders/{orderId}/shipments HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json
Idempotency-Key: idem_7f8e9d0c-1a2b-3c4d-5e6f-7a8b9c0d1e2f

{
  "carrier": "UPS",
  "trackingNumber": "1Z999AA10123456784",
  "serviceType": "GROUND",
  "shippedAt": "2025-01-15T09:00:00Z",
  "estimatedDelivery": "2025-01-18",
  "packages": [
    {
      "weight": 2.5,
      "weightUnit": "lb",
      "dimensions": {
        "length": 12,
        "width": 10,
        "height": 4,
        "unit": "in"
      },
      "contents": "POP Display Kit - Store #1234"
    }
  ],
  "shipFrom": {
    "name": "PSP Fulfillment Center",
    "address1": "100 Industrial Way",
    "city": "Chicago",
    "state": "IL",
    "postalCode": "60601",
    "country": "US"
  },
  "shipTo": {
    "name": "Store Manager",
    "company": "Retail Store #1234",
    "address1": "500 Main Street",
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US"
  }
}
```

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `orderId` | string | Yes | Order identifier for shipment |

#### Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `carrier` | string | Yes | Shipping carrier code |
| `trackingNumber` | string | Yes | Carrier tracking number |
| `serviceType` | string | No | Carrier service level |
| `shippedAt` | string (ISO 8601) | Yes | Shipment timestamp |
| `estimatedDelivery` | string (date) | No | Expected delivery date |
| `packages` | array | No | Package details |
| `shipFrom` | object | No | Origin address |
| `shipTo` | object | Yes | Destination address |

#### Valid Carrier Codes

| Code | Carrier Name |
|------|--------------|
| `UPS` | United Parcel Service |
| `FEDEX` | FedEx |
| `USPS` | US Postal Service |
| `DHL` | DHL Express |

#### Response

**Success (201 Created)**
```json
{
  "data": {
    "shipmentId": "SHP-2025-001234",
    "orderId": "ORD-2025-001234",
    "carrier": "UPS",
    "trackingNumber": "1Z999AA10123456784",
    "trackingUrl": "https://www.ups.com/track?tracknum=1Z999AA10123456784",
    "status": "in_transit",
    "shippedAt": "2025-01-15T09:00:00Z",
    "estimatedDelivery": "2025-01-18"
  },
  "meta": {
    "requestId": "req_ghi789jkl012",
    "timestamp": "2025-01-15T09:00:00Z"
  }
}
```

**Error Responses**

| Code | Error | Description |
|------|-------|-------------|
| 400 | `INVALID_CARRIER` | Unsupported carrier code |
| 400 | `INVALID_TRACKING` | Invalid tracking number format |
| 404 | `ORDER_NOT_FOUND` | Order does not exist |
| 409 | `DUPLICATE_TRACKING` | Tracking number already used |

---

### 3.3 Confirm Delivery

Confirms that a shipment has been delivered to the destination.

#### Request

```http
PUT /v1/shipments/{shipmentId}/delivered HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "deliveredAt": "2025-01-18T14:30:00Z",
  "signedBy": "J. Smith",
  "deliveryNotes": "Left at front desk",
  "proofOfDelivery": {
    "type": "signature",
    "imageUrl": "https://storage.example.com/pod/SHP-2025-001234.png"
  }
}
```

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `shipmentId` | string | Yes | Shipment identifier |

#### Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `deliveredAt` | string (ISO 8601) | Yes | Delivery timestamp |
| `signedBy` | string | No | Name of person who signed |
| `deliveryNotes` | string | No | Delivery notes |
| `proofOfDelivery` | object | No | Proof of delivery details |

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "shipmentId": "SHP-2025-001234",
    "orderId": "ORD-2025-001234",
    "status": "delivered",
    "deliveredAt": "2025-01-18T14:30:00Z",
    "signedBy": "J. Smith"
  },
  "meta": {
    "requestId": "req_mno345pqr678",
    "timestamp": "2025-01-18T14:30:00Z"
  }
}
```

---

## 4. Surveys API

### 4.1 Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/surveys/templates` | List survey templates |
| GET | `/surveys/templates/{templateId}` | Get template details |
| POST | `/surveys/responses` | Submit survey response |
| GET | `/surveys/responses/{responseId}` | Get response details |

---

### 4.2 List Survey Templates

Retrieves available survey templates for a tenant.

#### Request

```http
GET /v1/surveys/templates?page=1&pageSize=20 HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Query Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | 1 | Page number |
| `pageSize` | integer | 20 | Items per page (max 100) |
| `status` | string | - | Filter by status (active, archived) |
| `type` | string | - | Filter by survey type |

#### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "templateId": "TMPL-001",
      "name": "Store Installation Survey",
      "description": "Post-installation verification survey",
      "version": "2.0",
      "status": "active",
      "questionCount": 15,
      "estimatedMinutes": 10,
      "createdAt": "2024-06-01T00:00:00Z",
      "updatedAt": "2024-12-15T00:00:00Z"
    },
    {
      "templateId": "TMPL-002",
      "name": "Pre-Visit Store Assessment",
      "description": "Initial store layout assessment",
      "version": "1.5",
      "status": "active",
      "questionCount": 25,
      "estimatedMinutes": 20,
      "createdAt": "2024-03-15T00:00:00Z",
      "updatedAt": "2024-11-01T00:00:00Z"
    }
  ],
  "meta": {
    "requestId": "req_stu901vwx234",
    "timestamp": "2025-01-13T10:30:00Z"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 8,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPreviousPage": false
  }
}
```

---

### 4.3 Get Survey Template

Retrieves detailed survey template including all questions.

#### Request

```http
GET /v1/surveys/templates/TMPL-001 HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "templateId": "TMPL-001",
    "name": "Store Installation Survey",
    "description": "Post-installation verification survey",
    "version": "2.0",
    "status": "active",
    "sections": [
      {
        "sectionId": "SEC-001",
        "title": "Display Installation",
        "order": 1,
        "questions": [
          {
            "questionId": "Q-001",
            "type": "multiple_choice",
            "text": "Was the display installed in the correct location?",
            "required": true,
            "options": ["Yes", "No", "Partially"]
          },
          {
            "questionId": "Q-002",
            "type": "photo",
            "text": "Take a photo of the installed display",
            "required": true,
            "validation": {
              "minPhotos": 1,
              "maxPhotos": 5,
              "minResolution": "1920x1080"
            }
          },
          {
            "questionId": "Q-003",
            "type": "text",
            "text": "Describe any installation issues",
            "required": false,
            "validation": {
              "maxLength": 500
            }
          }
        ]
      }
    ],
    "createdAt": "2024-06-01T00:00:00Z",
    "updatedAt": "2024-12-15T00:00:00Z"
  },
  "meta": {
    "requestId": "req_yza567bcd890",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

### 4.4 Submit Survey Response

Submits a completed survey response.

#### Request

```http
POST /v1/surveys/responses HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json
Idempotency-Key: idem_survey_response_12345

{
  "templateId": "TMPL-001",
  "storeId": "STORE-1234",
  "campaignId": "CAMP-2025-Q1",
  "submittedBy": {
    "userId": "USR-567",
    "name": "John Installer",
    "email": "john@installer.com"
  },
  "answers": [
    {
      "questionId": "Q-001",
      "value": "Yes"
    },
    {
      "questionId": "Q-002",
      "value": {
        "photos": [
          {
            "url": "https://storage.example.com/photos/photo1.jpg",
            "takenAt": "2025-01-13T10:00:00Z",
            "location": {
              "latitude": 43.0389,
              "longitude": -87.9065
            }
          }
        ]
      }
    },
    {
      "questionId": "Q-003",
      "value": "No issues encountered"
    }
  ],
  "completedAt": "2025-01-13T10:30:00Z",
  "deviceInfo": {
    "type": "mobile",
    "os": "iOS 17.2",
    "appVersion": "2.5.0"
  }
}
```

#### Response

**Success (201 Created)**
```json
{
  "data": {
    "responseId": "RESP-2025-001234",
    "templateId": "TMPL-001",
    "storeId": "STORE-1234",
    "campaignId": "CAMP-2025-Q1",
    "status": "submitted",
    "completedAt": "2025-01-13T10:30:00Z",
    "validationStatus": "pending"
  },
  "meta": {
    "requestId": "req_efg123hij456",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

## 5. Store Layouts API

### 5.1 Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/stores/{storeId}/layouts` | Get store layout |
| PUT | `/stores/{storeId}/layouts` | Update store layout |
| GET | `/stores/{storeId}/layouts/history` | Get layout change history |

---

### 5.2 Get Store Layout

Retrieves the current layout configuration for a store.

#### Request

```http
GET /v1/stores/STORE-1234/layouts HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "storeId": "STORE-1234",
    "storeName": "Downtown Milwaukee #1234",
    "layoutVersion": "3.2",
    "lastUpdated": "2025-01-10T08:00:00Z",
    "dimensions": {
      "width": 50,
      "length": 80,
      "unit": "feet"
    },
    "zones": [
      {
        "zoneId": "ZONE-A",
        "name": "Entrance Display Area",
        "type": "high_traffic",
        "position": {
          "x": 0,
          "y": 0,
          "width": 15,
          "length": 20
        },
        "fixtures": [
          {
            "fixtureId": "FIX-001",
            "type": "floor_display",
            "name": "Main Promotional Display",
            "dimensions": {
              "width": 4,
              "depth": 2,
              "height": 6,
              "unit": "feet"
            },
            "position": {
              "x": 5,
              "y": 8
            }
          }
        ]
      },
      {
        "zoneId": "ZONE-B",
        "name": "Checkout Area",
        "type": "point_of_sale",
        "position": {
          "x": 35,
          "y": 70,
          "width": 15,
          "length": 10
        },
        "fixtures": []
      }
    ],
    "floorPlanUrl": "https://storage.example.com/layouts/STORE-1234-v3.2.pdf"
  },
  "meta": {
    "requestId": "req_klm789nop012",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

### 5.3 Update Store Layout

Updates the store layout configuration.

#### Request

```http
PUT /v1/stores/STORE-1234/layouts HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "zones": [
    {
      "zoneId": "ZONE-A",
      "name": "Entrance Display Area",
      "type": "high_traffic",
      "position": {
        "x": 0,
        "y": 0,
        "width": 15,
        "length": 20
      },
      "fixtures": [
        {
          "fixtureId": "FIX-001",
          "type": "floor_display",
          "name": "Main Promotional Display",
          "position": {
            "x": 5,
            "y": 8
          }
        },
        {
          "fixtureId": "FIX-002",
          "type": "endcap",
          "name": "New Seasonal Endcap",
          "position": {
            "x": 12,
            "y": 5
          }
        }
      ]
    }
  ],
  "changeReason": "Added new seasonal endcap display",
  "effectiveDate": "2025-01-15"
}
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "storeId": "STORE-1234",
    "layoutVersion": "3.3",
    "previousVersion": "3.2",
    "lastUpdated": "2025-01-13T10:30:00Z",
    "effectiveDate": "2025-01-15",
    "changeReason": "Added new seasonal endcap display"
  },
  "meta": {
    "requestId": "req_qrs345tuv678",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

## 6. Photo Rules API

### 6.1 Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/photo-rules` | List photo validation rules |
| GET | `/photo-rules/{ruleId}` | Get specific rule |
| POST | `/photos/validate` | Validate photo against rules |

---

### 6.2 List Photo Rules

Retrieves all photo validation rules for the tenant.

#### Request

```http
GET /v1/photo-rules?category=installation HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Query Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `category` | string | Filter by category (installation, verification, compliance) |
| `status` | string | Filter by status (active, inactive) |

#### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "ruleId": "RULE-001",
      "name": "Display Installation Photo",
      "category": "installation",
      "status": "active",
      "requirements": {
        "minResolution": {
          "width": 1920,
          "height": 1080
        },
        "maxFileSize": "10MB",
        "allowedFormats": ["jpeg", "png", "heic"],
        "requireGeoLocation": true,
        "requireTimestamp": true,
        "maxAge": "24h"
      },
      "aiValidation": {
        "enabled": true,
        "checks": [
          "display_visibility",
          "proper_installation",
          "branding_compliance"
        ],
        "minimumConfidence": 0.85
      }
    },
    {
      "ruleId": "RULE-002",
      "name": "Store Front Photo",
      "category": "verification",
      "status": "active",
      "requirements": {
        "minResolution": {
          "width": 1280,
          "height": 720
        },
        "maxFileSize": "5MB",
        "allowedFormats": ["jpeg", "png"],
        "requireGeoLocation": true,
        "requireTimestamp": true,
        "maxAge": "1h"
      },
      "aiValidation": {
        "enabled": true,
        "checks": [
          "store_front_visible",
          "signage_readable"
        ],
        "minimumConfidence": 0.80
      }
    }
  ],
  "meta": {
    "requestId": "req_wxy901zab234",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

### 6.3 Validate Photo

Validates a photo against specified rules.

#### Request

```http
POST /v1/photos/validate HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "photoUrl": "https://storage.example.com/uploads/photo123.jpg",
  "ruleIds": ["RULE-001"],
  "metadata": {
    "storeId": "STORE-1234",
    "campaignId": "CAMP-2025-Q1",
    "takenAt": "2025-01-13T10:00:00Z",
    "location": {
      "latitude": 43.0389,
      "longitude": -87.9065,
      "accuracy": 5
    }
  }
}
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "validationId": "VAL-2025-001234",
    "status": "passed",
    "results": [
      {
        "ruleId": "RULE-001",
        "passed": true,
        "checks": {
          "resolution": {
            "passed": true,
            "actual": {
              "width": 3024,
              "height": 4032
            },
            "required": {
              "width": 1920,
              "height": 1080
            }
          },
          "fileSize": {
            "passed": true,
            "actual": "4.2MB",
            "maximum": "10MB"
          },
          "geoLocation": {
            "passed": true,
            "distanceFromStore": "15m",
            "maximumAllowed": "100m"
          },
          "timestamp": {
            "passed": true,
            "age": "30m",
            "maximumAge": "24h"
          },
          "aiValidation": {
            "passed": true,
            "confidence": 0.92,
            "minimumRequired": 0.85,
            "detections": [
              {
                "check": "display_visibility",
                "confidence": 0.95,
                "passed": true
              },
              {
                "check": "proper_installation",
                "confidence": 0.89,
                "passed": true
              },
              {
                "check": "branding_compliance",
                "confidence": 0.91,
                "passed": true
              }
            ]
          }
        }
      }
    ]
  },
  "meta": {
    "requestId": "req_cde567fgh890",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

## 7. Webhooks Management API

### 7.1 Endpoint Summary

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/webhooks` | List webhook subscriptions |
| POST | `/webhooks` | Create webhook subscription |
| GET | `/webhooks/{webhookId}` | Get webhook details |
| PUT | `/webhooks/{webhookId}` | Update webhook |
| DELETE | `/webhooks/{webhookId}` | Delete webhook |
| GET | `/webhooks/{webhookId}/deliveries` | List delivery attempts |
| POST | `/webhooks/{webhookId}/test` | Send test event |

---

### 7.2 List Webhooks

Retrieves all webhook subscriptions for the authenticated tenant.

#### Request

```http
GET /v1/webhooks?page=1&pageSize=20 HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "webhookId": "WH-001",
      "url": "https://psp-system.example.com/webhooks/newpopsys",
      "status": "active",
      "events": [
        "order.generated",
        "campaign.published"
      ],
      "createdAt": "2024-06-01T00:00:00Z",
      "lastDeliveryAt": "2025-01-13T09:45:00Z",
      "successRate": 99.2
    }
  ],
  "meta": {
    "requestId": "req_ijk123lmn456",
    "timestamp": "2025-01-13T10:30:00Z"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 3,
    "totalPages": 1
  }
}
```

---

### 7.3 Create Webhook

Creates a new webhook subscription.

#### Request

```http
POST /v1/webhooks HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "url": "https://psp-system.example.com/webhooks/newpopsys",
  "events": [
    "order.generated",
    "campaign.published",
    "issue.created"
  ],
  "secret": "whsec_your_secret_key_here",
  "description": "Main PSP integration webhook",
  "headers": {
    "X-Custom-Header": "custom-value"
  }
}
```

#### Request Body

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `url` | string | Yes | HTTPS endpoint URL |
| `events` | array | Yes | Event types to subscribe |
| `secret` | string | Yes | HMAC signing secret (min 32 chars) |
| `description` | string | No | Webhook description |
| `headers` | object | No | Custom headers to include |

#### Response

**Success (201 Created)**
```json
{
  "data": {
    "webhookId": "WH-002",
    "url": "https://psp-system.example.com/webhooks/newpopsys",
    "status": "active",
    "events": [
      "order.generated",
      "campaign.published",
      "issue.created"
    ],
    "createdAt": "2025-01-13T10:30:00Z"
  },
  "meta": {
    "requestId": "req_opq789rst012",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

---

## 8. Health API

### 8.1 Endpoint Summary

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/health` | No | Basic health check |
| GET | `/health/ready` | No | Readiness probe |
| GET | `/health/live` | No | Liveness probe |

---

### 8.2 Health Check

Returns overall system health status.

#### Request

```http
GET /v1/health HTTP/1.1
Host: api.newpopsys.com
```

#### Response

**Success (200 OK)**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2025-01-13T10:30:00Z",
  "uptime": "45d 12h 30m",
  "checks": {
    "database": {
      "status": "healthy",
      "latency": "2ms"
    },
    "redis": {
      "status": "healthy",
      "latency": "1ms"
    },
    "queue": {
      "status": "healthy",
      "pendingJobs": 42
    },
    "storage": {
      "status": "healthy",
      "available": "85%"
    }
  }
}
```

**Degraded (200 OK)**
```json
{
  "status": "degraded",
  "version": "1.0.0",
  "timestamp": "2025-01-13T10:30:00Z",
  "checks": {
    "database": {
      "status": "healthy",
      "latency": "2ms"
    },
    "redis": {
      "status": "degraded",
      "latency": "150ms",
      "message": "High latency detected"
    },
    "queue": {
      "status": "healthy",
      "pendingJobs": 42
    }
  }
}
```

---

## 9. Common Data Types

### 9.1 Address Object

```json
{
  "name": "string",
  "company": "string",
  "address1": "string",
  "address2": "string",
  "city": "string",
  "state": "string",
  "postalCode": "string",
  "country": "string (ISO 3166-1 alpha-2)",
  "phone": "string",
  "email": "string"
}
```

### 9.2 GeoLocation Object

```json
{
  "latitude": "number (-90 to 90)",
  "longitude": "number (-180 to 180)",
  "accuracy": "number (meters)",
  "altitude": "number (meters, optional)"
}
```

### 9.3 Pagination Object

```json
{
  "page": "integer (current page)",
  "pageSize": "integer (items per page)",
  "totalItems": "integer (total count)",
  "totalPages": "integer (total pages)",
  "hasNextPage": "boolean",
  "hasPreviousPage": "boolean"
}
```

---

## 10. Related Documents

| Document ID | Title | Description |
|-------------|-------|-------------|
| SRS-11.1 | API Overview | Authentication, versioning, rate limiting |
| SRS-11.3 | External Integrations | Third-party system integrations |
| SRS-11.4 | Webhooks | Event-driven notifications |
| SRS-3.4 | Integration Architecture | Technical integration patterns |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-01-13 | System | Initial version |


---

# 11.3 External Integrations

## Document Information
| Field | Value |
|-------|-------|
| Document ID | SRS-11.3 |
| Version | 1.0 |
| Last Updated | 2025-01-13 |
| Status | Draft |
| Parent Document | SRS-11 API Specifications |

---

## 1. Introduction

### 1.1 Purpose
This document specifies the external system integrations for NewPOPSys, detailing how the platform connects with third-party services including ERP systems, CRM platforms, shipping carriers, and identity providers.

### 1.2 Integration Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        NewPOPSys Core                           │
├──────────────┬──────────────┬──────────────┬───────────────────┤
│  Orders API  │ Shipments API│  Events API  │   Identity API    │
└──────┬───────┴──────┬───────┴──────┬───────┴─────────┬─────────┘
       │              │              │                 │
       ▼              ▼              ▼                 ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌─────────────┐
│   PSP MIS    │ │   Shipping   │ │  Brand ERP   │ │     SSO     │
│   Systems    │ │   Carriers   │ │   Systems    │ │  Providers  │
└──────────────┘ └──────────────┘ └──────────────┘ └─────────────┘
```

### 1.3 Integration Partners Summary

| Partner Category | Systems | Direction |
|-----------------|---------|-----------|
| PSP MIS | W2P, EFI, Tharstern | Bidirectional |
| Shipping Carriers | UPS, FedEx, USPS, DHL | Bidirectional |
| Brand ERP | SAP, Oracle, NetSuite | Outbound Webhooks |
| Identity (SSO) | Azure AD, Okta, Auth0 | Inbound |
| Payment | Stripe, PayPal | Bidirectional |
| Storage | AWS S3, Azure Blob | Outbound |
| Notifications | SendGrid, Twilio | Outbound |

---

## 2. PSP MIS Integration

### 2.1 Overview
Print Service Provider (PSP) Management Information Systems receive orders from NewPOPSys and report back production status and shipment information.

### 2.2 Supported MIS Platforms

| Platform | Version | Protocol | Authentication |
|----------|---------|----------|----------------|
| W2P Custom | Various | REST API | API Key |
| EFI Pace | 28+ | REST/SOAP | OAuth 2.0 |
| Tharstern | 8+ | REST API | API Key |
| PrintSmith | Vision | REST API | API Key |

### 2.3 Data Flow

```
NewPOPSys                                    PSP MIS
    │                                            │
    │──────── order.generated webhook ──────────▶│
    │                                            │
    │◀─────── POST /orders/{id}/acknowledge ─────│
    │                                            │
    │◀─────── PUT /orders/{id}/status ───────────│
    │                (in_production)             │
    │                                            │
    │◀─────── PUT /orders/{id}/status ───────────│
    │                (ready_to_ship)             │
    │                                            │
    │◀─────── POST /orders/{id}/shipments ───────│
    │                                            │
    │──────── shipment.created webhook ─────────▶│
    │                                            │
```

### 2.4 Order Data Mapping

#### 2.4.1 NewPOPSys to PSP Order Fields

| NewPOPSys Field | PSP MIS Field | Description |
|-----------------|---------------|-------------|
| `orderId` | `external_order_id` | Unique order reference |
| `campaignId` | `project_code` | Campaign/project identifier |
| `items[].sku` | `product_sku` | Product SKU |
| `items[].quantity` | `quantity` | Order quantity |
| `items[].specifications` | `job_specs` | Print specifications |
| `shippingAddress` | `delivery_address` | Ship-to address |
| `priority` | `rush_flag` | Priority indicator |
| `dueDate` | `required_date` | Required delivery date |

#### 2.4.2 Sample Order Payload

```json
{
  "orderId": "ORD-2025-001234",
  "campaignId": "CAMP-2025-Q1-PROMO",
  "orderDate": "2025-01-13T10:00:00Z",
  "priority": "standard",
  "dueDate": "2025-01-20",
  "customer": {
    "customerId": "CUST-001",
    "name": "Acme Retail Brand",
    "accountNumber": "ACM-12345"
  },
  "items": [
    {
      "lineId": "LN-001",
      "sku": "POP-FLRDSP-24X36",
      "name": "Floor Display Stand 24x36",
      "quantity": 150,
      "specifications": {
        "material": "Corrugated E-Flute",
        "printing": "4/0 CMYK + Spot PMS 185C",
        "finishing": "Gloss Lamination",
        "assembly": "Ship Flat"
      },
      "artworkUrl": "https://storage.newpopsys.com/artwork/ORD-001234/LN-001.pdf"
    }
  ],
  "shippingAddress": {
    "name": "Store Manager",
    "company": "Acme Store #1234",
    "address1": "500 Main Street",
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US"
  },
  "shippingMethod": {
    "carrier": "UPS",
    "service": "GROUND",
    "instructions": "Deliver to receiving dock"
  }
}
```

### 2.5 PSP API Callbacks

#### 2.5.1 Status Update Callback

```http
PUT /v1/orders/ORD-2025-001234/status HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_psp_key_abc123
Content-Type: application/json

{
  "status": "in_production",
  "statusDetails": "Printing complete, moving to finishing",
  "updatedAt": "2025-01-14T14:30:00Z",
  "completionPercentage": 60,
  "estimatedCompletion": "2025-01-15T12:00:00Z"
}
```

### 2.6 Error Handling

| PSP Error | NewPOPSys Handling |
|-----------|-------------------|
| Order not found | Return 404, notify operations |
| Invalid status transition | Return 400, log attempt |
| Duplicate acknowledgment | Return 409, idempotent |
| Production failure | Accept callback, trigger issue.created |

---

## 3. Shipping Carrier Integration

### 3.1 Supported Carriers

| Carrier | API Version | Services Supported |
|---------|-------------|-------------------|
| UPS | REST 2.0 | Ground, 2-Day, Next Day, Freight |
| FedEx | REST 2023 | Ground, Express, Freight |
| USPS | Web Tools 3.0 | Priority, Priority Express, Parcel Select |
| DHL | Express API 2.0 | Express, eCommerce |

### 3.2 Carrier API Endpoints

#### 3.2.1 UPS Integration

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Rate Quote | `/rating/v1/rate` | POST |
| Create Shipment | `/shipments/v1/shipments` | POST |
| Track Package | `/track/v1/details/{trackingNumber}` | GET |
| Void Shipment | `/shipments/v1/shipments/{shipmentId}/void` | PUT |

#### 3.2.2 FedEx Integration

| Operation | Endpoint | Method |
|-----------|----------|--------|
| Rate Quote | `/rate/v1/rates/quotes` | POST |
| Create Shipment | `/ship/v1/shipments` | POST |
| Track Package | `/track/v1/trackingnumbers` | POST |
| Cancel Shipment | `/ship/v1/shipments/cancel` | PUT |

### 3.3 Tracking Integration

#### 3.3.1 Polling Configuration

| Carrier | Poll Interval | Batch Size | Timeout |
|---------|---------------|------------|---------|
| UPS | 30 minutes | 100 tracking numbers | 30 seconds |
| FedEx | 30 minutes | 100 tracking numbers | 30 seconds |
| USPS | 60 minutes | 50 tracking numbers | 60 seconds |
| DHL | 30 minutes | 50 tracking numbers | 45 seconds |

#### 3.3.2 Tracking Event Mapping

| Carrier Event | NewPOPSys Status | Description |
|---------------|------------------|-------------|
| Picked Up | `in_transit` | Package collected |
| In Transit | `in_transit` | En route |
| Out for Delivery | `out_for_delivery` | Final mile |
| Delivered | `delivered` | Package delivered |
| Exception | `exception` | Delivery issue |
| Returned | `returned` | Return to sender |

#### 3.3.3 Sample Tracking Response Mapping

**UPS Tracking Response:**
```json
{
  "trackResponse": {
    "shipment": [
      {
        "inquiryNumber": "1Z999AA10123456784",
        "package": [
          {
            "trackingNumber": "1Z999AA10123456784",
            "activity": [
              {
                "status": {
                  "type": "D",
                  "description": "Delivered",
                  "code": "KB"
                },
                "date": "20250118",
                "time": "143000",
                "location": {
                  "city": "MILWAUKEE",
                  "stateProvince": "WI",
                  "postalCode": "53202",
                  "country": "US"
                }
              }
            ]
          }
        ]
      }
    ]
  }
}
```

**Mapped NewPOPSys Event:**
```json
{
  "shipmentId": "SHP-2025-001234",
  "trackingNumber": "1Z999AA10123456784",
  "carrier": "UPS",
  "status": "delivered",
  "eventTimestamp": "2025-01-18T14:30:00Z",
  "location": {
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US"
  },
  "signedBy": "J SMITH"
}
```

### 3.4 Label Generation

#### 3.4.1 Label Format Support

| Carrier | Formats | Default |
|---------|---------|---------|
| UPS | ZPL, PNG, PDF, GIF | PDF |
| FedEx | ZPL, PNG, PDF | PDF |
| USPS | ZPL, PDF | PDF |
| DHL | ZPL, PDF | PDF |

#### 3.4.2 Label Request Example

```json
{
  "carrier": "UPS",
  "service": "GROUND",
  "labelFormat": "PDF",
  "shipFrom": {
    "name": "PSP Fulfillment",
    "address1": "100 Industrial Way",
    "city": "Chicago",
    "state": "IL",
    "postalCode": "60601",
    "country": "US",
    "phone": "3125551234"
  },
  "shipTo": {
    "name": "Store Manager",
    "company": "Retail Store #1234",
    "address1": "500 Main Street",
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US",
    "phone": "4145556789"
  },
  "packages": [
    {
      "weight": {
        "value": 5.5,
        "unit": "LB"
      },
      "dimensions": {
        "length": 12,
        "width": 10,
        "height": 4,
        "unit": "IN"
      },
      "reference1": "ORD-2025-001234",
      "reference2": "STORE-1234"
    }
  ]
}
```

---

## 4. Brand ERP Integration

### 4.1 Supported ERP Systems

| ERP System | Integration Method | Authentication |
|------------|-------------------|----------------|
| SAP S/4HANA | REST API / OData | OAuth 2.0 + Certificate |
| Oracle NetSuite | SuiteTalk REST | Token-Based Auth |
| Microsoft Dynamics 365 | Web API | Azure AD OAuth 2.0 |
| Sage Intacct | REST API | Session-Based |

### 4.2 Integration Patterns

NewPOPSys sends event notifications to Brand ERP systems via webhooks. ERPs do not call back into NewPOPSys directly.

```
NewPOPSys                              Brand ERP
    │                                      │
    │──── campaign.published webhook ─────▶│
    │                                      │
    │──── order.generated webhook ────────▶│
    │                                      │
    │──── order.shipped webhook ──────────▶│
    │                                      │
    │──── invoice.created webhook ────────▶│
    │                                      │
```

### 4.3 ERP Data Mapping

#### 4.3.1 Campaign to ERP Project

| NewPOPSys Field | SAP Field | NetSuite Field | Dynamics Field |
|-----------------|-----------|----------------|----------------|
| `campaignId` | `PROJECT_ID` | `entityId` | `msdyn_projectid` |
| `campaignName` | `PROJECT_DESC` | `name` | `msdyn_subject` |
| `budget` | `BUDGET_AMOUNT` | `projectedBudget` | `msdyn_plannedbudget` |
| `startDate` | `START_DATE` | `startDate` | `msdyn_scheduledstart` |
| `endDate` | `END_DATE` | `endDate` | `msdyn_scheduledend` |
| `brandId` | `CUSTOMER_ID` | `customer` | `customerid` |

#### 4.3.2 Order to ERP Sales Order

| NewPOPSys Field | SAP Field | NetSuite Field | Dynamics Field |
|-----------------|-----------|----------------|----------------|
| `orderId` | `SALES_ORDER_NO` | `tranId` | `salesorderid` |
| `orderDate` | `ORDER_DATE` | `tranDate` | `createdon` |
| `totalAmount` | `NET_VALUE` | `total` | `totalamount` |
| `shippingAddress` | `SHIP_TO_PARTY` | `shipAddress` | `shipto_composite` |
| `items[].sku` | `MATERIAL_NO` | `item` | `productid` |
| `items[].quantity` | `ORDER_QTY` | `quantity` | `quantity` |

### 4.4 Webhook Payload for ERP

```json
{
  "event": "order.shipped",
  "timestamp": "2025-01-15T09:00:00Z",
  "data": {
    "orderId": "ORD-2025-001234",
    "externalOrderId": "SO-12345",
    "campaignId": "CAMP-2025-Q1",
    "shippedAt": "2025-01-15T09:00:00Z",
    "carrier": "UPS",
    "trackingNumber": "1Z999AA10123456784",
    "trackingUrl": "https://ups.com/track?num=1Z999AA10123456784",
    "shipmentDetails": {
      "packageCount": 1,
      "totalWeight": {
        "value": 5.5,
        "unit": "LB"
      },
      "estimatedDelivery": "2025-01-18"
    },
    "financials": {
      "shippingCost": 15.99,
      "currency": "USD"
    }
  },
  "tenant": {
    "tenantId": "TNT-001",
    "brandName": "Acme Retail"
  }
}
```

---

## 5. Identity & SSO Integration

### 5.1 Supported Identity Providers

| Provider | Protocol | Features |
|----------|----------|----------|
| Azure AD | SAML 2.0 / OIDC | Enterprise SSO, MFA, Groups |
| Okta | SAML 2.0 / OIDC | Universal Directory, MFA |
| Auth0 | OIDC | Social Login, Custom DB |
| Google Workspace | OIDC | G Suite Integration |
| PingFederate | SAML 2.0 | Enterprise Federation |

### 5.2 SAML 2.0 Configuration

#### 5.2.1 Service Provider Metadata

| Attribute | Value |
|-----------|-------|
| Entity ID | `https://api.newpopsys.com/saml/metadata` |
| ACS URL | `https://api.newpopsys.com/saml/callback` |
| SLO URL | `https://api.newpopsys.com/saml/logout` |
| Name ID Format | `emailAddress` |
| Signature Algorithm | RSA-SHA256 |

#### 5.2.2 Required SAML Assertions

| Attribute | Description | Required |
|-----------|-------------|----------|
| `email` | User email address | Yes |
| `firstName` | User first name | Yes |
| `lastName` | User last name | Yes |
| `groups` | Group memberships | No |
| `employeeId` | Employee identifier | No |
| `department` | Department name | No |

#### 5.2.3 Group-to-Role Mapping

| IdP Group | NewPOPSys Role | Permissions |
|-----------|----------------|-------------|
| `newpopsys-admins` | `admin` | Full access |
| `newpopsys-brand-managers` | `brand_manager` | Brand management |
| `newpopsys-field-reps` | `field_rep` | Mobile app, surveys |
| `newpopsys-viewers` | `viewer` | Read-only access |

### 5.3 OIDC Configuration

#### 5.3.1 OpenID Connect Settings

| Setting | Value |
|---------|-------|
| Client ID | Provided per tenant |
| Redirect URI | `https://api.newpopsys.com/oauth/callback` |
| Response Type | `code` |
| Scopes | `openid profile email groups` |
| Token Endpoint Auth | `client_secret_post` |

#### 5.3.2 JWT Claims Mapping

```json
{
  "sub": "user-unique-id",
  "email": "user@company.com",
  "name": "John Doe",
  "given_name": "John",
  "family_name": "Doe",
  "groups": ["newpopsys-brand-managers"],
  "iss": "https://login.microsoftonline.com/{tenant-id}/v2.0",
  "aud": "{client-id}",
  "iat": 1705142400,
  "exp": 1705146000
}
```

### 5.4 Session Management

| Setting | Value |
|---------|-------|
| Session Duration | 8 hours |
| Idle Timeout | 30 minutes |
| Refresh Token Lifetime | 24 hours |
| Concurrent Sessions | 3 per user |

---

## 6. Payment Integration

### 6.1 Supported Payment Processors

| Processor | Use Case | Features |
|-----------|----------|----------|
| Stripe | Card Payments | PCI DSS, 3D Secure |
| PayPal | PayPal Payments | Express Checkout |
| ACH/Wire | B2B Payments | Net terms support |

### 6.2 Stripe Integration

#### 6.2.1 API Configuration

| Setting | Value |
|---------|-------|
| API Version | `2024-12-18.acacia` |
| Webhook Version | `2024-12-18.acacia` |
| Payment Methods | `card`, `us_bank_account` |

#### 6.2.2 Payment Intent Flow

```
Customer                NewPOPSys               Stripe
    │                       │                      │
    │── Place Order ───────▶│                      │
    │                       │                      │
    │                       │── Create PaymentIntent ─▶│
    │                       │                      │
    │                       │◀── client_secret ────│
    │                       │                      │
    │◀── Payment Form ──────│                      │
    │                       │                      │
    │── Confirm Payment ────────────────────────────▶│
    │                       │                      │
    │                       │◀── payment_intent.succeeded ──│
    │                       │    (webhook)         │
    │                       │                      │
    │◀── Order Confirmed ───│                      │
```

#### 6.2.3 Webhook Events

| Event | NewPOPSys Action |
|-------|------------------|
| `payment_intent.succeeded` | Mark order as paid |
| `payment_intent.payment_failed` | Notify customer, retry |
| `charge.refunded` | Update order status |
| `invoice.paid` | Update subscription |

---

## 7. Cloud Storage Integration

### 7.1 Supported Storage Providers

| Provider | Use Case | Features |
|----------|----------|----------|
| AWS S3 | Primary storage | CDN, versioning |
| Azure Blob | Enterprise customers | AD integration |
| Google Cloud Storage | Alternative | Multi-region |

### 7.2 AWS S3 Configuration

#### 7.2.1 Bucket Structure

| Bucket | Purpose | Lifecycle |
|--------|---------|-----------|
| `newpopsys-artwork-{env}` | Source artwork | 2 years |
| `newpopsys-photos-{env}` | Survey photos | 1 year |
| `newpopsys-exports-{env}` | Report exports | 90 days |
| `newpopsys-temp-{env}` | Temporary uploads | 24 hours |

#### 7.2.2 Pre-signed URL Generation

```json
{
  "operation": "putObject",
  "bucket": "newpopsys-photos-prod",
  "key": "surveys/2025/01/RESP-001234/photo-001.jpg",
  "expiresIn": 3600,
  "conditions": {
    "content-type": "image/jpeg",
    "content-length-range": [1, 10485760]
  }
}
```

#### 7.2.3 CDN Configuration

| Setting | Value |
|---------|-------|
| CDN Provider | AWS CloudFront |
| Origin | S3 bucket |
| TTL | 24 hours (artwork), 1 hour (dynamic) |
| Signed URLs | Required for private assets |

---

## 8. Notification Services

### 8.1 Email (SendGrid)

#### 8.1.1 Configuration

| Setting | Value |
|---------|-------|
| API Version | v3 |
| Sender Domain | `notifications.newpopsys.com` |
| IP Warmup | Dedicated IP pool |

#### 8.1.2 Email Templates

| Template | Trigger | Recipient |
|----------|---------|-----------|
| `order-confirmation` | Order created | Store manager |
| `shipment-notification` | Shipment created | Store manager |
| `survey-reminder` | Survey due | Field rep |
| `issue-escalation` | Issue unresolved 48h | Brand manager |

### 8.2 SMS (Twilio)

#### 8.2.1 Configuration

| Setting | Value |
|---------|-------|
| API Version | 2010-04-01 |
| Sender Number | Short code or toll-free |
| Messaging Service | Enabled |

#### 8.2.2 SMS Use Cases

| Use Case | Template |
|----------|----------|
| Delivery OTP | "Your delivery code is {code}. Valid for 30 minutes." |
| Survey Reminder | "Reminder: Complete installation survey for Store #{store_id}." |
| Urgent Issue | "URGENT: Issue #{issue_id} requires immediate attention." |

---

## 9. Error Handling & Retry

### 9.1 External API Error Handling

| Error Type | Retry Strategy | Max Attempts |
|------------|----------------|--------------|
| 5xx Server Error | Exponential backoff | 5 |
| 429 Rate Limited | Respect Retry-After | 3 |
| 401 Unauthorized | Refresh token, retry | 1 |
| 4xx Client Error | No retry | 0 |
| Network Timeout | Immediate retry | 3 |

### 9.2 Retry Schedule

```
Attempt 1: Immediate
Attempt 2: 1 second delay
Attempt 3: 5 seconds delay
Attempt 4: 30 seconds delay
Attempt 5: 5 minutes delay
```

### 9.3 Circuit Breaker Configuration

| Setting | Value |
|---------|-------|
| Failure Threshold | 5 failures in 60 seconds |
| Open Duration | 30 seconds |
| Half-Open Requests | 3 |
| Success Threshold | 2 consecutive successes |

---

## 10. Security Requirements

### 10.1 API Credential Storage

| Credential Type | Storage | Rotation |
|-----------------|---------|----------|
| API Keys | AWS Secrets Manager | 90 days |
| OAuth Tokens | Redis (encrypted) | Per session |
| Service Accounts | Vault | 30 days |
| Certificates | ACM / Key Vault | 1 year |

### 10.2 Data Encryption

| Data State | Encryption |
|------------|------------|
| In Transit | TLS 1.3 |
| At Rest | AES-256 |
| Secrets | AWS KMS / Azure Key Vault |

### 10.3 Audit Logging

All external API calls are logged with:
- Timestamp
- Target system
- Operation type
- Request ID
- Response status
- Latency
- Error details (if any)

---

## 11. Monitoring & Alerting

### 11.1 Health Checks

| Integration | Check Interval | Timeout |
|-------------|----------------|---------|
| Shipping Carriers | 5 minutes | 10 seconds |
| ERP Systems | 5 minutes | 30 seconds |
| Identity Providers | 1 minute | 5 seconds |
| Payment Processors | 1 minute | 10 seconds |

### 11.2 Alert Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| API Error Rate | > 1% | > 5% |
| Response Latency | > 2 seconds | > 5 seconds |
| Circuit Breaker Open | N/A | Any open |
| Authentication Failures | > 10/hour | > 50/hour |

---

## 12. Related Documents

| Document ID | Title | Description |
|-------------|-------|-------------|
| SRS-11.1 | API Overview | Authentication, versioning, rate limiting |
| SRS-11.2 | Internal APIs | RESTful endpoint specifications |
| SRS-11.4 | Webhooks | Event-driven notifications |
| SRS-3.4 | Integration Architecture | Technical integration patterns |

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-01-13 | System | Initial version |


---

# 11.4 Webhooks

## Document Information
| Field | Value |
|-------|-------|
| Document ID | SRS-11.4 |
| Version | 1.0 |
| Last Updated | 2026-01-01 |
| Status | Draft |
| Parent Document | SRS-11 API Specifications |

---

## 1. Introduction

### 1.1 Purpose
This document specifies the webhook system for NewPOPSys, enabling real-time event notifications to external systems including Brand ERPs, PSP MIS platforms, and custom integrations.

---

## 2. Event Types

### 2.1 Campaign Events
| Event Type | Trigger | Payload |
|------------|---------|---------|
| `campaign.created` | New campaign published | Campaign object |
| `campaign.updated` | Campaign details modified | Changed fields |
| `campaign.activated` | Campaign goes live | Campaign + stores |
| `campaign.completed` | All tasks finished | Campaign + summary |
| `campaign.cancelled` | Campaign cancelled | Campaign + reason |

### 2.2 Task Events
| Event Type | Trigger | Payload |
|------------|---------|---------|
| `task.assigned` | Task assigned to store | Task + store |
| `task.started` | Store begins task | Task + timestamp |
| `task.completed` | Task marked complete | Task + evidence |
| `task.verified` | Task passes QA | Task + verification |
| `task.rejected` | Task fails QA | Task + rejection reason |

### 2.3 Photo Events
| Event Type | Trigger | Payload |
|------------|---------|---------|
| `photo.uploaded` | New photo submitted | Photo metadata |
| `photo.processed` | AI analysis complete | Photo + scores |
| `photo.approved` | Photo approved | Photo + reviewer |
| `photo.rejected` | Photo rejected | Photo + reason |

### 2.4 Order Events
| Event Type | Trigger | Payload |
|------------|---------|---------|
| `order.created` | Kit order generated | Order details |
| `order.shipped` | Order dispatched | Order + tracking |
| `order.delivered` | Delivery confirmed | Order + POD |
| `shipment.exception` | Delivery issue | Exception details |

---

## 3. Payload Format

### 3.1 Standard Envelope
```json
{
  "id": "evt_abc123def456",
  "type": "campaign.created",
  "api_version": "2026-01-01",
  "created_at": "2026-01-01T12:00:00Z",
  "data": { "object": { } },
  "metadata": { "brand_id": "brand_123", "tenant_id": "tenant_456" }
}
```

---

## 4. Security

### 4.1 Signature Verification
All webhooks signed using HMAC-SHA256. Header: `X-POPSys-Signature`

### 4.2 Timestamp Validation
Reject requests where timestamp differs from server time by > 5 minutes.

---

## 5. Delivery & Retry

| Attempt | Delay |
|---------|-------|
| 1 | Immediate |
| 2 | 5 minutes |
| 3 | 30 minutes |
| 4 | 2 hours |
| 5 | 24 hours |

After 5 failed attempts: webhook disabled, admin notified, events queued 7 days.

---

## 6. Configuration Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/webhooks` | List webhooks |
| POST | `/api/v1/webhooks` | Create webhook |
| GET | `/api/v1/webhooks/{id}` | Get webhook |
| PATCH | `/api/v1/webhooks/{id}` | Update webhook |
| DELETE | `/api/v1/webhooks/{id}` | Delete webhook |
| POST | `/api/v1/webhooks/{id}/test` | Send test event |

---

## References
- [11.1 API Overview](11.1_API_Overview.md)
- [11.2 Internal APIs](11.2_Internal_APIs.md)
- [11.3 External Integrations](11.3_External_Integrations.md)

