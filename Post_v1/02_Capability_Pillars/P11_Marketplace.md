# P11: Designer/Installer Marketplace

**Capability Pillar**: Marketplace & Fulfillment Network
**Version**: 1.0
**Last Updated**: 2025-12-21
**Target Release**: v4+
**Effort Level**: XL (12-18 months)

---

## 1. Executive Summary

The Designer/Installer Marketplace represents a transformative shift in how PopSystem orchestrates POP campaign fulfillment. Moving from fixed PSP-brand relationships to an open marketplace model will unlock significant value through:

- **Increased Competition**: Multiple service providers competing for work drives better pricing and quality
- **Geographic Expansion**: Access to nationwide/global installer networks without direct contracting
- **Service Flexibility**: Brands can select providers based on specialty, price, speed, or quality ratings
- **Scalability**: Marketplace liquidity enables rapid campaign scaling without capacity constraints
- **Innovation**: Provider ecosystem drives innovation in installation techniques, materials, and services

**Vision Statement**: Create a trusted, liquid two-sided marketplace where brands seamlessly connect with verified, quality-rated fulfillment providers (designers, print vendors, installers) at competitive rates with full transparency and accountability.

**Strategic Value**:
- Differentiation from legacy POP platforms with fixed vendor relationships
- Platform business model with network effects and defensibility
- Revenue opportunities through transaction fees, premium provider listings, and value-added services
- Data-driven quality control and continuous improvement

---

## 2. Current State (v1)

### Fixed Relationship Model

PopSystem v1 operates on pre-negotiated, fixed relationships:

**Architecture**:
- PSPs have established relationships with specific brands
- Pricing negotiated in advance (contracted rates)
- Designer/installer resources allocated from PSP internal teams or preferred vendors
- Limited visibility into alternative providers
- Manual coordination for overflow or specialty work

**Limitations**:
1. **Capacity Constraints**: PSPs unable to scale beyond internal resources during peak periods
2. **Geographic Gaps**: Limited coverage in certain regions requires complex subcontracting
3. **Pricing Rigidity**: Pre-negotiated rates may not reflect market conditions or competitive options
4. **Quality Variability**: Limited feedback mechanisms for installer performance
5. **Innovation Friction**: Closed network discourages new entrants with innovative approaches
6. **Risk Concentration**: Dependence on single providers creates business continuity risks

**Current Workflow**:
```
Brand → Campaign → PSP Assignment (fixed) → PSP Internal Dispatch → Installer
                                         ↓
                                    Manual Subcontracting (as needed)
```

**Data Gaps**:
- No installer performance metrics across campaigns
- Limited pricing transparency
- No competitive benchmarking
- Manual insurance/certification verification

---

## 3. Marketplace Scope Options

### Option A: Regional Installer Network

**Scope**: Focus exclusively on installation/execution phase

**Model**:
- PSPs continue to handle design, print, and project management
- PSPs post installation jobs to marketplace with specifications
- Verified installers bid on jobs within their service areas
- Winner performs installation, uploads photo verification
- Payment released upon job completion and approval

**Participants**:
- Demand Side: PSPs, Brands (for direct-to-installer scenarios)
- Supply Side: Individual installers, small installation crews, specialized contractors

**Use Cases**:
- Retail fixture installation
- Window cling application
- Signage mounting
- Floor graphic installation
- Event setup/teardown

**Pros**:
- Narrower scope reduces complexity
- Clear value proposition for PSPs (capacity extension)
- Easier to achieve liquidity in specific markets
- Lower regulatory complexity (pure contractor model)

**Cons**:
- Limited differentiation (installation-only marketplaces exist)
- Smaller TAM than full-service model
- PSPs still bottleneck for design/print coordination

**Estimated Effort**: 9-12 months

---

### Option B: Full Service Network

**Scope**: End-to-end marketplace for design, print, and installation

**Model**:
- Brands or PSPs post campaign requirements
- Multiple provider types bid on different phases:
  - Designers submit creative concepts
  - Print vendors bid on production
  - Installers bid on execution
- Platform coordinates handoffs between phases
- Integrated quality control and payment processing

**Participants**:
- Demand Side: Brands, Agencies, PSPs
- Supply Side:
  - Freelance designers
  - Design agencies
  - Print shops (local and national)
  - Installation contractors
  - Full-service PSPs (competing on marketplace)

**Use Cases**:
- Full campaign orchestration without PSP intermediary
- PSPs sourcing specialty designers for specific brand aesthetics
- Print shops bidding competitively for high-volume runs
- Multi-phase campaigns with different specialists per phase

**Pros**:
- Maximum platform value (orchestrates entire value chain)
- Disintermediation potential (brands direct to providers)
- Richer data for quality/performance optimization
- Higher transaction volumes and revenue potential

**Cons**:
- Significant complexity in multi-phase coordination
- Harder to achieve liquidity across all provider types
- Potential conflict with existing PSP business models
- Quality control challenges across handoffs

**Estimated Effort**: 15-18 months

---

### Option C: Gig Economy Model

**Scope**: Real-time, on-demand matching for installation work

**Model**:
- Uber/TaskRabbit-style instant matching
- Installers maintain real-time availability in mobile app
- Jobs dispatched to nearest available qualified installer
- Dynamic pricing based on urgency, distance, complexity
- Instant payment upon photo verification and approval

**Participants**:
- Demand Side: PSPs, Brands, Facilities Managers
- Supply Side: Gig workers, part-time installers, specialized contractors

**Use Cases**:
- Emergency replacement installations
- Last-minute campaign launches
- One-off retail location updates
- Rapid response for damaged fixtures

**Pros**:
- Fastest time-to-execution for urgent needs
- Mobile-first experience for installers
- Real-time GPS tracking and status updates
- Simple, transparent pricing

**Cons**:
- Requires critical mass of active installers in each market
- Quality variability with gig workers
- Worker classification legal complexity (1099 vs W2)
- Limited applicability to complex, multi-day installations
- Price volatility during high-demand periods

**Estimated Effort**: 12-15 months

---

### Recommended Approach: Phased Hybrid

**Phase 1 (v4)**: Option A - Regional Installer Network
- Prove marketplace mechanics with narrowest viable scope
- Build supply-side liquidity in target metro areas
- Establish trust & safety infrastructure
- Generate performance data for quality algorithms

**Phase 2 (v5)**: Add Gig Economy Features
- Layer real-time matching onto proven installer network
- Mobile dispatch for time-sensitive jobs
- Dynamic pricing for urgent/emergency work

**Phase 3 (v6)**: Expand to Full Service Network
- Add designer marketplace
- Add print vendor marketplace
- Multi-phase coordination workflows

---

## 4. Core Marketplace Capabilities

### 4.1 Provider Profiles

