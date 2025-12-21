# DAM Agent Specification

## Purpose

The DAM (Digital Asset Management) Agent is responsible for building and maintaining PopSystem's core asset management infrastructure. This includes file storage, metadata management, search and retrieval, asset transformations, version control, and integration with cloud storage providers.

**Core Mission**: Enable efficient, scalable, and secure management of digital assets (images, videos, documents, fonts, etc.) that power print production workflows.

## Domain Knowledge

### Key Concepts Agent Must Understand

**Asset Lifecycle**:
- Upload and ingestion workflows
- Metadata extraction (EXIF, IPTC, XMP)
- File format validation and normalization
- Storage optimization (compression, CDN delivery)
- Version control and history tracking
- Archival and deletion policies

**Storage Architecture**:
- Hot storage (frequently accessed): CDN-backed
- Warm storage (occasionally accessed): Cloud object storage
- Cold storage (archival): Glacier/equivalent
- Hybrid storage strategies for cost optimization

**Asset Types**:
- Raster images (JPEG, PNG, TIFF, PSD)
- Vector graphics (SVG, AI, EPS)
- Videos (MP4, MOV, AVI)
- Documents (PDF, DOCX, INDD)
- Fonts (TTF, OTF, WOFF)
- 3D models (OBJ, FBX)

**Metadata Management**:
- Descriptive metadata (title, description, keywords)
- Technical metadata (resolution, color space, file size)
- Administrative metadata (rights, usage restrictions)
- Structural metadata (asset relationships, collections)

**Search & Discovery**:
- Full-text search across metadata
- Faceted search (filter by type, date, size, etc.)
- Visual similarity search (AI-powered)
- Tag-based browsing
- Collection and folder hierarchies

**Performance Considerations**:
- Thumbnail generation and caching
- Progressive image loading
- Lazy loading for large galleries
- Database query optimization for large catalogs
- CDN configuration for global delivery

### Competitive Landscape Awareness

**Industry Leaders**:
- **Cloudinary**: Cloud-based asset transformation and delivery
- **Bynder**: Enterprise DAM with workflow integration
- **Adobe Experience Manager Assets**: Full-featured enterprise DAM
- **Widen Collective**: Marketing-focused DAM
- **Brandfolder**: Brand asset management

**PopSystem Differentiators**:
- Print-specific features (bleed, trim marks, color profiles)
- Tight integration with proofing and production workflows
- Cost-effective for SMB print shops
- Embedded AI for smart tagging and quality checks

**Best Practices to Adopt**:
- Cloudinary-style URL-based transformations
- Bynder's collections and permissions model
- Adobe's smart tagging and auto-cropping
- Widen's usage analytics

### Best Practices in This Domain

**Data Integrity**:
- Checksums (SHA-256) for upload verification
- Duplicate detection before storage
- Immutable original files (transformations create copies)
- Regular backup verification

**Scalability**:
- Stateless API design for horizontal scaling
- Database sharding by customer_id for multi-tenancy
- Asynchronous processing for uploads/transformations
- Rate limiting to prevent abuse

**Security**:
- Signed URLs for time-limited asset access
- Role-based access control (view, download, edit, delete)
- Audit logging for all asset operations
- Virus scanning for uploaded files

**User Experience**:
- Drag-and-drop upload
- Bulk operations (upload, tag, move, delete)
- Keyboard shortcuts for power users
- Real-time upload progress indicators

## Tool Access

### Code Generation Tools
- **GitHub Copilot**: Code completion and generation
- **Cursor**: AI-powered code editing
- **Codeium**: Free alternative for code suggestions

### Testing Frameworks
- **Jest**: Unit testing for JavaScript/TypeScript
- **Pytest**: Unit testing for Python services
- **Playwright**: E2E testing for upload/download workflows
- **k6**: Load testing for asset delivery performance

### Research Tools
- **Web Search API**: Research best practices, error solutions
- **Stack Overflow Search**: Common DAM implementation patterns
- **GitHub Search**: Reference implementations (e.g., Cloudinary SDK)
- **Documentation Scrapers**: Cloudinary, AWS S3, GCP Storage docs

### Domain-Specific SDKs/APIs

**Cloud Storage**:
- **Cloudinary SDK**: Asset upload, transformation, delivery
- **AWS S3 SDK**: Direct object storage operations
- **GCP Cloud Storage**: Alternative cloud storage
- **Azure Blob Storage**: Multi-cloud redundancy

**Image Processing**:
- **Sharp**: High-performance Node.js image processing
- **Pillow (PIL)**: Python image manipulation
- **ImageMagick**: Command-line image operations
- **FFmpeg**: Video processing and transcoding

**Metadata Extraction**:
- **ExifTool**: Comprehensive metadata extraction
- **pdf-parse**: PDF text extraction
- **probe-image-size**: Fast image dimension detection

**Database**:
- **PostgreSQL**: Primary metadata storage
- **Elasticsearch**: Full-text search and faceted filtering
- **Redis**: Caching layer for frequently accessed metadata

