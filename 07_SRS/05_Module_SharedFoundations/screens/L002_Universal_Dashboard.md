# L002 Universal Dashboard - SRS Specification

> **SRS Section**: 5.1.2 | **Screen ID**: L002 | **Version**: 1.0 | **Status**: Draft
> **Module**: SharedFoundations (L-series)
> **Route**: `/dashboard`
> **Source**: [L02_Universal_Dashboard.md](../../../06_Screen_Specs/L02_Universal_Dashboard.md)
> **Last Updated**: 2026-01-01

---

## 1. Screen Overview

### 1.1 Purpose

The Universal Dashboard (L002) serves as the unified dashboard shell that adapts based on user role and permissions. It provides a consistent layout framework with role-specific widgets, KPIs, quick actions, and navigation while maintaining a cohesive user experience across all portal types (Brand Admin, Store Portal, PSP Operations, Regional Dashboard).

### 1.2 Access Requirements

| Attribute | Specification |
|-----------|---------------|
| **Authentication** | Authenticated access required |
| **Pre-conditions** | Valid session token, assigned role(s) |
| **Post-conditions** | Dashboard loaded with role-appropriate widgets |
| **Served Portals** | Brand Admin, Store Portal, PSP Operations, Regional Dashboard |

### 1.3 Screenshot Reference

![Universal Dashboard](../../screenshots/Admin_Portal/admin_portal_dashboard.png)

*Figure L002-1: Universal Dashboard - Role-adaptive dashboard with KPIs, widgets, and quick actions*

### 1.4 Navigation Path

| Entry Point | Path |
|-------------|------|
| Post-login redirect | Automatic from L001 based on role |
| Direct URL | `https://{tenant}.newpopsys.com/dashboard` |
| Sidebar navigation | Home/Dashboard link |
| Logo click | Returns to dashboard from any screen |

---

## 2. User Roles & Permissions

### 2.1 Role-Based Dashboard Configurations

| Role Enum | Dashboard Variant | Primary Widgets |
|-----------|------------------|-----------------|
| `PLATFORM_ADMIN` | PSP Admin Dashboard | System health, tenant metrics, support queue |
| `PSP_ADMIN` | PSP Admin Dashboard | Tenant overview, production stats, alerts |
| `PSP_OPS` | Operations Dashboard | Order queue, production status, SLA tracker |
| `BRAND_ADMIN` | Brand Dashboard | Campaign performance, store metrics, inventory |
| `CAMPAIGN_MANAGER` | Campaign Dashboard | Active campaigns, approvals, analytics |
| `REGIONAL_MANAGER` | Regional Dashboard | Store comparison, regional KPIs, compliance |
| `STORE_MANAGER` | Store Dashboard | Daily orders, inventory alerts, staff activity |
| `STORE_OPERATOR` | Store Dashboard (Limited) | Active campaigns, order status, quick actions |

### 2.2 RBAC Permission Matrix

| Permission | PLATFORM_ADMIN | PSP_ADMIN | PSP_OPS | BRAND_ADMIN | CAMPAIGN_MGR | REGIONAL_MGR | STORE_MGR | STORE_OP |
|------------|----------------|-----------|---------|-------------|--------------|--------------|-----------|----------|
| View system widgets | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| View tenant widgets | ✓ | ✓ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| View brand widgets | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ |
| View store widgets | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Customize layout | ✓ | ✓ | ✗ | ✓ | ✓ | ✗ | ✓ | ✗ |
| Export dashboard | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| View all stores | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ |

### 2.3 Widget Visibility Rules

**REQ-L002-FR-001**: The dashboard SHALL display only widgets authorized for the user's highest-priority role.

**REQ-L002-FR-002**: Users with multiple roles SHALL see a combined widget set with appropriate permission boundaries.

---

## 3. UI Components & Layout

### 3.1 Layout Structure

