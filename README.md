# NewPOPSys — SOW Documentation

> **Version**: 1.38 (2026-01-03)
> **Status**: v1 Locked — Ready for Development
> **Beta Target**: End of Q1

PSP-Led Campaign Orchestration Platform — complete Statement of Work documentation for v1 implementation and future roadmap planning.

---

## Quick Start

| Document | Purpose |
|----------|---------|
| [Master SOW](01_Main_SOW/MASTER_SOW_COMPILED.md) | Complete compiled v1 specification |
| [SRS](07_SRS/COMPILED_SRS.md) | Software Requirements Specification |
| [Dev Guide](08_Dev_Planning/DEV_GUIDE_FULL.md) | Technical Implementation Guide |
| [Document Index](00_Index/00_DOC_INDEX.md) | Registry of all documents with versions |
| [Interactive Wireframes](05_Wireframes/index.html) | Visual prototypes for stakeholder review |
| [API Reference](06_API/README.md) | OpenAPI specification |
| [Post-v1 Vision](Post_v1/README.md) | Future roadmap (v2-v4) |

---

## Folder Structure

```
.
├── 00_Index/               # Document registry, framework, Q&A gates, glossary
├── 01_Main_SOW/            # Compiled Master SOW
├── 02_SUPPs/               # Supplemental Specifications (by module)
├── 03_Templates/           # SOW templates for agentic development
├── 04_Reference/           # Reference materials & legacy docs
├── 05_Wireframes/          # Interactive HTML prototypes
├── 06_API/                 # OpenAPI specification
├── 06_Database_Model/      # Schema, relationships, indexes, seed data
├── 06_Screen_Specs/        # Detailed screen specifications (M/B/P/S series)
├── 07_SRS/                 # Software Requirements Specification
├── 08_Dev_Planning/        # Development guides and technical specs
├── Post_v1/                # Future vision: v2-v4 roadmap & capabilities
├── Reports/                # Analysis & strategy reports
├── 99_Archive/             # Archived versions (ZIP)
└── VERSION.json            # Central version tracking
```

---

## v1 Document Modules

| Module | SUPPs | Description |
|--------|-------|-------------|
| **Shared Foundations** | 001-008 | Cross-cutting: personas, domain model, RBAC, notifications, webhooks |
| **Store Execution** | 011, 017 | Store-facing workflows: offline sync, proof capture |
| **Brand Admin** | 013-015, 033 | Campaign & store management: surveys, kits, assignment, export |
| **PSP Operations** | 016, 018-019 | Fulfillment workflows: orders, verification, issues |
| **Platform Ops** | 012, 020-035, 038-039 | Technical: CI/CD, observability, security, data model, accessibility |
| **Screens & Interfaces** | 036-037 | UI specifications and screen flows |

---

## Screen Specifications

| Series | Module | Screens |
|--------|--------|---------|
| **M** | Mobile Store App | M01-M08: Login, Dashboard, Surveys, Photo Capture, Tasks, Profile |
| **B** | Brand Admin | B01-B07: Dashboard, Campaigns, Store Selection, Kit Definition, Review; **B08-B09: Surveys & Layouts** |
| **P** | PSP Operations | P01-P03: Order Queue, Shipments; **A007: Global Templates** |
| **S** | Store Portal | S01-S05: Dashboard, Campaign History, Photos, Team, Reports; **S06-S07: Survey & Layout View** |

---

## Database Model

The [06_Database_Model](06_Database_Model/) folder contains complete PostgreSQL schema:
- **Foundation DDL**: Tenancy, identity, RBAC
- **Module DDLs**: PSP, Brand, Store modules
- **Relationships**: Foreign key constraints
- **Indexes**: Performance optimization
- **Seed Data**: Enums, system users, default tenant
- **Validation**: Entity crosswalk and coverage matrix

---

## Post-v1 Roadmap

The [Post_v1](Post_v1/) folder contains strategic planning for future releases:

| Version | Focus | Key Capabilities |
|---------|-------|------------------|
| **v2** | SaaS Evolution | Multi-PSP network, DAM, AI intelligence |
| **v3** | Design & Proofing | Online designer, proofing workflows |
| **v4** | Enterprise | MIS integration, white-label, marketplace |

---

## Key Links

- [SOW Framework](00_Index/SOW_FRAMEWORK.md) — Document development workflow
- [Stakeholder Q&A Gates](00_Index/STAKEHOLDER_QA_GATES.md) — Approval requirements
- [Q&A Session Log](00_Index/QA_SESSION_LOG.md) — Latest decisions and next steps
- [Glossary](00_Index/GLOSSARY.md) — Domain terminology
- [Process Flow Index](00_Index/PROCESS_FLOW_INDEX.md) — Workflow diagrams

---

## Versioning System

- **Stable Filenames**: SUPP files use consistent names (no version in filename)
- **Version Header**: Each file tracks its version internally (e.g., `> **Version**: v0.7`)
- **Changelog**: Each SUPP has a changelog section at the bottom
- **VERSION.json**: Central source for SOW release version
- **Git History**: All changes tracked automatically

---

## Platform Overview

NewPOPSys v1 is a modernized campaign orchestration platform that helps Print Service Providers (PSPs) manage POP campaigns from creation through store execution and verification.

**Core Workflow**:
1.  **PSP Definition**: PSP defines Master Survey Templates & Layouts (`MasterSurveyTemplate`).
2.  **Brand Adoption**: Brands inherit Masters to create their own Instances (`BrandSurveyTemplate`).
3.  **Digital Twin**: Brands map store layouts using a Grid Graphics Builder (spatial data).
4.  **Campaign Loop**: Campaign → Store Assignment → Fulfillment → Execution → Verification.

**User Personas**:
- PSP Level: Platform Admin, PSP Admin, Production Operator, Support Agent
- Brand Level: Brand Admin, Campaign Manager, Regional Manager
- Store Level: Store Manager, Store Operator
- System: Integration User

---

*NewPOPSys SOW Documentation | ServFlow Development*
