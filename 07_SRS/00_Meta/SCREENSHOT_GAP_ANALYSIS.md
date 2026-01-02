# Screenshot Gap Analysis

> Analysis of ASCII wireframes vs actual screenshots in SRS screen specifications.

---

## Executive Summary

| Category | Count |
|----------|-------|
| Total Screen Specs | 31 |
| Specs WITH Screenshot References | 22 |
| Specs WITHOUT Screenshots | 9 |
| Files with ASCII Wireframes | 32 |
| Existing Screenshots | 59 |

**Key Finding**: Many screen specs have BOTH screenshot references AND ASCII wireframes. The ASCII wireframes serve as layout specifications but should be supplemented with actual UI mockups for a professional SRS.

---

## Gap Categories

### Category A: Missing Screenshots (Need Creation)

These screen specs have NO screenshot references and rely entirely on ASCII wireframes:

| Screen Spec | Module | Required Screenshot | Priority |
|-------------|--------|---------------------|----------|
| L001_Universal_Login.md | SharedFoundations | Universal login screen | HIGH |
| L002_Universal_Dashboard.md | SharedFoundations | Universal dashboard template | HIGH |
| S005_Reports.md | StorePortal | Reports dashboard | MEDIUM |
| A001_Admin_Dashboard.md | PlatformAdmin | Admin dashboard | HIGH |
| A002_User_Management.md | PlatformAdmin | User management grid | HIGH |
| A003_Brand_Configuration.md | PlatformAdmin | Brand config panel | MEDIUM |
| A004_System_Settings.md | PlatformAdmin | System settings | MEDIUM |
| A005_Audit_Logs.md | PlatformAdmin | Audit log viewer | LOW |
| A006_Support_Queue.md | PlatformAdmin | Support ticket queue | LOW |

### Category B: Has Screenshot + ASCII Wireframe (Consider Replacing Wireframe)

These specs have screenshot references but ALSO contain ASCII wireframes as layout specs:

| Screen Spec | Has Screenshot | ASCII Wireframe Purpose |
|-------------|----------------|------------------------|
| P001_Order_Queue.md | ✅ psp_ops_orders.png | Detailed layout specification |
| P002_Shipments.md | ✅ psp_ops_shipments.png | Layout specification |
| P003_Issues.md | ✅ psp_ops_issues.png | Layout specification |
| S001_Dashboard.md | ✅ store_portal_dashboard.png | Widget layout |
| S002_Campaign_History.md | ✅ store_portal_campaigns.png | Table layout |
| B001_Dashboard.md | ✅ admin_portal_dashboard.png | Metrics layout |
| L002_Universal_Dashboard.md | ❌ Missing | Dashboard template |

### Category C: Complete (Screenshot Covers Wireframe)

These specs have screenshots and either no wireframe or minimal wireframe notation:

| Screen Spec | Screenshot | Status |
|-------------|-----------|--------|
| M001_Login.md | mobile_app.png | ✅ Complete |
| M002_Dashboard.md | mobile_app_dashboard.png | ✅ Complete |
| M003_Receipt_Survey.md | mobile_app_scan.png, mobile_app_scan_detail.png | ✅ Complete |
| M004_Install_Survey.md | mobile_app_tasks.png, mobile_app_task_detail.png | ⚠️ Has wireframe |
| M005_Photo_Capture.md | mobile_app_photo_capture.png | ✅ Complete |
| M006_Tasks.md | mobile_app_tasks.png | ✅ Complete |
| M007_Profile.md | mobile_app_profile.png | ✅ Complete |
| M008_Retake.md | mobile_app_task_detail.png | ✅ Complete |
| B002_Campaign_List.md | admin_portal_campaigns.png | ✅ Complete |
| B003_Store_Selection.md | admin_portal_stores_tab.png | ✅ Complete |
| B004_Kit_Definition.md | admin_portal_new_campaign_wizard.png | ✅ Complete |
| B005_Campaign_Review.md | admin_portal_verification.png | ✅ Complete |
| B006_Store_List.md | admin_portal_stores_tab.png | ✅ Complete |
| B007_Verification.md | admin_portal_verification.png | ✅ Complete |
| S003_Photo_Gallery.md | store_portal_photos.png | ✅ Complete |
| S004_Team_Management.md | store_portal_team.png | ✅ Complete |

