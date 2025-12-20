# SUPP-037 — Screens — Survey Builder and Store Surveys

> **Version**: v1.0
> **Status**: Locked
> **Updated**: 2025-12-18
> **Dependencies**: SUPP-014 (Survey Builder), SUPP-017 (Store Execution)

---

## Purpose
Define the Survey Builder screens (Brand Admin) and Store Survey execution screens (Mobile App). Includes photo rules, computed fields, and override policies.

---

## Interactive Wireframes

**Brand Admin Survey Builder**: [admin_portal.html](../../05_Wireframes/admin_portal.html)
**Store Mobile App**: [mobile_app.html](../../05_Wireframes/mobile_app.html)

---

## Part A: Survey Builder (Brand Admin)

### A.1 Survey Template List

**Route**: `/admin/surveys`

| Component | Description |
|-----------|-------------|
| **Template Cards** | Name, version count, last updated, status badge |
| **Create Button** | "New Survey Template" → opens builder |
| **Filter** | Active/Archived toggle |
| **Search** | Search by name |
| **Actions** | Edit, Duplicate, Archive per template |

### A.2 Survey Builder Interface

**Route**: `/admin/surveys/:templateId/edit`

| Section | Components |
|---------|------------|
| **Header** | Template name (editable), Save Draft, Publish |
| **Canvas** | Drag-drop field arrangement |
| **Field Palette** | Available field types (left sidebar) |
| **Field Properties** | Selected field config (right sidebar) |
| **Preview** | Toggle mobile preview |
| **Version History** | View/restore previous versions |

### A.3 Available Field Types

| Type | Icon | Config Options |
|------|------|----------------|
| **Text** | 📝 | Label, placeholder, required, max length |
| **Number** | 🔢 | Label, min, max, required |
| **Select** | ☑️ | Label, options list, multi-select toggle |
| **Photo** | 📷 | Label, min/max photos, photo rule link |
| **Date** | 📅 | Label, required, date range constraints |
| **Signature** | ✍️ | Label, required |
| **Computed** | 🔣 | Formula, display label, allow_override |
| **Section** | 📂 | Header text, collapsible toggle |

### A.4 Photo Rule Configuration

**Route**: `/admin/photo-rules`

| Field | Type | Description |
|-------|------|-------------|
| Rule Name | Text | e.g., "Front Window Photo" |
| Min Photos | Number | Required minimum (default: 1) |
| Max Photos | Number | Maximum allowed (default: 5) |
| Ghost Image | File Upload | Reference overlay image |
| Instructions | Text | User-facing guidance |
| Required Flash | Toggle | Force flash on |
| Min Resolution | Number | Minimum pixels (e.g., 1024) |

### A.5 Computed Field Configuration

| Field | Type | Description |
|-------|------|-------------|
| Field Label | Text | Display name |
| Formula | Expression | e.g., `SUM(field1, field2)` |
| Allow Override | Toggle | Can store user override? |
| Override Roles | Multi-select | Who can override (Store User, Brand Admin) |

---

## Part B: Store Survey Execution (Mobile)

### B.1 Campaign Dashboard

**Route**: `/app/dashboard`

| Component | Description |
|-----------|-------------|
| **Active Campaigns** | Cards with campaign name, status, due date |
| **Status Badges** | Not Started, In Progress, Submitted, Complete |
| **Action Button** | "Start" or "Continue" per campaign |
| **Notifications** | Bell icon with unread count |

### B.2 Receipt Survey (Stage 1)

**Route**: `/app/campaign/:id/receipt`

| Component | Description |
|-----------|-------------|
| **Header** | Campaign name, "Receipt Verification" |
| **Item Checklist** | All shipped items with checkboxes |
| **Select All** | Quick action to confirm all |
| **Exception Button** | Per item: "Report Issue" |
| **Issue Modal** | Type (Missing/Damaged), description, photo upload |
| **Submit** | "All Items Received" or "Submit with Issues" |

### B.3 Install Survey (Stage 2)

**Route**: `/app/campaign/:id/install`

| Component | Description |
|-----------|-------------|
| **Progress Bar** | "3 of 5 Locations Complete" |
| **Location List** | Grouped by slot (e.g., "Front Window") |
| **Item Card** | Item name, photo requirement indicator |
| **Photo Capture** | Camera button, ghost image overlay |
| **Photo Preview** | Thumbnail grid, retake option |
| **Field Inputs** | Survey questions per item |
| **Save Draft** | Auto-save on field change |

