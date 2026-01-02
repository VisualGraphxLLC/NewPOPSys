# Current Sprint: S0 Foundation

## Sprint Overview

| Field | Value |
|-------|-------|
| Sprint | S0 - Foundation |
| Status | **NOT STARTED** |
| Start Date | 2026-01-06 |
| End Date | 2026-01-17 |
| Duration | 2 weeks |
| Team Capacity | 40 SP |
| Committed | 29 SP |
| Completed | 0 SP |

---

## Sprint Goal

> Establish the core development infrastructure including Frappe environment, Docker configuration, ERPNext initialization, and CI/CD pipeline to enable rapid feature development in subsequent sprints.

---

## Sprint Board

### Backlog (Ready for Sprint)

| ID | Title | Priority | Estimate | Assignee |
|----|-------|----------|----------|----------|
| | | | | |

### To Do (WIP: 5)

| ID | Title | Priority | Estimate | Assignee |
|----|-------|----------|----------|----------|
| POP-001 | Initialize Turborepo Monorepo Structure | P0 | 3 SP | TBD |
| POP-002 | Configure Docker Infrastructure | P0 | 5 SP | TBD |
| POP-003 | Setup Fastify Backend & Drizzle ORM | P0 | 5 SP | TBD |
| POP-004 | Define Core Database Schema | P0 | 8 SP | TBD |
| POP-005 | Initialize Next.js Monorepo Apps | P1 | 8 SP | TBD |
| POP-006 | Setup CI/CD Pipeline | P1 | 3 SP | TBD |

### In Progress (WIP: 0)

| ID | Title | Priority | Estimate | Assignee | Started |
|----|-------|----------|----------|----------|---------|
| | | | | | |

### Review (WIP: 0)

| ID | Title | Priority | Estimate | Assignee | Reviewer |
|----|-------|----------|----------|----------|----------|
| | | | | | |

### Done

| ID | Title | Priority | Estimate | Completed |
|----|-------|----------|----------|-----------|
| | | | | |

---

## Sprint Backlog Details

### POP-001: Initialize Turborepo Monorepo Structure
**Priority**: P0 | **Estimate**: 3 SP | **Status**: To Do

**Description**: Initialize Turborepo with pnpm workspaces for the new custom architecture.

**Technical Details**:
- Apps: `mobile-pwa`, `brand-admin`, `psp-admin`, `store-portal`
- Packages: `ui`, `api-client`, `types`, `utils`
- Backend: `api-server` (Fastify)

**Acceptance Criteria**:
- [ ] Turborepo initialized
- [ ] Apps and packages directories created
- [ ] Build pipeline configured
- [ ] Shared Drizzle config setup

**Dependencies**: None

---

### POP-002: Configure Docker Infrastructure
**Priority**: P0 | **Estimate**: 5 SP | **Status**: To Do

**Description**: Setup Docker Compose for local development with Postgres, Redis, and API.

**Technical Details**:
- PostgreSQL 16 container
- Redis 7 container
- Adminer or PGAdmin (optional)
- Volume persistence

**Acceptance Criteria**:
- [ ] docker-compose.yml created
- [ ] Postgres connected and accessible
- [ ] Redis connected
- [ ] Environment variables configured (.env)

**Dependencies**: None

---

### POP-003: Setup Fastify Backend & Drizzle ORM
**Priority**: P0 | **Estimate**: 5 SP | **Status**: To Do

**Description**: Initialize the Fastify backend service with Drizzle ORM connection.

**Technical Details**:
- Fastify 4.x setup
- Drizzle ORM with Postgres
- Zod validation integration
- Swagger/OpenAPI setup

**Acceptance Criteria**:
- [ ] Fastify server starts
- [ ] Drizzle connects to Docker Postgres
- [ ] Health check endpoint works
- [ ] Migration script functional

**Dependencies**: POP-001, POP-002

---

### POP-004: Define Core Database Schema
**Priority**: P0 | **Estimate**: 8 SP | **Status**: To Do

**Description**: Implement initial Drizzle schema for Users, Auth, and Core entities.

**Technical Details**:
- Users table
- Auth/Session tables
- Organizations/Tenants
- Stores table

**Acceptance Criteria**:
- [ ] Schema defined in TypeScript
- [ ] Migrations generated
- [ ] Migrations applied successfully
- [ ] ERD generated or verified

**Dependencies**: POP-003

---

### POP-005: Initialize Next.js Monorepo Apps
**Priority**: P1 | **Estimate**: 8 SP | **Status**: To Do

**Description**: Initialize Next.js applications for Brand, PSP, and Store portals within the monorepo.

**Technical Details**:
- `apps/brand-portal` (Next.js 14+)
- `apps/psp-portal` (Next.js 14+)
- `apps/store-portal` (Next.js 14+)
- Configure shared UI package consumption

**Acceptance Criteria**:
- [ ] Apps initialized successfully
- [ ] Development servers run in parallel
- [ ] Shared components render in all apps
- [ ] Build pipeline succeeds for all apps

**Dependencies**: POP-001

---

### POP-006: Setup CI/CD Pipeline
**Priority**: P1 | **Estimate**: 3 SP | **Status**: To Do

**Description**: Configure GitHub Actions for linting, testing, and Docker build verification.

**Acceptance Criteria**:
- [ ] CI workflow created
- [ ] Lint/Type-check passes
- [ ] Unit tests execution
- [ ] Docker build verification

**Dependencies**: POP-001

---

## Daily Standup Notes

### Day 1 (2026-01-06)
- Sprint not yet started

### Day 2 (2026-01-07)
-

### Day 3 (2026-01-08)
-

### Day 4 (2026-01-09)
-

### Day 5 (2026-01-10)
-

### Day 6 (2026-01-13)
-

### Day 7 (2026-01-14)
-

### Day 8 (2026-01-15)
-

### Day 9 (2026-01-16)
-

### Day 10 (2026-01-17)
- Sprint Review & Retrospective

---

## Sprint Metrics

| Metric | Value |
|--------|-------|
| Total Story Points | 29 SP |
| Completed Points | 0 SP |
| Remaining Points | 29 SP |
| Sprint Progress | 0% |
| Burndown On Track | N/A |

---

## Blockers & Risks

| ID | Description | Impact | Owner | Status |
|----|-------------|--------|-------|--------|
| | | | | |

---

## Sprint Notes

- Sprint planning scheduled for 2026-01-06
- Daily standups at 9:00 AM
- Sprint review scheduled for 2026-01-17

---

*Last Updated: 2026-01-01*
