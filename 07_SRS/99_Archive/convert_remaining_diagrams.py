#!/usr/bin/env python3
"""Convert remaining ASCII diagrams to Mermaid format."""

file_path = r"E:\Docker\PopSystem\SOW\07_SRS\SRS_OUTPUT.md"

with open(file_path, 'r', encoding='utf-8', errors='surrogateescape') as f:
    content = f.read()
    lines = content.split('\n')

print(f"Read {len(lines)} lines")

# Mermaid replacements
mermaid_lifecycle = '''```mermaid
flowchart LR
    C[Campaign] --> SA[Store Assignment]
    SA --> PF[PSP Fulfillment]
    PF --> SE[Store Execution]
    SE --> V[Verification]
    V --> VIS[Visibility]
```'''

mermaid_hierarchy = '''```mermaid
flowchart TD
    subgraph Platform["Platform Level (System-wide)"]
        PA[Platform Admin]
    end

    subgraph PSP["PSP Level (Tenant-wide)"]
        PSPA[PSP Admin]
        PO[Production Operator]
    end

    subgraph Brand["Brand Level (Brand-scoped)"]
        BA[Brand Admin]
        CM[Campaign Manager]
        RM[Regional Manager]
    end

    subgraph Store["Store Level (Store-scoped)"]
        SM[Store Manager]
        SO[Store Operator]
    end

    subgraph System["System Level (Machine-to-Machine)"]
        IU[Integration User]
    end

    Platform --> PSP
    PSP --> Brand
    Brand --> Store
    Store --> System
```'''

mermaid_aws = '''```mermaid
flowchart LR
    subgraph AWS["AWS Cloud"]
        CF[CloudFront<br/>CDN] --> ALB[ALB<br/>Load Balancer]
        ALB --> ECS[ECS Fargate<br/>Compute]
        ECS --> RDS[(RDS PostgreSQL<br/>Database)]

        CF --> S3[(S3<br/>Storage)]
        ECS --> EC[ElastiCache<br/>Redis]
        ECS --> SES[SES<br/>Email]
    end
```'''

def find_and_replace(lines, search_text, mermaid_replacement, diagram_name):
    """Find code block containing search_text and replace with mermaid."""
    for i, line in enumerate(lines):
        if search_text in line:
            # Find opening ```
            start = None
            for j in range(i, max(0, i-10), -1):
                if lines[j].strip() == '```':
                    start = j
                    break
            # Find closing ```
            end = None
            for j in range(i, min(len(lines), i+30)):
                if lines[j].strip() == '```' and j > i:
                    end = j
                    break

            if start is not None and end is not None:
                print(f"{diagram_name}: Found at lines {start+1}-{end+1}")
                return lines[:start] + [mermaid_replacement] + lines[end+1:]
            else:
                print(f"WARNING: Could not find boundaries for {diagram_name}")

    print(f"WARNING: Could not find {diagram_name}")
    return lines

# Convert diagram 1: Campaign Lifecycle Flow (search for the arrow pattern)
lines = find_and_replace(lines, 'Store Assignment', mermaid_lifecycle, 'Campaign Lifecycle Flow')

# Convert diagram 2: User Class Hierarchy (search for Platform Level)
lines = find_and_replace(lines, 'Platform Level (System-wide)', mermaid_hierarchy, 'User Class Hierarchy')

# Convert diagram 3: AWS Infrastructure (search for CloudFront)
lines = find_and_replace(lines, 'CloudFront', mermaid_aws, 'AWS Infrastructure')

# Write back
with open(file_path, 'w', encoding='utf-8', errors='surrogateescape') as f:
    f.write('\n'.join(lines))

print(f"\nDone! New line count: {len(lines)}")
