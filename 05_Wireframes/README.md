# NewPOPSys v1 — Wireframes

> **Updated**: 2025-12-23
> **Launch**: Open `index.html` in a browser

---

## Overview

Interactive HTML wireframes demonstrating key workflows from the SOW. Built with Tailwind CSS for responsive display.

---

## Available Wireframes

| File | Module | SUPP Coverage | Key Screens |
|------|--------|---------------|-------------|
| [index.html](index.html) | Hub | — | Landing page with links to all wireframes |
| [mobile_app.html](mobile_app.html) | Store Execution | SUPP-017, SUPP-036, SUPP-037 | Login, Dashboard, Receipt Survey, Install Survey, Photo Capture |
| [store_portal.html](store_portal.html) | Store Manager | SUPP-017, SUPP-001 | Dashboard, Campaign History, Photo Gallery, Team, Reports |
| [admin_portal.html](admin_portal.html) | Brand Admin | SUPP-014, SUPP-015 | Campaign Creation, Store Selection, Kit Assignment, Dashboards |
| [psp_ops.html](psp_ops.html) | PSP Operations | SUPP-018, SUPP-019 | Verification Queue, Photo Review, Issue Management, Reorder Approval |
| [store_surveys.html](store_surveys.html) | Surveys & Layouts | SUPP-014, SUPP-037 | Survey Builder, Store Layouts, Photo Rules, Survey Responses |

---

## Wireframe Coverage Matrix

### Store Mobile App (`mobile_app.html`)

| Screen | Status | Notes |
|--------|--------|-------|
| Login | ✅ Complete | Username/password, store selector |
| Dashboard | ✅ Complete | Active campaigns, status badges |
| Receipt Survey | ✅ Complete | Item checklist, exception reporting |
| Install Survey | ✅ Complete | Location grouping, photo capture |
| Photo Capture | ✅ Complete | Camera, ghost overlay, retake |
| Attestation | ✅ Complete | Checkbox, signature, submit |
| Retake Flow | ✅ Complete | Rejection reason, retake button |
| Offline Indicator | 🟡 Placeholder | Sync status shown but not functional |

### Store Manager Portal (`store_portal.html`)

| Screen | Status | Notes |
|--------|--------|-------|
| Dashboard | ✅ Complete | KPIs, active campaigns, pending actions, team status |
| Campaign History | ✅ Complete | Status tabs, expandable details, progress bars |
| Photo Gallery | ✅ Complete | Grid/list view, filters, status badges |
| Team Management | ✅ Complete | Members, invitations, activity metrics |
| Reports | ✅ Complete | KPIs, trend charts, team contribution |

### Brand Admin Portal (`admin_portal.html`)

| Screen | Status | Notes |
|--------|--------|-------|
| Campaign List | ✅ Complete | Cards, filters, create button |
| Campaign Create | ✅ Complete | Wizard flow, store selection |
| Store Selection Builder | ✅ Complete | Include/exclude, preview counter |
| Kit Assignment | ✅ Complete | Item list, slot mapping |
| Campaign Dashboard | ✅ Complete | Store progress table, phase bars |
| Store Detail Modal | ✅ Complete | Status, photos, actions |
| Survey Builder | ✅ Complete | See store_surveys.html for full implementation |
| Photo Rules | ✅ Complete | See store_surveys.html for full implementation |
| Store Import | 🟡 Basic | Upload, mapping, validation preview |
| Geography Tree | 🟡 Basic | Region/District hierarchy |

### PSP Operations (`psp_ops.html`)

| Screen | Status | Notes |
|--------|--------|-------|
| Verification Queue | ✅ Complete | Filter by status, sort by date |
| Photo Review | ✅ Complete | Full image, approve/reject, reason selector |
| Issue Dashboard | ✅ Complete | Open issues, type filters |
| Issue Detail | ✅ Complete | Evidence photo, approve/deny/reorder |
| Reorder Queue | ✅ Complete | Pending reorders, approve/create order |
| Order List | 🟡 Basic | Table with status badges |
| Shipment Tracking | 🟡 Basic | Tracking number, carrier, status |

### Store Surveys & Layouts (`store_surveys.html`)

| Screen | Status | Notes |
|--------|--------|-------|
| Survey Template List | ✅ Complete | Type badges, version, field count, status |
| Survey Builder Canvas | ✅ Complete | Drag-drop fields, conditional logic, preview |
| Field Properties Panel | ✅ Complete | Validation, visibility rules, photo rules |
| Store Layout List | ✅ Complete | Store search, region filter, slot counts |
| Store Layout Editor | ✅ Complete | Slot grid, add/edit/delete, slot types |
| Survey Responses List | ✅ Complete | Filters, status, pagination |
| Survey Response Detail | ✅ Complete | Answers, photos, edit audit, issue creation |
| Photo Rules | ✅ Complete | Rule cards, min/max, flash, ghost image |

---

## Known Gaps

| Gap | Priority | Resolution |
|-----|----------|------------|
| Notification preferences screen | Low | Add to admin_portal.html settings section |
| Export job history | Low | Add to admin_portal.html reports section |
| User management (invite/edit) | Medium | Add RBAC screens to admin_portal.html |
| Audit log viewer | Low | Add to admin_portal.html |
| Batch management (PSP) | Medium | Add to psp_ops.html |
| ~~Survey Builder~~ | ~~High~~ | ✅ RESOLVED - Added to store_surveys.html |
| ~~Store Layout Builder~~ | ~~High~~ | ✅ RESOLVED - Added to store_surveys.html |
| ~~Survey Responses Viewer~~ | ~~Medium~~ | ✅ RESOLVED - Added to store_surveys.html |

---

## How to Use

1. **Open in Browser**: Double-click `index.html` or serve via local server
2. **Navigate**: Click buttons and links to move between screens
3. **Validate**: Compare against SUPP documents for accuracy
4. **Report Issues**: Note any discrepancies for SOW updates

---

## Interactive Tooltips

All wireframes now include **interactive tooltips** that provide detailed documentation when you hover over key elements. Look for elements with dashed outlines.

### Tooltip Information Includes:
- **Feature Name**: What the UI element does
- **Data Sources**: Which database entities/fields are used
- **Dependencies**: What must happen before this works
- **Blockers**: What this feature blocks downstream

### How to Use:
1. Look for elements with **dashed colored outlines**
2. Hover over them to see the tooltip
3. Each tooltip shows: Feature, Data, Dependencies, and Blockers

### Color Coding by Portal:
| Portal | Outline Color |
|--------|---------------|
| Mobile App | Blue (#3b82f6) |
| Store Portal | Teal (#14b8a6) |
| Brand Admin | Purple (#9333ea) |
| PSP Ops | Yellow (#eab308) |

---

## Technical Notes

- Built with Tailwind CSS (CDN loaded)
- No backend required — all interactions are simulated
- State is not persisted between page reloads
- Mobile wireframes are responsive (resize browser to test)
- Tooltips use CSS-only implementation (no JavaScript dependencies)

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [SUPP-036](../02_SUPPs/Screens_Interfaces/SUPP-036%20-%20Screens%20-%20Interfaces%20-%20Screens%20Onboarding%20and%20Store%20Foundation.md) | Onboarding, Store Management screens |
| [SUPP-037](../02_SUPPs/Screens_Interfaces/SUPP-037%20-%20Screens%20-%20Interfaces%20-%20Screens%20SurveyBuilder%20and%20StoreSurveys.md) | Survey Builder, Store Survey screens |
| [Process Flow Index](../00_Index/PROCESS_FLOW_INDEX.md) | All process flow diagrams |

---

*End of README*
