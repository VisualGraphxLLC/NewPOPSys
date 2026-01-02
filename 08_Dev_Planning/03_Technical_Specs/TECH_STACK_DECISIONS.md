# Technology Stack Decisions

This document records architectural decisions using the ADR (Architecture Decision Record) format.

---

## ADR-001: React 18 with TypeScript

### Status
**Accepted**

### Context
We need to select a frontend framework for building four distinct applications:
- Mobile PWA (field reps)
- Brand Admin Dashboard
- PSP Operations Center
- Store Portal

Key requirements:
- Cross-platform mobile support via PWA
- Complex state management
- Real-time updates capability
- Strong typing for large codebase
- Developer ecosystem and hiring pool

### Decision
We will use **React 18.2+** with **TypeScript 5.3+** as our frontend framework.

### Alternatives Considered

| Framework | Pros | Cons |
|-----------|------|------|
| **Vue 3** | Simpler learning curve, good DX | Smaller ecosystem, fewer senior developers available |
| **Angular** | Full framework, enterprise support | Heavier bundle, steeper learning curve, less flexible |
| **React** | Largest ecosystem, concurrent features, PWA support | Requires additional library decisions |

### Consequences

**Positive:**
- Access to largest component ecosystem (Radix, TanStack, etc.)
- React 18 concurrent features for better UX
- Excellent TypeScript integration
- Strong PWA support with Vite
- Large talent pool for hiring

**Negative:**
- Need to make additional library choices (state, forms, etc.)
- Frequent ecosystem changes require maintenance

---

## ADR-002: Fastify over Express

### Status
**Accepted**

### Context
We need a Node.js web framework for our API server that handles:
- High request throughput (thousands of field reps)
- Photo upload processing
- Real-time task updates
- Complex validation

### Decision
We will use **Fastify 4.x** as our backend web framework.

### Alternatives Considered

| Framework | Throughput (req/s) | Pros | Cons |
|-----------|-------------------|------|------|
| **Express** | ~15,000 | Mature, widespread | Slower, callback-based design |
| **Fastify** | ~75,000 | 5x faster, schema-first, plugins | Smaller community |
| **Koa** | ~20,000 | Lightweight, modern | Less ecosystem support |
| **Hono** | ~100,000+ | Extremely fast, edge-ready | Very new, less mature |

### Consequences

**Positive:**
- 5x performance improvement over Express
- Built-in schema validation with JSON Schema
- Plugin architecture aligns with our modular design
- Excellent TypeScript support
- Request/response serialization

**Negative:**
- Smaller middleware ecosystem than Express
- Team needs to learn Fastify patterns
- Some Express middleware needs adaptation

### Benchmarks Reference

```
Framework      Requests/sec
-----------    ------------
Fastify        76,835
Koa            22,497
Express        15,123
```

---

## ADR-003: Drizzle ORM over Prisma

### Status
**Accepted**

### Context
We need an ORM/query builder for PostgreSQL that provides:
- Type-safe database queries
- Migration management
- Good performance for complex queries
- JSON/JSONB support for flexible data

### Decision
We will use **Drizzle ORM 0.29+** as our database toolkit.

### Alternatives Considered

| ORM | Type Safety | Performance | Flexibility |
|-----|-------------|-------------|-------------|
| **Prisma** | Excellent | Good (query engine overhead) | Limited (abstraction-heavy) |
| **Drizzle** | Excellent | Excellent (SQL-like) | High (thin abstraction) |
| **TypeORM** | Good | Moderate | Moderate |
| **Knex** | Manual | Excellent | High |

### Consequences

**Positive:**
- SQL-like syntax familiar to database developers
- No query engine binary (smaller deployments)
- Type-safe joins and relations
- Excellent PostgreSQL JSONB support
- Relational queries without N+1 issues
- Lightweight bundle size

