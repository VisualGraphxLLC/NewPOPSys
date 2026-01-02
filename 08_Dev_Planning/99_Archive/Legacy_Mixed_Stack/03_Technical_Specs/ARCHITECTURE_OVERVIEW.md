# Architecture Overview

This document provides a high-level view of the PopSystem architecture with visual diagrams.

---

## System Context

```mermaid
C4Context
    title System Context Diagram - PopSystem

    Person(fieldRep, "Field Rep", "Installs and verifies POP displays")
    Person(brandAdmin, "Brand Admin", "Manages campaigns and reviews compliance")
    Person(pspOps, "PSP Operations", "Coordinates logistics and assignments")
    Person(storeManager, "Store Manager", "Approves installations, reports issues")

    System(popSystem, "PopSystem", "POP Display Management Platform")

    System_Ext(imageStorage, "Cloud Storage", "Photo storage (S3/GCS)")
    System_Ext(notifications, "Notification Service", "Push/SMS/Email")
    System_Ext(maps, "Maps API", "Geocoding and routing")

    Rel(fieldRep, popSystem, "Uses", "Mobile PWA")
    Rel(brandAdmin, popSystem, "Manages", "Web Dashboard")
    Rel(pspOps, popSystem, "Coordinates", "Web Dashboard")
    Rel(storeManager, popSystem, "Reviews", "Web Portal")

    Rel(popSystem, imageStorage, "Stores photos")
    Rel(popSystem, notifications, "Sends alerts")
    Rel(popSystem, maps, "Geocodes stores")
```

---

## High-Level Architecture

```mermaid
graph TB
    subgraph "Client Applications"
        Mobile["Mobile PWA<br/>(Field Reps)"]
        Brand["Brand Admin<br/>(Dashboard)"]
        PSP["PSP Ops<br/>(Operations)"]
        Store["Store Portal<br/>(Managers)"]
    end

    subgraph "Edge/CDN"
        CDN["Cloudflare/Vercel Edge"]
    end

    subgraph "API Layer"
        Gateway["API Gateway<br/>(Rate Limiting, Auth)"]
        API["Fastify API Server"]
    end

    subgraph "Services"
        Auth["Auth Service"]
        Tasks["Task Service"]
        Campaigns["Campaign Service"]
        Compliance["Compliance Service"]
        Analytics["Analytics Service"]
    end

    subgraph "Data Layer"
        PG[(PostgreSQL 16)]
        Redis[(Redis Cache)]
        S3["S3/GCS<br/>(Photos)"]
    end

    subgraph "External Services"
        Push["Push Notifications"]
        SMS["SMS Gateway"]
        Email["Email Service"]
        Maps["Maps API"]
    end

    Mobile --> CDN
    Brand --> CDN
    PSP --> CDN
    Store --> CDN

    CDN --> Gateway
    Gateway --> API

    API --> Auth
    API --> Tasks
    API --> Campaigns
    API --> Compliance
    API --> Analytics

    Auth --> PG
    Auth --> Redis
    Tasks --> PG
    Campaigns --> PG
    Compliance --> PG
    Compliance --> S3
    Analytics --> PG

    API --> Push
    API --> SMS
    API --> Email
    Tasks --> Maps
```

---

## Application Architecture

### Frontend Application Structure

```mermaid
graph TB
    subgraph "React Application"
        Pages["Pages/Routes"]
        Features["Feature Components"]
        UI["UI Components<br/>(packages/ui)"]

        subgraph "State Management"
            TQ["TanStack Query<br/>(Server State)"]
            Zustand["Zustand<br/>(Client State)"]
        end

        subgraph "Data Layer"
            APIClient["API Client<br/>(packages/api-client)"]
            Types["Shared Types<br/>(packages/shared-types)"]
        end
    end

    Pages --> Features
    Features --> UI
    Features --> TQ
    Features --> Zustand
    TQ --> APIClient
    APIClient --> Types
```

### Backend Service Architecture

```mermaid
graph TB
    subgraph "Fastify Application"
        Routes["Route Handlers"]
        Middleware["Middleware Stack"]
        Plugins["Fastify Plugins"]

        subgraph "Business Logic"
            Services["Domain Services"]
            Validators["Zod Validators"]
        end

        subgraph "Data Access"
            Drizzle["Drizzle ORM"]
            Cache["Redis Client"]
            Storage["Storage Client"]
        end
    end

    Routes --> Middleware
    Routes --> Services
    Services --> Validators
    Services --> Drizzle
    Services --> Cache
    Services --> Storage
    Middleware --> Plugins
```

---

## Data Flow Diagrams

### Task Completion Flow

```mermaid
sequenceDiagram
    participant FR as Field Rep (Mobile)
    participant API as API Server
    participant DB as PostgreSQL
    participant S3 as Photo Storage
    participant WS as WebSocket
    participant Brand as Brand Admin

    FR->>FR: Complete checklist
    FR->>FR: Capture photos

    FR->>API: POST /tasks/:id/complete
    API->>S3: Upload photos
    S3-->>API: Photo URLs

    API->>DB: Create compliance record
    API->>DB: Update task status
    DB-->>API: Confirmation

    API->>WS: Emit task.completed
    API-->>FR: Success response

    WS-->>Brand: Real-time update
    Brand->>Brand: Dashboard updates
```

### Campaign Creation Flow

