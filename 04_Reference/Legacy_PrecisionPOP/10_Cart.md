# Page 10: Promotion Cart

## Page Overview
- **URL**: `/cart` or similar cart endpoint
- **Purpose**: Shopping cart for ordering promotional items and kit replacements
- **User Role**: Store Manager

## Screenshot Reference
- **File**: Cart.pdf

---

## Page Description

The Promotion Cart page provides an e-commerce-style checkout interface for store managers to review and submit orders for promotional materials. The page displays a clean, minimal layout with an empty cart state visible in this screenshot.

---

## Component Breakdown

### Header Section
- **Page Title**: "Your Promotion Cart"
- Standard PrecisionPOP navigation header with How To dropdown and user account menu

### Import Feature
- **"Import Order from CSV" button**: Allows bulk ordering via CSV file upload
- Positioned prominently at top left below page title

### Cart Table
Empty state table with the following columns:
| Column | Description |
|--------|-------------|
| Quantity | Number of items ordered |
| Promotion | Name of the promotional kit/item |
| Part # | Part number identifier |
| Spec | Specifications/dimensions |
| Type | Sign type category |
| Store | Store number/location |

### Notes Section
- **Notes field**: Large text area for adding order notes/special instructions
- Resizable textarea with drag handle

### Action Buttons
| Button | Style | Function |
|--------|-------|----------|
| Continue Shopping | White/outline | Return to browse more items |
| Confirm and place order | Red/primary | Submit the order |

### Footer
- Standard Vivid Impact branding footer
- Social media links (Facebook, Instagram, LinkedIn, YouTube)

---

## UX Observations

### Strengths
1. **Clean, simple layout** - Easy to understand cart structure
2. **CSV import option** - Useful for bulk/repeat orders
3. **Notes field** - Allows special instructions for fulfillment
4. **Clear call-to-action** - Red "Confirm and place order" button stands out

### Areas for Improvement
1. **No empty state message** - Cart shows empty table with no helpful text like "Your cart is empty. Browse kits to add items."
2. **No item thumbnails** - Table could benefit from showing product images
3. **No price/cost information** - If orders have costs, they're not shown
4. **No quantity controls** - No visible +/- buttons for adjusting quantities
5. **No remove item option** - Individual delete buttons not visible
6. **Missing cart count in header** - While there's a cart icon in nav, the count badge (showing "0") could be more prominent
7. **No order summary** - Missing subtotal, item count summary section
8. **No save for later** - Can't save cart without placing order

### Accessibility Notes
- Form fields appear to have proper labels
- Button contrast appears adequate
- Could benefit from table headers with proper scope attributes

---

## Related Pages
- Kit Detail pages (source of items to add)
- Kit Reorder form (alternative ordering flow)
- Order confirmation (post-checkout)

---

## Data Elements
- Cart items (from session/database)
- CSV import functionality
- Order notes
- Store association

---

## Technical Notes
- Cart appears to be session-based
- CSV import suggests batch ordering workflow
- No visible validation messages in empty state
