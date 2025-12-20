-- ==============================================================================
-- ENUM REFERENCE DATA - NewPOPSys v1
-- ==============================================================================
-- This file documents all enum types defined in 00_foundation_ddl.sql
-- The enums are already created via CREATE TYPE statements in the foundation DDL.
-- This file serves as a reference document for enum values and their meanings.
--
-- Dependencies: 00_foundation_ddl.sql (enums must exist)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- ENUM TYPE: role_enum
-- ==============================================================================
-- Purpose: RBAC role assignments for platform users
-- Source: SUPP-003 (Access Control)
-- Values:
--   - PLATFORM_ADMIN: Full system access + impersonation capabilities (future)
--   - PSP_ADMIN: PSP tenant administrator
--   - PSP_OPS: Production/fulfillment operations team
--   - BRAND_ADMIN: Full access to brand resources
--   - CAMPAIGN_MANAGER: Campaign-scoped brand user
--   - REGIONAL_MANAGER: Region-scoped oversight (requires region_scope_id)
--   - STORE_MANAGER: Full store privileges (requires store_scope_id)
--   - STORE_OPERATOR: Store execution only (requires store_scope_id)

COMMENT ON TYPE role_enum IS 'RBAC role assignments for platform users (8 roles from SUPP-003)';

-- ==============================================================================
-- ENUM TYPE: store_status_enum
-- ==============================================================================
-- Purpose: Store operational status
-- Values:
--   - ACTIVE: Store is operational and available for campaigns
--   - INACTIVE: Store is not operational but not closed
--   - TEMP_CLOSED: Temporarily closed (renovation, etc.)
--   - CLOSED: Permanently closed

COMMENT ON TYPE store_status_enum IS 'Store operational status (ACTIVE, INACTIVE, TEMP_CLOSED, CLOSED)';

-- ==============================================================================
-- ENUM TYPE: campaign_status_enum
-- ==============================================================================
-- Purpose: Campaign lifecycle status
-- Source: SUPP-002 (Core Domain)
-- Values:
--   - DRAFT: Campaign being created/edited
--   - SCHEDULED: Campaign scheduled for future publication
--   - PUBLISHED: Campaign active and stores can execute
--   - COMPLETED: Campaign execution period ended
--   - CANCELLED: Campaign cancelled before completion
--   - ARCHIVED: Campaign archived for historical purposes

COMMENT ON TYPE campaign_status_enum IS 'Campaign lifecycle status (DRAFT → PUBLISHED → COMPLETED → ARCHIVED)';

-- ==============================================================================
-- ENUM TYPE: verification_mode_enum
-- ==============================================================================
-- Purpose: Photo review workflow mode
-- Source: SUPP-017 (Photo Requirements)
-- Values:
--   - STRICT: Every photo requires manual review before approval
--   - FAST: Auto-approve photos unless flagged by rules/ML

COMMENT ON TYPE verification_mode_enum IS 'Photo review workflow mode (STRICT requires manual review, FAST auto-approves)';

-- ==============================================================================
-- ENUM TYPE: store_assignment_status_enum
-- ==============================================================================
-- Purpose: Store assignment execution status
-- Source: SUPP-002 (Core Domain)
-- Values:
--   - ASSIGNED: Store assigned to campaign, not ready yet
--   - READY: Store ready to execute (materials received)
--   - IN_PROGRESS: Store actively executing campaign
--   - SUBMITTED: Store submitted completion for review
--   - REWORK_REQUIRED: Store must fix issues before approval
--   - COMPLETE: Store execution approved and complete
--   - REOPENED: Completed assignment reopened for corrections
--   - WAIVED: Store execution waived/excused

COMMENT ON TYPE store_assignment_status_enum IS 'Store assignment execution status (ASSIGNED → READY → IN_PROGRESS → SUBMITTED → COMPLETE)';

