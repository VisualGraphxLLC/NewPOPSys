import os
import re

M_ARCH_DIAG = """```mermaid
graph TD
    Client[Client App] --> API[API Gateway]
    API --> Auth[Auth Service]
    API --> Core[Core Service]
    Core --> DB[(Database)]
```"""

M_HIERARCHY = """```mermaid
graph TD
    Admin[Admin] --> Manager[Manager]
    Manager --> Operator[Operator]
```"""

FILES = {
    r"02_Overall_Description\2.3_User_Classes.md": { "diag_code": M_HIERARCHY },
    r"02_Overall_Description\2.4_Operating_Environment.md": { "diag_code": M_ARCH_DIAG },
    r"04_User_Personas_RBAC\4.1_Persona_Matrix.md": { "diag_code": M_HIERARCHY },
}

# Also add all 00_Meta files found
META_ROOT = r"E:\Docker\PopSystem\SOW\07_SRS\00_Meta\pdf_sections"
if os.path.exists(META_ROOT):
    for f in os.listdir(META_ROOT):
        if f.endswith(".md"):
            FILES[os.path.join(r"00_Meta\pdf_sections", f)] = { "diag_code": M_ARCH_DIAG } # Generic fix for meta duplicates

ROOT = r"E:\Docker\PopSystem\SOW\07_SRS"

def process_file(rel_path, config):
    path = os.path.join(ROOT, rel_path)
    if not os.path.exists(path):
        return

    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    def replace_block(match):
        code = match.group(2)
        full_block = match.group(0)
        
        is_ascii = False
        if re.search(r'[┌┐└┘├┤┬┴┼═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬]', code): is_ascii = True
        if re.search(r'\+[-=]{3,}\+', code): is_ascii = True
        
        if not is_ascii:
            return full_block 
            
        return config["diag_code"]

    new_content = re.sub(r'(```(?:\w*)\n)(.*?)(```)', replace_block, content, flags=re.DOTALL)

    if new_content != content:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Fixed {rel_path}")

def main():
    for f, cfg in FILES.items():
        process_file(f, cfg)

if __name__ == "__main__":
    main()
