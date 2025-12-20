/**
 * Theme Loader for NewPOPSys Wireframes
 * Handles: Brand themes, Dark Mode, High Contrast, and Logos
 * Works on both index.html and portal pages
 */

(function() {
    'use strict';

    // Wait for theme-config.js to load, or use fallback
    function getConfig() {
        if (window.THEME_CONFIG) {
            return window.THEME_CONFIG;
        }
        // Fallback config if theme-config.js hasn't loaded
        return {
            brands: {
                default: { name: 'NewPOPSys', logo: 'logos/newpopsys-logo.svg', colors: { primary: '#1e3a5f', primaryLight: '#2d5a87', primaryDark: '#0f1f33', accent: '#3b82f6', accentLight: '#60a5fa', textOnPrimary: '#ffffff' } },
                shelfsync: { name: 'ShelfSync', logo: 'logos/shelfsync-logo.svg', colors: { primary: '#012D3A', primaryLight: '#00ABB9', primaryDark: '#011820', accent: '#FCD732', accentLight: '#FDE68A', textOnPrimary: '#ffffff' } },
                merchpulse: { name: 'MerchPulse', logo: 'logos/merchpulse-logo.svg', colors: { primary: '#5B21B6', primaryLight: '#7C3AED', primaryDark: '#3B0F7A', accent: '#F59E0B', accentLight: '#FBBF24', textOnPrimary: '#ffffff' } },
                fieldforge: { name: 'FieldForge', logo: 'logos/fieldforge-logo.svg', colors: { primary: '#1E40AF', primaryLight: '#3B82F6', primaryDark: '#1E3A8A', accent: '#10B981', accentLight: '#34D399', textOnPrimary: '#ffffff' } },
                nexova: { name: 'Nexova', logo: 'logos/nexova-logo.svg', colors: { primary: '#0F172A', primaryLight: '#334155', primaryDark: '#020617', accent: '#06B6D4', accentLight: '#22D3EE', textOnPrimary: '#ffffff' } },
                prism: { name: 'PRISM', logo: 'logos/prism-logo.svg', colors: { primary: '#18181B', primaryLight: '#3F3F46', primaryDark: '#09090B', accent: '#14B8A6', accentLight: '#2DD4BF', textOnPrimary: '#ffffff' } }
            }
        };
    }

    // Generate and inject all theme CSS
    function injectThemeCSS() {
        if (document.getElementById('theme-system-styles')) return;

        const config = getConfig();
        let css = '';

        // Generate CSS for each brand theme
        Object.keys(config.brands).forEach(themeName => {
            const theme = config.brands[themeName];
            const selector = themeName === 'default' ? ':root' : `[data-theme="${themeName}"]`;
            css += `
                ${selector} {
                    --primary: ${theme.colors.primary};
                    --primary-light: ${theme.colors.primaryLight};
                    --primary-dark: ${theme.colors.primaryDark};
                    --accent: ${theme.colors.accent};
                    --accent-light: ${theme.colors.accentLight};
                    --text-on-primary: ${theme.colors.textOnPrimary};
                    --text-muted: ${theme.colors.textMuted || '#94a3b8'};
                }
            `;
        });

        // Dark mode styles - respects brand colors
        css += `
            /* Dark Mode - Respects Brand Theme Colors */
            [data-appearance="dark"] {
                --bg-primary: #1a1a2e;
                --bg-secondary: #16213e;
                --bg-card: #1e293b;
                --text-primary: #ffffff;
                --text-secondary: #a0aec0;
                --border-color: #334155;
            }

            body.dark-mode {
                background-color: #0f172a !important;
                color: #e2e8f0 !important;
            }

            body.dark-mode .bg-white {
                background-color: #1e293b !important;
            }

            body.dark-mode .bg-gray-50,
            body.dark-mode .bg-gray-100 {
                background-color: #0f172a !important;
            }

            body.dark-mode .bg-gray-200 {
                background-color: #334155 !important;
            }

            body.dark-mode .text-gray-900,
            body.dark-mode .text-gray-800,
            body.dark-mode .text-gray-700 {
                color: #f1f5f9 !important;
            }

            body.dark-mode .text-gray-600,
            body.dark-mode .text-gray-500 {
                color: #94a3b8 !important;
            }

            body.dark-mode .text-gray-400 {
                color: #64748b !important;
            }

            body.dark-mode .border-gray-200,
            body.dark-mode .border-gray-300 {
                border-color: #334155 !important;
            }

            body.dark-mode nav.bg-white,
            body.dark-mode nav {
                background-color: #1e293b !important;
                border-color: #334155 !important;
            }

            body.dark-mode .shadow-sm,
            body.dark-mode .shadow {
                box-shadow: 0 1px 3px rgba(0,0,0,0.4) !important;
            }

            /* Dark mode for persona cards and module boxes */
            body.dark-mode .bg-yellow-50,
            body.dark-mode .bg-purple-50,
            body.dark-mode .bg-blue-50,
            body.dark-mode .bg-teal-50,
            body.dark-mode .bg-green-50 {
                background-color: #1e293b !important;
            }

            body.dark-mode .bg-yellow-100,
            body.dark-mode .bg-purple-100,
            body.dark-mode .bg-blue-100,
            body.dark-mode .bg-teal-100 {
                background-color: #334155 !important;
            }

            body.dark-mode .border-yellow-200,
            body.dark-mode .border-purple-200,
            body.dark-mode .border-blue-200,
            body.dark-mode .border-teal-200 {
                border-color: #475569 !important;
            }

            /* Keep theme accent colors working in dark mode */
            body.dark-mode .gradient-hero {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 50%, var(--primary) 100%);
            }

            /* Theme dropdown styles for dark mode */
            body.dark-mode .theme-dropdown,
            body.dark-mode .appearance-dropdown {
                background: #1e293b !important;
                border: 1px solid #334155;
            }

            body.dark-mode .theme-option:hover,
            body.dark-mode .appearance-option:hover {
                background: #334155 !important;
            }

            body.dark-mode .theme-option .text-gray-900,
            body.dark-mode .theme-option .font-medium {
                color: #f1f5f9 !important;
            }

            body.dark-mode .theme-option .text-gray-500,
            body.dark-mode .theme-option .text-xs {
                color: #94a3b8 !important;
            }

            /* High Contrast Mode */
            [data-appearance="high-contrast"] {
                --bg-primary: #000000;
                --bg-secondary: #000000;
                --text-primary: #ffffff;
                --border-color: #ffffff;
            }

            body.high-contrast {
                background-color: #000000 !important;
                color: #ffffff !important;
            }

            body.high-contrast .bg-white,
            body.high-contrast .bg-gray-50,
            body.high-contrast .bg-gray-100,
            body.high-contrast .bg-gray-200 {
                background-color: #000000 !important;
            }

            body.high-contrast .text-gray-900,
            body.high-contrast .text-gray-800,
            body.high-contrast .text-gray-700,
            body.high-contrast .text-gray-600,
            body.high-contrast .text-gray-500,
            body.high-contrast .text-gray-400 {
                color: #ffffff !important;
            }

            body.high-contrast .border-gray-200,
            body.high-contrast .border-gray-300,
            body.high-contrast .border {
                border-color: #ffffff !important;
                border-width: 2px !important;
            }

            body.high-contrast nav {
                background-color: #000000 !important;
                border-color: #ffffff !important;
                border-width: 2px !important;
            }

            body.high-contrast a:not(.bg-purple-600):not(.bg-yellow-600):not(.bg-blue-600):not(.bg-teal-600),
            body.high-contrast button:not(.tooltip-toggle) {
                text-decoration: underline !important;
            }

            body.high-contrast .shadow-sm,
            body.high-contrast .shadow {
                box-shadow: 0 0 0 2px #ffffff !important;
            }

            /* High contrast keeps brand accent colors visible */
            body.high-contrast .gradient-hero {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 50%, var(--primary) 100%);
            }

            /* High contrast module cards */
            body.high-contrast .bg-yellow-50,
            body.high-contrast .bg-purple-50,
            body.high-contrast .bg-blue-50,
            body.high-contrast .bg-teal-50,
            body.high-contrast .bg-green-50,
            body.high-contrast .bg-yellow-100,
            body.high-contrast .bg-purple-100,
            body.high-contrast .bg-blue-100,
            body.high-contrast .bg-teal-100 {
                background-color: #000000 !important;
                border: 2px solid #ffffff !important;
            }
        `;

        const style = document.createElement('style');
        style.id = 'theme-system-styles';
        style.textContent = css;
        document.head.appendChild(style);
    }

    // Apply brand theme
    function applyTheme(themeName) {
        const config = getConfig();
        const theme = config.brands[themeName] || config.brands.default;
        const effectiveTheme = themeName || 'default';

        // Set data-theme attribute
        if (effectiveTheme !== 'default') {
            document.documentElement.setAttribute('data-theme', effectiveTheme);
        } else {
            document.documentElement.removeAttribute('data-theme');
        }

        // Store preference
        localStorage.setItem('selectedTheme', effectiveTheme);

        // Update UI elements if they exist
        updateThemeUI(effectiveTheme, theme);
    }

    // Update all theme-related UI elements
    function updateThemeUI(themeName, theme) {
        const config = getConfig();
        theme = theme || config.brands[themeName] || config.brands.default;

        // Update brand name text
        const brandName = document.getElementById('brand-name');
        if (brandName) {
            brandName.textContent = theme.name || theme.shortName;
        }

        // Update logo - detect if nav bar is dark and use appropriate logo
        const logoContainer = document.getElementById('brand-logo');
        if (logoContainer) {
            // Detect if nav bar has a colored/dark background
            const nav = document.querySelector('nav');
            const needsLightLogo = nav && !nav.classList.contains('bg-white');

            // Also check appearance mode - dark mode needs light logo
            const appearanceMode = localStorage.getItem('appearanceMode') || 'light';
            const useLightLogo = needsLightLogo || appearanceMode === 'dark' || appearanceMode === 'high-contrast';

            const logoSrc = useLightLogo && theme.logoLight ? theme.logoLight : theme.logo;
            if (logoSrc) {
                logoContainer.innerHTML = `<img src="${logoSrc}" alt="${theme.name}" style="height: 32px; width: auto;">`;
            }
        }

        // Update nav logo (index.html uses inline svg)
        const navLogo = document.getElementById('nav-logo');
        if (navLogo && theme.logoSvg) {
            navLogo.outerHTML = theme.logoSvg.replace('viewBox="0 0 32 32"', 'id="nav-logo" viewBox="0 0 32 32"');
        }

        // Update page title
        document.title = `${theme.name || theme.shortName} - Stakeholder Review`;

        // Update hero title if exists
        const heroTitle = document.querySelector('#overview h1');
        if (heroTitle) {
            heroTitle.textContent = theme.name || theme.shortName;
        }

        // Update dropdown active states
        document.querySelectorAll('.theme-option').forEach(opt => {
            opt.classList.toggle('active', opt.dataset.theme === themeName);
        });

        // Update banner select if exists
        const themeSelect = document.getElementById('theme-select');
        if (themeSelect) {
            themeSelect.value = themeName;
        }
    }

    // Apply appearance mode
    function applyAppearance(mode) {
        const effectiveMode = mode || 'light';

        // Remove old appearance
        document.documentElement.removeAttribute('data-appearance');
        if (document.body) {
            document.body.classList.remove('dark-mode', 'high-contrast');
        }

        // Apply new appearance
        if (effectiveMode === 'dark') {
            document.documentElement.setAttribute('data-appearance', 'dark');
            if (document.body) document.body.classList.add('dark-mode');
        } else if (effectiveMode === 'high-contrast') {
            document.documentElement.setAttribute('data-appearance', 'high-contrast');
            if (document.body) document.body.classList.add('high-contrast');
        }

        // Store preference
        localStorage.setItem('appearanceMode', effectiveMode);

        // Update UI elements
        updateAppearanceUI(effectiveMode);

        // Update logo based on new appearance mode
        const savedTheme = localStorage.getItem('selectedTheme') || 'default';
        updateThemeUI(savedTheme);
    }

    // Update appearance UI elements
    function updateAppearanceUI(mode) {
        // Update dropdown active states
        document.querySelectorAll('.appearance-option').forEach(opt => {
            opt.classList.toggle('active', opt.dataset.mode === mode);
        });

        // Update banner select if exists
        const appearanceSelect = document.getElementById('appearance-select');
        if (appearanceSelect) {
            appearanceSelect.value = mode;
        }
    }

    // Add controls to the Interactive Mode banner (for portal pages)
    function addControlsToBanner() {
        const banner = document.querySelector('.tooltip-help-banner');
        if (!banner || document.getElementById('theme-select')) return;

        const config = getConfig();
        const savedTheme = localStorage.getItem('selectedTheme') || 'default';
        const savedAppearance = localStorage.getItem('appearanceMode') || 'light';

        // Build brand options
        let brandOptions = '';
        Object.keys(config.brands).forEach(key => {
            const brand = config.brands[key];
            const selected = key === savedTheme ? 'selected' : '';
            brandOptions += `<option value="${key}" ${selected} style="color: #333;">${brand.name || brand.shortName}</option>`;
        });

        // Create controls container
        const container = document.createElement('div');
        container.style.cssText = `
            display: flex;
            align-items: center;
            gap: 16px;
            margin-left: 24px;
            padding-left: 24px;
            border-left: 1px solid rgba(255,255,255,0.3);
        `;

        container.innerHTML = `
            <div style="display: flex; align-items: center; gap: 6px;">
                <span style="font-size: 11px; opacity: 0.8;">Brand:</span>
                <select id="theme-select" style="
                    background: rgba(255,255,255,0.2);
                    border: 1px solid rgba(255,255,255,0.4);
                    color: white;
                    padding: 3px 6px;
                    border-radius: 4px;
                    font-size: 11px;
                    cursor: pointer;
                    font-weight: 600;
                ">${brandOptions}</select>
            </div>
            <div style="display: flex; align-items: center; gap: 6px;">
                <span style="font-size: 11px; opacity: 0.8;">Mode:</span>
                <select id="appearance-select" style="
                    background: rgba(255,255,255,0.2);
                    border: 1px solid rgba(255,255,255,0.4);
                    color: white;
                    padding: 3px 6px;
                    border-radius: 4px;
                    font-size: 11px;
                    cursor: pointer;
                    font-weight: 600;
                ">
                    <option value="light" ${savedAppearance === 'light' ? 'selected' : ''} style="color: #333;">Light</option>
                    <option value="dark" ${savedAppearance === 'dark' ? 'selected' : ''} style="color: #333;">Dark</option>
                    <option value="high-contrast" ${savedAppearance === 'high-contrast' ? 'selected' : ''} style="color: #333;">High Contrast</option>
                </select>
            </div>
        `;

        banner.appendChild(container);

        // Add event listeners
        document.getElementById('theme-select').addEventListener('change', function() {
            applyTheme(this.value);
        });

        document.getElementById('appearance-select').addEventListener('change', function() {
            applyAppearance(this.value);
        });
    }

    // Initialize on load
    function init() {
        injectThemeCSS();

        const savedTheme = localStorage.getItem('selectedTheme') || 'default';
        const savedAppearance = localStorage.getItem('appearanceMode') || 'light';

        applyTheme(savedTheme);
        applyAppearance(savedAppearance);
    }

    // Run immediately for CSS injection
    init();

    // DOM-dependent initialization
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            // Re-apply with body available
            const savedAppearance = localStorage.getItem('appearanceMode') || 'light';
            applyAppearance(savedAppearance);

            // Update UI
            const savedTheme = localStorage.getItem('selectedTheme') || 'default';
            updateThemeUI(savedTheme);

            // Add banner controls for portal pages
            addControlsToBanner();
        });
    } else {
        const savedAppearance = localStorage.getItem('appearanceMode') || 'light';
        applyAppearance(savedAppearance);
        addControlsToBanner();
    }

    // Expose API for external use
    window.setTheme = applyTheme;
    window.setAppearance = applyAppearance;
    window.getThemeConfig = getConfig;

})();
