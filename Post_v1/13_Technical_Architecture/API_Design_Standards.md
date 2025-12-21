# API Design Standards

## Overview

This document establishes comprehensive API design guidelines for PopSystem, ensuring consistency, developer experience, and scalability across all platform APIs from v1 through v4+.

---

## Design Philosophy

```
CONSISTENCY → PREDICTABILITY → DEVELOPER JOY
```

**Core Principles:**
1. **Developer-First:** APIs should be intuitive and self-documenting
2. **Backward Compatibility:** Never break existing integrations
3. **Performance:** Design for efficiency from day one
4. **Security:** Authentication and authorization built-in
5. **Versioning:** Plan for evolution

---

## REST vs GraphQL Decision Framework

### Decision Matrix

| Use Case | REST | GraphQL | Rationale |
|----------|------|---------|-----------|
| CRUD operations | ✅ Preferred | ❌ | Simple, cacheable, standard HTTP |
| Complex queries | ❌ | ✅ Preferred | Single request, no over-fetching |
| Real-time updates | ❌ | ✅ (Subscriptions) | Built-in subscription support |
| Public API | ✅ Preferred | ⚠️ Optional | Broader compatibility, easier rate limiting |
| Mobile apps | ⚠️ | ✅ Preferred | Reduces bandwidth, flexible queries |
| Batch operations | ❌ | ✅ Preferred | Single request for multiple resources |
| File uploads | ✅ Preferred | ⚠️ Complex | Standard multipart/form-data |
| Third-party webhooks | ✅ Only | ❌ | Industry standard |

### PopSystem API Strategy

```
v1-v2: REST only
v3: REST + GraphQL (query layer)
v4: GraphQL Federation + REST for mutations
```

**Rationale:**
- **v1-v2:** REST is simpler to build and consume initially
- **v3:** Add GraphQL for complex frontend queries (analytics dashboards)
- **v4:** GraphQL Federation for microservices, REST for write operations

---

## RESTful API Design

### Resource Naming

#### Rules
1. **Use nouns, not verbs:** `/campaigns` not `/getCampaigns`
2. **Plural resources:** `/campaigns` not `/campaign`
3. **Lowercase, hyphenated:** `/campaign-templates` not `/campaignTemplates`
4. **Hierarchical relationships:** `/campaigns/{id}/posts` for nested resources
5. **Avoid deep nesting:** Max 2 levels (`/resources/{id}/subresources`)

#### Examples

```
✅ Good:
GET    /campaigns
GET    /campaigns/{id}
GET    /campaigns/{id}/posts
GET    /influencers?status=active
POST   /campaigns
PUT    /campaigns/{id}
DELETE /campaigns/{id}
POST   /campaigns/{id}/publish

❌ Bad:
GET    /getCampaigns
GET    /campaign/{id}
GET    /campaigns/{id}/posts/{postId}/comments/{commentId}/likes
POST   /createCampaign
POST   /campaigns/{id}/delete
```

### HTTP Methods

| Method | Purpose | Idempotent | Safe | Request Body | Success Code |
|--------|---------|------------|------|--------------|--------------|
| GET | Retrieve resource(s) | ✅ | ✅ | ❌ No | 200 OK |
| POST | Create new resource | ❌ | ❌ | ✅ Yes | 201 Created |
| PUT | Replace entire resource | ✅ | ❌ | ✅ Yes | 200 OK |
| PATCH | Partial update | ❌ | ❌ | ✅ Yes | 200 OK |
| DELETE | Remove resource | ✅ | ❌ | ❌ Optional | 204 No Content |

### Status Codes

#### Success Codes
```
200 OK              - Successful GET, PUT, PATCH
201 Created         - Successful POST
202 Accepted        - Async operation started
204 No Content      - Successful DELETE
304 Not Modified    - Cached response valid
```

#### Client Error Codes
```
400 Bad Request          - Invalid input
401 Unauthorized         - Missing/invalid authentication
403 Forbidden            - Valid auth, insufficient permissions
404 Not Found            - Resource doesn't exist
405 Method Not Allowed   - HTTP method not supported
409 Conflict             - Resource conflict (duplicate)
422 Unprocessable Entity - Validation error
429 Too Many Requests    - Rate limit exceeded
```

#### Server Error Codes
```
500 Internal Server Error - Unexpected error
502 Bad Gateway          - Upstream service error
503 Service Unavailable  - Temporary outage
504 Gateway Timeout      - Upstream timeout
```

