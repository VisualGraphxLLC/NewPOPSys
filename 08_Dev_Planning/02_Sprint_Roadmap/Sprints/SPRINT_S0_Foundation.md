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
| S0-08 | Initialize React Native/Expo mobile app | High | 8h | TBD | Not Started |
| S0-09 | Configure Supabase project and settings | Critical | 4h | TBD | Not Started |
| S0-10 | Implement Supabase authentication foundation | Critical | 12h | TBD | Not Started |
| S0-11 | Design and implement PostgreSQL initial schema | Critical | 16h | TBD | Not Started |
| S0-12 | Set up database migrations with Prisma | High | 8h | TBD | Not Started |
| S0-13 | Configure Row Level Security (RLS) policies | High | 8h | TBD | Not Started |
| S0-14 | Create seed data scripts | Medium | 4h | TBD | Not Started |
| S0-15 | Set up GitHub Actions CI pipeline | Critical | 8h | TBD | Not Started |
| S0-16 | Configure automated testing in CI | High | 8h | TBD | Not Started |
| S0-17 | Set up Vercel deployment for web apps | High | 4h | TBD | Not Started |
| S0-18 | Configure EAS Build for mobile app | High | 8h | TBD | Not Started |
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

### S0-09: Configure Supabase Project and Settings

**Description:** Set up Supabase project with proper configuration for authentication and database.

**Technical Details:**
- Create Supabase project in production region
- Configure authentication providers (Email, Google, Microsoft)
- Set up email templates for auth flows
- Configure storage buckets for file uploads
- Set up API rate limiting

**Acceptance Criteria:**
- [ ] Supabase project created and accessible
- [ ] Authentication providers configured
- [ ] Email templates customized
- [ ] Storage buckets created with proper policies
- [ ] API keys secured in environment variables

---

### S0-11: Design and Implement PostgreSQL Initial Schema

**Description:** Create the initial database schema supporting all core entities.

**Technical Details:**
- Users and authentication tables
- Organizations (brands, PSPs, stores)
- Campaigns and campaign assignments
- Store locations and details
- Initial indexes for query optimization

**Acceptance Criteria:**
- [ ] Schema supports all MVP entities
- [ ] Foreign key relationships properly defined
- [ ] Indexes created for common query patterns
- [ ] Schema documented in database diagram
- [ ] Migrations run successfully

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
| Supabase Account | Supabase | Available | Low |
| Vercel Account | Vercel | Available | Low |
| GitHub Repository | GitHub | Available | Low |
| Expo Account | Expo | Available | Low |

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
| Supabase configuration complexity | Medium | High | Early spike, documentation review |
| Turborepo learning curve | Low | Medium | Team training session planned |
| Database schema changes | Medium | Medium | Design review with stakeholders |
| CI pipeline debugging | Medium | Low | Incremental pipeline development |

---

## Team Allocation

| Role | Team Member | Capacity | Focus Areas |
|------|-------------|----------|-------------|
| Tech Lead | TBD | 100% | Architecture, reviews |
| Backend Dev 1 | TBD | 100% | Database, Supabase |
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

- Week 1 focus: Monorepo structure, Supabase, database schema
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
