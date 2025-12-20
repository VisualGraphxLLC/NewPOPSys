-- ==============================================================================
-- MISSING FIELDS DDL - NewPOPSys v1
-- ==============================================================================
-- Fields identified in gap analysis (00_ORCHESTRATION_LOG.md Section 1.2)
-- that are required by SUPP specifications but missing from SUPP-035.
--
-- Dependencies: All existing DDL files must be applied first
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- TABLE: tenants - Subscription & Capacity Fields
-- ==============================================================================
-- Purpose: Billing lifecycle and tenant capacity management

ALTER TABLE tenants
  ADD COLUMN IF NOT EXISTS subscription_start_date DATE,
  ADD COLUMN IF NOT EXISTS subscription_end_date DATE,
  ADD COLUMN IF NOT EXISTS max_brands INTEGER DEFAULT 10,
  ADD COLUMN IF NOT EXISTS max_users INTEGER DEFAULT 100;

COMMENT ON COLUMN tenants.subscription_start_date IS 'Start date of current subscription period';
COMMENT ON COLUMN tenants.subscription_end_date IS 'End date of current subscription period (NULL = no expiry)';
COMMENT ON COLUMN tenants.max_brands IS 'Maximum brands allowed under this tenant subscription';
COMMENT ON COLUMN tenants.max_users IS 'Maximum users allowed across all brands';


-- ==============================================================================
-- TABLE: brands - Support & Tier Fields
-- ==============================================================================
-- Purpose: Brand-level support routing and tier differentiation

ALTER TABLE brands
  ADD COLUMN IF NOT EXISTS brand_tier TEXT CHECK (brand_tier IN ('BASIC', 'STANDARD', 'PREMIUM', 'ENTERPRISE')),
  ADD COLUMN IF NOT EXISTS support_contact_email TEXT,
  ADD COLUMN IF NOT EXISTS support_contact_phone TEXT;

COMMENT ON COLUMN brands.brand_tier IS 'Brand service tier (may differ from tenant tier): BASIC, STANDARD, PREMIUM, ENTERPRISE';
COMMENT ON COLUMN brands.support_contact_email IS 'Primary support email for this brand';
COMMENT ON COLUMN brands.support_contact_phone IS 'Primary support phone for this brand';


-- ==============================================================================
-- TABLE: users - Profile & Security Fields
-- ==============================================================================
-- Purpose: User profile completeness and security features

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS phone_number TEXT,
  ADD COLUMN IF NOT EXISTS timezone TEXT DEFAULT 'UTC',
  ADD COLUMN IF NOT EXISTS locale TEXT DEFAULT 'en-US',
  ADD COLUMN IF NOT EXISTS profile_image_url TEXT,
  ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS email_verified_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS must_change_password BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS password_changed_at TIMESTAMPTZ;

COMMENT ON COLUMN users.phone_number IS 'User phone number for 2FA or notifications';
COMMENT ON COLUMN users.timezone IS 'User timezone for display formatting (IANA format, e.g., America/New_York)';
COMMENT ON COLUMN users.locale IS 'User locale for i18n (e.g., en-US, es-MX)';
COMMENT ON COLUMN users.profile_image_url IS 'URL to user avatar/profile image';
COMMENT ON COLUMN users.email_verified IS 'Whether user has verified their email address';
COMMENT ON COLUMN users.email_verified_at IS 'Timestamp when email was verified';
COMMENT ON COLUMN users.must_change_password IS 'Force password change on next login';
COMMENT ON COLUMN users.password_changed_at IS 'Last password change timestamp';


-- ==============================================================================
-- TABLE: memberships - Assignment & Access Tracking
-- ==============================================================================
-- Purpose: Temporal tracking of role assignments and security audit

ALTER TABLE memberships
  ADD COLUMN IF NOT EXISTS assigned_at TIMESTAMPTZ DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS assigned_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS last_access_at TIMESTAMPTZ;

