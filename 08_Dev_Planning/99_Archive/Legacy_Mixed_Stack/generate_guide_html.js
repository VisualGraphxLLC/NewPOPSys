const fs = require('fs');
const path = require('path');

const rootDir = __dirname;
const outputFile = path.join(rootDir, 'DEV_GUIDE_BOOK.html');

const filesToInclude = [
    'README.md',
    '01_Master_Plan/MASTER_DEVELOPMENT_PLAN.md',
    '02_Sprint_Roadmap/SPRINT_ROADMAP.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S0_Foundation.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S1_Auth_CoreUI.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S2_Mobile_Core.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S3_Brand_Portal.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S4_PSP_Portal.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S5_Store_Integration.md',
    '02_Sprint_Roadmap/Sprints/SPRINT_S6_Launch.md',
    '03_Technical_Specs/AI_DEVELOPMENT_HARNESS.md',
    '03_Technical_Specs/TECH_STACK_DECISIONS.md',
    '03_Technical_Specs/ARCHITECTURE_OVERVIEW.md',
    '05_Agile_Suite/TESTING_STRATEGY.md'
];

let htmlContent = `
<!DOCTYPE html>
<html>
<head>
    <title>PopSystem Dev Guide v1.38</title>
    <style>
        body { font-family: system-ui, -apple-system, sans-serif; line-height: 1.6; max-width: 900px; margin: 0 auto; padding: 40px; color: #333; }
        h1, h2, h3 { color: #111; margin-top: 2em; }
        h1 { border-bottom: 2px solid #eee; padding-bottom: 10px; }
        code { background: #f4f4f4; padding: 2px 5px; border-radius: 4px; }
        pre { background: #f4f4f4; padding: 15px; border-radius: 8px; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f8f9fa; }
        .page-break { page-break-before: always; }
        @media print { .page-break { page-break-before: always; } body { padding: 0; } }
    </style>
</head>
<body>
    <div style="text-align: center; padding: 100px 0;">
        <h1>PopSystem Development Guide</h1>
        <h2>Version 1.38 (Generated)</h2>
        <p>${new Date().toISOString().split('T')[0]}</p>
    </div>
    <div class="page-break"></div>
`;

function simpleMarkdownToHtml(markdown) {
    // Very basic MD parser for structure
    let html = markdown
        .replace(/^# (.*$)/gm, '<h1>$1</h1>')
        .replace(/^## (.*$)/gm, '<h2>$1</h2>')
        .replace(/^### (.*$)/gm, '<h3>$1</h3>')
        .replace(/^#### (.*$)/gm, '<h4>$1</h4>')
        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
        .replace(/`(.*?)`/g, '<code>$1</code>')
        .replace(/\[(.*?)\]\((.*?)\)/g, '<a href="$2">$1</a>')
        .replace(/\n\n/g, '<br><br>');
    
    // Convert Tables (simplified)
    html = html.replace(/\|(.+)\|/g, (match) => {
        const cells = match.split('|').filter(c => c.trim() !== '');
        return '<tr>' + cells.map(c => `<td>${c.trim()}</td>`).join('') + '</tr>';
    });
    // Wrap rows in table (hacky but works for print)
    html = html.replace(/(<tr>.*?<\/tr>)\s*(<tr>)/g, '$1$2'); // merge rows
    // This table mapping is too fragile for regex, avoiding full table parsing 
    // Instead just wrapping pre-blocks for code
    html = html.replace(/```([\s\S]*?)```/g, '<pre>$1</pre>');
    
    return html;
}

filesToInclude.forEach(file => {
    const fullPath = path.join(rootDir, file);
    if (fs.existsSync(fullPath)) {
        const content = fs.readFileSync(fullPath, 'utf8');
        htmlContent += `<div class="section">`;
        // Inject a simpler MD-to-HTML or just raw text wrapped in pre for now if robust parsing is hard
        // But let's try to make it readable.
        // Actually, just wrapping in <pre> preserves formatting perfectly for "Validation" purposes.
        // But User wants "PDF like SRS". SRS was decent.
        // Let's use a very simple structure.
        
        htmlContent += `<h1 style="color:blue; border-top: 5px solid blue; padding-top:20px;">DOC: ${file}</h1>`;
        htmlContent += `<pre style="white-space: pre-wrap; font-family: monospace;">${content}</pre>`; 
        htmlContent += `</div><div class="page-break"></div>`;
    } else {
        console.warn(`Missing file: ${file}`);
    }
});

htmlContent += `</body></html>`;

fs.writeFileSync(outputFile, htmlContent);
console.log(`Generated ${outputFile}`);
