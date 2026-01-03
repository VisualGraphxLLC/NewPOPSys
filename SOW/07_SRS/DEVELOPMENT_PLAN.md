# NewPOPSys v1 Development Plan

> **Document**: Master Development Plan
> **Version**: 1.0
> **Date**: 2025-12-30
> **Timeline**: 13 weeks to Beta (End Q1 2026)
> **Budget**: $150,000

---

## Executive Summary

NewPOPSys is a multi-tenant SaaS platform for Point-of-Purchase (POP) marketing campaign management, connecting Print Service Providers (PSPs), Brands, and Retail Stores. This Development Plan provides the complete roadmap for building the v1 Beta release within a 13-week accelerated timeline.

### Project Scope

| Dimension | Scope |
|-----------|-------|
| **Applications** | 4 platforms: Mobile PWA, Brand Admin Portal, Store Manager Portal, PSP Operations Portal |
| **Personas** | 9 user roles across 4 hierarchy levels (Platform, PSP, Brand, Store) |
| **Interfaces** | 81 total (24 primary screens + 6 additional + 51 modals) |
| **Database** | 45+ tables across 4 modules with full RBAC |
| **Integrations** | Email, S3 storage, webhook system, export engine |

### Key Deliverables

1. **Universal Login** - Single authentication for all portals with MFA and SSO support
2. **Mobile PWA** - Offline-capable store execution app with photo capture
3. **Brand Admin Portal** - Campaign management, verification, and analytics
4. **Store Manager Portal** - Team management and compliance monitoring
5. **PSP Operations Portal** - Order processing, shipments, and batch management
6. **API Layer** - RESTful API with OpenAPI documentation

---

## Document Index

This Development Plan references the following supporting documents:

### Core Planning Documents

| Document | Path | Description |
|----------|------|-------------|
| **Screen Inventory** | [SCREEN_INVENTORY.md](./SCREEN_INVENTORY.md) | Complete catalog of 81 interfaces |
| **Persona Maps** | [PERSONA_INTERACTION_MAPS.md](./PERSONA_INTERACTION_MAPS.md) | User journeys and workflows |
| **AI Dev Specs** | [AI_DEV_SPECS.md](./AI_DEV_SPECS.md) | Technical implementation specifications |

### Screen Specifications (25 files)

| Module | Screens | Path Pattern |
|--------|---------|--------------|
| Mobile App | M01-M08 | `../06_Screen_Specs/M0*.md` |
| Brand Admin | B01-B07 | `../06_Screen_Specs/B0*.md` |
| Store Portal | S01-S05 | `../06_Screen_Specs/S0*.md` |
| PSP Operations | P01-P03 | `../06_Screen_Specs/P0*.md` |
| Shared | L01 | `../06_Screen_Specs/L01_Universal_Login.md` |

### Database Schema (7 files)

| File | Description |
|------|-------------|
| `00_foundation_ddl.sql` | Core tables (tenants, users, roles) |
| `brand_module_ddl.sql` | Brand and campaign tables |
| `store_module_ddl.sql` | Store execution tables |
| `psp_module_ddl.sql` | Order and shipment tables |
| `12_missing_tables.sql` | Gap remediation |
| `13_missing_fields.sql` | Field additions |
| `14_survey_enhancements.sql` | Survey system updates |

### Requirements Documents (SUPPs)

| SUPP | Topic |
|------|-------|
| SUPP-001 | Persona Workflows & JTBD |
| SUPP-003 | RBAC & Permissions |
| SUPP-012 | Technology Selections |
| SUPP-016 | Orders, Shipments, Batches |
| SUPP-017 | Store Execution & Proof Capture |
| SUPP-018 | Verification & Photo Review |
| SUPP-019 | Issues, Reorders, Deinstall |

---

## Technology Stack

### Frontend
- **Framework**: React 18 + TypeScript
- **Styling**: Tailwind CSS + shadcn/ui
- **State**: Zustand (global) + TanStack Query (server)
- **Mobile**: PWA + Capacitor
- **Forms**: React Hook Form + Zod