**Designer Profiles**:
- Portfolio showcase (past campaign work)
- Software proficiencies (Adobe Suite, 3D rendering tools)
- Brand style specializations (luxury, QSR, automotive, etc.)
- Turnaround time commitments
- Pricing models (hourly, per concept, project-based)
- Awards/recognition
- Client testimonials

**Installer Profiles**:
- Service area (zip codes, metro areas)
- Certifications (3M Graphics Installer, electrical license, etc.)
- Equipment inventory (lifts, ladders, specialized tools)
- Crew size and availability
- Installation specialties (window clings, fixtures, electrical signage, etc.)
- Vehicle/transport capabilities
- Insurance coverage details
- Background check status
- Languages spoken

**Print Vendor Profiles**:
- Printing capabilities (offset, digital, large format, specialty)
- Materials supported (substrates, finishes)
- Production capacity (daily/weekly throughput)
- Finishing services (die-cutting, mounting, laminating)
- Turnaround time by job type
- Geographic shipping coverage
- Sustainability certifications

**Profile Verification**:
- Identity verification (SSN/EIN validation)
- Business license verification
- Insurance certificate upload and validation
- Certification document upload
- Reference checks (3+ professional references)
- Background checks (criminal, driving record for installers)
- Portfolio work verification (contact past clients)

**Profile Quality Signals**:
- Completion rate (jobs accepted vs. completed)
- On-time rate
- Quality score (from client ratings)
- Response time (to bid requests)
- Profile completeness percentage
- Years of experience
- Number of jobs completed on platform

---

### 4.2 Bidding System

**Job Posting Workflow**:
1. PSP/Brand creates job posting with specifications:
   - Scope of work (detailed requirements)
   - Location(s) with addresses
   - Timeline (start date, completion deadline)
   - Required certifications/qualifications
   - Materials provided vs. installer-sourced
   - Photo/documentation requirements
   - Budget range (optional)

2. Visibility settings:
   - Public (all qualified providers)
   - Invited-only (pre-selected providers)
   - Preferred network (past providers + public)

3. Posting duration (24-72 hours typical)

**Bidding Workflow**:
1. Providers receive notifications based on:
   - Geographic match
   - Skill/certification match
   - Availability during timeline
   - Past performance in category

2. Provider reviews job details and submits bid:
   - Total price (lump sum or itemized)
   - Proposed timeline
   - Crew composition
   - Approach/methodology notes
   - Questions/clarifications
   - Portfolio samples relevant to job

3. Automated bid validation:
   - Within budget range (if specified)
   - Timeline meets requirements
   - Provider meets qualification criteria

**Bid Evaluation Tools**:
- Side-by-side bid comparison table
- Provider quality score display
- Price vs. quality scatter plot
- Timeline Gantt chart comparison
- Auto-ranking by weighted criteria

**Award Mechanisms**:
- Manual selection (PSP chooses winner)
- Auto-award to lowest qualified bidder
- Reverse auction (declining price over time)
- Sealed bid (prices revealed only after deadline)

**Communication**:
- Q&A forum for all bidders (public clarifications)
- Private messaging with individual bidders
- Bid revision requests

---

### 4.3 Ratings & Reviews

**Multi-Dimensional Rating System**:

For Installers:
- Overall Quality (1-5 stars)
- Timeliness (1-5 stars)
- Professionalism (1-5 stars)
- Communication (1-5 stars)
- Worksite Cleanliness (1-5 stars)

For Designers:
- Creative Quality (1-5 stars)
- Brand Alignment (1-5 stars)
- Responsiveness to Feedback (1-5 stars)
- Timeliness (1-5 stars)
- Technical Skill (1-5 stars)

For Print Vendors:
- Print Quality (1-5 stars)
- Color Accuracy (1-5 stars)
- Timeliness (1-5 stars)
- Packaging/Shipping (1-5 stars)
- Customer Service (1-5 stars)

**Review Components**:
- Star ratings (required)
- Written feedback (optional but encouraged)
- Photo upload (work quality documentation)
- Would hire again? (Yes/No)
- Category tags (punctual, creative, detail-oriented, etc.)

**Review Timing**:
- Request sent automatically upon job completion
- Reminder after 3 days if not submitted
- 14-day window to submit review
- Late reviews accepted but flagged

**Review Verification**:
- Only verified job participants can review
- Cross-validation with job completion data
- Flagging system for suspicious reviews
- Dispute process for unfair reviews

**Provider Response**:
- Providers can respond to reviews (once)
- Response displayed alongside review
- Professional response encouraged for reputation

**Aggregate Metrics**:
- Overall rating (weighted by recency and job value)
- Total jobs completed
- Repeat client rate
- Response rate to reviews
- Category-specific ratings

**Review Incentives**:
- Badge for providers with >4.5 rating and 50+ jobs
- Featured placement for top-rated providers
- Discount on platform fees for highly-rated providers

---

### 4.4 Payment Processing

**Payment Architecture**: Stripe Connect (platform escrow model)

**Flow**:
1. **Job Award**: Funds placed in escrow when job awarded
2. **Milestone Payments** (for multi-phase jobs):
   - Design approval: 25%
   - Print completion: 35%
   - Installation completion: 40%
3. **Completion Verification**: Photo upload, GPS check-in, PSP approval
4. **Fund Release**: Payment released to provider account
5. **Platform Fee Deduction**: 8-12% transaction fee
6. **Provider Payout**: ACH transfer (2-3 days) or instant (1.5% fee)

**Escrow Protections**:
- Funds held until work verified
- Dispute resolution freezes payment
- Partial release for accepted milestones
- Automatic release after 7 days if no dispute filed

**Pricing Models Supported**:
- Fixed price (lump sum)
- Time & materials (hourly rate with cap)
- Per-unit pricing (per store, per fixture)
- Milestone-based

**Payment Security**:
- PCI DSS compliance via Stripe
- Two-factor authentication for payouts
- Fraud detection algorithms
- Chargeback protection for providers

**Tax Handling**:
- 1099 generation for providers (>$600/year)
- W-9 collection during onboarding
- Tax withholding for international providers
- Platform fee reporting

**Provider Payouts**:
- Standard ACH (free, 2-3 business days)
- Instant payout (1.5% fee, minutes)
- Weekly batch payouts (default)
- Minimum payout threshold: $50

**Invoicing**:
- Auto-generated invoices for completed jobs
- Itemized breakdown (labor, materials, fees)
- PDF download
- Accounting software integration (QuickBooks, Xero)

---

### 4.5 Dispute Resolution

