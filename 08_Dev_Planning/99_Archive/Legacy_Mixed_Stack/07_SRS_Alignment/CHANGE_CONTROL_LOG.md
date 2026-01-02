# Change Control Log

## Overview

This document tracks all scope changes, requirement modifications, and their impacts on the project. All changes must go through the formal Change Control process.

---

## Change Request Summary

| Status | Count | Effort Impact |
|--------|-------|---------------|
| Pending Review | 0 | 0 SP |
| Approved | 0 | 0 SP |
| Rejected | 0 | N/A |
| Implemented | 0 | 0 SP |
| **Total** | **0** | **0 SP** |

---

## Active Change Requests

### Pending Review

| CR ID | Title | Requested By | Date | Priority | Status |
|-------|-------|--------------|------|----------|--------|
| - | No pending requests | - | - | - | - |

### Under Implementation

| CR ID | Title | Sprint | Effort | Completion |
|-------|-------|--------|--------|------------|
| - | No active implementations | - | - | - |

---

## Change Request Log

### Template for New Entries

```
### CR-XXX: [Title]

**Requested By**: [Name/Role]
**Request Date**: YYYY-MM-DD
**Priority**: [Critical/High/Medium/Low]
**Status**: [Pending/Approved/Rejected/Implemented]

#### Description
[Detailed description of the requested change]

#### Business Justification
[Why this change is needed]

#### Scope Impact
- **SRS Documents Affected**: [List]
- **Screens Affected**: [List screen IDs]
- **Sprints Affected**: [List]

#### Effort Assessment
- **Development**: X story points
- **Testing**: X story points
- **Documentation**: X story points
- **Total**: X story points

#### Schedule Impact
- **Sprint Delay**: [None/X sprints]
- **Delivery Date Impact**: [None/Delayed to YYYY-MM-DD]

#### Risk Assessment
[Any risks introduced by this change]

#### Decision
- **Decision Date**: YYYY-MM-DD
- **Decision By**: [CAB/PM/PO]
- **Decision**: [Approved/Rejected/Deferred]
- **Rationale**: [Explanation]

#### Implementation
- **Implementation Sprint**: Sprint X
- **Completion Date**: YYYY-MM-DD
- **Verified By**: [Name]
```

---

## Approved Changes

| CR ID | Title | Approved Date | Sprint | Effort | Implemented |
|-------|-------|---------------|--------|--------|-------------|
| - | No approved changes yet | - | - | - | - |

---

## Rejected Changes

| CR ID | Title | Rejected Date | Reason |
|-------|-------|---------------|--------|
| - | No rejected changes | - | - |

---

## Deferred Changes

| CR ID | Title | Deferred Date | Defer Until | Reason |
|-------|-------|---------------|-------------|--------|
| - | No deferred changes | - | - | - |

---

## Change Control Process

### 1. Submission

```
┌─────────────────────────────────────────────────────────┐
│ Change Request Submitted                                │
│ - Complete CR form                                      │
│ - Attach supporting documentation                       │
│ - Submit to Project Manager                             │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
```

### 2. Initial Assessment

```
┌─────────────────────────────────────────────────────────┐
│ Initial Assessment (within 2 business days)             │
│ - PM reviews for completeness                           │
│ - Tech Lead provides initial effort estimate            │
│ - Impact assessment prepared                            │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
```

### 3. CAB Review

```
┌─────────────────────────────────────────────────────────┐
│ Change Advisory Board Review                            │
│ - Present change and impact                             │
│ - Stakeholder input                                     │
│ - Decision: Approve / Reject / Defer                    │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
     ┌────────┐     ┌──────────┐    ┌──────────┐
     │Approved│     │ Rejected │    │ Deferred │
     └────────┘     └──────────┘    └──────────┘
          │
          ▼
```

### 4. Implementation

```
┌─────────────────────────────────────────────────────────┐
│ Implementation                                          │
│ - Add to sprint backlog                                 │
│ - Update SRS documents                                  │
│ - Develop, test, deploy                                 │
│ - Update documentation                                  │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│ Verification & Closure                                  │
│ - Verify implementation complete                        │
│ - Update traceability matrices                          │
│ - Close change request                                  │
└─────────────────────────────────────────────────────────┘
```

---

## Change Advisory Board (CAB)

### Members

| Role | Name | Authority |
|------|------|-----------|
| Project Manager | TBD | Chair, Schedule decisions |
| Product Owner | TBD | Scope decisions |
| Tech Lead | TBD | Technical feasibility |
| Business Sponsor | TBD | Budget approval (>20 SP) |
| QA Lead | TBD | Quality impact assessment |

### Meeting Schedule

- **Regular CAB**: Weekly (as needed)
- **Emergency CAB**: Within 4 hours for Critical changes

### Decision Authority

| Change Size | Authority |
|-------------|-----------|
| Minor (< 5 SP) | Tech Lead + PO |
| Medium (5-20 SP) | CAB (standard) |
| Major (> 20 SP) | CAB + Business Sponsor |
| Critical (any size) | Emergency CAB |

---

## Impact Categories

### Scope Impact Levels

| Level | Description | Examples |
|-------|-------------|----------|
| None | No scope change | Bug fix, clarification |
| Minor | Small addition/change | New field, UI tweak |
| Moderate | Feature modification | New screen, workflow change |
| Major | Significant new work | New module, integration |
| Critical | Fundamental change | Architecture change |

### Schedule Impact Levels

| Level | Impact | Mitigation Options |
|-------|--------|---------------------|
| None | No delay | N/A |
| Minimal | < 1 week | Overtime, scope trade |
| Moderate | 1-2 weeks | Scope trade, resources |
| Significant | > 2 weeks | Phase shift, resources |
| Critical | > 1 sprint | Replanning required |

---

## Metrics

### Change Request Metrics

| Metric | Target | Current |
|--------|--------|---------|
| CR Response Time | < 2 days | N/A |
| Average Approval Time | < 5 days | N/A |
| CR Rejection Rate | < 30% | N/A |
| Implementation Success | > 95% | N/A |
| Scope Creep Index | < 10% | 0% |

---

*Last Updated: 2026-01-01*
