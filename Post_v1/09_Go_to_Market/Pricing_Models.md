# Pricing Models - PopSystem

## Executive Summary

This document outlines PopSystem's comprehensive pricing framework designed to support multiple customer segments, use cases, and value realization models. The pricing strategy balances revenue optimization with market penetration while providing transparent, flexible options that align with customer value perception.

## Pricing Philosophy

### Core Principles

1. **Value-Based Pricing**: Price reflects measurable customer value and outcomes
2. **Transparency**: Clear, predictable pricing without hidden fees
3. **Modularity**: Customers pay only for what they need
4. **Scalability**: Pricing grows with customer growth and expansion
5. **Flexibility**: Multiple models accommodate different buyer preferences
6. **Alignment**: Pricing structure aligns with how customers budget and purchase

### Strategic Objectives

- Maximize customer lifetime value (LTV)
- Minimize friction in buying process
- Enable land-and-expand growth motion
- Support multiple go-to-market channels
- Accommodate enterprise, mid-market, and SMB segments
- Facilitate marketplace transactions

## Pricing Model Overview

PopSystem offers four complementary pricing models that can be combined based on customer needs:

1. **Subscription-Based**: Fixed recurring fees for platform access
2. **Usage-Based**: Variable fees based on consumption metrics
3. **Transaction-Based**: Fees tied to specific business events or outcomes
4. **Module-Based**: À la carte pricing for specific capabilities

## 1. Subscription-Based Pricing

### Tiered Subscription Model

#### Starter Tier
**Target**: Small practices, clinics, community health centers

**Pricing**: $2,500/month ($30,000/year)

**Included Features**:
- Up to 10,000 lives under management
- Core population health dashboard
- Basic reporting (10 standard reports)
- Community level 1 support (email, 48-hour response)
- Single workspace
- 5 user seats included
- Standard security features
- Data storage: 100 GB
- API calls: 100,000/month

**Limitations**:
- No custom integrations
- No advanced analytics
- No care management workflows
- No AI/ML features

#### Professional Tier
**Target**: Mid-size health systems, large clinics, small ACOs

**Pricing**: $7,500/month ($90,000/year)

**Included Features**:
- Up to 50,000 lives under management
- Full population health platform
- Advanced reporting (50 standard reports + 10 custom)
- Standard support (email, phone, 24-hour response)
- 3 workspaces
- 25 user seats included
- Advanced security and compliance
- Data storage: 500 GB
- API calls: 500,000/month
- 5 pre-built EHR integrations
- Care gap identification
- Risk stratification
- Basic care management workflows

**Add-Ons Available**:
- Additional lives: $0.10/life/month
- Additional users: $150/user/month
- Custom reports: $500/report
- Additional storage: $100/100GB/month

#### Enterprise Tier
**Target**: Large health systems, IDNs, health plans, government agencies

**Pricing**: $25,000/month ($300,000/year) base + customization

**Included Features**:
- Unlimited lives under management
- Full platform with all modules
- Unlimited custom reporting
- Premium support (24/7, 4-hour response, dedicated CSM)
- Unlimited workspaces
- 100 user seats included
- Enterprise security (SSO, RBAC, audit logs)
- Data storage: 5 TB
- API calls: 5,000,000/month
- Unlimited EHR integrations
- Advanced care management
- Predictive analytics and AI/ML
- White-label options
- SLA guarantees (99.9% uptime)

**Customization**:
- Dedicated implementation team
- Custom integration development
- Tailored workflows and business rules
- On-site training
- Strategic account management

**Pricing Variables**:
- Organization size
- Number of facilities/locations
- Integration complexity
- Customization requirements
- Support SLA requirements

### Annual vs. Monthly Billing

#### Annual Prepayment Discount
- 12-month prepay: 16% discount (equivalent to 2 months free)
- 24-month prepay: 25% discount
- 36-month prepay: 33% discount

