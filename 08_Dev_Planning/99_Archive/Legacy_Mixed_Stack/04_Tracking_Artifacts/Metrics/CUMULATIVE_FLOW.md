# Cumulative Flow Diagram - NewPOPSys v1

## CFD Overview

The Cumulative Flow Diagram (CFD) shows the cumulative number of items in each workflow state over time. It helps identify bottlenecks, WIP issues, and flow problems.

---

## Current Sprint CFD: S0 Foundation

### CFD Visualization Template

```
Items
  ^
50 |                                          ████████ Done
   |                                    ██████████████
45 |                              ██████████████████████
   |                        ██████████████████████████████ Review
40 |                  ████████████████████████████████████
   |            ██████████████████████████████████████████
35 |      ████████████████████████████████████████████████ In Progress
   |████████████████████████████████████████████████████████
30 |██████████████████████████████████████████████████████████
   |████████████████████████████████████████████████████████████ To Do
25 |████████████████████████████████████████████████████████████████
   |██████████████████████████████████████████████████████████████████
20 |██████████████████████████████████████████████████████████████████████
   |████████████████████████████████████████████████████████████████████████
15 |██████████████████████████████████████████████████████████████████████████ Backlog
   +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---> Days
       1   2   3   4   5   6   7   8   9  10  11  12  13  14
```

---

## Daily CFD Data

| Day | Date | Backlog | To Do | In Progress | Review | Done | Total |
|-----|------|---------|-------|-------------|--------|------|-------|
| 0 | 2026-01-05 | 52 | 0 | 0 | 0 | 0 | 52 |
| 1 | 2026-01-06 | - | - | - | - | - | - |
| 2 | 2026-01-07 | - | - | - | - | - | - |
| 3 | 2026-01-08 | - | - | - | - | - | - |
| 4 | 2026-01-09 | - | - | - | - | - | - |
| 5 | 2026-01-10 | - | - | - | - | - | - |
| 6 | 2026-01-13 | - | - | - | - | - | - |
| 7 | 2026-01-14 | - | - | - | - | - | - |
| 8 | 2026-01-15 | - | - | - | - | - | - |
| 9 | 2026-01-16 | - | - | - | - | - | - |
| 10 | 2026-01-17 | - | - | - | - | - | - |

---

## Mermaid CFD Representation

```mermaid
xychart-beta
    title "Cumulative Flow - S0 Sprint"
    x-axis ["D0", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10"]
    y-axis "Items (Cumulative)" 0 --> 60
    line "Backlog" [52]
    line "To Do" [0]
    line "In Progress" [0]
    line "Review" [0]
    line "Done" [0]
```

---

## CFD Metrics

### Work in Progress (WIP)

| State | Current WIP | WIP Limit | Status |
|-------|-------------|-----------|--------|
| Backlog | 52 | Unlimited | Normal |
| To Do | 0 | 5 | Normal |
| In Progress | 0 | 3 | Normal |
| Review | 0 | 2 | Normal |
| Done | 0 | Unlimited | Normal |
| **Total WIP** | **0** | **10** | **Normal** |

### Flow Metrics

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Average Cycle Time | - | < 3 days | - |
| Average Lead Time | - | < 5 days | - |
| Throughput (items/day) | - | 0.5-1.0 | - |
| WIP Age (avg) | - | < 2 days | - |

---

## CFD Pattern Analysis

### Healthy Flow Pattern
```
All bands grow steadily to the right
Consistent band widths (stable WIP)
Done band grows at consistent rate
```

### Bottleneck Pattern
```
One band expands while others remain flat
Indicates blockage at that stage
Action: Focus resources on bottleneck
```

### Scope Creep Pattern
```
Total height increases mid-timeline
New items added faster than completed
Action: Review scope change process
```

### Starvation Pattern
```
Downstream bands stop growing
Upstream band not feeding downstream
Action: Investigate blockers upstream
```

---

## Band Width Analysis

| State | Target Width | Current Width | Trend |
|-------|--------------|---------------|-------|
| Backlog | Decreasing | - | - |
| To Do | Stable (3-5) | - | - |
| In Progress | Stable (2-3) | - | - |
| Review | Stable (1-2) | - | - |
| Done | Increasing | - | - |

---

## Approximate Cycle Time Calculation

```
Cycle Time = Avg Items in "In Progress" + "Review" / Throughput

Example:
  Avg WIP in Progress: 2.5 items
  Avg WIP in Review: 1.5 items
  Total Active WIP: 4 items
  Throughput: 1 item/day
  Cycle Time = 4 / 1 = 4 days
```

---

## Historical CFD Summary

| Sprint | Avg WIP | Throughput | Cycle Time | Issues |
|--------|---------|------------|------------|--------|
| S0 | - | - | - | Not started |
| S1 | - | - | - | Planned |
| S2 | - | - | - | Planned |

---

## CFD Improvement Actions

| Date | Issue Observed | Action Taken | Result |
|------|----------------|--------------|--------|
| - | - | - | - |

---

## Reading the CFD

### Key Indicators

| Observation | What It Means | Action |
|-------------|---------------|--------|
| Widening band | WIP increasing in that state | Investigate blockers |
| Narrowing band | WIP decreasing | May need more work pulled |
| Horizontal band | No progress | Critical blocker |
| Steps in Done | Items completed in batches | Consider smaller batches |
| Flat top line | No new work entering | Backlog needs grooming |

### Healthy CFD Characteristics

1. **Smooth curves** - Steady flow through system
2. **Consistent band widths** - Stable WIP
3. **Done band grows steadily** - Consistent throughput
4. **Total items stable or growing** - Scope managed

---

## Weekly CFD Review Checklist

- [ ] Identify any widening bands (bottlenecks)
- [ ] Check WIP against limits
- [ ] Calculate cycle time trend
- [ ] Verify throughput is meeting targets
- [ ] Note any scope changes
- [ ] Document blockers and resolutions

---

*Last Updated: 2026-01-01*
