# Generate section PDFs for NewPOPSys SRS
$basePath = "e:\Docker\PopSystem\SOW\07_SRS"
$pdfDir = "$basePath\00_Meta\pdf_sections"

# Create output directory
New-Item -ItemType Directory -Force -Path $pdfDir | Out-Null

# Define sections with their files
$sections = @{
    "00_Title" = @("00_Meta\TABLE_OF_CONTENTS.md")
    "01_Introduction" = @(
        "01_Introduction\1.1_Purpose.md",
        "01_Introduction\1.2_Scope.md",
        "01_Introduction\1.3_Definitions_Acronyms.md",
        "01_Introduction\1.4_References.md",
        "01_Introduction\1.5_Document_Overview.md"
    )
    "02_Overall_Description" = @(
        "02_Overall_Description\2.1_Product_Perspective.md",
        "02_Overall_Description\2.2_Product_Functions.md",
        "02_Overall_Description\2.3_User_Classes.md",
        "02_Overall_Description\2.4_Operating_Environment.md",
        "02_Overall_Description\2.5_Constraints.md",
        "02_Overall_Description\2.6_Assumptions_Dependencies.md"
    )
    "03_System_Architecture" = @(
        "03_System_Architecture\3.1_Database_Model.md",
        "03_System_Architecture\3.2_Application_Architecture.md",
        "03_System_Architecture\3.3_Technology_Stack.md",
        "03_System_Architecture\3.4_Integration_Architecture.md"
    )
    "04_User_Personas" = @(
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
        "04_User_Personas_RBAC\personas\Integration_User.md"
    )
    "05_SharedFoundations" = @("05_Module_SharedFoundations\screens\L001_Universal_Login.md")
    "06_MobilePWA" = @(
        "06_Module_MobilePWA\screens\M001_Login.md",
        "06_Module_MobilePWA\screens\M002_Dashboard.md",
        "06_Module_MobilePWA\screens\M003_Receipt_Survey.md",
        "06_Module_MobilePWA\screens\M004_Install_Survey.md",
        "06_Module_MobilePWA\screens\M005_Photo_Capture.md",
        "06_Module_MobilePWA\screens\M006_Tasks.md",
        "06_Module_MobilePWA\screens\M007_Profile.md",
        "06_Module_MobilePWA\screens\M008_Retake.md"
    )
    "07_BrandAdmin" = @(
        "07_Module_BrandAdmin\screens\B001_Dashboard.md",
        "07_Module_BrandAdmin\screens\B002_Campaign_List.md",
        "07_Module_BrandAdmin\screens\B003_Store_Selection.md",
        "07_Module_BrandAdmin\screens\B004_Kit_Definition.md",
        "07_Module_BrandAdmin\screens\B005_Campaign_Review.md",
        "07_Module_BrandAdmin\screens\B006_Store_List.md",
        "07_Module_BrandAdmin\screens\B007_Verification.md"
    )
    "08_PSPOperations" = @(
        "08_Module_PSPOperations\screens\P001_Order_Queue.md",
        "08_Module_PSPOperations\screens\P002_Shipments.md",
        "08_Module_PSPOperations\screens\P003_Issues.md"
    )
    "09_StorePortal" = @(
        "09_Module_StorePortal\screens\S001_Dashboard.md",
        "09_Module_StorePortal\screens\S002_Campaign_History.md",
        "09_Module_StorePortal\screens\S003_Photo_Gallery.md",
        "09_Module_StorePortal\screens\S004_Team_Management.md",
        "09_Module_StorePortal\screens\S005_Reports.md"
    )
    "10_PlatformAdmin" = @(
        "10_Module_PlatformAdmin\screens\A001_Dashboard.md",
        "10_Module_PlatformAdmin\screens\A002_Brand_Management.md",
        "10_Module_PlatformAdmin\screens\A003_User_Management.md",
        "10_Module_PlatformAdmin\screens\A004_PSP_Configuration.md",
        "10_Module_PlatformAdmin\screens\A005_System_Settings.md",
        "10_Module_PlatformAdmin\screens\A006_Analytics.md"
    )
    "11_API_Specifications" = @(
        "11_API_Specifications\11.1_API_Overview.md",
        "11_API_Specifications\11.2_Internal_APIs.md",
        "11_API_Specifications\11.3_External_Integrations.md",
        "11_API_Specifications\11.4_Webhooks.md"
    )
    "12_NFR" = @(
        "12_Non_Functional_Requirements\12.1_Performance.md",
        "12_Non_Functional_Requirements\12.2_Security.md",
        "12_Non_Functional_Requirements\12.3_Accessibility.md",
        "12_Non_Functional_Requirements\12.4_Scalability.md",
        "12_Non_Functional_Requirements\12.5_Availability.md",
        "12_Non_Functional_Requirements\12.6_Data_Retention.md"
    )
    "99_Appendices" = @(
        "99_Appendices\A_State_Machines.md",
        "99_Appendices\B_Notification_Matrix.md",
        "99_Appendices\C_Export_Formats.md",
        "99_Appendices\D_Glossary.md",
        "99_Appendices\E_Change_Log.md"
    )
}

# Process each section
foreach ($sectionName in $sections.Keys | Sort-Object) {
    $sectionFiles = $sections[$sectionName]
    $combinedMd = "$pdfDir\$sectionName.md"
    $pdfFile = "$pdfDir\$sectionName.pdf"

    # Combine files for this section
    "" | Out-File -FilePath $combinedMd -Encoding UTF8

    foreach ($file in $sectionFiles) {
        $fullPath = Join-Path $basePath $file
        if (Test-Path $fullPath) {
            $content = Get-Content $fullPath -Raw -Encoding UTF8
            "`n---`n" | Add-Content -Path $combinedMd -Encoding UTF8
            $content | Add-Content -Path $combinedMd -Encoding UTF8
        }
    }

    # Convert to PDF using md-to-pdf (default options)
    Write-Host "Converting $sectionName to PDF..."
    & npx md-to-pdf $combinedMd 2>&1

    if (Test-Path $pdfFile) {
        Write-Host "  Created: $pdfFile" -ForegroundColor Green
    } else {
        Write-Host "  FAILED: $sectionName" -ForegroundColor Red
    }
}

Write-Host "`nPDF generation complete. Files in: $pdfDir"
