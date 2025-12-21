# Context Management: Memory, RAG, and Knowledge Sharing

## Overview

This document defines how PopSystem AI agents maintain context, share knowledge, and leverage collective memory to improve performance over time. Effective context management enables agents to work efficiently, learn from experience, and coordinate across the platform.

**Purpose**: Establish standards for agent memory systems, retrieval-augmented generation (RAG), and knowledge base management to ensure agents have the right context at the right time while avoiding information overload and stale data.

---

## Context Management Architecture

### Three-Layer Context Model

```
┌─────────────────────────────────────────────────────────┐
│                  Layer 1: Immediate Context             │
│  (Working Memory - Current Task, Recent History)        │
│                   Token Window: 100K-200K               │
└─────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│                Layer 2: Session Context                 │
│  (Conversation History, Task Queue, Agent State)        │
│              Storage: Redis (ephemeral, 24h TTL)        │
└─────────────────────────────────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│               Layer 3: Long-Term Memory                 │
│  (Knowledge Base, Code Corpus, Historical Decisions)    │
│         Storage: Vector DB + PostgreSQL (persistent)    │
└─────────────────────────────────────────────────────────┘
```

---

## Layer 1: Immediate Context (Working Memory)

### Purpose
Provide agents with the most relevant information for the current task within their token window.

### Components

**1. Current Task Context**
- Task description and requirements
- Related code files (Read tool output)
- Recent conversation history (last 10-20 exchanges)
- Error messages and logs (if debugging)

**2. Codebase Context**
- Active files being modified
- Related modules and dependencies
- Recent commits affecting current work
- Code patterns and conventions

**3. Documentation Context**
- Relevant API documentation
- Architecture decision records (ADRs)
- Runbooks for current task domain
- User stories and acceptance criteria

### Token Budget Management

**Token Allocation** (for 200K token window):
- Current conversation: 20K tokens (10%)
- Code files: 80K tokens (40%)
- Documentation: 40K tokens (20%)
- Retrieved context (RAG): 40K tokens (20%)
- Response generation: 20K tokens (10%)

**Prioritization Rules**:
1. Current task description and requirements: Always included
2. Files being modified: Always included (truncated if >50K tokens)
3. Related documentation: High priority
4. Historical context: Medium priority (summarized if needed)
5. Tangential information: Low priority (excluded if token pressure)

