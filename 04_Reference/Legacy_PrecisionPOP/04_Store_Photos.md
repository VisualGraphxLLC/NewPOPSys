# Page 4: Store Photos Tab

**URL:** `https://precisionpop.com/dashboard/store/7610#!/store_photos`

**Screenshot:** [04_store_photos.jpeg](./04_store_photos.jpeg)

---

## Description

The Store Photos tab allows store managers to upload, manage, and download photos of their store. This is likely used to document signage installations, store layouts, or compliance verification.

---

## Page Components

### Header & Navigation
- Same header as previous pages
- **Store Photos tab** is now active (white background)

### Left Column - Store Photos Management

**Action Buttons:**
| Button | Color | Function |
|--------|-------|----------|
| + Add new | Green | Upload new photos |
| ✕ Delete | Red | Delete selected photos |
| ⊕ Download | White/Gray | Download selected photos |
| ⊕ CSV | White/Gray outline | Export photo list as CSV |

**Table Structure:**
| Column | Description |
|--------|-------------|
| (Checkbox) | Select photos for bulk actions |
| Name | Photo filename |
| Date Added | Upload timestamp |
| Added By | User who uploaded |
| (Actions) | Per-row action buttons |

**Current State:** Table is empty - no photos have been uploaded for this store.

### Right Column
- Same as previous pages (Good2Go logo + Kits & Inventory list)

---

## UX Observations

1. **Empty State:** No helpful message or prompt when no photos exist - could say "No photos uploaded yet. Click '+ Add new' to upload your first photo."
2. **Action Buttons:** Good variety of bulk actions (add, delete, download, export)
3. **CSV Export:** Useful for reporting/documentation purposes
4. **Color Coding:** Green for add, red for delete follows standard conventions
5. **Table Headers:** Clean column headers, though the empty unnamed columns (checkbox and actions) could be clearer
6. **No Preview:** Would be helpful to show thumbnail previews in the table
7. **No Categories/Tags:** No apparent way to organize photos by type (exterior, interior, signage, etc.)

---

*Captured: December 9, 2025*
