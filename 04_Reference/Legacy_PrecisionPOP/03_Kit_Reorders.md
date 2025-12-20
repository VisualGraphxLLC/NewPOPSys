# Page 3: Kit Reorders Tab

**URL:** `https://precisionpop.com/dashboard/store/7610#!/kit_reorders`

**Screenshot:** [03_kit_reorders.jpeg](./03_kit_reorders.jpeg)

---

## Description

The Kit Reorders tab displays a table of all reorder requests made by this store for marketing kit items. This allows store managers to track their reorder history and access order details.

---

## Page Components

### Header & Navigation
- Same header as previous pages
- **Kit Reorders tab** is now active (white background)

### Left Column - Kit Reorders Table

**Table Header Columns:**
| Column | Description |
|--------|-------------|
| # | Reorder ID number |
| Order | Kit/Campaign name (clickable link) |
| Store | Store number (clickable link) |
| Date | Date and time of reorder |
| (Unnamed) | Shows "N/A" for all rows |
| (Unnamed) | "Details" button |

**Reorder History (11 records shown):**

| # | Order | Store | Date | Details |
|---|-------|-------|------|---------|
| 12205 | Tackle the Season 2025 | 119 | 09/05/2025 6:32pm | Details |
| 11419 | Tackle the Season 2024 | 119 | 09/19/2024 2:22pm | Details |
| 11241 | Fun in the Sun 2024 | 119 | 07/18/2024 8:44am | Details |
| 11004 | Free 2 Smile 2024 | 119 | 05/23/2024 6:23pm | Details |
| 11003 | Free 2 Smile 2024 | 119 | 05/23/2024 6:22pm | Details |
| 10869 | Mystery Fuel May 2024 | 119 | 05/07/2024 6:13pm | Details |
| 8852 | Catch The Fun | 119 | 09/08/2023 3:39pm | Details |
| 8569 | Cool Down | 119 | 07/26/2023 7:09am | Details |
| 8542 | Cool Down | 119 | 07/11/2023 8:52am | Details |
| 8203 | Free To Smile | 119 | 05/24/2023 12:41pm | Details |
| 8194 | Free To Smile | 119 | 05/23/2023 2:57pm | Details |

**Interactive Elements:**
- Order names link to `/Orders/view/{id}`
- Store numbers link to `/Stores/view/{id}`
- Red "Details" buttons link to `/Kits/reorder_details/{id}`

### Right Column
- Same as previous pages (Good2Go logo + Kits & Inventory list)

---

## UX Observations

1. **Unnamed Columns:** Two columns have no headers - the "N/A" column purpose is unclear, and the "Details" column should be labeled
2. **Duplicate Entries:** Some kits appear twice with timestamps a minute apart (e.g., Free 2 Smile 2024 at 6:22pm and 6:23pm) - possible duplicate submission issue
3. **N/A Values:** Every row shows "N/A" in one column - if this field is never used, consider removing it
4. **Details Button:** Prominent red buttons make it easy to access order details
5. **No Pagination:** All 11 records shown on one page - may need pagination for stores with more history
6. **No Search/Filter:** Unlike Activity tab, no search functionality here
7. **No Status Column:** Would be helpful to show order status (pending, shipped, delivered)

---

*Captured: December 9, 2025*
