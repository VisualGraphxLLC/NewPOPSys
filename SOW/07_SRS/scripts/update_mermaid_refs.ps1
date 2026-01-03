# Update Mermaid References Script
# Updates markdown files to reference pre-rendered PNG diagrams
# PowerShell 5.1 compatible - Run from SOW/07_SRS/ directory

$ErrorActionPreference = "Stop"
$DiagramsDir = "diagrams_rendered"
$BaseDir = (Get-Location).Path

# PowerShell 5.1 compatible relative path function
function Get-RelativePath {
    param([string]$From, [string]$To)

    $fromParts = $From.TrimEnd('\').Split('\')
    $toParts = $To.TrimEnd('\').Split('\')

    # Find common path length
    $commonLength = 0
    $minLength = [Math]::Min($fromParts.Length, $toParts.Length)
    for ($i = 0; $i -lt $minLength; $i++) {
        if ($fromParts[$i] -eq $toParts[$i]) {
            $commonLength++
        } else {
            break
        }
    }

    # Build relative path
    $upCount = $fromParts.Length - $commonLength
    $relativeParts = @()

    for ($i = 0; $i -lt $upCount; $i++) {
        $relativeParts += ".."
    }

    for ($i = $commonLength; $i -lt $toParts.Length; $i++) {
        $relativeParts += $toParts[$i]
    }

    if ($relativeParts.Length -eq 0) {
        return "."
    }

    return $relativeParts -join "/"
}

Write-Host "Updating Mermaid diagram references..." -ForegroundColor Cyan

# Verify diagrams directory exists
if (-not (Test-Path $DiagramsDir)) {
    Write-Host "ERROR: $DiagramsDir not found. Run render_mermaid.ps1 first." -ForegroundColor Red
    exit 1
}

$diagramsFullPath = (Get-Item $DiagramsDir).FullName

# Find all markdown files
$mdFiles = Get-ChildItem -Path "." -Filter "*.md" -Recurse | Where-Object { $_.FullName -notmatch "node_modules" -and $_.FullName -notmatch "diagrams_rendered" }

$updatedCount = 0
$diagramCount = 0

foreach ($file in $mdFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    if (-not $content) { continue }

    $relativePath = $file.FullName.Replace($BaseDir + "\", "").Replace("\", "_").Replace(".md", "")

    # Match mermaid code blocks
    $pattern = '```mermaid\s*([\s\S]*?)```'
    $allMatches = [regex]::Matches($content, $pattern)

    if ($allMatches.Count -gt 0) {
        Write-Host "  Processing: $($file.Name) ($($allMatches.Count) diagrams)" -ForegroundColor Yellow

        $blockIndex = 0
        $newContent = $content
        $fileUpdated = $false

        foreach ($match in $allMatches) {
            $diagramName = "${relativePath}_diagram_${blockIndex}"
            $pngFile = Join-Path $diagramsFullPath "${diagramName}.png"

            if (Test-Path $pngFile) {
                # Calculate relative path from source file to diagrams folder
                $sourceDir = Split-Path $file.FullName -Parent
                $relativeToSource = Get-RelativePath -From $sourceDir -To $diagramsFullPath
                $imgPath = "$relativeToSource/${diagramName}.png"

                # Replace mermaid block with image reference
                $imgMarkdown = "![${diagramName}](${imgPath})"
                $newContent = $newContent.Replace($match.Value, $imgMarkdown)

                Write-Host "    Updated: ${diagramName}" -ForegroundColor Green
                $diagramCount++
                $fileUpdated = $true
            } else {
                Write-Host "    SKIPPED (PNG not found): ${diagramName}" -ForegroundColor Yellow
            }

            $blockIndex++
        }

        if ($fileUpdated) {
            # Write updated content back to file
            $newContent | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
            $updatedCount++
        }
    }
}

Write-Host "`nUpdate complete!" -ForegroundColor Cyan
Write-Host "Files updated: $updatedCount" -ForegroundColor Green
Write-Host "Diagram references: $diagramCount" -ForegroundColor Green