**Context Compression Techniques**:
- Summarize long code files (keep signatures, docstrings, critical logic)
- Extract key points from documentation
- Truncate conversation history (keep recent + summary of earlier)
- Remove redundant information (don't repeat already-read files)

---

## Layer 2: Session Context (Short-Term Memory)

### Purpose
Maintain state and context across multiple interactions within a session (workday).

### Storage: Redis (In-Memory)

**Key-Value Structure**:
```json
{
  "session_id": "sess_20251221_designer_001",
  "agent_id": "designer_agent",
  "started_at": "2025-12-21T08:00:00Z",
  "current_task": {
    "task_id": "task_abc123",
    "description": "Implement PDF color space conversion",
    "status": "in_progress",
    "files_modified": ["pdf_generator.ts", "color_utils.ts"],
    "context_summary": "Working on CMYK conversion using Adobe API"
  },
  "conversation_history": [
    {
      "timestamp": "2025-12-21T08:15:00Z",
      "role": "user",
      "content": "Fix the PDF color space issue"
    },
    {
      "timestamp": "2025-12-21T08:16:00Z",
      "role": "assistant",
      "content": "I'll implement CMYK conversion..."
    }
  ],
  "working_memory": {
    "escalation_pending": false,
    "blocked_on": null,
    "next_steps": ["Test with sample PDFs", "Update documentation"]
  },
  "ttl": 86400  // 24 hours
}
```

**Session Management**:
- Sessions auto-expire after 24 hours of inactivity
- Resume capability: Load previous session context
- Handoff between agents: Transfer session context
- Checkpointing: Periodic saves to persistent storage

---

## Layer 3: Long-Term Memory (Knowledge Base)

### Purpose
Persistent storage of learnings, decisions, code patterns, and best practices that agents reference over time.

### Storage: Hybrid (Vector DB + PostgreSQL)

**Vector Database** (Pinecone, Weaviate, or Chroma):
- Embeddings of code, documentation, and conversations
- Semantic search for relevant context
- Similarity-based retrieval

**PostgreSQL**:
- Structured data (tasks, decisions, metrics)
- Relational queries (e.g., "All tasks for Designer Agent in Q4")
- Audit trail and versioning

---

### Knowledge Base Structure

**1. Code Corpus**
```
/knowledge/code/
  ├── embeddings/
  │   ├── designer_agent_code.pkl
  │   ├── proofing_agent_code.pkl
  │   └── ...
  ├── patterns/
  │   ├── canvas_rendering_patterns.md
  │   ├── pdf_generation_patterns.md
  │   └── ...
  └── snippets/
      ├── common_typescript_utils.ts
      ├── error_handling_patterns.ts
      └── ...
```

**2. Documentation Corpus**
```
/knowledge/docs/
  ├── embeddings/
  │   ├── api_docs.pkl
  │   ├── architecture_docs.pkl
  │   └── ...
  ├── adrs/  (Architecture Decision Records)
  │   ├── adr-001-canvas-library-selection.md
  │   ├── adr-002-pdf-generation-strategy.md
  │   └── ...
  ├── runbooks/
  │   ├── designer/canvas-performance.md
  │   ├── proofing/websocket-scaling.md
  │   └── ...
  └── api_specs/
      ├── designer_api.yaml
      ├── proofing_api.yaml
      └── ...
```

**3. Conversation History** (Anonymized & Summarized)
```
/knowledge/conversations/
  ├── designer_agent/
  │   ├── 2025-12/
  │   │   ├── pdf_issues_summary.md
  │   │   ├── performance_optimization_summary.md
  │   │   └── ...
  │   └── embeddings.pkl
  └── proofing_agent/
      └── ...
```

**4. Decision Log**
```sql
CREATE TABLE agent_decisions (
  id SERIAL PRIMARY KEY,
  agent_id VARCHAR(50),
  decision_date TIMESTAMP,
  context TEXT,
  decision TEXT,
  rationale TEXT,
  outcome TEXT,  -- Updated later with results
  tags TEXT[]
);
```

**5. Performance Metrics**
```sql
CREATE TABLE agent_performance (
  id SERIAL PRIMARY KEY,
  agent_id VARCHAR(50),
  metric_date DATE,
  tasks_completed INT,
  avg_completion_time_hours DECIMAL,
  bugs_introduced INT,
  bugs_fixed INT,
  test_coverage_pct DECIMAL,
  code_review_approval_rate DECIMAL
);
```

---

## Retrieval-Augmented Generation (RAG)

### RAG Pipeline

```
User Query
    ↓
┌───────────────────────────────────────┐
│  1. Query Analysis & Expansion        │
│  (Intent detection, keyword expansion)│
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│  2. Embedding Generation              │
│  (Convert query to vector embedding)  │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│  3. Vector Search                     │
│  (Top-K similarity search in vector DB│
│   K = 10-20 documents)                │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│  4. Reranking                         │
│  (Re-score by relevance, recency)     │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│  5. Context Assembly                  │
│  (Top 3-5 documents, fit in token     │
│   budget)                             │
└───────────────────────────────────────┘
    ↓
┌───────────────────────────────────────┐
│  6. LLM Generation with Context       │
│  (Generate response using retrieved   │
│   context + working memory)           │
└───────────────────────────────────────┘
```

### RAG Configuration by Agent

**Designer Agent RAG Sources**:
- Code corpus: Canvas rendering, PDF generation patterns
- Documentation: Fabric.js API, Adobe PDF Services, print production specs
- Past issues: PDF color space bugs, font embedding issues
- Best practices: Print-ready PDF standards, CMYK conversion

**Proofing Agent RAG Sources**:
- Code corpus: WebSocket sync, annotation systems, workflow engines
- Documentation: W3C annotation spec, Temporal.io workflows
- Past issues: WebSocket disconnection bugs, annotation drift
- Best practices: Real-time collaboration patterns, state machine design

**Workflow Agent RAG Sources**:
- Code corpus: Connector implementations, workflow orchestration
- Documentation: Salesforce API, Shopify API, Zapier integration
- Past issues: Rate limiting errors, OAuth refresh failures
- Best practices: Integration patterns, error handling, retry logic

### RAG Quality Metrics

**Precision**: Are retrieved documents relevant?
- Target: >80% precision (4 out of 5 retrieved docs are useful)
- Measured by: Agent feedback ("Was this context helpful?")

**Recall**: Are the most relevant documents retrieved?
- Target: >70% recall (7 out of 10 relevant docs are retrieved)
- Measured by: Manual review of top-100 docs vs top-10 retrieved

**Latency**: How fast is retrieval?
- Target: <500ms for vector search + reranking
- Measured by: End-to-end retrieval time

---

## Knowledge Sharing Between Agents

### Shared Knowledge Base

**Central Repository**:
All agents contribute to and read from a shared knowledge base, but with domain-specific indexing.

**Contribution Rules**:
1. **After Task Completion**: Summarize key learnings and add to knowledge base
2. **After Bug Fix**: Document root cause and solution in runbooks
3. **After Escalation**: Record decision and rationale in decision log
4. **Weekly**: Summarize conversation highlights for future retrieval

**Example Workflow**:
```
Designer Agent fixes PDF color space bug
    ↓
Adds runbook entry: /runbooks/designer/pdf-color-management.md
    ↓
Embeds runbook in vector DB
    ↓
Workflow Agent encounters PDF color issue
    ↓
RAG retrieves Designer Agent's runbook
    ↓
Workflow Agent leverages learnings
```

### Cross-Agent Communication

**Synchronous** (Real-Time):
- Via API calls when one agent needs input from another
- Example: Designer Agent asks DAM Agent for asset metadata

**Asynchronous** (Event-Based):
- Via message queue (Kafka, RabbitMQ)
- Example: Proofing Agent publishes "Proof Approved" event → MIS Agent starts invoice generation

**Shared Context**:
- Session handoff between agents
- Example: Orchestrator assigns task to Designer Agent → Designer inherits session context

---

## Memory Lifecycle Management

### Retention Policies

**Immediate Context** (Layer 1):
- Retention: Duration of task (minutes to hours)
- Cleanup: Cleared after task completion or handoff

**Session Context** (Layer 2):
- Retention: 24 hours
- Cleanup: Auto-expire in Redis, archived to long-term if marked important

**Long-Term Memory** (Layer 3):
- Code corpus: Persisted indefinitely, updated with code changes
- Documentation: Persisted indefinitely, versioned
- Conversations: Summarized and stored for 1 year, then archived
- Decisions: Persisted indefinitely
- Metrics: Aggregated monthly, raw data retained for 1 year

### Data Pruning

**Vector Database**:
- Remove embeddings for deleted/deprecated code
- Reindex when code patterns change significantly
- Periodic cleanup of low-relevance documents (cosine similarity <0.3 to any query in 90 days)

**Conversation Summaries**:
- Summarize detailed conversations after 30 days
- Keep summaries for 1 year
- Archive original transcripts to cold storage (S3 Glacier)

---

## Context Privacy & Security

### Data Isolation

**Tenant-Specific Context**:
- White-labeled instances have isolated knowledge bases
- No cross-tenant context leakage
- Separate vector DB namespaces per tenant

**Sensitive Information**:
- API keys, credentials excluded from embeddings
- Customer PII anonymized in conversation logs
- Financial data encrypted at rest

### Access Control

**Agent Permissions**:
- Agents can read all knowledge base (within tenant)
- Agents can write only to their domain (Designer → /knowledge/designer/)
- Orchestrator has elevated write access

**Audit Trail**:
- Log all knowledge base writes
- Track which agent retrieved which documents
- Monitor for anomalous access patterns

---

## Context Optimization Strategies

### Token Efficiency

**Chunking**:
- Break large documents into semantic chunks (500-1000 tokens)
- Retrieve chunks, not entire documents
- Preserve context across chunk boundaries

**Summarization**:
- Summarize long code files (keep structure, signatures, key logic)
- Summarize conversation history (extract decisions, action items)
- Progressive summarization (detailed → high-level as context ages)

**Caching**:
- Cache frequently retrieved context (API docs, common patterns)
- Cache embeddings to avoid recomputation
- TTL-based invalidation (24 hours for dynamic content)

### Contextual Relevance Scoring

**Factors**:
1. **Semantic Similarity**: Cosine similarity of embeddings (60% weight)
2. **Recency**: Newer documents ranked higher (20% weight)
3. **Usage Frequency**: Frequently accessed docs ranked higher (10% weight)
4. **Agent Specialization**: Docs from same agent domain ranked higher (10% weight)

**Example**:
```python
relevance_score = (
    0.6 * cosine_similarity(query_embedding, doc_embedding) +
    0.2 * recency_score(doc_timestamp) +
    0.1 * usage_frequency_score(doc_id) +
    0.1 * domain_match_score(agent_id, doc_domain)
)
```

---

## Knowledge Base Maintenance

### Regular Updates

**Daily**:
- Ingest new code commits and generate embeddings
- Index new documentation and ADRs
- Update conversation summaries

**Weekly**:
- Reindex modified code files
- Prune low-relevance embeddings
- Aggregate performance metrics

**Monthly**:
- Review and update runbooks
- Archive old conversation logs
- Regenerate embeddings for significantly changed code

### Quality Assurance

**Embedding Quality**:
- Spot-check retrieval accuracy (sample queries)
- A/B test different embedding models (OpenAI vs Cohere vs custom)
- Monitor retrieval latency and optimize indexes

**Documentation Quality**:
- Ensure runbooks are up-to-date (check against recent issues)
- Validate ADRs reflect current architecture
- Prune outdated documentation

---

## Metrics & Observability

### Context Utilization Metrics

**RAG Performance**:
- Retrieval latency (p50, p95, p99)
- Top-K precision (% of retrieved docs used in response)
- Cache hit rate
- Embedding generation time

**Memory Usage**:
- Token usage per agent per task
- Context compression ratio
- Session context size over time

**Knowledge Base Health**:
- Number of documents indexed
- Embedding freshness (age of embeddings)
- Storage utilization (vector DB, PostgreSQL)
- Query volume per agent

### Dashboards

**Orchestrator Dashboard**:
- Context utilization across all agents
- RAG retrieval success rates
- Knowledge base growth over time
- Token budget allocation per agent

**Agent-Specific Dashboard**:
- Context sources used per task
- RAG document relevance scores
- Session context carryover between tasks
- Knowledge contributions (docs added, runbooks created)

---

## Future Enhancements

### v3+ Features

**1. Multi-Modal Context**:
- Image embeddings for design assets
- Video embeddings for training content
- 3D model embeddings for in-store visualization

**2. Continuous Learning**:
- Reinforcement learning from human feedback (RLHF)
- Fine-tuning embeddings based on retrieval success
- Adaptive context window sizing based on task complexity

**3. Collaborative Context**:
- Shared working memory across agents on joint tasks
- Context handoff protocols for task transitions
- Conflict resolution for contradictory context

**4. Federated Knowledge**:
- Cross-tenant knowledge sharing (with anonymization)
- Industry best practices corpus (shared across all instances)
- Partner ecosystem knowledge base

---

## Conclusion

Effective context management is critical for AI agent performance and efficiency. By implementing a three-layer context architecture (immediate, session, long-term), leveraging RAG for knowledge retrieval, and maintaining a high-quality knowledge base, PopSystem agents can work autonomously while continuously improving from experience.

**Key Principles**:
1. **Right Context, Right Time**: Prioritize relevant context within token budgets
2. **Learn and Share**: Agents contribute to collective knowledge base
3. **Efficient Retrieval**: RAG enables fast, accurate context retrieval
4. **Privacy & Security**: Tenant isolation and sensitive data protection
5. **Continuous Improvement**: Monitor, measure, and optimize context systems

**Success Metrics**:
- RAG precision >80%
- Context retrieval latency <500ms
- Agent task success rate >85% (with adequate context)
- Knowledge base contribution rate: 5+ entries per agent per week
- Token efficiency: <30% of budget wasted on irrelevant context
