# Module Catalog
**PopSystem Platform - Complete Module Reference**

## Overview
This document provides a comprehensive catalog of all PopSystem platform modules, their capabilities, dependencies, and integration points. The modular architecture enables customers to start with core functionality and add capabilities as needed.

---

## Module Summary Table

| Module | Description | Standalone | Dependencies | Tier |
|--------|-------------|------------|--------------|------|
| Core Platform | Campaign orchestration | Required | None | Base |
| DAM | Asset management | Yes | None | Add-on |
| AI - Data | Analytics & insights | No | Core | Add-on |
| AI - Image | Image processing | Yes | DAM recommended | Add-on |
| Designer | Template editing | Yes | DAM required | Add-on |
| Proofing | Approval workflows | Yes | DAM recommended | Add-on |
| Workflow | Automation engine | Yes | Core | Add-on |
| MIS Basic | Job costing | Yes | None | Add-on |
| MIS Pro | Full ERP | Yes | MIS Basic | Add-on |
| Academy | Training/LMS | Yes | None | Add-on |
| Marketplace | Installer network | Yes | Academy recommended | Add-on |
| White-Label | Custom branding | Add-on | Any tier | Premium |

---

## Module Specifications

### 1. Core Platform
**Required Base Module**

#### Features Included
- Campaign creation and management
- Multi-location campaign orchestration
- Brand asset library (basic)
- Order management system
- Customer portal (branded)
- User management and permissions
- Reporting dashboard (standard)
- Email notifications
- API access (rate-limited)
- Mobile responsive interface
- Single sign-on (SSO) support
- Audit logging

#### API Endpoints Exposed
```
POST   /api/v1/campaigns
GET    /api/v1/campaigns/{id}
PUT    /api/v1/campaigns/{id}
DELETE /api/v1/campaigns/{id}
GET    /api/v1/campaigns/{id}/locations

POST   /api/v1/orders
GET    /api/v1/orders/{id}
PUT    /api/v1/orders/{id}/status

GET    /api/v1/users
POST   /api/v1/users
PUT    /api/v1/users/{id}

GET    /api/v1/reports/campaign-summary
GET    /api/v1/reports/order-status
```

#### Data Models
```typescript
Campaign {
  id: string
  name: string
  brandId: string
  status: CampaignStatus
  startDate: datetime
  endDate: datetime
  locations: Location[]
  assets: Asset[]
  createdBy: string
  createdAt: datetime
  updatedAt: datetime
}

Order {
  id: string
  campaignId: string
  locationId: string
  status: OrderStatus
  items: OrderItem[]
  totalAmount: decimal
  submittedAt: datetime
  completedAt: datetime
}

User {
  id: string
  email: string
  role: UserRole
  tenantId: string
  permissions: Permission[]
  lastLogin: datetime
}
```

#### Integration Points
- **Billing System**: Usage tracking, subscription management
- **Email Service**: Campaign notifications, order confirmations
- **Authentication**: OAuth2, SAML, LDAP
- **All Add-on Modules**: Core provides base services for extensions

---

### 2. DAM (Digital Asset Management)
**Standalone Add-on Module**

#### Features Included
- Centralized asset repository
- Advanced metadata management
- Version control for assets
- Smart collections and tagging
- AI-powered auto-tagging
- Asset approval workflows
- Usage rights management
- Advanced search and filters
- CDN integration
- Format conversion
- Bulk upload/download
- Asset sharing links
- Brand guidelines storage
- Asset usage analytics

#### API Endpoints Exposed
```
POST   /api/v1/dam/assets
GET    /api/v1/dam/assets/{id}
PUT    /api/v1/dam/assets/{id}
DELETE /api/v1/dam/assets/{id}
GET    /api/v1/dam/assets/search

POST   /api/v1/dam/collections
GET    /api/v1/dam/collections/{id}
POST   /api/v1/dam/collections/{id}/assets

GET    /api/v1/dam/assets/{id}/versions
POST   /api/v1/dam/assets/{id}/versions

POST   /api/v1/dam/assets/{id}/approve
POST   /api/v1/dam/assets/{id}/reject

GET    /api/v1/dam/analytics/usage
GET    /api/v1/dam/analytics/downloads
```