-- ==============================================================================
-- ENUM TYPE: store_order_status_enum
-- ==============================================================================
-- Purpose: Store order fulfillment status
-- Source: SUPP-015 (Fulfillment)
-- Values:
--   - GENERATED: Order created by system from campaign publish
--   - ACKNOWLEDGED: PSP acknowledged order receipt
--   - IN_PRODUCTION: PSP producing materials
--   - KITTING: PSP assembling kit items
--   - READY_TO_SHIP: Order ready for shipment
--   - PARTIALLY_SHIPPED: Some items shipped, more pending
--   - SHIPPED: All items shipped
--   - DELIVERED: All shipments delivered
--   - CLOSED: Order administratively closed
--   - CANCELLED: Order cancelled

COMMENT ON TYPE store_order_status_enum IS 'Store order fulfillment status (GENERATED → ACKNOWLEDGED → IN_PRODUCTION → SHIPPED → DELIVERED)';

-- ==============================================================================
-- ENUM TYPE: order_type_enum
-- ==============================================================================
-- Purpose: Distinguish initial orders from reorders
-- Source: SUPP-016 (Issues & Reorders)
-- Values:
--   - INITIAL: Original campaign order
--   - REORDER: Replacement order for issues

COMMENT ON TYPE order_type_enum IS 'Order type (INITIAL = campaign order, REORDER = issue replacement)';

-- ==============================================================================
-- ENUM TYPE: shipment_status_enum
-- ==============================================================================
-- Purpose: Individual shipment tracking status
-- Source: SUPP-015 (Fulfillment)
-- Values:
--   - LABEL_CREATED: Shipping label generated
--   - IN_TRANSIT: Package in carrier network
--   - DELIVERED: Package delivered to store
--   - EXCEPTION: Delivery exception (address issue, etc.)
--   - RETURNED: Package returned to sender

COMMENT ON TYPE shipment_status_enum IS 'Individual shipment tracking status (LABEL_CREATED → IN_TRANSIT → DELIVERED)';

-- ==============================================================================
-- ENUM TYPE: photo_review_status_enum
-- ==============================================================================
-- Purpose: Photo review approval status
-- Source: SUPP-017 (Photo Requirements)
-- Values:
--   - PENDING: Photo awaiting review
--   - APPROVED: Photo approved by reviewer
--   - REJECTED: Photo rejected, retake required
--   - SUPERSEDED: Photo replaced by newer upload

COMMENT ON TYPE photo_review_status_enum IS 'Photo review approval status (PENDING → APPROVED or REJECTED or SUPERSEDED)';

-- ==============================================================================
-- ENUM TYPE: issue_type_enum
-- ==============================================================================
-- Purpose: Issue request classification
-- Source: SUPP-016 (Issues & Reorders)
-- Values:
--   - MISSING: Item not received in shipment
--   - DAMAGED: Item received but damaged
--   - INCORRECT: Wrong item received
--   - PACKAGING: Packaging issue

COMMENT ON TYPE issue_type_enum IS 'Issue request classification (MISSING, DAMAGED, INCORRECT, PACKAGING)';

-- ==============================================================================
-- ENUM TYPE: issue_request_status_enum
-- ==============================================================================
-- Purpose: Issue request workflow status
-- Source: SUPP-016 (Issues & Reorders)
-- Values:
--   - OPEN: Issue submitted by store
--   - TRIAGED: Issue reviewed and categorized
--   - AWAITING_APPROVAL: Issue pending approval decision
--   - APPROVED: Issue approved for reorder
--   - IN_FULFILLMENT: Reorder being fulfilled
--   - DENIED: Issue denied (no reorder)
--   - RESOLVED: Issue fully resolved

COMMENT ON TYPE issue_request_status_enum IS 'Issue request workflow status (OPEN → TRIAGED → APPROVED → IN_FULFILLMENT → RESOLVED)';

-- ==============================================================================
-- ENUM TYPE: rejection_reason_enum
-- ==============================================================================
-- Purpose: Photo rejection reason codes
-- Source: SUPP-017 (Photo Requirements)
-- Values:
--   - BLURRY: Photo too blurry to verify
--   - WRONG_ANGLE: Photo angle doesn't meet requirements
--   - WRONG_PLACEMENT: Item placed incorrectly
--   - DAMAGED: Photo shows damaged materials
--   - INSUFFICIENT_LIGHTING: Poor lighting quality
--   - OBSTRUCTION: View obstructed
--   - OTHER: Other reason (requires notes)

