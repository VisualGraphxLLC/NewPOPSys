# Sprint S0: Foundation & Infrastructure

## Sprint Overview

| Attribute | Value |
|-----------|-------|
| **Sprint Number** | S0 |
| **Theme** | Foundation & Infrastructure |
| **Start Date** | 2026-01-06 |
| **End Date** | 2026-01-17 |
| **Duration** | 2 weeks (10 working days) |
| **Sprint Goal** | Establish the technical foundation that all subsequent development will build upon |

## Sprint Goals

1. Set up Turborepo monorepo structure with shared packages
2. Implement authentication foundation with Supabase
3. Configure PostgreSQL database with initial schema
4. Establish CI/CD pipelines with GitHub Actions
5. Configure development, staging, and production environments

---

## Task Breakdown

| Task ID | Description | Priority | Estimate | Assignee | Status |
|---------|-------------|----------|----------|----------|--------|
| S0-01 | Initialize Turborepo monorepo structure | Critical | 8h | TBD | Not Started |
| S0-02 | Configure shared TypeScript configuration | Critical | 4h | TBD | Not Started |
| S0-03 | Set up shared ESLint and Prettier configs | High | 4h | TBD | Not Started |
| S0-04 | Create shared UI component package structure | High | 8h | TBD | Not Started |
| S0-05 | Initialize Next.js app for Brand Portal | High | 4h | TBD | Not Started |
| S0-06 | Initialize Next.js app for PSP Portal | High | 4h | TBD | Not Started |
| S0-07 | Initialize Next.js app for Store Portal | High | 4h | TBD | Not Started |
| S0-08 | Initialize Next.js PWA for Field App | High | 8h | TBD | Not Started |
| S0-09 | Initialize Fastify API Server | Critical | 4h | TBD | Not Started |
| S0-10 | Implement JWT Auth in Fastify | Critical | 12h | TBD | Not Started |
| S0-11 | Design and implement Drizzle/Postgres initial schema | Critical | 16h | TBD | Not Started |
| S0-12 | Set up database migrations with Drizzle Kit | High | 8h | TBD | Not Started |
| S0-13 | Configure API Route Validation (Zod) | High | 8h | TBD | Not Started |
| S0-14 | Create seed data scripts | Medium | 4h | TBD | Not Started |
| S0-15 | Set up GitHub Actions CI pipeline | Critical | 8h | TBD | Not Started |
| S0-16 | Configure automated testing in CI | High | 8h | TBD | Not Started |
| S0-17 | Set up Vercel deployment for web apps | High | 4h | TBD | Not Started |
| S0-18 | Configure Docker Build for backend | High | 8h | TBD | Not Started |
| S0-19 | Set up development environment variables | High | 4h | TBD | Not Started |
| S0-20 | Configure staging environment | High | 4h | TBD | Not Started |
| S0-21 | Configure production environment | Medium | 4h | TBD | Not Started |
| S0-22 | Document local development setup | High | 4h | TBD | Not Started |
| S0-23 | Create architecture decision records (ADRs) | Medium | 4h | TBD | Not Started |
| S0-24 | Set up error monitoring (Sentry) | Medium | 4h | TBD | Not Started |
| S0-25 | Configure logging infrastructure | Medium | 4h | TBD | Not Started |

---

## Task Details

### S0-01: Initialize Turborepo Monorepo Structure

**Description:** Create the foundational Turborepo monorepo structure with proper workspace configuration.

**Technical Details:**
- Initialize Turborepo with pnpm workspaces
- Configure turbo.json with pipeline definitions
- Set up apps/ directory for web and mobile applications
- Set up packages/ directory for shared code
- Configure root package.json with workspace scripts

**Acceptance Criteria:**
- [ ] Turborepo initialized with proper configuration
- [ ] pnpm workspaces configured correctly
- [ ] Pipeline runs build, lint, and test across all packages
- [ ] Hot module reload works in development

---

### S0-09: Initialize Fastify API Server

**Description:** Initialize the Fastify backend service with proper plugin architecture.

**Technical Details:**
- Set up Fastify instance with TypeScript
- Configure standard plugins (cors, helmet, swagger)
- Set up Zod type provider
- Configure error handling and logging (pino)
- Establish Docker health check endpoints

**Acceptance Criteria:**
- [ ] Fastify server runs successfully
- [ ] Swagger documentation accessible at /documentation
- [ ] Zod validation working for simple route
- [ ] Docker container builds successfully

---

### S0-11: Design and Implement Drizzle/Postgres Initial Schema

**Description:** Create the initial database schema using Drizzle ORM code-first approach.

