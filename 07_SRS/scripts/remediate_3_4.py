import os
import re

FILE_PATH = r"E:\Docker\PopSystem\SOW\07_SRS\03_System_Architecture\3.4_Integration_Architecture.md"

M_CORRELATION = """```mermaid
graph LR
    C[Campaign] --> O[Orders] --> S[Shipments] --> E[Execution] --> X[Exports]
    C -.-> ID1[corr_xxx]
    O -.-> ID2[corr_xxx]
    S -.-> ID3[corr_xxx]
    E -.-> ID4[corr_xxx]
    X -.-> ID5[corr_xxx]
```"""

def remediate():
    if not os.path.exists(FILE_PATH):
        print("File not found.")
        return

    with open(FILE_PATH, 'r', encoding='utf-8') as f:
        content = f.read()

    # 3.4.11 Correlation
    # Content block: ```\nCampaign -> ... \n ... \n```
    # We will search for the specific content pattern
    
    pattern = r'Campaign .*? Orders .*? Shipments .*? Execution .*? Exports.*?\n.*?(?:corr_xxx).*?\n'
    
    # It's inside a code block ```...```
    # Regex to find the whole block containing "Campaign -> Orders"
    
    block_pattern = r'```\nCampaign .*?Exports\n.*?```'
    
    match = re.search(block_pattern, content, re.DOTALL)
    if match:
        content = content.replace(match.group(0), M_CORRELATION)
        print("Fixed Correlation Diagram in 3.4")
    else:
        print("Correlation Diagram Pattern not found in 3.4")

    with open(FILE_PATH, 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == "__main__":
    remediate()
