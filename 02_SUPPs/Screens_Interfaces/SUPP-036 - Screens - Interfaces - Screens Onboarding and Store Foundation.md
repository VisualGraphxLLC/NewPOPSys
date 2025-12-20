# SUPP-036 — Screens — Onboarding and Store Foundation

> **Version**: v0.6
> **Status**: Locked
> **Updated**: 2025-12-18
> **Dependencies**: SUPP-001 (Personas), SUPP-013 (Stores)

---

## Purpose
Define the onboarding flows, store master data management screens, and import/conflict resolution UX for Brand Admin users.

---

## Interactive Wireframes

**Launch**: [admin_portal.html](../../05_Wireframes/admin_portal.html)

The wireframes demonstrate the complete flows described in this document.

---

## 1. Onboarding Flow

### 1.1 Brand Admin First Login

| Step | Screen | Components |
|------|--------|------------|
| 1 | Welcome | Logo, welcome message, "Get Started" CTA |
| 2 | Brand Profile | Brand name, logo upload, timezone selector |
| 3 | Import Stores | CSV/XLSX uploader, template download link |
| 4 | Review Regions | Auto-detected regions, edit/add capability |
| 5 | Invite Users | Email input, role selector, bulk invite option |
| 6 | Complete | Success message, "Go to Dashboard" CTA |

### 1.2 Store User First Login

| Step | Screen | Components |
|------|--------|------------|
| 1 | Welcome | Store name displayed, "Continue" CTA |
| 2 | Profile Confirm | Name, email, phone (prefilled if available) |
| 3 | Notification Prefs | Email/Push toggles by event type |
| 4 | Complete | Success, redirect to campaign dashboard |

---

## 2. Store Management Screens

### 2.1 Store List View

**Route**: `/admin/stores`

| Component | Description |
|-----------|-------------|
| **Search Bar** | Search by store number, name, city |
| **Filter Panel** | Region, District, Status, Groups |
| **Store Table** | Columns: Store #, Name, Region, Status, Actions |
| **Pagination** | 25/50/100 per page, page navigation |
| **Bulk Actions** | Select multiple → Edit Region, Change Status, Add to Group |
| **Export Button** | CSV/XLSX download of filtered results |

### 2.2 Store Detail View

**Route**: `/admin/stores/:storeId`

| Section | Fields |
|---------|--------|
| **Header** | Store #, Name, Status badge, Edit button |
| **Location** | Address, City, State, ZIP, Region/District |
| **Contacts** | Primary contact, Store manager, Phone, Email |
| **Groups** | List of groups with remove/add buttons |
| **Campaigns** | Active/completed campaigns with links |
| **Audit Log** | Recent changes with timestamp and actor |

---

## 3. Store Import Flow

### 3.1 Import Screen

**Route**: `/admin/stores/import`

| Step | Screen | Components |
|------|--------|------------|
| 1 | Upload | Drag-drop zone, file type validation, template link |
| 2 | Mapping | Column mapper (auto-detect with manual override) |
| 3 | Validation | Preview table with row-level errors highlighted |
| 4 | Conflicts | Conflict resolution grid (see 3.2) |
| 5 | Summary | Created/Updated/Skipped counts, "Apply" button |
| 6 | Result | Import report with download option |

### 3.2 Conflict Resolution UX (Bulk Apply)

**Locked Decision**: Conflicts require explicit action (Keep/Update/Skip)

| Component | Description |
|-----------|-------------|
| **Conflict Grid** | Table with columns: Store #, Field, Current Value, Import Value, Action |
| **Checkboxes** | Per-row selection for bulk operations |
| **Filter/Sort** | By region, city, conflict type |
| **Bulk Actions** | APPLY_UPDATE, APPLY_KEEP, APPLY_SKIP to selected rows |
| **Summary Modal** | Before apply: "You are updating 45 stores. Proceed?" |
| **Per-Row Override** | Click to edit individual row even after bulk selection |

### 3.3 Import Semantics (Locked)

| Topic | Decision |
|-------|----------|
| Import truth-set | Partial update (missing stores unaffected; never deactivate) |
| Match behavior | Conflict requiring explicit action (Keep/Update/Skip) |
| Bulk apply | ALLOWED: user can bulk-apply UPDATE/KEEP to selected conflicts |

---

## 4. Region/District Management

### 4.1 Geography List View

**Route**: `/admin/geography`

| Component | Description |
|-----------|-------------|
| **Tree View** | Collapsible: Region → District → Territory |
| **Store Counts** | Badge showing stores per node |
| **Add Button** | Add region/district/territory at each level |
| **Edit/Delete** | Inline actions per node |
| **Reassign Modal** | When deleting, prompt to reassign stores |

### 4.2 Add/Edit Region Modal

| Field | Type | Validation |
|-------|------|------------|
| Name | Text | Required, max 100 chars |
| Code | Text | Required, unique, max 10 chars |
| Parent | Select | For district/territory only |

---

## 5. Store Groups

### 5.1 Groups List View

**Route**: `/admin/store-groups`

| Component | Description |
|-----------|-------------|
| **Group Cards** | Name, description, store count, created by |
| **Create Button** | Opens create modal |
| **Edit/Delete** | Per-group actions |

### 5.2 Group Detail View

**Route**: `/admin/store-groups/:groupId`

| Section | Components |
|---------|------------|
| **Header** | Group name, description, Edit button |
| **Member Stores** | Table with store info, Remove button |
| **Add Stores** | Search/filter panel to add stores |
| **Used In** | List of campaigns using this group |

---

## 6. Audit & Safety

| Requirement | Implementation |
|-------------|----------------|
| Bulk apply audit | `audit_event` records: selection criteria, row IDs, action |
| Per-store audit | UPDATE_EXISTING produces before/after snapshots |
| Hard deletion | Never occurs via import |
| Verification tasks | Created for critical field changes on active campaigns |

---

## 7. Acceptance Criteria

1. **Onboarding**: Brand admin can complete setup flow in < 5 minutes
2. **Import**: Can import 1000+ stores via CSV without timeout
3. **Conflicts**: Bulk apply allows resolving 100+ conflicts efficiently
4. **Geography**: Tree view displays 3-level hierarchy correctly
5. **Groups**: Stores can belong to multiple groups
6. **Audit**: All changes logged with actor and timestamp

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| v0.4 | 2025-12-17 | Locked import semantics and bulk-apply controls |
| v0.5 | 2025-12-18 | Added conflict resolution UX |
| v0.6 | 2025-12-18 | Added full screen specs, wireframe reference, component details |

---

*End of SUPP-036*
