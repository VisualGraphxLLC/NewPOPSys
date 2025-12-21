# Build vs Buy Matrix

## Executive Summary

This document analyzes make/partner/acquire decisions for each capability pillar of PopSystem. Strategic sourcing decisions can reduce development time by 25-40% and accelerate time-to-market by 6-12 months.

**Key Recommendations**:
- **Build**: Core SaaS platform, Workflow engine, MIS (long-term)
- **Partner**: AI services, Designer SDK, LMS, Payment processing
- **Acquire**: Consider small MIS company for instant market entry
- **Hybrid**: DAM (build core, partner for CDN), Marketplace (build platform, leverage Stripe Connect)

---

## Decision Framework

### Evaluation Criteria

| Criterion | Weight | Description |
|-----------|--------|-------------|
| **Strategic Differentiation** | 30% | Is this a core competitive advantage? |
| **Speed to Market** | 25% | How quickly can we launch? |
| **Total Cost of Ownership** | 20% | 3-year cost (dev + licenses + maintenance) |
| **Control & Customization** | 15% | Can we tailor to our needs? |
| **Integration Complexity** | 10% | How hard to integrate with our platform? |

### Decision Matrix

| Score | Recommendation | Rationale |
|-------|----------------|-----------|
| 80-100 | **Build** | Core differentiation, full control needed |
| 60-79 | **Hybrid** | Build core, partner for commoditized parts |
| 40-59 | **Partner** | Standard solution, focus resources elsewhere |
| 20-39 | **Buy/Acquire** | Time-critical, complex domain, proven solution |

---

## Pillar-by-Pillar Analysis

### 1. Digital Asset Management (DAM)

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Core** | In-house | Full control, customization | Longer time to market | $450K |
| **Partner - Storage** | Cloudinary | CDN, transformations, API | Vendor lock-in, cost at scale | $180K |
| **Partner - Search** | Algolia | Best-in-class search, UI kits | Pricing at scale | $90K |
| **Acquire** | Canto/Bynder | Complete solution, proven | High cost, integration work | $600K+ |

#### Recommendation: **HYBRID BUILD**

**Approach**:
- **Build**: Asset metadata schema, collections, permissions, UI
- **Partner**: Cloudinary for storage/CDN, Algolia for search
- **Timeline**: 3-4 months (vs 6+ months full build)
- **Cost**: $270K over 3 years (Cloudinary + Algolia)

**Justification**:
- Asset organization is a differentiator (print-specific metadata)
- Storage/CDN is commoditized (Cloudinary best-in-class)
- Search is complex to build (Algolia reduces 2+ months effort)
- Avoids vendor lock-in for core data model

**Integration Complexity**: Medium
- Cloudinary SDK for uploads/transformations
- Algolia API for search indexing
- Both have React components

**Control**: High on metadata, Medium on delivery
- Own the data schema and relationships
- Cloudinary handles delivery optimization

---

### 2. AI - Image Generation & Manipulation

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build ML Models** | In-house | Full control, no API costs | Requires ML team, GPU infra | $800K+ |
| **Partner - APIs** | OpenAI DALL-E, Stability AI | State-of-art, no ML expertise | API costs, rate limits | $120K |
| **Partner - SDK** | Adobe Firefly, Canva | Commercial-safe, integrated | License costs, less flexible | $240K |
| **Partner - OSS** | Stable Diffusion (hosted) | Lower cost, customizable | Model management, quality | $80K |

#### Recommendation: **PARTNER (API + SDK)**

**Approach**:
- **v3**: Remove.bg for background removal, Cloudinary for basic transforms
- **v4**: OpenAI DALL-E for generation, Adobe Firefly for commercial use
- **Timeline**: 2 months integration (vs 8+ months building ML)
- **Cost**: $150K over 3 years (mixed API usage)

**Justification**:
- Image AI is not a core differentiator (availability is)
- Rapid innovation in AI space (hard to keep up in-house)
- API costs are variable (scale with usage)
- Focus dev resources on print-specific features

**Integration Complexity**: Low-Medium
- REST APIs with SDKs
- Async job processing for generation
- Image gallery UI (build custom)

**Control**: Low on models, High on UX
- No control over model quality/bias
- Full control over prompt engineering and UI

**Recommendation**: Start with APIs, evaluate OSS hosting if costs exceed $5K/month.

---