### Backend
- **Runtime**: Node.js 20 LTS
- **Framework**: Fastify 4
- **ORM**: Drizzle ORM
- **Database**: PostgreSQL 15
- **Cache**: Redis 7
- **Storage**: S3-compatible (MinIO for dev)

### Infrastructure
- **Monorepo**: Turborepo
- **Containerization**: Docker Compose
- **CI/CD**: GitHub Actions
- **Hosting**: Docker-based deployment

---

## Sprint Structure

### Overview (13 Weeks)

```
Week 1-2   : S0 - Foundation & Infrastructure
Week 3-4   : S1 - Authentication & Core UI
Week 5-6   : S2 - Mobile App Core
Week 7-8   : S3 - Brand Admin Portal
Week 9-10  : S4 - PSP Operations Portal
Week 11-12 : S5 - Store Portal & Integration
Week 13    : S6 - Polish, Testing & Beta Launch
```

### Sprint S0: Foundation (Week 1-2)

**Theme**: Infrastructure, tooling, database schema

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Initialize Turborepo monorepo | Project structure | AI_DEV_SPECS.md §2 |
| Configure TypeScript, ESLint, Prettier | Build tooling | AI_DEV_SPECS.md §2 |
| Set up Drizzle ORM with PostgreSQL | Database layer | AI_DEV_SPECS.md §7 |
| Create foundation schema | Core tables | 00_foundation_ddl.sql |
| Create brand module schema | Campaign tables | brand_module_ddl.sql |
| Create store module schema | Execution tables | store_module_ddl.sql |
| Create PSP module schema | Order tables | psp_module_ddl.sql |
| Apply gap remediation | Missing tables/fields | 12_missing_tables.sql, 13_missing_fields.sql |
| Set up Docker Compose | Local development | AI_DEV_SPECS.md §10 |
| Configure Redis cache | Session storage | AI_DEV_SPECS.md §10 |
| Set up MinIO | File storage | AI_DEV_SPECS.md §10 |
| Seed development data | Test fixtures | seed_data_manifest.md |

**Acceptance Criteria**:
- [ ] `pnpm dev` starts all services
- [ ] Database migrations run cleanly
- [ ] Seed data loads successfully
- [ ] All packages build without errors

### Sprint S1: Authentication (Week 3-4)

**Theme**: Universal login, RBAC, session management

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Create shared UI package | Component library | AI_DEV_SPECS.md §8 |
| Build form components | Input, Select, Checkbox | SCREEN_INVENTORY.md §Forms |
| Create auth API endpoints | Login, logout, refresh | L01_Universal_Login.md |
| Implement JWT token system | Session management | AI_DEV_SPECS.md §4.1 |
| Build login screen UI | L01 interface | L01_Universal_Login.md |
| Add MFA support | TOTP verification | L01_Universal_Login.md |
| Implement password reset | Email flow | L01_Universal_Login.md |
| Create role-based routing | Dashboard routing | PERSONA_INTERACTION_MAPS.md §2 |
| Set up auth store | Zustand state | AI_DEV_SPECS.md §9 |
| Add rate limiting | Security middleware | L01_Universal_Login.md |

**Acceptance Criteria**:
- [ ] Users can log in with email/password
- [ ] MFA modal appears when enabled
- [ ] Users route to correct dashboard by role
- [ ] Sessions persist across refresh
- [ ] Rate limiting blocks brute force

### Sprint S2: Mobile App (Week 5-6)

**Theme**: Store execution PWA with offline support

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Configure PWA manifest | Service worker | AI_DEV_SPECS.md §5.1 |
| Build mobile shell | Navigation, offline indicator | M01_Login.md |
| Create home dashboard | M01 interface | M02_Dashboard.md |
| Build task list | M02 interface | M06_Tasks.md |
| Create campaign detail view | M03 interface | - |
| Build receive & verify flow | M04 interface | M03_Receipt_Survey.md |
| Create install capture | M05 interface | M04_Install_Survey.md, M05_Photo_Capture.md |
| Build photo gallery | M06 interface | - |
| Create issue request form | M07 interface | - |
| Build profile settings | M08 interface | M07_Profile.md |
| Implement offline sync queue | IndexedDB storage | AI_DEV_SPECS.md §5.1 |
| Add camera integration | Photo capture API | M05_Photo_Capture.md |

