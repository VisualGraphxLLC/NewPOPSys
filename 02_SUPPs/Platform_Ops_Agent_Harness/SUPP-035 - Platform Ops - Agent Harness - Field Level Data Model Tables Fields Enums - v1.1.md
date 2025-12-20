# SUPP-035 — Field-Level Data Model Tables Fields Enums

> **Version**: v1.1
> **Status**: Locked
> **Updated**: 2025-12-19
> **Dependencies**: SUPP-002 (Domain Model), SUPP-013 (Stores), SUPP-015 (Campaigns)

---

## Purpose
Physical schema definitions for NewPOPSys v1. Serves as the authoritative reference for database migrations (Drizzle/Postgres) and Zod schemas.

## Common Fields
All tables include:
- `id` (UUID, PK)
- `created_at` (TIMESTAMPTZ, default NOW)
- `updated_at` (TIMESTAMPTZ, default NOW)
- `deleted_at` (TIMESTAMPTZ, nullable, for soft-delete)

---

## Enumerations

### Role Enum
```typescript
enum Role {
  PSP_ADMIN = 'PSP_ADMIN',           // Full PSP tenant access
  PSP_OPS = 'PSP_OPS',               // PSP operations (orders, shipments)
  BRAND_ADMIN = 'BRAND_ADMIN',       // Full brand access
  REGIONAL_ADMIN = 'REGIONAL_ADMIN', // Regional scope
  STORE_USER = 'STORE_USER',         // Store execution only
}
```

### Store Status Enum
```typescript
enum StoreStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  TEMP_CLOSED = 'TEMP_CLOSED',
  CLOSED = 'CLOSED',
}
```

### Campaign Status Enum
```typescript
enum CampaignStatus {
  DRAFT = 'DRAFT',           // Being created/edited
  SCHEDULED = 'SCHEDULED',   // Finalized, future start date
  PUBLISHED = 'PUBLISHED',   // Live, stores can execute (alias: ACTIVE)
  COMPLETED = 'COMPLETED',   // End date passed
  CANCELLED = 'CANCELLED',   // Terminated early
  ARCHIVED = 'ARCHIVED',     // Historical reference only
}
```

### Verification Mode Enum
```typescript
enum VerificationMode {
  STRICT = 'STRICT',   // Every photo requires review
  FAST = 'FAST',       // Auto-approve unless flagged
}
```

### Store Assignment Status Enum
```typescript
enum StoreAssignmentStatus {
  ASSIGNED = 'ASSIGNED',           // Store targeted; waiting on readiness
  READY = 'READY',                 // Store can execute
  IN_PROGRESS = 'IN_PROGRESS',     // Store actively working
  SUBMITTED = 'SUBMITTED',         // Awaiting review
  REWORK_REQUIRED = 'REWORK_REQUIRED', // Retake requested
  COMPLETE = 'COMPLETE',           // Counts toward campaign completion
  REOPENED = 'REOPENED',           // Admin reopened after complete
  WAIVED = 'WAIVED',               // Complete by exception/waiver
}
```

### Store Order Status Enum
```typescript
enum StoreOrderStatus {
  GENERATED = 'GENERATED',
  ACKNOWLEDGED = 'ACKNOWLEDGED',
  IN_PRODUCTION = 'IN_PRODUCTION',
  KITTING = 'KITTING',
  READY_TO_SHIP = 'READY_TO_SHIP',
  PARTIALLY_SHIPPED = 'PARTIALLY_SHIPPED',
  SHIPPED = 'SHIPPED',
  DELIVERED = 'DELIVERED',
  CLOSED = 'CLOSED',
  CANCELLED = 'CANCELLED',
}
```

### Order Type Enum
```typescript
enum OrderType {
  INITIAL = 'INITIAL',
  REORDER = 'REORDER',
}
```

