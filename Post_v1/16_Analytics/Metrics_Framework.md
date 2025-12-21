# Metrics Framework

## Overview

This document defines the comprehensive metrics framework for PopSystem, establishing standardized definitions, calculation methods, and ownership for all key performance indicators across operational, business, and product domains.

## Principles

1. **Actionable**: Metrics must drive decisions and actions
2. **Consistent**: Calculations standardized across organization
3. **Timely**: Updated frequently enough to enable intervention
4. **Owned**: Clear accountability for each metric
5. **Contextual**: Presented with relevant benchmarks and trends

---

## Operational Metrics

Metrics focused on day-to-day platform operations and execution quality.

| Metric | Definition | Calculation | Owner | Frequency | Target |
|--------|------------|-------------|-------|-----------|--------|
| Campaign completion rate | Percentage of campaigns finished on or before deadline | Completed on time / Total campaigns × 100% | Brand Manager | Daily | >95% |
| Store execution time | Average time from order placement to completion | Avg(completion_time - order_time) | PSP Operations | Daily | <5 days |
| First-time approval rate | Percentage of proofs approved on first submission | Approved on first try / Total submitted × 100% | Brand Manager | Weekly | >80% |
| Order fulfillment accuracy | Percentage of orders completed without errors | Accurate orders / Total orders × 100% | PSP Operations | Daily | >98% |
| Asset delivery SLA | Percentage of assets delivered within SLA | On-time deliveries / Total deliveries × 100% | PSP Operations | Daily | >95% |
| Store compliance rate | Percentage of stores meeting brand standards | Compliant stores / Total stores × 100% | Brand Manager | Weekly | >90% |
| Production capacity utilization | Percentage of available production capacity used | Used capacity / Total capacity × 100% | PSP Operations | Daily | 70-85% |
| Average approval cycle time | Mean time from submission to final approval | Avg(approval_time - submission_time) | Brand Manager | Weekly | <48 hours |
| Rework rate | Percentage of orders requiring rework | Orders with rework / Total orders × 100% | PSP Operations | Weekly | <5% |
| Kit assembly time | Average time to assemble a store kit | Avg(assembly_end - assembly_start) | PSP Operations | Weekly | <2 hours |
| Shipping on-time delivery | Percentage of shipments arriving on schedule | On-time arrivals / Total shipments × 100% | PSP Operations | Daily | >95% |
| Platform uptime | Percentage of time platform is available | (Total time - downtime) / Total time × 100% | Engineering | Real-time | >99.9% |

### Operational Metric Details

#### Campaign Completion Rate
- **Purpose**: Measure campaign execution effectiveness
- **Data Source**: Campaign management system
- **Segmentation**: By brand, region, campaign type
- **Alert Threshold**: <85%
- **Related Metrics**: Store execution time, approval cycle time

#### Store Execution Time
- **Purpose**: Track production efficiency
- **Data Source**: Order management system
- **Segmentation**: By PSP, order complexity, region
- **Alert Threshold**: >7 days
- **Related Metrics**: Production capacity utilization, rework rate

#### First-time Approval Rate
- **Purpose**: Measure quality of submissions and clarity of requirements
- **Data Source**: Approval workflow system
- **Segmentation**: By PSP, asset type, brand
- **Alert Threshold**: <70%
- **Related Metrics**: Average approval cycle time, rework rate

---

## Business Metrics

Metrics focused on financial performance and business health.

