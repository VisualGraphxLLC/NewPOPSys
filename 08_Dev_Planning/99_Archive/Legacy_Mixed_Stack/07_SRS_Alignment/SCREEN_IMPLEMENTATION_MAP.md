# Screen Implementation Map

## Overview

This document maps all SRS screen specifications (L/M/B/S/P series) to their implementation sprints, providing traceability from requirements to development.

---

## Screen Series Summary

| Series | Name | Screen Count | Sprint Range | Status |
|--------|------|--------------|--------------|--------|
| L | Login/Authentication | 10 | Sprint 1 | Planned |
| M | Main/Dashboard | 20 | Sprints 1-4 | Planned |
| B | Business Operations | 50 | Sprints 3-10 | Planned |
| S | Support/Service | 30 | Sprints 6-12 | Planned |
| P | Production/Workflow | 40 | Sprints 8-14 | Planned |

---

## L Series: Login/Authentication Screens

### Sprint 1

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| L001 | Login Page | P0 | Low | 3 |
| L002 | Password Reset Request | P0 | Low | 2 |
| L003 | Password Reset Confirm | P0 | Low | 2 |
| L004 | Two-Factor Authentication | P1 | Medium | 5 |
| L005 | Session Timeout Warning | P1 | Low | 2 |
| L006 | Account Locked | P1 | Low | 2 |
| L007 | First Login Password Change | P1 | Low | 3 |
| L008 | SSO Redirect | P2 | Medium | 5 |
| L009 | Logout Confirmation | P2 | Low | 1 |
| L010 | Login History | P3 | Low | 3 |

**Sprint 1 Total**: 10 screens, 28 story points

---

## M Series: Main/Dashboard Screens

### Sprint 1

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| M001 | Main Dashboard | P0 | High | 13 |
| M002 | Navigation Menu | P0 | Medium | 5 |
| M003 | Quick Actions Bar | P1 | Medium | 5 |
| M004 | Notification Center | P1 | Medium | 8 |

### Sprint 2

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| M005 | Order Summary Widget | P0 | Medium | 5 |
| M006 | Production Status Widget | P0 | Medium | 5 |
| M007 | Revenue Widget | P1 | Medium | 5 |
| M008 | Alerts Widget | P1 | Medium | 5 |

### Sprint 3

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| M009 | Customer Activity Feed | P1 | Medium | 5 |
| M010 | Pending Approvals Widget | P1 | Medium | 5 |
| M011 | Calendar Widget | P2 | Medium | 8 |
| M012 | Search Modal | P1 | High | 8 |

### Sprint 4

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| M013 | User Profile | P1 | Medium | 5 |
| M014 | User Preferences | P2 | Medium | 5 |
| M015 | Dashboard Customization | P2 | High | 13 |
| M016 | Help/Support Access | P2 | Low | 3 |
| M017 | System Status | P2 | Low | 3 |
| M018 | Announcements | P3 | Low | 3 |
| M019 | Quick Links | P3 | Low | 2 |
| M020 | Feedback Widget | P3 | Low | 3 |

---

## B Series: Business Operations Screens

### Sprint 3

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| B001 | Order List | P0 | High | 13 |
| B002 | Order Detail | P0 | High | 13 |
| B003 | Order Create | P0 | High | 13 |
| B004 | Order Edit | P0 | High | 8 |
| B005 | Order Status Update | P0 | Medium | 5 |

### Sprint 4

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| B006 | Customer List | P0 | Medium | 8 |
| B007 | Customer Detail | P0 | High | 13 |
| B008 | Customer Create | P0 | Medium | 8 |
| B009 | Customer Edit | P1 | Medium | 5 |
| B010 | Customer Orders History | P1 | Medium | 5 |

### Sprint 5

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| B011 | Product Catalog | P0 | High | 13 |
| B012 | Product Detail | P0 | High | 13 |
| B013 | Product Configuration | P0 | High | 13 |
| B014 | Pricing Calculator | P0 | High | 13 |
| B015 | Quote Generator | P1 | High | 13 |

### Sprint 6

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| B016 | Quote List | P1 | Medium | 8 |
| B017 | Quote Detail | P1 | High | 8 |
| B018 | Quote Approval | P1 | Medium | 5 |
| B019 | Invoice List | P1 | Medium | 8 |
| B020 | Invoice Detail | P1 | Medium | 8 |

### Sprint 7

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| B021 | Payment Processing | P0 | High | 13 |
| B022 | Payment History | P1 | Medium | 5 |
| B023 | Refund Processing | P1 | Medium | 8 |
| B024 | Credit Memo | P2 | Medium | 5 |
| B025 | Account Balance | P2 | Medium | 5 |

