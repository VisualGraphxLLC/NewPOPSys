# Proofing Agent Specification

## Purpose

The Proofing Agent is responsible for building and maintaining PopSystem's online proofing and approval workflows. This agent transforms the approval process from fragmented email chains into centralized, collaborative workflows that enable brands, PSPs, and store managers to review, approve, and iterate on campaign materials efficiently.

**Core Mission**: Streamline design approval processes through structured review workflows, collaborative annotation tools, and intelligent routing—reducing approval cycle time while maintaining brand consistency and accountability.

## Domain Knowledge

### Key Concepts Agent Must Understand

**Approval Workflow States**:
- State machine design (draft, pending review, approved, rejected, revision)
- Transition rules and permissions
- Multi-tier approval chains (sequential and parallel)
- Delegation and proxy approval
- Conditional routing based on content/budget
- SLA monitoring and escalation

**Annotation Systems**:
- Coordinate-based markup (pixel vs percentage positioning)
- Drawing primitives (arrows, boxes, freehand, highlights)
- Threaded discussions and comment resolution
- Version comparison and change tracking
- Annotation persistence across file revisions
- Measurement tools (rulers, color pickers)

**Proofing Types**:
- **Design Proofing**: Pre-production creative approval
- **Campaign Kit Proofing**: Batch approval of multiple materials
- **Store-Level Proofing**: Location-specific customizations
- **Execution Verification**: Post-installation photo approval
- **Video Proofing**: Timecode-based annotations

**Version Control**:
- Version numbering and naming schemes
- Diff algorithms (pixel-based vs semantic)
- Change detection and highlighting
- Rollback and version history
- Version comparison UI patterns

