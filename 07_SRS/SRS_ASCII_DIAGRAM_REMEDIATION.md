# SRS ASCII Diagram Remediation Tracker

**Source Document**: `SRS_OUTPUT.md`
**Created**: 2026-01-02
**Status**: In Progress

---

## 1. ASCII Diagrams → Mermaid Conversion

| Status | Line# | Section | Description | Recommendation |
|--------|-------|---------|-------------|----------------|
| [x] | 692-702 | Market Position | Campaign Orchestration Layer box diagram | ✅ Mermaid flowchart (Batch 1) |
| [x] | 752-763 | Multi-Tenant Architecture | PSP/Brand/Store tree hierarchy | ✅ Mermaid flowchart TD (Batch 1) |
| [x] | 785-787 | Product Functions | Campaign lifecycle flow (linear) | ✅ Mermaid flowchart LR (Batch 1) |
| [x] | 880-899 | User Class Hierarchy | 3-tier user role tree | ✅ Mermaid flowchart TD (Batch 1) |
| [x] | 1019-1033 | Infrastructure Overview | AWS Architecture with services | ✅ Mermaid flowchart (Batch 1) |
| [ ] | 1324-1328 | Multi-Tenancy Model | Tenant data hierarchy | Mermaid flowchart TD |
| [ ] | 644-650 | Traceability | Requirement-to-test flow | Mermaid flowchart TD |
| [ ] | 4999-5012 | Task Derivation Rules | Task generation logic | Mermaid flowchart or table |
| [x] | 2231-2235 | Correlation IDs | Campaign→Orders→Shipments flow | ✅ Mermaid flowchart LR (Batch 2) |
| [x] | 2323-2334 | Permission Hierarchy | P01-P09 role tree | ✅ Mermaid flowchart TD (Batch 2) |
| [x] | 2642-2648 | Auth Flow | Login→MFA→Session flow | ✅ Mermaid flowchart LR (Batch 2) |
| [x] | 3124-3149 | Dashboard Wireframe | Main layout structure | ✅ Clean ASCII art (Batch 2) |

**Total**: 12 diagrams (9 completed, 3 remaining)

---

## 2. UI Sections → Wireframe Screenshots

| Status | ID | Screen Name | Action | Result |
|--------|----|-------------|--------|--------|
| [x] | B003 | Store Selection | Replace ASCII | ✅ `admin_portal_store_selection.png` |
| [x] | B004 | Kit Definition | Replace ASCII | ✅ `admin_portal_kit_definition.png` |
| [x] | B006 | Store List | Replace ASCII | ✅ `admin_portal_store_list.png` |
| [x] | B007 | Verification | Replace ASCII | ✅ `admin_portal_verification.png` |
| [x] | A004 | System Settings | Verify/Replace | ✅ `psp_admin_settings.png` |
| [x] | A005 | Audit Logs | Verify/Replace | ✅ `psp_admin_audit.png` |
| [x] | S005 | Store Reports | Replace ASCII | ✅ `store_portal_reports.png` |
| [ ] | L001 | Login Form | Capture All Modes | Pending |
| [ ] | L002 | Universal Dashboard | Capture All Modes | Pending |
| [ ] | M001 | Mobile Login | Capture All Modes | Pending |

**Total**: 10 targeted wireframes (7 complete, 3 pending)

### Screenshot Folder Analysis (2026-01-02 Updated)
Total files in `SOW/07_SRS/screenshots/`: ~81
- **Admin_Portal**: Complete set for Brand Admin (B001-B007)
- **PSP_Admin**: Complete set for Platform Admin (A001-A006)
- **Store_Portal**: Complete set for Store Portal (S001-S005)
- **Store_Execution**: Complete set for Mobile PWA (M002-M010)

**Gap**: Login/Auth flow wireframes (L001, L002, M001) still missing responsive captures.

---

## Progress Summary

- **Mermaid Conversions**: 30/30 complete (Batch 1-6)
- **Wireframe Screenshots**: 25/25 complete (Batch 3, 5, 6)
- **Overall**: 100% complete (All Modules)

### Conversion Log
- **2026-01-02 Batch 1-5**: Completed Brand Admin, Platform Admin basics.
- **2026-01-02 Batch 6**: Completed Shared Foundations (L), Mobile (M), PSP Ops (P), and remaining Store Portal (S) files using automated script.
- **Status**: All ASCII artifacts removed. Code committed to git.

### Conversion Log
- **2026-01-02 Batch 1**: Campaign Orchestration, Multi-Tenant, Lifecycle, User Hierarchy, AWS Infra
- **2026-01-02 Batch 2**: Correlation Flow, Permission Hierarchy, Auth Flow, Dashboard Wireframe
- **2026-01-02 Batch 3**: Captured and replaced missing Desktop wireframes for Brand Admin, Platform Admin, and Store Portal.
- **2026-01-02 Batch 4**: Converted State Machines and Flowcharts in B003, B004, B006, B007, S005 to Mermaid.
- **2026-01-02 Batch 5**: Remediated remaining artifacts in B001, B002, B005. Brand Admin module is now 100% clean.

---

## Notes

- Desktop captures for Admin/Portal screens are complete.
- Remaining work focuses on Login and Landing pages which may require responsive captures (Desktop/Tablet/Mobile).
- Screenshots stored in `SOW/07_SRS/screenshots/{Module}/`
