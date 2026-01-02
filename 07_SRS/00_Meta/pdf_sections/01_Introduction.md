

---

# 1.1 Purpose

## Document Purpose

This Software Requirements Specification (SRS) document provides a comprehensive description of the NewPOPSys v1.38 platform, a PSP-led Point-of-Purchase (POP) Campaign Orchestration System. It serves as the definitive reference for all functional and non-functional requirements, system behaviors, and acceptance criteria for the v1 implementation.

## Intended Audience

| Audience | Usage |
|----------|-------|
| **Development Teams** | Primary implementation reference for building features, APIs, and user interfaces |
| **AI Development Agents** | Authoritative specification for agentic development workflows and autonomous code generation |
| **Quality Assurance** | Basis for test case development, acceptance criteria validation, and verification procedures |
| **Product Management** | Scope definition, feature prioritization, and stakeholder communication |
| **System Architects** | Technical design decisions, integration patterns, and infrastructure planning |
| **Operations Teams** | Deployment requirements, operational procedures, and support documentation |
| **Project Stakeholders** | Progress tracking, scope validation, and acceptance sign-off |

## Document Objectives

1. **Define Complete Scope**: Establish clear boundaries for v1 functionality, explicitly documenting what is included and what is deferred to future releases.

2. **Enable Agentic Development**: Provide structured, unambiguous specifications that support AI-assisted development with minimal human intervention.

3. **Establish Traceability**: Create direct links between requirements, source SOW documents, wireframes, and acceptance criteria.

4. **Support Verification**: Define measurable acceptance criteria and test scenarios for all functional requirements.

5. **Prevent Scope Creep**: Document protected "Not-Now" features and guardrails to maintain project discipline.

## Relationship to SOW Documentation

This SRS is derived from and complements the Statement of Work (SOW) documentation set:

| Document | Version | Relationship |
|----------|---------|--------------|
| Master SOW Compiled | v1.38 | Primary source of scope and requirements |
| SUPP-001 through SUPP-039 | Various | Detailed supplemental specifications |
| Screen Specifications | M/B/P/S Series | UI/UX requirements and wireframes |
| Database Model | DDL Files | Physical schema and data constraints |
| OpenAPI Specification | v1.0 | API contract definitions |

## Document Conventions

### Requirement Identifiers

All requirements use the following identifier format:

- **FR-XXX-NNN**: Functional Requirements (e.g., FR-CAM-001 for Campaign module)
- **NFR-XXX-NNN**: Non-Functional Requirements (e.g., NFR-SEC-001 for Security)
- **BR-XXX-NNN**: Business Rules (e.g., BR-VER-001 for Verification rules)
- **AC-XXX-NNN**: Acceptance Criteria (e.g., AC-CAM-001)

### Module Prefixes

| Prefix | Module |
|--------|--------|
| CAM | Campaign Management |
| STO | Store Management |
| ORD | Order/Fulfillment |
| EXE | Store Execution |
| VER | Verification |
| ISS | Issues/Reorders |
| EXP | Exports/Reports |
| INT | Integrations |
| SEC | Security/RBAC |
| PLT | Platform Operations |

### Priority Levels

| Priority | Definition |
|----------|------------|
| **P1 - Critical** | Core vertical slice functionality; must be complete for pilot |
| **P2 - Important** | Required for full pilot operation; can follow critical path |
| **P3 - Desired** | Enhances user experience; may be deferred if schedule requires |
| **P4 - Future** | Documented for future reference; explicitly out of v1 scope |

### Status Indicators

| Indicator | Meaning |
|-----------|---------|
| LOCKED | Requirement approved and frozen for implementation |
| IN_REVIEW | Under stakeholder review; implementation may proceed cautiously |
| DRAFT | Work in progress; not approved for implementation |
| DEFERRED | Explicitly moved to future release |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38*


---

# 1.2 Scope

## System Name

**NewPOPSys v1.38** - PSP-Led POP Campaign Orchestration Platform

## System Overview

