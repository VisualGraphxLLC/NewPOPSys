# NewPOPSys v1 — Executive Summary

**Version:** 1.0 | **Date:** December 2025 | **Status:** Ready for Development

---

## What Is NewPOPSys?

NewPOPSys v1 is a **PSP-led campaign orchestration platform** that replaces spreadsheets and email threads with an auditable, deterministic lifecycle:

```
Campaign → Store Assignment → PSP Fulfillment → Store Execution → Verification → Visibility
```

This is a modernized, feature-matched rebuild of the PrecisionPOP operational loop with a mobile-first store experience and automation-ready APIs.

---

## The Problem We Solve

| Current State | NewPOPSys v1 |
|---------------|--------------|
| Ad-hoc campaign setup via spreadsheets | Standardized campaigns, kits, and store assignments |
| Manual order coordination via email | Deterministic order generation with batch tracking |
| Paper checklists and photo emails | Mobile-first execution with guided proof capture |
| Status calls and spreadsheet tracking | Real-time visibility dashboards |
| No audit trail for compliance | Auditable state transitions with version control |

---

## Who Benefits

| Stakeholder | Value Delivered |
|-------------|-----------------|
| **PSP Operations** | Predictable orders, batch management, export integrations |
| **Brand Campaign Admin** | Campaign builder, progress visibility, controlled change management |
| **Regional Manager** | Exception-first workflow, compliance monitoring |
| **Store Manager** | Clear instructions, simple mobile interface, fast completion |

---

## v1 Scope Summary

| Component | Details |
|-----------|---------|
| Web Portals | 5 (PSP Admin, PSP Ops, Brand Admin, Regional, Store) |
| Mobile Experience | PWA with offline-capable drafts |
| User Personas | 8 roles with granular RBAC |
| State Machines | 6 core entity lifecycles |
| API Endpoints | ~80-100 estimated |
| Integrations | Webhooks, photo storage, exports |
| Documentation | 35+ SUPP specifications |

---

## Technology Stack

| Layer | Technology |
|-------|------------|
| Hosting | AWS (RDS, S3, managed services) |
| Database | PostgreSQL with JSONB for flexible schemas |
| Frontend | Next.js (React) with PWA scaffold |
| Backend | Node.js/TypeScript with Fastify |
| Queue | BullMQ on Redis |
| Observability | OpenTelemetry + Sentry |

---

## Budget & Timeline

| Approach | Cost | Timeline | Risk |
|----------|------|----------|------|
| Traditional US Team | $600,000 | 5-6 months | High |
| Traditional Global Team | $400,000 | 6-8 months | Medium-High |
| **AutoCoder + US Review** | **$150,000** | **3-4 months** | **Low** |
| AutoCoder + Global Review | $107,250 | 4-5 months | Low-Medium |

**Recommended:** AutoCoder Harness with US Review at $150,000 budget.

---

## What v1 Will NOT Do

These are protected scope boundaries, not future promises:

- **Not an MIS/ERP** — No job costing, accounting, or financial reporting
- **Not a marketplace** — No installer bidding or vendor marketplaces
- **Not analytics-heavy** — No predictive dashboards or AI insights (data readiness only)
- **Not long-term storage** — 90-day operational retention with export pathways
- **No silent scope expansion** — New scope requires explicit tradeoffs

---

## Pilot Partners

| Role | Organization |
|------|--------------|
| Pilot PSPs | Visual Graphx; Speedy CPS / Alpha Graphics |
| Pilot Brand | Good2Go (Speedy/AG pilot) |

---

## Success Criteria

1. **Campaign Lifecycle**: Campaigns flow from draft → published → executing → completed without manual intervention
2. **Store Execution**: 90%+ of stores complete execution within campaign timeline
3. **PSP Efficiency**: Order generation and fulfillment tracking reduce manual coordination by 80%
4. **Proof Capture**: Mobile-first photo submission with verification workflow operational
5. **Data Discipline**: 90-day retention enforced; exports available for compliance

---

## Next Steps

1. Confirm pilot scale parameters (stores, campaigns, media volume)
2. Complete vertical slice development
3. Pilot deployment with Good2Go stores
4. Iterate based on operational feedback
5. Expand to additional brands and PSPs

---

*This executive summary is derived from the comprehensive SOW documentation. For detailed specifications, see the [Master SOW](../SOW/01_Main_SOW/MASTER_SOW_COMPILED.md) and [SUPP documents](../SOW/02_SUPPs/).*
