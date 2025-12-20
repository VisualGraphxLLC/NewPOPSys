# SOW Q&A Session Log

> Captured answers to update SOW and move to dev-ready

---

## Session 1: Pilot Context & Scale ✅

### Pilot PSPs
- **Visual Graphx** - Confirmed
- **Speedy CPS / Alpha Graphics** - Confirmed
- No additional PSPs joining pilot

### Pilot Brands
- 2-3 brands target
- **Good2Go** - Confirmed (Speedy/AG pilot)
- No other confirmed brands yet

### Store Counts
| Brand | Stores | Notes |
|-------|--------|-------|
| Good2Go | 500 | Active pilot |
| Potential Client | 400 now, 1000+ planned | Future scale target |

- Geographic spread: **Across US with many sub-structures**
- Implies need for robust Region/District/Territory hierarchy

### Campaign Volume
- **1-2 campaigns per brand per month**
- **30-60 day rollout duration**
- No peak season mentioned yet

### Implications for SOW
1. Scale pilot for 500-1500 stores per brand
2. Multi-level geographic hierarchy required (Region → District → Territory)
3. Campaign lifecycle: design for 30-60 day active periods
4. Low campaign concurrency per brand (1-2 active at a time)

---

## Session 2: Store Execution Workflow ✅

### Photo/Media Volume
- **Dynamic per campaign**: Min 1 photo per promotional item
- Multiple photos possible for location slots in store
- **10MP resolution** (~3-5MB per photo)
- For 500 stores × 10 items × 2 photos avg = ~10,000 photos/campaign

### Current Store Workflow
1. Admin receives **email notification** of pending campaign
2. Logs in to view campaign (status: pending until PSP fulfills)
3. **Kit shipped to location** by PSP
4. Opens app → **checklist to confirm receipt + condition**
5. Installs or **hires installers** to facilitate rollout
6. **NEW**: Completion survey with image capture (not in current system)

