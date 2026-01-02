# Dev Planning Kickoff Prompt

> Execute this prompt when SRS (07_SRS) is complete to begin Development Planning execution.

---

## ORCHESTRATOR PROTOCOL

**Reference:** `/orchestrator` (global skill)

The orchestrator protocol is now a global skill. When starting a dev planning session, first invoke `/orchestrator` to activate dispatcher mode.

**Core Rule:** YOU ARE A DISPATCHER, NOT A WORKER. Never read, write, or analyze directly. Always dispatch agents.

---

## AGENT FLEET (Global Skills)

All agents are defined as global skills in `~/.claude/commands/`. Invoke them with DISPATCH syntax:

| Agent | Skill Command | Purpose | Response Limit |
|-------|---------------|---------|----------------|
| Analyzer | `/analyzer-agent` | Read files, summarize content | ≤20 lines |
| Writer | `/writer-agent` | Create/edit documents | ≤10 lines |
| Tracker | `/tracker-agent` | Update progress trackers | ≤5 lines |
| Executor | `/executor-agent` | Implement sprint tasks | ≤15 lines |
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
- `dev-planning` - Phase identifier
- `sprint-s<N>` - Sprint number

---

## EXECUTION WORKFLOW

```
1. DISPATCH analyzer -> "Summarize current sprint status from PROGRESS_TRACKER.md"
2. RECEIVE summary (under 20 lines)
3. DISPATCH analyzer -> "Read Sprint S[N] file and list incomplete tasks"
4. RECEIVE task list (under 20 lines)
5. FOR EACH task:
   a. DISPATCH executor -> "Complete task [X]"
   b. RECEIVE confirmation
   c. DISPATCH tracker -> "Update trackers for completed task [X]"
   d. RECEIVE confirmation
6. DISPATCH memory-sync -> "Save sprint completion summary"
7. REPEAT for next sprint
```

---

## KICKOFF COMMAND

**Step 1:** Activate orchestrator mode
```
/orchestrator
```

**Step 2:** Dispatch first agent to assess status
```
DISPATCH analyzer-agent:
"Read SOW/08_Dev_Planning/00_Meta/PROGRESS_TRACKER.md and SOW/08_Dev_Planning/04_Tracking_Artifacts/Sprint_Board/CURRENT_SPRINT.md.
Return: (1) Current phase status, (2) Next incomplete task, (3) Any blockers.
Save detailed status to memory with tags: ['popsys', 'dev-planning', 'status', 'kickoff']
Keep response under 20 lines."
```

---

## SPRINT SEQUENCE (DO NOT SKIP)

| Sprint | Status | Prerequisite |
|--------|--------|--------------|
| S0 - Foundation | Ready | SRS Complete |
| S1 - Auth & Core UI | Blocked | S0 Complete |
| S2 - Mobile App Core | Blocked | S1 Complete |
| S3 - Brand Admin Portal | Blocked | S2 Complete |
| S4 - PSP Operations Portal | Blocked | S3 Complete |
| S5 - Store Portal & Integration | Blocked | S4 Complete |
| S6 - Polish, Testing & Beta | Blocked | S5 Complete |

---

## EMERGENCY RULES

1. **Context getting long?** Dispatch memory-sync to save current state, then start fresh conversation
2. **Agent returned too much?** Tell them: "Summarize to under 20 lines, save details to memory"
3. **Uncertain what to do?** Dispatch analyzer to read relevant docs and summarize options
4. **Need to resume later?** Dispatch tracker to ensure all progress is logged, then dispatch memory-sync to save session state

---

*Created: 2026-01-01 | Updated: 2026-01-01 | Protocol Version: 2.0 (Global Skills)*
