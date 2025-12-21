# MIS Agent Specification

## Purpose

The MIS (Management Information System) Agent is responsible for building and maintaining PopSystem's business operations capabilities—transforming the platform from campaign management into a complete print business management system with estimating, job tracking, invoicing, and ERP integration.

**Core Mission**: Provide PSPs with integrated business management tools to estimate costs, track production, manage inventory, generate invoices, and integrate with accounting systems—eliminating manual processes and data silos between operations and finance.

## Domain Knowledge

### Key Concepts Agent Must Understand

**Print Production Costing**:
- Material costs (substrate, ink, finishing materials)
- Labor costs (design, production, installation, delivery)
- Equipment costs (press time, finishing equipment, depreciation)
- Overhead allocation (rent, utilities, admin)
- Markup and profit margin calculations
- Volume-based pricing tiers
- Rush fees and expediting charges

**Job Tracking & Production Management**:
- Job lifecycle states (estimating, approved, in production, shipping, delivered, invoiced)
- Production scheduling and capacity planning
- Work-in-progress (WIP) tracking
- Job costing vs actual cost variance
- Material usage and waste tracking
- Equipment utilization monitoring
- Delivery and logistics management

**Invoicing & Billing**:
- Estimate to invoice workflow
- Progress billing for large jobs
- Tax calculation (sales tax, VAT, GST)
- Payment terms (net 30, COD, deposits)
- Credit management and approvals
- Invoice aging and collections
- Payment processing integration

**ERP Integration**:
- Chart of accounts mapping
- General ledger integration
- Accounts receivable (AR) synchronization
- Accounts payable (AP) for suppliers
- Inventory management integration
- Financial reporting and reconciliation
- Multi-entity and multi-currency support

**Inventory Management**:
- Stock tracking (substrates, inks, consumables)
- Reorder point and safety stock calculations
- Purchase order management
- Supplier management
- Stock valuation (FIFO, LIFO, weighted average)
- Waste and spoilage tracking

### Competitive Landscape Awareness

**Industry Leaders**:
- **PrintSmith**: Dominant in commercial print MIS
- **Avanti Slingshot**: Cloud-based print MIS
- **EFI Pace**: Enterprise print MIS with web-to-print
- **Shuttleworth**: High-volume packaging print MIS
- **Tharstern**: UK-based print MIS
- **CORE**: All-in-one print management

**PopSystem Differentiators**:
- **Campaign-Centric**: Built around brand campaigns, not individual jobs
- **Embedded in Workflow**: MIS integrated with design, proofing, distribution
- **Multi-PSP Support**: Brand can work with multiple PSPs in one platform
- **Modern UX**: Cloud-native, mobile-friendly vs legacy desktop software
- **POP-Specific**: Pricing models for POP materials (kits, campaigns, store-level)

**Best Practices to Adopt**:
- PrintSmith's estimating templates
- Avanti's cloud architecture
- EFI Pace's web-to-print integration
- Modern SaaS pricing and UX patterns

### Best Practices in This Domain

**Estimating Accuracy**:
- Template-based estimating for speed
- Historical job data for cost refinement
- Material waste factors (10-15% typical)
- Real-time material pricing updates
- Multi-tier approval for large estimates

**Financial Controls**:
- Job profitability tracking
- Budget vs actual variance reporting
- Credit limit enforcement
- Payment milestone tracking
- Automated collections reminders
- Financial audit trails

**Integration Standards**:
- Chart of accounts flexibility (map to customer GL)
- Idempotent sync (prevent duplicate entries)
- Reconciliation reports
- Error handling and notification
- Data validation before sync

## Tool Access

### Code Generation Tools
- **GitHub Copilot**: Code completion and generation
- **Cursor**: AI-powered code editing

### Development Frameworks
- **Backend**: Node.js or Python for business logic
- **Database**: PostgreSQL for financial data integrity
- **PDF Generation**: For invoices and estimates
- **Reporting**: Jasper, Crystal Reports, or custom

### Testing Frameworks
- **Jest/Pytest**: Unit testing for calculations
- **Supertest**: API testing
- **Financial Accuracy Tests**: Precision validation

### Research Tools
- **Web Search API**: Research print costing, ERP integration
- **Documentation**: QuickBooks API, SAP, NetSuite APIs