#### Data Models
```typescript
Asset {
  id: string
  filename: string
  fileType: string
  fileSize: number
  url: string
  cdnUrl: string
  metadata: AssetMetadata
  tags: string[]
  collections: string[]
  version: number
  approvalStatus: ApprovalStatus
  usageRights: UsageRights
  uploadedBy: string
  uploadedAt: datetime
}

AssetMetadata {
  title: string
  description: string
  keywords: string[]
  brand: string
  campaign: string
  dimensions: Dimensions
  colorProfile: string
  exifData: object
}

Collection {
  id: string
  name: string
  description: string
  assetIds: string[]
  isSmartCollection: boolean
  filterCriteria: object
  createdBy: string
}
```

#### Integration Points
- **Core Platform**: Campaign asset linking
- **Designer**: Source for template assets
- **AI - Image**: Asset processing pipeline
- **Proofing**: Asset approval workflows
- **CDN**: Asset delivery optimization

---

### 3. AI - Data
**Add-on Module (Requires Core)**

#### Features Included
- Predictive campaign analytics
- Customer behavior insights
- Demand forecasting
- Inventory optimization recommendations
- Performance anomaly detection
- Natural language reporting
- Custom dashboard builder
- A/B test analysis
- ROI attribution modeling
- Seasonal trend analysis
- Location performance scoring
- Automated report generation

#### API Endpoints Exposed
```
GET    /api/v1/ai/analytics/campaign-forecast
GET    /api/v1/ai/analytics/customer-insights
GET    /api/v1/ai/analytics/demand-prediction
GET    /api/v1/ai/analytics/performance-anomalies

POST   /api/v1/ai/reports/generate
GET    /api/v1/ai/reports/{id}

POST   /api/v1/ai/dashboards
GET    /api/v1/ai/dashboards/{id}

GET    /api/v1/ai/recommendations/inventory
GET    /api/v1/ai/recommendations/pricing
```

#### Data Models
```typescript
CampaignForecast {
  campaignId: string
  predictedOrders: number
  confidenceInterval: number
  historicalComparison: object
  seasonalFactors: object
  generatedAt: datetime
}

CustomerInsight {
  segmentId: string
  segmentName: string
  customerCount: number
  avgOrderValue: decimal
  purchaseFrequency: number
  preferredProducts: Product[]
  churnRisk: number
}

PerformanceAnomaly {
  id: string
  type: AnomalyType
  severity: string
  affectedEntity: string
  detectedAt: datetime
  description: string
  recommendedAction: string
}
```

#### Integration Points
- **Core Platform**: Campaign and order data ingestion
- **MIS**: Financial data integration
- **DAM**: Asset performance metrics
- **Workflow**: Triggered automation based on insights

---

### 4. AI - Image
**Standalone Add-on Module**

#### Features Included
- Background removal
- Image upscaling (AI-enhanced)
- Smart cropping and resizing
- Object detection and isolation
- Style transfer
- Color palette extraction
- Image quality assessment
- Brand compliance checking
- Auto-enhancement
- Batch processing
- Format optimization
- Watermark detection/removal
- Image similarity search

#### API Endpoints Exposed
```
POST   /api/v1/ai/image/background-remove
POST   /api/v1/ai/image/upscale
POST   /api/v1/ai/image/crop-smart
POST   /api/v1/ai/image/detect-objects
POST   /api/v1/ai/image/style-transfer
POST   /api/v1/ai/image/enhance

GET    /api/v1/ai/image/jobs/{id}
GET    /api/v1/ai/image/jobs/{id}/result

POST   /api/v1/ai/image/batch
GET    /api/v1/ai/image/batch/{batchId}

POST   /api/v1/ai/image/similarity-search
GET    /api/v1/ai/image/quality-score
```

#### Data Models
```typescript
ImageJob {
  id: string
  type: ImageJobType
  status: JobStatus
  inputAssetId: string
  outputAssetId: string
  parameters: object
  progress: number
  createdAt: datetime
  completedAt: datetime
}

ObjectDetection {
  jobId: string
  objects: DetectedObject[]
  confidence: number
  processingTime: number
}

DetectedObject {
  label: string
  confidence: number
  boundingBox: BoundingBox
  category: string
}

QualityScore {
  assetId: string
  overallScore: number
  sharpness: number
  exposure: number
  composition: number
  brandCompliance: number
}
```

#### Integration Points
- **DAM**: Asset input/output storage
- **Designer**: Image enhancement workflow
- **Core Platform**: Asset processing in campaigns
- **Proofing**: Quality validation step

---

### 5. Designer
**Standalone Add-on Module (Requires DAM)**

