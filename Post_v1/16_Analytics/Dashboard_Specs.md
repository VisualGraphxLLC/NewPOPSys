# Dashboard Specifications

## Overview

This document defines the dashboard specifications for PopSystem's analytics platform, organized by primary audience and use case. Each dashboard provides role-specific insights with appropriate drill-down capabilities and contextual information.

## Design Principles

1. **Audience-First**: Tailored to specific user needs and decision-making context
2. **Actionable**: Every metric should drive a decision or action
3. **Progressive Disclosure**: High-level summary with drill-down capabilities
4. **Contextual**: Include trends, comparisons, and benchmarks
5. **Performant**: Load in <3 seconds with data freshness indicators
6. **Mobile-Responsive**: Key dashboards accessible on mobile devices

---

## Executive Dashboard

### Audience
C-suite executives, board members, investors

### Purpose
High-level business health and strategic performance monitoring

### Refresh Frequency
Real-time for platform metrics, daily for business metrics

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  EXECUTIVE OVERVIEW                         Updated: 2m ago │
├─────────────────────────────────────────────────────────────┤
│  KEY METRICS (Big Numbers)                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │   ARR    │  │  Customers│  │   NRR    │  │   NPS    │   │
│  │  $2.4M   │  │    45     │  │   112%   │  │   58     │   │
│  │  ↑ 23%   │  │  ↑ 8 MoM  │  │  ↑ 3pts  │  │  ↑ 5pts  │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
├─────────────────────────────────────────────────────────────┤
│  REVENUE TREND (12-month chart)                             │
│  [Line chart: ARR, MRR, Expansion Revenue]                  │
├────────────────┬────────────────────────────────────────────┤
│ CUSTOMER HEALTH│ PLATFORM OPERATIONS                        │
│  Churn: 2.1%   │  Active Campaigns: 127                     │
│  Health: 85/100│  Completion Rate: 94.2%                    │
│  At Risk: 3    │  Uptime: 99.97%                            │
├────────────────┴────────────────────────────────────────────┤
│  TOP CAMPAIGNS BY REVENUE                                   │
│  [Horizontal bar chart: Top 10 campaigns]                   │
├─────────────────────────────────────────────────────────────┤
│  GEOGRAPHIC DISTRIBUTION                                    │
│  [Map: Revenue by region with heat mapping]                │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Displayed

#### Primary Metrics (Big Numbers)
- **ARR**: Current annual recurring revenue with MoM/QoQ growth
- **Total Customers**: Active customer count with net new
- **NRR**: Net revenue retention with trend
- **NPS**: Net Promoter Score with trend
- **LTV:CAC**: Ratio with target indicator
- **Gross Margin**: Percentage with trend

#### Revenue Section
- **ARR Trend**: 12-month line chart with forecast
- **MRR Growth**: Monthly recurring revenue trend
- **Expansion Revenue**: Upsell/cross-sell contribution
- **Revenue by Segment**: Brand vs PSP vs other
- **Bookings vs Revenue**: New bookings compared to recognized revenue

#### Customer Health
- **Customer Count**: Total active customers
- **Churn Rate**: Monthly and annual churn
- **Health Score Distribution**: Histogram of customer health
- **At-Risk Customers**: Count and ARR at risk
- **Customer Acquisition**: New customers per month

#### Platform Operations
- **Active Campaigns**: Current campaigns in flight
- **Campaign Completion Rate**: On-time completion percentage
- **Store Execution Time**: Average days to complete
- **Platform Uptime**: 30-day uptime percentage
- **Support Tickets**: Open and response time

#### Strategic Insights
- **Top Campaigns**: By revenue, store count, or strategic importance
- **Top Customers**: By ARR, growth, or health score
- **Geographic Distribution**: Revenue and customer map
- **Product Mix**: Revenue by module/capability
- **Key Wins**: Notable achievements and milestones