NewPOPSys v1 is a modernized campaign orchestration platform that replaces spreadsheet-and-email workflows with an auditable, deterministic lifecycle. The platform enables Print Service Providers (PSPs) to coordinate POP (Point-of-Purchase) campaigns across Brands and Stores with full visibility and control.

### Core Platform Loop

```
Campaign → Store Assignment → PSP Fulfillment → Store Execution → Verification → Visibility
```

This loop represents the complete lifecycle of a POP campaign from creation through compliance verification.

## Included Functionality (v1 Scope)

### Module 1: Identity & RBAC
- Multi-tenant architecture with PSP as root tenant
- Brand management within PSP context
- User authentication (email/password)
- Role-based access control with 9 personas
- User invitations and membership management
- API key management for integrations
- Session management and security

### Module 2: Stores, Regions & Groups
- Store profile management (1,000+ stores per brand)
- Hierarchical geography (Region > District > Territory)
- Custom store grouping with include/exclude logic
- Store layout and location slot definitions
- External ID aliasing for brand integration

### Module 3: Survey Builder & Photo Rules
- Survey template creation with dynamic fields
- Survey versioning with immutable snapshots
- Photo rule configuration per location slot
- Reference image management
- Conditional logic and repeatable sections

### Module 4: Campaigns, Kits & Assignment
- Campaign creation (Promotional and Core Branding types)
- Kit definition with item specifications
- Store selection via selection recipes
- Assignment pinning with controlled rebase
- Campaign scheduling and lifecycle management

### Module 5: Orders, Shipments & PSP Operations
- Deterministic order generation on campaign publish
- Partial shipment support
- Batch tracking (PRODUCTION, PICK_PACK, SHIP_WAVE, CUSTOM)
- Multi-tracking number support
- PSP MIS integration points

### Module 6: Store Execution & Proof Capture
- Mobile-first web application (PWA scaffold)
- Best-effort offline with sync-on-open
- Receive/verify workflow
- Pre-install checklist completion
- Item installation tracking
- Proof photo capture per item/slot
- Completion survey with attestation

### Module 7: Verification & Retake Loop
- Photo review queue for Brand/Regional managers
- Approval/rejection with reason codes
- Retake request workflow
- STRICT and FAST verification modes
- Slot-level verification tracking

### Module 8: Issues, Reorders & Deinstall
- Issue reporting (Missing, Damaged, Incorrect, Packaging)
- Issue triage and approval workflow
- Reorder generation and tracking
- Campaign expiration handling
- Deinstall task management

### Module 9: Exports & Reports
- CSV/XLSX export generation
- PDF report generation
- JSON/XML data exports
- Async export processing with BullMQ
- Export artifact management

### Module 10: Integrations & Webhooks
- Signed webhook dispatch
- Inbound API with idempotency keys
- Event outbox pattern for reliability
- Retry scheduling with dead-letter queue
- PSP MIS integration scaffolding

### Module 11: Data Retention
- 90-day retention post campaign completion
- Export-before-delete workflow
- Automated purge jobs
- Asset registry for permanent definitions
- Audit event preservation

### Module 12: Offline & Sync Strategy
- PWA service worker scaffold
- Offline draft storage
- Sync-on-open submission queue
- Conflict resolution policies

## Excluded Functionality (Protected Not-Now)

The following are explicitly **out of scope** for v1 and protected from scope creep:

### Not an MIS/ERP
- No job costing or accounting
- No production scheduling
- No payroll integration
- No financial reporting

### Not a Marketplace
- No installer bidding/matchmaking
- No vendor marketplace
- No ratings/reviews system
- No dynamic pricing

### Not Analytics-Heavy
- No benchmarking dashboards
- No predictive analytics
- No AI insights surfaced to users
- Data readiness only (for future phases)

### Not Long-Term Storage
- No archival data warehouse
- No extended retention beyond 90 days
- Export pathways provided for data preservation

### Not Endlessly Customizable
- PSP adoption prioritized over store UX flexibility
- Store interface is execution-focused, not configurable

## Pilot Context

