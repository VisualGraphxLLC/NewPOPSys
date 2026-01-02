# SRS PDF Integration Content

**Source Documents**:
- `Process Matters - Architecture And Tech Stack.pdf`
- `Process Matters Reporting Requirements.pdf`

**Created**: 2026-01-02
**Purpose**: Mermaid diagrams for SRS integration

> ⚠️ **Important**: The PDF source documents describe a Python/FastAPI stack. The actual NewPOPSys v1 uses **Node.js/TypeScript with Fastify**. Tech stack sections below have been corrected to match SUPP-012 and SRS Section 3.3.

---

## 1. Physical Architecture (AWS)

The system leverages AWS managed services for scalability, security, and reliability.

```mermaid
flowchart LR
    subgraph Edge["Edge Layer"]
        CF[CloudFront CDN]
        WAF[AWS WAF]
    end

    subgraph Compute["Compute Layer"]
        ALB[Application Load Balancer]
        ECS[ECS Fargate<br/>Containers]
    end

    subgraph Auth["Authentication"]
        COG[AWS Cognito<br/>JWT Tokens]
    end

    subgraph Data["Data Layer"]
        RDS[(RDS PostgreSQL<br/>Multi-AZ)]
        S3[(S3 Buckets<br/>Assets/Reports)]
    end

    subgraph Services["Supporting Services"]
        SES[SES<br/>Email]
        CW[CloudWatch<br/>Monitoring]
    end

    User([User]) --> CF
    CF --> WAF
    WAF --> ALB
    ALB --> ECS
    ECS <--> COG
    ECS <--> RDS
    ECS <--> S3
    ECS --> SES
    ECS --> CW
```

---

## 2. Logical Architecture (Application Layers)

The application follows a modular monolith architecture (Turborepo monorepo).

```mermaid
flowchart TD
    subgraph Presentation["Presentation Layer"]
        UI[Next.js 14+<br/>App Router + React]
    end

    subgraph API["API Layer"]
        FE[Fastify<br/>REST Endpoints]
        AUTH[Session Cookies<br/>+ API Keys/HMAC]
    end

    subgraph Business["Business Logic Layer"]
        SVC[Service Classes<br/>Domain Logic]
        VAL[TypeScript<br/>Validation]
    end

    subgraph DataAccess["Data Access Layer"]
        ORM[Prisma ORM<br/>Repository Pattern]
    end

    subgraph Database["Database Layer"]
        PG[(PostgreSQL 15+<br/>Multi-Tenant RLS)]
    end

    UI --> FE
    FE --> AUTH
    AUTH --> SVC
    SVC --> VAL
    SVC --> ORM
    ORM --> PG
```

---

## 3. Report Types by User Role

Reports are segmented by user role with specific access permissions.

```mermaid
flowchart TD
    subgraph Reports["PopSys Reporting System"]
        direction TB

        subgraph PSP["PSP Admin Reports (4)"]
            R1[Orders Report]
            R2[Shipments Report]
            R3[Issue Report]
            R4[Ops Metrics Report]
        end

        subgraph Brand["Brand Admin Reports (4)"]
            R5[Campaign Summary]
            R6[Campaign Execution]
            R7[Verification Report]
            R8[Survey Results]
        end

        subgraph Regional["Regional Manager Reports (2)"]
            R9[Exception Queue]
            R10[Review Queue]
        end

        subgraph Store["Store User Reports (1)"]
            R11[Issue Reporting]
        end
    end
```

### Report Summary Table

| Role | Report Count | Reports |
|------|--------------|---------|
| PSP Admin | 4 | Orders, Shipments, Issues, Ops Metrics |
| Brand Admin | 4 | Campaign Summary, Execution, Verification, Survey |
| Regional Manager | 2 | Exception Queue, Review Queue |
| Store User | 1 | Issue Reporting |

---

## 4. Technology Stack

> **Note**: Aligned with SRS Section 3.3 and SUPP-012. The PDF source documents described a Python stack; the actual NewPOPSys v1 uses Node.js/TypeScript.

### Backend Stack

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Language | TypeScript | 5.x | Server-side logic |
| Framework | Fastify | Latest | REST API endpoints |
| ORM | Prisma | Latest | Database abstraction |
| Validation | TypeScript + Zod | - | Request/response validation |
| Queue | BullMQ | Latest | Background jobs, webhooks |

### Frontend Stack

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|
| Framework | Next.js | 14+ | App Router, SSR/SSG |
| UI Library | React | 18+ | Component architecture |
| Styling | TailwindCSS | 3.x | Utility-first CSS |
| Monorepo | Turborepo | Latest | Build orchestration |

### Infrastructure Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Containers | Docker | Application packaging |
| Orchestration | AWS ECS Fargate | Serverless containers |
| IaC | Terraform | Infrastructure provisioning |
| Observability | OpenTelemetry + Sentry | Tracing, error tracking |

### Database & Auth

| Component | Technology | Configuration |
|-----------|------------|---------------|
| Primary DB | PostgreSQL | 15+, Multi-AZ, RLS |
| Web Auth | Session Cookies | Server-side sessions |
| API Auth | API Keys + HMAC | Integration authentication |
| Storage | AWS S3 | Media, reports, exports |

---

## 5. REST API Design Principles

The API follows RESTful conventions:

```mermaid
flowchart LR
    subgraph Methods["HTTP Methods"]
        GET[GET<br/>Read]
        POST[POST<br/>Create]
        PUT[PUT<br/>Update]
        DELETE[DELETE<br/>Delete]
    end

    subgraph Features["API Features"]
        PAG[Pagination<br/>limit/offset]
        FILT[Filtering<br/>query params]
        SORT[Sorting<br/>order_by]
        AUTH2[Auth<br/>JWT Bearer]
    end

    Methods --> Features
```

### URL Structure
- Resource-oriented: `/api/v1/{resource}/{id}`
- Nested resources: `/api/v1/campaigns/{id}/tasks`
- Actions: `/api/v1/tasks/{id}/complete`

---

## Integration Notes

These diagrams should be integrated into the SRS at the following sections:
- Physical Architecture → Section 3.1 (System Architecture)
- Logical Architecture → Section 3.2 (Software Architecture)
- Report Types → Section 4.x (Reporting Requirements)
- Tech Stack → Appendix or Section 3.3 (Technology Stack)
