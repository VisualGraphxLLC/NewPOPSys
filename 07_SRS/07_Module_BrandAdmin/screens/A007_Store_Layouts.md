# Screen: A007 - Store Layouts

> **Module:** BrandAdmin
> **Route:** `/admin/layouts`
> **Status:** Wireframe
> **Priority:** P1

## 1. Description
The Store Layout Explorer (A007) is the verified "Layout Primary" interface. It allows Brand Administrators and PSP Operators to define the physical reality of stores before any logic is bound to them. It supports complex store environments via a **Zone/Floor Selector**, enabling distinct layouts for different areas (e.g., Gas Station Interior vs. Pump Area, Multi-story Malls).

## 2. Key Features
-   **Grid Graphics Builder**: Visual tool for drawing walls, zones, and placing fixtures.
-   **Zone/Floor Selector**: Dropdown to switch between "Main Floor", "Exterior", etc.
-   **Survey Binding**: Link physical slots to verification questions (e.g., "Hotspot Capture").
-   **Ghost Nodes**: View master layout elements defined by PSP.

## 3. UI Components
-   **Toolbar**: Tools for Select, Pan, Draw Wall, Draw Zone. Grid snap controls.
-   **Zone Selector**: Dropdown [Main Floor | Exterior | Level 2 | + Add Zone].
-   **Properties Panel**: Configuration for selected fixtures/slots, including Survey Binding.

## 4. Workflow
1.  **Define Structure**: Draw the physical layout (walls, zones) using the Grid Builder.
2.  **Define Zones**: Use the Zone Selector to model complex multi-area stores.
3.  **Place Slots**: Drag and drop fixtures (Gondolas, End Caps) into the layout.
4.  **Bind Logic**: Link these slots to Survey Questions for verification.

## 5. References
-   **Wireframe**: `05_Wireframes/Brand/layouts.html`