#### Monthly Billing
- Month-to-month available for Professional tier and below
- 20% premium over annual pricing
- No long-term commitment

### Multi-Year Agreements

#### 3-Year Agreement Benefits
- Price lock guarantee (no increases for contract term)
- Priority feature requests
- Dedicated customer success manager
- Quarterly business reviews
- Free major version upgrades
- Additional 10% discount

#### 5-Year Agreement Benefits
- All 3-year benefits plus:
- Executive sponsor assignment
- Custom development hours (40 hours/year)
- Annual on-site strategic planning session
- Beta access to new features
- Additional 15% discount

## 2. Usage-Based Pricing

### Consumption Metrics

Usage-based pricing applies to specific resources consumed beyond subscription limits.

#### Lives Under Management
**Definition**: Unique individuals in the population health registry

**Pricing Tiers** (beyond subscription limits):
- 0-100,000 lives: $0.15/life/month
- 100,001-500,000 lives: $0.10/life/month
- 500,001-1,000,000 lives: $0.07/life/month
- 1,000,000+ lives: $0.05/life/month

**Calculation**: Based on peak monthly active lives

#### Data Storage
**Definition**: Total data stored in platform (structured + unstructured)

**Pricing**:
- Standard storage: $100/TB/month
- Archival storage: $25/TB/month
- Backup storage: $50/TB/month

**Minimum**: Included in subscription tier

#### API Consumption
**Definition**: Number of API calls to PopSystem APIs

**Pricing** (beyond subscription limits):
- $10 per 100,000 API calls
- Bulk pricing: $5 per 100,000 for >10M calls/month

**Included**: Based on subscription tier

#### Data Processing
**Definition**: Computational resources for analytics, ML models, report generation

**Pricing**:
- Standard processing: $0.50/compute hour
- GPU processing (ML/AI): $2.00/compute hour
- Batch processing: $0.25/compute hour

#### Document Processing
**Definition**: OCR, NLP, clinical document parsing

**Pricing**:
- $0.01 per page processed
- Volume discount: $0.005/page for >1M pages/month

#### Outbound Communications
**Definition**: System-generated notifications and alerts

**Pricing**:
- Email: $0.001 per message
- SMS: $0.02 per message
- Push notification: $0.0005 per notification
- Voice call: $0.10 per minute

**Included**: 10,000 email credits/month per subscription

### Usage-Based Billing

#### Calculation
- Usage measured daily
- Aggregated monthly
- Billed in arrears
- Appears as separate line item on invoice

#### Soft Limits
- Warning at 80% of budgeted usage
- Alert at 100% of budgeted usage
- Optional hard caps to prevent overages

#### Usage Commitments
Customers can commit to minimum usage for discounted rates:

- $5,000/month commitment: 10% discount on usage
- $15,000/month commitment: 20% discount on usage
- $50,000/month commitment: 30% discount on usage

## 3. Transaction-Based Pricing

Transaction pricing ties fees to specific business events or outcomes.

### Care Coordination Transactions

#### Care Gap Closure
**Definition**: When a care gap is identified and subsequently closed

**Pricing**: $5 per gap closed
- Minimum: $1,000/month
- Includes: Gap identification, patient outreach, documentation

**Value Proposition**: Pay only for successful outcomes

#### Patient Outreach Campaigns
**Definition**: Automated outreach for preventive care, recalls, reminders

**Pricing**:
- Base: $0.50 per patient reached
- Multi-channel: $1.00 per patient (email + SMS + portal)
- Success fee: Additional $2.00 if appointment scheduled

#### Risk Assessment Completions
**Definition**: Comprehensive health risk assessment performed and scored

**Pricing**: $2 per completed assessment
- Includes: Survey delivery, completion tracking, risk scoring
- Minimum: 1,000 assessments/year

### Value-Based Care Support

#### Quality Measure Reporting
**Definition**: Automated calculation and submission of quality measures

