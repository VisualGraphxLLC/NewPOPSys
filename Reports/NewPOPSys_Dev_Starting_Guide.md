# NewPOPSys v1 — Developer Starting Guide

**Version:** 1.0 | **Date:** December 2025

---

## Quick Start

### Prerequisites
- Node.js LTS (v20+)
- pnpm (package manager)
- Docker Desktop (for local services)
- Git

### Local Development Setup

```bash
# Clone repository
git clone <repo-url>
cd newpopsys

# Install dependencies
pnpm install

# Start local services (Postgres, Redis, MinIO, MailHog)
docker-compose up -d

# Run database migrations
pnpm db:migrate

# Seed development data
pnpm db:seed

# Start development server
pnpm dev
```

### Local Services

| Service | Port | Purpose |
|---------|------|---------|
| PostgreSQL | 5432 | Database |
| Redis | 6379 | Queue/Cache |
| MinIO | 9000 | S3-compatible storage |
| MailHog | 8025 | Email capture |

---

## Repository Structure

```
newpopsys/
├── apps/
│   ├── web/              # Next.js web application
│   └── api/              # Fastify API service
├── packages/
│   ├── db/               # Drizzle schema & migrations
│   ├── shared/           # Shared types & utilities
│   └── ui/               # Shared UI components
├── workers/
│   └── jobs/             # BullMQ job processors
├── docker-compose.yml    # Local development services
└── turbo.json            # Monorepo configuration
```

---

## Technology Stack

| Layer | Technology | Documentation |
|-------|------------|---------------|
| Frontend | Next.js 14 (App Router) | [SUPP-012](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-012) |
| Backend | Fastify + TypeScript | [SUPP-012](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-012) |
| Database | PostgreSQL + Drizzle ORM | [SUPP-020](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-020) |
| Queue | BullMQ on Redis | [SUPP-027](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-027) |
| Storage | S3 (MinIO locally) | [SUPP-012](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-012) |
| Validation | Zod | [SUPP-020](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-020) |

---

## Core Concepts

### Domain Model

The system is organized around these core entities:

```
PSP (Tenant)
  └── Brand
       └── Store
            └── Campaign Assignment
                 └── Assignment Items
                      └── Photos / Proofs
```

### State Machines

Every major entity follows a defined state machine:

| Entity | States | Reference |
|--------|--------|-----------|
| Campaign | DRAFT → PUBLISHED → EXECUTING → COMPLETED | [SUPP-002](../SOW/02_SUPPs/Shared_Foundations/SUPP-002) |
| StoreAssignment | ASSIGNED → READY → IN_PROGRESS → SUBMITTED → COMPLETE | [Diagram](../SOW/05_Wireframes/diagrams/07-store-assignment-status.md) |
| Fulfillment | NOT_SHIPPED → SHIPPED → DELIVERED | [Diagram](../SOW/05_Wireframes/diagrams/02-fulfillment-status.md) |
| PhotoReview | PENDING → APPROVED/REJECTED → SUPERSEDED | [Diagram](../SOW/05_Wireframes/diagrams/11-photo-review-status.md) |

### Permissions (RBAC)

Permissions are role-based with hierarchical inheritance:

| Level | Roles |
|-------|-------|
| Platform | Platform Admin |
| PSP | PSP Admin, Production Operator |
| Brand | Brand Admin, Campaign Manager, Regional Manager |
| Store | Store Manager, Store Operator |

See [SUPP-003](../SOW/02_SUPPs/Shared_Foundations/SUPP-003) for the full permissions matrix.

---

## Development Workflow

### Branch Strategy

```
main (production)
  └── staging (pre-production)
       └── feature/* (development)
```

See [SUPP-022](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-022) for branching details.

### Feature Flags

Features under development use feature flags:

```typescript
if (await featureEnabled('PHOTO_RETAKE_V2', { tenantId })) {
  // New behavior
}
```

See [SUPP-023](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-023) for feature flag patterns.

### Testing

```bash
# Unit tests
pnpm test

# Integration tests
pnpm test:integration

# E2E tests (requires local services)
pnpm test:e2e
```

---

## API Development

### Endpoint Conventions

```
GET    /api/v1/campaigns           # List
POST   /api/v1/campaigns           # Create
GET    /api/v1/campaigns/:id       # Read
PATCH  /api/v1/campaigns/:id       # Update
DELETE /api/v1/campaigns/:id       # Delete
POST   /api/v1/campaigns/:id/publish  # Action
```

### Request Validation

All requests are validated with Zod schemas:

```typescript
const CreateCampaignSchema = z.object({
  name: z.string().min(1).max(255),
  brandId: z.string().uuid(),
  startDate: z.coerce.date(),
  endDate: z.coerce.date(),
});
```

### Response Format

```typescript
// Success
{
  data: { ... },
  meta: { timestamp, requestId }
}

// Error
{
  error: {
    code: "VALIDATION_ERROR",
    message: "...",
    details: [...]
  },
  meta: { timestamp, requestId }
}
```

---

## Background Jobs

Jobs are processed via BullMQ:

| Queue | Purpose | Reference |
|-------|---------|-----------|
| exports | CSV/Excel generation | [SUPP-005](../SOW/02_SUPPs/Shared_Foundations/SUPP-005) |
| webhooks | External notifications | [SUPP-027](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-027) |
| retention | Data cleanup | [SUPP-008](../SOW/02_SUPPs/Shared_Foundations/SUPP-008) |
| emails | Notification delivery | [SUPP-004](../SOW/02_SUPPs/Shared_Foundations/SUPP-004) |

---

## Observability

### Logging

```typescript
import { logger } from '@newpopsys/shared';

logger.info('Campaign published', {
  campaignId,
  storeCount,
  correlationId
});
```

### Tracing

OpenTelemetry traces are automatic for HTTP requests. Add custom spans:

```typescript
import { trace } from '@opentelemetry/api';

const span = trace.getActiveSpan();
span?.setAttribute('campaign.id', campaignId);
```

See [SUPP-029](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-029) for observability patterns.

---

## Key Documentation

| Document | Purpose |
|----------|---------|
| [Master SOW](../SOW/01_Main_SOW/MASTER_SOW_COMPILED.md) | Complete v1 specification |
| [SUPP-001](../SOW/02_SUPPs/Shared_Foundations/SUPP-001) | Personas & workflows |
| [SUPP-002](../SOW/02_SUPPs/Shared_Foundations/SUPP-002) | Domain model & state machines |
| [SUPP-012](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-012) | Technology selections |
| [SUPP-021](../SOW/02_SUPPs/Platform_Ops_Agent_Harness/SUPP-021) | Repo structure & CI |
| [Diagrams Index](../SOW/05_Wireframes/diagrams/index.md) | All architecture diagrams |

---

## Getting Help

1. Check the [SOW documentation](../SOW/) first
2. Review relevant SUPP documents
3. Check the decision log for past decisions
4. Ask in the team channel

---

*This guide provides quick-start information. For detailed specifications, consult the referenced SUPP documents.*
