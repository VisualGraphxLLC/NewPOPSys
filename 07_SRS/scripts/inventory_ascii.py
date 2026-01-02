import os
import re

def find_ascii_wireframes(root_dir):
    ascii_list = []
    
    for root, dirs, files in os.walk(root_dir):
        if 'screens' in root:
            for file in files:
                if file.endswith('.md'):
                    path = os.path.join(root, file)
                    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        # Look for code blocks starting with +--- or containing | | boxes
                        if '```' in content:
                            # Find all code blocks
                            blocks = re.findall(r'```(?:[\w]*)\n([\s\S]*?)```', content)
                            for block in blocks:
                                if '+--' in block or '|' in block and '-' in block and len(block) > 50:
                                    # Very likely an ASCII wireframe
                                    screen_id = file.split('_')[0]
                                    ascii_list.append({
                                        'file': path,
                                        'screen_id': screen_id,
                                        'description': file.replace('.md', '').replace('_', ' ')
                                    })
                                    break # Only need to know if the file has at least one
    return ascii_list

if __name__ == "__main__":
    srs_root = r"E:\Docker\PopSystem\SOW\07_SRS"
    results = find_ascii_wireframes(srs_root)
    
    print("# ASCII Wireframe Inventory")
    print("\nThe following screens contain ASCII wireframes that need to be replaced with true wireframe images.\n")
    print("| Screen ID | Screen Name | File Path |")
    print("|-----------|-------------|-----------|")
    for res in results:
        rel_path = os.path.relpath(res['file'], srs_root)
        print(f"| {res['screen_id']} | {res['description']} | {rel_path} |")
