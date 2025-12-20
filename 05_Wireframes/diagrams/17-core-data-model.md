# Core Data Model (ERD)

Entity Relationship Diagrams showing the complete NewPOPSys v1 data model.

> **Source**: SUPP-002 (Domain Model), SUPP-035 (Field-Level Data Model)

---

## Full ERD (All Entities)

```mermaid
erDiagram
    %% TENANCY & IDENTITY
    tenants ||--o{ brands : "has"
    tenants ||--o{ users : "contains"
    tenants ||--o{ api_keys : "owns"
    tenants ||--o{ webhook_endpoints : "configures"

    brands ||--o{ campaigns : "runs"
    brands ||--o{ stores : "manages"
    brands ||--o{ regions : "defines"
    brands ||--o{ store_groups : "creates"
    brands ||--o{ survey_templates : "designs"
    brands ||--o{ kit_definitions : "builds"
    brands ||--o{ photo_rules : "sets"

    users ||--o{ memberships : "has"
    memberships }o--|| brands : "scoped to"
    memberships }o--o| regions : "regional scope"
    memberships }o--o| stores : "store scope"

    %% GEOGRAPHY & STORES
    regions ||--o{ districts : "contains"
    regions ||--o{ territories : "contains"
    regions ||--o{ stores : "groups"

    districts ||--o{ territories : "contains"
    districts ||--o{ stores : "groups"

    territories ||--o{ stores : "groups"

    stores ||--o{ store_layouts : "has"
    stores ||--o{ store_group_memberships : "belongs to"

    store_groups ||--o{ store_group_memberships : "contains"
    store_layouts ||--o{ location_slots : "defines"

    %% SURVEYS & PHOTO RULES
    survey_templates ||--o{ survey_versions : "has versions"

    %% CAMPAIGNS & KITS
    campaigns ||--o{ store_assignments : "targets"
    campaigns }o--|| kit_definitions : "uses"
    campaigns }o--o| survey_versions : "pins"

    kit_definitions ||--o{ kit_items : "contains"
    kit_items }o--o| photo_rules : "requires"

    store_assignments }o--|| stores : "assigned to"
    store_assignments ||--o{ assignment_items : "includes"
    store_assignments ||--|| store_orders : "generates"
    store_assignments }o--o| store_layouts : "pins layout"
    store_assignments }o--o| survey_versions : "pins survey"

    assignment_items }o--|| kit_items : "for item"
    assignment_items }o--o| location_slots : "at slot"

    %% FULFILLMENT
    store_orders ||--o{ order_lines : "contains"
    store_orders ||--o{ shipments : "fulfilled by"

    order_lines }o--|| kit_items : "for item"

    shipments ||--o{ shipment_lines : "contains"
    shipment_lines }o--|| kit_items : "ships item"

    %% EXECUTION & VERIFICATION
    store_assignments ||--o| receive_verifications : "receipt"
    store_assignments ||--o{ store_survey_responses : "answers"
    store_assignments ||--o{ photo_uploads : "captures"
    store_assignments ||--o{ issue_requests : "reports"

    photo_uploads }o--o| assignment_items : "for item"
    photo_uploads }o--o| location_slots : "at slot"
    photo_uploads ||--o{ photo_reviews : "reviewed"
    photo_uploads ||--o{ retake_requests : "triggers"

    %% ISSUES & REORDERS
    issue_requests ||--o{ issue_lines : "affects"
    issue_requests ||--o| reorders : "generates"

    issue_lines }o--|| kit_items : "for item"
    reorders }o--|| store_orders : "replacement order"

    %% NOTIFICATIONS & AUDIT
    users ||--o{ notification_preferences : "configures"
    users ||--o{ notifications : "receives"
    tenants ||--o{ audit_events : "logs"
    webhook_endpoints ||--o{ webhook_deliveries : "sends"
```

---

## Simplified Core Loop ERD

```mermaid
erDiagram
    BRAND ||--o{ CAMPAIGN : "runs"
    CAMPAIGN ||--o{ STORE_ASSIGNMENT : "assigns"
    STORE_ASSIGNMENT }o--|| STORE : "to"
    STORE_ASSIGNMENT ||--|| STORE_ORDER : "generates"
    STORE_ORDER ||--o{ SHIPMENT : "shipped via"
    STORE_ASSIGNMENT ||--o{ PHOTO_UPLOAD : "captures"
    PHOTO_UPLOAD ||--o{ PHOTO_REVIEW : "reviewed"
    STORE_ASSIGNMENT ||--o{ ISSUE_REQUEST : "reports"
    ISSUE_REQUEST ||--o| REORDER : "triggers"

    BRAND {
        uuid id PK
        string name
    }
    CAMPAIGN {
        uuid id PK
        string name
        enum status
    }
    STORE {
        uuid id PK
        string store_number
    }
    STORE_ASSIGNMENT {
        uuid id PK
        enum status
    }
    STORE_ORDER {
        uuid id PK
        string order_number
    }
    SHIPMENT {
        uuid id PK
        enum status
    }
    PHOTO_UPLOAD {
        uuid id PK
        enum review_status
    }
    ISSUE_REQUEST {
        uuid id PK
        enum status
    }
```

---

## Module Ownership

```mermaid
flowchart TB
    subgraph SHARED["Shared Foundations"]
        T[tenants]
        B[brands]
        U[users]
        M[memberships]
    end

    subgraph BRAND_ADMIN["Brand Admin Module"]
        R[regions]
        S[stores]
        ST[survey_templates]
        KD[kit_definitions]
        C[campaigns]
        SA[store_assignments]
    end

    subgraph PSP_OPS["PSP Operations Module"]
        SO[store_orders]
        SH[shipments]
        RE[reorders]
    end

    subgraph STORE_EXEC["Store Execution Module"]
        PU[photo_uploads]
        IR[issue_requests]
    end

    subgraph VERIFICATION["Verification"]
        PRV[photo_reviews]
    end

    T --> B
    B --> C
    C --> SA
    SA --> SO
    SA --> PU
    PU --> PRV
    IR --> RE
```

---

## Legend

| Symbol | Meaning |
|--------|---------|
| \`\|\|--o{\` | One-to-Many |
| \`}o--\|\|\` | Many-to-One |
| \`\|\|--\|\|\` | One-to-One |
| \`PK\` | Primary Key |
| \`FK\` | Foreign Key |

---

*See SUPP-035 for complete field definitions.*
