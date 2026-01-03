# Persona Interaction Maps & User Journey Flows

> **Document**: Development Reference - Persona Workflows
> **Version**: 1.0
> **Date**: 2025-12-30
> **Source**: SUPP-001, SCREEN_INVENTORY.md, 12-personas-by-module.md

---

## Table of Contents

1. [Persona Definitions](#1-persona-definitions)
2. [Permission Matrix](#2-permission-matrix)
3. [Canonical Workflows](#3-canonical-workflows)
4. [Screen-to-Persona Mapping](#4-screen-to-persona-mapping)
5. [User Journey Flows](#5-user-journey-flows)
6. [Cross-Persona Interactions](#6-cross-persona-interactions)
7. [Edge Case Handling](#7-edge-case-handling)
8. [Deep Link Patterns](#8-deep-link-patterns)
9. [Sprint Implementation Guide](#9-sprint-implementation-guide)

---

## 1. Persona Definitions

### 1.1 Persona Hierarchy

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                              PLATFORM LEVEL                                  â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”‚
â”‚  â”‚  PLATFORM_ADMIN - Full system access, tenant management, security   â”‚    â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                PSP LEVEL                                     â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚     PSP_ADMIN        â”‚  â”‚   PRODUCTION_OPS     â”‚  â”‚ INTEGRATION_USERâ”‚   â”‚
â”‚  â”‚ Brand onboarding,    â”‚  â”‚ Order processing,    â”‚  â”‚ API/webhook     â”‚   â”‚
â”‚  â”‚ PSP settings, users  â”‚  â”‚ shipments, batches   â”‚  â”‚ service account â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                               BRAND LEVEL                                    â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚    BRAND_ADMIN       â”‚  â”‚  CAMPAIGN_MANAGER    â”‚  â”‚ REGIONAL_MANAGERâ”‚   â”‚
â”‚  â”‚ Full brand config,   â”‚  â”‚ Assigned campaigns,  â”‚  â”‚ Assigned stores,â”‚   â”‚
â”‚  â”‚ all campaigns        â”‚  â”‚ kits, photo rules    â”‚  â”‚ exception queue â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                               STORE LEVEL                                    â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”‚
â”‚  â”‚         STORE_MANAGER            â”‚  â”‚        STORE_OPERATOR          â”‚  â”‚
â”‚  â”‚ Team mgmt, approvals, analytics  â”‚  â”‚ Execution, surveys, requests   â”‚  â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 1.2 Complete Persona Table

| Code | Persona | Level | Primary Responsibility | Permission Level |
|------|---------|-------|------------------------|------------------|
| `PA` | Platform Admin | Platform | Full system config, tenant management, user impersonation, security & audit | All Privileged + Impersonate |
| `PSP` | PSP Admin | PSP | Brand onboarding, PSP settings, user management, reporting & exports | PSP All Privileged |
| `PO` | Production Operator | PSP | Update order statuses, shipments & tracking, batch processing, fulfillment queues | Status & Shipping Updates |
| `IU` | Integration User | System | Inbound API writes, webhook consumption, export triggers, MIS integration | API & Webhook Service Account |
| `BA` | Brand Admin | Brand | Full brand config, all campaigns, store management, user permissions | Brand Level Privileged |
| `CM` | Campaign Manager | Brand | Build campaigns, manage assigned campaigns, kits & photo rules, proof review | Must be assigned to campaigns |
| `RM` | Regional Manager | Brand | Oversee assigned stores, exception queue, approve/reject proofs, escalate | Store Compliance for segment |
| `SM` | Store Manager | Store | Manage store team, approve replacements, view all store campaigns | Full Store Privileges |
| `SO` | Store Operator | Store | Complete surveys, update status, request replacements (needs approval) | View Only + Execution |

---

## 2. Permission Matrix

### 2.1 Screen Access by Role

| Screen ID | Screen Name | PA | PSP | PO | BA | CM | RM | SM | SO |
|-----------|-------------|:--:|:---:|:--:|:--:|:--:|:--:|:--:|:--:|
| **L01** | Universal Login | âœ“ | âœ“ | âœ“ | âœ“ | âœ“ | âœ“ | âœ“ | âœ“ |
| **B01** | Brand Dashboard | âœ“ | âœ“ | - | âœ“ | âœ“ | R | - | - |
| **B02** | Campaign List | âœ“ | âœ“ | R | âœ“ | A | R | - | - |
| **B03** | Campaign Builder | âœ“ | - | - | âœ“ | A | - | - | - |
| **B04** | Store Selector | âœ“ | - | - | âœ“ | A | - | - | - |
| **B05** | Review Queue | âœ“ | âœ“ | - | âœ“ | A | A | - | - |
| **B06** | Store Detail | âœ“ | âœ“ | R | âœ“ | A | A | - | - |
| **B07** | Reports & Analytics | âœ“ | âœ“ | R | âœ“ | A | R | - | - |
| **S01** | Store Dashboard | âœ“ | âœ“ | - | âœ“ | R | âœ“ | âœ“ | - |
| **S02** | Team Management | âœ“ | âœ“ | - | âœ“ | - | - | âœ“ | - |
| **S03** | Store Analytics | âœ“ | âœ“ | - | âœ“ | R | âœ“ | âœ“ | - |
| **S04** | Campaign History | âœ“ | âœ“ | R | âœ“ | A | A | âœ“ | R |
| **P01** | PSP Order Queue | âœ“ | âœ“ | âœ“ | - | - | - | - | - |
| **P02** | Batch Manager | âœ“ | âœ“ | âœ“ | - | - | - | - | - |
| **P03** | Shipment Tracker | âœ“ | âœ“ | âœ“ | R | R | - | R | - |
| **P04** | Issue Queue | âœ“ | âœ“ | âœ“ | R | R | R | R | - |
| **P05** | Export Center | âœ“ | âœ“ | âœ“ | âœ“ | A | - | - | - |
| **M01** | Mobile Home | - | - | - | - | - | - | âœ“ | âœ“ |
| **M02** | Task List | - | - | - | - | - | - | âœ“ | âœ“ |
| **M03** | Campaign Detail | - | - | - | - | - | - | âœ“ | âœ“ |
| **M04** | Receive & Verify | - | - | - | - | - | - | âœ“ | âœ“ |
| **M05** | Install Capture | - | - | - | - | - | - | âœ“ | âœ“ |
| **M06** | Photo Gallery | - | - | - | - | - | - | âœ“ | âœ“ |
| **M07** | Issue Request | - | - | - | - | - | - | âœ“ | âœ“ |
| **M08** | Profile & Settings | - | - | - | - | - | - | âœ“ | âœ“ |

**Legend**: âœ“ = Full Access | A = Assigned Only | R = Read Only | - = No Access

### 2.2 Action Permissions

| Action | PA | PSP | PO | BA | CM | RM | SM | SO |
|--------|:--:|:---:|:--:|:--:|:--:|:--:|:--:|:--:|
| Create Campaign | âœ“ | - | - | âœ“ | A | - | - | - |
| Publish Campaign | âœ“ | - | - | âœ“ | A | - | - | - |
| Review Photos | âœ“ | âœ“ | - | âœ“ | A | A | - | - |
| Approve/Reject Photos | âœ“ | - | - | âœ“ | A | A | - | - |
| Apply Waiver | âœ“ | - | - | âœ“ | - | A | - | - |
| Force Complete | âœ“ | - | - | âœ“ | - | - | - | - |
| Process Orders | âœ“ | âœ“ | âœ“ | - | - | - | - | - |
| Create Shipments | âœ“ | âœ“ | âœ“ | - | - | - | - | - |
| Manage Batches | âœ“ | âœ“ | âœ“ | - | - | - | - | - |
| Submit Execution | - | - | - | - | - | - | âœ“ | âœ“ |
| Request Replacement | - | - | - | - | - | - | âœ“ | âœ“* |
| Approve Replacement | - | - | - | - | - | - | âœ“ | - |
| View Audit Log | âœ“ | âœ“ | R | âœ“ | - | - | - | - |
| Impersonate User | âœ“ | - | - | - | - | - | - | - |
| Manage Tenants | âœ“ | - | - | - | - | - | - | - |

**Note**: * = Requires Store Manager approval

---

## 3. Canonical Workflows

### 3.1 Production Operator Workflow (Steps 1-6)

![PERSONA_INTERACTION_MAPS_diagram_0](diagrams_rendered/PERSONA_INTERACTION_MAPS_diagram_0.png)

**Screen Flow**: P01 â†’ P02 â†’ P03 â†’ P04 â†’ P05

**Modals Used**:
- `P01-M1`: Order Details
- `P01-M2`: Bulk Status Update
- `P02-M1`: Create Batch
- `P02-M2`: Assign to Batch
- `P03-M1`: Create Shipment
- `P03-M2`: Add Tracking
- `P04-M1`: Issue Details
- `P04-M2`: Approve/Deny Issue

---

### 3.2 Brand Admin / Campaign Manager Workflow (Steps 7-12)

![PERSONA_INTERACTION_MAPS_diagram_1](diagrams_rendered/PERSONA_INTERACTION_MAPS_diagram_1.png)

**Screen Flow**: B03 â†’ B04 â†’ B01 â†’ B05 â†’ B06

**Modals Used**:
- `B03-M1`: Kit Item Editor
- `B03-M2`: Photo Rules Config
- `B03-M3`: Schedule Picker
- `B04-M1`: Region Selector
- `B04-M2`: Store Search
- `B04-M3`: Preview Stores
- `B05-M1`: Photo Review
- `B05-M2`: Rejection Reasons
- `B06-M1`: Store Actions
- `B06-M2`: Waiver Dialog

---

### 3.3 Regional Manager Workflow (Exception-First)

![PERSONA_INTERACTION_MAPS_diagram_2](diagrams_rendered/PERSONA_INTERACTION_MAPS_diagram_2.png)

**Screen Flow**: B05 (filtered) â†’ B06 â†’ Escalation

**Key Behaviors**:
- Works from exception queue filtered to assigned stores only
- Cannot access campaigns not assigned to their region
- Waiver capability limited by policy configuration
- All actions logged to audit trail

---

### 3.4 Store Execution Workflow (Steps 13-20)

![PERSONA_INTERACTION_MAPS_diagram_3](diagrams_rendered/PERSONA_INTERACTION_MAPS_diagram_3.png)

**Screen Flow**: M01 â†’ M02 â†’ M03 â†’ M04 â†’ M05 â†’ M06 â†’ M07 â†’ M08

**Modals Used**:
- `M03-M1`: Mockup Viewer
- `M03-M2`: Instructions Detail
- `M04-M1`: Item Scanner
- `M04-M2`: Anomaly Reporter
- `M05-M1`: Photo Capture
- `M05-M2`: Location Picker
- `M06-M1`: Photo Viewer
- `M06-M2`: Retake Interface
- `M07-M1`: Issue Type Selector
- `M07-M2`: Evidence Upload

---

## 4. Screen-to-Persona Mapping

### 4.1 PSP Operations Module

| Screen | Primary Users | Secondary Users | Key Actions |
|--------|---------------|-----------------|-------------|
| P01 Order Queue | PO | PSP, PA | View orders, filter by status, bulk status update |
| P02 Batch Manager | PO | PSP, PA | Create batches, assign orders, track progress |
| P03 Shipment Tracker | PO | PSP, BA (read) | Create shipments, add tracking, monitor delivery |
| P04 Issue Queue | PO | PSP, all (read) | Triage issues, approve/deny, create reorders |
| P05 Export Center | PO, PSP | BA, PA | Generate exports, download packages, schedule |

### 4.2 Brand Admin Module

| Screen | Primary Users | Secondary Users | Key Actions |
|--------|---------------|-----------------|-------------|
| B01 Dashboard | BA, CM | RM (read), PSP | Monitor KPIs, view alerts, drill-down |
| B02 Campaign List | BA, CM | RM (read), PO (read) | List campaigns, filter, access detail |
| B03 Campaign Builder | BA, CM | - | Create/edit campaigns, configure settings |
| B04 Store Selector | BA, CM | - | Select stores, preview, apply recipes |
| B05 Review Queue | BA, CM, RM | PSP | Review photos, approve/reject, retakes |
| B06 Store Detail | BA, CM, RM | PSP | View store execution, actions, history |
| B07 Reports & Analytics | BA | CM (assigned), RM (read) | Generate reports, view analytics |

### 4.3 Store Portal Module

| Screen | Primary Users | Secondary Users | Key Actions |
|--------|---------------|-----------------|-------------|
| S01 Store Dashboard | SM | BA, PSP | View store KPIs, active campaigns |
| S02 Team Management | SM | BA, PSP | Manage operators, permissions |
| S03 Store Analytics | SM | BA, RM | Performance metrics, trends |
| S04 Campaign History | SM | SO (read), BA, CM | View past campaigns, execution |

### 4.4 Mobile App Module

| Screen | Primary Users | Secondary Users | Key Actions |
|--------|---------------|-----------------|-------------|
| M01 Home | SM, SO | - | Dashboard, quick actions |
| M02 Task List | SM, SO | - | View assignments, filter |
| M03 Campaign Detail | SM, SO | - | Instructions, mockups, status |
| M04 Receive & Verify | SM, SO | - | Confirm receipt, report issues |
| M05 Install Capture | SM, SO | - | Photo capture, location tagging |
| M06 Photo Gallery | SM, SO | - | View photos, retakes |
| M07 Issue Request | SM, SO | - | Report issues, request replacements |
| M08 Profile & Settings | SM, SO | - | Account, notifications, offline |

---

## 5. User Journey Flows

### 5.1 Store User Journey (Mobile)

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                        STORE USER MOBILE JOURNEY                             â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                                              â”‚
â”‚  ðŸ“± NOTIFICATION                                                             â”‚
â”‚     â”‚                                                                        â”‚
â”‚     â–¼                                                                        â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                  â”‚
â”‚  â”‚   M01   â”‚â”€â”€â”€â–¶â”‚   M02   â”‚â”€â”€â”€â–¶â”‚   M03   â”‚â”€â”€â”€â–¶â”‚   M04   â”‚                  â”‚
â”‚  â”‚  Home   â”‚    â”‚  Tasks  â”‚    â”‚Campaign â”‚    â”‚ Receive â”‚                  â”‚
â”‚  â”‚         â”‚    â”‚         â”‚    â”‚ Detail  â”‚    â”‚ Verify  â”‚                  â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜    â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜                  â”‚
â”‚                                                     â”‚                        â”‚
â”‚                                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”      â”‚
â”‚                                    â”‚                â”‚                â”‚      â”‚
â”‚                                    â–¼                â–¼                â–¼      â”‚
â”‚                              â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”‚
â”‚                              â”‚   M05   â”‚      â”‚   M07   â”‚      â”‚   M06   â”‚  â”‚
â”‚                              â”‚ Install â”‚      â”‚  Issue  â”‚      â”‚ Gallery â”‚  â”‚
â”‚                              â”‚ Capture â”‚      â”‚ Request â”‚      â”‚         â”‚  â”‚
â”‚                              â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜      â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜      â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜  â”‚
â”‚                                   â”‚                                  â”‚      â”‚
â”‚                                   â–¼                                  â”‚      â”‚
â”‚                              â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                             â”‚      â”‚
â”‚                              â”‚Complete â”‚â—€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜      â”‚
â”‚                              â”‚ Survey  â”‚                                    â”‚
â”‚                              â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜                                    â”‚
â”‚                                   â”‚                                         â”‚
â”‚                      â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                           â”‚
â”‚                      â–¼                         â–¼                           â”‚
â”‚                 [FAST Mode]              [STRICT Mode]                     â”‚
â”‚                      â”‚                         â”‚                           â”‚
â”‚                      â–¼                         â–¼                           â”‚
â”‚                  COMPLETE              PENDING REVIEW                      â”‚
â”‚                                              â”‚                             â”‚
â”‚                                    â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”€â”€â”€â”€â”                  â”‚
â”‚                                    â–¼                   â–¼                  â”‚
â”‚                               [Approved]          [Rejected]              â”‚
â”‚                                    â”‚                   â”‚                  â”‚
â”‚                                    â–¼                   â–¼                  â”‚
â”‚                               COMPLETE            M06 Retake              â”‚
â”‚                                                        â”‚                  â”‚
â”‚                                                        â–¼                  â”‚
â”‚                                                   Resubmit                â”‚
â”‚                                                        â”‚                  â”‚
â”‚                                                        â–¼                  â”‚
â”‚                                                   COMPLETE                â”‚
â”‚                                                                           â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 5.2 Brand Admin Journey (Web)

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                         BRAND ADMIN WEB JOURNEY                              â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                                              â”‚
â”‚  ðŸ” LOGIN (L01)                                                              â”‚
â”‚     â”‚                                                                        â”‚
â”‚     â–¼                                                                        â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                                                                â”‚
â”‚  â”‚   B01   â”‚â—€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚Dashboardâ”‚                                                            â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜                                                            â”‚   â”‚
â”‚       â”‚                                                                 â”‚   â”‚
â”‚       â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”‚   â”‚
â”‚       â–¼                     â–¼                    â–¼                  â”‚  â”‚   â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”              â”‚  â”‚   â”‚
â”‚  â”‚   B02   â”‚          â”‚   B05   â”‚          â”‚   B07   â”‚              â”‚  â”‚   â”‚
â”‚  â”‚Campaign â”‚          â”‚ Review  â”‚          â”‚ Reports â”‚              â”‚  â”‚   â”‚
â”‚  â”‚  List   â”‚          â”‚  Queue  â”‚          â”‚         â”‚              â”‚  â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜              â”‚  â”‚   â”‚
â”‚       â”‚                    â”‚                                         â”‚  â”‚   â”‚
â”‚       â–¼                    â–¼                                         â”‚  â”‚   â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                                   â”‚  â”‚   â”‚
â”‚  â”‚   B03   â”‚          â”‚   B06   â”‚â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚   â”‚
â”‚  â”‚Campaign â”‚          â”‚ Store   â”‚                                      â”‚   â”‚
â”‚  â”‚ Builder â”‚          â”‚ Detail  â”‚                                      â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                                      â”‚   â”‚
â”‚       â”‚                                                                 â”‚   â”‚
â”‚       â–¼                                                                 â”‚   â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                                                           â”‚   â”‚
â”‚  â”‚   B04   â”‚                                                           â”‚   â”‚
â”‚  â”‚ Store   â”‚                                                           â”‚   â”‚
â”‚  â”‚Selector â”‚                                                           â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜                                                           â”‚   â”‚
â”‚       â”‚                                                                 â”‚   â”‚
â”‚       â–¼                                                                 â”‚   â”‚
â”‚  [PUBLISH]â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”‚                                                                              â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### 5.3 PSP Operations Journey (Web)

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                        PSP OPERATIONS WEB JOURNEY                            â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚                                                                              â”‚
â”‚  ðŸ” LOGIN (L01)                                                              â”‚
â”‚     â”‚                                                                        â”‚
â”‚     â–¼                                                                        â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                                                                â”‚
â”‚  â”‚   P01   â”‚â—€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”‚
â”‚  â”‚ Order   â”‚                                                             â”‚  â”‚
â”‚  â”‚  Queue  â”‚                                                             â”‚  â”‚
â”‚  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜                                                             â”‚  â”‚
â”‚       â”‚                                                                  â”‚  â”‚
â”‚       â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”‚  â”‚
â”‚       â–¼                     â–¼                    â–¼                   â”‚  â”‚  â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”          â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”               â”‚  â”‚  â”‚
â”‚  â”‚   P02   â”‚          â”‚   P03   â”‚          â”‚   P04   â”‚               â”‚  â”‚  â”‚
â”‚  â”‚ Batch   â”‚          â”‚Shipment â”‚          â”‚ Issue   â”‚               â”‚  â”‚  â”‚
â”‚  â”‚ Manager â”‚          â”‚ Tracker â”‚          â”‚  Queue  â”‚               â”‚  â”‚  â”‚
â”‚  â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜          â””â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”˜               â”‚  â”‚  â”‚
â”‚       â”‚                    â”‚                    â”‚                    â”‚  â”‚  â”‚
â”‚       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                    â”‚  â”‚  â”‚
â”‚                            â”‚                                         â”‚  â”‚  â”‚
â”‚                            â–¼                                         â”‚  â”‚  â”‚
â”‚                       â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”                                    â”‚  â”‚  â”‚
â”‚                       â”‚   P05   â”‚â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â”‚  â”‚
â”‚                       â”‚ Export  â”‚                                       â”‚  â”‚
â”‚                       â”‚ Center  â”‚                                       â”‚  â”‚
â”‚                       â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜                                       â”‚  â”‚
â”‚                                                                         â”‚  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

---

## 6. Cross-Persona Interactions

### 6.1 Interaction Matrix

```
                    â”Œâ”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”
                    â”‚ PA  â”‚ PSP â”‚ PO  â”‚ BA  â”‚ CM  â”‚ RM  â”‚ SM  â”‚ SO  â”‚ IU  â”‚
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Platform Admin    â”‚  -  â”‚  C  â”‚  C  â”‚  C  â”‚  C  â”‚  C  â”‚  C  â”‚  C  â”‚  C  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ PSP Admin         â”‚  E  â”‚  -  â”‚  C  â”‚  C  â”‚  N  â”‚  N  â”‚  N  â”‚  N  â”‚  C  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Production Ops    â”‚  E  â”‚  R  â”‚  -  â”‚  N  â”‚  N  â”‚  N  â”‚  A  â”‚  A  â”‚  W  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Brand Admin       â”‚  E  â”‚  R  â”‚  N  â”‚  -  â”‚  C  â”‚  C  â”‚  N  â”‚  N  â”‚  N  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Campaign Manager  â”‚  E  â”‚  R  â”‚  N  â”‚  R  â”‚  -  â”‚  N  â”‚  N  â”‚  N  â”‚  N  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Regional Manager  â”‚  E  â”‚  R  â”‚  N  â”‚  E  â”‚  R  â”‚  -  â”‚  N  â”‚  N  â”‚  N  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Store Manager     â”‚  E  â”‚  R  â”‚  R  â”‚  R  â”‚  R  â”‚  R  â”‚  -  â”‚  C  â”‚  N  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Store Operator    â”‚  E  â”‚  R  â”‚  R  â”‚  R  â”‚  R  â”‚  R  â”‚  R  â”‚  -  â”‚  N  â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¼â”€â”€â”€â”€â”€â”¤
â”‚ Integration User  â”‚  E  â”‚  R  â”‚  W  â”‚  W  â”‚  W  â”‚  W  â”‚  W  â”‚  W  â”‚  -  â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”´â”€â”€â”€â”€â”€â”˜

Legend:
C = Creates/Configures for     E = Escalates to        N = Notifies
R = Reports to                 W = Writes data for     A = Approves for
```

### 6.2 Key Handoff Points

| Handoff | From | To | Trigger | Data | Screen Flow |
|---------|------|-----|---------|------|-------------|
| Campaign Publish | BA/CM | PO | Publish button | Orders generated | B03 â†’ P01 |
| Photo Review | SO/SM | CM/RM | Submit execution | Photos queued | M05 â†’ B05 |
| Photo Rejection | CM/RM | SO/SM | Reject photos | Rejection reasons | B05 â†’ M06 |
| Issue Request | SO/SM | PO | Submit issue | Issue + evidence | M07 â†’ P04 |
| Issue Approval | PO | SO/SM | Approve/Deny | Decision + reorder | P04 â†’ M02 |
| Replacement Approval | SM | SO | Approve request | Approval status | S02 â†’ M07 |
| Escalation | RM | BA | Escalate button | Context + comments | B05 â†’ B01 |
| Shipment Update | PO | SO/SM | Create shipment | Tracking info | P03 â†’ M03 |
| Waiver Applied | BA/RM | SO/SM | Apply waiver | Waiver reason | B06 â†’ M03 |

### 6.3 Notification Flow

![PERSONA_INTERACTION_MAPS_diagram_4](diagrams_rendered/PERSONA_INTERACTION_MAPS_diagram_4.png)

---

## 7. Edge Case Handling

### 7.1 Edge Cases by Persona

| Edge Case | Primary Handler | Escalation Path | Resolution |
|-----------|-----------------|-----------------|------------|
| Store layout update mid-campaign | BA | PA (if system issue) | Rebase to latest with verification |
| Partial shipment needed | PO | PSP | Create partial, backorder remainder |
| Multiple tracking per shipment | PO | - | UI supports array of tracking |
| STRICT rejection loop | RM | BA | Apply waiver with reason |
| FAST mode auto-reopen | System | CM | Auto-queues for re-review |
| Asset substitution reorder | PO | PSP | Log substitution with audit |
| Late shipping threshold | System | RM â†’ BA | Escalation notification chain |
| Missing proof photos | RM | BA | Contact store, reopen, or waiver |
| Damaged goods all items | SO â†’ SM | PO | Single request expands to lines |
| Store user locked out | SM | BA â†’ PSP | Reset via team management |
| Campaign conflict (same store) | BA | PA | System validation on publish |
| Deinstall overdue | RM | BA | Notification escalation |

### 7.2 Verification Mode Behaviors

| Scenario | STRICT Mode | FAST Mode |
|----------|-------------|-----------|
| Initial submission | Queue for review | Auto-complete |
| Photo rejected | Store retakes â†’ Re-queue | Auto-reopen â†’ Re-queue |
| Partial completion | Hold pending | Allow partial |
| Deadline passed | Escalate to RM | Escalate to RM |
| Waiver applied | Requires reason | Requires reason |
| Auto-complete | Never | After re-review pass |

### 7.3 Offline Handling (Mobile)

| Action | Online | Offline | Sync Behavior |
|--------|--------|---------|---------------|
| View tasks | Live data | Cached data | Refresh on connect |
| View mockups | Load images | Cached images | Pre-fetch on WiFi |
| Capture photos | Upload immediately | Store locally | Queue for upload |
| Submit execution | Immediate | Draft mode | Submit on connect |
| Report issues | Immediate | Draft mode | Submit on connect |
| Receive shipment | Live update | Mark locally | Sync on connect |

---

## 8. Deep Link Patterns

### 8.1 Mobile App Deep Links

| Pattern | Target Screen | Parameters | Example |
|---------|---------------|------------|---------|
| `newpopsys://home` | M01 Home | - | `newpopsys://home` |
| `newpopsys://tasks` | M02 Task List | `?filter={status}` | `newpopsys://tasks?filter=pending` |
| `newpopsys://campaign/{id}` | M03 Campaign Detail | `id` | `newpopsys://campaign/camp_123` |
| `newpopsys://receive/{orderId}` | M04 Receive & Verify | `orderId` | `newpopsys://receive/ord_456` |
| `newpopsys://install/{assignmentId}` | M05 Install Capture | `assignmentId`, `?item={itemId}` | `newpopsys://install/asgn_789?item=item_012` |
| `newpopsys://photos/{assignmentId}` | M06 Photo Gallery | `assignmentId`, `?status={status}` | `newpopsys://photos/asgn_789?status=rejected` |
| `newpopsys://issue/new` | M07 Issue Request | `?orderId={orderId}` | `newpopsys://issue/new?orderId=ord_456` |
| `newpopsys://profile` | M08 Profile | - | `newpopsys://profile` |

### 8.2 Web Portal Deep Links

| Pattern | Target Screen | Parameters | Example |
|---------|---------------|------------|---------|
| `/login` | L01 Login | `?redirect={path}` | `/login?redirect=/admin/dashboard` |
| `/admin/dashboard` | B01 Dashboard | `?brand={id}` | `/admin/dashboard?brand=brand_123` |
| `/admin/campaigns` | B02 Campaign List | `?status={status}` | `/admin/campaigns?status=active` |
| `/admin/campaigns/{id}` | B03 Campaign Builder | `id` | `/admin/campaigns/camp_123` |
| `/admin/campaigns/{id}/stores` | B04 Store Selector | `id` | `/admin/campaigns/camp_123/stores` |
| `/admin/review` | B05 Review Queue | `?campaign={id}&store={id}` | `/admin/review?campaign=camp_123` |
| `/admin/stores/{id}` | B06 Store Detail | `id`, `?tab={tab}` | `/admin/stores/store_456?tab=execution` |
| `/admin/reports` | B07 Reports | `?type={type}` | `/admin/reports?type=completion` |
| `/store/dashboard` | S01 Dashboard | - | `/store/dashboard` |
| `/psp/orders` | P01 Order Queue | `?campaign={id}&status={status}` | `/psp/orders?status=pending` |
| `/psp/batches` | P02 Batch Manager | `?type={type}` | `/psp/batches?type=PRODUCTION` |
| `/psp/shipments` | P03 Shipment Tracker | `?order={id}` | `/psp/shipments?order=ord_456` |
| `/psp/issues` | P04 Issue Queue | `?priority={level}` | `/psp/issues?priority=HIGH` |
| `/psp/exports` | P05 Export Center | `?type={type}` | `/psp/exports?type=orders` |

---

## 9. Sprint Implementation Guide

### 9.1 Persona Priority by Sprint

| Sprint | Weeks | Primary Personas | Screens | Focus |
|--------|-------|------------------|---------|-------|
| **Sprint 1** | 1-2 | All (Auth) | L01 | Universal Login, RBAC |
| **Sprint 2** | 3-4 | SO, SM | M01-M05 | Core Mobile Execution |
| **Sprint 3** | 5-6 | BA, CM | B01-B04 | Campaign Creation |
| **Sprint 4** | 7-8 | SO, SM, CM | M06-M07, B05 | Photo Review Loop |
| **Sprint 5** | 9-10 | PO, PSP | P01-P04 | Fulfillment Core |
| **Sprint 6** | 11-12 | All | All + Polish | Integration & Beta |

### 9.2 Persona Dependencies

```
Sprint 1 (Auth)
    â”‚
    â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
    â–¼                     â–¼                                â–¼
Sprint 2 (Mobile)    Sprint 3 (Brand Admin)        Sprint 5 (PSP)
    â”‚                     â”‚                                â”‚
    â–¼                     â–¼                                â”‚
Sprint 4 (Review) â—€â”€â”€â”€â”€â”€â”€â”€â”˜                               â”‚
    â”‚                                                      â”‚
    â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
                                                           â–¼
                                                    Sprint 6 (Beta)
```

### 9.3 Critical Path per Persona

| Persona | Critical Path | Blocking For |
|---------|---------------|--------------|
| Platform Admin | L01 â†’ System Config | All tenant operations |
| PSP Admin | L01 â†’ Brand Onboarding | All brand operations |
| Production Ops | P01 â†’ P02 â†’ P03 | Store receipt |
| Brand Admin | B03 â†’ B04 â†’ Publish | Store assignments |
| Campaign Manager | B03 â†’ B05 | Photo verification |
| Regional Manager | B05 â†’ B06 | Exception resolution |
| Store Manager | S01 â†’ M01 â†’ M05 | Team execution |
| Store Operator | M01 â†’ M04 â†’ M05 | Completion data |
| Integration User | API â†’ Webhooks | MIS Integration |

---

## Appendix A: Persona Quick Reference Cards

### A.1 Store Operator Quick Card

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  STORE OPERATOR (SO)                                                    â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  Primary: Complete surveys, execute installations, report issues       â”‚
â”‚  Permission: View Only + Execution                                     â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  SCREENS: M01, M02, M03, M04, M05, M06, M07, M08                       â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KEY WORKFLOWS:                                                         â”‚
â”‚  1. Receive notification â†’ View campaign â†’ Check due dates             â”‚
â”‚  2. Receive order â†’ Verify items â†’ Report issues                       â”‚
â”‚  3. Complete pre-install â†’ Install items â†’ Capture photos              â”‚
â”‚  4. Complete survey â†’ Submit â†’ Handle rejections                       â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  LIMITATIONS:                                                           â”‚
â”‚  - Cannot approve replacement requests (needs SM)                      â”‚
â”‚  - Cannot access campaigns not assigned                                â”‚
â”‚  - Cannot view brand-level analytics                                   â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  ESCALATION: Store Manager â†’ Regional Manager â†’ Brand Admin            â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### A.2 Brand Admin Quick Card

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  BRAND ADMIN (BA)                                                       â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  Primary: Full brand configuration, all campaigns, user permissions    â”‚
â”‚  Permission: Brand Level Privileged                                    â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  SCREENS: B01, B02, B03, B04, B05, B06, B07, S01, S02, S03, S04        â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KEY WORKFLOWS:                                                         â”‚
â”‚  1. Create campaign â†’ Define kit â†’ Select stores â†’ Publish             â”‚
â”‚  2. Monitor dashboard â†’ Review KPIs â†’ Drill-down anomalies             â”‚
â”‚  3. Review proofs â†’ Approve/Reject â†’ Apply waivers                     â”‚
â”‚  4. Manage stores â†’ Configure settings â†’ Handle exceptions             â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  SPECIAL ABILITIES:                                                     â”‚
â”‚  - Force complete assignments                                          â”‚
â”‚  - Apply waivers without limit                                         â”‚
â”‚  - Access all campaigns (not just assigned)                            â”‚
â”‚  - Configure brand-level settings                                      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  ESCALATION: PSP Admin â†’ Platform Admin                                â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

### A.3 Production Operator Quick Card

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚  PRODUCTION OPERATOR (PO)                                               â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  Primary: Order processing, shipments, batch management, issues        â”‚
â”‚  Permission: Status & Shipping Updates                                 â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  SCREENS: P01, P02, P03, P04, P05                                      â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  KEY WORKFLOWS:                                                         â”‚
â”‚  1. Review orders â†’ Confirm plan â†’ Create batches                      â”‚
â”‚  2. Progress batch â†’ Create shipments â†’ Add tracking                   â”‚
â”‚  3. Process issues â†’ Approve/Deny â†’ Create reorders                    â”‚
â”‚  4. Generate exports â†’ Close fulfillment                               â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  BATCH TYPES:                                                           â”‚
â”‚  - PRODUCTION: Manufacturing run                                       â”‚
â”‚  - PICK_PACK: Warehouse picking                                        â”‚
â”‚  - SHIP_WAVE: Shipping batch                                           â”‚
â”‚  - CUSTOM: User-defined                                                â”‚
â”œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¤
â”‚  ESCALATION: PSP Admin â†’ Platform Admin                                â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

---

## Appendix B: Changelog

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-12-30 | AI | Initial creation from SUPP-001, SCREEN_INVENTORY, 12-personas-by-module |

---

*End of Persona Interaction Maps & User Journey Flows*
