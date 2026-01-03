#!/usr/bin/env python3
"""Safe ASCII to Mermaid conversion using line numbers."""

file_path = r"E:\Docker\PopSystem\SOW\07_SRS\SRS_OUTPUT.md"

# Read file with surrogateescape to preserve all bytes
with open(file_path, 'r', encoding='utf-8', errors='surrogateescape') as f:
    lines = f.readlines()

print(f"Read {len(lines)} lines")

# The ASCII diagram is at lines 671-681 (1-indexed), so 670-680 (0-indexed)
start_line = 670  # line 671 (opening ```)
end_line = 680    # line 681 (closing ```)

# Verify we're targeting the right section
if "CAMPAIGN ORCHESTRATION LAYER" in lines[672]:
    print("Found target section at expected location")
else:
    print("WARNING: Target section not at expected location, searching...")
    for i, line in enumerate(lines):
        if "CAMPAIGN ORCHESTRATION LAYER" in line:
            print(f"Found at line {i+1}")
            # Adjust to find the opening ```
            for j in range(i, max(0, i-10), -1):
                if lines[j].strip() == '```':
                    start_line = j
                    break
            # Find closing ```
            for j in range(i, min(len(lines), i+20)):
                if lines[j].strip() == '```' and j > i:
                    end_line = j
                    break
            break

mermaid_replacement = '''```mermaid
flowchart LR
    subgraph Orchestration["CAMPAIGN ORCHESTRATION LAYER<br/>(NewPOPSys v1.38)"]
        direction LR
        PSP[PSP Tenant] --> Brand[Brand Clients]
        Brand --> Store[Store Locations]
        Store --> Exec[Execution]
    end
    PSP -.-> PF[Production<br/>Fulfillment]
    Brand -.-> CC[Campaign<br/>Configuration]
    Store -.-> DT[Delivery<br/>Tracking]
    Exec -.-> IV[Installation<br/>Verification]
```
'''

# Replace lines
new_lines = lines[:start_line] + [mermaid_replacement] + lines[end_line+1:]

print(f"Replacing lines {start_line+1}-{end_line+1} with Mermaid diagram")
print(f"New line count: {len(new_lines)}")

# Write back with same encoding handling
with open(file_path, 'w', encoding='utf-8', errors='surrogateescape') as f:
    f.writelines(new_lines)

print("Done!")
