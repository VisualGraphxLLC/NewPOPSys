# NewPOPSys v1 Flow (PSP-Led)

End-to-end campaign orchestration flow showing persona handoffs and module responsibilities.

```mermaid
flowchart TB
    subgraph PSP["PSP Layer"]
        PSPAdmin["PSP Admin"]
        PSPOps["PSP Ops"]
    end

    subgraph Brand["Brand Layer"]
        BrandMgr["Brand Manager"]
    end

    subgraph Campaign["Campaign Orchestration"]
        CampaignDef["Campaign Definition"]
        StoreSelect["Store Selection"]
        StoreAssign["Store Assignment"]
    end

    subgraph Fulfillment["Fulfillment Module"]
        KitDef["Kit/Order Definition"]
        FulfillShip["Fulfillment & Shipping"]
    end

    subgraph Execution["Execution Module"]
        StoreMgr["Store Manager"]
        StoreExec["Store Execution"]
        PhotoSubmit["Photo Submission"]
    end

    subgraph Verification["Verification Module"]
        PhotoReview["Photo Review"]
        Approval["Approval/Rejection"]
        Rework["Rework Loop"]
    end

    subgraph Issues["Issue Resolution"]
        IssueReport["Issue Reporting"]
        Reorder["Reorder Requests"]
    end

    subgraph Visibility["Visibility & Reporting"]
        Dashboard["Dashboards"]
        Reports["Reports & Exports"]
    end

    subgraph Retention["Data Retention"]
        Archive["Archive Policy"]
    end

    %% PSP Setup Flow
    PSPAdmin -->|"configures system"| PSPOps
    PSPOps -->|"manages brands"| BrandMgr

    %% Campaign Creation Flow
    BrandMgr -->|"creates campaign"| CampaignDef
    CampaignDef -->|"defines scope"| StoreSelect
    StoreSelect -->|"targets stores"| StoreAssign

    %% Fulfillment Flow
    CampaignDef -->|"defines kits"| KitDef
    KitDef -->|"triggers orders"| FulfillShip
    FulfillShip -->|"delivers to"| StoreMgr

    %% Execution Flow
    StoreAssign -->|"notifies"| StoreMgr
    StoreMgr -->|"executes"| StoreExec
    StoreExec -->|"submits proofs"| PhotoSubmit

    %% Verification Flow
    PhotoSubmit -->|"enters review"| PhotoReview
    PhotoReview -->|"decision"| Approval
    Approval -->|"rejected"| Rework
    Rework -->|"retake"| PhotoSubmit

    %% Issue Flow
    StoreMgr -->|"reports issues"| IssueReport
    IssueReport -->|"generates"| Reorder
    Reorder -->|"fulfills"| FulfillShip

    %% Visibility
    PSPOps -->|"monitors"| Dashboard
    BrandMgr -->|"views"| Dashboard
    Dashboard --> Reports

    %% Retention
    Approval -->|"completed"| Archive
```

## Flow Description

### 1. PSP Setup
- **PSP Admin** configures system settings, users, and permissions
- **PSP Ops** manages day-to-day brand relationships

### 2. Campaign Creation
- **Brand Manager** creates campaigns with scope and timeline
- **Store Selection** targets specific stores by criteria
- **Store Assignment** links stores to campaign

### 3. Fulfillment
- **Kit Definition** specifies materials per store tier
- **Fulfillment** processes orders and ships to stores
- Tracking updates flow back to dashboard

### 4. Execution
- **Store Manager** receives materials and notifications
- **Store Execution** installs POP materials
- **Photo Submission** captures proof of execution

### 5. Verification
- **Photo Review** validates submissions
- **Approval/Rejection** determines compliance
- **Rework Loop** handles rejected submissions

### 6. Issue Resolution
- **Issue Reporting** captures problems (missing, damaged)
- **Reorder Requests** trigger replacement fulfillment

### 7. Visibility
- All personas access relevant dashboards
- Reports enable analysis and exports

### 8. Retention
- Completed campaigns follow archive policy
