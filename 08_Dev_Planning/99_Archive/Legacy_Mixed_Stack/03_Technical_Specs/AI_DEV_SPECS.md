# AI Development Specifications

## Target Audience

This document is designed for **AI coding assistants** (Claude, Cursor, GitHub Copilot, and similar tools) to provide context for code generation, review, and assistance within the PopSystem project.

---

## Technology Stack

### Frontend

| Technology | Version | Purpose |
|------------|---------|---------|
| Next.js | 14+ | App Router & React Framework |
| TypeScript | 5.3+ | Type-safe JavaScript |
| Turbo | Latest | Build tool and dev server |
| TanStack Query | 5.x | Server state management |
| React Hook Form | 7.x | Form handling |
| Zod | 3.x | Schema validation |
| TailwindCSS | 3.4+ | Utility-first CSS |
| Radix UI | Latest | Accessible component primitives |

### Backend

| Technology | Version | Purpose |
|------------|---------|---------|
| Node.js | 20 LTS | Runtime environment |
| Fastify | 4.x | High-performance web framework |
| TypeScript | 5.3+ | Type-safe JavaScript |
| Drizzle ORM | 0.29+ | Type-safe SQL ORM |
| PostgreSQL | 16 | Primary database |
| Redis | 7.x | Caching and sessions |

### Infrastructure

| Technology | Purpose |
|------------|---------|
| Turborepo | Monorepo build system |
| Docker | Containerization |
| pnpm | Package manager |
| Vitest | Unit testing |
| Playwright | E2E testing |

---

## Turborepo Structure

```
popsystem/
├── apps/
│   ├── mobile-pwa/          # Field rep mobile application
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   ├── stores/
│   │   │   └── utils/
│   │   ├── public/
│   │   └── package.json
│   │
│   ├── brand-admin/         # Brand manager dashboard
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── stores/
│   │   └── package.json
│   │
│   ├── psp-ops/             # PSP operations center
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── stores/
│   │   └── package.json
│   │
│   ├── store-portal/        # Store manager interface
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── stores/
│   │   └── package.json
│   │
│   └── api/                 # Backend API server
│       ├── src/
│       │   ├── routes/
│       │   ├── services/
│       │   ├── middleware/
│       │   └── plugins/
│       └── package.json
│
├── packages/
│   ├── ui/                  # Shared UI components
│   ├── api-client/          # Generated API client
│   ├── shared-types/        # Shared TypeScript types
│   ├── database/            # Drizzle schema and migrations
│   ├── config-eslint/       # Shared ESLint config
│   └── config-typescript/   # Shared TS config
│
├── turbo.json
├── pnpm-workspace.yaml
└── package.json
```

---

## Shared UI Components Strategy

### Component Library Location

All shared components live in `packages/ui/` following atomic design principles:

```
packages/ui/
├── src/
│   ├── atoms/           # Basic building blocks
│   │   ├── Button/
│   │   ├── Input/
│   │   ├── Badge/
│   │   └── Icon/
│   │
│   ├── molecules/       # Combinations of atoms
│   │   ├── FormField/
│   │   ├── Card/
│   │   ├── SearchInput/
│   │   └── StatusBadge/
│   │
│   ├── organisms/       # Complex components
│   │   ├── DataTable/
│   │   ├── FormBuilder/
│   │   ├── PhotoCapture/
│   │   └── TaskList/
│   │
│   └── templates/       # Page layouts
│       ├── DashboardLayout/
│       ├── FormLayout/
│       └── MobileLayout/
│
├── styles/
│   └── globals.css
└── index.ts
```

### Component Export Pattern

```typescript
// packages/ui/src/atoms/Button/index.ts
export { Button } from './Button';
export type { ButtonProps } from './Button.types';

// packages/ui/index.ts
export * from './src/atoms/Button';
export * from './src/molecules/FormField';
export * from './src/organisms/DataTable';
```

