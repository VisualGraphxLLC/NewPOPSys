# Development Planning - NewPOPSys v1.38

> **Purpose**: Agile development management artifacts complementing the IEEE 830 SRS in `07_SRS/`
> **Methodology**: Hybrid Agile/Scrum with Kanban + Gantt tracking
> **Timeline**: 13 weeks to Beta (End Q1 2026)
> **Budget**: $150,000

---

## Quick Navigation

| Section | Purpose | Key Documents |
|---------|---------|---------------|
| [00_Meta](./00_Meta/) | Framework & standards | [DEV_PLANNING_FRAMEWORK.md](./00_Meta/DEV_PLANNING_FRAMEWORK.md) |
| [01_Master_Plan](./01_Master_Plan/) | Strategic planning | [MASTER_DEVELOPMENT_PLAN.md](./01_Master_Plan/MASTER_DEVELOPMENT_PLAN.md) |
| [02_Sprint_Roadmap](./02_Sprint_Roadmap/) | Sprint breakdown | [SPRINT_ROADMAP.md](./02_Sprint_Roadmap/SPRINT_ROADMAP.md) |
| [03_Technical_Specs](./03_Technical_Specs/) | Implementation specs | [AI_DEV_SPECS.md](./03_Technical_Specs/AI_DEV_SPECS.md) |
| [04_Tracking_Artifacts](./04_Tracking_Artifacts/) | Kanban & Gantt | [GANTT_CHART.md](./04_Tracking_Artifacts/Gantt_Timeline/GANTT_CHART.md) |
| [05_Agile_Suite](./05_Agile_Suite/) | DoD, DoR, checklists | [DEFINITION_OF_DONE.md](./05_Agile_Suite/DEFINITION_OF_DONE.md) |
| [06_Risk_Quality](./06_Risk_Quality/) | Risk & quality gates | [RISK_REGISTER.md](./06_Risk_Quality/RISK_REGISTER.md) |
| [07_SRS_Alignment](./07_SRS_Alignment/) | SRS sync tracking | [SRS_SYNC_STATUS.md](./07_SRS_Alignment/SRS_SYNC_STATUS.md) |
| [99_Templates](./99_Templates/) | Reusable templates | Sprint, Task, Retro |

---

## Current Sprint Status

```
Sprint: S0 - Foundation          Status: NOT STARTED
Start:  2026-01-06               End: 2026-01-17
```

| Metric | Value |
|--------|-------|
| **Tasks Total** | 12 |
| **Completed** | 0 |
| **In Progress** | 0 |
| **Blocked** | 0 |

See [CURRENT_SPRINT.md](./04_Tracking_Artifacts/Sprint_Board/CURRENT_SPRINT.md) for details.

---

## Sprint Timeline

```
Week 1-2   : S0 - Foundation & Infrastructure
Week 3-4   : S1 - Authentication & Core UI
Week 5-6   : S2 - Mobile App Core
Week 7-8   : S3 - Brand Admin Portal
Week 9-10  : S4 - PSP Operations Portal
Week 11-12 : S5 - Store Portal & Integration
Week 13    : S6 - Polish, Testing & Beta Launch
```

See [GANTT_CHART.md](./04_Tracking_Artifacts/Gantt_Timeline/GANTT_CHART.md) for visual timeline.

---

## Relationship to SRS

This folder contains **development process** artifacts. Requirements are in `07_SRS/`:

| This Folder (08_Dev_Planning) | SRS Folder (07_SRS) |
|-------------------------------|---------------------|
| How we build | What we build |
| Sprint plans | Screen specifications |
| Task tracking | Functional requirements |
| Kanban/Gantt | Use cases & workflows |
| Quality gates | Acceptance criteria |

Cross-reference: [SRS_SYNC_STATUS.md](./07_SRS_Alignment/SRS_SYNC_STATUS.md)

---

## Key Artifacts

### For Daily Standups
- [CURRENT_SPRINT.md](./04_Tracking_Artifacts/Sprint_Board/CURRENT_SPRINT.md) - Today's tasks
- [SPRINT_BOARD_VIEW.md](./04_Tracking_Artifacts/Sprint_Board/SPRINT_BOARD_VIEW.md) - Kanban view