```mermaid
sequenceDiagram
    participant BA as Brand Admin
    participant API as API Server
    participant DB as PostgreSQL
    participant PSP as PSP Operations

    BA->>API: POST /campaigns
    API->>DB: Create campaign (draft)
    DB-->>API: Campaign ID
    API-->>BA: Campaign created

    BA->>API: POST /campaigns/:id/submit
    API->>DB: Update status (pending_approval)
    API->>PSP: Notify: New campaign for review

    PSP->>API: POST /campaigns/:id/approve
    API->>DB: Update status (approved)
    API->>DB: Generate initial tasks
    API->>BA: Notify: Campaign approved
```

---

## Deployment Architecture

```mermaid
graph TB
    subgraph "Production Environment"
        subgraph "Container Orchestration"
            API1["API Pod 1"]
            API2["API Pod 2"]
            API3["API Pod 3"]
            Worker["Background Worker"]
        end

        subgraph "Managed Services"
            PG[(PostgreSQL<br/>Primary)]
            PGR[(PostgreSQL<br/>Read Replica)]
            Redis[(Redis Cluster)]
            S3["Object Storage"]
        end

        LB["Load Balancer"]
    end

    subgraph "Edge"
        CDN["CDN"]
        WAF["WAF"]
    end

    Users((Users)) --> WAF
    WAF --> CDN
    CDN --> LB
    LB --> API1
    LB --> API2
    LB --> API3

    API1 --> PG
    API2 --> PG
    API3 --> PGR

    API1 --> Redis
    API2 --> Redis
    API3 --> Redis

    API1 --> S3
    Worker --> PG
    Worker --> Redis
```

---

## Security Architecture

```mermaid
graph TB
    subgraph "Client"
        App["App (HTTPS)"]
    end

    subgraph "Edge Security"
        WAF["WAF"]
        DDoS["DDoS Protection"]
        Rate["Rate Limiting"]
    end

    subgraph "Application Security"
        Auth["JWT Authentication"]
        RBAC["Role-Based Access"]
        Validation["Input Validation"]
    end

    subgraph "Data Security"
        Encryption["Encryption at Rest"]
        TLS["TLS in Transit"]
        Audit["Audit Logging"]
    end

    App --> WAF
    WAF --> DDoS
    DDoS --> Rate
    Rate --> Auth
    Auth --> RBAC
    RBAC --> Validation
    Validation --> Encryption
    Validation --> TLS
    Validation --> Audit
```

### Authentication Flow

```mermaid
sequenceDiagram
    participant User
    participant App
    participant API
    participant DB
    participant Redis

    User->>App: Login (email/password)
    App->>API: POST /auth/login
    API->>DB: Validate credentials
    DB-->>API: User record

    API->>API: Generate JWT (access + refresh)
    API->>Redis: Store refresh token
    API-->>App: Tokens + user data

    App->>App: Store tokens securely

    Note over App,API: Subsequent requests

    App->>API: Request + Bearer token
    API->>API: Validate JWT
    API-->>App: Protected resource

    Note over App,API: Token refresh

    App->>API: POST /auth/refresh
    API->>Redis: Validate refresh token
    API->>API: Issue new access token
    API-->>App: New access token
```

---

## Integration Points

### External Service Integrations

| Service | Purpose | Integration Method |
|---------|---------|-------------------|
| AWS S3 / GCS | Photo storage | SDK / Signed URLs |
| Firebase Cloud Messaging | Push notifications | REST API |
| Twilio | SMS notifications | REST API |
| SendGrid | Email notifications | REST API |
| Google Maps | Geocoding, directions | REST API |
| Stripe | Payment processing | SDK |

### Internal Service Communication

```mermaid
graph LR
    subgraph "Synchronous"
        API["API Server"]
        Auth["Auth Service"]
        API -->|HTTP| Auth
    end

    subgraph "Asynchronous"
        Queue["Redis Queue"]
        Worker["Background Worker"]
        API -->|Enqueue| Queue
        Queue -->|Dequeue| Worker
    end

    subgraph "Real-time"
        WS["WebSocket Server"]
        Pub["Redis Pub/Sub"]
        API -->|Publish| Pub
        Pub -->|Subscribe| WS
    end
```

---

## Scalability Considerations

### Horizontal Scaling

| Component | Scaling Strategy |
|-----------|-----------------|
| API Servers | Kubernetes HPA based on CPU/requests |
| Background Workers | Queue depth-based scaling |
| PostgreSQL Reads | Read replicas |
| Redis | Redis Cluster |
| Static Assets | CDN with edge caching |

### Caching Strategy

```mermaid
graph LR
    Request["Request"]
    CDN["CDN Cache<br/>(Static)"]
    Redis["Redis Cache<br/>(Dynamic)"]
    App["Application Cache<br/>(In-memory)"]
    DB[(Database)]

    Request --> CDN
    CDN -->|Miss| Redis
    Redis -->|Miss| App
    App -->|Miss| DB

    DB -->|Populate| App
    App -->|Populate| Redis
```

| Cache Layer | TTL | Use Case |
|-------------|-----|----------|
| CDN | 1 hour | Static assets, public API responses |
| Redis | 5-15 min | Session data, frequently accessed queries |
| Application | 1 min | Hot data, computed values |

---

*Last Updated: 2026-01-01*