COMMENT ON TYPE rejection_reason_enum IS 'Photo rejection reason codes (BLURRY, WRONG_ANGLE, WRONG_PLACEMENT, etc.)';

-- ==============================================================================
-- ENUM TYPE: audit_actor_type_enum
-- ==============================================================================
-- Purpose: Audit event actor classification
-- Source: SUPP-035 (Audit & Observability)
-- Values:
--   - HUMAN: Action performed by user
--   - SYSTEM: Action performed by automated system process
--   - INTEGRATION: Action performed by external integration (API key)

COMMENT ON TYPE audit_actor_type_enum IS 'Audit event actor classification (HUMAN, SYSTEM, INTEGRATION)';

-- ==============================================================================
-- ENUM TYPE: notification_channel_enum
-- ==============================================================================
-- Purpose: Notification delivery channels
-- Source: SUPP-018 (Notifications)
-- Values:
--   - EMAIL: Email notification
--   - IN_APP: In-application notification
--   - PUSH: Push notification (future)

COMMENT ON TYPE notification_channel_enum IS 'Notification delivery channels (EMAIL, IN_APP, PUSH)';

-- ==============================================================================
-- ENUM TYPE: export_format_enum
-- ==============================================================================
-- Purpose: Export file format options
-- Source: SUPP-019 (Exports)
-- Values:
--   - CSV: Comma-separated values
--   - XLSX: Excel spreadsheet
--   - PDF: PDF document
--   - JSON: JSON data
--   - XML: XML data

COMMENT ON TYPE export_format_enum IS 'Export file format options (CSV, XLSX, PDF, JSON, XML)';

-- ==============================================================================
-- ENUM TYPE: export_job_status_enum
-- ==============================================================================
-- Purpose: Export job processing status
-- Source: SUPP-019 (Exports)
-- Values:
--   - PENDING: Export job queued
--   - PROCESSING: Export job in progress
--   - COMPLETED: Export job completed successfully
--   - FAILED: Export job failed
--   - EXPIRED: Export file expired and deleted

COMMENT ON TYPE export_job_status_enum IS 'Export job processing status (PENDING → PROCESSING → COMPLETED or FAILED)';

-- ==============================================================================
-- ENUM TYPE: assignment_item_status_enum
-- ==============================================================================
-- Purpose: Individual assignment item lifecycle status
-- Source: SUPP-035 (Assignment Items)
-- Values:
--   - PLANNED: Item planned for assignment
--   - ORDERED: Item included in order
--   - SHIPPED: Item shipped to store
--   - DELIVERED: Item delivered to store
--   - RECEIVED: Store confirmed receipt
--   - INSTALLED: Store installed item
--   - PROOF_SUBMITTED: Store submitted proof photo
--   - RETAKE_REQUIRED: Photo rejected, retake needed
--   - SATISFIED: Item fully satisfied (approved)
--   - EXCEPTION: Item has unresolved issue

COMMENT ON TYPE assignment_item_status_enum IS 'Assignment item lifecycle status (PLANNED → ORDERED → SHIPPED → DELIVERED → RECEIVED → INSTALLED → PROOF_SUBMITTED → SATISFIED)';

-- ==============================================================================
-- ENUM TYPE: slot_verification_status_enum
-- ==============================================================================
-- Purpose: Location slot verification status
-- Source: SUPP-035 (Location Slots)
-- Values:
--   - PENDING: Slot awaiting verification
--   - SATISFIED: Slot verification complete and approved
--   - REWORK: Slot requires rework
--   - WAIVED: Slot verification waived

COMMENT ON TYPE slot_verification_status_enum IS 'Location slot verification status (PENDING → SATISFIED or REWORK or WAIVED)';

-- ==============================================================================
-- END OF ENUM REFERENCE DATA
-- ==============================================================================
