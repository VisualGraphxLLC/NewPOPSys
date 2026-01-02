# SRS Document Generation Plan for NewPOPSys

## Status: READY FOR EXECUTION

> **Reference**: Ninja v2 SRSv1.0.docx successfully extracted and analyzed.
> Structure follows IEEE 830 standard + Ninja SRS patterns (109+ functional requirements).

---

## 1. Project Context

| Field | Value |
|-------|-------|
| **System** | NewPOPSys v1.38 - PSP-led POP Campaign Orchestration Platform |
| **Documentation** | 220+ files (39 SUPPs, 25 screen specs, 16 database files) |
| **Diagram Format** | Mermaid |
| **Output Format** | Modular Markdown |
| **SRS Location** | `E:\Docker\PopSystem\SOW\07_SRS\` (renamed from 07_Dev_Plan) |
| **Goal** | Create SRS folder structure and generation plan (superstructure only) |

---

## 2. SRS Folder Structure

```
E:\Docker\PopSystem\SOW\07_SRS\
│
├── 00_Meta/
│   ├── SRS_MASTER_PLAN.md              # This plan (copied from claude plans)
│   ├── AGENT_MEMORY_LOG.md             # Sub-agent task tracking
│   ├── PROGRESS_TRACKER.md             # Section completion status
│   └── SOURCE_MAPPING.md               # SOW file → SRS section mapping
│
├── 01_Introduction/
│   ├── 1.1_Purpose.md
│   ├── 1.2_Scope.md
│   ├── 1.3_Definitions_Acronyms.md
│   ├── 1.4_References.md
│   └── 1.5_Document_Overview.md
│
├── 02_Overall_Description/
│   ├── 2.1_Product_Perspective.md      # System context diagram
│   ├── 2.2_Product_Functions.md        # High-level capability summary
│   ├── 2.3_User_Classes.md             # 9 personas overview
│   ├── 2.4_Operating_Environment.md
│   ├── 2.5_Constraints.md
│   ├── 2.6_Assumptions_Dependencies.md
│   └── diagrams/
│       └── system_context.mmd
│
├── 03_System_Architecture/
│   ├── 3.1_Database_Model.md           # ERD + table definitions
│   ├── 3.2_Application_Architecture.md # Component diagram
│   ├── 3.3_Technology_Stack.md         # From SUPP-012
│   ├── 3.4_Integration_Architecture.md # External systems
│   └── diagrams/
│       ├── erd_core.mmd
│       ├── erd_campaigns.mmd
│       ├── erd_execution.mmd
│       └── component_architecture.mmd
│
├── 04_User_Personas_RBAC/
│   ├── 4.1_Persona_Matrix.md           # All 9 personas with goals
│   ├── 4.2_Permission_Matrix.md        # RBAC grid (persona × feature)
│   ├── 4.3_Authentication_Flows.md     # Login, SSO, session
│   └── personas/
│       ├── PSP_Campaign_Manager.md
│       ├── PSP_Field_Operations.md
│       ├── Brand_Marketing_Manager.md
│       ├── Brand_Regional_Manager.md
│       ├── Store_Manager.md
│       ├── Store_Staff.md
│       ├── Platform_Admin.md
│       ├── Platform_Support.md
│       └── System_Integration.md
│
├── 05_Module_SharedFoundations/        # L-series screens
│   ├── 5.0_Module_Overview.md
│   └── screens/
│       ├── L001_Login.md
│       ├── L002_Dashboard.md
│       └── ...
│
├── 06_Module_MobilePWA/                # M-series (8 screens)
│   ├── 6.0_Module_Overview.md
│   └── screens/
│       ├── M001_Store_Dashboard.md
│       ├── M002_Campaign_List.md
│       └── ...
│
├── 07_Module_BrandAdmin/               # B-series (7 screens)
│   ├── 7.0_Module_Overview.md
│   └── screens/
│       ├── B001_Brand_Dashboard.md
│       └── ...
│
├── 08_Module_PSPOperations/            # P-series (3 screens)
│   ├── 8.0_Module_Overview.md
│   └── screens/
│       └── ...
│
├── 09_Module_StorePortal/              # S-series (5 screens)
│   ├── 9.0_Module_Overview.md
│   └── screens/
│       └── ...
│
├── 10_Module_PlatformAdmin/            # Admin screens
│   ├── 10.0_Module_Overview.md
│   └── screens/
│       └── ...
│
├── 11_API_Specifications/
│   ├── 11.1_API_Overview.md
│   ├── 11.2_Internal_APIs.md           # RESTful endpoints
│   ├── 11.3_External_Integrations.md   # Third-party APIs
│   ├── 11.4_Webhooks.md
│   └── schemas/
│       └── (JSON schemas)
│
├── 12_Non_Functional_Requirements/
│   ├── 12.1_Performance.md
│   ├── 12.2_Security.md
│   ├── 12.3_Accessibility.md
│   ├── 12.4_Scalability.md
│   ├── 12.5_Availability.md
│   └── 12.6_Data_Retention.md
│
└── 99_Appendices/
    ├── A_State_Machines.md             # Campaign, Task, Compliance states
    ├── B_Notification_Matrix.md        # Who gets notified when
    ├── C_Export_Formats.md             # Report/export specifications
    ├── D_Glossary.md
    └── E_Change_Log.md
