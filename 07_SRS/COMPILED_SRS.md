# NewPOPSys Software Requirements Specification

**Version:** 1.38
**Date:** 2026-01-01
**Status:** Final Draft
**Classification:** Internal - Confidential

---


---

# Executive Summary


## Project Overview

NewPOPSys is a multi-tenant Point of Purchase (POP) campaign management platform designed to enable brands to create, distribute, and verify in-store marketing materials across retail networks. The system provides end-to-end workflow management from campaign design through production fulfillment, integrating seamlessly with Print Service Providers (PSPs) to automate production queues and delivery tracking. By digitizing the traditionally manual POP process, NewPOPSys reduces time-to-market, improves compliance verification, and provides actionable analytics on campaign performance.

## Key Deliverables


## Scope Summary

- **6** application modules
- **35+** screen specifications
- **9** user personas with role-based access control (RBAC)
- **4** external integrations (PSP systems, authentication, storage, notifications)

## Technology Stack


## Risk Summary


## Approval

```
APPROVED BY:

_________________________    _______________
[Name], CIO                  Date


_________________________    _______________
[Name], VP Engineering       Date


_________________________    _______________
[Name], Product Owner        Date
```

*This document serves as the authoritative Software Requirements Specification for the NewPOPSys platform.*


---

# Table of Contents

## Front Matter
- [Executive Summary](./00_Executive_Summary.md)
- [Table of Contents](./00_Table_of_Contents.md)

## Section 1: Introduction
- [1.1 Purpose](./01_Introduction/1.1_Purpose.md)
- [1.2 Scope](./01_Introduction/1.2_Scope.md)
- [1.3 Definitions & Acronyms](./01_Introduction/1.3_Definitions_Acronyms.md)
- [1.4 References](./01_Introduction/1.4_References.md)
- [1.5 Document Overview](./01_Introduction/1.5_Document_Overview.md)

## Section 2: Overall Description
- [2.1 Product Perspective](./02_Overall_Description/2.1_Product_Perspective.md)
- [2.2 Product Functions](./02_Overall_Description/2.2_Product_Functions.md)
- [2.3 User Classes](./02_Overall_Description/2.3_User_Classes.md)
- [2.4 Operating Environment](./02_Overall_Description/2.4_Operating_Environment.md)
- [2.5 Constraints](./02_Overall_Description/2.5_Constraints.md)
- [2.6 Assumptions & Dependencies](./02_Overall_Description/2.6_Assumptions_Dependencies.md)

## Section 3: System Architecture
- [3.1 Database Model](./03_System_Architecture/3.1_Database_Model.md)
- [3.2 Application Architecture](./03_System_Architecture/3.2_Application_Architecture.md)
- [3.3 Technology Stack](./03_System_Architecture/3.3_Technology_Stack.md)
- [3.4 Integration Architecture](./03_System_Architecture/3.4_Integration_Architecture.md)

## Section 4: User Personas & RBAC
- [4.1 Persona Matrix](./04_User_Personas_RBAC/4.1_Persona_Matrix.md)
- [4.2 Permission Matrix](./04_User_Personas_RBAC/4.2_Permission_Matrix.md)
- [4.3 Authentication Flows](./04_User_Personas_RBAC/4.3_Authentication_Flows.md)
- [P01 Platform Administrator](./04_User_Personas_RBAC/personas/P01_Platform_Administrator.md)
- [P02 Brand Manager](./04_User_Personas_RBAC/personas/P02_Brand_Manager.md)
- [P03 Brand Coordinator](./04_User_Personas_RBAC/personas/P03_Brand_Coordinator.md)
- [P04 Regional Manager](./04_User_Personas_RBAC/personas/P04_Regional_Manager.md)
- [P05 Store Manager](./04_User_Personas_RBAC/personas/P05_Store_Manager.md)
- [P06 Store Operator](./04_User_Personas_RBAC/personas/P06_Store_Operator.md)
- [P07 PSP Admin](./04_User_Personas_RBAC/personas/P07_PSP_Admin.md)
- [P08 PSP Operator](./04_User_Personas_RBAC/personas/P08_PSP_Operator.md)
- [P09 Read-Only Viewer](./04_User_Personas_RBAC/personas/P09_ReadOnly_Viewer.md)

## Section 5: Module - Shared Foundations
- [Module Overview](./05_Module_SharedFoundations/01_Module_Overview.md)
- [L001 Universal Login](./05_Module_SharedFoundations/screens/L001_Universal_Login.md)
- [L002 Universal Dashboard](./05_Module_SharedFoundations/screens/L002_Universal_Dashboard.md)

## Section 6: Module - Mobile PWA
- [Module Overview](./06_Module_MobilePWA/01_Module_Overview.md)
- [M001 Mobile Dashboard](./06_Module_MobilePWA/screens/M001_Mobile_Dashboard.md)
- [M002 Survey List](./06_Module_MobilePWA/screens/M002_Survey_List.md)
- [M003 Survey Execution](./06_Module_MobilePWA/screens/M003_Survey_Execution.md)
- [M004 Photo Capture](./06_Module_MobilePWA/screens/M004_Photo_Capture.md)
- [M005 Campaign Materials](./06_Module_MobilePWA/screens/M005_Campaign_Materials.md)
- [M006 Notifications](./06_Module_MobilePWA/screens/M006_Notifications.md)
- [M007 Store Profile](./06_Module_MobilePWA/screens/M007_Store_Profile.md)
- [M008 Offline Mode](./06_Module_MobilePWA/screens/M008_Offline_Mode.md)

## Section 7: Module - Brand Admin
- [Module Overview](./07_Module_BrandAdmin/01_Module_Overview.md)
- [B001 Brand Dashboard](./07_Module_BrandAdmin/screens/B001_Brand_Dashboard.md)
- [B002 Campaign Management](./07_Module_BrandAdmin/screens/B002_Campaign_Management.md)
- [B003 Campaign Builder](./07_Module_BrandAdmin/screens/B003_Campaign_Builder.md)
- [B004 Survey Builder](./07_Module_BrandAdmin/screens/B004_Survey_Builder.md)
- [B005 Store Network](./07_Module_BrandAdmin/screens/B005_Store_Network.md)
- [B006 Analytics](./07_Module_BrandAdmin/screens/B006_Analytics.md)
- [B007 Asset Library](./07_Module_BrandAdmin/screens/B007_Asset_Library.md)

## Section 8: Module - PSP Operations
- [Module Overview](./08_Module_PSPOperations/01_Module_Overview.md)
- [P001 PSP Dashboard](./08_Module_PSPOperations/screens/P001_PSP_Dashboard.md)
- [P002 Production Queue](./08_Module_PSPOperations/screens/P002_Production_Queue.md)
- [P003 Fulfillment Tracking](./08_Module_PSPOperations/screens/P003_Fulfillment_Tracking.md)

## Section 9: Module - Store Portal
- [Module Overview](./09_Module_StorePortal/01_Module_Overview.md)
- [S001 Store Dashboard](./09_Module_StorePortal/screens/S001_Store_Dashboard.md)
- [S002 Store Management](./09_Module_StorePortal/screens/S002_Store_Management.md)
- [S003 User Management](./09_Module_StorePortal/screens/S003_User_Management.md)
- [S004 Compliance Reports](./09_Module_StorePortal/screens/S004_Compliance_Reports.md)
- [S005 Regional Overview](./09_Module_StorePortal/screens/S005_Regional_Overview.md)

## Section 10: Module - Platform Admin
- [Module Overview](./10_Module_PlatformAdmin/01_Module_Overview.md)
- [A001 Admin Dashboard](./10_Module_PlatformAdmin/screens/A001_Admin_Dashboard.md)
- [A002 Tenant Management](./10_Module_PlatformAdmin/screens/A002_Tenant_Management.md)
- [A003 User Administration](./10_Module_PlatformAdmin/screens/A003_User_Administration.md)
- [A004 System Configuration](./10_Module_PlatformAdmin/screens/A004_System_Configuration.md)
- [A005 Audit Logs](./10_Module_PlatformAdmin/screens/A005_Audit_Logs.md)
- [A006 Integration Management](./10_Module_PlatformAdmin/screens/A006_Integration_Management.md)

## Section 11: API Specifications
- [11.1 API Overview](./11_API_Specifications/11.1_API_Overview.md)
- [11.2 Internal APIs](./11_API_Specifications/11.2_Internal_APIs.md)
- [11.3 External Integrations](./11_API_Specifications/11.3_External_Integrations.md)
- [11.4 Webhooks](./11_API_Specifications/11.4_Webhooks.md)

## Section 12: Non-Functional Requirements
- [12.1 Performance](./12_Non_Functional_Requirements/12.1_Performance.md)
- [12.2 Security](./12_Non_Functional_Requirements/12.2_Security.md)
- [12.3 Accessibility](./12_Non_Functional_Requirements/12.3_Accessibility.md)
- [12.4 Scalability](./12_Non_Functional_Requirements/12.4_Scalability.md)
- [12.5 Availability](./12_Non_Functional_Requirements/12.5_Availability.md)
- [12.6 Data Retention](./12_Non_Functional_Requirements/12.6_Data_Retention.md)

## Appendices
- [A: State Machines](./99_Appendices/A_State_Machines.md)
- [B: Notification Matrix](./99_Appendices/B_Notification_Matrix.md)
- [C: Export Formats](./99_Appendices/C_Export_Formats.md)
- [D: Glossary](./99_Appendices/D_Glossary.md)
- [E: Change Log](./99_Appendices/E_Change_Log.md)

*NewPOPSys SRS v1.38 | 2026-01-01*


---

# Section 1: Introduction
# 1.1 Purpose

## Document Purpose

This Software Requirements Specification (SRS) document provides a comprehensive description of the NewPOPSys v1.38 platform, a PSP-led Point-of-Purchase (POP) Campaign Orchestration System. It serves as the definitive reference for all functional and non-functional requirements, system behaviors, and acceptance criteria for the v1 implementation.

## Intended Audience


## Document Objectives

1. **Define Complete Scope**: Establish clear boundaries for v1 functionality, explicitly documenting what is included and what is deferred to future releases.

2. **Enable Agentic Development**: Provide structured, unambiguous specifications that support AI-assisted development with minimal human intervention.

3. **Establish Traceability**: Create direct links between requirements, source SOW documents, wireframes, and acceptance criteria.

4. **Support Verification**: Define measurable acceptance criteria and test scenarios for all functional requirements.

5. **Prevent Scope Creep**: Document protected "Not-Now" features and guardrails to maintain project discipline.

## Relationship to SOW Documentation

This SRS is derived from and complements the Statement of Work (SOW) documentation set:


## Document Conventions

### Requirement Identifiers

All requirements use the following identifier format:

- **FR-XXX-NNN**: Functional Requirements (e.g., FR-CAM-001 for Campaign module)
- **NFR-XXX-NNN**: Non-Functional Requirements (e.g., NFR-SEC-001 for Security)
- **BR-XXX-NNN**: Business Rules (e.g., BR-VER-001 for Verification rules)
- **AC-XXX-NNN**: Acceptance Criteria (e.g., AC-CAM-001)

### Module Prefixes


### Priority Levels


### Status Indicators


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
Campaign  Store Assignment  PSP Fulfillment  Store Execution  Verification  Visibility
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

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Sections 2, 5, 6*


---
# 1.3 Definitions, Acronyms, and Abbreviations

## Abbreviations


## Domain Terminology

### Core Business Entities


### Campaign Types


### Geographic Hierarchy


### Survey & Layout


### Fulfillment


### Execution & Verification


### Issue Management


### Workflow Terms


### Technical Terms


### Verification Modes


## User Roles (Personas)

### PSP Level


### Brand Level


### Store Level


### System Level

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: GLOSSARY.md v1.2, SUPP-001 v0.3, SUPP-002 v0.5*


---
# 1.4 References

## Primary Source Documents

### Master SOW

### Shared Foundations SUPPs


### Brand Admin Module SUPPs


### PSP Operations Module SUPPs


### Store Execution Module SUPPs


### Platform Ops Agent Harness SUPPs


### Screens & Interfaces SUPPs


## Technical Specifications

### Database Model


### API Specification


### Screen Specifications


## Design Resources

### Wireframes & Prototypes


### Local Wireframes


## Reference Documents

### Index & Framework


### Reference SRS

### Legacy Reference

## External Standards


*Document Version: 1.0*
*Last Updated: 2026-01-01*


---
# 1.5 Document Overview

## SRS Structure

This Software Requirements Specification is organized into modular sections following IEEE 830 guidelines, adapted for agentic development workflows. Each section is maintained as separate Markdown files to enable parallel development and version control.

## Section Organization

### Section 1: Introduction
Establishes the purpose, scope, and context of the SRS document.


### Section 2: Overall Description
Provides system context and high-level product information.


### Section 3: System Architecture
Documents the technical architecture and data model.


### Section 4: User Personas & RBAC
Defines user roles, permissions, and authentication flows.


### Sections 5-10: Module Specifications
Each module section contains screen-by-screen functional requirements.


Each module folder contains:
- `X.0_Module_Overview.md` - Module summary and navigation
- `screens/*.md` - Individual screen specifications

### Section 11: API Specifications
Documents all API contracts and integrations.


### Section 12: Non-Functional Requirements
Specifies quality attributes and constraints.


### Section 99: Appendices
Supplementary reference materials.


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


## Traceability

Each requirement traces back to source documentation:

```
SRS Requirement  SUPP Reference  Master SOW Section
     
Screen Spec  Wireframe  API Contract
     
Test Case  Acceptance Criteria
```

*Document Version: 1.0*
*Last Updated: 2026-01-01*


---
# 01 - Introduction

This section contains the introductory materials for the NewPOPSys v1.38 SRS.

## Contents


## Source Documents

- `SOW/README.md`
- `SOW/MASTER_SOW_COMPILED.md`

*Section Status: Not Started*


---


---

# Section 2: Overall Description
# 2.1 Product Perspective

## System Context

NewPOPSys v1.38 is a standalone multi-tenant SaaS platform designed to replace spreadsheet-and-email workflows for POP (Point-of-Purchase) campaign management. The system positions Print Service Providers (PSPs) as the orchestrating authority for campaign lifecycle management across multiple Brands and their retail Stores.

### Market Position

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                     CAMPAIGN ORCHESTRATION LAYER                     â”‚
â”‚                         (NewPOPSys v1.38)                           â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  PSP Tenant  â†’  Brand Clients  â†’  Store Locations  â†’  Execution    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
         â†‘              â†‘                â†‘                â†‘
    Production     Campaign          Delivery        Installation
    Fulfillment    Configuration     Tracking        Verification
```

### System Boundaries

NewPOPSys operates as the coordination layer between:


## External Interfaces

### User Interfaces


### Hardware Interfaces

NewPOPSys is a cloud-native application with no direct hardware interfaces. However, the system interacts with:


### Software Interfaces


### Communication Interfaces


## Product Position Statement

**For** Print Service Providers managing POP campaigns for retail brands,

**Who** need to coordinate campaign execution across hundreds of store locations,

**NewPOPSys** is a campaign orchestration platform

**That** provides deterministic lifecycle management with complete audit visibility,

**Unlike** spreadsheet-and-email coordination or generic project management tools,

**Our product** enforces structured workflows, captures proof of execution, and maintains compliance traceability.

## Relationship to Other Systems

### What NewPOPSys IS NOT


### System Dependencies

![02_Overall_Description_2.1_Product_Perspective_diagram_0](./diagrams_rendered/02_Overall_Description_2.1_Product_Perspective_diagram_0.png)

## Operating Model

### Multi-Tenant Architecture

```
PSP Tenant (Root)
â”œâ”€â”€ Brand A
â”‚   â”œâ”€â”€ Stores (up to 1,000)
â”‚   â”œâ”€â”€ Campaigns
â”‚   â””â”€â”€ Users (Brand Admin, Campaign Manager, Regional Manager)
â”œâ”€â”€ Brand B
â”‚   â”œâ”€â”€ Stores
â”‚   â”œâ”€â”€ Campaigns
â”‚   â””â”€â”€ Users
â””â”€â”€ PSP Users (PSP Admin, Production Operator, Platform Admin)
```

### Data Isolation


## Constraints from External Systems


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Sections 2, 7*


---
# 2.2 Product Functions

## Core Platform Loop

NewPOPSys v1.38 implements a deterministic campaign lifecycle with complete audit visibility:

```
Campaign â†’ Store Assignment â†’ PSP Fulfillment â†’ Store Execution â†’ Verification â†’ Visibility
```

This loop replaces ad-hoc spreadsheet coordination with structured, traceable workflows.

## Functional Modules Summary

### Module 1: Identity & RBAC


**SUPP Reference:** SUPP-003 (RBAC and Permissions Matrix)

### Module 2: Stores, Regions & Groups


**SUPP Reference:** SUPP-013 (Stores, Regions, Groups)

### Module 3: Survey Builder & Photo Rules


**SUPP Reference:** SUPP-014 (Survey Builder, Layout, Photo Rules), SUPP-037 (Survey Builder)

### Module 4: Campaigns, Kits & Assignment


**SUPP Reference:** SUPP-015 (Campaigns, Kits, Assignment)

### Module 5: Orders, Shipments & PSP Operations


**SUPP Reference:** SUPP-016 (Orders, Shipments, Batches)

### Module 6: Store Execution & Proof Capture


**SUPP Reference:** SUPP-017 (Store Execution, Proof Capture), SUPP-011 (Offline and Sync)

### Module 7: Verification & Retake Loop


**SUPP Reference:** SUPP-018 (Verification, Photo Review, Retake)

### Module 8: Issues, Reorders & Deinstall


**SUPP Reference:** SUPP-019 (Issues, Reorders, Expiration, Deinstall)

### Module 9: Exports & Reports


**SUPP Reference:** SUPP-005 (Exports, Reports, Output Contracts)

### Module 10: Integrations & Webhooks


**SUPP Reference:** SUPP-006 (Webhooks and Inbound API)

### Module 11: Data Retention


**SUPP Reference:** SUPP-008 (Data Retention Classification)

### Module 12: Offline & Sync Strategy


**SUPP Reference:** SUPP-011 (Offline and Sync Strategy)

## Function Priority Matrix


## Cross-Functional Workflows

### Campaign Lifecycle

![02_Overall_Description_2.2_Product_Functions_diagram_0](./diagrams_rendered/02_Overall_Description_2.2_Product_Functions_diagram_0.png)

### Store Assignment Lifecycle

![02_Overall_Description_2.2_Product_Functions_diagram_1](./diagrams_rendered/02_Overall_Description_2.2_Product_Functions_diagram_1.png)

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Section 5, Section 9*


---
# 2.3 User Classes and Characteristics

## User Class Hierarchy

NewPOPSys v1.38 implements a three-tier user hierarchy aligned with the multi-tenant architecture:

[Diagram - See rendered image above or refer to source document]

## User Class Summary


## Detailed User Classes

### Platform Admin


**Key Permissions:**
- Create/manage PSP tenants
- Impersonate any user
- Access all audit logs
- Configure system-wide settings
- Manage feature flags

### PSP Admin


**Key Permissions:**
- Create/manage brands
- Manage all PSP-level users
- Access all brands within tenant
- Generate reports and exports
- Configure PSP settings

### Production Operator


**Key Permissions:**
- View/update order status
- Create shipments and tracking
- Manage production batches
- Process reorders
- Read-only campaign access

### Brand Admin


**Key Permissions:**
- Full brand configuration
- Create/manage campaigns
- Manage brand users
- Access all stores
- Review and approve photos

### Campaign Manager


**Key Permissions:**
- Create/edit assigned campaigns
- Manage store assignments
- View campaign analytics
- Cannot manage brand settings
- Scoped to assigned campaigns only

### Regional Manager


**Key Permissions:**
- Review photos for assigned regions
- Approve/reject submissions
- Handle escalations
- Read-only store data
- Scoped to assigned regions

### Store Manager


**Key Permissions:**
- Full store execution access
- Approve replacement requests
- Manage store team
- Complete all surveys
- Report issues

### Store Operator


**Key Permissions:**
- Execute surveys
- Upload photos
- Update task status
- Request replacements
- Cannot manage other users

### Integration User


**Key Permissions:**
- API access per granted scopes
- No UI access
- Webhook endpoint access
- Rate-limited operations
- Audit-logged actions

## User Class Interaction Matrix


## Accessibility Considerations


## Training Requirements


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Section 2.1; SUPP-001; SUPP-003*


---
# 2.4 Operating Environment

## Infrastructure Overview

NewPOPSys v1.38 operates as a cloud-native application deployed on AWS infrastructure with a focus on reliability, scalability, and cost efficiency.

[Diagram - See rendered image above or refer to source document]

## Production Environment Specifications

### Compute Resources


### Database


### Cache & Queue


### Storage


## Capacity Targets

### Pilot Scale (v1.38)


### Performance Baselines


## Client Environment Requirements

### Web Application (Desktop)


### Mobile PWA (Store Execution)


### Network Requirements


**Firewall/Proxy Requirements:**
- No SSL inspection (breaks certificate pinning)
- WebSocket upgrade support
- No request size limits <10MB

## Software Dependencies

### Server-Side Stack


### Client-Side Stack


### Observability Stack


## Security Environment

### Network Security


### Data Security


### Authentication


## Availability Requirements


### Maintenance Windows


## Environment Tiers


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Section 3; SUPP-039 v0.1*


---
# 2.5 Design and Implementation Constraints

## Architectural Constraints

### Multi-Tenancy Model


### Technology Stack Mandates


### API Design Constraints


## Regulatory and Compliance Constraints

### Accessibility Requirements


### Data Privacy


### Security Standards


## Operational Constraints

### Deployment Constraints


### Performance Constraints


### Scalability Constraints


## Business Constraints

### Scope Boundaries (Protected Not-Now)


### Pilot Constraints


## Integration Constraints

### External System Integration


### API Compatibility


## User Interface Constraints

### Browser Support


### Mobile Constraints


### Responsive Design


## Development Constraints

### Code Quality


### Documentation


### Version Control


## Resource Constraints

### Team Expertise


### Timeline Constraints


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Sections 2.3, 2.4, 6; SUPP-012; SUPP-039*


---
# 2.6 Assumptions and Dependencies

## Assumptions

### Business Assumptions


### Technical Assumptions


### User Assumptions


### Operational Assumptions


## Dependencies

### External Service Dependencies


### Third-Party Integration Dependencies


### Development Dependencies


### Infrastructure Dependencies


## Dependency Risk Assessment

### Critical Path Dependencies

![02_Overall_Description_2.6_Assumptions_Dependencies_diagram_0](./diagrams_rendered/02_Overall_Description_2.6_Assumptions_Dependencies_diagram_0.png)

### Dependency Monitoring


## Contingency Planning

### Dependency Failure Scenarios


### Recovery Procedures


## Pilot-Specific Dependencies

### Pilot Partner Dependencies


### Pilot Success Dependencies


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: MASTER_SOW_COMPILED.md v1.38, Sections 4.2, 10; SUPP-012; SUPP-039*


---
# 02 - Overall Description

This section provides a high-level overview of the NewPOPSys platform.

## Contents


## Diagrams

Located in `diagrams/` subfolder:
- `system_context.mmd` - System context diagram (Mermaid)

## Source Documents

- SUPP-001 (Personas)
- SUPP-012 (Technology Stack)
- MASTER_SOW_COMPILED.md

*Section Status: Not Started*


---


---

# Section 3: System Architecture
# 3.1 Database Model

> **IEEE 830 Reference**: Section 3.1 - System Architecture: Database Model
> **Source Documents**:
> - [Database Model Overview](../../06_Database_Model/README.md)
> - [Foundation Analysis](../../06_Database_Model/FOUNDATION_ANALYSIS.md)
> - [Entity Crosswalk](../../06_Database_Model/07_Validation/ENTITY_CROSSWALK.md)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 3.1.1 Purpose

This section defines the database model for NewPOPSys v1, including table organization, core design patterns, and entity relationships. The schema supports multi-tenant operations, soft-delete data retention, and comprehensive audit trails.

## 3.1.2 Database Environment

### 3.1.2.1 Technology Specifications


### 3.1.2.2 Schema Statistics


## 3.1.3 Core Design Patterns

### 3.1.3.1 Multi-Tenancy Model

All data is scoped through a two-level tenant hierarchy:

[Diagram - See rendered image above or refer to source document]

**Implementation Rules**:
- Every tenant represents a PSP organization with isolated data
- Brands cannot access other brands' data within the same PSP
- All queries scoped by `tenant_id` from JWT authentication
- Row-Level Security planned for Phase 2

### 3.1.3.2 Primary Key Strategy

All tables use UUID primary keys for distributed ID generation:

```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

### 3.1.3.3 Soft Delete Pattern

All tables implement logical deletion for data recovery and audit compliance:

```sql
deleted_at TIMESTAMPTZ  -- NULL = active, timestamp = deleted
```

All indexes use `WHERE deleted_at IS NULL` for active record filtering.

### 3.1.3.4 Audit Trail

Standard timestamp columns on all tables:


State changes logged to `audit_events` with before/after JSON snapshots.

## 3.1.4 Table Distribution by Module

### 3.1.4.1 Module Overview


### 3.1.4.2 Module 1: Tenancy & Identity (5 tables)


### 3.1.4.3 Module 2: Stores & Grouping (7 tables)


### 3.1.4.4 Module 3: Surveys & Layouts (6 tables)


### 3.1.4.5 Module 4: Campaigns & Kits (5 tables)


### 3.1.4.6 Module 5: Fulfillment (4 tables)


### 3.1.4.7 Module 6: Execution & Verification (5 tables)


### 3.1.4.8 Modules 7-11: Supporting Tables


## 3.1.5 Key Enumerations

### 3.1.5.1 Role-Based Access Control

```sql
CREATE TYPE role_enum AS ENUM (
  'PLATFORM_ADMIN',    -- Full system access
  'PSP_ADMIN',         -- PSP tenant administration
  'PSP_OPS',           -- Production/fulfillment operations
  'BRAND_ADMIN',       -- Full brand configuration
  'CAMPAIGN_MANAGER',  -- Campaign-scoped access
  'REGIONAL_MANAGER',  -- Region-scoped oversight
  'STORE_MANAGER',     -- Full store privileges
  'STORE_OPERATOR'     -- Execute tasks only
);
```

### 3.1.5.2 State Machine Enums


### 3.1.5.3 Computed Statuses (Application Layer)

The following statuses are derived from data, not stored:

- **FulfillmentStatus**: Computed from shipment quantities
- **ReceiptStatus**: Computed from delivery confirmations
- **ExecutionStatus**: Computed from installation progress
- **VerificationStatus**: Computed from photo reviews
- **StorePhase**: Rollup of all assignment statuses

## 3.1.6 Relationship Chains

### 3.1.6.1 Campaign Execution Flow

[Diagram - See rendered image above or refer to source document]

### 3.1.6.2 Store Hierarchy

[Diagram - See rendered image above or refer to source document]

### 3.1.6.3 Photo Verification Flow

[Diagram - See rendered image above or refer to source document]

### 3.1.6.4 Issue Resolution Flow

[Diagram - See rendered image above or refer to source document]

## 3.1.7 JSONB Usage Patterns


All JSONB columns default to `'{}'` (empty object), not NULL.

## 3.1.8 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.1 - Data Design / Database Model*


---
# 3.2 Application Architecture

## Overview


This section defines the application layer architecture for NewPOPSys v1.38, including the frontend/backend structure, multi-tenant patterns, module organization, state management, and error handling strategies.

## 1. Application Layer Architecture

### 1.1 High-Level Architecture

NewPOPSys follows a **modular monolith** architecture pattern for v1, designed to evolve into selective microservices as scaling demands require. The application is structured as a Turborepo monorepo with clear separation between frontend, backend, and shared packages.

![03_System_Architecture_3.2_Application_Architecture_diagram_0](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_0.png)

### 1.2 Monorepo Structure

The application uses Turborepo for monorepo management with the following structure:


