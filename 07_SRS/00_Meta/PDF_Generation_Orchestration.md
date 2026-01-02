# PDF Generation Orchestration Prompt

> **Purpose**: Complete PDF generation workflow for CIO submission
> **Prerequisites**: Phase 1 Analysis & Phase 2.1 Remediation complete
> **Target Output**: NewPOPSys_SRS_v1.38.pdf

---

## Invocation

```
/orchestrator

Execute PDF Generation Orchestration from SOW/07_SRS/00_Meta/PDF_Generation_Orchestration.md
Complete all phases sequentially.
Target: CIO-ready PDF package.
```

---

## Phase 2: Remaining Remediation Tasks

### Task 2.2: Create Executive Summary

```
DISPATCH writer-agent:
"Create SOW/07_SRS/00_Executive_Summary.md

Include these sections:

1. **Document Information Block**
   - Document: NewPOPSys Software Requirements Specification
   - Version: 1.38
   - Date: 2026-01-01
   - Classification: Internal - Confidential

2. **Project Overview** (1 paragraph)
   - NewPOPSys is a multi-tenant POP (Point of Purchase) campaign management platform
   - Enables brands to create, distribute, and verify in-store marketing materials
   - Integrates with Print Service Providers (PSPs) for production workflow

3. **Key Deliverables Table**
   | Deliverable | Description | Status |
   |-------------|-------------|--------|
   | Mobile PWA | Store operator app for surveys & photo capture | Specified |
   | Brand Admin Portal | Campaign creation & management | Specified |
   | PSP Operations Console | Production queue & fulfillment | Specified |
   | Store Portal | Regional/store management dashboard | Specified |
   | Platform Admin | Multi-tenant administration | Specified |
   | Integration APIs | REST/GraphQL endpoints | Specified |

4. **Scope Summary**
   - 6 application modules
   - 35+ screen specifications
   - 9 user personas with RBAC
   - 4 external integrations

5. **Technology Stack Summary**
   - Frontend: React/Next.js PWA
   - Backend: Node.js/NestJS
   - Database: PostgreSQL
   - Infrastructure: AWS/Kubernetes

6. **Risk Summary (Top 5)**
   | Risk | Impact | Mitigation |
   |------|--------|------------|
   | PSP Integration Delays | High | Early API prototyping |
   | Mobile Offline Sync | Medium | Progressive enhancement |
   | Multi-tenant Data Isolation | High | Row-level security |
   | Photo Storage Scaling | Medium | CDN + compression |
   | RBAC Complexity | Medium | Permission matrix validation |

7. **Approval Block**
   ```
   APPROVED BY:

   _________________________    _______________
   [Name], CIO                  Date

   _________________________    _______________
   [Name], VP Engineering       Date

   _________________________    _______________
   [Name], Product Owner        Date
   ```

Format for executive readability with bullet points and tables.
Save to memory with tags: ['popsys', 'srs', 'executive-summary', 'document']
Confirm in under 10 lines."
```

---

### Task 2.3: Create Table of Contents

```
DISPATCH writer-agent:
"Create SOW/07_SRS/00_Table_of_Contents.md

Generate hierarchical TOC with markdown links:

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
- Persona Profiles (9 personas)

## Section 5: Module - Shared Foundations
- [Module Overview](./05_Module_SharedFoundations/01_Module_Overview.md)
- [L001 Universal Login](./05_Module_SharedFoundations/screens/L001_Universal_Login.md)
- [L002 Universal Dashboard](./05_Module_SharedFoundations/screens/L002_Universal_Dashboard.md)

## Section 6: Module - Mobile PWA
- [Module Overview](./06_Module_MobilePWA/01_Module_Overview.md)
- Screen Specifications (M001-M008)

## Section 7: Module - Brand Admin
- [Module Overview](./07_Module_BrandAdmin/01_Module_Overview.md)
- Screen Specifications (B001-B007)

## Section 8: Module - PSP Operations
- [Module Overview](./08_Module_PSPOperations/01_Module_Overview.md)
- Screen Specifications (P001-P003)

## Section 9: Module - Store Portal
- [Module Overview](./09_Module_StorePortal/01_Module_Overview.md)
- Screen Specifications (S001-S005)

## Section 10: Module - Platform Admin
- [Module Overview](./10_Module_PlatformAdmin/01_Module_Overview.md)
- Screen Specifications (A001-A006)

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

Save to memory with tags: ['popsys', 'srs', 'toc', 'document']
Confirm in under 10 lines."
```

---

## Phase 3: PDF Compilation

### Task 3.1: Create Compilation Script

