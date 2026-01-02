# PSPOps Module Overview

> **Module ID:** PSPOps
> **Screen Range:** P001–P010
> **Version:** 1.0.0
> **Last Updated:** 2025-01-01

---

## 1. Module Summary

### Purpose

The PSPOps (Print Service Provider Operations) module provides comprehensive tools for production management, order fulfillment, and tenant administration within the PopSystem platform. This module serves as the operational backbone for PSPs, enabling efficient handling of print orders from receipt through delivery.

### Core Capabilities

- **Production Management** — Job scheduling, resource allocation, and workflow tracking
- **Order Fulfillment** — End-to-end order processing and shipping coordination
- **Tenant Administration** — Multi-tenant configuration and account management
- **Quality Control** — Inspection workflows and defect tracking

---

## 2. Screen Inventory

| Screen ID | Screen Name | Route | Status | Priority |
|-----------|-------------|-------|--------|----------|
| P001 | PSP Dashboard | `/psp/dashboard` | Planned | High |
| P002 | Order Queue | `/psp/orders` | Planned | High |
| P003 | Production Manager | `/psp/production` | Planned | High |
| P004 | Tenant Management | `/psp/tenants` | Planned | Medium |
| P005 | Fulfillment Center | `/psp/fulfillment` | Planned | High |
| P006 | Quality Control | `/psp/qc` | Planned | Medium |
| P007 | Reserved | — | Reserved | — |
| P008 | Reserved | — | Reserved | — |
| P009 | Reserved | — | Reserved | — |
| P010 | Reserved | — | Reserved | — |

**Active Screens:** 6
**Reserved Slots:** 4

---

## 3. Module Dependencies

### Internal Services

| Service | Purpose | Dependency Type |
|---------|---------|-----------------|
| Production Service | Job scheduling, workflow execution | Required |
| Order Service | Order retrieval, status updates | Required |
| Tenant Service | Multi-tenant context, configuration | Required |
| Fulfillment Service | Shipping, tracking, delivery | Required |

### External Integrations

| Integration | Purpose | Status |
|-------------|---------|--------|
| Shipping Carriers | Label generation, tracking | Planned |
| Equipment APIs | Machine status, job submission | Planned |
| Inventory System | Stock levels, material tracking | Planned |

---

## 4. RBAC Summary

### Role Permissions Matrix

| Permission | PLATFORM_ADMIN | PSP_ADMIN | PSP_OPS |
|------------|----------------|-----------|---------|
| View Dashboard | ✓ | ✓ | ✓ |
| Manage Orders | ✓ | ✓ | ✓ |
| Production Control | ✓ | ✓ | ✓ |
| Tenant Management | ✓ | ✓ | ✗ |
| Fulfillment Operations | ✓ | ✓ | ✓ |
| Quality Control | ✓ | ✓ | ✓ |
| System Configuration | ✓ | ✓ | ✗ |
| User Management | ✓ | ✓ | ✗ |

### Role Descriptions

- **PLATFORM_ADMIN** — Full system access across all tenants
- **PSP_ADMIN** — Full access within assigned PSP tenant
- **PSP_OPS** — Operational access only (orders, production, fulfillment, QC)

---

## 5. Key Integration Points

### Production Workflow

```
Order Received → Queue Assignment → Production Scheduling →
Job Execution → Quality Check → Fulfillment → Delivery
```

### Shipping Integration

- Carrier API connections (UPS, FedEx, USPS, DHL)
- Automated label generation
- Real-time tracking updates
- Delivery confirmation handling

### Quality Control

- Inspection checkpoints at configurable stages
- Defect categorization and tracking
- Rework workflow management
- Quality metrics and reporting

---

## 6. Related Documentation

| Document | Path |
|----------|------|
| Screen Specifications | `./02_Screen_P001_PSPDashboard.md` |
| API Contracts | `../API_Contracts/PSPOps_API.md` |
| Data Models | `../Data_Models/PSPOps_Models.md` |

---

## 7. Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2025-01-01 | System | Initial module overview |

---

*Document generated as part of PopSystem SRS v1.0*