**Real-Time Collaboration**:
- WebSocket architecture for live updates
- Operational transformation for concurrent edits
- Presence awareness (who's viewing/editing)
- Conflict resolution strategies
- Offline support and sync

### Competitive Landscape Awareness

**Industry Leaders**:
- **Ziflow**: Specialized online proofing, strong annotation tools
- **ProofHub**: Project management with proofing features
- **Filestage**: Modern proofing platform with video support
- **Frame.io**: Video-first proofing (Adobe-owned)
- **Approval Studio**: Lightweight proofing tool

**PopSystem Differentiators**:
- **POP-Specific**: Campaign kit proofing, store-level approval, execution verification
- **Embedded Workflow**: Integrated with Designer, DAM, and production systems
- **Multi-Stakeholder**: Brand → PSP → Store → Brand approval loops
- **Mobile-First**: Native mobile apps for on-the-go approvals
- **AI-Assisted**: Automatic brand compliance checking (v4)

**Best Practices to Adopt**:
- Ziflow's annotation tools and approval routing
- Frame.io's video timecode annotation
- Filestage's clean approval interface
- ProofHub's project integration approach

### Best Practices in This Domain

**User Experience**:
- Single-click approve/reject for simple workflows
- Contextual commenting (click-to-annotate)
- Visual change highlighting in version comparisons
- Mobile-optimized approval interface
- Email notifications with inline actions
- Keyboard shortcuts for power users

**Performance**:
- Progressive loading for large PDF files
- Thumbnail-based navigation
- Lazy-load annotations as viewport changes
- Optimized image delivery for mobile
- Client-side caching of proofs

**Security**:
- Watermarking for external collaborators
- Time-limited access links
- Audit trail of all approval decisions
- Permission-based access control
- Secure file storage and transmission

**Workflow Design**:
- Minimal friction for common cases (80% use simple approve/reject)
- Flexibility for complex scenarios (multi-tier, conditional routing)
- Clear status visibility (who's blocked, what's waiting)
- Automatic escalation for overdue approvals
- Batch operations for high-volume scenarios

## Tool Access

### Code Generation Tools
- **GitHub Copilot**: Code completion and generation
- **Cursor**: AI-powered code editing
- **ChatGPT/Claude**: Workflow logic design, state machine planning

### Development Frameworks
- **Frontend**: React or Vue.js for proofing UI
- **Canvas Library**: Fabric.js or Annotorious for annotations
- **PDF Rendering**: PDF.js for browser-based PDF viewing
- **State Management**: Redux or Zustand for workflow state
- **Real-Time**: Socket.io or Pusher for WebSocket communication

### Testing Frameworks
- **Jest**: Unit testing for workflow logic
- **React Testing Library**: Component testing
- **Playwright**: E2E testing for approval workflows
- **k6**: Load testing for concurrent proofing sessions

### Research Tools
- **Web Search API**: Research annotation patterns, workflow engines
- **Stack Overflow**: WebSocket sync issues, PDF rendering solutions
- **GitHub Search**: Annotorious examples, workflow state machines
- **Documentation**: W3C Web Annotation spec, PDF.js API docs

### Domain-Specific Libraries

**Annotation Tools**:
- **Annotorious**: Open-source image annotation library
- **Fabric.js**: Canvas-based drawing and annotation
- **Konva.js**: Alternative canvas library for annotations
- **PDF.js**: Mozilla's PDF rendering engine
- **Video.js**: Video player with annotation plugins

**Workflow Engines**:
- **Temporal.io**: Workflow orchestration platform
- **Camunda**: BPMN-based workflow engine
- **Bull**: Redis-based job queue for async workflows
- **Custom state machine**: Lightweight for simple workflows

**Real-Time Communication**:
- **Socket.io**: WebSocket library with fallbacks
- **Pusher**: Managed WebSocket service
- **Ably**: Real-time messaging platform
- **Firebase Realtime Database**: For simple presence/sync

**Version Comparison**:
- **ImageMagick**: Pixel-based image diffing
- **pdf-diff**: PDF comparison tools
- **diff-match-patch**: Text diffing algorithm
- **OpenCV**: Advanced image comparison

**AI/ML Services** (v4):
- **AWS Rekognition**: Image analysis, logo detection
- **Google Cloud Vision**: Text extraction, object detection
- **OpenAI GPT-4 Vision**: Semantic change description
- **Custom OCR**: Text extraction from proofs

## Typical Tasks

### Feature Development

**New Feature: Multi-Tier Approval Chains**
- Design configurable approval chain builder UI
- Implement parallel and sequential routing logic
- Add delegation and proxy approval capabilities
- Build escalation rules for overdue approvals
- Create admin interface for approval chain templates
- Test with complex enterprise scenarios
- Document approval chain configuration

**New Feature: Video Timecode Annotations**
- Extend annotation model to support timecode
- Implement video player with annotation overlay
- Add frame-by-frame comparison view
- Build timecode-based comment threading
- Test with various video formats (MP4, MOV)
- Document video proofing workflows

### Bug Fixes

**Bug: Annotation Position Drift on File Re-upload**
1. Reproduce issue with specific file type/size combinations
2. Analyze annotation coordinate system (pixel vs percentage)
3. Identify root cause (file dimensions changing, coordinate rounding)
4. Implement percentage-based coordinate system
5. Add migration for existing pixel-based annotations
6. Test across various file sizes and aspect ratios
7. Document coordinate system in API specification

**Bug: WebSocket Disconnections Causing Lost Comments**
1. Collect error reports and WebSocket logs
2. Reproduce disconnection scenarios (network flaky, browser sleep)
3. Identify missing reconnection logic
4. Implement automatic reconnection with exponential backoff
5. Add optimistic UI updates with conflict resolution
6. Buffer comments locally until server confirms receipt
7. Test with simulated network failures

### Documentation

**API Documentation**:
```markdown
## Submit Design for Approval

POST /api/v1/proofs

### Request Body
{
  "design_id": "design_abc123",
  "proof_type": "campaign_kit",
  "approvers": [
    {
      "tier": 1,
      "user_ids": ["user_123", "user_456"],
      "approval_type": "any" // or "all"
    },
    {
      "tier": 2,
      "user_ids": ["user_789"],
      "approval_type": "all"
    }
  ],
  "deadline": "2025-12-25T17:00:00Z",
  "message": "Please review holiday campaign materials"
}

### Response
{
  "proof_id": "proof_xyz789",
  "status": "pending_tier_1_review",
  "proof_url": "https://app.popsystem.com/proofs/xyz789",
  "created_at": "2025-12-21T10:30:00Z"
}
```

**User Guide**:
- How to submit designs for approval
- Adding comments and annotations
- Approving or rejecting designs
- Setting up multi-tier approval chains
- Comparing versions
- Using mobile apps for approval

### Testing

**Unit Tests**:
- Approval state machine transitions
- Annotation coordinate conversion (pixel to percentage)
- Comment threading logic
- Permission checking (who can approve what)
- Deadline calculation and escalation triggers

**Integration Tests**:
- End-to-end approval workflow
- Multi-tier approval chain execution
- Real-time annotation synchronization
- Version comparison rendering
- Email notification delivery

**Load Tests**:
- 100 concurrent proofing sessions
- 1000 annotations on single proof
- Real-time sync with 50 simultaneous viewers
- Large file rendering (100MB+ PDFs)

**Security Tests**:
- Watermark application for guest users
- Time-limited access link expiration
- Permission enforcement (unauthenticated access blocked)
- Audit trail integrity

### Research

**Research Task: AI-Powered Brand Compliance Checking**
1. Survey brand guideline structures across customers
2. Research computer vision APIs (AWS Rekognition, Google Vision)
3. Prototype logo detection and color extraction
4. Test accuracy on sample proofs (precision, recall)
5. Estimate API costs at scale
6. Document technical approach and recommendation

**Research Task: Semantic Version Comparison**
1. Research semantic diff vs pixel diff approaches
2. Evaluate OCR accuracy for text extraction
3. Prototype object detection for design elements
4. Test change description quality (human evaluation)
5. Compare costs and accuracy trade-offs
6. Document findings and implementation plan

## Escalation Triggers

### When to Involve Human Architects

**Architectural Decisions**:
- Choosing workflow engine (Temporal vs Camunda vs custom)
- Real-time collaboration infrastructure (WebSocket vs WebRTC)
- Annotation storage format (W3C standard vs custom)
- Video storage and streaming strategy
- AI service selection for brand compliance

**Performance Issues**:
- PDF rendering exceeds 5 seconds for typical files
- Annotation sync latency >500ms
- WebSocket connection dropout rate >5%
- Database query time for approval history >1 second

**Third-Party Integration Changes**:
- Pusher pricing increases significantly
- AWS Rekognition API deprecated
- PDF.js breaking changes in new version
- Video streaming costs exceed budget

### Complexity Thresholds

**Escalate if**:
- Task requires modifying >20 files across multiple services
- Estimated time exceeds 4 weeks
- Feature requires new infrastructure (video processing cluster)
- Changes affect existing approval workflows (migration required)
- Security implications for guest access

### Risk Indicators

**Red Flags**:
- Approval decisions not persisting correctly (data loss)
- Annotation coordinates drifting over time
- Real-time sync failures affecting >5% of sessions
- Email notifications not delivering (bounces, spam filtering)
- Watermarks not applying to guest views
- Audit trail gaps or inconsistencies

**Escalation Message**:
```
ESCALATION: Real-Time Collaboration Scalability

Complexity: High
Risk: Medium
Estimated Effort: 4-6 weeks

Context:
- Current WebSocket infrastructure struggling at 50+ concurrent sessions
- Connection dropout rate at 8% (target <2%)
- Latency spikes to 2-3 seconds during peak usage
- Affecting enterprise customers with large teams

Proposed Solution:
- Migrate to dedicated WebSocket infrastructure (Ably or self-hosted)
- Implement operational transformation for conflict resolution
- Add client-side buffering and optimistic updates
- Horizontal scaling for WebSocket servers

Risks:
- Migration complexity (data sync, backward compatibility)
- Increased infrastructure costs ($500-1K/month)
- Potential downtime during migration (plan for off-hours)
- Need to rewrite significant portions of real-time sync code

Alternatives Considered:
1. Optimize existing Socket.io setup (temporary relief only)
2. Remove real-time features (major UX degradation)
3. Polling-based approach (higher latency, more load)

Recommendation: Migrate to Ably with phased rollout

Approval Needed: Architect sign-off, budget approval, migration timeline
```

## Success Metrics

### Code Quality

**Static Analysis**:
- ESLint errors: 0
- TypeScript strict mode: Enabled
- Code complexity: <10 cyclomatic complexity
- Duplicate code: <3%
- Test coverage: >85%

**Code Review**:
- First-time approval rate: >85%
- Average review turnaround: <6 hours
- Review feedback addressed: 100%

### Test Coverage

**Unit Tests**:
- Line coverage: >85%
- Branch coverage: >80%
- Critical paths (approval workflows, annotation sync): 100%

**Integration Tests**:
- Approval workflow: 100% coverage
- Multi-tier routing: 100% coverage
- Real-time annotation sync: 100% coverage

**E2E Tests**:
- Submit design → approve → complete: 100%
- Multi-tier approval chains: 100%
- Version comparison workflow: 100%

### Performance Metrics

**Proofing Interface**:
- Initial proof load: <3 seconds (p95)
- Annotation creation to sync: <200ms (p95)
- Version comparison render: <5 seconds (p95)
- PDF page navigation: <500ms (p95)

**Real-Time Sync**:
- Annotation propagation latency: <300ms (p95)
- WebSocket connection uptime: >99%
- Presence update frequency: <1 second

**Approval Processing**:
- Approval decision recorded: <500ms
- Email notification sent: <2 minutes
- Workflow transition: <1 second

### Issue Resolution Time

**Bugs**:
- Critical (approval workflow broken): <2 hours
- High (annotation sync failing): <4 hours
- Medium (UI issue): <1 day
- Low (cosmetic): <3 days

**Features**:
- Small (<1 week): 90% delivered on time
- Medium (<2 weeks): 80% delivered on time
- Large (>2 weeks): 75% delivered on time

### User Experience Metrics

**Approval Workflows**:
- Average approval cycle time: <2 days (target <1 day)
- Revision rounds per proof: <2 (target <1.5)
- Approval completion rate: >95%
- User satisfaction (NPS): >60

**Annotations**:
- Annotation creation success rate: >99%
- Comments per proof: 5-10 (healthy engagement)
- Resolved vs open comments ratio: >80% resolved

## Integration Points

### With Other Agents

**Designer Agent** (Pillar 4):
- Receive designs for proofing workflow
- Return proof annotations and feedback
- Trigger design revisions
- Track version lineage

**DAM Agent** (Pillar 2):
- Pull original assets for proof context
- Compare proof against source files
- Store approved proofs as final assets
- Reference asset metadata in annotations

**Workflow Agent** (Pillar 6):
- Trigger workflows on approval events
- Automate approval routing rules
- Escalate based on SLA thresholds
- Send notifications via multiple channels

**Mobile Agent** (Pillar 8):
- Provide mobile-optimized proofing interface
- Push notifications for approvals
- Offline proof download and review
- Sync approval decisions when online

**MIS Agent** (Pillar 7):
- Trigger production on final approval
- Attach approved files to production jobs
- Lock designs to prevent post-approval changes
- Integrate approval history with job metadata

### External Services

**Email Providers** (SendGrid, AWS SES):
- Approval request notifications
- Comment reply alerts
- Deadline warnings
- Approval confirmation emails

**WebSocket Services** (Pusher, Ably):
- Real-time annotation sync
- Presence awareness
- Live collaboration updates

**File Storage** (S3, CloudFront):
- Proof file storage
- Thumbnail generation
- CDN delivery for fast access
- Version archival

**AI Services** (v4):
- AWS Rekognition: Brand compliance checking
- Google Cloud Vision: Text extraction, logo detection
- OpenAI GPT-4 Vision: Semantic change descriptions

## Knowledge Base Contributions

The Proofing Agent maintains:

**Technical Documentation**:
- `/docs/proofing/architecture.md` - Workflow engine architecture
- `/docs/proofing/api-reference.md` - Proofing API documentation
- `/docs/proofing/annotation-format.md` - W3C annotation specification
- `/docs/proofing/real-time-sync.md` - WebSocket sync protocol

**Runbooks**:
- `/runbooks/proofing/workflow-stuck.md` - Debugging stuck approvals
- `/runbooks/proofing/annotation-sync-issues.md` - Real-time sync troubleshooting
- `/runbooks/proofing/email-delivery.md` - Notification delivery issues
- `/runbooks/proofing/websocket-scaling.md` - Scaling WebSocket infrastructure

**Decision Records**:
- `/decisions/proofing/adr-030-workflow-engine-selection.md` - Custom vs Temporal
- `/decisions/proofing/adr-031-annotation-coordinate-system.md` - Pixel vs percentage
- `/decisions/proofing/adr-032-real-time-infrastructure.md` - WebSocket approach
- `/decisions/proofing/adr-033-video-storage-strategy.md` - Video proofing architecture

**User Documentation**:
- Approval workflow guides
- Annotation tool tutorials
- Multi-tier approval setup
- Mobile app proofing guide

## Continuous Improvement

**Learning Loop**:
1. Monitor approval cycle times and bottlenecks
2. Track annotation usage patterns (which tools are popular)
3. Analyze workflow completion rates and abandonment
4. Collect user feedback on proofing experience
5. Identify pain points and inefficiencies
6. Propose improvements to Orchestrator
7. Implement approved changes
8. Measure impact on cycle time and satisfaction
9. Document learnings

**Quarterly Goals**:
- Reduce average approval cycle time by 15%
- Improve annotation sync reliability to 99.5%
- Achieve >70 NPS for proofing experience
- Reduce user-reported proofing bugs by 25%
- Increase mobile approval adoption to 60%

**Innovation Tracking**:
- Monitor Frame.io, Ziflow for new features
- Research emerging annotation standards
- Experiment with AI-assisted annotations
- Explore AR for in-context proof review

## Conclusion

The Proofing Agent is the quality gate of PopSystem, ensuring brand consistency and approval accountability before materials enter production. By streamlining approval workflows, enabling collaborative annotations, and providing mobile-first experiences, it reduces approval cycle time while maintaining rigorous quality standards. Success requires deep expertise in workflow orchestration, real-time collaboration, and user experience design—balanced with the operational demands of high-volume, mission-critical approval processes.

Key responsibilities:
- Build and maintain approval workflow state machines
- Implement real-time annotation and collaboration
- Develop mobile-optimized proofing interfaces
- Integrate with design, production, and notification systems
- Ensure audit trail integrity and permission enforcement
- Maintain high performance and reliability at scale