**REQ-L002-UI-001**: The dashboard SHALL use a responsive grid layout with collapsible sidebar navigation.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│  [≡]  NewPOPSys Logo    Dashboard                    [🔔] [👤] User ▾ [⚙]  │
├─────────┬───────────────────────────────────────────────────────────────────┤
│         │  Welcome, {User Name}                              {Date/Time}    │
│  NAV    │  Role: {Primary Role} | Store: {Context}          [Switch ▾]     │
│  BAR    ├───────────────────────────────────────────────────────────────────┤
│         │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐  │
│ [🏠]    │  │   KPI 1     │ │   KPI 2     │ │   KPI 3     │ │   KPI 4     │  │
│ Home    │  │   Value     │ │   Value     │ │   Value     │ │   Value     │  │
│         │  │   +/-Δ%     │ │   +/-Δ%     │ │   +/-Δ%     │ │   +/-Δ%     │  │
│ [📦]    │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────┘  │
│ Orders  │  ┌────────────────────────────────┐ ┌────────────────────────────┐│
│         │  │                                │ │                            ││
│ [📊]    │  │      Chart Widget              │ │     List Widget            ││
│ Reports │  │      (Role-specific)           │ │     (Recent Activity)      ││
│         │  │                                │ │                            ││
│ [⚙️]    │  │                                │ │                            ││
│ Settings│  └────────────────────────────────┘ └────────────────────────────┘│
│         │  ┌────────────────────────────────┐ ┌────────────────────────────┐│
│ [?]     │  │    Quick Actions               │ │    Alerts/Notifications    ││
│ Help    │  │  [Action 1] [Action 2] [...]   │ │    • Alert 1               ││
│         │  │                                │ │    • Alert 2               ││
│         │  └────────────────────────────────┘ └────────────────────────────┘│
└─────────┴───────────────────────────────────────────────────────────────────┘
```

### 3.2 Responsive Breakpoints

| Breakpoint | Layout | Sidebar |
|------------|--------|---------|
| Desktop (>1200px) | 4-column grid | Expanded |
| Laptop (992-1200px) | 3-column grid | Collapsed icons |
| Tablet (768-992px) | 2-column grid | Hidden (hamburger) |
| Mobile (<768px) | 1-column stack | Hidden (hamburger) |

### 3.3 Component Specifications

#### 3.3.1 Header Bar

| Element | Description | Actions |
|---------|-------------|---------|
| Logo | Tenant/Brand logo (configurable) | Click → Dashboard home |
| Page Title | "Dashboard" | Static |
| Notifications | Bell icon with badge count | Click → Notification panel |
| User Menu | Avatar + name dropdown | Profile, Settings, Logout |
| Settings | Gear icon | Dashboard customization |

#### 3.3.2 KPI Cards

**REQ-L002-UI-002**: Each KPI card SHALL display:
- Metric label
- Current value (formatted)
- Trend indicator (↑/↓/→)
- Percentage change from comparison period
- Sparkline (optional)

#### 3.3.3 Widget Container

**REQ-L002-UI-003**: Widgets SHALL be:
- Draggable (if user has customize permission)
- Resizable within grid constraints
- Collapsible with state persistence
- Refreshable individually

---

## 4. Data Structures

### 4.1 TypeScript Interfaces

```typescript
// Dashboard Configuration
interface DashboardConfig {
  id: string;
  userId: string;
  roleId: RoleEnum;
  tenantId: string;
  layout: LayoutConfig;
  widgets: WidgetInstance[];
  preferences: DashboardPreferences;
  lastModified: Date;
}

interface LayoutConfig {
  columns: number;
  rows: number;
  gridGap: number;
  sidebarExpanded: boolean;
  sidebarPosition: 'left' | 'right';
}

interface WidgetInstance {
  id: string;
  widgetTypeId: string;
  title: string;
  position: GridPosition;
  size: GridSize;
  config: WidgetConfig;
  refreshInterval: number; // seconds, 0 = manual only
  collapsed: boolean;
  visible: boolean;
}

interface GridPosition {
  column: number;
  row: number;
}

interface GridSize {
  width: number;  // grid units
  height: number; // grid units
}

interface WidgetConfig {
  dataSource: string;
  filters?: Record<string, any>;
  chartType?: ChartType;
  displayOptions?: Record<string, any>;
}

// User Widget Preferences
interface DashboardPreferences {
  theme: 'light' | 'dark' | 'system';
  compactMode: boolean;
  autoRefresh: boolean;
  defaultDateRange: DateRangePreset;
  timezone: string;
}

// Role-based permissions
interface RolePermissions {
  roleId: RoleEnum;
  allowedWidgets: string[];
  canCustomize: boolean;
  canExport: boolean;
  dataScope: DataScopeLevel;
  maxWidgets: number;
}