### Usage in Apps

```typescript
// apps/mobile-pwa/src/components/TaskCard.tsx
import { Button, Card, StatusBadge } from '@popsystem/ui';
```

---

## API Patterns

### RESTful Conventions

| Method | Endpoint Pattern | Purpose |
|--------|------------------|---------|
| GET | `/api/v1/{resource}` | List resources |
| GET | `/api/v1/{resource}/:id` | Get single resource |
| POST | `/api/v1/{resource}` | Create resource |
| PATCH | `/api/v1/{resource}/:id` | Partial update |
| PUT | `/api/v1/{resource}/:id` | Full replacement |
| DELETE | `/api/v1/{resource}/:id` | Delete resource |

### Request Schema Pattern

```typescript
// Zod schema for request validation
const createTaskSchema = z.object({
  body: z.object({
    campaignId: z.string().uuid(),
    storeId: z.string().uuid(),
    type: z.enum(['installation', 'verification', 'removal']),
    scheduledDate: z.string().datetime(),
    instructions: z.string().optional(),
  }),
  params: z.object({}),
  query: z.object({}),
});

type CreateTaskRequest = z.infer<typeof createTaskSchema>;
```

### Response Schema Pattern

```typescript
// Standard success response
interface ApiResponse<T> {
  success: true;
  data: T;
  meta?: {
    page?: number;
    pageSize?: number;
    total?: number;
  };
}

// Standard error response
interface ApiError {
  success: false;
  error: {
    code: string;
    message: string;
    details?: Record<string, string[]>;
  };
}

// Paginated response
interface PaginatedResponse<T> extends ApiResponse<T[]> {
  meta: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
  };
}
```

### Route Handler Pattern

```typescript
// apps/api/src/routes/tasks/create.ts
import { FastifyInstance } from 'fastify';
import { createTaskSchema } from './schemas';

export async function createTaskRoute(fastify: FastifyInstance) {
  fastify.post(
    '/tasks',
    {
      schema: {
        body: createTaskSchema.shape.body,
        response: {
          201: taskResponseSchema,
          400: errorResponseSchema,
        },
      },
      preHandler: [fastify.authenticate],
    },
    async (request, reply) => {
      const task = await fastify.taskService.create(request.body);
      return reply.status(201).send({ success: true, data: task });
    }
  );
}
```

---

## Database Schema Overview

### Core Tables

#### Users

```typescript
// packages/database/src/schema/users.ts
export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  passwordHash: varchar('password_hash', { length: 255 }),
  role: userRoleEnum('role').notNull(),
  firstName: varchar('first_name', { length: 100 }),
  lastName: varchar('last_name', { length: 100 }),
  phone: varchar('phone', { length: 20 }),
  organizationId: uuid('organization_id').references(() => organizations.id),
  isActive: boolean('is_active').default(true),
  lastLoginAt: timestamp('last_login_at'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});
```

#### Campaigns

```typescript
export const campaigns = pgTable('campaigns', {
  id: uuid('id').defaultRandom().primaryKey(),
  brandId: uuid('brand_id').references(() => brands.id).notNull(),
  name: varchar('name', { length: 255 }).notNull(),
  description: text('description'),
  status: campaignStatusEnum('status').default('draft'),
  startDate: date('start_date'),
  endDate: date('end_date'),
  budget: decimal('budget', { precision: 10, scale: 2 }),
  targetStoreCount: integer('target_store_count'),
  popKitConfig: jsonb('pop_kit_config'),
  createdBy: uuid('created_by').references(() => users.id),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});
```

#### Stores

