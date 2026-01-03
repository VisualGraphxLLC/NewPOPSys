# Appendix D: Glossary

## D.1 Abbreviations and Acronyms

| Abbreviation | Full Term | Description |
|--------------|-----------|-------------|
| **API** | Application Programming Interface | Standard protocol for software component communication |
| **AWS** | Amazon Web Services | Cloud computing platform used for hosting and storage |
| **BullMQ** | Bull Message Queue | Queue library for Node.js based on Redis for background jobs |
| **CI/CD** | Continuous Integration / Continuous Deployment | Automated software delivery pipeline |
| **CSV** | Comma-Separated Values | Plain text data format for tabular data |
| **DDL** | Data Definition Language | SQL statements for schema definition |
| **E2E** | End-to-End | Testing methodology covering full user flows |
| **ERD** | Entity Relationship Diagram | Database schema visualization |
| **HMAC** | Hash-based Message Authentication Code | Cryptographic authentication mechanism for webhooks |
| **JSON** | JavaScript Object Notation | Lightweight data interchange format |
| **JSONB** | JSON Binary | PostgreSQL binary JSON data type with indexing |
| **JTBD** | Jobs To Be Done | Product development methodology focusing on user goals |
| **LTS** | Long-Term Support | Software version with extended maintenance |
| **MIS** | Management Information System | Business reporting and analytics system |
| **NFR** | Non-Functional Requirement | System quality attributes (performance, security, etc.) |
| **ORM** | Object-Relational Mapping | Database abstraction layer (Drizzle) |
| **OTLP** | OpenTelemetry Protocol | Standard for transmitting telemetry data |
| **PK** | Primary Key | Unique database record identifier |
| **POP** | Point of Purchase | Marketing materials displayed at retail locations |
| **PSP** | Print Service Provider | Company producing and fulfilling POP materials |
| **PWA** | Progressive Web App | Web application with native app capabilities |
| **RBAC** | Role-Based Access Control | Permission system based on user roles |
| **REST** | Representational State Transfer | API architectural style |
| **S3** | Simple Storage Service | AWS object storage for files and photos |
| **SDK** | Software Development Kit | Tools for building applications |
| **SKU** | Stock Keeping Unit | Unique product identifier |
| **SLA** | Service Level Agreement | Performance and availability guarantees |
| **SOW** | Statement of Work | Project scope and requirements document |
| **SQL** | Structured Query Language | Database query language |
| **SRS** | Software Requirements Specification | This document |
| **SSO** | Single Sign-On | Unified authentication across systems |
| **SUPP** | Supplemental Specification | Additional technical requirements document |
| **TBD** | To Be Determined | Placeholder for undefined requirements |
| **UI** | User Interface | Visual elements users interact with |
| **ULID** | Universally Unique Lexicographically Sortable Identifier | Time-ordered unique ID format |
| **UUID** | Universally Unique Identifier | Standard unique ID format |
| **UX** | User Experience | Overall user satisfaction and usability |
| **XLSX** | Excel Spreadsheet Format | Microsoft Excel file format |
| **XML** | Extensible Markup Language | Data interchange format |

---

## D.2 Domain Terminology

### D.2.1 Core Business Entities

| Term | Definition |
|------|------------|
| **PspTenant** | Root tenant representing a PSP organization. The paying customer. All brands, users, and data belong to a tenant. Multi-tenant isolation is enforced at the database level. |
| **Brand** | A client brand managed by the PSP. Each brand has its own stores, campaigns, and settings. Represents the end customer of the PSP. |
| **Store** | A physical retail location where POP materials are installed. Identified by store number within a brand. Has geographic hierarchy assignment. |
| **Campaign** | A brand's promotional program with defined timeline, participating stores, and materials to install. The primary unit of work in the system. |
| **Kit** | The collection of POP items to be shipped and installed for a campaign. Defined by Brand Admin during campaign setup. |
| **KitItem** | A single item within a kit (e.g., "Window Cling 24x36", "Counter Card"). Has SKU, quantity, and photo requirements. |

### D.2.2 Campaign Types

| Term | Definition |
|------|------------|
| **Promotional Campaign** | Campaign with a defined end date that triggers deinstall workflow upon expiration. Materials are temporary. Also called "Expiring Campaign". |
| **Core Branding Campaign** | Campaign with no end date. Deinstall only triggered manually by admin action. Materials are permanent branding elements. Also called "Non-expiring Campaign" or "Evergreen Campaign". |

### D.2.3 Geographic Hierarchy

| Term | Definition |
|------|------------|
| **Region** | Top level of geographic hierarchy (required). Examples: "West Coast", "Northeast", "Central". Used for Regional Manager scoping. |
| **District** | Second level of geographic hierarchy (optional). Groups stores within a region. Examples: "SoCal", "Bay Area". |
| **Territory** | Third level of geographic hierarchy (optional). Most granular geographic grouping. Examples: "LA Metro", "SF Downtown". |
| **StoreGroup** | Custom, non-geographic grouping of stores. Used for targeting campaigns to specific store sets. A store can belong to multiple groups. Examples: "Premium Stores", "24-Hour Locations". |