### Shipment Status Enum
```typescript
enum ShipmentStatus {
  LABEL_CREATED = 'LABEL_CREATED',
  IN_TRANSIT = 'IN_TRANSIT',
  DELIVERED = 'DELIVERED',
  EXCEPTION = 'EXCEPTION',
  RETURNED = 'RETURNED',
}
```

### Photo Review Status Enum
```typescript
enum PhotoReviewStatus {
  PENDING = 'PENDING',
  APPROVED = 'APPROVED',
  REJECTED = 'REJECTED',
  SUPERSEDED = 'SUPERSEDED',
}
```

### Issue Type Enum
```typescript
enum IssueType {
  MISSING = 'MISSING',
  DAMAGED = 'DAMAGED',
  INCORRECT = 'INCORRECT',
  PACKAGING = 'PACKAGING',
}
```

### Issue Request Status Enum
```typescript
enum IssueRequestStatus {
  OPEN = 'OPEN',                       // Reported by store
  TRIAGED = 'TRIAGED',                 // Classified + routed
  AWAITING_APPROVAL = 'AWAITING_APPROVAL', // Brand approval required
  APPROVED = 'APPROVED',               // Allowed to fulfill fix
  IN_FULFILLMENT = 'IN_FULFILLMENT',   // PSP producing/shipping replacement
  DENIED = 'DENIED',                   // No action (terminal)
  RESOLVED = 'RESOLVED',               // Fixed (terminal)
}
```

### Rejection Reason Enum
```typescript
enum RejectionReason {
  BLURRY = 'BLURRY',
  WRONG_ANGLE = 'WRONG_ANGLE',
  WRONG_PLACEMENT = 'WRONG_PLACEMENT',
  DAMAGED = 'DAMAGED',
  INSUFFICIENT_LIGHTING = 'INSUFFICIENT_LIGHTING',
  OBSTRUCTION = 'OBSTRUCTION',
  OTHER = 'OTHER',
}
```

### Audit Actor Type Enum
```typescript
enum AuditActorType {
  HUMAN = 'HUMAN',
  SYSTEM = 'SYSTEM',
  INTEGRATION = 'INTEGRATION',
}
```

### Notification Channel Enum
```typescript
enum NotificationChannel {
  EMAIL = 'EMAIL',
  IN_APP = 'IN_APP',
  PUSH = 'PUSH',  // Future
}
```

### Export Format Enum
```typescript
enum ExportFormat {
  CSV = 'CSV',
  XLSX = 'XLSX',
  PDF = 'PDF',
  JSON = 'JSON',
  XML = 'XML',
}
```

### Export Job Status Enum
```typescript
enum ExportJobStatus {
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  EXPIRED = 'EXPIRED',
}
```

### Assignment Item Status Enum
```typescript
enum AssignmentItemStatus {
  PLANNED = 'PLANNED',             // Requirement exists from publish
  ORDERED = 'ORDERED',             // Ordered for this store
  SHIPPED = 'SHIPPED',             // In transit
  DELIVERED = 'DELIVERED',         // Delivered to store
  RECEIVED = 'RECEIVED',           // Store confirmed receipt
  INSTALLED = 'INSTALLED',         // Installed at slot
  PROOF_SUBMITTED = 'PROOF_SUBMITTED', // Proof submitted for review
  RETAKE_REQUIRED = 'RETAKE_REQUIRED', // Retake needed
  SATISFIED = 'SATISFIED',         // Meets rules (terminal)
  EXCEPTION = 'EXCEPTION',         // Waived/alternate (terminal)
}
```

### Slot Verification Status Enum
```typescript
enum SlotVerificationStatus {
  PENDING = 'PENDING',   // Waiting on required proofs
  SATISFIED = 'SATISFIED', // Meets all rules (terminal)
  REWORK = 'REWORK',     // Needs retake
  WAIVED = 'WAIVED',     // Accepted by exception (terminal)
}
```

---

## Derived Status Values (Computed)

These values are **computed from multiple source columns**, not stored directly. Include in application code but not as database enums.

