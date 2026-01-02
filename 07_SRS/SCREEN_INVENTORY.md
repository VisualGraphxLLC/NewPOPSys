# NewPOPSys v1 - Comprehensive Screen & Interface Inventory

> **Version:** 1.0
> **Last Updated:** 2025-12-30
> **Status:** Development Plan Artifact
> **Sprint Target:** Beta End Q1 | Budget: $150,000

---

## Executive Summary

This document provides a complete inventory of all screens, modals, dialogs, and transitions across the NewPOPSys v1 platform. It serves as the definitive reference for development, testing, and integration work.

### Platform Statistics

| Application | Documented Screens | Additional Screens | Modals/Dialogs | Total Interfaces |
|-------------|-------------------|-------------------|----------------|------------------|
| **Authentication** | 1 (L01) | 0 | 4 | 5 |
| Mobile App | 8 (M01-M08) | 0 | 12 | 20 |
| Brand Admin Portal | 7 (B01-B07) | 5 (Settings) | 18 | 30 |
| Store Manager Portal | 5 (S01-S05) | 0 | 8 | 13 |
| PSP Operations Portal | 3 (P01-P03) | 1 (Batches) | 9 | 13 |
| **TOTAL** | **24** | **6** | **51** | **81** |

---

## Table of Contents

0. [Authentication Screens (L01)](#0-authentication-screens)
1. [Mobile App Screens (M01-M08)](#1-mobile-app-screens)
2. [Brand Admin Portal (B01-B07 + Settings)](#2-brand-admin-portal)
3. [Store Manager Portal (S01-S05)](#3-store-manager-portal)
4. [PSP Operations Portal (P01-P03 + Batches)](#4-psp-operations-portal)
5. [Cross-Application Navigation](#5-cross-application-navigation)
6. [Modal & Dialog Catalog](#6-modal-dialog-catalog)
7. [API Endpoint Summary](#7-api-endpoint-summary)
8. [Persona Access Matrix](#8-persona-access-matrix)
9. [Gap Analysis](#9-gap-analysis)

---

## 0. Authentication Screens

### Screen Inventory Table

| ID | Screen Name | Route | Primary Entity | Apps Served |
|----|-------------|-------|----------------|-------------|
| L01 | Universal Login | `/login` | User, Session | Brand Admin, Store Portal, PSP Operations, Regional Dashboard |

### Authentication Navigation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     L01 UNIVERSAL LOGIN                          │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │                    Entry Points                          │  │
│   │   • Direct URL: /login                                   │  │
│   │   • Session expired redirect                             │  │
│   │   • Logout redirect                                      │  │
│   └─────────────────────────────────────────────────────────┘  │
│                            │                                    │
│                            ▼                                    │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │              Authentication Flow                         │  │
│   │                                                          │  │
│   │   Email + Password ─┬─▶ [MFA Required?] ─┬─▶ MFA Modal  │  │
│   │                     │                    │               │  │
│   │   SSO Button ───────┼─▶ SSO Domain ──────┤               │  │
│   │                     │   Entry Modal      │               │  │
│   │                     │                    │               │  │
│   │   Forgot Password ──┼─▶ Reset Modal      │               │  │
│   │                     │                    │               │  │
│   └─────────────────────┼────────────────────┼───────────────┘  │
│                         │                    │                   │
│                         ▼                    ▼                   │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │              Role-Based Routing                          │  │
│   │                                                          │  │
│   │   TENANT_ADMIN ──────────▶ /psp/dashboard (P01)         │  │
│   │   TENANT_OPERATIONS ─────▶ /psp/orders (P01)            │  │
│   │   BRAND_ADMIN ───────────▶ /admin/dashboard (B01)       │  │
│   │   BRAND_REGIONAL ────────▶ /admin/regional              │  │
│   │   STORE_MANAGER ─────────▶ /store/dashboard (S01)       │  │
│   │   STORE_USER ────────────▶ /store/campaigns (S02)       │  │
│   │                                                          │  │
│   │   [Multi-Role User?] ────▶ Role Switcher Modal          │  │
│   └─────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Authentication Screen Details

#### L01 - Universal Login
- **SUPP Reference:** SUPP-003 (RBAC), SUPP-001 (Personas)
- **Components:** Logo, Email input, Password input, Remember Me checkbox, Sign In button, Forgot Password link, SSO button
- **Modals:** MFA Modal, Forgot Password Modal, SSO Domain Entry Modal, Role Switcher Modal
- **Security:** Rate limiting (5 failed attempts → 15 min lockout), CSRF protection, HttpOnly/Secure cookies, bcrypt hashing, 24hr session (30 days with Remember Me)
- **API Endpoints:**
  - `POST /auth/login` - Authenticate with email/password
  - `POST /auth/logout` - Terminate session
  - `POST /auth/mfa/verify` - Verify MFA code
  - `POST /auth/password/reset-request` - Request password reset
  - `POST /auth/password/reset` - Set new password
  - `POST /auth/sso/init` - Initiate SSO flow
  - `POST /auth/sso/callback` - Handle SSO response
  - `GET /auth/session` - Get current session info
  - `POST /auth/refresh` - Refresh JWT token

### Role Priority for Routing

When a user has multiple roles, the system routes to the highest-priority dashboard:

| Priority | Role | Route |
|----------|------|-------|
| 1 | TENANT_ADMIN | `/psp/dashboard` |
| 2 | TENANT_OPERATIONS | `/psp/orders` |
| 3 | BRAND_ADMIN | `/admin/dashboard` |
| 4 | BRAND_REGIONAL | `/admin/regional` |
| 5 | STORE_MANAGER | `/store/dashboard` |
| 6 | STORE_USER | `/store/campaigns` |

---

## 1. Mobile App Screens

### Screen Inventory Table

| ID | Screen Name | Route | Primary Entity | Entry Points | Exit Points |
|----|-------------|-------|----------------|--------------|-------------|
| M01 | Login | `/app/login` | User | App launch | M02 |
| M02 | Dashboard | `/app/dashboard` | Campaign | M01, M03-M08 | M03, M04, M06, M07, M08 |
| M03 | Receipt Survey | `/app/campaign/:id/receipt` | AssignmentItem | M02, M06, Notification | M04, M02 |
| M04 | Install Survey | `/app/campaign/:id/install` | PhotoUpload | M03, M06 | M05, M06, M02 |
| M05 | Photo Capture | `/app/camera` (modal) | PhotoUpload | M04, M08 | Parent screen |
| M06 | Tasks List | `/app/tasks` | Task (aggregated) | M02, M07 | M03, M04, M08, M01 |
| M07 | Profile | `/app/profile` | User | M02, M06 | M02, M01 |
| M08 | Retake Flow | `/app/campaign/:id/retake` | PhotoUpload | M02, M06, Notification | M05, M02 |

### Mobile Navigation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      M01 LOGIN                              │
│                         │                                   │
│                         ▼                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │               M02 DASHBOARD                          │  │
│  │     ┌─────────┬─────────┬─────────┬─────────┐       │  │
│  │     │         │         │         │         │       │  │
│  │     ▼         ▼         ▼         ▼         ▼       │  │
│  │   M03      M04       M06       M07       M08        │  │
│  │  Receipt  Install   Tasks    Profile   Retake       │  │
│  │  Survey   Survey    List               Flow         │  │
│  │     │         │         │                │          │  │
│  │     │    ┌────┤         │                │          │  │
│  │     │    ▼    │         │                │          │  │
│  │     │  M05    │         │                │          │  │
│  │     │  Photo  │         │                │          │  │
│  │     │  Camera │         │                │          │  │
│  │     │    │    │         │                │          │  │
│  │     ▼    ▼    ▼         │                │          │  │
│  │   M04 ◄──────┘         │                │          │  │
│  │     │                   │                │          │  │
│  │     └───────────────────┴────────────────┘          │  │
│  │                  ▼                                   │  │
│  │           Attestation → M02                         │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Mobile Screen Details

#### M01 - Login
- **SUPP Reference:** SUPP-036
- **Fields:** Store Number (pattern: `STR-\d{3,6}`), PIN (4-6 digits, masked)
- **Security:** Rate limiting 5 attempts/15min, 8hr session timeout
- **API:** `POST /auth/login`

#### M02 - Dashboard
- **SUPP Reference:** SUPP-017
- **Components:** Campaign cards with phase indicators, Notification badges
- **Phase Routing:** READY_TO_RECEIVE→M03, READY_TO_INSTALL→M04, NEEDS_ATTENTION→M08
- **API:** `GET /stores/{storeId}/assignments?status=active`, `GET /notifications?unread=true`

#### M03 - Receipt Survey
- **SUPP Reference:** SUPP-015, SUPP-017
- **Modal:** Issue Modal (bottom sheet) - Report missing/damaged items
- **Fields:** Item checkboxes, Issue type radio, Qty affected, Description, Photo
- **API:** `GET /assignments/{id}/items?stage=receipt`, `POST /issue-requests`, `POST /assignments/{id}/complete-receipt`
- **Offline:** Item checks queued, issues saved locally

#### M04 - Install Survey
- **SUPP Reference:** SUPP-015, SUPP-017
- **Modal:** Computed Field Override Modal
- **Fields:** Photo capture button, Survey text/number/select/multi-select fields
- **API:** `GET /assignments/{id}/items?stage=install`, `POST /photos`, `PUT /survey-responses/{assignmentItemId}`
- **Offline:** Photos queued, field changes saved locally

#### M05 - Photo Capture
- **SUPP Reference:** SUPP-037
- **Modal:** Review Modal (full-size with quality warnings)
- **Features:** Ghost image overlay (50% opacity), Flash toggle, Gallery access
- **API:** `GET /photo-rules/{ruleId}`, `POST /photos`, `PATCH /photos/{id}/confirm`
- **Metadata:** captured_at, device_model, gps coordinates, file_size, resolution

#### M06 - Tasks List
- **SUPP Reference:** SUPP-017
- **Modal:** Attestation Modal - Certification checkbox, Signature canvas
- **Task Types:** RECEIPT (📦), INSTALL (🔧), RETAKE (📷), ISSUE_UPDATE (ℹ️)
- **API:** `GET /stores/{storeId}/tasks`, `POST /assignments/{id}/submit`

#### M07 - Profile
- **SUPP Reference:** SUPP-036
- **Modals:** Edit Profile Modal, Change PIN Flow (3-step), Logout Confirmation
- **Fields:** Name, Phone (editable), Email (readonly), PIN change, Notification toggles, Theme
- **API:** `PATCH /users/me`, `POST /auth/verify-pin`, `PATCH /users/me/pin`, `PATCH /users/me/preferences`

#### M08 - Retake Flow
- **SUPP Reference:** SUPP-018, SUPP-037
- **Navigation:** Deep link support `newpopsys://app/campaign/{campaignId}/retake?items={ids}`
- **Rejection Reasons:** WRONG_ANGLE, TOO_DARK, BLURRY, WRONG_ITEM, INCOMPLETE, OBSTRUCTED, OTHER
- **API:** `GET /assignments/{id}/photos?status=REJECTED`, `POST /photos`, `PATCH /photos/{oldId}/supersede`

---

## 2. Brand Admin Portal

### Screen Inventory Table

| ID | Screen Name | Route | Primary Entity | Persona |
|----|-------------|-------|----------------|---------|
| B01 | Dashboard | `/admin/dashboard` | Dashboard | Brand Admin |
| B02 | Campaign List | `/admin/campaigns` | Campaign | Brand Admin |
| B03 | Store Selection | `/admin/campaigns/create/stores` | Store | Brand Admin |
| B04 | Kit Definition | `/admin/campaigns/:id/edit/kit` | Kit | Brand Admin |
| B05 | Campaign Review | `/admin/campaigns/:id/edit/review` | Campaign | Brand Admin |
| B06 | Store List | `/admin/stores` | Store | Brand Admin |
| B07 | Verification Queue | `/admin/verification` | PhotoUpload | Brand Admin |
| SET-1 | Settings Hub | `/admin/settings` | - | Brand Admin |
| SET-2 | User Management | `/admin/settings/users` | User | Brand Admin |
| SET-3 | Notifications | `/admin/settings/notifications` | Preferences | Brand Admin |
| SET-4 | Export History | `/admin/settings/export-history` | Export | Brand Admin |
| SET-5 | Audit Log | `/admin/settings/audit-log` | AuditEvent | Brand Admin |

### Campaign Wizard Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                   CAMPAIGN CREATION WIZARD                      │
│                                                                 │
│   B02 Campaign List                                            │
│         │                                                       │
│         │ [+ Create Campaign]                                   │
│         ▼                                                       │
│   ┌─────────────────┐                                          │
│   │ B03 STEP 1      │                                          │
│   │ Store Selection │                                          │
│   │                 │                                          │
│   │ • Campaign Name │                                          │
│   │ • Include/Excl  │                                          │
│   │ • Store Preview │                                          │
│   └────────┬────────┘                                          │
│            │ [Next]                                             │
│            ▼                                                    │
│   ┌─────────────────┐                                          │
│   │ B04 STEP 2      │                                          │
│   │ Kit Definition  │                                          │
│   │                 │                                          │
│   │ • Item Library  │                                          │
│   │ • Kit Canvas    │                                          │
│   │ • Photo Rules   │                                          │
│   └────────┬────────┘                                          │
│            │ [Next]                                             │
│            ▼                                                    │
│   ┌─────────────────┐     ┌─────────────────┐                  │
│   │ B05 STEP 3      │────▶│ B02 Campaign    │                  │
│   │ Review & Launch │     │ List (PUBLISHED)│                  │
│   │                 │     └─────────────────┘                  │
│   │ • Summary       │                                          │
│   │ • Timeline      │     [Save Draft]                         │
│   │ • Validation    │────▶ B02 (DRAFT)                         │
│   └─────────────────┘                                          │
└─────────────────────────────────────────────────────────────────┘
```

### Settings Hub Navigation

```
┌─────────────────────────────────────────────────────────────────┐
│                    SETTINGS HUB (SET-1)                         │
│                                                                 │
│   ┌─────────────────┐  ┌─────────────────┐                     │
│   │ User Management │  │ Notifications   │                     │
│   │     (SET-2)     │  │    (SET-3)      │                     │
│   │                 │  │                 │                     │
│   │ • User Table    │  │ • Email Toggles │                     │
│   │ • Invite Modal  │  │ • In-App Toggle │                     │
│   │ • Role Badges   │  │ • Digest Freq   │                     │
│   └─────────────────┘  └─────────────────┘                     │
│                                                                 │
│   ┌─────────────────┐  ┌─────────────────┐                     │
│   │ Export History  │  │ Audit Log       │                     │
│   │     (SET-4)     │  │    (SET-5)      │                     │
│   │                 │  │                 │                     │
│   │ • Job Table     │  │ • Event Table   │                     │
│   │ • Download      │  │ • Action Filter │                     │
│   │ • New Export    │  │ • Date Range    │                     │
│   └─────────────────┘  └─────────────────┘                     │
└─────────────────────────────────────────────────────────────────┘
```

### Brand Admin Screen Details

#### B01 - Dashboard
- **Components:** 4 KPI cards, Active campaigns table, Store phase chart, Alerts panel
- **Quick Actions:** New Campaign, Review Photos, View All Stores, Export
- **API:** `GET /brands/{brandId}/dashboard`

#### B02 - Campaign List
- **Status Badges:** DRAFT (gray), SCHEDULED (blue), PUBLISHED (green), COMPLETED (purple), CANCELLED (red), ARCHIVED (muted)
- **Actions:** View, Edit, Duplicate, Publish, Complete, Archive, Export
- **API:** `GET /campaigns?brand_id={id}&page=1`, `POST /campaigns/{id}/duplicate`

#### B03 - Store Selection (Wizard Step 1)
- **Components:** Base set toggle, Include/Exclude panels, Preview counter, Map view (optional)
- **Validation:** Campaign name required, at least 1 store selected
- **API:** `GET /stores/summary`, `POST /stores/preview`

#### B04 - Kit Definition (Wizard Step 2)
- **Modal:** Add Custom Item Modal (Name, Type, Description)
- **Components:** Item Library sidebar, Kit Canvas drop zone, Item cards with config
- **Location Slots:** FRONT_WINDOW, END_CAP_A, END_CAP_B, CHECKOUT, ENTRY_DOOR, BACK_WALL
- **API:** `GET /item-templates`, `GET /photo-rules`, `PUT /campaigns/{id}/kit`

#### B05 - Campaign Review (Wizard Step 3)
- **Modals:** Publish confirmation, Schedule date picker
- **Validation:** Start date >= today+1, End date >= start+7 days
- **API:** `POST /campaigns/{id}/validate`, `POST /campaigns/{id}/publish`, `POST /campaigns/{id}/schedule`

#### B06 - Store List
- **Features:** Bulk actions (Change Region, Add/Remove Group, Set Status)
- **Filters:** Search, Region, District, Status, Store Group
- **API:** `GET /stores?brand_id={id}&page=1`, `PATCH /stores/bulk`

#### B07 - Verification Queue
- **Modals:** Lightbox (full image + ghost comparison), Rejection Modal (reason + comment)
- **Rejection Reasons:** WRONG_ANGLE, TOO_DARK, BLURRY, WRONG_ITEM, INCOMPLETE, OBSTRUCTED, OTHER
- **API:** `GET /photos?review_status=PENDING`, `POST /photos/{id}/review`, `POST /photos/bulk-review`

---

## 3. Store Manager Portal

### Screen Inventory Table

| ID | Screen Name | Route | Primary Entity | Persona Access |
|----|-------------|-------|----------------|----------------|
| S01 | Dashboard | `/store/dashboard` | Dashboard | Manager, User |
| S02 | Campaign History | `/store/campaigns` | Assignment | Manager, User |
| S03 | Photo Gallery | `/store/photos` | PhotoUpload | Manager, User |
| S04 | Team Management | `/store/team` | Membership | Manager only |
| S05 | Reports | `/store/reports` | Analytics | Manager only |

### Store Portal Navigation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    STORE MANAGER PORTAL                         │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │                    S01 DASHBOARD                         │  │
│   │   ┌─────────┬─────────┬─────────┬─────────┐             │  │
│   │   │ Active  │ Pending │Completed│Compliance│             │  │
│   │   │Campaigns│ Actions │   This  │   Rate   │             │  │
│   │   │   (4)   │   (7)   │  Month  │   92%    │             │  │
│   │   └─────────┴─────────┴─────────┴─────────┘             │  │
│   │                                                          │  │
│   │   Quick Links:                                           │  │
│   │   ├─▶ S02 Campaign History                               │  │
│   │   ├─▶ S03 Photo Gallery                                  │  │
│   │   ├─▶ S04 Team Management (Manager only)                 │  │
│   │   └─▶ S05 Reports (Manager only)                         │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                 │
│   ┌──────────────────────┐    ┌──────────────────────┐        │
│   │   S02 CAMPAIGNS      │    │   S03 PHOTO GALLERY  │        │
│   │                      │    │                      │        │
│   │ • Search/Filter      │    │ • Filter by status   │        │
│   │ • Status tabs        │    │ • Grid/List view     │        │
│   │ • Expandable detail  │    │ • Lightbox viewer    │        │
│   │ • Export options     │────▶ • Rejection details │        │
│   └──────────────────────┘    └──────────────────────┘        │
│                                                                 │
│   ┌──────────────────────┐    ┌──────────────────────┐        │
│   │   S04 TEAM MGMT      │    │   S05 REPORTS        │        │
│   │   (Manager Only)     │    │   (Manager Only)     │        │
│   │                      │    │                      │        │
│   │ • Member table       │    │ • Date range picker  │        │
│   │ • Invite modal       │    │ • KPI cards          │        │
│   │ • Edit roles         │    │ • Trend charts       │        │
│   │ • Activity summary   │    │ • Export to CSV/PDF  │        │
│   └──────────────────────┘    └──────────────────────┘        │
└─────────────────────────────────────────────────────────────────┘
```

### Store Portal Screen Details

#### S01 - Dashboard
- **SUPP Reference:** SUPP-017, SUPP-001
- **Components:** KPI cards, Campaign list, Pending actions, Recent activity, Team status (manager only)
- **API:** `GET /stores/{storeId}/dashboard`

#### S02 - Campaign History
- **SUPP Reference:** SUPP-017, SUPP-015
- **Features:** Search, Status tabs (Active/Completed/All), Expandable detail panel
- **API:** `GET /stores/{storeId}/assignments`, `GET /assignments/{id}?include=items,photos`

#### S03 - Photo Gallery
- **SUPP Reference:** SUPP-018, SUPP-037
- **Modals:** Lightbox (full image + info panel), Superseded photo viewer
- **Filters:** Campaign, Status, Date range, Item type, Uploaded by
- **API:** `GET /stores/{storeId}/photos`

#### S04 - Team Management
- **SUPP Reference:** SUPP-001, SUPP-003
- **Modals:** Invite Team Member, Edit Team Member, Confirmation dialogs
- **Validation:** Email format required, Cannot remove last manager
- **API:** `GET /stores/{storeId}/members`, `POST /stores/{storeId}/invitations`, `PATCH /memberships/{id}`

#### S05 - Reports
- **Components:** Date picker, Tab navigation (Overview/Campaigns/Photos/Team/Issues)
- **KPIs:** Compliance Rate, On-Time Rate, Photo Approval Rate, Avg Completion Time
- **Charts:** Campaign trend (line), Photo rejections (pie), Team contribution (bar)
- **API:** `GET /stores/{storeId}/reports?range=90d`, `GET /stores/{storeId}/reports/export?format=csv`

---

## 4. PSP Operations Portal

### Screen Inventory Table

| ID | Screen Name | Route | Primary Entity | SUPP Reference |
|----|-------------|-------|----------------|----------------|
| P01 | Order Queue | `/psp/orders` | StoreOrder | SUPP-016 |
| P02 | Shipments | `/psp/shipments` | Shipment | SUPP-016 |
| P03 | Issues Queue | `/psp/issues` | IssueRequest | SUPP-019 |
| P04 | Batches | `/psp/batches` | Batch | SUPP-016 |

> **Note:** P04 Batches is visible in the wireframe but lacks a detailed spec document. See [Gap Analysis](#9-gap-analysis).

### PSP Operations Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    PSP OPERATIONS PORTAL                        │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │                 FULFILLMENT WORKFLOW                     │  │
│   │                                                          │  │
│   │   Campaign        Order         Shipment      Store      │  │
│   │   Published  ──▶  Generated ──▶  Created  ──▶ Receives   │  │
│   │       │              │              │            │        │  │
│   │       ▼              ▼              ▼            ▼        │  │
│   │   [B05 Admin]   [P01 Queue]   [P02 Track]   [M03 App]   │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                 │
│   ┌──────────────────┐    ┌──────────────────┐                │
│   │  P01 ORDER QUEUE │    │  P02 SHIPMENTS   │                │
│   │                  │    │                  │                │
│   │ • Status tabs    │    │ • Create modal   │                │
│   │ • Bulk actions   │    │ • Carrier track  │                │
│   │ • Detail panel   │───▶│ • Timeline view  │                │
│   │ • Acknowledge    │    │ • Exceptions     │                │
│   └──────────────────┘    └──────────────────┘                │
│            │                        │                          │
│            │ [Issues reported]      │ [Delivery exception]     │
│            ▼                        ▼                          │
│   ┌──────────────────────────────────────────┐                │
│   │            P03 ISSUES QUEUE              │                │
│   │                                          │                │
│   │ • Triage workflow                        │                │
│   │ • Approve/Reject actions                 │                │
│   │ • Create reorder                         │                │
│   │ • Evidence photos                        │                │
│   └──────────────────────────────────────────┘                │
│                                                                 │
│   ┌──────────────────┐                                        │
│   │  P04 BATCHES     │                                        │
│   │  (Wireframe only)│                                        │
│   │                  │                                        │
│   │ • Group orders   │                                        │
│   │ • Print picks    │                                        │
│   │ • Batch ship     │                                        │
│   └──────────────────┘                                        │
└─────────────────────────────────────────────────────────────────┘
```

### PSP Screen Details

#### P01 - Order Queue
- **SUPP Reference:** SUPP-016
- **Modals:** Order Detail Side Panel, Shipment Modal
- **Status Tabs:** New, Acknowledged, All
- **Bulk Actions:** Acknowledge, Create Batch, Export, Print Pick List
- **API:** `GET /orders?status=GENERATED,ACKNOWLEDGED`, `POST /orders/acknowledge`

#### P02 - Shipments
- **SUPP Reference:** SUPP-016
- **Modals:** Create Shipment Modal (Order, Carrier, Tracking, Ship Date, Items)
- **Carriers:** UPS, FedEx, USPS, Other
- **Status Flow:** LABEL_CREATED → IN_TRANSIT → OUT_FOR_DELIVERY → DELIVERED | EXCEPTION
- **API:** `GET /shipments?include=order,store`, `POST /shipments`

#### P03 - Issues Queue
- **SUPP Reference:** SUPP-019
- **Modals:** Issue Detail Side Panel, Reject Issue Modal, Create Reorder Confirmation
- **Issue Types:** MISSING (❌), DAMAGED (🔨), WRONG_ITEM (❓), QUANTITY_SHORT (📉)
- **Status Flow:** OPEN → TRIAGED → APPROVED/REJECTED → IN_FULFILLMENT → RESOLVED
- **API:** `GET /issues?status=OPEN,TRIAGED,APPROVED,IN_FULFILLMENT`, `PATCH /issues/{id}`, `POST /reorder-requests`

#### P04 - Batches (Spec Required)
- **Wireframe Elements:** Orders navigation, Batch creation, Group operations
- **Gap Status:** Screen visible in wireframe, no spec document exists
- **Recommended Spec:** See Gap Analysis section

---

## 5. Cross-Application Navigation

### Primary User Journeys

```
STORE USER JOURNEY (Mobile)
═══════════════════════════
Login (M01) → Dashboard (M02) → Receipt Survey (M03) → Install Survey (M04)
                                                              ↓
                                              Photo Capture (M05) → Tasks (M06)
                                                                         ↓
                                                              Attestation → Complete

BRAND ADMIN JOURNEY (Web)
═════════════════════════
Login → Dashboard (B01) → Create Campaign → Store Selection (B03)
                                                    ↓
                                           Kit Definition (B04)
                                                    ↓
                                           Review & Launch (B05)
                                                    ↓
                         ┌──────────────────────────┴──────────────────────────┐
                         ▼                                                     ▼
                 Campaign List (B02)                              Verification Queue (B07)
                         │                                                     │
                         └────────────────── Store List (B06) ─────────────────┘

STORE MANAGER JOURNEY (Web)
═══════════════════════════
Login → Dashboard (S01) → Campaign History (S02) ←→ Photo Gallery (S03)
              │
              ├──→ Team Management (S04)
              └──→ Reports (S05)

PSP OPERATIONS JOURNEY (Web)
════════════════════════════
Login → Order Queue (P01) → Acknowledge → Create Shipment (P02)
              │                                    │
              │                                    ▼
              │                           Track Delivery
              │                                    │
              │                           [Exception]
              ▼                                    ▼
        Issues Queue (P03) ←─────────────────────┘
              │
              ▼
        Approve/Reject → Create Reorder → P01 (new order)
```

### Deep Link Support

| App | Deep Link Pattern | Target Screen |
|-----|-------------------|---------------|
| Mobile | `newpopsys://app/login` | M01 Login |
| Mobile | `newpopsys://app/campaign/{id}/receipt` | M03 Receipt Survey |
| Mobile | `newpopsys://app/campaign/{id}/install` | M04 Install Survey |
| Mobile | `newpopsys://app/campaign/{id}/retake?items={ids}` | M08 Retake |
| Mobile | `newpopsys://app/tasks` | M06 Tasks |

---

## 6. Modal & Dialog Catalog

### Authentication Modals (4)

| ID | Modal Name | Parent Screen | Trigger | Fields | Actions |
|----|------------|---------------|---------|--------|---------|
| L-MOD-01 | MFA Modal | L01 | 202 MFA Required response | 6-digit code, Trust device checkbox | Cancel, Verify |
| L-MOD-02 | Forgot Password | L01 | "Forgot password?" link | Email address | Cancel, Send Reset Link |
| L-MOD-03 | SSO Domain Entry | L01 | "Sign in with SSO" button | Company domain | Cancel, Continue |
| L-MOD-04 | Role Switcher | L01 | Multiple roles detected | Role list (radio) | Select |

### Mobile App Modals (12)

| ID | Modal Name | Parent Screen | Trigger | Fields | Actions |
|----|------------|---------------|---------|--------|---------|
| M-MOD-01 | Error Alert | M01 | Invalid login | - | Dismiss |
| M-MOD-02 | Issue Report | M03 | Tap Issue button | Type, Qty, Description, Photo | Cancel, Submit |
| M-MOD-03 | Field Override | M04 | Tap Override link | Computed value, Your value, Reason | Cancel, Apply |
| M-MOD-04 | Photo Review | M05 | After capture | Image, Warnings | Retake, Use Photo |
| M-MOD-05 | Attestation | M06 | All items complete | Summary, Checkbox, Signature | Cancel, Submit |
| M-MOD-06 | Edit Profile | M07 | Tap edit icon | Name, Phone | Cancel, Save |
| M-MOD-07 | Change PIN Step 1 | M07 | Tap Change PIN | Current PIN | Next |
| M-MOD-08 | Change PIN Step 2 | M07 | Step 1 valid | New PIN | Next |
| M-MOD-09 | Change PIN Step 3 | M07 | Step 2 valid | Confirm PIN | Cancel, Save |
| M-MOD-10 | Logout Confirm | M07 | Tap Logout | - | Cancel, Logout |
| M-MOD-11 | Sync Warning | M03, M04 | Offline submit | - | OK |
| M-MOD-12 | Quality Warning | M05 | Low quality photo | - | Retake, Use Anyway |

### Brand Admin Modals (18)

| ID | Modal Name | Parent Screen | Trigger | Fields | Actions |
|----|------------|---------------|---------|--------|---------|
| B-MOD-01 | Archive Confirm | B02 | Archive action | - | Cancel, Archive |
| B-MOD-02 | Duplicate Confirm | B02 | Duplicate action | - | Cancel, Duplicate |
| B-MOD-03 | Store Map | B03 | Map view toggle | - | Close |
| B-MOD-04 | Add Custom Item | B04 | + Custom button | Name, Type, Description | Cancel, Add |
| B-MOD-05 | Publish Confirm | B05 | Publish button | Warning text | Cancel, Publish |
| B-MOD-06 | Schedule Date | B05 | Schedule button | Date picker | Cancel, Schedule |
| B-MOD-07 | Store Detail | B06 | Row click | Info, Campaigns, Activity | Close |
| B-MOD-08 | Photo Lightbox | B07 | Thumbnail click | Image, Ghost toggle | Prev, Next, Approve, Reject |
| B-MOD-09 | Rejection Reason | B07 | Reject button | Reason radio, Comment | Cancel, Submit |
| B-MOD-10 | Invite User | SET-2 | Invite button | Email, Name, Role | Cancel, Invite |
| B-MOD-11 | Edit User | SET-2 | Row click | Role, Status | Remove, Save |
| B-MOD-12 | New Export | SET-4 | New Export button | Type, Filters | Cancel, Start |
| B-MOD-13 | Export Error | SET-4 | View Error button | Error details | Close |
| B-MOD-14 | Filter Panel | B06, B07 | Filter button | Various filters | Apply, Clear |
| B-MOD-15 | Bulk Action Confirm | B06, B07 | Bulk action | Count, Action | Cancel, Confirm |
| B-MOD-16 | Campaign Detail | B02 | Row click | Campaign info | Close, Edit |
| B-MOD-17 | Validation Warning | B05 | Validation issues | Warning list | Close |
| B-MOD-18 | Date Range Picker | SET-5 | Filter button | Start/End date | Cancel, Apply |

### Store Portal Modals (8)

| ID | Modal Name | Parent Screen | Trigger | Fields | Actions |
|----|------------|---------------|---------|--------|---------|
| S-MOD-01 | Campaign Detail | S01 | Continue button | Campaign info | Close |
| S-MOD-02 | Campaign Expand | S02 | Row click | Detail panel | Collapse |
| S-MOD-03 | Export Options | S02 | Export button | Format radio | Cancel, Export |
| S-MOD-04 | Photo Lightbox | S03 | Thumbnail click | Image, Info panel | Prev, Next, Close |
| S-MOD-05 | Invite Member | S04 | Invite button | Email, Role, Message | Cancel, Send |
| S-MOD-06 | Edit Member | S04 | Row click | Role, Status | Remove, Save |
| S-MOD-07 | Remove Confirm | S04 | Remove button | - | Cancel, Remove |
| S-MOD-08 | Export Format | S05 | Export button | Format dropdown | Cancel, Export |

### PSP Operations Modals (9)

| ID | Modal Name | Parent Screen | Trigger | Fields | Actions |
|----|------------|---------------|---------|--------|---------|
| P-MOD-01 | Order Detail | P01 | Row click | Order info, Items | Acknowledge, Ship |
| P-MOD-02 | Bulk Acknowledge | P01 | Bulk action | Count | Cancel, Acknowledge |
| P-MOD-03 | Create Shipment | P02 | + Create button | Order, Carrier, Tracking, Date, Items | Cancel, Create |
| P-MOD-04 | Shipment Detail | P02 | Row click | Tracking, Items, Timeline | Close |
| P-MOD-05 | Issue Detail | P03 | Row click | Issue info, Evidence | Reject, Approve |
| P-MOD-06 | Reject Issue | P03 | Reject button | Reason radio, Explanation | Cancel, Reject |
| P-MOD-07 | Request Info | P03 | Request Info button | Message | Cancel, Send |
| P-MOD-08 | Create Reorder | P03 | Create Reorder button | Quantity confirm | Cancel, Create |
| P-MOD-09 | Print Pick List | P01 | Print button | - | Cancel, Print |

---

## 7. API Endpoint Summary

### Authentication Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| POST | `/auth/login` | M01, L01 | User authentication (mobile PIN or web password) |
| POST | `/auth/logout` | L01 | Terminate session |
| POST | `/auth/mfa/verify` | L01 | Verify MFA TOTP code |
| POST | `/auth/password/reset-request` | L01 | Request password reset email |
| POST | `/auth/password/reset` | L01 | Set new password with token |
| POST | `/auth/sso/init` | L01 | Initiate SSO flow (SAML/OIDC) |
| POST | `/auth/sso/callback` | L01 | Handle SSO provider response |
| GET | `/auth/session` | L01 | Get current session info |
| POST | `/auth/refresh` | L01 | Refresh JWT token |
| POST | `/auth/verify-pin` | M07 | Verify current PIN (mobile) |

### User Management Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/users/me` | M07 | Get current user profile |
| PATCH | `/users/me` | M07 | Update profile |
| PATCH | `/users/me/pin` | M07 | Change PIN |
| PATCH | `/users/me/preferences` | M07, SET-3 | Update notification preferences |
| GET | `/users?brand_id={id}` | SET-2 | List brand users |
| POST | `/users/invite` | SET-2 | Send invitation |
| PATCH | `/users/{id}` | SET-2 | Update user |

### Store Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/stores/{id}/dashboard` | M02, S01 | Dashboard data |
| GET | `/stores/{id}/assignments` | M02, S02 | Campaign assignments |
| GET | `/stores/{id}/tasks` | M06 | Aggregated tasks |
| GET | `/stores/{id}/photos` | S03 | Photo gallery |
| GET | `/stores/{id}/members` | S04 | Team members |
| POST | `/stores/{id}/invitations` | S04 | Send invitation |
| GET | `/stores/{id}/reports` | S05 | Report data |
| GET | `/stores?brand_id={id}` | B06 | Store list |
| GET | `/stores/summary` | B03 | Store counts |
| POST | `/stores/preview` | B03 | Preview store selection |
| PATCH | `/stores/bulk` | B06 | Bulk update |

### Campaign Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/brands/{id}/dashboard` | B01 | Brand dashboard |
| GET | `/campaigns?brand_id={id}` | B02 | Campaign list |
| GET | `/campaigns/{id}` | B02, B05 | Campaign detail |
| POST | `/campaigns` | B03 | Create campaign |
| PATCH | `/campaigns/{id}` | B02, B04, B05 | Update campaign |
| PUT | `/campaigns/{id}/kit` | B04 | Save kit |
| POST | `/campaigns/{id}/validate` | B05 | Validate before publish |
| POST | `/campaigns/{id}/publish` | B05 | Publish campaign |
| POST | `/campaigns/{id}/schedule` | B05 | Schedule publish |
| POST | `/campaigns/{id}/duplicate` | B02 | Duplicate campaign |

### Assignment Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/assignments/{id}/items` | M03, M04 | Assignment items |
| GET | `/assignments/{id}/photos` | M04 | Assignment photos |
| POST | `/assignments/{id}/complete-receipt` | M03 | Complete receipt |
| POST | `/assignments/{id}/submit` | M06 | Submit attestation |
| PATCH | `/assignment-items/{id}` | M03 | Update item status |

### Photo Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| POST | `/photos` | M04, M05, M08 | Upload photo |
| PATCH | `/photos/{id}/confirm` | M05, M08 | Confirm upload |
| PATCH | `/photos/{id}/supersede` | M08 | Mark as superseded |
| GET | `/photos?review_status=PENDING` | B07 | Pending photos |
| POST | `/photos/{id}/review` | B07 | Review photo |
| POST | `/photos/bulk-review` | B07 | Bulk review |
| GET | `/photo-rules/{id}` | M05 | Photo rules |

### Order & Fulfillment Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/orders` | P01 | Order queue |
| GET | `/orders/{id}` | P01 | Order detail |
| POST | `/orders/acknowledge` | P01 | Acknowledge orders |
| GET | `/shipments` | P02 | Shipment list |
| POST | `/shipments` | P02 | Create shipment |
| GET | `/issues` | P03 | Issue queue |
| PATCH | `/issues/{id}` | P03 | Update issue |
| POST | `/reorder-requests` | P03 | Create reorder |
| POST | `/issue-requests` | M03 | Report issue |

### Reference Data Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/regions` | B03, B06 | Region list |
| GET | `/store-groups` | B03 | Store groups |
| GET | `/item-templates` | B04 | Item library |
| GET | `/location-slots` | B04 | Slot definitions |
| GET | `/notifications` | M02 | Notifications |

### Reporting & Export Endpoints
| Method | Endpoint | Screen(s) | Description |
|--------|----------|-----------|-------------|
| GET | `/exports` | SET-4 | Export history |
| POST | `/exports` | SET-4 | Create export |
| GET | `/exports/{id}/download` | SET-4 | Download file |
| GET | `/audit-log` | SET-5 | Audit events |

---

## 8. Persona Access Matrix

### Role Definitions

| Role | Code | Primary App | Description |
|------|------|-------------|-------------|
| Platform Admin | PLATFORM_ADMIN | All | System administrator |
| PSP Admin | PSP_ADMIN | PSP Portal | PSP management |
| PSP Operator | PSP_OPS | PSP Portal | Fulfillment operations |
| Brand Admin | BRAND_ADMIN | Brand Portal | Brand management |
| Campaign Manager | CAMPAIGN_MANAGER | Brand Portal | Campaign operations |
| Regional Manager | REGIONAL_MANAGER | Store Portal | Multi-store oversight |
| Store Manager | STORE_MANAGER | Store/Mobile | Store-level management |
| Store Operator | STORE_OPERATOR | Mobile | Store execution |

### Screen Access by Role

| Screen | PLATFORM_ADMIN | PSP_OPS | BRAND_ADMIN | STORE_MANAGER | STORE_OPERATOR |
|--------|----------------|---------|-------------|---------------|----------------|
| **Mobile App** |
| M01 Login | - | - | - | ✓ | ✓ |
| M02 Dashboard | - | - | - | ✓ | ✓ |
| M03 Receipt Survey | - | - | - | ✓ | ✓ |
| M04 Install Survey | - | - | - | ✓ | ✓ |
| M05 Photo Capture | - | - | - | ✓ | ✓ |
| M06 Tasks | - | - | - | ✓ | ✓ |
| M07 Profile | - | - | - | ✓ | ✓ |
| M08 Retake | - | - | - | ✓ | ✓ |
| **Brand Admin** |
| B01 Dashboard | ✓ | - | ✓ | - | - |
| B02 Campaign List | ✓ | - | ✓ | - | - |
| B03 Store Selection | ✓ | - | ✓ | - | - |
| B04 Kit Definition | ✓ | - | ✓ | - | - |
| B05 Campaign Review | ✓ | - | ✓ | - | - |
| B06 Store List | ✓ | - | ✓ | View | - |
| B07 Verification | ✓ | - | ✓ | - | - |
| SET-1 Settings Hub | ✓ | - | ✓ | - | - |
| SET-2 User Mgmt | ✓ | - | ✓ | - | - |
| SET-3 Notifications | ✓ | - | ✓ | - | - |
| SET-4 Export History | ✓ | - | ✓ | - | - |
| SET-5 Audit Log | ✓ | - | ✓ | - | - |
| **Store Portal** |
| S01 Dashboard | - | - | - | ✓ | ✓ |
| S02 Campaign History | - | - | - | ✓ | ✓ |
| S03 Photo Gallery | - | - | - | ✓ | ✓ |
| S04 Team Mgmt | - | - | - | ✓ | - |
| S05 Reports | - | - | - | ✓ | - |
| **PSP Portal** |
| P01 Order Queue | ✓ | ✓ | - | - | - |
| P02 Shipments | ✓ | ✓ | - | - | - |
| P03 Issues | ✓ | ✓ | - | - | - |
| P04 Batches | ✓ | ✓ | - | - | - |

---

## 9. Gap Analysis

### Identified Gaps

#### Gap 1: P04 Batches Screen Spec Missing

**Status:** 🔴 Spec document required

**Evidence:**
- Wireframe `psp_ops.html` shows "Batches" in navigation
- No `P04_Batches.md` file exists in `06_Screen_Specs/`

**Recommended Spec Content:**
```markdown
# P04 - Batch Management

**Route:** `/psp/batches`
**SUPP Reference:** SUPP-016 (PSP Fulfillment)

## Purpose
Group multiple orders for efficient bulk processing, picking, and shipping.

## Components
- Batch list with status (OPEN, PICKING, SHIPPED, CLOSED)
- Create Batch modal (select orders by criteria)
- Batch detail panel (orders in batch, pick list)
- Print pick list action
- Bulk ship action

## API Endpoints
- GET /batches - List batches
- POST /batches - Create batch
- POST /batches/{id}/pick-list - Generate pick list
- POST /batches/{id}/ship - Ship all orders in batch
```

#### Gap 2: Survey Builder Screen Missing

**Status:** 🟡 Deferred (Beta scope?)

**Evidence:**
- SUPP-037 references Survey Builder
- No B-series screen spec for survey/template management

**Recommendation:** Add to Phase 2 or document as admin-only database configuration for Beta.

#### Gap 3: Webhook Management UI Missing

**Status:** 🟡 May be admin-only

**Evidence:**
- Multiple SUPP docs reference webhooks
- No screen for webhook configuration

**Recommendation:** Document if admin-only backend configuration or add Settings sub-screen.

### Wireframe vs Spec Alignment

| Wireframe Element | Spec Status | Action Required |
|-------------------|-------------|-----------------|
| admin_portal.html Settings nav | ✅ Documented in ADMIN_PORTAL_NEW_SCREENS.md | None |
| psp_ops.html Batches nav | ❌ No spec | Create P04_Batches.md |
| mobile_app.html Retake screen | ✅ M08 spec exists | None |
| store_portal.html Team nav | ✅ S04 spec exists | None |

### Data Model Gaps

| Entity | Spec Reference | Table Status |
|--------|----------------|--------------|
| RepeatableSection | SUPP-014 | In 12_missing_tables.sql |
| ResponseEditAudit | SUPP-014 | In 12_missing_tables.sql |
| PhotoLink | SUPP-014, SUPP-017 | In 12_missing_tables.sql |
| StoreChangeVerification | SUPP-013 | In 12_missing_tables.sql |
| StoreIdAlias | SUPP-013 | In 12_missing_tables.sql |
| CompletionSubmission | SUPP-002 | In 12_missing_tables.sql |

---

## Appendix A: File References

### Screen Spec Files

```
06_Screen_Specs/
├── 00_SCREEN_INDEX.md       # Master index
├── L01_Universal_Login.md   # Universal Login (Web Portals)
├── M01_Login.md             # Mobile Login
├── M02_Dashboard.md         # Mobile Dashboard
├── M03_Receipt_Survey.md    # Receipt Survey
├── M04_Install_Survey.md    # Install Survey
├── M05_Photo_Capture.md     # Photo Capture
├── M06_Tasks.md             # Tasks List
├── M07_Profile.md           # Profile
├── M08_Retake.md            # Retake Flow
├── B01_Dashboard.md         # Brand Dashboard
├── B02_Campaign_List.md     # Campaign List
├── B03_Store_Selection.md   # Store Selection
├── B04_Kit_Definition.md    # Kit Definition
├── B05_Campaign_Review.md   # Campaign Review
├── B06_Store_List.md        # Store List
├── B07_Verification.md      # Photo Verification
├── S01_Dashboard.md         # Store Dashboard
├── S02_Campaign_History.md  # Campaign History
├── S03_Photo_Gallery.md     # Photo Gallery
├── S04_Team_Management.md   # Team Management
├── S05_Reports.md           # Reports
├── P01_Order_Queue.md       # Order Queue
├── P02_Shipments.md         # Shipments
└── P03_Issues.md            # Issues Queue
```

### Wireframe Files

```
05_Wireframes/
├── login.html                    # Universal Login wireframe (4 modals)
├── admin_portal.html             # Brand Admin wireframe
├── mobile_app.html               # Mobile App wireframe
├── store_portal.html             # Store Portal wireframe
├── psp_ops.html                  # PSP Operations wireframe
└── ADMIN_PORTAL_NEW_SCREENS.md   # Settings screens documentation
```

---

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-30 | Claude Code | Initial comprehensive inventory |
| 1.1 | 2025-12-30 | Claude Code | Added L01 Universal Login (Section 0), 4 auth modals, 9 auth endpoints, file refs |