| Dimension | Target |
|-----------|--------|
| Pilot PSPs | 2 (Visual Graphx; Speedy CPS / Alpha Graphics) |
| Pilot Brands | 2-3 (Good2Go confirmed for Speedy/AG) |
| Stores per Brand | Up to 1,000 |
| Media Volume | >= 1 photo per item per location per campaign |
| Execution Platform | Web app first; PWA scaffold with offline drafts |
| Data Retention | 90 days post campaign completion |

## Success Criteria

A campaign can be:
1. Configured, published, and fulfilled without spreadsheets or manual reconciliation
2. Executed by stores with guided workflows and proof capture
3. Verified with approval/rejection/retake cycles
4. Exported with complete audit trail
5. Traced end-to-end using correlationId and audit logs
6. Automatically cleaned up per retention policy

## Scope Control

Any scope changes must:
1. Be formally requested through the Decision Log
2. Include tradeoff analysis (what gets deferred)
3. Receive stakeholder approval
4. Update affected SUPP documents
5. Regenerate this SRS with version bump

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Sections 2, 5, 6*


---

# 1.3 Definitions, Acronyms, and Abbreviations

## Abbreviations

| Abbreviation | Full Term |
|--------------|-----------|
| **API** | Application Programming Interface |
| **AWS** | Amazon Web Services |
| **BullMQ** | Queue library for Node.js based on Redis |
| **CI/CD** | Continuous Integration / Continuous Deployment |
| **CSV** | Comma-Separated Values |
| **DDL** | Data Definition Language |
| **E2E** | End-to-End (testing) |
| **ERD** | Entity Relationship Diagram |
| **HMAC** | Hash-based Message Authentication Code |
| **JSON** | JavaScript Object Notation |
| **JSONB** | JSON Binary (PostgreSQL data type) |
| **JTBD** | Jobs To Be Done (methodology) |
| **LTS** | Long-Term Support |
| **MIS** | Management Information System |
| **MMS** | Mermaid Markdown Syntax |
| **NFR** | Non-Functional Requirement |
| **ORM** | Object-Relational Mapping |
| **OTLP** | OpenTelemetry Protocol |
| **PK** | Primary Key |
| **POP** | Point of Purchase |
| **PSP** | Print Service Provider |
| **PWA** | Progressive Web App |
| **RBAC** | Role-Based Access Control |
| **REST** | Representational State Transfer |
| **S3** | Simple Storage Service (AWS) |
| **SDK** | Software Development Kit |
| **SKU** | Stock Keeping Unit |
| **SLA** | Service Level Agreement |
| **SOW** | Statement of Work |
| **SQL** | Structured Query Language |
| **SRS** | Software Requirements Specification |
| **SSO** | Single Sign-On |
| **SUPP** | Supplemental Specification |
| **TBD** | To Be Determined |
| **UI** | User Interface |
| **ULID** | Universally Unique Lexicographically Sortable Identifier |
| **UUID** | Universally Unique Identifier |
| **UX** | User Experience |
| **XLSX** | Excel Spreadsheet Format |
| **XML** | Extensible Markup Language |

## Domain Terminology

### Core Business Entities

| Term | Definition |
|------|------------|
| **PspTenant** | Root tenant representing a PSP organization. The paying customer. All brands, users, and data belong to a tenant. |
| **Brand** | A client brand managed by the PSP. Each brand has its own stores, campaigns, and settings. |
| **Store** | A physical retail location where POP materials are installed. |
| **Campaign** | A brand's promotional program with defined timeline, participating stores, and materials to install. |
| **Kit** | The collection of POP items to be shipped and installed for a campaign. |
| **KitItem** | A single item within a kit (e.g., "Window Cling 24x36", "Counter Card"). |

### Campaign Types

| Term | Definition |
|------|------------|
| **Promotional Campaign** | Campaign with defined end date that triggers deinstall workflow. Also called "Expiring Campaign". |
| **Core Branding Campaign** | Campaign with no end date. Deinstall only triggered manually. Also called "Non-expiring Campaign". |

### Geographic Hierarchy