**Acceptance Criteria**:
- [ ] App installable as PWA
- [ ] Offline indicator shows connection status
- [ ] Tasks sync when online
- [ ] Photos upload with retry
- [ ] Surveys save locally when offline

### Sprint S3: Brand Admin (Week 7-8)

**Theme**: Campaign management and verification

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Build admin shell | Navigation, layout | B01_Dashboard.md |
| Create dashboard | B01 interface | B01_Dashboard.md |
| Build campaign list | B02 interface | B02_Campaign_List.md |
| Create campaign builder wizard | B03 interface | - |
| Build store selector | B04 interface | B03_Store_Selection.md |
| Create kit definition | B04.1 interface | B04_Kit_Definition.md |
| Build review queue | B05 interface | B07_Verification.md |
| Create store detail view | B06 interface | B06_Store_List.md |
| Build reports dashboard | B07 interface | - |
| Implement STRICT/FAST modes | Verification logic | SUPP-018 |
| Add photo rejection flow | Retake requests | M08_Retake.md |

**Acceptance Criteria**:
- [ ] Campaigns created and published
- [ ] Stores selected with filters
- [ ] Kits defined with photo rules
- [ ] Photos reviewed and approved/rejected
- [ ] Verification modes work correctly

### Sprint S4: PSP Operations (Week 9-10)

**Theme**: Order fulfillment and shipment management

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Build PSP shell | Navigation, layout | P01_Order_Queue.md |
| Create order queue | P01 interface | P01_Order_Queue.md |
| Build batch manager | P02 interface | - |
| Create shipment tracker | P03 interface | P02_Shipments.md |
| Build issue queue | P04 interface | P03_Issues.md |
| Create export center | P05 interface | - |
| Implement order status workflow | State machine | SUPP-016 |
| Add batch assignment | Bulk operations | SUPP-016 |
| Create partial shipment support | Split orders | SUPP-016 |
| Build tracking integration | Carrier updates | P02_Shipments.md |

**Acceptance Criteria**:
- [ ] Orders display with filters
- [ ] Batches created and managed
- [ ] Shipments created with tracking
- [ ] Partial shipments supported
- [ ] Exports generate correctly

### Sprint S5: Store Portal (Week 11-12)

**Theme**: Store management and integrations

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Build store portal shell | Navigation, layout | S01_Dashboard.md |
| Create store dashboard | S01 interface | S01_Dashboard.md |
| Build team management | S02 interface | S04_Team_Management.md |
| Create store analytics | S03 interface | S05_Reports.md |
| Build campaign history | S04 interface | S02_Campaign_History.md |
| Add notification system | Email, in-app | SUPP-027 |
| Create webhook system | Event delivery | SUPP-027 |
| Build export engine | CSV, Excel | SUPP-005 |
| Add audit logging | Activity trail | SUPP-029 |

**Acceptance Criteria**:
- [ ] Store managers see team members
- [ ] Analytics display correctly
- [ ] Campaign history searchable
- [ ] Notifications delivered
- [ ] Exports downloadable

### Sprint S6: Polish & Launch (Week 13)

**Theme**: Testing, fixes, documentation, beta deployment

| Task | Deliverable | Spec Reference |
|------|-------------|----------------|
| Integration testing | E2E test suite | AI_DEV_SPECS.md §10.4 |
| Performance optimization | Load testing | - |
| Security audit | Penetration testing | - |
| Bug fixes | Issue resolution | - |
| Documentation | API docs, user guides | - |
| Beta deployment | Production environment | AI_DEV_SPECS.md §10 |
| Seed beta users | Pilot PSP access | SUPP-001 |
| Monitoring setup | Alerts, dashboards | SUPP-029 |

**Acceptance Criteria**:
- [ ] All critical paths tested
- [ ] No P0/P1 bugs open
- [ ] API documentation complete
- [ ] Beta accessible to pilot PSPs
- [ ] Monitoring alerts configured

---

## Interface Summary

### Primary Screens (24)

