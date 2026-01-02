# Naming Conventions

> Standards for task IDs, branches, and document naming
> **Version**: 1.0

---

## 1. Task IDs

### Format
```
S{sprint_number}-{sequence_number}
```

### Examples
| ID | Meaning |
|----|---------|
| `S0-01` | Sprint 0, Task 1 |
| `S3-15` | Sprint 3, Task 15 |
| `S6-08` | Sprint 6, Task 8 |

### Sub-tasks
```
S{sprint}-{task}.{subtask}
Example: S2-04.1, S2-04.2
```

---

## 2. Sprint Names

### Format
```
S{number} - {Theme}
```

### Project Sprints
| Sprint | Name |
|--------|------|
| S0 | Foundation & Infrastructure |
| S1 | Authentication & Core UI |
| S2 | Mobile App Core |
| S3 | Brand Admin Portal |
| S4 | PSP Operations Portal |
| S5 | Store Portal & Integration |
| S6 | Polish, Testing & Beta Launch |

---

## 3. Screen IDs

### Format
```
{Module Prefix}{Number}
```

### Prefixes
| Prefix | Module |
|--------|--------|
| L | Shared/Login |
| M | Mobile App |
| B | Brand Admin |
| S | Store Portal |
| P | PSP Operations |
| SET | Settings |

### Examples
| ID | Screen |
|----|--------|
| L01 | Universal Login |
| M01 | Mobile Login |
| M05 | Photo Capture |
| B03 | Store Selection |
| P02 | Shipments |

---

## 4. Git Branches

### Format
```
{type}/{sprint}-{task-id}-{short-description}
```

### Types
| Type | Usage |
|------|-------|
| `feature/` | New functionality |
| `fix/` | Bug fixes |
| `refactor/` | Code improvements |
| `docs/` | Documentation |
| `test/` | Test additions |

### Examples
```
feature/S1-01-universal-login
fix/S2-04-photo-upload-retry
refactor/S3-07-campaign-state
docs/S0-05-api-documentation
```

---

## 5. Commit Messages

### Format
```
{type}({scope}): {description}

[optional body]
[optional footer]
```

### Types
| Type | Usage |
|------|-------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `style` | Formatting |
| `refactor` | Restructuring |
| `test` | Tests |
| `chore` | Maintenance |

### Examples
```
feat(auth): implement MFA verification flow
fix(mobile): resolve photo upload memory leak
docs(api): add campaign endpoints documentation
```

---

## 6. File Naming

### Documents
```
UPPERCASE_WITH_UNDERSCORES.md
```
Examples: `SPRINT_ROADMAP.md`, `RISK_REGISTER.md`

### Sprint Files
```
SPRINT_S{number}_{Theme}.md
```
Examples: `SPRINT_S0_Foundation.md`, `SPRINT_S3_BrandAdmin.md`

### Code Files
```
PascalCase.tsx (components)
camelCase.ts (utilities)
kebab-case.ts (configs)
```

---

## 7. Priority Labels

| Priority | Label | Color |
|----------|-------|-------|
| P0 | Critical | Red |
| P1 | High | Orange |
| P2 | Medium | Yellow |
| P3 | Low | Green |

---

## 8. Status Labels

| Status | Symbol | Color |
|--------|--------|-------|
| Pending | ⬜ | Gray |
| In Progress | 🔵 | Blue |
| In Review | 🟡 | Yellow |
| Blocked | 🔴 | Red |
| Done | ✅ | Green |

---

*Last Updated: 2026-01-01*
