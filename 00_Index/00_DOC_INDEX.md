# NewPOPSys SOW Document Registry

> **Last Updated**: 2025-12-20
> **Master SOW Version**: v1.36
> **Total Documents**: 43+
> **All SUPPs**: Locked and ready for development
> **Next Step**: Generate OpenAPI spec, then initialize TypeScript multi-agent harness

---

## Quick Links

- [Compiled Master SOW](../01_Main_SOW/MASTER_SOW_COMPILED.md)
- [Interactive Wireframes](../05_Wireframes/index.html)
- [SOW Framework](./SOW_FRAMEWORK.md)
- [Stakeholder Q&A Gates](./STAKEHOLDER_QA_GATES.md)
- [Q&A Session Log (Next Steps)](./QA_SESSION_LOG.md) ← **Start here to continue**

---

## Document Hierarchy

```
NewPOPSys v1 Documentation
├── Master SOW (v1.36) ─────────────────────────────── Authority for scope, roadmap, acceptance
│   └── References all SUPPs as appendices
│
├── Context Documents ──────────────────────────────── Strategic direction, constraints
│   ├── Master Direction                            Why we're building this
│   ├── What It Will Never Be                       Scope guardrails (protected not-now)
│   ├── SaaS Evolution Strategy                     Future multi-tenant vision
│   └── Dev Starting Guide                          Developer onboarding
│
├── Shared Foundations (SUPP 001-008, 035) ────────── Cross-cutting concerns
│   ├── SUPP-001 Personas, Workflows, JTBD          ↓ All modules depend on this
│   ├── SUPP-002 Domain Model & State Machines      ↓ Schema foundation
│   ├── SUPP-003 RBAC & Permissions                 ↓ Auth/access rules
│   ├── SUPP-004 Notifications & Escalations        → SUPP-027
│   ├── SUPP-005 Exports & Reports                  → Brand Admin, PSP Ops
│   ├── SUPP-006 Webhooks & Inbound API
│   ├── SUPP-007 Completion & Overrides             → Store Execution
│   ├── SUPP-008 Data Retention Policy              → All modules
│   └── SUPP-035 Field-Level Data Model             ← SUPP-002 (complete schema)
│
├── Store Execution (SUPP 011, 017) ──────────────── Store-facing workflows
│   ├── SUPP-011 Offline & Sync Strategy
│   └── SUPP-017 Proof Capture                      ← SUPP-001, SUPP-003
│
├── Brand Admin (SUPP 013-015, 033) ──────────────── Campaign & store management
│   ├── SUPP-013 Stores, Regions, Groups
│   ├── SUPP-014 Survey Builder & Photo Rules       ◄ Supersedes SUPP-009
│   ├── SUPP-015 Campaigns, Kits, Assignment
│   └── SUPP-033 Brand Takeout Export
│
├── PSP Operations (SUPP 016, 018-019) ───────────── Fulfillment workflows
│   ├── SUPP-016 Orders, Shipments, Batches         ◄ Supersedes SUPP-010
│   ├── SUPP-018 Verification & Retake
│   └── SUPP-019 Issues, Reorders, Deinstall
│
├── Platform Ops (SUPP 012, 020-034) ───────────────  Technical implementation
│   ├── SUPP-012 Tech Selections ADR
│   ├── SUPP-020 Build Contracts & Schema           ← SUPP-002
│   ├── SUPP-021 Repo CI & Vertical Slice
│   ├── SUPP-022 Branching & Feature Flags
│   ├── SUPP-023 Feature Flags Data Model
│   ├── SUPP-024 Env Config & Secrets
│   ├── SUPP-025 Staging Seed & Testing
│   ├── SUPP-026 Local Dev Toolchain
│   ├── SUPP-027 Notifications Delivery             ← SUPP-004
│   ├── SUPP-029 Observability & Audit
│   ├── SUPP-030 Admin Ops Console
│   ├── SUPP-031 Supportability & Incidents
│   ├── SUPP-032 BreakGlass & Data Requests
│   └── SUPP-034 Rate Limits & Throttling
│
└── Screens & Interfaces (SUPP 036-037) ──────────── UI specifications
    ├── SUPP-036 Onboarding & Store Foundation
    ├── SUPP-037 SurveyBuilder & StoreSurveys
    └── Wireframes (HTML Interactive Prototypes)
```

---

## Superseded Documents

