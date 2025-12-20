# NewPOPSys v1 — SOW Documentation

> **Version**: See [VERSION.json](VERSION.json) for current release
> **Status**: All SUPPs locked and ready for development

PSP-Led Campaign Orchestration Platform — complete Statement of Work documentation for v1 implementation.

---

## Quick Start

| Document | Purpose |
|----------|---------|
| [Master SOW](01_Main_SOW/MASTER_SOW_COMPILED.md) | Complete compiled specification |
| [Document Index](00_Index/00_DOC_INDEX.md) | Registry of all documents with versions |
| [Interactive Wireframes](05_Wireframes/index.html) | Visual prototypes for stakeholder review |

---

## Folder Structure

```
SOW/
├── 00_Index/               # Document registry, framework, Q&A gates
├── 01_Main_SOW/            # Compiled Master SOW
├── 02_SUPPs/               # Supplemental Specifications (by module)
│   ├── Shared_Foundations/
│   ├── Store_Execution_Module/
│   ├── Brand_Admin_Module/
│   ├── PSP_Operations_Module/
│   ├── Platform_Ops_Agent_Harness/
│   └── Screens_Interfaces/
├── 03_Context_Docs/        # Strategic direction, constraints
├── 04_Reference/           # Reference materials
├── 05_Wireframes/          # Interactive HTML prototypes
├── 99_Archive/             # Archived versions
└── VERSION.json            # Central version tracking
```

---

## Document Modules

| Module | SUPPs | Description |
|--------|-------|-------------|
| **Shared Foundations** | 001-008, 035 | Cross-cutting concerns: personas, domain model, RBAC, notifications |
| **Store Execution** | 011, 017 | Store-facing workflows: offline sync, proof capture |
| **Brand Admin** | 013-015, 033 | Campaign & store management: surveys, kits, assignment |
| **PSP Operations** | 016, 018-019 | Fulfillment workflows: orders, verification, issues |
| **Platform Ops** | 012, 020-034, 038 | Technical implementation: CI/CD, observability, security |
| **Screens & Interfaces** | 036-037 | UI specifications and screen flows |

---

## Versioning System

- **Stable Filenames**: SUPP files use consistent names (no version in filename)
- **Version Header**: Each file tracks its version internally (e.g., `> **Version**: v0.7`)
- **Changelog**: Each SUPP has a changelog section at the bottom
- **VERSION.json**: Central source for SOW release version
- **Git History**: All changes tracked automatically

This ensures wireframe links never break when documents are updated.

---

## Key Links

- [SOW Framework](00_Index/SOW_FRAMEWORK.md) — Document development workflow
- [Stakeholder Q&A Gates](00_Index/STAKEHOLDER_QA_GATES.md) — Approval requirements
- [Q&A Session Log](00_Index/QA_SESSION_LOG.md) — Latest decisions and next steps

---

## Platform Overview

NewPOPSys v1 is a modernized campaign orchestration platform that helps Print Service Providers (PSPs) manage POP campaigns from creation through store execution and verification.

**Core Loop**: Campaign → Store Assignment → PSP Fulfillment → Store Execution → Verification → Visibility

**User Personas**:
- PSP Level: Platform Admin, PSP Admin, Production Operator, Support Agent
- Brand Level: Brand Admin, Campaign Manager, Regional Manager
- Store Level: Store Manager, Store Operator
- System: Integration User

---

*NewPOPSys v1 SOW Documentation | ServFlow Development*
