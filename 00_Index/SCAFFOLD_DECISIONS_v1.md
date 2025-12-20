# PopSystem v1 Scaffold Decisions

**Decision Date:** 2025-12-20
**Decided By:** Christian De Ramos
**Status:** LOCKED FOR v1

---

## Summary

These decisions resolve all open scaffold questions identified during the Production Readiness Review. All decisions are binding for v1 development.

---

## D1: Batch Management Scope

**Decision:** OUT OF SCOPE FOR v1

**Rationale:** Simplify PSP Operations Module for initial release. Batch management adds complexity without core value proposition impact.

**Impact:**
- Remove batch assignment from Production Operator workflow (SUPP-001)
- Remove batch-related permissions from RBAC (SUPP-003)
- Retain `batch_label` field in schema as optional free-text tag (no UI, API-only)
- Batch management becomes v2 candidate feature

**Documents to Update:** SUPP-001, SUPP-003, SUPP-016

---

## D2: Campaign Manager Role Implementation

**Decision:** SUBSET OF BRAND_ADMIN (assignment-scoped)

**Rationale:** Avoid schema changes. Campaign Manager is a Brand Admin with restricted scope defined by campaign assignment records, not a distinct role enum.

**Implementation:**
- Role enum remains: `PSP_ADMIN`, `PSP_OPS`, `BRAND_ADMIN`, `REGIONAL_ADMIN`, `STORE_USER`
- Campaign Manager = `BRAND_ADMIN` + `CampaignAssignment` record linking user to specific campaigns
- Permission checks: `if (user.role === 'BRAND_ADMIN' && hasCampaignAssignment(user, campaign))`
- UI label shows "Campaign Manager" based on assignment state, not role

**Documents to Update:** SUPP-001, SUPP-003, SUPP-035 (add CampaignAssignment table)

---

## D3: Photo Validation Rules (v1)

**Decision:** BASIC QUALITY WARNINGS (non-ML algorithms)

**Rationale:** Provide user guidance without ML infrastructure. Use proven computer vision algorithms.

**Implementation:**
- **Blur Detection:** Laplacian variance algorithm (edge detection)
  - Threshold: variance < 100 = "Image appears blurry"
  - Client-side JavaScript using canvas API
- **Darkness Detection:** Average luminance calculation
  - Threshold: luminance < 50 = "Image appears too dark"
  - RGB to luminance: `0.299*R + 0.587*G + 0.114*B`
- **Behavior:** Non-blocking warnings. User can proceed after acknowledgment.
- **Resolution Check:** Minimum 800x600 pixels (blocking)
- **Format Check:** JPEG/PNG only (blocking)

**Documents to Update:** SUPP-017, SUPP-014

---

## D4: Large Kit UX Strategy (61+ items)

**Decision:** MULTIPLE VIEW OPTIONS (platform-adaptive)

**Desktop (Brand Admin Portal):**
- Default: Grouped by Location Slot (collapsible sections)
- Optional: Flat List with search/filter
- Optional: Grid View (thumbnail-focused)
- User preference persisted

**Mobile (Store PWA):**
- Default: Grouped by Location Slot (progressive disclosure)
- Limited due to screen constraints
- Search/filter always available
- No grid view on mobile

**Implementation:**
- Add `viewPreference` field to user preferences
- Component supports `view` prop: `'grouped' | 'list' | 'grid'`
- Mobile forces `'grouped'` when screen width < 768px

**Documents to Update:** SUPP-001, SUPP-017, SUPP-036

---

## D5: Issue Approval Thresholds

**Decision:** ALL MANUAL REVIEW IN v1

**Rationale:** Establish baseline for fraud detection before enabling auto-approval. Collect data on issue patterns first.

**Implementation:**
- All `IssueRequest` submissions go to `AWAITING_APPROVAL` status
- PSP Operator or PSP Admin must approve/deny
- No dollar-value thresholds in v1
- Auto-approval becomes v2 feature with threshold configuration

**v2 Consideration:** Implement configurable thresholds per brand:
- First occurrence under $X: auto-approve
- Repeat issues: always manual
- High-value items: always manual

**Documents to Update:** SUPP-019, SUPP-003

---

## D6: PSP MIS Integration Documentation

**Decision:** GENERIC API ONLY

**Rationale:** Avoid PSP-specific coupling. Build flexible integration layer.