type DataScopeLevel = 'system' | 'tenant' | 'brand' | 'region' | 'store';
type DateRangePreset = 'today' | 'yesterday' | 'last7days' | 'last30days' | 'thisMonth' | 'lastMonth' | 'custom';
type ChartType = 'line' | 'bar' | 'pie' | 'donut' | 'area' | 'gauge' | 'table';

enum RoleEnum {
  PLATFORM_ADMIN = 'PLATFORM_ADMIN',
  PSP_ADMIN = 'PSP_ADMIN',
  PSP_OPS = 'PSP_OPS',
  BRAND_ADMIN = 'BRAND_ADMIN',
  CAMPAIGN_MANAGER = 'CAMPAIGN_MANAGER',
  REGIONAL_MANAGER = 'REGIONAL_MANAGER',
  STORE_MANAGER = 'STORE_MANAGER',
  STORE_OPERATOR = 'STORE_OPERATOR'
}
```

### 4.2 Widget Type Registry

```typescript
interface WidgetTypeDefinition {
  id: string;
  name: string;
  description: string;
  category: WidgetCategory;
  allowedRoles: RoleEnum[];
  defaultSize: GridSize;
  minSize: GridSize;
  maxSize: GridSize;
  configSchema: JSONSchema;
  dataEndpoint: string;
}

type WidgetCategory = 'kpi' | 'chart' | 'list' | 'action' | 'alert' | 'custom';
```

---

## 5. Business Rules

### 5.1 Dashboard Loading Rules

| Rule ID | Description | Priority |
|---------|-------------|----------|
| BR-L002-001 | Dashboard SHALL load default configuration for first-time users | High |
| BR-L002-002 | Custom layouts SHALL be persisted per user per role | High |
| BR-L002-003 | Widget data SHALL refresh on configurable intervals (default: 5 min) | Medium |
| BR-L002-004 | Failed widget loads SHALL NOT block other widgets | High |
| BR-L002-005 | Dashboard SHALL cache widget data for offline resilience | Medium |

### 5.2 Widget Visibility Rules

| Rule ID | Description | Priority |
|---------|-------------|----------|
| BR-L002-006 | Widgets SHALL only display data within user's permission scope | Critical |
| BR-L002-007 | Store-level users SHALL NOT see other store's data | Critical |
| BR-L002-008 | Aggregate widgets SHALL respect data scope boundaries | Critical |
| BR-L002-009 | Hidden widgets SHALL NOT fetch data | Medium |

### 5.3 Customization Rules

| Rule ID | Description | Priority |
|---------|-------------|----------|
| BR-L002-010 | Users without customize permission see admin-defined default layout | High |
| BR-L002-011 | Custom layouts SHALL have a "Reset to Default" option | Medium |
| BR-L002-012 | Widget removal SHALL require confirmation | Low |
| BR-L002-013 | Layout changes SHALL auto-save after 2 seconds of inactivity | Medium |

---

## 6. API Specifications

### 6.1 Get Dashboard Configuration

```
GET /api/v1/dashboard/config
```

**Request Headers:**
```
Authorization: Bearer {token}
X-Tenant-ID: {tenantId}
X-Role-Context: {roleId} (optional, for multi-role users)
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "dash_abc123",
    "userId": "user_xyz",
    "roleId": "STORE_MANAGER",
    "tenantId": "tenant_123",
    "layout": {
      "columns": 4,
      "rows": 6,
      "gridGap": 16,
      "sidebarExpanded": true,
      "sidebarPosition": "left"
    },
    "widgets": [...],
    "preferences": {
      "theme": "system",
      "compactMode": false,
      "autoRefresh": true,
      "defaultDateRange": "last7days",
      "timezone": "America/New_York"
    },
    "lastModified": "2026-01-01T10:00:00Z"
  }
}
```

**Error Responses:**
| Code | Condition |
|------|-----------|
| 401 | Invalid or expired token |
| 403 | User lacks dashboard access permission |
| 404 | No configuration found (returns default) |

### 6.2 Get Widget Data

```
GET /api/v1/dashboard/widgets/{widgetId}/data
```

**Request Headers:**
```
Authorization: Bearer {token}
X-Tenant-ID: {tenantId}
```

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| dateFrom | ISO8601 | No | Start date filter |
| dateTo | ISO8601 | No | End date filter |
| storeId | string | No | Store scope filter |
| refresh | boolean | No | Force cache bypass |

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "widgetId": "widget_orders_today",
    "widgetType": "kpi",
    "value": 156,
    "previousValue": 142,
    "changePercent": 9.86,
    "trend": "up",
    "sparkline": [120, 135, 128, 142, 156],
    "lastUpdated": "2026-01-01T14:30:00Z",
    "nextRefresh": "2026-01-01T14:35:00Z"
  }
}
```

