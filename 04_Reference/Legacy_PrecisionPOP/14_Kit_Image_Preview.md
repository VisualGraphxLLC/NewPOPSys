# Page 14: Kit Detail - Image Preview (Lightbox)

## Page Overview
- **URL**: `/kits/view/[kit_id]` with image modal overlay
- **Purpose**: Display enlarged product image in lightbox/modal overlay
- **User Role**: Store Manager

## Screenshot Reference
- **File**: Kits___Inventory_-_Image_Preview.pdf

---

## Page Description

This screenshot captures the image preview functionality on a kit detail page. When a user clicks on a thumbnail in the kit contents table, a lightbox modal opens displaying the product artwork at a larger size. The modal overlays the existing kit detail page (Dispense Signage 2025 visible behind).

---

## Component Breakdown

### Background Page (Dimmed)
- **Kit**: "Dispense Signage" (partial title visible)
- **Store**: STORE: 119
- Kit detail information visible but dimmed
- Timeline dates partially visible
- Kit Contents table with Bean2Cup entry visible

### Lightbox Modal
- **Overlay**: Semi-transparent dark overlay covering background
- **Image Container**: White/light background containing the artwork
- **Image Content**: Bean2Cup logo artwork
  - Purple "2" numeral design
  - Stylized coffee bean shape integrated into design
  - Clean vector graphic suitable for cut vinyl application

### Modal Behavior (Inferred)
- Click outside to close
- Possibly X button to close (not clearly visible)
- No visible navigation arrows (single image view)

---

## Image Details
- **Product**: Bean2Cup Cut Vinyl Logo
- **Part Number**: G2G-0725-DFS-02 (visible in background table)
- **Sign Type**: Logo Cut Vinyl - 3"x2.33"
- **Visual**: Purple numeral "2" with coffee bean design motif

---

## UX Observations

### Strengths
1. **Larger view** - Allows seeing artwork detail beyond small thumbnail
2. **Context preserved** - Background page shows where image came from
3. **Clean presentation** - Image displayed without clutter
4. **Quick access** - Click thumbnail to view (presumed)

### Areas for Improvement
1. **No visible close button** - Should have clear X button
2. **No image information** - Modal doesn't show item name, part number, or description
3. **No zoom controls** - Can't zoom in further on details
4. **No download option** - Can't save image locally
5. **No navigation** - Can't browse to next/previous images in kit
6. **No fullscreen option** - Can't view truly fullscreen
7. **Image size** - Appears relatively small within modal, could use more space
8. **No keyboard support** - Unknown if ESC closes modal

### Suggested Enhancements
1. Add item name and part number below image
2. Include download button for artwork reference
3. Add next/previous arrows for multi-item kits
4. Support keyboard navigation (ESC to close, arrows to navigate)
5. Add zoom/magnify functionality
6. Include dimensions and placement instructions if available

### Accessibility Notes
- Modal should trap focus
- ESC key should close modal
- Image needs descriptive alt text
- Focus should return to thumbnail after close
- Aria-modal and role="dialog" attributes needed

---

## Related Pages
- Kit Detail page (parent page)
- Other kit items (via navigation if implemented)

---

## Technical Notes
- Likely JavaScript-based lightbox library
- Image appears to be stored as PNG/SVG for vector artwork
- Modal overlay z-index implementation
- May need lazy loading for kits with many images

---

## Design Specifications

### Modal Container
- Centered on screen
- Semi-transparent black backdrop
- White/light image container

### Image Display
- Maintains aspect ratio
- Centered within container
- No visible border/frame

### Interaction
- Click thumbnail to open (presumed)
- Click outside to close (presumed)
- Scroll prevention on body when open
