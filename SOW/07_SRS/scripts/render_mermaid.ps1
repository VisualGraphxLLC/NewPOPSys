# Mermaid Diagram Rendering Script
# Extracts inline mermaid blocks from markdown files and renders to PNG
# Run from SOW/07_SRS/ directory

$ErrorActionPreference = "Stop"
$DiagramsDir = "diagrams_rendered"

# Create output directory
if (-not (Test-Path $DiagramsDir)) {
    New-Item -ItemType Directory -Path $DiagramsDir | Out-Null
}

Write-Host "Scanning for inline Mermaid diagrams..." -ForegroundColor Cyan

# Find all markdown files
$mdFiles = Get-ChildItem -Path "." -Filter "*.md" -Recurse | Where-Object { $_.FullName -notmatch "node_modules" }

$diagramCount = 0

foreach ($file in $mdFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $relativePath = $file.FullName.Replace((Get-Location).Path + "\", "").Replace("\", "_").Replace(".md", "")

    # Match mermaid code blocks
    $pattern = '```mermaid\s*([\s\S]*?)```'
    $matches = [regex]::Matches($content, $pattern)

    if ($matches.Count -gt 0) {
        Write-Host "  Processing: $($file.Name) ($($matches.Count) diagrams)" -ForegroundColor Yellow

        $blockIndex = 0
        $newContent = $content

        foreach ($match in $matches) {
            $mermaidCode = $match.Groups[1].Value.Trim()
            $diagramName = "${relativePath}_diagram_${blockIndex}"
            $mmdFile = Join-Path $DiagramsDir "${diagramName}.mmd"
            $pngFile = Join-Path $DiagramsDir "${diagramName}.png"

            # Write mermaid code to temp file
            $mermaidCode | Out-File -FilePath $mmdFile -Encoding UTF8 -NoNewline

            # Render to PNG using mmdc
            try {
                $mmdc = "mmdc"
                & $mmdc -i $mmdFile -o $pngFile -b transparent -w 1200 2>$null

                if (Test-Path $pngFile) {
                    Write-Host "    Rendered: ${diagramName}.png" -ForegroundColor Green
                    $diagramCount++

                    # Calculate relative path from source file to diagrams folder
                    $sourceDir = Split-Path $file.FullName -Parent
                    $diagramsFullPath = (Get-Item $DiagramsDir).FullName
                    $relativeToSource = [System.IO.Path]::GetRelativePath($sourceDir, $diagramsFullPath)
                    $imgPath = "$relativeToSource/${diagramName}.png".Replace("\", "/")

                    # Replace mermaid block with image reference
                    $imgMarkdown = "![${diagramName}](${imgPath})"
                    $newContent = $newContent.Replace($match.Value, $imgMarkdown)
                } else {
                    Write-Host "    FAILED: ${diagramName}" -ForegroundColor Red
                }
            } catch {
                Write-Host "    ERROR: $($_.Exception.Message)" -ForegroundColor Red
            }

            # Clean up temp mmd file
            if (Test-Path $mmdFile) {
                Remove-Item $mmdFile -Force
            }

            $blockIndex++
        }

        # Write updated content back to file
        $newContent | Out-File -FilePath $file.FullName -Encoding UTF8 -NoNewline
    }
}

Write-Host "`nMermaid rendering complete!" -ForegroundColor Cyan
Write-Host "Total diagrams rendered: $diagramCount" -ForegroundColor Green
Write-Host "Output directory: $DiagramsDir" -ForegroundColor Green
