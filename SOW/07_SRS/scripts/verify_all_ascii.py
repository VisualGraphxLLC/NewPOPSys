import os
import re

ROOT = r"E:\Docker\PopSystem\SOW\07_SRS"

# ASCII Markers:
# 1. Fenced blocks containing box-drawing chars or +---+ style
# 2. Exclude mermaid, json, sql blocks
# 3. Exclude markdown tables (lines starting with | but without +--+)

def is_ascii_art(block_content):
    # Check for Box Drawing Characters
    if re.search(r'[┌┐└┘├┤┬┴┼═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬]', block_content):
        return True
    
    # Check for standard ASCII boxes (+---+)
    # Must have at least one line starting with + or containing +---+
    lines = block_content.split('\n')
    for line in lines:
        if re.search(r'\+[-=]{3,}\+', line):
            return True
        if re.search(r'\|.*\|', line):
            # Potential table or box side
            # If it's a markdown table, it usually looks like | col | col |
            # ASCII art often has |   | (spaces)
            pass
            
    # Heuristic: Detect "v" or "^" arrows in blocks not marked as mermaid
    if re.search(r'\s+v\s+', block_content) or re.search(r'\s+\^\s+', block_content):
        # Arrows often indicate ASCII flow
        # But could be text.
        # Check for lines connecting arrows like "  |  "
        if re.search(r'\s+\|\s+', block_content):
             return True

    return False

def check_file(path):
    issues = []
    try:
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
    except:
        return []

    # Find all code blocks
    # Capture language tag
    blocks = re.finditer(r'```(\w*)\n(.*?)```', content, re.DOTALL)
    
    for m in blocks:
        lang = m.group(1).lower().strip()
        code = m.group(2)
        
        # Valid languages to skip
        if lang in ['mermaid', 'json', 'sql', 'yaml', 'xml', 'html', 'css', 'javascript', 'typescript', 'python', 'bash', 'sh']:
            continue
            
        # If no lang or 'text' or 'ascii'
        if is_ascii_art(code):
            # Check if it's a markdown table?
            # Markdown tables don't usually live in fences, but sometimes correctors put them there.
            # If it has +---+ it is DEFINITELY ASCII art (Markdown tables use |---|).
            if re.search(r'\+[-=]{3,}\+', code):
                 issues.append(f"Ascii Box in ```{lang}")
            elif re.search(r'[┌┐└┘]', code):
                 issues.append(f"Unicode Box in ```{lang}")
            elif "-->" in code and lang == "":
                 # ASCII Arrow flow?
                 issues.append(f"Ascii Flow in ```{lang}")
    
    return issues

def main():
    detected = {}
    for root, dirs, files in os.walk(ROOT):
        if "scripts" in root or ".git" in root or "node_modules" in root:
            continue
            
        for name in files:
            if name.endswith(".md"):
                path = os.path.join(root, name)
                results = check_file(path)
                if results:
                    rel = os.path.relpath(path, ROOT)
                    detected[rel] = results

    if detected:
        print("FOUND ASCII ARTIFACTS:")
        for f, errs in detected.items():
            print(f"{f}: {len(errs)} artifacts")
            for e in errs:
                print(f"  - {e}")
    else:
        print("NO ASCII ARTIFACTS FOUND.")

if __name__ == "__main__":
    main()
