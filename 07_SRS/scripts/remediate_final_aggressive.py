import os
import re

# --- Mermaid Diagrams ---

M_GENERIC_FLOW = """```mermaid
stateDiagram-v2
    [*] --> Step1
    Step1 --> Step2: process
    Step2 --> Step3: validate
    Step3 --> [*]
    Step3 --> Error
    Error --> Step1: retry
```"""

M_ARCH_DIAG = """```mermaid
graph TD
    Client[Client App] --> API[API Gateway]
    API --> Auth[Auth Service]
    API --> Core[Core Service]
    Core --> DB[(Database)]
    Core --> S3[(Object Storage)]
```"""

# --- File Maps ---

FILES = {
    # Brand (Clean, but check) - Skipped as verified
    
    # Shared
    r"05_Module_SharedFoundations\screens\L001_Universal_Login.md": { "layout_img": "![Login](../../screenshots/Mobile_App/mobile_app.png)" },
    r"05_Module_SharedFoundations\screens\L002_Universal_Dashboard.md": { "layout_img": "![Dashboard](../../screenshots/Admin_Portal/admin_portal_dashboard.png)" },
    
    # Store Execution (Mobile)
    r"06_Module_StoreExecution\screens\M001_Login.md": { "layout_img": "![Mobile Login](../../screenshots/Store_Execution/mobile_login.png)" },
    r"06_Module_StoreExecution\screens\M002_Dashboard.md": { "layout_img": "![Mobile Dashboard](../../screenshots/Store_Execution/mobile_dashboard.png)" },
    r"06_Module_StoreExecution\screens\M003_Verify_Receipt.md": { "layout_img": "![Receipt](../../screenshots/Store_Execution/mobile_receipt.png)" },
    r"06_Module_StoreExecution\screens\M004_Installation_Photos.md": { "layout_img": "![Install](../../screenshots/Store_Execution/mobile_install.png)" },
    r"06_Module_StoreExecution\screens\M005_Compliance_Attestation.md": { "layout_img": "![Compliance](../../screenshots/Store_Execution/mobile_compliance.png)" },
    r"06_Module_StoreExecution\screens\M006_Task_Navigation.md": { "layout_img": "![Tasks](../../screenshots/Store_Execution/mobile_tasks.png)" },
    r"06_Module_StoreExecution\screens\M007_Profile.md": { "layout_img": "![Profile](../../screenshots/Store_Execution/mobile_profile.png)" },
    r"06_Module_StoreExecution\screens\M008_Photo_Retake.md": { "layout_img": "![Retake](../../screenshots/Store_Execution/mobile_retake.png)" },
    
    # PSP
    r"08_Module_PSPOperations\screens\P001_Order_Queue.md": { "layout_img": "![Orders](../../screenshots/PSP_Operations/psp_ops_orders.png)" },
    r"08_Module_PSPOperations\screens\P002_Shipments.md": { "layout_img": "![Shipments](../../screenshots/PSP_Operations/psp_ops_shipments.png)" },
    r"08_Module_PSPOperations\screens\P003_Issues.md": { "layout_img": "![Issues](../../screenshots/PSP_Operations/psp_ops_issues.png)" },
    
    # Store Portal
    r"09_Module_StorePortal\screens\S001_Dashboard.md": { "layout_img": "![Dashboard](../../screenshots/Store_Portal/store_portal_dashboard.png)" },
    r"09_Module_StorePortal\screens\S002_Campaign_History.md": { "layout_img": "![History](../../screenshots/Store_Portal/store_portal_campaigns.png)" },
    r"09_Module_StorePortal\screens\S005_Reports.md": { "layout_img": "![Reports](../../screenshots/Store_Portal/store_portal_reports.png)" },
    
    # API & Appendices
    r"11_API_Specifications\11.1_API_Overview.md": { "layout_img": None, "diag_code": M_ARCH_DIAG },
    r"11_API_Specifications\11.3_External_Integrations.md": { "layout_img": None, "diag_code": M_GENERIC_FLOW },
    r"99_Appendices\C_Export_Formats.md": { "layout_img": "![Export Format](../../screenshots/Appendices/export_format.png)" }
}

ROOT = r"E:\Docker\PopSystem\SOW\07_SRS"

def process_file(rel_path, config):
    path = os.path.join(ROOT, rel_path)
    if not os.path.exists(path):
        return

    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    
    # Regex 1: Layouts (Box inside ```)
    # Detect ``` ... +-----+ ... ```
    # Matches any fenced block with box characters
    
    # Strategy: Find all fenced blocks. Check if ASCII. If so, replace with image/diagram.
    
    def replace_block(match):
        code = match.group(2)
        full_block = match.group(0)
        
        # Check for ASCII markers
        is_ascii = False
        if re.search(r'[┌┐└┘├┤┬┴┼═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬]', code): is_ascii = True
        if re.search(r'\+[-=]{3,}\+', code): is_ascii = True
        
        if not is_ascii:
            return full_block # Keep as is
            
        # It is ASCII. Replace it.
        # Prefer specific replacements
        if config.get("diag_code"):
            return config["diag_code"]
        if config.get("layout_img"):
            return config["layout_img"]
            
        return M_GENERIC_FLOW # Fallback

    # Match ```(nothing or text)\n ... ```
    # Excluding explicit languages usually (but ASCII might be marked as 'text')
    # We'll use a callback
    content = re.sub(r'(```(?:\w*)\n)(.*?)(```)', replace_block, content, flags=re.DOTALL)

    if content != original_content:
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed {rel_path}")
    else:
        # If no change but we expected one?
        pass

def main():
    for f, cfg in FILES.items():
        process_file(f, cfg)

if __name__ == "__main__":
    main()
