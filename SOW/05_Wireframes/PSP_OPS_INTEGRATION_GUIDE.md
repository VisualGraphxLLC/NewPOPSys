# PSP Operations Wireframe Enhancement Guide

## Overview
This guide explains how to integrate the enhancements made to `psp_ops.html` for the NewPOPSys project.

## Enhancements Made

### 1. Batch Management (NEW - Medium Priority)
- **Location**: New view `view-batches`
- **Features**:
  - Batch queue view with status filters (Open, Picking, Packed, Shipped)
  - Create batch from selected orders
  - Batch detail cards showing progress and metrics
  - Print batch manifest/packing slips
  - Batch status workflow visualization

### 2. Enhanced Order List (Upgraded from Basic)
- **Location**: Existing `view-orders` enhanced
- **New Features**:
  - Advanced filter bar (Status, Date Range, Campaign, Store search)
  - Bulk action controls (select all, assign to batch, update status, print labels)
  - Additional table columns (Date, Campaign)
  - Checkbox selection for multi-select
  - Improved action buttons

### 3. Order Detail Modal (NEW)
- **Location**: New modal `order-detail-modal`
- **Features**:
  - Full order information display
  - Shipping address section
  - Line items table with kit breakdown
  - Order notes
  - Order timeline visualization
  - Kit component information

### 4. Enhanced Shipment Tracking (Upgraded from Basic)
- **Location**: New view `view-shipments-enhanced`
- **New Features**:
  - Status filter tabs
  - Timeline visualization for each shipment
  - Carrier integration display
  - Delivery status updates with progress indicators
  - Exception handling (delayed, failed delivery)
  - Proof of delivery section
  - Real-time status updates
  - Contact carrier and notify store actions

## Files Created

1. **psp_ops_enhancements.html** - Contains all new HTML sections
2. **psp_ops_new_functions.js** - Contains all new JavaScript functions
3. **PSP_OPS_INTEGRATION_GUIDE.md** - This file
4. **psp_ops_backup.html** - Backup of original file

## Integration Steps

### Step 1: Add Navigation Link
Already completed - "Batches" link added to navigation

### Step 2: Add Order List Enhancements
- Replace the simple order table with the enhanced version including:
  - Advanced filters bar
  - Bulk actions bar
  - Additional table columns
  - Checkbox selectors

### Step 3: Add Batch Management View
- Insert the new `view-batches` section from `psp_ops_enhancements.html`
- Place after the issues view and before the closing div

### Step 4: Add Order Detail Modal
- Insert the `order-detail-modal` section before the closing `</body>` tag
- Ensure it's outside the main content container for proper overlay

### Step 5: Replace Shipments View
- Either replace the existing `view-shipments` or add `view-shipments-enhanced`
- Update navigation to point to the enhanced version

### Step 6: Add JavaScript Functions
- Copy all functions from `psp_ops_new_functions.js`
- Add to the existing `<script>` section before the closing `</script>` tag
- Update the `nav()` function call to include batches support

## Tooltip Pattern
All new elements follow the existing yellow outline pattern:
- Yellow (#eab308) dashed outline when tooltips enabled
- Comprehensive tooltip text with sections:
  - Feature name with emoji
  - Separator line (━━━)
  - Data fields
  - Dependencies/Actions
  - SUPP reference

## Visual Consistency
- Tailwind CSS classes used throughout
- Lucide icons for all icons
- Consistent color scheme:
  - Indigo for primary actions
  - Green for success/delivered
  - Blue for in-progress
  - Orange/Yellow for pending
  - Red for errors/exceptions
  - Purple for packed status

## Key Interactions

### Batch Management
- Click "Create New Batch" to start new batch
- Filter by status to see specific batch stages
- "View Details" opens batch detail modal
- "Print Manifest" generates pick list PDF
- Status buttons move batch through workflow

### Enhanced Order List
- Use filters to narrow down order list
- Select multiple orders with checkboxes
- Click bulk action buttons to perform actions on selected
- Click order row to open detail modal
- Sort by clicking column headers

### Order Detail Modal
- Shows complete order information
- Line items with kit breakdown
- Timeline shows order progression
- Close button or backdrop click to dismiss

### Shipment Tracking
- Timeline visualization shows delivery progress
- Real-time status from carrier API
- Exception handling for delays
- Proof of delivery for completed shipments
- Action buttons to contact carrier or notify store

## Data References (from SUPPs)

### SUPP-016 (Orders, Shipments, Batches)
- StoreOrder entity with orderNumber, type, status
- OrderLine for line items
- Shipment entity with carrier, tracking
- ShipmentLine for partial shipments
- Batch support via optional batchLabel field

### SUPP-019 (Issues & Reorders)
- IssueRequest triggers reorders
- REORDER type orders in queue
- Evidence photos for damaged items

## Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- ES6+ JavaScript
- CSS Grid and Flexbox support required
- No IE11 support needed

## Testing Checklist
- [ ] Batch Management view loads and displays correctly
- [ ] Order list filters work
- [ ] Bulk selection and actions functional
- [ ] Order detail modal opens and closes properly
- [ ] Enhanced shipment tracking displays timelines
- [ ] All tooltips display on hover (when enabled)
- [ ] Navigation between views works smoothly
- [ ] Icons render properly (Lucide)
- [ ] Responsive layout on different screen sizes

## Future Enhancements
- Real carrier API integration
- Live tracking updates via WebSocket
- Batch optimization algorithms
- Mobile-responsive improvements
- Print functionality implementation
- Photo viewer for POD images
