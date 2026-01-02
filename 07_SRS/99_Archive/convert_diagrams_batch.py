#!/usr/bin/env python3
"""Batch convert remaining ASCII diagrams to Mermaid."""

file_path = r"E:\Docker\PopSystem\SOW\07_SRS\SRS_OUTPUT.md"

with open(file_path, 'r', encoding='utf-8', errors='surrogateescape') as f:
    content = f.read()
    lines = content.split('\n')

print(f"Read {len(lines)} lines")

# Diagram 2: Multi-Tenant Architecture (lines 733-744)
mermaid_tenant = '''```mermaid
flowchart TD
    PSP[PSP Tenant - Root]
    PSP --> BrandA[Brand A]
    PSP --> BrandB[Brand B]
    PSP --> PSPUsers[PSP Users<br/>PSP Admin, Production Operator,<br/>Platform Admin]

    BrandA --> StoresA[Stores<br/>up to 1,000]
    BrandA --> CampaignsA[Campaigns]
    BrandA --> UsersA[Users<br/>Brand Admin, Campaign Manager,<br/>Regional Manager]

    BrandB --> StoresB[Stores]
    BrandB --> CampaignsB[Campaigns]
    BrandB --> UsersB[Users]
```'''

# Diagram 3: Campaign Lifecycle Flow (lines 764-766)
mermaid_lifecycle = '''```mermaid
flowchart LR
    C[Campaign] --> SA[Store Assignment]
    SA --> PF[PSP Fulfillment]
    PF --> SE[Store Execution]
    SE --> V[Verification]
    V --> VIS[Visibility]
```'''

# Replace diagram 2 (Multi-Tenant Architecture at lines 733-744)
# Find exact position by looking for "PSP Tenant (Root)"
start2 = None
end2 = None
for i, line in enumerate(lines):
    if 'PSP Tenant (Root)' in line:
        # Find opening ```
        for j in range(i, max(0, i-5), -1):
            if lines[j].strip() == '```':
                start2 = j
                break
        # Find closing ```
        for j in range(i, min(len(lines), i+20)):
            if lines[j].strip() == '```' and j > i:
                end2 = j
                break
        break

if start2 is not None and end2 is not None:
    print(f"Diagram 2 found at lines {start2+1}-{end2+1}")
    lines = lines[:start2] + [mermaid_tenant] + lines[end2+1:]
    print("Replaced Multi-Tenant Architecture diagram")
else:
    print("WARNING: Could not find Multi-Tenant Architecture diagram")

# Recalculate - find diagram 3 (Campaign lifecycle)
start3 = None
end3 = None
for i, line in enumerate(lines):
    if 'Campaign' in line and 'Store Assignment' in line and 'Fulfillment' in line:
        # Find opening ```
        for j in range(i, max(0, i-5), -1):
            if lines[j].strip() == '```':
                start3 = j
                break
        # Find closing ```
        for j in range(i, min(len(lines), i+5)):
            if lines[j].strip() == '```' and j > i:
                end3 = j
                break
        break

if start3 is not None and end3 is not None:
    print(f"Diagram 3 found at lines {start3+1}-{end3+1}")
    lines = lines[:start3] + [mermaid_lifecycle] + lines[end3+1:]
    print("Replaced Campaign Lifecycle diagram")
else:
    print("WARNING: Could not find Campaign Lifecycle diagram")

# Write back
with open(file_path, 'w', encoding='utf-8', errors='surrogateescape') as f:
    f.write('\n'.join(lines))

print(f"Done! New line count: {len(lines)}")