```
DISPATCH executor-agent:
"Create SOW/07_SRS/scripts/compile_srs.ps1

PowerShell script that:
1. Sets output file: COMPILED_SRS.md
2. Adds cover page with title, version, date
3. Concatenates files in order:
   - 00_Executive_Summary.md
   - 00_Table_of_Contents.md
   - All 01_Introduction/*.md files
   - All 02_Overall_Description/*.md files
   - All 03_System_Architecture/*.md files
   - All 04_User_Personas_RBAC/*.md files
   - All module sections (05-10) with overviews first, then screens
   - All 11_API_Specifications/*.md files
   - All 12_Non_Functional_Requirements/*.md files
   - All 99_Appendices/*.md files
4. Adds page break markers between major sections: ---\n\n<div style='page-break-after: always;'></div>\n\n---
5. Adds footer with document info on each section

Script should be runnable from SOW/07_SRS/ directory.
Confirm in under 15 lines."
```

### Task 3.2: Execute Compilation

```
DISPATCH executor-agent:
"Run the compilation script:
cd SOW/07_SRS && powershell -File scripts/compile_srs.ps1

Verify output file COMPILED_SRS.md exists and has content.
Report: (1) File created, (2) Approximate line count, (3) Any errors.
Confirm in under 15 lines."
```

### Task 3.3: Convert to PDF

```
DISPATCH executor-agent:
"Convert COMPILED_SRS.md to PDF.

Option A - If pandoc available:
pandoc COMPILED_SRS.md -o NewPOPSys_SRS_v1.38.pdf --pdf-engine=wkhtmltopdf --toc --toc-depth=3 -V geometry:margin=1in

Option B - If markdown-pdf available:
npx markdown-pdf COMPILED_SRS.md -o NewPOPSys_SRS_v1.38.pdf

Option C - Create print-ready HTML:
pandoc COMPILED_SRS.md -o NewPOPSys_SRS_v1.38.html --standalone --toc
(User can print to PDF from browser)

Try options in order. Report which method succeeded.
Output: SOW/07_SRS/NewPOPSys_SRS_v1.38.pdf (or .html)
Confirm in under 15 lines."
```

---

## Phase 4: Validation

### Task 4.1: Validate Output

```
DISPATCH analyzer-agent:
"Verify generated output file:
- Check SOW/07_SRS/NewPOPSys_SRS_v1.38.pdf exists (or .html fallback)
- If PDF: Report file size
- If HTML: Verify TOC links work
- Count major sections present
- Verify Executive Summary included
- Verify all 6 modules represented

Return: Pass/Fail with details.
Save to memory with tags: ['popsys', 'pdf', 'validation']
Keep response under 20 lines."
```

### Task 4.2: Update Progress Tracker

```
DISPATCH tracker-agent:
"Update SOW/07_SRS/00_Meta/PROGRESS_TRACKER.md:

Add to Phase Summary table:
| Phase 7 | PDF Generation | ✅ Complete | 100% |

Add new section after Section-Level Progress:
## PDF Generation Status
| File | Status | Size | Date |
|------|--------|------|------|
| 00_Executive_Summary.md | ✅ Created | ~80 lines | 2026-01-01 |
| 00_Table_of_Contents.md | ✅ Created | ~100 lines | 2026-01-01 |
| COMPILED_SRS.md | ✅ Generated | ~XXXX lines | 2026-01-01 |
| NewPOPSys_SRS_v1.38.pdf | ✅ Generated | XX MB | 2026-01-01 |

Update last modified timestamp.
Confirm in under 5 lines."
```

---

## Execution Checklist

| Step | Task | Agent | Status |
|------|------|-------|--------|
| 1 | Create Executive Summary | writer-agent | ⏳ |
| 2 | Create Table of Contents | writer-agent | ⏳ |
| 3 | Create Compilation Script | executor-agent | ⏳ |
| 4 | Run Compilation | executor-agent | ⏳ |
| 5 | Convert to PDF | executor-agent | ⏳ |
| 6 | Validate Output | analyzer-agent | ⏳ |
| 7 | Update Tracker | tracker-agent | ⏳ |

---

## Expected Deliverables

1. **SOW/07_SRS/00_Executive_Summary.md** - Executive-friendly project summary
2. **SOW/07_SRS/00_Table_of_Contents.md** - Navigable document index
3. **SOW/07_SRS/scripts/compile_srs.ps1** - Reusable compilation script
4. **SOW/07_SRS/COMPILED_SRS.md** - Single merged markdown file
5. **SOW/07_SRS/NewPOPSys_SRS_v1.38.pdf** - Final PDF for CIO submission

---

## Quick Start

Copy and paste this into Claude:

```
/orchestrator

I need to complete PDF generation for the NewPOPSys SRS.

Execute the workflow from: SOW/07_SRS/00_Meta/PDF_Generation_Orchestration.md

Start with Task 2.2 (Executive Summary) and proceed sequentially through all tasks.

Dispatch agents per the specifications. Each agent must:
- Follow their response limits
- Save work to memory with specified tags
- Confirm completion concisely

Track progress against the Execution Checklist.
Final deliverable: NewPOPSys_SRS_v1.38.pdf ready for CIO review.
```

---

*Created: 2026-01-01*
*Version: 1.0*
*Prerequisite: Phase 1-2.1 Complete*
