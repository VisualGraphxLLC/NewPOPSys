# Technology Stack Decisions (ADRs)

> **Status**: Authoritative
> **Source**: SUPP-012

---

## ADR-001: Next.js (App Router)
*   **Decision**: Use Next.js 14+ for all frontend applications (Mobile PWA, Brand, PSP, Store).
*   **Rationale**:
    *   Unified framework for SSR and Static generation.
    *   "PWA Scaffold" capability explicitly requested in SRS.
    *   Simplifies deployment via container or Vercel-like adapters.
*   **Consequences**: Strict adherence to App Router patterns (`app/` directory).

## ADR-002: Fastify (Backend)
*   **Decision**: Use Fastify 4.x for the dedicated API Service.
*   **Rationale**: 
    *   High performance (required for high-volume photo uploads).
    *   Schema-based validation (Zod/JSON Schema) native support.
*   **Consequences**: Separate `apps/api-server` deployment from Next.js frontends.

## ADR-003: Drizzle ORM
*   **Decision**: Use Drizzle ORM with PostgreSQL.
*   **Rationale**:
    *   Type-safety with low runtime overhead.
    *   Control over SQL queries (critical for complex Campaign targeting logic).
    *   JSONB support for Survey Schemas.

## ADR-004: Redis + BullMQ
*   **Decision**: Use Redis 7.x and BullMQ for async operations.
*   **Rationale**: SRS Mandates "Outbox pattern" and "Reliable Webhooks".
*   **Use Cases**:
    *   Webhook delivery retries.
    *   Large Export generation (PDF/CSV).
    *   Photo Processing/AI Validation jobs.

## ADR-005: Turborepo
*   **Decision**: Use Turborepo for Monorepo management.
*   **Rationale**:
    *   Efficient caching of builds.
    *   Dependency management for shared packages (`ui`, `database`).

## ADR-006: Authentication Strategy
*   **Decision**: 
    *   **Web**: Server-side Session Cookies (`fastify-secure-session` + `httpOnly`).
    *   **Integrations**: API Keys + HMAC (for Webhooks).
*   **Rationale**:
    *   Cookies provide superior security/UX for browser apps (vs JWT in localStorage).
    *   API Keys simpler for 3rd party integrations (PSP/Shipping).
*   **Source**: SRS Section 3.3.3.2.

## ADR-007: TanStack Query
*   **Decision**: Use TanStack Query (React Query) v5 for client-side data fetching and caching.
*   **Rationale**:
    *   Mandated by SRS Section 3.2 (Application Architecture).
    *   Handles loading/error states, caching, and optimistic updates effectively.
    *   Reduces boilerplate `useEffect` fetching code.
*   **Consequences**: All API data fetching in Client Components must use `useQuery`/`useMutation`.

---

*Verified against SRS v1.38*