| Term | Definition |
|------|------------|
| **Region** | Top level of geographic hierarchy (required). Examples: "West Coast", "Northeast". |
| **District** | Second level of geographic hierarchy (optional). Groups stores within a region. |
| **Territory** | Third level of geographic hierarchy (optional). Most granular geographic grouping. |
| **StoreGroup** | Custom, non-geographic grouping of stores. Used for targeting. A store can belong to multiple groups. |

### Survey & Layout

| Term | Definition |
|------|------------|
| **SurveyTemplate** | A reusable survey definition created by Brand Admin. Contains questions, sections, and logic. |
| **SurveyVersion** | An immutable snapshot of a SurveyTemplate. Campaigns pin to a specific version. |
| **StoreLayout** | Definition of a store's physical advertising locations. Versioned to support changes. |
| **LocationSlot** | A specific placement within a store where POP items can be installed. |
| **PhotoRule** | Requirements for proof photos at a location slot. Includes min/max photos, resolution, instructions. |

### Fulfillment

| Term | Definition |
|------|------------|
| **StoreOrder** | An order generated when a campaign is published, representing what PSP needs to produce and ship. |
| **OrderLine** | A line item in a StoreOrder specifying SKU and quantity. |
| **Shipment** | A physical shipment sent by PSP. An order may have multiple shipments (partial). |
| **ShipmentLine** | Items included in a specific shipment. Enables tracking partial fulfillment. |
| **Reorder** | A separate order generated to replace missing/damaged items. |
| **Batch** | PSP grouping of orders for production efficiency. Types: PRODUCTION, PICK_PACK, SHIP_WAVE, CUSTOM. |

### Execution & Verification

| Term | Definition |
|------|------------|
| **StoreAssignment** | The record binding a Store to a Campaign. Tracks progress through lifecycle. |
| **ReceiveVerification** | Store's confirmation that a shipment was received with item-level acceptance. |
| **CompletionSubmission** | Store's submission indicating installation is complete, including attestation. |
| **PhotoUpload** | A proof photo uploaded by the store, tied to an item and/or location slot. |
| **PhotoReview** | An admin's review decision on a photo (APPROVED/REJECTED with reason). |
| **RetakeRequest** | A request for the store to retake a rejected photo. |

### Issue Management

| Term | Definition |
|------|------------|
| **IssueRequest** | A store-reported problem (missing, damaged, incorrect items). |
| **IssueLine** | A specific item and quantity affected by an issue. |
| **IssueType** | Categories: MISSING, DAMAGED, INCORRECT, PACKAGING. |

### Workflow Terms

| Term | Definition |
|------|------------|
| **Campaign Publish** | Action that transitions campaign to active, generates assignments and orders. |
| **Receipt Survey** | First-stage store survey upon delivery. Confirms items received, reports issues. |
| **Install Survey** | Second-stage store survey. Captures proof photos of installed items. |
| **Completion Attestation** | Store user's checkbox confirmation that installation is complete. |
| **Retake Loop** | Workflow: rejected photos → RetakeRequest → new upload → review → repeat. |
| **Reorder Flow** | Issue approved → Reorder generated → PSP ships → Store receives. |
| **Deinstall Task** | End-of-campaign task where store removes expired POP materials. |
| **Waiver** | Administrative override marking requirement satisfied without proof. |
| **Reopen** | Admin action to unlock a COMPLETE store for additional work. |
| **Split Shipment** | Order fulfilled via multiple shipments. |

### Technical Terms

| Term | Definition |
|------|------------|
| **Rollup** | Aggregation of lower-level quantities to higher levels (Item → Store → Campaign). |
| **Pinning** | Freezing a specific version of survey/layout to a store assignment. |
| **Rebase** | Updating a pinned version to latest, with re-verification rules. |
| **Idempotency Key** | Unique identifier ensuring API request processed only once. |
| **Soft Delete** | Marking records as deleted without physical removal. |
| **Event Outbox** | Pattern for reliable webhook/event dispatch with retries. |

### Verification Modes

| Term | Definition |
|------|------------|
| **STRICT Mode** | Every photo requires explicit approval before store completion. |
| **FAST Mode** | Photos auto-approve unless flagged. Store completes immediately on submission. |