### 6.3 Save Dashboard Configuration

```
PUT /api/v1/dashboard/config
```

**Request Body:**
```json
{
  "layout": {...},
  "widgets": [...],
  "preferences": {...}
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "dash_abc123",
    "lastModified": "2026-01-01T14:35:00Z"
  }
}
```

### 6.4 Reset Dashboard to Default

```
POST /api/v1/dashboard/config/reset
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Dashboard reset to default configuration",
  "data": {...}
}
```

---

## 7. State Transitions

### 7.1 Dashboard State Machine

```
┌──────────────┐
│   LOADING    │ ──────────────────────────────────────┐
└──────┬───────┘                                       │
       │ Config loaded                                 │
       ▼                                               │
┌──────────────┐     Widget error      ┌──────────────┐
│    READY     │ ─────────────────────▶│   PARTIAL    │
└──────┬───────┘                       └──────┬───────┘
       │ User action                          │ Retry success
       ▼                                      │
┌──────────────┐                              │
│  REFRESHING  │ ◀────────────────────────────┘
└──────┬───────┘
       │ Complete
       ▼
┌──────────────┐
│    READY     │
└──────────────┘
```

### 7.2 State Definitions

| State | Description | User Actions Available |
|-------|-------------|----------------------|
| LOADING | Initial config fetch | None (spinner shown) |
| READY | All widgets loaded | All interactions |
| REFRESHING | Data refresh in progress | View only |
| PARTIAL | Some widgets failed | View working, retry failed |
| ERROR | Complete failure | Retry, contact support |

### 7.3 Widget-Level States

| State | Visual Indicator | Behavior |
|-------|------------------|----------|
| loading | Skeleton/spinner | No interaction |
| ready | Normal display | Full interaction |
| refreshing | Subtle indicator | View only |
| error | Error message + retry | Retry button |
| stale | Warning badge | Indicates old data |

---

## 8. Error Handling

### 8.1 Error Scenarios

| Error Code | Scenario | User Message | Recovery Action |
|------------|----------|--------------|-----------------|
| ERR-L002-001 | Config load failed | "Unable to load dashboard. Please refresh." | Retry button |
| ERR-L002-002 | Widget data timeout | "Widget data unavailable" | Auto-retry in 30s |
| ERR-L002-003 | Permission denied | "You don't have access to this widget" | Remove widget option |
| ERR-L002-004 | Network offline | "You're offline. Showing cached data." | Auto-reconnect |
| ERR-L002-005 | Save failed | "Unable to save changes. Retrying..." | Auto-retry 3x |
| ERR-L002-006 | Invalid widget config | "Widget configuration error" | Reset widget |

### 8.2 Error Display Patterns

**REQ-L002-ERR-001**: Widget errors SHALL be contained within the widget boundary.

**REQ-L002-ERR-002**: Global errors SHALL display in a dismissible toast notification.

**REQ-L002-ERR-003**: Critical errors SHALL display a full-page error state with recovery options.

### 8.3 Offline Behavior

**REQ-L002-ERR-004**: Dashboard SHALL:
- Cache last successful widget data
- Display stale indicator on cached data
- Queue layout changes for sync when online
- Show offline banner with connection status

---

## 9. Accessibility Requirements

### 9.1 WCAG 2.1 AA Compliance

| Requirement | Implementation |
|-------------|----------------|
| **REQ-L002-A11Y-001** | All widgets navigable via keyboard (Tab/Shift+Tab) |
| **REQ-L002-A11Y-002** | Focus indicators visible with 3:1 contrast ratio |
| **REQ-L002-A11Y-003** | Screen reader announcements for widget state changes |
| **REQ-L002-A11Y-004** | Color not sole means of conveying information |
| **REQ-L002-A11Y-005** | Minimum touch target size 44x44px |
| **REQ-L002-A11Y-006** | Motion/animation respects prefers-reduced-motion |

### 9.2 Keyboard Navigation

