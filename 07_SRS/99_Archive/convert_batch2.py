#!/usr/bin/env python3
"""Convert remaining ASCII diagrams (batch 2) to Mermaid format."""

file_path = r"E:\Docker\PopSystem\SOW\07_SRS\SRS_OUTPUT.md"

with open(file_path, 'r', encoding='utf-8', errors='surrogateescape') as f:
    content = f.read()
    lines = content.split('\n')

print(f"Read {len(lines)} lines")

# Mermaid replacements
mermaid_correlation = '''```mermaid
flowchart LR
    C[Campaign] --> O[Orders]
    O --> S[Shipments]
    S --> E[Execution]
    E --> EX[Exports]

    C -.-> |corr_xxx| O
    O -.-> |corr_xxx| S
    S -.-> |corr_xxx| E
    E -.-> |corr_xxx| EX
```'''

mermaid_permission = '''```mermaid
flowchart TD
    P01[Platform Admin P01]
    P02[PSP Admin P02]
    P03[Production Operator P03]
    P04[Brand Admin P04]
    P05[Campaign Manager P05]
    P06[Regional Manager P06]
    P07[Store Manager P07]
    P08[Store Operator P08]
    P09[Integration User P09]

    P01 --> P02
    P02 --> P03
    P02 --> P04
    P04 --> P05
    P04 --> P06
    P06 --> P07
    P07 --> P08

    P09 -.- |API-scoped| P01
```'''

mermaid_auth_flow = '''```mermaid
flowchart LR
    UR[User Request] --> L001[L001 Login]
    L001 --> AS[Auth Service]
    AS --> SSO[SSO Provider]
    L001 --> MFA[MFA Challenge]
    MFA --> SC[Session Created]
    SC --> L002[L002 Dashboard]
```'''

# Simple text description for wireframe (too complex for Mermaid)
wireframe_description = '''```
Dashboard Layout Wireframe

┌─────────────────────────────────────────────────────────────────┐
│  [≡] Logo        Dashboard Title        [🔔] [👤] User [⚙]     │
├─────────┬───────────────────────────────────────────────────────┤
│         │  Welcome, {User}          {Date/Time}                 │
│  NAV    │  Role: {Role} | Store: {Context}    [Switch ▾]        │
│  BAR    ├───────────────────────────────────────────────────────┤
│         │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐      │
│ [🏠]    │  │ KPI 1   │ │ KPI 2   │ │ KPI 3   │ │ KPI 4   │      │
│ Home    │  └─────────┘ └─────────┘ └─────────┘ └─────────┘      │
│         │  ┌─────────────────┐ ┌─────────────────┐              │
│ [📦]    │  │ Chart Widget    │ │ List Widget     │              │
│ Orders  │  └─────────────────┘ └─────────────────┘              │
│         │  ┌─────────────────┐ ┌─────────────────┐              │
│ [📊]    │  │ Quick Actions   │ │ Alerts          │              │
│ Reports │  └─────────────────┘ └─────────────────┘              │
│ [⚙️]    │                                                        │
│ Settings│                                                        │
└─────────┴───────────────────────────────────────────────────────┘
```'''

def find_and_replace(lines, search_text, replacement, diagram_name):
    """Find code block containing search_text and replace with mermaid."""
    for i, line in enumerate(lines):
        if search_text in line:
            # Find opening ```
            start = None
            for j in range(i, max(0, i-15), -1):
                if lines[j].strip() == '```':
                    start = j
                    break
            # Find closing ```
            end = None
            for j in range(i, min(len(lines), i+50)):
                if lines[j].strip() == '```' and j > i:
                    end = j
                    break

            if start is not None and end is not None:
                print(f"{diagram_name}: Found at lines {start+1}-{end+1}")
                return lines[:start] + [replacement] + lines[end+1:]
            else:
                print(f"WARNING: Could not find boundaries for {diagram_name}")
                return lines

    print(f"WARNING: Could not find {diagram_name}")
    return lines

# Convert diagrams
lines = find_and_replace(lines, 'corr_xxx', mermaid_correlation, 'Correlation Flow')
lines = find_and_replace(lines, 'Platform Admin (P01)', mermaid_permission, 'Permission Hierarchy')
lines = find_and_replace(lines, 'L001 Login', mermaid_auth_flow, 'Auth Flow')
lines = find_and_replace(lines, 'NewPOPSys Logo', wireframe_description, 'Dashboard Wireframe')

# Write back
with open(file_path, 'w', encoding='utf-8', errors='surrogateescape') as f:
    f.write('\n'.join(lines))

print(f"\nDone! New line count: {len(lines)}")