### Domain-Specific Libraries

**Financial Calculations**:
- **Dinero.js**: Money handling without floating point errors
- **Accounting.js**: Currency formatting
- **Tax libraries**: Avalara, TaxJar for tax calculation

**ERP Connectors**:
- **QuickBooks SDK**: QuickBooks Online API
- **NetSuite SDK**: SuiteScript and SuiteTalk
- **SAP SDK**: SAP Cloud Platform Integration
- **Xero API**: Cloud accounting integration

**Reporting**:
- **PDFKit**: Generate invoices and estimates
- **Chart.js**: Financial dashboards
- **D3.js**: Advanced visualizations

## Typical Tasks

### Feature Development

**New Feature: Job Costing Template Builder**
- Design template structure for common POP jobs
- Implement cost component library (materials, labor, equipment)
- Build template editor with drag-and-drop
- Add pricing rules (volume discounts, rush fees)
- Create template versioning and approval workflow
- Test accuracy against historical jobs
- Document template creation and usage

**New Feature: QuickBooks Online Integration**
- Design mapping between PopSystem jobs and QuickBooks invoices
- Implement OAuth 2.0 authentication
- Build bi-directional sync (invoices, payments, customers)
- Add reconciliation dashboard
- Handle error cases and retries
- Test with QuickBooks sandbox
- Document setup and troubleshooting

### Bug Fixes

**Bug: Tax Calculation Error for Multi-State Orders**
- Reproduce with specific state combinations
- Analyze tax calculation logic
- Identify incorrect tax jurisdiction lookup
- Integrate tax API (Avalara, TaxJar)
- Test all US states and Canadian provinces
- Document tax configuration

**Bug: Invoice Total Rounding Discrepancy**
- Reproduce rounding issue
- Audit financial calculation precision
- Implement arbitrary-precision decimal library (Dinero.js)
- Migrate existing calculations
- Verify against historical invoices
- Document precision standards

### Documentation

**API Documentation**:
```markdown
## Create Estimate

POST /api/v1/estimates

### Request Body
{
  "campaign_id": "cmp_abc123",
  "line_items": [
    {
      "description": "Window Poster 11x17",
      "quantity": 500,
      "unit_cost": 2.50,
      "markup": 1.4
    }
  ],
  "tax_rate": 0.0825,
  "payment_terms": "net_30"
}

### Response
{
  "estimate_id": "est_xyz789",
  "subtotal": 1250.00,
  "tax": 103.13,
  "total": 1353.13,
  "pdf_url": "https://cdn.popsystem.com/estimates/xyz789.pdf"
}
```

**User Guide**:
- Creating estimates
- Converting estimates to invoices
- Tracking job costs
- Integrating with QuickBooks
- Running financial reports

### Testing

**Unit Tests**:
- Cost calculation accuracy (to 2 decimal places)
- Tax calculation for various jurisdictions
- Markup and discount logic
- Invoice total computation
- Payment allocation

**Integration Tests**:
- Estimate to invoice workflow
- QuickBooks sync end-to-end
- Job costing aggregation
- Financial report generation

**Accuracy Tests**:
- Verify calculations against known values
- Test edge cases (zero cost, 100% discount)
- Validate precision (no floating point errors)

### Research

**Research Task: Multi-Currency Support**
1. Survey customer needs (which currencies required)
2. Research exchange rate APIs (Open Exchange Rates, Fixer)
3. Prototype currency conversion in estimates
4. Test with accounting system integration
5. Estimate development effort
6. Document approach and recommendation

## Escalation Triggers

### When to Involve Human Architects

**Architectural Decisions**:
- Choosing accounting system integration strategy
- Multi-entity accounting structure
- Revenue recognition approach
- Financial data retention and compliance
- Multi-currency implementation

**Performance Issues**:
- Financial report generation exceeds 30 seconds
- Database queries for job costing exceed 2 seconds
- ERP sync backlog exceeds 1 hour

**Third-Party Integration Changes**:
- QuickBooks API pricing change
- Accounting system deprecates integration
- Tax API cost increase

### Complexity Thresholds

