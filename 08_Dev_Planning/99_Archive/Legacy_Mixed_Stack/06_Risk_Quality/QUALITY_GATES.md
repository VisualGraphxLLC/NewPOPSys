# Quality Gates

## Overview

Quality gates are checkpoints throughout each sprint to ensure deliverables meet defined standards before proceeding. All gates must be passed before the sprint can be considered complete.

---

## Gate 1: Sprint Planning Complete

**Timing**: End of Sprint Planning session (Day 1)

### Entry Criteria
- [ ] Previous sprint retrospective completed
- [ ] Backlog grooming session held
- [ ] Team capacity confirmed

### Exit Criteria
- [ ] Sprint goal defined and documented
- [ ] All sprint backlog items have clear acceptance criteria
- [ ] Story points assigned to all items
- [ ] Team commitment confirmed
- [ ] Dependencies identified and documented
- [ ] Sprint board set up and ready

### Artifacts Required
- Sprint planning document
- Updated sprint backlog
- Capacity planning sheet

### Gate Owner
Product Owner + Scrum Master

---

## Gate 2: Mid-Sprint Review

**Timing**: Middle of sprint (typically Day 5 of 10-day sprint)

### Entry Criteria
- [ ] Sprint is 50% complete
- [ ] Daily standups conducted

### Exit Criteria
- [ ] At least 40% of sprint points in "Done" or "In Review"
- [ ] No critical blockers unaddressed for > 24 hours
- [ ] Technical debt items tracked
- [ ] Risk assessment updated
- [ ] Scope changes (if any) documented

### Health Check Questions
1. Are we on track to meet sprint goal?
2. Are there any emerging risks?
3. Do any stories need to be descoped?
4. Is the team maintaining sustainable pace?

### Actions if Gate Fails
- Immediate team huddle
- Scope reassessment
- Resource reallocation if needed
- Stakeholder communication

### Gate Owner
Scrum Master + Tech Lead

---

## Gate 3: Code Freeze

**Timing**: 2 days before sprint end

### Entry Criteria
- [ ] All development work complete
- [ ] Code reviews completed
- [ ] Unit tests passing

### Exit Criteria
- [ ] All code merged to sprint branch
- [ ] No new features after this point
- [ ] Integration tests passing
- [ ] Code coverage meets threshold (≥80%)
- [ ] Static analysis clean (no critical issues)
- [ ] Security scan completed
- [ ] Documentation updated

### Technical Checklist
```
□ All PRs merged
□ Build successful
□ Unit tests: ≥80% coverage
□ Integration tests: All passing
□ Performance tests: Within baseline
□ Security scan: No critical/high findings
□ API documentation updated
□ Database migrations tested
```

### Actions if Gate Fails
- Only critical bug fixes allowed
- Extended testing period
- Potential sprint goal adjustment

### Gate Owner
Tech Lead + QA Lead

---

## Gate 4: Sprint Review

**Timing**: Last day of sprint

### Entry Criteria
- [ ] Code freeze gate passed
- [ ] QA testing complete
- [ ] Demo environment prepared

### Exit Criteria
- [ ] All "Done" items meet Definition of Done
- [ ] Product Owner accepts completed stories
- [ ] Demo conducted successfully
- [ ] Release notes prepared
- [ ] Known issues documented
- [ ] Technical debt logged
- [ ] Metrics collected

### Definition of Done Checklist
```
□ Code complete and reviewed
□ Unit tests written and passing
□ Integration tests passing
□ Documentation complete
□ Deployed to staging
□ PO acceptance received
□ No critical bugs outstanding
```

### Sprint Metrics Collected
- Velocity (points completed)
- Commitment vs. Delivery ratio
- Bug escape rate
- Code coverage delta
- Cycle time

### Gate Owner
Product Owner + Scrum Master

---

## Quality Gate Summary Dashboard

| Gate | Timing | Primary Owner | Key Metric |
|------|--------|---------------|------------|
| Gate 1 | Day 1 | PO + SM | Sprint goal defined |
| Gate 2 | Day 5 | SM + TL | 40% points done |
| Gate 3 | Day 8 | TL + QA | All code merged |
| Gate 4 | Day 10 | PO + SM | Stories accepted |

## Escalation Path

```
Gate Failure
     │
     ▼
Scrum Master Assessment
     │
     ├──► Minor: Team resolves internally
     │
     ├──► Moderate: Tech Lead/PO involved
     │
     └──► Major: Project Manager + Stakeholders
```

---

*Last Updated: 2026-01-01*