#### Features Included
- Drag-and-drop template editor
- Pre-built template library
- Custom template creation
- Variable data field mapping
- Real-time preview
- Brand lock controls
- Multi-page document support
- Font management
- Color palette enforcement
- Template versioning
- Collaborative editing
- Export to multiple formats
- Print-ready PDF generation
- Responsive design support

#### API Endpoints Exposed
```
POST   /api/v1/designer/templates
GET    /api/v1/designer/templates/{id}
PUT    /api/v1/designer/templates/{id}
DELETE /api/v1/designer/templates/{id}

POST   /api/v1/designer/templates/{id}/customize
GET    /api/v1/designer/templates/{id}/preview

POST   /api/v1/designer/export
GET    /api/v1/designer/export/{jobId}

GET    /api/v1/designer/fonts
POST   /api/v1/designer/fonts

GET    /api/v1/designer/templates/{id}/versions
POST   /api/v1/designer/templates/{id}/versions/restore
```

#### Data Models
```typescript
Template {
  id: string
  name: string
  category: string
  dimensions: Dimensions
  pages: Page[]
  variables: Variable[]
  brandLocks: BrandLock[]
  version: number
  createdBy: string
  isPublished: boolean
}

Page {
  id: string
  order: number
  elements: Element[]
  background: Background
}

Element {
  id: string
  type: ElementType
  position: Position
  properties: object
  isLocked: boolean
  variableMapping: string
}

BrandLock {
  elementId: string
  lockType: LockType
  allowedValues: any[]
}
```

#### Integration Points
- **DAM**: Asset library integration (required)
- **Core Platform**: Template selection in campaigns
- **Proofing**: Design approval workflow
- **AI - Image**: Asset enhancement integration

---

### 6. Proofing
**Standalone Add-on Module**

#### Features Included
- Multi-stage approval workflows
- Online proofing interface
- Annotation and markup tools
- Version comparison
- Approval routing rules
- Deadline tracking
- Automated reminders
- Approval history
- Role-based approvers
- Mobile proofing app
- Email notifications
- Batch approval
- Conditional routing

#### API Endpoints Exposed
```
POST   /api/v1/proofing/proofs
GET    /api/v1/proofing/proofs/{id}
PUT    /api/v1/proofing/proofs/{id}

POST   /api/v1/proofing/proofs/{id}/approve
POST   /api/v1/proofing/proofs/{id}/reject
POST   /api/v1/proofing/proofs/{id}/request-changes

POST   /api/v1/proofing/proofs/{id}/annotations
GET    /api/v1/proofing/proofs/{id}/annotations

GET    /api/v1/proofing/workflows
POST   /api/v1/proofing/workflows

GET    /api/v1/proofing/proofs/{id}/history
```

#### Data Models
```typescript
Proof {
  id: string
  assetId: string
  workflowId: string
  currentStage: number
  status: ProofStatus
  deadline: datetime
  stages: ApprovalStage[]
  createdBy: string
  createdAt: datetime
}

ApprovalStage {
  stageNumber: number
  approvers: Approver[]
  requiredApprovals: number
  status: StageStatus
  completedAt: datetime
}

Approver {
  userId: string
  status: ApprovalStatus
  approvedAt: datetime
  comments: string
}

Annotation {
  id: string
  proofId: string
  userId: string
  position: Position
  type: AnnotationType
  content: string
  createdAt: datetime
}
```

#### Integration Points
- **DAM**: Asset retrieval for proofing (recommended)
- **Designer**: Template approval workflow
- **Core Platform**: Campaign approval gates
- **Workflow**: Automated routing

---

### 7. Workflow
**Standalone Add-on Module**

#### Features Included
- Visual workflow builder
- Trigger configuration (event, schedule, manual)
- Action library (50+ pre-built)
- Conditional logic
- Loop and iteration support
- External API integration
- Error handling and retries
- Workflow templates
- Execution monitoring
- Audit trail
- Parallel execution
- Webhook support
- Custom JavaScript actions

#### API Endpoints Exposed
```
POST   /api/v1/workflow/workflows
GET    /api/v1/workflow/workflows/{id}
PUT    /api/v1/workflow/workflows/{id}
DELETE /api/v1/workflow/workflows/{id}

POST   /api/v1/workflow/workflows/{id}/execute
GET    /api/v1/workflow/executions/{id}
POST   /api/v1/workflow/executions/{id}/cancel

GET    /api/v1/workflow/actions
GET    /api/v1/workflow/triggers

POST   /api/v1/workflow/webhooks
GET    /api/v1/workflow/webhooks/{id}
```

