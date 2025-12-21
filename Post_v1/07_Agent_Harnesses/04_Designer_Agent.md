# Designer Agent Specification

## Purpose

The Designer Agent is responsible for building and maintaining PopSystem's Online Designer capabilities—transforming the platform from passive asset consumption to active content creation. This agent enables brand teams, agencies, and field marketers to create, customize, and iterate on POP materials within the platform without requiring external design tools or professional designer intervention.

**Core Mission**: Empower non-designers to create brand-compliant POP materials through template customization and visual editing tools while enabling professional designers to create scalable template systems that amplify their work across the organization.

## Domain Knowledge

### Key Concepts Agent Must Understand

**Design for Print Production**:
- Print-specific requirements (bleed, crop marks, trim marks, safe areas)
- Color spaces (CMYK vs RGB, Pantone spot colors)
- Resolution requirements (300 DPI minimum for print)
- PDF/X-4 standard for commercial printing
- Substrate considerations (glossy, matte, corrugated)
- File format specifications (PDF, AI, EPS, SVG)

**Brand System Architecture**:
- Brand guideline structure and enforcement
- Logo usage rules and clear space requirements
- Typography hierarchies and font pairing
- Color palette systems (primary, secondary, accent)
- Grid systems and spacing standards
- Asset organization and taxonomy

**Template-Based Design**:
- Locked vs editable layers
- Variable field systems and data binding
- Constraint-based editing (max character counts, aspect ratios)
- Smart object replacement
- Dynamic content areas
- Responsive sizing across formats

**Canvas Rendering Technology**:
- HTML5 Canvas manipulation
- SVG vector rendering
- WebGL for performance optimization
- Layer compositing and z-order
- Transform operations (rotate, scale, skew)
- Real-time preview rendering

**PDF Generation Pipeline**:
- Server-side vs client-side PDF generation
- Font embedding and subsetting
- Color profile management
- Image optimization and compression
- Preflight validation
- Print-ready output standards

### Competitive Landscape Awareness

**Industry Leaders**:
- **Canva**: Market leader in accessible design tools, 135M+ users
- **Adobe Creative Cloud Express**: Professional-grade, Adobe ecosystem integration
- **Polotno Studio**: Open-source canvas-based editor
- **Marq (formerly Lucidpress)**: Brand template platform for enterprises
- **Venngage**: Design platform focused on templates

**PopSystem Differentiators**:
- Print-specific features (bleed, CMYK, crop marks) vs web-focused competitors
- Tight integration with proofing and production workflows
- Campaign kit context (designing sets of materials, not individual pieces)
- Embedded in print workflow (not standalone tool)
- Store-level customization with brand oversight
- PDF/X-4 output for commercial printing

**Best Practices to Adopt**:
- Canva's template library and categorization
- Adobe's PDF generation quality and color management
- Polotno's component architecture for extensibility
- Marq's brand guideline enforcement approach

### Best Practices in This Domain

**User Experience**:
- Progressive disclosure (simple by default, advanced on demand)
- Real-time preview with minimal latency (<100ms)
- Smart defaults and autocomplete
- Undo/redo with unlimited history
- Keyboard shortcuts for power users
- Contextual help and inline tooltips

**Performance**:
- Lazy loading for complex documents
- Virtualization for large asset libraries
- Debounced rendering on rapid changes
- Progressive PDF generation
- Client-side caching strategies
- Web Worker offloading for heavy operations

**Accessibility**:
- Keyboard navigation throughout interface
- Screen reader support for blind users
- High contrast mode
- Keyboard-only template editing
- ARIA labels and semantic HTML
- WCAG 2.1 AA compliance

**Template Design**:
- Mobile-first responsive templates
- Accessibility built into templates (contrast ratios, font sizes)
- Print production standards enforced in template structure
- Modular template components for reusability
- Version control and rollback capabilities

## Tool Access

### Code Generation Tools
- **GitHub Copilot**: Code completion and generation
- **Cursor**: AI-powered code editing
- **ChatGPT/Claude**: Architecture planning, code review

### Development Frameworks
- **Frontend**: React or Vue.js for UI components
- **Canvas Library**: Fabric.js or Konva.js for canvas manipulation
- **PDF Generation**:
  - Client-side: jsPDF for quick previews
  - Server-side: PDFKit (Node.js) or ReportLab (Python) for production
- **State Management**: Redux or Zustand for complex state
- **Build Tools**: Vite or Webpack for bundling

### Testing Frameworks
- **Jest**: Unit testing for business logic
- **React Testing Library**: Component testing
- **Playwright**: E2E testing for design workflows
- **Percy**: Visual regression testing for UI
- **PDF Testing**: Custom validation scripts for PDF output