**Pricing**: $100 per measure per reporting period
- HEDIS, CMS Stars, MIPS/MACRA support
- Includes: Data aggregation, calculation, export

#### Risk Adjustment
**Definition**: HCC coding support and documentation

**Pricing**:
- Per member per month (PMPM): $2-5 based on volume
- Success fee: 10% of incremental risk score improvement value

### Integration Transactions

#### Data Exchange Events
**Definition**: HL7, FHIR, or custom integration messages

**Pricing**:
- Inbound: $0.001 per message
- Outbound: $0.002 per message
- Transformation required: Additional $0.001 per message

**Volume Discounts**:
- >1M messages/month: 50% discount
- >10M messages/month: 75% discount

## 4. Module-Based Pricing

Customers can purchase specific modules à la carte or as part of subscription tiers.

### Core Modules

#### Population Health Registry
**Standalone Price**: $3,000/month

**Capabilities**:
- Patient registry and demographics
- Population segmentation
- Basic reporting
- Dashboard views

**Included In**: All tiers

#### Risk Stratification & Analytics
**Standalone Price**: $5,000/month

**Capabilities**:
- Predictive risk modeling
- Care gap identification
- Utilization analytics
- Custom cohort analysis

**Included In**: Professional and Enterprise tiers

#### Care Management
**Standalone Price**: $6,000/month

**Capabilities**:
- Care plan creation and tracking
- Task management
- Care team collaboration
- Patient engagement tools

**Included In**: Enterprise tier
**Available Add-On**: Starter and Professional tiers

### Advanced Modules

#### Social Determinants of Health (SDOH)
**Standalone Price**: $4,000/month

**Capabilities**:
- SDOH screening and assessment
- Community resource directory
- Referral management
- Longitudinal SDOH tracking

**Included In**: Enterprise tier (custom)
**Available Add-On**: All tiers

#### Chronic Disease Management
**Standalone Price**: $7,500/month (per condition)

**Conditions Available**:
- Diabetes
- Hypertension
- CHF
- COPD
- Asthma
- CKD

**Capabilities**:
- Condition-specific protocols
- Remote monitoring integration
- Patient education content
- Clinical decision support

**Pricing**:
- Single condition: $7,500/month
- 2-3 conditions: $6,000/month each
- 4+ conditions: $5,000/month each

#### Interoperability Hub
**Standalone Price**: $8,000/month

**Capabilities**:
- HL7 v2, CDA, FHIR support
- HIE connectivity
- ADT notifications
- Clinical data exchange
- Pre-built EHR connectors

**Included In**: Enterprise tier
**Available Add-On**: Professional tier

### Specialty Modules

#### Maternal Health
**Standalone Price**: $5,000/month

**Capabilities**:
- Prenatal care tracking
- High-risk pregnancy identification
- Postpartum care coordination
- Social support services

#### Behavioral Health Integration
**Standalone Price**: $6,000/month

**Capabilities**:
- Screening and assessment tools
- Integrated care planning
- Collaborative care model support
- Outcome tracking

#### Telehealth Integration
**Standalone Price**: $4,000/month

**Capabilities**:
- Virtual visit scheduling
- Video platform integration
- Remote patient monitoring
- Digital health device integration

#### AI/ML Analytics Engine
**Standalone Price**: $10,000/month

**Capabilities**:
- Predictive modeling
- Natural language processing
- Image analysis
- Automated insights
- Custom model training

**Requirements**: Enterprise tier subscription

### Module Bundles

#### Care Management Bundle
**Price**: $15,000/month (20% savings)

**Includes**:
- Care Management
- Risk Stratification & Analytics
- SDOH Module
- Chronic Disease Management (2 conditions)

#### Value-Based Care Bundle
**Price**: $20,000/month (25% savings)

**Includes**:
- All Core Modules
- Risk Stratification & Analytics
- Care Management
- Interoperability Hub
- AI/ML Analytics Engine