### Fulfillment Status (Qty-Derived)
```typescript
// Computed from shippedQty, deliveredQty, requiredQty
enum FulfillmentStatus {
  NOT_SHIPPED = 'NOT_SHIPPED',         // shippedQty = 0
  PARTIALLY_SHIPPED = 'PARTIALLY_SHIPPED', // 0 < shippedQty < requiredQty
  SHIPPED = 'SHIPPED',                 // shippedQty >= requiredQty, deliveredQty = 0
  PARTIALLY_DELIVERED = 'PARTIALLY_DELIVERED', // 0 < deliveredQty < requiredQty
  DELIVERED = 'DELIVERED',             // deliveredQty >= requiredQty
  EXCEPTION = 'EXCEPTION',             // Unresolved carrier exception
  CANCELLED = 'CANCELLED',             // Order cancelled (terminal)
}
```

### Receipt Status (Qty-Derived)
```typescript
// Computed from deliveredQty, receivedGoodQty, receivedDamagedQty
enum ReceiptStatus {
  NOT_DELIVERED = 'NOT_DELIVERED',     // deliveredQty = 0
  NOT_RECEIVED = 'NOT_RECEIVED',       // Delivered but receivedTotal = 0
  PARTIALLY_RECEIVED = 'PARTIALLY_RECEIVED', // 0 < receivedTotal < deliveredQty
  RECEIVED_WITH_DAMAGE = 'RECEIVED_WITH_DAMAGE', // Received but damage reported
  RECEIVED = 'RECEIVED',               // Fully received, no damage
}
```

### Execution Status (Store-Owned)
```typescript
// Tracks store's progress through installation
enum ExecutionStatus {
  NOT_READY = 'NOT_READY',       // Readiness blocked
  READY = 'READY',               // Readiness true, not started
  IN_PROGRESS = 'IN_PROGRESS',   // Installs started
  SUBMITTED = 'SUBMITTED',       // Proofs submitted
  REWORK_REQUIRED = 'REWORK_REQUIRED', // Retake requested
  COMPLETE = 'COMPLETE',         // Marked complete
  REOPENED = 'REOPENED',         // Admin reopened
  BLOCKED = 'BLOCKED',           // Open issues block progress
}
```

### Verification Status (Brand-Owned)
```typescript
// Tracks photo verification progress
enum VerificationStatus {
  NA = 'NA',                           // Nothing submitted yet
  PENDING = 'PENDING',                 // Submission exists, not fully reviewed
  PARTIALLY_APPROVED = 'PARTIALLY_APPROVED', // Some satisfied, not all
  APPROVED = 'APPROVED',               // satisfiedQty >= requiredQty
  REJECTED = 'REJECTED',               // Any required proof rejected
  WAIVED = 'WAIVED',                   // Administratively waived
}
```

### Store Phase (Derived Headline)
```typescript
// Single display value for Brand dashboard. Computed by priority rules.
enum StorePhase {
  REWORK = 'REWORK',                   // Verification rejected OR rework required
  COMPLETE = 'COMPLETE',               // Execution complete + verified
  IN_REVIEW = 'IN_REVIEW',             // Submitted, awaiting review
  EXECUTING = 'EXECUTING',             // Store actively installing
  READY_TO_EXECUTE = 'READY_TO_EXECUTE', // Ready but not started
  BLOCKED_BY_EXCEPTION = 'BLOCKED_BY_EXCEPTION', // Open issue blocks work
  WAITING_FOR_SHIPMENT = 'WAITING_FOR_SHIPMENT', // Not shipped or partial
  IN_TRANSIT = 'IN_TRANSIT',           // Shipped, not delivered
  AWAITING_RECEIPT = 'AWAITING_RECEIPT', // Delivered, not received
  UNKNOWN = 'UNKNOWN',                 // Data inconsistency
}
```

---

## 1. Tenancy & Identity