**Implementation:**
- Document webhook contracts (SUPP-006)
- Document REST API endpoints (SUPP-020)
- No PSP-specific adapters in v1
- PSP implements their side of integration
- Provide Postman collection and OpenAPI spec

**Integration Points:**
- Webhook: `order.created`, `shipment.status_changed`, `issue.created`
- API: Order acknowledgment, shipment creation, tracking updates

**Documents to Update:** SUPP-006, SUPP-016

---

## D7: Critical Store Fields (Change Verification)

**Decision:** BRAND CONFIGURABLE with sensible defaults

**Default Critical Fields (trigger verification on change during active campaign):**
- `address_line1`, `address_line2`
- `city`, `state`, `postal_code`
- `status` (ACTIVE ↔ INACTIVE)

**Optional Critical Fields (Brand can enable):**
- `region_id` (geographic reassignment)
- `external_store_guid` (external ID mismatch)
- `primary_contact_*` fields
- Custom fields via brand configuration

**Implementation:**
- Add `critical_field_config` JSONB to Brand settings
- Default config applied if not overridden
- Change detection compares current vs new values
- Verification task created for critical changes
- Non-critical changes apply immediately with audit log

**Documents to Update:** SUPP-013, Campaign configuration schema

---

## D8: Pre-Install Checklist Items

**Decision:** BRAND CONFIGURABLE (no system defaults)

**Rationale:** Checklist requirements vary significantly by brand, industry, and campaign type. One-size-fits-all defaults create friction.

**Implementation:**
- Brand Admin configures checklist items per campaign
- Minimum 0 items (can skip checklist entirely)
- Maximum 10 items (UX constraint)
- Each item: `{ label: string, required: boolean, helpText?: string }`
- Store must acknowledge all required items before proceeding to install

**Suggested Templates (documentation only, not enforced):**
- **Retail:** Old materials removed, Surface clean, Tools ready
- **Restaurant:** Health/safety check, Manager approval, Area cleared
- **Gas Station:** Pump area clear, Safety equipment available

**Documents to Update:** SUPP-015, SUPP-017, SUPP-014

---

## D9: Offline Sync Conflict Resolution

**Decision:** SERVER-AS-TRUTH + CONFLICT QUEUE

**Rationale:** Preserve data integrity while providing visibility into conflicts.

**Implementation:**
- Server version always wins on sync
- Conflicts detected when local timestamp < server timestamp for same record
- Conflicts queued for Store Manager review
- Conflict record includes: local value, server value, timestamps, user IDs
- Store Manager can acknowledge or escalate
- 30-day retention for conflict records

**Documents to Update:** SUPP-011, SUPP-017

---

## D10: Maximum Offline Duration

**Decision:** 24 HOURS

**Rationale:** Balances flexibility with data freshness. Matches typical daily store operation cycle.

**Implementation:**
- App checks `lastSyncTimestamp` on every launch
- If `now - lastSyncTimestamp > 24h`, force sync attempt
- If sync fails (no connectivity), show warning banner but allow continued offline use
- After 72h offline, show blocking modal requiring sync before new submissions
- Background sync attempts every 4 hours when app is open

**Documents to Update:** SUPP-011

---

## D11: Campaign Manager Draft Deletion

**Decision:** YES - WITH APPROVAL

**Rationale:** Empower Campaign Managers while maintaining Brand Admin oversight.

**Implementation:**
- Campaign Manager can request deletion of DRAFT campaigns they're assigned to
- Request creates `DeletionRequest` record with reason
- Brand Admin notified via email + in-app notification
- Brand Admin approves/denies within 48 hours
- If no response in 48h, auto-deny with "timeout" reason
- Approved deletions are soft-delete with 30-day recovery window

**Documents to Update:** SUPP-003, SUPP-015

---

## D12: Retake Queue Prioritization

**Decision:** CAMPAIGN DEADLINE + STORE GROUPING + FIFO FALLBACK

**Rationale:** Optimize for business impact while maintaining usable UX.

**Implementation:**
- Primary sort: Campaign end date (ascending) - expiring campaigns first
- Secondary sort: Store ID (grouped) - complete one store at a time
- Tertiary sort: Rejection timestamp (FIFO) - oldest first within store
- Store user sees their retakes grouped by store, within deadline priority
- PSP reviewer sees all retakes sorted by deadline, grouped by store