#### Population Health Complete
**Price**: $30,000/month (30% savings)

**Includes**:
- All Core Modules
- All Advanced Modules
- 2 Specialty Modules of choice
- Unlimited lives
- Premium support

## Packaging & Bundling Strategy

### Good-Better-Best Framework

| Feature/Module | Starter | Professional | Enterprise |
|---------------|---------|--------------|------------|
| **Base Price** | $2,500/mo | $7,500/mo | $25,000/mo |
| **Lives Included** | 10,000 | 50,000 | Unlimited |
| **Users Included** | 5 | 25 | 100 |
| **Population Registry** | ✓ | ✓ | ✓ |
| **Risk Stratification** | - | ✓ | ✓ |
| **Care Management** | - | Basic | Advanced |
| **SDOH Module** | Add-on | Add-on | ✓ |
| **Chronic Disease Mgmt** | - | 1 condition | Unlimited |
| **Interoperability** | - | 5 connectors | Unlimited |
| **AI/ML Analytics** | - | - | ✓ |
| **Support Level** | Community | Standard | Premium |
| **SLA** | None | 99.5% | 99.9% |

### Vertical-Specific Packages

#### Federally Qualified Health Center (FQHC) Edition
**Price**: $5,000/month

**Optimized For**: FQHCs and community health centers

**Includes**:
- Population Health Registry
- SDOH Module (enhanced)
- UDS reporting automation
- Sliding fee scale management
- Grant reporting tools
- Up to 25,000 lives

#### ACO/CIN Edition
**Price**: $15,000/month

**Optimized For**: Accountable Care Organizations

**Includes**:
- All core modules
- Value-Based Care Bundle
- MSSP quality reporting
- Shared savings calculation
- Network performance analytics
- Up to 100,000 attributed lives

#### Health Plan Edition
**Price**: $20,000/month

**Optimized For**: Payers and managed care organizations

**Includes**:
- Member management
- HEDIS reporting automation
- Stars quality measures
- Risk adjustment support
- Network adequacy analysis
- Up to 100,000 members

## Professional Services Pricing

### Implementation Services

#### Standard Implementation
**Price**: $15,000-50,000 (based on complexity)

**Included**:
- System configuration
- Data migration (up to 3 sources)
- User training (virtual)
- Go-live support (2 weeks)

**Timeline**: 4-8 weeks

#### Enterprise Implementation
**Price**: $75,000-250,000 (custom quote)

**Included**:
- Complex system configuration
- Custom integration development
- Data migration (unlimited sources)
- Workflow customization
- On-site training
- Dedicated implementation manager
- Go-live support (4 weeks)
- Post-launch optimization

**Timeline**: 12-24 weeks

### Integration Development

#### Pre-Built Connector Setup
**Price**: $2,500 per connector

**Examples**:
- Epic, Cerner, Allscripts, athenahealth
- Common HIE platforms
- Standard HL7 v2 feeds

#### Custom Integration Development
**Price**: $150-250/hour (T&M) or fixed-bid

**Estimate Range**: $10,000-100,000 per integration

**Scope**:
- Requirements gathering
- Interface design and development
- Testing and validation
- Documentation
- Ongoing support

### Training Services

#### Virtual Training
**Price**: $1,500 per session (up to 20 participants)

**Duration**: 2-4 hours

**Topics**:
- End-user training
- Administrator training
- Workflow optimization
- Report building

#### On-Site Training
**Price**: $5,000 per day (plus travel expenses)

**Includes**:
- Full-day sessions
- Hands-on workshops
- Train-the-trainer programs
- Custom curriculum

### Consulting Services

#### Strategic Advisory
**Price**: $15,000/month retainer or $300/hour

**Services**:
- Population health strategy
- Value-based care planning
- Workflow optimization
- Change management
- Data governance

#### Data Analytics & Insights
**Price**: $10,000-50,000 per project

