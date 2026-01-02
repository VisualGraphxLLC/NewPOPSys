# NewPOPSys v1 — Screen Specifications Index

> **Version**: v1.0
> **Updated**: 2025-12-19
> **Purpose**: Comprehensive screen-by-screen documentation with glossary, data maps, and process flows

---

## Overview

This folder contains detailed specifications for every screen in the NewPOPSys application. Each screen spec includes:

- **Screenshot/Wireframe Reference** — Visual reference
- **Screen Glossary** — Key terms visible on this screen
- **Data Model Map** — Entities and fields displayed/edited
- **Process Flows** — User actions and system responses
- **Acceptance Criteria** — Testable requirements

---

## Interactive Wireframes

| Wireframe | Launch | Description |
|-----------|--------|-------------|
| **Mobile App** | [store_execution.html](../05_Wireframes/store_execution.html) | Store execution flows |
| **Store Manager Portal** | [store_portal.html](../05_Wireframes/store_portal.html) | Store web dashboard |
| **Brand Admin** | [admin_portal.html](../05_Wireframes/admin_portal.html) | Campaign management |
| **PSP Operations** | [psp_ops.html](../05_Wireframes/psp_ops.html) | Fulfillment operations |

---

## Screen Catalog

### Mobile App (Store Execution)

| # | Screen | File | SUPP | Description |
|---|--------|------|------|-------------|
| M01 | Login | [M01_Login.md](M01_Login.md) | SUPP-036 | Store authentication |
| M02 | Dashboard | [M02_Dashboard.md](M02_Dashboard.md) | SUPP-017 | Campaign overview and alerts |
| M03 | Receipt Survey | [M03_Receipt_Survey.md](M03_Receipt_Survey.md) | SUPP-015, SUPP-017 | Shipment verification |
| M04 | Install Survey | [M04_Install_Survey.md](M04_Install_Survey.md) | SUPP-015, SUPP-017 | Photo capture workflow |
| M05 | Photo Capture | [M05_Photo_Capture.md](M05_Photo_Capture.md) | SUPP-037 | Camera interface |
| M06 | Tasks List | [M06_Tasks.md](M06_Tasks.md) | SUPP-017 | Task queue |
| M07 | Profile | [M07_Profile.md](M07_Profile.md) | SUPP-036 | User settings |
| M08 | Retake Flow | [M08_Retake.md](M08_Retake.md) | SUPP-018 | Photo rejection response |

### Brand Admin Portal

| # | Screen | File | SUPP | Description |
|---|--------|------|------|-------------|
| B01 | Dashboard | [B01_Dashboard.md](B01_Dashboard.md) | SUPP-001 | Program overview |
| B02 | Campaign List | [B02_Campaign_List.md](B02_Campaign_List.md) | SUPP-015 | Campaign management |
| B03 | Campaign Create - Store Selection | [B03_Store_Selection.md](B03_Store_Selection.md) | SUPP-015 | Store targeting |
| B04 | Campaign Create - Kit Definition | [B04_Kit_Definition.md](B04_Kit_Definition.md) | SUPP-015 | Item assignment |
| B05 | Campaign Create - Review | [B05_Campaign_Review.md](B05_Campaign_Review.md) | SUPP-015 | Launch confirmation |
| B06 | Store List | [B06_Store_List.md](B06_Store_List.md) | SUPP-013 | Store network |
| B07 | Verification Queue | [B07_Verification.md](B07_Verification.md) | SUPP-018 | Photo review |

### Store Manager Portal (Web)

| # | Screen | File | SUPP | Description |
|---|--------|------|------|-------------|
| S01 | Dashboard | [S01_Dashboard.md](S01_Dashboard.md) | SUPP-017 | Store overview and KPIs |
| S02 | Campaign History | [S02_Campaign_History.md](S02_Campaign_History.md) | SUPP-017 | Past and current campaigns |
| S03 | Photo Gallery | [S03_Photo_Gallery.md](S03_Photo_Gallery.md) | SUPP-018 | All submitted photos |
| S04 | Team Management | [S04_Team_Management.md](S04_Team_Management.md) | SUPP-001, SUPP-003 | Manage store users |
| S05 | Reports | [S05_Reports.md](S05_Reports.md) | SUPP-001 | Performance analytics |

### PSP Operations Portal

| # | Screen | File | SUPP | Description |
|---|--------|------|------|-------------|
| P01 | Order Queue | [P01_Order_Queue.md](P01_Order_Queue.md) | SUPP-016 | Fulfillment queue |
| P02 | Shipments | [P02_Shipments.md](P02_Shipments.md) | SUPP-016 | Tracking management |
| P03 | Issues Queue | [P03_Issues.md](P03_Issues.md) | SUPP-019 | Damage/missing claims |

---

## Data Model Quick Reference

### Core Entities by Screen

