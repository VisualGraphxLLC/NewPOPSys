const playwright = require('playwright');
const fs = require('fs');
const path = require('path');

async function run() {
    const browser = await playwright.chromium.launch();
    const page = await browser.newPage();
    const files = [
        'admin_portal.html',
        'autocoder.html',
        'index.html',
        'store_execution.html',
        'psp_admin.html',
        'psp_ops.html',
        'regional_dashboard.html',
        'store_portal.html',
        'store_surveys.html'
    ];
    const outputDir = 'E:\\Docker\\PopSystem\\SOW\\07_Dev_Plan\\screenshots';
    
    if (!fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    for (const file of files) {
        console.log(`Taking screenshot of ${file}...`);
        await page.goto(`http://localhost:8080/${file}`, { waitUntil: 'networkidle' });
        await page.screenshot({ path: path.join(outputDir, `${file.replace('.html', '')}.png`), fullPage: true });
    }

    await browser.close();
}

run().catch(err => {
    console.error(err);
    process.exit(1);
});
