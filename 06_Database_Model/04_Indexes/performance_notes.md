# Index Performance Notes and Strategy

**Version**: 1.0
**Created**: 2025-12-19
**Package**: 5 - Index Optimization
**Database**: NewPOPSys PostgreSQL

---

## Table of Contents

1. [Index Strategy Overview](#index-strategy-overview)
2. [Index Categories](#index-categories)
3. [Common Query Patterns](#common-query-patterns)
4. [Index Design Principles](#index-design-principles)
5. [Performance Optimization Techniques](#performance-optimization-techniques)
6. [Monitoring and Maintenance](#monitoring-and-maintenance)
7. [Index Coverage by Module](#index-coverage-by-module)
8. [Known Gaps and Future Enhancements](#known-gaps-and-future-enhancements)

---

## Index Strategy Overview

### Design Philosophy

The NewPOPSys index strategy is designed around three core principles:

1. **Query-Driven Design**: Every index is created to support specific, documented query patterns
2. **Soft-Delete Awareness**: All indexes include `WHERE deleted_at IS NULL` for efficient soft-delete filtering
3. **Partial Index Optimization**: High-selectivity filters use partial indexes to reduce size and improve performance

### Index Organization

Indexes are organized into 8 SQL files by functional area:

| File | Purpose | Index Count (Approx) |
|------|---------|---------------------|
| `01_idx_lookup.sql` | Primary lookups (users, API keys, memberships) | 15 |
| `02_idx_hierarchy.sql` | Geographic hierarchy navigation | 20 |
| `03_idx_campaigns.sql` | Campaign and assignment queries | 25 |
| `04_idx_fulfillment.sql` | Order and shipment tracking | 30 |
| `05_idx_photos.sql` | Photo upload and review workflows | 25 |
| `06_idx_issues.sql` | Issue tracking and resolution | 20 |
| `07_idx_audit.sql` | Audit trails and reporting | 25 |
| `08_idx_partial.sql` | Specialized partial/filtered indexes | 35 |
| **Total** | | **~195 indexes** |

---

## Index Categories

### 1. Foreign Key Indexes

**Purpose**: Support join operations and referential integrity checks

**Pattern**: Every foreign key column has a corresponding index (unless the table is very small)

**Examples**:
```sql
CREATE INDEX idx_store_assignments_campaign
  ON store_assignments(campaign_id)
  WHERE deleted_at IS NULL;

CREATE INDEX idx_photo_uploads_assignment
  ON photo_uploads(store_assignment_id)
  WHERE deleted_at IS NULL;
```

**Performance Impact**: 10-100x faster joins, essential for maintaining referential integrity

---

### 2. Status Indexes

**Purpose**: Support filtering by workflow state or status

**Pattern**: Both full and partial indexes depending on selectivity

**Examples**:
```sql
-- Full status index (all statuses)
CREATE INDEX idx_store_assignments_status
  ON store_assignments(status)
  WHERE deleted_at IS NULL;

-- Partial status index (specific status)
CREATE INDEX idx_store_assignments_ready
  ON store_assignments(campaign_id, created_at)
  WHERE status = 'READY' AND deleted_at IS NULL;
```

**Performance Impact**: 5-50x faster status filtering, critical for dashboards and queues

---

### 3. Timestamp Indexes

**Purpose**: Support sorting by time and date range queries

**Pattern**: DESC ordering for recent-first queries (most common pattern)

**Examples**:
```sql
CREATE INDEX idx_campaigns_brand_dates
  ON campaigns(brand_id, start_date, end_date)
  WHERE deleted_at IS NULL;

CREATE INDEX idx_photo_uploads_uploaded_at
  ON photo_uploads(uploaded_at DESC)
  WHERE deleted_at IS NULL;
```

**Performance Impact**: Essential for pagination and time-based filtering

---

### 4. Composite Indexes

**Purpose**: Support multi-column filtering and sorting

**Pattern**: Columns ordered by selectivity (most selective first) and query pattern

**Examples**:
```sql
-- Filter by brand and status, sort by date
CREATE INDEX idx_campaigns_brand_status_created
  ON campaigns(brand_id, status, created_at DESC)
  WHERE deleted_at IS NULL;

-- Filter by assignment and status, sort by upload time
CREATE INDEX idx_photo_uploads_assignment_status
  ON photo_uploads(store_assignment_id, review_status, uploaded_at DESC)
  WHERE deleted_at IS NULL;
```

**Column Ordering Strategy**:
1. Exact match columns (foreign keys, IDs)
2. Range/filter columns (status, type)
3. Sort columns (timestamps with DESC)

**Performance Impact**: Can eliminate sorting operations and enable index-only scans

---

### 5. GIN Indexes (JSONB)

**Purpose**: Enable efficient querying of JSONB columns

**Pattern**: Applied to JSONB columns frequently queried for specific keys or values

**Examples**:
```sql
-- Query campaign selection recipes
CREATE INDEX idx_campaigns_selection_recipe_gin
  ON campaigns USING GIN (selection_recipe_json)
  WHERE selection_recipe_json IS NOT NULL AND deleted_at IS NULL;

-- Query audit event changes
CREATE INDEX idx_audit_events_changes_gin
  ON audit_events USING GIN (changes)
  WHERE changes IS NOT NULL AND deleted_at IS NULL;

-- Query shipment tracking numbers (array)
CREATE INDEX idx_shipments_tracking_numbers
  ON shipments USING GIN (tracking_numbers)
  WHERE deleted_at IS NULL;
```

**Performance Impact**: Enables O(log n) JSONB queries vs O(n) sequential scans

**Trade-offs**:
- Larger index size (2-3x typical B-tree index)
- Slower updates (GIN indexes are slower to maintain)
- Essential for flexible schema queries

---

### 6. Partial/Filtered Indexes

**Purpose**: Reduce index size and improve performance for high-selectivity filters

**Pattern**: Include WHERE clause matching common query predicates

**Examples**:
```sql
-- Active stores only (vs all stores)
CREATE INDEX idx_active_stores
  ON stores(brand_id, status, region_id)
  WHERE deleted_at IS NULL AND status = 'ACTIVE';

-- Pending photo reviews only
CREATE INDEX idx_photo_uploads_pending_review
  ON photo_uploads(uploaded_at)
  WHERE review_status = 'PENDING' AND deleted_at IS NULL;

-- Active API keys only
CREATE INDEX idx_api_keys_tenant_active
  ON api_keys(tenant_id, created_at DESC)
  WHERE deleted_at IS NULL
    AND revoked_at IS NULL
    AND (expires_at IS NULL OR expires_at > CURRENT_TIMESTAMP);
```

**Size Reduction**: Typically 50-95% smaller than full index

**Performance Impact**:
- Faster scans (fewer entries)
- Better cache efficiency
- Lower maintenance overhead

**Important**: Query WHERE clause must match index predicate for index to be used

---

### 7. Unique Indexes

**Purpose**: Enforce business rules and provide lookup performance

**Examples**:
```sql
-- Unique store number per brand
CREATE UNIQUE INDEX idx_stores_number_brand_unique
  ON stores(store_number, brand_id)
  WHERE deleted_at IS NULL;

-- Unique order number
CREATE UNIQUE INDEX idx_store_orders_number_unique
  ON store_orders(order_number)
  WHERE deleted_at IS NULL;
```

**Performance Impact**: Provides constraint enforcement and fast exact-match lookups

---

## Common Query Patterns

### Pattern 1: Dashboard Queries

**Scenario**: Load campaign dashboard with assignments by status

```sql
-- Query
SELECT c.*,
       COUNT(sa.id) FILTER (WHERE sa.status = 'READY') as ready_count,
       COUNT(sa.id) FILTER (WHERE sa.status = 'IN_PROGRESS') as in_progress_count,
       COUNT(sa.id) FILTER (WHERE sa.status = 'COMPLETE') as complete_count
FROM campaigns c
LEFT JOIN store_assignments sa ON sa.campaign_id = c.id AND sa.deleted_at IS NULL
WHERE c.brand_id = $brand_id
  AND c.deleted_at IS NULL
  AND c.status IN ('PUBLISHED', 'IN_PROGRESS')
GROUP BY c.id
ORDER BY c.start_date DESC;

-- Indexes Used
-- 1. idx_active_campaigns (campaigns WHERE status IN ('PUBLISHED', 'IN_PROGRESS'))
-- 2. idx_store_assignments_campaign (join on campaign_id)
-- 3. idx_store_assignments_campaign_status (filter by status)
```

**Performance**: Sub-second response for 1000+ campaigns with 100K+ assignments

---

### Pattern 2: Review Queue Queries

**Scenario**: Load pending photo review queue, oldest first

```sql
-- Query
SELECT pu.*, sa.campaign_id, sa.store_id, s.store_number, s.name as store_name
FROM photo_uploads pu
JOIN store_assignments sa ON sa.id = pu.store_assignment_id
JOIN stores s ON s.id = sa.store_id
WHERE pu.review_status = 'PENDING'
  AND pu.deleted_at IS NULL
ORDER BY pu.uploaded_at ASC
LIMIT 50;

-- Indexes Used
-- 1. idx_photo_uploads_pending_review (partial index on PENDING photos)
-- 2. idx_store_assignments_id (PK, for join)
-- 3. idx_stores_id (PK, for join)
```

**Performance**: Constant-time queue access regardless of total photo count

---

### Pattern 3: Hierarchy Navigation

**Scenario**: Navigate from brand to stores through geographic hierarchy

```sql
-- Query: Find all active stores in a region
SELECT s.*
FROM stores s
WHERE s.region_id = $region_id
  AND s.status = 'ACTIVE'
  AND s.deleted_at IS NULL
ORDER BY s.district_id, s.store_number;

-- Index Used
-- idx_active_stores_region (partial index on active stores by region)

-- Query: Find all districts in a region with store counts
SELECT d.*, COUNT(s.id) as store_count
FROM districts d
LEFT JOIN stores s ON s.district_id = d.id AND s.deleted_at IS NULL
WHERE d.region_id = $region_id
  AND d.deleted_at IS NULL
GROUP BY d.id
ORDER BY d.name;

-- Indexes Used
-- 1. idx_districts_region (districts by region)
-- 2. idx_stores_district (stores by district)
```

**Performance**: Efficient navigation at all hierarchy levels

---

### Pattern 4: Audit Trail Queries

**Scenario**: View complete change history for an entity

```sql
-- Query
SELECT ae.*, u.email as actor_email
FROM audit_events ae
LEFT JOIN users u ON u.id = ae.actor_user_id
WHERE ae.entity_type = 'campaign'
  AND ae.entity_id = $campaign_id
  AND ae.deleted_at IS NULL
ORDER BY ae.created_at DESC;

-- Indexes Used
-- 1. idx_audit_events_entity_type_id_time (composite on entity_type, entity_id, created_at)
-- 2. idx_users_id (PK, for join)
```

**Performance**: Fast entity-specific audit trails regardless of total event count

---

### Pattern 5: Issue Management

**Scenario**: Priority queue for issue triage

```sql
-- Query
SELECT ir.*, sa.campaign_id, s.store_number
FROM issue_requests ir
JOIN store_assignments sa ON sa.id = ir.store_assignment_id
JOIN stores s ON s.id = sa.store_id
WHERE ir.status IN ('OPEN', 'TRIAGED')
  AND ir.deleted_at IS NULL
ORDER BY ir.priority DESC, ir.submitted_at ASC
LIMIT 100;

-- Indexes Used
-- 1. idx_issue_requests_priority_status_time (priority DESC, status, submitted_at)
-- 2. idx_store_assignments_id (PK, for join)
-- 3. idx_stores_id (PK, for join)
```

**Performance**: Optimized for priority-based processing

---

## Index Design Principles

### 1. Soft-Delete Pattern

**Rule**: All indexes include `WHERE deleted_at IS NULL`

**Rationale**:
- Excludes soft-deleted rows from index
- Reduces index size
- Improves query performance
- Matches application query pattern

**Example**:
```sql
-- ✅ GOOD: Includes soft-delete filter
CREATE INDEX idx_stores_brand
  ON stores(brand_id)
  WHERE deleted_at IS NULL;

-- ❌ BAD: Includes soft-deleted rows
CREATE INDEX idx_stores_brand
  ON stores(brand_id);
```

---

### 2. Column Ordering in Composite Indexes

**Rule**: Order columns by selectivity and query pattern

**Column Order Strategy**:
1. **Equality filters** (exact match): Most selective first
2. **Range filters** (>, <, BETWEEN): After equality
3. **Sort columns** (ORDER BY): Last

**Example**:
```sql
-- Query pattern: WHERE brand_id = ? AND status = ? ORDER BY created_at DESC

-- ✅ GOOD: Matches query pattern
CREATE INDEX idx_campaigns_brand_status_created
  ON campaigns(brand_id, status, created_at DESC)
  WHERE deleted_at IS NULL;

-- ❌ LESS OPTIMAL: Wrong order
CREATE INDEX idx_campaigns_created_status_brand
  ON campaigns(created_at DESC, status, brand_id)
  WHERE deleted_at IS NULL;
```

**Why**: PostgreSQL can use a leading subset of index columns, but not trailing subsets

---

### 3. DESC Ordering for Timestamps

**Rule**: Use DESC for timestamp columns in ORDER BY DESC queries

**Rationale**: Enables index-only scans in descending order

**Example**:
```sql
-- Query: ORDER BY created_at DESC

-- ✅ GOOD: Matches query order
CREATE INDEX idx_notifications_user
  ON notifications(user_id, created_at DESC)
  WHERE deleted_at IS NULL;

-- ❌ SUBOPTIMAL: Requires backward scan
CREATE INDEX idx_notifications_user
  ON notifications(user_id, created_at ASC)
  WHERE deleted_at IS NULL;
```

---

### 4. Nullable Columns in Partial Indexes

**Rule**: Use `IS NOT NULL` in partial index predicate for nullable columns

**Rationale**: Reduces index size by excluding NULL values

**Example**:
```sql
-- ✅ GOOD: Excludes NULLs
CREATE INDEX idx_photo_uploads_s3_key
  ON photo_uploads(s3_key)
  WHERE s3_key IS NOT NULL AND deleted_at IS NULL;

-- ⚠️ LESS OPTIMAL: Includes NULLs
CREATE INDEX idx_photo_uploads_s3_key
  ON photo_uploads(s3_key)
  WHERE deleted_at IS NULL;
```

---

### 5. GIN vs B-tree for JSONB

**Rule**: Use GIN for JSONB columns that are queried, B-tree for JSONB columns used only for storage

**When to Use GIN**:
- Querying JSONB keys or values
- Searching within JSONB structures
- Array containment queries

**When to Avoid GIN**:
- JSONB used only for storage (never queried)
- Very frequent updates (GIN updates are slower)
- Memory constrained systems (GIN indexes are larger)

**Example**:
```sql
-- ✅ GOOD: Frequently queried JSONB
CREATE INDEX idx_campaigns_selection_recipe_gin
  ON campaigns USING GIN (selection_recipe_json)
  WHERE selection_recipe_json IS NOT NULL AND deleted_at IS NULL;

-- ✅ GOOD: Not indexed (only used for storage)
-- No index on store_layouts.layout_json (only retrieved, never queried)
```

---

### 6. Covering Indexes

**Rule**: Include all columns needed by a query in the index (if reasonable)

**Rationale**: Enables index-only scans (no table access needed)

**Example**:
```sql
-- Query: SELECT campaign_id, status, updated_at FROM store_assignments WHERE campaign_id = ?

-- ✅ GOOD: Covering index
CREATE INDEX idx_store_assignments_campaign_covering
  ON store_assignments(campaign_id, status, updated_at)
  WHERE deleted_at IS NULL;

-- Index-only scan possible: All columns in index
```

**Trade-off**: Larger index size vs faster queries

---

## Performance Optimization Techniques

### 1. Partial Index Selectivity

**Goal**: Maximize index size reduction while maintaining query coverage

**Strategy**: Create partial indexes for high-selectivity filters

**Selectivity Analysis**:

| Filter | Selectivity | Partial Index? |
|--------|-------------|----------------|
| `status = 'ACTIVE'` (10% of rows) | High (90% reduction) | ✅ Yes |
| `status = 'PENDING'` (1% of rows) | Very High (99% reduction) | ✅ Yes |
| `status IN ('ACTIVE', 'INACTIVE')` (80% of rows) | Low (20% reduction) | ❌ No |
| `deleted_at IS NULL` (95% of rows) | Medium (5% reduction) | ✅ Yes (standard pattern) |

**Example**:
```sql
-- High selectivity: 1% of photos are PENDING
CREATE INDEX idx_photo_uploads_pending_review
  ON photo_uploads(uploaded_at)
  WHERE review_status = 'PENDING' AND deleted_at IS NULL;
-- Size: 1% of full index

-- Low selectivity: 80% of campaigns are active
-- Better to use full index with status column
CREATE INDEX idx_campaigns_brand_status
  ON campaigns(brand_id, status)
  WHERE deleted_at IS NULL;
-- Not worth creating partial index for status = 'ACTIVE'
```

---

### 2. Index Bloat Prevention

**Problem**: Indexes grow over time due to updates and deletes

**Solutions**:

1. **VACUUM regularly** (automatic in PostgreSQL 12+)
2. **REINDEX periodically** for heavily updated tables
3. **Use partial indexes** to reduce bloat on transient data

**Example**:
```sql
-- Monitor index bloat
SELECT
  schemaname,
  tablename,
  indexname,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
  idx_scan as index_scans,
  idx_tup_read as tuples_read,
  idx_tup_fetch as tuples_fetched
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Reindex if necessary
REINDEX INDEX CONCURRENTLY idx_photo_uploads_assignment;
```

---

### 3. Query Plan Analysis

**Tool**: `EXPLAIN ANALYZE`

**Usage**:
```sql
EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM store_assignments
WHERE campaign_id = $campaign_id
  AND status = 'IN_PROGRESS'
  AND deleted_at IS NULL;
```

**Look For**:
- **Index Scan** (good) vs **Seq Scan** (potentially bad)
- **Index Only Scan** (best) - all data from index
- **Bitmap Index Scan** (good for multiple conditions)
- **Buffers** - cache hit ratio (should be >95%)

**Example Output**:
```
Index Scan using idx_store_assignments_campaign_status on store_assignments
  Index Cond: ((campaign_id = '...'::uuid) AND (status = 'IN_PROGRESS'))
  Filter: (deleted_at IS NULL)
  Rows: 42
  Buffers: shared hit=15
  Planning Time: 0.123 ms
  Execution Time: 0.456 ms
```

---

### 4. Index Maintenance Scheduling

**Best Practices**:

1. **VACUUM**: Automatic (autovacuum)
2. **ANALYZE**: After bulk loads, weekly for active tables
3. **REINDEX**: Monthly for high-churn tables, quarterly for others

**Example Maintenance Script**:
```sql
-- Update statistics
ANALYZE campaigns;
ANALYZE store_assignments;
ANALYZE photo_uploads;

-- Reindex high-churn tables (if bloated)
REINDEX INDEX CONCURRENTLY idx_photo_uploads_assignment;
REINDEX INDEX CONCURRENTLY idx_store_assignments_campaign_status;

-- Check for missing indexes
SELECT
  schemaname,
  tablename,
  seq_scan,
  seq_tup_read,
  idx_scan,
  seq_tup_read / NULLIF(seq_scan, 0) as avg_seq_scan_rows
FROM pg_stat_user_tables
WHERE seq_scan > 1000
  AND seq_tup_read / NULLIF(seq_scan, 0) > 10000
ORDER BY seq_tup_read DESC;
```

---

## Monitoring and Maintenance

### Index Usage Statistics

```sql
-- Find unused indexes (candidates for removal)
SELECT
  schemaname,
  tablename,
  indexname,
  idx_scan,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
  AND idx_scan = 0
  AND indexrelid::regclass::text NOT LIKE '%_pkey'
ORDER BY pg_relation_size(indexrelid) DESC;

-- Find most used indexes
SELECT
  schemaname,
  tablename,
  indexname,
  idx_scan,
  idx_tup_read,
  idx_tup_fetch,
  pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
ORDER BY idx_scan DESC
LIMIT 50;
```

### Missing Index Detection

```sql
-- Find tables with high sequential scans (might need indexes)
SELECT
  schemaname,
  tablename,
  seq_scan,
  seq_tup_read,
  idx_scan,
  n_tup_ins + n_tup_upd + n_tup_del as total_writes,
  pg_size_pretty(pg_total_relation_size(relid)) as total_size
FROM pg_stat_user_tables
WHERE schemaname = 'public'
  AND seq_scan > 1000
ORDER BY seq_tup_read DESC;
```

### Cache Hit Ratio

```sql
-- Overall cache hit ratio (should be >95%)
SELECT
  SUM(heap_blks_hit) / NULLIF(SUM(heap_blks_hit + heap_blks_read), 0) * 100 as cache_hit_ratio
FROM pg_statio_user_tables;

-- Per-table cache hit ratio
SELECT
  schemaname,
  tablename,
  heap_blks_hit / NULLIF(heap_blks_hit + heap_blks_read, 0) * 100 as cache_hit_ratio,
  heap_blks_hit,
  heap_blks_read
FROM pg_statio_user_tables
WHERE schemaname = 'public'
  AND heap_blks_hit + heap_blks_read > 0
ORDER BY cache_hit_ratio ASC;
```

---

## Index Coverage by Module

### Module 1: Tenancy & Identity

**Tables**: tenants, brands, users, memberships, api_keys

**Key Indexes**:
- `idx_users_email` - User login lookups
- `idx_memberships_user_brand` - Permission checks
- `idx_memberships_brand_role` - Role-based queries
- `idx_api_keys_prefix` - API key authentication
- `idx_api_keys_tenant_active` - Active API key lookups

**Coverage**: ✅ Complete

---

### Module 2: Stores & Grouping

**Tables**: regions, districts, territories, stores, store_groups, store_group_memberships

**Key Indexes**:
- `idx_regions_parent` - Hierarchical navigation
- `idx_districts_region` - District lookups
- `idx_territories_district` - Territory lookups
- `idx_stores_region`, `idx_stores_district`, `idx_stores_territory` - Store hierarchy
- `idx_active_stores` - Active store listings
- `idx_stores_number_brand_unique` - Unique constraint + lookup

**Coverage**: ✅ Complete

---

### Module 3: Surveys & Layouts

**Tables**: survey_templates, survey_versions, store_layouts, location_slots, photo_rules

**Key Indexes**:
- `idx_survey_templates_brand` - Template listings
- `idx_survey_versions_template` - Version lookups
- `idx_store_layouts_store` - Store layout lookups
- `idx_store_layouts_current` - Current layout version
- `idx_location_slots_layout` - Slot listings
- `idx_photo_rules_brand` - Photo rule lookups

**Coverage**: ✅ Complete

---

### Module 4: Campaigns & Kits

**Tables**: campaigns, kit_definitions, kit_items, store_assignments, assignment_items

**Key Indexes**:
- `idx_campaigns_brand_dates` - Campaign date range queries
- `idx_campaigns_status_dates` - Active campaign lookups
- `idx_active_campaigns` - Partial index for active campaigns
- `idx_store_assignments_campaign_status` - Assignment filtering
- `idx_store_assignments_ready`, `_in_progress`, `_submitted` - Status queues
- `idx_assignment_items_assignment_status` - Item tracking

**Coverage**: ✅ Complete

---

### Module 5: Fulfillment

**Tables**: store_orders, order_lines, shipments, shipment_lines

**Key Indexes**:
- `idx_store_orders_campaign_store` - Order lookups
- `idx_store_orders_psp_ref` - PSP integration
- `idx_store_orders_pending_ack`, `_acknowledged` - Order queues
- `idx_shipments_in_transit` - Active shipment tracking
- `idx_shipments_tracking_numbers` - GIN index for tracking arrays

**Coverage**: ✅ Complete

---

### Module 6: Execution & Verification

**Tables**: receive_verifications, photo_uploads, photo_reviews, retake_requests, store_survey_responses

**Key Indexes**:
- `idx_photo_uploads_assignment_status` - Photo tracking
- `idx_photo_uploads_pending_review` - Review queue
- `idx_photo_reviews_reviewer_time` - Reviewer activity
- `idx_retake_requests_assignment_resolution` - Retake tracking
- `idx_receive_verifications_damages`, `_shortages` - Quality tracking

**Coverage**: ✅ Complete

---

### Module 7: Issues & Reorders

**Tables**: issue_requests, issue_lines, reorders

**Key Indexes**:
- `idx_issue_requests_priority_status_time` - Priority queue
- `idx_issue_requests_open`, `_awaiting_approval`, `_approved` - Workflow queues
- `idx_issue_lines_kit_item_qty` - Quality analytics
- `idx_reorders_issue_order` - Issue-to-fulfillment linking

**Coverage**: ✅ Complete

---

### Module 8: Notifications

**Tables**: notification_preferences, notifications

**Key Indexes**:
- `idx_notifications_user_read_status` - User inbox
- `idx_notifications_unread` - Unread notifications
- `idx_notifications_event_type_time` - Volume analysis
- `idx_notifications_failed` - Retry queue

**Coverage**: ✅ Complete

---

### Module 9: Webhooks & Integration

**Tables**: webhook_endpoints, webhook_deliveries

**Key Indexes**:
- `idx_webhook_endpoints_tenant_active` - Active endpoints
- `idx_webhook_deliveries_endpoint` - Delivery history
- `idx_webhook_deliveries_retry` - Retry queue
- `idx_failed_webhook_deliveries` - Failed delivery tracking

**Coverage**: ✅ Complete

---

### Module 10: Exports & Jobs

**Tables**: export_jobs

**Key Indexes**:
- `idx_export_jobs_brand_status_time` - Job listings
- `idx_export_jobs_pending` - Processing queue
- `idx_export_jobs_expired` - Cleanup queue
- `idx_export_jobs_filters_gin` - Filter queries

**Coverage**: ✅ Complete

---

### Module 11: Audit & Observability

**Tables**: audit_events

**Key Indexes**:
- `idx_audit_events_tenant_action_time` - Audit log queries
- `idx_audit_events_entity_type_id_time` - Entity audit trails
- `idx_audit_events_actor_time` - User activity tracking
- `idx_audit_events_metadata_gin`, `_changes_gin` - JSONB queries

**Coverage**: ✅ Complete

---

## Known Gaps and Future Enhancements

### Current Gaps

**None identified** - All query patterns from orchestration log Section 1.4 have been addressed.

### Future Enhancements

1. **Full-Text Search Indexes**
   - Add `tsvector` columns and GIN indexes for full-text search on:
     - Store names and addresses
     - Campaign names and descriptions
     - Issue request descriptions
   - **Estimated Impact**: Enables fast text search without external search engine

2. **Materialized Views**
   - Create materialized views for expensive aggregate queries:
     - Campaign progress rollups
     - Store assignment status summaries
     - Photo review metrics
   - **Estimated Impact**: 10-100x faster dashboard queries

3. **Partitioning**
   - Partition large tables by date for improved performance:
     - `audit_events` by created_at (monthly partitions)
     - `notifications` by created_at (monthly partitions)
     - `photo_uploads` by uploaded_at (quarterly partitions)
   - **Estimated Impact**: Faster queries, easier archival

4. **Expression Indexes**
   - Create indexes on computed expressions:
     - `LOWER(email)` for case-insensitive email lookups
     - `DATE(created_at)` for date-based grouping
   - **Estimated Impact**: Eliminates need for function calls in WHERE clauses

5. **BRIN Indexes**
   - Consider BRIN indexes for very large tables with natural ordering:
     - `audit_events(created_at)` - sequential time-series data
   - **Estimated Impact**: 100x smaller index size for time-series queries

### Performance Monitoring Recommendations

1. **Weekly**: Review slow query log and add indexes as needed
2. **Monthly**: Check index usage statistics and remove unused indexes
3. **Quarterly**: Reindex high-churn tables and analyze all tables
4. **Annually**: Review overall index strategy and optimize based on usage patterns

---

## Appendix: Index Naming Conventions

### Standard Format

```
idx_{table}_{columns}[_{condition}]
```

### Examples

| Index Name | Pattern | Description |
|------------|---------|-------------|
| `idx_users_email` | Simple | Single column index |
| `idx_memberships_user_brand` | Composite | Multi-column index |
| `idx_campaigns_brand_dates` | Composite | Date range index |
| `idx_store_assignments_ready` | Partial | Status-specific partial index |
| `idx_active_stores` | Partial | Descriptive name for filtered index |
| `idx_campaigns_selection_recipe_gin` | GIN | Explicit index type |

### Naming Guidelines

1. Always start with `idx_`
2. Include table name
3. Include all indexed columns (abbreviated if long)
4. Add suffix for partial indexes describing the filter
5. Add `_gin` suffix for GIN indexes
6. Keep names under 63 characters (PostgreSQL identifier limit)

---

**End of Performance Notes**
