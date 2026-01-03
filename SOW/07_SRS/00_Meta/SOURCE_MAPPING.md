# Source Document Mapping

> Maps SOW source documents to their target SRS sections.

---

## Quick Reference

| SRS Section | Primary Sources |
|-------------|-----------------|
| Introduction | README.md, MASTER_SOW_COMPILED.md |
| Overall Description | SUPP-001, SUPP-012, MASTER_SOW_COMPILED.md |
| Database Model | `06_Database_Model/*` (16 files) |
| App Architecture | SUPP-012, SUPP-021 |
| Personas/RBAC | SUPP-001, SUPP-003 |
| Screen Specs | `06_Screen_Specs/*` (25 files) |
| Wireframes | `05_Wireframes/*`, `07_SRS/screenshots/*` |
| APIs | `06_API/openapi.yaml` |
| State Machines | `05_Wireframes/diagrams/*` |
| NFRs | SUPP-038, SUPP-039 |

---

## Detailed Source Mapping

### 01_Introduction

| SRS File | Source Documents |
|----------|------------------|
| 1.1_Purpose.md | README.md |
| 1.2_Scope.md | MASTER_SOW_COMPILED.md Section 1 |
| 1.3_Definitions_Acronyms.md | All SUPPs (extract terminology) |
| 1.4_References.md | All source document list |
| 1.5_Document_Overview.md | SRS_MASTER_PLAN.md |

### 02_Overall_Description

| SRS File | Source Documents |
|----------|------------------|
| 2.1_Product_Perspective.md | MASTER_SOW_COMPILED.md, SUPP-021 |
| 2.2_Product_Functions.md | SUPP-001, Screen Specs Summary |
| 2.3_User_Classes.md | SUPP-001 (Personas) |
| 2.4_Operating_Environment.md | SUPP-012 (Tech Stack) |
| 2.5_Constraints.md | SUPP-012, SUPP-038 |
| 2.6_Assumptions_Dependencies.md | MASTER_SOW_COMPILED.md |

### 03_System_Architecture

| SRS File | Source Documents |
|----------|------------------|
| 3.1_Database_Model.md | `06_Database_Model/*.sql` (all 16 files) |
| 3.2_Application_Architecture.md | SUPP-012, SUPP-021 |
| 3.3_Technology_Stack.md | SUPP-012 |
| 3.4_Integration_Architecture.md | SUPP-021, `06_API/openapi.yaml` |

### 04_User_Personas_RBAC

| SRS File | Source Documents |
|----------|------------------|
| 4.1_Persona_Matrix.md | SUPP-001 |
| 4.2_Permission_Matrix.md | SUPP-003 |
| 4.3_Authentication_Flows.md | SUPP-003, Screen Specs (L001) |
| personas/*.md | SUPP-001 (individual persona details) |

### 05_Module_SharedFoundations (L-series)

| SRS File | Source Documents |
|----------|------------------|
| L001_Login.md | `06_Screen_Specs/L001*.md` |
| L002_Dashboard.md | `06_Screen_Specs/L002*.md` |
| ... | ... |

### 06_Module_MobilePWA (M-series)

| SRS File | Source Documents |
|----------|------------------|
| M001_Store_Dashboard.md | `06_Screen_Specs/M001*.md`, `screenshots/Mobile_App/` |
| M002_Campaign_List.md | `06_Screen_Specs/M002*.md` |
| ... | ... |

### 07_Module_BrandAdmin (B-series)

| SRS File | Source Documents |
|----------|------------------|
| B001_Brand_Dashboard.md | `06_Screen_Specs/B001*.md`, `screenshots/Admin_Portal/` |
| ... | ... |

### 08_Module_PSPOperations (P-series)

| SRS File | Source Documents |
|----------|------------------|
| P001_Operations_Dashboard.md | `06_Screen_Specs/P001*.md`, `screenshots/PSP_Operations/` |
| ... | ... |

### 09_Module_StorePortal (S-series)

| SRS File | Source Documents |
|----------|------------------|
| S001_Store_Dashboard.md | `06_Screen_Specs/S001*.md`, `screenshots/Store_Portal/` |
| ... | ... |

### 10_Module_PlatformAdmin

| SRS File | Source Documents |
|----------|------------------|
| A001_Admin_Dashboard.md | `06_Screen_Specs/A001*.md`, `screenshots/PSP_Admin/` |
| ... | ... |

### 11_API_Specifications

| SRS File | Source Documents |
|----------|------------------|
| 11.1_API_Overview.md | `06_API/openapi.yaml` |
| 11.2_Internal_APIs.md | `06_API/openapi.yaml` (paths section) |
| 11.3_External_Integrations.md | SUPP-021 |
| 11.4_Webhooks.md | `06_API/openapi.yaml` (webhook paths) |

### 12_Non_Functional_Requirements

| SRS File | Source Documents |
|----------|------------------|
| 12.1_Performance.md | SUPP-039 |
| 12.2_Security.md | SUPP-038 |
| 12.3_Accessibility.md | SUPP-039 |
| 12.4_Scalability.md | SUPP-039, SUPP-012 |
| 12.5_Availability.md | SUPP-039 |
| 12.6_Data_Retention.md | SUPP-038 |

### 99_Appendices

| SRS File | Source Documents |
|----------|------------------|
| A_State_Machines.md | `05_Wireframes/diagrams/*` |
| B_Notification_Matrix.md | Screen Specs (notification rules) |
| C_Export_Formats.md | Screen Specs (report features) |
| D_Glossary.md | All documents (terminology extraction) |
| E_Change_Log.md | N/A (generated during SRS creation) |

---

## Source Document Inventory

### SOW/02_Supporting_Documents/ (39 SUPPs)

| SUPP ID | Title | Used In |
|---------|-------|---------|
| SUPP-001 | User Personas | 02, 04 |
| SUPP-003 | RBAC Definition | 04 |
| SUPP-012 | Technology Stack | 02, 03 |
| SUPP-021 | Integration Architecture | 03, 11 |
| SUPP-038 | Security Requirements | 12 |
| SUPP-039 | Performance Requirements | 12 |
| ... | *(Full inventory TBD in Phase 2)* | ... |

### SOW/06_Screen_Specs/ (25 files)

| Prefix | Module | Count |
|--------|--------|-------|
| L-series | Shared Foundations | TBD |
| M-series | Mobile PWA | 8 |
| B-series | Brand Admin | 7 |
| P-series | PSP Operations | 3 |
| S-series | Store Portal | 5 |
| A-series | Platform Admin | TBD |

### SOW/06_Database_Model/ (16 files)

*(To be inventoried in Phase 2)*

### SOW/05_Wireframes/

| Folder | Content |
|--------|---------|
| screenshots/ | UI mockups |
| diagrams/ | State machines, flow diagrams |

---
*Last Updated: 2026-01-01*