| Metric | Definition | Calculation | Owner | Frequency | Target |
|--------|------------|-------------|-------|-----------|--------|
| ARR | Annual recurring revenue | MRR × 12 | Finance | Monthly | Growth YoY |
| MRR | Monthly recurring revenue | Sum of all subscription revenue normalized to monthly | Finance | Monthly | Growth MoM |
| NRR | Net revenue retention | ((Start ARR + Expansion - Churn) / Start ARR) × 100% | Customer Success | Quarterly | >110% |
| GRR | Gross revenue retention | ((Start ARR - Churn) / Start ARR) × 100% | Customer Success | Quarterly | >95% |
| CAC | Customer acquisition cost | Total S&M spend / New customers acquired | Marketing | Monthly | <$10k |
| LTV | Lifetime value | ARPU × Average customer lifespan (months) | Finance | Quarterly | >$150k |
| LTV:CAC ratio | Ratio of lifetime value to acquisition cost | LTV / CAC | Finance | Quarterly | >15:1 |
| Payback period | Months to recover CAC | CAC / (ARPU × Gross margin %) | Finance | Quarterly | <6 months |
| Customer churn rate | Percentage of customers lost | Lost customers / Total customers × 100% | Customer Success | Monthly | <5% annual |
| Revenue churn rate | Percentage of revenue lost from churn | Churned revenue / Total revenue × 100% | Customer Success | Monthly | <3% annual |
| Expansion revenue | Revenue from upsells and cross-sells | Sum of expansion transactions | Sales | Monthly | Growth MoM |
| Average contract value | Mean value of customer contracts | Total contract value / Number of contracts | Sales | Monthly | Growth YoY |
| Gross margin | Revenue minus direct costs | (Revenue - COGS) / Revenue × 100% | Finance | Monthly | >70% |
| EBITDA margin | Operating profitability | EBITDA / Revenue × 100% | Finance | Monthly | Path to 20%+ |
| Cash burn rate | Monthly cash consumption | (Starting cash - Ending cash) / Months | Finance | Monthly | Decreasing |
| Months of runway | Time until cash depletion | Current cash / Monthly burn rate | Finance | Monthly | >18 months |

### Business Metric Details

#### ARR (Annual Recurring Revenue)
- **Purpose**: Primary revenue metric for SaaS business
- **Data Source**: Billing system
- **Segmentation**: By customer tier, module, region
- **Alert Threshold**: Negative growth
- **Related Metrics**: MRR, NRR, customer count

#### NRR (Net Revenue Retention)
- **Purpose**: Measure ability to grow revenue from existing customers
- **Data Source**: Billing system
- **Calculation Notes**:
  - Cohort-based measurement
  - Includes expansions, downgrades, churn
  - Excludes new customer revenue
- **Alert Threshold**: <100%
- **Related Metrics**: Expansion revenue, churn rate

#### CAC (Customer Acquisition Cost)
- **Purpose**: Measure efficiency of customer acquisition
- **Data Source**: Finance system, CRM
- **Calculation Notes**:
  - S&M spend includes: salaries, commissions, marketing, tools
  - Typically measured with 1-month lag
- **Alert Threshold**: >$15k or LTV:CAC <10:1
- **Related Metrics**: LTV, payback period

#### LTV (Lifetime Value)
- **Purpose**: Measure total value of customer relationship
- **Data Source**: Finance system, billing
- **Calculation Methods**:
  - **Simple**: ARPU × Average lifespan
  - **Advanced**: NPV of future cash flows with churn probability
- **Alert Threshold**: LTV:CAC <10:1
- **Related Metrics**: CAC, ARPU, churn rate

---

## Product Metrics

Metrics focused on product usage, adoption, and health.

| Metric | Definition | Calculation | Owner | Frequency | Target |
|--------|------------|-------------|-------|-----------|--------|
| DAU | Daily active users | Unique users active in 24-hour period | Product | Daily | Growth WoW |
| MAU | Monthly active users | Unique users active in 30-day period | Product | Daily | Growth MoM |
| DAU/MAU ratio | User engagement ratio | DAU / MAU × 100% | Product | Daily | >40% |
| WAU | Weekly active users | Unique users active in 7-day period | Product | Daily | Growth WoW |
| Feature adoption rate | Percentage of users using specific feature | Users with feature / Total users × 100% | Product | Weekly | >60% for core |
| Module attach rate | Average add-on modules per customer | Total modules / Total customers | Product | Monthly | >2.5 |
| Time to first value | Time from signup to first key action | Avg(first_action_time - signup_time) | Product | Weekly | <24 hours |
| User onboarding completion | Percentage completing onboarding | Completed / Started × 100% | Product | Weekly | >80% |
| Power user ratio | Percentage of highly engaged users | Power users / Total users × 100% | Product | Monthly | >25% |
| Session duration | Average time per user session | Avg(session_end - session_start) | Product | Daily | Context-dependent |
| Feature discovery rate | Users discovering new features | Users using new feature / Total users × 100% | Product | Per release | >40% in 30 days |
| API usage rate | Percentage of customers using API | Customers with API calls / Total customers × 100% | Product | Monthly | >30% |
| Mobile app adoption | Percentage using mobile app | Mobile users / Total users × 100% | Product | Monthly | >50% |
| Search effectiveness | Searches resulting in action | Successful searches / Total searches × 100% | Product | Weekly | >70% |
| Error rate | Application errors per session | Errors / Sessions × 100% | Engineering | Real-time | <0.1% |
| Page load time | Average page load speed | P95(page_load_time) | Engineering | Daily | <2 seconds |

