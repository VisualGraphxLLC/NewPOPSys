# v3 Stakeholder Planning — Multi-Company Considerations

**Status:** Post-v1 Planning Document
**Purpose:** Capture multi-company governance questions for future SaaS evolution

---

## Context

When NewPOPSys evolves to support multiple PSPs (v3 SaaS model), complex stakeholder dynamics emerge. This document captures the key questions that must be resolved before that evolution.

**Important:** This is NOT v1 scope. These considerations are documented to inform v1 architecture decisions that preserve optionality.

---

## Stakeholder Landscape (Future State)

```
┌─────────────────────────────────────────────────────────────────────┐
│                     PLATFORM OWNERSHIP                              │
│                    (NewPOPSys IP)                                   │
│                          │                                          │
│    ┌────────────────────┼────────────────────┐                     │
│    │                    │                    │                      │
│    ▼                    ▼                    ▼                      │
│ ┌──────────┐      ┌──────────┐        ┌──────────┐                 │
│ │ Founding │      │ Future   │        │ Future   │                 │
│ │ PSP      │      │ PSP #2   │        │ PSP #3   │                 │
│ └────┬─────┘      └──────────┘        └──────────┘                 │
│      │                                                              │
│      ├── Brand Client A                                            │
│      ├── Brand Client B                                            │
│      └── Brand Client C                                            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Key Questions (To Be Resolved Pre-v3)

### 1. Competitive Intelligence

**Scenario:** Two competing PSPs use the same platform. Can they see each other's client lists, pricing, or performance?

| Stakeholder | Concern |
|-------------|---------|
| Founding PSP | "We built this. We don't want competitors seeing our client relationships." |
| Future PSP | "We need assurance our data is completely isolated." |
| Platform Owner | "We need aggregate data to improve the platform." |

**v1 Architecture Implication:** Build strong tenant isolation from day one.

---

### 2. Feature Development Priority

**Scenario:** Founding PSP wants Feature A, Future PSP wants Feature B. Limited dev resources.

| Stakeholder | Position |
|-------------|----------|
| Founding PSP | "We're the founding customer. Our needs should come first." |
| Future PSP | "We're paying the same. Equal treatment." |
| Platform Owner | "We need to balance individual needs with platform direction." |

**v1 Architecture Implication:** Build modular features that can be prioritized independently.

---

### 3. Brand Client Portability

**Scenario:** A brand decides to switch from PSP A to PSP B while staying on the platform.

| Stakeholder | Position |
|-------------|----------|
| PSP A | "That's our client relationship. Historical data should stay with us." |
| PSP B | "The client should bring their history for continuity." |
| Brand | "It's our data. We should control it." |
| Platform | "We need clear policies before this happens." |

**v1 Architecture Implication:** Treat brands as first-class entities; don't hard-couple to single PSP.

---

### 4. Data Ownership Matrix

| Data Type | Created By | Owned By (Decision Needed) |
|-----------|------------|---------------------------|
| Platform code/features | Platform | Platform |
| PSP account config | Platform | PSP |
| PSP branding assets | PSP | PSP |
| Brand client records | PSP | ? ? ? |
| Store profile data | Brand/Store | ? ? ? |
| Kit definitions | PSP | PSP |
| Campaign assignments | PSP | ? ? ? |
| Activity logs | System | ? ? ? |
| Aggregate analytics | Platform | Platform |

**v1 Architecture Implication:** Design data models with ownership clarity from the start.

---

## Governance Model Options (Future)

### Option A: Platform-Centric
- Platform owner makes all decisions
- PSPs are "tenants" with limited input
- Standardized feature set for all
- *Best for: SaaS model with many small PSPs*

### Option B: Consortium
- Steering committee with PSP representatives
- Voting rights based on usage/investment
- Shared development costs
- *Best for: Smaller number of larger PSPs*

### Option C: Hybrid (Recommended)
- Platform owner controls core features
- PSPs can fund custom modules
- Marketplace for optional add-ons
- Advisory board for major decisions
- *Best for: Balancing platform integrity with PSP autonomy*

---

## Legal Considerations (Pre-v3 Checklist)

| Requirement | Status |
|-------------|--------|
| Master Service Agreement template | Not started |
| Data Processing Agreement (GDPR) | Not started |
| Acceptable Use Policy | Not started |
| Privacy Policy update | Needed (current is outdated) |
| PSP → Brand agreement template | Not started |
| Liability and indemnification framework | Not started |

---

## Why This Matters for v1

Even though v1 is single-PSP, architecture decisions made now affect future evolution:

1. **Tenant isolation** — Build it properly from day one
2. **Brand as first-class entity** — Don't hard-couple to PSP
3. **Clean data boundaries** — Know who owns what
4. **Export pathways** — Enable data portability
5. **API stability** — Contracts that can survive evolution

---

## Next Steps (Post-v1)

1. Complete v1 and validate core loop
2. Onboard 2-3 additional PSPs to test multi-tenant
3. Conduct stakeholder workshop on governance
4. Legal review of data ownership framework
5. Technical design for v3 multi-PSP routing

---

*This document is derived from strategic planning sessions. It is explicitly NOT v1 scope and should not be used to justify v1 feature requests.*