| Module | Count | Screen IDs |
|--------|-------|------------|
| Mobile App | 8 | M01-M08 |
| Brand Admin | 7 | B01-B07 |
| Store Portal | 5 | S01-S05 |
| PSP Operations | 3 | P01-P03 |
| Shared | 1 | L01 |

### Additional Screens (6)

- B03.1 Campaign Builder Wizard
- B04.1 Kit Definition
- P04 Issue Queue
- P05 Export Center
- Settings (all portals)
- Help Center

### Modals (51)

| Category | Count |
|----------|-------|
| Mobile App | 16 |
| Brand Admin | 17 |
| Store Portal | 8 |
| PSP Operations | 10 |

See [SCREEN_INVENTORY.md](./SCREEN_INVENTORY.md) for complete modal catalog.

---

## Persona Access Matrix

| Screen | PA | PSP | PO | BA | CM | RM | SM | SO |
|--------|:--:|:---:|:--:|:--:|:--:|:--:|:--:|:--:|
| L01 Login | Y | Y | Y | Y | Y | Y | Y | Y |
| B01-B07 Brand | Y | Y | R | Y | A | R | - | - |
| S01-S05 Store | Y | Y | - | Y | R | Y | Y | R |
| P01-P05 PSP | Y | Y | Y | R | R | R | R | - |
| M01-M08 Mobile | - | - | - | - | - | - | Y | Y |

**Legend**: Y = Full Access | A = Assigned Only | R = Read Only | - = No Access

See [PERSONA_INTERACTION_MAPS.md](./PERSONA_INTERACTION_MAPS.md) for detailed permissions.

---

## Budget Allocation

### Cost Distribution ($150,000)

| Category | Allocation | Amount |
|----------|------------|--------|
| Development (AI-assisted) | 60% | $90,000 |
| Infrastructure & Hosting | 15% | $22,500 |
| Testing & QA | 10% | $15,000 |
| Design & UX | 10% | $15,000 |
| Contingency | 5% | $7,500 |

### AI Development Efficiency

The project leverages AI-assisted development to maximize velocity:

- **Code Generation**: ~70% of boilerplate code
- **Test Writing**: ~60% of unit tests
- **Documentation**: ~80% of technical docs
- **Review Assistance**: Bug detection and optimization

Expected efficiency gain: **2-3x** compared to traditional development.

---

## Risk Assessment

### Technical Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Offline sync complexity | High | Medium | Early prototype in S2 |
| Photo upload performance | Medium | Medium | Chunked uploads, retry logic |
| Multi-tenant data isolation | High | Low | Row-level security, testing |
| Mobile PWA limitations | Medium | Medium | Capacitor fallback for native features |

### Schedule Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Scope creep | High | High | Strict MVP definition, change control |
| Integration delays | Medium | Medium | Mock services, parallel development |
| Pilot PSP availability | Medium | Low | Early engagement, backup PSP |

### Mitigation Strategy

1. **Weekly stakeholder reviews** - Demo progress every Friday
2. **Feature flagging** - Deploy incomplete features behind flags
3. **Parallel workstreams** - Frontend/backend develop simultaneously
4. **Incremental delivery** - Ship working features continuously

---

## Quality Assurance

### Testing Strategy

| Level | Coverage Target | Tools |
|-------|-----------------|-------|
| Unit Tests | 80% | Vitest |
| Integration Tests | Critical paths | Playwright |
| E2E Tests | Happy paths | Playwright |
| Performance | P95 < 200ms | k6 |

### Acceptance Criteria

Each sprint must meet:
1. All tasks marked complete
2. Unit test coverage maintained
3. No P0/P1 bugs
4. Stakeholder demo approved
5. Documentation updated

---

## Deployment Strategy

### Environments

| Environment | Purpose | URL Pattern |
|-------------|---------|-------------|
| Local | Development | localhost:3000 |
| Staging | Integration testing | staging.newpopsys.com |
| Production | Beta release | app.newpopsys.com |

### CI/CD Pipeline

```
Push → Lint → Test → Build → Deploy Preview → Manual Promote → Production
```

### Release Process

1. Feature branches merge to `main`
2. Automatic staging deployment
3. QA validation on staging
4. Manual promotion to production
5. Feature flag enablement

---

## Communication Plan