### Interactions
- Click metric to see detailed trend and breakdown
- Hover for additional context and calculation
- Filter by date range (default: current month/quarter)
- Export to PDF for board reporting

### Alerts
- Red: Metric significantly below target
- Yellow: Metric slightly below target or trending down
- Green: Metric at or above target

---

## PSP Operations Dashboard

### Audience
PSP owners, production managers, fulfillment teams

### Purpose
Real-time production monitoring and operational efficiency tracking

### Refresh Frequency
Real-time (30-second updates)

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  PSP OPERATIONS                            Live │ Filters ▼ │
├─────────────────────────────────────────────────────────────┤
│  TODAY'S SNAPSHOT                                           │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐          │
│  │ Orders  │ │Producing│ │Completed│ │Capacity │          │
│  │   34    │ │   12    │ │   22    │ │  78%    │          │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘          │
├─────────────────────────────────────────────────────────────┤
│  PRODUCTION PIPELINE                                        │
│  [Kanban view: New → In Prod → QA → Shipping → Delivered]  │
│     8          12        5        6           3             │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────┬─────────────────────────────────┐ │
│  │ PERFORMANCE METRICS │ REVENUE & FINANCIALS            │ │
│  │ Exec Time: 4.2 days │ MTD Revenue: $87k               │ │
│  │ First Pass: 83%     │ Avg Order: $2.1k                │ │
│  │ Rework Rate: 7%     │ Top Client: BrandCo ($24k)      │ │
│  │ On-time: 91%        │ Margin: 42%                     │ │
│  └─────────────────────┴─────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ACTIVE ORDERS (Table)                                      │
│  Order │ Brand   │ Status      │ Due Date  │ Progress  ▼   │
│  #1234 │ BrandCo │ Producing   │ Dec 23    │ ████░ 75%     │
│  #1235 │ RetailX │ QA Review   │ Dec 24    │ ████░ 80%     │
│  ...                                                        │
├─────────────────────────────────────────────────────────────┤
│  CAPACITY PLANNING                                          │
│  [Gantt chart: Scheduled work vs available capacity]       │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Displayed

#### Daily Operations
- **Order Volume**: New, in-progress, completed today
- **Production Status**: Count by stage in pipeline
- **Capacity Utilization**: Current load vs max capacity
- **Urgent Orders**: Due within 48 hours
- **Blocked Orders**: Awaiting approval or materials

#### Performance Metrics
- **Execution Time**: Average days from order to completion
  - Trend over last 30 days
  - Breakdown by complexity level
- **First-Time Approval Rate**: Percentage approved without revision
- **Rework Rate**: Orders requiring redo
- **On-Time Delivery**: Orders completed by due date
- **Quality Score**: Defect rate and customer feedback

#### Revenue & Financials
- **MTD Revenue**: Month-to-date billing
- **Projected Monthly Revenue**: Based on pipeline
- **Average Order Value**: Mean revenue per order
- **Revenue by Client**: Top clients by spend
- **Gross Margin**: Revenue minus direct costs
- **Outstanding Invoices**: AR aging

#### Pipeline Management
- **Production Pipeline**: Visual kanban or swimlane
  - New orders
  - In production
  - Quality assurance
  - Shipping
  - Delivered
- **Order Details**: Click to see full order information
- **Bottleneck Identification**: Stages with longest duration

#### Capacity Planning
- **Current Capacity**: Percentage utilized
- **Available Capacity**: Hours/units available
- **Scheduled Work**: Gantt chart of committed work
- **Overflow Risk**: Periods approaching 100% capacity
- **Resource Allocation**: Staff/equipment assignment

#### Team Performance
- **Productivity**: Orders per person per day
- **Efficiency**: Actual vs estimated time
- **Quality**: Error rate by team member
- **Utilization**: Billable hours percentage

### Filters
- Date range (today, this week, this month)
- Client/Brand
- Order complexity
- Production status
- Team/resource

### Interactions
- Click order to see full details and timeline
- Drag orders to reprioritize
- Click capacity chart to adjust schedules
- Export production report

