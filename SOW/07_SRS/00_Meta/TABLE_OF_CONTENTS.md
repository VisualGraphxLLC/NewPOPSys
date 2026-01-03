# NewPOPSys Software Requirements Specification
## Table of Contents

| Document Info | |
|---------------|---|
| **Version** | 1.0 |
| **Status** | In Development |
| **Last Updated** | 2026-01-01 |
| **Total Files** | 77 files across 14 sections |

---

## Document Structure Overview

This SRS is organized into logical sections covering all aspects of the NewPOPSys platform, from high-level architecture to detailed screen specifications for each user module.

---

## 00_Meta
*Project documentation, tracking, and cross-reference materials*

| File | Description |
|------|-------------|
| [SRS_MASTER_PLAN.md](./SRS_MASTER_PLAN.md) | Overall SRS development strategy and roadmap |
| [AGENT_MEMORY_LOG.md](./AGENT_MEMORY_LOG.md) | AI agent session logs and decision history |
| [PROGRESS_TRACKER.md](./PROGRESS_TRACKER.md) | Development progress and completion status |
| [SOURCE_MAPPING.md](./SOURCE_MAPPING.md) | Mapping between source documents and SRS sections |
| [GAP_REPORT.md](./GAP_REPORT.md) | Analysis of gaps and missing requirements |
| [TABLE_OF_CONTENTS.md](./TABLE_OF_CONTENTS.md) | This document |

**Section Total: 6 files**

---

## 01_Introduction
*Purpose, scope, and foundational context for the SRS*

| File | Description |
|------|-------------|
| [1.1_Purpose.md](../01_Introduction/1.1_Purpose.md) | Document purpose and intended audience |
| [1.2_Scope.md](../01_Introduction/1.2_Scope.md) | System boundaries and scope definition |
| [1.3_Definitions_Acronyms.md](../01_Introduction/1.3_Definitions_Acronyms.md) | Glossary of terms, abbreviations, and acronyms |
| [1.4_References.md](../01_Introduction/1.4_References.md) | Referenced documents and standards |
| [1.5_Document_Overview.md](../01_Introduction/1.5_Document_Overview.md) | Guide to navigating this SRS |

**Section Total: 5 files**

---

## 02_Overall_Description
*Product perspective, features, and operating environment*

| File | Description |
|------|-------------|
| [2.1_Product_Perspective.md](../02_Overall_Description/2.1_Product_Perspective.md) | System context and relationship to other systems |
| [2.2_Product_Features.md](../02_Overall_Description/2.2_Product_Features.md) | High-level feature summary |
| [2.3_User_Classes.md](../02_Overall_Description/2.3_User_Classes.md) | User types and their characteristics |
| [2.4_Operating_Environment.md](../02_Overall_Description/2.4_Operating_Environment.md) | Technical environment and infrastructure |
| [2.5_Design_Constraints.md](../02_Overall_Description/2.5_Design_Constraints.md) | Limitations and design boundaries |
| [2.6_Assumptions_Dependencies.md](../02_Overall_Description/2.6_Assumptions_Dependencies.md) | Assumptions made and external dependencies |
| [diagrams/system_context.mmd](../02_Overall_Description/diagrams/system_context.mmd) | System context diagram (Mermaid) |

**Section Total: 7 files**

---

## 03_System_Architecture
*Technical architecture, database design, and integration patterns*

| File | Description |
|------|-------------|
| [3.1_Database_Model.md](../03_System_Architecture/3.1_Database_Model.md) | Database schema and entity relationships |
| [3.2_Component_Architecture.md](../03_System_Architecture/3.2_Component_Architecture.md) | System component breakdown and interactions |
| [3.3_Deployment_Architecture.md](../03_System_Architecture/3.3_Deployment_Architecture.md) | Infrastructure and deployment topology |
| [3.4_Integration_Architecture.md](../03_System_Architecture/3.4_Integration_Architecture.md) | External system integrations and APIs |
| [diagrams/erd_core.mmd](../03_System_Architecture/diagrams/erd_core.mmd) | Core entity relationship diagram |
| [diagrams/erd_orders.mmd](../03_System_Architecture/diagrams/erd_orders.mmd) | Orders entity relationship diagram |
| [diagrams/component_overview.mmd](../03_System_Architecture/diagrams/component_overview.mmd) | Component architecture diagram |
| [diagrams/deployment.mmd](../03_System_Architecture/diagrams/deployment.mmd) | Deployment architecture diagram |

