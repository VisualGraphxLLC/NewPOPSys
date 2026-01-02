import os
import re

# --- Mermaid Diagrams ---

M_L001_LOGIN = """```mermaid
stateDiagram-v2
    [*] --> FormDisplayed
    FormDisplayed --> ValidatingCredentials: submit
    ValidatingCredentials --> Authenticated: valid
    ValidatingCredentials --> ErrorDisplayed: invalid
    ErrorDisplayed --> FormDisplayed: retry
    Authenticated --> [*]
```"""

M_L002_DASH = """```mermaid
stateDiagram-v2
    [*] --> Loading
    Loading --> Ready: success
    Loading --> Partial: verification failed
    Ready --> Refreshing: action
    Refreshing --> Ready: done
```"""

M_APP_AUTH = """```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Validating: credentials entered
    Validating --> Authenticating: local validation
    Authenticating --> Authenticated: success
    Authenticating --> Error: fail
    Authenticated --> [*]
```"""

M_ORDER_STATUS = """```mermaid
stateDiagram-v2
    GENERATED --> ACKNOWLEDGED: acknowledge
    ACKNOWLEDGED --> IN_PRODUCTION: start_production
    IN_PRODUCTION --> KITTING: complete_kitting
    KITTING --> READY_TO_SHIP: ready
    READY_TO_SHIP --> SHIPPED: ship
    SHIPPED --> DELIVERED: deliver
    SHIPPED --> CLOSED: close
```"""

M_ISSUE_STATUS = """```mermaid
stateDiagram-v2
    OPEN --> TRIAGE: assign
    TRIAGE --> RESOLVED: fix
    TRIAGE --> REJECTED: invalid
    RESOLVED --> CLOSED: verify
```"""

M_GENERIC_FLOW = """```mermaid
stateDiagram-v2
    [*] --> Step1
    Step1 --> Step2: action
    Step2 --> Step3: action
    Step3 --> [*]
    Step3 --> Error
    Error --> Step1: retry
```"""

M_TASK_NAV = """```mermaid
stateDiagram-v2
    TaskList --> DetermineType: tap_card
    DetermineType --> Receipt: type=RECEIPT
    DetermineType --> Install: type=INSTALL
    DetermineType --> Retake: type=RETAKE
    DetermineType --> Issue: type=ISSUE
    Receipt --> TaskList: return
    Install --> TaskList: return
    Retake --> TaskList: return
    Issue --> TaskList: return
```"""

# --- File Maps ---

FILES = {
    # Shared
    r"05_Module_SharedFoundations\screens\L001_Universal_Login.md": {
        "layout_img": "![Universal Login Screen](../../screenshots/Mobile_App/mobile_app.png)",
        "diag_map": {"7.1 Login State Machine": M_L001_LOGIN}
    },
    r"05_Module_SharedFoundations\screens\L002_Universal_Dashboard.md": {
        "layout_img": "![Universal Dashboard](../../screenshots/Admin_Portal/admin_portal_dashboard.png)",
        "diag_map": {"7.1 Dashboard State Machine": M_L002_DASH}
    },
    # Mobile
    r"06_Module_StoreExecution\screens\M001_Login.md": {
        "layout_img": "![Mobile Login](../../screenshots/Store_Execution/mobile_dashboard.png)",
        "diag_map": {"7.1 Authentication State Machine": M_APP_AUTH}
    },
    r"06_Module_StoreExecution\screens\M002_Dashboard.md": {
        "layout_img": "![Mobile Dashboard](../../screenshots/Store_Execution/mobile_dashboard.png)",
        "diag_map": {"7.1": M_GENERIC_FLOW} # Generic
    },
    r"06_Module_StoreExecution\screens\M006_Task_Navigation.md": {
        "layout_img": "![Task Navigation](../../screenshots/Store_Execution/mobile_tasks_receive.png)",
        "diag_map": {
            "7.1 Task Navigation State Machine": M_TASK_NAV,
            "7.2 Attestation Submission State Machine": M_GENERIC_FLOW
        }
    },
    # PSP
    r"08_Module_PSPOperations\screens\P001_Order_Queue.md": {
        "layout_img": "![Order Queue](../../screenshots/PSP_Operations/psp_ops_orders.png)",
        "diag_map": {"7.1 Order Status State Machine": M_ORDER_STATUS}
    },
    r"08_Module_PSPOperations\screens\P002_Shipments.md": {
        "layout_img": "![Shipments](../../screenshots/PSP_Operations/psp_ops_shipments.png)",
        "diag_map": {"7.1": M_GENERIC_FLOW}
    },
    r"08_Module_PSPOperations\screens\P003_Issues.md": {
        "layout_img": "![Issues](../../screenshots/PSP_Operations/psp_ops_issues.png)",
        "diag_map": {"7.1 Issue Status State Machine": M_ISSUE_STATUS}
    },
    # Store Portal
    r"09_Module_StorePortal\screens\S001_Dashboard.md": {
        "layout_img": "![Store Dashboard](../../screenshots/Store_Portal/store_portal_dashboard.png)",
        "diag_map": {}
    },
    r"09_Module_StorePortal\screens\S002_Campaign_History.md": {
        "layout_img": "![Campaign History](../../screenshots/Store_Portal/store_portal_campaigns.png)",
        "diag_map": {}
    }
}

