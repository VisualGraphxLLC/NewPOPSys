# NewPOPSys v1 - AI-Actionable Development Specifications

> **Version:** 1.0
> **Created:** 2025-12-30
> **Target:** Beta End Q1 2026 | Budget: $150,000
> **Purpose:** Provide clear, actionable specifications for AI-assisted development

---

## Table of Contents

1. [Tech Stack & Architecture](#1-tech-stack--architecture)
2. [Project Structure](#2-project-structure)
3. [Sprint Implementation Guide](#3-sprint-implementation-guide)
4. [Module Specifications](#4-module-specifications)
5. [API Contracts](#5-api-contracts)
6. [Database Implementation](#6-database-implementation)
7. [Component Library](#7-component-library)
8. [State Management](#8-state-management)
9. [Testing Requirements](#9-testing-requirements)
10. [Deployment Specifications](#10-deployment-specifications)

---

## 1. Tech Stack & Architecture

### Frontend Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| Framework | React | 18.x | UI Framework |
| Language | TypeScript | 5.x | Type safety |
| Styling | Tailwind CSS | 3.x | Utility-first CSS |
| Components | shadcn/ui | Latest | UI component library |
| State | Zustand | 4.x | Global state management |
| Data Fetching | TanStack Query | 5.x | Server state management |
| Forms | React Hook Form + Zod | Latest | Form handling + validation |
| Routing | React Router | 6.x | Client-side routing |
| Mobile | PWA + Capacitor | Latest | Native wrapper |
| Charts | Recharts | 2.x | Data visualization |
| Tables | TanStack Table | 8.x | Data tables |

### Backend Stack

| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| Runtime | Node.js | 20.x LTS | Server runtime |
| Framework | Fastify | 4.x | HTTP framework |
| Language | TypeScript | 5.x | Type safety |
| ORM | Drizzle ORM | Latest | Database ORM |
| Validation | Zod | 3.x | Schema validation |
| Auth | JWT + bcrypt | - | Authentication |
| Queue | BullMQ | 4.x | Job queue |
| Cache | Redis | 7.x | Session/cache |
| Storage | S3-compatible | - | File storage |

### Database

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Primary | PostgreSQL | 16.x | Main database |
| Cache | Redis | 7.x | Session + cache |
| Search | PostgreSQL FTS | - | Full-text search |

### Infrastructure

| Component | Service | Purpose |
|-----------|---------|---------|
| Container | Docker | Containerization |
| Orchestration | Docker Compose | Local dev |
| Reverse Proxy | Nginx | Load balancing |
| CI/CD | GitHub Actions | Automation |
| Monitoring | Prometheus + Grafana | Metrics |
| Logging | Loki | Log aggregation |

---

## 2. Project Structure

### Monorepo Layout

```
newpopsys/
├── apps/
│   ├── mobile/                 # React PWA + Capacitor
│   │   ├── src/
│   │   │   ├── components/     # Mobile-specific components
│   │   │   ├── screens/        # M01-M08 screens
│   │   │   ├── hooks/          # Custom hooks
│   │   │   ├── store/          # Zustand stores
│   │   │   ├── services/       # API services
│   │   │   └── utils/          # Utilities
│   │   ├── public/
│   │   └── package.json
│   │
│   ├── brand-admin/            # Brand Admin Portal
│   │   ├── src/
│   │   │   ├── components/     # Portal components
│   │   │   ├── pages/          # B01-B07, SET-1 to SET-5
│   │   │   ├── hooks/
│   │   │   ├── store/
│   │   │   └── services/
│   │   └── package.json
│   │
│   ├── store-portal/           # Store Manager Portal
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── pages/          # S01-S05
│   │   │   ├── hooks/
│   │   │   └── services/
│   │   └── package.json
│   │
│   ├── psp-ops/                # PSP Operations Portal
│   │   ├── src/
│   │   │   ├── components/
│   │   │   ├── pages/          # P01-P04
│   │   │   ├── hooks/
│   │   │   └── services/
│   │   └── package.json
│   │
│   └── api/                    # Backend API
│       ├── src/
│       │   ├── routes/         # Route handlers
│       │   ├── services/       # Business logic
│       │   ├── repositories/   # Data access
│       │   ├── middleware/     # Auth, validation
│       │   ├── jobs/           # Background jobs
│       │   └── utils/
│       └── package.json
│
├── packages/
│   ├── ui/                     # Shared UI components
│   │   ├── src/
│   │   │   ├── components/     # Button, Input, Modal, etc.
│   │   │   ├── hooks/
│   │   │   └── utils/
│   │   └── package.json
│   │
│   ├── shared/                 # Shared utilities
│   │   ├── src/
│   │   │   ├── types/          # TypeScript types
│   │   │   ├── schemas/        # Zod schemas
│   │   │   ├── constants/      # Enums, constants
│   │   │   └── utils/
│   │   └── package.json
│   │
│   └── database/               # Database package
│       ├── src/
│       │   ├── schema/         # Drizzle schema
│       │   ├── migrations/     # SQL migrations
│       │   └── seed/           # Seed data
│       └── package.json
│
├── docker/
│   ├── docker-compose.yml
│   ├── docker-compose.dev.yml
│   └── nginx/
│
├── .github/
│   └── workflows/
│
├── turbo.json
├── package.json
└── tsconfig.json
```

---

## 3. Sprint Implementation Guide

### Sprint 0: Foundation (Week 1-2)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S0-01 | Initialize monorepo with Turborepo | P0 | None | - |
| S0-02 | Configure TypeScript, ESLint, Prettier | P0 | S0-01 | - |
| S0-03 | Set up PostgreSQL with Docker | P0 | S0-01 | 06_Database_Model |
| S0-04 | Implement Drizzle schema from DDL | P0 | S0-03 | 01_Schema/*.sql |
| S0-05 | Create database migrations | P0 | S0-04 | - |
| S0-06 | Set up Redis for sessions | P0 | S0-01 | - |
| S0-07 | Configure Fastify with middleware | P0 | S0-01 | - |
| S0-08 | Implement JWT auth service | P0 | S0-07 | L01_Universal_Login.md |
| S0-09 | Create shared UI package | P1 | S0-01 | 07_Component_Library |
| S0-10 | Set up TanStack Query | P1 | S0-09 | - |

#### Implementation Details: S0-04 Drizzle Schema

**File:** `packages/database/src/schema/index.ts`

```typescript
// Import from DDL files in order:
// 1. 00_foundation_ddl.sql - tenants, brands, users, memberships
// 2. brand_module_ddl.sql - campaigns, kits, items
// 3. store_module_ddl.sql - stores, assignments, photos
// 4. psp_module_ddl.sql - orders, shipments, issues
// 5. 12_missing_tables.sql - additional tables

export * from './foundation';
export * from './brand';
export * from './store';
export * from './psp';
export * from './audit';
```

**Schema Pattern (Example):**

```typescript
// packages/database/src/schema/foundation.ts
import { pgTable, uuid, text, timestamp, boolean, pgEnum } from 'drizzle-orm/pg-core';

export const userStatusEnum = pgEnum('user_status', ['active', 'inactive', 'suspended']);

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: text('email').notNull().unique(),
  passwordHash: text('password_hash'),
  mfaEnabled: boolean('mfa_enabled').default(false),
  status: userStatusEnum('status').default('active'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
  deletedAt: timestamp('deleted_at'),
});
```

---

### Sprint 1: Authentication & Mobile Core (Week 3-4)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S1-01 | L01 Universal Login screen | P0 | S0-08 | L01_Universal_Login.md |
| S1-02 | MFA Modal component | P0 | S1-01 | L01_Universal_Login.md |
| S1-03 | SSO Domain Entry modal | P1 | S1-01 | L01_Universal_Login.md |
| S1-04 | Role-based routing | P0 | S1-01 | PERSONA_INTERACTION_MAPS.md |
| S1-05 | M01 Mobile Login screen | P0 | S0-08 | M01_Login.md |
| S1-06 | M02 Dashboard screen | P0 | S1-05 | M02_Dashboard.md |
| S1-07 | M07 Profile screen | P1 | S1-05 | M07_Profile.md |
| S1-08 | Auth API endpoints | P0 | S0-08 | SCREEN_INVENTORY.md Section 7 |
| S1-09 | Session management | P0 | S1-08 | - |
| S1-10 | PWA manifest & service worker | P1 | S1-06 | - |

#### Implementation Details: S1-01 Universal Login

**File:** `apps/brand-admin/src/pages/login/LoginPage.tsx`

```typescript
// Route: /login
// SUPP Reference: SUPP-003, SUPP-001

import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { loginSchema, type LoginInput } from '@newpopsys/shared/schemas';
import { useAuth } from '@/hooks/useAuth';
import { MFAModal } from './MFAModal';
import { ForgotPasswordModal } from './ForgotPasswordModal';
import { SSODomainModal } from './SSODomainModal';
import { RoleSwitcherModal } from './RoleSwitcherModal';

export function LoginPage() {
  const [mfaRequired, setMfaRequired] = useState(false);
  const [showForgotPassword, setShowForgotPassword] = useState(false);
  const [showSSO, setShowSSO] = useState(false);
  const [showRoleSwitcher, setShowRoleSwitcher] = useState(false);
  const [userRoles, setUserRoles] = useState<UserRole[]>([]);

  const { login, verifyMFA } = useAuth();

  const form = useForm<LoginInput>({
    resolver: zodResolver(loginSchema),
    defaultValues: { email: '', password: '', rememberMe: false },
  });

  const onSubmit = async (data: LoginInput) => {
    const result = await login(data);

    if (result.mfaRequired) {
      setMfaRequired(true);
    } else if (result.roles.length > 1) {
      setUserRoles(result.roles);
      setShowRoleSwitcher(true);
    } else {
      // Route based on single role
      routeByRole(result.roles[0]);
    }
  };

  // ... render form with modals
}
```

**API Contract:**

```typescript
// POST /auth/login
interface LoginRequest {
  email: string;
  password: string;
  rememberMe?: boolean;
}

interface LoginResponse {
  success: boolean;
  mfaRequired?: boolean;
  token?: string;
  user?: {
    id: string;
    email: string;
    roles: UserRole[];
  };
}

// POST /auth/mfa/verify
interface MFAVerifyRequest {
  code: string;
  trustDevice?: boolean;
}
```

---

### Sprint 2: Store Execution Core (Week 5-6)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S2-01 | M03 Receipt Survey screen | P0 | S1-06 | M03_Receipt_Survey.md |
| S2-02 | Issue Report modal | P0 | S2-01 | M03_Receipt_Survey.md |
| S2-03 | M04 Install Survey screen | P0 | S2-01 | M04_Install_Survey.md |
| S2-04 | M05 Photo Capture screen | P0 | S2-03 | M05_Photo_Capture.md |
| S2-05 | Photo quality analysis | P1 | S2-04 | M05_Photo_Capture.md |
| S2-06 | M06 Tasks List screen | P0 | S2-03 | M06_Tasks.md |
| S2-07 | Attestation modal | P0 | S2-06 | M06_Tasks.md |
| S2-08 | M08 Retake Flow screen | P0 | S2-04 | M08_Retake.md |
| S2-09 | Offline sync queue | P1 | S2-03 | - |
| S2-10 | Deep link handling | P1 | S1-06 | SCREEN_INVENTORY.md |

#### Implementation Details: S2-04 Photo Capture

**File:** `apps/mobile/src/screens/PhotoCapture/PhotoCaptureScreen.tsx`

```typescript
// Route: /app/camera (modal overlay)
// SUPP Reference: SUPP-037

import { useRef, useState } from 'react';
import { Camera } from '@capacitor/camera';
import { Geolocation } from '@capacitor/geolocation';
import { usePhotoUpload } from '@/hooks/usePhotoUpload';

interface PhotoCaptureProps {
  assignmentItemId: string;
  locationSlot: LocationSlot;
  photoRuleId: string;
  ghostImageUrl?: string;
}

export function PhotoCaptureScreen({
  assignmentItemId,
  locationSlot,
  photoRuleId,
  ghostImageUrl,
}: PhotoCaptureProps) {
  const [capturedPhoto, setCapturedPhoto] = useState<CapturedPhoto | null>(null);
  const [showReview, setShowReview] = useState(false);
  const [qualityWarnings, setQualityWarnings] = useState<string[]>([]);

  const { uploadPhoto, isUploading } = usePhotoUpload();

  const capturePhoto = async () => {
    // Get GPS coordinates
    const position = await Geolocation.getCurrentPosition();

    // Capture with camera
    const photo = await Camera.getPhoto({
      quality: 90,
      allowEditing: false,
      resultType: 'base64',
      source: 'CAMERA',
    });

    // Analyze quality
    const warnings = analyzePhotoQuality(photo);

    setCapturedPhoto({
      base64: photo.base64String!,
      format: photo.format,
      capturedAt: new Date().toISOString(),
      deviceModel: await getDeviceInfo(),
      gpsCoordinates: {
        lat: position.coords.latitude,
        lng: position.coords.longitude,
      },
      resolution: `${photo.webPath}`, // Extract actual resolution
    });

    setQualityWarnings(warnings);
    setShowReview(true);
  };

  const confirmPhoto = async () => {
    if (!capturedPhoto) return;

    await uploadPhoto({
      assignmentItemId,
      locationSlot,
      photoRuleId,
      ...capturedPhoto,
    });
  };

  // ... render camera UI with ghost overlay
}
```

**Database References:**

```sql
-- From store_module_ddl.sql
-- Table: photo_uploads
-- Fields: id, assignment_item_id, location_slot, storage_url,
--         review_status, captured_at, device_model, gps_lat, gps_lng,
--         file_size, resolution, created_at

-- From 12_missing_tables.sql
-- Table: photo_links
-- Fields: id, photo_upload_id, requirement_id, status
```

---

### Sprint 3: Campaign Management (Week 7-8)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S3-01 | B01 Dashboard screen | P0 | S1-01 | B01_Dashboard.md |
| S3-02 | B02 Campaign List screen | P0 | S3-01 | B02_Campaign_List.md |
| S3-03 | B03 Store Selection (Wizard Step 1) | P0 | S3-02 | B03_Store_Selection.md |
| S3-04 | B04 Kit Definition (Wizard Step 2) | P0 | S3-03 | B04_Kit_Definition.md |
| S3-05 | B05 Campaign Review (Wizard Step 3) | P0 | S3-04 | B05_Campaign_Review.md |
| S3-06 | Campaign publish flow | P0 | S3-05 | B05_Campaign_Review.md |
| S3-07 | Store selection recipe builder | P1 | S3-03 | SUPP-002 |
| S3-08 | Kit item drag-drop | P1 | S3-04 | B04_Kit_Definition.md |
| S3-09 | Campaign validation service | P0 | S3-05 | B05_Campaign_Review.md |
| S3-10 | Order generation job | P0 | S3-06 | SUPP-016 |

#### Implementation Details: S3-03 Store Selection

**File:** `apps/brand-admin/src/pages/campaigns/create/StoreSelectionPage.tsx`

```typescript
// Route: /admin/campaigns/create/stores
// SUPP Reference: SUPP-002

import { useState, useCallback } from 'react';
import { useQuery, useMutation } from '@tanstack/react-query';
import { StoreSelectionRecipe, SelectionMode } from '@newpopsys/shared/types';

export function StoreSelectionPage() {
  const [recipe, setRecipe] = useState<StoreSelectionRecipe>({
    mode: 'include',
    baseSet: 'all',
    includes: {
      regions: [],
      districts: [],
      territories: [],
      storeGroups: [],
      stores: [],
    },
    excludes: {
      regions: [],
      districts: [],
      territories: [],
      stores: [],
    },
  });

  const { data: preview, isLoading } = useQuery({
    queryKey: ['store-preview', recipe],
    queryFn: () => previewStoreSelection(recipe),
    enabled: hasSelections(recipe),
  });

  // Handlers for include/exclude panel updates
  const addRegion = useCallback((regionId: string, panel: 'includes' | 'excludes') => {
    setRecipe(prev => ({
      ...prev,
      [panel]: {
        ...prev[panel],
        regions: [...prev[panel].regions, regionId],
      },
    }));
  }, []);

  // ... render three-column layout:
  // Left: Include panel
  // Center: Store preview with count
  // Right: Exclude panel
}
```

**API Contract:**

```typescript
// POST /stores/preview
interface StorePreviewRequest {
  recipe: StoreSelectionRecipe;
}

interface StorePreviewResponse {
  totalCount: number;
  stores: Array<{
    id: string;
    storeNumber: string;
    name: string;
    region: string;
    district: string;
  }>;
  breakdown: {
    byRegion: Record<string, number>;
    byDistrict: Record<string, number>;
  };
}
```

---

### Sprint 4: Verification & PSP (Week 9-10)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S4-01 | B07 Verification Queue screen | P0 | S3-01 | B07_Verification.md |
| S4-02 | Photo lightbox component | P0 | S4-01 | B07_Verification.md |
| S4-03 | Bulk review actions | P1 | S4-01 | B07_Verification.md |
| S4-04 | P01 Order Queue screen | P0 | S3-10 | P01_Order_Queue.md |
| S4-05 | P02 Shipments screen | P0 | S4-04 | P02_Shipments.md |
| S4-06 | Create Shipment modal | P0 | S4-05 | P02_Shipments.md |
| S4-07 | P03 Issues Queue screen | P0 | S4-04 | P03_Issues.md |
| S4-08 | Issue triage workflow | P0 | S4-07 | P03_Issues.md |
| S4-09 | P04 Batches screen | P1 | S4-04 | SUPP-016 |
| S4-10 | Reorder generation | P0 | S4-07 | SUPP-019 |

#### Implementation Details: S4-01 Verification Queue

**File:** `apps/brand-admin/src/pages/verification/VerificationQueuePage.tsx`

```typescript
// Route: /admin/verification
// SUPP Reference: SUPP-018

import { useState } from 'react';
import { useInfiniteQuery, useMutation } from '@tanstack/react-query';
import { PhotoLightbox } from './PhotoLightbox';
import { RejectionModal } from './RejectionModal';

const REJECTION_REASONS = [
  { code: 'WRONG_ANGLE', label: 'Wrong Angle' },
  { code: 'TOO_DARK', label: 'Too Dark' },
  { code: 'BLURRY', label: 'Blurry' },
  { code: 'WRONG_ITEM', label: 'Wrong Item' },
  { code: 'INCOMPLETE', label: 'Incomplete' },
  { code: 'OBSTRUCTED', label: 'Obstructed' },
  { code: 'OTHER', label: 'Other' },
] as const;

export function VerificationQueuePage() {
  const [selectedPhoto, setSelectedPhoto] = useState<Photo | null>(null);
  const [showRejection, setShowRejection] = useState(false);
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  const { data, fetchNextPage, hasNextPage } = useInfiniteQuery({
    queryKey: ['photos', 'pending'],
    queryFn: ({ pageParam }) => fetchPendingPhotos({ cursor: pageParam }),
    getNextPageParam: (lastPage) => lastPage.nextCursor,
  });

  const reviewMutation = useMutation({
    mutationFn: reviewPhoto,
    onSuccess: () => {
      // Move to next photo in queue
      moveToNextPhoto();
    },
  });

  const bulkReviewMutation = useMutation({
    mutationFn: bulkReviewPhotos,
    onSuccess: () => {
      setSelectedIds(new Set());
    },
  });

  const handleApprove = () => {
    if (selectedPhoto) {
      reviewMutation.mutate({
        photoId: selectedPhoto.id,
        decision: 'APPROVED',
      });
    }
  };

  const handleReject = (reason: string, comment?: string) => {
    if (selectedPhoto) {
      reviewMutation.mutate({
        photoId: selectedPhoto.id,
        decision: 'REJECTED',
        rejectionReason: reason,
        comment,
      });
    }
  };

  // ... render grid with lightbox
}
```

---

### Sprint 5: Store Portal & Reporting (Week 11-12)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S5-01 | S01 Store Dashboard screen | P0 | S1-01 | S01_Dashboard.md |
| S5-02 | S02 Campaign History screen | P0 | S5-01 | S02_Campaign_History.md |
| S5-03 | S03 Photo Gallery screen | P0 | S5-01 | S03_Photo_Gallery.md |
| S5-04 | S04 Team Management screen | P0 | S5-01 | S04_Team_Management.md |
| S5-05 | S05 Reports screen | P0 | S5-01 | S05_Reports.md |
| S5-06 | B06 Store List screen | P0 | S3-01 | B06_Store_List.md |
| S5-07 | SET-1 Settings Hub | P1 | S3-01 | SCREEN_INVENTORY.md |
| S5-08 | SET-2 User Management | P1 | S5-07 | SCREEN_INVENTORY.md |
| S5-09 | SET-4 Export History | P1 | S5-07 | SCREEN_INVENTORY.md |
| S5-10 | SET-5 Audit Log | P1 | S5-07 | SCREEN_INVENTORY.md |

---

### Sprint 6: Polish & Beta (Week 13)

#### Tasks

| ID | Task | Priority | Dependencies | Spec Reference |
|----|------|----------|--------------|----------------|
| S6-01 | End-to-end testing | P0 | All | - |
| S6-02 | Performance optimization | P0 | All | - |
| S6-03 | Accessibility audit | P1 | All | - |
| S6-04 | Security audit | P0 | All | - |
| S6-05 | Documentation | P1 | All | - |
| S6-06 | Deployment scripts | P0 | All | - |
| S6-07 | Monitoring setup | P1 | S6-06 | - |
| S6-08 | Beta environment | P0 | S6-06 | - |

---

## 4. Module Specifications

### 4.1 Authentication Module

**Location:** `apps/api/src/routes/auth/`

#### Endpoints

| Method | Path | Handler | Description |
|--------|------|---------|-------------|
| POST | `/auth/login` | loginHandler | Email/password login |
| POST | `/auth/logout` | logoutHandler | Terminate session |
| POST | `/auth/mfa/verify` | mfaVerifyHandler | Verify TOTP code |
| POST | `/auth/password/reset-request` | resetRequestHandler | Request reset email |
| POST | `/auth/password/reset` | resetHandler | Set new password |
| POST | `/auth/sso/init` | ssoInitHandler | Start SSO flow |
| POST | `/auth/sso/callback` | ssoCallbackHandler | Handle SSO response |
| GET | `/auth/session` | sessionHandler | Get session info |
| POST | `/auth/refresh` | refreshHandler | Refresh JWT |

#### Security Requirements

```typescript
// packages/shared/src/schemas/auth.ts
import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  rememberMe: z.boolean().optional().default(false),
});

export const mfaSchema = z.object({
  code: z.string().length(6, 'Code must be 6 digits').regex(/^\d+$/, 'Code must be numeric'),
  trustDevice: z.boolean().optional().default(false),
});

// Rate limiting config
export const AUTH_RATE_LIMITS = {
  login: { windowMs: 15 * 60 * 1000, max: 5 }, // 5 attempts per 15 min
  mfa: { windowMs: 5 * 60 * 1000, max: 3 },    // 3 attempts per 5 min
  passwordReset: { windowMs: 60 * 60 * 1000, max: 3 }, // 3 per hour
};
```

---

### 4.2 Mobile App Module

**Location:** `apps/mobile/src/screens/`

#### Screen Files

| Screen ID | File | Route | Components |
|-----------|------|-------|------------|
| M01 | `Login/LoginScreen.tsx` | `/app/login` | PINInput, ErrorAlert |
| M02 | `Dashboard/DashboardScreen.tsx` | `/app/dashboard` | CampaignCard, NotificationBadge |
| M03 | `Receipt/ReceiptSurveyScreen.tsx` | `/app/campaign/:id/receipt` | ItemChecklist, IssueModal |
| M04 | `Install/InstallSurveyScreen.tsx` | `/app/campaign/:id/install` | SurveyField, PhotoButton |
| M05 | `Camera/PhotoCaptureScreen.tsx` | `/app/camera` | CameraView, GhostOverlay, ReviewModal |
| M06 | `Tasks/TasksListScreen.tsx` | `/app/tasks` | TaskCard, AttestationModal |
| M07 | `Profile/ProfileScreen.tsx` | `/app/profile` | EditProfileModal, ChangePINFlow |
| M08 | `Retake/RetakeFlowScreen.tsx` | `/app/campaign/:id/retake` | RejectedPhotoCard |

#### Offline Support

```typescript
// apps/mobile/src/services/offline/syncQueue.ts
import { openDB, DBSchema } from 'idb';

interface SyncQueueDB extends DBSchema {
  pendingUploads: {
    key: string;
    value: {
      id: string;
      type: 'photo' | 'survey' | 'issue';
      payload: unknown;
      createdAt: string;
      retryCount: number;
    };
  };
  cachedData: {
    key: string;
    value: {
      key: string;
      data: unknown;
      expiresAt: string;
    };
  };
}

export async function initSyncQueue() {
  return openDB<SyncQueueDB>('newpopsys-sync', 1, {
    upgrade(db) {
      db.createObjectStore('pendingUploads', { keyPath: 'id' });
      db.createObjectStore('cachedData', { keyPath: 'key' });
    },
  });
}

export async function queueForSync(item: PendingUpload) {
  const db = await initSyncQueue();
  await db.put('pendingUploads', item);
}

export async function processSyncQueue() {
  const db = await initSyncQueue();
  const pending = await db.getAll('pendingUploads');

  for (const item of pending) {
    try {
      await syncItem(item);
      await db.delete('pendingUploads', item.id);
    } catch (error) {
      if (item.retryCount < 3) {
        await db.put('pendingUploads', {
          ...item,
          retryCount: item.retryCount + 1,
        });
      }
    }
  }
}
```

---

### 4.3 Brand Admin Module

**Location:** `apps/brand-admin/src/pages/`

#### Screen Files

| Screen ID | File | Route | Key Components |
|-----------|------|-------|----------------|
| B01 | `dashboard/DashboardPage.tsx` | `/admin/dashboard` | KPICard, CampaignTable, AlertPanel |
| B02 | `campaigns/CampaignListPage.tsx` | `/admin/campaigns` | CampaignTable, StatusBadge |
| B03 | `campaigns/create/StoreSelectionPage.tsx` | `/admin/campaigns/create/stores` | IncludePanel, ExcludePanel, StorePreview |
| B04 | `campaigns/create/KitDefinitionPage.tsx` | `/admin/campaigns/:id/edit/kit` | ItemLibrary, KitCanvas, DragDropContext |
| B05 | `campaigns/create/CampaignReviewPage.tsx` | `/admin/campaigns/:id/edit/review` | ValidationSummary, PublishModal |
| B06 | `stores/StoreListPage.tsx` | `/admin/stores` | StoreTable, BulkActions, FilterPanel |
| B07 | `verification/VerificationQueuePage.tsx` | `/admin/verification` | PhotoGrid, Lightbox, RejectionModal |

#### Campaign Wizard State

```typescript
// apps/brand-admin/src/store/campaignWizard.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface CampaignWizardState {
  step: 1 | 2 | 3;
  campaign: {
    name: string;
    type: 'expiring' | 'core_branding';
    startDate: string | null;
    endDate: string | null;
    verificationMode: 'STRICT' | 'FAST';
    selectionRecipe: StoreSelectionRecipe | null;
    kit: KitDefinition | null;
  };
  // Actions
  setStep: (step: 1 | 2 | 3) => void;
  setCampaignName: (name: string) => void;
  setSelectionRecipe: (recipe: StoreSelectionRecipe) => void;
  setKit: (kit: KitDefinition) => void;
  reset: () => void;
}

export const useCampaignWizard = create<CampaignWizardState>()(
  persist(
    (set) => ({
      step: 1,
      campaign: {
        name: '',
        type: 'expiring',
        startDate: null,
        endDate: null,
        verificationMode: 'STRICT',
        selectionRecipe: null,
        kit: null,
      },
      setStep: (step) => set({ step }),
      setCampaignName: (name) => set((state) => ({
        campaign: { ...state.campaign, name },
      })),
      setSelectionRecipe: (recipe) => set((state) => ({
        campaign: { ...state.campaign, selectionRecipe: recipe },
      })),
      setKit: (kit) => set((state) => ({
        campaign: { ...state.campaign, kit },
      })),
      reset: () => set({
        step: 1,
        campaign: {
          name: '',
          type: 'expiring',
          startDate: null,
          endDate: null,
          verificationMode: 'STRICT',
          selectionRecipe: null,
          kit: null,
        },
      }),
    }),
    { name: 'campaign-wizard' }
  )
);
```

---

### 4.4 PSP Operations Module

**Location:** `apps/psp-ops/src/pages/`

#### Screen Files

| Screen ID | File | Route | Key Components |
|-----------|------|-------|----------------|
| P01 | `orders/OrderQueuePage.tsx` | `/psp/orders` | OrderTable, OrderDetailPanel, BulkActions |
| P02 | `shipments/ShipmentsPage.tsx` | `/psp/shipments` | ShipmentTable, CreateShipmentModal, TrackingTimeline |
| P03 | `issues/IssuesQueuePage.tsx` | `/psp/issues` | IssueTable, IssueDetailPanel, ReorderModal |
| P04 | `batches/BatchesPage.tsx` | `/psp/batches` | BatchTable, CreateBatchModal, PickListPrint |

#### Order Status Flow

```typescript
// packages/shared/src/constants/orderStatus.ts
export const ORDER_STATUS_FLOW = {
  GENERATED: {
    next: ['ACKNOWLEDGED'],
    actions: ['acknowledge'],
  },
  ACKNOWLEDGED: {
    next: ['PICKING', 'SHIPPED'],
    actions: ['addToBatch', 'createShipment'],
  },
  PICKING: {
    next: ['SHIPPED'],
    actions: ['createShipment'],
  },
  SHIPPED: {
    next: ['DELIVERED', 'EXCEPTION'],
    actions: ['updateTracking'],
  },
  DELIVERED: {
    next: [],
    actions: [],
  },
  EXCEPTION: {
    next: ['SHIPPED', 'CANCELLED'],
    actions: ['resolveException', 'cancel'],
  },
  CANCELLED: {
    next: [],
    actions: [],
  },
} as const;

export const SHIPMENT_STATUS_FLOW = {
  LABEL_CREATED: {
    next: ['IN_TRANSIT'],
  },
  IN_TRANSIT: {
    next: ['OUT_FOR_DELIVERY', 'EXCEPTION'],
  },
  OUT_FOR_DELIVERY: {
    next: ['DELIVERED', 'EXCEPTION'],
  },
  DELIVERED: {
    next: [],
  },
  EXCEPTION: {
    next: ['IN_TRANSIT', 'DELIVERED'],
  },
} as const;
```

---

## 5. API Contracts

### 5.1 REST API Standards

```typescript
// packages/shared/src/types/api.ts

// Standard response wrapper
export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: Record<string, string[]>;
  };
  meta?: {
    page?: number;
    pageSize?: number;
    total?: number;
    hasMore?: boolean;
  };
}

// Pagination request
export interface PaginationParams {
  page?: number;
  pageSize?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

// Standard error codes
export const API_ERROR_CODES = {
  VALIDATION_ERROR: 'VALIDATION_ERROR',
  UNAUTHORIZED: 'UNAUTHORIZED',
  FORBIDDEN: 'FORBIDDEN',
  NOT_FOUND: 'NOT_FOUND',
  CONFLICT: 'CONFLICT',
  RATE_LIMITED: 'RATE_LIMITED',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
} as const;
```

### 5.2 Campaign Endpoints

```typescript
// GET /campaigns
interface ListCampaignsRequest extends PaginationParams {
  brandId: string;
  status?: CampaignStatus[];
  search?: string;
}

interface ListCampaignsResponse extends ApiResponse<Campaign[]> {
  meta: {
    page: number;
    pageSize: number;
    total: number;
    statusCounts: Record<CampaignStatus, number>;
  };
}

// POST /campaigns
interface CreateCampaignRequest {
  brandId: string;
  name: string;
  type: 'expiring' | 'core_branding';
  startDate: string;
  endDate?: string;
  verificationMode: 'STRICT' | 'FAST';
  selectionRecipe: StoreSelectionRecipe;
}

// PUT /campaigns/:id/kit
interface SaveKitRequest {
  items: Array<{
    itemTemplateId: string;
    quantity: number;
    locationSlot: LocationSlot;
    photoRules: PhotoRuleConfig[];
  }>;
}

// POST /campaigns/:id/publish
interface PublishCampaignRequest {
  scheduledDate?: string; // If omitted, publish immediately
}

interface PublishCampaignResponse extends ApiResponse<{
  campaignId: string;
  status: 'PUBLISHED' | 'SCHEDULED';
  ordersGenerated: number;
  assignmentsCreated: number;
}> {}
```

### 5.3 Photo Endpoints

```typescript
// POST /photos
interface UploadPhotoRequest {
  assignmentItemId: string;
  locationSlot: LocationSlot;
  photoRuleId: string;
  base64: string;
  format: 'jpeg' | 'png';
  capturedAt: string;
  deviceModel: string;
  gpsLat?: number;
  gpsLng?: number;
  resolution: string;
}

interface UploadPhotoResponse extends ApiResponse<{
  photoId: string;
  uploadUrl: string; // Pre-signed S3 URL
  status: 'PENDING_UPLOAD' | 'UPLOADED';
}> {}

// POST /photos/:id/review
interface ReviewPhotoRequest {
  decision: 'APPROVED' | 'REJECTED';
  rejectionReason?: RejectionReason;
  comment?: string;
}

// POST /photos/bulk-review
interface BulkReviewPhotosRequest {
  photoIds: string[];
  decision: 'APPROVED' | 'REJECTED';
  rejectionReason?: RejectionReason;
  comment?: string;
}
```

---

## 6. Database Implementation

### 6.1 Drizzle Schema Mapping

Reference the DDL files in `06_Database_Model/01_Schema/`:

| DDL File | Drizzle File | Tables |
|----------|--------------|--------|
| `00_foundation_ddl.sql` | `schema/foundation.ts` | tenants, brands, users, memberships, api_keys |
| `brand_module_ddl.sql` | `schema/brand.ts` | campaigns, kits, kit_items, photo_rules, regions, districts |
| `store_module_ddl.sql` | `schema/store.ts` | stores, assignments, assignment_items, photo_uploads |
| `psp_module_ddl.sql` | `schema/psp.ts` | store_orders, order_lines, shipments, issue_requests |
| `12_missing_tables.sql` | `schema/extensions.ts` | photo_links, completion_submissions, store_change_verification |

### 6.2 Common Query Patterns

```typescript
// packages/database/src/queries/campaigns.ts
import { db } from '../client';
import { campaigns, storeAssignments, stores } from '../schema';
import { eq, and, inArray, sql } from 'drizzle-orm';

export async function getCampaignWithStats(campaignId: string) {
  const [campaign] = await db
    .select({
      ...campaigns,
      totalStores: sql<number>`count(distinct ${storeAssignments.storeId})`,
      completedStores: sql<number>`count(distinct case when ${storeAssignments.status} = 'COMPLETED' then ${storeAssignments.storeId} end)`,
    })
    .from(campaigns)
    .leftJoin(storeAssignments, eq(campaigns.id, storeAssignments.campaignId))
    .where(eq(campaigns.id, campaignId))
    .groupBy(campaigns.id);

  return campaign;
}

export async function getAssignmentsByStore(storeId: string, status?: string[]) {
  return db
    .select()
    .from(storeAssignments)
    .where(
      and(
        eq(storeAssignments.storeId, storeId),
        status ? inArray(storeAssignments.status, status) : undefined
      )
    )
    .orderBy(storeAssignments.createdAt);
}
```

### 6.3 Index References

Reference `06_Database_Model/04_Indexes/` for performance indexes:

| Query Pattern | Index File | Key Indexes |
|---------------|------------|-------------|
| User lookup | `01_idx_lookup.sql` | `idx_users_email`, `idx_memberships_user_brand` |
| Campaign listing | `03_idx_campaigns.sql` | `idx_campaigns_brand_dates`, `idx_campaigns_status` |
| Photo review | `05_idx_photos.sql` | `idx_photo_uploads_pending_review`, `idx_photo_uploads_rejected` |
| Order queue | `04_idx_fulfillment.sql` | `idx_store_orders_pending_ack`, `idx_store_orders_psp_ref` |
| Audit trail | `07_idx_audit.sql` | `idx_audit_events_entity_type_id_time` |

---

## 7. Component Library

### 7.1 Shared UI Components

**Location:** `packages/ui/src/components/`

| Component | File | Props | Usage |
|-----------|------|-------|-------|
| Button | `Button.tsx` | variant, size, loading, disabled | All apps |
| Input | `Input.tsx` | type, error, label, helper | Forms |
| Select | `Select.tsx` | options, multiple, searchable | Forms |
| Modal | `Modal.tsx` | open, onClose, title, size | Dialogs |
| DataTable | `DataTable.tsx` | columns, data, pagination, sorting | Lists |
| Badge | `Badge.tsx` | variant, children | Status indicators |
| Card | `Card.tsx` | header, footer, children | Content containers |
| Tabs | `Tabs.tsx` | items, activeKey, onChange | Navigation |
| Toast | `Toast.tsx` | type, message, duration | Notifications |
| Spinner | `Spinner.tsx` | size | Loading states |

### 7.2 Domain-Specific Components

**Location:** `apps/*/src/components/`

| Component | App | File | Purpose |
|-----------|-----|------|---------|
| CampaignCard | Mobile | `CampaignCard.tsx` | Dashboard campaign display |
| PhotoGrid | Brand Admin | `PhotoGrid.tsx` | Verification queue grid |
| Lightbox | Brand Admin | `Lightbox.tsx` | Photo review with ghost overlay |
| StoreSelector | Brand Admin | `StoreSelector.tsx` | Include/exclude store panels |
| KitCanvas | Brand Admin | `KitCanvas.tsx` | Drag-drop kit builder |
| OrderTable | PSP | `OrderTable.tsx` | Order queue with bulk actions |
| ShipmentForm | PSP | `ShipmentForm.tsx` | Create/edit shipment |
| IssueDetail | PSP | `IssueDetail.tsx` | Issue triage panel |

---

## 8. State Management

### 8.1 Zustand Store Pattern

```typescript
// packages/shared/src/store/createStore.ts
import { create, StateCreator } from 'zustand';
import { devtools, persist, PersistOptions } from 'zustand/middleware';

export function createPersistedStore<T>(
  name: string,
  storeCreator: StateCreator<T>,
  persistOptions?: Partial<PersistOptions<T>>
) {
  return create<T>()(
    devtools(
      persist(storeCreator, {
        name,
        ...persistOptions,
      }),
      { name }
    )
  );
}
```

### 8.2 Authentication Store

```typescript
// packages/shared/src/store/auth.ts
import { createPersistedStore } from './createStore';

interface AuthState {
  user: User | null;
  token: string | null;
  roles: UserRole[];
  activeRole: UserRole | null;
  // Actions
  setAuth: (user: User, token: string, roles: UserRole[]) => void;
  setActiveRole: (role: UserRole) => void;
  clearAuth: () => void;
  // Selectors
  isAuthenticated: () => boolean;
  hasRole: (role: UserRole) => boolean;
  canAccess: (permission: Permission) => boolean;
}

export const useAuth = createPersistedStore<AuthState>('auth', (set, get) => ({
  user: null,
  token: null,
  roles: [],
  activeRole: null,

  setAuth: (user, token, roles) => set({
    user,
    token,
    roles,
    activeRole: roles[0], // Default to highest priority role
  }),

  setActiveRole: (role) => set({ activeRole: role }),

  clearAuth: () => set({
    user: null,
    token: null,
    roles: [],
    activeRole: null,
  }),

  isAuthenticated: () => get().token !== null,

  hasRole: (role) => get().roles.includes(role),

  canAccess: (permission) => {
    const { activeRole } = get();
    if (!activeRole) return false;
    return ROLE_PERMISSIONS[activeRole].includes(permission);
  },
}));
```

### 8.3 TanStack Query Setup

```typescript
// packages/shared/src/query/queryClient.ts
import { QueryClient } from '@tanstack/react-query';

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5, // 5 minutes
      gcTime: 1000 * 60 * 30, // 30 minutes
      retry: (failureCount, error) => {
        if (error instanceof ApiError && error.status === 401) {
          return false; // Don't retry auth errors
        }
        return failureCount < 3;
      },
      refetchOnWindowFocus: false,
    },
    mutations: {
      retry: false,
    },
  },
});

// Query key factory
export const queryKeys = {
  campaigns: {
    all: ['campaigns'] as const,
    list: (brandId: string, filters?: object) =>
      ['campaigns', 'list', brandId, filters] as const,
    detail: (id: string) => ['campaigns', 'detail', id] as const,
  },
  photos: {
    pending: ['photos', 'pending'] as const,
    byAssignment: (assignmentId: string) =>
      ['photos', 'assignment', assignmentId] as const,
  },
  orders: {
    queue: (status?: string[]) => ['orders', 'queue', status] as const,
    detail: (id: string) => ['orders', 'detail', id] as const,
  },
  // ... more query keys
};
```

---

## 9. Testing Requirements

### 9.1 Test Structure

```
tests/
├── unit/                    # Unit tests
│   ├── components/          # UI component tests
│   ├── hooks/               # Custom hook tests
│   ├── services/            # Service function tests
│   └── utils/               # Utility function tests
├── integration/             # Integration tests
│   ├── api/                 # API endpoint tests
│   └── database/            # Database query tests
├── e2e/                     # End-to-end tests
│   ├── mobile/              # Mobile app flows
│   ├── brand-admin/         # Brand admin flows
│   ├── store-portal/        # Store portal flows
│   └── psp-ops/             # PSP ops flows
└── fixtures/                # Test data fixtures
```

### 9.2 Critical Test Paths

| Flow | Priority | Test File | Coverage |
|------|----------|-----------|----------|
| User login (web) | P0 | `e2e/auth/web-login.spec.ts` | Email/pass, MFA, SSO |
| User login (mobile) | P0 | `e2e/auth/mobile-login.spec.ts` | PIN, session |
| Campaign creation | P0 | `e2e/brand-admin/campaign-wizard.spec.ts` | Full wizard flow |
| Photo capture | P0 | `e2e/mobile/photo-capture.spec.ts` | Capture, upload, sync |
| Photo verification | P0 | `e2e/brand-admin/verification.spec.ts` | Approve, reject, bulk |
| Order fulfillment | P0 | `e2e/psp-ops/order-flow.spec.ts` | Acknowledge, ship |
| Issue handling | P0 | `e2e/psp-ops/issues.spec.ts` | Triage, approve, reorder |

### 9.3 Test Data Fixtures

```typescript
// tests/fixtures/campaigns.ts
export const mockCampaign = {
  id: 'camp_001',
  brandId: 'brand_001',
  name: 'Summer Promo 2026',
  type: 'expiring',
  status: 'PUBLISHED',
  startDate: '2026-06-01',
  endDate: '2026-08-31',
  verificationMode: 'STRICT',
  selectionRecipe: {
    mode: 'include',
    baseSet: 'all',
    includes: { regions: ['reg_001'], stores: [] },
    excludes: { stores: ['store_099'] },
  },
  createdAt: '2026-05-01T00:00:00Z',
  updatedAt: '2026-05-15T00:00:00Z',
};

export const mockAssignment = {
  id: 'assign_001',
  campaignId: 'camp_001',
  storeId: 'store_001',
  status: 'READY_TO_INSTALL',
  kitId: 'kit_001',
  createdAt: '2026-06-01T00:00:00Z',
};
```

---

## 10. Deployment Specifications

### 10.1 Docker Compose (Development)

```yaml
# docker/docker-compose.dev.yml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: newpopsys
      POSTGRES_USER: newpopsys
      POSTGRES_PASSWORD: devpassword
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  api:
    build:
      context: ..
      dockerfile: docker/Dockerfile.api
    environment:
      DATABASE_URL: postgresql://newpopsys:devpassword@postgres:5432/newpopsys
      REDIS_URL: redis://redis:6379
      JWT_SECRET: dev-secret-change-in-production
    ports:
      - "3000:3000"
    depends_on:
      - postgres
      - redis

  mobile:
    build:
      context: ..
      dockerfile: docker/Dockerfile.mobile
    ports:
      - "3001:3000"

  brand-admin:
    build:
      context: ..
      dockerfile: docker/Dockerfile.brand-admin
    ports:
      - "3002:3000"

  store-portal:
    build:
      context: ..
      dockerfile: docker/Dockerfile.store-portal
    ports:
      - "3003:3000"

  psp-ops:
    build:
      context: ..
      dockerfile: docker/Dockerfile.psp-ops
    ports:
      - "3004:3000"

volumes:
  postgres_data:
```

### 10.2 Environment Variables

```bash
# .env.example

# Database
DATABASE_URL=postgresql://user:pass@host:5432/newpopsys
DATABASE_POOL_SIZE=20

# Redis
REDIS_URL=redis://host:6379

# JWT
JWT_SECRET=your-secret-key-min-32-chars
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=30d

# S3 Storage
S3_BUCKET=newpopsys-uploads
S3_REGION=us-east-1
S3_ACCESS_KEY=your-access-key
S3_SECRET_KEY=your-secret-key

# Email (for password reset, notifications)
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=notifications@example.com
SMTP_PASS=your-smtp-password

# Feature Flags
ENABLE_MFA=true
ENABLE_SSO=false
ENABLE_OFFLINE_SYNC=true

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

### 10.3 CI/CD Pipeline

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm typecheck

  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_DB: test
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
      redis:
        image: redis:7
        ports:
          - 6379:6379
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm test
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/test
          REDIS_URL: redis://localhost:6379

  build:
    runs-on: ubuntu-latest
    needs: [lint, typecheck, test]
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm build
```

---

## Appendix A: File Reference Index

### Source Documents

| Document | Location | Purpose |
|----------|----------|---------|
| SUPP-001 | `02_SUPPs/Shared_Foundations/` | Personas, workflows, JTBD |
| SUPP-003 | `02_SUPPs/Shared_Foundations/` | RBAC permissions |
| Screen Specs | `06_Screen_Specs/*.md` | Individual screen requirements |
| Database DDL | `06_Database_Model/01_Schema/` | Database schema |
| Indexes | `06_Database_Model/04_Indexes/` | Query optimization |
| Wireframes | `05_Wireframes/*.html` | Visual references |
| Screen Inventory | `07_Dev_Plan/SCREEN_INVENTORY.md` | Complete interface catalog |
| Persona Maps | `07_Dev_Plan/PERSONA_INTERACTION_MAPS.md` | User journey flows |

### Implementation Checklist

- [ ] S0: Foundation complete
- [ ] S1: Auth & Mobile core complete
- [ ] S2: Store execution complete
- [ ] S3: Campaign management complete
- [ ] S4: Verification & PSP complete
- [ ] S5: Store portal & reporting complete
- [ ] S6: Polish & Beta ready

---

**Document Version:** 1.0
**Last Updated:** 2025-12-30
**Author:** Claude Code
