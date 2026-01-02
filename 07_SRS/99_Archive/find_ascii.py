#!/usr/bin/env python3
"""Find all remaining ASCII diagrams that need conversion."""

with open(r"E:\Docker\PopSystem\SOW\07_SRS\SRS_OUTPUT.md", 'r', encoding='utf-8', errors='surrogateescape') as f:
    lines = f.readlines()

# Find code blocks with potential ASCII art
in_code_block = False
block_start = 0
suspicious_blocks = []

for i, line in enumerate(lines):
    stripped = line.strip()

    if stripped.startswith('```') and not stripped.startswith('```mermaid'):
        if not in_code_block:
            in_code_block = True
            block_start = i
        else:
            in_code_block = False
            # Check if block has non-ASCII or arrow patterns
            block_content = ''.join(lines[block_start:i+1])
            if any(ord(c) > 127 for c in block_content) or '→' in block_content or '─' in block_content or '│' in block_content:
                suspicious_blocks.append((block_start+1, i+1, block_content[:200]))
            # Also check for simple text diagrams with arrows
            elif '-->' in block_content or '<--' in block_content or '->' in block_content:
                suspicious_blocks.append((block_start+1, i+1, block_content[:200]))

print(f"Found {len(suspicious_blocks)} suspicious code blocks:")
for start, end, preview in suspicious_blocks:
    print(f"\n=== Lines {start}-{end} ===")
    print(preview.replace('\n', '\\n')[:150])