-- Add foreign key for assigned_by
-- ALTER TABLE memberships
--   ADD CONSTRAINT fk_memberships_assigned_by
--   FOREIGN KEY (assigned_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN memberships.assigned_at IS 'When this role was assigned';
COMMENT ON COLUMN memberships.assigned_by_user_id IS 'User who assigned this role';
COMMENT ON COLUMN memberships.expires_at IS 'Optional expiration for temporary role grants';
COMMENT ON COLUMN memberships.last_access_at IS 'Last time user accessed resources under this role';

CREATE INDEX IF NOT EXISTS idx_memberships_expires ON memberships(expires_at)
  WHERE expires_at IS NOT NULL AND deleted_at IS NULL;


-- ==============================================================================
-- TABLE: campaigns - Lifecycle Audit Fields
-- ==============================================================================
-- Purpose: Full lifecycle audit trail for campaign management

ALTER TABLE campaigns
  ADD COLUMN IF NOT EXISTS created_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS locked_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS locked_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS archived_by_user_id UUID;

-- Foreign keys (commented for deferred constraint addition)
-- ALTER TABLE campaigns
--   ADD CONSTRAINT fk_campaigns_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_campaigns_locked_by FOREIGN KEY (locked_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_campaigns_archived_by FOREIGN KEY (archived_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN campaigns.created_by_user_id IS 'User who created the campaign';
COMMENT ON COLUMN campaigns.locked_at IS 'When campaign was locked for editing (after publish)';
COMMENT ON COLUMN campaigns.locked_by_user_id IS 'User who locked the campaign';
COMMENT ON COLUMN campaigns.archived_at IS 'When campaign was archived';
COMMENT ON COLUMN campaigns.archived_by_user_id IS 'User who archived the campaign';


-- ==============================================================================
-- TABLE: store_assignments - Execution Lifecycle Fields
-- ==============================================================================
-- Purpose: Status transition audit and blocking reason tracking

ALTER TABLE store_assignments
  ADD COLUMN IF NOT EXISTS readiness_blocked_reasons JSONB DEFAULT '[]'::jsonb,
  ADD COLUMN IF NOT EXISTS ready_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS started_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS submitted_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS submitted_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS completed_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS reopened_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS reopened_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS reopened_reason TEXT,
  ADD COLUMN IF NOT EXISTS waived_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS waived_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS waived_reason TEXT;

-- Foreign keys (commented for deferred constraint addition)
-- ALTER TABLE store_assignments
--   ADD CONSTRAINT fk_store_assignments_submitted_by FOREIGN KEY (submitted_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_store_assignments_completed_by FOREIGN KEY (completed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_store_assignments_reopened_by FOREIGN KEY (reopened_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_store_assignments_waived_by FOREIGN KEY (waived_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN store_assignments.readiness_blocked_reasons IS 'Array of blocking reasons preventing READY status (e.g., ["PENDING_SHIPMENT", "MISSING_LAYOUT"])';
COMMENT ON COLUMN store_assignments.ready_at IS 'When assignment became ready for execution';
COMMENT ON COLUMN store_assignments.started_at IS 'When store started execution (IN_PROGRESS)';
COMMENT ON COLUMN store_assignments.submitted_at IS 'When store submitted for review';
COMMENT ON COLUMN store_assignments.submitted_by_user_id IS 'Store user who submitted';
COMMENT ON COLUMN store_assignments.completed_at IS 'When assignment was marked complete';
COMMENT ON COLUMN store_assignments.completed_by_user_id IS 'User who marked complete (usually reviewer)';
COMMENT ON COLUMN store_assignments.reopened_at IS 'When assignment was reopened after completion';
COMMENT ON COLUMN store_assignments.reopened_by_user_id IS 'User who reopened the assignment';
COMMENT ON COLUMN store_assignments.reopened_reason IS 'Reason for reopening';
COMMENT ON COLUMN store_assignments.waived_at IS 'When assignment was waived (exempted)';
COMMENT ON COLUMN store_assignments.waived_by_user_id IS 'User who waived the assignment';
COMMENT ON COLUMN store_assignments.waived_reason IS 'Reason for waiving';


-- ==============================================================================
-- TABLE: store_orders - Order Lifecycle Fields
-- ==============================================================================
-- Purpose: Order lifecycle audit and cancellation tracking

ALTER TABLE store_orders
  ADD COLUMN IF NOT EXISTS generated_at TIMESTAMPTZ DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS generated_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS production_started_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS kitting_started_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS ready_to_ship_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS shipped_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS delivered_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS cancelled_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS cancelled_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS cancellation_reason TEXT,
  ADD COLUMN IF NOT EXISTS closed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS closed_by_user_id UUID;

-- Foreign keys (commented for deferred constraint addition)
-- ALTER TABLE store_orders
--   ADD CONSTRAINT fk_store_orders_generated_by FOREIGN KEY (generated_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_store_orders_cancelled_by FOREIGN KEY (cancelled_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_store_orders_closed_by FOREIGN KEY (closed_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN store_orders.generated_at IS 'When order was generated (on campaign publish)';
COMMENT ON COLUMN store_orders.generated_by_user_id IS 'User who triggered order generation (usually campaign publisher)';
COMMENT ON COLUMN store_orders.production_started_at IS 'When PSP started production';
COMMENT ON COLUMN store_orders.kitting_started_at IS 'When PSP started kitting';
COMMENT ON COLUMN store_orders.ready_to_ship_at IS 'When order was marked ready for shipping';
COMMENT ON COLUMN store_orders.shipped_at IS 'When first shipment was created';
COMMENT ON COLUMN store_orders.delivered_at IS 'When all shipments were delivered';
COMMENT ON COLUMN store_orders.cancelled_at IS 'When order was cancelled';
COMMENT ON COLUMN store_orders.cancelled_by_user_id IS 'User who cancelled the order';
COMMENT ON COLUMN store_orders.cancellation_reason IS 'Reason for order cancellation';
COMMENT ON COLUMN store_orders.closed_at IS 'When order was closed (complete or cancelled)';
COMMENT ON COLUMN store_orders.closed_by_user_id IS 'User who closed the order';


-- ==============================================================================
-- TABLE: assignment_items - Status Transition Timestamps
-- ==============================================================================
-- Purpose: Track lifecycle state transitions for audit and metrics

ALTER TABLE assignment_items
  ADD COLUMN IF NOT EXISTS planned_at TIMESTAMPTZ DEFAULT NOW(),
  ADD COLUMN IF NOT EXISTS ordered_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS shipped_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS delivered_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS received_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS installed_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS proof_submitted_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS satisfied_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS exception_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS exception_reason TEXT;

-- Quantity tracking fields (per SUPP-035 derived status)
ALTER TABLE assignment_items
  ADD COLUMN IF NOT EXISTS shipped_qty INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS delivered_qty INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS received_good_qty INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS received_damaged_qty INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS installed_qty INTEGER DEFAULT 0,
  ADD COLUMN IF NOT EXISTS satisfied_qty INTEGER DEFAULT 0;

COMMENT ON COLUMN assignment_items.planned_at IS 'When item was added to assignment';
COMMENT ON COLUMN assignment_items.ordered_at IS 'When item was included in store order';
COMMENT ON COLUMN assignment_items.shipped_at IS 'When item was first shipped';
COMMENT ON COLUMN assignment_items.delivered_at IS 'When item was delivered to store';
COMMENT ON COLUMN assignment_items.received_at IS 'When store confirmed receipt';
COMMENT ON COLUMN assignment_items.installed_at IS 'When item was installed at location';
COMMENT ON COLUMN assignment_items.proof_submitted_at IS 'When proof photo was submitted';
COMMENT ON COLUMN assignment_items.satisfied_at IS 'When item proof was approved';
COMMENT ON COLUMN assignment_items.exception_at IS 'When item was marked as exception';
COMMENT ON COLUMN assignment_items.exception_reason IS 'Reason for exception status';
COMMENT ON COLUMN assignment_items.shipped_qty IS 'Quantity shipped so far';
COMMENT ON COLUMN assignment_items.delivered_qty IS 'Quantity delivered so far';
COMMENT ON COLUMN assignment_items.received_good_qty IS 'Quantity received in good condition';
COMMENT ON COLUMN assignment_items.received_damaged_qty IS 'Quantity received damaged';
COMMENT ON COLUMN assignment_items.installed_qty IS 'Quantity installed';
COMMENT ON COLUMN assignment_items.satisfied_qty IS 'Quantity with approved proof photos';


-- ==============================================================================
-- TABLE: location_slots - Layout Position Fields
-- ==============================================================================
-- Purpose: Slot lifecycle and visual positioning for future layout builder

ALTER TABLE location_slots
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE,
  ADD COLUMN IF NOT EXISTS position_x INTEGER,
  ADD COLUMN IF NOT EXISTS position_y INTEGER,
  ADD COLUMN IF NOT EXISTS width INTEGER,
  ADD COLUMN IF NOT EXISTS height INTEGER;

COMMENT ON COLUMN location_slots.is_active IS 'Soft toggle for slot (vs deleted_at for permanent removal)';
COMMENT ON COLUMN location_slots.position_x IS 'X coordinate for visual layout builder (pixels from left)';
COMMENT ON COLUMN location_slots.position_y IS 'Y coordinate for visual layout builder (pixels from top)';
COMMENT ON COLUMN location_slots.width IS 'Slot width in visual layout builder (pixels)';
COMMENT ON COLUMN location_slots.height IS 'Slot height in visual layout builder (pixels)';

CREATE INDEX IF NOT EXISTS idx_location_slots_active ON location_slots(store_layout_id, is_active)
  WHERE deleted_at IS NULL;


-- ==============================================================================
-- TABLE: photo_rules - Lifecycle Fields
-- ==============================================================================
-- Purpose: Photo rule ownership and lifecycle management

ALTER TABLE photo_rules
  ADD COLUMN IF NOT EXISTS created_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

-- Foreign key (commented for deferred constraint addition)
-- ALTER TABLE photo_rules
--   ADD CONSTRAINT fk_photo_rules_created_by FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN photo_rules.created_by_user_id IS 'User who created this photo rule';
COMMENT ON COLUMN photo_rules.is_active IS 'Whether rule is available for use in new campaigns';

CREATE INDEX IF NOT EXISTS idx_photo_rules_active ON photo_rules(brand_id, is_active)
  WHERE deleted_at IS NULL;


-- ==============================================================================
-- TABLE: issue_requests - Status Lifecycle Fields
-- ==============================================================================
-- Purpose: Full lifecycle audit for issue resolution workflow

ALTER TABLE issue_requests
  ADD COLUMN IF NOT EXISTS triaged_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS triaged_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS triage_notes TEXT,
  ADD COLUMN IF NOT EXISTS priority TEXT CHECK (priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')),
  ADD COLUMN IF NOT EXISTS approved_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS approved_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS approval_notes TEXT,
  ADD COLUMN IF NOT EXISTS denied_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS denied_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS denial_reason TEXT,
  ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS resolved_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS resolution_notes TEXT,
  ADD COLUMN IF NOT EXISTS resolution_type TEXT CHECK (resolution_type IN ('REORDER', 'CREDIT', 'WAIVED', 'DUPLICATE', 'OTHER'));

-- Foreign keys (commented for deferred constraint addition)
-- ALTER TABLE issue_requests
--   ADD CONSTRAINT fk_issue_requests_triaged_by FOREIGN KEY (triaged_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_issue_requests_approved_by FOREIGN KEY (approved_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_issue_requests_denied_by FOREIGN KEY (denied_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
--   ADD CONSTRAINT fk_issue_requests_resolved_by FOREIGN KEY (resolved_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN issue_requests.triaged_at IS 'When issue was triaged/categorized';
COMMENT ON COLUMN issue_requests.triaged_by_user_id IS 'User who triaged the issue';
COMMENT ON COLUMN issue_requests.triage_notes IS 'Notes from triage process';
COMMENT ON COLUMN issue_requests.priority IS 'Issue priority: LOW, MEDIUM, HIGH, URGENT';
COMMENT ON COLUMN issue_requests.approved_at IS 'When issue was approved for resolution';
COMMENT ON COLUMN issue_requests.approved_by_user_id IS 'User who approved the issue';
COMMENT ON COLUMN issue_requests.approval_notes IS 'Notes from approval';
COMMENT ON COLUMN issue_requests.denied_at IS 'When issue was denied';
COMMENT ON COLUMN issue_requests.denied_by_user_id IS 'User who denied the issue';
COMMENT ON COLUMN issue_requests.denial_reason IS 'Reason for denial';
COMMENT ON COLUMN issue_requests.resolved_at IS 'When issue was fully resolved';
COMMENT ON COLUMN issue_requests.resolved_by_user_id IS 'User who resolved the issue';
COMMENT ON COLUMN issue_requests.resolution_notes IS 'Notes on resolution';
COMMENT ON COLUMN issue_requests.resolution_type IS 'How issue was resolved: REORDER, CREDIT, WAIVED, DUPLICATE, OTHER';

CREATE INDEX IF NOT EXISTS idx_issue_requests_priority ON issue_requests(priority, status)
  WHERE deleted_at IS NULL AND status NOT IN ('RESOLVED', 'DENIED');


-- ==============================================================================
-- TABLE: retake_requests - Resolution Fields
-- ==============================================================================
-- Purpose: Retake resolution tracking

-- Resolution status enum for retake requests
CREATE TYPE IF NOT EXISTS retake_resolution_enum AS ENUM (
  'PENDING',
  'COMPLETED',
  'APPROVED',
  'SUPERSEDED',
  'WAIVED',
  'EXPIRED'
);

ALTER TABLE retake_requests
  ADD COLUMN IF NOT EXISTS resolution_status TEXT DEFAULT 'PENDING'
    CHECK (resolution_status IN ('PENDING', 'COMPLETED', 'APPROVED', 'SUPERSEDED', 'WAIVED', 'EXPIRED')),
  ADD COLUMN IF NOT EXISTS resolved_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS resolved_by_user_id UUID,
  ADD COLUMN IF NOT EXISTS resolution_notes TEXT,
  ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ;

-- Foreign key (commented for deferred constraint addition)
-- ALTER TABLE retake_requests
--   ADD CONSTRAINT fk_retake_requests_resolved_by FOREIGN KEY (resolved_by_user_id) REFERENCES users(id) ON DELETE SET NULL;

COMMENT ON COLUMN retake_requests.resolution_status IS 'Retake resolution: PENDING, COMPLETED, APPROVED, SUPERSEDED, WAIVED, EXPIRED';
COMMENT ON COLUMN retake_requests.resolved_at IS 'When retake request was resolved';
COMMENT ON COLUMN retake_requests.resolved_by_user_id IS 'User who resolved the retake';
COMMENT ON COLUMN retake_requests.resolution_notes IS 'Notes on resolution';
COMMENT ON COLUMN retake_requests.expires_at IS 'Deadline for retake submission';

CREATE INDEX IF NOT EXISTS idx_retake_requests_pending ON retake_requests(store_assignment_id, resolution_status)
  WHERE resolution_status = 'PENDING' AND deleted_at IS NULL;


-- ==============================================================================
-- END OF MISSING FIELDS DDL
-- ==============================================================================
