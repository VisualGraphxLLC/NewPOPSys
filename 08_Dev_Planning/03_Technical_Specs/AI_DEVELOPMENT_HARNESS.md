# AI Development Harness Strategy

> Defines the "Agentic" methodology for building NewPOPSys v1, leveraging the `SOW` architecture as the primary context.

---

## 1. The Orchestrator Model

We use a **Dispatcher/Worker** model to manage the complexity of the full stack build.

### 1.1 The Dispatcher (Plan & Verify)
The User acts as the Architect, but the **Orchestrator Agent** (You) manages the Sprint Board.
- **Rule**: Never edit code directly in Orchestrator Mode.
- **Responsibility**: Read `CURRENT_SPRINT.md`, identify the next task, and Dispatch a Worker.
- **Context**: Loads `MASTER_DEVELOPMENT_PLAN.md` and `TECH_STACK_DECISIONS.md`.

### 1.2 The Worker (Execute)
A "Worker" is a targeted agent session focused on a **Single Task**.
- **Rule**: Only load the files necessary for the specific task.
- **Responsibility**: Implement the feature, run tests, and report back.
- **Context**: Loads the specific `SUPP-0xx` relevant to the feature.

---

## 2. Context Loading Strategy

To avoid context window overflow, we strictly map Modules to SUPP files.

| Module | Primary Context | Supplemental Context |
|--------|-----------------|----------------------|
| **Core/Auth** | `SUPP-003_RBAC` | `TECH_STACK_DECISIONS.md` |
| **Brand Admin** | `SUPP-015_Campaigns` | `SUPP-013_Stores` |
| **PSP Ops** | `SUPP-016_Orders` | `SUPP-006_Webhooks` |
| **Mobile App** | `SUPP-017_Execution` | `SUPP-011_Offline` |
| **API/Backend** | `SUPP-006_Inbound` | `SUPP-029_Observability` |

### 2.1 The "Context Header"
Every Worker session should start by reading the **Authoritative Spec**:
> "I am working on Task [ID]. Please read `SOW/02_SUPPs/.../SUPP-XXX.md` to understand the requirements."

---

## 3. Development Workflows

### 3.1 Feature Implementation Loop
1.  **Checkout**: `git checkout -b feat/POP-XXX-description`
2.  **Spec Check**: Read the relevant `SUPP` file.
3.  **Scaffold**: Create file structures (e.g., `apps/brand-portal/app/campaigns/page.tsx`).
4.  **Implement**: Write code using **Next.js / Fastify** patterns.
5.  **Test**: Write Unit Tests (`vitest`).
6.  **Verify**: Run `npm run test` and `npm run lint`.
7.  **Commit**: `git commit -m "feat(module): description (POP-XXX)"`

### 3.2 The "Audit" Gate
Before marking a task as Done, the Orchestrator must run an **Audit**:
1.  **Check Requirements**: Does the code match `SUPP` Acceptance Criteria?
2.  **Check Stack**: Did we use Next.js/Fastify, or accidentally slip into Express/Vite?
3.  **Check Lint**: Are there `eslint` errors?

---

## 4. Automation Scripts (The Harness)

We will build a local CLI `scripts/dev-harness.ts` to assist the AI.

### 4.1 `npm run ai:context`
Generates a "Context Pack" for the current task.
- Reads `CURRENT_SPRINT.md`.
- identifying active task.
- Concatenates relevant `SUPP` files into a single buffer for the AI to read.

### 4.2 `npm run ai:verify`
Runs a strict suite of checks:
- TypeCheck (TSC)
- Lint (ESLint)
- Test (Vitest)
- Boundary Check (Ensures no illegal imports between Monorepo packages).

---

## 5. Agent Instructions (System Prompt Injection)

When initializing a Worker, include this specific instruction:

```text
You are a Senior Full Stack Engineer building NewPOPSys v1.
STACK: Turborepo, Next.js (Web), Fastify (API), Postgres (Drizzle).
SOURCE OF TRUTH: SOW/02_SUPPs/*.md.
RULE: Do not invent features. If it's not in the SUPP, ask the Orchestrator.
```

---

*Last Updated: 2026-01-02*