#### Data Models
```typescript
Workflow {
  id: string
  name: string
  description: string
  trigger: Trigger
  actions: Action[]
  isActive: boolean
  createdBy: string
  lastExecuted: datetime
}

Trigger {
  type: TriggerType
  config: object
  conditions: Condition[]
}

Action {
  id: string
  type: ActionType
  config: object
  nextActions: string[]
  errorHandler: ErrorHandler
}

Execution {
  id: string
  workflowId: string
  status: ExecutionStatus
  startedAt: datetime
  completedAt: datetime
  logs: LogEntry[]
  result: object
}
```

#### Integration Points
- **Core Platform**: Campaign event triggers
- **All Modules**: Cross-module automation
- **External APIs**: Third-party integrations
- **Email Service**: Notification actions

---

### 8. MIS Basic
**Standalone Add-on Module**

#### Features Included
- Job costing and estimation
- Purchase order management
- Vendor management
- Basic inventory tracking
- Job ticketing
- Time tracking
- Invoice generation
- Payment tracking
- Profit margin analysis
- Job status dashboard
- Client billing
- Tax calculation

#### API Endpoints Exposed
```
POST   /api/v1/mis/jobs
GET    /api/v1/mis/jobs/{id}
PUT    /api/v1/mis/jobs/{id}

POST   /api/v1/mis/estimates
GET    /api/v1/mis/estimates/{id}
POST   /api/v1/mis/estimates/{id}/convert

POST   /api/v1/mis/purchase-orders
GET    /api/v1/mis/purchase-orders/{id}

GET    /api/v1/mis/vendors
POST   /api/v1/mis/vendors

POST   /api/v1/mis/invoices
GET    /api/v1/mis/invoices/{id}
POST   /api/v1/mis/invoices/{id}/send
```

#### Data Models
```typescript
Job {
  id: string
  orderId: string
  jobNumber: string
  status: JobStatus
  estimatedCost: decimal
  actualCost: decimal
  estimatedHours: number
  actualHours: number
  materials: Material[]
  labor: Labor[]
  marginPercent: number
}

Estimate {
  id: string
  estimateNumber: string
  customerId: string
  lineItems: LineItem[]
  totalAmount: decimal
  validUntil: datetime
  status: EstimateStatus
}

PurchaseOrder {
  id: string
  poNumber: string
  vendorId: string
  jobId: string
  items: POItem[]
  totalAmount: decimal
  status: POStatus
}
```

#### Integration Points
- **Core Platform**: Order-to-job conversion
- **MIS Pro**: Upgrade path
- **Accounting Systems**: QuickBooks, Xero integration

---

### 9. MIS Pro
**Standalone Add-on Module (Requires MIS Basic)**

#### Features Included
- All MIS Basic features
- Full ERP capabilities
- Advanced inventory management
- Production scheduling
- Shop floor control
- Equipment maintenance tracking
- Multi-location inventory
- Advanced reporting suite
- Financial consolidation
- GL integration
- Cost center allocation
- Capacity planning
- Material requirements planning
- Supply chain management

#### API Endpoints Exposed
```
All MIS Basic endpoints plus:

GET    /api/v1/mis-pro/production-schedule
POST   /api/v1/mis-pro/production-schedule

GET    /api/v1/mis-pro/inventory/multi-location
POST   /api/v1/mis-pro/inventory/transfer

GET    /api/v1/mis-pro/capacity-planning
POST   /api/v1/mis-pro/mrp/run

GET    /api/v1/mis-pro/gl/accounts
POST   /api/v1/mis-pro/gl/journal-entry

GET    /api/v1/mis-pro/equipment
POST   /api/v1/mis-pro/equipment/{id}/maintenance
```

#### Data Models
```typescript
ProductionSchedule {
  id: string
  jobs: ScheduledJob[]
  resources: Resource[]
  startDate: datetime
  endDate: datetime
  optimizationCriteria: string
}

ScheduledJob {
  jobId: string
  equipmentId: string
  startTime: datetime
  endTime: datetime
  setupTime: number
  runTime: number
  priority: number
}

InventoryLocation {
  id: string
  locationName: string
  items: InventoryItem[]
  reorderPoint: number
  maxQuantity: number
}

Equipment {
  id: string
  name: string
  type: string
  status: EquipmentStatus
  maintenanceSchedule: Maintenance[]
  utilizationRate: number
}
```

#### Integration Points
- **MIS Basic**: Data inheritance and extension
- **Core Platform**: Production planning integration
- **ERP Systems**: SAP, Oracle integration
- **Accounting**: Full GL sync

---

