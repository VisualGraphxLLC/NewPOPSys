# NewPOPSys v1 — Master Direction

**Version:** 1.0 | **Date:** December 2025

---

## Strategic Intent

NewPOPSys v1 is a **focused rebuild** of the PrecisionPOP operational loop. The goal is not to reinvent the industry, but to:

1. **Modernize** the existing workflow with mobile-first execution
2. **Standardize** campaign orchestration across PSPs and brands
3. **Automate** the operational handoffs that currently require manual coordination
4. **Scaffold** for future evolution without expanding v1 scope

---

## Core Platform Loop

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   Campaign → Store Assignment → PSP Fulfillment → Store Execution       │
│                           ↓                                             │
│                    Verification → Visibility → Retention/Export         │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

Every feature request must be evaluated against this loop. If it doesn't serve the loop, it's out of scope for v1.

---

## Guiding Principles

### 1. PSP-Led Adoption
The PSP is the paying customer and operational owner. v1 optimizes for PSP efficiency and adoption, not broad configurability.

### 2. Execution Over Exploration
Store users complete tasks; they don't explore features. The store UX is deliberately constrained to drive completion speed.

### 3. Deterministic Operations
Orders are generated programmatically. Status transitions follow defined state machines. Overrides require explicit audit trails.

### 4. Data Discipline
- 90-day operational retention
- Export before deletion
- No silent accumulation of historical data

### 5. Protected Scope
Scope changes require explicit tradeoffs. "Nice to have" features are documented in Post_v1, not snuck into v1.

---

## Personas & Responsibilities

### PSP Level
| Persona | Core Responsibility |
|---------|---------------------|
| Platform Admin | System configuration, tenant management, support access |
| PSP Admin | Brand onboarding, PSP settings, user management |
| Production Operator | Order fulfillment, batch management, shipment tracking |

### Brand Level
| Persona | Core Responsibility |
|---------|---------------------|
| Brand Admin | Full brand configuration, all campaigns, store management |
| Campaign Manager | Build campaigns, define kits, review proofs |
| Regional Manager | Exception monitoring, compliance for assigned stores |

### Store Level
| Persona | Core Responsibility |
|---------|---------------------|
| Store Manager | Team management, approval workflows, store analytics |
| Store Operator | Task execution, proof capture, completion attestation |

---

## Architecture Direction

### Technology Choices
- **AWS-hosted** for pilot stability
- **PostgreSQL** as system of record
- **Next.js** for unified web experience
- **TypeScript** throughout for type safety
- **OpenTelemetry** for vendor-neutral observability

### Integration Strategy
- API-first design with OpenAPI contracts
- Webhook events for external system integration
- Export packages for data portability
- No hard coupling to specific downstream systems

### Scalability Approach
- Vertical scaling for pilot (managed services)
- Horizontal scaling patterns documented for post-pilot
- Queue-based async processing for heavy operations

---

## Delivery Approach

### AutoCoder Harness
v1 development uses AI-assisted code generation with human review:

| Phase | Human Role | AI Role |
|-------|------------|---------|
| Specification | Define requirements | Generate detailed specs |
| Architecture | Review decisions | Propose patterns |
| Implementation | Review & polish | Generate code |
| Testing | Validate behavior | Generate test cases |
| Documentation | Approve content | Generate docs |

### Quality Gates
1. All code reviewed by human architect
2. CI/CD pipeline with automated testing
3. Security review before production deployment
4. Performance testing at pilot scale

---

## What We're Not Building (v1)

These items are **protected scope boundaries**:

| Category | Explicitly Excluded |
|----------|---------------------|
| Financial | Job costing, invoicing, accounting integration |
| Marketplace | Installer bidding, vendor ratings, dynamic pricing |
| Analytics | Predictive dashboards, benchmarking, AI insights |
| Storage | Long-term archival, data warehouse, historical analytics |
| Customization | White-label theming, custom workflows, plugin architecture |

---

## Evolution Path (Without Expanding v1)

v1 is intentionally PSP-led. The architecture preserves optionality for future evolution:

1. **v1**: PSP-led campaign orchestration (current scope)
2. **v1.x**: Additional PSP and brand onboarding
3. **v2**: Brand-led configuration options
4. **v3**: Multi-PSP network / SaaS marketplace

Each phase builds on the previous without requiring v1 scope expansion.

---

## Decision Authority

| Decision Type | Authority |
|---------------|-----------|
| Scope changes | Requires stakeholder approval + documented tradeoff |
| Technology choices | Tech Lead with stakeholder awareness |
| UX patterns | Follow established SOW wireframes |
| Timeline changes | Requires impact assessment |

---

## Document Hierarchy

```
Master SOW (authoritative)
    ↓
SUPP Documents (detailed specifications)
    ↓
Decision Log (changes and rationale)
    ↓
Backlog/Tickets (implementation tasks)
```

When in doubt, defer to the higher-level document.

---

*This document establishes strategic direction. For implementation details, see the [Master SOW](../SOW/01_Main_SOW/MASTER_SOW_COMPILED.md) and individual SUPP specifications.*