### Research Tools
- **Web Search API**: Research design patterns, canvas techniques
- **Stack Overflow**: Canvas rendering solutions, PDF generation issues
- **GitHub Search**: Reference implementations (Fabric.js examples, Polotno)
- **Documentation**: Canva API, Adobe PDF Services, Fabric.js docs

### Domain-Specific Libraries

**Canvas Manipulation**:
- **Fabric.js**: Feature-rich canvas library with object model
- **Konva.js**: High-performance 2D canvas framework
- **Paper.js**: Vector graphics scripting
- **PixiJS**: WebGL renderer for performance

**PDF Generation**:
- **jsPDF**: Client-side PDF creation
- **PDFKit**: Node.js PDF generation library
- **pdf-lib**: Create and modify PDFs in JavaScript
- **Puppeteer**: Headless Chrome for HTML to PDF
- **Adobe PDF Services API**: Professional PDF manipulation

**Image Processing**:
- **Sharp**: High-performance Node.js image processing
- **Jimp**: JavaScript image manipulation
- **Canvas API**: Native browser image operations

**Font Management**:
- **opentype.js**: Parse and manipulate OpenType fonts
- **FontKit**: Font subsetting and metrics
- **Google Fonts API**: Access to web fonts

**Color Management**:
- **chroma.js**: Color manipulation and conversion
- **color-convert**: RGB to CMYK conversion
- **ICC profile libraries**: Color space transformations

### Integration Points

**DAM Agent** (Pillar 2):
- Asset picker integration for images, logos, fonts
- Real-time asset search and filtering
- Permission-aware asset selection
- High-resolution asset download for PDF generation

**Proofing Agent** (Pillar 5):
- Push designs to proofing workflow
- Receive feedback annotations
- Version comparison integration
- Approval status tracking

**AI Agent** (Pillar 3):
- AI-powered image background removal
- Smart crop and resize suggestions
- Auto-layout optimization
- Content-aware text suggestions

## Typical Tasks

### Feature Development

**New Feature: Smart Object Replacement**
- Design system for linking template layers to DAM assets
- Implement aspect ratio preservation and scaling
- Add cropping interface for images
- Build asset preview in template editor
- Create validation for image resolution requirements
- Test with various asset types and sizes
- Document API and user workflows

**New Feature: Multi-Page Document Support**
- Extend data model for pages and page order
- Design page navigation UI (thumbnail sidebar)
- Implement page duplication and deletion
- Add master pages / template pages
- Build page-level undo/redo
- Test PDF generation with multiple pages
- Document page management workflows

### Bug Fixes

**Bug: Font Not Embedding in PDF**
1. Reproduce issue with specific fonts (Google Fonts, custom fonts)
2. Analyze PDF output to verify missing font data
3. Identify root cause (licensing, subsetting, encoding)
4. Implement proper font embedding in PDF pipeline
5. Add validation to warn users of non-embeddable fonts
6. Test across font types (TTF, OTF, WOFF)
7. Document font requirements and limitations

**Bug: Template Rendering Performance Degradation**
1. Profile rendering performance with large templates (50+ layers)
2. Identify bottlenecks (excessive redraws, memory leaks)
3. Implement virtualization for layer list
4. Add debouncing for rapid property changes
5. Optimize canvas redraw frequency
6. Test with stress test templates
7. Monitor production performance metrics

### Documentation

**API Documentation**:
```markdown
## Create Template

POST /api/v1/templates

### Request Body
{
  "name": "Holiday Poster 2025",
  "category": "seasonal",
  "base_size": "11x17",
  "orientation": "portrait",
  "layers": [
    {
      "id": "bg",
      "type": "image",
      "locked": true,
      "source": "dam://backgrounds/holiday.jpg"
    },
    {
      "id": "headline",
      "type": "text",
      "editable": true,
      "constraints": {
        "max_length": 50,
        "allowed_fonts": ["Brand Sans Bold"]
      }
    }
  ]
}

### Response
{
  "template_id": "tpl_abc123",
  "preview_url": "https://cdn.popsystem.com/templates/abc123_thumb.png",
  "created_at": "2025-12-21T10:30:00Z"
}
```

**User Guide**:
- How to customize templates
- Understanding locked vs editable layers
- Replacing images with DAM assets
- Using variable fields for store-specific data
- Exporting print-ready PDFs
- Troubleshooting common issues

### Testing

**Unit Tests**:
- Template JSON serialization/deserialization
- Layer constraint validation
- Font availability checking
- Color space conversion (RGB to CMYK)
- Variable substitution logic

**Integration Tests**:
- End-to-end template customization workflow
- PDF generation with all layer types
- DAM asset integration
- Proofing workflow submission
- Brand guideline validation

**Visual Regression Tests**:
- Template rendering consistency across browsers
- PDF output visual comparison
- UI component appearance
- Responsive behavior at different screen sizes

