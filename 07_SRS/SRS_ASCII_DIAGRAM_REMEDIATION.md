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

| Status | Line# | Section | Component | Action |
|--------|-------|---------|-----------|--------|
| [ ] | 2772 | L001 Login | Login Form Wireframe | ❌ No existing screenshot - needs creation |
| [ ] | 2775 | L001 Login | MFA Modal | ❌ No existing screenshot - needs creation |
| [ ] | 2780 | L001 Login | Forgot Password Modal | ❌ No existing screenshot - needs creation |
| [ ] | 2785 | L001 Login | SSO Domain Entry Modal | ❌ No existing screenshot - needs creation |
| [ ] | 2790 | L001 Login | Role Selector Modal | ❌ No existing screenshot - needs creation |
| [ ] | 4979 | Store Execution | Task Card Layout | 🟡 Partial: Mobile_App/mobile_task.png exists |
| [ ] | 4982 | Store Execution | Attestation Screen Layout | ❌ No existing screenshot - needs creation |

**Total**: 7 wireframes (0 complete, 1 partial match, 6 missing)

### Screenshot Folder Analysis (2026-01-02)
Found 63 screenshots in `SOW/07_SRS/screenshots/`:
- **Admin_Portal**: 15 files (dashboard, campaigns, stores, verification, settings)
- **Mobile_App**: 12 files (dashboard, tasks, scan, profile, photo capture)
- **PSP_Admin**: 5 files (dashboard, brands, users, audit)
- **PSP_Operations**: 6 files (orders, issues, shipments, status)
- **Regional_Dashboard**: 7 files (main, campaigns, exceptions, verification)
- **Store_Portal**: 6 files (dashboard, photos, team, campaigns, layout)
- **Store_Surveys**: 9 files (builder, layouts, responses, rules, editor)

**Gap**: No Login/Auth flow wireframes exist in screenshot collection

---

## Progress Summary

- **Mermaid Conversions**: 9/12 complete (Batch 1: 5, Batch 2: 4)
- **Wireframe Screenshots**: 0/7 complete
- **Overall**: 9/19 complete

### Conversion Log
- **2026-01-02 Batch 1**: Campaign Orchestration, Multi-Tenant, Lifecycle, User Hierarchy, AWS Infra
- **2026-01-02 Batch 2**: Correlation Flow, Permission Hierarchy, Auth Flow, Dashboard Wireframe

---

## Notes

- ASCII diagrams use corrupted UTF-8 box characters (â"‚, â"œ, â"€, etc.)
- Wireframes should follow existing design system in `SOW/05_Wireframes/`
- Screenshots should be PNG format, placed in `SOW/07_SRS/assets/`
