# Testing Strategy

## 1. Unit Testing (Vitest)
*   **Scope**: Utility functions, Hooks, API Handlers.
*   **Tool**: **Vitest** (Fast, native ESM).
*   **Target**: 80% Coverage on core logic.

## 2. Integration Testing (Vitest + Supertest)
*   **Scope**: API Endpoints (Fastify).
*   **Strategy**: Spin up ephemeral Postres/Redis containers.

## 3. E2E Testing (Playwright)
*   **Scope**: Critical User Flows (Login, Photo Capture).
*   **Tool**: **Playwright**.
*   **Target**: Smoke tests for every deploy.

## 4. Manual Testing
*   **Scope**: UX Polish, Edge Cases.