### 10. Academy
**Standalone Add-on Module**

#### Features Included
- Learning management system
- Course creation tools
- Video hosting
- Quiz and assessment builder
- Certification tracking
- Progress tracking
- Gamification (badges, points)
- Discussion forums
- Live webinar integration
- Content library
- Mobile learning app
- SCORM compliance
- Reporting and analytics

#### API Endpoints Exposed
```
GET    /api/v1/academy/courses
POST   /api/v1/academy/courses
GET    /api/v1/academy/courses/{id}

POST   /api/v1/academy/courses/{id}/enroll
GET    /api/v1/academy/courses/{id}/progress

POST   /api/v1/academy/assessments
GET    /api/v1/academy/assessments/{id}
POST   /api/v1/academy/assessments/{id}/submit

GET    /api/v1/academy/certifications
GET    /api/v1/academy/certifications/{userId}

GET    /api/v1/academy/analytics/completion-rates
```

#### Data Models
```typescript
Course {
  id: string
  title: string
  description: string
  modules: Module[]
  duration: number
  difficulty: string
  certificationId: string
  instructors: string[]
  isPublished: boolean
}

Module {
  id: string
  title: string
  order: number
  lessons: Lesson[]
  assessment: Assessment
}

Enrollment {
  id: string
  userId: string
  courseId: string
  progress: number
  startedAt: datetime
  completedAt: datetime
  certificateIssued: boolean
}

Certification {
  id: string
  name: string
  requirements: Requirement[]
  validityPeriod: number
  issuedTo: string[]
}
```

#### Integration Points
- **Core Platform**: User management sync
- **Marketplace**: Installer certification
- **Video Platforms**: Vimeo, Wistia integration
- **Zoom**: Live session integration

---

### 11. Marketplace
**Standalone Add-on Module**

#### Features Included
- Installer directory
- Capability filtering
- Rating and review system
- Availability calendar
- Quote request management
- Job matching algorithm
- Installer profiles
- Portfolio showcase
- Insurance verification
- Background check integration
- Messaging system
- Payment processing
- Performance analytics

#### API Endpoints Exposed
```
GET    /api/v1/marketplace/installers
GET    /api/v1/marketplace/installers/{id}
POST   /api/v1/marketplace/installers

POST   /api/v1/marketplace/quote-requests
GET    /api/v1/marketplace/quote-requests/{id}

POST   /api/v1/marketplace/reviews
GET    /api/v1/marketplace/reviews/installer/{id}

GET    /api/v1/marketplace/availability
POST   /api/v1/marketplace/bookings

POST   /api/v1/marketplace/matches
GET    /api/v1/marketplace/matches/{jobId}
```

#### Data Models
```typescript
Installer {
  id: string
  businessName: string
  serviceArea: GeoArea[]
  capabilities: Capability[]
  certifications: string[]
  rating: number
  reviewCount: number
  insurance: Insurance
  availability: Availability
  portfolio: PortfolioItem[]
}

QuoteRequest {
  id: string
  jobId: string
  requesterId: string
  serviceType: string
  location: Location
  deadline: datetime
  quotes: Quote[]
  status: QuoteStatus
}

Quote {
  id: string
  installerId: string
  amount: decimal
  estimatedDuration: number
  notes: string
  validUntil: datetime
  status: QuoteStatus
}

Review {
  id: string
  installerId: string
  reviewerId: string
  jobId: string
  rating: number
  comment: string
  createdAt: datetime
}
```

#### Integration Points
- **Core Platform**: Order fulfillment
- **Academy**: Certification verification
- **Payment Gateway**: Stripe, PayPal
- **Background Check**: Checkr integration

---

### 12. White-Label
**Premium Add-on (Works with Any Tier)**

#### Features Included
- Custom domain configuration
- Brand color customization
- Logo upload and placement
- Custom email templates
- Custom CSS injection
- Favicon configuration
- Loading screen branding
- Custom terminology
- Multi-brand support
- Brand asset management
- Theme preview
- Mobile app branding
- SSL certificate management

#### API Endpoints Exposed
```
GET    /api/v1/white-label/config
PUT    /api/v1/white-label/config

POST   /api/v1/white-label/themes
GET    /api/v1/white-label/themes/{id}
PUT    /api/v1/white-label/themes/{id}

POST   /api/v1/white-label/domains
GET    /api/v1/white-label/domains/{id}
DELETE /api/v1/white-label/domains/{id}

POST   /api/v1/white-label/email-templates
GET    /api/v1/white-label/email-templates/{id}
```

