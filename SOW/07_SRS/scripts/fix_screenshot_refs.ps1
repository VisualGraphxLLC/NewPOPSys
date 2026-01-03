# Fix Screenshot References Script
# Updates markdown files with correct screenshot paths
# PowerShell 5.1 compatible - Run from SOW/07_SRS/ directory

$ErrorActionPreference = "Stop"
$BaseDir = (Get-Location).Path

Write-Host "Fixing screenshot references in markdown files..." -ForegroundColor Cyan

# Define replacements: old path -> new path
$replacements = @{
    # Fix incorrect path depth (../../../ -> ../../ for screens folders)
    '../../../screenshots/' = '../../screenshots/'

    # Fix missing screenshot filenames
    'admin_portal_campaign_list.png' = 'admin_portal_campaigns.png'
    'admin_portal_store_selection.png' = 'admin_portal_stores_tab.png'
    'admin_portal_kit_definition.png' = 'admin_portal_new_campaign_wizard.png'
    'admin_portal_campaign_review.png' = 'admin_portal_verification.png'
    'admin_portal_store_list.png' = 'admin_portal_stores_tab.png'
    'admin_portal_verification_queue.png' = 'admin_portal_verification.png'
    'Store_Portal/S003_Photo_Gallery.png' = 'Store_Portal/store_portal_photos.png'
    'Store_Portal/S004_Team_Management.png' = 'Store_Portal/store_portal_team.png'
}

# Find all markdown files (excluding node_modules and diagrams_rendered)
$mdFiles = Get-ChildItem -Path "." -Filter "*.md" -Recurse | Where-Object {
    $_.FullName -notmatch "node_modules" -and
    $_.FullName -notmatch "diagrams_rendered"
}

$updatedCount = 0
$replacementCount = 0

foreach ($file in $mdFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if (-not $content) { continue }

    $originalContent = $content
    $fileUpdated = $false

    foreach ($old in $replacements.Keys) {
        $new = $replacements[$old]
        if ($content -match [regex]::Escape($old)) {
            $content = $content.Replace($old, $new)
            $fileUpdated = $true
            $replacementCount++
            Write-Host "  Fixed in $($file.Name): $old -> $new" -ForegroundColor Yellow
        }
    }

    if ($fileUpdated) {
        $content | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
        $updatedCount++
    }
}

Write-Host "`nScreenshot reference fix complete!" -ForegroundColor Cyan
Write-Host "Files updated: $updatedCount" -ForegroundColor Green
Write-Host "Replacements made: $replacementCount" -ForegroundColor Green

# Verify screenshot paths after fixes
Write-Host "`nVerifying screenshot references..." -ForegroundColor Cyan
$screenshotsDir = "screenshots"
$brokenRefs = @()

foreach ($file in $mdFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if (-not $content) { continue }

    # Find all screenshot references
    $pattern = '!\[.*?\]\((.*?screenshots/.*?\.png)\)'
    $matches = [regex]::Matches($content, $pattern)

    foreach ($match in $matches) {
        $imgPath = $match.Groups[1].Value
        # Convert relative path to actual path from file location
        $sourceDir = Split-Path $file.FullName -Parent
        $fullImgPath = Join-Path $sourceDir $imgPath
        $fullImgPath = [System.IO.Path]::GetFullPath($fullImgPath)

        if (-not (Test-Path $fullImgPath)) {
            $brokenRefs += @{
                File = $file.Name
                Path = $imgPath
            }
        }
    }
}

if ($brokenRefs.Count -gt 0) {
    Write-Host "`nBroken references still found:" -ForegroundColor Red
    foreach ($ref in $brokenRefs) {
        Write-Host "  $($ref.File): $($ref.Path)" -ForegroundColor Red
    }
} else {
    Write-Host "All screenshot references verified!" -ForegroundColor Green
}
