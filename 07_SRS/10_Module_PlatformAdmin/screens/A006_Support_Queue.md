# A006: Support Queue

## 1. Overview

| Field | Value |
|-------|-------|
| **Screen ID** | A006 |
| **Module** | Platform Admin |
| **Primary Persona** | Support Agent |
| **Secondary Personas** | Platform Admin, PSP Admin |
| **SOW Reference** | SUPP-031, SUPP-004 |

## 2. Screenshot Reference

![Support Queue](../../screenshots/PSP_Operations/psp_ops_issues.png)

*Figure A006-1: Support Queue - Support ticket management, failed webhooks, and system alerts*

> **Layout Reference:** Design follows standard support ticketing patterns.

## 3. Screen Description

The Support Queue screen provides a centralized interface for managing customer support requests, escalated issues, and system alerts requiring attention. Support Agents use this screen as their primary workspace for handling support cases.

This screen aggregates support tickets, failed webhook deliveries requiring retry, user-reported issues, and system-generated alerts. It provides quick access to user impersonation (read-only for Support Agents), audit log viewing, and case management tools.

The queue supports filtering by priority, status, category, and assignment. Cases can be assigned to specific agents or teams, and all case interactions are tracked for quality assurance and training purposes.

---

## 4. User Access (RBAC)

| Persona | Can Access | Permissions | Notes |
|---------|------------|-------------|-------|
| Platform Admin | Y | Full Access | All cases, assign to any agent |
| PSP Admin | Y | Tenant-Scoped | Manage tenant support cases |
| Support Agent | Y | Assigned Cases | Work assigned cases, view all tenant cases |
| Production Operator | Y | Limited | View fulfillment-related issues only |
| Brand Admin | N | - | Uses issue management in Brand module |
| Store Manager | N | - | Submits issues through Store module |

---

## 5. Data Model

### Primary Entities

- **SupportCase** - Support ticket/case
  - Key fields: case_id, subject, description, status, priority, category, reporter_id, assignee_id, tenant_id, created_at, updated_at, resolved_at
- **CaseComment** - Case discussion thread
  - Key fields: comment_id, case_id, author_id, content, is_internal, created_at
- **FailedWebhook** - Failed webhook delivery for retry
  - Key fields: delivery_id, endpoint_id, event_type, payload, attempts, last_attempt, status
- **SystemAlert** - System-generated alerts
  - Key fields: alert_id, alert_type, severity, message, acknowledged, created_at

### Relationships

![10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_0](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_0.png)

---

## 6. APIs

### Internal APIs

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /api/v1/support/cases | GET | List support cases with filters |
| /api/v1/support/cases | POST | Create support case |
| /api/v1/support/cases/{id} | GET | Get case details |
| /api/v1/support/cases/{id} | PUT | Update case |
| /api/v1/support/cases/{id}/comments | GET | List case comments |
| /api/v1/support/cases/{id}/comments | POST | Add case comment |
| /api/v1/support/cases/{id}/assign | POST | Assign case to agent |
| /api/v1/support/failed-webhooks | GET | List failed webhooks |
| /api/v1/support/failed-webhooks/{id}/retry | POST | Retry failed webhook |
| /api/v1/support/alerts | GET | List system alerts |
| /api/v1/support/alerts/{id}/acknowledge | POST | Acknowledge alert |

### External Integrations

| System | Purpose | Data Flow |
|--------|---------|-----------|
| Ticketing System | External ticket sync (optional) | Bidirectional |
| Notification Service | Agent notifications | Outbound |

---

## 7. Business Rules

- BR-A006-01: New cases default to "Open" status and "Medium" priority
- BR-A006-02: Cases auto-escalate if unacknowledged for 4 hours
- BR-A006-03: Critical priority cases trigger immediate notification
- BR-A006-04: Support Agent can impersonate users (read-only) for debugging
- BR-A006-05: Internal comments are not visible to case reporter
- BR-A006-06: Failed webhooks can be retried up to 5 additional times manually
- BR-A006-07: Resolved cases can be reopened within 30 days
- BR-A006-08: Case resolution requires resolution category and notes

---

## 8. UI Components