## User Roles (Personas)

### PSP Level

| Role | Definition |
|------|------------|
| **Platform Admin** | Highest privilege. Full system configuration, tenant management, user impersonation. |
| **PSP Admin** | Brand onboarding, PSP-level settings, user management, reporting and exports. |
| **Production Operator** | Updates order statuses, creates shipments and tracking, processes batches. |

### Brand Level

| Role | Definition |
|------|------------|
| **Brand Admin** | Full brand configuration, all campaigns access, store management, user permissions. |
| **Campaign Manager** | Brand Admin scoped to assigned campaigns only. |
| **Regional Manager** | Exception-first workflow. Reviews photos, handles escalations, scoped to region. |

### Store Level

| Role | Definition |
|------|------------|
| **Store Manager** | Store-level authority. Manages team, approves replacements, full execution permissions. |
| **Store Operator** | Execution-only permissions. Complete surveys, update status, request replacements. |

### System Level

| Role | Definition |
|------|------------|
| **Integration User** | Service account for API/webhook operations. No UI access. |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: GLOSSARY.md v1.2, SUPP-001 v0.3, SUPP-002 v0.5*


---

# 1.4 References

## Primary Source Documents

### Master SOW

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| MASTER_SOW_COMPILED.md | v1.38 | `SOW/01_Main_SOW/` | Complete compiled v1 specification with all SUPPs as appendices |

### Shared Foundations SUPPs

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| SUPP-001 | v0.3 | `SOW/02_SUPPs/Shared_Foundations/` | Persona Workflows, JTBD, Screens |
| SUPP-002 | v0.5 | `SOW/02_SUPPs/Shared_Foundations/` | Core Domain Model and State Machines |
| SUPP-003 | v0.7 | `SOW/02_SUPPs/Shared_Foundations/` | RBAC and Permissions Matrix |
| SUPP-004 | v0.5 | `SOW/02_SUPPs/Shared_Foundations/` | Notifications and Escalation Matrix |
| SUPP-005 | v0.3 | `SOW/02_SUPPs/Shared_Foundations/` | Exports, Reports, Output Contracts |
| SUPP-006 | v0.6 | `SOW/02_SUPPs/Shared_Foundations/` | Webhooks and Inbound API Event Contract |
| SUPP-007 | v0.4 | `SOW/02_SUPPs/Shared_Foundations/` | Completion Expiration Overrides |
| SUPP-008 | v0.4 | `SOW/02_SUPPs/Shared_Foundations/` | Data Retention Classification Policy (Option A) |

### Brand Admin Module SUPPs

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| SUPP-013 | v0.2 | `SOW/02_SUPPs/Brand_Admin_Module/` | Stores, Regions, Groups |
| SUPP-014 | v0.4 | `SOW/02_SUPPs/Brand_Admin_Module/` | Survey Builder, Layout, Photo Rules |
| SUPP-015 | v0.5 | `SOW/02_SUPPs/Brand_Admin_Module/` | Campaigns, Kits, Assignment |
| SUPP-033 | v0.1 | `SOW/02_SUPPs/Brand_Admin_Module/` | Brand Takeout Export Package Scaffold |

### PSP Operations Module SUPPs

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| SUPP-016 | v0.4 | `SOW/02_SUPPs/PSP_Operations_Module/` | Orders, Shipments, Batches, PSP Ops |
| SUPP-018 | v0.3 | `SOW/02_SUPPs/PSP_Operations_Module/` | Verification, Photo Review, Retake |
| SUPP-019 | v0.3 | `SOW/02_SUPPs/PSP_Operations_Module/` | Issues, Reorders, Expiration, Deinstall |

### Store Execution Module SUPPs

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| SUPP-011 | v0.3 | `SOW/02_SUPPs/Store_Execution_Module/` | Offline and Sync Strategy |
| SUPP-017 | v0.3 | `SOW/02_SUPPs/Store_Execution_Module/` | Store Execution, Proof Capture |