### Alerts
- Orders approaching deadline
- Capacity exceeding 90%
- Quality issues detected
- Approval bottlenecks

---

## Brand Performance Dashboard

### Audience
Brand managers, marketing teams, retail operations

### Purpose
Campaign tracking, store performance, and brand compliance monitoring

### Refresh Frequency
Hourly updates

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  BRAND PERFORMANCE                    Brand: [BrandCo ▼]    │
├─────────────────────────────────────────────────────────────┤
│  ACTIVE CAMPAIGNS                                           │
│  ┌─────────────────┐ ┌─────────────────┐ ┌──────────────┐  │
│  │ Holiday Promo   │ │ Spring Launch   │ │ Q1 Refresh   │  │
│  │ 156 stores      │ │ 89 stores       │ │ 234 stores   │  │
│  │ ████████░ 92%   │ │ ████░░░░░ 45%   │ │ ██░░░░░░░ 23%│  │
│  │ Due: Dec 30     │ │ Due: Jan 15     │ │ Due: Feb 1   │  │
│  └─────────────────┘ └─────────────────┘ └──────────────┘  │
├─────────────────────────────────────────────────────────────┤
│  CAMPAIGN METRICS                                           │
│  Overall Completion: 87% │ Store Compliance: 94%            │
│  Avg Approval Time: 1.8d │ First-Pass Approval: 79%         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────┬───────────────────────────┐│
│  │ STORE PERFORMANCE           │ ASSET LIBRARY             ││
│  │ [Map: Store status by geo]  │ Total Assets: 1,247       ││
│  │  ● Completed   ● In-Progress│ Used This Month: 342      ││
│  │  ● Not Started ● Issues     │ Top: Logo_2024.svg (89x)  ││
│  │                             │ Expiring Soon: 12         ││
│  └─────────────────────────────┴───────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│  APPROVAL WORKFLOW                                          │
│  Pending Your Review: 7 items                               │
│  [Card view of items needing approval with thumbnails]      │
├─────────────────────────────────────────────────────────────┤
│  COST TRACKING                                              │
│  Budget: $125k  │  Spent: $87k  │  Committed: $23k          │
│  [Progress bar showing budget utilization]                  │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Displayed

#### Campaign Overview
- **Active Campaigns**: List with key stats per campaign
  - Campaign name and type
  - Store count
  - Completion percentage
  - Due date and status
- **Campaign Health**: On track, at risk, or delayed
- **Overall Completion Rate**: Across all campaigns

#### Campaign Details (per campaign)
- **Progress by Stage**: Creative → Approval → Production → Installation
- **Store Rollout**: Map showing geographic distribution and status
- **Timeline**: Gantt chart of planned vs actual
- **Budget**: Planned vs actual spend
- **Asset Usage**: Which assets used in campaign

#### Store Performance
- **Store Compliance Rate**: Meeting brand standards
- **Geographic Distribution**: Map with status indicators
  - Green: Completed
  - Yellow: In progress
  - Red: Issues or delays
  - Gray: Not started
- **Store Segmentation**: Performance by region, size, tier
- **Issue Tracking**: Stores requiring attention

#### Approval Metrics
- **Approval Cycle Time**: Average time to approve
- **First-Time Approval Rate**: Approved without changes
- **Pending Approvals**: Count awaiting your review
- **Approval Queue**: Items prioritized by urgency
- **Revision Requests**: Common reasons for rejection

#### Asset Library
- **Total Assets**: Count in library
- **Asset Usage**: Most and least used
- **Recent Uploads**: Latest additions
- **Expiring Assets**: Rights expiring soon
- **Asset Categories**: Logos, images, templates, etc.
- **Version Control**: Latest versions and history

#### Cost Tracking
- **Campaign Budget**: Allocated budget per campaign
- **Actual Spend**: Invoiced and paid amounts
- **Committed Spend**: Orders placed, not yet invoiced
- **Forecast**: Projected final cost
- **Variance**: Over/under budget analysis
- **Cost per Store**: Average implementation cost