- **apps/**
  - **web/**: Next.js frontend application
    - `app/`: App router pages
    - `components/`: React components
    - `hooks/`: Custom React hooks
    - `styles/`: CSS/Tailwind styles
  - **api/**: Fastify API server
    - `routes/`: API route handlers
    - `services/`: Business logic services
    - `middleware/`: Auth, validation, tenant context
    - `plugins/`: Fastify plugins
  - **worker/**: BullMQ background workers
    - `jobs/`: Job processors
    - `queues/`: Queue definitions
    - `handlers/`: Event handlers
- **packages/**
  - **shared/**: Shared types, utilities, Zod schemas
    - `types/`: TypeScript type definitions
    - `schemas/`: Zod validation schemas
    - `utils/`: Common utility functions
  - **db/**: Prisma schema and migrations
    - `prisma/`: Schema and migrations
    - `client/`: Generated Prisma client
  - **ui/**: Shared UI component library
    - `components/`: Reusable React components
    - `primitives/`: Base design system components
- **tooling/**
  - `eslint/`: Shared ESLint configuration
  - `typescript/`: Shared TypeScript configuration
  - `tailwind/`: Shared Tailwind configuration


### 1.3 Frontend Architecture (Next.js)

The frontend uses Next.js with the App Router pattern:


**Route Organization by Module:**


- **app/**
  - **(auth)/**: Authentication routes
    - `login/`
    - `forgot-password/`
  - **(psp)/**: PSP Operations module
    - `dashboard/`
    - `orders/`
    - `shipments/`
    - `batches/`
  - **(brand)/**: Brand Admin module
    - `campaigns/`
    - `stores/`
    - `kits/`
    - `reviews/`
  - **(store)/**: Store Portal / Mobile PWA
    - `tasks/`
    - `campaigns/`
    - `receive/`
    - `install/`
  - **(admin)/**: Platform Admin module
    - `tenants/`
    - `users/`
    - `settings/`


### 1.4 Backend Architecture (Fastify API)

The API layer uses Fastify for performance and developer ergonomics:


**API Route Organization:**


- **routes/**
  - **v1/**
    - `auth/`: Authentication endpoints
    - `campaigns/`: Campaign CRUD + publish
    - `stores/`: Store management
    - `orders/`: Order/fulfillment operations
    - `shipments/`: Shipment tracking
    - `issues/`: Issue/reorder management
    - `reviews/`: Photo review queue
    - `exports/`: Report generation
    - `webhooks/`: Inbound webhook handlers
  - **internal/**: Internal service endpoints
    - `health/`
    - `metrics/`

## 2. Multi-Tenant Architecture

### 2.1 Tenancy Model (v1)

NewPOPSys implements a **Shared Database, Shared Schema** multi-tenancy model with Row-Level Security (RLS) for data isolation.

![03_System_Architecture_3.2_Application_Architecture_diagram_1](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_1.png)

### 2.2 Tenant Context Propagation

Every request includes tenant context that flows through all layers:

```typescript
// Tenant context interface
interface RequestContext {
  tenantId: string;      // PSP tenant identifier
  userId: string;        // Authenticated user ID
  brandId?: string;      // Brand scope (if applicable)
  permissions: string[]; // Resolved RBAC permissions
  sessionId: string;     // For audit logging
}

// Middleware extracts tenant from JWT/session
async function tenantMiddleware(request, reply) {
  const session = await getSession(request);
  request.context = {
    tenantId: session.tenantId,
    userId: session.userId,
    brandId: session.brandId,
    permissions: await resolvePermissions(session),
    sessionId: session.id
  };

  // Set PostgreSQL session variable for RLS
  await db.$executeRaw`SELECT set_config('app.current_tenant', ${session.tenantId}, true)`;
}
```

### 2.3 Row-Level Security Implementation

```sql
-- Campaign table with tenant isolation
CREATE TABLE campaigns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  brand_id UUID NOT NULL REFERENCES brands(id),
  name VARCHAR(255) NOT NULL,
  status campaign_status NOT NULL DEFAULT 'DRAFT',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;

-- Tenant isolation policy
CREATE POLICY tenant_isolation ON campaigns
  USING (tenant_id = current_setting('app.current_tenant')::UUID);

-- Brand-level filtering (for Brand Admin scope)
CREATE POLICY brand_scope ON campaigns
  USING (
    current_setting('app.user_role') = 'PLATFORM_ADMIN'
    OR brand_id = current_setting('app.current_brand')::UUID
  );
```

### 2.4 Tenant Hierarchy

![03_System_Architecture_3.2_Application_Architecture_diagram_2](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_2.png)

## 3. Module Organization

### 3.1 Module Overview

NewPOPSys is organized into six functional modules, each serving specific persona groups:


### 3.2 Module Component Diagram

![03_System_Architecture_3.2_Application_Architecture_diagram_3](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_3.png)

### 3.3 Module Dependencies

![03_System_Architecture_3.2_Application_Architecture_diagram_4](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_4.png)

## 4. State Management

### 4.1 State Management Strategy

NewPOPSys employs a layered state management approach:


### 4.2 Data Flow Architecture

![03_System_Architecture_3.2_Application_Architecture_diagram_5](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_5.png)

### 4.3 Offline Support (PWA)

For store execution workflows, the PWA provides best-effort offline support:

```typescript
// Service Worker caching strategy
const cacheStrategies = {
  // Static assets: Cache-first
  static: 'CacheFirst',

  // API data: Network-first with offline fallback
  api: 'NetworkFirst',

  // Draft submissions: IndexedDB queue
  drafts: 'BackgroundSync'
};

// Offline draft sync
interface OfflineDraft {
  id: string;
  type: 'photo_upload' | 'survey_response' | 'issue_report';
  payload: unknown;
  createdAt: Date;
  syncStatus: 'pending' | 'syncing' | 'failed';
}

// Sync on reconnection
async function syncOfflineDrafts() {
  const drafts = await getDraftsFromIndexedDB();
  for (const draft of drafts) {
    await submitDraft(draft);
    await markDraftSynced(draft.id);
  }
}
```

## 5. Error Handling

### 5.1 Error Handling Strategy

NewPOPSys implements a comprehensive error handling strategy across all layers:

![03_System_Architecture_3.2_Application_Architecture_diagram_6](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_6.png)

### 5.2 Error Categories


### 5.3 Structured Error Response

```typescript
// Standard error response format
interface ApiError {
  error: {
    code: string;           // Machine-readable error code
    message: string;        // Human-readable message
    details?: {             // Validation errors
      field: string;
      message: string;
    }[];
    requestId: string;      // For support reference
    timestamp: string;      // ISO-8601
  };
}

// Example validation error
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data",
    "details": [
      { "field": "campaign.name", "message": "Name is required" },
      { "field": "campaign.startDate", "message": "Start date must be in the future" }
    ],
    "requestId": "req_abc123",
    "timestamp": "2026-01-01T10:30:00Z"
  }
}
```

### 5.4 Error Handling Implementation

```typescript
// Global error handler (Fastify)
fastify.setErrorHandler(async (error, request, reply) => {
  const requestId = request.id;
  const context = request.context;

  // Structured log
  const logEntry = {
    level: error.statusCode >= 500 ? 'error' : 'warn',
    requestId,
    tenantId: context?.tenantId,
    userId: context?.userId,
    method: request.method,
    url: request.url,
    error: {
      name: error.name,
      message: error.message,
      code: error.code,
      stack: error.stack
    }
  };

  logger.log(logEntry);

  // Sentry for 5xx errors
  if (error.statusCode >= 500) {
    Sentry.captureException(error, {
      extra: { requestId, tenantId: context?.tenantId }
    });
  }

  // Sanitized response (no internal details)
  return reply.status(error.statusCode || 500).send({
    error: {
      code: error.code || 'INTERNAL_ERROR',
      message: error.statusCode >= 500
        ? 'An unexpected error occurred'
        : error.message,
      requestId,
      timestamp: new Date().toISOString()
    }
  });
});
```

### 5.5 Observability Integration

```typescript
// OpenTelemetry tracing
import { trace, SpanStatusCode } from '@opentelemetry/api';

const tracer = trace.getTracer('popsys-api');

async function createCampaign(data: CampaignInput, context: RequestContext) {
  const span = tracer.startSpan('createCampaign');

  try {
    span.setAttributes({
      'tenant.id': context.tenantId,
      'campaign.type': data.type
    });

    const campaign = await campaignService.create(data, context);

    span.setStatus({ code: SpanStatusCode.OK });
    return campaign;

  } catch (error) {
    span.setStatus({
      code: SpanStatusCode.ERROR,
      message: error.message
    });
    span.recordException(error);
    throw error;

  } finally {
    span.end();
  }
}
```

## 6. Component Interaction Diagram

### 6.1 Full System Component Diagram

![03_System_Architecture_3.2_Application_Architecture_diagram_7](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_7.png)

### 6.2 Request Flow Sequence

![03_System_Architecture_3.2_Application_Architecture_diagram_8](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_8.png)

## 7. Security Architecture

### 7.1 Authentication Flow

![03_System_Architecture_3.2_Application_Architecture_diagram_9](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_9.png)

### 7.2 API Key Authentication (Integrations)

![03_System_Architecture_3.2_Application_Architecture_diagram_10](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_10.png)

## 8. Deployment Architecture

### 8.1 Environment Strategy


### 8.2 CI/CD Pipeline

![03_System_Architecture_3.2_Application_Architecture_diagram_11](./diagrams_rendered/03_System_Architecture_3.2_Application_Architecture_diagram_11.png)

### 8.3 Quality Gates

All deployments must pass:

1. **Linting** - ESLint, Prettier
2. **Type Checking** - TypeScript strict mode
3. **Unit Tests** - Jest (80% coverage minimum)
4. **Integration Tests** - API contract verification
5. **E2E Tests** - Playwright for critical paths
6. **OpenAPI Drift Check** - API spec matches implementation
7. **Security Scan** - npm audit, dependency vulnerabilities

## References


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*IEEE 830 Compliant*


---
# 3.3 Technology Stack

> **IEEE 830 Reference**: Section 3.3 - System Architecture: Technology Stack
> **Source Document**: [SUPP-012 - Technology Selections ADR](../../02_SUPPs/Platform_Ops_Agent_Harness/SUPP-012%20-%20Platform%20Ops%20-%20Agent%20Harness%20-%20Technology%20Selections%20ADR.md)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 3.3.1 Purpose

This section defines the technology selections for NewPOPSys v1. All decisions documented here are **locked for v1** to ensure deterministic builds and consistent infrastructure across environments.

## 3.3.2 Technology Matrix

### 3.3.2.1 Infrastructure Layer


### 3.3.2.2 Application Layer


### 3.3.2.3 Security & Authentication


### 3.3.2.4 Communication & Notifications


### 3.3.2.5 Observability & Operations


## 3.3.3 Architecture Rationale

### 3.3.3.1 AWS + PostgreSQL + S3

**Decision**: AWS services as primary infrastructure platform.

**Rationale**: Lowest-friction path for a multi-tenant, media-heavy workflow application at pilot scale. RDS PostgreSQL provides:
- JSONB for flexible survey schema storage
- Strong relational constraints for fulfillment/execution workflows
- Proven scalability for anticipated growth

### 3.3.3.2 Session Cookies vs. JWT

**Decision**: Server-side session cookies for web application authentication.

**Rationale**:
- Maintains sane UX for web users
- Simplifies token management
- API keys + HMAC for integrations keeps external access simple and auditable

### 3.3.3.3 OpenTelemetry

**Decision**: OpenTelemetry for observability with structured JSON logs.

**Rationale**:
- Sentry provides immediate pilot stabilization support
- OpenTelemetry ensures vendor portability if observability vendors change
- Request ID correlation enables distributed tracing

### 3.3.3.4 Outbox Pattern for Webhooks

**Decision**: Outbox pattern with BullMQ retry workers.

**Rationale**:
- Guarantees webhook delivery even during transient failures
- Dead-letter queue captures persistent failures for investigation
- Idempotency-Key prevents duplicate processing

## 3.3.4 Allowed Overrides

The following substitutions are permitted without architectural changes:


## 3.3.5 Implementation Constraints

Per SUPP-012, the following constraints apply to implementation:

1. **Event Envelope Format**: Adopt early per SUPP-006
2. **Stable IDs**: Exports must never depend on internal DB row order
3. **Survey Versioning**: Treat as immutable; pin to assignments; require explicit rebase
4. **Migration Tooling**: Enforce SQL-level constraints for core relationships

## 3.3.6 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Design Constraints / Technology Stack*


---
# 3.4 Integration Architecture

> **Version**: 1.0
> **Status**: Draft
> **Last Updated**: 2026-01-01
> **References**: SUPP-006, SUPP-012, SUPP-027, SUPP-034, openapi.yaml

## 3.4.1 Overview

NewPOPSys integrates with external systems through a robust, event-driven architecture designed for reliability, security, and observability. The integration layer supports:

- **Outbound Webhooks**: At-least-once delivery of system events to PSP and Brand systems
- **Inbound APIs**: RESTful endpoints for external systems to update orders, shipments, and execution status
- **Async Processing**: BullMQ-based queue workers for reliable event delivery and retry handling


## 3.4.2 External System Integrations

### 3.4.2.1 Integration Partners

![03_System_Architecture_3.4_Integration_Architecture_diagram_0](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_0.png)

### 3.4.2.2 Integration Capabilities by Partner Type


## 3.4.3 Webhook Architecture

### 3.4.3.1 Outbox Pattern Implementation

NewPOPSys uses the **Transactional Outbox Pattern** to ensure reliable webhook delivery without distributed transactions.

![03_System_Architecture_3.4_Integration_Architecture_diagram_1](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_1.png)

### 3.4.3.2 Event Envelope Structure

All webhook deliveries use a standardized envelope format:

```json
{
  "eventId": "evt_01HXYZ...",
  "eventType": "order.created",
  "occurredAt": "2025-12-17T18:00:00Z",
  "schemaVersion": "1.0",
  "pspId": "psp_...",
  "brandId": "br_...",
  "campaignId": "cmp_...",
  "storeId": "sto_...",
  "correlationId": "corr_...",
  "actor": {
    "type": "system|human|integration",
    "id": "usr_..."
  },
  "data": {
    // Event-specific payload
  }
}
```

### 3.4.3.3 Webhook Headers


### 3.4.3.4 Webhook Event Types (v1)


## 3.4.4 API Authentication

### 3.4.4.1 Authentication Methods


### 3.4.4.2 API Key Structure

API keys follow a prefixed format for environment identification:

```
Production: vg_live_xxxxxxxxxxxxxxxxxxxxxxxx
Test/Staging: vg_test_xxxxxxxxxxxxxxxxxxxxxxxx
```

**Security Requirements:**
- Keys are hashed (bcrypt) before storage
- Each key has least-privilege scopes assigned
- Key rotation supported with grace period
- Revocation is immediate and audited

### 3.4.4.3 HMAC-SHA256 Webhook Signature Verification

![03_System_Architecture_3.4_Integration_Architecture_diagram_2](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_2.png)

**Signature Calculation:**

```
String to sign: <timestamp>.<raw_body_bytes>
Signature: HMAC_SHA256(secret, string_to_sign)
Header: X-NewPOPSys-Signature-256: sha256=<hex>
```

**Verification Code Example (Node.js):**

```javascript
const crypto = require('crypto');

function verifyWebhook(req, secret) {
  const signature = req.headers['x-newpopsys-signature-256'];
  const timestamp = req.headers['x-newpopsys-timestamp'];
  const body = JSON.stringify(req.body);

  // Check timestamp freshness (5 minute window)
  const now = Math.floor(Date.now() / 1000);
  if (Math.abs(now - parseInt(timestamp)) > 300) {
    throw new Error('Webhook timestamp too old');
  }

  // Compute expected signature
  const payload = `${timestamp}.${body}`;
  const expected = 'sha256=' + crypto
    .createHmac('sha256', secret)
    .update(payload)
    .digest('hex');

  // Constant-time comparison
  if (!crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(expected)
  )) {
    throw new Error('Invalid webhook signature');
  }

  return true;
}
```

## 3.4.5 Idempotency Patterns

### 3.4.5.1 Inbound API Idempotency

All write operations require an `Idempotency-Key` header to ensure safe retries.

![03_System_Architecture_3.4_Integration_Architecture_diagram_3](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_3.png)

**Idempotency Key Requirements:**


**Response Codes:**


### 3.4.5.2 Outbound Webhook Idempotency

Webhook consumers must deduplicate by `eventId`:

- Each event has a globally unique `eventId` (UUIDv7)
- Delivery is at-least-once (retries may duplicate)
- Consumers should store seen `eventId` values for deduplication window
- Recommended deduplication window: 72 hours (matches retry window)

## 3.4.6 Error Handling and Retry Strategies

### 3.4.6.1 Webhook Retry Schedule

Exponential backoff with jitter is used for failed webhook deliveries:


After attempt 10, delivery enters **DEAD_LETTER** status unless manually replayed.

![03_System_Architecture_3.4_Integration_Architecture_diagram_4](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_4.png)

### 3.4.6.2 Dead Letter Queue Management

- **Automatic DLQ**: After 10 failed attempts (max 72 hours)
- **Manual Replay**: Unlimited, requires admin action with reason/comment
- **Audit Trail**: All replay actions logged with who/when/why

### 3.4.6.3 Circuit Breaker Pattern

For consistently failing endpoints:


### 3.4.6.4 Response Code Handling


## 3.4.7 Rate Limiting

### 3.4.7.1 Inbound API Rate Limits

Rate limiting is enforced at the API gateway level with tenant-aware keys:


**Rate Limit Headers:**


**Exceeded Response:**
- HTTP 429 Too Many Requests
- `Retry-After` header with seconds until reset

### 3.4.7.2 Webhook Concurrency Throttle

Per-endpoint concurrency controls prevent overwhelming consumer systems:


## 3.4.8 Integration Sequence Diagrams

### 3.4.8.1 Campaign Publish Flow

![03_System_Architecture_3.4_Integration_Architecture_diagram_5](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_5.png)

### 3.4.8.2 Shipment Update Flow

![03_System_Architecture_3.4_Integration_Architecture_diagram_6](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_6.png)

### 3.4.8.3 Issue/Reorder Flow

![03_System_Architecture_3.4_Integration_Architecture_diagram_7](./diagrams_rendered/03_System_Architecture_3.4_Integration_Architecture_diagram_7.png)

## 3.4.9 Delivery Records Data Model

### 3.4.9.1 Webhook Delivery Record

```
webhook_delivery:
  - id: UUID
  - event_id: UUID (FK to event)
  - endpoint_id: UUID (FK to webhook_endpoint)
  - status: ENUM (PENDING, IN_FLIGHT, DELIVERED, FAILED, DEAD_LETTER, BLOCKED)
  - http_status: INT (nullable)
  - attempt_count: INT
  - next_attempt_at: TIMESTAMP (nullable)
  - last_attempt_at: TIMESTAMP (nullable)
  - last_error: TEXT (nullable)
  - request_id: UUID
  - correlation_id: UUID
  - created_at: TIMESTAMP
  - updated_at: TIMESTAMP
```

### 3.4.9.2 Idempotency Key Record

```
idempotency_key:
  - id: UUID
  - tenant_id: UUID
  - key: VARCHAR(64)
  - method: VARCHAR(10)
  - path: VARCHAR(255)
  - request_hash: VARCHAR(64)
  - response_status: INT
  - response_body_hash: VARCHAR(64)
  - created_at: TIMESTAMP
  - expires_at: TIMESTAMP

UNIQUE(tenant_id, key)
```

## 3.4.10 Security Considerations

### 3.4.10.1 Webhook Security


### 3.4.10.2 Staging Environment Safety


### 3.4.10.3 API Key Security

- Keys hashed with bcrypt before storage
- Least-privilege scopes per key
- Immediate revocation capability
- Audit logging for all key operations

## 3.4.11 Correlation and Tracing

All integration events include `correlationId` for end-to-end tracing:

[Diagram - See rendered image above or refer to source document]

- OpenTelemetry spans linked by correlation ID
- Structured JSON logs include `requestId` and `correlationId`
- Webhook deliveries carry correlation through the chain

## 3.4.12 Schema Versioning

### 3.4.12.1 Versioning Strategy


### 3.4.12.2 Consumer Guidelines

- Ignore unknown fields (forward compatibility)
- Handle `eventType` + `schemaVersion` explicitly
- Prepare for schema version in headers: `X-NewPOPSys-Schema-Version`

## 3.4.13 Acceptance Criteria

- [ ] AC-001: Webhook deliveries use HMAC-SHA256 signatures with timestamp validation
- [ ] AC-002: Failed webhooks retry with exponential backoff (max 72 hours)
- [ ] AC-003: Dead-letter deliveries are replayable via admin UI with audit trail
- [ ] AC-004: All inbound write APIs require `Idempotency-Key` header
- [ ] AC-005: Duplicate idempotency keys return cached response (same payload) or 409 (different payload)
- [ ] AC-006: Rate limiting returns 429 with `Retry-After` header
- [ ] AC-007: Webhook concurrency per endpoint is limited to prevent overwhelming consumers
- [ ] AC-008: Staging blocks non-allowlisted webhook URLs and email recipients
- [ ] AC-009: All integration events include `correlationId` for tracing
- [ ] AC-010: API keys support rotation with grace period

## Changelog


---
# 03 - System Architecture

This section documents the technical architecture of NewPOPSys.

## Contents


## Diagrams

Located in `diagrams/` subfolder:
- `erd_core.mmd` - Core entities ERD
- `erd_campaigns.mmd` - Campaign entities ERD
- `erd_execution.mmd` - Execution entities ERD
- `component_architecture.mmd` - Application components

## Source Documents

- `SOW/06_Database_Model/` (16 files)
- SUPP-012 (Technology Stack)
- SUPP-021 (Architecture)

*Section Status: In Progress (2 of 4 complete)*


---


---

# Section 4: User Personas & RBAC
# 4.1 Persona Matrix

## 1. Purpose

This section defines the user personas for NewPOPSys v1.38. Each persona represents a distinct user class with specific responsibilities, permission levels, and system interactions. The persona matrix serves as the authoritative reference for role-based access control (RBAC) implementation.

**Authoritative Source**: SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens

## 2. Persona Overview

NewPOPSys supports nine (9) distinct personas organized across four hierarchical levels:


## 3. Persona Matrix

### 3.1 PSP Level Personas


### 3.2 Brand Level Personas


### 3.3 Store Level Personas


### 3.4 System Level Personas

## 4. Permission Hierarchy

[Diagram - See rendered image above or refer to source document]

## 5. Key Constraints


## 6. References

- **SUPP-001**: Shared Foundations - Persona Workflows JTBD Screens (authoritative source)
- **Section 4.2**: Permission Matrix (detailed RBAC grid)
- **Section 4.3**: Authentication Flows

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*IEEE 830 Compliant*


---
# 4.2 Permission Matrix

> **SRS Section**: 4.2 | **Version**: 1.0 | **Status**: Draft
> **Source**: [SUPP-003 - RBAC and Permissions Matrix](../../02_SUPPs/Shared_Foundations/SUPP-003%20-%20Shared%20Foundations%20-%20RBAC%20and%20Permissions%20Matrix.md)
> **Last Updated**: 2026-01-01

## 4.2.1 Purpose

This section defines the Role-Based Access Control (RBAC) permission matrix for NewPOPSys v1. It specifies authorized capabilities for each role across system features, completion workflows, and security controls.

## 4.2.2 Role Enumeration

The system defines eight roles via `role_enum`:


> **Note**: Support Agent uses `PSP_OPS` with `support_scope = true` flag (read-only access).

## 4.2.3 Permission Matrix by Level

### 4.2.3.1 PSP Level Permissions


### 4.2.3.2 Brand Level Permissions


### 4.2.3.3 Store Level Permissions


### 4.2.3.4 System (Integration User)


**Legend**: Y = Full access | Y* = Scoped/limited access | N = No access

## 4.2.4 Completion Authority Matrix


**Audit Requirements**:
- All completion actions require attestation
- Rejection requires reason code
- Waiver/reopen requires written justification
- Force-complete snapshots incomplete stores

## 4.2.5 Security Requirements

### 4.2.5.1 Multi-Factor Authentication


### 4.2.5.2 Impersonation Controls


- All impersonation sessions emit audit events (start/end with reason)
- Original user sees banner when being impersonated
- All other roles cannot impersonate

### 4.2.5.3 API Security


## 4.2.6 Traceability


*Document Status: Draft | IEEE 830 Compliant*


---
# 4.3 Authentication Flows

> **SRS Section**: 4.3 | **Version**: 1.0 | **Status**: Draft
> **System**: NewPOPSys v1.38
> **Source**: [SUPP-003 - RBAC and Permissions Matrix](../../02_SUPPs/Shared_Foundations/SUPP-003%20-%20Shared%20Foundations%20-%20RBAC%20and%20Permissions%20Matrix.md)
> **Last Updated**: 2026-01-01

## 4.3.1 Purpose

This section specifies the authentication mechanisms, session management policies, and security flows for NewPOPSys v1.38. It defines requirements for user authentication (web UI), API key authentication (integrations), multi-factor authentication (MFA), password policies, session lifecycle, and user impersonation.

## 4.3.2 Scope

This specification covers:
- Session-based authentication for web UI users
- API key authentication for integration accounts
- Multi-factor authentication requirements and flows
- Password complexity and lifecycle policies
- Session management including expiration and refresh
- User impersonation flow for Platform Admin support

## 4.3.3 Authentication Methods

### 4.3.3.1 Session-Based Authentication (Web UI)

The primary authentication method for human users accessing NewPOPSys via web browser.


### 4.3.3.2 API Key Authentication (Integrations)

Authentication method for Integration User service accounts and external system integrations.


## 4.3.4 Password Policy

### 4.3.4.1 Password Requirements


### 4.3.4.2 Password Lifecycle


### 4.3.4.3 Password Reset Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_0](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_0.png)

## 4.3.5 Multi-Factor Authentication (MFA)

### 4.3.5.1 MFA Requirements by Role


### 4.3.5.2 MFA Method Specifications

#### TOTP (Time-Based One-Time Password)


#### WebAuthn (Recommended for Admin Roles)


### 4.3.5.3 MFA Enrollment Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_1](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_1.png)

### 4.3.5.4 MFA Login Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_2](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_2.png)

## 4.3.6 Session Management

### 4.3.6.1 Session Lifecycle Parameters


### 4.3.6.2 Session Token Specifications


### 4.3.6.3 Session Refresh Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_3](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_3.png)

### 4.3.6.4 Session Invalidation Triggers


## 4.3.7 Account Security Controls

### 4.3.7.1 Failed Login Handling


### 4.3.7.2 Lockout Recovery Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_4](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_4.png)

## 4.3.8 API Key Authentication

### 4.3.8.1 API Key Lifecycle


### 4.3.8.2 API Key Creation Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_5](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_5.png)

### 4.3.8.3 API Key Permission Scoping


### 4.3.8.4 API Rate Limiting


## 4.3.9 User Impersonation

### 4.3.9.1 Impersonation Authorization


### 4.3.9.2 Impersonation Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_6](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_6.png)

### 4.3.9.3 Impersonation Session Constraints


### 4.3.9.4 Impersonation Audit Trail

All impersonation sessions generate the following audit events:


## 4.3.10 Authentication Flow Diagrams

### 4.3.10.1 Complete Login Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_7](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_7.png)

### 4.3.10.2 API Authentication Flow

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_8](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_8.png)

### 4.3.10.3 Session Lifecycle State Machine

![04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_9](./diagrams_rendered/04_User_Personas_RBAC_4.3_Authentication_Flows_diagram_9.png)

## 4.3.11 Security Requirements Summary

### 4.3.11.1 Cryptographic Requirements


### 4.3.11.2 Compliance Requirements


## 4.3.12 Traceability Matrix


## 4.3.13 References

- **Section 4.1**: Persona Matrix (user classes)
- **Section 4.2**: Permission Matrix (RBAC authorization)
- **Section 12.2**: Security Non-Functional Requirements
- **SUPP-003**: Shared Foundations - RBAC and Permissions Matrix

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*IEEE 830 Compliant*


---
# 04 - User Personas & RBAC

This section documents all user personas and their role-based access control.

## Contents


## Persona Details

Located in `personas/` subfolder:


## Source Documents

- SUPP-001 (User Personas)
- SUPP-003 (RBAC Definition)

*Section Status: Not Started*


---


---

# Section 5: Shared Foundations Module
# Module Overview: SharedFoundations (L-Series)


## 1. Module Summary

### Purpose

The SharedFoundations module provides cross-cutting screens and functionality shared across all portals within the PopSystem ecosystem. These screens establish consistent user experiences for authentication, navigation, personalization, and system-wide notifications regardless of which portal a user accesses.

### Scope

- **Universal Authentication**: Single sign-on entry point for all portals
- **Unified Dashboard**: Role-aware landing page with contextual widgets
- **User Profile Management**: Personal settings and preferences
- **System Settings**: Application-wide configuration options
- **Notification Center**: Centralized alert and message management

### Design Principles

1. **Consistency**: Identical look and behavior across all portals
2. **Role-Awareness**: Content adapts based on user permissions
3. **Accessibility**: WCAG 2.1 AA compliance
4. **Responsiveness**: Full mobile and desktop support

## 2. Screen Inventory Table


## 3. Module Dependencies

### Required Services


### External Integrations


## 4. RBAC Summary

### Access Matrix


### Permission Notes

- **Full**: Complete read/write access to all features
- **Limited**: Can modify own data only
- **Role-Scoped**: Dashboard widgets filtered by role permissions
- **View Only**: Read access without modification capability
- **None**: Screen not accessible to this role

## 5. Key Integration Points

### Authentication Flow

```
User Request  L001 Login  Auth Service  SSO Provider
                    
              MFA Challenge (if enabled)
                    
              Session Created  L002 Dashboard
```

### Session Management


### Cross-Portal State

- User preferences sync across all portals
- Notification read status shared globally
- Session valid for all portals under same domain

## 6. Technical Specifications


## 7. Revision History


## Related Documents

- [L001 Universal Login SRS](./L001_Universal_Login.md)
- [L002 Universal Dashboard SRS](./L002_Universal_Dashboard.md)
- [Authentication Architecture](../08_Architecture/Auth_Architecture.md)
- [RBAC Matrix](../06_Security/RBAC_Matrix.md)


---
# L001 Universal Login Screen - SRS Specification

> **SRS Section**: 5.1.1 | **Screen ID**: L001 | **Version**: 1.0 | **Status**: Draft
> **Module**: SharedFoundations (L-series)
> **Route**: `/login`
> **Source**: [L01_Universal_Login.md](../../../06_Screen_Specs/L01_Universal_Login.md)
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Universal Login Screen (L001) serves as the single authentication entry point for all NewPOPSys web portal users. It provides unified credential-based authentication with role-based routing, multi-factor authentication support, SSO integration for enterprise customers, and password recovery functionality.

### 1.2 Access Requirements


### 1.3 Screenshot Reference

![Universal Login Screen](./screenshots/Mobile_App/mobile_app.png)

*Figure L001-1: Universal Login Screen - Mobile and Web responsive login interface*

### 1.4 Navigation Path


## 2. User Roles & Permissions

### 2.1 Accessible Roles

All system roles may access this screen prior to authentication. Post-authentication routing is determined by role hierarchy.


### 2.2 Role-Based Routing Priority

**REQ-L001-FR-001**: The system SHALL route authenticated users to their primary dashboard based on highest-priority role assignment.

```
Priority Order (highest first):
1. PLATFORM_ADMIN / PSP_ADMIN  /psp/dashboard
2. PSP_OPS  /psp/orders
3. BRAND_ADMIN / CAMPAIGN_MANAGER  /admin/dashboard
4. REGIONAL_MANAGER  /admin/regional
5. STORE_MANAGER  /store/dashboard
6. STORE_OPERATOR  /store/campaigns
```

### 2.3 Multi-Role Handling

**REQ-L001-FR-002**: When a user holds multiple roles across different levels, the system SHALL:
- Use the highest-level role (Tenant > Brand > Store)
- Within the same level, use the highest-permission role
- Display a role selector modal if the user has multiple significant roles

### 2.4 MFA Requirements by Role


## 3. UI Components

### 3.1 Layout Structure

**REQ-L001-UI-001**: The login screen SHALL display a centered card layout with responsive breakpoints.


### 3.2 Primary Components


### 3.3 Login Form Wireframe


![Universal Login Screen](./screenshots/Mobile_App/mobile_app.png)


### 3.4 MFA Modal

**REQ-L001-UI-002**: When MFA is required, the system SHALL display a modal dialog for code entry.

> *[Visual component defined in Design System]*


### 3.5 Forgot Password Modal

**REQ-L001-UI-003**: Password reset SHALL be initiated via a modal dialog.

> *[Visual component defined in Design System]*


### 3.6 SSO Domain Entry Modal

**REQ-L001-UI-004**: SSO authentication SHALL prompt for company domain.

> *[Visual component defined in Design System]*


### 3.7 Role Selector Modal

**REQ-L001-UI-005**: For multi-role users, the system SHALL display a role selection modal.

> *[Visual component defined in Design System]*

## 4. Data Requirements

### 4.1 Entities Involved


### 4.2 User Entity Fields

**REQ-L001-DR-001**: The following user fields SHALL be accessed during authentication:


### 4.3 Membership Entity Fields

**REQ-L001-DR-002**: Role determination SHALL query membership records:


### 4.4 Session Data Structure

**REQ-L001-DR-003**: The session object SHALL contain:


![Universal Login Screen](./screenshots/Mobile_App/mobile_app.png)

## 5. Business Rules & Validation

### 5.1 Input Validation Rules

**REQ-L001-BR-001**: Email field validation:


**REQ-L001-BR-002**: Password field validation:


**REQ-L001-BR-003**: MFA code validation:


**REQ-L001-BR-004**: SSO domain validation:


### 5.2 Authentication Business Rules

**REQ-L001-BR-005**: Account lockout policy:


**REQ-L001-BR-006**: Password requirements (for password reset flow):


**REQ-L001-BR-007**: Session parameters:


### 5.3 MFA Business Rules

**REQ-L001-BR-008**: MFA enforcement:
- Roles with mandatory MFA SHALL be redirected to MFA enrollment if not configured
- TOTP codes valid for +/- 1 period (90-second window)
- "Trust this device" stores device fingerprint for 30 days
- 3 failed MFA attempts triggers account lockout

**REQ-L001-BR-009**: MFA recovery:
- 10 single-use backup codes provided at enrollment
- Backup codes are 16 characters each
- Using backup code invalidates that code permanently

## 6. API Integration Points

### 6.1 Authentication Endpoints

**REQ-L001-API-001**: The following API endpoints SHALL be implemented:


### 6.2 Request/Response Specifications

**REQ-L001-API-002**: Login request format:
```json
{
  "email": "user@company.com",
  "password": "SecurePassword123!",
  "remember_me": true,
  "device_fingerprint": "abc123..."
}
```

**REQ-L001-API-003**: Successful login response (no MFA):
```json
{
  "success": true,
  "session": {
    "token": "eyJhbGc...",
    "expires_at": "2026-01-02T08:00:00Z",
    "user": {
      "id": "uuid",
      "email": "user@company.com",
      "primary_role": "BRAND_ADMIN",
      "roles": ["BRAND_ADMIN", "CAMPAIGN_MANAGER"]
    },
    "redirect_url": "/admin/dashboard"
  }
}
```

**REQ-L001-API-004**: MFA required response:
```json
{
  "success": true,
  "mfa_required": true,
  "mfa_token": "temp_token_for_mfa_verification",
  "methods": ["totp", "backup_code"]
}
```

### 6.3 Error Response Format

**REQ-L001-API-005**: Error responses SHALL follow structured format:
```json
{
  "success": false,
  "error": {
    "code": "AUTH_INVALID_CREDENTIALS",
    "message": "Invalid email or password",
    "details": null
  }
}
```

## 7. State Transitions

### 7.1 Login State Machine

**REQ-L001-ST-001**: The login flow SHALL follow this state machine:


[Diagram - See rendered image above or refer to source document]


### 7.2 Session Lifecycle States

**REQ-L001-ST-002**: Session state transitions:


### 7.3 Password Reset State Machine

**REQ-L001-ST-003**: Password reset flow states:

![Login](./screenshots/Mobile_App/mobile_app.png)

## 8. Error Handling

### 8.1 Error Codes and Messages

**REQ-L001-ERR-001**: Authentication error handling:


### 8.2 Client-Side Validation Errors

**REQ-L001-ERR-002**: Form validation error display:


### 8.3 Network Error Handling

**REQ-L001-ERR-003**: Network failure handling:


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

**REQ-L001-A11Y-001**: Screen SHALL meet WCAG 2.1 Level AA standards:


### 9.2 Keyboard Navigation

**REQ-L001-A11Y-002**: Keyboard interaction requirements:


### 9.3 Screen Reader Support

**REQ-L001-A11Y-003**: Screen reader announcements:


### 9.4 ARIA Attributes

**REQ-L001-A11Y-004**: Required ARIA implementations:

```html
<!-- Email field with error -->
<label for="email">Email Address</label>
<input
  id="email"
  type="email"
  aria-required="true"
  aria-invalid="true"
  aria-describedby="email-error"
/>
<span id="email-error" role="alert">Please enter a valid email address</span>

<!-- Password field -->
<label for="password">Password</label>
<input
  id="password"
  type="password"
  aria-required="true"
/>
<button
  type="button"
  aria-label="Show password"
  aria-pressed="false"
>
  [eye icon]
</button>

<!-- Login button with loading state -->
<button
  type="submit"
  aria-busy="true"
  aria-label="Signing in, please wait"
>
  <span class="spinner" aria-hidden="true"></span>
  Signing In...
</button>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance Criteria


### 10.2 Security Acceptance Criteria


### 10.3 Performance Acceptance Criteria


### 10.4 Accessibility Acceptance Criteria


## 11. Traceability Matrix


## 12. Cross-References


## 13. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 5 - Screen Specifications*
*Last Updated: 2026-01-01*


---
# L002 Universal Dashboard - SRS Specification

> **SRS Section**: 5.1.2 | **Screen ID**: L002 | **Version**: 1.0 | **Status**: Draft
> **Module**: SharedFoundations (L-series)
> **Route**: `/dashboard`
> **Source**: [L02_Universal_Dashboard.md](../../../06_Screen_Specs/L02_Universal_Dashboard.md)
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Universal Dashboard (L002) serves as the unified dashboard shell that adapts based on user role and permissions. It provides a consistent layout framework with role-specific widgets, KPIs, quick actions, and navigation while maintaining a cohesive user experience across all portal types (Brand Admin, Store Portal, PSP Operations, Regional Dashboard).

### 1.2 Access Requirements


### 1.3 Screenshot Reference

![Universal Dashboard](./screenshots/Admin_Portal/admin_portal_dashboard.png)

*Figure L002-1: Universal Dashboard - Role-adaptive dashboard with KPIs, widgets, and quick actions*

### 1.4 Navigation Path


## 2. User Roles & Permissions

### 2.1 Role-Based Dashboard Configurations


### 2.2 RBAC Permission Matrix


### 2.3 Widget Visibility Rules

**REQ-L002-FR-001**: The dashboard SHALL display only widgets authorized for the user's highest-priority role.

**REQ-L002-FR-002**: Users with multiple roles SHALL see a combined widget set with appropriate permission boundaries.

## 3. UI Components & Layout

### 3.1 Layout Structure

**REQ-L002-UI-001**: The dashboard SHALL use a responsive grid layout with collapsible sidebar navigation.


![Universal Dashboard](./screenshots/Admin_Portal/admin_portal_dashboard.png)


### 3.2 Responsive Breakpoints


### 3.3 Component Specifications

#### 3.3.1 Header Bar


#### 3.3.2 KPI Cards

**REQ-L002-UI-002**: Each KPI card SHALL display:
- Metric label
- Current value (formatted)
- Trend indicator (//)
- Percentage change from comparison period
- Sparkline (optional)

#### 3.3.3 Widget Container

**REQ-L002-UI-003**: Widgets SHALL be:
- Draggable (if user has customize permission)
- Resizable within grid constraints
- Collapsible with state persistence
- Refreshable individually

## 4. Data Structures

### 4.1 TypeScript Interfaces


![Universal Dashboard](./screenshots/Admin_Portal/admin_portal_dashboard.png)


### 4.2 Widget Type Registry

```typescript
interface WidgetTypeDefinition {
  id: string;
  name: string;
  description: string;
  category: WidgetCategory;
  allowedRoles: RoleEnum[];
  defaultSize: GridSize;
  minSize: GridSize;
  maxSize: GridSize;
  configSchema: JSONSchema;
  dataEndpoint: string;
}

type WidgetCategory = 'kpi' | 'chart' | 'list' | 'action' | 'alert' | 'custom';
```

## 5. Business Rules

### 5.1 Dashboard Loading Rules


### 5.2 Widget Visibility Rules


### 5.3 Customization Rules


## 6. API Specifications

### 6.1 Get Dashboard Configuration

```
GET /api/v1/dashboard/config
```

**Request Headers:**
```
Authorization: Bearer {token}
X-Tenant-ID: {tenantId}
X-Role-Context: {roleId} (optional, for multi-role users)
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "dash_abc123",
    "userId": "user_xyz",
    "roleId": "STORE_MANAGER",
    "tenantId": "tenant_123",
    "layout": {
      "columns": 4,
      "rows": 6,
      "gridGap": 16,
      "sidebarExpanded": true,
      "sidebarPosition": "left"
    },
    "widgets": [...],
    "preferences": {
      "theme": "system",
      "compactMode": false,
      "autoRefresh": true,
      "defaultDateRange": "last7days",
      "timezone": "America/New_York"
    },
    "lastModified": "2026-01-01T10:00:00Z"
  }
}
```

**Error Responses:**


### 6.2 Get Widget Data

```
GET /api/v1/dashboard/widgets/{widgetId}/data
```

**Request Headers:**
```
Authorization: Bearer {token}
X-Tenant-ID: {tenantId}
```

**Query Parameters:**


**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "widgetId": "widget_orders_today",
    "widgetType": "kpi",
    "value": 156,
    "previousValue": 142,
    "changePercent": 9.86,
    "trend": "up",
    "sparkline": [120, 135, 128, 142, 156],
    "lastUpdated": "2026-01-01T14:30:00Z",
    "nextRefresh": "2026-01-01T14:35:00Z"
  }
}
```

### 6.3 Save Dashboard Configuration

```
PUT /api/v1/dashboard/config
```

**Request Body:**
```json
{
  "layout": {...},
  "widgets": [...],
  "preferences": {...}
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "dash_abc123",
    "lastModified": "2026-01-01T14:35:00Z"
  }
}
```

### 6.4 Reset Dashboard to Default

```
POST /api/v1/dashboard/config/reset
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Dashboard reset to default configuration",
  "data": {...}
}
```

## 7. State Transitions

### 7.1 Dashboard State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 State Definitions


### 7.3 Widget-Level States


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Error Display Patterns

**REQ-L002-ERR-001**: Widget errors SHALL be contained within the widget boundary.

**REQ-L002-ERR-002**: Global errors SHALL display in a dismissible toast notification.

**REQ-L002-ERR-003**: Critical errors SHALL display a full-page error state with recovery options.

### 8.3 Offline Behavior

**REQ-L002-ERR-004**: Dashboard SHALL:
- Cache last successful widget data
- Display stale indicator on cached data
- Queue layout changes for sync when online
- Show offline banner with connection status

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Keyboard Navigation


### 9.3 ARIA Attributes

```html
<section role="region" aria-label="Dashboard">
  <div role="grid" aria-label="Widget grid">
    <article role="gridcell" aria-label="Orders Today">
      <h2 id="widget-title">Orders Today</h2>
      <div aria-describedby="widget-title" aria-live="polite">
        <!-- Widget content -->
      </div>
    </article>
  </div>
</section>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Security Acceptance


## 11. Traceability Matrix


## 12. Cross-References

### 12.1 Related Screens


### 12.2 Related Documents


### 12.3 Dependencies


## 13. Revision History

*Document generated as part of NewPOPSys v1.38 SRS completion initiative.*


---

# Section 6: Store Execution (Mobile PWA) Module
# Module Overview: Store Execution (Mobile PWA)


## 1. Module Summary

### Purpose

The **Store Execution** module (formerly Store Operations) is the primary interface for field personnel and store managers. It is designed as a **Mobile-First PWA** to support offline-capable workflows for campaign material life cycles: from initial receipt verification to installation, photo documentation, and eventual deinstallation.

### Scope

- **Adaptive Workflow Engine**: Automatically advances through Receive -> Install -> Attest based on campaign state.
- **Offline Persistence**: Stores sync queue and local cache to support low-connectivity areas (e.g., store backrooms/basements).
- **Compliance Documentation**: Mandatory photo documentation with metadata (timestamp, GPS, slot ID).
- **Attestation**: Multi-point compliance checklists with digital signature capture.
- **Deinstallation Cycle**: Managed removal of materials at campaign end-of-life.

### Target Users

- **Store Operators**: Primary executors of receipt and installation.
- **Store Managers**: Verification and final attestation sign-off.
- **Brand Admin (Observational)**: Real-time visibility into execution results.

## 2. Screen Inventory


## 3. Workflow Visualizations (Wireframes)

### 3.1 Dashboard & Task Entry
The primary hub for users, displaying campaign status and quick stats.


### 3.2 Receipt & Verification Flow
Users verify SKU counts and condition of materials using a checklist approach.


### 3.3 Installation & Photo Documentation
Location-based slots with placement guidance and integrated photo capture.


### 3.4 Compliance Attestation
Final manager sign-off with compliance certification and digital signature.


### 3.5 Deinstallation Cycle
Closing the loop on campaign assets after the promotion ends.


## 4. Module Dependencies

### Internal Services
- **Campaign Service**: Determines the active tasks and slot definitions for each store.
- **File/Asset Service**: Manages photo uploads and signature image persistence.
- **Sync Service**: Handles background sync of offline actions.

### External Systems
- **Logistics Integration**: Feeds delivery alerts to trigger the "Receive" workflow.

## 5. RBAC Summary


## 6. Revision History



---
# M001 - Login Screen

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M001
> **Route**: `/app/login`
> **IEEE 830 Section**: 3.2.1 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Login screen provides secure authentication for store personnel accessing the NewPOPSys mobile PWA. It implements a simplified store-centric authentication flow using store number and personal PIN, optimized for retail environments where users may share devices but require individual accountability.

### 1.2 Scope

This specification covers:
- Store number input and validation
- PIN-based authentication
- Session token management
- Rate limiting and security controls
- Offline authentication fallback

### 1.3 Screenshot Reference

![Login Screen](./screenshots/Store_Execution/mobile_dashboard.png) 
*Note: Using Dashboard as placeholder; specific login wireframe is defined in L001.*

### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Constraints

- Only users with active `Membership` records for a store may authenticate
- User must have `is_active = true` status
- Store must have `status = ACTIVE`

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Layout Specification


![Mobile Login](./screenshots/Store_Execution/mobile_dashboard.png)

## 4. Data Requirements

### 4.1 Input Data


### 4.2 Output Data


### 4.3 Data Model References


### 4.4 Data Requirements


## 5. Business Rules & Validation

### 5.1 Authentication Rules


### 5.2 Rate Limiting Rules


### 5.3 Session Rules


### 5.4 Validation Requirements


## 6. API Integration Points

### 6.1 Authentication Endpoint


#### Request Schema


![Mobile Login](./screenshots/Store_Execution/mobile_dashboard.png)


#### Response Schema (Success - 200)

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "expires_at": "2026-01-01T09:00:00Z",
  "user": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@store.com",
    "role": "STORE_OPERATOR"
  },
  "store": {
    "id": "uuid",
    "store_number": "STR-001",
    "name": "Downtown Location",
    "brand_id": "uuid"
  }
}
```

#### Error Responses


### 6.2 Token Refresh Endpoint


#### Request Schema

```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Authentication State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 Rate Limit State Machine


[Diagram - See rendered image above or refer to source document]


### 7.3 State Requirements


## 8. Error Handling

### 8.1 Error Categories


### 8.2 Error Messages


### 8.3 Offline Authentication


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Assistive Technology Support


### 9.3 ARIA Implementation

```html
<form role="form" aria-labelledby="login-heading">
  <h1 id="login-heading">Welcome Back</h1>

  <label for="store-number">Store Number</label>
  <input id="store-number" type="text"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="store-error" />
  <span id="store-error" role="alert"></span>

  <label for="pin">PIN</label>
  <input id="pin" type="password" inputmode="numeric"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="pin-error" />
  <span id="pin-error" role="alert"></span>

  <button type="submit" aria-busy="false">Login</button>
</form>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Security Acceptance


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.1 - User Interface Requirements*


---
# M002 - Dashboard Screen

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M002
> **Route**: `/app/dashboard`
> **IEEE 830 Section**: 3.2.1 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Dashboard screen serves as the primary hub for store personnel after authentication. It displays active campaigns assigned to the user's store, providing at-a-glance status information and navigation to execution workflows. The dashboard aggregates campaign progress, pending tasks, and urgent notifications.

### 1.2 Scope

This specification covers:
- Campaign card display and filtering
- StorePhase status derivation and display
- Notification badge system
- Quick action navigation
- Data refresh and synchronization

### 1.3 Screenshot Reference


### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Matrix


## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Layout Specification


![Mobile Dashboard](./screenshots/Store_Execution/mobile_dashboard.png)


### 3.4 Campaign Card Detail

![Mobile Dashboard](./screenshots/Store_Execution/mobile_dashboard.png)

## 4. Data Requirements

### 4.1 Data Sources


### 4.2 Computed Fields


### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 StorePhase Derivation


### 5.2 Filter Rules


### 5.3 Notification Types


### 5.4 Business Rule Requirements


## 6. API Integration Points

### 6.1 Get Store Assignments


#### Query Parameters


#### Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "campaign": {
        "id": "uuid",
        "name": "Summer Promo 2026",
        "brand": { "id": "uuid", "name": "Acme", "logo_url": "..." },
        "install_start": "2026-01-10",
        "install_end": "2026-01-15",
        "status": "PUBLISHED"
      },
      "status": "IN_PROGRESS",
      "store_phase": "INSTALLING",
      "item_counts": {
        "total": 12,
        "received": 8,
        "installed": 5,
        "photos_approved": 3,
        "photos_rejected": 2
      },
      "completion_percentage": 65
    }
  ],
  "meta": {
    "total": 10,
    "unread_notifications": 3
  }
}
```

### 6.2 Get Notifications


#### Query Parameters


### 6.3 API Requirements


## 7. State Transitions

### 7.1 StorePhase State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 Dashboard View State

```
[LOADING]
    â”‚
    â”œâ”€â”€â–º [ERROR] â”€â”€â–º [RETRY]
    â”‚
    â”‚ Data loaded
    â–¼
[DISPLAYING]
    â”‚
    â”œâ”€â”€â–º [REFRESHING] â”€â”€â–º [DISPLAYING]
    â”‚
    â”‚ User taps campaign
    â–¼
[NAVIGATING]
```

### 7.3 State Requirements


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Offline Behavior


### 8.3 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Screen Reader Announcements


### 9.3 ARIA Implementation

```html
<section aria-label="Campaign List" role="list">
  <article role="listitem" tabindex="0"
           aria-label="Summer Promo 2026, 65% complete">
    <h2>Summer Promo 2026</h2>
    <div role="progressbar" aria-valuenow="65"
         aria-valuemin="0" aria-valuemax="100">
      65%
    </div>
    <span class="status" aria-label="Status: Installing">
      INSTALLING
    </span>
  </article>
</section>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Edge Cases


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.1 - User Interface Requirements*


---
# M003 - Verify Receipt Checklist

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M003
> **Route**: `/app/campaign/:id/receive`
> **IEEE 830 Section**: 3.2.1 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Verify Receipt Checklist screen enables store personnel to verify and document the receipt of campaign materials. Users systematically confirm each item received, report discrepancies (missing, damaged, wrong items), and create issue requests when problems are identified. This screen is critical for inventory accuracy and triggering fulfillment issue resolution workflows.

### 1.2 Scope

This specification covers:
- Item checklist verification workflow
- Issue reporting with quantity and reason
- Partial receipt handling
- Issue request creation
- Receipt confirmation attestation

### 1.3 Screenshot Reference


### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Approval Workflow


## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Layout Specification


![Mobile Interface](./screenshots/Store_Execution/mobile_dashboard.png)


### 3.4 Issue Modal Layout

![Receipt](./screenshots/Store_Execution/mobile_receipt.png)

## 4. Data Requirements

### 4.1 Data Sources


### 4.2 Issue Types Enumeration


### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Receipt Validation Rules


### 5.2 Issue Request Rules


### 5.3 Completion Rules


### 5.4 Validation Requirements


## 6. API Integration Points

### 6.1 Get Assignment Items


#### Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "kit_item": {
        "id": "uuid",
        "sku": "POS-001",
        "name": "Window Poster (24x36)",
        "quantity": 2,
        "photo_rule_id": "uuid"
      },
      "received_qty": 2,
      "item_status": "RECEIVED",
      "has_open_issue": false
    }
  ]
}
```

### 6.2 Update Item Receipt


#### Request Schema

```json
{
  "received_qty": 2
}
```

### 6.3 Create Issue Request


#### Request Schema

```json
{
  "assignment_id": "uuid",
  "lines": [
    {
      "assignment_item_id": "uuid",
      "issue_type": "DAMAGED",
      "quantity": 1,
      "notes": "Box was crushed during shipping"
    }
  ]
}
```

### 6.4 Complete Receiving


#### Request Schema

```json
{
  "attestation": true,
  "notes": "All items verified"
}
```

### 6.5 API Requirements


## 7. State Transitions

### 7.1 AssignmentItem.item_status Transitions

```
[NOT_RECEIVED]
      â”‚
      â”œâ”€â”€â–º [PARTIAL_RECEIVED] â”€â”€â–º [RECEIVED]
      â”‚
      â””â”€â”€â–º [RECEIVED]
      â”‚
      â””â”€â”€â–º [ISSUE_REPORTED]
```

### 7.2 StoreAssignment Status Transitions

```
[READY] â”€â”€â–º [RECEIVING] â”€â”€â–º [READY_TO_INSTALL]
                â”‚
                â””â”€â”€â–º [RECEIVING] (partial, can re-enter)
```

### 7.3 IssueRequest Status Transitions

```
[OPEN]
   â”‚
   â”œâ”€â”€â–º [TRIAGED] â”€â”€â–º [AWAITING_APPROVAL]
   â”‚                         â”‚
   â”‚                         â”œâ”€â”€â–º [APPROVED] â”€â”€â–º [IN_FULFILLMENT]
   â”‚                         â”‚
   â”‚                         â””â”€â”€â–º [DENIED]
   â”‚
   â””â”€â”€â–º [RESOLVED] (if issue was mistake)
```

### 7.4 State Requirements


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Offline Support


### 8.3 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Screen Reader Announcements


### 9.3 ARIA Implementation

```html
<form role="form" aria-label="Receipt verification">
  <div role="progressbar" aria-valuenow="8"
       aria-valuemin="0" aria-valuemax="12">
    8 of 12 items verified
  </div>

  <fieldset>
    <legend class="sr-only">Item list</legend>
    <div role="group" aria-label="Window Poster (24x36)">
      <input type="checkbox" id="item-1"
             aria-describedby="item-1-desc" />
      <label for="item-1">Window Poster (24x36)</label>
      <span id="item-1-desc">SKU: POS-001, Quantity: 2</span>
    </div>
  </fieldset>
</form>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Edge Cases


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.1 - User Interface Requirements*


---
# M004 - Installation Photos

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M004
> **Route**: `/app/campaign/:id/install`
> **IEEE 830 Section**: 3.2.1 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Installation Photos screen guides store personnel through the physical installation of POP materials at designated locations within the store. Users navigate a location-based checklist, viewing where each item should be placed and capturing proof photos. The screen supports the store's layout with slot assignments and ghost image overlays for precise placement.

### 1.2 Scope

This specification covers:
- Location slot accordion navigation
- Item placement guidance with ghost images
- Pre-install condition verification
- Photo capture workflow integration
- Auto-save progress with debounce
- Installation completion tracking

### 1.3 Screenshot Reference


### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Matrix


## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Layout Specification


![Mobile Interface](./screenshots/Store_Execution/mobile_dashboard.png)


### 3.4 Item Card Expanded View

![Install](./screenshots/Store_Execution/mobile_install.png)

## 4. Data Requirements

### 4.1 Data Sources


### 4.2 Computed Fields


### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Installation Workflow Rules


### 5.2 Photo Requirements


### 5.3 Completion Rules


### 5.4 Auto-Save Rules


### 5.5 Validation Requirements


## 6. API Integration Points

### 6.1 Get Assignment with Layout


#### Response Schema

```json
{
  "id": "uuid",
  "campaign_id": "uuid",
  "status": "IN_PROGRESS",
  "layout": {
    "id": "uuid",
    "slots": [
      {
        "id": "uuid",
        "slot_code": "FW-01",
        "name": "Front Window",
        "position_hints": "Left of main entrance",
        "items": [
          {
            "id": "uuid",
            "kit_item": {
              "id": "uuid",
              "name": "Window Poster (24x36)",
              "sku": "POS-001",
              "photo_rule": {
                "ghost_image_url": "https://...",
                "instructions": "Capture straight-on...",
                "min_photos": 1,
                "required_angles": ["front"]
              }
            },
            "item_status": "INSTALLED",
            "photos": [
              {
                "id": "uuid",
                "thumbnail_url": "https://...",
                "review_status": "PENDING"
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### 6.2 Update Item Status


#### Request Schema

```json
{
  "item_status": "INSTALLED",
  "checklist_state": {
    "surface_clean": true,
    "previous_removed": true,
    "position_matches": true
  }
}
```

### 6.3 Complete Installation


#### Request Schema

```json
{
  "attestation": true,
  "notes": "All items installed as specified"
}
```

### 6.4 API Requirements


## 7. State Transitions

### 7.1 AssignmentItem.item_status Transitions

```
[RECEIVED]
     â”‚
     â”‚ Start installation
     â–¼
[INSTALLING]
     â”‚
     â”‚ Photo captured
     â–¼
[PROOF_SUBMITTED]
     â”‚
     â”‚ Mark complete
     â–¼
[INSTALLED]
     â”‚
     â”œâ”€â”€â–º [RETAKE_REQUIRED] â”€â”€â–º [PROOF_SUBMITTED]
     â”‚
     â–¼
[VERIFIED] (after approval)
```

### 7.2 Location Slot States

```
[NOT_STARTED] â”€â”€â–º [IN_PROGRESS] â”€â”€â–º [COMPLETE]
                       â”‚
                       â””â”€â”€â–º [PARTIAL] (some items waived)
```

### 7.3 Install Survey View States

```
[LOADING]
    â”‚
    â”‚ Data loaded
    â–¼
[INTERACTIVE]
    â”‚
    â”œâ”€â”€â–º [SAVING] â”€â”€â–º [INTERACTIVE]
    â”‚
    â”œâ”€â”€â–º [CAMERA_OPEN] â”€â”€â–º [INTERACTIVE]
    â”‚
    â”‚ All complete
    â–¼
[READY_TO_COMPLETE]
    â”‚
    â”‚ Submit
    â–¼
[SUBMITTING] â”€â”€â–º [COMPLETE]
```

### 7.4 State Requirements


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Offline Support


### 8.3 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Screen Reader Announcements


### 9.3 ARIA Implementation

```html
<div role="region" aria-label="Installation survey">
  <div role="progressbar" aria-valuenow="75"
       aria-valuemin="0" aria-valuemax="100"
       aria-label="Overall progress">
    75%
  </div>

  <div class="accordion">
    <button aria-expanded="true" aria-controls="slot-1-content"
            id="slot-1-header">
      Front Window (2 of 2 complete)
    </button>
    <div id="slot-1-content" role="region"
         aria-labelledby="slot-1-header">
      <!-- Item cards -->
    </div>
  </div>
</div>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Edge Cases


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.1 - User Interface Requirements*


---
# M005 - Compliance Attestation

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M005
> **Route**: `/app/campaign/:id/attest`
> **IEEE 830 Section**: 3.2.5 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Compliance Attestation screen is the final legal and operational sign-off for a campaign installation. It requires the store manager or authorized personnel to certify that all materials have been installed according to brand standards, documented via photos, and that any issues have been reported. It features a digital signature capture for accountability.

### 1.2 Scope

This specification covers:
- 4-point compliance checklist verification
- Final summary of installed items and captured photos
- Digital signature pad for manager sign-off
- Submission logic with validation for incomplete tasks
- Role-based restriction (Manager only for final sign-off)

### 1.3 Screenshot Reference


### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Constraints

- User must have active `Membership` for the store
- Assignment item must belong to user's current store
- Campaign must be in PUBLISHED status with active install window

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Camera View Layout

![Compliance](./screenshots/Store_Execution/mobile_compliance.png)

### 3.4 Review View Layout

![Compliance](./screenshots/Store_Execution/mobile_compliance.png)

## 4. Data Requirements

### 4.1 Input Data


### 4.2 Output Data


### 4.3 Photo Metadata Captured


### 4.4 Data Model References


### 4.5 Data Requirements


## 5. Business Rules & Validation

### 5.1 Photo Rule Enforcement


### 5.2 Quality Validation (v1)


### 5.3 Upload Queue Rules


### 5.4 Flash Mode Settings


### 5.5 Validation Requirements


## 6. API Integration Points

### 6.1 Get Photo Rule


#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "min_photos": 1,
  "max_photos": 3,
  "ghost_image_url": "https://cdn.example.com/ghost/poster-template.png",
  "instructions": "Align poster with outline",
  "required_flash": false,
  "min_resolution": 1024
}
```

### 6.2 Create Photo Upload


#### Request Schema

```json
{
  "assignment_item_id": "uuid",
  "captured_at": "2026-01-01T10:30:00Z",
  "device_model": "iPhone 14",
  "gps_latitude": 40.7128,
  "gps_longitude": -74.0060,
  "file_size_bytes": 524288,
  "resolution": "1920x1080"
}
```

#### Response Schema (Success - 201)

```json
{
  "id": "uuid",
  "presigned_url": "https://s3.example.com/upload?signature=...",
  "expires_at": "2026-01-01T10:45:00Z"
}
```

### 6.3 Confirm Upload


#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "file_url": "https://cdn.example.com/photos/uuid.jpg",
  "thumbnail_url": "https://cdn.example.com/thumbs/uuid.jpg",
  "upload_status": "UPLOADED"
}
```

### 6.4 API Requirements


## 7. State Transitions

### 7.1 Photo Upload State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 Camera Flow State Machine


[Diagram - See rendered image above or refer to source document]


### 7.3 Offline Queue State Machine


[Diagram - See rendered image above or refer to source document]


### 7.4 State Requirements


## 8. Error Handling

### 8.1 Error Categories


### 8.2 Error Messages


### 8.3 Offline Behavior


### 8.4 Local Storage Structure

```javascript
{
  "photoQueue": [
    {
      "localId": "uuid-123",
      "assignmentItemId": "uuid-456",
      "imagePath": "/local/photos/uuid-123.jpg",
      "capturedAt": "2026-01-01T10:30:00Z",
      "status": "queued", // queued | uploading | failed
      "retryCount": 0,
      "metadata": {
        "device_model": "iPhone 14",
        "gps_latitude": 40.7128,
        "gps_longitude": -74.0060
      }
    }
  ]
}
```

### 8.5 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Assistive Technology Support


### 9.3 ARIA Implementation

```html
<div role="application" aria-label="Photo Capture">
  <button aria-label="Close camera" id="close-btn">X</button>
  <button aria-label="Flash mode: Auto" id="flash-toggle">Flash</button>

  <div role="img" aria-label="Camera viewfinder">
    <!-- Camera preview -->
  </div>

  <p aria-live="polite" id="instructions">
    Align poster with outline
  </p>

  <button aria-label="Take photo" id="shutter-btn">Capture</button>

  <div role="alert" id="quality-warning" aria-live="assertive">
    Photo resolution too low
  </div>
</div>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Security Acceptance


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.5 - User Interface Requirements*


---
# M006 - Task Navigation
 
 > **Module**: Store Execution (Mobile PWA)
 > **Screen ID**: M006
 > **Route**: `/app/tasks`
 > **IEEE 830 Section**: 3.2.6 - User Interface Requirements
 > **Version**: 1.1
 > **Last Updated**: 2026-01-02

 ## 1. Screen Overview
 
 ### 1.1 Purpose
 
 The Task Navigation screen (formerly Tasks List) provides a consolidated view of all pending work items for the store user. Tasks are dynamically derived from entity states and grouped by phase (Receive, Install, Deinstall, Attest).
 
 ### 1.2 Scope
 
 This specification covers:
 - Task derivation from entity states
 - Task list display with filtering (Receive / Install / Deinstall)
 - Priority calculation and sorting
 - Attestation workflow entry points
 
 ### 1.3 Screenshot Reference


### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Constraints

- User must have active `Membership` for the store
- Tasks visible only for campaigns assigned to user's store
- Attestation requires all mandatory photos to be uploaded

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Task Card Layout

![Tasks](./screenshots/Store_Execution/mobile_tasks.png)

### 3.4 Attestation Screen Layout

**Route**: `/app/campaign/:id/submit`

![Tasks](./screenshots/Store_Execution/mobile_tasks.png)

## 4. Data Requirements

### 4.1 Input Data


### 4.2 Output Data


### 4.3 Task Derivation Rules

Tasks are dynamically generated from entity states:

```
RECEIPT tasks:
  - StoreAssignment WHERE store_phase = READY_TO_RECEIVE

INSTALL tasks:
  - AssignmentItem WHERE item_status = RECEIVED
  - Grouped by LocationSlot

RETAKE tasks:
  - PhotoUpload WHERE review_status = REJECTED

ISSUE_UPDATE tasks:
  - IssueRequest WHERE status changed (RESOLVED, etc.)
```

### 4.4 Data Model References


### 4.5 Data Requirements


## 5. Business Rules & Validation

### 5.1 Task Type Definitions


### 5.2 Priority Calculation Rules


### 5.3 Filter Options


### 5.4 Attestation Rules


### 5.5 Validation Requirements


## 6. API Integration Points

### 6.1 Get Tasks Endpoint


#### Response Schema (Success - 200)

```json
{
  "tasks": [
    {
      "id": "derived-uuid",
      "type": "RETAKE",
      "priority": "HIGH",
      "title": "Retake Required",
      "subtitle": "Summer Promo - Front Window Poster",
      "description": "Wrong angle - please recapture",
      "due_date": "2026-01-01",
      "campaign_id": "uuid",
      "campaign_name": "Summer Promo",
      "assignment_item_id": "uuid",
      "photo_upload_id": "uuid"
    }
  ],
  "counts": {
    "total": 5,
    "high_priority": 2,
    "overdue": 1
  }
}
```

### 6.2 Submit Attestation Endpoint


#### Request Schema

```json
{
  "attestation_text": "I certify that all items shown above are installed correctly at this store.",
  "signature_data": "data:image/png;base64,..."
}
```

#### Response Schema (Success - 200)

```json
{
  "assignment_id": "uuid",
  "status": "SUBMITTED",
  "attested_at": "2026-01-01T14:30:00Z",
  "attested_by": "uuid",
  "signature_url": "https://cdn.example.com/signatures/uuid.png"
}
```

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Task Navigation State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 Attestation Submission State Machine


[Diagram - See rendered image above or refer to source document]


### 7.3 Assignment Status After Attestation

```
StoreAssignment.status:
  IN_PROGRESS â†’ SUBMITTED

CompletionAttestation:
  Created with attested_at, attested_by, signature_url
```

### 7.4 State Requirements


## 8. Error Handling

### 8.1 Error Categories


### 8.2 Error Messages


### 8.3 Attestation Validation Errors


### 8.4 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Assistive Technology Support


### 9.3 ARIA Implementation

```html
<div role="main" aria-labelledby="tasks-heading">
  <h1 id="tasks-heading">My Tasks <span aria-label="5 tasks">(5)</span></h1>

  <div role="group" aria-label="Task filters">
    <button role="radio" aria-checked="true">All</button>
    <button role="radio" aria-checked="false">Receipts</button>
    <button role="radio" aria-checked="false">Installs</button>
    <button role="radio" aria-checked="false">Retakes</button>
  </div>

  <ul role="list" aria-label="Task list">
    <li role="listitem">
      <article aria-labelledby="task-1-title">
        <span aria-label="High priority">HIGH</span>
        <h2 id="task-1-title">Retake Required</h2>
        <p>Summer Promo - Front Window Poster</p>
        <time datetime="2026-01-01">Due: Today</time>
        <button>View Details</button>
      </article>
    </li>
  </ul>
</div>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Security Acceptance


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.6 - User Interface Requirements*


---
# M007 - Profile Screen

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M007
> **Route**: `/app/profile`
> **IEEE 830 Section**: 3.2.7 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Profile screen provides user account management capabilities including personal information display and editing, notification preference configuration, PIN change functionality, and secure logout. It serves as the central hub for user-specific settings within the mobile PWA.

### 1.2 Scope

This specification covers:
- User profile display (name, email, phone, store)
- Profile editing (name, phone - email read-only)
- Notification preference toggles (email/push per type)
- PIN change workflow with current PIN verification
- Secure logout with session clearing
- App version display for support

### 1.3 Screenshot Reference

![Profile Screen](./screenshots/Store_Execution/mobile_profile.png)
*(Note: Tablet and Desktop views follow standard responsive scaling)*

### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Constraints

- Users can only view/edit their own profile
- Email address is read-only (managed by admin)
- Store assignment displayed but not editable

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Profile Layout

![Profile](./screenshots/Store_Execution/mobile_profile.png)

### 3.4 Edit Modal Layout

![Profile](./screenshots/Store_Execution/mobile_profile.png)

## 4. Data Requirements

### 4.1 Input Data


### 4.2 Output Data


### 4.3 User Settings Structure

```typescript
interface UserSettings {
  notifications: {
    shipment_updates: { email: boolean, push: boolean },
    photo_reviews: { email: boolean, push: boolean },
    campaign_reminders: { email: boolean, push: boolean },
    issue_updates: { email: boolean, push: boolean }
  },
  display: {
    theme: 'light' | 'dark' | 'system'
  }
}
```

### 4.4 Data Model References


### 4.5 Data Requirements


## 5. Business Rules & Validation

### 5.1 Profile Edit Rules


### 5.2 PIN Change Rules


### 5.3 Notification Type Defaults


### 5.4 Security Rules


### 5.5 Validation Requirements


## 6. API Integration Points

### 6.1 Get User Profile


#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "name": "John Doe",
  "email": "john@store.com",
  "phone": "(555) 123-4567",
  "avatar_url": "https://cdn.example.com/avatars/uuid.jpg",
  "memberships": [
    {
      "store_id": "uuid",
      "store_number": "STR-001",
      "store_name": "Acme Retail - Downtown",
      "role": "STORE_OPERATOR"
    }
  ],
  "notification_preferences": {
    "shipment_updates": { "email": true, "push": true },
    "photo_reviews": { "email": false, "push": true },
    "campaign_reminders": { "email": true, "push": true },
    "issue_updates": { "email": true, "push": false }
  }
}
```

### 6.2 Update User Profile


#### Request Schema

```json
{
  "name": "John Doe Updated",
  "phone": "(555) 987-6543"
}
```

### 6.3 Update Notification Preferences


#### Request Schema

```json
{
  "notification_type": "photo_reviews",
  "email_enabled": true,
  "push_enabled": true
}
```

### 6.4 Verify Current PIN


#### Request Schema

```json
{
  "pin": "1234"
}
```

### 6.5 Change PIN


#### Request Schema

```json
{
  "current_pin": "1234",
  "new_pin": "5678"
}
```

### 6.6 Logout


### 6.7 API Requirements


## 7. State Transitions

### 7.1 Profile Edit State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 PIN Change State Machine


[Diagram - See rendered image above or refer to source document]


### 7.3 Logout State Machine


[Diagram - See rendered image above or refer to source document]


### 7.4 State Requirements


## 8. Error Handling

### 8.1 Error Categories


### 8.2 Error Messages


### 8.3 PIN Change Error States


### 8.4 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Assistive Technology Support


### 9.3 ARIA Implementation

```html
<main role="main" aria-labelledby="profile-heading">
  <h1 id="profile-heading">Profile</h1>

  <section aria-labelledby="user-info-heading">
    <h2 id="user-info-heading">User Information</h2>
    <dl>
      <dt>Name</dt>
      <dd>John Doe</dd>
      <dt>Email</dt>
      <dd>john@store.com</dd>
    </dl>
    <button aria-label="Edit profile">Edit</button>
  </section>

  <section aria-labelledby="notifications-heading">
    <h2 id="notifications-heading">Notifications</h2>
    <div role="group" aria-labelledby="shipment-label">
      <span id="shipment-label">Shipment Updates</span>
      <label>
        Email
        <input type="checkbox" role="switch" aria-checked="true" />
      </label>
      <label>
        Push
        <input type="checkbox" role="switch" aria-checked="true" />
      </label>
    </div>
  </section>

  <button aria-label="Log out of application">Logout</button>
</main>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Security Acceptance


## 11. Traceability Matrix


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.7 - User Interface Requirements*


---
# M008 - Photo Retake

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M008
> **Route**: `/app/campaign/:id/retake`
> **IEEE 830 Section**: 3.2.8 - User Interface Requirements
> **Version**: 1.1
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Photo Retake screen guides store users through the process of recapturing rejected installation photos. It displays rejection reasons and admin feedback, provides side-by-side comparison between rejected and replacement photos, and manages the supersession workflow where new photos replace rejected ones.

### 1.2 Scope

This specification covers:
- Display of rejected photos with rejection reasons
- Admin comment viewing for retake guidance
- Camera integration for replacement photo capture
- Side-by-side before/after comparison
- Photo supersession workflow (old -> SUPERSEDED, new -> PENDING)

### 1.3 Screenshot Reference

![Retake Flow Screen](./screenshots/Store_Execution/mobile_photo_captured.png)
*(Note: View shows the review state after capture; Tablet/Desktop modes scale responsively)*

### 1.4 Source Documents


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role Requirements


### 2.3 Permission Constraints

- User must have active `Membership` for the store
- Assignment must belong to user's store
- Campaign must still be in active install window or grace period

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Component Requirements


### 3.3 Single Retake Card Layout

![Retake](./screenshots/Store_Execution/mobile_retake.png)

### 3.4 After Capture Layout

![Retake](./screenshots/Store_Execution/mobile_retake.png)

### 3.5 Multiple Retakes List Layout

![Retake](./screenshots/Store_Execution/mobile_retake.png)

## 4. Data Requirements

### 4.1 Input Data


### 4.2 Output Data


### 4.3 Data Model References


### 4.4 Status Transitions

```
PhotoUpload (old):
  review_status: REJECTED -> SUPERSEDED (after retake submitted)

PhotoUpload (new):
  Created with review_status: PENDING

AssignmentItem:
  item_status: RETAKE_REQUIRED -> PROOF_SUBMITTED (after retake)
```

### 4.5 Data Requirements


## 5. Business Rules & Validation

### 5.1 Rejection Reason Codes


### 5.2 Retake Workflow Rules


### 5.3 Photo Supersession Rules


### 5.4 Deep Link Format

```
newpopsys://app/campaign/{campaignId}/retake?items={assignmentItemIds}
```

### 5.5 Validation Requirements


## 6. API Integration Points

### 6.1 Get Rejected Photos


#### Response Schema (Success - 200)

```json
{
  "rejected_photos": [
    {
      "id": "uuid",
      "file_url": "https://cdn.example.com/photos/uuid.jpg",
      "thumbnail_url": "https://cdn.example.com/thumbs/uuid.jpg",
      "assignment_item_id": "uuid",
      "kit_item": {
        "name": "Front Window Poster",
        "description": "Main promotional poster"
      },
      "location_slot": {
        "name": "Front Window"
      },
      "review": {
        "rejection_reason": "WRONG_ANGLE",
        "admin_comment": "Please capture the poster straight-on, not at an angle. Ensure all corners are visible.",
        "reviewed_at": "2026-01-01T10:00:00Z",
        "reviewer_name": "Jane Admin"
      },
      "photo_rule": {
        "ghost_image_url": "https://cdn.example.com/ghosts/poster.png",
        "instructions": "Align poster with outline"
      }
    }
  ]
}
```

### 6.2 Create Retake Photo


#### Request Schema

```json
{
  "assignment_item_id": "uuid",
  "supersedes_id": "uuid",
  "captured_at": "2026-01-01T14:30:00Z",
  "device_model": "iPhone 14",
  "gps_latitude": 40.7128,
  "gps_longitude": -74.0060
}
```

### 6.3 Confirm Upload


### 6.4 Mark Photo Superseded


#### Request Schema

```json
{
  "superseded_by": "uuid"
}
```

#### Response Schema (Success - 200)

```json
{
  "id": "uuid",
  "review_status": "SUPERSEDED",
  "superseded_by": "uuid",
  "superseded_at": "2026-01-01T14:35:00Z"
}
```

### 6.5 API Requirements


## 7. State Transitions

### 7.1 Retake Flow State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 Photo Status State Machine


[Diagram - See rendered image above or refer to source document]


### 7.3 Assignment Item State Machine


[Diagram - See rendered image above or refer to source document]


### 7.4 State Requirements


## 8. Error Handling

### 8.1 Error Categories


### 8.2 Error Messages


### 8.3 Offline Behavior


### 8.4 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Assistive Technology Support


### 9.3 ARIA Implementation

```html
<main role="main" aria-labelledby="retake-heading">
  <h1 id="retake-heading">Retake Required</h1>
  <h2>Front Window Poster</h2>

  <figure role="group" aria-labelledby="rejected-caption">
    <img src="rejected.jpg"
         alt="Rejected photo of Front Window Poster installation"
         aria-describedby="rejection-reason" />
    <figcaption id="rejected-caption">
      <span id="rejection-reason" role="status">
        Rejected: Wrong Angle
      </span>
    </figcaption>
  </figure>

  <blockquote aria-label="Reviewer feedback">
    Please capture the poster straight-on, not at an angle.
    Ensure all corners are visible.
  </blockquote>

  <button aria-label="Open camera to retake photo">
    Retake Photo
  </button>

  <div role="region" aria-labelledby="comparison-heading" hidden>
    <h3 id="comparison-heading">Comparison</h3>
    <div role="group" aria-label="Before and after photos">
      <img src="before.jpg" alt="Before: rejected photo" />
      <img src="after.jpg" alt="After: new replacement photo" />
    </div>
    <button>Retake Again</button>
    <button>Submit Replacement</button>
  </div>
</main>
```

## 10. Acceptance Criteria

### 10.1 Functional Acceptance


### 10.2 Non-Functional Acceptance


### 10.3 Security Acceptance


## 11. Traceability Matrix


## 12. Notification Triggers

When photos are rejected, the system sends notifications:


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2.8 - User Interface Requirements*


---
# M009 - Deinstall Checklist

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M009
> **Route**: `/app/campaign/:id/deinstall`
> **IEEE 830 Section**: 3.2.9 - User Interface Requirements
> **Version**: 1.0
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Deinstall Checklist screen facilitates the removal of POP materials once a campaign has ended. It provides a list of all items previously installed and requires the user to confirm their removal. This ensures that old promotional materials are not left in-store, maintaining brand consistency and clearing space for new campaigns.

### 1.2 Scope

This specification covers:
- List of installed items for removal
- Multi-select removal confirmation
- Disposal instructions per item type (e.g., "Recycle", "Return to Brand")
- Progress tracking for deinstallation phase

### 1.3 Screenshot Reference


## 2. User Roles & Permissions

### 2.1 Authorized Roles


## 3. UI Components

### 3.1 Component Inventory


## 10. Acceptance Criteria

### 10.1 Functional Acceptance


*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2.9 - User Interface Requirements*


---
# M010 - Deinstall Confirmation

> **Module**: Store Execution (Mobile PWA)
> **Screen ID**: M010
> **Route**: `/app/campaign/:id/deinstall/confirm`
> **IEEE 830 Section**: 3.2.10 - User Interface Requirements
> **Version**: 1.0
> **Last Updated**: 2026-01-02

## 1. Screen Overview

### 1.1 Purpose

The Deinstall Confirmation screen serves as the final sign-off for the removal lifecycle. Users provide a final attestation that the deinstallation is complete and the store area is ready for the next campaign.

### 1.2 Scope

This specification covers:
- Final summary of deinstalled items
- Completion attestation checkbox
- Digital signature (if required by brand)
- Campaign closure trigger

### 1.3 Screenshot Reference


## 2. User Roles & Permissions

### 2.1 Authorized Roles


## 3. UI Components


## 10. Acceptance Criteria


*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2.10 - User Interface Requirements*


---

# Section 7: Brand Admin Module
# Module Overview: BrandAdmin (A-Series)

> **Module ID:** MOD-ADMIN
> **Screen Range:** A001 – A010
> **Version:** 1.0
> **Last Updated:** 2025-01-01

## 1. Module Summary

### Purpose

The BrandAdmin module provides brand-level administration capabilities for managing marketing campaigns, digital assets, store networks, and performance reporting. This module serves as the central control hub for brand administrators to oversee all POP/POS marketing activities across their retail network.

### Core Capabilities


### Target Users

- Brand Administrators
- Campaign Managers
- Regional Managers
- Marketing Operations Teams

## 2. Screen Inventory


**Status Legend:** Planned | In Development | Complete | Reserved

## 3. Module Dependencies

### Internal Services


### External Integrations


## 4. RBAC Summary

### Role Permissions Matrix


### Role Descriptions

- **BRAND_ADMIN:** Full administrative access to all module features
- **CAMPAIGN_MANAGER:** Campaign and asset management; no user/store admin
- **REGIONAL_MANAGER:** View-only access with regional data filtering

## 5. Key Integration Points

### Asset Management Integration

- Upload and categorize marketing assets
- Version control with approval workflows
- Automatic thumbnail and preview generation
- CDN distribution to store displays

### Campaign Workflow Integration

- Campaign creation with asset assignment
- Store targeting and scheduling
- Multi-level approval chains
- Automated deployment triggers

### Approval Chain Integration


### Data Flow

```
Asset Upload  Approval Queue  Asset Library  Campaign Assignment
                                                       
Store Selection  Campaign Schedule  Campaign Creation
       
   Deployment  Store Displays
```

## 6. Revision History

*This document provides a high-level overview of the BrandAdmin module. For detailed screen specifications, refer to individual SRS documents (A001-SRS through A006-SRS).*


---
# B001 - Brand Admin Dashboard

> **SRS Section**: 7.1.1 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Brand Admin Dashboard serves as the primary landing page for brand-level users, providing at-a-glance visibility into campaign performance, store compliance, and pending actions requiring attention.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/dashboard`
- **Entry Points**:
  - Direct URL navigation
  - Post-login redirect (default landing)
  - Brand logo/home link in navigation

### 1.4 Screenshot Reference

![Dashboard](./screenshots/Admin_Portal/admin_portal_dashboard.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Data Scoping Rules


## 3. UI Components

### 3.1 Layout Structure

![Brand Admin Dashboard](./screenshots/Admin_Portal/admin_portal_dashboard.png)


### 3.2 Component Specifications


### 3.3 KPI Card Definitions


### 3.4 Component States


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 Aggregation Queries


### 4.3 Data Refresh


## 5. Business Rules & Validation

### 5.1 Display Rules


### 5.2 Scoping Rules


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Request/Response Specifications

**GET /api/v1/dashboard/summary**

```json
// Response 200 OK
{
  "activeCampaigns": 12,
  "totalStores": 847,
  "pendingReviews": 23,
  "complianceRate": 94.2,
  "lastUpdated": "2026-01-01T10:30:00Z"
}
```

**GET /api/v1/campaigns?limit=5&sort=-updated_at&status[]=PUBLISHED&status[]=DRAFT**

```json
// Response 200 OK
{
  "data": [
    {
      "id": "uuid",
      "name": "Summer Promo 2025",
      "status": "PUBLISHED",
      "storeCount": 234,
      "completionRate": 80.0,
      "installStart": "2025-12-01",
      "installEnd": "2025-12-31"
    }
  ],
  "meta": {
    "total": 5,
    "limit": 5,
    "offset": 0
  }
}
```

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Page Load State Machine

[Diagram - See rendered image above or refer to source document]

### 7.2 State Definitions


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---
# B002 - Campaign List

> **SRS Section**: 7.1.2 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Campaign List screen provides brand administrators with a comprehensive view of all campaigns across their lifecycle states. It serves as the primary campaign management hub for creating, monitoring, and administering promotional campaigns.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/campaigns`
- **Entry Points**:
  - Main navigation: "Campaigns" menu item
  - Dashboard: Active Campaigns KPI click-through
  - Quick Actions: "New Campaign" redirects here after creation

### 1.4 Screenshot Reference

![Campaign List](./screenshots/Admin_Portal/admin_portal_campaigns.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Scoping Requirements


## 3. UI Components

### 3.1 Layout Structure

![Campaign List Wireframe](./screenshots/Admin_Portal/admin_portal_campaigns.png)


### 3.2 Component Specifications


### 3.3 Status Tab Definitions


### 3.4 Campaign Status Badges


### 3.5 Row Action Menu


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 List Query Requirements


### 4.3 Default Sort Order


## 5. Business Rules & Validation

### 5.1 Status Transition Rules


### 5.2 Delete Rules


### 5.3 Duplicate Rules


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 List Request Parameters

```
GET /api/v1/campaigns
  ?status[]=PUBLISHED&status[]=DRAFT
  &search=summer
  &sort=-updated_at
  &page=1
  &limit=20
```

### 6.3 List Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "name": "Summer Promo 2025",
      "status": "PUBLISHED",
      "installStart": "2025-12-01",
      "installEnd": "2025-12-31",
      "storeCount": 234,
      "completedCount": 187,
      "completionRate": 79.9,
      "createdAt": "2025-11-01T10:00:00Z",
      "updatedAt": "2025-12-15T14:30:00Z",
      "createdBy": {
        "id": "uuid",
        "name": "John Smith"
      }
    }
  ],
  "meta": {
    "total": 47,
    "page": 1,
    "limit": 20,
    "totalPages": 3
  }
}
```

### 6.4 API Requirements


## 7. State Transitions

### 7.1 Campaign Lifecycle State Machine

[Diagram - See rendered image above or refer to source document]

### 7.2 UI State Management


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---
# B003 - Store Selection

> **SRS Section**: 7.1.3 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Store Selection screen is the first step in the Campaign Builder wizard. It allows campaign creators to define which stores will participate in a campaign using a rule-based "Selection Recipe" system that supports both inclusion and exclusion criteria.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/campaigns/create/stores` (new campaign)
- **Route**: `/admin/campaigns/:id/edit/stores` (edit existing)
- **Entry Points**:
  - Campaign List: "New Campaign" button
  - Campaign Detail: "Edit" action (draft only)
- **Wizard Position**: Step 1 of 3

### 1.4 Screenshot Reference

![Store Selection](./screenshots/Admin_Portal/admin_portal_stores_tab.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Only for assigned campaigns | N = No access

### 2.2 Data Scoping Requirements


## 3. UI Components

### 3.1 Layout Structure
![Store Selection Wireframe](./screenshots/Admin_Portal/admin_portal_store_selection.png)

### 3.2 Component Specifications


### 3.3 Rule Builder Fields


### 3.4 Component States


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 Selection Recipe Schema

```json
{
  "version": 1,
  "include": [
    {
      "field": "region_id",
      "operator": "IN",
      "values": ["uuid1", "uuid2"]
    },
    {
      "field": "group_id",
      "operator": "=",
      "value": "uuid3"
    }
  ],
  "exclude": [
    {
      "field": "status",
      "operator": "=",
      "value": "INACTIVE"
    }
  ],
  "logic": "AND"
}
```

### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Campaign Name Validation


### 5.2 Selection Recipe Rules


### 5.3 Rule Hierarchy


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Preview Request

```json
// POST /api/v1/campaigns/{id}/preview-stores
{
  "selectionRecipe": {
    "include": [
      {"field": "region_id", "operator": "IN", "values": ["uuid1"]}
    ],
    "exclude": [
      {"field": "status", "operator": "=", "value": "INACTIVE"}
    ]
  }
}
```

### 6.3 Preview Response

```json
{
  "count": 234,
  "breakdown": {
    "byRegion": [
      {"regionId": "uuid1", "name": "Northeast", "count": 156},
      {"regionId": "uuid2", "name": "Midwest", "count": 78}
    ],
    "byStatus": [
      {"status": "ACTIVE", "count": 234}
    ]
  }
}
```

### 6.4 Save Campaign Request

```json
// PATCH /api/v1/campaigns/{id}
{
  "name": "Summer Promo 2025",
  "selectionRecipe": {
    "version": 1,
    "include": [...],
    "exclude": [...],
    "logic": "AND"
  }
}
```

### 6.5 API Requirements


## 7. State Transitions

### 7.1 Wizard Navigation State Machine

[Diagram - See rendered image above or refer to source document]

### 7.2 Form State Machine

[Diagram - See rendered image above or refer to source document]

### 7.3 Preview State


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Validation Messages


### 8.3 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---
# B004 - Kit Definition

> **SRS Section**: 7.1.4 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Kit Definition screen is the second step in the Campaign Builder wizard. It allows campaign creators to define the promotional materials (kit items) that will be distributed to stores, including item specifications, quantities, and optional placement requirements.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/campaigns/:id/edit/kit`
- **Entry Points**:
  - Campaign Builder Step 1: "Save & Continue" button
  - Campaign Detail: "Edit" action (draft only)
- **Wizard Position**: Step 2 of 3

### 1.4 Screenshot Reference

![Kit Definition](./screenshots/Admin_Portal/admin_portal_new_campaign_wizard.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Only for assigned campaigns | N = No access

### 2.2 Data Scoping Requirements


## 3. UI Components

### 3.1 Layout Structure
![Kit Definition Wireframe](./screenshots/Admin_Portal/admin_portal_kit_definition.png)

### 3.2 Component Specifications


### 3.3 Kit Item Types


### 3.4 Location Slot Options


### 3.5 Component States


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 Kit Item Schema

```json
{
  "id": "uuid",
  "kitDefinitionId": "uuid",
  "name": "Summer Poster (24x36)",
  "sku": "POSTER-SUM-2436",
  "itemType": "POSTER",
  "quantity": 2,
  "locationSlotId": "uuid|null",
  "sortOrder": 1,
  "photoRule": {
    "minPhotos": 1,
    "requiredAngles": ["front"],
    "instructions": "Capture full poster with surrounding context"
  }
}
```

### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Kit Item Validation


### 5.2 Kit Definition Rules


### 5.3 Photo Rule Configuration


### 5.4 Location Slot Rules


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Get Kit Definition Response

```json
// GET /api/v1/campaigns/{id}/kit
{
  "id": "uuid",
  "campaignId": "uuid",
  "name": "Summer Promo 2025 Kit",
  "items": [
    {
      "id": "uuid",
      "name": "Summer Poster (24x36)",
      "sku": "POSTER-SUM-001",
      "itemType": "POSTER",
      "quantity": 2,
      "sortOrder": 1,
      "locationSlot": {
        "id": "uuid",
        "code": "FRONT_WINDOW",
        "name": "Front Window"
      },
      "photoRule": {
        "minPhotos": 1,
        "requiredAngles": ["front"],
        "instructions": "Capture full poster"
      }
    }
  ],
  "summary": {
    "itemCount": 3,
    "totalUnits": 7
  }
}
```

### 6.3 Add Item Request

```json
// POST /api/v1/campaigns/{id}/kit/items
{
  "name": "Counter Display Stand",
  "itemType": "COUNTER_DISPLAY",
  "quantity": 1,
  "locationSlotId": null,
  "photoRule": {
    "enabled": false
  }
}
```

### 6.4 Reorder Items Request

```json
// POST /api/v1/campaigns/{id}/kit/items/reorder
{
  "itemOrder": [
    { "itemId": "uuid1", "sortOrder": 1 },
    { "itemId": "uuid2", "sortOrder": 2 },
    { "itemId": "uuid3", "sortOrder": 3 }
  ]
}
```

### 6.5 API Requirements


## 7. State Transitions

### 7.1 Wizard Navigation State Machine

[Diagram - See rendered image above or refer to source document]

### 7.2 Item Edit State Machine

[Diagram - See rendered image above or refer to source document]

### 7.3 Drag-Drop State Machine

[Diagram - See rendered image above or refer to source document]

### 7.4 Item Card States


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Validation Messages


### 8.3 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---
# B005 - Campaign Review & Launch

> **SRS Section**: 7.1.5 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Campaign Review screen is the final step in the Campaign Builder wizard. It presents a comprehensive summary of the campaign configuration including selected stores, kit definitions, and scheduling details. Upon approval, the publish action creates store assignments and triggers initial order generation.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/campaigns/:id/edit/review` (wizard step 3)
- **Route**: `/admin/campaigns/:id/review` (standalone review)
- **Entry Points**:
  - Campaign Builder: "Continue" from Kit Definition step
  - Campaign Detail: "Review" action (draft only)
- **Wizard Position**: Step 3 of 3

### 1.4 Screenshot Reference

![Campaign Review](./screenshots/Admin_Portal/admin_portal_new_campaign_wizard.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Only for assigned campaigns | N = No access

### 2.2 Data Scoping Requirements


## 3. UI Components

### 3.1 Layout Structure

![Campaign Review Wireframe](./screenshots/Admin_Portal/admin_portal_new_campaign_wizard.png)


### 3.2 Component Specifications


### 3.3 Summary Card Details

#### 3.3.1 Store Selection Summary


#### 3.3.2 Kit Definition Summary


### 3.4 Pre-Launch Checklist Items


### 3.5 Component States


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 Campaign Summary Query

```sql
SELECT
  c.id,
  c.name,
  c.status,
  c.install_start,
  c.install_end,
  c.selection_recipe_json,
  COUNT(DISTINCT ki.id) as item_count,
  SUM(ki.quantity) as total_pieces,
  COUNT(DISTINCT ki.photo_rule_id) FILTER (WHERE ki.photo_rule_id IS NOT NULL) as photo_rule_count
FROM campaigns c
LEFT JOIN kit_definitions kd ON kd.campaign_id = c.id
LEFT JOIN kit_items ki ON ki.kit_definition_id = kd.id
WHERE c.id = :campaign_id
  AND c.deleted_at IS NULL
GROUP BY c.id;
```

### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Date Validation Rules


### 5.2 Publish Prerequisites


### 5.3 Publish Actions


### 5.4 Late Installation Option


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Summary Request

```json
// GET /api/v1/campaigns/{id}/summary
// Response 200 OK
{
  "campaign": {
    "id": "uuid",
    "name": "Summer Promo 2025",
    "status": "DRAFT",
    "installStart": "2025-12-01",
    "installEnd": "2025-12-31",
    "allowLateInstallation": true,
    "gracePeriodDays": 7
  },
  "storeSelection": {
    "totalStores": 234,
    "regions": [
      {"id": "uuid", "name": "Northeast", "storeCount": 156},
      {"id": "uuid", "name": "Midwest", "storeCount": 78}
    ],
    "exclusionCount": 0
  },
  "kitDefinition": {
    "itemCount": 5,
    "totalPieces": 12,
    "photoRequirements": 3,
    "items": [
      {"id": "uuid", "name": "Window Banner", "quantity": 2, "hasSku": true},
      {"id": "uuid", "name": "Counter Display", "quantity": 1, "hasSku": false}
    ]
  },
  "checklist": {
    "campaignName": {"passed": true, "message": "Campaign name defined"},
    "storeSelection": {"passed": true, "message": "234 stores selected"},
    "kitItems": {"passed": true, "message": "5 items defined"},
    "photoRules": {"passed": true, "message": "Photo requirements configured"},
    "installDates": {"passed": true, "message": "Install dates set"},
    "itemSkus": {"passed": false, "message": "2 items missing SKUs", "fixable": true}
  },
  "readyToPublish": false
}
```

### 6.3 Validate Request

```json
// POST /api/v1/campaigns/{id}/validate
// Response 200 OK
{
  "valid": false,
  "errors": [
    {
      "code": "MISSING_SKU",
      "field": "kit_items",
      "message": "2 items are missing SKUs",
      "itemIds": ["uuid1", "uuid2"]
    }
  ],
  "warnings": [
    {
      "code": "LARGE_CAMPAIGN",
      "message": "This campaign will create 234 store assignments"
    }
  ]
}
```

### 6.4 Publish Request

```json
// POST /api/v1/campaigns/{id}/publish
{
  "installStart": "2025-12-01",
  "installEnd": "2025-12-31",
  "allowLateInstallation": true,
  "gracePeriodDays": 7,
  "notifyStores": true
}
```

### 6.5 Publish Response

```json
// Response 200 OK
{
  "campaign": {
    "id": "uuid",
    "status": "SCHEDULED",
    "publishedAt": "2025-11-15T10:30:00Z",
    "publishedBy": "uuid"
  },
  "assignments": {
    "created": 234,
    "storeOrders": 234
  },
  "notifications": {
    "scheduled": 234,
    "method": "email"
  }
}
```

### 6.6 API Requirements


## 7. State Transitions

### 7.1 Campaign Status Transition (Publish)

[Diagram - See rendered image above or refer to source document]

### 7.2 Wizard Navigation State Machine

[Diagram - See rendered image above or refer to source document]

### 7.3 Publish State Machine

[Diagram - See rendered image above or refer to source document]

### 7.4 UI State Transitions


## 8. Error Handling

### 8.1 Validation Errors


### 8.2 Publish Errors


### 8.3 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---
# B006 - Store List

> **SRS Section**: 7.1.6 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Store List screen provides brand administrators with a comprehensive view of all stores within their brand. It enables store management, status monitoring, group assignments, and quick access to individual store details and campaign participation.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/stores`
- **Entry Points**:
  - Main navigation: "Stores" menu item
  - Dashboard: "Total Stores" KPI click-through
  - Campaign Detail: Store list link

### 1.4 Screenshot Reference

![Store List](./screenshots/Admin_Portal/admin_portal_stores_tab.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Data Scoping Requirements


## 3. UI Components

### 3.1 Layout Structure

### 3.1 Layout Structure
![Store List Wireframe](./screenshots/Admin_Portal/admin_portal_store_list.png)

### 3.2 Component Specifications


### 3.3 Status Tab Definitions


### 3.4 Store Status Badges


### 3.5 Store Row Information


### 3.6 Row Action Menu


### 3.7 Component States


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 List Query Requirements


### 4.3 Default Sort Order


## 5. Business Rules & Validation

### 5.1 Store Status Rules


### 5.2 Store Group Rules


### 5.3 Invitation Rules


### 5.4 Bulk Operation Rules


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 List Request Parameters

```
GET /api/v1/stores
  ?status[]=ACTIVE&status[]=ONBOARDING
  &region_id=uuid
  &group_id=uuid
  &search=downtown
  &sort=store_number
  &page=1
  &limit=20
```

### 6.3 List Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "storeNumber": "1234",
      "name": "Downtown Location",
      "addressLine1": "789 Main Street",
      "city": "Boston",
      "state": "MA",
      "zipCode": "02101",
      "status": "ACTIVE",
      "region": {
        "id": "uuid",
        "name": "Northeast"
      },
      "district": {
        "id": "uuid",
        "name": "New England"
      },
      "activeCampaigns": 3,
      "groups": [
        {"id": "uuid", "name": "Premium Locations"}
      ],
      "createdAt": "2025-01-15T10:00:00Z",
      "updatedAt": "2025-12-01T14:30:00Z"
    }
  ],
  "meta": {
    "total": 847,
    "page": 1,
    "limit": 20,
    "totalPages": 43
  },
  "statusCounts": {
    "ACTIVE": 780,
    "INACTIVE": 45,
    "ONBOARDING": 20,
    "SUSPENDED": 2
  }
}
```

### 6.4 Status Change Request

```json
// PATCH /api/v1/stores/{id}/status
{
  "status": "INACTIVE",
  "reason": "Temporary closure for renovation",
  "effectiveDate": "2025-12-15"
}
```

### 6.5 Bulk Status Change Request

```json
// PATCH /api/v1/stores/bulk/status
{
  "storeIds": ["uuid1", "uuid2", "uuid3"],
  "status": "INACTIVE",
  "reason": "Seasonal closure"
}
```

### 6.6 Export Request

```json
// POST /api/v1/stores/export
{
  "format": "csv",
  "filters": {
    "status": ["ACTIVE"],
    "regionId": "uuid"
  },
  "fields": ["storeNumber", "name", "address", "region", "status", "campaigns"]
}
```

### 6.7 API Requirements


## 7. State Transitions

### 7.1 Store Status State Machine

[Diagram - See rendered image above or refer to source document]

### 7.2 Store Status Transitions

```

### 7.4 Page State Definitions


[Diagram - See rendered image above or refer to source document]


### 8.2 Validation Messages


### 8.3 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---
# B007 - Photo Verification Queue

> **SRS Section**: 7.1.7 | **Module**: BrandAdmin (B-Series)
> **Version**: 1.0 | **Status**: Draft
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Photo Verification Queue provides brand administrators with a streamlined interface for reviewing store-submitted installation photos. It enables efficient approval or rejection of photos, management of retake requests, and tracking of verification progress across campaigns.

### 1.2 Access Control


### 1.3 Navigation Path

- **Route**: `/admin/verification`
- **Route**: `/admin/verification?campaign={id}` (campaign-filtered)
- **Entry Points**:
  - Main navigation: "Verification" menu item
  - Dashboard: "Pending Reviews" KPI click-through
  - Campaign Detail: "Review Photos" action

### 1.4 Screenshot Reference

![Verification Queue](./screenshots/Admin_Portal/admin_portal_verification.png)

## 2. User Roles & Permissions

### 2.1 Role-Based Access Matrix


**Legend**: Y = Full access | Y* = Scoped access | N = No access

### 2.2 Data Scoping Requirements


## 3. UI Components

### 3.1 Layout Structure
![Verification Queue Wireframe](./screenshots/Admin_Portal/admin_portal_verification.png)

### 3.2 Component Specifications


### 3.3 Status Tab Definitions


### 3.4 Photo Review Status Badges


### 3.5 Photo Card Information


### 3.6 Photo Card Actions


### 3.7 Rejection Reason Codes


### 3.8 Component States


## 4. Data Requirements

### 4.1 Entities & Fields


### 4.2 Queue Query Requirements


### 4.3 Photo URL Requirements


## 5. Business Rules & Validation

### 5.1 Review Decision Rules


### 5.2 Retake Request Rules


### 5.3 Assignment Completion Rules


### 5.4 Bulk Operation Rules


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 List Request Parameters

```
GET /api/v1/photos
  ?status=PENDING
  &campaign_id=uuid
  &store_id=uuid
  &sort=-created_at
  &page=1
  &limit=20
```

### 6.3 List Response Schema

```json
{
  "data": [
    {
      "id": "uuid",
      "thumbnailUrl": "https://cdn.example.com/photos/thumb/...",
      "fullSizeUrl": "https://cdn.example.com/photos/full/...",
      "reviewStatus": "PENDING",
      "createdAt": "2025-12-15T14:30:00Z",
      "submissionNumber": 1,
      "store": {
        "id": "uuid",
        "storeNumber": "1234"
      },
      "campaign": {
        "id": "uuid",
        "name": "Summer Promo 2025"
      },
      "kitItem": {
        "id": "uuid",
        "name": "Window Banner"
      },
      "locationSlot": {
        "id": "uuid",
        "slotCode": "FRONT_WINDOW",
        "displayName": "Front Window"
      },
      "assignmentItem": {
        "id": "uuid",
        "status": "SUBMITTED"
      }
    }
  ],
  "meta": {
    "total": 23,
    "page": 1,
    "limit": 20,
    "totalPages": 2
  },
  "statusCounts": {
    "PENDING": 23,
    "APPROVED": 456,
    "REJECTED": 34,
    "SUPERSEDED": 12
  }
}
```

### 6.4 Review Request

```json
// POST /api/v1/photos/{id}/review
{
  "decision": "REJECTED",
  "reasonCode": "WRONG_ANGLE",
  "comment": "Please retake photo from the front of the store"
}
```

### 6.5 Review Response

```json
{
  "photoReview": {
    "id": "uuid",
    "photoId": "uuid",
    "decision": "REJECTED",
    "reasonCode": "WRONG_ANGLE",
    "comment": "Please retake photo from the front of the store",
    "reviewerId": "uuid",
    "createdAt": "2025-12-15T15:00:00Z"
  },
  "retakeRequest": {
    "id": "uuid",
    "photoId": "uuid",
    "reason": "WRONG_ANGLE",
    "createdAt": "2025-12-15T15:00:00Z"
  },
  "notification": {
    "sent": true,
    "method": "push",
    "recipient": "store_manager@store1234.com"
  }
}
```

### 6.6 Bulk Approve Request

```json
// POST /api/v1/photos/bulk/approve
{
  "photoIds": ["uuid1", "uuid2", "uuid3"],
  "comment": "Batch approval for verified installations"
}
```

### 6.7 Bulk Reject Request

```json
// POST /api/v1/photos/bulk/reject
{
  "photoIds": ["uuid1", "uuid2"],
  "reasonCode": "TOO_DARK",
  "comment": "Please retake with better lighting"
}
```

### 6.8 API Requirements


## 7. State Transitions

### 7.1 Photo Review Status State Machine

[Diagram - See rendered image above or refer to source document]

### 7.2 Photo Review Transitions


### 7.3 Assignment Item Status Updates

[Diagram - See rendered image above or refer to source document]

### 7.4 UI State Machine
[Diagram - See rendered image above or refer to source document]
### 7.5 Photo Modal States


### 8.3 Error Requirements


## 9. Accessibility Requirements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Test Scenarios


## 11. Related Screens


## 12. Revision History

*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements / Screen Specifications*


---

# Section 8: PSP Operations Module


---
# P001 - Order Queue Screen Specification

> **Module**: PSP Operations Portal
> **Screen ID**: P001
> **Route**: `/psp/orders`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **SUPP Reference**: SUPP-016 (Fulfillment - Order Processing)

## 1. Screen Overview

### 1.1 Purpose

The Order Queue screen provides PSP Production Operators with a centralized view of all store orders requiring fulfillment action. It enables order acknowledgment, status tracking, and drill-down access to order details for production processing.

### 1.2 Business Context

This screen serves as the primary work queue for PSP fulfillment operations. Orders flow from campaign assignments through to shipment, with this screen managing the critical handoff between order generation and production.

### 1.3 Screenshot Reference

![Order Queue Screen](./screenshots/PSP_Operations/psp_ops_orders.png)

### 1.4 Navigation Path

```
PSP Portal  Orders (sidebar)  /psp/orders
```

### 1.5 Related Screens


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Permission Requirements


### 2.3 Data Scope

- **Tenant Isolation**: Orders filtered by JWT tenant_id
- **Brand Visibility**: All brands within tenant visible
- **Campaign Scope**: All campaigns across brands visible

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Layout Specification


![Order Queue](./screenshots/PSP_Operations/psp_ops_orders.png)


### 3.3 Component Specifications

#### P001-C001: Page Header


#### P001-C005: Order Table


## 4. Data Requirements

### 4.1 Entity Mapping


### 4.2 Data Query


![Order Queue](./screenshots/PSP_Operations/psp_ops_orders.png)


### 4.3 Data Requirements Matrix


## 5. Business Rules & Validation

### 5.1 Order Status Rules


### 5.2 Validation Rules


### 5.3 Business Constraints


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Request/Response Schemas

#### GET /api/v1/orders

**Request Parameters:**


**Response Schema:**

```json
{
  "data": [
    {
      "id": "uuid",
      "order_number": "ORD-1234",
      "status": "GENERATED",
      "order_type": "INITIAL",
      "psp_order_ref": "PSP-REF-001",
      "created_at": "2025-12-15T10:30:00Z",
      "acknowledged_at": null,
      "store": {
        "id": "uuid",
        "store_number": "STR-001",
        "name": "Downtown Store"
      },
      "campaign": {
        "id": "uuid",
        "name": "Summer Promo"
      },
      "brand": {
        "id": "uuid",
        "name": "Acme Corp"
      },
      "line_count": 5,
      "total_quantity": 12
    }
  ],
  "pagination": {
    "page": 1,
    "page_size": 25,
    "total_items": 299,
    "total_pages": 12
  }
}
```

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Order Status State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 State Transition Requirements


### 7.3 Status Display Mapping


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Error Display


### 8.3 Logging Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Keyboard Navigation


### 9.3 Screen Reader Support


## 10. Acceptance Criteria

### 10.1 Functional Acceptance Criteria


### 10.2 Non-Functional Acceptance Criteria


### 10.3 Traceability Matrix


## Appendix A: Revision History

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*


---
# P002 - Shipments Screen Specification

> **Module**: PSP Operations Portal
> **Screen ID**: P002
> **Route**: `/psp/shipments`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **SUPP Reference**: SUPP-016 (Fulfillment - Shipment Processing)

## 1. Screen Overview

### 1.1 Purpose

The Shipments screen enables PSP Production Operators to create, track, and manage shipments for fulfilled orders. It provides carrier integration, tracking number management, and delivery status monitoring across all active shipments.

### 1.2 Business Context

This screen represents the final fulfillment stage where completed orders are shipped to stores. Shipment creation triggers webhook events to external systems and updates order status automatically. Carrier tracking integration provides real-time delivery visibility.

### 1.3 Screenshot Reference

![Shipments Screen](./screenshots/PSP_Operations/psp_ops_shipments.png)

### 1.4 Navigation Path

```
PSP Portal  Shipments (sidebar)  /psp/shipments
```

### 1.5 Related Screens


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Permission Requirements


### 2.3 Data Scope

- **Tenant Isolation**: Shipments filtered by JWT tenant_id
- **Order Linkage**: Only shipments for tenant's orders visible
- **Carrier Access**: Carrier credentials scoped to tenant

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Layout Specification


![Shipments](./screenshots/PSP_Operations/psp_ops_shipments.png)


### 3.3 Component Specifications

#### P002-C005: Shipments Table


#### P002-C008: Create Shipment Modal


![Shipments](./screenshots/PSP_Operations/psp_ops_shipments.png)

## 4. Data Requirements

### 4.1 Entity Mapping


### 4.2 Data Query

```sql
SELECT
  sh.id, sh.carrier, sh.tracking_numbers, sh.status,
  sh.shipped_at, sh.estimated_delivery, sh.delivered_at,
  so.order_number,
  s.store_number, s.name as store_name,
  c.name as campaign_name,
  COUNT(sl.id) as line_count
FROM shipments sh
JOIN store_orders so ON sh.order_id = so.id
JOIN stores s ON so.store_id = s.id
JOIN campaigns c ON so.campaign_id = c.id
LEFT JOIN shipment_lines sl ON sl.shipment_id = sh.id
WHERE sh.tenant_id = :tenant_id
  AND sh.deleted_at IS NULL
  AND sh.status IN (:status_filter)
GROUP BY sh.id, so.id, s.id, c.id
ORDER BY sh.created_at DESC
LIMIT :page_size OFFSET :offset
```

### 4.3 Data Requirements Matrix


## 5. Business Rules & Validation

### 5.1 Shipment Creation Rules


### 5.2 Validation Rules


### 5.3 Carrier Tracking Format Validation


### 5.4 Business Constraints


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Request/Response Schemas

#### POST /api/v1/shipments

**Request Schema:**

```json
{
  "order_id": "uuid",
  "carrier": "UPS",
  "tracking_numbers": ["1Z999AA10123456784"],
  "shipped_at": "2025-12-15T10:00:00Z",
  "lines": [
    {
      "order_line_id": "uuid",
      "quantity_shipped": 2
    }
  ]
}
```

**Response Schema:**

```json
{
  "id": "uuid",
  "carrier": "UPS",
  "tracking_numbers": ["1Z999AA10123456784"],
  "status": "LABEL_CREATED",
  "shipped_at": "2025-12-15T10:00:00Z",
  "estimated_delivery": null,
  "order": {
    "id": "uuid",
    "order_number": "ORD-1234"
  },
  "store": {
    "id": "uuid",
    "store_number": "STR-001"
  },
  "lines": [
    {
      "id": "uuid",
      "order_line_id": "uuid",
      "quantity_shipped": 2,
      "item_name": "Window Poster"
    }
  ],
  "created_at": "2025-12-15T10:00:00Z"
}
```

### 6.3 Webhook Events


### 6.4 Carrier Integration


### 6.5 API Requirements


## 7. State Transitions

### 7.1 Shipment Status State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 State Transition Requirements


### 7.3 Status Display Mapping


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Error Display


### 8.3 Logging Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Keyboard Navigation


### 9.3 Screen Reader Support


## 10. Acceptance Criteria

### 10.1 Functional Acceptance Criteria


### 10.2 Non-Functional Acceptance Criteria


### 10.3 Integration Acceptance Criteria


### 10.4 Traceability Matrix


## Appendix A: Revision History

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*


---
# P003 - Issues Queue Screen Specification

> **Module**: PSP Operations Portal
> **Screen ID**: P003
> **Route**: `/psp/issues`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **SUPP Reference**: SUPP-019 (Exception Management)

## 1. Screen Overview

### 1.1 Purpose

The Issues Queue screen provides PSP Production Operators with a centralized view of all reported issues requiring triage and resolution. It enables issue review, approval/rejection decisions, and reorder creation for valid claims.

### 1.2 Business Context

This screen manages the exception handling workflow for store-reported problems including missing items, damaged goods, wrong items, and quantity shortages. Approved issues flow into reorder creation and fulfillment, closing the loop on store satisfaction.

### 1.3 Screenshot Reference

![Issues Queue Screen](./screenshots/PSP_Operations/psp_ops_issues.png)

### 1.4 Navigation Path

```
PSP Portal  Issues (sidebar)  /psp/issues
```

### 1.5 Related Screens


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Permission Requirements


### 2.3 Data Scope

- **Tenant Isolation**: Issues filtered by JWT tenant_id
- **Brand Visibility**: All brands within tenant visible
- **Store Access**: Issues from all stores visible

## 3. UI Components

### 3.1 Component Inventory


### 3.2 Layout Specification


![Issues](./screenshots/PSP_Operations/psp_ops_issues.png)


### 3.3 Issue Detail Panel


![Issues](./screenshots/PSP_Operations/psp_ops_issues.png)


### 3.4 Component Specifications

#### P003-C005: Issues Table


## 4. Data Requirements

### 4.1 Entity Mapping


### 4.2 Data Query

```sql
SELECT
  ir.id, ir.issue_number, ir.issue_type, ir.status,
  ir.description, ir.quantity_affected, ir.created_at,
  ir.triage_notes, ir.resolved_at, ir.resolution_type,
  ki.name as item_name, ki.sku,
  ai.quantity as qty_ordered,
  s.store_number, s.name as store_name,
  c.name as campaign_name,
  b.name as brand_name,
  (SELECT COUNT(*) FROM photo_uploads pu
   WHERE pu.reference_type = 'ISSUE'
   AND pu.reference_id = ir.id) as photo_count
FROM issue_requests ir
JOIN assignment_items ai ON ir.assignment_item_id = ai.id
JOIN kit_items ki ON ai.kit_item_id = ki.id
JOIN store_assignments sa ON ai.store_assignment_id = sa.id
JOIN stores s ON sa.store_id = s.id
JOIN campaigns c ON sa.campaign_id = c.id
JOIN brands b ON c.brand_id = b.id
WHERE ir.tenant_id = :tenant_id
  AND ir.deleted_at IS NULL
  AND ir.status IN (:status_filter)
ORDER BY ir.created_at ASC
LIMIT :page_size OFFSET :offset
```

### 4.3 Data Requirements Matrix


## 5. Business Rules & Validation

### 5.1 Issue Type Rules


### 5.2 Triage Rules


### 5.3 Validation Rules


### 5.4 Rejection Reason Codes


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Request/Response Schemas

#### POST /api/v1/issues/{id}/reject

**Request Schema:**

```json
{
  "reason_code": "INSUFFICIENT_EVIDENCE",
  "explanation": "Photos do not clearly show the reported damage. The item appears intact.",
  "notify_store": true
}
```

**Response Schema:**

```json
{
  "id": "uuid",
  "issue_number": "ISS-1042",
  "status": "REJECTED",
  "issue_type": "DAMAGED",
  "rejection": {
    "reason_code": "INSUFFICIENT_EVIDENCE",
    "explanation": "Photos do not clearly show the reported damage.",
    "rejected_by": "user@psp.com",
    "rejected_at": "2025-12-15T14:30:00Z"
  },
  "store_notified": true
}
```

#### POST /api/v1/issues/{id}/reorder

**Request Schema:**

```json
{
  "quantity": 1,
  "notes": "Replacement for damaged item",
  "priority": "NORMAL"
}
```

**Response Schema:**

```json
{
  "id": "uuid",
  "reorder_number": "REO-1042",
  "status": "PENDING",
  "issue_id": "uuid",
  "order": {
    "id": "uuid",
    "order_number": "ORD-1500",
    "status": "GENERATED"
  },
  "quantity": 1,
  "created_at": "2025-12-15T14:35:00Z"
}
```

### 6.3 Webhook Events


### 6.4 API Requirements


## 7. State Transitions

### 7.1 Issue Status State Machine


[Diagram - See rendered image above or refer to source document]


### 7.2 State Transition Requirements


### 7.3 Status Display Mapping


### 7.4 Issue Type Display


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Error Display


### 8.3 Logging Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Keyboard Navigation


### 9.3 Screen Reader Support


## 10. Acceptance Criteria

### 10.1 Functional Acceptance Criteria


### 10.2 Business Logic Acceptance Criteria


### 10.3 Non-Functional Acceptance Criteria


### 10.4 Traceability Matrix


## Appendix A: Revision History

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*


---

# Section 9: Store Portal Module


---
# S001 - Store Dashboard Screen Specification

> **Module**: StorePortal
> **Screen ID**: S001
> **Route**: `/store/dashboard`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

## 1. Screen Overview

### 1.1 Purpose

The Store Dashboard serves as the primary landing page for store personnel, providing a consolidated view of campaign status, pending actions, and key performance metrics. It enables store managers and operators to quickly assess their workload and navigate to priority tasks.

### 1.2 Screenshot Reference

![Store Portal Dashboard](./screenshots/Store_Portal/store_portal_dashboard.png)

### 1.3 Source References


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role-Based Display Rules


### 2.3 Permission Requirements


## 3. UI Components

### 3.1 Component Inventory


### 3.2 KPI Cards Specification


### 3.3 Layout Structure


![Store Dashboard](./screenshots/Store_Portal/store_portal_dashboard.png)


### 3.4 Component Requirements


## 4. Data Requirements

### 4.1 Entity Dependencies


### 4.2 Data Query Specification


![Store Dashboard](./screenshots/Store_Portal/store_portal_dashboard.png)


### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Display Rules


### 5.2 StorePhase Display Mapping


### 5.3 Business Rule Requirements


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Request/Response Specifications

#### GET /api/stores/{storeId}/dashboard

**Request Headers:**
```
Authorization: Bearer {jwt_token}
X-Tenant-ID: {tenant_uuid}
```

**Response Schema:**
```json
{
  "store": {
    "id": "uuid",
    "name": "string",
    "externalGuid": "string"
  },
  "metrics": {
    "activeCampaigns": "number",
    "pendingActions": "number",
    "completedThisMonth": "number",
    "complianceRate": "number"
  },
  "campaigns": [
    {
      "id": "uuid",
      "name": "string",
      "phase": "StorePhase",
      "installStart": "ISO8601",
      "installEnd": "ISO8601",
      "pendingTasks": ["string"]
    }
  ],
  "recentActivity": [
    {
      "id": "uuid",
      "type": "string",
      "actor": "string",
      "description": "string",
      "timestamp": "ISO8601"
    }
  ],
  "teamStatus": {
    "activeMembers": "number",
    "pendingInvitations": "number"
  }
}
```

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Dashboard Load States

![Dashboard](./screenshots/Store_Portal/store_portal_dashboard.png)

### 7.2 State Descriptions


### 7.3 State Requirements


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Partial Load Handling


### 8.3 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Screen Reader Support


### 9.3 Keyboard Navigation


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Non-Functional Requirements


### 10.3 Traceability Matrix


## Document History

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*


---
# S002 - Campaign History Screen Specification

> **Module**: StorePortal
> **Screen ID**: S002
> **Route**: `/store/campaigns`
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

## 1. Screen Overview

### 1.1 Purpose

The Campaign History screen provides store personnel with a comprehensive view of all campaign assignments, both active and completed. Users can filter by status, view detailed campaign information, track execution progress, and access historical campaign data for compliance and audit purposes.

### 1.2 Screenshot Reference

![Store Portal Campaigns](./screenshots/Store_Portal/store_portal_campaigns.png)

### 1.3 Source References


## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Role-Based Capabilities


### 2.3 Permission Requirements


## 3. UI Components

### 3.1 Component Inventory


### 3.2 Layout Structure


![Campaign History](./screenshots/Store_Portal/store_portal_campaigns.png)


### 3.3 Component Requirements


## 4. Data Requirements

### 4.1 Entity Dependencies


### 4.2 Data Query Specification


![Campaign History](./screenshots/Store_Portal/store_portal_campaigns.png)


### 4.3 Data Requirements


## 5. Business Rules & Validation

### 5.1 Status Tab Filtering


### 5.2 StorePhase Status Display


### 5.3 Progress Calculation


### 5.4 Business Rule Requirements


## 6. API Integration Points

### 6.1 API Endpoints


### 6.2 Request/Response Specifications

#### GET /api/stores/{storeId}/assignments

**Query Parameters:**


**Response Schema:**
```json
{
  "data": [
    {
      "id": "uuid",
      "campaignId": "uuid",
      "campaignName": "string",
      "campaignCode": "string",
      "phase": "StorePhase",
      "installStart": "ISO8601",
      "installEnd": "ISO8601",
      "progress": "number",
      "itemCount": "number",
      "photoStats": {
        "required": "number",
        "uploaded": "number",
        "approved": "number"
      },
      "completedAt": "ISO8601 | null"
    }
  ],
  "pagination": {
    "page": "number",
    "limit": "number",
    "total": "number",
    "pages": "number"
  }
}
```

#### GET /api/assignments/{id}

**Query Parameters:**

**Response Schema:**
```json
{
  "id": "uuid",
  "campaign": {
    "id": "uuid",
    "name": "string",
    "code": "string",
    "installStart": "ISO8601",
    "installEnd": "ISO8601"
  },
  "phase": "StorePhase",
  "progress": "number",
  "tasks": [
    {
      "name": "string",
      "status": "pending | complete",
      "completedAt": "ISO8601 | null"
    }
  ],
  "items": [
    {
      "id": "uuid",
      "name": "string",
      "sku": "string",
      "quantity": "number",
      "slotCode": "string",
      "photoCount": "number",
      "photoApproved": "boolean"
    }
  ],
  "receiveVerification": {
    "verifiedAt": "ISO8601",
    "verifiedBy": "string"
  },
  "completionAttestation": {
    "attestedAt": "ISO8601",
    "attestedBy": "string"
  }
}
```

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Page States

![History](./screenshots/Store_Portal/store_portal_campaigns.png)

### 7.2 State Descriptions


### 7.3 State Requirements


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Validation Errors


### 8.3 Error Requirements


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Screen Reader Support


### 9.3 Keyboard Navigation


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Non-Functional Requirements


### 10.3 Traceability Matrix


## Document History

*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Functional Requirements*


---
# S003 Photo Gallery - Screen Specification

> **SRS Section**: 5.9.3 | **Module**: Store Portal | **Version**: 1.0
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **Source Documents**:
> - [S03 Photo Gallery Screen Spec](../../../../06_Screen_Specs/S03_Photo_Gallery.md)
> - [SUPP-018 Photo Review](../../../../02_SUPPs/SUPP-018_Photo_Review.md)
> - [SUPP-037 Store Surveys](../../../../02_SUPPs/SUPP-037_Store_Surveys.md)
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Photo Gallery screen provides store personnel with a centralized view of all installation proof photos submitted for their store. It enables browsing, filtering, and reviewing photo upload history across campaigns, with detailed status visibility for approved, pending, rejected, and superseded photos.

### 1.2 Route Configuration


### 1.3 Screen Context


### 1.4 Screenshot Reference

![Photo Gallery Screen](./screenshots/Store_Portal/store_portal_photos.png)

## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Permission Requirements


### 2.3 Data Scoping Rules


## 3. UI Components

### 3.1 Component Hierarchy

```
PhotoGalleryPage
â”œâ”€â”€ PageHeader
â”‚   â”œâ”€â”€ TitleSection ("Photo Gallery")
â”‚   â””â”€â”€ StatusSummary (count by status)
â”œâ”€â”€ FilterBar
â”‚   â”œâ”€â”€ CampaignFilter (dropdown)
â”‚   â”œâ”€â”€ StatusFilter (dropdown)
â”‚   â”œâ”€â”€ DateRangeFilter (dropdown)
â”‚   â”œâ”€â”€ ItemTypeFilter (multi-select)
â”‚   â””â”€â”€ UploadedByFilter (dropdown) [Store Manager only]
â”œâ”€â”€ ViewToggle
â”‚   â”œâ”€â”€ GridViewButton
â”‚   â””â”€â”€ ListViewButton
â”œâ”€â”€ ActionBar
â”‚   â””â”€â”€ BulkDownloadButton [Store Manager only]
â”œâ”€â”€ ContentArea
â”‚   â”œâ”€â”€ PhotoGrid (default view)
â”‚   â”‚   â””â”€â”€ PhotoCard[] (repeating)
â”‚   â””â”€â”€ PhotoList (alternate view)
â”‚       â””â”€â”€ PhotoRow[] (repeating)
â”œâ”€â”€ Pagination
â”‚   â”œâ”€â”€ ResultCount
â”‚   â””â”€â”€ LoadMoreButton
â””â”€â”€ LightboxModal
    â”œâ”€â”€ PhotoViewer
    â”œâ”€â”€ PhotoInfoPanel
    â””â”€â”€ NavigationControls
```

### 3.2 Component Specifications


### 3.3 Photo Card Layout

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                 â”‚
â”‚    [Thumbnail]  â”‚
â”‚                 â”‚
â”‚       âœ“         â”‚  â† Status overlay
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚ Window Poster   â”‚  â† Item name
â”‚ Summer Promo    â”‚  â† Campaign name
â”‚ Jun 15, 2025    â”‚  â† Upload date
â”‚ by John D.      â”‚  â† Uploader name
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 3.4 Status Overlay Specifications


## 4. Data Requirements

### 4.1 API Endpoints


### 4.2 Request Parameters

**GET /stores/{storeId}/photos**


### 4.3 Response Schema

```typescript
interface PhotoGalleryResponse {
  photos: PhotoUploadDTO[];
  meta: {
    total: number;
    page: number;
    limit: number;
    hasMore: boolean;
  };
  summary: {
    approved: number;
    pending: number;
    rejected: number;
    superseded: number;
  };
}

interface PhotoUploadDTO {
  id: string;                          // UUID
  file_url: string;                    // S3 signed URL
  thumbnail_url: string;               // S3 signed thumbnail URL
  review_status: PhotoReviewStatus;    // Enum
  created_at: string;                  // ISO 8601

  // Related data
  item_name: string;                   // KitItem.name
  item_type: ItemType;                 // KitItem.item_type
  slot_name: string | null;            // LocationSlot.name
  campaign_id: string;                 // Campaign.id
  campaign_name: string;               // Campaign.name
  uploaded_by: string;                 // User.id
  uploader_name: string;               // User.name

  // Review data (if reviewed)
  rejection_reason?: RejectionReasonCode;
  admin_comment?: string;
  reviewed_at?: string;
  reviewer_name?: string;

  // Superseded link
  superseded_by_id?: string;           // Replacement photo ID
}
```

### 4.4 Database Query

```sql
SELECT
  pu.id,
  pu.file_url,
  pu.thumbnail_url,
  pu.review_status,
  pu.created_at,
  ki.name as item_name,
  ki.item_type,
  ls.name as slot_name,
  c.id as campaign_id,
  c.name as campaign_name,
  u.id as uploaded_by,
  u.name as uploader_name,
  pr.rejection_reason,
  pr.admin_comment,
  pr.created_at as reviewed_at,
  rev.name as reviewer_name,
  pu.superseded_by_id
FROM photo_uploads pu
JOIN assignment_items ai ON pu.assignment_item_id = ai.id
JOIN kit_items ki ON ai.kit_item_id = ki.id
LEFT JOIN location_slots ls ON ai.location_slot_id = ls.id
JOIN store_assignments sa ON ai.store_assignment_id = sa.id
JOIN campaigns c ON sa.campaign_id = c.id
JOIN users u ON pu.uploaded_by = u.id
LEFT JOIN photo_reviews pr ON pr.photo_upload_id = pu.id
  AND pr.id = (SELECT id FROM photo_reviews WHERE photo_upload_id = pu.id ORDER BY created_at DESC LIMIT 1)
LEFT JOIN users rev ON pr.reviewer_id = rev.id
WHERE sa.store_id = :storeId
  AND pu.deleted_at IS NULL
  AND sa.deleted_at IS NULL
ORDER BY pu.created_at DESC
LIMIT :limit OFFSET :offset
```

### 4.5 Caching Strategy


## 5. Business Rules & Validation

### 5.1 Display Rules


### 5.2 Filter Rules


### 5.3 Lightbox Rules


### 5.4 Download Rules


## 6. API Integration Points

### 6.1 Gallery Data Flow

![09_Module_StorePortal_screens_S003_Photo_Gallery_diagram_0](./diagrams_rendered/09_Module_StorePortal_screens_S003_Photo_Gallery_diagram_0.png)

### 6.2 Lightbox Data Flow

![09_Module_StorePortal_screens_S003_Photo_Gallery_diagram_1](./diagrams_rendered/09_Module_StorePortal_screens_S003_Photo_Gallery_diagram_1.png)

### 6.3 Integration Dependencies


## 7. State Transitions

### 7.1 Photo Review Status States

```
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
                    â”‚   PENDING   â”‚
                    â””â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”˜
                           â”‚
              â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
              â–¼            â–¼            â”‚
       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”       â”‚
       â”‚ APPROVED â”‚  â”‚ REJECTED â”‚       â”‚
       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜       â”‚
                          â”‚             â”‚
                          â–¼             â”‚
                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”        â”‚
                    â”‚SUPERSEDEDâ”‚â†â”€â”€â”€â”€â”€â”€â”€â”˜
                    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
                    (after retake)
```

### 7.2 Status Transition Rules


### 7.3 View State Management


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Loading States


### 8.3 Empty States


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Keyboard Shortcuts


### 9.3 Screen Reader Announcements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Non-Functional Requirements


### 10.3 Security Requirements


## 11. Traceability Matrix


## 12. Related Screens


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Specific Requirements / Functional Requirements*


---
# S004 Team Management - Screen Specification

> **SRS Section**: 5.9.4 | **Module**: Store Portal | **Version**: 1.0
> **IEEE 830 Reference**: Section 3.2 - Functional Requirements
> **Source Documents**:
> - [S04 Team Management Screen Spec](../../../../06_Screen_Specs/S04_Team_Management.md)
> - [SUPP-001 Personas](../../../../02_SUPPs/Shared_Foundations/SUPP-001_Personas.md)
> - [SUPP-003 RBAC](../../../../02_SUPPs/Shared_Foundations/SUPP-003_RBAC.md)
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Team Management screen enables Store Managers to administer their store's team members, including inviting new users, managing roles, tracking activity metrics, and removing access. This screen is restricted to Store Manager role only.

### 1.2 Route Configuration


### 1.3 Screen Context


### 1.4 Screenshot Reference

![Team Management Screen](./screenshots/Store_Portal/store_portal_team.png)

## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Permission Requirements


### 2.3 Data Scoping Rules


## 3. UI Components

### 3.1 Component Hierarchy

```
TeamManagementPage
â”œâ”€â”€ PageHeader
â”‚   â”œâ”€â”€ TitleSection ("Team Management")
â”‚   â””â”€â”€ InviteMemberButton
â”œâ”€â”€ ActiveMembersSection
â”‚   â”œâ”€â”€ SectionHeader ("Active Members ({count})")
â”‚   â””â”€â”€ MemberTable
â”‚       â””â”€â”€ MemberRow[] (repeating)
â”‚           â”œâ”€â”€ AvatarWithName
â”‚           â”œâ”€â”€ EmailAddress
â”‚           â”œâ”€â”€ RoleBadge
â”‚           â”œâ”€â”€ StatusBadge
â”‚           â”œâ”€â”€ LastActiveDate
â”‚           â””â”€â”€ ActionMenu
â”œâ”€â”€ PendingInvitationsSection
â”‚   â”œâ”€â”€ SectionHeader ("Pending Invitations ({count})")
â”‚   â””â”€â”€ InvitationTable
â”‚       â””â”€â”€ InvitationRow[] (repeating)
â”‚           â”œâ”€â”€ EmailAddress
â”‚           â”œâ”€â”€ RoleBadge
â”‚           â”œâ”€â”€ InvitedDate
â”‚           â”œâ”€â”€ ExpiresDate
â”‚           â””â”€â”€ ActionButtons (Resend, Cancel)
â”œâ”€â”€ ActivitySummarySection
â”‚   â”œâ”€â”€ SectionHeader ("Team Activity (Last 30 Days)")
â”‚   â””â”€â”€ ActivityTable
â”‚       â””â”€â”€ ActivityRow[] (repeating)
â”œâ”€â”€ InviteMemberModal
â”‚   â”œâ”€â”€ EmailInput
â”‚   â”œâ”€â”€ RoleSelector
â”‚   â”œâ”€â”€ PersonalMessageInput
â”‚   â””â”€â”€ ActionButtons (Cancel, Send Invitation)
â””â”€â”€ EditMemberModal
    â”œâ”€â”€ MemberInfo
    â”œâ”€â”€ RoleDropdown
    â”œâ”€â”€ StatusToggle
    â”œâ”€â”€ ActivitySummary
    â”œâ”€â”€ RemoveButton
    â””â”€â”€ ActionButtons (Cancel, Save)
```

### 3.2 Component Specifications


### 3.3 Role Badge Specifications


### 3.4 Status Badge Specifications


## 4. Data Requirements

### 4.1 API Endpoints


### 4.2 Request/Response Schemas

**GET /stores/{storeId}/members Response**

```typescript
interface TeamMembersResponse {
  members: TeamMemberDTO[];
  meta: {
    total: number;
    managerCount: number;
    operatorCount: number;
  };
}

interface TeamMemberDTO {
  id: string;                    // Membership ID
  user_id: string;               // User ID
  name: string;                  // User full name
  email: string;                 // User email
  phone?: string;                // User phone
  avatar_url?: string;           // Profile picture URL
  role: 'STORE_MANAGER' | 'STORE_OPERATOR';
  status: 'active' | 'inactive';
  joined_at: string;             // ISO 8601
  last_active_at?: string;       // ISO 8601
  photo_count: number;           // Total photos uploaded
  is_current_user: boolean;      // Flag for self
}
```

**GET /stores/{storeId}/invitations Response**

```typescript
interface InvitationsResponse {
  invitations: InvitationDTO[];
}

interface InvitationDTO {
  id: string;                    // Invitation ID
  email: string;                 // Invited email
  role: 'STORE_MANAGER' | 'STORE_OPERATOR';
  invited_at: string;            // ISO 8601
  expires_at: string;            // ISO 8601
  invited_by: string;            // Inviter user name
  status: 'pending' | 'expired';
}
```

**POST /stores/{storeId}/invitations Request**

```typescript
interface CreateInvitationRequest {
  email: string;                 // Required
  role: 'STORE_MANAGER' | 'STORE_OPERATOR';  // Required
  message?: string;              // Optional personal message
}
```

**GET /stores/{storeId}/activity Response**

```typescript
interface TeamActivityResponse {
  activity: TeamMemberActivityDTO[];
  period: {
    from: string;               // ISO 8601
    to: string;                 // ISO 8601
    days: number;               // Default 30
  };
}

interface TeamMemberActivityDTO {
  user_id: string;
  user_name: string;
  photos: number;               // Photos uploaded
  receipts: number;             // Receipt surveys completed
  installs: number;             // Install surveys completed
  issues: number;               // Issues reported
}
```

### 4.3 Database Query - Team Members

```sql
SELECT
  m.id as membership_id,
  u.id as user_id,
  u.name,
  u.email,
  u.phone,
  u.avatar_url,
  m.role,
  CASE WHEN u.is_active THEN 'active' ELSE 'inactive' END as status,
  m.created_at as joined_at,
  u.last_active_at,
  COUNT(pu.id) as photo_count
FROM memberships m
JOIN users u ON m.user_id = u.id
LEFT JOIN photo_uploads pu ON pu.uploaded_by = u.id
WHERE m.store_id = :storeId
  AND m.deleted_at IS NULL
  AND u.deleted_at IS NULL
GROUP BY m.id, u.id
ORDER BY
  CASE m.role WHEN 'STORE_MANAGER' THEN 0 ELSE 1 END,
  u.name
```

### 4.4 Database Query - Team Activity

```sql
WITH activity_period AS (
  SELECT
    CURRENT_DATE - INTERVAL '30 days' as start_date,
    CURRENT_DATE as end_date
)
SELECT
  u.id as user_id,
  u.name as user_name,
  COUNT(DISTINCT pu.id) as photos,
  COUNT(DISTINCT CASE WHEN ssr.survey_type = 'receipt' THEN ssr.id END) as receipts,
  COUNT(DISTINCT CASE WHEN ssr.survey_type = 'install' THEN ssr.id END) as installs,
  COUNT(DISTINCT ir.id) as issues
FROM memberships m
JOIN users u ON m.user_id = u.id
CROSS JOIN activity_period ap
LEFT JOIN photo_uploads pu ON pu.uploaded_by = u.id
  AND pu.created_at BETWEEN ap.start_date AND ap.end_date
LEFT JOIN store_survey_responses ssr ON ssr.submitted_by = u.id
  AND ssr.submitted_at BETWEEN ap.start_date AND ap.end_date
LEFT JOIN issue_requests ir ON ir.reported_by = u.id
  AND ir.created_at BETWEEN ap.start_date AND ap.end_date
WHERE m.store_id = :storeId
  AND m.deleted_at IS NULL
GROUP BY u.id, u.name
ORDER BY u.name
```

## 5. Business Rules & Validation

### 5.1 Invitation Rules


### 5.2 Role Management Rules


### 5.3 Status Management Rules


### 5.4 Activity Calculation Rules


## 6. API Integration Points

### 6.1 Load Team Data Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_0](./diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_0.png)

### 6.2 Invite Member Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_1](./diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_1.png)

### 6.3 Edit Member Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_2](./diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_2.png)

### 6.4 Remove Member Flow

![09_Module_StorePortal_screens_S004_Team_Management_diagram_3](./diagrams_rendered/09_Module_StorePortal_screens_S004_Team_Management_diagram_3.png)

### 6.5 Integration Dependencies


## 7. State Transitions

### 7.1 Invitation Status States

```
     â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
     â”‚ PENDING  â”‚
     â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜
          â”‚
    â”Œâ”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”
    â–¼           â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ACCEPTEDâ”‚  â”‚ EXPIRED â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
    â”‚
    â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ MEMBERSHIP  â”‚
â”‚  CREATED    â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 7.2 Member Status States

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  ACTIVE  â”‚â—„â”€â”€â”€â”€â”€â–ºâ”‚ INACTIVE â”‚
â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”˜       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
     â”‚
     â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ REMOVED  â”‚
â”‚(soft del)â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 7.3 State Transition Actions


## 8. Error Handling

### 8.1 Error Scenarios


### 8.2 Validation Messages


### 8.3 Loading States


### 8.4 Empty States


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Keyboard Shortcuts


### 9.3 Screen Reader Announcements


## 10. Acceptance Criteria

### 10.1 Functional Requirements


### 10.2 Non-Functional Requirements


### 10.3 Security Requirements


## 11. Traceability Matrix


## 12. Related Screens


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.2 - Specific Requirements / Functional Requirements*


---
# S005 Store Reports - Screen Specification

> **SRS Section**: 5.9.5 | **Version**: 1.0 | **Status**: Draft
> **Module**: Store Portal
> **Route**: `/store/reports`
> **Source**: [S05_Reports.md](../../../../06_Screen_Specs/S05_Reports.md)
> **Last Updated**: 2026-01-01

## 1. Screen Overview

### 1.1 Purpose

The Store Reports screen provides Store Managers with comprehensive analytics and performance insights for their store's campaign execution, photo compliance, team performance, and issue resolution. This read-only analytics interface aggregates data across multiple entities to deliver actionable metrics with trend analysis and benchmarking capabilities.

### 1.2 Scope

This specification defines the functional requirements, data requirements, and user interface components for the Store Reports screen within the Store Portal module of NewPOPSys v1.

### 1.3 Primary Functions


### 1.4 Screenshot Reference

![Store Reports Dashboard](./screenshots/Store_Portal/store_portal_reports.png)

*Figure S005-1: Store Reports Dashboard - Analytics and performance metrics interface*

### 1.5 Screen Context

![Reports](./screenshots/Store_Portal/store_portal_reports.png)

## 2. User Roles & Permissions

### 2.1 Authorized Roles


### 2.2 Permission Requirements


### 2.3 Access Control Rules

```
REQ-S005-SEC-004: Data Isolation
- Users SHALL only view reports for stores where membership.store_id matches
- All API calls SHALL include tenant_id and store_id scoping
- Report data SHALL NOT include cross-store comparisons without aggregation

REQ-S005-SEC-005: Role Enforcement
- Store Operators SHALL be denied access with HTTP 403
- Navigation item SHALL be hidden for unauthorized roles
- Direct URL access SHALL redirect to Dashboard with access denied message
```

## 3. UI Components

### 3.1 Component Hierarchy

![Reports](./screenshots/Store_Portal/store_portal_reports.png)

### 3.2 Component Specifications

#### 3.2.1 Page Header


#### 3.2.2 Tab Navigation


#### 3.2.3 KPI Cards


#### 3.2.4 Charts


#### 3.2.5 Data Tables


### 3.3 Reports Layout

### 3.3 Reports Layout
![Store Reports Wireframe](./screenshots/Store_Portal/store_portal_reports.png)

## 4. Data Requirements

### 4.1 Data Model References


### 4.2 Database Queries

#### 4.2.1 Compliance Metrics Query

```sql
SELECT
    COUNT(*) as total_campaigns,
    COUNT(CASE WHEN sa.status = 'COMPLETE' THEN 1 END) as completed,
    COUNT(CASE WHEN sa.status = 'COMPLETE'
          AND sa.completed_at <= c.install_end_date THEN 1 END) as on_time,
    AVG(EXTRACT(EPOCH FROM (sa.completed_at - c.install_start_date)) / 86400)
        as avg_duration_days
FROM store_assignments sa
JOIN campaigns c ON sa.campaign_id = c.id
WHERE sa.store_id = :storeId
  AND sa.deleted_at IS NULL
  AND c.deleted_at IS NULL
  AND sa.created_at >= :startDate
  AND sa.created_at <= :endDate;
```

#### 4.2.2 Photo Metrics Query

```sql
SELECT
    COUNT(pu.id) as total_photos,
    COUNT(CASE WHEN pu.review_status = 'APPROVED' THEN 1 END) as approved,
    COUNT(CASE WHEN pu.review_status = 'REJECTED' THEN 1 END) as rejected,
    COUNT(CASE WHEN pu.review_status = 'PENDING' THEN 1 END) as pending
FROM photo_uploads pu
JOIN assignment_items ai ON pu.assignment_item_id = ai.id
JOIN store_assignments sa ON ai.store_assignment_id = sa.id
WHERE sa.store_id = :storeId
  AND pu.deleted_at IS NULL
  AND pu.created_at >= :startDate
  AND pu.created_at <= :endDate;
```

#### 4.2.3 Rejection Reasons Query

```sql
SELECT
    pr.reason_code,
    COUNT(*) as count
FROM photo_reviews pr
JOIN photo_uploads pu ON pr.photo_upload_id = pu.id
JOIN assignment_items ai ON pu.assignment_item_id = ai.id
JOIN store_assignments sa ON ai.store_assignment_id = sa.id
WHERE sa.store_id = :storeId
  AND pr.decision = 'REJECTED'
  AND pr.deleted_at IS NULL
  AND pr.created_at >= :startDate
  AND pr.created_at <= :endDate
GROUP BY pr.reason_code
ORDER BY count DESC;
```

#### 4.2.4 Team Contribution Query

```sql
SELECT
    u.id as user_id,
    u.first_name || ' ' || LEFT(u.last_name, 1) || '.' as display_name,
    COUNT(DISTINCT pu.id) as photos_uploaded,
    COUNT(DISTINCT CASE WHEN sa.status = 'COMPLETE' THEN sa.id END) as completions
FROM users u
JOIN memberships m ON u.id = m.user_id
LEFT JOIN photo_uploads pu ON pu.uploaded_by = u.id
LEFT JOIN assignment_items ai ON pu.assignment_item_id = ai.id
LEFT JOIN store_assignments sa ON ai.store_assignment_id = sa.id
WHERE m.store_id = :storeId
  AND m.deleted_at IS NULL
  AND u.is_active = true
  AND (pu.created_at >= :startDate OR pu.created_at IS NULL)
  AND (pu.created_at <= :endDate OR pu.created_at IS NULL)
GROUP BY u.id, u.first_name, u.last_name
ORDER BY photos_uploaded DESC;
```

#### 4.2.5 Issues Summary Query

```sql
SELECT
    ir.issue_type,
    ir.status,
    COUNT(*) as count,
    AVG(EXTRACT(EPOCH FROM (ir.resolved_at - ir.created_at)) / 3600)
        as avg_resolution_hours
FROM issue_requests ir
JOIN store_assignments sa ON ir.store_assignment_id = sa.id
WHERE sa.store_id = :storeId
  AND ir.deleted_at IS NULL
  AND ir.created_at >= :startDate
  AND ir.created_at <= :endDate
GROUP BY ir.issue_type, ir.status
ORDER BY count DESC;
```

### 4.3 API Response Interfaces

```typescript
interface StoreReportsResponse {
    storeId: string;
    dateRange: {
        start: string;  // ISO date
        end: string;    // ISO date
        label: string;  // "Last 90 Days"
    };
    kpis: KPIMetrics;
    campaignMetrics: CampaignMetrics;
    photoMetrics: PhotoMetrics;
    teamMetrics: TeamMemberMetrics[];
    issueMetrics: IssueMetrics;
    trends: TrendData[];
}

interface KPIMetrics {
    complianceRate: {
        value: number;       // Percentage (0-100)
        trend: number;       // Change from previous period
        status: 'green' | 'yellow' | 'red';
    };
    onTimeRate: {
        value: number;
        trend: number;
        status: 'green' | 'yellow' | 'red';
    };
    photoApprovalRate: {
        value: number;
        trend: number;
        status: 'green' | 'yellow' | 'red';
    };
    avgCompletionDays: {
        value: number;       // Days
        trend: number;
        status: 'green' | 'yellow' | 'red';
    };
}

interface CampaignMetrics {
    total: number;
    completed: number;
    onTime: number;
    late: number;
    inProgress: number;
    campaigns: CampaignDetail[];
}

interface CampaignDetail {
    campaignId: string;
    campaignName: string;
    status: string;
    completedAt: string | null;
    onTime: boolean | null;
    photoCount: number;
    issueCount: number;
}

interface PhotoMetrics {
    total: number;
    approved: number;
    rejected: number;
    pending: number;
    approvalRate: number;
    rejectionReasons: RejectionReason[];
}

interface RejectionReason {
    code: string;
    label: string;
    count: number;
    percentage: number;
}

interface TeamMemberMetrics {
    userId: string;
    displayName: string;
    photosUploaded: number;
    completions: number;
    contributionPercentage: number;
}

interface IssueMetrics {
    total: number;
    open: number;
    resolved: number;
    avgResolutionHours: number;
    byType: IssueTypeBreakdown[];
}

interface IssueTypeBreakdown {
    type: string;
    count: number;
    percentage: number;
}

interface TrendData {
    period: string;         // "2025-12", "2025-W52"
    complianceRate: number;
    onTimeRate: number;
    photoApprovalRate: number;
}
```

### 4.4 Data Freshness


## 5. Business Rules & Validation

### 5.1 Date Range Rules


### 5.2 KPI Calculation Rules


### 5.3 Threshold Rules


### 5.4 Data Scope Rules


### 5.5 Comparison Rules


## 6. API Integration Points

### 6.1 Endpoint Specifications

#### 6.1.1 Get Store Reports

```
GET /api/v1/stores/{storeId}/reports
```

**Query Parameters:**


**Response:**

```json
{
    "data": {
        "storeId": "uuid",
        "dateRange": {
            "start": "2024-10-01",
            "end": "2024-12-31",
            "label": "Last 90 Days"
        },
        "kpis": {
            "complianceRate": { "value": 94, "trend": 3, "status": "green" },
            "onTimeRate": { "value": 88, "trend": 5, "status": "green" },
            "photoApprovalRate": { "value": 97, "trend": -1, "status": "green" },
            "avgCompletionDays": { "value": 4.2, "trend": -0.5, "status": "green" }
        },
        "campaignMetrics": { ... },
        "photoMetrics": { ... },
        "teamMetrics": [ ... ],
        "issueMetrics": { ... },
        "trends": [ ... ]
    },
    "meta": {
        "generatedAt": "2024-12-31T12:00:00Z",
        "comparisons": {
            "networkAverage": { ... },
            "regionAverage": { ... }
        }
    }
}
```

#### 6.1.2 Export Store Reports

```
GET /api/v1/stores/{storeId}/reports/export
```

**Query Parameters:**


**Response:**

```
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="store-reports-2024-12-31.csv"
```

### 6.2 Request/Response Flow

![Reports](./screenshots/Store_Portal/store_portal_reports.png)

### 6.3 API Requirements


## 7. State Transitions

### 7.1 Screen States

![Reports](./screenshots/Store_Portal/store_portal_reports.png)mermaid
stateDiagram-v2
    [*] --> LOADING
    LOADING --> SUCCESS: Data Ready
    LOADING --> ERROR: Failure
    LOADING --> EMPTY: No Data
    SUCCESS --> REFRESHING: Range Change
    REFRESHING --> SUCCESS
    SUCCESS --> EXPORTING: Export
    EXPORTING --> SUCCESS
    SUCCESS --> NAVIGATING: Tab Switch
    NAVIGATING --> SUCCESS
    ERROR --> LOADING: Retry
    EMPTY --> LOADING: Change Range
```
### 8.1 Error Scenarios


### 8.2 Error Handling Requirements


### 8.3 Validation Errors


## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance


### 9.2 Chart Accessibility


### 9.3 Keyboard Navigation


## 10. Acceptance Criteria

### 10.1 Functional Acceptance Criteria


### 10.2 Non-Functional Acceptance Criteria


### 10.3 Edge Case Acceptance Criteria


## 11. Traceability Matrix


## 12. Appendix

### 12.1 Date Range Presets


### 12.2 Export File Formats


### 12.3 Related Documents


*Document Status: Draft*
*IEEE 830 Compliance: Section 3.2 - Specific Requirements / Functional Requirements*


---

# Section 10: Platform Admin Module
# Module 10: Platform Administration

> **Module ID**: PA (Platform Admin)
> **Version**: 1.0
> **Last Updated**: 2026-01-01
> **Status**: Complete

## 1. Module Purpose

The Platform Administration module serves as the central administration console for NewPOPSys, providing platform-wide configuration, user management, and system monitoring capabilities. This module enables Platform Administrators to manage the multi-tenant environment, configure integrations, and maintain system health across all brands and stores.

## 2. Scope

This module encompasses all administrative screens prefixed with **A** (A001-A006):

- **Screen Range**: A001 - A006
- **Route Prefix**: `/admin/*`
- **Permission Tier**: Highest (Platform-level)

## 3. Target Users


> **Reference**: See [04_User_Personas_RBAC/personas/Platform_Admin.md](../04_User_Personas_RBAC/personas/Platform_Admin.md)

## 4. Key Capabilities

### 4.1 Brand Management
- Multi-tenant brand onboarding workflow
- Brand-specific configuration (themes, features, limits)
- Brand hierarchy and relationship management

### 4.2 User Administration
- User provisioning and lifecycle management
- Role-Based Access Control (RBAC) configuration
- Permission matrix management across all modules

### 4.3 PSP Network Configuration
- Print Service Provider partner onboarding
- PSP capability mapping and routing rules
- SLA configuration and monitoring

### 4.4 System Monitoring
- Real-time system health dashboards
- Performance metrics and diagnostics
- Error tracking and alerting configuration

### 4.5 Platform Analytics
- Cross-brand analytics and reporting
- Usage metrics and trend analysis
- Executive dashboard generation

### 4.6 Integration Management
- API key generation and rotation
- Webhook endpoint configuration
- Third-party integration settings

## 5. Screen Inventory


## 6. Integration Points


## 7. Security Considerations

### 7.1 Access Requirements
- **Authentication**: MFA mandatory for all Platform Admin users
- **Authorization**: Highest privilege tier (Level 5)
- **Session**: 30-minute idle timeout, 8-hour max session

### 7.2 Audit Requirements
- All actions logged with user, timestamp, and IP
- Sensitive operations require confirmation
- Audit logs retained for 7 years (compliance)

### 7.3 Data Protection
- PII handling follows GDPR/CCPA guidelines
- Encryption at rest and in transit
- Role-based data visibility filters

> **Reference**: See [12_Non_Functional_Requirements/12.2_Security.md](../12_Non_Functional_Requirements/12.2_Security.md)

## 8. Cross-References


## 9. Revision History

*Module Overview - Platform Administration*
*NewPOPSys v1.38 SRS Documentation*


---
# A001: Admin Dashboard

## 1. Overview


## 2. Screenshot Reference

![Admin Dashboard](./screenshots/PSP_Admin/psp_admin_dashboard.png)

*Figure A001-1: Admin Dashboard - Platform-wide system health, security events, and operational metrics*

> **Layout Reference:** Design patterns follow Brand Dashboard (B01) conventions.

## 3. Screen Description

The Admin Dashboard serves as the command center for Platform Administrators, providing a consolidated view of system health, security events, tenant status, and operational metrics. This screen is the primary landing page for users with Platform Admin or PSP Admin roles.

The dashboard displays real-time system health indicators, recent security events requiring attention, tenant activity summaries, and quick-access navigation to critical administrative functions. Key performance indicators (KPIs) are prominently displayed to enable rapid assessment of platform status.

Platform Admins use this screen to monitor overall system health, identify security anomalies, and navigate to detailed administrative functions. The dashboard supports drill-down into specific metrics and provides contextual links to relevant management screens.

## 4. User Access (RBAC)


## 5. Data Model

### Primary Entities

- **Tenant** - PSP tenant configuration and status
  - Key fields: tenant_id, name, status, created_at, settings
- **AuditEvent** - System-wide audit trail entries
  - Key fields: event_id, event_type, actor_id, timestamp, correlation_id
- **User** - Platform user accounts
  - Key fields: user_id, email, role, tenant_id, last_login
- **SystemHealth** - Real-time system metrics (derived)
  - Key fields: service_name, status, latency, error_rate

### Relationships

![10_Module_PlatformAdmin_screens_A001_Admin_Dashboard_diagram_0](./diagrams_rendered/10_Module_PlatformAdmin_screens_A001_Admin_Dashboard_diagram_0.png)

## 6. APIs

### Internal APIs


### External Integrations


## 7. Business Rules

- BR-A001-01: Dashboard data refreshes every 60 seconds automatically
- BR-A001-02: Security events with severity >= HIGH display in alert panel
- BR-A001-03: PSP Admin sees only their tenant's data (tenant isolation)
- BR-A001-04: System health indicators use traffic-light status (green/yellow/red)
- BR-A001-05: Failed authentication attempts > 5 in 15 minutes triggers security alert

## 8. UI Components

### Dashboard Widgets


### Quick Actions Menu

- User Management (A002)
- Brand Configuration (A003)
- System Settings (A004)
- Audit Logs (A005)
- Support Queue (A006)

## 9. Acceptance Criteria

- [ ] AC-A001-01: Platform Admin can view all tenant data on dashboard
- [ ] AC-A001-02: PSP Admin sees only their tenant's metrics
- [ ] AC-A001-03: Support Agent can view dashboard in read-only mode
- [ ] AC-A001-04: Security events display with severity color coding
- [ ] AC-A001-05: Dashboard auto-refreshes without page reload
- [ ] AC-A001-06: Clicking on KPI navigates to detailed view
- [ ] AC-A001-07: System health shows status for all critical services
- [ ] AC-A001-08: MFA status indicator visible for admin session

## 10. Related Documents

- SUPP-029 - Observability, Metrics, and Audit
- SUPP-030 - Admin Ops Console (deprecated, merged into module)
- SUPP-031 - Supportability, Logs, and Impersonation
- SRS-4.4.1 - Platform Admin Persona

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*


---
# A002: User Management

## 1. Overview


## 2. Screenshot Reference

![User Management](./screenshots/PSP_Admin/psp_admin_users.png)

*Figure A002-1: User Management - Platform user administration with roles, permissions, and session management*

> **Layout Reference:** Design follows standard user management grid patterns.

## 3. Screen Description

The User Management screen provides comprehensive user account administration capabilities across the platform. Platform Admins can manage users across all tenants, while PSP Admins are scoped to their own tenant.

This screen enables user creation, role assignment, permission management, and account lifecycle operations (enable/disable/delete). It also provides access to user activity logs, session management, and security settings including MFA enforcement.

Key features include bulk user operations, role-based filtering, user search, and the ability to view impersonation history for any user account.

## 4. User Access (RBAC)


## 5. Data Model

### Primary Entities

- **User** - Platform user accounts
  - Key fields: user_id, email, first_name, last_name, role, tenant_id, status, mfa_enabled, created_at, last_login
- **Role** - System role definitions
  - Key fields: role_id, name, permissions[], scope_type
- **UserSession** - Active user sessions
  - Key fields: session_id, user_id, created_at, expires_at, ip_address
- **ImpersonationLog** - Impersonation history
  - Key fields: log_id, impersonator_id, target_user_id, reason, start_time, end_time

### Relationships

![10_Module_PlatformAdmin_screens_A002_User_Management_diagram_0](./diagrams_rendered/10_Module_PlatformAdmin_screens_A002_User_Management_diagram_0.png)

## 6. APIs

### Internal APIs


### External Integrations


## 7. Business Rules

- BR-A002-01: Platform Admin cannot delete other Platform Admins (requires direct DB access)
- BR-A002-02: MFA is mandatory for Platform Admin, PSP Admin, and Brand Admin roles (per SUPP-003)
- BR-A002-03: User deletion is soft-delete; records retained for audit compliance
- BR-A002-04: PSP Admin can only manage users within their tenant
- BR-A002-05: Impersonation requires reason field and creates audit trail
- BR-A002-06: Impersonation sessions expire after 30 minutes (hard limit: 2 hours)
- BR-A002-07: Password reset triggers mandatory password change on next login
- BR-A002-08: Account lockout after 5 failed login attempts (15-minute cooldown)
- BR-A002-09: Support Agent can only impersonate Store Users in read-only mode

## 8. UI Components

### User List Table


### User Detail Panel

- Profile Information (editable)
- Role Assignment
- Permission Overrides (if applicable)
- MFA Settings
- Session History
- Impersonation History
- Audit Trail (recent actions by user)

### Bulk Actions

- Enable/Disable selected users
- Force password reset
- Export user list (CSV)

## 9. State Transitions

![10_Module_PlatformAdmin_screens_A002_User_Management_diagram_1](./diagrams_rendered/10_Module_PlatformAdmin_screens_A002_User_Management_diagram_1.png)

## 10. Acceptance Criteria

- [ ] AC-A002-01: Platform Admin can create users in any tenant
- [ ] AC-A002-02: PSP Admin can only see and manage users in their tenant
- [ ] AC-A002-03: User creation sends invitation email
- [ ] AC-A002-04: Role assignment updates permissions immediately
- [ ] AC-A002-05: Impersonation requires reason and creates audit event
- [ ] AC-A002-06: Impersonation session shows banner to impersonated user
- [ ] AC-A002-07: MFA reset requires confirmation
- [ ] AC-A002-08: Bulk actions apply to selected users only
- [ ] AC-A002-09: User search returns results within 500ms
- [ ] AC-A002-10: Deleted users cannot log in but records are retained

## 11. Related Documents

- SUPP-003 - RBAC and Permissions Matrix
- SUPP-031 - Supportability, Logs, and Impersonation
- SRS-4.2 - Permission Matrix
- SRS-4.4.1 - Platform Admin Persona

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*


---
# A003: Brand Configuration

## 1. Overview


## 2. Screenshot Reference

![Brand Configuration](./screenshots/PSP_Admin/psp_admin_brands.png)

*Figure A003-1: Brand Configuration - Brand tenant onboarding, feature flags, and integration settings*

> **Layout Reference:** Design follows brand onboarding patterns from SUPP documents.

## 3. Screen Description

The Brand Configuration screen enables Platform Admins and PSP Admins to onboard and configure brand tenants within the PSP ecosystem. This screen provides comprehensive brand setup including branding assets, notification preferences, feature flag configurations, and integration settings.

Brand onboarding follows a "skeletonize" approach where the PSP creates the brand structure, configures initial settings, and then invites Brand Admin users to complete detailed configuration. This screen manages the PSP-level brand settings that determine platform behavior for each brand.

Key capabilities include brand creation, feature flag management, API key provisioning, notification channel configuration, and brand-level policy settings.

## 4. User Access (RBAC)


## 5. Data Model

### Primary Entities

- **Brand** - Brand tenant configuration
  - Key fields: brand_id, name, tenant_id, status, logo_url, primary_color, created_at
- **BrandSettings** - Brand-specific settings
  - Key fields: brand_id, notification_preferences, verification_mode, sla_settings
- **FeatureFlag** - Feature flag configurations
  - Key fields: flag_id, flag_key, scope_type, scope_id, value, enabled
- **APIKey** - Brand API credentials
  - Key fields: key_id, brand_id, key_hash, permissions[], created_at, expires_at

### Relationships

![10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_0](./diagrams_rendered/10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_0.png)

## 6. APIs

### Internal APIs


### External Integrations


## 7. Business Rules

- BR-A003-01: Brand names must be unique within a PSP tenant
- BR-A003-02: Brand deletion is soft-delete; historical data retained
- BR-A003-03: API keys are shown only once at creation; stored hashed
- BR-A003-04: Feature flag changes are audited with before/after values
- BR-A003-05: Feature flags use scope precedence: USER > STORE > CAMPAIGN > BRAND > TENANT
- BR-A003-06: Brand status change to Inactive disables all brand user logins
- BR-A003-07: At least one Brand Admin must be invited before brand goes Active
- BR-A003-08: Notification preferences inherit from PSP defaults if not overridden

## 8. UI Components

### Brand List Table


### Brand Configuration Tabs

1. **General Settings**
   - Brand name, logo, colors
   - Contact information
   - Status management

2. **Notification Preferences**
   - Email notification toggles
   - Webhook configuration
   - Escalation rules

3. **Feature Flags**
   - Flag list with toggle controls
   - Scope selection (Brand-wide vs Campaign-specific)
   - Override inheritance display

4. **API Keys**
   - Key list with permissions
   - Create new key
   - Revoke existing keys

5. **Users**
   - Brand-level user list
   - Invite Brand Admin

## 9. State Transitions

![10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_1](./diagrams_rendered/10_Module_PlatformAdmin_screens_A003_Brand_Configuration_diagram_1.png)

## 10. Feature Flag Configuration

### Available Feature Flags (v1)


## 11. Acceptance Criteria

- [ ] AC-A003-01: Platform Admin can create brands in any tenant
- [ ] AC-A003-02: PSP Admin can only create brands in their tenant
- [ ] AC-A003-03: Brand creation initializes default settings
- [ ] AC-A003-04: Feature flag changes take effect immediately
- [ ] AC-A003-05: API key is displayed only once at creation
- [ ] AC-A003-06: Brand deactivation prevents user logins
- [ ] AC-A003-07: Logo upload accepts PNG/JPG up to 2MB
- [ ] AC-A003-08: Brand admin invitation sends email notification
- [ ] AC-A003-09: Audit log records all configuration changes
- [ ] AC-A003-10: Feature flag scope inheritance is visually indicated

## 12. Related Documents

- SUPP-003 - RBAC and Permissions Matrix
- SUPP-023 - Feature Flags Admin UX
- SUPP-004 - Notifications and Escalation Matrix
- SRS-4.4.1 - Platform Admin Persona

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*


---
# A004: System Settings

## 1. Overview


## 2. Screenshot Reference

![System Settings](./screenshots/PSP_Admin/psp_admin_settings.png)

*Figure A004-1: System Settings - Platform-wide configuration, webhooks, and feature flag management*

> **Layout Reference:** Design follows standard settings management patterns.

## 3. Screen Description

The System Settings screen provides centralized configuration for platform-wide and tenant-wide settings. Platform Admins have access to global system configuration, while PSP Admins can configure tenant-specific settings within their scope.

This screen manages critical platform behaviors including authentication policies, API rate limits, webhook configurations, feature flags at the platform level, email delivery settings, and data retention policies. Changes to system settings are considered high-risk operations and require confirmation.

The settings are organized into logical categories with clear descriptions of each setting's impact. All changes are audited with before/after values for compliance and troubleshooting purposes.

## 4. User Access (RBAC)


## 5. Data Model

### Primary Entities

- **SystemSetting** - Platform-wide settings
  - Key fields: setting_id, key, value, data_type, category, description, last_modified
- **TenantSetting** - Tenant-specific settings
  - Key fields: tenant_id, key, value, inherits_from_system
- **WebhookEndpoint** - Configured webhook destinations
  - Key fields: endpoint_id, url, events[], secret_hash, status, last_delivery
- **EmailConfiguration** - Email delivery settings
  - Key fields: provider, api_key_hash, from_address, reply_to

### Relationships

![10_Module_PlatformAdmin_screens_A004_System_Settings_diagram_0](./diagrams_rendered/10_Module_PlatformAdmin_screens_A004_System_Settings_diagram_0.png)

## 6. APIs

### Internal APIs


### External Integrations


## 7. Business Rules

- BR-A004-01: System settings changes require confirmation dialog
- BR-A004-02: Security-critical settings require MFA re-authentication
- BR-A004-03: Tenant settings inherit from system settings if not overridden
- BR-A004-04: Webhook secrets are shown only once at creation
- BR-A004-05: Webhook delivery uses exponential backoff retry (per SUPP-006)
- BR-A004-06: Email configuration changes require test email before activation
- BR-A004-07: Rate limit changes take effect within 60 seconds
- BR-A004-08: All setting changes are immutably audited

## 8. UI Components

### Settings Categories

1. **Authentication & Security**
   - Password policy (length, complexity, rotation)
   - MFA enforcement rules
   - Session timeout settings
   - Account lockout thresholds
   - IP allowlist/blocklist

2. **API Configuration**
   - Rate limiting (requests per minute)
   - API versioning settings
   - CORS allowed origins
   - Request size limits

3. **Webhooks**
   - Endpoint management
   - Event subscription configuration
   - Retry policy settings
   - Webhook signing key management

4. **Email Delivery**
   - Provider configuration
   - From address settings
   - Template management
   - Delivery queue settings

5. **Feature Flags (Platform Level)**
   - Global feature toggles
   - Rollout percentage controls
   - Kill switches for emergencies

6. **Data Retention**
   - Audit log retention period
   - Session data retention
   - Deleted record retention
   - Export file retention

### Setting Entry Format


## 9. Webhook Configuration

### Event Types Available


### Webhook Delivery Specification

- **Retry Policy**: Exponential backoff (1s, 2s, 4s, 8s, 16s) up to 5 attempts
- **Signing**: HMAC-SHA256 signature in `X-Signature-256` header
- **Timeout**: 30 second connection timeout
- **Idempotency**: Unique `X-Delivery-Id` header for deduplication

## 10. Security Settings Detail

### Password Policy Options


### Session Settings


## 11. Acceptance Criteria

- [ ] AC-A004-01: Platform Admin can modify all system settings
- [ ] AC-A004-02: PSP Admin can only modify tenant settings
- [ ] AC-A004-03: Setting changes display confirmation dialog
- [ ] AC-A004-04: Security settings require MFA re-authentication
- [ ] AC-A004-05: Webhook test sends sample payload successfully
- [ ] AC-A004-06: Email test delivers to specified address
- [ ] AC-A004-07: Setting inheritance is visually indicated
- [ ] AC-A004-08: All changes are recorded in audit log
- [ ] AC-A004-09: Invalid setting values show validation errors
- [ ] AC-A004-10: Rate limit changes apply within 60 seconds

## 12. Related Documents

- SUPP-006 - Webhooks and External Integration
- SUPP-023 - Feature Flags Admin UX
- SUPP-029 - Observability, Metrics, and Audit
- SUPP-027 - Message Delivery
- SRS-4.4.1 - Platform Admin Persona

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*


---
# A005: Audit Logs

## 1. Overview


## 2. Screenshot Reference

![Audit Logs](./screenshots/PSP_Admin/psp_admin_audit.png)

*Figure A005-1: Audit Logs - Immutable audit trail with search, filtering, and compliance export*

> **Layout Reference:** Design follows Audit Explorer patterns from SUPP-029.

## 3. Screen Description

The Audit Logs screen provides comprehensive access to the platform's immutable audit trail. This screen enables administrators to search, filter, and analyze all audited events across the platform for security monitoring, compliance reporting, and troubleshooting.

The audit log captures all significant system events including user actions, data modifications, authentication events, impersonation sessions, and system configuration changes. Each event includes correlation IDs for end-to-end request tracing and actor identification for accountability.

Platform Admins have access to all audit events across all tenants, while PSP Admins and Support Agents are scoped to their tenant's events. The screen supports advanced filtering, date range selection, and export capabilities for compliance reporting.

## 4. User Access (RBAC)


## 5. Data Model

### Primary Entities

- **AuditEvent** - Immutable audit trail entries
  - Key fields: event_id, event_type, actor_id, actor_type, target_type, target_id, action, timestamp, correlation_id, request_id, tenant_id, brand_id, metadata
- **AuditEventType** - Event type definitions
  - Key fields: type_code, description, severity, retention_class

### Event Categories


### Relationships

![10_Module_PlatformAdmin_screens_A005_Audit_Logs_diagram_0](./diagrams_rendered/10_Module_PlatformAdmin_screens_A005_Audit_Logs_diagram_0.png)

## 6. APIs

### Internal APIs


### External Integrations


## 7. Business Rules

- BR-A005-01: Audit log entries are immutable; cannot be modified or deleted
- BR-A005-02: Audit logs are retained for 7 years per COMPLIANCE retention class
- BR-A005-03: Access to audit logs is itself audited
- BR-A005-04: Impersonation events include both actual actor and impersonated actor
- BR-A005-05: High-severity events trigger real-time notifications (per SUPP-004)
- BR-A005-06: Export requests create audit events with export metadata
- BR-A005-07: Correlation ID links all events from a single request chain
- BR-A005-08: Request ID identifies individual service calls within correlation

## 8. UI Components

### Search and Filter Panel


### Event List Table


### Event Detail Panel

- **Event Metadata**
  - Event ID, Type, Timestamp
  - Correlation ID, Request ID
  - Source IP, User Agent

- **Actor Information**
  - Actual Actor (who performed action)
  - Impersonated Actor (if applicable)
  - Actor Role and Tenant

- **Target Information**
  - Resource Type and ID
  - Before/After values (for modifications)

- **Related Events**
  - Events with same Correlation ID
  - Events affecting same target

## 9. Audit Event Schema

```json
{
  "event_id": "uuid",
  "event_type": "record.updated",
  "severity": "INFO",
  "timestamp": "2026-01-01T10:30:00Z",
  "correlation_id": "uuid",
  "request_id": "uuid",
  "actor": {
    "user_id": "uuid",
    "email": "admin@example.com",
    "role": "PLATFORM_ADMIN",
    "ip_address": "192.168.1.1",
    "user_agent": "Mozilla/5.0..."
  },
  "impersonated_actor": null,
  "target": {
    "type": "Brand",
    "id": "uuid",
    "name": "Good2Go"
  },
  "action": "UPDATE",
  "changes": {
    "before": {"status": "active"},
    "after": {"status": "inactive"}
  },
  "metadata": {
    "reason": "Brand requested deactivation"
  }
}
```

## 10. Export Capabilities

### Export Formats


### Export Options

- Date range selection
- Event type filtering
- Include/exclude sensitive fields
- Scheduled exports (daily/weekly)

## 11. Acceptance Criteria

- [ ] AC-A005-01: Platform Admin can view all tenant audit events
- [ ] AC-A005-02: PSP Admin sees only their tenant's events
- [ ] AC-A005-03: Date range filter returns events within range
- [ ] AC-A005-04: Correlation ID search returns all related events
- [ ] AC-A005-05: Event detail shows before/after values for changes
- [ ] AC-A005-06: Impersonation events show both actors clearly
- [ ] AC-A005-07: Export generates file in selected format
- [ ] AC-A005-08: Search returns results within 2 seconds for typical queries
- [ ] AC-A005-09: Pagination works correctly for large result sets
- [ ] AC-A005-10: Accessing audit logs creates its own audit event

## 12. Related Documents

- SUPP-029 - Observability, Metrics, and Audit
- SUPP-031 - Supportability, Logs, and Impersonation
- SUPP-003 - RBAC and Permissions Matrix
- SRS-4.4.1 - Platform Admin Persona

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*


---
# A006: Support Queue

## 1. Overview


## 2. Screenshot Reference

![Support Queue](./screenshots/PSP_Operations/psp_ops_issues.png)

*Figure A006-1: Support Queue - Support ticket management, failed webhooks, and system alerts*

> **Layout Reference:** Design follows standard support ticketing patterns.

## 3. Screen Description

The Support Queue screen provides a centralized interface for managing customer support requests, escalated issues, and system alerts requiring attention. Support Agents use this screen as their primary workspace for handling support cases.

This screen aggregates support tickets, failed webhook deliveries requiring retry, user-reported issues, and system-generated alerts. It provides quick access to user impersonation (read-only for Support Agents), audit log viewing, and case management tools.

The queue supports filtering by priority, status, category, and assignment. Cases can be assigned to specific agents or teams, and all case interactions are tracked for quality assurance and training purposes.

## 4. User Access (RBAC)


## 5. Data Model

### Primary Entities

- **SupportCase** - Support ticket/case
  - Key fields: case_id, subject, description, status, priority, category, reporter_id, assignee_id, tenant_id, created_at, updated_at, resolved_at
- **CaseComment** - Case discussion thread
  - Key fields: comment_id, case_id, author_id, content, is_internal, created_at
- **FailedWebhook** - Failed webhook delivery for retry
  - Key fields: delivery_id, endpoint_id, event_type, payload, attempts, last_attempt, status
- **SystemAlert** - System-generated alerts
  - Key fields: alert_id, alert_type, severity, message, acknowledged, created_at

### Relationships

![10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_0](./diagrams_rendered/10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_0.png)

## 6. APIs

### Internal APIs


### External Integrations


## 7. Business Rules

- BR-A006-01: New cases default to "Open" status and "Medium" priority
- BR-A006-02: Cases auto-escalate if unacknowledged for 4 hours
- BR-A006-03: Critical priority cases trigger immediate notification
- BR-A006-04: Support Agent can impersonate users (read-only) for debugging
- BR-A006-05: Internal comments are not visible to case reporter
- BR-A006-06: Failed webhooks can be retried up to 5 additional times manually
- BR-A006-07: Resolved cases can be reopened within 30 days
- BR-A006-08: Case resolution requires resolution category and notes

## 8. UI Components

### Queue Tabs


### Case List Table


### Case Detail Panel

- **Case Information**
  - Subject, Description
  - Status, Priority, Category
  - Reporter details with impersonation link
  - Assignee with reassign option

- **Timeline**
  - Chronological activity log
  - Comments (internal and external)
  - Status changes
  - Assignment changes

- **Actions**
  - Add Comment (internal/external toggle)
  - Change Status
  - Change Priority
  - Reassign
  - Impersonate Reporter (read-only)
  - View Related Audit Events
  - Resolve Case

### Failed Webhook Panel


## 9. State Transitions

### Case Status Flow

![10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_1](./diagrams_rendered/10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_1.png)

### Case Priority Levels


## 10. Impersonation Integration

### Support Agent Impersonation

- **Scope**: Store Users only (per SUPP-003)
- **Mode**: Read-only (cannot modify data)
- **Access Path**: Case Detail â†’ Reporter â†’ Impersonate
- **Session Limit**: 30 minutes
- **Requirements**: Reason required, audit logged

### Impersonation UI

1. Click "Impersonate Reporter" on case
2. Enter reason for impersonation
3. Confirm impersonation start
4. Read-only session begins with banner
5. "End Impersonation" button always visible
6. Auto-terminate at 30 minutes

## 11. Acceptance Criteria

- [ ] AC-A006-01: Support Agent sees cases scoped to their tenant
- [ ] AC-A006-02: Unassigned queue shows cases awaiting assignment
- [ ] AC-A006-03: Case assignment sends notification to assignee
- [ ] AC-A006-04: Internal comments are hidden from case reporter
- [ ] AC-A006-05: Failed webhook retry attempts delivery
- [ ] AC-A006-06: Impersonation requires reason and is audited
- [ ] AC-A006-07: Impersonation session is read-only for Support Agent
- [ ] AC-A006-08: Case resolution requires category and notes
- [ ] AC-A006-09: SLA timers display on case list
- [ ] AC-A006-10: Auto-escalation triggers after SLA threshold

## 12. Related Documents

- SUPP-031 - Supportability, Logs, and Impersonation
- SUPP-004 - Notifications and Escalation Matrix
- SUPP-003 - RBAC and Permissions Matrix
- SRS-4.4.1 - Platform Admin Persona

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*


---

# Section 11: API Specifications
# 11.1 API Overview

## Document Information


## 1. Introduction

### 1.1 Purpose
This document provides a comprehensive overview of the NewPOPSys API architecture, including authentication mechanisms, versioning strategies, rate limiting policies, and error handling conventions. It serves as the foundational reference for all API consumers and integrators.

### 1.2 Scope
The NewPOPSys API enables:
- **Inbound Operations**: PSP systems acknowledging orders, updating statuses, and creating shipments
- **Outbound Webhooks**: Event-driven notifications to integrated systems
- **Internal Services**: Survey management, store layouts, photo rules, and health monitoring

### 1.3 API Version


## 2. Server Environments

### 2.1 Environment Configuration


### 2.2 Environment Identification
API keys are prefixed to identify their environment:


## 3. Authentication

### 3.1 API Key Authentication
NewPOPSys uses API Key authentication for all API requests.

#### 3.1.1 Request Header Format
```http
X-API-Key: vg_live_your_api_key_here
```

#### 3.1.2 Authentication Flow
[Diagram - See rendered image above or refer to source document]

### 3.2 API Key Security Requirements


### 3.3 Authentication Errors


**Example Error Response:**
```json
{
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid or missing API key",
    "timestamp": "2025-01-13T10:30:00Z",
    "requestId": "req_abc123def456"
  }
}
```

## 4. API Versioning

### 4.1 Versioning Strategy
NewPOPSys employs **URL Path Versioning** for explicit version control.

### 4.2 Version Lifecycle


### 4.3 Breaking vs Non-Breaking Changes

**Non-Breaking Changes (No Version Bump):**
- Adding new optional request parameters
- Adding new response fields
- Adding new endpoints
- Adding new webhook event types

**Breaking Changes (Major Version Bump):**
- Removing or renaming fields
- Changing field types
- Modifying required parameters
- Changing endpoint paths
- Altering authentication mechanisms

### 4.4 Deprecation Headers
When endpoints are deprecated, responses include:

```http
Deprecation: true
Sunset: Sat, 01 Jul 2025 00:00:00 GMT
Link: <https://docs.newpopsys.com/migration>; rel="deprecation"
```

## 5. Rate Limiting

### 5.1 Rate Limit Tiers


### 5.2 Rate Limit Response Headers


**Example Response Headers:**
```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 300
X-RateLimit-Remaining: 247
X-RateLimit-Reset: 1705142400
Content-Type: application/json
```

### 5.3 Rate Limit Exceeded Response
When rate limits are exceeded, the API returns HTTP 429:

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please retry after 45 seconds.",
    "retryAfter": 45,
    "timestamp": "2025-01-13T10:30:00Z",
    "requestId": "req_abc123def456"
  }
}
```

**Response Headers:**
```http
HTTP/1.1 429 Too Many Requests
Retry-After: 45
X-RateLimit-Limit: 300
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1705142445
```

### 5.4 Rate Limit Best Practices


## 6. Request Standards

### 6.1 Content Types


### 6.2 Request Headers


### 6.3 Idempotency

For POST, PUT, and PATCH requests, use the `Idempotency-Key` header to ensure exactly-once semantics:

```http
POST /v1/orders/ORD-001/shipments HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Idempotency-Key: idem_7f8e9d0c-1a2b-3c4d-5e6f-7a8b9c0d1e2f
Content-Type: application/json

{
  "carrier": "UPS",
  "trackingNumber": "1Z999AA10123456784"
}
```

**Idempotency Behavior:**


## 7. Response Standards

### 7.1 HTTP Status Codes

#### Success Codes


#### Client Error Codes


#### Server Error Codes


### 7.2 Standard Response Format

#### Success Response
```json
{
  "data": {
    "id": "ORD-2025-001234",
    "status": "acknowledged",
    "updatedAt": "2025-01-13T10:30:00Z"
  },
  "meta": {
    "requestId": "req_abc123def456",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

#### Collection Response (with Pagination)
```json
{
  "data": [
    { "id": "ORD-001", "status": "pending" },
    { "id": "ORD-002", "status": "shipped" }
  ],
  "meta": {
    "requestId": "req_abc123def456",
    "timestamp": "2025-01-13T10:30:00Z"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 156,
    "totalPages": 8,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
```

### 7.3 Error Response Format

All error responses follow a consistent structure:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "trackingNumber",
        "message": "Tracking number is required",
        "code": "REQUIRED_FIELD"
      },
      {
        "field": "carrier",
        "message": "Invalid carrier code",
        "code": "INVALID_VALUE",
        "allowedValues": ["UPS", "FEDEX", "USPS", "DHL"]
      }
    ],
    "timestamp": "2025-01-13T10:30:00Z",
    "requestId": "req_abc123def456",
    "documentationUrl": "https://docs.newpopsys.com/errors/VALIDATION_ERROR"
  }
}
```

### 7.4 Error Code Reference


## 8. Pagination

### 8.1 Pagination Parameters


### 8.2 Example Request
```http
GET /v1/orders?page=2&pageSize=50&sort=-createdAt HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

### 8.3 Sort Direction


## 9. Health Check Endpoints

### 9.1 Endpoint Summary


### 9.2 Health Response

```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2025-01-13T10:30:00Z",
  "checks": {
    "database": "healthy",
    "redis": "healthy",
    "queue": "healthy"
  }
}
```

### 9.3 Health Status Values


## 10. Security Considerations

### 10.1 Transport Security


### 10.2 Request Validation


### 10.3 Audit Logging

All API requests are logged with:
- Request timestamp
- API key (masked)
- Request ID
- Endpoint and method
- Response status code
- Response time
- Client IP (anonymized for GDPR)

## 11. SDK and Client Libraries

### 11.1 Official SDKs


### 11.2 API Client Generation
OpenAPI specification available for generating custom clients:
```
https://api.newpopsys.com/v1/openapi.json
https://api.newpopsys.com/v1/openapi.yaml
```

## 12. Related Documents


## Revision History


---
# 11.2 Internal APIs

## Document Information


## 1. Introduction

### 1.1 Purpose
This document specifies all internal RESTful API endpoints for the NewPOPSys platform. These APIs enable PSP (Print Service Provider) systems and internal services to interact with the NewPOPSys platform for order management, shipment tracking, and related operations.

### 1.2 Base URL
All endpoints are relative to the base URL:
- **Production**: `https://api.newpopsys.com/v1`
- **Staging**: `https://staging-api.newpopsys.com/v1`
- **Development**: `http://localhost:3000/v1`

### 1.3 Authentication
All endpoints require API key authentication via the `X-API-Key` header unless otherwise specified.

## 2. Orders API

### 2.1 Endpoint Summary


### 2.2 Acknowledge Order

Acknowledges receipt of an order from NewPOPSys, confirming the PSP has received and will process the order.

#### Request

```http
POST /v1/orders/{orderId}/acknowledge HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "acknowledgedAt": "2025-01-13T10:30:00Z",
  "estimatedShipDate": "2025-01-15",
  "notes": "Order received and queued for production"
}
```

#### Path Parameters

#### Request Body


#### Response

**Success (200 OK)**
```json
{
  "data": {
    "orderId": "ORD-2025-001234",
    "status": "acknowledged",
    "acknowledgedAt": "2025-01-13T10:30:00Z",
    "estimatedShipDate": "2025-01-15"
  },
  "meta": {
    "requestId": "req_abc123def456",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

**Error Responses**


### 2.3 Update Order Status

Updates the current status of an order in the fulfillment workflow.

#### Request

```http
PUT /v1/orders/{orderId}/status HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "status": "in_production",
  "statusDetails": "Printing in progress - 50% complete",
  "updatedAt": "2025-01-13T14:30:00Z"
}
```

#### Path Parameters

#### Request Body


#### Valid Status Values


#### Response

**Success (200 OK)**
```json
{
  "data": {
    "orderId": "ORD-2025-001234",
    "previousStatus": "acknowledged",
    "currentStatus": "in_production",
    "statusDetails": "Printing in progress - 50% complete",
    "updatedAt": "2025-01-13T14:30:00Z"
  },
  "meta": {
    "requestId": "req_def456ghi789",
    "timestamp": "2025-01-13T14:30:00Z"
  }
}
```

**Error Responses**


## 3. Shipments API

### 3.1 Endpoint Summary


### 3.2 Create Shipment

Creates a shipment record for an order with tracking information.

#### Request

```http
POST /v1/orders/{orderId}/shipments HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json
Idempotency-Key: idem_7f8e9d0c-1a2b-3c4d-5e6f-7a8b9c0d1e2f

{
  "carrier": "UPS",
  "trackingNumber": "1Z999AA10123456784",
  "serviceType": "GROUND",
  "shippedAt": "2025-01-15T09:00:00Z",
  "estimatedDelivery": "2025-01-18",
  "packages": [
    {
      "weight": 2.5,
      "weightUnit": "lb",
      "dimensions": {
        "length": 12,
        "width": 10,
        "height": 4,
        "unit": "in"
      },
      "contents": "POP Display Kit - Store #1234"
    }
  ],
  "shipFrom": {
    "name": "PSP Fulfillment Center",
    "address1": "100 Industrial Way",
    "city": "Chicago",
    "state": "IL",
    "postalCode": "60601",
    "country": "US"
  },
  "shipTo": {
    "name": "Store Manager",
    "company": "Retail Store #1234",
    "address1": "500 Main Street",
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US"
  }
}
```

#### Path Parameters

#### Request Body


#### Valid Carrier Codes


#### Response

**Success (201 Created)**
```json
{
  "data": {
    "shipmentId": "SHP-2025-001234",
    "orderId": "ORD-2025-001234",
    "carrier": "UPS",
    "trackingNumber": "1Z999AA10123456784",
    "trackingUrl": "https://www.ups.com/track?tracknum=1Z999AA10123456784",
    "status": "in_transit",
    "shippedAt": "2025-01-15T09:00:00Z",
    "estimatedDelivery": "2025-01-18"
  },
  "meta": {
    "requestId": "req_ghi789jkl012",
    "timestamp": "2025-01-15T09:00:00Z"
  }
}
```

**Error Responses**


### 3.3 Confirm Delivery

Confirms that a shipment has been delivered to the destination.

#### Request

```http
PUT /v1/shipments/{shipmentId}/delivered HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "deliveredAt": "2025-01-18T14:30:00Z",
  "signedBy": "J. Smith",
  "deliveryNotes": "Left at front desk",
  "proofOfDelivery": {
    "type": "signature",
    "imageUrl": "https://storage.example.com/pod/SHP-2025-001234.png"
  }
}
```

#### Path Parameters

#### Request Body


#### Response

**Success (200 OK)**
```json
{
  "data": {
    "shipmentId": "SHP-2025-001234",
    "orderId": "ORD-2025-001234",
    "status": "delivered",
    "deliveredAt": "2025-01-18T14:30:00Z",
    "signedBy": "J. Smith"
  },
  "meta": {
    "requestId": "req_mno345pqr678",
    "timestamp": "2025-01-18T14:30:00Z"
  }
}
```

## 4. Surveys API

### 4.1 Endpoint Summary


### 4.2 List Survey Templates

Retrieves available survey templates for a tenant.

#### Request

```http
GET /v1/surveys/templates?page=1&pageSize=20 HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Query Parameters


#### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "templateId": "TMPL-001",
      "name": "Store Installation Survey",
      "description": "Post-installation verification survey",
      "version": "2.0",
      "status": "active",
      "questionCount": 15,
      "estimatedMinutes": 10,
      "createdAt": "2024-06-01T00:00:00Z",
      "updatedAt": "2024-12-15T00:00:00Z"
    },
    {
      "templateId": "TMPL-002",
      "name": "Pre-Visit Store Assessment",
      "description": "Initial store layout assessment",
      "version": "1.5",
      "status": "active",
      "questionCount": 25,
      "estimatedMinutes": 20,
      "createdAt": "2024-03-15T00:00:00Z",
      "updatedAt": "2024-11-01T00:00:00Z"
    }
  ],
  "meta": {
    "requestId": "req_stu901vwx234",
    "timestamp": "2025-01-13T10:30:00Z"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 8,
    "totalPages": 1,
    "hasNextPage": false,
    "hasPreviousPage": false
  }
}
```

### 4.3 Get Survey Template

Retrieves detailed survey template including all questions.

#### Request

```http
GET /v1/surveys/templates/TMPL-001 HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "templateId": "TMPL-001",
    "name": "Store Installation Survey",
    "description": "Post-installation verification survey",
    "version": "2.0",
    "status": "active",
    "sections": [
      {
        "sectionId": "SEC-001",
        "title": "Display Installation",
        "order": 1,
        "questions": [
          {
            "questionId": "Q-001",
            "type": "multiple_choice",
            "text": "Was the display installed in the correct location?",
            "required": true,
            "options": ["Yes", "No", "Partially"]
          },
          {
            "questionId": "Q-002",
            "type": "photo",
            "text": "Take a photo of the installed display",
            "required": true,
            "validation": {
              "minPhotos": 1,
              "maxPhotos": 5,
              "minResolution": "1920x1080"
            }
          },
          {
            "questionId": "Q-003",
            "type": "text",
            "text": "Describe any installation issues",
            "required": false,
            "validation": {
              "maxLength": 500
            }
          }
        ]
      }
    ],
    "createdAt": "2024-06-01T00:00:00Z",
    "updatedAt": "2024-12-15T00:00:00Z"
  },
  "meta": {
    "requestId": "req_yza567bcd890",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

### 4.4 Submit Survey Response

Submits a completed survey response.

#### Request

```http
POST /v1/surveys/responses HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json
Idempotency-Key: idem_survey_response_12345

{
  "templateId": "TMPL-001",
  "storeId": "STORE-1234",
  "campaignId": "CAMP-2025-Q1",
  "submittedBy": {
    "userId": "USR-567",
    "name": "John Installer",
    "email": "john@installer.com"
  },
  "answers": [
    {
      "questionId": "Q-001",
      "value": "Yes"
    },
    {
      "questionId": "Q-002",
      "value": {
        "photos": [
          {
            "url": "https://storage.example.com/photos/photo1.jpg",
            "takenAt": "2025-01-13T10:00:00Z",
            "location": {
              "latitude": 43.0389,
              "longitude": -87.9065
            }
          }
        ]
      }
    },
    {
      "questionId": "Q-003",
      "value": "No issues encountered"
    }
  ],
  "completedAt": "2025-01-13T10:30:00Z",
  "deviceInfo": {
    "type": "mobile",
    "os": "iOS 17.2",
    "appVersion": "2.5.0"
  }
}
```

#### Response

**Success (201 Created)**
```json
{
  "data": {
    "responseId": "RESP-2025-001234",
    "templateId": "TMPL-001",
    "storeId": "STORE-1234",
    "campaignId": "CAMP-2025-Q1",
    "status": "submitted",
    "completedAt": "2025-01-13T10:30:00Z",
    "validationStatus": "pending"
  },
  "meta": {
    "requestId": "req_efg123hij456",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

## 5. Store Layouts API

### 5.1 Endpoint Summary


### 5.2 Get Store Layout

Retrieves the current layout configuration for a store.

#### Request

```http
GET /v1/stores/STORE-1234/layouts HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "storeId": "STORE-1234",
    "storeName": "Downtown Milwaukee #1234",
    "layoutVersion": "3.2",
    "lastUpdated": "2025-01-10T08:00:00Z",
    "dimensions": {
      "width": 50,
      "length": 80,
      "unit": "feet"
    },
    "zones": [
      {
        "zoneId": "ZONE-A",
        "name": "Entrance Display Area",
        "type": "high_traffic",
        "position": {
          "x": 0,
          "y": 0,
          "width": 15,
          "length": 20
        },
        "fixtures": [
          {
            "fixtureId": "FIX-001",
            "type": "floor_display",
            "name": "Main Promotional Display",
            "dimensions": {
              "width": 4,
              "depth": 2,
              "height": 6,
              "unit": "feet"
            },
            "position": {
              "x": 5,
              "y": 8
            }
          }
        ]
      },
      {
        "zoneId": "ZONE-B",
        "name": "Checkout Area",
        "type": "point_of_sale",
        "position": {
          "x": 35,
          "y": 70,
          "width": 15,
          "length": 10
        },
        "fixtures": []
      }
    ],
    "floorPlanUrl": "https://storage.example.com/layouts/STORE-1234-v3.2.pdf"
  },
  "meta": {
    "requestId": "req_klm789nop012",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

### 5.3 Update Store Layout

Updates the store layout configuration.

#### Request

```http
PUT /v1/stores/STORE-1234/layouts HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "zones": [
    {
      "zoneId": "ZONE-A",
      "name": "Entrance Display Area",
      "type": "high_traffic",
      "position": {
        "x": 0,
        "y": 0,
        "width": 15,
        "length": 20
      },
      "fixtures": [
        {
          "fixtureId": "FIX-001",
          "type": "floor_display",
          "name": "Main Promotional Display",
          "position": {
            "x": 5,
            "y": 8
          }
        },
        {
          "fixtureId": "FIX-002",
          "type": "endcap",
          "name": "New Seasonal Endcap",
          "position": {
            "x": 12,
            "y": 5
          }
        }
      ]
    }
  ],
  "changeReason": "Added new seasonal endcap display",
  "effectiveDate": "2025-01-15"
}
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "storeId": "STORE-1234",
    "layoutVersion": "3.3",
    "previousVersion": "3.2",
    "lastUpdated": "2025-01-13T10:30:00Z",
    "effectiveDate": "2025-01-15",
    "changeReason": "Added new seasonal endcap display"
  },
  "meta": {
    "requestId": "req_qrs345tuv678",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

## 6. Photo Rules API

### 6.1 Endpoint Summary


### 6.2 List Photo Rules

Retrieves all photo validation rules for the tenant.

#### Request

```http
GET /v1/photo-rules?category=installation HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Query Parameters


#### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "ruleId": "RULE-001",
      "name": "Display Installation Photo",
      "category": "installation",
      "status": "active",
      "requirements": {
        "minResolution": {
          "width": 1920,
          "height": 1080
        },
        "maxFileSize": "10MB",
        "allowedFormats": ["jpeg", "png", "heic"],
        "requireGeoLocation": true,
        "requireTimestamp": true,
        "maxAge": "24h"
      },
      "aiValidation": {
        "enabled": true,
        "checks": [
          "display_visibility",
          "proper_installation",
          "branding_compliance"
        ],
        "minimumConfidence": 0.85
      }
    },
    {
      "ruleId": "RULE-002",
      "name": "Store Front Photo",
      "category": "verification",
      "status": "active",
      "requirements": {
        "minResolution": {
          "width": 1280,
          "height": 720
        },
        "maxFileSize": "5MB",
        "allowedFormats": ["jpeg", "png"],
        "requireGeoLocation": true,
        "requireTimestamp": true,
        "maxAge": "1h"
      },
      "aiValidation": {
        "enabled": true,
        "checks": [
          "store_front_visible",
          "signage_readable"
        ],
        "minimumConfidence": 0.80
      }
    }
  ],
  "meta": {
    "requestId": "req_wxy901zab234",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

### 6.3 Validate Photo

Validates a photo against specified rules.

#### Request

```http
POST /v1/photos/validate HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "photoUrl": "https://storage.example.com/uploads/photo123.jpg",
  "ruleIds": ["RULE-001"],
  "metadata": {
    "storeId": "STORE-1234",
    "campaignId": "CAMP-2025-Q1",
    "takenAt": "2025-01-13T10:00:00Z",
    "location": {
      "latitude": 43.0389,
      "longitude": -87.9065,
      "accuracy": 5
    }
  }
}
```

#### Response

**Success (200 OK)**
```json
{
  "data": {
    "validationId": "VAL-2025-001234",
    "status": "passed",
    "results": [
      {
        "ruleId": "RULE-001",
        "passed": true,
        "checks": {
          "resolution": {
            "passed": true,
            "actual": {
              "width": 3024,
              "height": 4032
            },
            "required": {
              "width": 1920,
              "height": 1080
            }
          },
          "fileSize": {
            "passed": true,
            "actual": "4.2MB",
            "maximum": "10MB"
          },
          "geoLocation": {
            "passed": true,
            "distanceFromStore": "15m",
            "maximumAllowed": "100m"
          },
          "timestamp": {
            "passed": true,
            "age": "30m",
            "maximumAge": "24h"
          },
          "aiValidation": {
            "passed": true,
            "confidence": 0.92,
            "minimumRequired": 0.85,
            "detections": [
              {
                "check": "display_visibility",
                "confidence": 0.95,
                "passed": true
              },
              {
                "check": "proper_installation",
                "confidence": 0.89,
                "passed": true
              },
              {
                "check": "branding_compliance",
                "confidence": 0.91,
                "passed": true
              }
            ]
          }
        }
      }
    ]
  },
  "meta": {
    "requestId": "req_cde567fgh890",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

## 7. Webhooks Management API

### 7.1 Endpoint Summary


### 7.2 List Webhooks

Retrieves all webhook subscriptions for the authenticated tenant.

#### Request

```http
GET /v1/webhooks?page=1&pageSize=20 HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
```

#### Response

**Success (200 OK)**
```json
{
  "data": [
    {
      "webhookId": "WH-001",
      "url": "https://psp-system.example.com/webhooks/newpopsys",
      "status": "active",
      "events": [
        "order.generated",
        "campaign.published"
      ],
      "createdAt": "2024-06-01T00:00:00Z",
      "lastDeliveryAt": "2025-01-13T09:45:00Z",
      "successRate": 99.2
    }
  ],
  "meta": {
    "requestId": "req_ijk123lmn456",
    "timestamp": "2025-01-13T10:30:00Z"
  },
  "pagination": {
    "page": 1,
    "pageSize": 20,
    "totalItems": 3,
    "totalPages": 1
  }
}
```

### 7.3 Create Webhook

Creates a new webhook subscription.

#### Request

```http
POST /v1/webhooks HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_abc123
Content-Type: application/json

{
  "url": "https://psp-system.example.com/webhooks/newpopsys",
  "events": [
    "order.generated",
    "campaign.published",
    "issue.created"
  ],
  "secret": "whsec_your_secret_key_here",
  "description": "Main PSP integration webhook",
  "headers": {
    "X-Custom-Header": "custom-value"
  }
}
```

#### Request Body


#### Response

**Success (201 Created)**
```json
{
  "data": {
    "webhookId": "WH-002",
    "url": "https://psp-system.example.com/webhooks/newpopsys",
    "status": "active",
    "events": [
      "order.generated",
      "campaign.published",
      "issue.created"
    ],
    "createdAt": "2025-01-13T10:30:00Z"
  },
  "meta": {
    "requestId": "req_opq789rst012",
    "timestamp": "2025-01-13T10:30:00Z"
  }
}
```

## 8. Health API

### 8.1 Endpoint Summary


### 8.2 Health Check

Returns overall system health status.

#### Request

```http
GET /v1/health HTTP/1.1
Host: api.newpopsys.com
```

#### Response

**Success (200 OK)**
```json
{
  "status": "healthy",
  "version": "1.0.0",
  "timestamp": "2025-01-13T10:30:00Z",
  "uptime": "45d 12h 30m",
  "checks": {
    "database": {
      "status": "healthy",
      "latency": "2ms"
    },
    "redis": {
      "status": "healthy",
      "latency": "1ms"
    },
    "queue": {
      "status": "healthy",
      "pendingJobs": 42
    },
    "storage": {
      "status": "healthy",
      "available": "85%"
    }
  }
}
```

**Degraded (200 OK)**
```json
{
  "status": "degraded",
  "version": "1.0.0",
  "timestamp": "2025-01-13T10:30:00Z",
  "checks": {
    "database": {
      "status": "healthy",
      "latency": "2ms"
    },
    "redis": {
      "status": "degraded",
      "latency": "150ms",
      "message": "High latency detected"
    },
    "queue": {
      "status": "healthy",
      "pendingJobs": 42
    }
  }
}
```

## 9. Common Data Types

### 9.1 Address Object

```json
{
  "name": "string",
  "company": "string",
  "address1": "string",
  "address2": "string",
  "city": "string",
  "state": "string",
  "postalCode": "string",
  "country": "string (ISO 3166-1 alpha-2)",
  "phone": "string",
  "email": "string"
}
```

### 9.2 GeoLocation Object

```json
{
  "latitude": "number (-90 to 90)",
  "longitude": "number (-180 to 180)",
  "accuracy": "number (meters)",
  "altitude": "number (meters, optional)"
}
```

### 9.3 Pagination Object

```json
{
  "page": "integer (current page)",
  "pageSize": "integer (items per page)",
  "totalItems": "integer (total count)",
  "totalPages": "integer (total pages)",
  "hasNextPage": "boolean",
  "hasPreviousPage": "boolean"
}
```

## 10. Related Documents


## Revision History


---
# 11.3 External Integrations

## Document Information


## 1. Introduction

### 1.1 Purpose
This document specifies the external system integrations for NewPOPSys, detailing how the platform connects with third-party services including ERP systems, CRM platforms, shipping carriers, and identity providers.

### 1.2 Integration Architecture Overview

[Diagram - See rendered image above or refer to source document]

### 1.3 Integration Partners Summary


## 2. PSP MIS Integration

### 2.1 Overview
Print Service Provider (PSP) Management Information Systems receive orders from NewPOPSys and report back production status and shipment information.

### 2.2 Supported MIS Platforms


### 2.3 Data Flow

[Diagram - See rendered image above or refer to source document]

### 2.4 Order Data Mapping

#### 2.4.1 NewPOPSys to PSP Order Fields


#### 2.4.2 Sample Order Payload

```json
{
  "orderId": "ORD-2025-001234",
  "campaignId": "CAMP-2025-Q1-PROMO",
  "orderDate": "2025-01-13T10:00:00Z",
  "priority": "standard",
  "dueDate": "2025-01-20",
  "customer": {
    "customerId": "CUST-001",
    "name": "Acme Retail Brand",
    "accountNumber": "ACM-12345"
  },
  "items": [
    {
      "lineId": "LN-001",
      "sku": "POP-FLRDSP-24X36",
      "name": "Floor Display Stand 24x36",
      "quantity": 150,
      "specifications": {
        "material": "Corrugated E-Flute",
        "printing": "4/0 CMYK + Spot PMS 185C",
        "finishing": "Gloss Lamination",
        "assembly": "Ship Flat"
      },
      "artworkUrl": "https://storage.newpopsys.com/artwork/ORD-001234/LN-001.pdf"
    }
  ],
  "shippingAddress": {
    "name": "Store Manager",
    "company": "Acme Store #1234",
    "address1": "500 Main Street",
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US"
  },
  "shippingMethod": {
    "carrier": "UPS",
    "service": "GROUND",
    "instructions": "Deliver to receiving dock"
  }
}
```

### 2.5 PSP API Callbacks

#### 2.5.1 Status Update Callback

```http
PUT /v1/orders/ORD-2025-001234/status HTTP/1.1
Host: api.newpopsys.com
X-API-Key: vg_live_psp_key_abc123
Content-Type: application/json

{
  "status": "in_production",
  "statusDetails": "Printing complete, moving to finishing",
  "updatedAt": "2025-01-14T14:30:00Z",
  "completionPercentage": 60,
  "estimatedCompletion": "2025-01-15T12:00:00Z"
}
```

### 2.6 Error Handling


## 3. Shipping Carrier Integration

### 3.1 Supported Carriers


### 3.2 Carrier API Endpoints

#### 3.2.1 UPS Integration


#### 3.2.2 FedEx Integration


### 3.3 Tracking Integration

#### 3.3.1 Polling Configuration


#### 3.3.2 Tracking Event Mapping


#### 3.3.3 Sample Tracking Response Mapping

**UPS Tracking Response:**
```json
{
  "trackResponse": {
    "shipment": [
      {
        "inquiryNumber": "1Z999AA10123456784",
        "package": [
          {
            "trackingNumber": "1Z999AA10123456784",
            "activity": [
              {
                "status": {
                  "type": "D",
                  "description": "Delivered",
                  "code": "KB"
                },
                "date": "20250118",
                "time": "143000",
                "location": {
                  "city": "MILWAUKEE",
                  "stateProvince": "WI",
                  "postalCode": "53202",
                  "country": "US"
                }
              }
            ]
          }
        ]
      }
    ]
  }
}
```

**Mapped NewPOPSys Event:**
```json
{
  "shipmentId": "SHP-2025-001234",
  "trackingNumber": "1Z999AA10123456784",
  "carrier": "UPS",
  "status": "delivered",
  "eventTimestamp": "2025-01-18T14:30:00Z",
  "location": {
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US"
  },
  "signedBy": "J SMITH"
}
```

### 3.4 Label Generation

#### 3.4.1 Label Format Support


#### 3.4.2 Label Request Example

```json
{
  "carrier": "UPS",
  "service": "GROUND",
  "labelFormat": "PDF",
  "shipFrom": {
    "name": "PSP Fulfillment",
    "address1": "100 Industrial Way",
    "city": "Chicago",
    "state": "IL",
    "postalCode": "60601",
    "country": "US",
    "phone": "3125551234"
  },
  "shipTo": {
    "name": "Store Manager",
    "company": "Retail Store #1234",
    "address1": "500 Main Street",
    "city": "Milwaukee",
    "state": "WI",
    "postalCode": "53202",
    "country": "US",
    "phone": "4145556789"
  },
  "packages": [
    {
      "weight": {
        "value": 5.5,
        "unit": "LB"
      },
      "dimensions": {
        "length": 12,
        "width": 10,
        "height": 4,
        "unit": "IN"
      },
      "reference1": "ORD-2025-001234",
      "reference2": "STORE-1234"
    }
  ]
}
```

## 4. Brand ERP Integration

### 4.1 Supported ERP Systems


### 4.2 Integration Patterns

NewPOPSys sends event notifications to Brand ERP systems via webhooks. ERPs do not call back into NewPOPSys directly.

[Diagram - See rendered image above or refer to source document]

### 4.3 ERP Data Mapping

#### 4.3.1 Campaign to ERP Project


#### 4.3.2 Order to ERP Sales Order


### 4.4 Webhook Payload for ERP

```json
{
  "event": "order.shipped",
  "timestamp": "2025-01-15T09:00:00Z",
  "data": {
    "orderId": "ORD-2025-001234",
    "externalOrderId": "SO-12345",
    "campaignId": "CAMP-2025-Q1",
    "shippedAt": "2025-01-15T09:00:00Z",
    "carrier": "UPS",
    "trackingNumber": "1Z999AA10123456784",
    "trackingUrl": "https://ups.com/track?num=1Z999AA10123456784",
    "shipmentDetails": {
      "packageCount": 1,
      "totalWeight": {
        "value": 5.5,
        "unit": "LB"
      },
      "estimatedDelivery": "2025-01-18"
    },
    "financials": {
      "shippingCost": 15.99,
      "currency": "USD"
    }
  },
  "tenant": {
    "tenantId": "TNT-001",
    "brandName": "Acme Retail"
  }
}
```

## 5. Identity & SSO Integration

### 5.1 Supported Identity Providers


### 5.2 SAML 2.0 Configuration

#### 5.2.1 Service Provider Metadata


#### 5.2.2 Required SAML Assertions


#### 5.2.3 Group-to-Role Mapping


### 5.3 OIDC Configuration

#### 5.3.1 OpenID Connect Settings


#### 5.3.2 JWT Claims Mapping

```json
{
  "sub": "user-unique-id",
  "email": "user@company.com",
  "name": "John Doe",
  "given_name": "John",
  "family_name": "Doe",
  "groups": ["newpopsys-brand-managers"],
  "iss": "https://login.microsoftonline.com/{tenant-id}/v2.0",
  "aud": "{client-id}",
  "iat": 1705142400,
  "exp": 1705146000
}
```

### 5.4 Session Management


## 6. Payment Integration

### 6.1 Supported Payment Processors


### 6.2 Stripe Integration

#### 6.2.1 API Configuration


#### 6.2.2 Payment Intent Flow

[Diagram - See rendered image above or refer to source document]

#### 6.2.3 Webhook Events


## 7. Cloud Storage Integration

### 7.1 Supported Storage Providers


### 7.2 AWS S3 Configuration

#### 7.2.1 Bucket Structure


#### 7.2.2 Pre-signed URL Generation

```json
{
  "operation": "putObject",
  "bucket": "newpopsys-photos-prod",
  "key": "surveys/2025/01/RESP-001234/photo-001.jpg",
  "expiresIn": 3600,
  "conditions": {
    "content-type": "image/jpeg",
    "content-length-range": [1, 10485760]
  }
}
```

#### 7.2.3 CDN Configuration


## 8. Notification Services

### 8.1 Email (SendGrid)

#### 8.1.1 Configuration


#### 8.1.2 Email Templates


### 8.2 SMS (Twilio)

#### 8.2.1 Configuration


#### 8.2.2 SMS Use Cases


## 9. Error Handling & Retry

### 9.1 External API Error Handling


### 9.2 Retry Schedule

```
Attempt 1: Immediate
Attempt 2: 1 second delay
Attempt 3: 5 seconds delay
Attempt 4: 30 seconds delay
Attempt 5: 5 minutes delay
```

### 9.3 Circuit Breaker Configuration


## 10. Security Requirements

### 10.1 API Credential Storage


### 10.2 Data Encryption


### 10.3 Audit Logging

All external API calls are logged with:
- Timestamp
- Target system
- Operation type
- Request ID
- Response status
- Latency
- Error details (if any)

## 11. Monitoring & Alerting

### 11.1 Health Checks


### 11.2 Alert Thresholds


## 12. Related Documents


## Revision History


---
# 11.4 Webhooks

## Document Information


## 1. Introduction

### 1.1 Purpose
This document specifies the webhook system for NewPOPSys, enabling real-time event notifications to external systems including Brand ERPs, PSP MIS platforms, and custom integrations.

## 2. Event Types

### 2.1 Campaign Events


### 2.2 Task Events


### 2.3 Photo Events


### 2.4 Order Events


## 3. Payload Format

### 3.1 Standard Envelope
```json
{
  "id": "evt_abc123def456",
  "type": "campaign.created",
  "api_version": "2026-01-01",
  "created_at": "2026-01-01T12:00:00Z",
  "data": { "object": { } },
  "metadata": { "brand_id": "brand_123", "tenant_id": "tenant_456" }
}
```

## 4. Security

### 4.1 Signature Verification
All webhooks signed using HMAC-SHA256. Header: `X-POPSys-Signature`

### 4.2 Timestamp Validation
Reject requests where timestamp differs from server time by > 5 minutes.

## 5. Delivery & Retry


After 5 failed attempts: webhook disabled, admin notified, events queued 7 days.

## 6. Configuration Endpoints


## References
- [11.1 API Overview](11.1_API_Overview.md)
- [11.2 Internal APIs](11.2_Internal_APIs.md)
- [11.3 External Integrations](11.3_External_Integrations.md)


---
# 11 - API Specifications

API documentation for NewPOPSys.

## Contents


## JSON Schemas

Located in `schemas/` subfolder (extracted from OpenAPI spec)

## Source Documents

- `SOW/06_API/openapi.yaml`
- SUPP-021 (Integration Architecture)

*Section Status: Not Started*


---


---

# Section 12: Non-Functional Requirements
# 12.1 Performance Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Performance
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 12.1.1 Purpose

This section defines measurable performance requirements for NewPOPSys v1, including response time targets, throughput limits, and database query performance expectations. All requirements include specific targets and verification methods.

## 12.1.2 API Response Time Requirements

### 12.1.2.1 Response Time SLAs by Endpoint Category


### 12.1.2.2 Verification Methods


## 12.1.3 Throughput Requirements

### 12.1.3.1 System Throughput Targets


### 12.1.3.2 Concurrent User Capacity


### 12.1.3.3 Verification Methods


## 12.1.4 Database Performance Requirements

### 12.1.4.1 Query Performance Targets


### 12.1.4.2 Connection Pool Configuration


### 12.1.4.3 Verification Methods

- Query performance monitoring via `pg_stat_statements` extension
- Slow query logging for queries exceeding 100ms
- Explain plan analysis for all list/aggregation endpoints

## 12.1.5 Photo Processing Performance

### 12.1.5.1 Photo Pipeline Targets


### 12.1.5.2 Photo Size Limits


### 12.1.5.3 Verification Methods

- S3 upload timing instrumentation with OpenTelemetry
- Lambda CloudWatch metrics for processing duration
- CDN cache hit ratio monitoring via CloudFront analytics

## 12.1.6 Page Load Performance

### 12.1.6.1 Web Vitals Targets


### 12.1.6.2 PWA Performance (Mobile Store App)


### 12.1.6.3 Verification Methods

- Lighthouse CI integration in deployment pipeline
- Real User Monitoring (RUM) via Sentry Performance
- Synthetic monitoring for critical user journeys

## 12.1.7 Caching Strategy

### 12.1.7.1 Cache Layer Requirements


### 12.1.7.2 Cache Hit Ratio Targets


## 12.1.8 Background Job Performance

### 12.1.8.1 Job Processing Targets


### 12.1.8.2 Queue Depth Limits


## 12.1.9 Monitoring and Alerting

### 12.1.9.1 Performance Monitoring Requirements


### 12.1.9.2 Alert Thresholds


## 12.1.10 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Performance Requirements*


---
# 12.2 Security Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Security
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements), SUPP-003 (RBAC)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 12.2.1 Purpose

This section defines security requirements for NewPOPSys v1, covering authentication, authorization, data protection, compliance, and security operations. All requirements include specific implementation targets and verification methods.

## 12.2.2 Authentication Requirements

### 12.2.2.1 Primary Authentication


### 12.2.2.2 Multi-Factor Authentication


### 12.2.2.3 Password Policy


### 12.2.2.4 Account Lockout


### 12.2.2.5 Verification Methods

- Automated security testing for auth flows in CI/CD
- Penetration testing before launch
- Session hijacking prevention verification

## 12.2.3 Authorization Requirements

### 12.2.3.1 Role-Based Access Control (RBAC)


### 12.2.3.2 Tenant Isolation


### 12.2.3.3 API Authorization


### 12.2.3.4 Verification Methods

- Authorization bypass testing (horizontal and vertical)
- Automated RBAC matrix validation
- Tenant isolation penetration testing

## 12.2.4 Data Protection Requirements

### 12.2.4.1 Encryption at Rest


### 12.2.4.2 Encryption in Transit


### 12.2.4.3 Sensitive Data Handling


### 12.2.4.4 Verification Methods

- TLS certificate validation in monitoring
- Encryption verification via AWS Config rules
- Log audit for PII leakage

## 12.2.5 OWASP Top 10 Mitigation

### 12.2.5.1 Security Controls Matrix


### 12.2.5.2 Verification Methods

- OWASP ZAP automated scanning in CI/CD
- Manual penetration testing quarterly
- Dependency vulnerability scanning with Snyk/Dependabot

## 12.2.6 Audit Logging Requirements

### 12.2.6.1 Audit Event Categories


### 12.2.6.2 Audit Log Fields


### 12.2.6.3 Audit Log Protection


## 12.2.7 Security Operations

### 12.2.7.1 Vulnerability Management


### 12.2.7.2 Penetration Testing


### 12.2.7.3 Security Monitoring


## 12.2.8 Compliance Requirements

### 12.2.8.1 Regulatory Compliance


### 12.2.8.2 GDPR Specific Requirements


### 12.2.8.3 Verification Methods

- Compliance checklist review
- Third-party audit (for SOC 2)
- Privacy impact assessment

## 12.2.9 Incident Response

### 12.2.9.1 Security Incident Classification


### 12.2.9.2 Incident Response Requirements


## 12.2.10 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Security Requirements*


---
# 12.3 Accessibility Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Accessibility
> **Source Documents**: SUPP-038 (Section 508 Accessibility Scaffold)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 12.3.1 Purpose

This section defines accessibility requirements for NewPOPSys v1, ensuring the platform is usable by people with disabilities and compliant with federal accessibility mandates. The v1 release establishes foundational patterns enabling full WCAG 2.1 Level AA compliance in v1.1.

## 12.3.2 Compliance Targets

### 12.3.2.1 Accessibility Standards


### 12.3.2.2 Target Audience


## 12.3.3 Semantic HTML Requirements

### 12.3.3.1 Document Structure


### 12.3.3.2 Page Layout Template

```tsx
// Required page structure for all screens
<PageLayout>
  <header role="banner">...</header>
  <nav role="navigation">...</nav>
  <main role="main" id="main-content">...</main>
  <footer role="contentinfo">...</footer>
</PageLayout>
```

### 12.3.3.3 Verification Methods

- axe-core automated testing in CI/CD
- HTML validation via W3C validator
- Manual semantic structure review

## 12.3.4 Keyboard Navigation Requirements

### 12.3.4.1 Core Keyboard Requirements


### 12.3.4.2 Focus Indicator Standards


### 12.3.4.3 Keyboard Shortcuts (v1.1)


## 12.3.5 Form Accessibility Requirements

### 12.3.5.1 Form Field Requirements


### 12.3.5.2 Form Pattern Template

```tsx
<div>
  <label htmlFor="store-name" id="store-name-label">
    Store Name <span aria-hidden="true">*</span>
  </label>
  <input
    id="store-name"
    aria-labelledby="store-name-label"
    aria-describedby={error ? "store-name-error" : undefined}
    aria-required="true"
    aria-invalid={!!error}
  />
  {error && (
    <span id="store-name-error" role="alert">
      {error}
    </span>
  )}
</div>
```

### 12.3.5.3 Verification Methods

- Form association validation via axe-core
- Screen reader announcement testing
- Error message accessibility review

## 12.3.6 Color and Contrast Requirements

### 12.3.6.1 Contrast Ratio Requirements


### 12.3.6.2 Color Independence


### 12.3.6.3 Accessible Color Palette


### 12.3.6.4 Verification Methods

- Automated contrast checker in CI/CD
- Colorblind simulation testing
- Design review for color-only indicators

## 12.3.7 Interactive Component Patterns

### 12.3.7.1 ARIA Patterns by Component


### 12.3.7.2 Prohibited Patterns


## 12.3.8 Image and Media Requirements

### 12.3.8.1 Alternative Text


### 12.3.8.2 Media Alternatives


## 12.3.9 Mobile/PWA Accessibility

### 12.3.9.1 Touch Target Requirements


### 12.3.9.2 Responsive Accessibility


### 12.3.9.3 Motion Preference Pattern

```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

## 12.3.10 Screen Reader Support

### 12.3.10.1 v1 Screen Reader Compatibility


### 12.3.10.2 v1.1 Screen Reader Testing Matrix


## 12.3.11 Testing and Validation

### 12.3.11.1 Automated Testing Requirements


### 12.3.11.2 Manual Testing Requirements


### 12.3.11.3 CI/CD Gate

```yaml
- name: Accessibility Check
  run: |
    npx axe-core --tags wcag2a,wcag2aa
    # Fail on critical/serious issues
```

## 12.3.12 Documentation Requirements (v1.1)

### 12.3.12.1 Compliance Documentation


## 12.3.13 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Accessibility Requirements*


---
# 12.4 Scalability Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Scalability
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements), SUPP-012 (Technology Selections)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 12.4.1 Purpose

This section defines scalability requirements for NewPOPSys v1, covering horizontal and vertical scaling strategies, load balancing, caching, and capacity planning. Requirements ensure the platform can grow from pilot scale to enterprise deployments.

## 12.4.2 Scaling Targets

### 12.4.2.1 Capacity Milestones


### 12.4.2.2 Scaling Triggers


## 12.4.3 Horizontal Scaling

### 12.4.3.1 Application Layer Scaling


### 12.4.3.2 Auto-Scaling Configuration


### 12.4.3.3 Stateless Design Requirements


## 12.4.4 Vertical Scaling

### 12.4.4.1 Database Vertical Scaling Path


### 12.4.4.2 Container Sizing


## 12.4.5 Database Scaling Strategy

### 12.4.5.1 Read Replica Configuration


### 12.4.5.2 Connection Pooling


### 12.4.5.3 Query Optimization


## 12.4.6 Caching Strategy

### 12.4.6.1 Cache Layer Architecture


### 12.4.6.2 Cache Configuration


### 12.4.6.3 Redis Scaling


## 12.4.7 Load Balancing

### 12.4.7.1 Load Balancer Configuration


### 12.4.7.2 Routing Strategy


### 12.4.7.3 SSL/TLS Configuration


## 12.4.8 Storage Scaling

### 12.4.8.1 Object Storage (S3)


### 12.4.8.2 Storage Capacity Planning


## 12.4.9 Background Job Scaling

### 12.4.9.1 Queue Architecture


### 12.4.9.2 Job Scaling Strategy


## 12.4.10 CDN and Edge Caching

### 12.4.10.1 CloudFront Configuration


### 12.4.10.2 Cache Behavior Rules


## 12.4.11 Multi-Tenancy Scaling

### 12.4.11.1 Tenant Isolation


### 12.4.11.2 Tenant-Level Rate Limits


## 12.4.12 Verification and Testing

### 12.4.12.1 Load Testing Requirements


### 12.4.12.2 Scaling Verification


## 12.4.13 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Scalability Requirements*


---
# 12.5 Availability Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Availability
> **Source Documents**: SUPP-039 (Infrastructure, Performance & Security Requirements)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 12.5.1 Purpose

This section defines availability requirements for NewPOPSys v1, covering uptime SLAs, disaster recovery, failover mechanisms, backup strategies, and maintenance procedures. All requirements include specific targets and verification methods.

## 12.5.2 Uptime Requirements

### 12.5.2.1 Service Level Targets


### 12.5.2.2 Uptime Calculation


### 12.5.2.3 Availability by Component


## 12.5.3 High Availability Architecture

### 12.5.3.1 Multi-AZ Deployment


### 12.5.3.2 Load Balancer Configuration


### 12.5.3.3 Container Health Checks


## 12.5.4 Disaster Recovery

### 12.5.4.1 Recovery Objectives


### 12.5.4.2 Disaster Recovery Strategy


### 12.5.4.3 Cross-Region Replication (v1.1+)


## 12.5.5 Backup Strategy

### 12.5.5.1 Database Backup


### 12.5.5.2 Point-in-Time Recovery (PITR)


### 12.5.5.3 Object Storage Backup


### 12.5.5.4 Configuration Backup


## 12.5.6 Failover Mechanisms

### 12.5.6.1 Automatic Failover


### 12.5.6.2 Manual Failover Procedures


### 12.5.6.3 Verification Methods

- Quarterly failover drills (documented)
- Annual DR simulation
- Chaos engineering tests (v1.1+)

## 12.5.7 Maintenance Windows

### 12.5.7.1 Scheduled Maintenance


### 12.5.7.2 Zero-Downtime Deployment


### 12.5.7.3 Emergency Maintenance


## 12.5.8 Incident Response

### 12.5.8.1 Incident Severity Classification


### 12.5.8.2 On-Call Requirements


### 12.5.8.3 Runbook Requirements


## 12.5.9 Monitoring and Alerting

### 12.5.9.1 Availability Monitoring


### 12.5.9.2 Alert Channels


### 12.5.9.3 Status Communication


## 12.5.10 Graceful Degradation

### 12.5.10.1 Degradation Strategies


### 12.5.10.2 Circuit Breaker Patterns


## 12.5.11 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Availability Requirements*


---
# 12.6 Data Retention Requirements

> **IEEE 830 Reference**: Section 3.3 - Non-Functional Requirements: Data Retention
> **Source Documents**: SUPP-008 (Data Retention Classification Policy), SUPP-039 (Infrastructure Requirements)
> **Version**: 1.0
> **Last Updated**: 2026-01-01

## 12.6.1 Purpose

This section defines data retention requirements for NewPOPSys v1, covering data classification, retention periods, purge workflows, GDPR compliance, backup policies, and audit trail retention. The core principle is: **Delete heavy artifacts on a clock; keep lightweight accountability.**

## 12.6.2 Data Classification

### 12.6.2.1 Data Classes Overview


### 12.6.2.2 Storage Classification


## 12.6.3 Retention Periods

### 12.6.3.1 Class A: Campaign Proof Media


### 12.6.3.2 Class B: Campaign Records (Light)


### 12.6.3.3 Class C: Store Master Data


### 12.6.3.4 Class D: Reusable Definitions


### 12.6.3.5 Class E: Asset Registry


### 12.6.3.6 Class F: Exports


## 12.6.4 Purge Workflow

### 12.6.4.1 Automated Purge Process


### 12.6.4.2 Purge Job Configuration


### 12.6.4.3 Export Bundle Contents


## 12.6.5 GDPR Compliance

### 12.6.5.1 Data Subject Rights


### 12.6.5.2 Right to Erasure (RTBF) Workflow


### 12.6.5.3 Data Anonymization


### 12.6.5.4 GDPR Exceptions


## 12.6.6 Audit Trail Retention

### 12.6.6.1 Audit Log Types


### 12.6.6.2 Audit Log Protection


### 12.6.6.3 Audit Log Archival


## 12.6.7 Backup Retention

### 12.6.7.1 Database Backup Retention


### 12.6.7.2 Object Storage Retention


### 12.6.7.3 Configuration Backup


## 12.6.8 Tenant Data Lifecycle

### 12.6.8.1 Tenant Offboarding


### 12.6.8.2 Tenant Data Export (Takeout)


## 12.6.9 Storage Lifecycle Management

### 12.6.9.1 S3 Lifecycle Policies


### 12.6.9.2 Database Maintenance


## 12.6.10 Verification and Compliance

### 12.6.10.1 Retention Verification


### 12.6.10.2 Compliance Reporting


## 12.6.11 Cross-References


*Document Status: Complete*
*IEEE 830 Compliance: Section 3.3 - Data Retention Requirements*


---
# 12 - Non-Functional Requirements

Performance, security, and quality requirements.

## Contents


## Source Documents

- SUPP-038 (Security Requirements)
- SUPP-039 (Performance Requirements)

*Section Status: Not Started*


---


---

# Appendices
# Appendix A: State Machine Diagrams

## A.1 Overview

This appendix consolidates all state machine diagrams used throughout the NewPOPSys platform. These diagrams define the valid states, transitions, and triggers for key business entities.

### State Machine Categories


## A.2 Campaign Lifecycle States

The campaign progresses through a defined lifecycle from creation to archival.

### A.2.1 Campaign Status State Diagram

![99_Appendices_A_State_Machines_diagram_0](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_0.png)

### A.2.2 Campaign State Definitions


### A.2.3 Campaign Transition Triggers


## A.3 Store Assignment States

Tracks each store's progress through a campaign from assignment to completion.

### A.3.1 StoreAssignment Status State Diagram

![99_Appendices_A_State_Machines_diagram_1](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_1.png)

### A.3.2 StoreAssignment State Definitions


## A.4 Assignment Item States

Tracks individual kit items at a store through the fulfillment and execution lifecycle.

### A.4.1 AssignmentItem Status State Diagram

![99_Appendices_A_State_Machines_diagram_2](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_2.png)

### A.4.2 AssignmentItem State Definitions


## A.5 Fulfillment States

Tracks order and shipment progress from PSP perspective.

### A.5.1 FulfillmentStatus State Diagram (Computed)

![99_Appendices_A_State_Machines_diagram_3](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_3.png)

### A.5.2 FulfillmentStatus Computation Logic


## A.6 Photo Review States

Tracks individual photo review workflow.

### A.6.1 PhotoReview Status State Diagram

![99_Appendices_A_State_Machines_diagram_4](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_4.png)

### A.6.2 PhotoReview State Definitions


### A.6.3 Rejection Reason Codes


## A.7 Issue Request States

Tracks issue reporting, triage, and resolution workflow.

### A.7.1 IssueRequest Status State Diagram

![99_Appendices_A_State_Machines_diagram_5](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_5.png)

### A.7.2 IssueRequest State Definitions


### A.7.3 Issue Type Classifications


## A.8 Deinstall Task States

Tracks end-of-campaign material removal workflow.

### A.8.1 DeinstallTask Status State Diagram

![99_Appendices_A_State_Machines_diagram_6](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_6.png)

### A.8.2 DeinstallTask State Definitions


## A.9 Store Order States

Tracks PSP order processing workflow.

### A.9.1 StoreOrder Status State Diagram

![99_Appendices_A_State_Machines_diagram_7](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_7.png)

### A.9.2 StoreOrder State Definitions


## A.10 State Interrelationships

### A.10.1 Status Ownership by Module

![99_Appendices_A_State_Machines_diagram_8](./diagrams_rendered/99_Appendices_A_State_Machines_diagram_8.png)

### A.10.2 StorePhase Computation

The `StorePhase` is a computed rollup representing overall store progress:


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SOW Diagram Collection, SUPP-001, SUPP-002*


---
# Appendix B: Notification Matrix

## B.1 Overview

This appendix defines all system-generated notifications, their recipients, delivery methods, and trigger conditions. Notifications ensure timely communication across all user roles throughout the campaign lifecycle.

### Notification Channels


### Notification Priority Levels


## B.2 Campaign Lifecycle Notifications


## B.3 Store Assignment Notifications


## B.4 Fulfillment Notifications


## B.5 Issue & Reorder Notifications


## B.6 Photo Review & Verification Notifications


## B.7 User & Access Notifications


## B.8 Report & Export Notifications


## B.9 Escalation Notifications


## B.10 Deinstall Notifications


## B.11 Notification Preferences

### B.11.1 User-Configurable Preferences

Users can customize notification delivery for non-critical events:


### B.11.2 Non-Configurable (Mandatory) Notifications

The following notification types cannot be disabled:

- Password reset
- Account deactivation
- Critical escalations (SLA breach)
- Security alerts
- System maintenance

## B.12 Notification Templates

### B.12.1 Email Subject Line Patterns


### B.12.2 Push Notification Character Limits


## B.13 Webhook Events

For integration users, the following events trigger webhooks:


## B.14 Notification Delivery SLAs


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SOW Functional Requirements, SUPP-002*


---
# Appendix C: Export Formats

## C.1 Overview

This appendix defines the specifications for all data exports supported by the NewPOPSys platform. Exports enable offline analysis, integration with external systems, and archival of campaign data.

### Supported Export Formats


### Export Access by Role


## C.2 CSV Export Specifications

### C.2.1 General CSV Format


### C.2.2 Campaign Export (CSV)

**Filename Pattern:** `campaigns_{tenant}_{YYYYMMDD}.csv`


### C.2.3 Store Assignment Export (CSV)

**Filename Pattern:** `store_assignments_{campaign_id}_{YYYYMMDD}.csv`


### C.2.4 Order Export (CSV)

**Filename Pattern:** `orders_{campaign_id}_{YYYYMMDD}.csv`


### C.2.5 Issue Export (CSV)

**Filename Pattern:** `issues_{campaign_id}_{YYYYMMDD}.csv`


## C.3 Excel Export Specifications

### C.3.1 General Excel Format


### C.3.2 Campaign Summary Report (XLSX)

**Filename Pattern:** `campaign_report_{campaign_name}_{YYYYMMDD}.xlsx`

**Sheet 1: Summary**


**Sheet 2: Store Details**

Full store assignment data with conditional formatting:
- Green: Complete stores
- Yellow: In progress
- Red: Overdue/Exception

**Sheet 3: Item Breakdown**

Kit item summary with quantities:
- Ordered vs Shipped vs Delivered vs Installed

**Sheet 4: Issues**

All issues with status and resolution

**Sheet 5: Timeline**

Daily progress chart data

### C.3.3 Compliance Report (XLSX)

**Filename Pattern:** `compliance_report_{campaign_name}_{YYYYMMDD}.xlsx`

**Sheet 1: Executive Summary**
- Overall compliance rate
- Regional breakdown
- Risk highlights

**Sheet 2: Store Compliance**


**Sheet 3: Non-Compliant Stores**

Filtered list of non-compliant stores with:
- Missing items detail
- Pending retakes
- Open issues
- Last activity date

**Sheet 4: Waiver Log**

All waived items with justification

## C.4 PDF Report Specifications

### C.4.1 General PDF Format


### C.4.2 Campaign Completion Certificate (PDF)

**Purpose:** Official documentation of successful campaign completion at a store.

**Template Structure:**

![Export Format](./screenshots/Appendices/export_format.png)

### C.4.3 Photo Proof Report (PDF)

**Purpose:** Visual documentation of installed materials with approval status.

**Template Structure:**

- Page 1: Cover page with campaign and store info
- Pages 2-N: Photo grid (2x2 per page)
  - Photo thumbnail (300x300px)
  - Item name
  - Location slot
  - Status (Approved/Rejected)
  - Reviewer notes
  - Timestamp

### C.4.4 Executive Summary Report (PDF)

**Purpose:** High-level campaign performance for stakeholders.

**Sections:**

1. **Cover Page**
   - Campaign name, brand, date range
   - Report generated date

2. **KPI Dashboard** (1 page)
   - Total stores / Complete / In Progress
   - Completion rate gauge chart
   - Issue rate
   - Photo approval rate

3. **Regional Breakdown** (1 page)
   - Bar chart by region
   - Top/bottom performers

4. **Timeline** (1 page)
   - Cumulative completion curve
   - Daily submission rates

5. **Issues Summary** (1 page)
   - Issue counts by type
   - Resolution rates

6. **Appendix** (as needed)
   - Detailed store list

## C.5 JSON Export Specifications

### C.5.1 General JSON Format


### C.5.2 Standard JSON Wrapper

```json
{
  "export": {
    "type": "campaign_data",
    "version": "1.0",
    "generated_at": "2026-01-01T12:00:00Z",
    "generated_by": "user@example.com",
    "tenant_id": "01ABC...",
    "filters": {
      "campaign_id": "01DEF...",
      "date_from": "2026-01-01",
      "date_to": "2026-01-31"
    },
    "record_count": 150,
    "page": 1,
    "total_pages": 1
  },
  "data": [
    { ... },
    { ... }
  ]
}
```

### C.5.3 Campaign Object (JSON)

```json
{
  "id": "01HXYZ...",
  "name": "Summer 2026 Promo",
  "brand": {
    "id": "01HABC...",
    "name": "Brand Co"
  },
  "type": "PROMOTIONAL",
  "status": "PUBLISHED",
  "dates": {
    "start": "2026-06-01",
    "end": "2026-08-31"
  },
  "kit": {
    "id": "01HKIT...",
    "item_count": 5,
    "items": [
      {
        "id": "01HITM...",
        "sku": "WC-24x36-001",
        "name": "Window Cling 24x36",
        "quantity": 2
      }
    ]
  },
  "rollup": {
    "stores_total": 500,
    "stores_complete": 425,
    "stores_in_progress": 50,
    "stores_not_started": 25,
    "completion_rate": 85.0
  },
  "metadata": {
    "created_at": "2026-05-01T10:00:00Z",
    "created_by": "admin@example.com",
    "published_at": "2026-05-15T09:00:00Z"
  }
}
```

### C.5.4 Store Assignment Object (JSON)

```json
{
  "id": "01HASG...",
  "campaign_id": "01HXYZ...",
  "store": {
    "id": "01HSTR...",
    "number": "1234",
    "name": "Downtown Location",
    "address": {
      "street": "123 Main St",
      "city": "Anytown",
      "state": "CA",
      "postal_code": "90210",
      "country": "US"
    },
    "geography": {
      "region": "West",
      "district": "SoCal",
      "territory": "LA Metro"
    }
  },
  "status": "COMPLETE",
  "phase": "COMPLETE",
  "items": {
    "total": 5,
    "received": 5,
    "installed": 5,
    "satisfied": 5
  },
  "photos": {
    "required": 5,
    "submitted": 6,
    "approved": 5,
    "rejected": 1
  },
  "issues": {
    "total": 1,
    "open": 0,
    "resolved": 1
  },
  "timeline": {
    "assigned_at": "2026-06-01T00:00:00Z",
    "ready_at": "2026-06-05T14:30:00Z",
    "started_at": "2026-06-06T10:00:00Z",
    "submitted_at": "2026-06-06T16:00:00Z",
    "completed_at": "2026-06-07T09:30:00Z"
  }
}
```

## C.6 Data Export Schemas

### C.6.1 Available Export Endpoints


### C.6.2 Export Request Parameters


### C.6.3 Export Response

```json
{
  "export_id": "01HEXP...",
  "status": "PROCESSING",
  "progress": 45,
  "estimated_completion": "2026-01-01T12:05:00Z",
  "download_url": null,
  "expires_at": null
}
```

When complete:

```json
{
  "export_id": "01HEXP...",
  "status": "COMPLETE",
  "progress": 100,
  "completed_at": "2026-01-01T12:03:00Z",
  "download_url": "https://cdn.example.com/exports/01HEXP....csv",
  "expires_at": "2026-01-02T12:03:00Z",
  "file_size_bytes": 1048576,
  "record_count": 5000
}
```

## C.7 Photo Export Specifications

### C.7.1 Photo Metadata Export (CSV/JSON)

Photos are exported as metadata with signed URLs (not embedded images).


### C.7.2 Photo Archive Export (ZIP)

For bulk photo download, a ZIP archive is generated:

**Structure:**
![Export Format](./screenshots/Appendices/export_format.png)

**Manifest.json:**
```json
{
  "campaign_id": "01HXYZ...",
  "export_date": "2026-01-01",
  "total_photos": 2500,
  "total_size_mb": 1250,
  "stores": [
    {
      "store_number": "1234",
      "photo_count": 5,
      "files": [
        {
          "filename": "item_ABC_slot_1.jpg",
          "item_sku": "WC-24x36-001",
          "status": "APPROVED"
        }
      ]
    }
  ]
}
```

## C.8 Scheduled Exports

### C.8.1 Schedule Configuration


### C.8.2 Delivery Options


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SOW Functional Requirements, SUPP-002*


---
# Appendix D: Glossary

## D.1 Abbreviations and Acronyms


## D.2 Domain Terminology

### D.2.1 Core Business Entities


### D.2.2 Campaign Types


### D.2.3 Geographic Hierarchy


### D.2.4 Survey and Layout


### D.2.5 Fulfillment Terms


### D.2.6 Execution and Verification


### D.2.7 Issue Management


### D.2.8 Workflow Terms


### D.2.9 Technical Terms


### D.2.10 Verification Modes


## D.3 User Roles (Personas)

### D.3.1 PSP Level Roles


### D.3.2 Brand Level Roles


### D.3.3 Store Level Roles


### D.3.4 System Level Roles

## D.4 Status Values

### D.4.1 Campaign Status


### D.4.2 Store Assignment Status


### D.4.3 Photo Review Status


### D.4.4 Issue Status


## D.5 Industry Terms


*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SRS 1.3 Definitions, SUPP-001, Domain Expert Interviews*


---
# Appendix E: Change Log

## E.1 Overview

This appendix maintains a chronological record of all changes to the Software Requirements Specification (SRS) document. All modifications, additions, and deletions are tracked with version numbers, dates, authors, and descriptions.

### Version Numbering Convention


## E.2 Change History

## E.3 Detailed Change Records

### Version 1.0 - Initial Release (2026-01-01)

**Summary**: Complete initial Software Requirements Specification for NewPOPSys platform.

#### Sections Delivered


#### Key Features Specified

1. **Multi-Tenant Architecture**
   - PSP tenant isolation with Row-Level Security
   - Brand hierarchy with geographic organization
   - Store-level execution tracking

2. **Campaign Management**
   - Full campaign lifecycle (Draft  Published  Completed  Archived)
   - Kit definition with photo requirements
   - Store assignment and targeting

3. **Fulfillment Workflow**
   - Order generation and tracking
   - Shipment management with carrier integration
   - Issue reporting and reorder processing

4. **Execution & Verification**
   - Receipt verification workflow
   - Installation photo capture
   - Review and approval process
   - Retake request handling

5. **Integration Architecture**
   - RESTful API design
   - Webhook event system
   - External carrier integrations
   - S3 file storage

## E.4 Pending Changes


## E.5 Review and Approval

### Version 1.0 Approval


## E.6 Change Request Template

For future change requests, use the following template:

```markdown
### Change Request: [CR-XXX]

**Date Submitted**: YYYY-MM-DD
**Submitted By**: [Name]
**Priority**: [Critical | High | Medium | Low]

#### Description
[Detailed description of the proposed change]

#### Justification
[Business or technical reason for the change]

#### Sections Affected
- [ ] Section X.X - Description
- [ ] Section Y.Y - Description

#### Impact Assessment
- **Scope Impact**: [None | Minor | Moderate | Major]
- **Schedule Impact**: [None | Minor | Moderate | Major]
- **Resource Impact**: [None | Minor | Moderate | Major]

#### Approval
- [ ] Product Owner Approval
- [ ] Technical Lead Approval
- [ ] Stakeholder Notification

#### Implementation Notes
[Any technical notes for implementing the change]
```

## E.7 Document Governance

### Review Schedule


### Change Control Process

1. **Request**: Submit change request using template
2. **Review**: Technical lead reviews for feasibility
3. **Approve**: Product owner approves priority and scope
4. **Implement**: Author updates relevant sections
5. **Verify**: QA reviews changes for consistency
6. **Publish**: Updated version released with change log entry

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Maintained By: SRS Documentation Team*


---
# 99 - Appendices

Supporting materials and reference documents.

## Contents


## Source Documents

- State diagrams from `SOW/05_Wireframes/diagrams/`
- Notification rules from screen specs

*Section Status: Not Started*


---


---

**End of Document - NewPOPSys SRS v1.38**