### Platform Ops Agent Harness SUPPs

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| SUPP-012 | v0.2 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Technology Selections ADR |
| SUPP-020 | v0.2 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Build Contracts and Physical Schema |
| SUPP-021 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Repo CI and Vertical Slice Plan |
| SUPP-022 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Branching, Feature Flags, Release Workers |
| SUPP-023 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Feature Flags Data Model and Admin UX |
| SUPP-024 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Env Config, Secrets, Tenant Bootstrap |
| SUPP-025 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Staging Seed Scale Plan and Testing Targets |
| SUPP-026 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Local Dev Staging Parity and Toolchain |
| SUPP-027 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Notifications, Webhooks, Deliverability |
| SUPP-029 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Observability, Tracing, Logging, Audit |
| SUPP-030 | v0.2 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Admin Ops Console Minimum Screens |
| SUPP-031 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Supportability, Impersonation, Incident |
| SUPP-032 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Break-Glass, Retention Safety, Data Requests |
| SUPP-034 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Rate Limits, Upload Guards, Throttling |
| SUPP-035 | v1.3 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Field Level Data Model, Tables, Fields, Enums |
| SUPP-038 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Section 508 Accessibility Scaffold |
| SUPP-039 | v0.1 | `SOW/02_SUPPs/Platform_Ops_Agent_Harness/` | Infrastructure, Performance, Security |

### Screens & Interfaces SUPPs

| Document | Version | Location | Description |
|----------|---------|----------|-------------|
| SUPP-036 | v0.6 | `SOW/02_SUPPs/Screens_Interfaces/` | Screens Onboarding and Store Foundation |
| SUPP-037 | v1.0 | `SOW/02_SUPPs/Screens_Interfaces/` | Survey Builder and Store Surveys |

## Technical Specifications

### Database Model

| Document | Location | Description |
|----------|----------|-------------|
| Foundation DDL | `SOW/06_Database_Model/01_Schema/` | Core schema (tenancy, identity, RBAC) |
| Module DDLs | `SOW/06_Database_Model/01_Schema/` | PSP, Brand, Store module schemas |
| Relationships | `SOW/06_Database_Model/02_Relationships/` | Foreign key constraints |
| Indexes | `SOW/06_Database_Model/04_Indexes/` | Performance optimization indexes |
| Seed Data | `SOW/06_Database_Model/05_Seed_Data/` | Enums, system users, default tenant |
| Validation | `SOW/06_Database_Model/07_Validation/` | Entity crosswalk and coverage matrix |

### API Specification

| Document | Location | Description |
|----------|----------|-------------|
| OpenAPI Specification | `SOW/06_API/openapi.yaml` | RESTful API contract definition |
| API README | `SOW/06_API/README.md` | API documentation and usage |

### Screen Specifications

| Series | Location | Description |
|--------|----------|-------------|
| M-Series (Mobile) | `SOW/06_Screen_Specs/` | M01-M08: Store mobile app screens |
| B-Series (Brand) | `SOW/06_Screen_Specs/` | B01-B07: Brand admin screens |
| P-Series (PSP) | `SOW/06_Screen_Specs/` | P01-P03: PSP operations screens |
| S-Series (Store Portal) | `SOW/06_Screen_Specs/` | S01-S05: Store portal screens |

## Design Resources

### Wireframes & Prototypes

| Resource | URL | Description |
|----------|-----|-------------|
| Axure Wireframes | https://qvcdv1.axshare.com/ | Interactive HTML prototypes |
| Adobe XD UI Standards | https://xd.adobe.com/view/a639299d-04e9-4f4c-bb70-c89b0d5c8cee-f36a/ | UI component library |
| Confluence Mind Map | https://servrx.atlassian.net/wiki/spaces/~5f07510d108462001583d6de/pages/14450692/Mind+Maps | System mind maps |

### Local Wireframes

| Location | Description |
|----------|-------------|
| `SOW/05_Wireframes/` | Interactive HTML prototypes (local copy) |
| `SOW/05_Wireframes/screenshots/` | Static screenshot captures |
| `SOW/05_Wireframes/diagrams/` | Mermaid state machine diagrams |

## Reference Documents

### Index & Framework

