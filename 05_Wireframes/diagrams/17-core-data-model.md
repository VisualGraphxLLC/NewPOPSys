# Core Data Object Model (v1, PSP-Led)

Entity relationships for the NewPOPSys v1 data architecture.

```mermaid
erDiagram
    PSP ||--o{ Brand : "manages"
    PSP ||--o{ User : "has"

    Brand ||--o{ Campaign : "owns"
    Brand ||--o{ Store : "has"
    Brand ||--o{ Region : "has"

    Region ||--o{ Store : "contains"

    Campaign ||--o{ CampaignStore : "includes"
    Campaign ||--o{ PromoItem : "defines"
    Campaign ||--o{ Kit : "packages"

    Store ||--o{ CampaignStore : "participates"

    CampaignStore ||--o{ StoreAssignment : "creates"
    CampaignStore ||--o{ Fulfillment : "receives"

    Kit ||--o{ KitItem : "contains"
    PromoItem ||--o{ KitItem : "used in"

    StoreAssignment ||--o{ AssignmentItem : "has"
    AssignmentItem ||--o{ Photo : "documented by"

    PromoItem ||--o{ AssignmentItem : "tracks"
    PromoItem ||--o{ Slot : "placed in"

    Photo ||--o{ PhotoReview : "reviewed by"

    StoreAssignment ||--o{ IssueRequest : "raises"
    IssueRequest ||--o{ Fulfillment : "triggers"

    Fulfillment ||--o{ Shipment : "has"
    Shipment ||--o{ ShipmentItem : "contains"

    PSP {
        uuid id PK
        string name
        string domain
        jsonb settings
    }

    Brand {
        uuid id PK
        uuid psp_id FK
        string name
        string logo_url
    }

    Region {
        uuid id PK
        uuid brand_id FK
        string name
        string code
    }

    Store {
        uuid id PK
        uuid brand_id FK
        uuid region_id FK
        string store_number
        string name
        string tier
        jsonb address
    }

    Campaign {
        uuid id PK
        uuid brand_id FK
        string name
        enum status
        date start_date
        date end_date
        date execution_deadline
    }

    CampaignStore {
        uuid id PK
        uuid campaign_id FK
        uuid store_id FK
        enum phase
    }

    PromoItem {
        uuid id PK
        uuid campaign_id FK
        string name
        string sku
        int quantity_per_store
    }

    Kit {
        uuid id PK
        uuid campaign_id FK
        string name
        string tier
    }

    KitItem {
        uuid id PK
        uuid kit_id FK
        uuid promo_item_id FK
        int quantity
    }

    Slot {
        uuid id PK
        uuid promo_item_id FK
        string name
        string location_type
    }

    StoreAssignment {
        uuid id PK
        uuid campaign_store_id FK
        enum status
        timestamp started_at
        timestamp submitted_at
    }

    AssignmentItem {
        uuid id PK
        uuid store_assignment_id FK
        uuid promo_item_id FK
        enum status
        int required_qty
        int verified_qty
    }

    Photo {
        uuid id PK
        uuid assignment_item_id FK
        string storage_url
        timestamp uploaded_at
        jsonb metadata
    }

    PhotoReview {
        uuid id PK
        uuid photo_id FK
        uuid reviewer_id FK
        enum status
        string notes
        timestamp reviewed_at
    }

    IssueRequest {
        uuid id PK
        uuid store_assignment_id FK
        enum type
        enum status
        string description
    }

    Fulfillment {
        uuid id PK
        uuid campaign_store_id FK
        uuid issue_request_id FK
        enum status
        int required_qty
        int shipped_qty
        int delivered_qty
    }

    Shipment {
        uuid id PK
        uuid fulfillment_id FK
        string carrier
        string tracking_number
        enum status
    }

    ShipmentItem {
        uuid id PK
        uuid shipment_id FK
        uuid promo_item_id FK
        int quantity
    }

    User {
        uuid id PK
        uuid psp_id FK
        string email
        enum role
        jsonb permissions
    }
```

## Entity Groups

### Organization
| Entity | Purpose |
|--------|---------|
| PSP | Print service provider tenant |
| Brand | Client organization under PSP |
| Region | Geographic grouping of stores |
| Store | Physical retail location |

### Campaign
| Entity | Purpose |
|--------|---------|
| Campaign | Marketing initiative with timeline |
| CampaignStore | Store participation in campaign |
| PromoItem | Promotional material to install |
| Kit | Packaged set of items by tier |
| Slot | Installation location for item |

### Execution
| Entity | Purpose |
|--------|---------|
| StoreAssignment | Store's work for campaign |
| AssignmentItem | Single item to install |
| Photo | Proof of installation |
| PhotoReview | Verification decision |

### Fulfillment
| Entity | Purpose |
|--------|---------|
| Fulfillment | Order for store materials |
| Shipment | Carrier tracking record |
| ShipmentItem | Items in shipment |
| IssueRequest | Problem report from store |

### Users
| Entity | Purpose |
|--------|---------|
| User | System user with role/permissions |
