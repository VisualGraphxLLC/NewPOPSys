# Implementation Patterns

This document defines the standard code patterns and conventions used throughout the PopSystem codebase.

---

## Table of Contents

1. [Component Structure (Atomic Design)](#component-structure-atomic-design)
2. [API Endpoint Patterns](#api-endpoint-patterns)
3. [State Management with Zustand](#state-management-with-zustand)
4. [Form Handling with React Hook Form + Zod](#form-handling-with-react-hook-form--zod)
5. [Error Handling Patterns](#error-handling-patterns)
6. [Testing Patterns](#testing-patterns)

---

## Component Structure (Atomic Design)

### Atoms

Basic building blocks that cannot be broken down further.

```typescript
// packages/ui/src/atoms/Button/Button.tsx
import { forwardRef } from 'react';
import { cva, type VariantProps } from 'class-variance-authority';
import { cn } from '../../utils/cn';

const buttonVariants = cva(
  'inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50',
  {
    variants: {
      variant: {
        primary: 'bg-primary-600 text-white hover:bg-primary-700',
        secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200',
        outline: 'border border-gray-300 bg-transparent hover:bg-gray-50',
        ghost: 'hover:bg-gray-100',
        danger: 'bg-red-600 text-white hover:bg-red-700',
      },
      size: {
        sm: 'h-8 px-3 text-sm',
        md: 'h-10 px-4 text-sm',
        lg: 'h-12 px-6 text-base',
        icon: 'h-10 w-10',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  }
);

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  isLoading?: boolean;
}

export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, isLoading, children, disabled, ...props }, ref) => {
    return (
      <button
        ref={ref}
        className={cn(buttonVariants({ variant, size }), className)}
        disabled={disabled || isLoading}
        {...props}
      >
        {isLoading && (
          <svg
            className="mr-2 h-4 w-4 animate-spin"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              className="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="4"
            />
            <path
              className="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
            />
          </svg>
        )}
        {children}
      </button>
    );
  }
);

Button.displayName = 'Button';
```

### Molecules

Combinations of atoms that form a functional unit.

```typescript
// packages/ui/src/molecules/FormField/FormField.tsx
import { forwardRef, type ReactNode } from 'react';
import { Input, type InputProps } from '../../atoms/Input';
import { Label } from '../../atoms/Label';
import { cn } from '../../utils/cn';

export interface FormFieldProps extends InputProps {
  label: string;
  error?: string;
  hint?: string;
  required?: boolean;
  leftAddon?: ReactNode;
  rightAddon?: ReactNode;
}

export const FormField = forwardRef<HTMLInputElement, FormFieldProps>(
  ({ label, error, hint, required, className, id, leftAddon, rightAddon, ...props }, ref) => {
    const fieldId = id || label.toLowerCase().replace(/\s+/g, '-');

    return (
      <div className={cn('space-y-1.5', className)}>
        <Label htmlFor={fieldId} required={required}>
          {label}
        </Label>

        <div className="relative">
          {leftAddon && (
            <div className="absolute inset-y-0 left-0 flex items-center pl-3">
              {leftAddon}
            </div>
          )}

          <Input
            ref={ref}
            id={fieldId}
            aria-describedby={error ? `${fieldId}-error` : hint ? `${fieldId}-hint` : undefined}
            aria-invalid={!!error}
            className={cn(
              leftAddon && 'pl-10',
              rightAddon && 'pr-10',
              error && 'border-red-500 focus:ring-red-500'
            )}
            {...props}
          />

          {rightAddon && (
            <div className="absolute inset-y-0 right-0 flex items-center pr-3">
              {rightAddon}
            </div>
          )}
        </div>

        {error && (
          <p id={`${fieldId}-error`} className="text-sm text-red-600">
            {error}
          </p>
        )}

        {hint && !error && (
          <p id={`${fieldId}-hint`} className="text-sm text-gray-500">
            {hint}
          </p>
        )}
      </div>
    );
  }
);

FormField.displayName = 'FormField';
```

### Organisms

Complex components composed of molecules and atoms.

```typescript
// packages/ui/src/organisms/DataTable/DataTable.tsx
import { useState, useMemo, type ReactNode } from 'react';
import {
  useReactTable,
  getCoreRowModel,
  getSortedRowModel,
  getPaginationRowModel,
  getFilteredRowModel,
  flexRender,
  type ColumnDef,
  type SortingState,
} from '@tanstack/react-table';
import { Button } from '../../atoms/Button';
import { Input } from '../../atoms/Input';
import { cn } from '../../utils/cn';

export interface DataTableProps<T> {
  data: T[];
  columns: ColumnDef<T>[];
  searchPlaceholder?: string;
  searchColumn?: string;
  pageSize?: number;
  isLoading?: boolean;
  emptyState?: ReactNode;
  onRowClick?: (row: T) => void;
}

export function DataTable<T extends { id: string | number }>({
  data,
  columns,
  searchPlaceholder = 'Search...',
  searchColumn,
  pageSize = 10,
  isLoading,
  emptyState,
  onRowClick,
}: DataTableProps<T>) {
  const [sorting, setSorting] = useState<SortingState>([]);
  const [globalFilter, setGlobalFilter] = useState('');

  const table = useReactTable({
    data,
    columns,
    state: { sorting, globalFilter },
    onSortingChange: setSorting,
    onGlobalFilterChange: setGlobalFilter,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    initialState: { pagination: { pageSize } },
  });

  if (isLoading) {
    return <DataTableSkeleton columns={columns.length} rows={pageSize} />;
  }

  return (
    <div className="space-y-4">
      {searchColumn && (
        <Input
          placeholder={searchPlaceholder}
          value={globalFilter}
          onChange={(e) => setGlobalFilter(e.target.value)}
          className="max-w-sm"
        />
      )}

      <div className="rounded-md border">
        <table className="w-full">
          <thead className="bg-gray-50">
            {table.getHeaderGroups().map((headerGroup) => (
              <tr key={headerGroup.id}>
                {headerGroup.headers.map((header) => (
                  <th
                    key={header.id}
                    className={cn(
                      'px-4 py-3 text-left text-sm font-medium text-gray-500',
                      header.column.getCanSort() && 'cursor-pointer select-none'
                    )}
                    onClick={header.column.getToggleSortingHandler()}
                  >
                    {flexRender(header.column.columnDef.header, header.getContext())}
                    {header.column.getIsSorted() === 'asc' && ' ↑'}
                    {header.column.getIsSorted() === 'desc' && ' ↓'}
                  </th>
                ))}
              </tr>
            ))}
          </thead>
          <tbody>
            {table.getRowModel().rows.length === 0 ? (
              <tr>
                <td colSpan={columns.length} className="py-8 text-center">
                  {emptyState || 'No results found.'}
                </td>
              </tr>
            ) : (
              table.getRowModel().rows.map((row) => (
                <tr
                  key={row.id}
                  className={cn(
                    'border-t hover:bg-gray-50',
                    onRowClick && 'cursor-pointer'
                  )}
                  onClick={() => onRowClick?.(row.original)}
                >
                  {row.getVisibleCells().map((cell) => (
                    <td key={cell.id} className="px-4 py-3 text-sm">
                      {flexRender(cell.column.columnDef.cell, cell.getContext())}
                    </td>
                  ))}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <div className="flex items-center justify-between">
        <span className="text-sm text-gray-500">
          Page {table.getState().pagination.pageIndex + 1} of {table.getPageCount()}
        </span>
        <div className="flex gap-2">
          <Button
            variant="outline"
            size="sm"
            onClick={() => table.previousPage()}
            disabled={!table.getCanPreviousPage()}
          >
            Previous
          </Button>
          <Button
            variant="outline"
            size="sm"
            onClick={() => table.nextPage()}
            disabled={!table.getCanNextPage()}
          >
            Next
          </Button>
        </div>
      </div>
    </div>
  );
}
```

---

## API Endpoint Patterns

### Route Organization

```typescript
// apps/api/src/routes/tasks/index.ts
import { FastifyPluginAsync } from 'fastify';
import { listTasksRoute } from './list';
import { getTaskRoute } from './get';
import { createTaskRoute } from './create';
import { updateTaskRoute } from './update';
import { completeTaskRoute } from './complete';

export const tasksRoutes: FastifyPluginAsync = async (fastify) => {
  // Apply authentication to all task routes
  fastify.addHook('preHandler', fastify.authenticate);

  fastify.register(listTasksRoute);
  fastify.register(getTaskRoute);
  fastify.register(createTaskRoute);
  fastify.register(updateTaskRoute);
  fastify.register(completeTaskRoute);
};
```

### Schema Definition

```typescript
// apps/api/src/routes/tasks/schemas.ts
import { z } from 'zod';

// Request schemas
export const listTasksQuerySchema = z.object({
  campaignId: z.string().uuid().optional(),
  status: z.enum(['pending', 'assigned', 'in_progress', 'completed']).optional(),
  assignedTo: z.string().uuid().optional(),
  page: z.coerce.number().int().positive().default(1),
  pageSize: z.coerce.number().int().positive().max(100).default(20),
});

export const createTaskBodySchema = z.object({
  campaignId: z.string().uuid(),
  storeId: z.string().uuid(),
  type: z.enum(['installation', 'verification', 'maintenance', 'removal']),
  scheduledDate: z.string().datetime(),
  priority: z.number().int().min(1).max(10).default(5),
  instructions: z.string().max(2000).optional(),
});

export const completeTaskBodySchema = z.object({
  checklistData: z.record(z.boolean()),
  notes: z.string().max(2000).optional(),
  photoIds: z.array(z.string().uuid()).min(1).max(10),
  location: z.object({
    latitude: z.number(),
    longitude: z.number(),
  }),
});

// Response schemas
export const taskSchema = z.object({
  id: z.string().uuid(),
  campaignId: z.string().uuid(),
  storeId: z.string().uuid(),
  assignedTo: z.string().uuid().nullable(),
  type: z.string(),
  status: z.string(),
  priority: z.number(),
  scheduledDate: z.string().nullable(),
  completedAt: z.string().nullable(),
  instructions: z.string().nullable(),
  createdAt: z.string(),
  updatedAt: z.string(),
});

export const paginatedTasksSchema = z.object({
  success: z.literal(true),
  data: z.array(taskSchema),
  meta: z.object({
    page: z.number(),
    pageSize: z.number(),
    total: z.number(),
    totalPages: z.number(),
  }),
});
```

### Route Handler

```typescript
// apps/api/src/routes/tasks/list.ts
import { FastifyPluginAsync } from 'fastify';
import { listTasksQuerySchema, paginatedTasksSchema } from './schemas';
import { TaskService } from '../../services/task.service';

export const listTasksRoute: FastifyPluginAsync = async (fastify) => {
  fastify.get(
    '/tasks',
    {
      schema: {
        description: 'List tasks with filtering and pagination',
        tags: ['Tasks'],
        querystring: listTasksQuerySchema,
        response: {
          200: paginatedTasksSchema,
        },
        security: [{ bearerAuth: [] }],
      },
    },
    async (request, reply) => {
      const query = listTasksQuerySchema.parse(request.query);
      const userId = request.user.id;
      const userRole = request.user.role;

      const taskService = new TaskService(fastify.db);

      const { tasks, total } = await taskService.list({
        ...query,
        // Restrict field reps to their assigned tasks
        assignedTo: userRole === 'field_rep' ? userId : query.assignedTo,
      });

      return reply.send({
        success: true,
        data: tasks,
        meta: {
          page: query.page,
          pageSize: query.pageSize,
          total,
          totalPages: Math.ceil(total / query.pageSize),
        },
      });
    }
  );
};
```

### Service Layer

```typescript
// apps/api/src/services/task.service.ts
import { eq, and, sql, desc, count } from 'drizzle-orm';
import { tasks, stores, users } from '@popsystem/database';
import type { DbClient } from '../plugins/database';

interface ListTasksParams {
  campaignId?: string;
  status?: string;
  assignedTo?: string;
  page: number;
  pageSize: number;
}

export class TaskService {
  constructor(private db: DbClient) {}

  async list(params: ListTasksParams) {
    const { campaignId, status, assignedTo, page, pageSize } = params;
    const offset = (page - 1) * pageSize;

    const conditions = [];
    if (campaignId) conditions.push(eq(tasks.campaignId, campaignId));
    if (status) conditions.push(eq(tasks.status, status));
    if (assignedTo) conditions.push(eq(tasks.assignedTo, assignedTo));

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    const [taskList, [{ total }]] = await Promise.all([
      this.db
        .select({
          id: tasks.id,
          campaignId: tasks.campaignId,
          storeId: tasks.storeId,
          assignedTo: tasks.assignedTo,
          type: tasks.type,
          status: tasks.status,
          priority: tasks.priority,
          scheduledDate: tasks.scheduledDate,
          completedAt: tasks.completedAt,
          instructions: tasks.instructions,
          createdAt: tasks.createdAt,
          updatedAt: tasks.updatedAt,
          store: {
            name: stores.name,
            address: stores.address,
          },
        })
        .from(tasks)
        .leftJoin(stores, eq(tasks.storeId, stores.id))
        .where(whereClause)
        .orderBy(desc(tasks.priority), desc(tasks.createdAt))
        .limit(pageSize)
        .offset(offset),
      this.db
        .select({ total: count() })
        .from(tasks)
        .where(whereClause),
    ]);

    return { tasks: taskList, total };
  }

  async create(data: typeof tasks.$inferInsert) {
    const [task] = await this.db.insert(tasks).values(data).returning();
    return task;
  }

  async complete(taskId: string, data: CompleteTaskData) {
    return this.db.transaction(async (tx) => {
      // Update task status
      const [task] = await tx
        .update(tasks)
        .set({
          status: 'completed',
          completedAt: new Date(),
          notes: data.notes,
          updatedAt: new Date(),
        })
        .where(eq(tasks.id, taskId))
        .returning();

      // Create compliance record
      const [compliance] = await tx
        .insert(complianceRecords)
        .values({
          taskId,
          submittedBy: data.userId,
          checklistData: data.checklistData,
          status: 'pending_review',
        })
        .returning();

      // Link photos to compliance record
      await tx
        .update(compliancePhotos)
        .set({ complianceRecordId: compliance.id })
        .where(inArray(compliancePhotos.id, data.photoIds));

      return { task, compliance };
    });
  }
}
```

---

## State Management with Zustand

### Store Definition

```typescript
// apps/mobile-pwa/src/stores/authStore.ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';
import type { User } from '@popsystem/shared-types';

interface AuthState {
  user: User | null;
  accessToken: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
}

interface AuthActions {
  setUser: (user: User) => void;
  setTokens: (accessToken: string, refreshToken: string) => void;
  logout: () => void;
  setLoading: (isLoading: boolean) => void;
}

type AuthStore = AuthState & AuthActions;

const initialState: AuthState = {
  user: null,
  accessToken: null,
  refreshToken: null,
  isAuthenticated: false,
  isLoading: true,
};

export const useAuthStore = create<AuthStore>()(
  persist(
    immer((set) => ({
      ...initialState,

      setUser: (user) =>
        set((state) => {
          state.user = user;
          state.isAuthenticated = true;
          state.isLoading = false;
        }),

      setTokens: (accessToken, refreshToken) =>
        set((state) => {
          state.accessToken = accessToken;
          state.refreshToken = refreshToken;
        }),

      logout: () =>
        set((state) => {
          state.user = null;
          state.accessToken = null;
          state.refreshToken = null;
          state.isAuthenticated = false;
          state.isLoading = false;
        }),

      setLoading: (isLoading) =>
        set((state) => {
          state.isLoading = isLoading;
        }),
    })),
    {
      name: 'auth-storage',
      storage: createJSONStorage(() => localStorage),
      partialize: (state) => ({
        user: state.user,
        accessToken: state.accessToken,
        refreshToken: state.refreshToken,
        isAuthenticated: state.isAuthenticated,
      }),
    }
  )
);

// Selectors
export const selectUser = (state: AuthStore) => state.user;
export const selectIsAuthenticated = (state: AuthStore) => state.isAuthenticated;
```

### Complex Store with Actions

```typescript
// apps/mobile-pwa/src/stores/offlineStore.ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

interface PendingAction {
  id: string;
  type: 'complete_task' | 'upload_photo' | 'submit_compliance';
  payload: unknown;
  createdAt: string;
  retryCount: number;
}

interface OfflineState {
  isOnline: boolean;
  pendingActions: PendingAction[];
  syncInProgress: boolean;
  lastSyncAt: string | null;
}

interface OfflineActions {
  setOnlineStatus: (isOnline: boolean) => void;
  addPendingAction: (action: Omit<PendingAction, 'id' | 'createdAt' | 'retryCount'>) => void;
  removePendingAction: (id: string) => void;
  incrementRetry: (id: string) => void;
  setSyncInProgress: (inProgress: boolean) => void;
  setLastSyncAt: (date: string) => void;
  clearAllPending: () => void;
}

type OfflineStore = OfflineState & OfflineActions;

export const useOfflineStore = create<OfflineStore>()(
  persist(
    immer((set, get) => ({
      isOnline: navigator.onLine,
      pendingActions: [],
      syncInProgress: false,
      lastSyncAt: null,

      setOnlineStatus: (isOnline) =>
        set((state) => {
          state.isOnline = isOnline;
        }),

      addPendingAction: (action) =>
        set((state) => {
          state.pendingActions.push({
            ...action,
            id: crypto.randomUUID(),
            createdAt: new Date().toISOString(),
            retryCount: 0,
          });
        }),

      removePendingAction: (id) =>
        set((state) => {
          state.pendingActions = state.pendingActions.filter((a) => a.id !== id);
        }),

      incrementRetry: (id) =>
        set((state) => {
          const action = state.pendingActions.find((a) => a.id === id);
          if (action) {
            action.retryCount += 1;
          }
        }),

      setSyncInProgress: (inProgress) =>
        set((state) => {
          state.syncInProgress = inProgress;
        }),

      setLastSyncAt: (date) =>
        set((state) => {
          state.lastSyncAt = date;
        }),

      clearAllPending: () =>
        set((state) => {
          state.pendingActions = [];
        }),
    })),
    {
      name: 'offline-storage',
      storage: createJSONStorage(() => localStorage),
    }
  )
);
```

---

## Form Handling with React Hook Form + Zod

### Form Schema

```typescript
// apps/mobile-pwa/src/schemas/complianceForm.ts
import { z } from 'zod';

export const complianceFormSchema = z.object({
  checklistItems: z.object({
    displayInstalled: z.boolean(),
    correctLocation: z.boolean(),
    properCondition: z.boolean(),
    signageVisible: z.boolean(),
    stockAvailable: z.boolean(),
  }),
  notes: z.string().max(2000).optional(),
  photos: z
    .array(
      z.object({
        id: z.string(),
        uri: z.string(),
        type: z.enum(['before', 'after', 'detail', 'issue']),
      })
    )
    .min(1, 'At least one photo is required')
    .max(10, 'Maximum 10 photos allowed'),
  location: z.object({
    latitude: z.number(),
    longitude: z.number(),
    accuracy: z.number().optional(),
  }),
});

export type ComplianceFormData = z.infer<typeof complianceFormSchema>;
```

### Form Component

```typescript
// apps/mobile-pwa/src/components/compliance/ComplianceForm.tsx
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { Button, FormField, Checkbox, TextArea } from '@popsystem/ui';
import { complianceFormSchema, type ComplianceFormData } from '../../schemas/complianceForm';
import { PhotoCapture } from './PhotoCapture';
import { useGeolocation } from '../../hooks/useGeolocation';
import { api } from '../../lib/api';

interface ComplianceFormProps {
  taskId: string;
  onSuccess?: () => void;
}

export function ComplianceForm({ taskId, onSuccess }: ComplianceFormProps) {
  const queryClient = useQueryClient();
  const { location, error: locationError } = useGeolocation();

  const {
    control,
    handleSubmit,
    formState: { errors, isSubmitting },
    setValue,
    watch,
  } = useForm<ComplianceFormData>({
    resolver: zodResolver(complianceFormSchema),
    defaultValues: {
      checklistItems: {
        displayInstalled: false,
        correctLocation: false,
        properCondition: false,
        signageVisible: false,
        stockAvailable: false,
      },
      notes: '',
      photos: [],
      location: undefined,
    },
  });

  // Update location when available
  useEffect(() => {
    if (location) {
      setValue('location', {
        latitude: location.latitude,
        longitude: location.longitude,
        accuracy: location.accuracy,
      });
    }
  }, [location, setValue]);

  const submitMutation = useMutation({
    mutationFn: (data: ComplianceFormData) =>
      api.compliance.submit(taskId, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['tasks', taskId] });
      queryClient.invalidateQueries({ queryKey: ['tasks'] });
      onSuccess?.();
    },
  });

  const onSubmit = (data: ComplianceFormData) => {
    submitMutation.mutate(data);
  };

  const photos = watch('photos');

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
      {/* Checklist Section */}
      <div className="space-y-4">
        <h3 className="font-medium text-gray-900">Compliance Checklist</h3>

        {Object.entries({
          displayInstalled: 'Display properly installed',
          correctLocation: 'Correct placement location',
          properCondition: 'Display in proper condition',
          signageVisible: 'Signage clearly visible',
          stockAvailable: 'Product stock available',
        }).map(([key, label]) => (
          <Controller
            key={key}
            name={`checklistItems.${key as keyof ComplianceFormData['checklistItems']}`}
            control={control}
            render={({ field }) => (
              <Checkbox
                id={key}
                label={label}
                checked={field.value}
                onChange={field.onChange}
              />
            )}
          />
        ))}
      </div>

      {/* Photo Capture Section */}
      <div className="space-y-4">
        <h3 className="font-medium text-gray-900">
          Photos ({photos.length}/10)
        </h3>

        <Controller
          name="photos"
          control={control}
          render={({ field }) => (
            <PhotoCapture
              photos={field.value}
              onChange={field.onChange}
              maxPhotos={10}
              error={errors.photos?.message}
            />
          )}
        />
      </div>

      {/* Notes Section */}
      <Controller
        name="notes"
        control={control}
        render={({ field }) => (
          <FormField
            label="Additional Notes"
            error={errors.notes?.message}
          >
            <TextArea
              {...field}
              placeholder="Enter any additional observations..."
              rows={4}
            />
          </FormField>
        )}
      />

      {/* Location Status */}
      {locationError && (
        <p className="text-sm text-red-600">
          Location access required. Please enable location services.
        </p>
      )}

      {/* Submit Button */}
      <Button
        type="submit"
        className="w-full"
        isLoading={isSubmitting || submitMutation.isPending}
        disabled={!location || submitMutation.isPending}
      >
        Submit Compliance Report
      </Button>

      {submitMutation.isError && (
        <p className="text-sm text-red-600">
          Failed to submit. Please try again.
        </p>
      )}
    </form>
  );
}
```

---

## Error Handling Patterns

### API Error Types

```typescript
// packages/shared-types/src/api/errors.ts
export class ApiError extends Error {
  constructor(
    public code: string,
    public message: string,
    public statusCode: number,
    public details?: Record<string, string[]>
  ) {
    super(message);
    this.name = 'ApiError';
  }

  static badRequest(message: string, details?: Record<string, string[]>) {
    return new ApiError('BAD_REQUEST', message, 400, details);
  }

  static unauthorized(message = 'Unauthorized') {
    return new ApiError('UNAUTHORIZED', message, 401);
  }

  static forbidden(message = 'Forbidden') {
    return new ApiError('FORBIDDEN', message, 403);
  }

  static notFound(resource: string) {
    return new ApiError('NOT_FOUND', `${resource} not found`, 404);
  }

  static conflict(message: string) {
    return new ApiError('CONFLICT', message, 409);
  }

  static internal(message = 'Internal server error') {
    return new ApiError('INTERNAL_ERROR', message, 500);
  }
}
```

### Error Handler Middleware

```typescript
// apps/api/src/middleware/errorHandler.ts
import { FastifyError, FastifyReply, FastifyRequest } from 'fastify';
import { ZodError } from 'zod';
import { ApiError } from '@popsystem/shared-types';

export function errorHandler(
  error: FastifyError,
  request: FastifyRequest,
  reply: FastifyReply
) {
  request.log.error(error);

  // Handle Zod validation errors
  if (error instanceof ZodError) {
    const details: Record<string, string[]> = {};
    error.errors.forEach((err) => {
      const path = err.path.join('.');
      if (!details[path]) details[path] = [];
      details[path].push(err.message);
    });

    return reply.status(400).send({
      success: false,
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Validation failed',
        details,
      },
    });
  }

  // Handle custom API errors
  if (error instanceof ApiError) {
    return reply.status(error.statusCode).send({
      success: false,
      error: {
        code: error.code,
        message: error.message,
        details: error.details,
      },
    });
  }

  // Handle Fastify errors
  if (error.statusCode) {
    return reply.status(error.statusCode).send({
      success: false,
      error: {
        code: error.code || 'ERROR',
        message: error.message,
      },
    });
  }

  // Unknown errors
  return reply.status(500).send({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
    },
  });
}
```

### Frontend Error Boundary

```typescript
// apps/mobile-pwa/src/components/ErrorBoundary.tsx
import { Component, type ReactNode } from 'react';
import { Button } from '@popsystem/ui';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export class ErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    console.error('Error boundary caught:', error, errorInfo);
    // Send to error tracking service
  }

  handleReset = () => {
    this.setState({ hasError: false, error: null });
  };

  render() {
    if (this.state.hasError) {
      if (this.props.fallback) {
        return this.props.fallback;
      }

      return (
        <div className="flex min-h-screen flex-col items-center justify-center p-4">
          <h1 className="text-xl font-semibold text-gray-900">
            Something went wrong
          </h1>
          <p className="mt-2 text-gray-600">
            We encountered an unexpected error.
          </p>
          <Button
            onClick={this.handleReset}
            className="mt-4"
          >
            Try Again
          </Button>
        </div>
      );
    }

    return this.props.children;
  }
}
```

### Query Error Handling

```typescript
// apps/mobile-pwa/src/hooks/useErrorHandler.ts
import { useCallback } from 'react';
import { toast } from 'sonner';

interface ApiErrorResponse {
  success: false;
  error: {
    code: string;
    message: string;
    details?: Record<string, string[]>;
  };
}

export function useErrorHandler() {
  const handleError = useCallback((error: unknown) => {
    if (error instanceof Response) {
      error.json().then((body: ApiErrorResponse) => {
        toast.error(body.error.message);
      });
      return;
    }

    if (error instanceof Error) {
      toast.error(error.message);
      return;
    }

    toast.error('An unexpected error occurred');
  }, []);

  return { handleError };
}

// Usage with TanStack Query
export function useTasks() {
  const { handleError } = useErrorHandler();

  return useQuery({
    queryKey: ['tasks'],
    queryFn: api.tasks.list,
    onError: handleError,
  });
}
```

---

## Testing Patterns

### Component Testing

```typescript
// packages/ui/src/atoms/Button/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import { Button } from './Button';

describe('Button', () => {
  it('renders children correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click me');
  });

  it('handles click events', () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(<Button isLoading>Submit</Button>);

    expect(screen.getByRole('button')).toBeDisabled();
    expect(screen.getByRole('button')).toHaveAttribute('disabled');
  });

  it('applies variant styles', () => {
    render(<Button variant="danger">Delete</Button>);

    expect(screen.getByRole('button')).toHaveClass('bg-red-600');
  });
});
```

### API Route Testing

```typescript
// apps/api/tests/integration/tasks.test.ts
import { describe, it, expect, beforeAll, afterAll, beforeEach } from 'vitest';
import { buildApp } from '../../src/app';
import { createTestUser, createTestCampaign, cleanupTestData } from '../fixtures';

describe('Tasks API', () => {
  let app: FastifyInstance;
  let authToken: string;
  let testCampaign: Campaign;

  beforeAll(async () => {
    app = await buildApp({ testing: true });
    await app.ready();

    const user = await createTestUser(app.db, { role: 'psp_manager' });
    authToken = app.jwt.sign({ userId: user.id, role: user.role });
    testCampaign = await createTestCampaign(app.db);
  });

  afterAll(async () => {
    await cleanupTestData(app.db);
    await app.close();
  });

  describe('POST /tasks', () => {
    it('creates a new task', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/tasks',
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
        payload: {
          campaignId: testCampaign.id,
          storeId: 'test-store-id',
          type: 'installation',
          scheduledDate: '2024-02-01T10:00:00Z',
        },
      });

      expect(response.statusCode).toBe(201);

      const body = response.json();
      expect(body.success).toBe(true);
      expect(body.data.campaignId).toBe(testCampaign.id);
      expect(body.data.status).toBe('pending');
    });

    it('returns 400 for invalid data', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/tasks',
        headers: {
          Authorization: `Bearer ${authToken}`,
        },
        payload: {
          campaignId: 'invalid-uuid',
        },
      });

      expect(response.statusCode).toBe(400);

      const body = response.json();
      expect(body.success).toBe(false);
      expect(body.error.code).toBe('VALIDATION_ERROR');
    });

    it('returns 401 without auth token', async () => {
      const response = await app.inject({
        method: 'POST',
        url: '/api/v1/tasks',
        payload: {},
      });

      expect(response.statusCode).toBe(401);
    });
  });
});
```

---

*Last Updated: 2026-01-01*