**Documents to Update:** SUPP-017, SUPP-018

---

## D13: Retake Deadline Expiration

**Decision:** AUTO-ESCALATE → FLAG + CONTINUE

**Rationale:** Don't block campaign completion, but ensure visibility.

**Implementation:**
1. When retake deadline passes:
   - If Regional Manager assigned: Escalate notification
   - Regional Manager has 24h to waive or extend
2. If no Regional Manager OR no response in 24h:
   - Auto-flag item as `NON_COMPLIANT`
   - Item status = `RETAKE_EXPIRED`
   - Store can complete campaign (not blocking)
3. Non-compliant items:
   - Visible in campaign dashboard with warning badge
   - Included in compliance reports
   - Cannot be retroactively approved (audit trail locked)

**Documents to Update:** SUPP-018, SUPP-019

---

## D14: Regional Manager Override Authority

**Decision:** NO - BRAND ADMIN AUTHORITY IS HIGHER

**Rationale:** Clear hierarchy prevents confusion. Regional Manager is operational, not administrative.

**Implementation:**
- Regional Manager CANNOT:
  - Reopen completed campaigns
  - Override Brand Admin photo rule rejections
  - Delete campaigns
  - Modify campaign configuration
- Regional Manager CAN:
  - Waive individual photo requirements (within region)
  - Extend retake deadlines (within region)
  - Reopen individual store assignments (within region)
  - Override store-level decisions

**Documents to Update:** SUPP-003

---

## D15: Bulk Operations Permissions

**Decision:** BRAND ADMIN + REGIONAL MANAGER (scoped)

**Rationale:** Enable efficiency while respecting role boundaries.

**Implementation:**
- **Brand Admin:** All bulk operations, no scope limits
- **Regional Manager:** Bulk operations within their region only

**Bulk Operations Supported:**
| Operation | Brand Admin | Regional Manager |
|-----------|-------------|------------------|
| Bulk approve photos | Yes (all) | Yes (region) |
| Bulk reject photos | Yes (all) | Yes (region) |
| Bulk close issues | Yes (all) | Yes (region) |
| Bulk waive items | Yes (all) | Yes (region) |
| Bulk assign stores | Yes (all) | No |
| Bulk export | Yes (all) | Yes (region) |

**Batch Size Limit:** 100 items per operation (configurable)

**Documents to Update:** SUPP-003, API endpoints

---

## D16: IssueRequest State Machine (Canonical)

**Decision:** SUPP-035 STYLE

**Rationale:** More granular states provide better visibility into issue lifecycle.

**Canonical States:**
```
OPEN → TRIAGED → AWAITING_APPROVAL → APPROVED → IN_FULFILLMENT → RESOLVED
                                   ↘ DENIED → CLOSED
```

**State Definitions:**
| State | Description | Next States |
|-------|-------------|-------------|
| OPEN | Issue just reported by store | TRIAGED |
| TRIAGED | PSP reviewed, categorized, assigned | AWAITING_APPROVAL |
| AWAITING_APPROVAL | Pending approval decision | APPROVED, DENIED |
| APPROVED | Approved, reorder will be created | IN_FULFILLMENT |
| DENIED | Rejected with reason | CLOSED |
| IN_FULFILLMENT | Reorder created and being fulfilled | RESOLVED |
| RESOLVED | Replacement delivered, issue closed | (terminal) |
| CLOSED | Denied issue, no action taken | (terminal) |

**Migration:** Update SUPP-002 to align with SUPP-035 naming.

**Documents to Update:** SUPP-002, SUPP-019

---

## D17: Support Agent Role

**Decision:** ADD TO RBAC MATRIX

**Implementation:**
- Role: Uses `PSP_OPS` enum with `support_scope` flag
- Permissions: READ-ONLY across all PSP tenant data
- Capabilities:
  - View all orders, shipments, issues
  - View audit logs
  - Replay failed webhooks (read + retry, not modify)
  - Access audit explorer
  - Cannot modify any data
  - Cannot approve/deny anything
- Impersonation: Can impersonate Store Users for debugging (read-only session)

**Documents to Update:** SUPP-003, SUPP-031

---

## D18: Quantity Tracking Fields

**Decision:** ADD TO ASSIGNMENT_ITEMS TABLE

**Rationale:** Enable rollup algorithm and fulfillment visibility.