**Section Total: 8 files**

---

## 04_User_Personas_RBAC
*User personas, roles, permissions, and authentication*

| File | Description |
|------|-------------|
| [4.1_Persona_Matrix.md](../04_User_Personas_RBAC/4.1_Persona_Matrix.md) | Overview matrix of all user personas |
| [4.2_Permission_Matrix.md](../04_User_Personas_RBAC/4.2_Permission_Matrix.md) | Role-based access control matrix |
| [4.3_Authentication_Flows.md](../04_User_Personas_RBAC/4.3_Authentication_Flows.md) | Login, SSO, and authentication workflows |

### Individual Persona Specifications

| File | Description |
|------|-------------|
| [personas/P01_Store_Associate.md](../04_User_Personas_RBAC/personas/P01_Store_Associate.md) | Store Associate persona definition |
| [personas/P02_Store_Manager.md](../04_User_Personas_RBAC/personas/P02_Store_Manager.md) | Store Manager persona definition |
| [personas/P03_District_Manager.md](../04_User_Personas_RBAC/personas/P03_District_Manager.md) | District Manager persona definition |
| [personas/P04_Regional_Manager.md](../04_User_Personas_RBAC/personas/P04_Regional_Manager.md) | Regional Manager persona definition |
| [personas/P05_Brand_Admin.md](../04_User_Personas_RBAC/personas/P05_Brand_Admin.md) | Brand Administrator persona definition |
| [personas/P06_PSP_Operator.md](../04_User_Personas_RBAC/personas/P06_PSP_Operator.md) | PSP Operator persona definition |
| [personas/P07_PSP_Manager.md](../04_User_Personas_RBAC/personas/P07_PSP_Manager.md) | PSP Manager persona definition |
| [personas/P08_Platform_Admin.md](../04_User_Personas_RBAC/personas/P08_Platform_Admin.md) | Platform Administrator persona definition |
| [personas/P09_API_Consumer.md](../04_User_Personas_RBAC/personas/P09_API_Consumer.md) | API Consumer/Integration persona definition |

**Section Total: 12 files**

---

## 05_Module_SharedFoundations
*Shared screens and components used across all modules*

| File | Description |
|------|-------------|
| [screens/L001_Universal_Login.md](../05_Module_SharedFoundations/screens/L001_Universal_Login.md) | Universal login and authentication screen |

**Section Total: 1 file**

---

## 06_Module_MobilePWA
*Mobile Progressive Web App for field staff*

| File | Description |
|------|-------------|
| [screens/M001_Dashboard.md](../06_Module_MobilePWA/screens/M001_Dashboard.md) | Mobile dashboard and home screen |
| [screens/M002_Survey_List.md](../06_Module_MobilePWA/screens/M002_Survey_List.md) | Survey list and filtering |
| [screens/M003_Survey_Capture.md](../06_Module_MobilePWA/screens/M003_Survey_Capture.md) | Survey data capture workflow |
| [screens/M004_Photo_Capture.md](../06_Module_MobilePWA/screens/M004_Photo_Capture.md) | Photo capture with annotations |
| [screens/M005_Offline_Queue.md](../06_Module_MobilePWA/screens/M005_Offline_Queue.md) | Offline data queue management |
| [screens/M006_Installation_Checklist.md](../06_Module_MobilePWA/screens/M006_Installation_Checklist.md) | Installation verification checklist |
| [screens/M007_Store_Profile.md](../06_Module_MobilePWA/screens/M007_Store_Profile.md) | Store profile and information |
| [screens/M008_Notifications.md](../06_Module_MobilePWA/screens/M008_Notifications.md) | Push notifications and alerts |

