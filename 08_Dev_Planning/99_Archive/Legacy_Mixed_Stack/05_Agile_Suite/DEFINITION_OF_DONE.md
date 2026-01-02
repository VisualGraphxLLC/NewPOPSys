# Definition of Done (DoD)

## Overview

The Definition of Done is a shared understanding of what it means for a user story or task to be considered complete. All items must be checked before a story can be moved to "Done."

---

## Quality Criteria Checklist

### Code Quality
- [ ] **Code complete and committed** - All code changes are finalized and pushed to the feature branch
- [ ] **Code follows project coding standards** - Linting passes with no errors
- [ ] **No hardcoded values** - Configuration externalized appropriately

### Testing
- [ ] **Unit tests passing** - All existing and new unit tests pass
- [ ] **Code coverage ≥80%** - Minimum coverage threshold met for new code
- [ ] **No test flakiness** - Tests are reliable and deterministic

### Code Review
- [ ] **Code reviewed and approved** - At least one team member has reviewed and approved the PR
- [ ] **Review comments addressed** - All feedback has been resolved or discussed

### Documentation
- [ ] **Documentation updated** - README, API docs, or inline comments updated as needed
- [ ] **Changelog updated** - Notable changes recorded for release notes

### Bug Status
- [ ] **No P0/P1 bugs** - No critical or high-priority bugs remain open for this feature
- [ ] **Known issues documented** - Any accepted limitations are documented

### Deployment
- [ ] **Deployed to staging** - Changes successfully deployed to staging environment
- [ ] **Smoke tests passing** - Basic functionality verified in staging

### Acceptance
- [ ] **Acceptance criteria verified** - All acceptance criteria from the user story are met
- [ ] **Product Owner sign-off** - PO has reviewed and accepted the implementation

### Accessibility
- [ ] **Accessibility checked (WCAG 2.1 AA)** - UI changes meet accessibility standards
- [ ] **Keyboard navigation works** - All interactive elements accessible via keyboard
- [ ] **Screen reader compatible** - Content readable by assistive technologies

---

## Quick Reference

| Category | Criteria | Required |
|----------|----------|----------|
| Code | Complete and committed | ✅ |
| Testing | Unit tests passing (≥80% coverage) | ✅ |
| Review | Code reviewed and approved | ✅ |
| Docs | Documentation updated | ✅ |
| Bugs | No P0/P1 bugs | ✅ |
| Deploy | Deployed to staging | ✅ |
| Accept | Acceptance criteria verified | ✅ |
| A11y | WCAG 2.1 AA compliance | ✅ |

---

## Exceptions

In rare circumstances, exceptions may be granted by the Tech Lead or Product Owner. All exceptions must be:
1. Documented in the ticket
2. Tracked as technical debt if applicable
3. Addressed within the next sprint

---

*Last Updated: 2026-01-01*