### Sprints 8-10

| Screen ID | Screen Name | Sprint | Priority | Story Points |
|-----------|-------------|--------|----------|--------------|
| B026-B030 | Inventory Management | 8 | P1 | 35 |
| B031-B035 | Vendor Management | 8 | P2 | 30 |
| B036-B040 | Reporting - Sales | 9 | P1 | 40 |
| B041-B045 | Reporting - Operations | 9 | P2 | 35 |
| B046-B050 | Admin/Settings | 10 | P2 | 40 |

---

## S Series: Support/Service Screens

### Sprint 6

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| S001 | Support Ticket List | P1 | Medium | 8 |
| S002 | Support Ticket Detail | P1 | High | 8 |
| S003 | Create Ticket | P1 | Medium | 5 |
| S004 | Ticket Assignment | P1 | Medium | 5 |
| S005 | Ticket Response | P1 | Medium | 5 |

### Sprint 7

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| S006 | Knowledge Base | P2 | High | 13 |
| S007 | FAQ Management | P2 | Medium | 8 |
| S008 | Chat Interface | P2 | High | 13 |
| S009 | Email Templates | P2 | Medium | 5 |
| S010 | Canned Responses | P2 | Low | 3 |

### Sprints 8-12

| Screen ID | Screen Name | Sprint | Priority | Story Points |
|-----------|-------------|--------|----------|--------------|
| S011-S015 | RMA Processing | 8 | P1 | 40 |
| S016-S020 | Complaint Management | 9 | P2 | 35 |
| S021-S025 | Customer Feedback | 10 | P2 | 30 |
| S026-S030 | Support Reporting | 11-12 | P2 | 35 |

---

## P Series: Production/Workflow Screens

### Sprint 8

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| P001 | Production Queue | P0 | High | 13 |
| P002 | Job Detail | P0 | High | 13 |
| P003 | Job Assignment | P0 | Medium | 8 |
| P004 | Production Schedule | P0 | High | 13 |
| P005 | Resource Allocation | P1 | High | 13 |

### Sprint 9

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| P006 | Proof Review | P0 | High | 13 |
| P007 | Proof Approval | P0 | Medium | 8 |
| P008 | Proof Comparison | P1 | High | 13 |
| P009 | Annotation Tool | P1 | High | 13 |
| P010 | Proof History | P2 | Medium | 5 |

### Sprint 10

| Screen ID | Screen Name | Priority | Complexity | Story Points |
|-----------|-------------|----------|------------|--------------|
| P011 | Print Queue | P0 | High | 13 |
| P012 | Device Status | P0 | Medium | 8 |
| P013 | Job Routing | P1 | High | 13 |
| P014 | Material Tracking | P1 | Medium | 8 |
| P015 | Quality Check | P1 | Medium | 8 |

### Sprints 11-14

| Screen ID | Screen Name | Sprint | Priority | Story Points |
|-----------|-------------|--------|----------|--------------|
| P016-P020 | Finishing Operations | 11 | P1 | 40 |
| P021-P025 | Shipping Integration | 11-12 | P0 | 45 |
| P026-P030 | Tracking & Delivery | 12 | P1 | 40 |
| P031-P035 | Production Reports | 13 | P2 | 35 |
| P036-P040 | Workflow Automation | 13-14 | P2 | 40 |

---

## Implementation Progress

| Series | Total Screens | Implemented | In Progress | Remaining |
|--------|---------------|-------------|-------------|-----------|
| L | 10 | 0 | 0 | 10 |
| M | 20 | 0 | 0 | 20 |
| B | 50 | 0 | 0 | 50 |
| S | 30 | 0 | 0 | 30 |
| P | 40 | 0 | 0 | 40 |
| **Total** | **150** | **0** | **0** | **150** |

---

## Dependencies

### Cross-Screen Dependencies

| Screen | Depends On | Dependency Type |
|--------|------------|-----------------|
| M005 (Order Widget) | B001 (Order List) | Data |
| B002 (Order Detail) | L001 (Login) | Authentication |
| P006 (Proof Review) | B011 (Product Catalog) | Configuration |
| S001 (Support Tickets) | B007 (Customer Detail) | Customer Data |

### External Dependencies

| Screen Series | External System | Integration Point |
|---------------|-----------------|-------------------|
| B (Orders) | OnPrintShop | Order sync |
| P (Production) | OneVision | Job submission |
| P (Proofing) | Ziflow | Proof workflow |
| P (Shipping) | XPS Ship | Label generation |

---

*Last Updated: 2026-01-01*