```typescript
export const stores = pgTable('stores', {
  id: uuid('id').defaultRandom().primaryKey(),
  retailerId: uuid('retailer_id').references(() => retailers.id),
  storeNumber: varchar('store_number', { length: 50 }),
  name: varchar('name', { length: 255 }).notNull(),
  address: varchar('address', { length: 500 }),
  city: varchar('city', { length: 100 }),
  state: varchar('state', { length: 50 }),
  zipCode: varchar('zip_code', { length: 20 }),
  latitude: decimal('latitude', { precision: 10, scale: 7 }),
  longitude: decimal('longitude', { precision: 10, scale: 7 }),
  timezone: varchar('timezone', { length: 50 }),
  storeMetadata: jsonb('store_metadata'),
  isActive: boolean('is_active').default(true),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});
```

#### Tasks

```typescript
export const tasks = pgTable('tasks', {
  id: uuid('id').defaultRandom().primaryKey(),
  campaignId: uuid('campaign_id').references(() => campaigns.id).notNull(),
  storeId: uuid('store_id').references(() => stores.id).notNull(),
  assignedTo: uuid('assigned_to').references(() => users.id),
  type: taskTypeEnum('type').notNull(),
  status: taskStatusEnum('status').default('pending'),
  priority: integer('priority').default(5),
  scheduledDate: date('scheduled_date'),
  completedAt: timestamp('completed_at'),
  instructions: text('instructions'),
  notes: text('notes'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});
```

#### Compliance Records

```typescript
export const complianceRecords = pgTable('compliance_records', {
  id: uuid('id').defaultRandom().primaryKey(),
  taskId: uuid('task_id').references(() => tasks.id).notNull(),
  submittedBy: uuid('submitted_by').references(() => users.id).notNull(),
  status: complianceStatusEnum('status').default('pending_review'),
  submittedAt: timestamp('submitted_at').defaultNow(),
  reviewedBy: uuid('reviewed_by').references(() => users.id),
  reviewedAt: timestamp('reviewed_at'),
  score: integer('score'),
  feedback: text('feedback'),
  checklistData: jsonb('checklist_data'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const compliancePhotos = pgTable('compliance_photos', {
  id: uuid('id').defaultRandom().primaryKey(),
  complianceRecordId: uuid('compliance_record_id').references(() => complianceRecords.id).notNull(),
  photoUrl: varchar('photo_url', { length: 500 }).notNull(),
  photoType: photoTypeEnum('photo_type'),
  caption: varchar('caption', { length: 255 }),
  metadata: jsonb('metadata'),
  uploadedAt: timestamp('uploaded_at').defaultNow(),
});
```

### Enum Definitions

```typescript
// packages/database/src/schema/enums.ts
export const userRoleEnum = pgEnum('user_role', [
  'super_admin',
  'brand_admin',
  'psp_admin',
  'psp_manager',
  'field_rep',
  'store_manager',
]);

export const campaignStatusEnum = pgEnum('campaign_status', [
  'draft',
  'pending_approval',
  'approved',
  'active',
  'paused',
  'completed',
  'cancelled',
]);

export const taskStatusEnum = pgEnum('task_status', [
  'pending',
  'assigned',
  'in_progress',
  'completed',
  'verified',
  'failed',
  'cancelled',
]);

export const taskTypeEnum = pgEnum('task_type', [
  'installation',
  'verification',
  'maintenance',
  'removal',
  'survey',
]);

export const complianceStatusEnum = pgEnum('compliance_status', [
  'pending_review',
  'approved',
  'rejected',
  'needs_revision',
]);
```

---

## Code Generation Guidelines for AI Assistants

### When generating React components:

1. Use functional components with TypeScript
2. Define props interface separately
3. Use Tailwind CSS for styling
4. Export from index.ts file
5. Include proper accessibility attributes

### When generating API routes:

1. Use Zod for request/response validation
2. Follow RESTful conventions
3. Include proper error handling
4. Use dependency injection for services
5. Include authentication middleware

### When generating database code:

1. Use Drizzle ORM syntax
2. Include proper indexes
3. Define relations explicitly
4. Use appropriate column types
5. Include timestamps on all tables

---

*Last Updated: 2026-01-01*
