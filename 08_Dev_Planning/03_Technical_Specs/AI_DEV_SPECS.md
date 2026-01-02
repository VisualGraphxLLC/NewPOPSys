# AI Development Specifications

> **Guidance for AI Agents**: Use this context for all code generation.

## 1. Project Context
*   **Project**: NewPOPSys v1 (Point of Purchase Management).
*   **Type**: Monorepo (Turborepo).
*   **Strict Stack**: Next.js, Fastify, Drizzle, Redis.

---

## 2. Code Patterns

### 2.1 Frontend (Next.js)
*   **Directory Structure**: Use App Router (`app/page.tsx`, `app/layout.tsx`).
*   **Data Fetching**: Use `fetch` in Server Components where possible. Use Client Components only for interactivity.
*   **State**: Use `React.useState` or `React.useContext`. **Do NOT install Redux/Zustand**.
*   **Styling**: Tailwind CSS utility classes.

### 2.2 Backend (Fastify)
*   **Route Definition**:
    ```typescript
    fastify.post('/api/campaigns', {
      schema: { body: CampaignSchema },
      handler: async (req, reply) => { ... }
    })
    ```
*   **Async Jobs (BullMQ)**:
    ```typescript
    await campaignQueue.add('process-photos', { campaignId }, { attempts: 3 });
    ```

### 2.3 Database (Drizzle)
*   **Schema**: Define in `packages/database/src/schema/*.ts`.
*   **Query**:
    ```typescript
    const result = await db.select().from(campaigns).where(eq(campaigns.id, id));
    ```

---

## 3. Automation Scripts
*   **Context Loading**: Run `npm run ai:context` (if available) to concatenate SUPP files.
*   **Verification**: Always run `npm run lint` and `npm run typecheck` before committing.

---

*No Vite. No Supabase.*
