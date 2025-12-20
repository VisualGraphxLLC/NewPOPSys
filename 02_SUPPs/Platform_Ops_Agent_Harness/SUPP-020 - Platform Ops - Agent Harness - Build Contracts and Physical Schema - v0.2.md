Date: 2025-12-17

Purpose: Authoritative build blueprint for Module 20: physical Postgres schema, OpenAPI contracts, auth, audit, idempotency, outbox/webhooks, pagination, export job interfaces, and scale-ready guardrails.

# Locked Decisions (Module 20)

  --------------------------------------------------------------------------------------------------------------------------------------
  Decision                            Selection
  ----------------------------------- --------------------------------------------------------------------------------------------------
  Multi-tenant strategy               1A --- Single DB, shared schema, tenant_id on every row

  Primary ID strategy                 2A --- UUIDv7 across all entities

  Migrations/query layer              Drizzle ORM schema (TS) + drizzle-kit migrations (20.1A)

  API architecture                    4C --- Hybrid (Next for simple; backend service for core)

  API versioning                      5A --- /api/v1 path versioning

  Web auth + integration auth         6A --- Cookies for web + API keys for integrations + signed webhooks + Idempotency-Key

  Outbox                              7A --- DB outbox table + worker dispatcher; Kafka later via outbox publisher (20.5A)

  Exports                             8B --- Small exports sync; large exports async jobs

  Media model                         9A --- MediaAsset table + join tables for proof bindings

  Audit logging                       10A --- Audit events for every state change + actor + correlationId

  Tenant enforcement                  20.2B --- Scaffold Postgres RLS policies now; enable later (app-layer enforcement in v1 runtime)

  Pagination                          20.3A --- Cursor pagination using (createdAt, id(UUIDv7))

  OpenAPI format                      20.4C --- Both: canonical OpenAPI YAML + generated validators/types (CI-enforced)
  --------------------------------------------------------------------------------------------------------------------------------------

## Recommendation Note on RLS (20.2)

- 2B is the least long-term pain: you design tables and policies with RLS in mind without paying the day-1 velocity tax of turning it on everywhere.

- 2C (RLS from day 1) is great when you already have a mature ops/security posture and time for policy debugging; otherwise it slows pilots.

- So: scaffold policies now, keep runtime enforcement in the app for v1, flip the switch later when traffic and teams justify it.

# 1) Postgres Physical Schema (Draft)

All tenant-scoped tables include tenant_id (pspId). Brand is a secondary scope dimension within tenant_id.

  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Domain                              Tables (Draft)
  ----------------------------------- -----------------------------------------------------------------------------------------------------------------------------------------
  Tenancy/Identity                    psp_tenant, brand, app_user, membership, role, permission, api_key, audit_event

  Stores/Grouping                     store, region_node, store_group, store_group_membership, store_alias

  Surveys/Layout                      survey_template, survey_version, store_survey_response, store_layout, location_slot, photo_rule, photo_rule_override

  Campaigns/Assignment                campaign, selection_recipe, store_assignment, kit_definition, kit_item_definition, assignment_item, rebase_event

  Fulfillment                         store_order, order_line, shipment, shipment_line, shipment_tracking, batch, batch_membership

  Execution/Verification              store_task, receive_verification, install_record, proof_photo_link, completion_submission, photo_review, slot_verification, retake_task

  Issues/Reorders                     issue_request, issue_line, approval_policy, approval_decision, reorder, non_compliance_case, asset_substitution

  Async/Infra                         outbox_event, webhook_endpoint, webhook_delivery, idempotency_key, export_job, export_artifact, retention_job
  -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Key Constraints (Minimum)

- Unique(store.tenant_id, store.store_number)

- Unique(store_group.tenant_id, store_group.slug)

- Unique(survey_version.template_id, survey_version.version)

- Unique(store_assignment.campaign_id, store_assignment.store_id)

- Unique(store_order.campaign_id, store_order.store_id) --- v1 default

- FK constraints for core relationships; soft-delete only for media/purge flows where needed.

## Indexing (Pilot + Scale)

- Tenant lists: index (tenant_id, created_at desc) (+ id) for cursor pagination.

- Store selection: (tenant_id, region_node_id), (tenant_id, store_number), group membership indexes.

- Execution reporting: (campaign_id, store_id), (assignment_item_id), (location_slot_id), (slot_verification_status).

- Outbox/Delivery workers: (status, next_attempt_at), (endpoint_id, status, next_attempt_at).

# 2) RLS Scaffold (20.2B)

- Schema must support future RLS: every tenant-scoped table has tenant_id and (optionally) brand_id.