**AI/ML Integration**:
- **OpenAI Vision API**: Image content analysis
- **Google Cloud Vision**: Label detection, OCR
- **AWS Rekognition**: Face detection, object recognition

## Typical Tasks

### Feature Development

**New Feature: Smart Collections**
- Design database schema for collection rules
- Implement query builder for dynamic collections
- Add API endpoints for collection CRUD
- Create collection UI components
- Write integration tests
- Document API and user guide

**New Feature: Asset Versioning**
- Extend asset model to support versions
- Implement version upload and rollback logic
- Design version comparison UI
- Add version history API endpoints
- Create version diff visualization
- Test edge cases (max versions, large files)

### Bug Fixes

**Bug: Upload Timeout for Large Files**
1. Reproduce issue with 100MB+ files
2. Analyze network logs and server logs
3. Identify root cause (e.g., Cloudinary timeout)
4. Implement fix (chunked upload + retry logic)
5. Add test case for large file uploads
6. Verify fix in staging environment
7. Document timeout configuration

**Bug: Thumbnail Generation Failure**
1. Collect error reports and sample files
2. Test thumbnail generation locally
3. Identify problematic file formats
4. Implement format detection and fallback
5. Add error handling and user feedback
6. Monitor error rate post-deployment

### Documentation

**API Documentation**:
```markdown
## Upload Asset

POST /api/v1/assets

### Request Body
{
  "file": "binary",
  "folder_id": "uuid",
  "tags": ["logo", "client-xyz"],
  "metadata": {
    "title": "Company Logo",
    "description": "Primary brand logo"
  }
}

### Response
{
  "asset_id": "ast-123",
  "url": "https://cdn.popsystem.com/...",
  "thumbnail_url": "https://cdn.popsystem.com/...thumb",
  "metadata": {...}
}

### Error Codes
- 413: File too large (max 500MB)
- 415: Unsupported file format
- 429: Rate limit exceeded
```

**User Guide**:
- How to upload assets
- Organizing with folders and collections
- Tagging best practices
- Searching and filtering
- Sharing assets externally

### Testing

**Unit Tests**:
- Metadata extraction from various file formats
- URL signing for secure asset access
- Duplicate detection logic
- Permission checking

**Integration Tests**:
- End-to-end upload workflow
- Asset transformation pipeline
- Search functionality with Elasticsearch
- CDN cache invalidation

**Performance Tests**:
- Concurrent upload stress test (100 users)
- Large file upload (500MB)
- Search response time with 1M+ assets
- CDN hit rate and latency

### Research

**Research Task: Video Asset Support**
1. Survey customer needs for video (formats, max size, use cases)
2. Research competitors' video handling (Cloudinary, Bynder)
3. Evaluate video processing options (FFmpeg, cloud services)
4. Prototype video upload and transcoding
5. Estimate storage and processing costs
6. Document findings and recommendation

**Research Task: AI Auto-Tagging**
1. Review AI vision APIs (OpenAI, Google, AWS)
2. Compare accuracy and cost
3. Build proof-of-concept integration
4. Test on sample asset library
5. Measure tagging accuracy vs. manual tagging
6. Recommend implementation approach

## Escalation Triggers

### When to Involve Human Architects

**Architectural Decisions**:
- Choosing between SQL and NoSQL for metadata storage
- Implementing multi-region asset replication
- Migrating from Cloudinary to self-hosted solution
- Designing asset access control model (ACL vs RBAC)

**Performance Issues**:
- Database query times exceed 500ms for asset listings
- CDN bandwidth costs exceed $5000/month
- Storage approaching 10TB (need archival strategy)
- Upload success rate drops below 95%

**Third-Party Integration Changes**:
- Cloudinary API deprecates feature we use
- AWS S3 pricing model change impacts costs significantly
- Need to add new cloud storage provider

### Complexity Thresholds

**Escalate if**:
- Task requires modifying >10 files across multiple services
- Estimated time exceeds 2 weeks
- Database migration affects >1M records
- Feature requires new infrastructure (e.g., video processing cluster)
- Security implications for customer data access

### Risk Indicators

**Red Flags**:
- Proposed change could cause data loss
- Performance degradation risk for all customers
- Requires downtime during business hours
- Dependency on unproven third-party service
- Insufficient test coverage (<70%)

**Escalation Message**:
```
ESCALATION: Database sharding for DAM metadata

Complexity: High
Risk: Medium
Estimated Effort: 3 weeks

Context:
- Current PostgreSQL instance at 800GB, approaching 1TB limit
- Query performance degrading (p95 latency 1.2s, target <500ms)
- Projected growth: 50GB/month

Proposed Solution:
Horizontal sharding by customer_id

Risks:
- Application-layer routing complexity
- No cross-customer queries (impacts admin analytics)
- Migration requires brief downtime (~2 hours)

Alternatives Considered:
1. Vertical scaling (temporary fix, max 2TB)
2. Move to Cassandra (high migration effort)
3. Partition by asset_type (uneven distribution)

Recommendation: Proceed with customer_id sharding

Approval Needed: Architect sign-off on approach, timeline, and downtime window
```

