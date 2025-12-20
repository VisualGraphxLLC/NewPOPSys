**NewPOPSys -- Platform Direction & Execution Guide (v1 PSP-Led)**

Canonical direction for partners, product, and development

# 1. Purpose

NewPOPSys is the initial release (v1) of a PSP-led campaign orchestration platform. In v1, the Print Service Provider (PSP) is the direct customer, the system owner, and the operational facilitator. Brands participate as invited program owners, with Regional Managers and Stores participating as execution and oversight users.

The platform modernizes the legacy PrecisionPOP system with a mobile-first user experience, cleaner workflows, and a scalable foundation. The intent is to help PSPs win, service, and retain brand clients by reducing friction across campaign creation, fulfillment, and store execution.

# 2. Customer and User Model (No Ambiguity)

## 2.1 Who pays / who owns / who uses

- PSP (Customer + Owner + Facilitator): purchases/operates NewPOPSys, configures programs, fulfills campaigns, supports users.

- Brand (Invited Program Owner): creates campaigns, selects stores, monitors progress, consumes reporting within a PSP-managed environment.

- Regional Manager (Oversight User): monitors execution, intervenes by exception, escalates issues.

- Store Manager (Execution User): receives kits/tasks, executes installs, confirms completion, submits issues/photos.

Rule of thumb for v1 prioritization: if a decision improves PSP adoption, fulfillment efficiency, and brand retention without harming store execution, it wins. Brand usability matters because it helps the PSP sell and retain the brand.

# 3. Core Platform Loop

Everything in NewPOPSys should reinforce the campaign lifecycle:

- Brand defines campaign (within PSP tenant)

- Store assignment (by brand rules and PSP configuration)

- PSP fulfillment (orders, kitting, production, shipping)

- Store execution (receive → install → confirm)

- Verification (photos, exceptions, confirmations)

- Visibility (brand + regional reporting; PSP operational views)

Surveys, kits, photos, reorders, and reporting are supporting mechanics that exist to close this loop cleanly.

# 4. v1 Scope -- Modernized PrecisionPOP (Feature Matched)

v1 is a feature-matched modernization of the legacy PrecisionPOP system. The goal is continuity of capability with major improvements in usability and operability.

## 4.1 Included in v1

- Campaign management fundamentals (campaigns, store assignment, timelines, instructions)

- Store profiles and attributes (as required by current workflows)

- Surveys (modernized UX; progressive disclosure)

- Kits and kit contents (including large kits)

- Order/fulfillment intake for PSP operations

- Execution status tracking (item and kit level)

- Issue reporting (missing/damaged) and reorder signaling

- Photo upload / verification artifacts

- Activity logging / audit history

- Role-based access (PSP admin, brand, regional, store)

- Baseline reporting for brand/regional + PSP operational views

## 4.2 Not in v1 (Protected Not-Now List)

- Installer marketplace / bidding system

- Full PSP MIS (costing, accounting, scheduling)

- Advanced analytics/benchmarking beyond baseline visibility

- Long-term object storage and archival beyond initial retention policy

- AI automation features beyond data readiness and scaffolding

# 5. UX Principles (Non-Negotiable)

- Mobile-first for stores; desktop supports admin/reporting

- Progressive disclosure for long surveys and large kits

- Fast paths for common store actions (receive, install, issue, photo, confirm)

- Kit-level clarity at a glance (progress, missing, blocked, done)

- Exception-first views for regional oversight

- Minimize manual interpretation for PSP fulfillment (clean orders, clear specs)

# 6. Technical Direction (Plain Language + Dev Starting Point)

## 6.1 Plain language

NewPOPSys is built so multiple brands and store networks can operate within a PSP-managed environment. The system records what was ordered, what was shipped, what was installed, and what proof exists---without spreadsheets or email chains.

## 6.2 Developer starting point

- Campaign-centric domain model (campaign → assignments → kits/orders → execution states → verification artifacts)

- Tenant awareness: PSP-managed environment with clear separation of brand/store data inside the PSP context

- API-first services for future integrations and internal modularity

- Event hooks/webhooks readiness for downstream systems (DAM, prepress, W2P, AI)

- Cloud-ready deployment with CI/CD, logging, and role-aware auditing

# 7. Integration Scaffolding (Build Later, Don't Block Now)

v1 must not block future connections to:

- Digital Asset Management (DAM)

- Prepress automation

- Shipping/fulfillment systems

- Web2Print + online designer tools

- AI services (verification, insights, automation)

v1 requirement: keep data models and APIs clean enough that these integrations can be added without rewrites.

# 8. Data Retention Policy (v1 Decision)

To control early cost and complexity, operational project data is retained for 90 days after a project is marked complete. After 90 days, the brand is offered an export option; otherwise data is deleted. Long-term object storage and archival are planned for a later phase.

# 9. Timeline, Budget, and Delivery Targets

- SOW finalized by end of year (Christmas preferred)

- Beta v1 delivered by end of Q1

- Target budget: \$150,000

Delivery will be managed via milestone tracking and scope control. If a feature threatens timeline or budget, it moves to the Not-Now list.

# 10. Partner Reporting and Escalation

## 10.1 Bi-weekly update cadence

Partners receive bi-weekly written updates with: summary, progress, risks/blockers, decisions needed (if any), and next two-week plan.

## 10.2 Escalation rule

Escalation outside the bi-weekly cadence occurs only for material budget impact, major architectural pivot, or a directional change request.

# 11. Future SaaS Evolution (Reference Only)

v1 is PSP-led by design. The platform is being architected to preserve future optionality for a neutral, brand-scalable SaaS network. That evolution is intentionally deferred and documented separately in: "NewPOPSys -- SaaS Evolution & Market Expansion Strategy."

# Appendix: v1 PSP-Led Campaign Orchestration Flow

![](media/image1.png){width="6.225196850393701in" height="6.287353455818023in"}