| Entity | Screens Used | Primary Operations |
|--------|--------------|-------------------|
| `Campaign` | B01, B02, B03, B04, B05, M02, S01, S02 | Create, Publish, View |
| `Store` | B06, B03, M01, M02, P01, P02, S01 | View, Filter, Target |
| `StoreAssignment` | M02, M03, M04, M06, B01, S01, S02 | Track progress |
| `StoreOrder` | P01, P02, M03 | Generate, Acknowledge, Ship |
| `Shipment` | P02, M03 | Create, Track, Deliver |
| `PhotoUpload` | M04, M05, B07, M08, S03 | Capture, Upload, Review |
| `PhotoReview` | B07, M08, S03 | Approve, Reject |
| `IssueRequest` | P03, M03 | Report, Triage, Resolve |
| `KitItem` | B04, M03, M04 | Define, Assign |
| `Kit` | B04, B05 | Define, Review |
| `User` | M01, M07, S04 | Authenticate, Profile |
| `Membership` | M01, M07, B06, S04 | Role assignment |
| `Invitation` | S04 | Team invites |
| `Region` | B03, B06 | Filtering, Targeting |
| `StoreGroup` | B03, B06 | Custom targeting |
| `LocationSlot` | B04, M04 | Installation placement |
| `PhotoRule` | B04, M04, M05 | Capture requirements |
| `AssignmentItem` | M03, M04, P03 | Item-level tracking |
| `OrderLine` | P01, P02 | Line item fulfillment |
| `ShipmentLine` | P02 | Partial shipments |
| `ReorderRequest` | P03 | Replacement fulfillment |
| `Notification` | M02, M07 | User alerts |
| `SurveyResponse` | M04 | Survey data capture |

---

## Status Enums by Screen

| Status | Screens | Values |
|--------|---------|--------|
| `CampaignStatus` | B02, M02 | DRAFT, SCHEDULED, PUBLISHED, COMPLETED |
| `StoreAssignmentStatus` | M02, B01 | ASSIGNED, READY, IN_PROGRESS, SUBMITTED, COMPLETE |
| `PhotoReviewStatus` | B07, M05, M08 | PENDING, APPROVED, REJECTED, SUPERSEDED |
| `IssueRequestStatus` | P03, M03 | OPEN, TRIAGED, APPROVED, IN_FULFILLMENT, RESOLVED |
| `StoreOrderStatus` | P01, P02 | GENERATED, ACKNOWLEDGED, SHIPPED, DELIVERED |
| `ShipmentStatus` | P02, M03 | LABEL_CREATED, IN_TRANSIT, DELIVERED, EXCEPTION |

---

## Cross-References

| Document | Purpose |
|----------|---------|
| [GLOSSARY.md](../00_Index/GLOSSARY.md) | Full terminology definitions |
| [PROCESS_FLOW_INDEX.md](../00_Index/PROCESS_FLOW_INDEX.md) | All process flow diagrams |
| [Mermaid Charts](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md) | State diagrams |
| [SUPP-035 Data Model](../02_SUPPs/Platform_Ops_Agent_Harness/SUPP-035%20-%20Platform%20Ops%20-%20Agent%20Harness%20-%20Field%20Level%20Data%20Model%20Tables%20Fields%20Enums%20-%20v1.1.md) | Field-level schema |

---

## Screen Count Summary

| Application | Screens | Status |
|-------------|---------|--------|
| Mobile App (Store Execution) | 8 | Complete |
| Store Manager Portal (Web) | 5 | Complete |
| Brand Admin Portal | 7 | Complete |
| PSP Operations Portal | 3 | Complete |
| **Total** | **23** | **All documented** |

---

## Navigation Map

### Mobile App Flow
```
M01 Login
    ↓
M02 Dashboard ←→ M06 Tasks ←→ M07 Profile
    ↓
M03 Receipt Survey
    ↓
M04 Install Survey ←→ M05 Photo Capture
    ↓
M06 Tasks (Attestation)
    ↓
M08 Retake (if photos rejected)
```

### Brand Admin Flow
```
B01 Dashboard
    ↓
B02 Campaign List → B03 Store Selection → B04 Kit Definition → B05 Review
    ↓
B06 Store List
    ↓
B07 Verification Queue
```

### Store Manager Portal Flow
```
S01 Dashboard
    ↓
S02 Campaign History ←→ S03 Photo Gallery
    ↓
S04 Team Management
    ↓
S05 Reports
```

### PSP Operations Flow
```
P01 Order Queue → P02 Shipments
         ↓
    P03 Issues Queue
```

---

## Store Access Summary

| Application | Users | Access Method |
|-------------|-------|---------------|
| Mobile App | Store User, Store Manager | Native iOS/Android app |
| Store Manager Portal | Store Manager only | Web browser |
| Brand Admin Portal | Brand Admin | Web browser |
| PSP Operations Portal | PSP Admin, PSP Operator | Web browser |

---

*End of Screen Index*