#### Quality & Compliance
- **Brand Compliance Score**: Adherence to guidelines
- **Quality Issues**: Reported problems
- **Store Audits**: Pass/fail results
- **Photo Verification**: Proof of installation
- **Non-Compliance**: Stores needing correction

### Filters
- Campaign
- Date range
- Region/Market
- Store tier
- Status

### Interactions
- Click campaign to see detailed view
- Click store on map for store details
- Click approval item to review and approve
- Export campaign report
- Share campaign dashboard with stakeholders

### Alerts
- Campaign falling behind schedule
- Stores with compliance issues
- Approvals overdue
- Budget approaching limit

---

## Product Health Dashboard

### Audience
Product managers, engineering teams, UX researchers

### Purpose
Product usage, feature adoption, and technical health monitoring

### Refresh Frequency
Real-time for technical metrics, hourly for usage metrics

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  PRODUCT HEALTH                              Last 30 Days   │
├─────────────────────────────────────────────────────────────┤
│  ENGAGEMENT METRICS                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │   MAU    │ │   DAU    │ │ DAU/MAU  │ │  Sessions│      │
│  │   1,247  │ │    456   │ │   36.6%  │ │  8,234   │      │
│  │  ↑ 12%   │ │  ↑ 8%    │ │  ↓ 1.2%  │ │  ↑ 15%   │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
├─────────────────────────────────────────────────────────────┤
│  USER ACTIVITY TREND                                        │
│  [Line chart: DAU, WAU, MAU over 90 days]                  │
├─────────────────────────────────────────────────────────────┤
│  ┌────────────────────────┬────────────────────────────────┐│
│  │ FEATURE ADOPTION       │ TECHNICAL HEALTH               ││
│  │ Campaign Mgmt:   98%   │ Uptime:           99.97%       ││
│  │ Asset Library:   87%   │ Error Rate:       0.08%        ││
│  │ Approval Flow:   92%   │ P95 Load Time:    1.8s         ││
│  │ Analytics:       45%   │ API Success:      99.2%        ││
│  │ Mobile App:      34%   │ Failed Jobs:      12           ││
│  └────────────────────────┴────────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│  MODULE ADOPTION                                            │
│  [Stacked bar: Customers by module combination]            │
│  Core Only: 12  │  +Analytics: 18  │  +AI: 8  │  All: 7    │
├─────────────────────────────────────────────────────────────┤
│  RECENT FEEDBACK (Sorted by upvotes)                        │
│  ▲156 Bulk approval of similar items                        │
│  ▲89  Mobile app for store managers                         │
│  ▲67  Integration with Adobe Creative Cloud                 │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Displayed

#### Engagement Metrics
- **MAU**: Monthly active users with trend
- **DAU**: Daily active users with trend
- **WAU**: Weekly active users with trend
- **DAU/MAU Ratio**: Stickiness indicator
- **Sessions**: Total sessions with avg per user
- **Session Duration**: Average time per session
- **Pages per Session**: Depth of engagement

#### User Activity
- **Activity Trend**: DAU/WAU/MAU over time
- **Cohort Retention**: User retention by signup cohort
- **Power Users**: Highly engaged user count
- **Dormant Users**: Not active in 30 days
- **User Segmentation**: Activity by role, company size

#### Feature Adoption
- **Feature Usage**: Percentage using each major feature
  - Campaign management
  - Asset library
  - Approval workflows
  - Analytics/reporting
  - Mobile app
  - API/integrations
  - AI capabilities
- **Feature Trends**: Adoption over time
- **Feature Discovery**: How users find features
- **Time to Adoption**: Days from signup to feature use

#### Module Adoption
- **Module Attach Rate**: Average modules per customer
- **Module Combinations**: Common bundles
- **Module Trends**: Growth in specific modules
- **Upsell Candidates**: Customers likely to add modules
- **Module Revenue**: ARR by module

