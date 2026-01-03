# NewPOPSys v1 — Scope Boundaries

**Version:** 1.0 | **Date:** December 2025

---

## Purpose

This document defines what NewPOPSys v1 **will never be**. These are not "future features" or "nice to haves" — they are **protected scope boundaries** that keep v1 focused on its core mission.

If a feature request falls into the categories below, the answer is **No** unless explicitly traded in through formal scope control with documented tradeoffs.

---

## The Core Mission (v1)

NewPOPSys v1 is a **PSP-led campaign orchestration platform**. It coordinates:

```
Campaign → Store Assignment → PSP Fulfillment → Store Execution → Verification → Visibility
```

**That's it.** Everything outside this loop is out of scope.

---

## What v1 Will Never Be

### 1. Not an MIS/ERP

| Excluded Feature | Why It's Out |
|-----------------|--------------|
| Job costing | PSP has existing MIS for this |
| Accounting integration | Financial systems are separate |
| Production scheduling | Orders are handed off, not scheduled |
| Payroll/HR | Completely unrelated domain |
| Financial reporting | PSP handles their own financials |

**The Boundary:** NewPOPSys generates orders and tracks fulfillment status. What happens inside the PSP's production floor is their business.

---

### 2. Not a Marketplace

| Excluded Feature | Why It's Out |
|-----------------|--------------|
| Installer bidding | Stores execute; they don't bid |
| Vendor marketplace | PSP is the vendor |
| Ratings/reviews | Not a consumer platform |
| Dynamic pricing | Fixed campaign pricing |
| Multi-vendor routing | Single PSP per brand in v1 |

**The Boundary:** The PSP-Brand relationship is established outside the platform. NewPOPSys orchestrates execution, not vendor selection.

---

### 3. Not Analytics-Heavy

| Excluded Feature | Why It's Out |
|-----------------|--------------|
| Predictive dashboards | Operational visibility, not forecasting |
| Benchmarking across brands | Privacy boundaries between tenants |
| AI-powered insights | Data readiness only in v1 |
| Trend analysis | Export data for external analysis |
| Performance scoring | Simple completion metrics only |

**The Boundary:** NewPOPSys provides operational status visibility. Deep analytics happen in external BI tools via exports.

---

### 4. Not Long-Term Storage

| Excluded Feature | Why It's Out |
|-----------------|--------------|
| Archival data warehouse | 90-day operational retention |
| Historical photo storage | Export before deletion |
| Multi-year campaign history | Not an archive system |
| Compliance record keeping | Export packages for compliance |

**The Boundary:** Operational data is retained for 90 days after campaign completion. Users must export what they need to keep. The platform is not a filing cabinet.

---

### 5. Not Endlessly Customizable

| Excluded Feature | Why It's Out |
|-----------------|--------------|
| White-label theming | Standard branding for v1 |
| Custom workflow builders | Defined state machines |
| Plugin architecture | Closed system for v1 |
| Per-store customization | Campaign-level configuration |
| Custom report builders | Predefined export formats |

**The Boundary:** v1 prioritizes operational discipline over flexibility. Customization creates support burden and edge cases.

---

### 6. No Silent Scope Expansion

| Pattern | Response |
|---------|----------|
| "Can we just add..." | Requires scope control review |
| "It would be nice if..." | Document in Post_v1, not v1 |
| "The old system had..." | Modernization, not replication |
| "What if we also..." | Focus on core loop first |
| "Users are asking for..." | Validate against v1 mission |

**The Boundary:** New scope requires explicit tradeoffs. If something goes in, something else comes out or timeline extends. No free additions.

---

## How Scope Requests Are Handled

### Step 1: Is it in the core loop?
```
Campaign → Store Assignment → PSP Fulfillment → Store Execution → Verification → Visibility
```
If no, it's likely out of scope.

### Step 2: Does it hit a protected boundary?
Review the categories above. If it matches, the answer is No.

### Step 3: Formal scope control
If the request might be valid:
1. Document the request with rationale
2. Identify what would be traded (scope, timeline, or budget)
3. Get stakeholder approval
4. Update SOW documentation

---

## What IS In Scope (Reminders)

These are the things v1 DOES do:

| Capability | Status |
|------------|--------|
| Campaign creation with kits and store selection | In Scope |
| Deterministic order generation | In Scope |
| Batch tracking and shipment management | In Scope |
| Mobile-first store execution | In Scope |
| Photo proof capture with verification | In Scope |
| Approve/reject/retake workflow | In Scope |
| Real-time status visibility | In Scope |
| Standard exports (CSV, Excel) | In Scope |
| Webhook notifications | In Scope |
| 90-day retention with export | In Scope |

---

## Post-v1 Parking Lot

Features that might make sense later but are explicitly **not v1**:

| Feature | Potential Phase |
|---------|-----------------|
| Multi-PSP routing | v2/v3 (SaaS evolution) |
| Brand-led configuration | v2 |
| Advanced analytics dashboard | v2 |
| White-label theming | v2 |
| Third-party installer network | v3 |
| AI-powered insights | v3 |

These are documented in the [Post_v1 folder](../SOW/Post_v1/) for future reference.

---

## Why These Boundaries Matter

1. **Focus**: Limited scope enables faster delivery
2. **Quality**: Fewer features means fewer bugs
3. **Adoption**: Simpler system is easier to adopt
4. **Maintainability**: Less code to maintain
5. **Budget**: $150,000 budget requires discipline
6. **Timeline**: 3-4 months requires focus

---

*This document is the authoritative reference for scope decisions. When in doubt, refer here. If something isn't explicitly in scope, assume it's out.*