### `tenants`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `name` | TEXT | NOT NULL | Display name |
| `slug` | TEXT | UNIQUE, NOT NULL | URL-safe identifier |
| `subscription_tier` | TEXT | NOT NULL | 'PILOT', 'STANDARD', 'ENTERPRISE' |
| `settings_json` | JSONB | DEFAULT '{}' | Tenant-level config |

### `brands`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `tenant_id` | UUID | FK tenants.id, NOT NULL | Parent PSP tenant |
| `name` | TEXT | NOT NULL | Brand display name |
| `code` | TEXT | UNIQUE per tenant | Short code (e.g., 'G2G') |
| `logo_url` | TEXT | | S3 URL |
| `settings_json` | JSONB | DEFAULT '{}' | Brand-level config |

### `users`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `email` | TEXT | UNIQUE, NOT NULL | Login identifier |
| `password_hash` | TEXT | NOT NULL | bcrypt hash |
| `full_name` | TEXT | NOT NULL | Display name |
| `is_global_admin` | BOOL | DEFAULT FALSE | Platform admin (v1 = false) |
| `last_login_at` | TIMESTAMPTZ | | Last authentication |

### `memberships`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `user_id` | UUID | FK users.id, NOT NULL | |
| `tenant_id` | UUID | FK tenants.id, NOT NULL | PSP scope |
| `brand_id` | UUID | FK brands.id, NULLABLE | NULL for PSP staff |
| `role` | Role | NOT NULL | See Role enum |
| `region_scope_id` | UUID | FK regions.id, NULLABLE | For REGIONAL_ADMIN |
| `store_scope_id` | UUID | FK stores.id, NULLABLE | For STORE_USER |

### `api_keys`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `tenant_id` | UUID | FK tenants.id, NOT NULL | Owner PSP |
| `key_hash` | TEXT | NOT NULL | SHA256 of key |
| `key_prefix` | TEXT | NOT NULL | First 8 chars for ID |
| `name` | TEXT | NOT NULL | Descriptive name |
| `scopes` | TEXT[] | DEFAULT '{}' | Permitted operations |
| `expires_at` | TIMESTAMPTZ | NULLABLE | Optional expiry |
| `last_used_at` | TIMESTAMPTZ | | |

---

## 2. Stores & Grouping

### `regions`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `name` | TEXT | NOT NULL | e.g., "West Coast" |
| `code` | TEXT | UNIQUE per brand | Short code |
| `parent_region_id` | UUID | FK regions.id, NULLABLE | For hierarchy |

### `districts`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `region_id` | UUID | FK regions.id, NOT NULL | Parent region |
| `name` | TEXT | NOT NULL | |
| `code` | TEXT | UNIQUE per brand | Short code |

### `territories`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `district_id` | UUID | FK districts.id, NULLABLE | Parent (optional) |
| `region_id` | UUID | FK regions.id, NOT NULL | Fallback parent |
| `name` | TEXT | NOT NULL | |
| `code` | TEXT | UNIQUE per brand | Short code |

### `stores`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `store_number` | TEXT | UNIQUE per brand, NOT NULL | Brand's identifier |
| `name` | TEXT | NOT NULL | Store display name |
| `address_line1` | TEXT | NOT NULL | |
| `address_line2` | TEXT | | |
| `city` | TEXT | NOT NULL | |
| `state` | TEXT | NOT NULL | State/Province |
| `zip_code` | TEXT | NOT NULL | Postal code |
| `country` | TEXT | DEFAULT 'US' | ISO country code |
| `region_id` | UUID | FK regions.id, NOT NULL | Geographic hierarchy |
| `district_id` | UUID | FK districts.id, NULLABLE | Optional layer |
| `territory_id` | UUID | FK territories.id, NULLABLE | Optional layer |
| `status` | StoreStatus | DEFAULT 'ACTIVE' | See enum |
| `primary_contact_name` | TEXT | | |
| `primary_contact_email` | TEXT | | |
| `primary_contact_phone` | TEXT | | |
| `store_manager_name` | TEXT | | |
| `external_store_guid` | TEXT | | External system mapping |
| `notes` | TEXT | | |

