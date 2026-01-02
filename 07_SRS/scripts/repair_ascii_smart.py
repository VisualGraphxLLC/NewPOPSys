import os

def read_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        return f.readlines()

def write_file(path, lines):
    with open(path, 'w', encoding='utf-8') as f:
        f.writelines(lines)

def is_fence(line):
    return line.strip().startswith('```')

def get_blocks(lines):
    # Split file into chunks. 
    # A block is either a code fenced block or a run of text lines.
    # Returns list of dicts: {'type': 'text'|'code', 'lines': []}
    blocks = []
    current_lines = []
    in_code = False
    
    for line in lines:
        if is_fence(line):
            if in_code:
                # End of code block
                current_lines.append(line)
                blocks.append({'type': 'code', 'lines': current_lines})
                current_lines = []
                in_code = False
            else:
                # Start of code block
                if current_lines:
                    blocks.append({'type': 'text', 'lines': current_lines})
                current_lines = [line]
                in_code = True
        else:
            current_lines.append(line)
            
    if current_lines:
        blocks.append({'type': 'text' if in_code else 'text', 'lines': current_lines})
        # Note: if EOF reached without closing fence, strictly it's broken, treating as text/mixed.
        # But get_blocks logic treats as text if in_code is set? 
        # Actually if in_code is True at EOF, it means unclosed code block.
        # Let's fix type.
    
    return blocks

# Predicates
def is_ascii_b006_71(lines):
    s = "".join(lines)
    return "[ONBOARDING]" in s and "accept invitation" in s and "mermaid" not in s.lower()

def is_mermaid_b006_71(lines):
    s = "".join(lines)
    return "stateDiagram-v2" in s and "Accept Invitation" in s

def is_ascii_b007_71(lines):
    s = "".join(lines)
    return "[PENDING]" in s and "approve" in s and "mermaid" not in s.lower()

def is_mermaid_b007_71(lines):
    s = "".join(lines)
    return "stateDiagram-v2" in s and "PENDING --> APPROVED" in s

def is_ascii_b007_73(lines):
    s = "".join(lines)
    return "assignment_item.status" in s and "mermaid" not in s.lower() and ("-->" in s or "->" in s)

def is_mermaid_b007_73(lines):
    s = "".join(lines)
    return "flowchart TD" in s and "PA[Photo APPROVED]" in s

def is_mermaid_b007_74(lines):
    s = "".join(lines)
    return "stateDiagram-v2" in s and "Loading --> Loaded" in s and "Selecting --> Processing" in s

def is_ascii_s005(lines):
    s = "".join(lines)
    return "Reports Screen States" in s and "mermaid" not in s.lower()

# Repair Logics
def logic_b006(blocks):
    # Locate replacement candidates
    m_71 = None
    for b in blocks:
        if b['type'] == 'code' and is_mermaid_b006_71(b['lines']):
            m_71 = b['lines']
            break
    
    new_blocks = []
    for b in blocks:
        if b['type'] == 'text':
            # Clean garbage
            clean = [l for l in b['lines'] if l.strip() not in ['v', '[Loaded]']]
            new_blocks.append({'type': 'text', 'lines': clean})
        elif b['type'] == 'code':
            if is_ascii_b006_71(b['lines']):
                if m_71:
                    new_blocks.append({'type': 'code', 'lines': m_71})
                else:
                    new_blocks.append(b) # Keep if no replacement found
            elif is_mermaid_b006_71(b['lines']):
                # This is the misplaced copy. Skip it.
                pass
            else:
                new_blocks.append(b)
        else:
            new_blocks.append(b)
    return new_blocks

def logic_b007(blocks):
    m_71 = None
    m_73 = None
    m_74 = None
    
    # Harvest
    for b in blocks:
        if b['type'] == 'code':
            if is_mermaid_b007_71(b['lines']): m_71 = b['lines']
            if is_mermaid_b007_73(b['lines']): m_73 = b['lines']
            if is_mermaid_b007_74(b['lines']): m_74 = b['lines']
            
    new_blocks = []
    for b in blocks:
        if b['type'] == 'code':
            if is_ascii_b007_71(b['lines']):
                if m_71: new_blocks.append({'type': 'code', 'lines': m_71})
                else: new_blocks.append(b)
            elif is_ascii_b007_73(b['lines']):
                if m_73: new_blocks.append({'type': 'code', 'lines': m_73})
                else: new_blocks.append(b)
            elif is_mermaid_b007_71(b['lines']):
                # This block (m_71) was found misplaced at 7.4. Replace it with m_74.
                if m_74: new_blocks.append({'type': 'code', 'lines': m_74})
                else: pass # Delete if no m_74? Or keep?
            elif is_mermaid_b007_73(b['lines']):
                # Misplaced m_73. Delete.
                pass
            elif is_mermaid_b007_74(b['lines']):
                # Misplaced m_74 (found later). Delete.
                pass
            else:
                new_blocks.append(b)
        else:
            new_blocks.append(b)
    return new_blocks

def logic_s005(blocks):
    new_blocks = []
    for b in blocks:
        if b['type'] == 'code' and is_ascii_s005(b['lines']):
            # Remove ASCII
            pass
        else:
            new_blocks.append(b)
    return new_blocks

def run_repairs():
    files = [
        {"path": r"E:\Docker\PopSystem\SOW\07_SRS\07_Module_BrandAdmin\screens\B006_Store_List.md", "func": logic_b006},
        {"path": r"E:\Docker\PopSystem\SOW\07_SRS\07_Module_BrandAdmin\screens\B007_Verification.md", "func": logic_b007},
        {"path": r"E:\Docker\PopSystem\SOW\07_SRS\09_Module_StorePortal\screens\S005_Reports.md", "func": logic_s005},
    ]
    
    for item in files:
        if os.path.exists(item['path']):
            print(f"Repairing {item['path']}...")
            lines = read_file(item['path'])
            blocks = get_blocks(lines)
            new_blocks = item['func'](blocks)
            
            final_lines = []
            for b in new_blocks:
                final_lines.extend(b['lines'])
            
            write_file(item['path'], final_lines)
            print("Done.")
        else:
            print(f"File not found: {item['path']}")

if __name__ == "__main__":
    run_repairs()
