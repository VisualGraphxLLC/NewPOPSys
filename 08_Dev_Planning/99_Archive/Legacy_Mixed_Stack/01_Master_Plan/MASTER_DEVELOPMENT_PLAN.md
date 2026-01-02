# Master Development Plan

## NewPOPSys v1.38 - PSP-led POP Campaign Orchestration Platform

---

## Executive Summary

NewPOPSys v1.38 represents a complete modernization of the POP (Point of Purchase) campaign management system, transitioning from the legacy Ninja platform to a PSP-led orchestration model. This document serves as the authoritative development plan, outlining budget allocation, timeline, technical architecture, and deliverables.

---

## Project Overview

| Attribute | Value |
|-----------|-------|
| **Project Name** | NewPOPSys v1.38 |
| **Project Type** | PSP-led POP Campaign Orchestration Platform |
| **Development Model** | AI-Assisted Agile Development |
| **Target Release** | Beta - End Q1 2026 |
| **Total Interfaces** | 81 (24 Primary + 6 Additional + 51 Modals) |

---

## Budget Allocation

### Total Budget: $150,000

| Category | Percentage | Amount | Description |
|----------|------------|--------|-------------|
| **Development** | 60% | $90,000 | Frontend, Backend, API, Integration |
| **Infrastructure** | 15% | $22,500 | Cloud hosting, CI/CD, DevOps |
| **Quality Assurance** | 10% | $15,000 | Testing, automation, UAT |
| **Design** | 10% | $15,000 | UI/UX, prototyping, design system |
| **Contingency** | 5% | $7,500 | Risk mitigation, scope changes |

### Budget Distribution by Sprint

| Sprint | Duration | Budget Allocation | Cumulative |
|--------|----------|-------------------|------------|
| S0 | 2 weeks | $18,000 (12%) | $18,000 |
| S1 | 2 weeks | $22,500 (15%) | $40,500 |
| S2 | 2 weeks | $27,000 (18%) | $67,500 |
| S3 | 2 weeks | $27,000 (18%) | $94,500 |
| S4 | 2 weeks | $27,000 (18%) | $121,500 |
| S5 | 2 weeks | $21,000 (14%) | $142,500 |
| S6 | 1 week | $7,500 (5%) | $150,000 |

---

## Timeline

### Project Duration: 13 Weeks to Beta (End Q1 2026)

```
Week 1-2   │ S0: Foundation & Setup
Week 3-4   │ S1: Authentication & Core UI
Week 5-6   │ S2: Mobile App Development
Week 7-8   │ S3: Brand Admin Portal
Week 9-10  │ S4: PSP Operations Center
Week 11-12 │ S5: Store Portal
Week 13    │ S6: Integration & Beta Launch
```

### Sprint Structure

| Sprint | Name | Duration | Start | End | Focus Area |
|--------|------|----------|-------|-----|------------|
| **S0** | Foundation | 2 weeks | Week 1 | Week 2 | Infrastructure, Architecture, Design System |
| **S1** | Auth & Core | 2 weeks | Week 3 | Week 4 | Authentication, Navigation, Core Components |
| **S2** | Mobile App | 2 weeks | Week 5 | Week 6 | PWA, Field Rep Features, Offline Support |
| **S3** | Brand Admin | 2 weeks | Week 7 | Week 8 | Campaign Management, Asset Library, Reporting |
| **S4** | PSP Ops | 2 weeks | Week 9 | Week 10 | Production Queue, Scheduling, Fulfillment |
| **S5** | Store Portal | 2 weeks | Week 11 | Week 12 | Store Management, Inventory, Requests |
| **S6** | Beta Launch | 1 week | Week 13 | Week 13 | Integration Testing, Deployment, Beta Release |

> **Cross-Reference:** See [Sprint Roadmap](../02_Sprint_Roadmap/) for detailed sprint breakdowns.

---

## Technology Stack

### Frontend Architecture

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Framework** | Next.js | 14+ | Full-stack React framework |
| **Language** | TypeScript | 5.x | Type-safe development |
| **State Management** | Context  | - | Built-in React state |
| **Styling** | Tailwind CSS | 3.x | Utility-first CSS framework |
| **Build Tool** | Turbo | Latest | Monorepo build system |
| **Monorepo** | Turborepo | Latest | Monorepo build system |