### `store_groups`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `name` | TEXT | NOT NULL | e.g., "High Volume" |
| `description` | TEXT | | |
| `created_by_user_id` | UUID | FK users.id | Creator |

### `store_group_memberships`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_id` | UUID | FK stores.id, NOT NULL | |
| `store_group_id` | UUID | FK store_groups.id, NOT NULL | |
| UNIQUE | | (store_id, store_group_id) | |

### `store_layouts`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_id` | UUID | FK stores.id, NOT NULL | |
| `version` | INT | DEFAULT 1 | For versioning |
| `is_current` | BOOL | DEFAULT TRUE | |
| `layout_json` | JSONB | | Full layout definition |

### `location_slots`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_layout_id` | UUID | FK store_layouts.id, NOT NULL | |
| `slot_name` | TEXT | NOT NULL | e.g., "Front Window" |
| `slot_type` | TEXT | NOT NULL | e.g., "WINDOW", "SHELF" |
| `sort_order` | INT | DEFAULT 0 | Display order |
| `dimensions` | JSONB | | Width/height if relevant |

---

## 3. Surveys & Photo Rules

### `survey_templates`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `name` | TEXT | NOT NULL | Template name |
| `description` | TEXT | | |
| `is_active` | BOOL | DEFAULT TRUE | |

### `survey_versions`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `survey_template_id` | UUID | FK survey_templates.id, NOT NULL | |
| `version_number` | INT | NOT NULL | Incrementing |
| `definition_json` | JSONB | NOT NULL | Full survey structure |
| `published_at` | TIMESTAMPTZ | | When made active |
| UNIQUE | | (survey_template_id, version_number) | |

### `photo_rules`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `name` | TEXT | NOT NULL | Rule set name |
| `min_photos` | INT | DEFAULT 1 | Minimum required |
| `max_photos` | INT | DEFAULT 5 | Maximum allowed |
| `require_flash` | BOOL | DEFAULT FALSE | |
| `min_resolution` | INT | | Minimum pixels |
| `ghost_image_url` | TEXT | | Reference overlay |
| `instructions` | TEXT | | User guidance |

---

## 4. Campaigns & Kits

### `campaigns`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `name` | TEXT | NOT NULL | Campaign name |
| `description` | TEXT | | |
| `start_date` | DATE | NOT NULL | Execution start |
| `end_date` | DATE | NOT NULL | Execution end |
| `status` | CampaignStatus | DEFAULT 'DRAFT' | See enum |
| `verification_mode` | VerificationMode | DEFAULT 'STRICT' | See enum |
| `psp_campaign_ref` | TEXT | | PSP's MIS ID |
| `selection_recipe_json` | JSONB | | Store selection criteria |
| `kit_definition_id` | UUID | FK kit_definitions.id | Linked kit |
| `survey_version_id` | UUID | FK survey_versions.id | Pinned survey |
| `published_at` | TIMESTAMPTZ | | When published |
| `published_by_user_id` | UUID | FK users.id | Who published |

### `kit_definitions`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NOT NULL | |
| `name` | TEXT | NOT NULL | Kit name |
| `description` | TEXT | | |
| `is_template` | BOOL | DEFAULT FALSE | Reusable template |

### `kit_items`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `kit_definition_id` | UUID | FK kit_definitions.id, NOT NULL | |
| `sku` | TEXT | NOT NULL | Product identifier |
| `name` | TEXT | NOT NULL | Item name |
| `description` | TEXT | | |
| `quantity` | INT | DEFAULT 1 | Per-store quantity |
| `slot_type` | TEXT | | e.g., "WINDOW" |
| `photo_rule_id` | UUID | FK photo_rules.id | Photo requirements |
| `sort_order` | INT | DEFAULT 0 | Display order |