#### Data Models
```typescript
WhiteLabelConfig {
  tenantId: string
  domains: Domain[]
  theme: Theme
  branding: Branding
  emailTemplates: EmailTemplate[]
  terminology: Terminology
}

Theme {
  id: string
  name: string
  colors: ColorPalette
  typography: Typography
  customCSS: string
  isActive: boolean
}

Branding {
  primaryLogo: string
  secondaryLogo: string
  favicon: string
  loadingScreen: string
  loginBackground: string
}

Domain {
  domain: string
  sslCertificate: string
  status: DomainStatus
  verifiedAt: datetime
}
```

#### Integration Points
- **All Modules**: Theme application
- **DNS Providers**: Cloudflare, Route53
- **SSL Providers**: Let's Encrypt, DigiCert
- **Email Service**: Template customization

---

## Module Activation Requirements

### Technical Prerequisites
| Module | Compute | Storage | Database |
|--------|---------|---------|----------|
| Core Platform | 2 vCPU | 50 GB | 10 GB |
| DAM | 1 vCPU | 500 GB | 5 GB |
| AI - Data | 4 vCPU | 100 GB | 20 GB |
| AI - Image | 8 vCPU (GPU) | 200 GB | 5 GB |
| Designer | 2 vCPU | 50 GB | 10 GB |
| Proofing | 1 vCPU | 100 GB | 5 GB |
| Workflow | 2 vCPU | 20 GB | 10 GB |
| MIS Basic | 1 vCPU | 50 GB | 15 GB |
| MIS Pro | 2 vCPU | 100 GB | 30 GB |
| Academy | 2 vCPU | 200 GB | 10 GB |
| Marketplace | 1 vCPU | 50 GB | 10 GB |
| White-Label | Minimal | Minimal | Minimal |

### Setup Time Estimates
- **Instant Activation** (< 5 minutes): DAM, Designer, Proofing, White-Label
- **Quick Setup** (< 30 minutes): Workflow, MIS Basic, Academy, Marketplace
- **Configuration Required** (1-2 hours): AI - Data, AI - Image, MIS Pro
- **Custom Implementation** (1-5 days): Enterprise integrations, data migrations

---

## Version Compatibility Matrix

| Module | Min Platform Version | Compatible Modules | Breaking Changes |
|--------|---------------------|-------------------|------------------|
| Core Platform | v2.0+ | All | v2.0: New auth system |
| DAM | v2.0+ | All | v2.1: Metadata schema |
| AI - Data | v2.1+ | Core, MIS, DAM | v2.1: New ML models |
| AI - Image | v2.0+ | DAM, Designer | v2.2: GPU required |
| Designer | v2.0+ | DAM, Proofing | v2.0: Template format |
| Proofing | v2.0+ | DAM, Designer | None |
| Workflow | v2.1+ | All | v2.1: Action schema |
| MIS Basic | v2.0+ | Core, MIS Pro | None |
| MIS Pro | v2.1+ | MIS Basic | v2.1: GL structure |
| Academy | v2.0+ | Marketplace | None |
| Marketplace | v2.0+ | Academy | None |
| White-Label | v2.0+ | All | None |

---

## Support and Documentation

### Resources per Module
- **API Documentation**: Swagger/OpenAPI specs at `/api/docs/{module}`
- **SDK Libraries**: JavaScript, Python, PHP, .NET
- **Postman Collections**: Available for all modules
- **Video Tutorials**: Hosted in Academy module
- **Sample Code**: GitHub repository per module
- **Community Forum**: discourse.popsystem.com

### Support Tiers
- **Community**: Forum support for all modules
- **Standard**: Email support, 24-hour response
- **Premium**: Priority support, dedicated account manager
- **Enterprise**: 24/7 phone support, custom SLAs

---

## Future Roadmap

### Planned Modules (2026-2027)
- **AI - Voice**: Voice-to-order interface
- **AR Preview**: Augmented reality visualization
- **Sustainability**: Carbon tracking and reporting
- **Franchise Manager**: Multi-unit franchise tools
- **Events**: Trade show and event management
- **Mobile POS**: Point-of-sale for retail locations

### Beta Program
Customers can opt-in to beta test upcoming modules with:
- Early access (60-90 days pre-launch)
- Discounted pricing (50% off first year)
- Direct feedback channel to product team
- No long-term commitment required

---

**Document Version**: 1.0
**Last Updated**: December 2025
**Maintained By**: Product Management Team
**Review Cycle**: Quarterly