**Negative:**
- Less mature than Prisma
- Smaller community and fewer tutorials
- Manual migration writing (vs Prisma's auto-generate)

### Code Comparison

```typescript
// Drizzle - SQL-like, transparent
const tasks = await db
  .select()
  .from(tasksTable)
  .leftJoin(storesTable, eq(tasksTable.storeId, storesTable.id))
  .where(eq(tasksTable.status, 'pending'))
  .limit(10);

// Prisma - More abstracted
const tasks = await prisma.task.findMany({
  where: { status: 'pending' },
  include: { store: true },
  take: 10,
});
```

---

## ADR-004: PostgreSQL 16

### Status
**Accepted**

### Context
We need a primary database that supports:
- Complex relational queries (campaigns, stores, tasks)
- JSON/JSONB for flexible configurations
- Geospatial queries (store locations)
- High reliability and ACID compliance
- Horizontal read scaling

### Decision
We will use **PostgreSQL 16** as our primary database.

### Alternatives Considered

| Database | JSON Support | Geo Support | Scalability | Cost |
|----------|-------------|-------------|-------------|------|
| **PostgreSQL** | Excellent (JSONB) | PostGIS | Read replicas | Free |
| **MySQL 8** | Good (JSON) | Basic | Read replicas | Free |
| **MongoDB** | Native | Native | Horizontal | Free/Paid |
| **CockroachDB** | Good | Limited | Distributed | Paid |

### Consequences

**Positive:**
- PostgreSQL 16's improved JSON performance
- JSONB for flexible POP kit configurations
- PostGIS extension for store proximity queries
- Mature, battle-tested reliability
- Excellent Drizzle ORM integration
- Free and open source

**Negative:**
- Vertical scaling limitations
- Need to manage read replicas manually
- More complex setup than managed NoSQL

### PostgreSQL 16 Features We'll Use

- **JSONB path queries** - For querying nested POP kit configs
- **Parallel query execution** - For analytics dashboards
- **Improved vacuum** - Better performance under load
- **pg_stat_io** - Better monitoring capabilities

---

## ADR-005: Turborepo for Monorepo

### Status
**Accepted**

### Context
We have multiple applications (4 frontend apps, 1 API) and shared packages that need:
- Unified dependency management
- Shared code between apps
- Consistent build and test pipelines
- Incremental builds for CI performance

### Decision
We will use **Turborepo** as our monorepo build system with **pnpm** workspaces.

### Alternatives Considered

| Tool | Speed | Learning Curve | Features |
|------|-------|----------------|----------|
| **Turborepo** | Excellent | Low | Caching, pipelines |
| **Nx** | Excellent | High | Full-featured, complex |
| **Lerna** | Moderate | Low | Publishing focus |
| **Rush** | Good | High | Enterprise focus |

### Consequences

**Positive:**
- Zero-config setup for most cases
- Excellent build caching (local + remote)
- Simple pipeline configuration
- Works seamlessly with pnpm
- Lower learning curve than Nx
- Vercel backing ensures maintenance

**Negative:**
- Fewer features than Nx
- No built-in generators/schematics
- Less granular task dependencies

### Configuration

```json
// turbo.json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": ["dist/**", ".next/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {},
    "test": {
      "dependsOn": ["build"]
    }
  }
}
```

---

## ADR-006: TanStack Query for Data Fetching

### Status
**Accepted**

### Context
We need a data fetching solution that handles:
- Server state caching
- Background refetching
- Optimistic updates for offline-first mobile
- Request deduplication
- Pagination and infinite loading

### Decision
We will use **TanStack Query (React Query) 5.x** for server state management.

### Alternatives Considered

| Library | Caching | Offline | DX | Bundle Size |
|---------|---------|---------|-----|-------------|
| **TanStack Query** | Excellent | Good | Excellent | 12kb |
| **SWR** | Good | Limited | Good | 4kb |
| **RTK Query** | Good | Limited | Moderate | Redux dependency |
| **Apollo Client** | Excellent | Good | Good | 35kb+ |

### Consequences

**Positive:**
- Automatic caching and invalidation
- Built-in loading/error states
- Optimistic updates for responsive UI
- Query invalidation by key patterns
- Excellent DevTools
- Mutation hooks for write operations

**Negative:**
- Additional learning curve
- Need to design cache key strategy
- Potential for stale data if not configured properly

### Usage Pattern

```typescript
// hooks/useTasks.ts
export function useTasks(campaignId: string) {
  return useQuery({
    queryKey: ['tasks', { campaignId }],
    queryFn: () => api.tasks.list({ campaignId }),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}

export function useCompleteTask() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: api.tasks.complete,
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: ['tasks', { taskId: variables.taskId }]
      });
    },
  });
}
```

---

## Summary Matrix

| Decision | Choice | Primary Reason |
|----------|--------|----------------|
| Frontend Framework | React 18 + TypeScript | Ecosystem & PWA support |
| Backend Framework | Fastify 4 | Performance (5x Express) |
| ORM | Drizzle | Type-safety + SQL control |
| Database | PostgreSQL 16 | JSONB + reliability |
| Monorepo | Turborepo | Simplicity + caching |
| Data Fetching | TanStack Query | Caching + offline support |

---

*Last Updated: 2026-01-01*