### `store_assignments`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `campaign_id` | UUID | FK campaigns.id, NOT NULL | |
| `store_id` | UUID | FK stores.id, NOT NULL | |
| `status` | StoreAssignmentStatus | DEFAULT 'PENDING' | See enum |
| `assigned_at` | TIMESTAMPTZ | DEFAULT NOW | |
| `layout_version_id` | UUID | FK store_layouts.id | Pinned layout |
| `survey_version_id` | UUID | FK survey_versions.id | Pinned survey |
| UNIQUE | | (campaign_id, store_id) | |

### `assignment_items`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `kit_item_id` | UUID | FK kit_items.id, NOT NULL | |
| `location_slot_id` | UUID | FK location_slots.id, NULLABLE | Mapped slot |
| `quantity` | INT | DEFAULT 1 | |
| `status` | TEXT | DEFAULT 'PENDING' | Item-level status |

---

## 5. Fulfillment

### `store_orders`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `campaign_id` | UUID | FK campaigns.id, NOT NULL | |
| `store_id` | UUID | FK stores.id, NOT NULL | |
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `order_number` | TEXT | UNIQUE, NOT NULL | e.g., "ORD-1001" |
| `order_type` | OrderType | DEFAULT 'INITIAL' | See enum |
| `psp_order_ref` | TEXT | | PSP's MIS ID |
| `status` | StoreOrderStatus | DEFAULT 'GENERATED' | See enum |
| `acknowledged_at` | TIMESTAMPTZ | | When PSP ack'd |
| `shipping_address_snapshot` | JSONB | | Frozen at generation |
| `batch_label` | TEXT | | PSP batch tag (optional) |

### `order_lines`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_order_id` | UUID | FK store_orders.id, NOT NULL | |
| `kit_item_id` | UUID | FK kit_items.id, NOT NULL | |
| `quantity` | INT | NOT NULL | |
| `sku` | TEXT | NOT NULL | Denormalized |

### `shipments`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_order_id` | UUID | FK store_orders.id, NOT NULL | |
| `carrier` | TEXT | | UPS, FEDEX, etc. |
| `tracking_numbers` | JSONB | DEFAULT '[]' | Array of strings |
| `shipped_at` | TIMESTAMPTZ | | |
| `delivered_at` | TIMESTAMPTZ | | |
| `status` | ShipmentStatus | DEFAULT 'LABEL_CREATED' | See enum |

### `shipment_lines`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `shipment_id` | UUID | FK shipments.id, NOT NULL | |
| `kit_item_id` | UUID | FK kit_items.id, NOT NULL | |
| `quantity` | INT | NOT NULL | Qty in this box |

---

## 6. Execution & Verification

### `receive_verifications`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `verified_at` | TIMESTAMPTZ | DEFAULT NOW | |
| `verified_by_user_id` | UUID | FK users.id | |
| `all_items_received` | BOOL | DEFAULT TRUE | |
| `notes` | TEXT | | |

### `store_survey_responses`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `survey_version_id` | UUID | FK survey_versions.id, NOT NULL | |
| `response_json` | JSONB | NOT NULL | Full answers |
| `submitted_at` | TIMESTAMPTZ | | |
| `submitted_by_user_id` | UUID | FK users.id | |

### `photo_uploads`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `assignment_item_id` | UUID | FK assignment_items.id, NULLABLE | |
| `location_slot_id` | UUID | FK location_slots.id, NULLABLE | |
| `s3_key` | TEXT | NOT NULL | Storage path |
| `s3_url` | TEXT | | Presigned URL (cached) |
| `file_size_bytes` | INT | | |
| `mime_type` | TEXT | | image/jpeg, etc. |
| `review_status` | PhotoReviewStatus | DEFAULT 'PENDING' | See enum |
| `uploaded_at` | TIMESTAMPTZ | DEFAULT NOW | |
| `uploaded_by_user_id` | UUID | FK users.id | |