**Technical Details:**
- Users and Authentication tables (refresh tokens)
- Organizations (Tenants)
- Stores and Locations
- Campaigns and Assignments
- JSONB columns for flexible configuration

**Acceptance Criteria:**
- [ ] Schema defined in `src/db/schema.ts`
- [ ] Relations defined using Drizzle relations API
- [ ] Migrations generated via `drizzle-kit generate`
- [ ] Migrations applied successfully to local Postgres
- [ ] ERD matches architectural requirements

---

### S0-15: Set Up GitHub Actions CI Pipeline

**Description:** Implement continuous integration pipeline for automated testing and builds.

**Technical Details:**
- Trigger on push and pull request
- Matrix testing across Node versions
- Parallel execution of lint, type-check, and test
- Cache dependencies for faster builds
- Status checks required for merge

**Acceptance Criteria:**
- [ ] Pipeline triggers on all PRs
- [ ] All quality checks execute in parallel
- [ ] Build artifacts cached properly
- [ ] Average pipeline duration under 5 minutes
- [ ] Failed checks block PR merge

---

## Acceptance Criteria

### Sprint Completion Criteria

- [ ] All team members can clone repo and run locally in under 15 minutes
- [ ] CI pipeline passes on all commits to main branch
- [ ] Database migrations run successfully in all environments
- [ ] Authentication flow works end-to-end (signup, login, logout)
- [ ] All three web apps and mobile app build successfully
- [ ] Environment variables documented and secured
- [ ] Local development guide completed and tested

### Definition of Done

- [ ] Code reviewed and approved by at least one team member
- [ ] Unit tests written for new functionality
- [ ] No linting errors or warnings
- [ ] TypeScript strict mode passing
- [ ] Documentation updated
- [ ] Deployed to staging environment

---

## Dependencies

### External Dependencies

| Dependency | Source | Status | Risk |
|------------|--------|--------|------|
| Docker Hub | Docker | Available | Low |
| Vercel Account | Vercel | Available | Low |
| GitHub Repository | GitHub | Available | Low |
| Apple Developer | Apple | Available | Low |

### Incoming Dependencies

None - S0 is the foundation sprint.

### Outgoing Dependencies

| Blocked Task | Blocked Sprint | Impact |
|--------------|----------------|--------|
| S1-01 Universal Login | S1 | Critical - Auth required |
| S1-03 Core Layouts | S1 | Critical - Monorepo required |
| S1-04 Role-based Routing | S1 | High - Database required |

---

## Risks and Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Fastify plugin complexity | Low | Medium | Use established community plugins |
| Turborepo learning curve | Low | Medium | Team training session planned |
| Database schema changes | Medium | Medium | Design review with stakeholders |
| CI pipeline debugging | Medium | Low | Incremental pipeline development |

---

## Team Allocation

| Role | Team Member | Capacity | Focus Areas |
|------|-------------|----------|-------------|
| Tech Lead | TBD | 100% | Architecture, reviews |
| Backend Dev 1 | TBD | 100% | Database, Fastify API |
| Backend Dev 2 | TBD | 100% | CI/CD, environments |
| Frontend Dev | TBD | 50% | Monorepo, app setup |
| DevOps | TBD | 100% | Infrastructure, deployments |

---

## Sprint Ceremonies

| Ceremony | Date | Time | Duration |
|----------|------|------|----------|
| Sprint Planning | Jan 6, 2026 | 10:00 AM | 2 hours |
| Daily Standup | Daily | 9:00 AM | 15 minutes |
| Mid-Sprint Review | Jan 10, 2026 | 2:00 PM | 1 hour |
| Sprint Review | Jan 17, 2026 | 2:00 PM | 1 hour |
| Sprint Retrospective | Jan 17, 2026 | 3:30 PM | 1 hour |

---

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Setup time for new developer | < 15 minutes | Timed test |
| CI pipeline duration | < 5 minutes | GitHub Actions |
| Build success rate | 100% | CI metrics |
| Code coverage baseline | > 50% | Jest coverage |

---

## Notes

- Week 1 focus: Monorepo structure, API setup, database schema
- Week 2 focus: CI/CD, environments, documentation
- Daily syncs at 9 AM to unblock issues quickly
- Architecture decisions documented in ADRs

---

## Related Documents

- [Sprint Roadmap](../SPRINT_ROADMAP.md)
- [Sprint Calendar](../SPRINT_CALENDAR.md)
- [Dependency Map](../DEPENDENCY_MAP.md)

---

*Last Updated: 2026-01-01*
