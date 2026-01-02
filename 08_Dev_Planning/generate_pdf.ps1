# Generate PDF for Dev Guide v2.0
$basePath = "E:\Docker\PopSystem\SOW\08_Dev_Planning"
$combinedMd = "$basePath\DEV_GUIDE_FULL.md"
$pdfFile = "$basePath\DEV_GUIDE_FULL.pdf"

# Files in order
$files = @(
    "01_Master_Plan\MASTER_DEVELOPMENT_PLAN.md",
    "02_Sprint_Roadmap\SPRINT_ROADMAP.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S0_Foundation.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S1_Auth_CoreUI.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S2_Mobile_Core.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S3_Brand_Portal.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S4_PSP_Portal.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S5_Store_Integration.md",
    "02_Sprint_Roadmap\Sprints\SPRINT_S6_Launch.md",
    "03_Technical_Specs\TECH_STACK_DECISIONS.md",
    "03_Technical_Specs\AI_DEV_SPECS.md",
    "05_Agile_Suite\TESTING_STRATEGY.md"
)

# Initialize output
"# PopSystem Dev Guide v2.0 (Clean Build)`n`n" | Out-File -FilePath $combinedMd -Encoding UTF8

foreach ($file in $files) {
    $fullPath = Join-Path $basePath $file
    if (Test-Path $fullPath) {
        "`n`n<div class='page-break'></div>`n`n" | Add-Content -Path $combinedMd -Encoding UTF8
        Get-Content $fullPath -Raw -Encoding UTF8 | Add-Content -Path $combinedMd -Encoding UTF8
    }
}

Write-Host "Converting to PDF..."
$css = ".page-break { page-break-after: always; } body { font-family: sans-serif; }"
$cssFile = "$basePath\style.css"
$css | Out-File -FilePath $cssFile -Encoding UTF8

& npx md-to-pdf $combinedMd --stylesheet $cssFile 2>&1

if (Test-Path $pdfFile) {
    Write-Host "SUCCESS: $pdfFile" -ForegroundColor Green
}
else {
    Write-Host "FAILURE" -ForegroundColor Red
}