### Request/Response Format

#### Request Example
```http
POST /v1/campaigns HTTP/1.1
Host: api.popsystem.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
Accept: application/json
X-Tenant-ID: tenant-123
X-Request-ID: req-abc-123

{
  "name": "Summer Sale 2025",
  "type": "PRODUCT_LAUNCH",
  "budget": {
    "amount": 10000,
    "currency": "USD"
  },
  "targetAudience": {
    "demographics": ["18-35", "female"],
    "interests": ["fashion", "beauty"]
  },
  "startDate": "2025-06-01T00:00:00Z",
  "endDate": "2025-08-31T23:59:59Z"
}
```

#### Success Response
```http
HTTP/1.1 201 Created
Content-Type: application/json
X-Request-ID: req-abc-123
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640000000

{
  "data": {
    "id": "campaign-xyz-789",
    "name": "Summer Sale 2025",
    "type": "PRODUCT_LAUNCH",
    "status": "DRAFT",
    "budget": {
      "amount": 10000,
      "currency": "USD",
      "spent": 0
    },
    "targetAudience": {
      "demographics": ["18-35", "female"],
      "interests": ["fashion", "beauty"]
    },
    "startDate": "2025-06-01T00:00:00Z",
    "endDate": "2025-08-31T23:59:59Z",
    "createdAt": "2025-12-21T10:30:00Z",
    "updatedAt": "2025-12-21T10:30:00Z",
    "createdBy": "user-456"
  },
  "meta": {
    "requestId": "req-abc-123",
    "version": "1.0"
  }
}
```

#### Error Response
```http
HTTP/1.1 422 Unprocessable Entity
Content-Type: application/json
X-Request-ID: req-abc-123

{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The request contains invalid data",
    "details": [
      {
        "field": "budget.amount",
        "code": "MIN_VALUE",
        "message": "Budget must be at least $500",
        "value": 100
      },
      {
        "field": "endDate",
        "code": "INVALID_DATE",
        "message": "End date must be after start date",
        "value": "2025-05-01T00:00:00Z"
      }
    ]
  },
  "meta": {
    "requestId": "req-abc-123",
    "timestamp": "2025-12-21T10:30:00Z",
    "documentation": "https://docs.popsystem.com/api/errors/validation-error"
  }
}
```

---

## API Versioning Strategy

### URL Versioning (Recommended for v1-v3)

```
https://api.popsystem.com/v1/campaigns
https://api.popsystem.com/v2/campaigns
https://api.popsystem.com/v3/campaigns
```

**Pros:**
- Clear and explicit
- Easy to cache
- Easy to route to different backends
- Browser-friendly (testable in browser)

**Cons:**
- Clutters URL namespace
- Version in every request

### Header Versioning (Optional for v4+)

```http
GET /campaigns HTTP/1.1
Host: api.popsystem.com
Accept: application/vnd.popsystem.v3+json
```

**Pros:**
- Cleaner URLs
- Same endpoint, different versions
- More RESTful

**Cons:**
- Less visible
- Harder to test in browser
- Requires header inspection

### Version Lifecycle

```
ACTIVE → DEPRECATED → SUNSET
  │         │            │
  │         ├─ 6 months warning
  │         └─ Migration guide published
  │
  └─ New version released
```

#### Versioning Policy
1. **Backward compatibility within a version** (v1.x)
2. **Breaking changes require new version** (v2)
3. **Support N-1 versions** (when v3 launches, v2 supported, v1 deprecated)
4. **Minimum 6 months deprecation notice**
5. **12+ months support for deprecated versions**

#### Breaking Changes
Require new major version:
- Removing fields
- Renaming fields
- Changing field types
- Changing authentication
- Changing response structure
- Removing endpoints

#### Non-Breaking Changes
Can be added to existing version:
- Adding new fields (optional)
- Adding new endpoints
- Adding new query parameters (optional)
- Adding new error codes
- Performance improvements
- Bug fixes

---

## Authentication & Authorization

### OAuth 2.0 + JWT Strategy