**Dispute Categories**:
- Quality issues (work not to specification)
- Timeline delays (missed deadlines)
- No-show (provider didn't arrive)
- Scope creep (job different than posted)
- Payment disputes (amount, milestones)
- Damage claims (property damage during installation)

**Resolution Process**:

**Tier 1: Direct Resolution (0-48 hours)**
- In-app messaging between parties
- Platform provides mediation templates
- Document upload (photos, receipts)
- Suggested resolution proposals

**Tier 2: Platform Mediation (48-96 hours)**
- Assigned case manager reviews evidence
- Video call with both parties (if needed)
- Binding decision on payment/remediation
- Quality team reviews for systemic issues

**Tier 3: Arbitration (96+ hours)**
- Escalation to third-party arbitration service
- Legal review for significant claims
- Formal arbitration process
- Binding resolution

**Common Resolutions**:
- Partial refund (20-50% for minor issues)
- Full refund + find replacement provider
- Extended timeline (no penalty)
- Re-work at provider expense
- Payment from insurance (for damage claims)

**Evidence Requirements**:
- Photos/video of issue
- Communication logs
- Job specification documents
- Expert assessment (for quality disputes)

**Performance Impact**:
- Disputes flagged on provider profile
- Repeated disputes trigger quality review
- Successful resolutions noted positively
- Frivolous disputes penalize requester

**Dispute Prevention**:
- Clear job specifications template
- Pre-job photo documentation
- Milestone check-ins
- Real-time communication tools

---

### 4.6 Insurance Verification

**Required Coverage by Provider Type**:

**Installers**:
- General Liability: $1M per occurrence / $2M aggregate (minimum)
- Workers Compensation: State-required minimums for crews
- Commercial Auto: $1M for vehicle-based work
- Tools & Equipment: Optional but recommended

**Designers**:
- Professional Liability (E&O): $500K minimum
- General Liability: $500K (if on-site work)

**Print Vendors**:
- General Liability: $1M per occurrence
- Product Liability: $1M (for printed materials)
- Commercial Property: Coverage for equipment/inventory

**Verification Process**:
1. Provider uploads Certificate of Insurance (COI)
2. Automated parsing extracts:
   - Coverage types
   - Policy numbers
   - Coverage amounts
   - Effective dates
   - Insurance carrier
3. Platform verifies with insurance carrier (API or manual)
4. Quarterly re-verification
5. Renewal reminders 30 days before expiration

**Platform as Additional Insured**:
- PSPs and PopSystem added as additional insured on GL policies
- Waiver of subrogation
- 30-day cancellation notice required

**Claims Process**:
- Damage reported via dispute system
- Insurance information auto-populated
- Platform assists with claim filing
- Claim tracking dashboard

**Insurance Incentives**:
- Badge for providers with premium coverage (>$2M)
- Higher bid visibility for well-insured providers
- Reduced platform fees for comprehensive coverage

---

### 4.7 Background Checks

**Scope by Provider Type**:

**Installers** (high physical access risk):
- Criminal history (national database, 7 years)
- Sex offender registry
- Motor vehicle records (for drivers)
- Identity verification
- Work authorization verification

**Designers** (low physical risk):
- Identity verification
- Work authorization

**Print Vendors** (business entities):
- Business license verification
- EIN validation
- Better Business Bureau check

**Background Check Process**:
1. Provider consents during onboarding
2. Third-party service runs checks (Checkr, Sterling)
3. Results reviewed within 48-72 hours
4. Adverse findings trigger review:
   - Violent crimes: Automatic disqualification
   - Theft/fraud: Case-by-case review
   - DUI (installers): Recent (<3 years) disqualifies
   - Other misdemeanors: Case-by-case
5. Provider can dispute inaccurate findings

**Ongoing Monitoring**:
- Annual re-verification
- Continuous monitoring for new criminal records (opt-in)
- Immediate suspension for serious offenses

**Privacy & Compliance**:
- FCRA compliance (Fair Credit Reporting Act)
- Ban-the-box considerations (jurisdictional)
- Secure storage of background check data
- Provider access to their own records

**Badge System**:
- "Verified" badge for passed background check
- "Premium Verified" for enhanced checks with continuous monitoring

---

### 4.8 Mobile Dispatch

**Installer Mobile App Features**:

**Job Discovery**:
- Push notifications for new jobs matching profile
- Map view of available jobs by location
- Filter by pay range, date, type
- Quick bid submission from mobile

**Active Job Management**:
- Turn-by-turn navigation to job site
- Arrival check-in (GPS + time stamp)
- Digital job packet (specs, diagrams, contacts)
- Photo documentation (before/during/after)
- Real-time messaging with PSP/brand

**Time Tracking**:
- Clock in/out for hourly jobs
- Break tracking
- Auto-calculation of billable hours
- Mileage tracking

**Issue Reporting**:
- On-site issue logging (missing materials, access problems)
- Photo/video upload
- Request assistance/guidance
- Initiate dispute process

**Completion Workflow**:
- Photo verification upload (required)
- Completion checklist (digital sign-off)
- Request payment release
- Customer signature capture (if required)

**Scheduling**:
- Calendar view of awarded jobs
- Availability toggle (accept new work or not)
- Conflict detection
- Time block reservations

**Earnings Dashboard**:
- Current balance
- Payment history
- Pending payments (in escrow)
- Tax documents

**Performance Metrics**:
- Ratings summary
- Job completion stats
- Response time average
- Leaderboard (optional gamification)

---

### 4.9 GPS Tracking

**Purpose**:
- Verify installer arrival at job site
- Ensure safety (provider location known during job)
- Time tracking accuracy
- Optimize routing for multi-location jobs

**Implementation**:
- Background location tracking during active jobs (iOS/Android)
- Breadcrumb trail (location pings every 5-10 minutes)
- Geofence around job site (200-meter radius)
- Arrival/departure timestamps

**Privacy Controls**:
- Location tracking ONLY during active jobs
- Clear opt-in consent
- Provider can view their own location history
- Data retention: 90 days, then anonymized

**Use Cases**:
- Automatic arrival notification to PSP
- Proof of attendance for payment disputes
- Multi-stop route optimization
- Estimated arrival time for urgent jobs

**Integration Points**:
- Mobile app GPS API (iOS Core Location, Android Location Services)
- Backend geospatial database (PostGIS)
- Real-time dashboard for PSPs (live tracking)

---

### 4.10 Photo Verification

**Required Photos by Job Type**:

**Installation Jobs**:
- Before (empty wall/location)
- During (installation in progress, 2-3 shots)
- After (completed installation, multiple angles)
- Close-ups (detail shots showing quality)
- Wide shots (showing context/environment)

**Print Jobs**:
- Proof print (color accuracy check)
- Production run samples
- Quality control inspections
- Packaging/shipping prep

**Design Jobs**:
- Concept sketches/mockups
- Revision iterations
- Final approved designs
- Installation context renderings

**Photo Requirements**:
- Minimum resolution: 1920x1080
- EXIF data required (timestamp, GPS)
- Clear, well-lit images
- No filters or heavy editing

**Automated Validation**:
- GPS verification (photo taken at job site)
- Timestamp verification (during job window)
- Quality checks (resolution, blur detection)
- Duplicate detection

**Photo Storage**:
- Cloud storage (AWS S3, Cloudflare R2)
- Thumbnail generation for fast loading
- Full-resolution download for verification
- Long-term archival (5 years for disputes/audits)

**AI-Assisted Verification**:
- Object detection (installed fixture matches specs)
- Image similarity (before/after comparison)
- Quality scoring (sharpness, composition)
- Anomaly detection (damage, incorrect placement)

**PSP Review Workflow**:
- Receive notification when photos uploaded
- Review in dashboard (approve/reject/request more)
- Annotate photos with feedback
- Trigger payment release upon approval

---

## 5. Two-Sided Market Dynamics

### The Chicken-and-Egg Problem

**Challenge**: Providers won't join without job volume; PSPs won't use marketplace without provider liquidity.

**Cold Start Strategies**:

**Supply-Side (Provider Acquisition)**:
1. **Direct Outreach**: Recruit existing PSP installer networks to join platform
2. **Trade Show Presence**: Recruit at SGIA, ISA Sign Expo, other industry events
3. **Free Membership**: No cost to join, only fees on completed jobs (remove barrier)
4. **Seed Capital**: Offer sign-up bonuses ($100-500) for first 100 providers per market
5. **Training & Certification**: Offer free 3M/PDAA certification courses (value-add)
6. **Market Concentration**: Launch in 3-5 target metros (NYC, LA, Chicago, Atlanta, Dallas) rather than nationwide

**Demand-Side (PSP Adoption)**:
1. **Guaranteed Overflow**: Position as capacity extension, not replacement
2. **Pilot Program**: Free transaction fees for first 3 months
3. **Hybrid Model**: Allow PSPs to use internal resources or marketplace
4. **White-Label Option**: PSPs can private-label marketplace for their brands
5. **Success Stories**: Document cost savings and faster fulfillment from pilots

**Cross-Side Subsidies**:
- PSPs pay higher platform fees (12%) to subsidize provider acquisition
- Providers get discounted fees (5%) during growth phase
- Shift to balanced fees (8% each) once liquidity achieved

---

### Achieving Liquidity

**Liquidity Definition**: Sufficient supply of providers to fulfill 95%+ of posted jobs within 24 hours.

**Metrics**:
- Time-to-first-bid (target: <4 hours)
- Bid density (target: 5+ bids per job)
- Fill rate (target: 95%+ jobs awarded)
- Repeat usage (target: 60%+ PSPs post 2nd job within 30 days)

**Liquidity Tactics by Phase**:

**Phase 1 (Months 1-6): Seed Liquidity**
- Focus on single metro (e.g., NYC)
- Recruit 50+ installers across specialties
- Subsidize first 100 jobs with bonus payments
- Manual matching to ensure success

**Phase 2 (Months 7-12): Expand & Automate**
- Launch in 2 additional metros
- Build automated matching algorithms
- Introduce dynamic pricing for urgent jobs
- Provider referral program (recruit peers)

**Phase 3 (Months 13-18): Scale & Optimize**
- Nationwide coverage in top 20 metros
- 500+ active providers
- Self-sustaining liquidity (minimal subsidies)
- Advanced matching (AI-driven quality predictions)

**Liquidity Risk Mitigation**:
- Fallback to PSP internal resources if no bids
- Platform can recruit last-minute via concierge service
- Insurance policy for unfilled jobs (platform finds provider, pays premium)

---

### Network Effects Strategy

**Direct Network Effects**:
- More providers → More bid competition → Better pricing for PSPs → More jobs posted → More opportunities for providers

**Cross-Side Network Effects**:
- More PSPs → More data on installer quality → Better matching → Higher installer earnings → More providers join

**Data Network Effects**:
- More jobs → Better understanding of market pricing, timelines, quality
- Pricing prediction models improve
- Quality scoring algorithms improve
- Fraud detection improves

**Platform Moats**:
1. **Reputation Data**: Provider ratings and history not portable to competitors
2. **Payment History**: Escrow trust built over time
3. **Workflow Integration**: Embedded in PSP campaign management processes
4. **Insurance Verification**: High-friction onboarding completed

**Defensibility Timeline**:
- Year 1: Weak (easy to replicate)
- Year 2: Moderate (provider liquidity in key markets)
- Year 3+: Strong (network effects compounding, reputation data moat)

**Multi-Tenanting Risk**:
- Providers will join multiple platforms (low switching cost)
- Mitigation: Exclusive bid windows for platform-loyal providers
- Quality advantage: Our data enables better matches than competitors

---

## 6. Technical Architecture

### 6.1 Matching Algorithms

**Goal**: Optimize job-to-provider matching for quality, speed, and cost.

**Matching Factors**:
1. **Geographic Distance**: Haversine distance from provider to job site
2. **Skill Match**: Provider certifications/specialties vs. job requirements
3. **Availability**: Provider calendar availability during job timeline
4. **Quality Score**: Historical rating, completion rate, on-time rate
5. **Price Competitiveness**: Historical bid amounts vs. job budgets
6. **Response Rate**: Likelihood provider will bid (engagement score)
7. **Repeat Relationship**: Has provider worked with this PSP before?

**Matching Models**:

**Model 1: Broadcast Matching** (MVP)
- Post job to all providers meeting basic criteria (geo + skills)
- Providers self-select to bid
- Simple, transparent, requires minimal intelligence

**Model 2: Targeted Invitations** (v2)
- Rank providers by composite match score
- Invite top 20 providers to bid
- Reduces noise for providers, increases bid quality

**Model 3: Predictive Matching** (v3)
- Machine learning model predicts:
  - Probability of provider bidding
  - Predicted bid amount
  - Predicted completion quality
- Optimize invitations to maximize fill rate + quality

**Model 4: Real-Time Assignment** (Gig Economy Mode)
- No bidding, instant assignment to best available provider
- Dynamic pricing based on demand/supply balance
- Requires high provider density

**Algorithm Implementation**:
```python
# Pseudocode for Match Scoring
def calculate_match_score(job, provider):
    score = 0

    # Geographic proximity (0-30 points)
    distance_miles = haversine(job.location, provider.location)
    geo_score = max(0, 30 - distance_miles * 0.5)

    # Skill match (0-25 points)
    skill_overlap = len(job.required_skills & provider.skills)
    skill_score = min(25, skill_overlap * 8)

    # Quality rating (0-20 points)
    quality_score = provider.avg_rating * 4

    # Availability (0-15 points)
    availability_score = 15 if provider.is_available(job.timeline) else 0

    # Price competitiveness (0-10 points)
    price_score = 10 if provider.avg_bid <= job.budget else 0

    return geo_score + skill_score + quality_score + availability_score + price_score
```

**Continuous Optimization**:
- A/B testing of matching algorithms
- Track conversion rate (invitations → bids → awards → completions)
- Feedback loop from job outcomes to scoring weights

---

### 6.2 Payment Processing

**Payment Stack**: Stripe Connect (Managed Accounts)

**Architecture**:

```
PopSystem (Platform Account)
    ├── Connected Accounts (Providers)
    │   ├── Installer 1 (Stripe Express Account)
    │   ├── Installer 2 (Stripe Express Account)
    │   └── Designer 1 (Stripe Express Account)
    └── Payment Flow
        ├── PSP pays PopSystem (platform fee + provider amount)
        ├── Funds held in escrow (Stripe Balance)
        ├── Job completion verified
        └── Transfer to provider account (minus platform fee)
```

**Implementation Details**:

**Onboarding**:
- Providers complete Stripe Connect onboarding (SSN/EIN, bank account)
- Identity verification via Stripe (automated)
- Bank account micro-deposit verification
- Payout schedule configuration

**Payment Capture**:
```javascript
// Create PaymentIntent for job escrow
const paymentIntent = await stripe.paymentIntents.create({
  amount: jobAmount * 100, // cents
  currency: 'usd',
  customer: pspCustomerId,
  capture_method: 'manual', // Hold funds
  metadata: {
    job_id: '12345',
    provider_id: 'prov_789'
  }
});
```

**Escrow Hold**:
- Authorize payment on PSP payment method
- Funds reserved but not captured
- Hold for up to 7 days (Stripe limit)
- Auto-capture 24 hours before expiration if no dispute

**Fund Release**:
```javascript
// Transfer to provider account
const transfer = await stripe.transfers.create({
  amount: (jobAmount - platformFee) * 100,
  currency: 'usd',
  destination: providerStripeAccountId,
  transfer_group: `job_12345`,
  metadata: {
    job_id: '12345'
  }
});

// Capture the PaymentIntent
await stripe.paymentIntents.capture(paymentIntentId);
```

**Platform Fee Collection**:
- Deducted automatically via Stripe `application_fee_amount`
- Separate from provider payout
- Platform receives fee immediately upon capture

**Refunds & Disputes**:
- Partial refunds via Stripe Refunds API
- Dispute freezes transfer to provider
- Refund reverses transfer if already paid

**Compliance**:
- PCI DSS Level 1 (Stripe handles)
- Stripe Identity for KYC
- Automated 1099-K generation for providers (>$20K and 200 transactions)

**Alternative: PayPal for Work**:
- Similar escrow functionality
- Higher fees (3.5% vs. Stripe 2.9%)
- Broader international support

---

### 6.3 Trust & Safety Infrastructure

**Multi-Layered Approach**:

**Layer 1: Proactive Prevention**
- Identity verification (government ID upload + liveness check)
- Background checks (criminal, sex offender, MVR)
- Insurance verification
- Reference checks (3+ professional references)
- Skill certifications (3M, PDAA, etc.)

**Layer 2: Behavioral Monitoring**
- Anomaly detection:
  - Rapid account creation from same IP
  - Unusual bidding patterns (bid stuffing)
  - Review manipulation (coordinated positive reviews)
  - Payment fraud (stolen credit cards)
- Machine learning models trained on fraud signals
- Manual review queue for flagged accounts

**Layer 3: Community Enforcement**
- Rating/review system (post-job feedback)
- Report abuse functionality (harassment, unsafe work)
- Strike system (3 strikes = suspension)
- Ban appeals process

**Layer 4: Incident Response**
- 24/7 trust & safety team (outsourced initially)
- Immediate suspension for severe violations
- Law enforcement coordination for criminal activity
- Victim support (refunds, alternative providers)

**Key Risks & Mitigations**:

| Risk | Mitigation |
|------|------------|
| Fraudulent providers | Identity + background checks, insurance verification |
| Payment fraud | Stripe Radar (ML fraud detection), manual review for large jobs |
| Quality issues | Photo verification, ratings, dispute resolution |
| Safety incidents | Background checks, GPS tracking, insurance coverage |
| Review manipulation | Verified purchase requirement, ML anomaly detection |
| Account takeovers | 2FA, login anomaly detection |

**Trust & Safety Metrics**:
- Fraud rate (target: <0.5% of transactions)
- Dispute rate (target: <2% of jobs)
- Account suspension rate (target: <1% of providers)
- Average resolution time (target: <48 hours)

**Tooling**:
- Sift Science or similar fraud detection platform
- Checkr or Sterling for background checks
- Onfido or Persona for identity verification
- Internal admin dashboard for case management

---

## 7. Legal Considerations

### 7.1 Worker Classification (1099 vs. W2)

**Critical Decision**: Are marketplace providers independent contractors (1099) or employees (W2)?

**1099 Independent Contractor Model** (Recommended):

**Criteria** (IRS 20-Factor Test):
- Providers set their own rates (via bidding)
- Providers choose which jobs to bid on (no obligation)
- Providers use their own tools/equipment
- Providers can work for multiple platforms/clients
- Platform does not provide training (only certification verification)
- Platform does not set work hours or methods
- Providers run their own businesses (LLC/sole proprietor)

**Benefits**:
- No payroll taxes (15.3% FICA savings)
- No benefits obligations (health insurance, PTO)
- Scalable workforce without HR overhead
- Flexibility for providers to work when they want

**Risks**:
- Misclassification lawsuits (see Uber, Lyft legal battles)
- State-level AB5 laws (California) with stricter ABC test
- Potential for class-action lawsuits seeking back wages/benefits
- Regulatory scrutiny from DOL

**Mitigation**:
- Clear independent contractor agreements
- No platform-mandated schedules or quotas
- Providers invoice for work (not paid hourly by platform)
- Avoid excessive control over work methods
- Providers can decline jobs without penalty
- Legal review in all operating states

---

**W2 Employee Model** (Not Recommended for Marketplace):

**When Required**:
- Platform controls when/how work is performed
- Platform provides tools/equipment
- Exclusive work arrangement
- Fixed hourly wages set by platform

**Implications**:
- Payroll taxes (~15.3% additional cost)
- Workers' comp insurance (state-dependent, 1-10% of payroll)
- Unemployment insurance
- Benefits obligations (for full-time workers)
- Scheduling/HR management overhead
- Limited scalability

**Hybrid Model** (Possible but Complex):
- Core internal installers (W2) for key markets
- Marketplace overflow providers (1099) for surge/specialty
- Clear separation of responsibilities

---

### 7.2 Insurance & Liability

**Platform Liability Exposure**:

1. **Property Damage**: Installer damages client property during installation
2. **Personal Injury**: Installer injures themselves or client staff on-site
3. **Defective Work**: Installation fails, causing damage (e.g., falling sign injures customer)
4. **Data Breach**: Platform data compromised, exposing user information
5. **Professional Liability**: Platform gives bad advice, causing financial loss

**Insurance Stack**:

**Required Platform Coverage**:
- **General Liability**: $2M per occurrence / $5M aggregate
  - Covers bodily injury, property damage claims
  - Includes "failure to supervise" third parties (installers)
- **Cyber Liability**: $5M coverage
  - Data breach notification costs
  - Regulatory fines (GDPR, CCPA)
  - Business interruption
- **Errors & Omissions (E&O)**: $2M
  - Professional liability for platform operations
  - Covers negligent matching, bad advice
- **Directors & Officers (D&O)**: $3M
  - Protects leadership from shareholder lawsuits

**Provider Insurance Requirements** (see section 4.6):
- Installers: GL $1M, Workers Comp, Commercial Auto
- Designers: E&O $500K
- Print Vendors: GL $1M, Product Liability

**Indemnification Structure**:
- Providers indemnify platform for their negligent work
- Platform indemnifies PSPs for platform failures (e.g., bad background check)
- Platform does NOT indemnify for provider work quality (PSP chooses provider)

**Claims Handling**:
- Provider insurance is primary
- Platform insurance is excess/secondary
- Platform assists with claim filing but doesn't assume liability

**Annual Insurance Costs** (estimated):
- Platform coverage: $50K-$100K annually
- Provider verification overhead: $5-10 per provider

---

### 7.3 Regional Regulations

**State Licensing Requirements**:

**Contractor Licensing** (varies by state):
- California: Contractors must have state license (C-45 for signage)
- Texas: No general contractor license requirement
- New York: License required for electrical sign work
- Florida: Registered contractor or certified

**Platform Compliance**:
- Verify providers hold required licenses for their service area
- Store license numbers and expiration dates
- Block bidding on jobs requiring licenses they don't have
- Auto-reminders for license renewals

**Sales Tax Obligations**:
- Platform may have nexus in states where providers operate
- Marketplace facilitator laws (many states) make platform responsible for collecting sales tax on services
- Stripe Tax or TaxJar integration to automate

**Local Permitting**:
- Some municipalities require permits for signage installation
- Platform should inform PSPs/providers but not manage permitting
- Include permit responsibility in job specifications

**Data Privacy Regulations**:
- **GDPR** (EU): If any EU-based providers or clients
  - Data processing agreements
  - Right to erasure
  - Consent management
- **CCPA** (California): Consumer data rights
  - Privacy policy disclosure
  - Do-not-sell option
  - Data deletion requests
- **Other States**: VA, CO, CT have similar laws

**Compliance Strategy**:
- Legal review before launching in each state
- Partner with legal counsel specializing in gig economy
- Automated compliance checks (license verification, tax collection)
- Regular audits (annual)

---

## 8. FOSS & Platform Options

### 8.1 Open Source Marketplace Platforms

**Option 1: Sharetribe**

**Overview**:
- Open-source marketplace framework (Ruby on Rails)
- Designed for service/rental marketplaces
- Used by hundreds of marketplaces globally

**Features**:
- Provider profiles with portfolios
- Booking/scheduling system
- Messaging between users
- Payment processing (Stripe integration)
- Reviews/ratings
- Admin dashboard
- Customizable workflows

**Pros**:
- Mature codebase (10+ years development)
- Active community and documentation
- SaaS option (Sharetribe Go/Flex) for faster deployment
- Mobile-responsive web app (can wrap in React Native)

**Cons**:
- No native mobile apps (need custom development)
- Limited bid/auction functionality (designed for booking model)
- Self-hosting requires Rails expertise
- SaaS version has monthly fees ($79-$299/mo + transaction fees)

**Customization Effort**:
- Fork open-source version (Sharetribe Community Edition)
- Add bidding system (custom development)
- Integrate insurance verification (custom)
- Estimated: 4-6 months with 2 developers

**Cost**:
- Self-hosted: Infrastructure only ($200-500/mo AWS)
- Sharetribe Flex (headless API): $299/mo + 0.5-2% transaction fee
- Development: $150K-$250K for full customization

---

**Option 2: Arcadier**

**Overview**:
- SaaS marketplace platform
- No-code/low-code configuration
- Includes mobile apps

**Features**:
- Multi-vendor marketplace
- Escrow payments
- Commission management
- Mobile apps (iOS/Android white-label)
- Shipping/logistics
- Basic customization via dashboard

**Pros**:
- Fastest time-to-market (weeks, not months)
- Includes mobile apps out-of-box
- No development required for basic marketplace
- Handles payments, hosting, security

**Cons**:
- Limited customization (locked into platform capabilities)
- Monthly SaaS fees ($59-$599/mo + transaction fees)
- Vendor lock-in (hard to migrate away)
- May not support complex bidding workflows
- Not open-source (can't modify core code)

**Cost**:
- SaaS fees: $299/mo (mid-tier plan)
- Transaction fees: 1-3%
- Customization: Limited to platform capabilities

---

**Option 3: Custom Build (Recommended for Full Control)**

**Tech Stack**:
- **Backend**: Node.js (Express) or Python (Django/FastAPI)
- **Database**: PostgreSQL with PostGIS (geospatial queries)
- **Frontend**: React (web dashboard), React Native (mobile apps)
- **Payments**: Stripe Connect
- **File Storage**: AWS S3 or Cloudflare R2
- **Background Jobs**: Redis + Bull/Celery
- **Search**: Elasticsearch for provider search
- **Real-time**: WebSockets (Socket.io) for messaging

**Architecture**:
```
┌─────────────────┐      ┌─────────────────┐
│  React Web App  │      │ React Native    │
│  (PSP/Brand)    │      │ (Provider App)  │
└────────┬────────┘      └────────┬────────┘
         │                        │
         └────────────┬───────────┘
                      │ REST API / GraphQL
                ┌─────▼──────┐
                │  Node.js   │
                │  Backend   │
                └─────┬──────┘
         ┌────────────┼────────────┐
         │            │            │
    ┌────▼───┐   ┌───▼────┐  ┌────▼────┐
    │ Postgres│   │ Redis  │  │ Stripe  │
    │ +PostGIS│   │(cache) │  │ Connect │
    └─────────┘   └────────┘  └─────────┘
```

**Pros**:
- Complete customization freedom
- No vendor lock-in or ongoing platform fees
- Optimized for PopSystem-specific workflows
- Can integrate deeply with existing campaign management system

**Cons**:
- Longest development time (12-18 months)
- Requires strong in-house or contracted development team
- Ongoing maintenance burden
- Security responsibility (PCI, data protection)

**Development Phases**:
1. **Phase 1 (Months 1-4)**: Core marketplace (profiles, job posting, bidding)
2. **Phase 2 (Months 5-8)**: Payments, ratings, disputes
3. **Phase 3 (Months 9-12)**: Mobile apps, GPS tracking, photo verification
4. **Phase 4 (Months 13-15)**: Trust & safety, insurance verification, background checks
5. **Phase 5 (Months 16-18)**: Advanced matching algorithms, analytics

**Cost**:
- Development team: 3 full-stack engineers, 1 mobile engineer, 1 DevOps
- Estimated cost: $500K-$750K (full build)
- Ongoing: $30K-$50K/mo (hosting, maintenance, support)

---

### Recommendation

**Short-term (v4 Pilot)**: Sharetribe Flex
- Launch faster with proven platform
- Validate marketplace demand with minimal investment
- Accept limitations on bidding/matching
- Cost: $50K-$100K customization + $299/mo SaaS

**Long-term (v5+)**: Custom Build
- Migrate from Sharetribe once product-market fit proven
- Full feature set (bidding, advanced matching, mobile dispatch)
- Platform IP ownership
- Cost: $500K+ development

---

## 9. Phase Roadmap

### Phase 1: v4 Foundation (Months 1-6)

**Scope**: Regional installer network in 1-2 pilot markets

**Deliverables**:
- Provider onboarding (profiles, insurance, background checks)
- Job posting & bidding system (manual matching)
- Basic rating/review system
- Stripe Connect payment processing
- Admin dashboard for marketplace management

**Target Markets**:
- Primary: New York Metro
- Secondary: Los Angeles

**Success Metrics**:
- 50+ verified installers onboarded
- 100+ jobs posted
- 90%+ fill rate
- 4.0+ average provider rating

**Team**:
- 2 full-stack engineers
- 1 product manager
- 1 designer
- Contract legal counsel

**Budget**: $150K

---

### Phase 2: v4.5 Optimization (Months 7-12)

**Scope**: Expand to 5 markets, optimize matching

**Deliverables**:
- Automated matching algorithms (targeted invitations)
- Dispute resolution workflows
- Provider mobile app (MVP)
- Photo verification system
- Advanced analytics dashboard

**New Markets**:
- Chicago
- Atlanta
- Dallas

**Success Metrics**:
- 200+ verified providers
- 500+ jobs completed
- 95%+ fill rate
- <24 hour time-to-first-bid
- 2% dispute rate

**Team**:
- Add 1 mobile engineer
- Add 1 data scientist (matching algorithms)

**Budget**: $200K

---

### Phase 3: v5 Designer Marketplace (Months 13-18)

**Scope**: Add designer network and print vendor network

**Deliverables**:
- Designer profiles & portfolios
- Design project workflows (concepts, revisions, approval)
- Print vendor capabilities database
- Multi-phase job coordination
- Integrated proofing/approval tools

**Success Metrics**:
- 100+ designers onboarded
- 50+ print vendors onboarded
- 200+ design projects completed
- End-to-end campaigns (design→print→install) via marketplace

**Team**:
- Add 1 backend engineer (multi-phase workflows)
- Add 1 designer marketplace specialist (operations)

**Budget**: $250K

---

### Phase 4: v6 Gig Economy Features (Months 19-24)

**Scope**: Real-time matching and mobile-first experience

**Deliverables**:
- Real-time job dispatch (instant matching)
- Advanced mobile app (GPS tracking, push notifications)
- Dynamic pricing algorithms
- Provider availability scheduling
- Heat maps (supply/demand visualization)

**Success Metrics**:
- <30 minute time-to-match for urgent jobs
- 500+ active providers across 20 markets
- 60%+ mobile app engagement (providers using app for all jobs)

**Team**:
- Add 1 mobile engineer
- Add 1 DevOps engineer (real-time infrastructure)

**Budget**: $300K

---

### Total Investment: $900K over 24 months

---

## 10. Effort Estimate

### Development Effort

**Custom Build Estimate** (Full marketplace, all features):

| Component | Effort (Engineer-Months) | Cost @ $15K/mo |
|-----------|-------------------------|----------------|
| Core Marketplace (profiles, jobs, bidding) | 8 | $120K |
| Payment Processing (Stripe integration, escrow) | 4 | $60K |
| Ratings & Reviews | 2 | $30K |
| Dispute Resolution | 3 | $45K |
| Provider Verification (insurance, background checks) | 4 | $60K |
| Mobile Apps (iOS + Android) | 10 | $150K |
| GPS Tracking & Photo Verification | 3 | $45K |
| Matching Algorithms | 4 | $60K |
| Admin Dashboard | 4 | $60K |
| Trust & Safety Infrastructure | 3 | $45K |
| Testing, QA, DevOps | 6 | $90K |
| **Total** | **51 EM** | **$765K** |

**Timeline**: 12-18 months with team of 3-4 engineers

---

### Operational Effort

**Pre-Launch**:
- Legal review (worker classification, terms of service): $25K
- Insurance policy setup: $10K
- Provider recruitment (marketing, outreach): $50K
- Content creation (training materials, FAQs): $15K

**Ongoing** (per month):
- Trust & safety team (outsourced): $5K
- Customer support (providers + PSPs): $3K
- Insurance costs: $8K
- Background check services: $2K (variable)
- Infrastructure (AWS, Stripe fees): $5K

**Annual Operational Cost**: ~$300K

---

### Total Cost to Launch

| Category | Cost |
|----------|------|
| Development (18 months) | $765K |
| Pre-launch operational | $100K |
| First-year ongoing operational | $300K |
| **Total (Year 1-1.5)** | **$1.165M** |

**Effort Classification**: **XL**
- 12-18 month development timeline
- 3-4 person engineering team
- Significant operational complexity (trust & safety, legal, insurance)
- Requires ongoing marketplace management and optimization

---

## 11. Key Decisions Needed

### Strategic Decisions

1. **Marketplace Scope** (Required by: Pre-Development)
   - Decision: Option A (Installers), B (Full Service), or C (Gig Economy)?
   - Recommendation: Start with Option A, expand to B/C in later phases
   - Impact: Determines development scope and go-to-market strategy

2. **Build vs. Buy** (Required by: Pre-Development)
   - Decision: Custom build vs. Sharetribe vs. Arcadier?
   - Recommendation: Sharetribe Flex for pilot, custom build for scale
   - Impact: $150K vs. $750K development cost, 6 months vs. 18 months timeline

3. **Geographic Strategy** (Required by: Pre-Launch)
   - Decision: Nationwide launch vs. metro-by-metro?
   - Recommendation: Launch in 2 pilot metros, expand to 20 over 24 months
   - Impact: Easier to achieve liquidity with focused launch

4. **Worker Classification** (Required by: Pre-Launch)
   - Decision: 1099 independent contractors vs. W2 employees?
   - Recommendation: 1099 with strong legal safeguards
   - Impact: 15%+ cost savings but legal risk

---

### Product Decisions

5. **Bidding Model** (Required by: Design Phase)
   - Decision: Open bidding, sealed bid, reverse auction, or instant matching?
   - Recommendation: Start with open bidding, add instant matching in v6
   - Impact: User experience, time-to-fill, pricing dynamics

6. **Fee Structure** (Required by: Launch)
   - Decision: Transaction fee percentage, who pays, tiered pricing?
   - Recommendation: 8-12% transaction fee paid by PSP, 3-5% by provider
   - Impact: Revenue model, provider/PSP adoption

7. **Quality Control** (Required by: Design Phase)
   - Decision: Pre-screen all providers or open enrollment with ratings?
   - Recommendation: Pre-screening for v4, expand to ratings-based in v5
   - Impact: Launch speed vs. quality assurance

8. **Payment Terms** (Required by: Stripe Integration)
   - Decision: Escrow release timing, milestone payments, instant payout fees?
   - Recommendation: Escrow with 7-day auto-release, instant payout option (1.5% fee)
   - Impact: Cash flow for providers, risk mitigation for PSPs

---

### Technical Decisions

9. **Mobile Strategy** (Required by: Architecture Phase)
   - Decision: Native apps, React Native, or mobile web?
   - Recommendation: React Native for cross-platform development
   - Impact: Development speed, app performance, GPS accuracy

10. **Matching Algorithm** (Required by: v4 Development)
    - Decision: Manual matching, rules-based, or ML-based?
    - Recommendation: Rules-based for v4, ML for v5+
    - Impact: Time-to-hire, match quality, development complexity

11. **Payment Provider** (Required by: Pre-Development)
    - Decision: Stripe Connect, PayPal for Work, or custom?
    - Recommendation: Stripe Connect
    - Impact: Fee structure (2.9% + $0.30), international support, feature set

---

### Operational Decisions

12. **Provider Verification Depth** (Required by: Launch)
    - Decision: Basic (identity only) vs. Full (background + insurance)?
    - Recommendation: Full verification for installers, basic for designers
    - Impact: Onboarding friction, safety/quality assurance

13. **Trust & Safety Approach** (Required by: Launch)
    - Decision: In-house team vs. outsourced?
    - Recommendation: Outsource initially (Taskrabbit Trust & Safety as model)
    - Impact: $5K-$10K/mo cost, faster launch

14. **Dispute Resolution** (Required by: Design Phase)
    - Decision: Platform-mediated vs. third-party arbitration?
    - Recommendation: Platform-mediated for <$5K disputes, arbitration for larger
    - Impact: Customer satisfaction, legal risk, operational burden

---

### Go-to-Market Decisions

15. **Launch Partners** (Required by: 6 months pre-launch)
    - Decision: Which PSPs to pilot with?
    - Recommendation: 2-3 mid-size PSPs with regional focus
    - Impact: Credibility, feedback quality, early adoption

16. **Provider Recruitment** (Required by: 3 months pre-launch)
    - Decision: Direct outreach, paid ads, trade shows, referrals?
    - Recommendation: Multi-channel (direct + trade shows + referrals)
    - Budget: $50K for initial recruitment

17. **Pricing Strategy** (Required by: Launch)
    - Decision: Launch pricing (discounted) vs. target pricing?
    - Recommendation: Free for first 3 months, then 8% fee
    - Impact: Adoption rate, early revenue

---

## Appendix A: Comparable Marketplaces

**TaskRabbit** (Gig Economy Model):
- On-demand handyman/installation services
- Real-time matching via mobile app
- Background checks, insurance requirements
- 15%+ service fee

**Thumbtack** (Bidding Model):
- Service provider marketplace (broad categories)
- Providers pay per lead (bid on jobs)
- Reviews/ratings system
- Weaker trust & safety than TaskRabbit

**Fiverr/Upwork** (Freelance Platforms):
- Designer/creative freelance marketplaces
- Fixed-price and hourly engagements
- Escrow payment system
- 5-20% platform fees

**Fieldwire** (Construction Management):
- Not a marketplace, but workflow tool for field teams
- Mobile-first with GPS, photo verification
- Relevant UX patterns for installer app

---

## Appendix B: Risk Register

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Failure to achieve liquidity | Medium | High | Metro-by-metro launch, provider subsidies |
| Worker misclassification lawsuits | Medium | High | Legal review, clear 1099 safeguards |
| Quality/safety incidents | Medium | Medium | Background checks, insurance, ratings |
| PSP resistance (cannibalization fear) | High | Medium | Position as capacity extension, hybrid model |
| Payment fraud | Low | Medium | Stripe Radar, manual review for large jobs |
| Data breach | Low | High | Penetration testing, SOC 2 compliance |
| Competitive response | Medium | Medium | Speed to liquidity, network effects moat |
| Regulatory changes (AB5-style laws) | Medium | High | Monitor legislation, legal reserves |

---

## Appendix C: Success Metrics Dashboard

**Provider Metrics**:
- Active providers (weekly active users)
- Provider retention (% still active after 90 days)
- Average jobs per provider per month
- Provider earnings (median monthly)
- Provider NPS

**Demand Metrics**:
- Jobs posted per week
- Fill rate (% jobs awarded)
- Time-to-first-bid (hours)
- Repeat posting rate (% PSPs posting 2+ jobs)
- PSP NPS

**Marketplace Health**:
- Liquidity score (bids per job)
- Match rate (% invitations → bids)
- Completion rate (% awarded jobs completed)
- Dispute rate (% jobs disputed)
- Average rating (provider quality)

**Financial Metrics**:
- GMV (Gross Merchandise Value - total job value)
- Take rate (platform fee %)
- Revenue (GMV × take rate)
- CAC (Customer Acquisition Cost - provider and PSP)
- LTV (Lifetime Value - repeat transactions)

---

**Document End**

---

**Next Steps**:
1. Review with leadership and secure strategic direction decision (Option A/B/C)
2. Conduct legal review of worker classification in target markets
3. Evaluate build vs. buy (schedule demos of Sharetribe, Arcadier)
4. Identify 2-3 pilot PSP partners for v4 launch
5. Draft detailed technical architecture document (if custom build)
6. Begin provider recruitment strategy planning (outreach lists, messaging)

**Document Owner**: Product Strategy Team
**Review Cycle**: Quarterly (marketplace metrics and roadmap adjustments)