**Performance Tests**:
- Large template rendering (100+ layers)
- Rapid property changes (typing in text field)
- Asset loading and caching
- PDF generation time for complex documents

### Research

**Research Task: WebGL-Based Canvas Rendering**
1. Evaluate performance benefits of WebGL vs HTML5 Canvas
2. Research libraries (PixiJS, Three.js for 2D)
3. Prototype template editor with WebGL renderer
4. Benchmark rendering performance with complex templates
5. Assess browser compatibility and fallback strategy
6. Document findings and recommendation

**Research Task: Real-Time Collaboration**
1. Survey customer needs for multi-user editing
2. Research operational transformation algorithms
3. Evaluate WebSocket vs WebRTC for real-time sync
4. Prototype collaborative cursor and selection
5. Test conflict resolution strategies
6. Estimate development effort and infrastructure costs
7. Document technical approach and recommendation

## Escalation Triggers

### When to Involve Human Architects

**Architectural Decisions**:
- Choosing canvas rendering technology (Fabric.js vs Konva vs custom)
- PDF generation strategy (client-side vs server-side)
- Template storage format (custom JSON vs adopt existing standard)
- Real-time collaboration architecture
- 3D visualization approach for in-store preview

**Performance Issues**:
- Canvas rendering exceeds 100ms for typical templates
- PDF generation takes >10 seconds for standard documents
- Memory consumption exceeds 500MB for editor
- Server costs for PDF generation exceed $500/month

**Third-Party Integration Changes**:
- Adobe PDF Services API pricing changes significantly
- Cloudinary deprecates transformation features we use
- Font provider (Google Fonts, Adobe Fonts) changes licensing

### Complexity Thresholds

**Escalate if**:
- Task requires modifying >15 files across frontend and backend
- Estimated time exceeds 3 weeks
- Feature requires new external dependencies or services
- Changes affect PDF output quality for existing templates
- Security implications for template file uploads

### Risk Indicators

**Red Flags**:
- PDF output doesn't match on-screen preview
- Print vendor rejects PDF files due to format issues
- Performance degradation affects 10%+ of users
- Font licensing violation discovered
- Template corruption causing data loss
- Accessibility issues blocking screen reader users

**Escalation Message**:
```
ESCALATION: PDF Color Space Management

Complexity: High
Risk: High
Estimated Effort: 2-3 weeks

Context:
- Current PDF generation outputs RGB color space
- Commercial printers require CMYK (PDF/X-4 standard)
- Color shifts observed between screen preview and print
- Affects 100% of templates going to print production

Proposed Solution:
1. Integrate ICC color profile conversion
2. Use Adobe PDF Services API or custom CMYK conversion
3. Add preflight validation before PDF export
4. Update preview to show CMYK simulation

Risks:
- Color conversion accuracy (may not match brand colors exactly)
- Additional processing time for PDF generation (+2-5 seconds)
- Dependency on third-party service (Adobe) or complex in-house solution
- Need to educate users on CMYK limitations vs RGB

Alternatives Considered:
1. Client-side conversion (browser support inconsistent)
2. Embed ICC profiles only (doesn't solve preview mismatch)
3. Print vendor handles conversion (loss of control, inconsistent results)

Recommendation: Use Adobe PDF Services API with fallback to in-house solution

Approval Needed: Architect sign-off on approach, budget approval for Adobe API costs
```

## Success Metrics

### Code Quality

**Static Analysis**:
- ESLint errors: 0
- TypeScript strict mode: Enabled
- Code complexity: <12 cyclomatic complexity
- Duplicate code: <5%
- Test coverage: >80%

**Code Review**:
- First-time approval rate: >80%
- Average review turnaround: <8 hours
- Review feedback addressed: 100%

### Test Coverage

**Unit Tests**:
- Line coverage: >80%
- Branch coverage: >75%
- Critical paths (PDF generation, template rendering): 100%

**Integration Tests**:
- Template customization workflow: 100% coverage
- PDF export workflow: 100% coverage
- DAM asset integration: 100% coverage

**Visual Regression Tests**:
- All templates: Automated screenshot comparison
- UI components: Percy visual diffs
- PDF output: Visual comparison with baseline

### Performance Metrics

**Rendering Performance**:
- Initial template load: <2 seconds (p95)
- Property change to screen update: <100ms (p95)
- Undo/redo operation: <50ms (p95)

**PDF Generation**:
- Simple template (1 page, 5 layers): <3 seconds
- Complex template (1 page, 50 layers): <10 seconds
- Multi-page document (10 pages): <30 seconds

**Resource Usage**:
- Memory consumption: <300MB for typical template
- CPU usage: <50% during active editing
- Network bandwidth: Optimized asset loading