#### Flow Diagram
```
┌──────────┐                              ┌──────────┐
│  Client  │                              │  Auth    │
│  (SPA)   │                              │  Server  │
└────┬─────┘                              └────┬─────┘
     │                                         │
     │ 1. GET /authorize                       │
     │────────────────────────────────────────>│
     │                                         │
     │ 2. Login page                           │
     │<────────────────────────────────────────│
     │                                         │
     │ 3. User credentials                     │
     │────────────────────────────────────────>│
     │                                         │
     │ 4. Authorization code                   │
     │<────────────────────────────────────────│
     │                                         │
     │ 5. POST /token (code)                   │
     │────────────────────────────────────────>│
     │                                         │
     │ 6. Access token + Refresh token         │
     │<────────────────────────────────────────│
     │                                         │
     ▼                                         ▼
┌──────────┐                              ┌──────────┐
│  Client  │  7. API Request with token   │   API    │
│  (SPA)   │─────────────────────────────>│  Server  │
└──────────┘                              └──────────┘
```

### JWT Token Structure

```typescript
// Access Token (short-lived: 15 minutes)
{
  "header": {
    "alg": "RS256",
    "typ": "JWT",
    "kid": "key-2025-01"
  },
  "payload": {
    "iss": "https://auth.popsystem.com",
    "sub": "user-123",
    "aud": "https://api.popsystem.com",
    "exp": 1640001000,
    "iat": 1640000100,
    "tenant_id": "tenant-abc",
    "email": "user@example.com",
    "roles": ["campaign_manager", "admin"],
    "permissions": [
      "campaigns:read",
      "campaigns:write",
      "analytics:read"
    ]
  },
  "signature": "..."
}

// Refresh Token (long-lived: 30 days)
{
  "jti": "refresh-xyz-789",
  "sub": "user-123",
  "exp": 1642592100,
  "token_type": "refresh"
}
```

### Authentication Endpoints

```typescript
// POST /auth/login
{
  "email": "user@example.com",
  "password": "••••••••",
  "mfa_code": "123456" // If MFA enabled
}

// Response
{
  "access_token": "eyJhbGci...",
  "refresh_token": "eyJqdGki...",
  "token_type": "Bearer",
  "expires_in": 900, // 15 minutes
  "scope": "campaigns:* analytics:read"
}

// POST /auth/refresh
{
  "refresh_token": "eyJqdGki..."
}

// Response
{
  "access_token": "eyJhbGci...",
  "expires_in": 900
}

// POST /auth/logout
{
  "refresh_token": "eyJqdGki..."
}

// Response
{
  "message": "Successfully logged out"
}
```

### API Request Authentication

```http
GET /v1/campaigns HTTP/1.1
Host: api.popsystem.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
X-Tenant-ID: tenant-abc
```

### Authorization (RBAC)

#### Permission Format
```
<resource>:<action>:<scope>

Examples:
campaigns:read:own      - Read own campaigns
campaigns:write:team    - Write team campaigns
campaigns:delete:all    - Delete any campaign
analytics:read:all      - Read all analytics
billing:write:own       - Manage own billing
```

#### Role Definitions

```typescript
const roles = {
  VIEWER: {
    permissions: [
      'campaigns:read:own',
      'analytics:read:own',
      'influencers:read:all'
    ]
  },

  CAMPAIGN_MANAGER: {
    inherits: ['VIEWER'],
    permissions: [
      'campaigns:write:own',
      'campaigns:publish:own',
      'influencers:invite:all'
    ]
  },

  TEAM_ADMIN: {
    inherits: ['CAMPAIGN_MANAGER'],
    permissions: [
      'campaigns:*:team',
      'analytics:read:team',
      'users:read:team',
      'users:invite:team'
    ]
  },

  ACCOUNT_OWNER: {
    inherits: ['TEAM_ADMIN'],
    permissions: [
      '*:*:all', // All permissions
      'billing:*:own',
      'settings:*:own'
    ]
  }
};
```

#### Authorization Middleware

```typescript
// Check permissions
const requirePermission = (permission: string) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    const user = req.user; // From JWT
    const hasPermission = await authService.checkPermission(
      user.id,
      permission,
      req.context
    );

    if (!hasPermission) {
      return res.status(403).json({
        error: {
          code: 'FORBIDDEN',
          message: `Missing required permission: ${permission}`
        }
      });
    }

    next();
  };
};

// Usage
router.delete(
  '/campaigns/:id',
  requirePermission('campaigns:delete:own'),
  campaignsController.delete
);
```

---

## Rate Limiting

### Tier-Based Limits

| Tier | Requests/Hour | Requests/Day | Burst | Use Case |
|------|---------------|--------------|-------|----------|
| **Free** | 100 | 1,000 | 10/min | Individual users, testing |
| **Starter** | 1,000 | 10,000 | 50/min | Small businesses |
| **Professional** | 10,000 | 100,000 | 200/min | Growing businesses |
| **Enterprise** | 100,000 | 1,000,000 | 1000/min | Large organizations |
| **Unlimited** | Custom | Custom | Custom | Strategic partners |