### Backend Architecture

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| **Runtime** | Node.js | 20.x LTS | Server-side JavaScript |
| **Framework** | Fastify | 4.x | High-performance HTTP framework |
| **ORM** | Drizzle ORM | Latest | Type-safe database queries |
| **Database** | PostgreSQL | 16.x | Primary data store |
| **Cache** | Redis | 7.x | Session management, caching |
| **Queue** | BullMQ | 5.x | Background job processing |

### Infrastructure

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Container** | Docker | Application containerization |
| **Orchestration** | Docker Compose | Local development orchestration |
| **CI/CD** | GitHub Actions | Automated testing and deployment |
| **CDN** | Cloudflare | Asset delivery, edge caching |
| **Monitoring** | Grafana + Loki | Observability and logging |

---

## Interface Inventory

### Total: 81 Interfaces

#### Primary Screens (24)

| Module | Count | Screens |
|--------|-------|---------|
| Mobile App | 8 | Dashboard, Campaign List, Task Detail, Photo Capture, Survey, Route, Profile, Sync |
| Brand Admin | 6 | Dashboard, Campaigns, Assets, Stores, Reports, Settings |
| PSP Operations | 6 | Queue, Schedule, Production, Shipping, Analytics, Config |
| Store Portal | 4 | Dashboard, Inventory, Requests, History |

#### Additional Screens (6)

| Screen | Purpose |
|--------|---------|
| Login | Universal authentication |
| Registration | User onboarding |
| Password Reset | Account recovery |
| Onboarding | First-time user flow |
| Help Center | Support documentation |
| Notifications | System alerts management |

#### Modal Components (51)

| Category | Count | Examples |
|----------|-------|----------|
| Form Modals | 18 | Create Campaign, Add Asset, New Store |
| Confirmation Dialogs | 12 | Delete, Submit, Approve, Reject |
| Detail Views | 10 | Campaign Detail, Task Detail, Order Detail |
| Selection Modals | 6 | Store Picker, Date Range, Filter Options |
| Media Modals | 5 | Image Preview, Gallery, Photo Annotation |

> **Cross-Reference:** See [Sprint Roadmap](../02_Sprint_Roadmap/) for interface delivery schedule.

---

## Quality Gates

### Code Quality Standards

| Metric | Target | Tool |
|--------|--------|------|
| Code Coverage | ≥ 80% | Jest + Vitest |
| Type Coverage | 100% | TypeScript strict mode |
| Lint Score | 0 errors | ESLint + Prettier |
| Bundle Size | < 200KB initial | Bundlesize |
| Lighthouse Score | ≥ 90 | Chrome DevTools |

### Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| First Contentful Paint | < 1.5s | Lighthouse |
| Time to Interactive | < 3.0s | Lighthouse |
| API Response Time | < 200ms (p95) | Application Monitoring |
| Database Query Time | < 50ms (p95) | Query Logging |

---

## Risk Management

### Identified Risks

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Scope creep | Medium | High | Strict change control, sprint boundaries |
| Technical debt | Medium | Medium | Code reviews, refactoring sprints |
| Integration delays | Low | High | Early API contracts, mock services |
| Resource availability | Low | Medium | Cross-training, documentation |
| Third-party dependencies | Low | Medium | Vendor evaluation, fallback options |

---

## Success Metrics

### Launch Criteria

- [ ] All 81 interfaces implemented and tested
- [ ] 80% code coverage achieved
- [ ] Zero critical/high severity bugs
- [ ] Performance targets met
- [ ] Security audit passed
- [ ] UAT sign-off received

### Post-Launch KPIs

| KPI | Target | Timeframe |
|-----|--------|-----------|
| User Adoption | 500 active users | 30 days post-launch |
| System Uptime | 99.5% | Monthly |
| User Satisfaction | ≥ 4.0/5.0 | Quarterly survey |
| Bug Resolution | < 24h critical | Ongoing |

---

## Document References

| Document | Location | Purpose |
|----------|----------|---------|
| Project Charter | [PROJECT_CHARTER.md](./PROJECT_CHARTER.md) | Executive summary and vision |
| Milestone Schedule | [MILESTONE_SCHEDULE.md](./MILESTONE_SCHEDULE.md) | High-level gates and dates |
| Resource Allocation | [RESOURCE_ALLOCATION.md](./RESOURCE_ALLOCATION.md) | Team structure and roles |
| Sprint Roadmap | [../02_Sprint_Roadmap/](../02_Sprint_Roadmap/) | Detailed sprint planning |

---

## Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Project Sponsor | | | |
| Technical Lead | | | |
| Product Owner | | | |
| QA Lead | | | |

---

*Last Updated: 2026-01-01*