### For Sprint Planning
- [BACKLOG.md](./04_Tracking_Artifacts/Sprint_Board/BACKLOG.md) - Prioritized backlog
- [DEFINITION_OF_READY.md](./05_Agile_Suite/DEFINITION_OF_READY.md) - Entry criteria

### For Sprint Review
- [BURNDOWN_CHART.md](./04_Tracking_Artifacts/Metrics/BURNDOWN_CHART.md) - Progress tracking
- [SPRINT_METRICS.md](./04_Tracking_Artifacts/Metrics/SPRINT_METRICS.md) - Velocity data

### For Releases
- [RELEASE_CHECKLIST.md](./05_Agile_Suite/RELEASE_CHECKLIST.md) - Pre-release verification
- [QUALITY_GATES.md](./06_Risk_Quality/QUALITY_GATES.md) - Quality checkpoints

---

## Document Index

### 00_Meta/ (Framework)
- `DEV_PLANNING_FRAMEWORK.md` - Methodology documentation
- `NAMING_CONVENTIONS.md` - Standards for task IDs, branches
- `RELATIONSHIP_DIAGRAM.md` - How documents connect

### 01_Master_Plan/ (Strategy)
- `MASTER_DEVELOPMENT_PLAN.md` - Project overview, budget, scope
- `PROJECT_CHARTER.md` - Executive summary
- `MILESTONE_SCHEDULE.md` - High-level timeline with gates
- `RESOURCE_ALLOCATION.md` - Team structure

### 02_Sprint_Roadmap/ (Sprints)
- `SPRINT_ROADMAP.md` - Sprint overview
- `SPRINT_CALENDAR.md` - Date-bound schedule
- `DEPENDENCY_MAP.md` - Cross-sprint dependencies
- `Sprints/SPRINT_S0_Foundation.md` through `SPRINT_S6_Launch.md`

### 03_Technical_Specs/ (Implementation)
- `AI_DEV_SPECS.md` - Detailed technical specs
- `TECH_STACK_DECISIONS.md` - ADR-style decisions
- `ARCHITECTURE_OVERVIEW.md` - System architecture
- `MONOREPO_STRUCTURE.md` - Code organization
- `IMPLEMENTATION_PATTERNS.md` - Code patterns

### 04_Tracking_Artifacts/ (Progress)
- `Sprint_Board/` - Kanban views
- `Gantt_Timeline/` - Timeline views
- `Metrics/` - Burndown, velocity, flow

### 05_Agile_Suite/ (Process)
- `DEFINITION_OF_DONE.md` - Quality criteria
- `DEFINITION_OF_READY.md` - Entry criteria
- `ACCEPTANCE_CRITERIA_GUIDE.md` - AC writing guide
- `TECH_DEBT_REGISTER.md` - Technical debt tracking
- `RELEASE_CHECKLIST.md` - Release verification
- `TESTING_STRATEGY.md` - Test approach
- `RETROSPECTIVE_LOG.md` - Retro summaries

### 06_Risk_Quality/ (Governance)
- `RISK_REGISTER.md` - Active risks
- `QUALITY_GATES.md` - Sprint checkpoints
- `DEPENDENCY_RISKS.md` - External dependencies
- `ISSUE_TRACKER_POLICY.md` - Bug triage

### 07_SRS_Alignment/ (Sync)
- `SRS_SYNC_STATUS.md` - Alignment tracker
- `SCREEN_IMPLEMENTATION_MAP.md` - Screen to sprint mapping
- `SUPP_IMPLEMENTATION_MAP.md` - SUPP to sprint mapping
- `CHANGE_CONTROL_LOG.md` - Scope changes

### 99_Templates/ (Reusable)
- `SPRINT_TEMPLATE.md`
- `TASK_TEMPLATE.md`
- `RETROSPECTIVE_TEMPLATE.md`
- `RELEASE_NOTES_TEMPLATE.md`
- `INCIDENT_TEMPLATE.md`

---

*Created: 2026-01-01 | Last Updated: 2026-01-01*