| Original SUPP | Title | Superseded By | Notes |
|---------------|-------|---------------|-------|
| SUPP-009 | Survey Builder and Photo Rules v0.3 | SUPP-014 v0.4 | Content merged into Brand Admin module |
| SUPP-010 | Fulfillment Shipments Batches Exports v0.3 | SUPP-016 v0.4 | Content merged into PSP Operations module |
| SUPP-028 | Webhook Security Event Envelope v0.1 | SUPP-006 v0.5 | Content merged into Webhooks SUPP |

---

## Current SUPP Index

**Note**: All SUPPs are now located in `02_SUPPs/` (DOCX files archived to `99_Archive_DOCX/`)

### Shared Foundations

| SUPP | Version | Status | Title | Path |
|------|---------|--------|-------|------|
| SUPP-001 | v0.2 | Locked | Persona Workflows JTBD Screens | `02_SUPPs/Shared_Foundations/` |
| SUPP-002 | v0.3 | Locked | Core Domain Model and State Machines | `02_SUPPs/Shared_Foundations/` |
| SUPP-003 | v0.5 | Locked | RBAC and Permissions Matrix | `02_SUPPs/Shared_Foundations/` |
| SUPP-004 | v0.4 | Locked | Notifications and Escalation Matrix | `02_SUPPs/Shared_Foundations/` |
| SUPP-005 | v0.3 | Locked | Exports Reports Output Contracts | `02_SUPPs/Shared_Foundations/` |
| SUPP-006 | v0.5 | Locked | Webhooks and Inbound API Event Contract | `02_SUPPs/Shared_Foundations/` |
| SUPP-007 | v0.4 | Locked | Completion Expiration Overrides | `02_SUPPs/Shared_Foundations/` |
| SUPP-008 | v0.4 | Locked | Data Retention Classification Policy | `02_SUPPs/Shared_Foundations/` |
| **SUPP-035** | **v1.0** | Locked | Field Level Data Model Tables Enums | `02_SUPPs/Platform_Ops_Agent_Harness/` |

### Store Execution Module

| SUPP | Version | Status | Title | Path |
|------|---------|--------|-------|------|
| SUPP-011 | v0.3 | Locked | Offline and Sync Strategy | `02_SUPPs/Store_Execution_Module/` |
| SUPP-017 | v0.3 | Locked | Store Execution Proof Capture | `02_SUPPs/Store_Execution_Module/` |

### Brand Admin Module

| SUPP | Version | Status | Title | Path |
|------|---------|--------|-------|------|
| SUPP-013 | v0.2 | Locked | Stores Regions Groups | `02_SUPPs/Brand_Admin_Module/` |
| SUPP-014 | v0.4 | Locked | Survey Builder Layout Photo Rules | `02_SUPPs/Brand_Admin_Module/` |
| SUPP-015 | v0.3 | Locked | Campaigns Kits Assignment | `02_SUPPs/Brand_Admin_Module/` |
| SUPP-033 | v0.1 | Locked | Brand Takeout Export Package Scaffold | `02_SUPPs/Brand_Admin_Module/` |

### PSP Operations Module

| SUPP | Version | Status | Title | Path |
|------|---------|--------|-------|------|
| SUPP-016 | v0.4 | Locked | Orders Shipments Batches PSP Ops | `02_SUPPs/PSP_Operations_Module/` |
| SUPP-018 | v0.3 | Locked | Verification Photo Review Retake | `02_SUPPs/PSP_Operations_Module/` |
| SUPP-019 | v0.3 | Locked | Issues Reorders Expiration Deinstall | `02_SUPPs/PSP_Operations_Module/` |

### Platform Ops / Agent Harness

| SUPP | Version | Status | Title | Path |
|------|---------|--------|-------|------|
| SUPP-012 | v0.2 | Locked | Technology Selections ADR | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-020 | v0.2 | Locked | Build Contracts and Physical Schema | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-021 | v0.1 | Locked | Repo CI and Vertical Slice Plan | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-022 | v0.1 | Locked | Branching FeatureFlags Release Workers | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-023 | v0.1 | Locked | Feature Flags Data Model and Admin UX | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-024 | v0.1 | Locked | Env Config Secrets Tenant Bootstrap | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-025 | v0.1 | Locked | Staging Seed Scale Plan Testing Targets | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-026 | v0.1 | Locked | Local Dev Staging Parity Toolchain | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-027 | v0.1 | Locked | Notifications Webhooks Deliverability | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-029 | v0.1 | Locked | Observability Tracing Logging Audit | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-030 | v0.2 | Locked | Admin Ops Console Minimum Screens | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-031 | v0.1 | Locked | Supportability Policies Impersonation | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-032 | v0.1 | Locked | BreakGlass Retention Safety Data Requests | `02_SUPPs/Platform_Ops_Agent_Harness/` |
| SUPP-034 | v0.1 | Locked | Rate Limits Upload Guards Throttle | `02_SUPPs/Platform_Ops_Agent_Harness/` |

