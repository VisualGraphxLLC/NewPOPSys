# Issue Tracker Policy

## Bug Triage Rules

This document defines the priority system, response times, and workflows for managing issues and bugs in the project.

---

## Priority Levels

### P0: Critical - Production Down

**Definition**: System is completely unusable, data loss occurring, or security breach detected.

| Attribute | Requirement |
|-----------|-------------|
| **Response Time** | 15 minutes |
| **Resolution Target** | Same day (within 4 hours) |
| **Escalation** | Immediate to Tech Lead + Management |
| **Communication** | Status updates every 30 minutes |
| **Team Assignment** | All hands on deck if needed |

**Examples**:
- Production application completely inaccessible
- Database corruption or data loss
- Security breach or active attack
- Payment processing failure
- Critical integration (OnPrintShop/OneVision) completely down

**Triage Actions**:
1. Immediately create incident channel
2. Page on-call engineer
3. Notify stakeholders
4. Begin root cause investigation
5. Implement hotfix or rollback

---

### P1: High - Major Feature Broken

**Definition**: Critical functionality is broken with no workaround, affecting multiple users.

| Attribute | Requirement |
|-----------|-------------|
| **Response Time** | 1 hour |
| **Resolution Target** | Within current sprint |
| **Escalation** | Tech Lead within 4 hours |
| **Communication** | Daily updates to stakeholders |
| **Team Assignment** | Senior developer assigned |

**Examples**:
- Order creation failing for all users
- User authentication broken
- Major workflow (proofing, production) blocked
- Data sync failures with external systems
- Reports generating incorrect data

**Triage Actions**:
1. Assess impact and affected users
2. Assign senior developer immediately
3. Identify workaround if possible
4. Schedule fix for current sprint
5. Communicate ETA to affected parties

---

### P2: Medium - Workaround Exists

**Definition**: Functionality impaired but workaround available, affecting some users.

| Attribute | Requirement |
|-----------|-------------|
| **Response Time** | 4 hours |
| **Resolution Target** | Next sprint |
| **Escalation** | If no progress after 1 week |
| **Communication** | Weekly status in sprint review |
| **Team Assignment** | Added to sprint backlog |

**Examples**:
- Feature works but requires extra steps
- Performance degradation (slow but functional)
- Minor integration issues with fallback
- UI/UX issues affecting workflow
- Partial data display problems

**Triage Actions**:
1. Document the workaround
2. Communicate workaround to users
3. Add to next sprint planning
4. Estimate effort required
5. Track in backlog with priority

---

### P3: Low - Minor/Cosmetic

**Definition**: Minor issues, cosmetic problems, or nice-to-have improvements.

| Attribute | Requirement |
|-----------|-------------|
| **Response Time** | 1 business day |
| **Resolution Target** | Backlog (as capacity allows) |
| **Escalation** | Only if pattern emerges |
| **Communication** | Sprint planning discussions |
| **Team Assignment** | Picked up during slack time |

**Examples**:
- Typos or minor text issues
- Cosmetic UI alignment issues
- Minor UX improvements
- Non-critical warning messages
- Edge case handling improvements

**Triage Actions**:
1. Log in backlog
2. Tag appropriately
3. Review during backlog grooming
4. Bundle with related work
5. Address during slack time

---

## Priority Matrix

```
                    │ Single User │ Multiple Users │ All Users │
────────────────────┼─────────────┼────────────────┼───────────│
System Down         │     P1      │       P0       │    P0     │
────────────────────┼─────────────┼────────────────┼───────────│
Feature Broken      │     P2      │       P1       │    P1     │
────────────────────┼─────────────┼────────────────┼───────────│
Degraded/Workaround │     P3      │       P2       │    P2     │
────────────────────┼─────────────┼────────────────┼───────────│
Cosmetic/Minor      │     P3      │       P3       │    P3     │
────────────────────┴─────────────┴────────────────┴───────────┘
```

---

## Issue Lifecycle

### States

```
┌─────────┐    ┌──────────┐    ┌─────────────┐    ┌───────────┐    ┌────────┐
│   New   │───►│  Triaged │───►│ In Progress │───►│ In Review │───►│ Closed │
└─────────┘    └──────────┘    └─────────────┘    └───────────┘    └────────┘
     │              │                 │                 │
     │              │                 │                 │
     ▼              ▼                 ▼                 ▼
┌─────────┐    ┌──────────┐    ┌─────────────┐    ┌───────────┐
│ Invalid │    │ Duplicate│    │   Blocked   │    │  Reopened │
└─────────┘    └──────────┘    └─────────────┘    └───────────┘
```

### State Definitions

| State | Description | Actions |
|-------|-------------|---------|
| New | Just reported, not yet reviewed | Awaiting triage |
| Triaged | Priority assigned, validated | Ready for assignment |
| In Progress | Actively being worked on | Developer assigned |
| In Review | Fix ready, awaiting review | Code review + QA |
| Closed | Resolved and verified | Deployed to production |
| Invalid | Not a bug or unreproducible | Documented reason |
| Duplicate | Already tracked elsewhere | Linked to original |
| Blocked | Waiting on external factor | Blocker documented |
| Reopened | Previously closed, issue persists | Re-triaged |

---

## Required Information

### Bug Report Template

```markdown
## Bug Description
[Clear description of the issue]

## Steps to Reproduce
1.
2.
3.

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Browser/Client:
- User Role:
- Timestamp:

## Screenshots/Logs
[Attach relevant evidence]

## Impact Assessment
- Users Affected:
- Workaround Available:
```

### Triage Checklist

- [ ] Issue is reproducible
- [ ] Priority assigned
- [ ] Component/area tagged
- [ ] Assignee identified (if P0/P1)
- [ ] Sprint/milestone assigned
- [ ] Related issues linked
- [ ] Customer communication needed?

---

## Roles and Responsibilities

| Role | Responsibility |
|------|----------------|
| Reporter | Provide complete bug information |
| Triage Lead | Daily review of new issues, priority assignment |
| Developer | Fix within SLA, update issue status |
| QA | Verify fixes, regression testing |
| Scrum Master | Monitor metrics, process compliance |

## Metrics and Reporting

### Weekly Metrics
- Open issues by priority
- Average time to resolution
- Bug escape rate
- Reopen rate

### Targets

| Metric | Target |
|--------|--------|
| P0 Resolution | < 4 hours |
| P1 Resolution | < 5 days |
| P2 Resolution | < 15 days |
| Bug Reopen Rate | < 10% |
| Triage Time | < 24 hours |

---

*Last Updated: 2026-01-01*
