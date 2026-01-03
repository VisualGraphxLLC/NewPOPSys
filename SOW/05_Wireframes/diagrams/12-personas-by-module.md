# Personas by Module

Shows which user roles interact with which platform modules.

```mermaid
flowchart TB
  subgraph SHARED["Shared Foundations"]
    SF["All personas access shared data<br/>based on role permissions"]
  end

  subgraph BRAND_MODULE["Brand Admin Module"]
    BA["BRAND_ADMIN<br/>Full brand access"]
    RA["REGIONAL_ADMIN<br/>Scoped to region"]
  end

  subgraph PSP_MODULE["PSP Operations Module"]
    PA["PSP_ADMIN<br/>Tenant config + security"]
    PO["PSP_OPS<br/>Orders + shipments"]
    IU["INTEGRATION_USER<br/>API automation"]
  end

  subgraph STORE_MODULE["Store Execution Module"]
    SU["STORE_USER<br/>Mobile execution"]
  end

  SF --> BRAND_MODULE
  SF --> PSP_MODULE
  SF --> STORE_MODULE
```

## Role Summary

| Module | Roles | Responsibilities |
|--------|-------|------------------|
| **Brand Admin** | Brand Admin, Regional Admin | Campaign config, verification, reporting |
| **PSP Operations** | PSP Admin, PSP Ops, Integration | Tenant config, fulfillment, API |
| **Store Execution** | Store User | Receive, install, proof capture |

---

*From [Complete Diagram Collection](../../04_Reference/NewPOPSys_v1_Mermaid_Charts.md)*