### Screens & Interfaces

| SUPP | Version | Status | Title | Path |
|------|---------|--------|-------|------|
| **SUPP-036** | **v0.6** | Locked | Screens Onboarding and Store Foundation | `02_SUPPs/Screens_Interfaces/` |
| **SUPP-037** | **v1.0** | Locked | Screens SurveyBuilder and StoreSurveys | `02_SUPPs/Screens_Interfaces/` |
| Wireframes | v1.0 | Interactive | HTML Wireframe Suite | `05_Wireframes/index.html` |

---

## Context Documents

| Document | Purpose | Path |
|----------|---------|------|
| Master Direction | Strategic vision, customer model, core platform loop | `03_Context_Docs/` |
| What It Will Never Be | Explicit scope exclusions (protected not-now) | `03_Context_Docs/` |
| SaaS Evolution Strategy | Future multi-tenant brand-led vision | `03_Context_Docs/` |
| Dev Starting Guide | Developer onboarding | `03_Context_Docs/` |

---

## Reference Documents

| Document | Purpose | Path |
|----------|---------|------|
| PrecisionPOP Product Walkthrough | Analysis of legacy system | `04_Reference/` |
| Document Review Kickoff Plan | Kickoff process | `04_Reference/` |

---

## Folder Structure (Current)

```
SOW/
├── 00_Index/                   # Registry, framework, Q&A gates
├── 01_Main_SOW/                # Compiled Master SOW
├── 02_SUPPs/                   # ✅ ALL active SUPPs (Markdown)
│   ├── Shared_Foundations/
│   ├── Store_Execution_Module/
│   ├── Brand_Admin_Module/
│   ├── PSP_Operations_Module/
│   ├── Platform_Ops_Agent_Harness/
│   └── Screens_Interfaces/
├── 03_Context_Docs/            # Strategic direction
├── 04_Reference/               # Reference materials
├── 05_Wireframes/              # Interactive HTML prototypes
├── 99_Archive_DOCX/            # Archived DOCX originals
├── 99_Archive_MD_Converted/    # Old MD conversions (superseded)
└── 99_Archive_Superseded/      # Old versions
```

---

## Maintenance Protocol

### When Updating a SUPP
1. Edit the SUPP file in `02_SUPPs/[Module]/` (stable filename - no version in filename)
2. Bump the `Version` field in the file header
3. Add entry to the Changelog section at bottom of file
4. Update `VERSION.json` if releasing a new SOW version
5. Regenerate compiled Master SOW
6. Git history tracks all changes automatically

> **Note:** Version numbers are tracked in file headers and changelogs, not filenames.
> This ensures wireframe links never break when documents are updated.

### Status Definitions
| Status | Meaning |
|--------|---------|
| **Locked** | Approved for implementation, no changes without scope control |
| **In Review** | Content complete, awaiting stakeholder approval |
| **Draft** | Work in progress, not ready for review |
| **Superseded** | Replaced by another SUPP |

---

## Recent Updates (2025-12-20)

| Change | Description |
|--------|-------------|
| **Versioning System** | Switched to stable filenames - versions tracked in file headers and changelogs, not filenames |
| **VERSION.json** | Added central version file that wireframes read dynamically |
| **All SUPPs** | Added Changelog sections; filenames no longer include version |
| **Master SOW** | Renamed to `MASTER_SOW_COMPILED.md` (stable filename) |
| **Wireframe Links** | All links updated to use stable filenames - no more broken links |

### Previous Updates (2025-12-18)

| SUPP | Change |
|------|--------|
| SUPP-035 | v0.9 → **v1.0**: Added missing tables (kit_definitions, kit_items, location_slots, store_groups, audit_events, etc.), defined all enums |
| SUPP-036 | v0.5 → **v0.6**: Added full screen specs, wireframe references, component details |
| SUPP-037 | v0.9 → **v1.0**: Complete rewrite with survey builder, mobile flows, override policies |
| File Org | Consolidated all MD files to `02_SUPPs/`, archived DOCX to `99_Archive_DOCX/` |

---

*End of Document Registry*