### B.4 Photo Capture UX

| Step | Screen | Components |
|------|--------|------------|
| 1 | Camera | Viewfinder, ghost image overlay (if configured) |
| 2 | Capture | Shutter button, flash toggle |
| 3 | Review | Captured image, "Retake" or "Use Photo" |
| 4 | Upload | Progress indicator, background upload |

**Validation Indicators** (future scope, v1 placeholder):
- "Too dark" warning
- "Blurry" warning
- "Wrong orientation" warning

### B.5 Computed Fields Display

| Scenario | Display |
|----------|---------|
| Override Disabled | Read-only computed value |
| Override Enabled | Computed value + "Override" link |
| Override Active | User value shown, computed in tooltip |

### B.6 Attestation & Submit

**Route**: `/app/campaign/:id/submit`

| Component | Description |
|-----------|-------------|
| **Summary** | All locations, items, photos (expandable) |
| **Incomplete Items** | Highlighted with "Fix" action |
| **Attestation** | Checkbox: "I certify these items are installed correctly" |
| **Signature** | Canvas for signature capture |
| **Submit Button** | Disabled until attestation complete |
| **Confirmation** | Success message with submission ID |

---

## Part C: Override Policies (Locked)

### C.1 Policy Toggles (v1)

| Topic | Decision |
|-------|----------|
| Brand can disable overrides | Yes (brand setting: `allow_computed_overrides=false`) |
| Campaign override tightening | No (brand-only policy; campaign cannot tighten in v1) |
| Exports include values | Include final + computed + override metadata |

### C.2 Settings & Data Model

| Setting | Location | Effect |
|---------|----------|--------|
| `brand.settings_json.allow_computed_overrides` | Brand config | Enables/disables override UI globally |
| `field.allow_override` | Survey template | Per-field override toggle |
| User role | Membership | Must be Store Manager or Brand Admin |

### C.3 Export Contract

| Column | Description |
|--------|-------------|
| `value_final` | Final value used for reporting |
| `value_computed` | Computed value at submission time |
| `is_overridden` | Boolean flag |
| `override_value` | User-entered value (if overridden) |
| `override_user_id` | Who overrode |
| `override_timestamp` | When override occurred |
| `override_reason` | Optional reason text |

---

## Part D: Retake Workflow (Mobile)

### D.1 Retake Notification

| Component | Description |
|-----------|-------------|
| **Push/Email** | "Action Required: 2 Photos Rejected" |
| **Dashboard Badge** | Campaign shows "Retake Required" status |
| **Deep Link** | Opens directly to retake screen |

### D.2 Retake Screen

**Route**: `/app/campaign/:id/retake`

| Component | Description |
|-----------|-------------|
| **Rejected Photo** | Original photo with rejection overlay |
| **Reason** | e.g., "Wrong Angle" |
| **Admin Comment** | Additional instructions |
| **Retake Button** | Opens camera |
| **Submit** | Uploads new photo, moves to PENDING review |

---

## Part E: Offline Support

| Feature | Implementation |
|---------|----------------|
| Survey drafts | Saved to local storage |
| Photo queue | Photos queued for upload when online |
| Sync indicator | "Synced" / "Pending Upload" status |
| Conflict resolution | Server wins for metadata; photos never overwritten |

---

## Acceptance Criteria

### Survey Builder
1. Admin can create survey template with all field types
2. Photo rules can be configured and linked to fields
3. Computed fields support basic formulas
4. Override toggle works per field
5. Version history shows all published versions

### Store Surveys
1. Receipt survey shows all shipped items
2. Exception reporting creates issue request
3. Install survey groups items by location
4. Photo capture shows ghost image overlay
5. Progress bar updates in real-time
6. Attestation required before submit
7. Retake workflow shows rejection reason

### Offline
1. Survey drafts persist when app closed
2. Photos upload in background when online
3. Sync status visible to user

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| v0.8 | 2025-12-17 | Locked override policy toggles |
| v0.9 | 2025-12-18 | Added export contract, scaffold notes |
| v1.0 | 2025-12-18 | Complete rewrite with full screen specs, wireframe refs, mobile flows |

---

*End of SUPP-037*
