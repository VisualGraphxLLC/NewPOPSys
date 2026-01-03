# Combine all SRS files into single document for PDF generation
$basePath = "e:\Docker\PopSystem\SOW\07_SRS"
$outputFile = "$basePath\00_Meta\COMBINED_SRS_FOR_PDF.md"

# Clear output file
"" | Out-File -FilePath $outputFile -Encoding UTF8

# Title Page
@"
---
title: 'NewPOPSys v1.38 - Software Requirements Specification'
author: 'Visual Graphx / ServRx'
date: '2026-01-01'
---

# NewPOPSys v1.38
## Software Requirements Specification
### PSP-led POP Campaign Orchestration Platform

| Field | Value |
|-------|-------|
| **Version** | 1.0 |
| **Status** | For CIO Approval |
| **Date** | January 1, 2026 |
| **Classification** | Internal |

---

"@ | Out-File -FilePath $outputFile -Encoding UTF8

# Define all files in order
$files = @(
    "00_Meta\TABLE_OF_CONTENTS.md",
    "01_Introduction\1.1_Purpose.md",
    "01_Introduction\1.2_Scope.md",
    "01_Introduction\1.3_Definitions_Acronyms.md",
    "01_Introduction\1.4_References.md",
    "01_Introduction\1.5_Document_Overview.md",
    "02_Overall_Description\2.1_Product_Perspective.md",
    "02_Overall_Description\2.2_Product_Functions.md",
    "02_Overall_Description\2.3_User_Classes.md",
    "02_Overall_Description\2.4_Operating_Environment.md",
    "02_Overall_Description\2.5_Constraints.md",
    "02_Overall_Description\2.6_Assumptions_Dependencies.md",
    "03_System_Architecture\3.1_Database_Model.md",
    "03_System_Architecture\3.2_Application_Architecture.md",
    "03_System_Architecture\3.3_Technology_Stack.md",
    "03_System_Architecture\3.4_Integration_Architecture.md",
    "04_User_Personas_RBAC\4.1_Persona_Matrix.md",
    "04_User_Personas_RBAC\4.2_Permission_Matrix.md",
    "04_User_Personas_RBAC\4.3_Authentication_Flows.md",
    "04_User_Personas_RBAC\personas\PSP_Admin.md",
    "04_User_Personas_RBAC\personas\Production_Operator.md",
    "04_User_Personas_RBAC\personas\Platform_Admin.md",
    "04_User_Personas_RBAC\personas\Brand_Admin.md",
    "04_User_Personas_RBAC\personas\Campaign_Manager.md",
    "04_User_Personas_RBAC\personas\Regional_Manager.md",
    "04_User_Personas_RBAC\personas\Store_Manager.md",
    "04_User_Personas_RBAC\personas\Store_Operator.md",
    "04_User_Personas_RBAC\personas\Integration_User.md",
    "05_Module_SharedFoundations\screens\L001_Universal_Login.md",
    "06_Module_MobilePWA\screens\M001_Login.md",
    "06_Module_MobilePWA\screens\M002_Dashboard.md",
    "06_Module_MobilePWA\screens\M003_Receipt_Survey.md",
    "06_Module_MobilePWA\screens\M004_Install_Survey.md",
    "06_Module_MobilePWA\screens\M005_Photo_Capture.md",
    "06_Module_MobilePWA\screens\M006_Tasks.md",
    "06_Module_MobilePWA\screens\M007_Profile.md",
    "06_Module_MobilePWA\screens\M008_Retake.md",
    "07_Module_BrandAdmin\screens\B001_Dashboard.md",
    "07_Module_BrandAdmin\screens\B002_Campaign_List.md",
    "07_Module_BrandAdmin\screens\B003_Store_Selection.md",
    "07_Module_BrandAdmin\screens\B004_Kit_Definition.md",
    "07_Module_BrandAdmin\screens\B005_Campaign_Review.md",
    "07_Module_BrandAdmin\screens\B006_Store_List.md",
    "07_Module_BrandAdmin\screens\B007_Verification.md",
    "08_Module_PSPOperations\screens\P001_Order_Queue.md",
    "08_Module_PSPOperations\screens\P002_Shipments.md",
    "08_Module_PSPOperations\screens\P003_Issues.md",
    "09_Module_StorePortal\screens\S001_Dashboard.md",
    "09_Module_StorePortal\screens\S002_Campaign_History.md",
    "09_Module_StorePortal\screens\S003_Photo_Gallery.md",
    "09_Module_StorePortal\screens\S004_Team_Management.md",
    "09_Module_StorePortal\screens\S005_Reports.md",
    "10_Module_PlatformAdmin\screens\A001_Dashboard.md",
    "10_Module_PlatformAdmin\screens\A002_Brand_Management.md",
    "10_Module_PlatformAdmin\screens\A003_User_Management.md",
    "10_Module_PlatformAdmin\screens\A004_PSP_Configuration.md",
    "10_Module_PlatformAdmin\screens\A005_System_Settings.md",
    "10_Module_PlatformAdmin\screens\A006_Analytics.md",
    "11_API_Specifications\11.1_API_Overview.md",
    "11_API_Specifications\11.2_Internal_APIs.md",
    "11_API_Specifications\11.3_External_Integrations.md",
    "11_API_Specifications\11.4_Webhooks.md",
    "12_Non_Functional_Requirements\12.1_Performance.md",
    "12_Non_Functional_Requirements\12.2_Security.md",
    "12_Non_Functional_Requirements\12.3_Accessibility.md",
    "12_Non_Functional_Requirements\12.4_Scalability.md",
    "12_Non_Functional_Requirements\12.5_Availability.md",
    "12_Non_Functional_Requirements\12.6_Data_Retention.md",
    "99_Appendices\A_State_Machines.md",
    "99_Appendices\B_Notification_Matrix.md",
    "99_Appendices\C_Export_Formats.md",
    "99_Appendices\D_Glossary.md",
    "99_Appendices\E_Change_Log.md"
)

$count = 0
foreach ($file in $files) {
    $fullPath = Join-Path $basePath $file
    if (Test-Path $fullPath) {
        $content = Get-Content $fullPath -Raw -Encoding UTF8
        "`n---`n" | Add-Content -Path $outputFile -Encoding UTF8
        $content | Add-Content -Path $outputFile -Encoding UTF8
        $count++
        Write-Host "Added: $file"
    } else {
        Write-Host "MISSING: $file" -ForegroundColor Red
    }
}

Write-Host "`nTotal files combined: $count"
Write-Host "Output: $outputFile"
