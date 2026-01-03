# B009 - Layout Manager

> **Module**: BrandAdmin
> **Screen ID**: B009
> **Route**: `/brand/layouts`
> **Version**: 1.0
> **Last Updated**: 2026-01-03
> **IEEE 830 Compliance**: Section 3.2 - Functional Requirements

---

## 1. Screen Overview

### 1.1 Purpose
Allows Brand Administrators to define **Store Layouts** (the physical map of marketing slots) and assign them to specific stores. This supports the "Planogram" functionality where campaigns target specific slots (e.g., "Front Window").

### 1.2 Users
- **Brand Admin**: Full access.
- **Store Manager**: (Read-only view via S007).

---

## 2. Features

### 2.1 Layout Library
- Manage the brand's repository of layout types (e.g., "Standard Mall", "Flagship Tier 1").
- **Inheritance**: Can start a new layout from a `MasterStoreLayout` provided by the PSP.

### 2.2 Layout Visual Editor (Grid Graphics Builder)
- **Interactive Grid Canvas**:
    -   **Draw Mode**: Create walls, zones (Aisles, Checkout), and structures using accurate snap-to-grid tools.
    -   **Shape Library**: Drag-and-drop standard fixtures (Gondola, Endcap, Rounder).
    -   **Dimensions**: Input real-world measurements (e.g., "4 ft width") for accurate scaling.
- **Slot Management**:
    -   **Ghost Nodes**: View "Master Slots" (from inherited Master Layout) as ghosts that must be placed/snapped onto the grid.
    -   **Properties**: Define `Width`, `Height`, `Depth` for every slot.
- **Survey Binding**: Link each slot to a specific "Hotspot Capture" question in the survey.

### 2.3 Store Assignment
- **Goal**: Map every physical store to a Layout Type.
- **Bulk Action**: Select multiple stores -> "Assign Layout: Standard Mall".
- **Coverage Report**: View % of stores with a valid layout assigned.

---

## 3. Data Requirements

### 3.1 Entities
- `StoreLayout`: The definition used by the brand.
- `LocationSlot`: The individual pins.
- `Store.layoutId`: FK to the assigned layout.

### 3.2 Key Logic
- **Campaign Validation**: When targeting a slot (e.g., "Front Window") in a campaign, the system warns if selected stores do not have that slot in their assigned layout.

---

## 4. Acceptance Criteria
1.  Admin can create a "Small Format" layout based on the PSP Master.
2.  Admin can add a custom "Countertop Spinner" slot to this layout.
3.  Admin can batch-assign this layout to all "Region: Northeast" stores.
4.  System correctly reports 100% layout coverage for that region.
