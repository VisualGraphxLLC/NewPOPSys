import os
import re

files = [
    r"08_Module_PSPOperations\screens\P002_Shipments.md",
    r"08_Module_PSPOperations\screens\P003_Issues.md",
    r"09_Module_StorePortal\screens\S001_Dashboard.md",
    r"09_Module_StorePortal\screens\S002_Campaign_History.md"
]

root = r"E:\Docker\PopSystem\SOW\07_SRS"

for f in files:
    path = os.path.join(root, f)
    print(f"\n--- {f} ---")
    try:
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            # Find Pattern of diagrams
            blocks = re.findall(r'(### \d+\.\d+ .*?Machine\s*\n\s*)```(.*?)```', content, re.DOTALL)
            for title, code in blocks:
                print(f"DIAGRAM: {title.strip()}")
                print(code[:100] + "...") # First 100 chars to identify
    except Exception as e:
        print(f"Error: {e}")