### Product Metric Details

#### DAU/MAU (Stickiness Ratio)
- **Purpose**: Measure product stickiness and engagement
- **Data Source**: Analytics platform
- **Definition of "Active"**: User performs any meaningful action (not just login)
- **Alert Threshold**: <30%
- **Related Metrics**: DAU, MAU, session duration

#### Feature Adoption Rate
- **Purpose**: Track uptake of specific features
- **Data Source**: Feature flag system, analytics
- **Measurement Period**: Typically 30 days after release
- **Segmentation**: By user role, customer tier
- **Alert Threshold**: <50% for core features after 90 days
- **Related Metrics**: Feature discovery rate, time to first value

#### Module Attach Rate
- **Purpose**: Measure platform expansion and value creation
- **Data Source**: Billing system, product analytics
- **Calculation**: Count active modules per customer
- **Alert Threshold**: Declining trend
- **Related Metrics**: Expansion revenue, NRR

#### Time to First Value
- **Purpose**: Measure onboarding effectiveness
- **Data Source**: Analytics platform
- **Key Actions by User Type**:
  - **Brand**: Create first campaign
  - **PSP**: Accept first order
  - **Store**: Submit first request
- **Alert Threshold**: >48 hours
- **Related Metrics**: Onboarding completion, activation rate

---

## Customer Health Metrics

Metrics for tracking customer satisfaction and success.

| Metric | Definition | Calculation | Owner | Frequency | Target |
|--------|------------|-------------|-------|-----------|--------|
| NPS | Net Promoter Score | % Promoters - % Detractors | Customer Success | Quarterly | >50 |
| CSAT | Customer satisfaction score | Avg rating on satisfaction survey | Customer Success | Post-interaction | >4.5/5 |
| Customer health score | Composite health indicator | Weighted score of usage + support + sentiment | Customer Success | Weekly | >80/100 |
| Support ticket volume | Number of support requests | Count of tickets created | Support | Daily | Decreasing |
| First response time | Time to first support response | Avg(first_response - ticket_created) | Support | Daily | <2 hours |
| Ticket resolution time | Time to resolve support ticket | Avg(resolved - created) | Support | Daily | <24 hours |
| Support ticket escalation rate | Percentage of tickets escalated | Escalated / Total × 100% | Support | Weekly | <10% |
| Product feedback volume | Suggestions and requests submitted | Count of feedback items | Product | Weekly | Trend analysis |
| Reference customer ratio | Customers willing to be references | Reference customers / Total × 100% | Customer Success | Quarterly | >30% |
| Executive engagement | C-level participation in QBRs | Execs attending / Total QBRs × 100% | Customer Success | Quarterly | >80% |

---

## Metric Governance

### Data Quality Standards

1. **Accuracy**: Automated validation checks, source of truth defined
2. **Completeness**: <1% null values for required fields
3. **Consistency**: Same metric shows same value across all dashboards
4. **Timeliness**: Metrics updated within defined SLA
5. **Auditability**: Calculation logic documented and version controlled

### Metric Review Process

