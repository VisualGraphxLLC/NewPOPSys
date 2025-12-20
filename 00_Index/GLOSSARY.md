# NewPOPSys v1 — Glossary & Terminology Reference

> **Version**: v1.2
> **Status**: Active
> **Updated**: 2025-12-20
> **Sources**: SUPP-001, SUPP-002, SUPP-035, Status Tables, StorePhase Derivation, Status Glossary Concise

---

## Quick Navigation

- [System Modules](#system-modules)
- [Personas & Roles](#personas--roles)
- [Core Entities](#core-entities)
- [Status Enumerations](#status-enumerations)
- [Derived Status Values](#derived-status-values)
- [Event Triggers](#event-triggers)
- [Workflow Terminology](#workflow-terminology)
- [Technical Terms](#technical-terms)
- [Abbreviations](#abbreviations)

---

## System Modules

PopSystem is organized into four primary modules, each serving distinct user groups.

| Module | Description | Primary Users |
|--------|-------------|---------------|
| **Brand Admin Module** | Web portal for brand users to create campaigns, select stores, define kits, configure photo rules, and monitor execution dashboards. Includes survey builder and store management. | Brand Admin, Campaign Manager, Regional Manager |
| **Store Execution Module** | Mobile-first PWA where store users receive shipments, report issues, install POP materials, capture proof photos, and complete attestation. Offline-capable. | Store Manager, Store Operator |
| **PSP Operations Module** | Operations interface for PSP fulfillment team to manage orders, production batches, shipments, tracking, and reorders. Supports API integration with PSP MIS systems. | PSP Admin, Production Operator |
| **Platform Ops Module** | System administration and infrastructure module covering deployment, monitoring, webhooks, exports, rate limiting, observability, and support tools. | Platform Admin, Support Agent |

---

## Personas & Roles

### Role Enums (Stored in Database)

| Term | Definition | Module Access |
|------|------------|---------------|
| **PSP_ADMIN** | Tenant administrator responsible for system configuration, brand onboarding, security settings, and user permissions. Full access to PSP tenant. | PSP Operations, Admin Console |
| **PSP_OPS** | Fulfillment operations user who manages orders, production batches, shipments, tracking, and reorders. Can update via UI or API. | PSP Operations |
| **BRAND_ADMIN** | Brand administrator (also "Campaign Admin") who creates campaigns, selects stores, defines kits, sets verification rules, and monitors dashboards. | Brand Admin |
| **REGIONAL_ADMIN** | Regional oversight role with exception-first workflow. Reviews photos, handles escalations, applies waivers, and reopens stores. Scoped to geographic region. | Brand Admin (regional scope) |
| **STORE_USER** | Store employee who receives shipments, reports issues, installs POP materials, captures proof photos, and completes attestation. | Store Execution (mobile) |
| **INTEGRATION_USER** | Service account for PSP automation. Used for inbound API writes, webhook consumption, and export triggers. No UI access. | API only |

### Persona Names (Human-Readable)

These are display names for users based on their role and assignment scope.

| Persona | Mapped Role | Description |
|---------|-------------|-------------|
| **Platform Admin** | PSP_ADMIN + impersonation rights | Highest privilege. Full system configuration, tenant management, user impersonation for support, security and audit access. |
| **PSP Admin** | PSP_ADMIN | Brand onboarding, PSP-level settings, user management, reporting and exports. Cannot impersonate. |
| **Production Operator** | PSP_OPS | PSP fulfillment team member. Updates order statuses, creates shipments and tracking, processes batches, views fulfillment queues. |
| **Support Agent** | PSP_OPS + limited scope | Read-only access for support. Can view logs, replay webhooks, access audit explorer. Cannot modify data. |
| **Brand Admin** | BRAND_ADMIN | Full brand configuration, all campaigns access, store management, user permissions within brand. |
| **Campaign Manager** | BRAND_ADMIN + campaign assignment | Brand Admin scoped to assigned campaigns only. Cannot access campaigns they're not assigned to. |
| **Regional Manager** | REGIONAL_ADMIN | Exception-first workflow. Reviews photos, handles escalations, applies waivers, reopens stores. Scoped to assigned geographic region. |
| **Store Manager** | STORE_USER + full store access | Store-level authority. Can manage store team, approve replacement requests, view all store campaigns, full execution permissions. |
| **Store Operator** | STORE_USER + limited scope | Store staff with execution-only permissions. Complete surveys, update status, request replacements (requires Store Manager approval), view assigned campaigns only. |

---

## Core Entities

### Tenancy & Identity

| Entity | Definition |
|--------|------------|
| **PspTenant** | Root tenant representing a PSP (Print Service Provider) organization. The paying customer. All brands, users, and data belong to a tenant. |
| **Brand** | A client brand managed by the PSP. Each brand has its own stores, campaigns, and settings. Belongs to exactly one PspTenant. |
| **User** | A human user with authentication credentials. Can have multiple memberships across brands with different roles. |
| **Membership** | The binding between a User and a Brand with a specific Role. Defines what a user can access and do. |
| **ApiKey** | Authentication credential for integrations (INTEGRATION_USER). Has scopes limiting permitted operations and optional expiration. |
| **AuditEvent** | Immutable log entry recording who did what, when. Includes actor type (HUMAN, SYSTEM, INTEGRATION), action, entity, and before/after state. |

### Stores & Geography

| Entity | Definition |
|--------|------------|
| **Store** | A physical retail location where POP materials are installed. Has address, contacts, and belongs to a geographic hierarchy. |
| **Region** | Top level of geographic hierarchy (required). Examples: "West Coast", "Northeast". |
| **District** | Second level of geographic hierarchy (optional). Groups stores within a region. |
| **Territory** | Third level of geographic hierarchy (optional). Most granular geographic grouping. |
| **StoreGroup** | Custom, non-geographic grouping of stores. Used for targeting (e.g., "High Volume", "New Stores"). A store can belong to multiple groups. |
| **StoreLayout** | Definition of a store's physical advertising locations. Versioned to support changes over time. |
| **LocationSlot** | A specific placement within a store where POP items can be installed. Examples: "Front Window", "Checkout Counter", "Aisle Endcap". |

### Surveys & Photo Rules

| Entity | Definition |
|--------|------------|
| **SurveyTemplate** | A reusable survey definition created by Brand Admin. Contains questions, sections, and logic. |
| **SurveyVersion** | An immutable snapshot of a SurveyTemplate. Campaigns pin to a specific version to ensure consistency. |
| **PhotoRule** | Requirements for proof photos at a location slot. Includes min/max photos, resolution requirements, reference images, and instructions. |
| **StoreSurveyResponse** | A store's submitted answers to a survey, tied to a specific SurveyVersion. |

### Campaigns & Kits

| Entity | Definition |
|--------|------------|
| **Campaign** | A brand's promotional program with defined timeline, participating stores, and materials to install. The central organizing entity. See Campaign Types below. |
| **Promotional Campaign** | Campaign with defined end date that triggers deinstall workflow. Also called "Expiring Campaign". Requires removal of POP materials after expiration. |
| **Core Branding Campaign** | Campaign with no end date. Deinstall only triggered manually. Also called "Non-expiring Campaign". Used for permanent brand materials. |
| **SelectionRecipe** | The criteria used to select which stores participate in a campaign. Can include/exclude by region, group, or individual store. |
| **KitDefinition** | The collection of POP items to be shipped and installed for a campaign. Reusable as a template. |
| **KitItem** | A single item within a kit (e.g., "Window Cling 24x36", "Counter Card"). Has SKU, quantity, and photo requirements. |
| **StoreAssignment** | The record binding a Store to a Campaign. Tracks the store's progress through the campaign lifecycle. |
| **AssignmentItem** | A specific KitItem assigned to a store, potentially mapped to a LocationSlot. Tracks item-level quantities and status. |

### Fulfillment

| Entity | Definition |
|--------|------------|
| **StoreOrder** | An order generated when a campaign is published, representing what PSP needs to produce and ship to a store. |
| **OrderLine** | A line item in a StoreOrder specifying SKU and quantity. |
| **Shipment** | A physical shipment sent by PSP. An order may have multiple shipments (split/partial shipments). |
| **ShipmentLine** | Items included in a specific shipment. Enables tracking partial fulfillment at the item level. |
| **Reorder** | A separate order generated to replace missing/damaged items. Links to the original IssueRequest. |

### Execution & Verification

| Entity | Definition |
|--------|------------|
| **ReceiveVerification** | Store's confirmation that a shipment was received. Includes item-level acceptance/damage reporting. |
| **IssueRequest** | A store-reported problem (missing, damaged, incorrect items). May trigger a reorder. |
| **IssueLine** | A specific item and quantity affected by an issue. |
| **CompletionSubmission** | Store's submission indicating installation is complete, including attestation. |
| **PhotoUpload** | A proof photo uploaded by the store, tied to an AssignmentItem and/or LocationSlot. |
| **PhotoReview** | An admin's review decision on a photo (APPROVED/REJECTED with reason). |
| **RetakeRequest** | A request for the store to retake a rejected photo, with instructions. |

---

## Status Enumerations

### CampaignStatus
The lifecycle state of a campaign.

| Value | Definition |
|-------|------------|
| `DRAFT` | Campaign is being created/edited. Not visible to stores. |
| `SCHEDULED` | Campaign is finalized and scheduled for future start date. |
| `ACTIVE` | Campaign is live. Stores can execute. |
| `COMPLETED` | Campaign end date has passed. Execution window closed. |
| `ARCHIVED` | Campaign moved to archive. Historical reference only. |

### StoreOrderStatus
The fulfillment state of a store's order (PSP-owned).

| Value | Definition |
|-------|------------|
| `GENERATED` | Order created when campaign published. Awaiting PSP acknowledgment. |
| `ACKNOWLEDGED` | PSP confirmed receipt and assigned internal reference. |
| `IN_PRODUCTION` | Order is being produced/printed. |
| `KITTING` | Items being assembled into kit for shipment. |
| `READY_TO_SHIP` | Kit ready, awaiting carrier pickup. |
| `PARTIALLY_SHIPPED` | Some items shipped, more to follow (split shipment). |
| `SHIPPED` | All items shipped. In transit to store. |
| `DELIVERED` | Carrier confirmed delivery to store address. |
| `CLOSED` | Order fulfillment complete. No further action needed. |
| `CANCELLED` | Order cancelled (terminal state). |

### ShipmentStatus
The tracking state of a physical shipment.

| Value | Definition |
|-------|------------|
| `LABEL_CREATED` | Shipping label generated. Package not yet picked up. |
| `IN_TRANSIT` | Package picked up by carrier. En route to destination. |
| `DELIVERED` | Carrier confirmed delivery. |
| `EXCEPTION` | Carrier reported problem (address issue, damage, etc.). |
| `RETURNED` | Package returned to sender. |

### StoreAssignmentStatus
The execution state of a store's work on a campaign.

**Owner**: System (auto) + Brand/Regional (overrides)

| Value | Definition | Transitions |
|-------|------------|-------------|
| `ASSIGNED` | Store targeted; waiting on readiness. | → READY |
| `READY` | Store can execute. | → IN_PROGRESS |
| `IN_PROGRESS` | Store actively working. | → SUBMITTED |
| `SUBMITTED` | Awaiting review. | → COMPLETE, REWORK_REQUIRED |
| `REWORK_REQUIRED` | Retake requested. | → IN_PROGRESS, SUBMITTED |
| `COMPLETE` | Counts toward campaign completion. | → REOPENED |
| `REOPENED` | Admin reopened after complete. | → IN_PROGRESS |
| `WAIVED` | Complete by exception/waiver. | Terminal (audit required) |

### AssignmentItemStatus
The lifecycle of one promo item at one store slot.

**Owner**: System + Store + Verification

| Value | Definition | Transitions |
|-------|------------|-------------|
| `PLANNED` | Requirement exists from publish. | → ORDERED |
| `ORDERED` | Ordered for this store. | → SHIPPED |
| `SHIPPED` | In transit. | → DELIVERED |
| `DELIVERED` | Delivered to store. | → RECEIVED |
| `RECEIVED` | Store confirmed receipt. | → INSTALLED, EXCEPTION |
| `INSTALLED` | Installed at slot. | → PROOF_SUBMITTED |
| `PROOF_SUBMITTED` | Proof submitted for review. | → SATISFIED, RETAKE_REQUIRED |
| `RETAKE_REQUIRED` | Retake needed. | → PROOF_SUBMITTED |
| `SATISFIED` | Meets rules; counts toward completion. | Terminal (unless reopened) |
| `EXCEPTION` | Waived/alternate accepted/removal. | Terminal (audit required) |

### PhotoReviewStatus
The review state of a proof photo.

| Value | Definition |
|-------|------------|
| `PENDING` | Photo uploaded, awaiting review. |
| `APPROVED` | Photo meets requirements. Accepted. |
| `REJECTED` | Photo does not meet requirements. Retake required. |
| `SUPERSEDED` | Photo replaced by a newer upload (retake submitted). |

### IssueType
Categories of problems stores can report.

| Value | Definition |
|-------|------------|
| `MISSING` | Item not in shipment (expected but not received). |
| `DAMAGED` | Item arrived damaged/unusable. |
| `INCORRECT` | Wrong item shipped (different SKU than expected). |
| `PACKAGING` | Packaging damage that may affect contents. |

### IssueRequestStatus
The workflow state of an issue/reorder request.

**Owner**: Store (create) + PSP/Brand (resolve)

| Value | Definition | Transitions |
|-------|------------|-------------|
| `OPEN` | Reported by store. | → TRIAGED |
| `TRIAGED` | Classified + routed. | → AWAITING_APPROVAL, APPROVED, DENIED |
| `AWAITING_APPROVAL` | Brand approval required by policy. | → APPROVED, DENIED |
| `APPROVED` | Allowed to fulfill fix. | → IN_FULFILLMENT |
| `IN_FULFILLMENT` | PSP producing/shipping replacement. | → RESOLVED |
| `DENIED` | No action. | Terminal |
| `RESOLVED` | Fixed. | Terminal |

### SlotVerificationStatus
The verification state of a location slot.

**Owner**: System (rollup) + Brand/Regional (override)

| Value | Definition | Transitions |
|-------|------------|-------------|
| `PENDING` | Waiting on required proofs. | → SATISFIED, REWORK, WAIVED |
| `SATISFIED` | Meets all rules. | Terminal (unless reopened) |
| `REWORK` | Needs retake. | → PENDING |
| `WAIVED` | Accepted by exception. | Terminal (audit required) |

### RejectionReason
Reasons a photo may be rejected.

| Value | Definition |
|-------|------------|
| `BLURRY` | Image is out of focus or motion-blurred. |
| `WRONG_ANGLE` | Photo taken from incorrect angle per instructions. |
| `WRONG_PLACEMENT` | Item installed in wrong location. |
| `DAMAGED` | Photo shows damaged/defective installation. |
| `INSUFFICIENT_LIGHTING` | Too dark to verify installation. |
| `OBSTRUCTION` | Something blocking view of the installed item. |
| `OTHER` | Other reason (comment required). |

### VerificationMode
How a campaign handles photo review.

| Value | Definition |
|-------|------------|
| `STRICT` | Every photo requires explicit approval before store completion. |
| `FAST` | Photos auto-approve unless flagged. Store completes immediately on submission. |

### OrderType
Distinguishes original orders from replacements.

| Value | Definition |
|-------|------------|
| `INITIAL` | Original order generated when campaign published. |
| `REORDER` | Replacement order generated from approved issue. |

---

## Derived Status Values

These values are **computed from multiple source columns**, not stored directly.

### FulfillmentStatus (Qty-Derived)
Computed from `shippedQty`, `deliveredQty`, `requiredQty`.

| Value | Condition |
|-------|-----------|
| `NOT_SHIPPED` | `shippedQty = 0` |
| `PARTIALLY_SHIPPED` | `0 < shippedQty < requiredQty` |
| `SHIPPED` | `shippedQty >= requiredQty AND deliveredQty = 0` |
| `PARTIALLY_DELIVERED` | `0 < deliveredQty < requiredQty` |
| `DELIVERED` | `deliveredQty >= requiredQty` |
| `EXCEPTION` | Unresolved carrier exception (overrides above) |
| `CANCELLED` | Order cancelled (terminal) |

### ReceiptStatus (Qty-Derived)
Computed from `deliveredQty`, `receivedGoodQty`, `receivedDamagedQty`.

| Value | Condition |
|-------|-----------|
| `NOT_DELIVERED` | `deliveredQty = 0` |
| `NOT_RECEIVED` | Delivered but `receivedTotal = 0` |
| `PARTIALLY_RECEIVED` | `0 < receivedTotal < deliveredQty` |
| `RECEIVED_WITH_DAMAGE` | `receivedTotal >= deliveredQty AND receivedDamagedQty > 0` |
| `RECEIVED` | `receivedTotal >= deliveredQty AND receivedDamagedQty = 0` |

### ExecutionStatus (Store-Owned)
Tracks store's progress through installation.

| Value | Condition |
|-------|-----------|
| `NOT_READY` | Readiness blocked (policy/inventory) |
| `READY` | Readiness true, not started |
| `IN_PROGRESS` | Installs started (`installedQty > 0`) |
| `SUBMITTED` | Proofs submitted, awaiting review |
| `REWORK_REQUIRED` | Retake requested |
| `COMPLETE` | Completion allowed + store marked complete |
| `REOPENED` | Admin reopened after complete |
| `BLOCKED` | Explicit blocking (open issues + policy) |

### VerificationStatus (Brand-Owned)
Tracks photo verification progress.

| Value | Condition |
|-------|-----------|
| `NA` | Nothing submitted yet |
| `PENDING` | Submission exists, not fully reviewed |
| `PARTIALLY_APPROVED` | Some satisfied, not all |
| `APPROVED` | `satisfiedQty >= requiredQty` (or waived) |
| `REJECTED` | Any required proof rejected |
| `WAIVED` | Administratively waived (audit reason required) |

### StorePhase (Derived Headline)
Single display value computed from all status columns. Used in Brand dashboard.

| Priority | Condition | StorePhase |
|----------|-----------|------------|
| 1 | `VerificationStatus == REJECTED` OR `ExecutionStatus == REWORK_REQUIRED` | **REWORK** |
| 2 | `ExecutionStatus == COMPLETE` AND `VerificationStatus in {APPROVED, WAIVED}` | **COMPLETE** |
| 3 | `ExecutionStatus == SUBMITTED` OR `VerificationStatus in {PENDING, PARTIALLY_APPROVED}` | **IN_REVIEW** |
| 4 | `ExecutionStatus == IN_PROGRESS` | **EXECUTING** |
| 5 | `ExecutionStatus == READY` | **READY_TO_EXECUTE** |
| 6 | `hasOpenIssues == true` AND policy blocks execution | **BLOCKED_BY_EXCEPTION** |
| 7 | `FulfillmentStatus in {NOT_SHIPPED, PARTIALLY_SHIPPED}` | **WAITING_FOR_SHIPMENT** |
| 8 | `FulfillmentStatus in {SHIPPED, PARTIALLY_DELIVERED}` | **IN_TRANSIT** |
| 9 | `FulfillmentStatus == DELIVERED` AND `ReceiptStatus in {NOT_RECEIVED, PARTIALLY_RECEIVED}` | **AWAITING_RECEIPT** |
| 10 | else | **UNKNOWN** (data inconsistency) |

---

## Event Triggers

Stable event names for webhooks, API notifications, and internal messaging.

### Campaign Events
| Event | Description |
|-------|-------------|
| `campaign.published` | Campaign transitioned to PUBLISHED; assignments + orders generated |
| `campaign.completed` | Campaign marked COMPLETED (rollup satisfied or end date) |
| `campaign.cancelled` | Campaign terminated early |

### Order Events
| Event | Description |
|-------|-------------|
| `orders.generated` | Orders created for stores on campaign publish |
| `order.acknowledged` | PSP acknowledged order receipt |
| `order.status_changed` | Order status transitioned |

### Shipment Events
| Event | Description |
|-------|-------------|
| `shipment.created` | Shipment record created with tracking |
| `shipment.in_transit` | Shipment picked up by carrier |
| `shipment.delivered` | Shipment delivered to store |
| `shipment.exception` | Carrier reported exception |

### Store Execution Events
| Event | Description |
|-------|-------------|
| `store.receive_verified` | Store verified receipt of shipment |
| `install.recorded` | Installation recorded for item |
| `proof.submitted` | Proof photos submitted |
| `assignment.completed` | Store assignment marked complete |
| `assignment.waived` | Assignment waived by admin |
| `assignment.reopened` | Assignment reopened after completion |

### Review Events
| Event | Description |
|-------|-------------|
| `review.approved` | Photo approved by reviewer |
| `review.rejected` | Photo rejected with reason |
| `retake.requested` | Retake requested for rejected photo |
| `retake.submitted` | Retake photo uploaded |

### Issue Events
| Event | Description |
|-------|-------------|
| `issue.created` | Issue reported by store |
| `issue.triaged` | Issue classified and routed |
| `issue.approved` | Issue approved for reorder |
| `issue.denied` | Issue denied |
| `reorder.created` | Reorder generated from approved issue |
| `replacement.shipped` | Replacement shipment sent |

### Deinstall Events
| Event | Description |
|-------|-------------|
| `deinstall.scheduled` | Deinstall task scheduled for store |
| `deinstall.completed` | Deinstall completed by store |

---

## Workflow Terminology

| Term | Definition |
|------|------------|
| **Campaign Publish** | Action that transitions a campaign from DRAFT to SCHEDULED/ACTIVE, generates StoreAssignments and StoreOrders, and notifies PSP. |
| **Receipt Survey** | First-stage store survey upon delivery. Store confirms which items received, reports missing/damaged. |
| **Install Survey** | Second-stage store survey. Store captures proof photos of each installed item at its location slot. |
| **Completion Attestation** | Store user's checkbox confirmation that installation is complete, with userId + timestamp. |
| **Retake Loop** | Workflow where rejected photos trigger RetakeRequest → Store uploads new photo → Review → repeat until approved/waived. |
| **Reorder Flow** | IssueRequest approved → Reorder generated → PSP ships replacement → Store receives and installs. |
| **Deinstall Task** | End-of-campaign task where store removes expired POP materials. May require proof photos per campaign settings. |
| **Waiver** | Administrative override that marks a requirement as satisfied without proof. Requires reason and creates audit entry. |
| **Reopen** | Admin action to unlock a COMPLETE store for additional work. Creates audit entry. |
| **Split Shipment** | Order fulfilled via multiple shipments. System tracks item-level quantities across shipments. |
| **Batch** | PSP grouping of orders for production efficiency. Types: PRODUCTION, PICK_PACK, SHIP_WAVE, CUSTOM. **Note: Out of scope for v1.** |
| **Pre-install Checklist** | Brand-configurable safety and readiness acknowledgements required before store can begin installation. Items defined per campaign by Brand Admin. |
| **Force-complete** | Brand Admin action to mark a campaign as completed before all stores finish. Requires reason and creates audit entry. Triggers retention clock. |
| **Auto-approve** | Automatic approval of issue requests based on policy (e.g., low-value first-time requests). **Not enabled in v1 - all approvals are manual.** |

---

## Technical Terms

| Term | Definition |
|------|------------|
| **Rollup** | Aggregation of lower-level quantities to higher levels (Item → Store → Campaign). Used for dashboard percentages. |
| **Pinning** | Freezing a specific version of survey/layout to a store assignment, ensuring mid-campaign changes don't affect in-progress work. |
| **Rebase** | Updating a pinned version to latest, with rules for what requires re-verification. |
| **Idempotency Key** | Unique identifier for API requests ensuring the same request processed only once. Required for inbound mutations. |
| **HMAC-SHA256** | Cryptographic signature algorithm used for webhook verification. |
| **Soft Delete** | Marking records as deleted (`deleted_at` timestamp) without physical removal. Supports recovery and audit. |
| **MIS** | Management Information System. PSP's internal order management system. `pspOrderRef` links to MIS record. |
| **PWA** | Progressive Web App. Store mobile app is a PWA with offline-capable features. |

---

## Abbreviations

| Abbreviation | Full Term |
|--------------|-----------|
| **POP** | Point of Purchase (advertising materials in retail) |
| **PSP** | Print Service Provider |
| **MIS** | Management Information System |
| **RBAC** | Role-Based Access Control |
| **SLA** | Service Level Agreement |
| **SKU** | Stock Keeping Unit |
| **PWA** | Progressive Web App |
| **API** | Application Programming Interface |
| **HMAC** | Hash-based Message Authentication Code |
| **ERD** | Entity Relationship Diagram |
| **JTBD** | Jobs To Be Done |
| **UX** | User Experience |
| **UI** | User Interface |

---

## Cross-References

| Topic | Document |
|-------|----------|
| Persona workflows | [SUPP-001](../02_SUPPs/Shared_Foundations/SUPP-001%20-%20Shared%20Foundations%20-%20Persona%20Workflows%20JTBD%20Screens%20-%20v0.2.md) |
| Domain model | [SUPP-002](../02_SUPPs/Shared_Foundations/SUPP-002%20-%20Shared%20Foundations%20-%20Core%20Domain%20Model%20and%20State%20Machines%20-%20v0.3.md) |
| Field-level schema | [SUPP-035](../02_SUPPs/Platform_Ops_Agent_Harness/SUPP-035%20-%20Platform%20Ops%20-%20Agent%20Harness%20-%20Field%20Level%20Data%20Model%20Tables%20Fields%20Enums%20-%20v1.0.md) |
| Status tables | [Status Tables](../04_Reference/NewPOPSys_v1_Status_Tables.md) |
| StorePhase derivation | [StorePhase Derivation](../04_Reference/NewPOPSys_v1_StorePhase_Derivation.md) |
| Rollup algorithm | [Rollup Algorithm](../04_Reference/NewPOPSys_v1_Rollup_Algorithm.md) |
| Mermaid charts | [Mermaid Charts](../04_Reference/NewPOPSys_v1_Mermaid_Charts.md) |
| API contract | [OpenAPI Spec](../../API/openapi.yaml) |

---

*End of Glossary*