#### User Flows
- **Onboarding Funnel**: Signup → Setup → First Value
- **Critical Paths**: Success rates through key workflows
- **Drop-off Points**: Where users abandon flows
- **Conversion Rates**: Key action completion rates

#### Technical Health
- **Uptime**: Platform availability percentage
- **Error Rate**: Application errors per session
- **Page Load Time**: P50, P95, P99 load times
- **API Performance**: Response times and success rates
- **Failed Jobs**: Background job failures
- **Database Performance**: Query times and slow queries
- **Infrastructure**: Server health and resource usage

#### User Feedback
- **Feedback Volume**: Submissions per week
- **Top Requests**: Most upvoted features
- **Sentiment Analysis**: Positive/neutral/negative
- **Support Tickets**: Volume and common issues
- **NPS Comments**: Themes from NPS surveys
- **Beta Participation**: Users testing new features

#### Mobile App Metrics
- **App Downloads**: Install count
- **App MAU**: Monthly active app users
- **App Crashes**: Crash rate and top crashes
- **App Rating**: Store rating and reviews
- **App Version Adoption**: Users on latest version

### Filters
- Date range
- User segment (role, tier, etc.)
- Feature/module
- Platform (web, mobile, API)

### Interactions
- Click feature to see detailed usage analytics
- Click error to see stack trace and context
- Click feedback to see full details and discussion
- Drill into cohorts for retention analysis
- Export product metrics

### Alerts
- Error rate spike
- Performance degradation
- Feature adoption declining
- Critical user feedback
- Uptime breach

---

## Support Dashboard

### Audience
Customer support team, customer success managers

### Purpose
Support ticket management and customer health monitoring

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  SUPPORT OPERATIONS                         Live Updates    │
├─────────────────────────────────────────────────────────────┤
│  TICKET OVERVIEW                                            │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │  Open    │ │ Overdue  │ │ Avg FRT  │ │ Avg RTT  │      │
│  │    23    │ │     3    │ │  1.2h    │ │  18.5h   │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
├─────────────────────────────────────────────────────────────┤
│  MY QUEUE (Assigned to me)                                  │
│  [List: Urgent tickets requiring attention]                │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────┬───────────────────────────────┐│
│  │ TICKET TRENDS           │ CUSTOMER HEALTH               ││
│  │ [Line: Volume over 30d] │ At Risk: 3 customers          ││
│  │ Peak: Mondays 10am      │ Avg Health: 82/100            ││
│  │ Common: Login issues    │ QBRs This Week: 2             ││
│  └─────────────────────────┴───────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│  CSAT & FEEDBACK                                            │
│  Current CSAT: 4.6/5  │  Recent Feedback: "Great support!" │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Displayed

#### Ticket Metrics
- **Open Tickets**: Current open count
- **Overdue Tickets**: Past SLA
- **First Response Time**: Time to first reply
- **Resolution Time**: Time to close
- **Ticket Volume**: New tickets per day/week
- **Backlog**: Aged tickets

#### Customer Health
- **Health Score**: Composite score per customer
- **At-Risk Customers**: Low health score
- **Recent Activity**: Customer engagement
- **Upcoming QBRs**: Scheduled reviews
- **Expansion Opportunities**: Upsell candidates

#### Support Quality
- **CSAT**: Customer satisfaction score
- **First Contact Resolution**: Resolved on first interaction
- **Escalation Rate**: Tickets escalated to tier 2/3
- **Reopened Tickets**: Tickets reopened after closure

### Filters
- Ticket status
- Priority
- Customer
- Category
- Assigned agent

---

## Sales Dashboard

### Audience
Sales team, account executives, sales leadership

