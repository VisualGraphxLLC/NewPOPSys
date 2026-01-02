# Definition of Ready (DoR)

## Overview

The Definition of Ready establishes the criteria a user story must meet before it can be pulled into a sprint. Stories that don't meet these criteria should be refined before sprint planning.

---

## Entry Criteria for Sprint Planning

### Core Requirements

#### 1. Clear Description with Acceptance Criteria
- [ ] **User story format** - Written as "As a [user], I want [goal], so that [benefit]"
- [ ] **Acceptance criteria defined** - Clear, testable conditions for completion
- [ ] **Success metrics identified** - How we'll measure the feature's success
- [ ] **Edge cases documented** - Known edge cases and how to handle them

#### 2. Dependencies Identified
- [ ] **Technical dependencies** - Required APIs, services, or libraries identified
- [ ] **Team dependencies** - Other team members or teams needed are aware
- [ ] **External dependencies** - Third-party services or approvals needed
- [ ] **Blockers resolved** - No outstanding blockers that would prevent work

#### 3. Estimate Provided (Story Points)
- [ ] **Story pointed** - Team has estimated complexity using story points
- [ ] **Fits in sprint** - Story is small enough to complete within one sprint
- [ ] **Broken down if needed** - Large stories split into smaller, deliverable pieces

#### 4. Design/Wireframe Available (if UI)
- [ ] **Visual design approved** - Mockups or wireframes reviewed by stakeholders
- [ ] **Responsive specs** - Designs for desktop, tablet, and mobile if applicable
- [ ] **Component library alignment** - Design uses existing components where possible
- [ ] **Accessibility requirements** - A11y considerations documented in design

#### 5. API Contract Defined (if Backend)
- [ ] **Endpoint specification** - Request/response format documented
- [ ] **Error handling defined** - Error codes and messages specified
- [ ] **Authentication/authorization** - Security requirements documented
- [ ] **Performance requirements** - Expected latency and throughput defined

---

## Checklist Summary

| Criteria | Required For | Status |
|----------|--------------|--------|
| Clear description with acceptance criteria | All stories | ⬜ |
| Dependencies identified | All stories | ⬜ |
| Estimate provided (story points) | All stories | ⬜ |
| Design/wireframe available | UI stories | ⬜ |
| API contract defined | Backend stories | ⬜ |

---

## Refinement Process

### Before Refinement
1. Product Owner drafts user story with basic acceptance criteria
2. Story is added to the backlog for refinement

### During Refinement
1. Team reviews story and asks clarifying questions
2. Acceptance criteria are finalized
3. Dependencies are identified
4. Design assets are attached (if applicable)
5. Story is estimated

### After Refinement
1. Story is marked as "Ready"
2. Story can be pulled into sprint planning

---

## Red Flags (Not Ready)

A story is **NOT ready** if:
- ❌ Acceptance criteria are vague or missing
- ❌ "We'll figure it out during the sprint"
- ❌ Waiting on design or approval
- ❌ Dependencies are unresolved
- ❌ Story is too large (>8 story points)
- ❌ Technical approach is unclear

---

*Last Updated: 2026-01-01*