### 3. Designer Tool

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Full control, print-optimized | Long dev time, complex | $900K |
| **Partner - Embed** | Canva SDK | Proven UX, fast to market | License cost, limited control | $360K |
| **Partner - OSS** | Polotno (open-source) | Customizable, lower cost | Less polished, support | $180K |
| **Hybrid** | Polotno + Custom | Balance cost and control | Integration complexity | $450K |

#### Recommendation: **HYBRID (Polotno + Custom Extensions)**

**Approach**:
- **v2**: Embed Polotno for template preview and basic edits
- **v3**: Extend Polotno with custom print features (bleed, CMYK, crop marks)
- **v4**: Build variable data engine on top for mail merge
- **Timeline**: 1 month (v2), 3 months (v3), 6 months (v4)
- **Cost**: $180K licensing + $270K custom dev = $450K

**Justification**:
- Polotno is print-friendly (vs Canva's web focus)
- Open-source allows deep customization
- Community support and plugins available
- Avoids $900K+ custom build

**Alternative**: Canva SDK if targeting mainstream users
- **Pros**: Best-in-class UX, handles all edge cases
- **Cons**: $360K cost, less print-specific features
- **Decision point**: User testing in v2 (which UX resonates?)

**Integration Complexity**: Medium
- React component integration
- Custom toolbar and panels
- Print-ready export pipeline (PDF, CMYK conversion)

**Control**: Medium-High
- Source code access (Polotno)
- Can fork and extend
- Build custom rendering engine for variable data

---

### 4. Learning Management System (LMS)

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Full control, tight integration | Not core value, long dev | $450K |
| **Partner - SaaS** | Skilljar, Docebo | Enterprise-ready, proven | High cost, integration effort | $180K |
| **Partner - OSS** | Moodle, Open edX | Free, customizable | Complex setup, maintenance | $120K |
| **Embed** | Thinkific, Teachable | Fast setup, affordable | Limited branding, separate login | $60K |

#### Recommendation: **PARTNER (Skilljar or Embed Thinkific)**

**Approach**:
- **v2**: Embed Thinkific for MVP ($20K/year)
- **v3**: Migrate to Skilljar if enterprise customers need white-label ($60K/year)
- **Timeline**: 2-3 weeks integration (vs 3 months build)
- **Cost**: $60K (Thinkific) or $180K (Skilljar) over 3 years

**Justification**:
- LMS is not a differentiator (table stakes feature)
- Skilljar specializes in customer training (our use case)
- Building LMS diverts resources from core platform
- Easy to migrate later if needed (SCORM exports)

**Integration Complexity**: Low
- SSO via SAML/OAuth
- Embed iframe or redirect to subdomain
- API for progress tracking in main app

**Control**: Low-Medium
- Limited UI customization (Thinkific)
- Better white-label with Skilljar
- No control over feature roadmap

**Alternative**: Build if Academy becomes a revenue driver
- Wait for customer validation (v3)
- Build in v4 if LMS becomes core to business model

---

### 5. MIS/ERP System

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Perfect fit, competitive edge | Long dev, domain complexity | $1.2M |
| **Partner - Integrate** | PrintVis, Avanti | Proven print MIS, feature-rich | Expensive, hard to integrate | $300K |
| **Acquire** | Small MIS company | Instant product, customer base | Integration work, tech debt | $500K-2M |
| **Hybrid** | Build core + Partner billing | Control workflow, leverage GL | Still significant build | $600K |

#### Recommendation: **BUILD LONG-TERM, EVALUATE ACQUISITION**

**Approach**:
- **v2**: Skip MIS, focus on DAM and Designer
- **v3**: Build job ticketing and estimating (4 months)
- **v4**: Add production scheduling and financials (6 months)
- **Parallel**: Explore acquiring a small MIS company (< 100 customers)
- **Timeline**: 10 months build OR 6 months acquisition integration
- **Cost**: $600K build OR $500K-2M acquisition

**Justification**:
- MIS is a major differentiator (integrated vs bolt-on)
- Existing MIS products are hard to white-label
- Print industry expertise is critical (build or acquire)
- Acquisition could accelerate by 12+ months

**Acquisition Criteria**:
- Modern tech stack (not legacy .NET/Java)
- < 100 customers (manageable migration)
- Strong estimating and job ticketing
- Weak on design/DAM (where PopSystem excels)
- **Target**: $500K-1.5M purchase price

**Integration Complexity**: High
- Data migration from acquired system
- UI/UX redesign to match PopSystem
- API integration with DAM, Designer, Workflow
- Customer migration and support

**Control**: Full
- Own the product and roadmap
- Can sunset legacy features
- Deep customization for print workflows

**Decision Timeline**: Evaluate acquisition targets in v2 (6 months due diligence), decide by v3 planning.

---

### 6. Workflow & Process Automation

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Tight integration, full control | Complex state management | $540K |
| **Partner - Platform** | Temporal, Camunda | Robust workflow engine | Learning curve, overhead | $150K |
| **Partner - No-Code** | Zapier, Make | Fast setup, 5000+ integrations | Limited control, cost at scale | $180K |
| **Hybrid** | Custom engine + Zapier | Core workflows in-app, external via Zapier | Dual systems to maintain | $450K |

#### Recommendation: **HYBRID BUILD**

**Approach**:
- **Build**: Core workflow engine for job/approval workflows
- **Partner**: Zapier/Make for external integrations (CRM, email, Slack)
- **Consider**: Temporal for complex orchestration (if needed in v4)
- **Timeline**: 1 month (v2 basic), 3 months (v3 advanced)
- **Cost**: $300K build + $150K Zapier = $450K

**Justification**:
- Workflow is a differentiator (print-specific processes)
- External integrations are commoditized (Zapier excels)
- Building all integrations in-house is inefficient
- Temporal adds complexity (only if needed for long-running jobs)

**Integration Complexity**: Medium
- Build workflow engine with state machine
- Zapier webhooks for triggers and actions
- Temporal SDK if adopting (Go/Java/Python)

**Control**: High on core, Low on external
- Full control over job workflows
- Zapier handles 3rd-party API changes

**When to adopt Temporal**:
- If workflows span days/weeks (long-running)
- If need for complex retry logic and error handling
- If orchestrating microservices (v4+)

---

### 7. Mobile Experience

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **PWA Only** | In-house | Single codebase, web tech | Limited native features | $150K |
| **React Native** | In-house | Shared code, native feel | Bridge maintenance, debugging | $450K |
| **Native iOS + Android** | In-house | Best performance, UX | Dual codebases, slow dev | $900K |
| **Partner - Framework** | Flutter, Ionic | Cross-platform, fast dev | Learning curve (Flutter) | $400K |

#### Recommendation: **PWA (v2) + React Native (v3+)**

**Approach**:
- **v2**: Responsive PWA with offline support
- **v3**: React Native app for iOS/Android
- **v4**: Native features (AR, camera) via RN modules
- **Timeline**: 2 months PWA, 3 months RN
- **Cost**: $150K + $300K = $450K

**Justification**:
- PWA validates mobile demand with low investment
- React Native reuses React components (70% code sharing)
- Native apps unlock push notifications, AR, offline-first
- Flutter learning curve not justified (team knows React)

**Integration Complexity**: Low-Medium
- PWA: Same codebase as web (mobile-first CSS)
- React Native: Expo for rapid prototyping, eject for native modules

**Control**: Full
- Own the mobile experience
- No platform lock-in (can migrate to native later)

**Alternative**: Skip native if PWA adoption is high
- Monitor PWA usage in v2
- Build native only if customers demand app store presence

---

### 8. White-Label & Reseller Platform

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Full control, tight integration | Dev effort, domain setup | $420K |
| **Partner - Multi-tenant** | Frontegg, WorkOS | Pre-built admin, SSO | Cost per tenant, less flexible | $240K |
| **Hybrid** | Custom theme + WorkOS SSO | Balance cost and control | Integration complexity | $300K |

#### Recommendation: **BUILD (extends SaaS pillar)**

**Approach**:
- **v2**: Basic theming (logo, colors, CSS)
- **v3**: Custom domains + SSO (WorkOS for enterprise SSO)
- **v4**: Plugin marketplace, full white-label
- **Timeline**: 3 weeks (v2), 2 months (v3), 3 months (v4)
- **Cost**: $240K build + $60K WorkOS = $300K

**Justification**:
- White-label is core to reseller revenue model
- Extends SaaS multi-tenancy (already building)
- WorkOS simplifies enterprise SSO (vs building SAML/OAuth)
- Custom domains are straightforward (Cloudflare/Let's Encrypt)

**Integration Complexity**: Low-Medium
- Theme engine with CSS variables
- WorkOS SDK for SSO providers
- DNS automation for custom domains

**Control**: High
- Full control over theming system
- WorkOS handles SSO complexity
- Own the reseller business logic

---

### 9. Marketplace

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Full control, print-specific | Complex, two-sided market | $900K |
| **Partner - Platform** | Sharetribe, Arcadier | Marketplace-in-a-box | Generic, limited customization | $180K |
| **Partner - Payments** | Stripe Connect | Payment splits, onboarding | Still need to build marketplace | $90K |
| **Hybrid** | Custom + Stripe Connect | Best of both worlds | Build effort, Stripe fees | $600K |

#### Recommendation: **HYBRID (Custom + Stripe Connect)**

**Approach**:
- **v4**: Build marketplace platform (seller profiles, listings, search)
- **Partner**: Stripe Connect for payments and payouts
- **Timeline**: 7 months (marketplace) + 2 weeks (Stripe)
- **Cost**: $510K build + $90K Stripe fees = $600K

**Justification**:
- Marketplace UX is a differentiator (print templates/plugins)
- Payment splits are complex (Stripe Connect handles this)
- Sharetribe too generic (not print-focused)
- Need custom review/rating for print quality

**Integration Complexity**: Medium
- Stripe Connect for seller onboarding
- Webhook handling for payouts
- Custom search/discovery UI

**Control**: High on UX, Medium on payments
- Own the seller and buyer experience
- Stripe handles compliance and fraud
- Full control over commission structure

**Recommendation**: Start with curated templates (v3), open to sellers in v4 after proving demand.

---

### 10. Payment Processing

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build Custom** | In-house | Full control, no fees | PCI compliance, fraud risk | $600K+ |
| **Partner - Stripe** | Stripe | Best-in-class, global, Connect | 2.9% + 30¢ fees | $200K |
| **Partner - PayPal** | PayPal/Braintree | Familiar, buyer trust | Holds/disputes, UX | $220K |
| **Partner - Adyen** | Adyen | Enterprise, lower fees | Complex setup, minimums | $150K |

#### Recommendation: **PARTNER (Stripe)**

**Approach**:
- **v2**: Stripe Checkout for subscriptions
- **v3**: Stripe Connect for marketplace
- **v4**: Stripe Billing for usage-based pricing
- **Timeline**: 1 week per integration
- **Cost**: ~$200K in fees over 3 years (assumes $7M GMV)

**Justification**:
- Never build payments (PCI compliance nightmare)
- Stripe is best-in-class for SaaS and marketplaces
- Excellent developer experience and docs
- Connect handles multi-party payouts

**Integration Complexity**: Low
- Well-documented APIs and React libraries
- Webhooks for event handling
- Stripe Dashboard for support

**Control**: Low-Medium
- No control over fees or features
- Stripe sets compliance rules
- Good API coverage for customization

**No viable alternative**: Always partner for payments.

---

### 11. AI - Data & Content Intelligence

| Option | Provider | Pros | Cons | 3-Yr TCO |
|--------|----------|------|------|----------|
| **Build ML Models** | In-house | Custom for print industry | Requires ML team, data | $900K |
| **Partner - LLMs** | OpenAI GPT, Anthropic Claude | Best-in-class NLP, no ML team | API costs, rate limits | $180K |
| **Partner - OSS** | Hugging Face models (hosted) | Lower cost, customizable | Model management, quality | $120K |
| **Hybrid** | LLM APIs + Fine-tune OSS | Use APIs, fine-tune for print | Complexity, dual systems | $300K |

#### Recommendation: **PARTNER (OpenAI/Anthropic APIs)**

**Approach**:
- **v2**: GPT-4 for product data enrichment
- **v3**: Claude for classification and categorization
- **v4**: Fine-tuned models for print-specific tasks (if needed)
- **Timeline**: 3 weeks (v2), 2 months (v3), 3 months (v4)
- **Cost**: $180K in API usage over 3 years

**Justification**:
- LLMs are commoditizing fast (hard to compete)
- Print-specific knowledge can be added via prompts
- API costs scale with usage (variable cost)
- Focus ML resources on print-specific CV (if needed)

**Integration Complexity**: Low
- REST APIs with rate limiting
- Async job processing for batch tasks
- Prompt engineering and testing

**Control**: Low on models, High on prompts
- No control over model updates
- Full control over prompt engineering
- Can switch providers (multi-model strategy)

**When to build custom**:
- If API costs exceed $10K/month
- If need for proprietary print industry models
- If data privacy requires on-prem (Europe)

---

## Cost Comparison Summary

### 3-Year Total Cost of Ownership (TCO)

| Pillar | Build Only | Partner Only | Hybrid (Recommended) | Savings |
|--------|------------|--------------|----------------------|---------|
| DAM | $600K | $600K (acquire) | $270K | 55% |
| AI - Image | $800K | $240K | $150K | 81% |
| Designer | $900K | $360K | $450K | 50% |
| LMS | $450K | $180K | $60K (Thinkific) | 87% |
| MIS/ERP | $1.2M | $300K (integrate) | $600K (build) | 0-50% |
| Workflow | $540K | $330K | $450K | 17% |
| Mobile | $900K (native) | $400K (Flutter) | $450K (PWA+RN) | 50% |
| White-Label | $420K | $240K | $300K | 29% |
| Marketplace | $900K | $180K (Sharetribe) | $600K | 33% |
| Payments | $600K+ | $200K | $200K (Stripe) | 67% |
| AI - Data | $900K | $180K | $180K | 80% |
| **TOTAL** | **$8.3M** | **$3.2M** | **$3.7M** | **55%** |

**Key Insight**: Hybrid approach saves $4.6M (55%) over building everything in-house, while maintaining control over differentiators.

---

## Integration Complexity Assessment

### Complexity Matrix

| Integration | Complexity | Timeline | Key Challenges |
|-------------|------------|----------|----------------|
| Cloudinary (DAM) | Low | 1 week | SDK integration, webhook handling |
| Algolia (Search) | Low | 1 week | Index syncing, UI components |
| Stripe (Payments) | Low | 1 week | Webhook security, PCI compliance |
| Stripe Connect (Marketplace) | Medium | 2 weeks | Seller onboarding flow, payouts |
| OpenAI/Claude (AI) | Low | 1 week | Rate limiting, cost management |
| Polotno (Designer) | Medium | 2 weeks | React integration, custom panels |
| Canva SDK (Designer) | Medium | 2 weeks | Embed authentication, callback handling |
| Skilljar (LMS) | Low | 1 week | SSO setup, progress API |
| Thinkific (LMS) | Low | 3 days | Iframe embed, webhook for completion |
| WorkOS (SSO) | Medium | 2 weeks | SAML/OAuth providers, directory sync |
| Zapier (Workflow) | Low | 1 week | Webhook triggers, action endpoints |
| Temporal (Workflow) | High | 4 weeks | Learning curve, worker setup |

**Total Integration Effort**: 15-20 weeks across all partners (vs 100+ weeks building all in-house)

---

## Control & Customization Matrix

### What You Control vs Partner Controls

| Pillar | Data | Business Logic | UX | Pricing | Roadmap |
|--------|------|----------------|-----|---------|---------|
| DAM (Hybrid) | Own | Own | Own | Own | Own |
| AI - Image (Partner) | Partner | Partner | Own | Partner | Partner |
| Designer (Polotno) | Own | Shared | Own | Own | Shared |
| Designer (Canva) | Partner | Partner | Partner | Partner | Partner |
| LMS (Skilljar) | Shared | Partner | Shared | Partner | Partner |
| MIS (Build) | Own | Own | Own | Own | Own |
| Workflow (Hybrid) | Own | Own | Own | Own | Own |
| Mobile (RN) | Own | Own | Own | Own | Own |
| Marketplace (Hybrid) | Own | Own | Own | Shared | Own |
| Payments (Stripe) | Shared | Partner | Shared | Partner | Partner |
| AI - Data (Partner) | Partner | Partner | Own | Partner | Partner |

**Legend**:
- **Own**: Full control
- **Shared**: Co-owned (API access to customize)
- **Partner**: Controlled by vendor

**Critical Insight**: Maintain ownership of data and UX for differentiation, leverage partners for commoditized backend services.

---

## Speed to Market Comparison

### Time to MVP by Approach

| Pillar | Build Only | Partner Only | Hybrid | Fastest |
|--------|------------|--------------|--------|---------|
| DAM | 6 months | 3 months (acquire) | 3 months | Hybrid |
| AI - Image | 8 months | 2 weeks | 2 months | Partner |
| Designer | 12 months | 1 month | 4 months | Partner |
| LMS | 3 months | 2 weeks | 2 weeks | Partner |
| MIS/ERP | 10 months | 2 months (integrate) | 10 months | Partner |
| Workflow | 7 months | 1 month | 4 months | Partner |
| Mobile | 9 months | 4 months | 5 months | Hybrid |
| White-Label | 7 months | 1 month | 4 months | Partner |
| Marketplace | 9 months | 1 month | 7 months | Partner |
| Payments | N/A (don't build) | 1 week | 1 week | Partner |
| AI - Data | 8 months | 3 weeks | 3 weeks | Partner |

**Average acceleration**: Hybrid approach is 50-60% faster than building everything.

---

## Risk Analysis

### Vendor Lock-In Risk

| Partner | Lock-In Risk | Mitigation Strategy |
|---------|-------------|---------------------|
| **Cloudinary** | Medium | Own metadata, export assets, use S3 as backup |
| **Stripe** | Low | Standard payment data exports, easy to migrate |
| **OpenAI/Claude** | Low | Multi-model strategy, abstract API layer |
| **Polotno** | Low | Open-source, can fork if needed |
| **Canva SDK** | High | Proprietary, hard to migrate designs out |
| **Skilljar** | Medium | SCORM exports, can migrate to Moodle/edX |
| **Algolia** | Medium | Own search data, can migrate to ElasticSearch |
| **WorkOS** | Low | Standard SSO protocols, easy to replace |
| **Temporal** | Medium | Open-source, can self-host if needed |

**Mitigation Best Practices**:
1. **Own your data**: Always maintain source data in your database
2. **Abstract integrations**: Use adapter pattern for easy swapping
3. **Export capabilities**: Ensure partners provide data export
4. **Multi-vendor strategy**: Use multiple providers for critical services (AI models)

### Partner Failure Risk

| Partner | Failure Risk | Backup Plan |
|---------|-------------|-------------|
| Cloudinary | Low (well-funded, profitable) | Migrate to Imgix or Cloudflare Images |
| Stripe | Very Low (public, dominant) | PayPal/Braintree (complex migration) |
| OpenAI/Claude | Medium (consolidation risk) | Multi-model abstraction layer |
| Polotno | Medium (OSS project) | Fork repo, self-maintain |
| Canva | Low (unicorn, profitable) | Rebuild with Polotno (painful) |
| Skilljar | Medium (private company) | Migrate to Docebo or build |
| Algolia | Low (well-funded) | ElasticSearch or Typesense |

**Insurance**: Maintain abstraction layers and export data quarterly.

---

## Decision Recommendations by Phase

### v2 (Months 1-6)

| Pillar | Decision | Rationale |
|--------|----------|-----------|
| DAM | Hybrid (Cloudinary + Algolia) | Fast to market, proven tech |
| Designer | Partner (Polotno) | Validate demand before big build |
| LMS | Partner (Thinkific embed) | Non-critical, cheap to test |
| Mobile | Build (PWA) | Reuse web code, low cost |
| Payments | Partner (Stripe) | No-brainer, never build |
| AI - Data | Partner (GPT-4 API) | Fast, flexible, low commitment |
| Workflow | Build (basic) | Core differentiator, simple v1 |
| White-Label | Build (basic) | Extends SaaS work, critical |

**v2 Total Partner Cost**: ~$60K/year (~$180K over 3 years)

### v3 (Months 7-15)

| Pillar | Decision | Rationale |
|--------|----------|-----------|
| AI - Image | Partner (APIs) | Not a differentiator, fast |
| Designer | Hybrid (extend Polotno) | Add print features, still leverage SDK |
| MIS | **DECISION POINT** | Acquire vs Build based on v2 learnings |
| Mobile | Build (React Native) | Demand validated, need native features |
| Marketplace | Build (Stripe Connect) | Prep for v4, core revenue driver |
| LMS | Upgrade (Skilljar if needed) | If enterprise demand, otherwise keep Thinkific |

**v3 Decision**: MIS acquisition vs build (critical 6-month evaluation)

### v4 (Months 16-24)

| Pillar | Decision | Rationale |
|--------|----------|-----------|
| MIS | Build/Acquired | Fully integrated system |
| Marketplace | Launch (Custom + Stripe) | Core revenue, fully built |
| Designer | Extend (Variable data) | Advanced features on top of Polotno |
| Workflow | Consider Temporal | If complex orchestration needed |

---

## Financial Model: Build vs Hybrid

### 3-Year Cost Breakdown

#### Build-Only Approach
| Category | Cost |
|----------|------|
| Development (100 months × $120K/year) | $6.0M |
| Infrastructure (hosting, DB) | $300K |
| Maintenance (20% per year) | $1.2M |
| QA/DevOps (30% overhead) | $1.8M |
| **Total** | **$9.3M** |

#### Hybrid Approach (Recommended)
| Category | Cost |
|----------|------|
| Development (55 months × $120K/year) | $3.3M |
| Partner Licenses (see TCO table) | $600K |
| Infrastructure (reduced) | $180K |
| Maintenance (15% per year) | $600K |
| Integration/QA (25% overhead) | $900K |
| **Total** | **$5.6M** |

**Savings**: $3.7M (40%) over 3 years

### ROI on Partnering

| Partner | Annual Cost | Build Cost (avoided) | ROI |
|---------|------------|---------------------|-----|
| Stripe | $70K | $200K | 186% |
| Cloudinary + Algolia | $90K | $200K | 122% |
| LMS (Thinkific) | $20K | $150K | 650% |
| AI APIs (OpenAI/Claude) | $60K | $300K | 400% |
| Polotno | $10K | $300K | 2900% |

**Blended ROI**: 200%+ on partner investments (vs building in-house)

---

## Action Plan

### Immediate Decisions (Next 30 Days)

1. **Finalize Designer approach**:
   - Run 2-week POC with Polotno and Canva SDK
   - User test with 10 beta customers
   - Decision: Polotno (customization) vs Canva (UX)

2. **LMS selection**:
   - Trial Thinkific and Skilljar (2 weeks each)
   - Evaluate integration complexity
   - Decision: Start with Thinkific, upgrade later if needed

3. **MIS strategy**:
   - Hire M&A advisor to identify acquisition targets
   - Interview 5 print MIS vendors for partnership
   - Build vs acquire decision by end of v2 (Month 6)

4. **Infrastructure partners**:
   - Set up Stripe account and test Checkout
   - Trial Cloudinary and Algolia (free tiers)
   - Confirm WorkOS for enterprise SSO

### Partnership Negotiations (Months 2-4)

1. **Negotiate volume pricing**:
   - Cloudinary: Custom plan for startup (50% discount)
   - Algolia: Commit to annual plan (15% discount)
   - Stripe: Negotiate fees after $1M GMV
   - Skilljar: Annual commitment (20% discount)

2. **Lock in long-term agreements**:
   - 2-year commits for predictable costs
   - Growth pricing tiers (avoid sticker shock at scale)
   - Exit clauses (data export, migration support)

### Quarterly Reviews

- **Q1**: Finalize all v2 partnerships
- **Q2**: Evaluate v2 partner performance, optimize costs
- **Q3**: MIS decision (acquire vs build), plan v3 partnerships
- **Q4**: Negotiate v3 partner renewals, plan v4 needs

---

## Conclusion

**Recommended Strategy**: Hybrid approach with strategic partnering

### Build In-House (Core Differentiation)
- SaaS multi-tenancy platform
- DAM metadata and permissions
- Workflow engine (print-specific)
- MIS job ticketing (or acquire)
- White-label theming
- Marketplace platform (UI/UX)

### Partner (Commoditized Services)
- Payments (Stripe - always)
- AI models (OpenAI, Anthropic)
- Designer SDK (Polotno, possibly Canva)
- LMS (Thinkific → Skilljar)
- Storage/CDN (Cloudinary)
- Search (Algolia)
- SSO (WorkOS)

### Strategic Decisions Still Open
1. **MIS**: Acquire vs Build (evaluate in v2, decide by Month 6)
2. **Designer**: Polotno vs Canva SDK (POC in Month 1, decide Month 2)
3. **LMS**: Thinkific vs Skilljar (start cheap, upgrade if needed)
4. **Workflow**: Plain build vs Temporal (defer until v3 if simple workflows suffice)

**Bottom Line**: Hybrid approach saves $3.7M and accelerates time-to-market by 6-12 months, while maintaining control over core differentiators.

**Next Step**: Execute POCs for Designer and LMS in Month 1, finalize partnerships by Month 2.