### `photo_reviews`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `photo_upload_id` | UUID | FK photo_uploads.id, NOT NULL | |
| `reviewer_user_id` | UUID | FK users.id, NOT NULL | |
| `status` | PhotoReviewStatus | NOT NULL | APPROVED/REJECTED |
| `rejection_reason` | RejectionReason | NULLABLE | If rejected |
| `rejection_comment` | TEXT | | Additional notes |
| `reviewed_at` | TIMESTAMPTZ | DEFAULT NOW | |

### `retake_requests`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `photo_upload_id` | UUID | FK photo_uploads.id, NOT NULL | Original photo |
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `reason` | RejectionReason | NOT NULL | |
| `comment` | TEXT | | Instructions |
| `requested_at` | TIMESTAMPTZ | DEFAULT NOW | |
| `completed_at` | TIMESTAMPTZ | | When retake submitted |
| `new_photo_upload_id` | UUID | FK photo_uploads.id, NULLABLE | Replacement |

---

## 7. Issues & Reorders

### `issue_requests`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `store_assignment_id` | UUID | FK store_assignments.id, NOT NULL | |
| `type` | IssueType | NOT NULL | See enum |
| `description` | TEXT | | |
| `status` | IssueRequestStatus | DEFAULT 'SUBMITTED' | See enum |
| `evidence_photo_id` | UUID | FK photo_uploads.id, NULLABLE | Damage photo |
| `submitted_at` | TIMESTAMPTZ | DEFAULT NOW | |
| `submitted_by_user_id` | UUID | FK users.id | |
| `reviewed_at` | TIMESTAMPTZ | | |
| `reviewed_by_user_id` | UUID | FK users.id | |

### `issue_lines`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `issue_request_id` | UUID | FK issue_requests.id, NOT NULL | |
| `kit_item_id` | UUID | FK kit_items.id, NOT NULL | |
| `quantity` | INT | DEFAULT 1 | Affected qty |

### `reorders`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `issue_request_id` | UUID | FK issue_requests.id, NOT NULL | Trigger |
| `store_order_id` | UUID | FK store_orders.id, NOT NULL | Generated order |
| `status` | StoreOrderStatus | | Tracks fulfillment |

---

## 8. Notifications & Preferences

### `notification_preferences`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `user_id` | UUID | FK users.id, NOT NULL | |
| `channel` | NotificationChannel | NOT NULL | See enum |
| `event_type` | TEXT | NOT NULL | e.g., "photo.rejected" |
| `enabled` | BOOL | DEFAULT TRUE | |
| UNIQUE | | (user_id, channel, event_type) | |

### `notifications`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `user_id` | UUID | FK users.id, NOT NULL | Recipient |
| `channel` | NotificationChannel | NOT NULL | |
| `event_type` | TEXT | NOT NULL | |
| `subject` | TEXT | | Email subject / title |
| `body` | TEXT | | Content |
| `action_url` | TEXT | | Deep link |
| `read_at` | TIMESTAMPTZ | | For in-app |
| `sent_at` | TIMESTAMPTZ | | When delivered |

---

## 9. Webhooks & Integration

### `webhook_endpoints`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `tenant_id` | UUID | FK tenants.id, NOT NULL | Owner |
| `url` | TEXT | NOT NULL | Destination URL |
| `secret` | TEXT | NOT NULL | HMAC signing key |
| `events` | TEXT[] | NOT NULL | Subscribed events |
| `is_active` | BOOL | DEFAULT TRUE | |
| `last_success_at` | TIMESTAMPTZ | | |
| `last_failure_at` | TIMESTAMPTZ | | |
| `failure_count` | INT | DEFAULT 0 | Consecutive failures |

### `webhook_deliveries`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `webhook_endpoint_id` | UUID | FK webhook_endpoints.id, NOT NULL | |
| `event_type` | TEXT | NOT NULL | e.g., "campaign.published" |
| `payload_json` | JSONB | NOT NULL | Event data |
| `status_code` | INT | | HTTP response |
| `response_body` | TEXT | | Truncated response |
| `attempt_count` | INT | DEFAULT 1 | |
| `next_retry_at` | TIMESTAMPTZ | | If failed |
| `delivered_at` | TIMESTAMPTZ | | Final success |