```

---

## 3. Screen Specification Template

Each screen document follows this structure:

```markdown
# [Screen ID]: [Screen Name]

## 1. Overview
| Field | Value |
|-------|-------|
| **Screen ID** | [M001, B002, etc.] |
| **Module** | [Mobile PWA, Brand Admin, etc.] |
| **Primary Persona** | [Who primarily uses this] |
| **SOW Reference** | [Link to source screen spec] |

## 2. Wireframe
![Screen Name](../../../05_Wireframes/screenshots/[filename].png)
> Source: [Link to Axure/original wireframe]

## 3. Screen Description
[2-3 paragraph functional description]

## 4. User Access (RBAC)
| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| PSP Campaign Manager | ✓ | View, Edit, Delete | Full access |
| Store Manager | ✓ | View Only | Read-only |
| Store Staff | ✗ | - | No access |

## 5. Data Model
### Primary Entities
- **[Entity Name]** - [Brief description]
  - Key fields: field1, field2, field3

### Relationships
` ` `mermaid
erDiagram
    CAMPAIGN ||--o{ TASK : contains
    TASK }o--|| STORE : assigned_to
` ` `

## 6. APIs

### Internal APIs
| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/[resource] | GET | List items |
| /api/v1/[resource]/{id} | PUT | Update item |

### External Integrations
| System | Purpose | Data Flow |
|--------|---------|-----------|
| [External System] | [Purpose] | Inbound/Outbound |

## 7. Business Rules
- BR-001: [Business rule description]
- BR-002: [Business rule description]

## 8. State Transitions (if applicable)
` ` `mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Active : Publish
    Active --> Completed : All tasks done
` ` `

## 9. Acceptance Criteria
- [ ] AC-001: [Criterion]
- [ ] AC-002: [Criterion]
```

---

## 4. Agent Memory Logging System

### AGENT_MEMORY_LOG.md Format
```markdown
# Agent Memory Log

## Session: YYYY-MM-DD HH:MM

### Task #[N]
| Field | Value |
|-------|-------|
| **Agent Type** | Explore / Plan / General |
| **Agent ID** | [ID for resume] |
| **Task** | [Description] |
| **Status** | Complete / In-Progress / Blocked |

**Files Examined:**
- path/to/file1.md
- path/to/file2.md

**Key Findings:**
- Finding 1
- Finding 2

**Outputs Created:**
- path/to/output.md

**Next Steps:**
- [If any]

---
```

### PROGRESS_TRACKER.md Format
```markdown
# SRS Generation Progress

