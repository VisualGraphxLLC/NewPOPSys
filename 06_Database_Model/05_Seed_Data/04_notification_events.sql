-- ==============================================================================
-- NOTIFICATION EVENT TYPES - NewPOPSys v1
-- ==============================================================================
-- Defines standard notification event types and their default channel preferences.
-- This file does not insert into notification_preferences directly (user-specific),
-- but documents the event types that the application should support.
--
-- Application code should use these event types when creating notifications
-- and should check user preferences for channel delivery.
--
-- Dependencies: 00_foundation_ddl.sql (notification tables must exist)
-- Version: 1.0
-- Created: 2025-12-19
-- ==============================================================================

-- ==============================================================================
-- NOTIFICATION EVENT TYPE REFERENCE
-- ==============================================================================

-- This is a reference document. The actual event types are stored as TEXT
-- in the notification_preferences.event_type and notifications.event_type columns.

-- Event Naming Convention: <entity>.<action>
-- Example: campaign.published, photo.rejected, shipment.delivered

-- ==============================================================================
-- CAMPAIGN EVENTS
-- ==============================================================================

-- Event: campaign.published
-- Description: Campaign published and stores can begin execution
-- Triggered: When campaign status changes to PUBLISHED
-- Recipients: Brand admins, campaign managers, assigned store users
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: campaign.scheduled
-- Description: Campaign scheduled for future publication
-- Triggered: When campaign status changes to SCHEDULED
-- Recipients: Brand admins, campaign managers
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: campaign.completed
-- Description: Campaign execution period ended
-- Triggered: When campaign status changes to COMPLETED
-- Recipients: Brand admins, campaign managers
-- Default Channels: EMAIL, IN_APP
-- Priority: MEDIUM

-- Event: campaign.cancelled
-- Description: Campaign cancelled before completion
-- Triggered: When campaign status changes to CANCELLED
-- Recipients: Brand admins, campaign managers, assigned store users
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- ==============================================================================
-- STORE ASSIGNMENT EVENTS
-- ==============================================================================

-- Event: assignment.created
-- Description: Store assigned to campaign
-- Triggered: When store_assignment created
-- Recipients: Store managers, store operators for that store
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: assignment.ready
-- Description: Store ready to execute (materials received)
-- Triggered: When store_assignment status changes to READY
-- Recipients: Store managers, store operators
-- Default Channels: IN_APP
-- Priority: HIGH

-- Event: assignment.submitted
-- Description: Store submitted completion for review
-- Triggered: When store_assignment status changes to SUBMITTED
-- Recipients: Brand admins, campaign managers
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: assignment.complete
-- Description: Store execution approved and complete
-- Triggered: When store_assignment status changes to COMPLETE
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: MEDIUM

-- Event: assignment.rework_required
-- Description: Store must fix issues before approval
-- Triggered: When store_assignment status changes to REWORK_REQUIRED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: assignment.reopened
-- Description: Completed assignment reopened for corrections
-- Triggered: When store_assignment status changes to REOPENED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- ==============================================================================
-- ORDER & FULFILLMENT EVENTS
-- ==============================================================================

-- Event: order.generated
-- Description: Order generated from campaign publish
-- Triggered: When store_order created with status GENERATED
-- Recipients: PSP ops team
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: order.acknowledged
-- Description: PSP acknowledged order receipt
-- Triggered: When store_order status changes to ACKNOWLEDGED
-- Recipients: Brand admins, campaign managers
-- Default Channels: IN_APP
-- Priority: LOW

-- Event: order.shipped
-- Description: Order shipped to store
-- Triggered: When store_order status changes to SHIPPED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: order.delivered
-- Description: Order delivered to store
-- Triggered: When store_order status changes to DELIVERED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- ==============================================================================
-- SHIPMENT EVENTS
-- ==============================================================================

-- Event: shipment.in_transit
-- Description: Shipment in carrier network
-- Triggered: When shipment status changes to IN_TRANSIT
-- Recipients: Store managers, store operators
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: shipment.delivered
-- Description: Shipment delivered to store
-- Triggered: When shipment status changes to DELIVERED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: shipment.exception
-- Description: Delivery exception occurred
-- Triggered: When shipment status changes to EXCEPTION
-- Recipients: Store managers, PSP ops team
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- ==============================================================================
-- PHOTO & VERIFICATION EVENTS
-- ==============================================================================

