# Master Development Plan - NewPOPSys v1.38

> **Status**: Final
> **Author**: System Architect
> **Date**: 2026-01-02
> **Source**: SOW v1.38 & SRS v1.38

---

## 1. Executive Summary

NewPOPSys v1 is a pilot-grade platform (MPV) designed to manage Point-of-Purchase (POP) installation and verification for retail chains.

*   **Goal**: Replace legacy "PrecisionPOP" system with a scalable, modern architecture.
*   **Budget**: $150,000 (Fixed Bid).
*   **Timeline**: 13 Weeks (Target Beta: End Q1 2026).
*   **Key Deliverables**:
    1.  **Mobile PWA**: Field Rep execution (Offline-capable).
    2.  **Brand Portal**: Campaign management dashboard.
    3.  **PSP Portal**: Print & logistics operations.
    4.  **Store Portal**: Store manager visibility.

---

## 2. Technology Stack (Authoritative)

**All development must adhere strictly to this stack per SUPP-012.**

| Layer | Technology | Decision | Purpose |
|-------|------------|----------|---------|
| **Frontend** | **Next.js 14+** | App Router | PWA Scaffold, Web Portals, SSR. |
| **Language** | **TypeScript** | 5.3+ | Strict typing across full stack. |
| **Styling** | **Tailwind CSS** | 3.x | Utility-first styling. |
| **State** | **Context API** | - | Client state (No external libs). |
| **Backend** | **Fastify** | 4.x | High-performance API Service. |
| **Database** | **PostgreSQL** | 16 (RDS) | Primary System of Record. |
| **ORM** | **Drizzle** | Latest | SQL-like, type-safe queries. |
| **Async** | **Redis + BullMQ** | 7.x | Webhooks, Exports, Job Queues. |
| **Build** | **Turborepo** | Latest | Monorepo orchestration. |
| **Infra** | **AWS** | ECS/Fargate | Containerized hosting. |

> **Explicit Exclusions**:
> *   NO **Vite** (Next.js handles build).
> *   NO **Zustand** (Context API sufficient).
> *   NO **TanStack Query** (Use standard fetch/SWR pattern unless mandated).
> *   NO **Supabase** (Custom Auth + RDS).

---

## 3. Architecture Overview

### 3.1 Monorepo Structure (Turborepo)
```
apps/
  ├── mobile-pwa/    # Next.js (Field Reps)
  ├── brand-portal/  # Next.js (Brand Admins)
  ├── psp-portal/    # Next.js (Print/Ops)
  ├── store-portal/  # Next.js (Store Mgrs)
  └── api-server/    # Fastify (Core logic)
packages/
  ├── ui/            # Shared React components
  ├── database/      # Drizzle Schema & Migrations
  └── types/         # Shared Zod schemas/TS types
```

### 3.2 Key Flows
1.  **Campaign Management**: Brands define Campaigns (JSONB config in Postgres).
2.  **Logistics**: PSPs manage print queues and shipments (Integrated via Webhooks/Redis).
3.  **Execution**: Field Reps capture photos (PWA Offline Drafts -> Sync to Fastify).
4.  **Validation**: AI/Manual review of photos (Stored in S3).

---

## 4. Development Roadmap

| Sprint | Theme | Key Deliverables |
|--------|-------|------------------|
| **S0** | **Foundation** | Monorepo, Fastify Setup, Drizzle Schema, CI/CD. |
| **S1** | **Auth & Core** | JWT Auth, RBAC, Basic UI Shell (Next.js). |
| **S2** | **Mobile Core** | Field App PWA, Photo Capture, Offline Drafts. |
| **S3** | **Brand Portal** | Campaign Builder, Store Selection. |
| **S4** | **PSP Ops** | Order Queue, Shipping Integrations (BullMQ). |
| **S5** | **Integration** | Webhooks, Store Portal, Reporting. |
| **S6** | **Launch** | E2E Testing, Load Tests, Production Deploy. |

---

## 5. Budget & Resources

*   **Total Budget**: $150,000
    *   Development: $100,000
    *   Design/QA: $30,000
    *   Infrastructure/Ops: $20,000
*   **Team**: 2 Full Stack Devs, 1 QA/Lead.

---

*Last Updated: 2026-01-02*
