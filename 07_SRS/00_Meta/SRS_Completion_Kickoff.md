# SRS Completion Kickoff Prompt

> Execute this prompt to complete the remaining SRS documentation gaps for NewPOPSys v1.38.

---

## ORCHESTRATOR PROTOCOL

**Reference:** `/orchestrator` (global skill)

The orchestrator protocol is a global skill. When starting an SRS completion session, first invoke `/orchestrator` to activate dispatcher mode.

**Core Rule:** YOU ARE A DISPATCHER, NOT A WORKER. Never read, write, or analyze directly. Always dispatch agents.

---

## AGENT FLEET (Global Skills)

All agents are defined as global skills in `~/.claude/commands/`. Invoke them with DISPATCH syntax:

| Agent | Skill Command | Purpose | Response Limit |
|-------|---------------|---------|----------------|
| Analyzer | `/analyzer-agent` | Read files, summarize content | ≤20 lines |
| Writer | `/writer-agent` | Create/edit documents | ≤10 lines |
| Tracker | `/tracker-agent` | Update progress trackers | ≤5 lines |
| Memory Sync | `/memory-sync-agent` | Store/retrieve from memory | ≤10 lines |

### Dispatch Syntax

```
DISPATCH <agent-name>:
"[Instructions for the agent]
[Include relevant file paths]
[Specify tags for memory operations]"
```

### Project-Specific Tags

When dispatching agents for this project, include these tags:
- `popsys` - Project identifier
- `srs` - Document type
- `completion` - Phase identifier

---

## GAP ANALYSIS SUMMARY

Based on comprehensive review against SRS_MASTER_PLAN.md:

### Missing Files (Priority 1)
| File | Location | Status |
|------|----------|--------|
| L002_Universal_Dashboard.md | 05_Module_SharedFoundations/screens/ | NOT CREATED |
| 5.0_Module_Overview.md | 05_Module_SharedFoundations/ | NOT CREATED |
| 6.0_Module_Overview.md | 06_Module_MobilePWA/ | NOT CREATED |
| 7.0_Module_Overview.md | 07_Module_BrandAdmin/ | NOT CREATED |
| 8.0_Module_Overview.md | 08_Module_PSPOperations/ | NOT CREATED |
| 9.0_Module_Overview.md | 09_Module_StorePortal/ | NOT CREATED |
| 10.0_Module_Overview.md | 10_Module_PlatformAdmin/ | NOT CREATED |

### Missing Content (Priority 2)
| Issue | Affected Files | Action |
|-------|---------------|--------|
| Wireframes | All 27 screen specs | Add embedded Mermaid wireframes or link external assets |
| Traceability Matrix | Older screen files | Backward-update with REQ-XXX mappings |

### Quality Status
- **27 of 28 screen files exist** (96% implementation)
- Files are production-ready (11-13 sections vs 9 planned)
- Exceeds template with: Error Handling, Accessibility sections

---

## EXECUTION WORKFLOW

```
1. DISPATCH analyzer -> "Read L001_Universal_Login.md as reference template"
2. RECEIVE template structure (under 20 lines)
3. FOR EACH missing file:
   a. DISPATCH writer -> "Create [file] following template structure"
   b. RECEIVE confirmation
   c. DISPATCH tracker -> "Update PROGRESS_TRACKER.md for [file]"
   d. RECEIVE confirmation
4. FOR wireframe integration:
   a. DISPATCH analyzer -> "List all screen files needing wireframes"
   b. DISPATCH writer -> "Add Mermaid wireframe to [file]"
   c. DISPATCH tracker -> "Update progress"
5. DISPATCH memory-sync -> "Save SRS completion summary with tags"
6. DISPATCH tracker -> "Update Phase 6 to 100% in PROGRESS_TRACKER.md"
```

---

## KICKOFF COMMAND

**Step 1:** Activate orchestrator mode
```
/orchestrator
```

**Step 2:** Dispatch first agent to get reference template
```
DISPATCH analyzer-agent:
"Read SOW/07_SRS/05_Module_SharedFoundations/screens/L001_Universal_Login.md.
Extract the section structure and format.
Return: (1) Section list, (2) Key format patterns, (3) Mermaid diagram examples.
Save to memory with tags: ['popsys', 'srs', 'template-reference']
Keep response under 20 lines."
```

