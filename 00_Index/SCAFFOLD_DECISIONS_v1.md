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

---

## Sign-Off

| Role | Name | Date |
|------|------|------|
| Product Owner | Christian De Ramos | 2025-12-20 |
| Technical Lead | AutoCoder by ServFlow | 2025-12-20 |

---

*Document generated by AutoCoder by ServFlow*