- Policy pattern (scaffold now): USING (tenant_id = current_setting(\'app.tenant_id\')::uuid).

- App sets \'app.tenant_id\' at connection/session scope when/if RLS is enabled later.

- v1 runtime: enforce tenant checks in the service layer; still keep policy SQL checked in repo for later enablement.

Example policy snippet (for later enablement):

\`\`\`sql\
\-- Scaffold: keep in /db/rls/ as future-ready artifacts\
ALTER TABLE store ENABLE ROW LEVEL SECURITY;\
CREATE POLICY store_tenant_isolation ON store\
USING (tenant_id = current_setting(\'app.tenant_id\')::uuid);\
\`\`\`

# 3) Media Asset Model (9A)

- media_asset: id(UUIDv7), tenant_id, brand_id?, type, mime, size, checksum, storage_provider, storage_key/pointer_uri, retention_class, created_by, created_at, expires_at?

- proof_photo_link binds media_asset to: campaign_id, store_id, assignment_item_id, location_slot_id, rule_id

- All access via presigned URLs; exports contain mediaAssetId + (optional) short-lived URL.

# 4) Audit + Idempotency + Outbox (7A/10A)

- audit_event is append-only; every state transition emits an event with actorType and correlationId.

- idempotency_key prevents duplicate integration writes; key scope = tenant_id + key + endpoint + method.

- outbox_event drives webhook dispatch (at-least-once). webhook_delivery records attempts, errors, and replays.

- Kafka later: add an outbox publisher that mirrors outbox_event to Kafka topics without changing write paths.

# 5) Pagination Contract (20.3A)

- Cursor-based pagination for high-volume lists: cursor = base64({createdAt, id}).

- Sorting: ORDER BY created_at DESC, id DESC (id is UUIDv7 so time-sortable).

- Stable even under inserts; avoids offset/limit performance cliffs.

# 6) OpenAPI + Validation (20.4C)

- Canonical spec: /openapi/v1.yaml in repo (reviewable, diffable).

- Code validation: request/response schemas in code (e.g., Zod) + generated validators/types.

- CI gate: regenerate openapi from schemas and fail if diff from committed YAML (prevents drift).

- Error envelope: {errorCode, message, correlationId, details?}

# 7) Endpoint Index (Draft)

  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Area                                Endpoints (Draft)
  ----------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Auth                                POST /api/v1/auth/login, POST /api/v1/auth/logout, POST /api/v1/auth/invite/accept

  Stores                              GET/POST/PUT /api/v1/stores, POST /api/v1/stores/import

  Groups/Regions                      GET/POST /api/v1/regions, GET/POST /api/v1/groups, POST /api/v1/groups/{id}/members

  Surveys/Layout                      POST /api/v1/surveyTemplates, POST /api/v1/surveyTemplates/{id}/publish, GET/PUT /api/v1/stores/{id}/surveyResponse

  Campaigns                           POST /api/v1/campaigns, PUT /api/v1/campaigns/{id}, POST /api/v1/campaigns/{id}/publish, GET /api/v1/campaigns/{id}/dashboard

  PSP Ops                             GET /api/v1/psp/campaigns/{id}/orders, GET/PUT /api/v1/psp/orders/{id}, POST/PUT /api/v1/psp/shipments, POST/PUT /api/v1/psp/batches

  Store App                           GET /api/v1/storeApp/campaigns, POST /api/v1/storeApp/orders/{id}/receiveVerification, POST /api/v1/storeApp/proofs, POST /api/v1/storeApp/completionSubmissions

  Review                              GET /api/v1/reviewQueue, POST /api/v1/photoReviews/{photoLinkId}/approve, POST /api/v1/photoReviews/{photoLinkId}/reject

  Issues/Reorders                     POST /api/v1/issues, POST /api/v1/issues/{lineId}/approve\|reject, POST /api/v1/issues/{requestId}/createReorder

  Exports                             POST /api/v1/exports, GET /api/v1/exports/{jobId}, GET /api/v1/exports/{jobId}/download

  Integration                         POST/PUT /api/v1/integration/orders, /shipments, /batches (idempotent)
  ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 8) Export Job Contract (8B)

- Small exports can run sync with size guard (row count or time budget).

- Large exports run async (export_job + export_artifact).

- Artifacts have expiry; avoid storing forever.

# Acceptance Criteria (Module 20)

1.  DB migrations create schema with constraints + indexes and pass CI.

2.  OpenAPI v1 YAML exists and matches generated schemas (CI drift gate).

3.  Cursor pagination implemented for stores, campaigns, orders, proofs, issues.

4.  Outbox + webhook deliveries provide at-least-once delivery with retries + replay UI hooks.

5.  Idempotency works for integration write endpoints and returns consistent responses.

6.  Audit events emitted for every state transition with correlationId and actor typing.