**Step 3:** Create missing L002 file
```
DISPATCH writer-agent:
"Create SOW/07_SRS/05_Module_SharedFoundations/screens/L002_Universal_Dashboard.md.
Follow the template structure from L001.
Screen Purpose: Unified dashboard shell that adapts based on user role/permissions.
Include sections: Overview, Wireframe (Mermaid), Screen Description, RBAC Matrix, Data Model, APIs, Business Rules, State Transitions, Error Handling, Accessibility, Acceptance Criteria, Traceability Matrix.
Save confirmation to memory with tags: ['popsys', 'srs', 'L002', 'created']
Keep response under 10 lines."
```

**Step 4:** Create Module Overview files (batch)
```
DISPATCH writer-agent:
"Create 6 Module Overview files:
- SOW/07_SRS/05_Module_SharedFoundations/5.0_Module_Overview.md
- SOW/07_SRS/06_Module_MobilePWA/6.0_Module_Overview.md
- SOW/07_SRS/07_Module_BrandAdmin/7.0_Module_Overview.md
- SOW/07_SRS/08_Module_PSPOperations/8.0_Module_Overview.md
- SOW/07_SRS/09_Module_StorePortal/9.0_Module_Overview.md
- SOW/07_SRS/10_Module_PlatformAdmin/10.0_Module_Overview.md

Each overview should contain:
1. Module purpose and scope
2. User roles served
3. Screen inventory table (linking to screen specs)
4. Key workflows diagram (Mermaid)
5. Integration points
6. Dependencies on other modules

Save confirmation to memory with tags: ['popsys', 'srs', 'module-overview', 'batch']
Keep response under 10 lines."
```

**Step 5:** Update progress tracker
```
DISPATCH tracker-agent:
"Update SOW/07_SRS/00_Meta/PROGRESS_TRACKER.md:
1. Add L002_Universal_Dashboard.md to 05_Module_SharedFoundations section
2. Add 6 Module Overview files to their respective sections
3. Update Phase 6 completion percentage
Save confirmation to memory with tags: ['popsys', 'srs', 'tracker-update']
Keep response under 5 lines."
```

---

## TASK CHECKLIST

| # | Task | Agent | Status |
|---|------|-------|--------|
| 1 | Create L002_Universal_Dashboard.md | Writer | ⏳ Not Started |
| 2 | Create 5.0_Module_Overview.md | Writer | ⏳ Not Started |
| 3 | Create 6.0_Module_Overview.md | Writer | ⏳ Not Started |
| 4 | Create 7.0_Module_Overview.md | Writer | ⏳ Not Started |
| 5 | Create 8.0_Module_Overview.md | Writer | ⏳ Not Started |
| 6 | Create 9.0_Module_Overview.md | Writer | ⏳ Not Started |
| 7 | Create 10.0_Module_Overview.md | Writer | ⏳ Not Started |
| 8 | Update PROGRESS_TRACKER.md | Tracker | ⏳ Not Started |
| 9 | Add wireframes to screen specs (optional) | Writer | ⏳ Not Started |
| 10 | Final review and PDF regeneration | Executor | ⏳ Not Started |

---

## EMERGENCY RULES

1. **Context getting long?** Dispatch memory-sync to save current state, then start fresh conversation
2. **Agent returned too much?** Tell them: "Summarize to under 20 lines, save details to memory"
3. **Uncertain what to do?** Dispatch analyzer to read relevant docs and summarize options
4. **Need to resume later?** Dispatch tracker to ensure all progress is logged, then dispatch memory-sync to save session state

---

## FILE LOCATIONS REFERENCE

| Resource | Path |
|----------|------|
| SRS Root | `SOW/07_SRS/` |
| Master Plan | `SOW/07_SRS/00_Meta/SRS_MASTER_PLAN.md` |
| Progress Tracker | `SOW/07_SRS/00_Meta/PROGRESS_TRACKER.md` |
| Screen Template | `SOW/07_SRS/05_Module_SharedFoundations/screens/L001_Universal_Login.md` |
| PDF Scripts | `SOW/07_SRS/00_Meta/generate_pdfs.ps1` |
| Combined SRS | `SOW/07_SRS/00_Meta/combine_srs.ps1` |

---

*Created: 2026-01-01 | Protocol Version: 2.0 (Global Skills) | Target: SRS Phase 6 Completion*