| Key | Action |
|-----|--------|
| Tab | Move between widgets |
| Enter | Activate widget/button |
| Space | Toggle collapse/expand |
| Arrow keys | Navigate within widget |
| Escape | Close modal/dropdown |
| Ctrl+R | Refresh current widget |

### 9.3 ARIA Attributes

```html
<section role="region" aria-label="Dashboard">
  <div role="grid" aria-label="Widget grid">
    <article role="gridcell" aria-label="Orders Today">
      <h2 id="widget-title">Orders Today</h2>
      <div aria-describedby="widget-title" aria-live="polite">
        <!-- Widget content -->
      </div>
    </article>
  </div>
</section>
```

---

## 10. Acceptance Criteria

### 10.1 Functional Acceptance

| ID | Criterion | Priority |
|----|-----------|----------|
| AC-L002-001 | Dashboard loads within 3 seconds on standard connection | High |
| AC-L002-002 | Role-appropriate widgets display based on user permissions | Critical |
| AC-L002-003 | Widget layout persists across sessions | High |
| AC-L002-004 | KPI values update in real-time when auto-refresh enabled | Medium |
| AC-L002-005 | Users can drag and resize widgets (if permitted) | Medium |
| AC-L002-006 | Dashboard functions in offline mode with cached data | Medium |
| AC-L002-007 | Error states display clearly without blocking other widgets | High |

### 10.2 Non-Functional Acceptance

| ID | Criterion | Metric |
|----|-----------|--------|
| AC-L002-008 | Initial load performance | < 3s (LCP) |
| AC-L002-009 | Widget refresh performance | < 1s per widget |
| AC-L002-010 | Memory usage | < 100MB heap |
| AC-L002-011 | Accessibility score | 100% Lighthouse |
| AC-L002-012 | Mobile responsiveness | All breakpoints functional |

### 10.3 Security Acceptance

| ID | Criterion | Priority |
|----|-----------|----------|
| AC-L002-013 | Widget data respects RBAC boundaries | Critical |
| AC-L002-014 | No cross-tenant data leakage | Critical |
| AC-L002-015 | Session timeout enforced | High |

---

## 11. Traceability Matrix

| Requirement ID | Source | BRD Ref | FRS Ref | Test Case |
|----------------|--------|---------|---------|-----------|
| REQ-L002-FR-001 | RBAC-006 | BRD-4.2.1 | FRS-5.1.2 | TC-L002-001 |
| REQ-L002-FR-002 | RBAC-007 | BRD-4.2.2 | FRS-5.1.2 | TC-L002-002 |
| REQ-L002-UI-001 | UI-STD-001 | BRD-6.1 | FRS-6.1.2 | TC-L002-010 |
| REQ-L002-UI-002 | UI-STD-002 | BRD-6.2 | FRS-6.1.2 | TC-L002-011 |
| REQ-L002-UI-003 | UI-STD-003 | BRD-6.2 | FRS-6.1.2 | TC-L002-012 |
| REQ-L002-ERR-001 | ERR-STD-001 | BRD-7.1 | FRS-7.1 | TC-L002-020 |
| REQ-L002-A11Y-001 | WCAG-2.1 | BRD-8.1 | FRS-8.1 | TC-L002-030 |

---

## 12. Cross-References

### 12.1 Related Screens

| Screen ID | Relationship | Description |
|-----------|--------------|-------------|
| L001 | Predecessor | Login redirects to dashboard |
| L003 | Navigation | User profile/settings |
| A001-A010 | Navigation | Admin module screens |
| S001-S010 | Navigation | Store module screens |
| P001-P010 | Navigation | PSP module screens |

### 12.2 Related Documents

| Document | Section | Relevance |
|----------|---------|-----------|
| BRD | 4.2 Role-Based Access | Permission definitions |
| FRS | 5.1 SharedFoundations | Module architecture |
| UI Style Guide | 3.0 Components | Widget design patterns |
| API Specification | Auth, Dashboard | Endpoint details |

### 12.3 Dependencies

| System | Dependency Type | Description |
|--------|-----------------|-------------|
| Auth Service | Runtime | Token validation, role context |
| User Service | Runtime | User preferences, profile |
| Analytics Service | Runtime | Widget data aggregation |
| Cache Service | Runtime | Widget data caching |

---

## 13. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-01-01 | System | Initial SRS specification |

---

*Document generated as part of NewPOPSys v1.38 SRS completion initiative.*