### Rate Limit Headers

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 1000          # Total requests allowed in window
X-RateLimit-Remaining: 847       # Requests remaining
X-RateLimit-Reset: 1640001000    # Unix timestamp when limit resets
X-RateLimit-Used: 153            # Requests used
Retry-After: 300                 # Seconds to wait (if 429)
```

### Rate Limit Response

```http
HTTP/1.1 429 Too Many Requests
Content-Type: application/json
Retry-After: 300

{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Rate limit exceeded. Please retry after 300 seconds.",
    "limit": 1000,
    "remaining": 0,
    "reset": 1640001000,
    "resetAt": "2025-12-21T11:00:00Z"
  },
  "meta": {
    "documentation": "https://docs.popsystem.com/api/rate-limiting",
    "upgradePlan": "https://popsystem.com/pricing"
  }
}
```

### Rate Limiting Strategy

```typescript
// Redis-based sliding window
class RateLimiter {
  async checkLimit(
    userId: string,
    tier: string
  ): Promise<RateLimitResult> {
    const key = `ratelimit:${tier}:${userId}`;
    const limit = TIER_LIMITS[tier];
    const window = 3600; // 1 hour

    const now = Date.now();
    const windowStart = now - (window * 1000);

    // Remove old requests
    await redis.zremrangebyscore(key, 0, windowStart);

    // Count requests in current window
    const count = await redis.zcard(key);

    if (count >= limit) {
      const oldestRequest = await redis.zrange(key, 0, 0);
      const resetTime = parseInt(oldestRequest[0]) + (window * 1000);

      return {
        allowed: false,
        limit,
        remaining: 0,
        reset: Math.floor(resetTime / 1000)
      };
    }

    // Add current request
    await redis.zadd(key, now, `${now}-${uuid()}`);
    await redis.expire(key, window);

    return {
      allowed: true,
      limit,
      remaining: limit - count - 1,
      reset: Math.floor((now + (window * 1000)) / 1000)
    };
  }
}
```

---

## Pagination

### Cursor-Based Pagination (Recommended)

**When to use:** Large datasets, real-time data, consistent ordering

```http
GET /v1/campaigns?limit=20&after=cursor_abc123 HTTP/1.1
```

**Response:**
```json
{
  "data": [
    { "id": "campaign-1", "name": "Summer Sale" },
    { "id": "campaign-2", "name": "Winter Collection" }
  ],
  "pagination": {
    "hasMore": true,
    "nextCursor": "cursor_xyz789",
    "prevCursor": "cursor_abc123",
    "limit": 20
  },
  "meta": {
    "total": null  // Unknown with cursor pagination
  }
}
```

**Next page:**
```http
GET /v1/campaigns?limit=20&after=cursor_xyz789
```

**Previous page:**
```http
GET /v1/campaigns?limit=20&before=cursor_abc123
```

### Offset-Based Pagination

**When to use:** Small datasets, need page numbers, stable data

```http
GET /v1/campaigns?page=2&per_page=20 HTTP/1.1
```

**Response:**
```json
{
  "data": [...],
  "pagination": {
    "page": 2,
    "perPage": 20,
    "totalPages": 10,
    "totalItems": 197,
    "hasNext": true,
    "hasPrev": true
  },
  "links": {
    "first": "/v1/campaigns?page=1&per_page=20",
    "prev": "/v1/campaigns?page=1&per_page=20",
    "self": "/v1/campaigns?page=2&per_page=20",
    "next": "/v1/campaigns?page=3&per_page=20",
    "last": "/v1/campaigns?page=10&per_page=20"
  }
}
```

### Pagination Limits

```typescript
const PAGINATION_LIMITS = {
  default: 20,
  min: 1,
  max: 100,
  maxForAdmin: 1000
};
```

---

## Error Response Format

### Standard Error Schema

```typescript
interface ApiError {
  error: {
    code: string;                    // Machine-readable error code
    message: string;                 // Human-readable message
    details?: Array<{                // Validation errors
      field: string;
      code: string;
      message: string;
      value?: any;
    }>;
    suggestion?: string;             // How to fix
    retryable?: boolean;            // Can retry?
  };
  meta: {
    requestId: string;
    timestamp: string;
    documentation?: string;          // Link to docs
    support?: string;               // Support contact
  };
}
```

### Error Codes

```typescript
// Client Errors (4xx)
const CLIENT_ERRORS = {
  // Authentication
  INVALID_CREDENTIALS: 'Invalid email or password',
  TOKEN_EXPIRED: 'Access token has expired',
  TOKEN_INVALID: 'Access token is invalid',
  MFA_REQUIRED: 'Multi-factor authentication required',

  // Authorization
  FORBIDDEN: 'Insufficient permissions',
  TENANT_ACCESS_DENIED: 'Access to this tenant denied',

  // Validation
  VALIDATION_ERROR: 'Request validation failed',
  REQUIRED_FIELD: 'Required field missing',
  INVALID_FORMAT: 'Field format invalid',
  OUT_OF_RANGE: 'Value out of acceptable range',

  // Resources
  NOT_FOUND: 'Resource not found',
  ALREADY_EXISTS: 'Resource already exists',
  CONFLICT: 'Resource conflict',

  // Rate Limiting
  RATE_LIMIT_EXCEEDED: 'Rate limit exceeded',
  QUOTA_EXCEEDED: 'Quota exceeded for your plan'
};

