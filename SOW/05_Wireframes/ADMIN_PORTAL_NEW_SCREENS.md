# Admin Portal - New Screens Implementation Guide

This document details the four "Known Gaps" screens that need to be added to `admin_portal.html`.

## Changes Required

### 1. Navigation Bar Update (Already Completed)

The Settings link has been added to the navigation:
- Location: Line ~139-170
- Added: Settings nav link with tooltip

```html
<a href="#" id="link-settings" onclick="nav('view-settings')"
    class="nav-link hover:text-purple-600 h-16 flex items-center has-tooltip"
    data-tooltip="⚙️ SETTINGS...">Settings</a>
```

### 2. JavaScript Navigation Update (Needs to be added)

Add these lines to the `nav()` function (around line 970):

```javascript
if (viewId === 'view-settings') linkId = 'link-settings';
if (viewId === 'view-user-management') linkId = 'link-settings';
if (viewId === 'view-notifications') linkId = 'link-settings';
if (viewId === 'view-export-history') linkId = 'link-settings';
if (viewId === 'view-audit-log') linkId = 'link-settings';
```

### 3. New View Sections (To be inserted before line 473)

Insert the following five view sections immediately before the "VIEW: CREATE CAMPAIGN WIZARD" comment:

#### 3.1 Settings Hub (view-settings)
- Grid of 4 cards linking to detail screens
- User Management (Medium priority)
- Notification Preferences (Low priority)
- Export Job History (Low priority)
- Audit Log Viewer (Low priority)

#### 3.2 User Management Screen (view-user-management)
- User list table with columns: Name, Email, Role, Status, Last Login, Actions
- Role badges: Brand Admin (purple), Store Manager (blue), Store Employee (teal)
- "Invite User" button in header
- Action buttons: Edit (purple), Deactivate (red)
- Shows 4 sample users including one with "Pending" status

#### 3.3 Notification Preferences Screen (view-notifications)
- Email Notifications section with toggle switches
- In-App Notifications section with toggles
- Digest Frequency selector (Daily/Weekly/Monthly/Never)
- Per-Campaign Notifications override list
- "Save Preferences" button in header

#### 3.4 Export Job History Screen (view-export-history)
- Table of export jobs with columns: Type, Description, Created, Status, File Size, Actions
- Status badges: Completed (green), Processing (blue), Failed (red)
- Sample data showing Campaign Report, Store Data, Photo Archive exports
- Action buttons: Download (purple), Re-run (blue), View Error (gray)
- "New Export" button in header

#### 3.5 Audit Log Viewer Screen (view-audit-log)
- Table with columns: Timestamp, User, Action, Entity, Details
- Action badges: Approve (green), Update (blue), Create (purple), Login (slate), Reject (red), Delete (yellow)
- Filter controls: Date Range picker, Filter button, Export button
- Shows 7 sample audit log entries

## Implementation Notes

- All views follow the existing pattern with `class="view hidden"`
- All tooltips use the `has-tooltip` class and `data-tooltip` attribute
- All icons use Lucide (`data-lucide="icon-name"`)
- All views include "Back to Settings" button that calls `nav('view-settings')`
- All styling matches existing Tailwind CSS patterns
- Priority badges use: orange-100/800 (Medium), gray-100/600 (Low)

## File Location

Insert location: **Line 472** (immediately before `<!-- VIEW: CREATE CAMPAIGN WIZARD (Original Content) -->`)

## Complete Code

Due to the size of the complete implementation (~600 lines), the full HTML code for all five view sections has been prepared and can be inserted programmatically or manually.

The code follows these patterns from existing views:
- View container: `<div id="view-xxx" class="view hidden">`
- Headers with back buttons and action buttons
- White card backgrounds with `rounded-xl shadow-sm border`
- Tables with `hover:bg-gray-50` rows
- Consistent spacing and typography

## Testing

After implementation:
1. Click "Settings" in navigation - should show settings hub
2. Click each card - should navigate to detail screen
3. Click "Back to Settings" - should return to hub
4. Enable tooltip mode - all elements should have informative tooltips
5. All Lucide icons should render properly