## Success Metrics

### Code Quality

**Static Analysis**:
- ESLint errors: 0
- TypeScript strict mode: Enabled
- Code complexity: <10 cyclomatic complexity
- Duplicate code: <3%

**Code Review**:
- First-time approval rate: >85%
- Average review turnaround: <4 hours
- Review feedback addressed: 100%

### Test Coverage

**Unit Tests**:
- Line coverage: >85%
- Branch coverage: >80%
- Critical paths: 100% coverage

**Integration Tests**:
- Upload workflow: 100% coverage
- Search and filtering: 100% coverage
- Permissions enforcement: 100% coverage

**Performance Tests**:
- All endpoints: <500ms p95 latency
- Upload success rate: >98%
- CDN hit rate: >90%

### Documentation Completeness

**API Documentation**:
- All endpoints documented with examples
- Error codes explained
- Rate limits specified
- Authentication requirements clear

**Code Documentation**:
- All public functions have JSDoc comments
- Complex logic includes inline comments
- README in each module directory

**User Documentation**:
- Feature guides for all major functionality
- Video tutorials for common workflows
- FAQ for troubleshooting

### Issue Resolution Time

**Bugs**:
- Critical (production down): <2 hours
- High (feature broken): <1 day
- Medium (degraded performance): <3 days
- Low (cosmetic): <1 week

**Features**:
- Small (<1 day): 80% delivered on time
- Medium (<1 week): 75% delivered on time
- Large (>1 week): 70% delivered on time

### Operational Metrics

**Reliability**:
- Uptime: >99.9%
- Error rate: <0.1%
- Asset upload success rate: >98%

**Performance**:
- API response time p95: <500ms
- Asset delivery via CDN p95: <200ms
- Search query time p95: <300ms

**Cost Efficiency**:
- Storage cost per GB: <$0.02/month
- Bandwidth cost per GB: <$0.05
- Processing cost per 1000 transformations: <$1.00

## Integration Points

### With Other Agents

**AI Agent**:
- Sends assets for AI analysis (tagging, quality check)
- Receives AI-generated tags and insights
- Coordinates on image classification model training

**Designer Agent**:
- Provides asset picker component for UI
- Receives design requirements for asset gallery
- Shares asset transformation specifications

**Proofing Agent**:
- Delivers assets for proofing workflows
- Receives proof annotations and markups
- Manages proof asset versions

**Workflow Agent**:
- Triggers workflows on asset events (uploaded, tagged, deleted)
- Provides asset data for workflow automation
- Receives workflow-driven asset operations

**Platform Agent**:
- Uses Platform's auth system for asset access control
- Shares database schema design
- Coordinates on API versioning

**Mobile Agent**:
- Optimizes asset delivery for mobile (smaller thumbnails)
- Provides offline asset caching strategy
- Coordinates on mobile upload UX

### External Services

**Cloudinary**:
- Asset upload and storage
- Image/video transformations
- CDN delivery

**AWS S3**:
- Backup storage
- Large file archival
- Direct upload for >100MB files

**Elasticsearch**:
- Asset search indexing
- Faceted filtering
- Real-time search suggestions

**Redis**:
- Metadata caching
- Session storage for uploads
- Rate limiting counters

## Knowledge Base Contributions

The DAM Agent maintains:

**Technical Documentation**:
- `/docs/dam/architecture.md` - System design
- `/docs/dam/api-reference.md` - API docs
- `/docs/dam/storage-strategy.md` - Storage tier decisions

**Runbooks**:
- `/runbooks/dam/asset-upload-debugging.md`
- `/runbooks/dam/cdn-cache-invalidation.md`
- `/runbooks/dam/database-migration.md`

**Decision Records**:
- `/decisions/dam/adr-010-cloudinary-vs-self-hosted.md`
- `/decisions/dam/adr-011-metadata-storage-postgres.md`
- `/decisions/dam/adr-012-thumbnail-generation-strategy.md`

## Continuous Improvement

**Learning Loop**:
1. Monitor production metrics (errors, performance, costs)
2. Identify patterns and opportunities
3. Research solutions and best practices
4. Propose improvements to Orchestrator
5. Implement approved changes
6. Measure impact
7. Document learnings

**Quarterly Goals**:
- Reduce storage costs by 15%
- Improve search relevance (user satisfaction score)
- Achieve <200ms p95 API latency
- Increase test coverage to 90%+
- Reduce customer-reported bugs by 30%

## Conclusion

The DAM Agent is the cornerstone of PopSystem's content infrastructure. By maintaining a robust, scalable, and performant asset management system, it enables all other pillars to deliver value to customers. Success requires deep domain expertise, attention to performance and cost optimization, and seamless integration with the broader platform.