### Queue Tabs

| Tab | Description | Badge |
|-----|-------------|-------|
| My Cases | Cases assigned to current agent | Count |
| Unassigned | Cases awaiting assignment | Count |
| All Open | All open cases (filtered by access) | Count |
| Failed Webhooks | Webhooks requiring retry | Count |
| Alerts | System alerts | Count |
| Resolved | Recently resolved cases | - |

### Case List Table

| Column | Description | Sortable | Filterable |
|--------|-------------|----------|------------|
| Case # | Case identifier | Yes | Yes |
| Subject | Case subject line | Yes | Yes |
| Priority | Critical/High/Medium/Low | Yes | Yes (dropdown) |
| Status | Open/In Progress/Pending/Resolved | Yes | Yes (dropdown) |
| Category | Issue category | Yes | Yes (dropdown) |
| Reporter | User who reported | Yes | Yes |
| Assignee | Assigned agent | Yes | Yes (dropdown) |
| Age | Time since creation | Yes | Yes (range) |
| Updated | Last update time | Yes | Yes |

### Case Detail Panel

- **Case Information**
  - Subject, Description
  - Status, Priority, Category
  - Reporter details with impersonation link
  - Assignee with reassign option

- **Timeline**
  - Chronological activity log
  - Comments (internal and external)
  - Status changes
  - Assignment changes

- **Actions**
  - Add Comment (internal/external toggle)
  - Change Status
  - Change Priority
  - Reassign
  - Impersonate Reporter (read-only)
  - View Related Audit Events
  - Resolve Case

### Failed Webhook Panel

| Column | Description |
|--------|-------------|
| Endpoint | Webhook destination URL |
| Event | Event type that triggered |
| Attempts | Number of delivery attempts |
| Last Error | Error message from last attempt |
| Actions | Retry, View Payload, Dismiss |

---

## 9. State Transitions

### Case Status Flow

![10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_1](../../diagrams_rendered/10_Module_PlatformAdmin_screens_A006_Support_Queue_diagram_1.png)

### Case Priority Levels

| Priority | SLA (First Response) | SLA (Resolution) | Escalation |
|----------|---------------------|------------------|------------|
| Critical | 15 minutes | 4 hours | Immediate to PSP Admin |
| High | 1 hour | 8 hours | After 2 hours |
| Medium | 4 hours | 24 hours | After 8 hours |
| Low | 8 hours | 72 hours | After 24 hours |

---

## 10. Impersonation Integration

### Support Agent Impersonation

- **Scope**: Store Users only (per SUPP-003)
- **Mode**: Read-only (cannot modify data)
- **Access Path**: Case Detail â†’ Reporter â†’ Impersonate
- **Session Limit**: 30 minutes
- **Requirements**: Reason required, audit logged

### Impersonation UI

1. Click "Impersonate Reporter" on case
2. Enter reason for impersonation
3. Confirm impersonation start
4. Read-only session begins with banner
5. "End Impersonation" button always visible
6. Auto-terminate at 30 minutes

---

## 11. Acceptance Criteria

- [ ] AC-A006-01: Support Agent sees cases scoped to their tenant
- [ ] AC-A006-02: Unassigned queue shows cases awaiting assignment
- [ ] AC-A006-03: Case assignment sends notification to assignee
- [ ] AC-A006-04: Internal comments are hidden from case reporter
- [ ] AC-A006-05: Failed webhook retry attempts delivery
- [ ] AC-A006-06: Impersonation requires reason and is audited
- [ ] AC-A006-07: Impersonation session is read-only for Support Agent
- [ ] AC-A006-08: Case resolution requires category and notes
- [ ] AC-A006-09: SLA timers display on case list
- [ ] AC-A006-10: Auto-escalation triggers after SLA threshold

---

## 12. Related Documents

- SUPP-031 - Supportability, Logs, and Impersonation
- SUPP-004 - Notifications and Escalation Matrix
- SUPP-003 - RBAC and Permissions Matrix
- SRS-4.4.1 - Platform Admin Persona

---

*Document Version: 1.0*
*Last Updated: 2026-01-01*
*System: NewPOPSys v1.38*
