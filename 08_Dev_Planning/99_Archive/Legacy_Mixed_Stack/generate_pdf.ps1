# Generate PDF for Dev Guide v1.38
$basePath = "E:\Docker\PopSystem\SOW\08_Dev_Planning"
$combinedMd = "$basePath\DEV_GUIDE_FULL.md"
$pdfFile = "$basePath\DEV_GUIDE_FULL.pdf"

# Files in order
$files = @(
    "README.md",
    "01_Master_Plan\MASTER_DEVELOPMENT_PLAN.md",
    "02_Sprint_Roadmap\SPRINT_ROADMAP.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S0_Foundation.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S1_Auth_CoreUI.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S2_Mobile_Core.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S3_Brand_Portal.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S4_PSP_Portal.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S5_Store_Integration.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S6_Launch.md",
    "03_Technical_Specs\AI_DEVELOPMENT_HARNESS.md",
    "03_Technical_Specs\TECH_STACK_DECISIONS.md",
    "03_Technical_Specs\AI_DEV_SPECS.md",
    "03_Technical_Specs\ARCHITECTURE_OVERVIEW.md",
    "04_Tracking_Artifacts\Sprint_Board\CURRENT_SPRINT.md",
    "05_Agile_Suite\TESTING_STRATEGY.md",
    "05_Agile_Suite\DEFINITION_OF_DONE.md"
)

# Initialize output
"# PopSystem Development Guide v1.38`n`n" | Out-File -FilePath $combinedMd -Encoding UTF8

foreach ($file in $files) {
    $fullPath = Join-Path $basePath $file
    if (Test-Path $fullPath) {
        # Add a page break and file header
        "`n`n<div class='page-break'></div>`n`n" | Add-Content -Path $combinedMd -Encoding UTF8
        # Add content
        Get-Content $fullPath -Raw -Encoding UTF8 | Add-Content -Path $combinedMd -Encoding UTF8
    }
    else {
        Write-Host "Warning: Missing $file" -ForegroundColor Yellow
    }
}

Write-Host "Converting to PDF via md-to-pdf..."
# Use npx to convert. --stylesheet-encoding utf-8 is good practice but basic usage usually works
# We add some CSS for page breaks
$css = "body { font-family: sans-serif; } .page-break { page-break-after: always; } table { width: 100%; border-collapse: collapse; } th, td { border: 1px solid #ccc; padding: 5px; }"
$cssFile = "$basePath\style.css"
$css | Out-File -FilePath $cssFile -Encoding UTF8

& npx md-to-pdf $combinedMd --stylesheet $cssFile 2>&1

if (Test-Path $pdfFile) {
    Write-Host "SUCCESS: Generated $pdfFile" -ForegroundColor Green
}
else {
    Write-Host "FAILURE: PDF not found." -ForegroundColor Red
}
