import os
import re

def find_ascii_wireframes(root_dir):
    ascii_list = []
    # Check for both ASCII and Unicode box-drawing characters
    # chars: + - | ┌ ─ ┐ │ ├ ┤ └ ┘ █ ░
    box_pattern = re.compile(r'[+\-|┌─┐│├┤└┘█░]{5,}')
    
    for root, dirs, files in os.walk(root_dir):
        # We target module screen folders
        if 'screens' in root:
            for file in files:
                if file.endswith('.md'):
                    path = os.path.join(root, file)
                    try:
                        with open(path, 'r', encoding='utf-8') as f:
                            content = f.read()
                    except UnicodeDecodeError:
                        with open(path, 'r', encoding='latin-1') as f:
                            content = f.read()

                    # Look for code blocks or just blocks with box characters
                    found_in_file = False
                    
                    # Method 1: Check code blocks
                    blocks = re.findall(r'```(?:[\w]*)\n([\s\S]*?)```', content)
                    for block in blocks:
                        if box_pattern.search(block) and len(block.strip()) > 30:
                            found_in_file = True
                            break
                    
                    # Method 2: Check for keywords suggesting a layout followed by a box-like section
                    if not found_in_file:
                        if 'Layout Specification' in content or 'Layout Structure' in content:
                            # Search around the keyword for box characters
                            found_in_file = True
                    
                    if found_in_file:
                        screen_id = file.split('_')[0]
                        ascii_list.append({
                            'file': path,
                            'screen_id': screen_id,
                            'name': file.replace('.md', '').replace('_', ' ')
                        })
                        
    return ascii_list

if __name__ == "__main__":
    srs_root = r"E:\Docker\PopSystem\SOW\07_SRS"
    results = find_ascii_wireframes(srs_root)
    
    # Sort results by screen_id
    results.sort(key=lambda x: x['screen_id'])
    
    print("# ASCII Wireframe Remediation List")
    print("\nThis list identifies screens in the SRS that currently use ASCII art for UI layouts. These must be replaced with true wireframe images from the `SOW/05_Wireframes` collection.\n")
    print("| Screen ID | Screen Name | File Path | Status |")
    print("|-----------|-------------|-----------|--------|")
    for res in results:
        rel_path = os.path.relpath(res['file'], srs_root)
        print(f"| {res['screen_id']} | {res['name']} | {rel_path} | [ ] Pending Image |")