### Verification Today
- Currently **ad-hoc and often skipped**
- Clients asking for **compliance checkpoint** = completion survey + brand acceptance
- **Reject/retake is NEW functionality** (doesn't exist today)

### Problem Scenarios
- **#1 Problem**: Missing/damaged items
- **Reorders are manual** → want to automate
- Wrong items shipped (less common but happens)

### Implications for SOW
1. **Completion survey + photo capture** is key new feature
2. **Reject/retake workflow** is new—design carefully
3. **Issue reporting** (missing/damaged) with **automated reorder** flow
4. Support for **third-party installers** (not just store staff)
5. Photo storage: ~50GB per campaign (10K photos × 5MB)

---

## Session 3: PSP Fulfillment ✅

### Order Generation
- **Auto-generate**: Campaign order + store sub-orders (for kitting)
- PSPs build orders in their **MIS or push via API/webhook**
- PSPs assign **internal order ID** to campaign orders

### Shipment Process
- **Split shipments** supported
- **Split quantities per line item** supported
- Multiple tracking numbers implied

### Batching
- **OUT OF SCOPE for v1**
- PSPs do batch in practice, but system won't manage it

### PSP Visibility Needs (ALL)
- Order totals per campaign ✓
- Store-level order details ✓
- Shipment tracking status ✓
- Issue/reorder queues ✓

### Reorder Handling
- **Reorders = separate orders** (not amendments)
- Visible separately at PSP and Store levels
- Monitored separately on brand side
- **Rolled up for reporting**

### Implications for SOW
1. **Campaign → Store Orders** hierarchy with PSP internal ID mapping
2. **API/webhook inbound** for PSP order data push
3. **Partial shipments** + line-item splits = complex state machine
4. **Reorder as new order entity** linked to original
5. Reporting: aggregate reorders but track separately

---

## Session 4: Integrations ✅

### Outbound Webhooks (ALL events)
- Campaign published
- Order generated
- Shipment status changes
- Store completion submitted
- Photo approved/rejected

### Inbound API/Events (ALL)
- Order acknowledgment
- Shipment created + tracking
- Delivery confirmation
- **MIS order ID + status mapping** (key requirement)

### Downstream Systems (v1)
- **Email** only for v1
- No carrier APIs, ERP, or BI required at pilot

### Authentication
- **API Keys** for v1
- OAuth after v1

### Implications for SOW
1. **Full webhook coverage** for all major state changes
2. **Inbound API** for PSP order/shipment data with MIS ID mapping
3. **Email integration** required for notifications
4. **API key auth** sufficient for pilot

---

## Q&A Complete! Summary

### v1 Scope Confirmed
| Area | Scope |
|------|-------|
| PSPs | 2 (VG, Speedy/AG) |
| Brands | 2-3 (Good2Go confirmed) |
| Stores | 500-1500 per brand |
| Campaigns | 1-2/month, 30-60 day rollouts |
| Photos | ~10K per campaign, 10MP |

### NEW Features (not in current system)
1. Completion survey with photo capture
2. Reject/retake workflow
3. Automated reorder flow
4. Split shipments + line quantities
5. Full webhook coverage

### OUT OF SCOPE v1
- Batching management
- OAuth
- Carrier APIs
- BI/Analytics integrations

---

## Layer 1: Domain Model Clarifications

### Order Structure
- **Campaign → StoreOrder** (2 levels)
- Stores roll up to campaign for reporting
- No intermediate "CampaignOrder" entity needed

### MIS Order ID Mapping
- MIS ID can attach at **both** campaign and store order levels
- Depends on PSP preference
- Fields: `pspCampaignRef` and `pspOrderRef`

### Installer Tracking
- **OUT OF SCOPE v1** — future module
- v1 tracks completion + attestation only
- No need to track installer identity

### Completion Survey
- Same structure as store survey (SUPP-014)
- Tied to **campaign values** (items in kit)
- Purpose: confirm all items facilitated + in correct locations
- Uses photo capture for location slot verification

### Two-Stage Survey Requirement (New)
1.  **Receipt Survey**: Checklist of items + exception/reorder reporting (on arrival)
2.  **Install Survey**: Photos of each item/location + verification checklist (on completion)
- Both are **dynamic** based on campaign kit selections

---

## Session 5: SOW Completion & Multi-Agent Harness (2025-12-18/19)

### SOW Document Status: ALL LOCKED

| SUPP | Version | Status | Key Updates |
|------|---------|--------|-------------|
| SUPP-035 | v1.0 | Locked | Complete field-level data model - 15+ enums, all tables defined |
| SUPP-036 | v0.6 | Locked | Full screen specs for onboarding, store import, conflict resolution UX |
| SUPP-037 | v1.0 | Locked | Complete survey builder + mobile store survey screens |
| All Others | Various | Locked | See [00_DOC_INDEX.md](./00_DOC_INDEX.md) |

### File Organization Completed

**Active SOW Files**: All 34 SUPPs now in `02_SUPPs/` (Markdown)

**Archive Consolidated**: Single `99_Archive/` folder organized by type:
- `DOCX/` - 121 files
- `MD/` - 47 files
- `ZIP/` - 6 cleanup pack archives
- `PNG/` - 3 images
- `Incremental_Versions/` - 2 compressed ZIPs:
  - `SOW_Versions_v1_01-32.zip` (30 incremental SOW versions)
  - `SUPP_Drafts_Archive.zip` (21 SUPP draft versions)

### Multi-Agent Harness Decision

**Recommendation**: AutoCoder Agent SDK (TypeScript)
- See: `AutoCoder_Harness/MULTI_AGENT_ARCHITECTURE_COMPARISON.md`
- See: `AutoCoder_Harness/IMPLEMENTATION_ROADMAP.md`

**Agent Types Planned**:
| Agent | Model | Purpose |
|-------|-------|---------|
| Orchestrator | Sonnet | Task routing, progress tracking |
| Architect | Opus | Design decisions, planning |
| Implementation | Sonnet | Code writing |
| Reviewer | Opus | Code review, quality |
| Tester | Opus | Test generation |
| Documenter | Sonnet | Documentation |

---

## Session 6: OpenAPI Spec Generation (2025-12-19) ✅

### OpenAPI Spec Created

| Artifact | Path | Description |
|----------|------|-------------|
| `openapi.yaml` | `API/openapi.yaml` | Full OpenAPI 3.1 specification |
| `README.md` | `API/README.md` | API documentation guide |

### API Coverage

**Inbound API (PSP → NewPOPSys)**:
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/orders/{id}/acknowledge` | POST | PSP acknowledges order receipt |
| `/orders/{id}/status` | PATCH | Update production status |
| `/orders/{id}/shipments` | POST | Create shipment (split supported) |
| `/shipments/{id}/delivered` | POST | Confirm delivery |
| `/shipments/{id}/status` | PATCH | Update tracking status |

**Outbound Webhooks (NewPOPSys → PSP)**:
| Event | Trigger |
|-------|---------|
| `campaign.published` | Campaign goes live |
| `order.generated` | Order created for store |
| `issue.created` | Store reports problem |
| `issue.approved` | Issue approved/reorder triggered |
| `submission.receipt_verified` | Kit receipt confirmed |
| `submission.install_completed` | Installation completed |
| `photo.rejected` | Photo needs retake |

**Security**:
- API Key auth (`X-API-Key` header)
- HMAC-SHA256 webhook signatures (`X-VG-Signature`)
- Idempotency keys required for mutations
- Rate limiting headers

**Schemas**:
- All enums from SUPP-035 included
- Full request/response schemas
- Webhook event envelope format
- Error response format

---

## NEXT STEPS (Pick up here)

### Immediate (Ready to Execute)

1. ~~**Generate OpenAPI Spec** (from SUPP-006)~~ ✅ DONE
   - Output: `API/openapi.yaml`

2. **Initialize TypeScript Multi-Agent Harness**
   - Follow roadmap in `AutoCoder_Harness/IMPLEMENTATION_ROADMAP.md`
   - Phase 1: Project scaffold, dependencies, base agent class

### Deferred

3. **Build Orchestrator Agent** (Phase 2)
4. **Port Tool Implementations** (Phase 3)
5. **Implement Specialized Agents** (Phase 4)
6. **Integration Testing** (Phase 5)

---

*Last Updated: 2025-12-19*