| Document | Location | Description |
|----------|----------|-------------|
| Document Index | `SOW/00_Index/00_DOC_INDEX.md` | Registry of all documents with versions |
| SOW Framework | `SOW/00_Index/SOW_FRAMEWORK.md` | Document development workflow |
| Glossary | `SOW/00_Index/GLOSSARY.md` | Domain terminology reference |
| Process Flow Index | `SOW/00_Index/PROCESS_FLOW_INDEX.md` | Workflow diagram index |
| Q&A Session Log | `SOW/00_Index/QA_SESSION_LOG.md` | Stakeholder decisions |

### Reference SRS

| Document | Location | Description |
|----------|----------|-------------|
| Ninja v2 SRS | `SOW/03_Templates/ninja_docx_extracted/` | Reference SRS with IEEE 830 structure |

### Legacy Reference

| Document | Location | Description |
|----------|----------|-------------|
| PrecisionPOP Legacy | `SOW/04_Reference/Legacy_PrecisionPOP/` | Legacy system documentation |

## External Standards

| Standard | Description | Relevance |
|----------|-------------|-----------|
| IEEE 830-1998 | Software Requirements Specification Standard | Document structure |
| OpenAPI 3.0 | REST API Specification Standard | API contract format |
| PostgreSQL 15 | Database reference documentation | Schema design |
| WCAG 2.1 AA | Web Content Accessibility Guidelines | Accessibility requirements |
| Section 508 | US Federal accessibility standards | Compliance requirements |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*


---

# 1.5 Document Overview

## SRS Structure

This Software Requirements Specification is organized into modular sections following IEEE 830 guidelines, adapted for agentic development workflows. Each section is maintained as separate Markdown files to enable parallel development and version control.

## Section Organization

### Section 1: Introduction
Establishes the purpose, scope, and context of the SRS document.

| File | Content |
|------|---------|
| 1.1_Purpose.md | Document objectives, audience, and conventions |
| 1.2_Scope.md | System boundaries, included/excluded functionality |
| 1.3_Definitions_Acronyms.md | Terminology and abbreviations |
| 1.4_References.md | Source documents and external references |
| 1.5_Document_Overview.md | This document structure guide |

### Section 2: Overall Description
Provides system context and high-level product information.

| File | Content |
|------|---------|
| 2.1_Product_Perspective.md | System context and external interfaces |
| 2.2_Product_Functions.md | Summary of major system capabilities |
| 2.3_User_Classes.md | Overview of user personas and characteristics |
| 2.4_Operating_Environment.md | Hardware, software, and network requirements |
| 2.5_Constraints.md | Design and implementation constraints |
| 2.6_Assumptions_Dependencies.md | Assumptions and external dependencies |
| diagrams/system_context.mmd | Mermaid context diagram |

### Section 3: System Architecture
Documents the technical architecture and data model.