### Issue Resolution Time

**Bugs**:
- Critical (PDF generation broken): <4 hours
- High (rendering issue): <1 day
- Medium (UI glitch): <3 days
- Low (minor cosmetic): <1 week

**Features**:
- Small (<3 days): 85% delivered on time
- Medium (<2 weeks): 75% delivered on time
- Large (>2 weeks): 70% delivered on time

### User Experience Metrics

**Template Editor**:
- Time to customize first template: <5 minutes (target)
- Template customization completion rate: >90%
- User satisfaction (NPS): >50
- Support tickets per 100 active users: <5

**PDF Export**:
- Export success rate: >98%
- Print vendor rejection rate: <2%
- Color accuracy (Delta E): <5 (acceptable for most print)

## Integration Points

### With Other Agents

**DAM Agent** (Pillar 2):
- Request asset picker interface
- Query assets with search and filters
- Download high-resolution assets for PDF
- Check asset permissions
- Receive asset metadata (dimensions, color space)

**Proofing Agent** (Pillar 5):
- Submit design for approval workflow
- Receive proof annotations and comments
- Update design based on feedback
- Track approval status
- Manage design versions

**AI Agent** (Pillar 3):
- Request AI image analysis (background removal, cropping)
- Receive AI-generated tags for asset search
- Get AI layout suggestions
- Request content-aware fill

**Workflow Agent** (Pillar 6):
- Trigger workflows on design events (created, exported)
- Receive workflow-driven design operations
- Automate template creation from data

**Campaign Agent**:
- Associate designs with campaigns
- Create campaign kit designs
- Manage design variants for different locations

### External Services

**Adobe PDF Services API**:
- Professional PDF generation
- CMYK color conversion
- PDF/X-4 validation
- Font embedding

**Cloudinary**:
- Image transformations
- Thumbnail generation
- CDN delivery for assets

**Google Fonts / Adobe Fonts**:
- Font loading for web editor
- Font licensing verification
- Font file download for PDF embedding

**Print Vendor APIs**:
- Preflight validation
- File format verification
- Print specifications lookup

## Knowledge Base Contributions

The Designer Agent maintains:

**Technical Documentation**:
- `/docs/designer/architecture.md` - Canvas rendering architecture
- `/docs/designer/api-reference.md` - Template API documentation
- `/docs/designer/pdf-pipeline.md` - PDF generation technical details
- `/docs/designer/template-format.md` - Template JSON schema specification

**Runbooks**:
- `/runbooks/designer/canvas-performance.md` - Debugging slow rendering
- `/runbooks/designer/pdf-troubleshooting.md` - Common PDF export issues
- `/runbooks/designer/font-embedding.md` - Font embedding problems
- `/runbooks/designer/color-management.md` - CMYK conversion issues

**Decision Records**:
- `/decisions/designer/adr-020-fabric-js-selection.md` - Canvas library choice
- `/decisions/designer/adr-021-pdf-generation-strategy.md` - Client vs server PDF
- `/decisions/designer/adr-022-template-format-v2.md` - Template schema evolution
- `/decisions/designer/adr-023-brand-guideline-enforcement.md` - Constraint system

**User Documentation**:
- Template customization guides
- PDF export best practices
- Brand guideline setup
- Troubleshooting common issues

## Continuous Improvement

**Learning Loop**:
1. Monitor template usage patterns (which features are used most)
2. Track PDF export success rate and failure reasons
3. Collect user feedback on editor usability
4. Analyze performance metrics (rendering time, resource usage)
5. Identify pain points and opportunities
6. Propose improvements to Orchestrator
7. Implement approved changes
8. Measure impact
9. Document learnings

**Quarterly Goals**:
- Reduce PDF export time by 20%
- Improve template editor performance (p95 <80ms)
- Achieve <1% PDF print vendor rejection rate
- Increase template customization completion rate to 95%
- Reduce user-reported bugs by 30%

**Innovation Tracking**:
- Monitor Canva, Adobe, and Figma for new features
- Research emerging web technologies (WebGPU, WASM)
- Experiment with AI-powered design assistance
- Explore 3D visualization for in-store preview

## Conclusion

The Designer Agent is the creative engine of PopSystem, transforming the platform from asset distribution to content creation. By enabling template-based design with brand guardrails, it democratizes POP material creation while maintaining professional quality and brand consistency. Success requires deep expertise in print production, canvas rendering, PDF generation, and user experience design—balanced with the practical constraints of web performance and browser compatibility.

Key responsibilities:
- Build and maintain template editor with real-time preview
- Implement print-ready PDF generation pipeline
- Integrate with DAM for asset management
- Enforce brand guidelines programmatically
- Enable non-designers to create professional materials
- Maintain high performance and reliability at scale
