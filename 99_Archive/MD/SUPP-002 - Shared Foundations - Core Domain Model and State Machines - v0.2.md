Date: 2025-12-17

Purpose: Canonical domain model and state machines for v1. This anchors data modeling, API contracts, reporting, and agentic development so implementations remain deterministic.

# Core Loop Anchor

Campaign → Store Assignment → Orders/Shipments (PSP) → Store Execution → Verification/Retakes → Visibility/Exports → Retention.

# Primary Entities (v1)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------
  Domain                              Entities
  ----------------------------------- --------------------------------------------------------------------------------------------------------------------------
  Tenancy & Identity                  PSP Tenant, Brand, User, Membership, Role, APIKey/IntegrationUser, AuditEvent

  Stores & Grouping                   Store, Region (optional hierarchy), District (optional), Territory (optional), StoreGroup, GroupMembership, StoreIdAlias

  Layouts/Surveys/Rules               StoreLayout, LocationSlot, SurveyTemplate, SurveyVersion, StoreSurveyResponse, RepeatableSection, PhotoRule, PhotoLink

  Campaigns/Kits/Assignment           Campaign, SelectionRecipe, StoreAssignment, KitDefinition, KitItemDefinition, AssignmentItem, RebaseEvent

  Fulfillment                         StoreOrder, OrderLine, Shipment, ShipmentLine, ShipmentTracking, Batch, BatchMembership

  Execution & Verification            StoreTask, ReceiveVerification, InstallRecord, CompletionSubmission, PhotoReview, SlotVerification, RetakeTask

  Issues/Reorders                     IssueRequest, IssueLine, ApprovalPolicy, ApprovalDecision, Reorder, NonComplianceCase, AssetSubstitution
  --------------------------------------------------------------------------------------------------------------------------------------------------------------

# Key Relationship Rules

- PSP is tenant root; brands exist within PSP tenant.

- Store belongs to exactly one Region node; District/Territory layers optional. Stores may belong to multiple StoreGroups.

- Store Assignment pins SurveyVersion + LayoutVersion by default; controlled rebase allowed with audit + verification tasks if fulfillment started.

- Photos always bind to: campaign + store + item + locationSlot + ruleId (never 'floating' campaign photos).

- Orders default: 1 store order per store per campaign; scaffold add-on orders later.

- Shipments: 0..N per order; partial shipments supported; shipment can have 1..N tracking numbers.

# Canonical Status Enumerations (v1)

  --------------------------------------------------------------------------------------------------------------------------------------------------------------
  Object                              States (v1)
  ----------------------------------- --------------------------------------------------------------------------------------------------------------------------
  Campaign                            DRAFT, SCHEDULED, ACTIVE, COMPLETED, ARCHIVED

  StoreAssignment Execution           IN_PROGRESS, SUBMITTED_FOR_REVIEW, REWORK_REQUESTED, COMPLETE

  Order                               GENERATED, ACKNOWLEDGED, IN_PRODUCTION, KITTING, READY_TO_SHIP, PARTIALLY_SHIPPED, SHIPPED, DELIVERED, CLOSED, CANCELLED

  Shipment                            LABEL_CREATED, IN_TRANSIT, DELIVERED, EXCEPTION, RETURNED

  PhotoReview                         PENDING, APPROVED, REJECTED, SUPERSEDED

  Issue/Reorder                       ISSUE_SUBMITTED, APPROVAL_PENDING, APPROVED, REJECTED, REORDER_IN_PRODUCTION, REORDER_SHIPPED, REORDER_DELIVERED, CLOSED

  NonComplianceCase                   OPEN, ACKNOWLEDGED, RESOLVED, WAIVED, CLOSED
  --------------------------------------------------------------------------------------------------------------------------------------------------------------

# State Machines (Mermaid - Reference)

Store Assignment Execution (assignment-level):

\`\`\`mermaid\
stateDiagram-v2\
\[\*\] \--\> IN_PROGRESS\
IN_PROGRESS \--\> SUBMITTED_FOR_REVIEW : store submits completion\
SUBMITTED_FOR_REVIEW \--\> COMPLETE : all proofs satisfied OR waiver\
SUBMITTED_FOR_REVIEW \--\> REWORK_REQUESTED : photo rejected (STRICT mode)\
COMPLETE \--\> REWORK_REQUESTED : photo rejected (FAST mode auto-reopen)\
REWORK_REQUESTED \--\> SUBMITTED_FOR_REVIEW : store resubmits retake\
COMPLETE \--\> IN_PROGRESS : admin reopens\
\`\`\`

Photo Review (photo-level):

\`\`\`mermaid\
stateDiagram-v2\
\[\*\] \--\> PENDING\
PENDING \--\> APPROVED\
PENDING \--\> REJECTED\
REJECTED \--\> PENDING : retake uploaded\
APPROVED \--\> SUPERSEDED : replaced\
PENDING \--\> SUPERSEDED : replaced before review\
\`\`\`

Fulfillment Order (store order):

\`\`\`mermaid\
stateDiagram-v2\
\[\*\] \--\> GENERATED\
GENERATED \--\> ACKNOWLEDGED\
ACKNOWLEDGED \--\> IN_PRODUCTION\
IN_PRODUCTION \--\> KITTING\
KITTING \--\> READY_TO_SHIP\
READY_TO_SHIP \--\> PARTIALLY_SHIPPED\
READY_TO_SHIP \--\> SHIPPED\
PARTIALLY_SHIPPED \--\> SHIPPED\
SHIPPED \--\> DELIVERED\
DELIVERED \--\> CLOSED\
GENERATED \--\> CANCELLED\
ACKNOWLEDGED \--\> CANCELLED\
\`\`\`

# Reporting & Export Dimensions

- Required query chain: campaign → store → item → locationSlot → proofs → review outcomes.

- All status transitions must emit immutable AuditEvents (actorType human\|integration).

- Exports must include stable identifiers + human-readable keys (storeNumber + GUID alias).

- Retention-aware: proof URLs may expire; exports include asset IDs/pointers.