-- Event: photo.uploaded
-- Description: Photo uploaded by store
-- Triggered: When photo_upload created
-- Recipients: Brand admins (if STRICT mode)
-- Default Channels: IN_APP
-- Priority: LOW

-- Event: photo.approved
-- Description: Photo approved by reviewer
-- Triggered: When photo_review status changes to APPROVED
-- Recipients: Store managers, store operators
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: photo.rejected
-- Description: Photo rejected, retake required
-- Triggered: When photo_review status changes to REJECTED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: retake.requested
-- Description: Retake request created for rejected photo
-- Triggered: When retake_request created
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- ==============================================================================
-- ISSUE & REORDER EVENTS
-- ==============================================================================

-- Event: issue.submitted
-- Description: Issue request submitted by store
-- Triggered: When issue_request created
-- Recipients: PSP ops team, brand admins
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: issue.triaged
-- Description: Issue reviewed and categorized
-- Triggered: When issue_request status changes to TRIAGED
-- Recipients: Store managers
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: issue.approved
-- Description: Issue approved for reorder
-- Triggered: When issue_request status changes to APPROVED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: MEDIUM

-- Event: issue.denied
-- Description: Issue denied (no reorder)
-- Triggered: When issue_request status changes to DENIED
-- Recipients: Store managers, store operators
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- Event: issue.resolved
-- Description: Issue fully resolved
-- Triggered: When issue_request status changes to RESOLVED
-- Recipients: Store managers, store operators
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- Event: reorder.created
-- Description: Reorder generated from approved issue
-- Triggered: When reorder created
-- Recipients: PSP ops team, store managers
-- Default Channels: IN_APP
-- Priority: MEDIUM

-- ==============================================================================
-- EXPORT EVENTS
-- ==============================================================================

-- Event: export.completed
-- Description: Export job completed successfully
-- Triggered: When export_job status changes to COMPLETED
-- Recipients: User who requested export
-- Default Channels: EMAIL, IN_APP
-- Priority: MEDIUM

-- Event: export.failed
-- Description: Export job failed
-- Triggered: When export_job status changes to FAILED
-- Recipients: User who requested export
-- Default Channels: EMAIL, IN_APP
-- Priority: MEDIUM

-- Event: export.expired
-- Description: Export file expired and deleted
-- Triggered: When export_job expires_at reached
-- Recipients: User who requested export
-- Default Channels: IN_APP
-- Priority: LOW

-- ==============================================================================
-- WEBHOOK EVENTS
-- ==============================================================================

-- Event: webhook.delivery_failed
-- Description: Webhook delivery failed after max retries
-- Triggered: When webhook_delivery fails permanently
-- Recipients: Tenant admins, PSP admins
-- Default Channels: EMAIL, IN_APP
-- Priority: HIGH

-- ==============================================================================
-- USAGE EXAMPLES
-- ==============================================================================

-- Example 1: Creating a notification for campaign.published event
/*
INSERT INTO notifications (
  user_id,
  channel,
  event_type,
  subject,
  body,
  action_url,
  created_at
) VALUES (
  '...',  -- user_id
  'EMAIL',
  'campaign.published',
  'Campaign "Spring Refresh 2025" has been published',
  'The campaign is now live and stores can begin execution. View campaign details for more information.',
  'https://app.newpopsys.com/campaigns/...',
  NOW()
);
*/