**Section Total: 8 files**

---

## 07_Module_BrandAdmin
*Brand administration portal for corporate users*

| File | Description |
|------|-------------|
| [screens/B001_Dashboard.md](../07_Module_BrandAdmin/screens/B001_Dashboard.md) | Brand admin dashboard and KPIs |
| [screens/B002_Campaign_Manager.md](../07_Module_BrandAdmin/screens/B002_Campaign_Manager.md) | Campaign creation and management |
| [screens/B003_Store_Directory.md](../07_Module_BrandAdmin/screens/B003_Store_Directory.md) | Store directory and management |
| [screens/B004_Analytics.md](../07_Module_BrandAdmin/screens/B004_Analytics.md) | Analytics and reporting dashboard |
| [screens/B005_Asset_Library.md](../07_Module_BrandAdmin/screens/B005_Asset_Library.md) | Digital asset management |
| [screens/B006_User_Management.md](../07_Module_BrandAdmin/screens/B006_User_Management.md) | Brand user administration |
| [screens/B007_Settings.md](../07_Module_BrandAdmin/screens/B007_Settings.md) | Brand configuration settings |

**Section Total: 7 files**

---

## 08_Module_PSPOperations
*Print Service Provider operations portal*

| File | Description |
|------|-------------|
| [screens/P001_Production_Queue.md](../08_Module_PSPOperations/screens/P001_Production_Queue.md) | Production job queue and management |
| [screens/P002_Job_Details.md](../08_Module_PSPOperations/screens/P002_Job_Details.md) | Individual job details and workflow |
| [screens/P003_Shipping_Integration.md](../08_Module_PSPOperations/screens/P003_Shipping_Integration.md) | Shipping label and tracking integration |

**Section Total: 3 files**

---

## 09_Module_StorePortal
*Store-level portal for managers and staff*

| File | Description |
|------|-------------|
| [screens/S001_Dashboard.md](../09_Module_StorePortal/screens/S001_Dashboard.md) | Store dashboard and status overview |
| [screens/S002_Order_History.md](../09_Module_StorePortal/screens/S002_Order_History.md) | Order history and tracking |
| [screens/S003_Survey_Review.md](../09_Module_StorePortal/screens/S003_Survey_Review.md) | Survey submission review |
| [screens/S004_Installation_Status.md](../09_Module_StorePortal/screens/S004_Installation_Status.md) | Installation progress tracking |
| [screens/S005_Support_Tickets.md](../09_Module_StorePortal/screens/S005_Support_Tickets.md) | Support ticket submission and tracking |

**Section Total: 5 files**

---

## 10_Module_PlatformAdmin
*Platform administration for system operators*

| File | Description |
|------|-------------|
| [screens/A001_System_Dashboard.md](../10_Module_PlatformAdmin/screens/A001_System_Dashboard.md) | System health and monitoring dashboard |
| [screens/A002_Tenant_Management.md](../10_Module_PlatformAdmin/screens/A002_Tenant_Management.md) | Multi-tenant brand management |
| [screens/A003_PSP_Network.md](../10_Module_PlatformAdmin/screens/A003_PSP_Network.md) | PSP network administration |
| [screens/A004_Global_Settings.md](../10_Module_PlatformAdmin/screens/A004_Global_Settings.md) | Platform-wide configuration |
| [screens/A005_Audit_Logs.md](../10_Module_PlatformAdmin/screens/A005_Audit_Logs.md) | System audit trail and logs |
| [screens/A006_Integration_Hub.md](../10_Module_PlatformAdmin/screens/A006_Integration_Hub.md) | Third-party integration management |

**Section Total: 6 files**

---

## 11_API_Specifications
*RESTful API documentation and specifications*