| Section | Files | Status | Agent ID | Last Updated |
|---------|-------|--------|----------|--------------|
| 01_Introduction | 5 | Not Started | - | - |
| 02_Overall_Description | 7 | Not Started | - | - |
| 03_System_Architecture | 5 | Not Started | - | - |
| 04_User_Personas_RBAC | 12 | Not Started | - | - |
| 05_Module_SharedFoundations | TBD | Not Started | - | - |
| 06_Module_MobilePWA | 9 | Not Started | - | - |
| 07_Module_BrandAdmin | 8 | Not Started | - | - |
| 08_Module_PSPOperations | 4 | Not Started | - | - |
| 09_Module_StorePortal | 6 | Not Started | - | - |
| 10_Module_PlatformAdmin | TBD | Not Started | - | - |
| 11_API_Specifications | 5 | Not Started | - | - |
| 12_Non_Functional_Requirements | 6 | Not Started | - | - |
| 99_Appendices | 5 | Not Started | - | - |
```

---

## 5. SRS Generation Workflow

### Phase 1: Setup
- [x] Rename 07_Dev_Plan to 07_SRS
- [x] Create 00_Meta/ folder
- [x] Copy this plan to SRS_MASTER_PLAN.md
- [ ] Initialize tracking files (AGENT_MEMORY_LOG.md, PROGRESS_TRACKER.md, SOURCE_MAPPING.md)
- [ ] Create SRS folder structure per Section 2

### Phase 2: Foundation Research
- [ ] Extract database model from 06_Database_Model/ (16 files)
- [ ] Extract tech stack from SUPP-012
- [ ] Map all 81 interfaces to modules (from 06_Screen_Specs/)
- [ ] Compile persona/RBAC from SUPP-001, SUPP-003

### Phase 3: Architecture Section
- [ ] Generate Mermaid ERD diagrams from DDL files
- [ ] Create application architecture diagram
- [ ] Document technology selections
- [ ] Create integration architecture diagram

### Phase 4: Module-by-Module Generation
For each of 6 modules, using screen template from Section 3:
- [ ] Module overview with navigation flow diagram
- [ ] Screen-by-screen documentation:
  - Reference wireframe screenshot (link to 05_Wireframes/)
  - Write screen description
  - Map personas with permissions (RBAC table)
  - Link data models (Mermaid ERD snippet)
  - Document APIs (internal + external)

**Module Order** (by dependency):
1. Shared Foundations (L-series) - Login, Dashboard, common components
2. Mobile PWA / Store Execution (M-series - 8 screens)
3. Brand Admin (B-series - 7 screens)
4. PSP Operations (P-series - 3 screens)
5. Store Portal (S-series - 5 screens)
6. Platform Admin (supporting screens)

### Phase 5: Cross-Cutting Sections
- [ ] API specifications (from openapi.yaml)
- [ ] Non-functional requirements (from SUPP-038, SUPP-039)
- [ ] Appendices (state machines from 05_Wireframes/diagrams/)

### Phase 6: Assembly & Review
- [ ] Cross-reference validation (links, IDs)
- [ ] Gap identification report
- [ ] Update PROGRESS_TRACKER.md

---

## 6. Source Document Mapping

| SRS Section | Source Documents |
|-------------|------------------|
| Introduction | README.md, MASTER_SOW_COMPILED.md |
| Database Model | 06_Database_Model/* (16 files) |
| App Architecture | SUPP-012, SUPP-021 |
| Personas/RBAC | SUPP-001, SUPP-003 |
| Screen Specs | 06_Screen_Specs/* (25 files) |
| Wireframes | 05_Wireframes/*, 07_SRS/screenshots/* |
| APIs | 06_API/openapi.yaml |
| State Machines | 05_Wireframes/diagrams/* |
| NFRs | SUPP-038, SUPP-039 |

---

## 7. Questions Resolved

| Question | Resolution |
|----------|------------|
| **Example SRS Access** | Ninja v2 SRSv1.0.docx extracted to `SOW\03_Templates\ninja_docx_extracted\` (278 images, 9.2MB XML). Structure validated with 109+ functional requirements. |
| **Diagram Format** | **Mermaid** - user confirmed |
| **Output Format** | **Modular Markdown** - user confirmed |
| **Wireframe Handling** | Reference existing screenshots via relative links (no duplication) |
| **Plan Storage** | Saved to `E:\Docker\PopSystem\SOW\07_SRS\00_Meta\SRS_MASTER_PLAN.md` |

---

## 8. Implementation Steps (Upon Approval)

Upon user approval of this plan:

1. **Create folder structure** - All 13 top-level directories from Section 2
2. **Initialize 00_Meta/** - Create tracking files
3. **Create placeholder READMEs** - One per module folder explaining contents
4. **Begin Phase 2** - Foundation research with sub-agents

**Estimated Files to Create**: ~80-100 markdown files across all sections

---

## 9. Design Resources (External)

| Resource | Link |
|----------|------|
| Axure Wireframe | https://qvcdv1.axshare.com/ |
| Adobe XD UI Standards | https://xd.adobe.com/view/a639299d-04e9-4f4c-bb70-c89b0d5c8cee-f36a/ |
| Confluence Mind Map | https://servrx.atlassian.net/wiki/spaces/~5f07510d108462001583d6de/pages/14450692/Mind+Maps |

---

## 10. Kickoff Prompt (Fresh Context)

Copy and paste the following prompt to start SRS generation in a new context window:

---

```
# SRS Generation Kickoff - NewPOPSys v1.38