**Schema Addition:**
```sql
ALTER TABLE assignment_items ADD COLUMN shipped_qty INT DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN delivered_qty INT DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN received_good_qty INT DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN received_damaged_qty INT DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN installed_qty INT DEFAULT 0;
ALTER TABLE assignment_items ADD COLUMN verified_qty INT DEFAULT 0;
```

**Derivation Rules:**
- `shipped_qty`: Sum of shipment_items.quantity where shipment.status != CANCELLED
- `delivered_qty`: Sum where shipment.status = DELIVERED
- `received_good_qty`: From receipt survey (store-reported)
- `received_damaged_qty`: From receipt survey (store-reported)
- `installed_qty`: From install survey completion
- `verified_qty`: From photo approval count

**Documents to Update:** SUPP-035, Rollup Algorithm reference

---

## D19: MediaAsset Table

**Decision:** IMPLEMENT FOR RETENTION POLICY

**Rationale:** Enable data retention lifecycle management per SUPP-020.

**Schema:**
```sql
CREATE TABLE media_assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES psp_tenants(id),
  asset_type TEXT NOT NULL, -- 'PROOF_PHOTO', 'ISSUE_PHOTO', 'REFERENCE_IMAGE'
  s3_key TEXT NOT NULL,
  s3_bucket TEXT NOT NULL,
  file_size_bytes BIGINT,
  mime_type TEXT,
  retention_class TEXT NOT NULL, -- 'OPERATIONAL', 'COMPLIANCE', 'ARCHIVE'
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  deleted_at TIMESTAMPTZ,

  -- Linkage (polymorphic)
  linked_entity_type TEXT, -- 'proof_submission', 'issue_request', 'photo_rule'
  linked_entity_id UUID
);

CREATE INDEX idx_media_assets_expiry ON media_assets(expires_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_media_assets_retention ON media_assets(retention_class, expires_at);
```

**Retention Classes:**
| Class | Duration | Auto-Delete |
|-------|----------|-------------|
| OPERATIONAL | 90 days after campaign end | Yes |
| COMPLIANCE | 1 year after campaign end | No (manual) |
| ARCHIVE | 7 years | No (export first) |

**Documents to Update:** SUPP-020, SUPP-035

---

## Implementation Checklist

| Decision | Documents Updated | Schema Changes | Priority |
|----------|------------------|----------------|----------|
| D1: Batch Out of Scope | SUPP-001, 003, 016 | Remove batch_membership | HIGH |
| D2: Campaign Manager | SUPP-001, 003, 035 | Add CampaignAssignment | HIGH |
| D3: Photo Validation | SUPP-014, 017 | None | MEDIUM |
| D4: Large Kit Views | SUPP-001, 017, 036 | Add viewPreference | MEDIUM |
| D5: Manual Approval | SUPP-003, 019 | None | LOW |
| D6: Generic API | SUPP-006, 016 | None | LOW |
| D7: Critical Fields | SUPP-013, Campaign | Add critical_field_config | MEDIUM |
| D8: Configurable Checklist | SUPP-014, 015, 017 | Add checklist_config | MEDIUM |
| D9: Offline Sync | SUPP-011, 017 | Add conflict_queue table | HIGH |
| D10: Offline Duration | SUPP-011 | None | LOW |
| D11: CM Draft Deletion | SUPP-003, 015 | Add deletion_requests | MEDIUM |
| D12: Retake Priority | SUPP-017, 018 | None (query logic) | MEDIUM |
| D13: Retake Expiration | SUPP-018, 019 | Add RETAKE_EXPIRED status | HIGH |
| D14: RM Override | SUPP-003 | None | LOW |
| D15: Bulk Operations | SUPP-003, API | None | MEDIUM |
| D16: Issue States | SUPP-002, 019 | Align enum | HIGH |
| D17: Support Agent | SUPP-003, 031 | Add support_scope flag | MEDIUM |
| D18: Quantity Fields | SUPP-035 | Add 6 qty columns | HIGH |
| D19: MediaAsset | SUPP-020, 035 | Add media_assets table | HIGH |

---

## Sign-Off

| Role | Name | Date |
|------|------|------|
| Product Owner | Christian De Ramos | 2025-12-20 |
| Technical Lead | AutoCoder by ServFlow | 2025-12-20 |

---

*Document generated by AutoCoder by ServFlow*