**Deliverables**:
- Custom analytics development
- Predictive model building
- Data visualization
- Executive dashboards
- Ad hoc analysis

## Support & Maintenance

### Support Tiers

#### Community Support (Starter Tier)
**Included**: In subscription

**Coverage**:
- Email support
- Knowledge base access
- Community forums
- 48-hour response time

#### Standard Support (Professional Tier)
**Included**: In subscription

**Coverage**:
- Email and phone support
- Business hours (8am-6pm local time)
- 24-hour response time (P1), 48-hour (P2-P3)
- Quarterly system health reviews

#### Premium Support (Enterprise Tier)
**Included**: In subscription

**Coverage**:
- 24/7/365 support
- Dedicated customer success manager
- 4-hour response (P1), 24-hour (P2), 48-hour (P3)
- Monthly business reviews
- Named support contacts
- Escalation path to engineering

#### Mission Critical Support
**Price**: Additional $5,000/month

**Coverage** (adds to Premium):
- 1-hour response for P1 issues
- Dedicated Slack channel
- Proactive monitoring and alerting
- Quarterly on-site visits
- Disaster recovery planning

### Managed Services

#### Fully Managed Operations
**Price**: 20-30% of subscription value

**Services**:
- User administration
- System configuration changes
- Report generation
- Data quality management
- Integration monitoring
- Performance optimization

## Pricing for Specific Scenarios

### Non-Profit & Academic Pricing

#### Qualified Non-Profit Discount
**Discount**: 25% off subscription pricing

**Eligibility**:
- 501(c)(3) status
- Community health centers
- Free clinics
- Public health departments

#### Academic & Research Discount
**Discount**: 40% off subscription pricing

**Eligibility**:
- Accredited academic institutions
- Research projects
- Time-limited to project duration

### Government Pricing

#### FedRAMP Authorized Offering
**Premium**: 15-20% above commercial pricing

**Justification**:
- Enhanced security controls
- Continuous monitoring
- Compliance documentation
- Audit support

#### State & Local Government
**Pricing**: Standard commercial with volume discounts

**Procurement**:
- GSA Schedule pricing available
- State contract vehicles
- Cooperative purchasing agreements

### International Pricing

#### Regional Pricing Adjustment
- North America: Base pricing
- Western Europe: 1.1x base (VAT additional)
- Asia-Pacific: 0.9x base
- Latin America: 0.8x base
- Africa/Middle East: 0.7x base

**Factors**:
- Market purchasing power
- Competitive landscape
- Local regulatory requirements
- Currency stability

## Marketplace Pricing

### AWS Marketplace

#### Pricing Model
- Hourly SaaS contracts
- Annual/multi-year contracts
- Private offers for custom deals

#### Fees
- AWS Marketplace fee: 3% of transaction
- Reflected in pricing or absorbed

#### Benefits
- Apply to AWS committed spend
- Consolidated billing
- Streamlined procurement

### Azure Marketplace

#### Pricing Model
- Flat-rate SaaS
- Per-user pricing
- Consumption-based

#### Fees
- Microsoft transact fee: 3-20% depending on publisher status
- ISV qualified pricing available

### Google Cloud Marketplace

#### Pricing Model
- Usage-based billing
- Integrated with GCP billing

#### Fees
- Google Marketplace fee: 3%

## Pricing Governance

### Discount Authority

#### Sales Rep Authority
- Up to 10% discount from list price
- Payment term flexibility (net-30 to net-60)

#### Sales Manager Authority
- Up to 20% discount from list price
- Custom payment plans
- Professional services bundling

#### VP Sales Authority
- Up to 30% discount from list price
- Multi-year deal structuring
- Strategic account pricing

#### Executive Authority (CEO/CFO)
- >30% discount
- Loss-leader strategic deals
- Custom commercial terms

### Price Change Policy

#### Existing Customers
- Grandfathered pricing for contract term
- 90-day notice for renewals
- Price increases capped at 5% annually (CPI-based)

