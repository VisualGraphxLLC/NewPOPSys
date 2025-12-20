# NewPOPSys v1 — Entity Relationship Diagram

> **Updated**: 2025-12-19
> **Source**: SUPP-002 (Domain Model), SUPP-035 (Field-Level Data Model)
> Paste into [Mermaid Live](https://mermaid.live) to render.

---

## Full ERD (All Entities)

```mermaid
erDiagram
    %% ============================================
    %% TENANCY & IDENTITY
    %% ============================================

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

    %% ============================================
    %% GEOGRAPHY & STORES
    %% ============================================

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

    %% ============================================
    %% SURVEYS & PHOTO RULES
    %% ============================================

    survey_templates ||--o{ survey_versions : "has versions"

    %% ============================================
    %% CAMPAIGNS & KITS
    %% ============================================

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

    %% ============================================
    %% FULFILLMENT
    %% ============================================

    store_orders ||--o{ order_lines : "contains"
    store_orders ||--o{ shipments : "fulfilled by"

    order_lines }o--|| kit_items : "for item"

    shipments ||--o{ shipment_lines : "contains"

    shipment_lines }o--|| kit_items : "ships item"

    %% ============================================
    %% EXECUTION & VERIFICATION
    %% ============================================

    store_assignments ||--o| receive_verifications : "receipt"
    store_assignments ||--o{ store_survey_responses : "answers"
    store_assignments ||--o{ photo_uploads : "captures"
    store_assignments ||--o{ issue_requests : "reports"

    photo_uploads }o--o| assignment_items : "for item"
    photo_uploads }o--o| location_slots : "at slot"
    photo_uploads ||--o{ photo_reviews : "reviewed"
    photo_uploads ||--o{ retake_requests : "triggers"

    %% ============================================
    %% ISSUES & REORDERS
    %% ============================================

    issue_requests ||--o{ issue_lines : "affects"
    issue_requests ||--o| reorders : "generates"

    issue_lines }o--|| kit_items : "for item"

    reorders }o--|| store_orders : "replacement order"

    %% ============================================
    %% NOTIFICATIONS & AUDIT
    %% ============================================

    users ||--o{ notification_preferences : "configures"
    users ||--o{ notifications : "receives"

    tenants ||--o{ audit_events : "logs"

    webhook_endpoints ||--o{ webhook_deliveries : "sends"

    %% ============================================
    %% ENTITY DEFINITIONS
    %% ============================================

    tenants {
        uuid id PK
        string name
        string slug UK
        string subscription_tier
        jsonb settings_json
    }

    brands {
        uuid id PK
        uuid tenant_id FK
        string name
        string code
        string logo_url
        jsonb settings_json
    }

    users {
        uuid id PK
        string email UK
        string password_hash
        string full_name
        boolean is_global_admin
        timestamp last_login_at
    }

    memberships {
        uuid id PK
        uuid user_id FK
        uuid tenant_id FK
        uuid brand_id FK
        enum role
        uuid region_scope_id FK
        uuid store_scope_id FK
    }

    api_keys {
        uuid id PK
        uuid tenant_id FK
        string key_hash
        string key_prefix
        string name
        array scopes
        timestamp expires_at
    }

    stores {
        uuid id PK
        uuid brand_id FK
        string store_number UK
        string name
        string address_line1
        string city
        string state
        string zip_code
        uuid region_id FK
        uuid district_id FK
        uuid territory_id FK
        enum status
    }

    regions {
        uuid id PK
        uuid brand_id FK
        string name
        string code
        uuid parent_region_id FK
    }

    campaigns {
        uuid id PK
        uuid brand_id FK
        string name
        date start_date
        date end_date
        enum status
        enum verification_mode
        string psp_campaign_ref
        uuid kit_definition_id FK
        uuid survey_version_id FK
    }

    store_assignments {
        uuid id PK
        uuid campaign_id FK
        uuid store_id FK
        enum status
        uuid layout_version_id FK
        uuid survey_version_id FK
    }

    store_orders {
        uuid id PK
        uuid campaign_id FK
        uuid store_id FK
        uuid store_assignment_id FK
        string order_number UK
        enum order_type
        string psp_order_ref
        enum status
        timestamp acknowledged_at
    }

    shipments {
        uuid id PK
        uuid store_order_id FK
        string carrier
        jsonb tracking_numbers
        timestamp shipped_at
        timestamp delivered_at
        enum status
    }

    photo_uploads {
        uuid id PK
        uuid store_assignment_id FK
        uuid assignment_item_id FK
        uuid location_slot_id FK
        string s3_key
        enum review_status
        timestamp uploaded_at
    }

    issue_requests {
        uuid id PK
        uuid store_assignment_id FK
        enum type
        string description
        enum status
        uuid evidence_photo_id FK
    }
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
        date start_date
        date end_date
    }

    STORE {
        uuid id PK
        string store_number
        string name
    }

    STORE_ASSIGNMENT {
        uuid id PK
        enum status
    }

    STORE_ORDER {
        uuid id PK
        string order_number
        enum status
    }

    SHIPMENT {
        uuid id PK
        string carrier
        enum status
    }

    PHOTO_UPLOAD {
        uuid id PK
        enum review_status
    }

    PHOTO_REVIEW {
        uuid id PK
        enum status
    }

    ISSUE_REQUEST {
        uuid id PK
        enum type
        enum status
    }

    REORDER {
        uuid id PK
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
        AK[api_keys]
        AE[audit_events]
    end

    subgraph BRAND_ADMIN["Brand Admin Module"]
        R[regions]
        D[districts]
        TR[territories]
        S[stores]
        SG[store_groups]
        ST[survey_templates]
        SV[survey_versions]
        KD[kit_definitions]
        KI[kit_items]
        PR[photo_rules]
        C[campaigns]
        SA[store_assignments]
        AI[assignment_items]
    end

    subgraph PSP_OPS["PSP Operations Module"]
        SO[store_orders]
        OL[order_lines]
        SH[shipments]
        SL[shipment_lines]
        RE[reorders]
    end

    subgraph STORE_EXEC["Store Execution Module"]
        RV[receive_verifications]
        SSR[store_survey_responses]
        PU[photo_uploads]
        IR[issue_requests]
        IL[issue_lines]
    end

    subgraph VERIFICATION["Verification (Brand/Regional)"]
        PRV[photo_reviews]
        RR[retake_requests]
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
| `||--o{` | One-to-Many |
| `}o--||` | Many-to-One |
| `||--||` | One-to-One |
| `}o--o{` | Many-to-Many |
| `PK` | Primary Key |
| `FK` | Foreign Key |
| `UK` | Unique Key |

---

*End of ERD*