| File | Description |
|------|-------------|
| [11.1_API_Overview.md](../11_API_Specifications/11.1_API_Overview.md) | API design principles and conventions |
| [11.2_Authentication_API.md](../11_API_Specifications/11.2_Authentication_API.md) | Authentication and authorization endpoints |
| [11.3_Core_Endpoints.md](../11_API_Specifications/11.3_Core_Endpoints.md) | Core business logic API endpoints |
| [11.4_Webhook_Events.md](../11_API_Specifications/11.4_Webhook_Events.md) | Webhook event definitions and payloads |

**Section Total: 4 files**

---

## 12_Non_Functional_Requirements
*Performance, security, and quality attributes*

| File | Description |
|------|-------------|
| [12.1_Performance.md](../12_Non_Functional_Requirements/12.1_Performance.md) | Performance benchmarks and requirements |
| [12.2_Security.md](../12_Non_Functional_Requirements/12.2_Security.md) | Security requirements and controls |
| [12.3_Reliability.md](../12_Non_Functional_Requirements/12.3_Reliability.md) | Availability and disaster recovery |
| [12.4_Scalability.md](../12_Non_Functional_Requirements/12.4_Scalability.md) | Scalability and capacity planning |
| [12.5_Usability.md](../12_Non_Functional_Requirements/12.5_Usability.md) | Usability and accessibility standards |
| [12.6_Compliance.md](../12_Non_Functional_Requirements/12.6_Compliance.md) | Regulatory and compliance requirements |

**Section Total: 6 files**

---

## 99_Appendices
*Supporting materials and reference documentation*

| File | Description |
|------|-------------|
| [Appendix_A_Glossary.md](../99_Appendices/Appendix_A_Glossary.md) | Extended glossary of terms |
| [Appendix_B_Data_Dictionary.md](../99_Appendices/Appendix_B_Data_Dictionary.md) | Complete data element definitions |
| [Appendix_C_UI_Standards.md](../99_Appendices/Appendix_C_UI_Standards.md) | UI/UX design standards and patterns |
| [Appendix_D_Error_Codes.md](../99_Appendices/Appendix_D_Error_Codes.md) | System error codes and handling |
| [Appendix_E_Change_Log.md](../99_Appendices/Appendix_E_Change_Log.md) | Document revision history |

**Section Total: 5 files**

---

## Summary

| Section | Files | Status |
|---------|-------|--------|
| 00_Meta | 6 | In Progress |
| 01_Introduction | 5 | Complete |
| 02_Overall_Description | 7 | Complete |
| 03_System_Architecture | 8 | Complete |
| 04_User_Personas_RBAC | 12 | Complete |
| 05_Module_SharedFoundations | 1 | Complete |
| 06_Module_MobilePWA | 8 | Complete |
| 07_Module_BrandAdmin | 7 | Complete |
| 08_Module_PSPOperations | 3 | Complete |
| 09_Module_StorePortal | 5 | Complete |
| 10_Module_PlatformAdmin | 6 | Complete |
| 11_API_Specifications | 4 | Complete |
| 12_Non_Functional_Requirements | 6 | Complete |
| 99_Appendices | 5 | Complete |
| **TOTAL** | **83** | |

---

## Navigation Guide

- **New to the project?** Start with [1.1_Purpose.md](../01_Introduction/1.1_Purpose.md) and [1.5_Document_Overview.md](../01_Introduction/1.5_Document_Overview.md)
- **Understanding users?** See [4.1_Persona_Matrix.md](../04_User_Personas_RBAC/4.1_Persona_Matrix.md)
- **Technical architecture?** Begin with [3.2_Component_Architecture.md](../03_System_Architecture/3.2_Component_Architecture.md)
- **Screen specifications?** Navigate to the relevant module section (05-10)
- **API integration?** See [11.1_API_Overview.md](../11_API_Specifications/11.1_API_Overview.md)

---

*This Table of Contents is auto-maintained. Last generated: 2026-01-01*