### D.2.4 Survey and Layout

| Term | Definition |
|------|------------|
| **SurveyTemplate** | A reusable survey definition created by Brand Admin. Contains questions, sections, conditional logic, and validation rules. |
| **SurveyVersion** | An immutable snapshot of a SurveyTemplate. Campaigns pin to a specific version to ensure consistency across stores. |
| **StoreLayout** | Definition of a store's physical advertising locations. Describes where POP items can be placed. Versioned to support changes over time. |
| **LocationSlot** | A specific placement within a store where POP items can be installed. Examples: "Front Window - Left", "Counter Display - Register 1". |
| **PhotoRule** | Requirements for proof photos at a location slot. Specifies minimum/maximum photos, resolution requirements, and capture instructions. |

### D.2.5 Fulfillment Terms

| Term | Definition |
|------|------------|
| **StoreOrder** | An order generated when a campaign is published, representing what PSP needs to produce and ship to a store. One order per store per campaign. |
| **OrderLine** | A line item in a StoreOrder specifying SKU, quantity required, and fulfillment status. Maps to KitItems. |
| **Shipment** | A physical shipment sent by PSP to a store. An order may have multiple shipments (partial fulfillment). Contains carrier and tracking information. |
| **ShipmentLine** | Items included in a specific shipment. Enables tracking partial fulfillment when not all items ship together. |
| **Reorder** | A separate order generated to replace missing or damaged items reported through the issue workflow. |
| **Batch** | PSP grouping of orders for production efficiency. Types: PRODUCTION (manufacturing), PICK_PACK (warehouse), SHIP_WAVE (logistics), CUSTOM (ad-hoc). |

### D.2.6 Execution and Verification

| Term | Definition |
|------|------------|
| **StoreAssignment** | The record binding a Store to a Campaign. Tracks progress through the complete lifecycle from assignment to completion. |
| **AssignmentItem** | Individual kit item tracked at the store level. Maintains quantities and status through fulfillment and execution. |
| **ReceiveVerification** | Store's confirmation that a shipment was received with item-level acceptance, damage reporting, and quantity verification. |
| **CompletionSubmission** | Store's submission indicating installation is complete, including attestation checkbox and final comments. |
| **PhotoUpload** | A proof photo uploaded by the store. Tied to an item and/or location slot. Includes metadata like timestamp and GPS. |
| **PhotoReview** | An admin's review decision on a photo. States: PENDING, APPROVED, REJECTED. Includes reason codes for rejections. |
| **RetakeRequest** | A request for the store to retake a rejected photo. Includes reviewer feedback and deadline. |

### D.2.7 Issue Management

| Term | Definition |
|------|------------|
| **IssueRequest** | A store-reported problem requiring resolution. Created during receipt verification or later in the process. |
| **IssueLine** | A specific item and quantity affected by an issue. Multiple lines can be attached to one IssueRequest. |
| **IssueType** | Categories: MISSING (item not in shipment), DAMAGED (item arrived damaged), INCORRECT (wrong item shipped), PACKAGING (packaging issue only). |
| **IssueResolution** | How the issue was resolved: REORDER (replacement shipped), CREDIT (refund issued), WAIVED (no action needed), DENIED (not approved). |

### D.2.8 Workflow Terms

| Term | Definition |
|------|------------|
| **Campaign Publish** | Action that transitions campaign from DRAFT to PUBLISHED. Generates store assignments and orders. Triggers notifications to stores. |
| **Receipt Survey** | First-stage store survey upon delivery. Confirms items received, reports issues, captures receipt photos if required. |
| **Install Survey** | Second-stage store survey. Captures proof photos of installed items at designated location slots. |
| **Completion Attestation** | Store user's checkbox confirmation that installation is complete. Required before submission. |
| **Retake Loop** | Workflow cycle: rejected photos trigger RetakeRequest, store uploads new photo, admin reviews, repeat until approved or waived. |
| **Reorder Flow** | Issue approved triggers Reorder generation, PSP produces and ships replacement, store receives and verifies. |
| **Deinstall Task** | End-of-campaign task where store removes expired POP materials. Created automatically when promotional campaign ends. |
| **Waiver** | Administrative override marking a requirement satisfied without proof. Used for exceptions and edge cases. Requires justification. |
| **Reopen** | Admin action to unlock a COMPLETE store assignment for additional work. Creates audit trail. |
| **Split Shipment** | Order fulfilled via multiple shipments. Common when items have different production times. |

### D.2.9 Technical Terms

