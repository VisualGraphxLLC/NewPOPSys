import os
import re

FILE_PATH = r"E:\Docker\PopSystem\SOW\07_SRS\03_System_Architecture\3.1_Database_Model.md"

# 1. Tenant Hierarchy
M_TENANT = """```mermaid
graph TD
    Tenants[Tenants (PSP Root)] --> Brands[Brands (Customer Brands)]
    Brands --> Campaigns[Campaigns]
    Brands --> Stores[Stores]
    Brands --> Users[Users (via Memberships)]
```"""

# 2. Campaign Flow
M_CAMPAIGN = """```mermaid
graph LR
    Tenants --> Brands --> Campaigns --> Assignments[Store Assignments]
    Assignments --> Orders[Orders]
    Assignments --> Photos[Photos]
    Assignments --> Issues[Issues]
```"""

# 3. Store Hierarchy
M_STORE = """```mermaid
graph TD
    Brands --> Regions
    Regions --> Stores
    Stores --> Layouts --> Slots
    Regions --> Districts
    Districts --> Territories
```"""

# 4. Photo Flow
M_PHOTO = """```mermaid
graph LR
    Assignments[Store Assignments] --> Uploads[Photo Uploads]
    Uploads --> Reviews[Photo Reviews]
    Reviews --> Retakes[Retake Requests]
```"""

# 5. Issue Flow
M_ISSUE = """```mermaid
graph LR
    Assignments[Store Assignments] --> Issues[Issue Requests]
    Issues --> Reorders
    Reorders --> Orders[Store Orders]
```"""

def remediate():
    if not os.path.exists(FILE_PATH):
        print("File not found.")
        return

    with open(FILE_PATH, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replacements based on context headers
    
    # 3.1.3.1 - Tenant Hierarchy
    # Find block after "### 3.1.3.1"
    content = re.sub(
        r'(### 3.1.3.1.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_TENANT}", 
        content, 
        count=1,
        flags=re.DOTALL
    )

    # 3.1.6.1 - Campaign Flow
    content = re.sub(
        r'(### 3.1.6.1.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_CAMPAIGN}", 
        content, 
        count=1, 
        flags=re.DOTALL
    )

    # 3.1.6.2 - Store Hierarchy
    content = re.sub(
        r'(### 3.1.6.2.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_STORE}", 
        content, 
        count=1, 
        flags=re.DOTALL
    )

    # 3.1.6.3 - Photo Flow
    content = re.sub(
        r'(### 3.1.6.3.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_PHOTO}", 
        content, 
        count=1, 
        flags=re.DOTALL
    )

    # 3.1.6.4 - Issue Flow
    content = re.sub(
        r'(### 3.1.6.4.*?\n\s*)```(?:.|[\r\n])*?```', 
        f"\\1{M_ISSUE}", 
        content, 
        count=1, 
        flags=re.DOTALL
    )

    with open(FILE_PATH, 'w', encoding='utf-8') as f:
        f.write(content)
    print("Fixed 3.1_Database_Model.md")

if __name__ == "__main__":
    remediate()
