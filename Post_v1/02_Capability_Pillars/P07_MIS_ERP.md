# Capability Pillar 7: MIS/ERP Integration & Production Management

**Status:** Strategic Planning Document
**Pillar:** MIS/ERP
**Phase:** v3+ (Post-v1 Long-term)
**Effort:** XL to XXL (36-60+ months full development)
**Last Updated:** December 2025

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State - v1 Scope](#current-state---v1-scope)
3. [Strategic Context](#strategic-context)
4. [Product Strategy Options](#product-strategy-options)
5. [Core MIS Capabilities](#core-mis-capabilities)
6. [Accounting & General Ledger Integration](#accounting--general-ledger-integration)
7. [Competitive Landscape](#competitive-landscape)
8. [Technical Architecture](#technical-architecture)
9. [Phase Roadmap](#phase-roadmap)
10. [FOSS & Licensable Options](#foss--licensable-options)
11. [Effort Estimates & Resource Requirements](#effort-estimates--resource-requirements)
12. [Key Decisions Needed](#key-decisions-needed)
13. [Appendices](#appendices)

---

## Executive Summary

### The Opportunity

MIS/ERP (Management Information System / Enterprise Resource Planning) represents the most complex and potentially transformative capability pillar for PopSystem. Print MIS systems are the operational backbone of PSP businesses, managing everything from quote generation to job costing, production scheduling, inventory, purchasing, and financial reporting.

The PSP software market is mature but fragmented. Dominant players like Tharstern, PrintVis, and EFI Pace serve traditional commercial print. However, **POP and retail execution represent an underserved vertical** with unique requirements:

- Campaign-driven batch production (not one-off jobs)
- Store-level fulfillment tracking integrated with execution
- Kit assembly and multi-item shipments
- Reorder management with store-level issue tracking
- Integration with brand campaigns and verification workflows

**PopSystem v1 explicitly excludes MIS functionality.** PSPs use their existing systems (EFI Pace, PrintVis, Tharstern, or custom solutions). The v1 API provides integration points for order sync and status updates.

### Strategic Question

Should PopSystem evolve into a complete production management platform, or remain a campaign orchestration layer that integrates with existing MIS systems?

This decision fundamentally shapes the product roadmap, go-to-market strategy, development investment, and competitive positioning.

### Three Paths Forward

| Approach | Description | Market Position |
|----------|-------------|-----------------|
| **Integration-Only** | PopSystem remains MIS-agnostic. Deep connectors to major platforms. | Campaign orchestration specialist |
| **Hybrid Module** | Light MIS features for small PSPs. Integrations for enterprises. | Dual-market strategy |
| **Full MIS/ERP** | Complete production management platform purpose-built for POP. | Vertical market consolidation |

**This document explores all three paths** to inform strategic decision-making.

---

## Current State - v1 Scope

### v1 Boundary: MIS is Out of Scope

PopSystem v1 focuses exclusively on **campaign orchestration**, not production management.

**v1 Provides:**
- Campaign definition and store selection
- Order generation with line items
- Order status tracking (GENERATED → ACKNOWLEDGED → IN_PRODUCTION → SHIPPED)
- Shipment tracking and delivery confirmation
- Issue/reorder workflow
- Store execution and verification

**v1 Does NOT Provide:**
- Job costing or estimating
- Production scheduling or capacity planning
- Equipment tracking or job ticketing
- Material procurement or inventory management
- Time tracking or labor costing
- Invoicing or accounts receivable
- Purchase orders or vendor management
- General ledger integration

### v1 Integration Points

PSPs use external MIS systems and sync with PopSystem via API:

```
┌─────────────────────────────────────────────────────────────┐
│                       PSP MIS System                        │
│          (EFI Pace, PrintVis, Tharstern, Custom)            │
│                                                             │
│  • Job costing & estimating                                 │
│  • Production scheduling                                    │
│  • Equipment tracking                                       │
│  • Inventory management                                     │
│  • Purchasing & receiving                                   │
│  • Invoicing & A/R                                          │
│  • Financial reporting                                      │
└─────────────────────────────────────────────────────────────┘
                           ↑ ↓
                    REST API + Webhooks
                           ↑ ↓
┌─────────────────────────────────────────────────────────────┐
│                        PopSystem v1                         │
│                                                             │
│  • Campaign orchestration                                   │
│  • Order generation & tracking                              │
│  • Store fulfillment status                                 │
│  • Issue/reorder workflow                                   │
│  • Verification & proof management                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Key Fields:**
- `StoreOrder.pspOrderRef` - Links to MIS job/order ID
- `StoreOrder.status` - Synced via API (PSP updates via webhook)
- `Shipment.trackingNumber` - Created in MIS, synced to PopSystem

**Current Model Assumptions:**
- PSP has existing MIS infrastructure
- PSP staff enters PopSystem orders into MIS manually OR via API integration
- PopSystem is the source of truth for **campaign/store data**
- MIS is the source of truth for **production/financial data**

This works for v1 because:
1. Target PSPs already have MIS investments
2. Integration scope is manageable (order sync only)
3. v1 focuses on store execution gap, not production management
4. Avoids massive development effort for launch

---

## Strategic Context

### Market Dynamics

**Print MIS Market Overview:**
- Mature market with established vendors
- High switching costs (6-18 months implementation)
- Deep customization required per PSP
- Pricing: $10K-$100K+ per year depending on scale
- Strong vendor lock-in through workflow dependency

**PSP Segments:**

| Segment | MIS Status | PopSystem Opportunity |
|---------|-----------|----------------------|
| **Large PSPs (>$10M revenue)** | Have enterprise MIS (EFI Pace, PrintVis, Tharstern). Heavy integration, customization. | Integration-only. PopSystem as campaign layer. |
| **Mid-size PSPs ($2M-$10M)** | Mixed. Some have MIS, some use patchwork (QuickBooks + Excel + FileMaker). | Hybrid opportunity. Light MIS module OR integration. |
| **Small PSPs (<$2M revenue)** | Minimal MIS. QuickBooks for accounting. Manual job tracking. Excel-based estimating. | Standalone MIS module opportunity. Complete solution. |
| **Start-ups / New PSPs** | Greenfield. Looking for all-in-one platform. | Full MIS/ERP greenfield opportunity. |

**Vertical Specialization:**

Traditional print MIS systems are generalists (commercial, packaging, wide-format, labels). **POP/retail execution is underserved.**

POP-specific requirements:
- Campaign-based production (not individual job orders)
- Kit assembly and multi-SKU shipments
- Store-level addressing and tracking
- Integration with proof-of-execution workflows
- Seasonal volume spikes (holiday campaigns)
- Brand-driven workflows (not customer-agnostic)

**No existing MIS is purpose-built for POP campaign fulfillment at scale.**

### Competitive Gaps

**What competitors don't do well for POP:**

| Competitor | Strengths | POP Gaps |
|------------|-----------|----------|
| **EFI Pace** | Comprehensive ERP. Strong financials. Multi-plant. | Complex, expensive. Not campaign-aware. No store-level tracking. |
| **PrintVis** | Deep Dynamics 365 integration. Manufacturing focus. | Requires Microsoft ERP. Steep learning curve. Not POP-native. |
| **Tharstern** | Modern cloud MIS. Good UX. Strong estimating. | Generalist. No campaign orchestration. Manual store management. |
| **ShopVOX** | Affordable. Small shop focus. | Limited scalability. Weak multi-location. No execution tracking. |
| **Cyrious** | Mature platform. Strong workflow. | Legacy UI. Not store-execution aware. |

**None integrate campaign orchestration + fulfillment + store execution + verification in a single platform.**

This is PopSystem's differentiation opportunity.

### Build vs. Buy vs. Partner

Three strategic approaches to MIS/ERP:

**Option 1: Build from Scratch**
- Pros: Complete control. POP-optimized. Differentiated IP.
- Cons: Massive effort (5+ years). Accounting complexity. Compete with mature vendors.

**Option 2: Acquire/License Existing MIS**
- Pros: Faster time to market. Proven accounting. Existing customer base.
- Cons: Integration complexity. Legacy code. Cultural fit. High acquisition cost.

**Option 3: FOSS Adaptation (Odoo, ERPNext)**
- Pros: Proven frameworks. Active communities. Lower licensing cost.
- Cons: Customization required. Support dependencies. Feature gaps.

**Option 4: Deep Integrations Only (v1 Approach)**
- Pros: No MIS development. PSPs use existing tools. Focused scope.
- Cons: Limited differentiation. Integration burden on each PSP. No small PSP solution.

---

## Product Strategy Options

### Option A: Standalone Product ("PopMIS")

**Concept:** Offer a separate MIS/ERP product specifically for POP-focused PSPs.

**Target Market:**
- Small to mid-size PSPs without existing MIS
- Start-up PSPs in POP vertical
- PSPs dissatisfied with generalist MIS solutions

**Product Bundling:**
- PopMIS sold separately from PopSystem campaign orchestration
- Can be purchased together or independently
- Integrates natively with PopSystem but not required

**Go-to-Market:**
- Position as "POP-native MIS"
- Alternative to EFI Pace / PrintVis for POP vertical
- Lower cost, faster implementation vs. enterprise MIS

**Pricing Model:**
- Subscription: $500-$2,000/month based on volume
- One-time implementation: $5K-$25K
- Revenue model: Recurring SaaS

**Pros:**
- Clear product positioning
- Serves underserved market (small POP PSPs)
- Distinct revenue stream
- Can evolve independently of PopSystem

**Cons:**
- Competes with established MIS vendors
- Requires full accounting/financial development
- Support complexity (two products)
- Sales cycle complexity (bundling decisions)

---

### Option B: Integrated Module ("PSP Pro" Tier)

**Concept:** MIS features built into PopSystem as premium tier.

**Packaging:**
```
PopSystem Tiers:

┌────────────────────────────────────────────────────┐
│  PSP Starter ($500/mo)                             │
│  • Campaign orchestration                          │
│  • Order tracking                                  │
│  • Store execution                                 │
│  • Basic reporting                                 │
│  • MIS integration required (bring your own)       │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│  PSP Professional ($1,500/mo)                      │
│  • Everything in Starter, PLUS:                    │
│  • Job costing & estimating                        │
│  • Production scheduling                           │
│  • Equipment tracking                              │
│  • Inventory management                            │
│  • Labor tracking                                  │
│  • Financial subledger                             │
│  • QuickBooks/Xero integration                     │
└────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────┐
│  PSP Enterprise (Custom pricing)                   │
│  • Everything in Professional, PLUS:               │
│  • Multi-plant management                          │
│  • Advanced GL integration                         │
│  • Custom workflows                                │
│  • API access (unlimited)                          │
│  • Dedicated support                               │
└────────────────────────────────────────────────────┘
```

**Target Market:**
- PSPs graduating from basic tier as they grow
- Mid-market PSPs looking to consolidate tools
- PSPs wanting single platform for campaign + production

**Pros:**
- Unified platform experience
- Upsell pathway from base tier
- Single codebase and data model
- Integrated user experience (no context switching)
- Simpler sales (single product, multiple tiers)

**Cons:**
- Scope creep risk for base product
- Must maintain feature parity across tiers
- Complexity in shared vs. tier-specific features
- Large PSPs may resist "bundled" MIS

---

### Option C: Hybrid Approach (Both Available)

**Concept:** Offer both integrated tier AND standalone product.

**Market Segmentation:**

```
Customer Journey:

Small PSP, New to MIS
    ↓
PopSystem Starter + PopMIS Standalone
    ↓
Grows, wants integration
    ↓
Upgrades to PopSystem Pro (integrated)
    ↓
Becomes enterprise
    ↓
Migrates to EFI Pace + PopSystem integration


Mid-size PSP, Has QuickBooks
    ↓
PopSystem Pro (integrated, QB sync)
    ↓
Stays on Pro tier long-term


Large PSP, Has EFI Pace
    ↓
PopSystem Starter + API integration
    ↓
Never needs MIS features (already has)
```

**Product Catalog:**

| Product | Target | Pricing |
|---------|--------|---------|
| **PopSystem Starter** | Large PSPs with existing MIS | $500/mo |
| **PopSystem Pro** | Mid-market PSPs, all-in-one | $1,500/mo |
| **PopMIS Standalone** | PSPs not using PopSystem campaigns | $800/mo |
| **PopSystem + PopMIS Bundle** | Small PSPs, full solution | $1,800/mo (discount) |

**Pros:**
- Maximum market coverage
- Flexibility for customer needs
- Standalone MIS can compete outside PopSystem ecosystem
- Clear upgrade paths

**Cons:**
- Product portfolio complexity
- Marketing message confusion
- Engineering overhead (two MIS codebases OR complex tier logic)
- Support training across configurations

---

### Recommended Strategy

**Phase 1 (v1-v2): Integration-Only**
- Focus on deep integrations with major MIS platforms
- Build robust API for order sync, status updates, webhooks
- Document integration patterns for custom PSP systems
- Validate market demand for MIS features

**Phase 2 (v3): Light MIS Module (Integrated Tier)**
- Add basic job costing to PopSystem Pro tier
- Inventory tracking for campaign materials
- Simple production scheduling
- QuickBooks/Xero subledger integration
- Target: Small PSPs without existing MIS

**Phase 3 (v4+): Evaluate Standalone Product**
- If v3 MIS module proves successful, consider standalone PopMIS
- OR deepen integrations with enterprise MIS for large PSP segment
- Decision based on customer feedback and market traction

**Rationale:**
- De-risks development (prove demand first)
- Serves large PSPs immediately (integration-only)
- Builds MIS competency incrementally
- Preserves optionality for standalone product later

---

## Core MIS Capabilities

If PopSystem develops MIS features (Option B or C), the following capabilities are table stakes for print MIS.

### 1. Job Costing & Estimating

**Job Costing** tracks actual costs incurred for a production job.

**Components:**
- Material costs (substrate, ink, finishing supplies)
- Labor costs (setup time, run time, finishing time)
- Equipment costs (press time, depreciation, maintenance)
- Overhead allocation (rent, utilities, admin)
- Outside services (shipping, outsourced finishing)

**Key Features:**
- Real-time cost tracking during production
- Budget vs. actual variance reporting
- Job profitability analysis
- Historical cost data for estimating

**Data Model:**
```
Job
  - jobNumber
  - campaignId (link to PopSystem campaign)
  - estimatedCost
  - actualCost
  - margin (%)
  - status (ESTIMATING, IN_PRODUCTION, COMPLETED, INVOICED)

JobCostLine
  - jobId
  - costType (MATERIAL, LABOR, EQUIPMENT, OVERHEAD, OUTSOURCE)
  - description
  - estimatedCost
  - actualCost
  - variance
  - glAccountCode
```

**Estimating** generates quotes based on customer requirements.

**Inputs:**
- Quantity
- Substrate/material
- Colors
- Finishing requirements
- Delivery requirements

**Calculations:**
- Material cost = (quantity × substrate cost) + waste factor
- Labor cost = (setup time + run time) × labor rate
- Equipment cost = press time × machine rate
- Markup = costs × margin %
- Quote total = costs + markup

**POP-Specific Considerations:**
- Campaign-level estimating (total kits, all stores)
- Kit assembly labor
- Store-specific addressing/personalization
- Multi-SKU shipments
- Reorder pricing (smaller quantities, higher unit cost)

---

### 2. Production Scheduling

**Purpose:** Plan when jobs run on which equipment to optimize capacity and meet deadlines.

**Key Features:**
- Visual production calendar (Gantt chart)
- Equipment capacity planning
- Job prioritization and sequencing
- Setup time optimization (minimize changeovers)
- Due date management
- Bottleneck identification

**Scheduling Algorithms:**
- **FIFO (First In, First Out):** Simple, but inefficient
- **EDD (Earliest Due Date):** Prioritize by deadline
- **SPT (Shortest Processing Time):** Maximize throughput
- **Constraint-based:** Optimize around bottlenecks (e.g., single finishing machine)

**Data Model:**
```
ProductionSchedule
  - scheduleDate
  - equipmentId
  - jobId
  - startTime
  - endTime
  - status (PLANNED, IN_PROGRESS, COMPLETED, DELAYED)

Equipment
  - equipmentId
  - name (e.g., "HP Indigo 12000")
  - type (PRESS, CUTTER, LAMINATOR, FOLDER, etc.)
  - capacityPerHour
  - status (AVAILABLE, IN_USE, MAINTENANCE, DOWN)
```

**POP-Specific Considerations:**
- Campaign-driven deadlines (install by date)
- Batch production (all stores in one campaign)
- Kit assembly scheduling (post-press)
- Seasonal peaks (holiday campaigns)
- Reorder prioritization (urgent vs. routine)

---

### 3. Inventory Management

**Purpose:** Track materials, finished goods, and kit components.

**Inventory Types:**
- **Raw Materials:** Substrate, ink, adhesives, laminates
- **Finished Goods:** Printed POP items ready to ship
- **Kit Components:** Items to be assembled into kits
- **Shipping Supplies:** Boxes, packing materials

**Key Features:**
- Real-time stock levels
- Reorder points and automatic PO generation
- Lot/batch tracking
- Expiration date management (inks, adhesives)
- Physical inventory reconciliation
- FIFO/LIFO costing

**Data Model:**
```
InventoryItem
  - sku
  - description
  - category (RAW_MATERIAL, FINISHED_GOOD, COMPONENT, SUPPLY)
  - unitOfMeasure
  - quantityOnHand
  - quantityAllocated (reserved for jobs)
  - quantityAvailable (onHand - allocated)
  - reorderPoint
  - reorderQuantity
  - unitCost (current)
  - totalValue (quantity × cost)

InventoryTransaction
  - transactionId
  - transactionType (PURCHASE, CONSUMPTION, ADJUSTMENT, TRANSFER)
  - itemSku
  - quantity (+ or -)
  - unitCost
  - transactionDate
  - reference (PO number, job number, etc.)
```

**POP-Specific Considerations:**
- Campaign-driven material requirements planning
- Kit components tracked separately
- Store-specific personalized items (non-reusable)
- Obsolete inventory (expired campaigns)
- Return/restock from cancelled campaigns

---

### 4. Equipment Tracking

**Purpose:** Monitor equipment usage, maintenance, and performance.

**Key Features:**
- Equipment uptime/downtime tracking
- Preventive maintenance scheduling
- Equipment utilization reports
- Cost per hour calculations
- Performance metrics (impressions/hour, waste %, etc.)

**Data Model:**
```
Equipment
  - equipmentId
  - name
  - type
  - manufacturer
  - model
  - serialNumber
  - purchaseDate
  - purchaseCost
  - depreciationSchedule
  - currentValue

EquipmentLog
  - logId
  - equipmentId
  - logType (PRODUCTION, MAINTENANCE, DOWNTIME)
  - startTime
  - endTime
  - jobId (if production)
  - notes
  - userId (operator)

MaintenanceSchedule
  - scheduleId
  - equipmentId
  - maintenanceType (PREVENTIVE, REPAIR)
  - frequencyDays
  - lastPerformed
  - nextDue
  - estimatedDowntime
```

**POP-Specific Considerations:**
- Equipment switching costs (long runs = more efficient)
- Ganging jobs on sheet (maximize press efficiency)
- Finishing equipment as bottleneck
- Kit assembly workstations (not presses)

---

### 5. Labor Management

**Purpose:** Track employee time, productivity, and costs.

**Key Features:**
- Time clock integration
- Job-level time tracking
- Labor cost allocation to jobs
- Productivity reporting (units/hour)
- Overtime tracking
- Shift scheduling

**Data Model:**
```
Employee
  - employeeId
  - name
  - role (PRESS_OPERATOR, FINISHER, ASSEMBLER, SHIPPER)
  - hourlyRate
  - status (ACTIVE, INACTIVE)

TimeEntry
  - entryId
  - employeeId
  - jobId
  - workType (SETUP, RUN, TEARDOWN, ASSEMBLY, QA)
  - startTime
  - endTime
  - hoursWorked
  - laborCost (hours × rate)
```

**POP-Specific Considerations:**
- Kit assembly labor (manual process)
- Quality control time (proof checking)
- Packing and shipping labor
- Store-specific addressing time

---

### 6. Purchasing

**Purpose:** Manage vendor relationships and procurement.

**Key Features:**
- Purchase order creation and tracking
- Vendor management
- Receiving and inspection
- Price history and vendor comparison
- Blanket POs for recurring materials
- Three-way match (PO, receipt, invoice)

**Data Model:**
```
PurchaseOrder
  - poNumber
  - vendorId
  - orderDate
  - expectedDeliveryDate
  - status (DRAFT, SENT, ACKNOWLEDGED, RECEIVED, CLOSED)
  - totalAmount

POLine
  - poNumber
  - lineNumber
  - itemSku
  - description
  - quantityOrdered
  - quantityReceived
  - unitPrice
  - lineTotal

Vendor
  - vendorId
  - name
  - contact
  - paymentTerms (NET30, NET60, etc.)
  - leadTimeDays
```

**POP-Specific Considerations:**
- Campaign-driven material procurement
- Just-in-time ordering for large campaigns
- Substrate specialty items (custom sizes, finishes)

---

### 7. Financial Reporting

**Purpose:** Provide management visibility into financial performance.

**Key Reports:**
- Profit & Loss (P&L) by period
- Job profitability report
- Equipment utilization and ROI
- Inventory valuation
- Accounts receivable aging
- Cash flow projection

**Data Model:**
```
GeneralLedgerAccount
  - accountCode
  - accountName
  - accountType (ASSET, LIABILITY, EQUITY, REVENUE, EXPENSE)
  - balance

JournalEntry
  - entryId
  - entryDate
  - description
  - source (JOB_COST, INVOICE, PAYMENT, ADJUSTMENT)
  - debitAccountCode
  - creditAccountCode
  - amount
  - reference (job number, invoice number, etc.)
```

**POP-Specific Considerations:**
- Campaign profitability (not just job profitability)
- Brand-level P&L (if multi-brand PSP)
- Reorder margin analysis
- Seasonal revenue reporting (holiday spikes)

---

### 8. Quote Generation

**Purpose:** Automate pricing and proposal generation.

**Key Features:**
- Template-based quote creation
- Pricing formulas (cost + markup)
- Quantity breaks (tiered pricing)
- Quote versioning (revisions)
- Approval workflows
- Quote-to-order conversion

**Data Model:**
```
Quote
  - quoteNumber
  - brandId
  - createdDate
  - expirationDate
  - status (DRAFT, SENT, ACCEPTED, REJECTED, EXPIRED)
  - totalAmount
  - margin (%)

QuoteLine
  - quoteNumber
  - lineNumber
  - description
  - quantity
  - unitPrice
  - lineTotal
  - estimatedCost
  - margin (%)
```

**POP-Specific Considerations:**
- Campaign-level quoting (total program cost)
- Per-store cost breakdown
- Recurring campaign pricing (annual programs)
- Reorder pricing (higher unit cost, lower quantity)

---

## Accounting & General Ledger Integration

Accounting integration is the most complex aspect of MIS development. Two primary approaches:

### Approach 1: Integration-First (Recommended for v3)

**Concept:** PopSystem manages operational data (jobs, costs, inventory). Accounting handled by external system (QuickBooks, Xero, Sage).

**Architecture:**
```
┌────────────────────────────────────────────────────────┐
│              PopSystem MIS Module                      │
│                                                        │
│  Operational Data:                                     │
│  • Job costing                                         │
│  • Inventory transactions                              │
│  • Purchase orders                                     │
│  • Labor time                                          │
│                                                        │
│         ↓ Subledger Journals ↓                         │
└────────────────────────────────────────────────────────┘
                       ↓
           Journal Entry Generator
                       ↓
┌────────────────────────────────────────────────────────┐
│          QuickBooks / Xero / Sage (GL)                 │
│                                                        │
│  Financial Data:                                       │
│  • General ledger                                      │
│  • Accounts receivable                                 │
│  • Accounts payable                                    │
│  • Bank reconciliation                                 │
│  • Tax reporting                                       │
│  • Financial statements                                │
└────────────────────────────────────────────────────────┘
```

**How It Works:**

1. **Operational transactions** happen in PopSystem (job costs, inventory, labor)
2. **Subledger** tracks detailed operational data
3. **Journal entry generator** creates summary GL entries
4. **API sync** pushes journal entries to accounting system
5. **Reconciliation** ensures subledger totals match GL

**Example Journal Entries:**

```
Job Completion (Job #12345):
  DR: Work in Process (Asset)         $1,500
      CR: Raw Materials Inventory (Asset)  $800
      CR: Labor Expense (Expense)           $500
      CR: Equipment Cost (Expense)          $200

Job Shipped (Job #12345):
  DR: Cost of Goods Sold (Expense)    $1,500
      CR: Work in Process (Asset)           $1,500

Invoice Created (Job #12345):
  DR: Accounts Receivable (Asset)     $2,250
      CR: Sales Revenue (Revenue)           $2,250
```

**Integration Connectors:**

| System | API | Complexity | Market Share |
|--------|-----|-----------|--------------|
| **QuickBooks Online** | REST API, OAuth2 | Medium | 80% (SMB) |
| **QuickBooks Desktop** | QBXML, SDK | High | 15% (legacy) |
| **Xero** | REST API, OAuth2 | Medium | 3% (growing) |
| **Sage Intacct** | REST API | High | 2% (enterprise) |
| **NetSuite** | SuiteTalk (SOAP) | Very High | <1% (large PSPs) |

**Pros:**
- Leverage existing accounting expertise (PSP's accountant knows QuickBooks)
- Avoid building tax, payroll, banking features
- Lower development effort (connectors vs. full GL)
- Established compliance and reporting

**Cons:**
- Integration complexity and error handling
- Dual-system reconciliation
- API rate limits and sync delays
- Feature constraints (limited by external system)

---

### Approach 2: Universal GL (Built-in Accounting)

**Concept:** PopSystem includes full general ledger, A/R, A/P, and financial reporting.

**Architecture:**
```
┌─────────────────────────────────────────────────────────┐
│           PopSystem Full ERP Platform                   │
│                                                         │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Operational Modules                              │  │
│  │  • Job costing                                    │  │
│  │  • Inventory                                      │  │
│  │  • Purchasing                                     │  │
│  │  • Labor                                          │  │
│  └───────────────────────────────────────────────────┘  │
│                      ↓                                  │
│  ┌───────────────────────────────────────────────────┐  │
│  │  General Ledger                                   │  │
│  │  • Chart of accounts                              │  │
│  │  • Journal entries                                │  │
│  │  • Financial statements                           │  │
│  │  • Multi-currency                                 │  │
│  └───────────────────────────────────────────────────┘  │
│                      ↓                                  │
│  ┌───────────────────────────────────────────────────┐  │
│  │  Reporting & Compliance                           │  │
│  │  • Tax reporting                                  │  │
│  │  • Audit trails                                   │  │
│  │  • Financial exports                              │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

**Pros:**
- Unified platform (no external dependencies)
- Real-time financial visibility
- Custom reporting tailored to POP workflows
- No integration complexity

**Cons:**
- Massive development effort (3-5 years)
- Accounting compliance burden (GAAP, tax regulations)
- Competing with mature accounting platforms
- Requires deep accounting expertise on team
- PSPs may prefer established accounting systems

**Recommendation:** **Do NOT build full GL for v3.** Too high effort, too low differentiation. Focus on integration-first approach.

---

### Approach 3: Hybrid (Subledger + Integration Layer)

**Concept:** Best of both worlds. PopSystem maintains detailed subledgers for operational data, with flexible GL integration.

**Architecture:**
```
┌─────────────────────────────────────────────────────────┐
│              PopSystem Subledgers                       │
│                                                         │
│  • Job Cost Subledger (detailed job expenses)           │
│  • Inventory Subledger (detailed stock movements)       │
│  • A/R Subledger (customer invoices)                    │
│  • A/P Subledger (vendor bills)                         │
│                                                         │
│         ↓ Configurable Mapping ↓                        │
└─────────────────────────────────────────────────────────┘
                       ↓
        ┌──────────────────────────────┐
        │  Journal Entry Generator     │
        │  • Account mapping rules     │
        │  • Summarization logic       │
        │  • Multi-currency conversion │
        └──────────────────────────────┘
                       ↓
        ┌──────────────┬────────────────┐
        ↓              ↓                ↓
  QuickBooks       Xero            Built-in GL
   Connector     Connector        (Optional)
```

**Key Features:**
- Subledgers provide operational detail
- GL integration is configurable (choose your accounting system)
- Can operate standalone OR sync to external GL
- Account mapping UI for PSP customization

**Example Subledger Data:**

```
Job Cost Subledger Entry:
  Job: 12345
  Date: 2025-12-20
  Line: Material - Substrate
  Quantity: 500 sheets
  Unit Cost: $1.50
  Total: $750
  GL Account: 5000-RAW-MATERIALS

Summarized Journal Entry (to QuickBooks):
  Date: 2025-12-20
  DR: Work in Process (#1200) - $750
  CR: Inventory (#1100) - $750
  Memo: Materials for Job 12345
```

**Pros:**
- Detailed operational data in PopSystem
- Flexibility in accounting system choice
- Can build "lite GL" incrementally if needed
- Reconciliation is built-in (subledger = source of truth)

**Cons:**
- More complex architecture
- Mapping configuration required per PSP
- Support complexity (multiple accounting systems)

**Recommendation:** **This is the preferred architecture for v3-v4.** Balances flexibility, development effort, and operational value.

---

### Multi-Currency Support

For PSPs operating internationally or serving global brands:

**Requirements:**
- Transaction currency (currency of the sale/purchase)
- Functional currency (PSP's reporting currency)
- Exchange rate management (daily rates, locked rates for transactions)
- Realized/unrealized gain/loss tracking
- Multi-currency financial reports

**Data Model:**
```
Currency
  - currencyCode (USD, CAD, EUR, GBP, etc.)
  - currencyName
  - symbol
  - active (boolean)

ExchangeRate
  - fromCurrency
  - toCurrency
  - effectiveDate
  - rate
  - source (MANUAL, API_IMPORT)

Transaction
  - transactionId
  - transactionCurrency
  - transactionAmount
  - exchangeRate (locked at transaction time)
  - functionalCurrency
  - functionalAmount
```

**v3 Scope:** Single currency only. Multi-currency in v4+.

---

## Competitive Landscape

### Major Print MIS Vendors

#### 1. **EFI Pace**

**Overview:**
- Market leader in commercial print MIS
- Comprehensive ERP (estimating, production, accounting, shipping)
- Primarily on-premise, cloud version available
- Deep customization required

**Strengths:**
- Mature platform (30+ years)
- Strong estimating and costing
- Multi-plant support
- Large install base (700+ customers)

**Weaknesses:**
- Expensive ($50K-$200K+ annual cost)
- Complex implementation (6-12 months)
- Legacy UI (dated user experience)
- Not campaign-aware or POP-specific

**Target Market:** Large commercial printers (>$10M revenue)

**PopSystem Differentiation:**
- Campaign orchestration native
- Store-level execution tracking
- Lightweight, fast implementation
- Modern cloud-native UX

---

#### 2. **PrintVis**

**Overview:**
- Built on Microsoft Dynamics 365 Business Central
- Strong manufacturing focus (capacity planning, shop floor control)
- European market leader
- Deep ERP integration (finance, CRM, inventory)

**Strengths:**
- Leverages Dynamics 365 ecosystem
- Strong workflow automation
- Good multi-site support
- Robust financials (via D365)

**Weaknesses:**
- Requires Microsoft Dynamics license ($$$)
- Steep learning curve
- Not POP-native
- Complex setup

**Target Market:** Mid to large PSPs already on Microsoft stack

**PopSystem Differentiation:**
- No ERP platform dependency
- POP-specific workflows
- Campaign-driven production
- Store execution integration

---

#### 3. **Tharstern**

**Overview:**
- Modern cloud-based print MIS
- Founded in UK, growing in US
- Strong estimating and quoting
- Good UX (better than legacy competitors)

**Strengths:**
- Cloud-native architecture
- Modern interface
- Faster implementation vs. Pace/PrintVis
- Modular pricing (buy what you need)

**Weaknesses:**
- Generalist (not POP-focused)
- Limited store-level tracking
- Smaller install base (newer entrant)
- Manual campaign management

**Target Market:** Mid-market commercial printers

**PopSystem Differentiation:**
- Campaign orchestration + MIS unified
- Store execution tracking
- Proof-of-performance workflows
- POP vertical specialization

---

#### 4. **ShopVOX**

**Overview:**
- Affordable cloud MIS for small print shops
- Sign and graphics focus
- Simple UX, fast setup
- Subscription pricing ($200-$500/mo)

**Strengths:**
- Low cost, low barrier to entry
- Easy to use
- Good for start-ups and small shops
- Quick implementation (days, not months)

**Weaknesses:**
- Limited scalability
- Weak multi-location support
- No campaign orchestration
- Basic financials (no GL)

**Target Market:** Small print shops (<$1M revenue)

**PopSystem Differentiation:**
- Campaign-native vs. job-native
- Multi-store execution tracking
- Scalable to larger PSPs
- POP-specific features (kits, reorders)

---

#### 5. **Cyrious Control**

**Overview:**
- Legacy print MIS (20+ years)
- Strong in sign/wide-format
- Workflow automation focus
- Primarily on-premise

**Strengths:**
- Mature feature set
- Strong workflow engine
- Loyal customer base
- Good for complex custom work

**Weaknesses:**
- Dated UI (Windows client)
- Limited cloud offering
- Not campaign-aware
- Slow innovation cycle

**Target Market:** Legacy customers, wide-format specialists

**PopSystem Differentiation:**
- Modern web-based UX
- Cloud-native, mobile-friendly
- Campaign orchestration built-in
- Store execution integration

---

### Competitive Matrix

| Feature | EFI Pace | PrintVis | Tharstern | ShopVOX | PopSystem (v4 Vision) |
|---------|----------|----------|-----------|---------|----------------------|
| **Campaign Orchestration** | ❌ Manual | ❌ Manual | ❌ Manual | ❌ Manual | ✅ Native |
| **Store Execution Tracking** | ❌ No | ❌ No | ❌ No | ❌ No | ✅ Core Feature |
| **Proof of Performance** | ❌ No | ❌ No | ❌ No | ❌ No | ✅ Built-in |
| **Job Costing** | ✅ Advanced | ✅ Advanced | ✅ Good | ⚠️ Basic | ✅ POP-Optimized |
| **Production Scheduling** | ✅ Advanced | ✅ Advanced | ✅ Good | ⚠️ Basic | ✅ Campaign-Aware |
| **Inventory Management** | ✅ Full | ✅ Full | ✅ Good | ⚠️ Basic | ✅ Kit-Focused |
| **Estimating/Quoting** | ✅ Advanced | ✅ Advanced | ✅ Excellent | ⚠️ Basic | ✅ Campaign-Based |
| **GL Integration** | ✅ Built-in | ✅ D365 Native | ✅ QB/Xero | ⚠️ QB Only | ✅ Multi-Platform |
| **Pricing** | 💰💰💰💰 | 💰💰💰💰 | 💰💰💰 | 💰 | 💰💰 |
| **Implementation Time** | 6-12 mo | 6-12 mo | 3-6 mo | Days | 2-4 weeks |
| **Target Market** | Large | Enterprise | Mid | Small | Small-Mid POP |

**Key Insight:** No competitor natively integrates campaign orchestration + MIS + store execution. This is PopSystem's unique value proposition.

---

### Market Gaps & Opportunities

**Gap 1: POP-Specific MIS**
- Existing MIS systems are generalists (commercial, packaging, labels)
- POP workflows are different (campaigns, kits, store-level tracking)
- **Opportunity:** Build vertical MIS for POP market

**Gap 2: Small PSP Solutions**
- Small POP PSPs use QuickBooks + Excel + manual processes
- Can't afford Pace/PrintVis ($50K+/year)
- ShopVOX not POP-aware
- **Opportunity:** Affordable POP MIS for <$5M revenue PSPs

**Gap 3: Integrated Campaign + MIS**
- Current model requires two systems (PopSystem + MIS)
- Data silos, manual sync, duplicate entry
- **Opportunity:** Single platform for campaign + production

**Gap 4: Store Execution + Accounting**
- No MIS links store-level execution to job costing
- Can't track cost-per-store or execution efficiency
- **Opportunity:** Unified data model from campaign → production → store → financials

---

### Build vs. Acquire Decision Framework

**When to BUILD:**
- Unique POP workflows not served by existing MIS
- Integration-first approach (subledger + connectors)
- Incremental development (v3 → v4 → v4+)
- Differentiation through vertical focus

**When to ACQUIRE:**
- Accelerate time to market (5 years → 1 year)
- Gain existing customer base
- Obtain proven accounting/financial modules
- Enter market with established credibility

**When to PARTNER:**
- Large PSPs already on Pace/PrintVis
- Integration-only strategy
- Avoid MIS development entirely
- Focus on campaign orchestration differentiation

**Recommended for PopSystem:**

**Phase 1 (v1-v2):** PARTNER (deep integrations)
**Phase 2 (v3):** BUILD (light MIS module, subledger approach)
**Phase 3 (v4+):** EVALUATE (acquire if market traction warrants)

---

## Technical Architecture

### Subledger Design (v3 Approach)

**Principle:** PopSystem owns operational detail. External GL owns financial summary.

**Subledger Entities:**

```
┌──────────────────────────────────────────────────────────┐
│                  Job Cost Subledger                      │
└──────────────────────────────────────────────────────────┘

JobCostTransaction
  - transactionId (UUID)
  - jobNumber
  - campaignId (link to PopSystem campaign)
  - transactionDate
  - transactionType (MATERIAL, LABOR, EQUIPMENT, OVERHEAD, OUTSOURCE)
  - description
  - quantity
  - unitCost
  - totalCost
  - glAccountCode (mapped to external GL)
  - posted (boolean - has it been sent to GL?)
  - journalEntryRef (GL entry ID after posting)


┌──────────────────────────────────────────────────────────┐
│               Inventory Subledger                        │
└──────────────────────────────────────────────────────────┘

InventoryTransaction
  - transactionId
  - transactionDate
  - transactionType (PURCHASE, CONSUMPTION, ADJUSTMENT, TRANSFER)
  - itemSku
  - quantity (+ or -)
  - unitCost
  - totalValue
  - reference (PO number, job number, etc.)
  - warehouseLocation
  - glAccountCode
  - posted


┌──────────────────────────────────────────────────────────┐
│                A/R Subledger (Invoices)                  │
└──────────────────────────────────────────────────────────┘

Invoice
  - invoiceNumber
  - brandId
  - campaignId
  - invoiceDate
  - dueDate
  - totalAmount
  - amountPaid
  - balanceDue
  - status (DRAFT, SENT, PARTIAL_PAYMENT, PAID, OVERDUE)
  - posted

InvoiceLine
  - invoiceNumber
  - lineNumber
  - jobNumber
  - description
  - quantity
  - unitPrice
  - lineTotal
  - glAccountCode (revenue account)


┌──────────────────────────────────────────────────────────┐
│                A/P Subledger (Vendor Bills)              │
└──────────────────────────────────────────────────────────┘

VendorBill
  - billNumber
  - vendorId
  - billDate
  - dueDate
  - totalAmount
  - amountPaid
  - balanceDue
  - status (PENDING, PAID)
  - posted

BillLine
  - billNumber
  - lineNumber
  - poNumber
  - description
  - quantity
  - unitCost
  - lineTotal
  - glAccountCode (expense account)
```

---

### Journal Entry Generator

**Purpose:** Transform subledger transactions into GL journal entries.

**Workflow:**
1. **Accumulate** subledger transactions (hourly, daily, or on-demand)
2. **Summarize** by GL account code
3. **Generate** balanced journal entries (debits = credits)
4. **Post** to external GL via API
5. **Mark** subledger records as posted
6. **Store** GL entry reference for reconciliation

**Example Code (Conceptual):**

```typescript
async function generateJournalEntries(date: Date) {
  const unpostedTransactions = await db.jobCostTransaction.findMany({
    where: { posted: false, transactionDate: date }
  });

  // Group by GL account
  const accountSummary = summarizeByAccount(unpostedTransactions);

  // Create balanced journal entry
  const journalEntry = {
    entryDate: date,
    description: `Job costs for ${date}`,
    lines: [
      // Debit WIP
      { accountCode: '1200', debitAmount: accountSummary.totalCost, creditAmount: 0 },
      // Credit various expense accounts
      ...accountSummary.credits
    ]
  };

  // Post to QuickBooks
  const glEntryRef = await quickbooks.createJournalEntry(journalEntry);

  // Update subledger
  await db.jobCostTransaction.updateMany({
    where: { transactionId: { in: unpostedTransactions.map(t => t.id) } },
    data: { posted: true, journalEntryRef: glEntryRef }
  });
}
```

---

### Integration Connectors

**QuickBooks Online Connector (Priority 1)**

**Authentication:** OAuth2
**API:** REST
**Rate Limits:** 500 requests/min (per app), 100 requests/min (per company)

**Key Endpoints:**
- `POST /v3/company/{companyId}/journalentry` - Create journal entry
- `POST /v3/company/{companyId}/invoice` - Create invoice
- `POST /v3/company/{companyId}/bill` - Create vendor bill
- `GET /v3/company/{companyId}/account` - List GL accounts

**Mapping Configuration:**
```json
{
  "accountMappings": {
    "1100-INVENTORY": "Inventory Asset",
    "1200-WIP": "Work in Process",
    "5000-COGS": "Cost of Goods Sold",
    "4000-REVENUE": "Sales Revenue"
  },
  "syncFrequency": "DAILY",
  "postingMode": "SUMMARY"
}
```

**Error Handling:**
- Retry on rate limit (exponential backoff)
- Alert on authentication failure (OAuth token expired)
- Queue failed entries for manual review

---

**Xero Connector (Priority 2)**

**Authentication:** OAuth2
**API:** REST
**Rate Limits:** 60 requests/min

**Similar approach to QuickBooks:**
- Journal entry posting
- Invoice creation
- Account mapping
- Error handling

---

**Sage Intacct Connector (Priority 3 - Enterprise)**

**Authentication:** Web Services credentials
**API:** REST (legacy XML also available)
**Complexity:** Higher (enterprise features, multi-entity)

**Target Market:** Large PSPs with complex financials

---

### Data Model: Core MIS Tables

**Jobs Table:**
```sql
CREATE TABLE jobs (
  job_id UUID PRIMARY KEY,
  job_number VARCHAR(50) UNIQUE NOT NULL,
  campaign_id UUID REFERENCES campaigns(campaign_id),
  brand_id UUID REFERENCES brands(brand_id),
  psp_tenant_id UUID REFERENCES psp_tenants(tenant_id),

  job_name VARCHAR(255),
  job_type VARCHAR(50), -- INITIAL_CAMPAIGN, REORDER, CUSTOM

  -- Dates
  created_date TIMESTAMP NOT NULL,
  due_date DATE,
  start_date DATE,
  completion_date DATE,

  -- Costing
  estimated_cost DECIMAL(10,2),
  actual_cost DECIMAL(10,2),
  quoted_price DECIMAL(10,2),
  invoiced_amount DECIMAL(10,2),
  margin_percent DECIMAL(5,2),

  -- Status
  job_status VARCHAR(50), -- ESTIMATING, APPROVED, IN_PRODUCTION, COMPLETED, INVOICED

  -- Audit
  created_by UUID,
  updated_at TIMESTAMP
);
```

**Job Cost Lines Table:**
```sql
CREATE TABLE job_cost_lines (
  cost_line_id UUID PRIMARY KEY,
  job_id UUID REFERENCES jobs(job_id),

  cost_type VARCHAR(50), -- MATERIAL, LABOR, EQUIPMENT, OVERHEAD, OUTSOURCE
  cost_category VARCHAR(100), -- SUBSTRATE, INK, PRESS_TIME, FINISHING, etc.
  description TEXT,

  estimated_quantity DECIMAL(10,2),
  actual_quantity DECIMAL(10,2),
  unit_of_measure VARCHAR(20),

  estimated_unit_cost DECIMAL(10,4),
  actual_unit_cost DECIMAL(10,4),

  estimated_total DECIMAL(10,2),
  actual_total DECIMAL(10,2),
  variance DECIMAL(10,2), -- actual - estimated

  gl_account_code VARCHAR(50),
  posted BOOLEAN DEFAULT FALSE,
  journal_entry_ref VARCHAR(100),

  transaction_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Equipment Table:**
```sql
CREATE TABLE equipment (
  equipment_id UUID PRIMARY KEY,
  psp_tenant_id UUID REFERENCES psp_tenants(tenant_id),

  equipment_name VARCHAR(255) NOT NULL,
  equipment_type VARCHAR(50), -- PRESS, CUTTER, LAMINATOR, FOLDER, ASSEMBLY_STATION
  manufacturer VARCHAR(100),
  model VARCHAR(100),
  serial_number VARCHAR(100),

  -- Costing
  purchase_date DATE,
  purchase_cost DECIMAL(10,2),
  depreciation_years INT,
  hourly_rate DECIMAL(10,2), -- Allocated cost per hour

  -- Capacity
  capacity_per_hour DECIMAL(10,2),
  capacity_unit VARCHAR(50), -- IMPRESSIONS, SHEETS, FEET, etc.

  -- Status
  status VARCHAR(50), -- ACTIVE, MAINTENANCE, RETIRED

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);
```

**Production Schedule Table:**
```sql
CREATE TABLE production_schedule (
  schedule_id UUID PRIMARY KEY,
  job_id UUID REFERENCES jobs(job_id),
  equipment_id UUID REFERENCES equipment(equipment_id),

  scheduled_date DATE NOT NULL,
  scheduled_start_time TIME,
  scheduled_end_time TIME,

  actual_start_time TIMESTAMP,
  actual_end_time TIMESTAMP,

  status VARCHAR(50), -- PLANNED, IN_PROGRESS, COMPLETED, DELAYED, CANCELLED

  assigned_to UUID REFERENCES users(user_id), -- Operator

  notes TEXT,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);
```

**Inventory Items Table:**
```sql
CREATE TABLE inventory_items (
  item_id UUID PRIMARY KEY,
  psp_tenant_id UUID REFERENCES psp_tenants(tenant_id),

  sku VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  item_category VARCHAR(50), -- RAW_MATERIAL, FINISHED_GOOD, COMPONENT, SUPPLY

  -- Quantities
  quantity_on_hand DECIMAL(10,2) DEFAULT 0,
  quantity_allocated DECIMAL(10,2) DEFAULT 0, -- Reserved for jobs
  quantity_available AS (quantity_on_hand - quantity_allocated) STORED,

  unit_of_measure VARCHAR(20),

  -- Costing
  unit_cost DECIMAL(10,4), -- Current average cost
  total_value DECIMAL(10,2),

  -- Reordering
  reorder_point DECIMAL(10,2),
  reorder_quantity DECIMAL(10,2),
  preferred_vendor_id UUID REFERENCES vendors(vendor_id),

  -- GL
  gl_account_code VARCHAR(50),

  -- Status
  active BOOLEAN DEFAULT TRUE,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP
);
```

**Inventory Transactions Table:**
```sql
CREATE TABLE inventory_transactions (
  transaction_id UUID PRIMARY KEY,
  item_id UUID REFERENCES inventory_items(item_id),

  transaction_type VARCHAR(50), -- PURCHASE, CONSUMPTION, ADJUSTMENT, TRANSFER
  transaction_date TIMESTAMP NOT NULL,

  quantity DECIMAL(10,2), -- Positive = increase, Negative = decrease
  unit_cost DECIMAL(10,4),
  total_value DECIMAL(10,2),

  reference_type VARCHAR(50), -- PO, JOB, ADJUSTMENT
  reference_id UUID,

  warehouse_location VARCHAR(100),

  gl_account_code VARCHAR(50),
  posted BOOLEAN DEFAULT FALSE,
  journal_entry_ref VARCHAR(100),

  notes TEXT,
  created_by UUID REFERENCES users(user_id),
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Phase Roadmap

### v1-v2: Integration-Only (Current Approach)

**Scope:**
- PopSystem generates `StoreOrder` entities
- PSPs use existing MIS systems (EFI Pace, PrintVis, Tharstern, custom)
- API integration for order sync and status updates

**Deliverables:**
- ✅ REST API for order retrieval
- ✅ Webhook subscriptions for order events
- ✅ `pspOrderRef` field to link PopSystem order to MIS job
- 🔲 Sample integration code (Python, C#)
- 🔲 Integration guides for major MIS platforms

**Effort:** 0 months (v1 scope complete)

**Success Metrics:**
- 2+ PSPs successfully integrate PopSystem with their MIS
- Order sync latency < 5 minutes
- 95%+ status update accuracy

---

### v3: Basic Job Costing & Inventory (Light MIS Module)

**Timeline:** 12-18 months after v1 launch

**Target Market:** Small PSPs without existing MIS (< $5M revenue)

**Scope:**

**Job Costing:**
- Link jobs to PopSystem campaigns
- Track material, labor, equipment costs
- Job profitability reports
- Actual vs. estimated variance

**Inventory Management:**
- Track raw materials and finished goods
- Consumption tracking (materials used per job)
- Reorder alerts
- Basic stock adjustments

**Scheduling:**
- Simple production calendar (date-based, not time-optimized)
- Equipment assignment
- Due date tracking

**Integration:**
- QuickBooks Online subledger integration (invoices, job costs)
- Journal entry generator for GL posting
- Account mapping configuration

**NOT in v3:**
- Estimating/quoting (manual entry only)
- Advanced scheduling algorithms
- Multi-plant support
- Purchase order management
- Xero/Sage integration (QB only)

**Data Model:**
- `jobs` table (basic fields)
- `job_cost_lines` table
- `inventory_items` table
- `inventory_transactions` table
- `production_schedule` table (simple)
- `equipment` table (basic)

**UI Additions:**
- "MIS" tab in PSP portal
- Job costing screen (list, detail, cost entry)
- Inventory screen (stock levels, transactions)
- Production schedule (calendar view)
- QuickBooks sync configuration

**Effort:** 6-9 months (2 engineers)

**Success Metrics:**
- 5+ small PSPs adopt MIS module
- 80%+ of costs tracked in PopSystem (vs. manual)
- QB sync accuracy 95%+
- Job profitability visibility within 24 hours of completion

---

### v4: Full MIS Module (POP-Optimized)

**Timeline:** 24-36 months after v1 launch

**Target Market:** Mid-market PSPs ($2M-$10M revenue), both new and migrating from other MIS

**Scope:**

**Estimating & Quoting:**
- Template-based quote generation
- Pricing formulas (cost + markup)
- Quantity breaks
- Quote-to-job conversion

**Advanced Scheduling:**
- Constraint-based scheduling (equipment bottlenecks)
- Gantt chart visualization
- Setup time optimization
- Campaign-driven batch scheduling (gang multiple stores)

**Purchasing:**
- Purchase order creation
- Vendor management
- Receiving and inspection
- Three-way match (PO, receipt, invoice)

**Labor Management:**
- Time tracking integration
- Labor cost allocation to jobs
- Productivity reporting

**Financial Reporting:**
- Job profitability dashboard
- Equipment utilization reports
- Inventory valuation
- Campaign P&L (roll-up across all jobs)

**Multi-Platform Accounting:**
- QuickBooks Online (expanded)
- QuickBooks Desktop (QBXML)
- Xero integration
- Sage Intacct (enterprise)

**Advanced Inventory:**
- Lot/batch tracking
- Multi-location warehouses
- Cycle counting
- FIFO/LIFO costing

**Kit Assembly Tracking:**
- Kit BOM (bill of materials)
- Assembly labor tracking
- Component picking lists
- QA checkpoints

**NOT in v4:**
- Multi-plant (that's v4+)
- Multi-currency (that's v4+)
- Advanced manufacturing (lean, six sigma)

**Effort:** 18-24 months (4-5 engineers)

**Success Metrics:**
- 20+ PSPs using full MIS module
- 10+ PSPs migrate from legacy MIS to PopSystem
- Average implementation time < 8 weeks
- Customer satisfaction (NPS) > 40

---

### v4+: Complete ERP (Enterprise Features)

**Timeline:** 36+ months after v1 launch

**Target Market:** Large PSPs (>$10M revenue), multi-plant operations

**Scope:**

**Multi-Plant Management:**
- Plant-level inventory and equipment
- Inter-plant transfers
- Centralized scheduling with plant capacity
- Plant-level P&L

**Multi-Currency:**
- Transaction currency support
- Exchange rate management
- Realized/unrealized gain/loss
- Multi-currency financial reports

**Advanced Analytics:**
- Business intelligence dashboards
- Predictive costing (ML-based)
- Campaign profitability forecasting
- Capacity planning optimization

**Built-in General Ledger (Optional):**
- Full GL, A/R, A/P
- Bank reconciliation
- Tax reporting
- Financial statement generation
- Audit trails

**Supply Chain:**
- Vendor portals (self-service POs)
- Automated procurement
- Vendor performance tracking

**Quality Management:**
- Defect tracking
- Root cause analysis
- SPC (statistical process control)

**HR & Payroll (Partner Integration):**
- Integration with ADP, Paychex
- Time clock sync
- Benefits tracking

**Effort:** Ongoing (20+ months, 6-8 engineers)

**Success Metrics:**
- 50+ PSPs on MIS module
- 5+ enterprise PSPs (>$20M revenue) using PopSystem as primary ERP
- Platform revenue > $5M/year from MIS features

---

## FOSS & Licensable Options

If PopSystem chooses to accelerate MIS development by adapting existing open-source platforms, here are the leading options:

### Option 1: Odoo (Recommended FOSS Candidate)

**Overview:**
- Open-source ERP platform (Python/PostgreSQL)
- Modular architecture (CRM, MIS, Inventory, Accounting, HR, etc.)
- 7M+ users worldwide
- Active community and commercial support (Odoo S.A.)

**Licensing:**
- **Community Edition:** LGPL (open source, free)
- **Enterprise Edition:** Proprietary (paid, $20/user/month)

**Relevant Modules:**
- **Manufacturing:** Production orders, BOM, work centers
- **Inventory:** Stock management, warehousing
- **Accounting:** GL, A/R, A/P, bank reconciliation
- **Project:** Job tracking, time sheets
- **Sales:** Quotes, orders

**Customization for POP:**
- Create "Campaign" module (custom)
- Extend Manufacturing for kit assembly
- Add store execution tracking
- Build PopSystem integration layer

**Pros:**
- Proven ERP framework (don't reinvent GL, inventory, etc.)
- Active development and community
- Modular (use what you need)
- Cost-effective vs. building from scratch

**Cons:**
- Odoo UX is dated (requires customization)
- Python stack (vs. PopSystem's TS/JS)
- Licensing complexity (Community vs. Enterprise)
- Integration overhead (Odoo ↔ PopSystem sync)

**Effort to Adapt:**
- Evaluate: 1 month
- Custom modules: 6-12 months
- Integration: 3-6 months
- Total: 12-18 months (vs. 24+ months build from scratch)

**Recommendation:** **Strong candidate if PopSystem pursues standalone MIS product.** Accelerates time to market while leveraging proven accounting/financial modules.

---

### Option 2: ERPNext (Alternative FOSS)

**Overview:**
- Open-source ERP (Python/MariaDB)
- Built by Frappe Technologies (India)
- Manufacturing focus
- Modern web UI (better than Odoo)

**Licensing:**
- **Community Edition:** GPL (open source, free)
- **Cloud Hosting:** SaaS pricing ($10-50/user/month)

**Relevant Modules:**
- Manufacturing
- Stock (inventory)
- Accounts (GL, A/R, A/P)
- Projects
- Buying (purchasing)
- Selling (quotes, invoices)

**Pros:**
- Modern UI (React-based)
- Strong manufacturing features
- Active community
- Good documentation

**Cons:**
- Smaller ecosystem than Odoo
- Less third-party integrations
- Python stack (integration complexity)
- Fewer US-based consultants

**Effort to Adapt:** Similar to Odoo (12-18 months)

**Recommendation:** **Secondary option to Odoo.** Consider if UX is priority over ecosystem.

---

### Option 3: Dolibarr (Lightweight FOSS)

**Overview:**
- Open-source ERP/CRM (PHP/MySQL)
- European focus
- Small business oriented
- Modular

**Pros:**
- Lightweight, easy to install
- PHP stack (easier integration if PopSystem uses PHP anywhere)
- Low resource requirements

**Cons:**
- Less sophisticated than Odoo/ERPNext
- Weaker manufacturing features
- Smaller community
- Dated UI

**Recommendation:** **Not recommended for PopSystem.** Too lightweight for MIS requirements.

---

### Option 4: Apache OFBiz (Enterprise FOSS)

**Overview:**
- Open-source ERP framework (Java)
- Apache Foundation project
- Highly modular

**Pros:**
- Enterprise-grade
- Strong framework architecture
- Active Apache community

**Cons:**
- Complex setup and customization
- Java stack (integration overhead)
- Steep learning curve
- Heavy resource requirements

**Recommendation:** **Not recommended.** Too complex for PopSystem's needs.

---

### Option 5: License Existing Commercial MIS

**Approach:** Acquire or license an existing print MIS codebase and rebrand.

**Candidates:**
- Small/mid-market MIS vendors open to acquisition
- Legacy MIS with good bones but stagnant development
- Distressed assets (vendors exiting market)

**Pros:**
- Proven print-specific features
- Existing customer base (potential upsell)
- Skip 3-5 years of development
- Immediate credibility in print market

**Cons:**
- High acquisition cost ($1M-$10M+)
- Legacy code and technical debt
- Cultural integration (if acquiring company + team)
- Customer migration complexity

**Recommendation:** **Evaluate opportunistically.** If the right acquisition target emerges (distressed asset, good code, reasonable price), this could be faster than FOSS adaptation.

---

### FOSS Comparison Matrix

| Platform | Maturity | UI/UX | Manufacturing | Accounting | Community | Effort to Adapt |
|----------|----------|-------|---------------|------------|-----------|-----------------|
| **Odoo** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 12-18 months |
| **ERPNext** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | 12-18 months |
| **Dolibarr** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | 6-12 months |
| **OFBiz** | ⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 18-24 months |

**Recommended:** **Odoo** for full MIS, **Build Custom** for light v3 module.

---

## Effort Estimates & Resource Requirements

### v3: Light MIS Module (Subledger + QB Integration)

**Scope:** Job costing, basic inventory, simple scheduling, QuickBooks sync

**Team:**
- 2 Full-stack engineers
- 1 UX designer (part-time, 25%)
- 1 Accountant consultant (external, 10 hours/month)

**Timeline:** 6-9 months

**Effort Breakdown:**

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| **Design & Planning** | 1 month | Data model, UX wireframes, QB integration architecture |
| **Database Schema** | 2 weeks | Tables, indexes, migrations |
| **Job Costing Module** | 2 months | Job entity, cost lines, entry UI, reports |
| **Inventory Module** | 2 months | Items, transactions, stock tracking, alerts |
| **Production Scheduling** | 1 month | Calendar UI, equipment assignment |
| **QuickBooks Integration** | 2 months | OAuth, journal entry generator, mapping config, testing |
| **Testing & QA** | 1 month | Unit tests, integration tests, QB sandbox testing |
| **Documentation** | 2 weeks | User docs, API docs, support runbooks |
| **Beta & Launch** | 1 month | Beta customers, feedback, refinement, GA launch |

**Total Effort:** 6-9 months, 2 FTEs

**Cost Estimate:**
- Engineering: $300K (2 FTEs × $150K loaded cost × 9 months)
- Design: $20K
- Accounting consulting: $5K
- **Total: ~$325K**

---

### v4: Full MIS Module (POP-Optimized)

**Scope:** Estimating, advanced scheduling, purchasing, labor, multi-platform accounting, kit assembly

**Team:**
- 4 Full-stack engineers
- 1 UI/UX designer (full-time)
- 1 Product manager (full-time)
- 1 Accountant consultant (external, ongoing)
- 1 QA engineer

**Timeline:** 18-24 months

**Effort Breakdown:**

| Phase | Duration | Deliverables |
|-------|----------|--------------|
| **Architecture & Design** | 2 months | Technical design, UX design system, API contracts |
| **Core MIS Framework** | 4 months | Jobs, costing, scheduling engine, inventory (enhanced) |
| **Estimating & Quoting** | 3 months | Quote templates, pricing engine, approvals, conversions |
| **Purchasing Module** | 3 months | POs, vendor management, receiving, three-way match |
| **Labor Tracking** | 2 months | Time entry, cost allocation, productivity reports |
| **Advanced Scheduling** | 4 months | Constraint-based scheduler, Gantt UI, optimization |
| **Kit Assembly** | 2 months | BOM, picking, assembly labor, QA checkpoints |
| **Multi-Platform Accounting** | 4 months | Xero, Sage, QB Desktop connectors; testing |
| **Financial Reporting** | 2 months | Job P&L, equipment ROI, campaign profitability |
| **Testing & QA** | 3 months | Comprehensive testing, beta customers |
| **Documentation & Training** | 1 month | Docs, videos, support training |
| **Launch & Stabilization** | 2 months | GA launch, bug fixes, performance tuning |

**Total Effort:** 18-24 months, 7-8 FTEs

**Cost Estimate:**
- Engineering: $2.4M (4 engineers × $150K × 2 years)
- Design: $300K (1 designer × $150K × 2 years)
- PM: $300K
- QA: $250K
- Consulting: $50K
- **Total: ~$3.3M**

---

### v4+: Complete ERP (Enterprise)

**Scope:** Multi-plant, multi-currency, built-in GL, supply chain, advanced analytics

**Team:**
- 6-8 Full-stack engineers
- 2 UI/UX designers
- 2 Product managers
- 2 QA engineers
- 1 DevOps engineer
- Accounting/compliance consultants

**Timeline:** Ongoing (20+ months initial build, then continuous enhancement)

**Cost Estimate:**
- **Initial Build:** $5M-$7M (20 months)
- **Ongoing Enhancement:** $2M-$3M/year

**Note:** This is XL to XXL effort. Only pursue if v4 MIS module achieves significant market traction (50+ customers, $2M+ ARR from MIS features).

---

### Build vs. FOSS Adaptation Comparison

| Approach | Timeline | Cost | Risk | Control |
|----------|----------|------|------|---------|
| **Build v3 (Light MIS)** | 6-9 months | $325K | Low | Full control |
| **Build v4 (Full MIS)** | 18-24 months | $3.3M | Medium | Full control |
| **Adapt Odoo** | 12-18 months | $1.5M | Medium | Shared (FOSS dependency) |
| **Acquire MIS vendor** | 6-12 months | $2M-$10M | High | Full control (after integration) |

**Recommendation:**
- **v3:** Build custom (focused scope, manageable effort)
- **v4:** Evaluate Odoo adaptation vs. build (depends on v3 success)
- **v4+:** Consider acquisition if strategic opportunity arises

---

## Key Decisions Needed

Before proceeding with MIS/ERP development, the following strategic decisions must be made:

### Decision 1: Product Strategy

**Question:** Should PopSystem develop MIS features, or remain integration-focused?

**Options:**
- **A.** Integration-only (deep connectors, no native MIS)
- **B.** Light MIS module (v3 tier for small PSPs)
- **C.** Full MIS platform (compete with Pace/PrintVis)

**Decision Criteria:**
- Customer demand (how many PSPs need MIS vs. have it?)
- Competitive positioning (differentiation vs. feature parity)
- Development capacity (can we staff 4-8 engineers for 2+ years?)
- Strategic focus (are we a campaign platform or full ERP?)

**Stakeholders:** Leadership, Product, Engineering, Sales

**Timeline:** Decide by end of v1 pilot (validate market demand)

---

### Decision 2: Accounting Approach

**Question:** Subledger + integration OR built-in general ledger?

**Options:**
- **A.** Integration-first (QB/Xero connectors, no native GL)
- **B.** Hybrid (subledger detail + flexible GL integration)
- **C.** Built-in GL (full accounting platform)

**Decision Criteria:**
- Accounting expertise on team
- Customer preference (do PSPs want to keep existing accounting systems?)
- Development effort (GL = 2-3 years of work)
- Compliance burden (tax, audit, financial reporting)

**Recommendation:** **Option B (Hybrid)** for v3-v4. Defer built-in GL to v4+ only if market demands.

**Stakeholders:** Product, Engineering, Customer Advisory Board

**Timeline:** Decide before v3 design phase

---

### Decision 3: Build vs. FOSS vs. Acquire

**Question:** Build MIS from scratch, adapt FOSS, or acquire existing vendor?

**Options:**
- **A.** Build custom (full control, POP-optimized)
- **B.** Adapt Odoo/ERPNext (accelerate with FOSS)
- **C.** Acquire small MIS vendor (buy vs. build)

**Decision Criteria:**
- Time to market urgency
- Budget availability
- Engineering capacity
- Strategic IP ownership vs. speed

**Recommendation:**
- **v3:** Build custom (light module, focused scope)
- **v4:** Evaluate Odoo if v3 proves market demand
- **Acquisition:** Opportunistic (if right target emerges)

**Stakeholders:** Leadership, Finance, Engineering, M&A (if applicable)

**Timeline:** v3 decision: Now. v4 decision: 12 months post-v1 launch.

---

### Decision 4: Target Market Segmentation

**Question:** Which PSP segment should MIS features target?

**Options:**
- **A.** Small PSPs (<$2M revenue, no existing MIS)
- **B.** Mid-market PSPs ($2M-$10M, mixed MIS adoption)
- **C.** Enterprise PSPs (>$10M, have Pace/PrintVis)

**Decision Criteria:**
- Market size (how many PSPs in each segment?)
- Willingness to switch (switching costs vs. pain of current state)
- Pricing tolerance (what can each segment afford?)
- Sales complexity (SMB self-service vs. enterprise sales cycle)

**Recommendation:**
- **v3:** Target Small PSPs (greenfield, fastest adoption)
- **v4:** Expand to Mid-market (upsell + competitive displacement)
- **v4+:** Enterprise (full feature parity with Pace/PrintVis)

**Stakeholders:** Product, Sales, Marketing

**Timeline:** Decide before v3 launch (shapes positioning and pricing)

---

### Decision 5: Pricing & Packaging

**Question:** How should MIS features be priced and packaged?

**Options:**
- **A.** Tiered pricing (Starter, Pro, Enterprise)
- **B.** Standalone product (PopMIS separate from PopSystem)
- **C.** Hybrid (both available)

**Decision Criteria:**
- Customer buying patterns (bundled vs. à la carte)
- Sales motion (land-and-expand vs. all-in-one)
- Revenue optimization (maximize LTV)
- Competitive pricing (Pace is $50K/year, ShopVOX is $5K/year)

**Recommendation:**
- **v3:** Integrated tier (PopSystem Pro at $1,500/mo)
- **v4+:** Evaluate standalone if demand warrants

**Stakeholders:** Product, Sales, Finance, Pricing team

**Timeline:** Finalize before v3 beta launch

---

### Decision 6: Phasing & Investment

**Question:** What is the investment appetite and timeline for MIS development?

**Options:**
- **A.** No MIS (integration-only forever)
- **B.** Light MIS (v3 only, $325K investment)
- **C.** Full MIS (v3 + v4, $3.5M+ investment over 3 years)
- **D.** Acquisition (upfront $2M-$10M, faster time to market)

**Decision Criteria:**
- Available capital
- ROI expectations
- Strategic importance (core vs. adjacent)
- Competitive pressure

**Stakeholders:** Leadership, Finance, Board

**Timeline:** Decide as part of v2-v3 roadmap planning

---

## Appendices

### Appendix A: MIS Vendor Contact List

| Vendor | Website | Target Market | Pricing |
|--------|---------|---------------|---------|
| EFI Pace | efi.com/pace | Large commercial | $50K-$200K/year |
| PrintVis | printvis.com | Mid-large (Dynamics) | $30K-$150K/year |
| Tharstern | tharstern.com | Mid-market | $20K-$60K/year |
| ShopVOX | shopvox.com | Small shops | $2,400-$6,000/year |
| Cyrious | cyrious.com | Sign/wide-format | $10K-$40K/year |
| Avanti | avantisystems.com | Commercial print | $30K-$100K/year |
| Presto | presto.com | Commercial print | $20K-$80K/year |

---

### Appendix B: Accounting Platform APIs

**QuickBooks Online:**
- Docs: developer.intuit.com
- Auth: OAuth2
- Rate Limits: 500/min (app), 100/min (company)
- Sandbox: Available

**Xero:**
- Docs: developer.xero.com
- Auth: OAuth2
- Rate Limits: 60/min
- Sandbox: Available

**Sage Intacct:**
- Docs: developer.intacct.com
- Auth: Web Services (username/password)
- Rate Limits: Generous (100s of requests/min)
- Sandbox: Available (requires sales contact)

---

### Appendix C: POP-Specific MIS Requirements

**Unique to POP vs. Commercial Print:**

1. **Campaign-Driven Production**
   - Batch all stores in one campaign
   - Store-level addressing and personalization
   - Kit assembly (multi-SKU shipments)

2. **Store-Level Tracking**
   - Per-store fulfillment status
   - Per-store cost allocation (for brand reporting)
   - Store-specific reorders (not full campaign)

3. **Proof-of-Execution Integration**
   - Link job costs to verification status
   - Campaign completion = all stores installed AND verified
   - Retake costs (unplanned labor/materials)

4. **Seasonal Volume Spikes**
   - Holiday campaigns = 3-5× normal volume
   - Capacity planning for Q4 surge
   - Temporary labor tracking

5. **Reorder Economics**
   - Small quantities (1-10 stores)
   - Higher unit cost (no economies of scale)
   - Urgent turnaround (replacement for missing items)

6. **Brand Relationships**
   - Multi-brand cost allocation
   - Brand-level P&L (PSPs serve 10-50 brands)
   - Recurring campaign pricing (annual programs)

**These requirements are NOT well-served by generalist MIS platforms.** Opportunity for vertical specialization.

---

### Appendix D: Sample Integration Code

**QuickBooks Journal Entry Creation (Node.js)**

```javascript
const QuickBooks = require('node-quickbooks');

async function postJobCostToQB(jobCostData) {
  const qbo = new QuickBooks({
    consumerKey: process.env.QB_CLIENT_ID,
    consumerSecret: process.env.QB_CLIENT_SECRET,
    token: tenant.qbAccessToken,
    tokenSecret: tenant.qbRefreshToken,
    realmId: tenant.qbRealmId,
    useSandbox: false
  });

  const journalEntry = {
    Line: [
      {
        Description: `Job ${jobCostData.jobNumber} - Materials`,
        DetailType: 'JournalEntryLineDetail',
        Amount: jobCostData.materialCost,
        JournalEntryLineDetail: {
          PostingType: 'Debit',
          AccountRef: { value: '1200' } // WIP Asset
        }
      },
      {
        Description: `Job ${jobCostData.jobNumber} - Materials`,
        DetailType: 'JournalEntryLineDetail',
        Amount: jobCostData.materialCost,
        JournalEntryLineDetail: {
          PostingType: 'Credit',
          AccountRef: { value: '1100' } // Inventory Asset
        }
      }
    ]
  };

  try {
    const result = await qbo.createJournalEntry(journalEntry);

    // Update subledger with GL reference
    await db.jobCostTransaction.update({
      where: { id: jobCostData.transactionId },
      data: {
        posted: true,
        journalEntryRef: result.Id
      }
    });

    console.log(`Posted journal entry ${result.Id} to QuickBooks`);
    return result;

  } catch (error) {
    console.error('QB sync failed:', error);
    // Queue for retry
    await db.syncError.create({
      data: {
        transactionId: jobCostData.transactionId,
        errorMessage: error.message,
        retryCount: 0
      }
    });
  }
}
```

---

### Appendix E: Glossary

| Term | Definition |
|------|------------|
| **MIS** | Management Information System. Software for managing print production operations. |
| **ERP** | Enterprise Resource Planning. Comprehensive business management software (MIS + accounting + HR + CRM). |
| **GL** | General Ledger. Core accounting system tracking all financial transactions. |
| **Subledger** | Detailed operational ledger (e.g., job costs, inventory) that summarizes into GL. |
| **Journal Entry** | Accounting transaction recording debits and credits to GL accounts. |
| **Job Costing** | Tracking actual costs incurred for a production job. |
| **Chart of Accounts** | List of all GL accounts (assets, liabilities, revenue, expenses). |
| **A/R** | Accounts Receivable. Money owed by customers. |
| **A/P** | Accounts Payable. Money owed to vendors. |
| **COGS** | Cost of Goods Sold. Expense category for production costs. |
| **WIP** | Work in Process. Asset account for jobs in production (not yet completed). |
| **BOM** | Bill of Materials. List of components needed to produce a finished good. |
| **FIFO** | First In, First Out. Inventory costing method. |
| **LIFO** | Last In, First Out. Inventory costing method. |
| **Three-Way Match** | Comparing PO, receipt, and invoice to ensure accuracy before payment. |
| **GAAP** | Generally Accepted Accounting Principles. US accounting standards. |

---

**End of Document**

---

**Summary:**

This capability pillar document provides a comprehensive strategic analysis of MIS/ERP integration for PopSystem. The recommended approach is:

1. **v1-v2:** Integration-only (current approach)
2. **v3:** Light MIS module (job costing, inventory, QB sync) for small PSPs
3. **v4:** Full MIS platform (estimating, scheduling, multi-platform accounting) for mid-market
4. **v4+:** Enterprise ERP (multi-plant, multi-currency, advanced features) if market warrants

**Key Decision:** Choose between integration-only, integrated tier, or standalone product based on v1 customer feedback and market validation.

**Effort:** XL to XXL (6 months for v3 light module, 24+ months for full MIS, $3M+ investment)

**Strategic Importance:** High potential for differentiation (POP-native MIS), but requires significant investment and focus. Decision should be market-driven, not feature-driven.
