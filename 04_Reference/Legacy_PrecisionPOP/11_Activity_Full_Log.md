# Page 11: Activity Log - Full View

## Page Overview
- **URL**: `/dashboard/store/7610#!/activity` (expanded via "View More")
- **Purpose**: Complete chronological activity history for the store
- **User Role**: Store Manager

## Screenshot Reference
- **File**: Activity_-_Full_Log.pdf

---

## Page Description

The Activity Log Full View provides a comprehensive, paginated view of all store activity. This expanded view is accessed by clicking "View More" from the dashboard Activity widget. It shows the complete history of kit orders, installations, receipts, and promotions with search and filtering capabilities.

---

## Component Breakdown

### Header Section
- **Page Title**: "Activity Log 119" (store number appended)
- Standard PrecisionPOP navigation

### Search & Filter Bar
| Element | Description |
|---------|-------------|
| Search Activity | Text input field for searching activity entries |
| Clear Search Text | Red button to reset search filter |
| Helper Text | "Search by name, type, or status. (Example: 'Installed' will show only installed activity.)" |

### Activity Timeline
Chronological list grouped by date with calendar icons:

**Sample Entries Visible:**
| Date | Activity |
|------|----------|
| TODAY | Good2Go Store Manager Store #119 received a kit from **Rewards2Go 2025** |
| WEDNESDAY, SEPTEMBER 10, 2025 | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| FRIDAY, SEPTEMBER 05, 2025 | Dustin Lee ordered kit items from **Tackle the Season 2025** (119) |
| FRIDAY, SEPTEMBER 05, 2025 | Dustin Lee ordered kit items from **Tackle the Season 2025** (119) |
| FRIDAY, SEPTEMBER 05, 2025 | Dustin Lee installed a kit from **Tackle the Season 2025** |
| MONDAY, AUGUST 04, 2025 | Dustin Lee ordered a promotion for 119 |
| MONDAY, AUGUST 04, 2025 | Dustin Lee ordered a promotion for 119 |
| MONDAY, JULY 28, 2025 | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| THURSDAY, JULY 10, 2025 | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| MONDAY, MAY 19, 2025 | Dustin Lee ordered a promotion for 119 |
| MONDAY, MAY 19, 2025 | Dustin Lee ordered a promotion for 119 |
| MONDAY, APRIL 07, 2025 | Dustin Lee ordered a promotion for 119 |
| MONDAY, APRIL 07, 2025 | Dustin Lee ordered a promotion for 119 |
| THURSDAY, JANUARY 23, 2025 | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| THURSDAY, JANUARY 23, 2025 | Good2Go Store Manager Store #119 installed a kit from **Rewards2Go 2025 Part 2** |
| THURSDAY, JANUARY 02, 2025 | Good2Go Store Manager Store #119 received a kit from **Rewards2Go 2025** |
| FRIDAY, DECEMBER 20, 2024 | Good2Go Store Manager Store #119 ordered a promotion for 119 |
| WEDNESDAY, NOVEMBER 06, 2024 | Good2Go Store Manager Store #119 installed a kit from **Give a Smile 2024** |
| WEDNESDAY, NOVEMBER 06, 2024 | Good2Go Store Manager Store #119 received a kit from **Give a Smile 2024** |
| WEDNESDAY, NOVEMBER 06, 2024 | Good2Go Store Manager Store #119 received a kit from **Give a Smile 2024** |

### Pagination Controls
- **Page indicator**: "Page 1 of 5, showing 20 out of 100 total."
- **Page buttons**: 1, 2, 3, >, >> (numbered + next + last)

### Activity Types Observed
1. **Received a kit from [Kit Name]** - Kit delivery confirmed
2. **Ordered a promotion for [Store#]** - New promotion ordered
3. **Ordered kit items from [Kit Name]** - Reorder placed
4. **Installed a kit from [Kit Name]** - Installation confirmed

### User Attribution
- "Good2Go Store Manager Store #119" - Store manager account
- "Dustin Lee" - Individual user (possibly corporate/regional)

---

## UX Observations

### Strengths
1. **Searchable** - Can filter by name, type, or status
2. **Date grouping** - Clear chronological organization
3. **Pagination** - Handles large data sets (100 entries)
4. **User attribution** - Shows who performed each action
5. **Clickable links** - Kit names link to detail pages

### Areas for Improvement
1. **Duplicate entries** - Multiple identical entries on same dates (Sept 5, Aug 4, May 19, April 7, Nov 6)
   - May indicate system issue or intentional per-item logging
2. **No date range filter** - Can't filter to specific time periods
3. **No activity type filter** - Only free text search, no dropdown for "Installed", "Received", etc.
4. **No export option** - Can't download activity log
5. **Sparse entry details** - "ordered a promotion for 119" doesn't say which promotion
6. **No timestamps** - Only dates shown, not specific times
7. **Dense layout** - Long list could benefit from alternating row colors

### Accessibility Notes
- Calendar icons provide visual date grouping
- Links appear to have proper styling
- Pagination buttons could use better ARIA labels

---

## Related Pages
- Dashboard Activity widget (abbreviated view)
- Kit Detail pages (linked from kit names)
- Store Profile

---

## Data Elements
- Activity entries with: date, user, action type, related kit/promotion, store number
- Pagination metadata (page, total, count)
- Search query parameter

---

## Technical Notes
- Total of 100 activity entries for this store
- 20 entries per page (5 pages total)
- Search appears to be text-based filter
- Duplicate entries may need investigation for data integrity