# Add M003, M004, M005, M007, M008 with generic handling
for i in [3, 4, 5, 7, 8]:
    name = f"M00{i}"
    # Find full filename in dir? No, hardcode potential names or just skip precise name
    # We will assume standard names
    # Actually, let's just use walk/find to apply generic fixes to any M*.md file that has ASCII
    pass

ROOT = r"E:\Docker\PopSystem\SOW\07_SRS"

def process_file_generic(path, layout_img, diag_map=None):
    if not os.path.exists(path):
        return
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    orig = content
    
    # 1. Replace Layout blocks (Header 3.x Layout)
    pattern_layout = r'(### \d+\.\d+ Layout.*?\n\s*)```(?:.|[\r\n])*?```'
    matches = re.finditer(pattern_layout, content, re.DOTALL)
    for m in matches:
        # We replace specific block
        replacement = f"{m.group(1)}\n{layout_img}\n"
        content = content.replace(m.group(0), replacement)

    # 2. Replace Diagrams
    if diag_map:
        for header, code in diag_map.items():
            pattern_diag = r'(### ' + re.escape(header) + r'.*?\n\s*)```(?:.|[\r\n])*?```'
            match_diag = re.search(pattern_diag, content, re.DOTALL)
            if match_diag:
                 replacement = f"{match_diag.group(1)}\n{code}\n"
                 content = content.replace(match_diag.group(0), replacement)
    
    # 3. Generic Diagram Replacement for any remaining "State Machine" ASCII
    # (Only if we haven't handled it)
    pattern_generic_diag = r'(### \d+\.\d+ .*?State Machine\s*\n\s*)```(?:.|[\r\n])*?```'
    # We want to replace it ONLY if it still looks like ASCII (contains +-- or | )
    # But checking that is tricky.
    # We will assume if we passed diag_map, we handled specific ones.
    # For others, we apply M_GENERIC_FLOW
    
    matches_gen = re.finditer(pattern_generic_diag, content, re.DOTALL)
    for m in matches_gen:
        if "mermaid" not in m.group(0): # If not already replaced
             content = content.replace(m.group(0), f"{m.group(1)}\n{M_GENERIC_FLOW}\n")

    if content != orig:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Updated {os.path.basename(path)}")
    else:
        print(f"No changes {os.path.basename(path)}")

def main():
    # Process explicit map
    for f, cfg in FILES.items():
        process_file_generic(os.path.join(ROOT, f), cfg["layout_img"], cfg.get("diag_map"))
        
    # Process remaining M-series generic
    m_dir = os.path.join(ROOT, r"06_Module_StoreExecution\screens")
    if os.path.exists(m_dir):
        for f in os.listdir(m_dir):
            if f.endswith(".md") and f.startswith("M") and f not in [k.split('\\')[-1] for k in FILES.keys()]:
                path = os.path.join(m_dir, f)
                # Generic M fix
                process_file_generic(path, "![Mobile Interface](../../screenshots/Store_Execution/mobile_dashboard.png)")

if __name__ == "__main__":
    main()