- **Weekly**: Operational metrics review with department heads
- **Monthly**: Business metrics review with executive team
- **Quarterly**: Comprehensive metrics framework review
- **Annual**: Strategic metric selection and target setting

### Metric Lifecycle

1. **Proposal**: Metric proposed with business justification
2. **Definition**: Clear definition and calculation method established
3. **Implementation**: Data collection and calculation automated
4. **Validation**: Accuracy verified against known scenarios
5. **Adoption**: Metric added to dashboards and reports
6. **Review**: Regular assessment of metric's value
7. **Deprecation**: Remove metrics that no longer drive decisions

### Change Management

- All metric definition changes require approval from metric owner + analytics team
- Changes documented with version history and effective date
- Downstream dependencies identified before changes
- Historical data recalculated if methodology changes materially

---

## Benchmarks and Targets

### SaaS Industry Benchmarks

| Metric | Good | Great | Best-in-Class |
|--------|------|-------|---------------|
| NRR | 100-110% | 110-120% | >120% |
| GRR | >90% | >95% | >97% |
| LTV:CAC | 3:1 | 5:1 | >10:1 |
| Payback Period | 12-18 mo | 6-12 mo | <6 mo |
| CAC as % of LTV | 25-33% | 15-25% | <15% |
| Annual Churn | 10-15% | 5-10% | <5% |
| DAU/MAU | 20-30% | 30-40% | >40% |
| NPS | 30-50 | 50-70 | >70 |

### PopSystem Target Evolution

| Metric | v1 (Current) | v2 (12 months) | v3 (24 months) | v4 (36 months) |
|--------|--------------|----------------|----------------|----------------|
| ARR | $500k | $2M | $5M | $10M |
| NRR | 95% | 105% | 115% | 120% |
| CAC | $15k | $12k | $10k | $8k |
| LTV:CAC | 8:1 | 12:1 | 15:1 | 18:1 |
| Module Attach | 1.2 | 2.0 | 2.5 | 3.0 |
| DAU/MAU | 25% | 35% | 40% | 45% |
| NPS | 40 | 50 | 60 | 70 |
| Gross Margin | 65% | 70% | 75% | 75% |

---

## Implementation Notes

### Phase 1: Foundation (Months 1-3)
- Implement core operational and business metrics
- Establish data collection infrastructure
- Build executive and operations dashboards
- Train teams on metric definitions

### Phase 2: Expansion (Months 4-6)
- Add product and customer health metrics
- Implement automated alerting
- Build role-specific dashboards
- Establish metric review cadences

### Phase 3: Optimization (Months 7-12)
- Add advanced segmentation and cohort analysis
- Implement predictive metrics
- Build self-service analytics capabilities
- Optimize data collection and calculation performance

### Data Sources Required

- **Operational**: Order management, workflow, production systems
- **Business**: Billing, CRM, financial systems
- **Product**: Analytics platform, feature flags, application logs
- **Customer Health**: Survey tools, support system, CRM

### Tool Stack

- **Data Warehouse**: PostgreSQL → Snowflake/BigQuery (scale)
- **ETL**: Custom scripts → dbt (transformation)
- **Analytics Platform**: Segment/Rudderstack for event tracking
- **BI Tool**: Metabase → Preset/Looker (See BI_Tool_Evaluation.md)
- **Alerting**: Custom → PagerDuty/Opsgenie integration

---

## Appendix

### Glossary

- **ARPU**: Average Revenue Per User
- **COGS**: Cost of Goods Sold
- **Cohort**: Group of customers acquired in same time period
- **Churn**: Customer or revenue loss
- **Expansion**: Revenue growth from existing customers
- **MoM**: Month-over-Month growth
- **QoQ**: Quarter-over-Quarter growth
- **YoY**: Year-over-Year growth
- **P95**: 95th percentile (5% of values are higher)
- **SLA**: Service Level Agreement

### Related Documents

- Dashboard_Specs.md - Dashboard designs for each metric set
- Data_Architecture.md - Technical implementation of metrics
- BI_Tool_Evaluation.md - Analytics tooling decisions
- AI_Insights_Roadmap.md - Advanced analytics capabilities
