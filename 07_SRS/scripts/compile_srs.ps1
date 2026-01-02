# NewPOPSys SRS Compilation Script
# Run from SOW/07_SRS/ directory
# Version 2.0 - Clean PDF-friendly output

$OutputFile = "COMPILED_SRS.md"
# Simple markdown page break - no HTML
$PageBreak = "`n`n---`n`n"

# Function to rewrite relative image paths for compiled output
function Rewrite-ImagePaths {
    param([string]$Content, [string]$SourceFolder)
    $Content = $Content -replace '\!\[([^\]]*)\]\(\.\./\.\./\.\./screenshots/', '![$1](./screenshots/'
    $Content = $Content -replace '\!\[([^\]]*)\]\(\.\./\.\./screenshots/', '![$1](./screenshots/'
    $Content = $Content -replace '\!\[([^\]]*)\]\(\.\./screenshots/', '![$1](./screenshots/'
    $Content = $Content -replace '\!\[([^\]]*)\]\(\.\./\.\./\.\./diagrams_rendered/', '![$1](./diagrams_rendered/'
    $Content = $Content -replace '\!\[([^\]]*)\]\(\.\./\.\./diagrams_rendered/', '![$1](./diagrams_rendered/'
    $Content = $Content -replace '\!\[([^\]]*)\]\(\.\./diagrams_rendered/', '![$1](./diagrams_rendered/'
    return $Content
}

# Function to remove Mermaid code blocks (markdown-pdf can't render them)
function Remove-MermaidBlocks {
    param([string]$Content)
    # Remove ```mermaid ... ``` blocks and replace with placeholder
    $Content = $Content -replace '(?s)```mermaid\r?\n.*?```', '[Diagram - See rendered image above or refer to source document]'
    return $Content
}

# Function to remove ALL ASCII art wireframes - both Unicode and standard ASCII
function Clean-AsciiArt {
    param([string]$Content)

    # Remove Unicode box-drawing characters
    $Content = $Content -replace '[\u2500-\u257F]+', ''
    $Content = $Content -replace '[\u2550-\u256C]+', ''
    $Content = $Content -replace '[\u25A0-\u25FF]+', ''
    $Content = $Content -replace '[\u2190-\u21FF]+', ''

    # Remove standard ASCII wireframe boxes (lines with +, -, |, etc.)
    # Remove lines that are primarily box characters
    $Content = $Content -replace '(?m)^\s*[\+\-\|]+[\+\-\|\s]*$', ''
    # Remove box corner/edge patterns
    $Content = $Content -replace '(?m)^\s*\|[^\|]*\|\s*$', ''
    # Remove lines starting with | that look like box sides
    $Content = $Content -replace '(?m)^\s*\|.*\|\s*$', ''

    # Remove entire ```wireframe``` or ```ascii``` code blocks
    $Content = $Content -replace '(?s)```(?:wireframe|ascii|text)?\r?\n[\s\S]*?(?:\+[-\+]+\+|[\u2500-\u257F])[\s\S]*?```', '[See screenshot for UI layout]'

    # Remove standalone wireframe sections (multiple consecutive box lines)
    $Content = $Content -replace '(?s)(\+[-\+]+\+[\s\S]*?)+\+[-\+]+\+', '[See screenshot for UI layout]'

    # Clean up resulting empty code blocks
    $Content = $Content -replace '(?s)```\s*```', ''
    # Clean up multiple consecutive blank lines
    $Content = $Content -replace '(\r?\n){4,}', "`n`n`n"
    # Clean up multiple consecutive placeholders
    $Content = $Content -replace '(\[See screenshot for UI layout\]\s*)+', ('[See screenshot for UI layout]' + "`n`n")

    return $Content
}

# Master content cleaning function
function Clean-Content {
    param([string]$Content, [string]$SourceFolder)
    $Content = Rewrite-ImagePaths -Content $Content -SourceFolder $SourceFolder
    $Content = Remove-MermaidBlocks -Content $Content
    $Content = Clean-AsciiArt -Content $Content
    return $Content
}

# Build content in memory to avoid file locking issues
$script:CompiledContent = @"
# NewPOPSys Software Requirements Specification

**Version:** 1.38
**Date:** 2026-01-01
**Status:** Final Draft
**Classification:** Internal - Confidential

---

"@