-- Example 2: Creating default notification preferences for a new user
/*
INSERT INTO notification_preferences (user_id, channel, event_type, enabled)
VALUES
  -- High-priority events: EMAIL + IN_APP
  ('...', 'EMAIL', 'campaign.published', TRUE),
  ('...', 'IN_APP', 'campaign.published', TRUE),
  ('...', 'EMAIL', 'photo.rejected', TRUE),
  ('...', 'IN_APP', 'photo.rejected', TRUE),
  ('...', 'EMAIL', 'issue.submitted', TRUE),
  ('...', 'IN_APP', 'issue.submitted', TRUE),

  -- Medium-priority events: IN_APP only by default
  ('...', 'EMAIL', 'assignment.complete', FALSE),
  ('...', 'IN_APP', 'assignment.complete', TRUE),
  ('...', 'EMAIL', 'photo.approved', FALSE),
  ('...', 'IN_APP', 'photo.approved', TRUE),

  -- Low-priority events: IN_APP only
  ('...', 'EMAIL', 'order.acknowledged', FALSE),
  ('...', 'IN_APP', 'order.acknowledged', TRUE)
ON CONFLICT (user_id, channel, event_type) DO NOTHING;
*/

-- Example 3: Checking user preferences before sending notification
/*
SELECT
  np.enabled,
  np.channel
FROM notification_preferences np
WHERE np.user_id = '...'
  AND np.event_type = 'photo.rejected'
  AND np.enabled = TRUE;
*/

-- If no preferences found, use system defaults (documented above)

-- ==============================================================================
-- DEFAULT PREFERENCE INITIALIZATION FUNCTION
-- ==============================================================================

-- Function to initialize default notification preferences for a new user
-- This should be called by application code when a user is created

/*
CREATE OR REPLACE FUNCTION initialize_default_notification_preferences(
  p_user_id UUID
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO notification_preferences (user_id, channel, event_type, enabled)
  VALUES
    -- Campaign events
    (p_user_id, 'EMAIL', 'campaign.published', TRUE),
    (p_user_id, 'IN_APP', 'campaign.published', TRUE),
    (p_user_id, 'IN_APP', 'campaign.scheduled', TRUE),
    (p_user_id, 'EMAIL', 'campaign.cancelled', TRUE),
    (p_user_id, 'IN_APP', 'campaign.cancelled', TRUE),

    -- Assignment events
    (p_user_id, 'EMAIL', 'assignment.created', TRUE),
    (p_user_id, 'IN_APP', 'assignment.created', TRUE),
    (p_user_id, 'IN_APP', 'assignment.ready', TRUE),
    (p_user_id, 'IN_APP', 'assignment.submitted', TRUE),
    (p_user_id, 'EMAIL', 'assignment.rework_required', TRUE),
    (p_user_id, 'IN_APP', 'assignment.rework_required', TRUE),

    -- Order events
    (p_user_id, 'EMAIL', 'order.shipped', TRUE),
    (p_user_id, 'IN_APP', 'order.shipped', TRUE),
    (p_user_id, 'EMAIL', 'order.delivered', TRUE),
    (p_user_id, 'IN_APP', 'order.delivered', TRUE),

    -- Shipment events
    (p_user_id, 'EMAIL', 'shipment.delivered', TRUE),
    (p_user_id, 'IN_APP', 'shipment.delivered', TRUE),
    (p_user_id, 'EMAIL', 'shipment.exception', TRUE),
    (p_user_id, 'IN_APP', 'shipment.exception', TRUE),

    -- Photo events
    (p_user_id, 'EMAIL', 'photo.rejected', TRUE),
    (p_user_id, 'IN_APP', 'photo.rejected', TRUE),
    (p_user_id, 'IN_APP', 'photo.approved', TRUE),

    -- Issue events
    (p_user_id, 'EMAIL', 'issue.submitted', TRUE),
    (p_user_id, 'IN_APP', 'issue.submitted', TRUE),
    (p_user_id, 'EMAIL', 'issue.approved', TRUE),
    (p_user_id, 'IN_APP', 'issue.approved', TRUE),
    (p_user_id, 'EMAIL', 'issue.denied', TRUE),
    (p_user_id, 'IN_APP', 'issue.denied', TRUE),

    -- Export events
    (p_user_id, 'EMAIL', 'export.completed', TRUE),
    (p_user_id, 'IN_APP', 'export.completed', TRUE)
  ON CONFLICT (user_id, channel, event_type) DO NOTHING;
END;
$$ LANGUAGE plpgsql;
*/

-- Usage:
-- SELECT initialize_default_notification_preferences('...');

-- ==============================================================================
-- END OF NOTIFICATION EVENT TYPES
-- ==============================================================================
