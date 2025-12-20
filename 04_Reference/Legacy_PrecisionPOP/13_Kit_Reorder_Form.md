# Page 13: Kit Reorder Form (Missing Item Order)

## Page Overview
- **URL**: `/kits/reorder/[kit_id]` or similar
- **Purpose**: Allow store managers to reorder missing, damaged, or additional kit items
- **User Role**: Store Manager

## Screenshot Reference
- **File**: Kits___Inventory_-_Missing_Item.pdf (2 pages)

---

## Page Description

The Kit Reorder Form provides a streamlined interface for store managers to request replacement or additional items from a specific kit. This page is accessed via the "Click Here to Order" button on kit detail pages when items are missing or damaged. It displays all kit items with quantity selectors and reason dropdowns.

---

## Component Breakdown

### Header Section
- **Page Title**: "Reorder for: Rewards2Go 2025 (61 items) 119"
- **Date Range**: Start Date: 01-02-2025 | End Date: 03-11-2025
- Standard PrecisionPOP navigation

### Search Feature
- **Search:** text input field (top right)
- Filters the item list in real-time

### Reorder Table
**Table Columns:**
| Column | Description |
|--------|-------------|
| Quantity | Dropdown selector (0 ▼) for order quantity |
| Reason | Dropdown selector (Select...) for reorder reason |
| Part Number | Item SKU/identifier |
| Artwork | Product thumbnail image |
| Name | Full item name with type and dimensions |

### Sample Items (28 shown):

| Default Qty | Part Number | Item Name |
|-------------|-------------|-----------|
| 0 | G2G-0125-CT-01 | Rockstar Case Tucker (Case Tuckers - 8.5 x 13.5) |
| 0 | G2G-0125-CD-01 | Rockstar Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-WS-05 | Mars Share Size Window Sign (Window Sign - 23.5 x 23.5) |
| 0 | G2G-0125-PBS-01 | Mars Share Size/Snickers Pecan Wire Promo Bin Sign 2-Sided (Promo Bin Sign - 11 x 7) |
| 0 | G2G-0125-WS-06 | Coffee & Hostess Kickplate 23.5x23.5 (Window Sign - 23.5 x 23.5) |
| 0 | G2G-0125-WS-07 | Pepsi Window Sign (Window Sign - 23.5 x 23.5) |
| 0 | G2G-0125-DB-05 | Rewards2Go Door Banner (Door Banner - 23 x 6) |
| 0 | G2G-0125-CD-03 | BuzzBallz Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-CD-04 | Coca-Cola Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-CD-05 | Pepsi/Mt. Dew Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-CD-06 | Gatorade Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-CD-07 | G2G Water-Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-CD-09 | Beer Single Cooler Cling (Cooler Decal - 6 x 6) |
| 0 | G2G-0125-IS-01 | Rewards2Go Blitz Book Rockstar (Instruction Sheet - 8.5 x 11) |
| 0 | G2G-0125-POS-01 | Rewards2Go Cashier Cheat Sheet (Poster - 8.5 x 11) |
| 0 | G2G-0125-WS-02 (duplic) | Rockstar Window Sign 23.5x23.5 (Window Sign - 23.5 x 23.5) |
| 0 | G2G-0125-CDC-08 | Reign Storm Cooler Cling (Cooler Door Cling - 5 x 7) |
| 0 | G2G-0125-WS-02 | Rockstar Kickplate 23.5x23.5 (Window Sign - 23.5 x 23.5) |
| 0 | G2G-0125-DB-04 | Marlboro Save $2.30 (AZ-ID) Door Banner (Door Banner - 23 x 6) |
| 0 | G2G-0125-PT-05 | Rockstar Pump Topper 24X15 (Pump Topper (SQ-24x15) - 24 x 17.5) |
| 0 | G2G-0125-SS-01 | Mars Share Size Candy Aisle Strip (Candy Aisle Strip 1.25 x 48) |
| 0 | G2G-0125-NI-01 | Coffee & Hostess Napkin Insert Vertical (Napkin Insert - 5.5 x 10.875) |
| 0 | G2G-0125-SS-02 | Snickers Pecan R2G Candy Aisle Strips (Candy Aisle Strip 1.25 x 48) |
| 0 | G2G-0125-CPS-01 | Rockstar Cooler Price Strip (Cooler Price Strip - 4 x 1.25) |
| 0 | G2G-0125-CPS-04 | Coca-Cola Cooler Price Strip (Cooler Price Strip - 4 x 1.25) |
| 0 | G2G-0125-CPS-05 | Pepsi/Mt. Dew Cooler Price Strip (Cooler Price Strip - 4 x 1.25) |
| 0 | G2G-0125-CPS-06 | Gatorade Cooler Price Strip (Cooler Price Strip - 4 x 1.25) |
| 0 | G2G-0125-CPS-08 | Beer Singles Cooler Price Strip (Cooler Price Strip - 4 x 1.25) |

### Pagination
- "Showing 1 to 28 of 28 entries"

### Submit Section
- **"Submit reorder" button**: Red primary button at bottom left

---

## Form Fields

### Quantity Dropdown
- Default value: 0
- Allows selecting number of items to reorder
- Appears to be per-item quantity selection

### Reason Dropdown
- Default value: "Select..."
- Presumed options (not visible): Missing, Damaged, Additional, etc.
- Required field for explaining reorder request

---

## UX Observations

### Strengths
1. **Complete item listing** - Shows all kit items for easy selection
2. **Visual reference** - Thumbnails help identify correct items
3. **Reason tracking** - Dropdown captures why items need reordering
4. **Search functionality** - Can filter to find specific items
5. **Clear part numbers** - Easy to reference for support calls
6. **Kit context preserved** - Shows kit name and date range in header

### Areas for Improvement
1. **No bulk select** - Can't select all or multiple items at once
2. **Reason required per item?** - Unclear if reason is required for each item with qty > 0
3. **No quantity limits shown** - Unknown if there are max reorder quantities
4. **No cart summary** - Can't see what's selected before submitting
5. **No cost information** - If reorders have costs, they're not shown
6. **Duplicate entries** - "G2G-0125-WS-02 (duplic)" shows data quality issue
7. **Long form** - 28+ items requires scrolling, no "items with qty > 0" filter
8. **No confirmation preview** - Submit goes directly without review step

### Workflow Suggestions
1. Add "Review Order" step before final submission
2. Show running total of items selected
3. Allow filtering to show "only items I'm ordering"
4. Pre-populate common reasons based on selection patterns

### Accessibility Notes
- Form dropdowns should have associated labels
- Table rows could benefit from hover states
- Submit button should have loading state

---

## Related Pages
- Kit Detail page (source page)
- Cart (if items go to cart)
- Order confirmation
- Kit Reorders tab (history of reorders)

---

## Data Elements
- Kit ID and metadata
- Item list with: part number, name, type, dimensions, thumbnail
- Quantity per item
- Reason per item
- Store association

---

## Technical Notes
- Form appears to submit directly (not add to cart)
- 28 items shown suggests same pagination as kit detail
- Duplicate entry handling needs attention
- Date range shows kit validity period