Write-Host "Compiling NewPOPSys SRS v1.38 (Clean PDF Mode)..." -ForegroundColor Cyan

# Function to append file with section header
function Append-Section {
    param([string]$Path, [string]$SectionName)
    if (Test-Path $Path) {
        $script:CompiledContent += $PageBreak
        $content = Get-Content -Path $Path -Raw
        $content = Clean-Content -Content $content -SourceFolder "."
        $script:CompiledContent += $content
        Write-Host "  Added: $Path" -ForegroundColor Green
    } else {
        Write-Host "  Skipped (not found): $Path" -ForegroundColor Yellow
    }
}

# Function to append all MD files in a folder
function Append-Folder {
    param([string]$Folder, [string]$SectionName)
    if (Test-Path $Folder) {
        $script:CompiledContent += $PageBreak
        $script:CompiledContent += "# $SectionName`n"
        Get-ChildItem -Path $Folder -Filter "*.md" | Sort-Object Name | ForEach-Object {
            $content = Get-Content -Path $_.FullName -Raw
            $content = Clean-Content -Content $content -SourceFolder $Folder
            $script:CompiledContent += $content
            $script:CompiledContent += "`n`n---`n"
            Write-Host "  Added: $($_.Name)" -ForegroundColor Green
        }
    }
}

# Function to append module with overview first, then screens
function Append-Module {
    param([string]$ModuleFolder, [string]$ModuleName)
    if (Test-Path $ModuleFolder) {
        $script:CompiledContent += $PageBreak
        $script:CompiledContent += "# $ModuleName`n"

        # Overview first
        $overview = Join-Path $ModuleFolder "01_Module_Overview.md"
        if (Test-Path $overview) {
            $content = Get-Content -Path $overview -Raw
            $content = Clean-Content -Content $content -SourceFolder $ModuleFolder
            $script:CompiledContent += $content
            Write-Host "  Added: $ModuleName Overview" -ForegroundColor Green
        }

        # Then screens
        $screensFolder = Join-Path $ModuleFolder "screens"
        if (Test-Path $screensFolder) {
            Get-ChildItem -Path $screensFolder -Filter "*.md" | Sort-Object Name | ForEach-Object {
                $script:CompiledContent += "`n`n---`n"
                $content = Get-Content -Path $_.FullName -Raw
                $content = Clean-Content -Content $content -SourceFolder $screensFolder
                $script:CompiledContent += $content
                Write-Host "  Added: $($_.Name)" -ForegroundColor Green
            }
        }
    }
}

# Front Matter
Append-Section "00_Executive_Summary.md" "Executive Summary"
Append-Section "00_Table_of_Contents.md" "Table of Contents"

# Section 1-4
Append-Folder "01_Introduction" "Section 1: Introduction"
Append-Folder "02_Overall_Description" "Section 2: Overall Description"
Append-Folder "03_System_Architecture" "Section 3: System Architecture"
Append-Folder "04_User_Personas_RBAC" "Section 4: User Personas & RBAC"

# Modules 5-10
Append-Module "05_Module_SharedFoundations" "Section 5: Shared Foundations Module"
Append-Module "06_Module_MobilePWA" "Section 6: Mobile PWA Module"
Append-Module "07_Module_BrandAdmin" "Section 7: Brand Admin Module"
Append-Module "08_Module_PSPOperations" "Section 8: PSP Operations Module"
Append-Module "09_Module_StorePortal" "Section 9: Store Portal Module"
Append-Module "10_Module_PlatformAdmin" "Section 10: Platform Admin Module"

# Sections 11-12 and Appendices
Append-Folder "11_API_Specifications" "Section 11: API Specifications"
Append-Folder "12_Non_Functional_Requirements" "Section 12: Non-Functional Requirements"
Append-Folder "99_Appendices" "Appendices"

# Footer
$script:CompiledContent += "`n`n---`n`n**End of Document - NewPOPSys SRS v1.38**"

# Write all content at once to avoid file locking issues
Write-Host "`nWriting compiled output..." -ForegroundColor Yellow
$script:CompiledContent | Out-File -FilePath $OutputFile -Encoding UTF8 -Force

$lineCount = (Get-Content $OutputFile).Count
Write-Host "`nCompilation complete!" -ForegroundColor Cyan
Write-Host "Output: $OutputFile ($lineCount lines)" -ForegroundColor Green