## Task
Execute the SRS generation plan located at:
`E:\Docker\PopSystem\SOW\07_SRS\00_Meta\SRS_MASTER_PLAN.md`

## Context
- **System**: NewPOPSys v1.38 - PSP-led POP Campaign Orchestration Platform
- **SOW Documentation**: 220+ files in `E:\Docker\PopSystem\SOW\`
- **Reference SRS**: Ninja v2 SRSv1.0.docx extracted to `SOW\03_Templates\ninja_docx_extracted\` (109+ functional requirements, IEEE 830)

## Immediate Actions (Phase 1 - Setup)
1. Read the master plan at `07_SRS\00_Meta\SRS_MASTER_PLAN.md`
2. Create the SRS folder structure per Section 2 of the plan
3. Initialize tracking files in `07_SRS\00_Meta\`:
   - `AGENT_MEMORY_LOG.md` - Log each sub-agent task
   - `PROGRESS_TRACKER.md` - Track section completion
   - `SOURCE_MAPPING.md` - Map SOW files to SRS sections
4. Create placeholder README.md files in each module folder

## Key Source Locations
| Content | Location |
|---------|----------|
| SUPP documents (39) | `SOW\02_Supporting_Documents\` |
| Screen specs (25) | `SOW\06_Screen_Specs\` |
| Database model (16 files) | `SOW\06_Database_Model\` |
| Wireframe screenshots | `SOW\05_Wireframes\` |
| API spec | `SOW\06_API\openapi.yaml` |
| Personas/RBAC | `SUPP-001`, `SUPP-003` |
| Tech stack | `SUPP-012` |
| Reference SRS | `SOW\03_Templates\ninja_docx_extracted\` |

## Output Requirements
- **Diagram format**: Mermaid
- **Document format**: Modular Markdown
- **Wireframes**: Reference existing screenshots via relative links (no duplication)

## Agent Memory Protocol
After completing each significant task, update `AGENT_MEMORY_LOG.md` with:
- Agent type and ID (for resume capability)
- Files examined
- Key findings
- Outputs created
- Next steps

Begin with Phase 1 Setup tasks.
```

---

*Plan Version: 1.2 - Ready for Execution*
*Last Updated: 2026-01-01*
*Based on: IEEE 830 Standard + Agentic SOW Template patterns*
