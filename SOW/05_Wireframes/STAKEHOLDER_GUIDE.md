# NewPOPSys v1 — Stakeholder Guide

> **Version**: 1.0
> **Date**: 2025-12-19
> **Audience**: Project Stakeholders, Business Owners, Executive Sponsors
> **Purpose**: Executive overview of the NewPOPSys platform capabilities, user segments, and interactive wireframe guide

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [System Overview](#2-system-overview)
3. [User Segments Deep Dive](#3-user-segments-deep-dive)
   - [Brand Admin Module](#31-brand-admin-module)
   - [Store Execution Module](#32-store-execution-module)
   - [PSP Operations Module](#33-psp-operations-module)
4. [Data Flow & Relationships](#4-data-flow--relationships)
5. [Feature Matrix](#5-feature-matrix)
6. [Interactive Wireframe Guide](#6-interactive-wireframe-guide)
7. [Glossary of Key Terms](#7-glossary-of-key-terms)

---

## 1. Executive Summary

### What is NewPOPSys?

NewPOPSys (New Point-of-Purchase System) is a comprehensive platform for managing promotional material campaigns across retail store networks. It connects three key stakeholders:

| Stakeholder | Role | Primary Goal |
|-------------|------|--------------|
| **Brand** | Creates campaigns, defines kits, monitors compliance | Ensure promotional materials are installed correctly across all stores |
| **PSP (Print Service Provider)** | Fulfills orders, ships materials, handles issues | Produce and deliver materials on time with quality |
| **Store** | Receives materials, installs items, submits proof | Complete installations correctly and on schedule |

### Key Business Value

```
┌─────────────────────────────────────────────────────────────────────┐
│                        BUSINESS OUTCOMES                            │
├─────────────────────────────────────────────────────────────────────┤
│  📊 Real-time Visibility    │  Track campaign progress instantly    │
│  📷 Photo Verification      │  Prove installations with evidence    │
│  ⚡ Faster Issue Resolution │  Handle missing/damaged items quickly │
│  📈 Compliance Analytics    │  Measure on-time completion rates     │
│  🔄 Streamlined Workflow    │  Automated handoffs between parties   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. System Overview

### Platform Architecture

```
                    ┌─────────────────────────────────────┐
                    │         NewPOPSys Platform          │
                    │         (Cloud-Based SaaS)          │
                    └──────────────┬──────────────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
        ▼                          ▼                          ▼
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│  Brand Admin  │         │     Store     │         │      PSP      │
│    Portal     │         │   Execution   │         │  Operations   │
│    (Web)      │         │ (Mobile+Web)  │         │    (Web)      │
└───────────────┘         └───────────────┘         └───────────────┘
        │                          │                          │
        │                          │                          │
┌───────────────┐         ┌───────────────┐         ┌───────────────┐
│ • Campaigns   │         │ • Mobile App  │         │ • Orders      │
│ • Store Mgmt  │         │ • Web Portal  │         │ • Shipments   │
│ • Photo Review│         │ • Photos      │         │ • Issues      │
│ • Analytics   │         │ • Reports     │         │ • Reorders    │
└───────────────┘         └───────────────┘         └───────────────┘
```

### Application Summary

| Application | Users | Platform | Screens |
|-------------|-------|----------|---------|
| **Brand Admin Portal** | Brand Admin | Web Browser | 7 screens |
| **Store Mobile App** | Store User, Store Manager | iOS/Android | 8 screens |
| **Store Manager Portal** | Store Manager | Web Browser | 5 screens |
| **PSP Operations Portal** | PSP Admin, PSP Operator | Web Browser | 3 screens |
| **Total** | | | **23 screens** |

---

## 3. User Segments Deep Dive

### 3.1 Brand Admin Module

#### Who Uses It?
- **Brand Administrators** — Marketing and operations staff who create and manage promotional campaigns
- **Brand Managers** — Executives who monitor compliance and review analytics

#### Primary Responsibilities

```
┌─────────────────────────────────────────────────────────────────────┐
│                     BRAND ADMIN CAPABILITIES                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  CAMPAIGN MANAGEMENT                                                │
│  ├── Create new campaigns with target dates                        │
│  ├── Select stores using include/exclude rules                     │
│  ├── Define kits (promotional items to ship)                       │
│  ├── Assign items to installation locations (slots)                │
│  ├── Publish campaigns to trigger fulfillment                      │
│  └── Monitor real-time progress across all stores                  │
│                                                                     │
│  STORE NETWORK MANAGEMENT                                           │
│  ├── Import stores via CSV/Excel                                   │
│  ├── Organize by Region → District → Territory                     │
│  ├── Create custom store groups for targeting                      │
│  └── View store compliance history                                 │
│                                                                     │
│  PHOTO VERIFICATION                                                 │
│  ├── Review submitted installation photos                          │
│  ├── Approve photos that meet standards                            │
│  ├── Reject photos with specific feedback                          │
│  └── Track retake completion                                       │
│                                                                     │
│  ANALYTICS & REPORTING                                              │
│  ├── Dashboard with key performance indicators                     │
│  ├── Campaign completion rates                                     │
│  ├── On-time vs late analysis                                      │
│  └── Export reports                                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Key Screens

| Screen | Purpose | Key Actions |
|--------|---------|-------------|
| **Dashboard (B01)** | Program overview | View KPIs, quick actions |
| **Campaign List (B02)** | Manage all campaigns | Create, edit, archive |
| **Store Selection (B03)** | Target stores for campaign | Include/exclude by region, group |
| **Kit Definition (B04)** | Define what ships to stores | Add items, assign slots, photo rules |
| **Campaign Review (B05)** | Final check before launch | Verify, publish, schedule |
| **Store List (B06)** | Manage store network | Search, filter, bulk edit |
| **Verification Queue (B07)** | Review installation photos | Approve, reject with feedback |

#### Campaign Lifecycle

```
    ┌──────────┐      ┌───────────┐      ┌───────────┐      ┌───────────┐
    │  DRAFT   │ ───► │ SCHEDULED │ ───► │ PUBLISHED │ ───► │ COMPLETED │
    └──────────┘      └───────────┘      └───────────┘      └───────────┘
         │                  │                  │                  │
    Brand creates     Brand sets         System sends      All stores
    campaign config   future date        orders to PSP     complete
```

---

### 3.2 Store Execution Module

#### Who Uses It?
- **Store Users** — Retail employees who receive shipments and install materials
- **Store Managers** — Supervisors who oversee execution and manage their team

#### Access Methods

| Application | Users | Use Case |
|-------------|-------|----------|
| **Mobile App** | Store User, Store Manager | In-store execution: receive, install, photograph |
| **Web Portal** | Store Manager only | Desktop access: history, gallery, team, reports |

#### Primary Responsibilities

```
┌─────────────────────────────────────────────────────────────────────┐
│                     STORE EXECUTION CAPABILITIES                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  MOBILE APP (In-Store Execution)                                   │
│  ├── View active campaigns and due dates                           │
│  ├── Receive shipments and verify contents                         │
│  ├── Report missing or damaged items                               │
│  ├── Install promotional materials at designated locations         │
│  ├── Capture photos as proof of installation                       │
│  ├── Complete survey fields (if configured)                        │
│  ├── Submit with attestation and signature                         │
│  └── Handle photo retakes when requested                           │
│                                                                     │
│  WEB PORTAL (Manager Dashboard)                                     │
│  ├── View store KPIs and compliance rate                           │
│  ├── Browse campaign history and completion status                 │
│  ├── Access photo gallery with all submissions                     │
│  ├── Manage team members (invite, roles)                           │
│  └── View performance reports and trends                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Key Screens — Mobile App

| Screen | Purpose | Key Actions |
|--------|---------|-------------|
| **Login (M01)** | Authenticate | Enter store # and PIN |
| **Dashboard (M02)** | Campaign overview | See active work, notifications |
| **Receipt Survey (M03)** | Verify shipment | Confirm items, report issues |
| **Install Survey (M04)** | Document installation | Capture photos, complete fields |
| **Photo Capture (M05)** | Camera interface | Capture with ghost overlay |
| **Tasks List (M06)** | Pending actions | Attestation and submit |
| **Profile (M07)** | User settings | Notifications, change PIN |
| **Retake Flow (M08)** | Fix rejected photos | See reason, recapture |

#### Key Screens — Web Portal

| Screen | Purpose | Key Actions |
|--------|---------|-------------|
| **Dashboard (S01)** | Store overview | KPIs, pending actions, team |
| **Campaign History (S02)** | All campaigns | Filter, expand details |
| **Photo Gallery (S03)** | All photos | Filter, view, download |
| **Team Management (S04)** | Manage users | Invite, change roles |
| **Reports (S05)** | Analytics | Compliance trends, team stats |

#### Store Execution Flow

```
    ┌────────────┐     ┌────────────┐     ┌────────────┐     ┌────────────┐
    │  ASSIGNED  │ ──► │   READY    │ ──► │ IN_PROGRESS│ ──► │  SUBMITTED │
    └────────────┘     └────────────┘     └────────────┘     └────────────┘
          │                  │                  │                  │
     Campaign          Shipment           Store              Photos
     published         delivered          installing         submitted
                                                                  │
                                                                  ▼
                                                          ┌────────────┐
                                                          │  COMPLETE  │
                                                          └────────────┘
                                                                  │
                                                             All photos
                                                             approved
```

---

### 3.3 PSP Operations Module

#### Who Uses It?
- **PSP Administrators** — Manage fulfillment operations and user access
- **PSP Operators** — Process orders, manage shipments, handle issues

#### Primary Responsibilities

```
┌─────────────────────────────────────────────────────────────────────┐
│                      PSP OPERATIONS CAPABILITIES                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ORDER MANAGEMENT                                                   │
│  ├── Receive orders when campaigns are published                   │
│  ├── Acknowledge orders (confirm receipt)                          │
│  ├── Batch orders for production efficiency                        │
│  └── Track order status through fulfillment                        │
│                                                                     │
│  SHIPMENT MANAGEMENT                                                │
│  ├── Create shipments with tracking numbers                        │
│  ├── Support partial shipments (split orders)                      │
│  ├── Monitor delivery status via carrier webhooks                  │
│  └── Handle delivery exceptions                                    │
│                                                                     │
│  ISSUE RESOLUTION                                                   │
│  ├── Receive issue reports from stores                             │
│  ├── Triage and approve/reject claims                              │
│  ├── Create reorders for approved issues                           │
│  └── Track resolution to completion                                │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Key Screens

| Screen | Purpose | Key Actions |
|--------|---------|-------------|
| **Order Queue (P01)** | Incoming orders | Acknowledge, batch, ship |
| **Shipments (P02)** | Track packages | Create, monitor, handle exceptions |
| **Issues Queue (P03)** | Resolve problems | Triage, approve, create reorders |

#### PSP Fulfillment Flow

```
    ┌───────────┐     ┌──────────────┐     ┌─────────┐     ┌───────────┐
    │ GENERATED │ ──► │ ACKNOWLEDGED │ ──► │ SHIPPED │ ──► │ DELIVERED │
    └───────────┘     └──────────────┘     └─────────┘     └───────────┘
          │                  │                  │                │
     Brand publishes    PSP confirms       Package          Store
     campaign           receipt            in transit        receives
```

---

## 4. Data Flow & Relationships

### End-to-End Campaign Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          COMPLETE CAMPAIGN LIFECYCLE                         │
└─────────────────────────────────────────────────────────────────────────────┘

     BRAND                        PSP                         STORE
       │                           │                            │
       │  1. Create Campaign       │                            │
       │  2. Select Stores         │                            │
       │  3. Define Kit            │                            │
       │  4. PUBLISH ─────────────►│                            │
       │                           │                            │
       │                           │  5. Receive Orders         │
       │                           │  6. Acknowledge            │
       │                           │  7. Produce Materials      │
       │                           │  8. SHIP ─────────────────►│
       │                           │                            │
       │                           │                            │  9. Receive Shipment
       │                           │                            │ 10. Verify Contents
       │                           │◄──── (if issues) ──────────│ 11. Report Issues
       │                           │                            │
       │                           │  12. Triage Issue          │
       │                           │  13. Create Reorder        │
       │                           │  14. Ship Replacement ────►│
       │                           │                            │
       │                           │                            │ 15. Install Materials
       │                           │                            │ 16. Capture Photos
       │◄──────────────────────────────────────────────────────│ 17. SUBMIT
       │                           │                            │
       │ 18. Review Photos         │                            │
       │ 19. Approve / Reject ────────────────────────────────►│
       │                           │                            │
       │                           │                            │ 20. Retake (if rejected)
       │◄──────────────────────────────────────────────────────│ 21. Resubmit
       │                           │                            │
       │ 22. Approve ──────────────────────────────────────────►│ COMPLETE
       │                           │                            │
       ▼                           ▼                            ▼
```

### Entity Relationship Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           CORE DATA ENTITIES                                 │
└─────────────────────────────────────────────────────────────────────────────┘

                              ┌──────────┐
                              │  BRAND   │
                              └────┬─────┘
                                   │ owns
                    ┌──────────────┼──────────────┐
                    │              │              │
               ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
               │ Campaign│   │  Store  │   │   Kit   │
               └────┬────┘   └────┬────┘   └────┬────┘
                    │             │              │
                    │ assigns     │              │ contains
                    │             │              │
               ┌────▼─────────────▼────┐   ┌────▼────┐
               │   StoreAssignment     │   │ KitItem │
               │  (Campaign + Store)   │   └────┬────┘
               └────┬──────────────────┘        │
                    │                           │
                    │ generates                 │ assigned to
                    │                           │
               ┌────▼────┐              ┌──────▼──────┐
               │StoreOrder│◄────────────│AssignmentItem│
               └────┬────┘              └──────┬──────┘
                    │                          │
                    │ ships via                │ documented by
                    │                          │
               ┌────▼────┐              ┌──────▼──────┐
               │ Shipment│              │ PhotoUpload │
               └─────────┘              └──────┬──────┘
                                               │
                                               │ reviewed in
                                               │
                                        ┌──────▼──────┐
                                        │ PhotoReview │
                                        └─────────────┘
```

### Status Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       STATUS PROGRESSION BY MODULE                           │
└─────────────────────────────────────────────────────────────────────────────┘

CAMPAIGN STATUS (Brand Owns)
═══════════════════════════════════════════════════════════════════════════════
  DRAFT ──► SCHEDULED ──► PUBLISHED ──► COMPLETED ──► ARCHIVED
    │            │             │              │
    │            │             │              └── All stores complete
    │            │             └── Orders sent to PSP
    │            └── Future publish date set
    └── Being configured


STORE ASSIGNMENT STATUS (System Tracks)
═══════════════════════════════════════════════════════════════════════════════
  ASSIGNED ──► READY ──► IN_PROGRESS ──► SUBMITTED ──► COMPLETE
      │          │            │              │             │
      │          │            │              │             └── Photos approved
      │          │            │              └── Awaiting review
      │          │            └── Installing
      │          └── Shipment delivered
      └── Campaign published


ORDER STATUS (PSP Owns)
═══════════════════════════════════════════════════════════════════════════════
  GENERATED ──► ACKNOWLEDGED ──► SHIPPED ──► DELIVERED
       │              │              │            │
       │              │              │            └── Tracking confirmed
       │              │              └── Carrier picked up
       │              └── PSP confirmed receipt
       └── Campaign published


PHOTO REVIEW STATUS (Brand Owns)
═══════════════════════════════════════════════════════════════════════════════
  PENDING ──► APPROVED
      │
      └──► REJECTED ──► SUPERSEDED (when retake submitted)


ISSUE STATUS (PSP Owns)
═══════════════════════════════════════════════════════════════════════════════
  OPEN ──► TRIAGED ──► APPROVED ──► IN_FULFILLMENT ──► RESOLVED
    │          │           │               │               │
    │          │           │               │               └── Replacement delivered
    │          │           │               └── Reorder shipped
    │          │           └── Claim valid
    │          └── Under review
    └── Store reported
```

---

## 5. Feature Matrix

### Features by User Role

| Feature | Store User | Store Mgr | Brand Admin | PSP Operator |
|---------|:----------:|:---------:|:-----------:|:------------:|
| **Campaign Management** |
| Create campaign | | | ✅ | |
| View campaigns | ✅ | ✅ | ✅ | |
| Publish campaign | | | ✅ | |
| **Store Execution** |
| Receive shipments | ✅ | ✅ | | |
| Report issues | ✅ | ✅ | | |
| Install items | ✅ | ✅ | | |
| Capture photos | ✅ | ✅ | | |
| Submit attestation | ✅ | ✅ | | |
| **Photo Review** |
| View own photos | ✅ | ✅ | | |
| Approve/reject photos | | | ✅ | |
| Request retakes | | | ✅ | |
| **Team Management** |
| View own profile | ✅ | ✅ | ✅ | ✅ |
| Manage team members | | ✅ | | |
| Invite users | | ✅ | ✅ | ✅ |
| **Fulfillment** |
| View orders | | | | ✅ |
| Acknowledge orders | | | | ✅ |
| Create shipments | | | | ✅ |
| Handle issues | | | | ✅ |
| **Reporting** |
| View store reports | | ✅ | | |
| View program reports | | | ✅ | |
| Export data | | ✅ | ✅ | ✅ |

### Notification Matrix

| Event | Store User | Store Mgr | Brand Admin | PSP Operator |
|-------|:----------:|:---------:|:-----------:|:------------:|
| Shipment delivered | ✅ Push | ✅ Email + Push | | |
| Photo approved | ✅ Push | ✅ Push | | |
| Photo rejected | ✅ Push | ✅ Email + Push | | |
| Campaign reminder | ✅ Push | ✅ Email + Push | | |
| Issue reported | | | | ✅ Email |
| Issue resolved | ✅ Push | ✅ Email | | |
| New orders | | | | ✅ Email |
| Campaign published | | | ✅ Email | ✅ Email |

---

## 6. Interactive Wireframe Guide

### Accessing the Wireframes

**Location**: `SOW/05_Wireframes/index.html`

Open in any modern web browser (Chrome, Firefox, Safari, Edge). No installation required.

### Available Wireframes

| Wireframe | File | Color Theme | Primary Users |
|-----------|------|-------------|---------------|
| 📱 Store Mobile App | `store_execution.html` | Blue | Store User, Store Manager |
| 🏪 Store Manager Portal | `store_portal.html` | Teal | Store Manager |
| 🖥️ Brand Admin Portal | `admin_portal.html` | Purple | Brand Admin |
| 👷 PSP Operations | `psp_ops.html` | Yellow | PSP Operator |

### How to Navigate

1. **Hub Page**: Start at `index.html` to see all four wireframes
2. **Click Cards**: Click any wireframe card to launch that prototype
3. **Navigation Bar**: Use the top navigation to switch between screens
4. **Click Actions**: Buttons and links are interactive — click to navigate
5. **Tooltips**: Hover over elements to see explanations (where available)

### Wireframe Features

| Feature | Description |
|---------|-------------|
| **🔵 Tooltips** | Hover over elements with dotted underlines to see explanations |
| **📊 Sample Data** | Realistic mock data to understand context |
| **🔗 Navigation** | Click buttons and links to move between screens |
| **📱 Responsive** | Mobile wireframe works on narrow browser windows |

### Understanding the Tooltips

When hovering over elements, tooltips explain:

| Icon | Meaning |
|------|---------|
| 📝 | **Data Field** — What data is displayed/entered |
| ⚡ | **Action** — What happens when clicked |
| 🔗 | **Dependency** — What this feature depends on |
| 🚫 | **Blocker** — What this feature blocks |
| ℹ️ | **Info** — General explanation |

### Screen-by-Screen Guide

#### Store Mobile App (`store_execution.html`)

| Screen | What to Look For |
|--------|------------------|
| Login | Store # and PIN authentication |
| Dashboard | Campaign cards with status badges, progress bars |
| Receipt Survey | Item checklist, "Report Issue" flow |
| Install Survey | Location grouping, photo capture buttons |
| Photo Capture | Ghost image overlay concept |
| Attestation | Signature capture, submit button |

#### Store Manager Portal (`store_portal.html`)

| Screen | What to Look For |
|--------|------------------|
| Dashboard | KPI cards, active campaigns, pending actions |
| Campaigns | Status tabs, expandable rows with details |
| Photos | Grid view, status badges, filter options |
| Team | Member table, invite button, activity metrics |
| Reports | Charts placeholder, trend data, team contribution |

#### Brand Admin Portal (`admin_portal.html`)

| Screen | What to Look For |
|--------|------------------|
| Dashboard | Program KPIs, campaign table, quick actions |
| Campaigns | List with status badges, create button |
| Create → Stores | Include/exclude checkboxes, preview count |
| Create → Kit | Item cards, slot dropdowns |
| Create → Review | Summary cards, publish button |
| Stores | Table with filters, bulk actions |
| Verification | Photo grid, approve/reject buttons |

#### PSP Operations (`psp_ops.html`)

| Screen | What to Look For |
|--------|------------------|
| Orders | Queue with status tabs, acknowledge button |
| Shipments | Tracking numbers, carrier badges |
| Issues | Issue cards, triage actions |

---

## 7. Glossary of Key Terms

| Term | Definition |
|------|------------|
| **Campaign** | A promotional program with target dates and assigned stores |
| **Kit** | The collection of promotional items shipped to stores |
| **KitItem** | An individual item in a kit (poster, standee, etc.) |
| **StoreAssignment** | Links a campaign to a specific store; tracks progress |
| **LocationSlot** | A designated placement area in store (Front Window, End Cap) |
| **PhotoUpload** | Image captured as proof of installation |
| **PhotoReview** | Brand admin's evaluation of a photo (approve/reject) |
| **IssueRequest** | A reported problem (missing/damaged items) |
| **Reorder** | Replacement order created for approved issues |
| **Attestation** | Store's formal certification that installation is complete |
| **StorePhase** | Computed headline status showing where store is in process |
| **Ghost Image** | Semi-transparent overlay showing expected photo framing |

---

## Appendix: Quick Reference Cards

### For Brand Admins

```
┌─────────────────────────────────────────────────────────────────────┐
│                    BRAND ADMIN QUICK REFERENCE                       │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  TO CREATE A CAMPAIGN:                                               │
│  1. Dashboard → "New Campaign"                                       │
│  2. Enter name and dates                                             │
│  3. Select stores (include/exclude)                                  │
│  4. Define kit items and slots                                       │
│  5. Review and Publish                                               │
│                                                                      │
│  TO REVIEW PHOTOS:                                                   │
│  1. Click "Verification" in nav                                      │
│  2. Click photo to view full-size                                    │
│  3. Compare with ghost image                                         │
│  4. Approve or Reject with reason                                    │
│                                                                      │
│  KEY METRICS TO MONITOR:                                             │
│  • Active Campaigns: How many running?                               │
│  • Pending Reviews: Photos awaiting your action                      │
│  • Compliance Rate: % stores complete on time                        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### For Store Managers

```
┌─────────────────────────────────────────────────────────────────────┐
│                   STORE MANAGER QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  DAILY WORKFLOW:                                                     │
│  1. Check Dashboard for pending actions                              │
│  2. When shipment arrives → Receipt Survey                           │
│  3. Install materials at designated slots                            │
│  4. Capture photos per requirements                                  │
│  5. Submit with attestation                                          │
│                                                                      │
│  IF PHOTO REJECTED:                                                  │
│  1. Check notification for reason                                    │
│  2. Open Retake screen                                               │
│  3. Recapture following guidance                                     │
│  4. Submit new photo                                                 │
│                                                                      │
│  IF ITEMS MISSING/DAMAGED:                                           │
│  1. In Receipt Survey, tap "Report Issue"                            │
│  2. Select issue type and quantity                                   │
│  3. Add photo evidence (for damage)                                  │
│  4. Submit — replacement will ship                                   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### For PSP Operators

```
┌─────────────────────────────────────────────────────────────────────┐
│                    PSP OPERATOR QUICK REFERENCE                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  ORDER PROCESSING:                                                   │
│  1. Check Order Queue for new orders                                 │
│  2. Acknowledge to confirm receipt                                   │
│  3. Batch for production efficiency                                  │
│  4. Create Shipment with tracking                                    │
│                                                                      │
│  ISSUE HANDLING:                                                     │
│  1. Check Issues Queue for new reports                               │
│  2. Review evidence photos                                           │
│  3. Approve valid claims                                             │
│  4. Create Reorder for approved                                      │
│  5. Ship replacement                                                 │
│                                                                      │
│  KEY METRICS:                                                        │
│  • New Orders: Unacknowledged orders                                 │
│  • In Transit: Packages currently shipping                           │
│  • Open Issues: Claims awaiting triage                               │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

*End of Stakeholder Guide*

---

**Document Control**

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-19 | System | Initial creation |

**Related Documents**
- [Screen Specifications Index](../06_Screen_Specs/00_SCREEN_INDEX.md)
- [Process Flow Index](../00_Index/PROCESS_FLOW_INDEX.md)
- [Glossary](../00_Index/GLOSSARY.md)
- [Wireframes](../05_Wireframes/index.html)