---

## Existing Screenshot Inventory

### Mobile_App (12 files)
- mobile_app.png
- mobile_app_dashboard.png
- mobile_app_tasks.png
- mobile_app_task_detail.png
- mobile_app_scan.png
- mobile_app_scan_detail.png
- mobile_app_photo_capture.png
- mobile_app_profile.png
- mobile_app_profile_detail.png
- mobile_home.png
- mobile_task.png
- (12th file from inventory)

### Admin_Portal (15 files)
- admin_portal.png
- admin_portal_dashboard.png
- admin_portal_campaigns.png
- admin_portal_campaigns_tab.png
- admin_portal_stores_tab.png
- admin_portal_new_campaign.png
- admin_portal_new_campaign_wizard.png
- admin_portal_verification.png
- admin_portal_settings.png
- admin_dashboard.png
- admin_campaigns.png
- admin_layouts.png
- admin_inventory.png
- (additional files)

### PSP_Operations (6 files)
- psp_ops.png
- psp_ops_home.png
- psp_ops_orders.png
- psp_ops_shipments.png
- psp_ops_issues.png
- psp_ops_status.png

### Store_Portal (7 files)
- store_portal.png
- store_portal_dashboard.png
- store_portal_campaigns.png
- store_portal_photos.png
- store_portal_team.png
- store_portal_reports.png (if exists)
- (additional files)

### Store_Surveys (8 files)
- store_surveys.png
- store_surveys_builder.png
- store_surveys_layouts.png
- store_surveys_responses.png
- store_surveys_rules.png
- survey_list.png
- survey_editor.png
- survey_preview.png

### Regional_Dashboard (7 files)
- regional_dashboard.png
- (additional files)

---

## Required Actions

### Phase 1: Add Missing Screenshots (Priority HIGH)

| File | Action | Screenshot Needed |
|------|--------|-------------------|
| L001_Universal_Login.md | Create/capture | Generic login mockup |
| L002_Universal_Dashboard.md | Create/capture | Dashboard template wireframe |
| A001_Admin_Dashboard.md | Use existing? | Check admin_dashboard.png |
| A002_User_Management.md | Create/capture | User grid with roles |

### Phase 2: Platform Admin Screenshots

| File | Action | Notes |
|------|--------|-------|
| A003_Brand_Configuration.md | Create/capture | Brand setup wizard |
| A004_System_Settings.md | Use existing? | Check admin_portal_settings.png |
| A005_Audit_Logs.md | Create/capture | Log viewer table |
| A006_Support_Queue.md | Create/capture | Ticket queue |

### Phase 3: Remaining Gaps

| File | Action | Notes |
|------|--------|-------|
| S005_Reports.md | Use existing? | Check store_portal_reports.png |

---

## Screenshot Mapping Recommendations

For screens missing screenshots, map to these potential sources:

| Missing Screen | Suggested Source |
|----------------|------------------|
| L001_Universal_Login | Reuse mobile_app.png or admin_portal.png login |
| L002_Universal_Dashboard | Create template from admin_portal_dashboard.png |
| A001_Admin_Dashboard | Use admin_dashboard.png or admin_portal_dashboard.png |
| A002_User_Management | Create from admin_portal_settings.png base |
| S005_Reports | Use store_portal.png or regional_dashboard.png |

---

## ASCII Wireframe Retention Decision

**Recommendation**: Keep ASCII wireframes as supplementary layout specifications in the SRS, but ensure each screen spec ALSO has a real screenshot reference.

**Rationale**:
1. ASCII wireframes provide precise layout dimensions and positioning
2. Screenshots show actual UI appearance
3. Both serve different documentation purposes
4. IEEE 830 compliant SRS can include both

---

*Generated: 2026-01-01*
*Analysis covers: SOW/07_SRS screen specifications*
