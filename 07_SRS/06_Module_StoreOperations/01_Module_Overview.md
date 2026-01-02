# Module Overview: Store Operations

| Property       | Value                                      |
|----------------|-------------------------------------------|
| Module ID      | MOD-STORE                                  |
| Module Name    | Store Operations                           |
| Screen Range   | S001 - S010                                |
| Status         | Planned                                    |
| Last Updated   | 2025-01-01                                 |

---

## 1. Module Summary

### Purpose

The Store Operations module provides store-level functionality for campaign execution, inventory management, and order processing. This module serves as the primary interface for store personnel to manage day-to-day POP material operations within their assigned locations.

### Scope

- Campaign viewing and execution tracking at store level
- Real-time inventory management for POP materials
- Order queue management and fulfillment tracking
- Store performance dashboard and metrics
- Integration with corporate campaign scheduling

### Target Users

- Store Managers
- Store Operations Staff
- Regional Managers (oversight)

---

## 2. Screen Inventory

| Screen ID | Screen Name          | Route                   | Status   | Priority |
|-----------|---------------------|-------------------------|----------|----------|
| S001      | Store Dashboard     | `/store/dashboard`      | Planned  | High     |
| S002      | Campaign List       | `/store/campaigns`      | Planned  | High     |
| S003      | Campaign Detail     | `/store/campaigns/:id`  | Planned  | High     |
| S004      | Inventory Management| `/store/inventory`      | Planned  | High     |
| S005      | Order Queue         | `/store/orders`         | Planned  | Medium   |
| S006      | Reserved            | TBD                     | Reserved | -        |
| S007      | Reserved            | TBD                     | Reserved | -        |
| S008      | Reserved            | TBD                     | Reserved | -        |
| S009      | Reserved            | TBD                     | Reserved | -        |
| S010      | Reserved            | TBD                     | Reserved | -        |

---

## 3. Module Dependencies

### Internal Service Dependencies

| Service            | Dependency Type | Description                              |
|--------------------|-----------------|------------------------------------------|
| Campaign Service   | Required        | Campaign data, schedules, and assets     |
| Inventory Service  | Required        | Stock levels, movements, and alerts      |
| Order Service      | Required        | Order queue, status, and fulfillment     |
| Store Service      | Required        | Store configuration and hierarchy        |
| User Service       | Required        | Authentication and authorization         |

### External System Dependencies

| System             | Integration Type | Purpose                                  |
|--------------------|------------------|------------------------------------------|
| POS System         | API              | Sales data and transaction sync          |
| Corporate ERP      | API              | Inventory replenishment triggers         |
| Notification Hub   | Event            | Alert delivery to store personnel        |

---

## 4. RBAC Summary

### Role Permissions Matrix

| Permission                  | STORE_MANAGER | STORE_OPERATOR | REGIONAL_MANAGER |
|-----------------------------|---------------|----------------|------------------|
| View Dashboard              | Yes           | Yes            | Yes              |
| View Campaigns              | Yes           | Yes            | Yes              |
| Update Campaign Status      | Yes           | Yes            | No               |
| Manage Inventory            | Yes           | Limited        | No               |
| Adjust Stock Levels         | Yes           | No             | No               |
| Process Orders              | Yes           | Yes            | No               |
| View Reports                | Yes           | Limited        | Yes              |
| Export Data                 | Yes           | No             | Yes              |

### Access Level Definitions

- **Full**: Complete read/write access to all module features
- **Limited**: Read access with restricted write operations
- **View**: Read-only access for oversight and reporting

---

## 5. Key Integration Points

### POS Integration

- Real-time sales data synchronization
- Campaign material usage tracking
- Automated inventory deduction on sale

### Inventory Sync

- Bidirectional sync with central inventory system
- Automated low-stock alerts
- Cycle count reconciliation

### Campaign Scheduling

- Push notifications for upcoming campaigns
- Automated material allocation
- Compliance tracking and reporting

### Data Flow Summary

```
Corporate Systems <--> Store Operations Module <--> POS System
        |                       |                       |
        v                       v                       v
   Campaigns              Inventory               Sales Data
   Orders                 Alerts                  Transactions
```

---

## 6. Revision History

| Version | Date       | Author         | Changes                          |
|---------|------------|----------------|----------------------------------|
| 1.0     | 2025-01-01 | System         | Initial module overview created  |

---

## References

- [Campaign Service API](../API/campaign-service.md)
- [Inventory Service API](../API/inventory-service.md)
- [Order Service API](../API/order-service.md)
- [RBAC Configuration Guide](../Security/rbac-guide.md)