| Term | Definition |
|------|------------|
| **Rollup** | Aggregation of lower-level quantities to higher levels. Item quantities roll up to Store, Store metrics roll up to Campaign. |
| **Pinning** | Freezing a specific version of survey or layout to a store assignment. Ensures consistency even if template changes. |
| **Rebase** | Updating a pinned version to latest. May require re-verification. Admin action with confirmation. |
| **Idempotency Key** | Unique identifier ensuring API request processed only once. Prevents duplicate orders or actions on retry. |
| **Soft Delete** | Marking records as deleted (deleted_at timestamp) without physical removal. Preserves audit history. |
| **Event Outbox** | Pattern for reliable webhook/event dispatch with retries. Ensures external systems receive all notifications. |
| **Tenant Isolation** | Database-level separation ensuring one tenant cannot access another's data. Enforced via Row-Level Security (RLS). |

### D.2.10 Verification Modes

| Term | Definition |
|------|------------|
| **STRICT Mode** | Every photo requires explicit approval by reviewer before store can complete. Default for high-compliance campaigns. |
| **FAST Mode** | Photos auto-approve unless explicitly flagged. Store completes immediately on submission. Used for trusted stores or low-risk campaigns. |
| **Hybrid Mode** | Some items require strict verification, others auto-approve. Configured per KitItem. |

---

## D.3 User Roles (Personas)

### D.3.1 PSP Level Roles

| Role | Definition |
|------|------------|
| **Platform Admin** | Highest privilege. Full system configuration, tenant management, user impersonation for support. Internal PSP IT staff. |
| **PSP Admin** | Brand onboarding, PSP-level settings, user management, reporting and exports. Day-to-day PSP operations manager. |
| **Production Operator** | Updates order statuses, creates shipments and tracking, processes batches. Warehouse and fulfillment staff. |

### D.3.2 Brand Level Roles

| Role | Definition |
|------|------------|
| **Brand Admin** | Full brand configuration, all campaigns access, store management, user permissions. Primary brand contact at PSP. |
| **Campaign Manager** | Brand Admin scoped to assigned campaigns only. Manages specific campaigns without full brand access. |
| **Regional Manager** | Exception-first workflow. Reviews photos, handles escalations, scoped to assigned region. Field operations role. |

### D.3.3 Store Level Roles

| Role | Definition |
|------|------------|
| **Store Manager** | Store-level authority. Manages team, approves replacements, full execution permissions. Store general manager. |
| **Store Operator** | Execution-only permissions. Complete surveys, update status, request replacements. Store associate or merchandiser. |

### D.3.4 System Level Roles

| Role | Definition |
|------|------------|
| **Integration User** | Service account for API/webhook operations. No UI access. Used for system-to-system communication. |

---

## D.4 Status Values

### D.4.1 Campaign Status

| Status | Description |
|--------|-------------|
| DRAFT | Being configured, not active |
| SCHEDULED | Set to publish at future date |
| PUBLISHED | Active, stores executing |
| COMPLETED | All stores satisfied or ended |
| CANCELLED | Terminated before completion |
| ARCHIVED | Historical, read-only |

### D.4.2 Store Assignment Status

| Status | Description |
|--------|-------------|
| ASSIGNED | Selected for campaign |
| READY | Materials delivered |
| IN_PROGRESS | Actively working |
| SUBMITTED | Photos pending review |
| COMPLETE | All requirements met |
| REWORK_REQUIRED | Photos rejected |
| REOPENED | Unlocked for more work |
| WAIVED | Admin bypassed review |

### D.4.3 Photo Review Status

| Status | Description |
|--------|-------------|
| PENDING | Awaiting review |
| APPROVED | Accepted |
| REJECTED | Needs retake |
| SUPERSEDED | Replaced by retake |

### D.4.4 Issue Status

| Status | Description |
|--------|-------------|
| OPEN | Just reported |
| TRIAGED | Classified and routed |
| AWAITING_APPROVAL | Needs brand approval |
| APPROVED | Reorder authorized |
| DENIED | Rejected |
| IN_FULFILLMENT | Replacement shipping |
| RESOLVED | Replacement received |

---

## D.5 Industry Terms

| Term | Definition |
|------|------------|
| **Point of Purchase (POP)** | Marketing materials displayed at retail locations to influence buying decisions. |
| **Point of Sale (POS)** | Location where transactions occur; often used interchangeably with POP in retail context. |
| **Planogram** | Diagram showing how products and displays should be arranged in a store. |
| **Merchandising** | Activities to promote product sales including display setup and maintenance. |
| **Compliance** | Degree to which stores meet campaign requirements for installation and photo proof. |
| **Field Execution** | On-site activities at retail locations to implement marketing programs. |
| **Fulfillment** | Process of producing, packaging, and shipping materials to stores. |
| **Kitting** | Assembling multiple items into a single package for shipping. |
| **Proof of Performance** | Documentation (typically photos) proving marketing materials were properly installed. |
| **Retail Audit** | Verification visit to confirm in-store execution meets standards. |

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*Source: SRS 1.3 Definitions, SUPP-001, Domain Expert Interviews*