// Server Errors (5xx)
const SERVER_ERRORS = {
  INTERNAL_ERROR: 'Internal server error',
  SERVICE_UNAVAILABLE: 'Service temporarily unavailable',
  DATABASE_ERROR: 'Database operation failed',
  EXTERNAL_SERVICE_ERROR: 'External service error'
};
```

### Error Examples

#### Validation Error
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "email",
        "code": "INVALID_FORMAT",
        "message": "Email format is invalid",
        "value": "not-an-email"
      }
    ],
    "suggestion": "Ensure all fields meet the documented requirements"
  },
  "meta": {
    "requestId": "req-123",
    "timestamp": "2025-12-21T10:30:00Z",
    "documentation": "https://docs.popsystem.com/api/validation"
  }
}
```

#### Not Found Error
```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "Campaign not found",
    "suggestion": "Verify the campaign ID and ensure you have access"
  },
  "meta": {
    "requestId": "req-456",
    "timestamp": "2025-12-21T10:30:00Z"
  }
}
```

---

## HATEOAS Considerations

### Hypermedia Links (Optional for v2+)

```json
{
  "data": {
    "id": "campaign-123",
    "name": "Summer Sale",
    "status": "ACTIVE",
    "_links": {
      "self": {
        "href": "/v1/campaigns/campaign-123"
      },
      "posts": {
        "href": "/v1/campaigns/campaign-123/posts"
      },
      "analytics": {
        "href": "/v1/campaigns/campaign-123/analytics"
      },
      "pause": {
        "href": "/v1/campaigns/campaign-123/pause",
        "method": "POST"
      },
      "edit": {
        "href": "/v1/campaigns/campaign-123",
        "method": "PUT"
      }
    },
    "_actions": {
      "canPause": true,
      "canDelete": false,
      "canEdit": true
    }
  }
}
```

---

## OpenAPI/Swagger Standards

### OpenAPI 3.0 Specification

```yaml
openapi: 3.0.3
info:
  title: PopSystem API
  version: 1.0.0
  description: |
    PopSystem influencer marketing platform API.

    ## Authentication
    All endpoints require Bearer token authentication.

  contact:
    name: API Support
    email: api-support@popsystem.com
    url: https://docs.popsystem.com

  license:
    name: Proprietary

servers:
  - url: https://api.popsystem.com/v1
    description: Production
  - url: https://api-staging.popsystem.com/v1
    description: Staging
  - url: http://localhost:3000/v1
    description: Development

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    Campaign:
      type: object
      required:
        - name
        - type
        - budget
      properties:
        id:
          type: string
          format: uuid
          readOnly: true
          example: campaign-abc-123
        name:
          type: string
          minLength: 3
          maxLength: 100
          example: Summer Sale 2025
        type:
          type: string
          enum: [PRODUCT_LAUNCH, BRAND_AWARENESS, ENGAGEMENT]
        status:
          type: string
          enum: [DRAFT, ACTIVE, PAUSED, COMPLETED]
          readOnly: true
        budget:
          $ref: '#/components/schemas/Budget'
        createdAt:
          type: string
          format: date-time
          readOnly: true
        updatedAt:
          type: string
          format: date-time
          readOnly: true

    Budget:
      type: object
      required:
        - amount
        - currency
      properties:
        amount:
          type: number
          minimum: 500
          maximum: 1000000
          example: 10000
        currency:
          type: string
          enum: [USD, EUR, GBP]
          example: USD
        spent:
          type: number
          readOnly: true
          example: 2500

    Error:
      type: object
      properties:
        error:
          type: object
          properties:
            code:
              type: string
            message:
              type: string
            details:
              type: array
              items:
                type: object

security:
  - bearerAuth: []

paths:
  /campaigns:
    get:
      summary: List campaigns
      operationId: listCampaigns
      tags:
        - Campaigns
      parameters:
        - name: status
          in: query
          schema:
            type: string
            enum: [DRAFT, ACTIVE, PAUSED, COMPLETED]
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
      responses:
        '200':
          description: List of campaigns
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/Campaign'

    post:
      summary: Create campaign
      operationId: createCampaign
      tags:
        - Campaigns
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Campaign'
      responses:
        '201':
          description: Campaign created
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    $ref: '#/components/schemas/Campaign'
        '422':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
```

