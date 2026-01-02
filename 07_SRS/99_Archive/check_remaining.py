#!/usr/bin/env python3
"""Check for remaining ASCII diagrams with corrupted box characters."""

with open(r'E:\Docker\PopSystem\SOW\07_SRS\SRS_OUTPUT.md', 'r', encoding='utf-8', errors='surrogateescape') as f:
    lines = f.readlines()

in_block = False
block_start = 0
found = []

for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped.startswith('```') and not stripped.startswith('```mermaid'):
        if not in_block:
            in_block = True
            block_start = i
        else:
            in_block = False
            block = ''.join(lines[block_start:i+1])
            # Check for non-ASCII characters (corrupted box-drawing chars)
            has_non_ascii = any(ord(c) > 127 for c in block)
            # Also check for arrow patterns that suggest diagrams
            has_arrows = any(p in block for p in ['-->', '<--', '->', '<-'])
            if has_non_ascii or has_arrows:
                preview = block[:150].replace('\n', ' ')
                found.append((block_start+1, i+1, preview))

print(f"Found {len(found)} code blocks with non-ASCII or arrow patterns:")
for start, end, preview in found:
    print(f"\nLines {start}-{end}:")
    print(f"  {preview[:100]}...")
