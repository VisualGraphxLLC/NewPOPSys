# Wireframe Hosting Setup Guide

This document explains how to host the HTML wireframes so they're navigable via a public URL.

## Recommended: Netlify (Quickest)

### One-Time Quick Deploy (No Account)
1. Go to [netlify.com/drop](https://netlify.com/drop)
2. Drag and drop this entire `05_Wireframes` folder onto the page
3. Get an instant shareable URL

### Persistent Deploy with Auto-Updates

1. **Install Netlify CLI**
   ```bash
   npm install -g netlify-cli
   ```

2. **Login to Netlify**
   ```bash
   netlify login
   ```

3. **Initialize the site (first time only)**
   ```bash
   cd "I:\Shared drives\VG Development\PopSystem\SOW\05_Wireframes"
   netlify init
   ```
   - Choose "Create & configure a new site"
   - Select your team
   - Give it a name (e.g., `popsystem-wireframes`)

4. **Deploy updates**
   ```bash
   cd "I:\Shared drives\VG Development\PopSystem\SOW\05_Wireframes"
   netlify deploy --prod
   ```

---

## Alternative: GitHub Pages

### Initial Setup

1. **Initialize Git repo**
   ```bash
   cd "I:\Shared drives\VG Development\PopSystem\SOW\05_Wireframes"
   git init
   git add .
   git commit -m "Initial wireframes"
   ```

2. **Create GitHub repo**
   - Go to github.com → New Repository
   - Name it (e.g., `popsystem-wireframes`)
   - Keep it public (required for free GitHub Pages) or use private with GitHub Pro
   - Don't initialize with README

3. **Push to GitHub**
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/popsystem-wireframes.git
   git branch -M main
   git push -u origin main
   ```

4. **Enable GitHub Pages**
   - Go to repo Settings → Pages
   - Source: Deploy from branch
   - Branch: `main`, folder: `/ (root)`
   - Save

5. **Access your site**
   - URL will be: `https://YOUR_USERNAME.github.io/popsystem-wireframes/`
   - Takes 1-2 minutes to build initially

### Updating the Wireframes

After making changes to the HTML files:

```bash
cd "I:\Shared drives\VG Development\PopSystem\SOW\05_Wireframes"
git add .
git commit -m "Update wireframes"
git push
```

GitHub Pages will auto-rebuild within 1-2 minutes.

---

## Alternative: Simple Local Server (For Team on Same Network)

If you just need to share with teammates locally:

```bash
cd "I:\Shared drives\VG Development\PopSystem\SOW\05_Wireframes"
npx serve
```

Share the displayed URL (e.g., `http://192.168.1.100:3000`) with your team.

---

## Notes

- **Shared Drive Caveat**: Git can have sync issues on Google Shared Drives. If you experience problems, consider keeping the Git repo on a local drive and copying files to the shared drive.
- **Private Access**: If you need password protection, Netlify offers this on paid plans, or you can use Vercel with similar features.

## Current Hosting Status

- [x] Hosted on: GitHub Pages
- [x] URL: https://cderamos-2ct.github.io/NewPOPSys/
- [x] Last deployed: 2025-12-19