---

## SDK Generation Strategy

### Auto-Generated SDKs

```yaml
# Generate SDKs from OpenAPI spec
Languages:
  - TypeScript/JavaScript (npm)
  - Python (pip)
  - Go (go modules)
  - PHP (composer)
  - Ruby (gem)

Tools:
  - openapi-generator-cli
  - Custom templates for idiomatic code
```

### TypeScript SDK Example

```typescript
// Auto-generated from OpenAPI spec
import { PopSystemClient } from '@popsystem/sdk';

const client = new PopSystemClient({
  apiKey: process.env.POPSYSTEM_API_KEY,
  environment: 'production'
});

// Type-safe SDK methods
const campaign = await client.campaigns.create({
  name: 'Summer Sale',
  type: 'PRODUCT_LAUNCH',
  budget: {
    amount: 10000,
    currency: 'USD'
  }
});

console.log(campaign.id); // Fully typed
```

---

## Webhook Design Patterns

### Webhook Registration

```http
POST /v1/webhooks HTTP/1.1

{
  "url": "https://customer.com/webhooks/popsystem",
  "events": [
    "campaign.published",
    "campaign.completed",
    "post.created"
  ],
  "secret": "whsec_abc123...",
  "active": true
}
```

### Webhook Payload

```http
POST /webhooks/popsystem HTTP/1.1
Host: customer.com
Content-Type: application/json
X-PopSystem-Event: campaign.published
X-PopSystem-Signature: sha256=abc123...
X-PopSystem-Delivery-ID: delivery-123

{
  "id": "evt_abc123",
  "type": "campaign.published",
  "created": "2025-12-21T10:30:00Z",
  "data": {
    "object": {
      "id": "campaign-xyz",
      "name": "Summer Sale",
      "status": "ACTIVE",
      "publishedAt": "2025-12-21T10:30:00Z"
    }
  },
  "tenant_id": "tenant-123"
}
```

### Webhook Security

```typescript
// Verify webhook signature
function verifyWebhookSignature(
  payload: string,
  signature: string,
  secret: string
): boolean {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');

  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(`sha256=${expectedSignature}`)
  );
}
```

### Webhook Retry Policy

```
Attempt 1: Immediate
Attempt 2: 1 minute later
Attempt 3: 5 minutes later
Attempt 4: 30 minutes later
Attempt 5: 2 hours later
Attempt 6: 12 hours later

Max attempts: 6
After 6 failures: Mark webhook as failed, notify customer
```

---

## API Testing Standards

### Contract Testing

```typescript
// Ensure API matches OpenAPI spec
import { validateSpec } from 'openapi-validator';

describe('POST /campaigns', () => {
  it('should match OpenAPI spec', async () => {
    const response = await request(app)
      .post('/v1/campaigns')
      .send(validCampaign);

    expect(response.status).toBe(201);
    expect(validateSpec(response.body, 'Campaign')).toBe(true);
  });
});
```

---

## Key Takeaways

1. **Consistency is King:** Follow standards religiously
2. **Developer Experience:** Make APIs intuitive and well-documented
3. **Versioning:** Plan for change from day one
4. **Security:** Authentication and authorization are non-negotiable
5. **OpenAPI:** Single source of truth for API contracts
6. **Rate Limiting:** Protect platform and ensure fairness

---

**Document Version:** 1.0
**Last Updated:** 2025-12-21
**Owner:** API Architecture Team
**Review Cycle:** Quarterly
