# NewPOPSys Evolution Roadmap

**Status:** Strategic Planning Document
**Purpose:** Define the path from v1 (PSP-led) to v3 (SaaS Network)

---

## Evolution Philosophy

Each phase must prove value before the next begins. No phase is guaranteed — progress depends on v1 success and market validation.

---

## Phase Overview

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│   v1 (Current)                                                      │
│   PSP-Led Campaign Orchestration                                    │
│   ─────────────────────────────                                     │
│   • Single PSP tenant model                                         │
│   • Core loop: Campaign → Fulfillment → Execution → Verification    │
│   • Mobile-first store experience                                   │
│   • 90-day retention with exports                                   │
│                                                                     │
│                           ↓                                         │
│                                                                     │
│   v1.x (Near-term)                                                  │
│   Multi-Tenant Expansion                                            │
│   ──────────────────────                                            │
│   • Additional PSP tenants onboarded                                │
│   • Per-tenant configuration options                                │
│   • Improved onboarding automation                                  │
│   • Performance optimization at scale                               │
│                                                                     │
│                           ↓                                         │
│                                                                     │
│   v2 (Medium-term)                                                  │
│   Brand-Led Configuration                                           │
│   ─────────────────────────                                         │
│   • Brands can configure without PSP involvement                    │
│   • Self-service campaign creation                                  │
│   • Advanced reporting and analytics                                │
│   • White-label theming options                                     │
│                                                                     │
│                           ↓                                         │
│                                                                     │
│   v3 (Long-term)                                                    │
│   Multi-PSP Network / SaaS Marketplace                              │
│   ────────────────────────────────────                              │
│   • Brands can work with multiple PSPs                              │
│   • Dynamic routing by region/capability                            │
│   • Unified visibility across PSP relationships                     │
│   • Network effects and marketplace dynamics                        │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## v1 → v1.x Transition

### Prerequisites
- [ ] v1 core loop validated with pilot brand
- [ ] PSP fulfillment workflow stable
- [ ] Store execution adoption > 80%
- [ ] No critical bugs in production

### v1.x Additions
| Feature | Purpose |
|---------|---------|
| Multi-tenant dashboard | Platform admin visibility across PSPs |
| Tenant onboarding automation | Reduce manual setup time |
| Per-tenant feature flags | Control rollout of new capabilities |
| Performance monitoring | Handle increased load |

### Not in v1.x
- Brand self-service (that's v2)
- Multi-PSP per brand (that's v3)
- Advanced analytics (that's v2)

---

## v1.x → v2 Transition

### Prerequisites
- [ ] 3+ PSPs successfully onboarded
- [ ] Tenant isolation validated
- [ ] Support processes scaled
- [ ] Revenue model validated

### v2 Additions
| Feature | Purpose |
|---------|---------|
| Brand admin portal | Self-service campaign creation |
| Advanced reporting | BI-lite capabilities in-platform |
| White-label theming | PSP branding customization |
| Custom exports | Brand-defined report formats |
| API rate limiting tiers | Differentiated service levels |

### Not in v2
- Multi-PSP routing (that's v3)
- Marketplace features (that's v3)
- AI-powered insights (that's v3)

---

## v2 → v3 Transition

### Prerequisites
- [ ] 10+ PSPs on platform
- [ ] Brand demand for multi-PSP validated
- [ ] Legal framework for data sharing established
- [ ] Governance model agreed

### v3 Additions
| Feature | Purpose |
|---------|---------|
| Multi-PSP brand accounts | Brands work with multiple PSPs |
| Capability routing | Match campaigns to PSP strengths |
| Unified brand dashboard | Single view across all PSP relationships |
| Network analytics | Cross-PSP insights (anonymized) |
| Marketplace dynamics | PSP discovery and ratings |

---

## Success Metrics by Phase

### v1 Success
| Metric | Target |
|--------|--------|
| Pilot brand adoption | 90%+ stores active |
| Campaign completion rate | 85%+ on-time |
| PSP fulfillment efficiency | 50%+ reduction in manual coordination |
| Store execution time | < 15 min average |

### v1.x Success
| Metric | Target |
|--------|--------|
| PSP onboarding time | < 1 week |
| Tenant isolation | Zero cross-tenant data exposure |
| Platform uptime | 99.5%+ |

### v2 Success
| Metric | Target |
|--------|--------|
| Brand self-service adoption | 70%+ campaigns created by brands |
| Support ticket reduction | 40%+ decrease |
| Report export usage | 80%+ of brands using |

### v3 Success
| Metric | Target |
|--------|--------|
| Multi-PSP brands | 20%+ of brands using multiple PSPs |
| PSP discovery | New PSPs gaining clients through platform |
| Network effects | Platform value increases with each participant |

---

## Architecture Decisions That Enable Evolution

These v1 decisions preserve optionality for future phases:

| Decision | Enables |
|----------|---------|
| Brands as first-class entities | v2 brand-led configuration |
| Strong tenant isolation | v1.x multi-tenant, v3 data boundaries |
| API-first design | v2 integrations, v3 marketplace |
| Event-driven architecture | v3 cross-PSP routing |
| Export pathways | v2 analytics, v3 data portability |
| Clean state machines | All phases — consistent behavior |

---

## Anti-Patterns to Avoid

| Pattern | Why It's Dangerous |
|---------|-------------------|
| Hard-coupling brand to PSP | Blocks v3 evolution |
| PSP-specific features in core | Creates maintenance burden |
| Skipping v1 validation | Later phases depend on v1 stability |
| Premature optimization for scale | Focus on correctness first |
| Silent scope creep | Each phase has defined boundaries |

---

## Decision Rights

| Phase | Who Decides |
|-------|-------------|
| v1 scope changes | Current stakeholders |
| v1.x initiation | v1 success metrics met |
| v2 scope | PSP advisory input |
| v3 scope | Full stakeholder governance |

---

*This roadmap is directional, not committal. Each phase must prove value before the next begins. v1 is the foundation — get it right first.*
