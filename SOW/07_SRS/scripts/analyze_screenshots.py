import os

# Define screenshot mappings based on standard SRS screen IDs
# Format: ScreenID: [List of acceptable image filename patterns]
SCREEN_MAPPINGS = {
    # 05_SharedFoundations
    'L001': ['login', 'universal_login'],
    'L002': ['landing', 'universal_dashboard'],
    
    # 06_StoreExecution
    'M001': ['mobile_login'],
    'M002': ['mobile_dashboard', 'tablet_dashboard', 'desktop_dashboard'],
    'M003': ['verify_receipt', 'mobile_verify_receipt'],
    'M004': ['install_photos', 'mobile_install_photos'],
    'M005': ['attestation', 'mobile_attestation'],
    'M006': ['tasks', 'mobile_tasks_receive'],
    'M007': ['profile', 'mobile_profile'],
    'M008': ['retake', 'photo_captured'],
    'M009': ['deinstall_list'],
    'M010': ['deinstall_confirm'],
    
    # 07_BrandAdmin
    'B001': ['admin_portal_dashboard'],
    'B002': ['admin_portal_campaigns', 'campaign_wizard'],
    'B003': ['store_selection'],
    'B004': ['kit_definition'],
    'B005': ['campaign_review'],
    'B006': ['store_list'],
    'B007': ['verification', 'verification_queue'],
    
    # 08_PSPOperations
    'P001': ['order_queue', 'psp_ops_orders'],
    'P002': ['shipments', 'psp_ops_shipments'],
    'P003': ['issues', 'psp_ops_issues'],
    
    # 09_StorePortal
    'S001': ['store_portal_dashboard', 'store_dashboard'],
    'S002': ['store_portal_campaigns', 'campaign_history'],
    'S003': ['store_portal_photos', 'photo_gallery'],
    'S004': ['store_portal_team', 'team_mgmt'],
    'S005': ['store_portal_reports'],
    
    # 10_PlatformAdmin
    'A001': ['psp_admin_dashboard'],
    'A002': ['user_mgmt', 'psp_admin_users'],
    'A003': ['brand_config', 'psp_admin_brands'],
    'A004': ['system_settings'],
    'A005': ['audit_logs'],
    'A006': ['analytics']
}

def analyze_screenshots(srs_root, screenshots_root):
    # Get list of all actual screenshot files
    actual_files = []
    for root, dirs, files in os.walk(screenshots_root):
        for file in files:
            if file.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
                actual_files.append(file.lower())
                
    print("# Screenshot Gap Analysis Report\n")
    print("## 1. Inventory Summary")
    print(f"- **Total Screenshot Files Found**: {len(actual_files)}")
    print(f"- **Total SRS Screens Defined**: {len(SCREEN_MAPPINGS)}")
    print("\n## 2. Match Status\n")
    print("| Screen ID | Associated Keywords | Match Status | Best Match Found |")
    print("|-----------|---------------------|--------------|------------------|")
    
    matches_found = 0
    missing = []
    
    for screen_id, patterns in sorted(SCREEN_MAPPINGS.items()):
        found_match = None
        # Loose matching logic
        for pattern in patterns:
            for actual in actual_files:
                if pattern in actual:
                    found_match = actual
                    break
            if found_match:
                break
        
        status_icon = "✅" if found_match else "❌"
        status_text = "Found" if found_match else "MISSING"
        match_name = found_match if found_match else "-"
        
        print(f"| {screen_id} | {', '.join(patterns)} | {status_icon} {status_text} | {match_name} |")
        
        if found_match:
            matches_found += 1
        else:
            missing.append(screen_id)

    print("\n## 3. Missing Screens Action Plan")
    if not missing:
        print("\n**All defined screens have at least one matching screenshot pattern!**")
    else:
        print("\nThe following screens have NO matching screenshots detected based on standard naming:")
        print(f"\n**Missing Count**: {len(missing)}")
        for m in missing:
            print(f"- {m}")

if __name__ == "__main__":
    analyze_screenshots(
        r"E:\Docker\PopSystem\SOW\07_SRS",
        r"E:\Docker\PopSystem\SOW\07_SRS\screenshots"
    )
