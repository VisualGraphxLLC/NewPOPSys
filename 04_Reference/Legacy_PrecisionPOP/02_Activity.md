# Page 2: Activity Tab

**URL:** `https://precisionpop.com/dashboard/store/7610#!/activity`

**Screenshot:** [02_activity.jpeg](./02_activity.jpeg)

---

## Description

The Activity tab displays a chronological activity log/feed showing all actions taken on this store's account. It functions as an audit trail for store managers and administrators.

---

## Page Components

### Header & Navigation
- Same header as Page 1 (PrecisionPOP logo, How To, User dropdown)
- **Activity tab** is now active (white background) in the red navigation bar

### Left Column - Activity Feed

**Header Section:**
- "Activity" title with "View More »" link (links to `/logs?store_id=7610`)
- Search bar with placeholder "Search activity"
- Helper text: "Search by name, type, or status. (Example: 'Installed' will show only installed activity.)"

**Activity Log Entries:**
Entries are grouped by date with a calendar icon, showing:

| Date | Activity |
|------|----------|
| **Wed, September 10** | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| **Fri, September 05** | Dustin Lee ordered kit items from Tackle the Season 2025 (119) |
| | Dustin Lee ordered kit items from Tackle the Season 2025 (119) |
| | Dustin Lee installed a kit from Tackle the Season 2025 |
| **Mon, August 04** | Dustin Lee ordered a promotion for 119 |
| | Dustin Lee ordered a promotion for 119 |
| **Mon, July 28** | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| **Thu, July 10** | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| **Mon, May 19** | Dustin Lee ordered a promotion for 119 |
| | Dustin Lee ordered a promotion for 119 |
| **Mon, April 07** | Dustin Lee ordered a promotion for 119 |
| | Dustin Lee ordered a promotion for 119 |

**Activity Types Observed:**
- Ordered a promotion
- Ordered kit items
- Installed a kit
- Received a kit

**Bottom:** "View More »" link for pagination

### Right Column
- Same as Page 1 (Good2Go logo + Kits & Inventory list with status badges)

---

## UX Observations

1. **Duplicate Entries:** Some activities appear twice on the same date (e.g., "Dustin Lee ordered a promotion for 119" repeated) - may need deduplication
2. **Search Functionality:** Good that search supports filtering by status (e.g., "Installed")
3. **Date Grouping:** Clean visual grouping by date with calendar icons
4. **User Attribution:** Shows who performed each action (store manager vs. named user like "Dustin Lee")
5. **Linkable Items:** Kit names and store numbers are clickable links for drill-down
6. **Pagination:** "View More" available at top and bottom for longer history

---

*Captured: December 9, 2025*