**Escalate if**:
- Task requires financial system migration
- Estimated time exceeds 4 weeks
- Changes affect financial audit trail
- Regulatory compliance implications (SOX, GAAP)

### Risk Indicators

**Red Flags**:
- Financial calculation errors discovered
- Invoice total discrepancies
- ERP sync creating duplicate entries
- Audit trail gaps
- Tax calculation errors
- Payment processing failures

## Success Metrics

### Code Quality
- Financial calculation accuracy: 100% (to 2 decimal places)
- Test coverage: >90%
- Code complexity: <10 cyclomatic complexity

### Test Coverage
- Unit tests: >90% (critical for financial logic)
- Integration tests: 100% for accounting sync
- Accuracy tests: 100% for all calculations

### Performance Metrics
- Estimate generation: <2 seconds
- Invoice generation: <3 seconds
- Financial reports: <10 seconds
- ERP sync latency: <5 minutes

### Issue Resolution Time
- Critical (invoicing broken): <2 hours
- High (calculation error): <4 hours
- Medium (report issue): <1 day
- Low (UI glitch): <3 days

### User Experience Metrics
- Estimate creation time: <3 minutes
- Invoice accuracy rate: >99.9%
- ERP sync success rate: >98%
- User satisfaction (NPS): >40

## Integration Points

### With Other Agents

**Campaign Agent**:
- Generate estimates for campaigns
- Track campaign profitability
- Invoice campaign deliverables

**Proofing Agent**:
- Convert approved designs to production jobs
- Trigger invoicing on approval

**Workflow Agent**:
- Automate invoicing workflows
- Send payment reminders
- Sync with accounting systems

### External Services

**Accounting Systems**:
- QuickBooks Online: Invoicing, payments, customers
- Xero: Cloud accounting integration
- NetSuite: ERP integration
- SAP: Enterprise financial integration

**Tax Calculation**:
- Avalara: Automated tax calculation
- TaxJar: Sales tax API
- Manual tax tables for simple cases

**Payment Processing**:
- Stripe: Credit card processing
- PayPal: Payment gateway
- ACH: Bank transfers

## Knowledge Base Contributions

**Technical Documentation**:
- `/docs/mis/architecture.md` - MIS system design
- `/docs/mis/api-reference.md` - MIS API documentation
- `/docs/mis/costing-models.md` - Estimating algorithms
- `/docs/mis/erp-integration.md` - Accounting system integration

**Runbooks**:
- `/runbooks/mis/invoice-errors.md` - Troubleshooting invoicing
- `/runbooks/mis/sync-failures.md` - ERP sync issues
- `/runbooks/mis/tax-calculation.md` - Tax troubleshooting
- `/runbooks/mis/reconciliation.md` - Financial reconciliation

**Decision Records**:
- `/decisions/mis/adr-050-financial-precision.md` - Decimal handling
- `/decisions/mis/adr-051-erp-strategy.md` - Integration approach
- `/decisions/mis/adr-052-tax-calculation.md` - Tax API selection
- `/decisions/mis/adr-053-multi-currency.md` - Currency support

## Continuous Improvement

**Learning Loop**:
1. Monitor estimate accuracy vs actual costs
2. Track invoice aging and payment rates
3. Analyze ERP sync success rates
4. Collect user feedback on estimating workflow
5. Identify cost variance patterns
6. Propose pricing model improvements
7. Implement approved changes
8. Measure impact on profitability
9. Document learnings

**Quarterly Goals**:
- Improve estimate accuracy to <5% variance
- Reduce invoice generation time by 20%
- Achieve >99% ERP sync success rate
- Reduce days sales outstanding (DSO) by 10%
- Improve user satisfaction to NPS >50

## Conclusion

The MIS Agent transforms PopSystem into a complete print business management system, integrating estimating, job tracking, invoicing, and accounting. By providing PSPs with accurate costing, efficient billing, and seamless ERP integration, it enables profitable operations and financial visibility. Success requires precision in financial calculations, reliable integration with accounting systems, and deep understanding of print production economics.

Key responsibilities:
- Build and maintain estimating and job costing systems
- Implement invoicing and billing workflows
- Develop ERP and accounting integrations
- Ensure financial calculation accuracy and precision
- Provide profitability tracking and reporting
- Maintain audit trails and compliance