#### New Customers
- Current published pricing
- Annual price list updates (January 1)
- Strategic pricing for large deals

### Promotional Pricing

#### Launch Promotions
- Early adopter discount: 30% first year
- Referral credits: $5,000 per qualified referral
- Case study participation: 10% ongoing discount

#### Seasonal Promotions
- Q4 year-end promotion: Extended trials, implementation credits
- Conference promotions: Show specials for event attendees

## Total Cost of Ownership (TCO) Modeling

### Sample TCO - Mid-Size Health System

**Organization Profile**:
- 3 hospitals, 20 clinics
- 100,000 attributed lives
- 50 users
- 5 data integrations

**PopSystem Costs** (Professional Tier):
- Subscription: $90,000/year
- Additional lives (50,000 @ $0.10): $60,000/year
- Additional users (25 @ $150): $45,000/year
- Implementation (one-time): $35,000
- Training: $10,000
- Integrations (5 @ $2,500): $12,500

**Year 1 Total**: $252,500
**Years 2-3**: $195,000/year

**Alternative (Legacy System)**:
- License fees: $200,000/year
- Maintenance: $40,000/year
- Infrastructure: $50,000/year
- Implementation: $150,000
- Customization: $75,000
- Annual upgrades: $30,000/year

**Year 1 Total**: $515,000
**Years 2-3**: $320,000/year

**3-Year Savings with PopSystem**: $530,000 (51% reduction)

## Pricing Psychology & Positioning

### Value Anchoring
- Lead with enterprise pricing to make mid-tier seem accessible
- Emphasize ROI and cost savings vs. legacy systems
- Position against "cost of doing nothing"

### Good-Better-Best Effect
- Starter: Anchor low price, limited features (drives consideration)
- Professional: Sweet spot for most buyers (optimize for conversion)
- Enterprise: Premium positioning (aspirational, high ACV)

### Decoy Pricing
- Module pricing positioned to make bundles attractive
- Annual billing discounts encourage commitment
- Multi-year deals positioned as "no-brainer"

## Competitive Pricing Analysis

### Pricing vs. Key Competitors

| Vendor | Entry Price | Mid-Market | Enterprise |
|--------|-------------|------------|------------|
| PopSystem | $2,500/mo | $7,500/mo | $25,000/mo |
| Legacy Vendor A | N/A | $15,000/mo | $40,000/mo |
| Legacy Vendor B | $5,000/mo | $12,000/mo | $35,000/mo |
| Modern Competitor | $3,000/mo | $9,000/mo | $30,000/mo |

**Positioning**: Premium value at mid-market price point

## Revenue Modeling

### Sample Customer Cohort Analysis

**Year 1** (50 customers):
- 15 Starter tier: $450,000 ARR
- 25 Professional tier: $2,250,000 ARR
- 10 Enterprise tier: $3,000,000 ARR
- **Total Subscription ARR**: $5,700,000

**Usage & Overages** (15% of subscription): $855,000

**Professional Services** (40% attach): $300,000

**Year 1 Total Revenue**: $6,855,000

**Year 2** (Growth):
- Customer retention: 90%
- Upsell expansion: 25% of customers expand 20%
- New customers: 50 additional
- **Year 2 Revenue**: $14,200,000

## Conclusion

PopSystem's pricing framework provides flexibility to serve diverse market segments while optimizing for revenue growth and customer value realization. The multi-modal pricing approach—combining subscription, usage, transaction, and module-based models—enables customers to choose the structure that best aligns with their business model and budget processes.

Key pricing strategy elements:
- Clear value differentiation across tiers
- Modular options for customization
- Volume and commitment incentives
- Transparent, predictable costs
- Competitive positioning at mid-market price points
- Multiple paths to expansion revenue

This pricing foundation supports PopSystem's go-to-market objectives while remaining adaptable to market feedback and competitive dynamics.