---

## 10. Exports & Jobs

### `export_jobs`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `brand_id` | UUID | FK brands.id, NULLABLE | Scope |
| `campaign_id` | UUID | FK campaigns.id, NULLABLE | Scope |
| `requested_by_user_id` | UUID | FK users.id, NOT NULL | |
| `export_type` | TEXT | NOT NULL | e.g., "campaign_summary" |
| `format` | ExportFormat | NOT NULL | See enum |
| `status` | ExportJobStatus | DEFAULT 'PENDING' | See enum |
| `parameters_json` | JSONB | | Filters, options |
| `s3_key` | TEXT | | Output file |
| `file_size_bytes` | INT | | |
| `started_at` | TIMESTAMPTZ | | |
| `completed_at` | TIMESTAMPTZ | | |
| `expires_at` | TIMESTAMPTZ | | Auto-delete |
| `error_message` | TEXT | | If failed |

---

## 11. Audit & Observability

### `audit_events`
| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| `tenant_id` | UUID | FK tenants.id, NOT NULL | |
| `brand_id` | UUID | FK brands.id, NULLABLE | |
| `actor_type` | AuditActorType | NOT NULL | See enum |
| `actor_user_id` | UUID | FK users.id, NULLABLE | If HUMAN |
| `actor_api_key_id` | UUID | FK api_keys.id, NULLABLE | If INTEGRATION |
| `action` | TEXT | NOT NULL | e.g., "campaign.published" |
| `entity_type` | TEXT | NOT NULL | e.g., "Campaign" |
| `entity_id` | UUID | NOT NULL | Target entity |
| `before_json` | JSONB | | State before |
| `after_json` | JSONB | | State after |
| `metadata_json` | JSONB | | Additional context |
| `ip_address` | TEXT | | Request origin |
| `user_agent` | TEXT | | Client info |

---

## Indexes (Recommended)

```sql
-- Frequently queried
CREATE INDEX idx_stores_brand_region ON stores(brand_id, region_id);
CREATE INDEX idx_stores_status ON stores(status) WHERE deleted_at IS NULL;
CREATE INDEX idx_campaigns_brand_status ON campaigns(brand_id, status);
CREATE INDEX idx_store_assignments_campaign ON store_assignments(campaign_id);
CREATE INDEX idx_store_assignments_store ON store_assignments(store_id);
CREATE INDEX idx_store_orders_campaign ON store_orders(campaign_id);
CREATE INDEX idx_store_orders_status ON store_orders(status);
CREATE INDEX idx_photo_uploads_assignment ON photo_uploads(store_assignment_id);
CREATE INDEX idx_photo_uploads_review_status ON photo_uploads(review_status);
CREATE INDEX idx_audit_events_entity ON audit_events(entity_type, entity_id);
CREATE INDEX idx_audit_events_tenant_time ON audit_events(tenant_id, created_at DESC);
```

---

## Changelog

| Version | Date | Changes |
|---------|------|---------|
| v0.9 | 2025-12-18 | Initial draft with core tables |
| v1.0 | 2025-12-18 | Added missing tables (kit_definitions, kit_items, location_slots, store_groups, audit_events, webhook_endpoints, export_jobs, notification_preferences). Defined all enums. Changed status to Locked. |
| v1.1 | 2025-12-19 | Aligned enums with Glossary: Updated CampaignStatus (added PUBLISHED, CANCELLED), StoreAssignmentStatus (added ASSIGNED, READY, REOPENED, WAIVED), IssueRequestStatus (renamed to match Glossary states). Added missing enums: AssignmentItemStatus, SlotVerificationStatus. Added derived status section: FulfillmentStatus, ReceiptStatus, ExecutionStatus, VerificationStatus, StorePhase. |

---

*End of SUPP-035*