### Purpose
Pipeline management, quota tracking, and sales performance

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│  SALES PERFORMANCE                          Q4 2024         │
├─────────────────────────────────────────────────────────────┤
│  QUOTA ATTAINMENT                                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐      │
│  │  Quota   │ │  Closed  │ │ Progress │ │ Forecast │      │
│  │  $500k   │ │  $387k   │ │   77%    │ │  $523k   │      │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘      │
├─────────────────────────────────────────────────────────────┤
│  PIPELINE                                                   │
│  [Funnel: Lead → Qualified → Demo → Proposal → Closed]     │
│    127      45           23      12          8              │
├─────────────────────────────────────────────────────────────┤
│  TOP OPPORTUNITIES                                          │
│  [Table: Company, Value, Stage, Close Date, Probability]   │
└─────────────────────────────────────────────────────────────┘
```

### Metrics Displayed

#### Quota & Performance
- **Quota**: Assigned target
- **Closed Won**: Actual bookings
- **Progress**: Percentage to quota
- **Forecast**: Projected attainment
- **Best Case**: Optimistic scenario
- **Worst Case**: Conservative scenario

#### Pipeline Metrics
- **Pipeline Value**: Total opportunity value
- **Weighted Pipeline**: Probability-adjusted value
- **Pipeline by Stage**: Distribution across funnel
- **Pipeline Velocity**: Days in each stage
- **Conversion Rates**: Stage-to-stage conversion

#### Activity Metrics
- **Activities**: Calls, emails, meetings
- **New Leads**: This period
- **Demos Scheduled**: Upcoming demos
- **Proposals Sent**: Outstanding proposals

---

## Implementation Guidelines

### Dashboard Development Process

1. **Requirements Gathering**
   - Interview target users
   - Document key questions dashboard must answer
   - Identify required metrics and data sources

2. **Design & Mockup**
   - Create wireframes
   - Get user feedback
   - Iterate on layout and content

3. **Data Pipeline Development**
   - Build data models
   - Create transformations
   - Establish refresh schedules

4. **Dashboard Development**
   - Build in BI tool
   - Implement interactivity
   - Optimize performance

5. **Testing & Validation**
   - Verify data accuracy
   - Test performance at scale
   - User acceptance testing

6. **Rollout & Training**
   - Document dashboard usage
   - Train users
   - Collect feedback

7. **Iteration**
   - Monitor usage analytics
   - Refine based on feedback
   - Add requested features

### Technical Requirements

- **Performance**: Dashboards load in <3 seconds
- **Refresh**: Data freshness indicator on every dashboard
- **Responsiveness**: Mobile-friendly layouts
- **Export**: PDF and CSV export capabilities
- **Sharing**: Embeddable and shareable links
- **Security**: Role-based access control
- **Alerts**: Configurable threshold alerts
- **Annotations**: Ability to add notes to charts

### Accessibility

- WCAG 2.1 AA compliance
- Keyboard navigation support
- Screen reader compatibility
- Color-blind friendly palettes
- Alt text for visualizations

### Monitoring

- Track dashboard usage (views, users, time spent)
- Identify unused dashboards for deprecation
- Monitor query performance
- Collect user feedback

---

## Dashboard Roadmap

### Phase 1: Foundation (Months 1-3)
- Executive Dashboard
- PSP Operations Dashboard
- Basic Brand Dashboard

### Phase 2: Expansion (Months 4-6)
- Product Health Dashboard
- Support Dashboard
- Enhanced Brand Dashboard with approvals

### Phase 3: Advanced (Months 7-12)
- Sales Dashboard
- Custom dashboard builder
- Advanced segmentation and cohort analysis
- Embedded dashboards in application

### Phase 4: AI Enhancement (Months 13-18)
- Natural language querying
- Automated insights and anomaly detection
- Predictive dashboards
- Personalized dashboard recommendations

---

## Related Documents

- Metrics_Framework.md - Detailed metric definitions
- Data_Architecture.md - Data pipeline and infrastructure
- BI_Tool_Evaluation.md - Tool selection rationale
- AI_Insights_Roadmap.md - Advanced analytics capabilities