| File | Content |
|------|---------|
| 3.1_Database_Model.md | Entity-relationship model and schema |
| 3.2_Application_Architecture.md | Component architecture and patterns |
| 3.3_Technology_Stack.md | Technology selections and rationale |
| 3.4_Integration_Architecture.md | External system integrations |
| diagrams/*.mmd | Mermaid ERD and architecture diagrams |

### Section 4: User Personas & RBAC
Defines user roles, permissions, and authentication flows.

| File | Content |
|------|---------|
| 4.1_Persona_Matrix.md | All personas with goals and needs |
| 4.2_Permission_Matrix.md | RBAC grid (persona x feature) |
| 4.3_Authentication_Flows.md | Login, session, security flows |
| personas/*.md | Detailed persona specifications |

### Sections 5-10: Module Specifications
Each module section contains screen-by-screen functional requirements.

| Section | Module | Screen Series |
|---------|--------|---------------|
| 05_Module_SharedFoundations | Login, Dashboard, Common | L-series |
| 06_Module_MobilePWA | Store Execution App | M-series |
| 07_Module_BrandAdmin | Brand Administration | B-series |
| 08_Module_PSPOperations | PSP Fulfillment | P-series |
| 09_Module_StorePortal | Store Web Portal | S-series |
| 10_Module_PlatformAdmin | System Administration | Admin screens |

Each module folder contains:
- `X.0_Module_Overview.md` - Module summary and navigation
- `screens/*.md` - Individual screen specifications

### Section 11: API Specifications
Documents all API contracts and integrations.

| File | Content |
|------|---------|
| 11.1_API_Overview.md | API design principles and patterns |
| 11.2_Internal_APIs.md | RESTful endpoint specifications |
| 11.3_External_Integrations.md | Third-party API integrations |
| 11.4_Webhooks.md | Webhook event contracts |
| schemas/*.json | JSON Schema definitions |

### Section 12: Non-Functional Requirements
Specifies quality attributes and constraints.

| File | Content |
|------|---------|
| 12.1_Performance.md | Response times, throughput, capacity |
| 12.2_Security.md | Authentication, authorization, data protection |
| 12.3_Accessibility.md | WCAG 2.1 AA and Section 508 compliance |
| 12.4_Scalability.md | Growth capacity and scaling strategies |
| 12.5_Availability.md | Uptime, redundancy, disaster recovery |
| 12.6_Data_Retention.md | Retention policies and data lifecycle |

### Section 99: Appendices
Supplementary reference materials.

| File | Content |
|------|---------|
| A_State_Machines.md | Campaign, Task, Compliance state diagrams |
| B_Notification_Matrix.md | Who gets notified when |
| C_Export_Formats.md | Report and export specifications |
| D_Glossary.md | Complete terminology reference |
| E_Change_Log.md | Document revision history |

## Screen Specification Template

Each screen document follows a consistent structure:

```markdown
# [Screen ID]: [Screen Name]

## 1. Overview
- Screen ID, Module, Primary Persona, SOW Reference

## 2. Wireframe
- Screenshot with link to source

## 3. Screen Description
- Functional description

## 4. User Access (RBAC)
- Persona access matrix with permissions

## 5. Data Model
- Primary entities and relationships (Mermaid ERD)

## 6. APIs
- Internal endpoints and external integrations

## 7. Business Rules
- BR-XXX numbered rules

## 8. State Transitions (if applicable)
- Mermaid state diagram

## 9. Acceptance Criteria
- AC-XXX numbered criteria
```

## Reading Guide

### For Developers

1. Start with **Section 3** (Architecture) to understand the technical foundation
2. Review **Section 4** (Personas/RBAC) for access control context
3. Navigate to the relevant **Module Section (5-10)** for feature implementation
4. Reference **Section 11** (APIs) for endpoint contracts
5. Consult **Section 12** (NFRs) for quality requirements

### For AI Development Agents

1. Read **1.1 Purpose** for document conventions and requirement formats
2. Use **1.3 Definitions** for domain vocabulary
3. Reference **1.4 References** to locate source documents
4. Navigate to specific module/screen files for implementation context
5. Cross-reference with SUPP documents for detailed specifications

### For QA Engineers

1. Review **1.2 Scope** for included/excluded functionality
2. Use **Module Sections (5-10)** for acceptance criteria per screen
3. Reference **Section 12** (NFRs) for quality attribute testing
4. Consult **Appendix A** (State Machines) for state transition testing

### For Product Managers

1. Start with **Section 2** (Overall Description) for product context
2. Review **Section 4** (Personas) for user needs alignment
3. Use **Module Sections (5-10)** for feature scope validation
4. Reference **1.2 Scope** for explicit exclusions

## Diagram Conventions

All diagrams use Mermaid syntax for portability:

| Diagram Type | Usage |
|--------------|-------|
| `flowchart` | Process flows and user journeys |
| `sequenceDiagram` | API and system interactions |
| `stateDiagram-v2` | Entity lifecycle states |
| `erDiagram` | Data model relationships |
| `graph` | Architecture components |

## Traceability

Each requirement traces back to source documentation:

```
SRS Requirement → SUPP Reference → Master SOW Section
     ↓
Screen Spec → Wireframe → API Contract
     ↓
Test Case → Acceptance Criteria
```

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*