### Stakeholder Updates

| Cadence | Meeting | Attendees |
|---------|---------|-----------|
| Daily | Standup | Dev team |
| Weekly | Demo | Stakeholders |
| Bi-weekly | Sprint review | All |
| Monthly | Steering | Executives |

### Channels

- **Slack**: #newpopsys-dev, #newpopsys-stakeholders
- **GitHub**: Issues, PRs, Discussions
- **Confluence**: Documentation, decisions

---

## Success Metrics

### Beta Launch Criteria

| Metric | Target |
|--------|--------|
| Screens implemented | 24/24 primary |
| API endpoints | 50+ |
| Test coverage | >80% |
| Performance | P95 < 200ms |
| Uptime | 99.5% |

### Pilot Success Criteria

| Metric | Target |
|--------|--------|
| Pilot PSPs onboarded | 2 |
| Campaigns executed | 5+ |
| Store executions | 100+ |
| Photo uploads | 1,000+ |
| User satisfaction | >4/5 |

---

## Getting Started

### For AI Development Assistants

1. **Read** [AI_DEV_SPECS.md](./AI_DEV_SPECS.md) for technical implementation details
2. **Reference** [SCREEN_INVENTORY.md](./SCREEN_INVENTORY.md) for interface requirements
3. **Understand** [PERSONA_INTERACTION_MAPS.md](./PERSONA_INTERACTION_MAPS.md) for user workflows
4. **Follow** screen specs in `../06_Screen_Specs/` for detailed requirements
5. **Implement** database schema from `../06_Database_Model/01_Schema/`

### Quick Start Commands

```bash
# Clone and setup
git clone <repo> newpopsys
cd newpopsys
pnpm install

# Start development
pnpm dev

# Run tests
pnpm test

# Build all packages
pnpm build
```

### Priority Implementation Order

1. **S0**: Database schema and project structure
2. **S1**: Auth system (L01 login screen)
3. **S2**: Mobile core (M01-M08 screens)
4. **S3**: Brand admin (B01-B07 screens)
5. **S4**: PSP operations (P01-P05 screens)
6. **S5**: Store portal (S01-S05 screens)
7. **S6**: Integration, testing, beta launch

---

## Appendices

### A. Wireframe Files

All interactive wireframes are located in `../05_Wireframes/`:

| File | Description |
|------|-------------|
| `index.html` | Wireframe navigation hub |
| `login.html` | L01 Universal Login |
| `mobile_*.html` | M01-M08 Mobile screens |
| `admin_*.html` | B01-B07 Brand Admin screens |
| `store_*.html` | S01-S05 Store Portal screens |
| `psp_*.html` | P01-P05 PSP Operations screens |

### B. Database ERD

Core relationships:

```
Tenant (1) ──< Brand (N) ──< Store (N) ──< StoreUser (N)
   │              │            │
   │              │            └──< StoreOrder (N) ──< OrderLineItem (N)
   │              │
   │              └──< Campaign (N) ──< Kit (N) ──< KitItem (N)
   │                      │
   │                      └──< Assignment (N) ──< Execution (N) ──< Photo (N)
   │
   └──< TenantUser (N) ──< Membership (N)
```

### C. API Endpoint Summary

| Module | Endpoints | Auth Required |
|--------|-----------|---------------|
| Auth | 9 | No (public) |
| Users | 12 | Yes |
| Campaigns | 15 | Yes |
| Stores | 10 | Yes |
| Orders | 12 | Yes |
| Shipments | 8 | Yes |
| Executions | 10 | Yes |
| Photos | 6 | Yes |
| Reports | 8 | Yes |

Total: ~90 API endpoints

### D. Glossary

| Term | Definition |
|------|------------|
| **PSP** | Print Service Provider - fulfillment partner |
| **POP** | Point of Purchase - retail marketing materials |
| **Kit** | Collection of POP items for a campaign |
| **Assignment** | Store's task to execute a campaign |
| **Execution** | Completed store task with proofs |
| **STRICT mode** | All photos require manual review |
| **FAST mode** | Auto-approve unless flagged |

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-30 | Initial Development Plan release |

---

*End of NewPOPSys v1 Development Plan*
