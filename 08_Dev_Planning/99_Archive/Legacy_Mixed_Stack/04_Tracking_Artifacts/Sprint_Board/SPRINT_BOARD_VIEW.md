# Sprint Board View - NewPOPSys v1

## Kanban Board Template

### Board Configuration

| Column | WIP Limit | Description |
|--------|-----------|-------------|
| Backlog | Unlimited | Prioritized items ready for sprint planning |
| To Do | 5 | Committed items for current sprint |
| In Progress | 3 | Actively being worked on |
| Review | 2 | Code review / QA / stakeholder review |
| Done | Unlimited | Completed and accepted |

---

## Current Sprint Board

| Backlog | To Do (WIP:5) | In Progress (WIP:3) | Review (WIP:2) | Done |
|---------|---------------|---------------------|----------------|------|
| | | | | |
| | | | | |
| | | | | |
| | | | | |
| | | | | |

---

## Task Movement Rules

### Entry Criteria (Moving Right)

| Transition | Criteria |
|------------|----------|
| Backlog → To Do | Sprint planning commitment, acceptance criteria defined |
| To Do → In Progress | WIP limit not exceeded, developer assigned, dependencies resolved |
| In Progress → Review | Implementation complete, unit tests passing, PR created |
| Review → Done | Code reviewed, QA passed, acceptance criteria verified, merged |

### Exit Criteria (Blocking)

| Column | Blocking Conditions |
|--------|---------------------|
| To Do | Missing requirements, unclear acceptance criteria |
| In Progress | Blocked by dependency, waiting for clarification |
| Review | Failed code review, QA issues, stakeholder feedback pending |

---

## WIP Limit Policies

### Enforcement Rules

1. **Hard Limit**: Cannot move task into column if WIP limit reached
2. **Pull System**: Team members pull work when capacity available
3. **Swarming**: If column is full, help complete existing items first
4. **Escalation**: Blocked items > 24 hours escalated to daily standup

### WIP Limit Adjustments

| Scenario | Action |
|----------|--------|
| Consistent bottleneck | Increase limit by 1, monitor for 1 sprint |
| Frequent idle time | Decrease limit by 1, monitor for 1 sprint |
| Sprint retrospective | Team vote to adjust limits |

---

## Card Template

```markdown
### [TASK-XXX] Task Title
**Priority**: P0/P1/P2/P3
**Estimate**: X SP
**Assignee**: @username
**Sprint**: SX

**Description**: Brief task description

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2

**Dependencies**: TASK-YYY, TASK-ZZZ
**Blocked By**: (if applicable)
**Labels**: [API] [UI] [Database] [Integration]
```

---

## Daily Standup Format

1. Review board right-to-left (Review → In Progress → To Do)
2. Identify blocked items
3. Verify WIP limits respected
4. Update task status
5. Flag risks and dependencies

---

## Sprint Board Metrics

| Metric | Current Value | Target |
|--------|---------------|--------|
| Avg Cycle Time | - | < 3 days |
| WIP Violations | - | 0 per sprint |
| Blocked Items | - | < 2 at any time |
| Throughput | - | 15-20 SP/sprint |

---

*Last Updated: 2026-01-01*
