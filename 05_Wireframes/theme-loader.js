/**
 * Theme Loader for NewPOPSys Wireframes
 * Handles: Brand themes, Dark Mode, High Contrast, and Logos
 */

(function() {
    // Brand theme definitions with logo paths
    const themes = {
        default: { name: 'NewPOPSys', logo: 'logos/newpopsys-logo.svg' },
        shelfsync: { name: 'ShelfSync', logo: 'logos/shelfsync-logo.svg' },
        merchpulse: { name: 'MerchPulse', logo: 'logos/merchpulse-logo.svg' },
        fieldforge: { name: 'FieldForge', logo: 'logos/fieldforge-logo.svg' },
        nexova: { name: 'Nexova', logo: 'logos/nexova-logo.svg' },
        prism: { name: 'PRISM', logo: 'logos/prism-logo.svg' }
    };

    // Apply brand theme to document
    function applyTheme(themeName) {
        const theme = themes[themeName] || themes.default;

        if (themeName && themeName !== 'default') {
            document.documentElement.setAttribute('data-theme', themeName);
        } else {
            document.documentElement.removeAttribute('data-theme');
        }
        localStorage.setItem('selectedTheme', themeName || 'default');

        // Update selector if it exists
        const selector = document.getElementById('theme-select');
        if (selector) {
            selector.value = themeName || 'default';
        }

        // Update logo if container exists
        const logoContainer = document.getElementById('brand-logo');
        if (logoContainer) {
            logoContainer.innerHTML = `<img src="${theme.logo}" alt="${theme.name}" style="height: 32px; width: auto;">`;
        }

        // Update brand name if element exists
        const brandName = document.getElementById('brand-name');
        if (brandName) {
            brandName.textContent = theme.name;
        }
    }

    // Apply appearance mode (light/dark/high-contrast)
    function applyAppearance(mode) {
        document.documentElement.removeAttribute('data-appearance');
        document.body.classList.remove('dark-mode', 'high-contrast');

        if (mode === 'dark') {
            document.documentElement.setAttribute('data-appearance', 'dark');
            document.body.classList.add('dark-mode');
        } else if (mode === 'high-contrast') {
            document.documentElement.setAttribute('data-appearance', 'high-contrast');
            document.body.classList.add('high-contrast');
        }
        localStorage.setItem('appearanceMode', mode || 'light');

        // Update selector if exists
        const selector = document.getElementById('appearance-select');
        if (selector) {
            selector.value = mode || 'light';
        }
    }

    // Inject appearance CSS if not already present
    function injectAppearanceCSS() {
        if (document.getElementById('appearance-styles')) return;

        const style = document.createElement('style');
        style.id = 'appearance-styles';
        style.textContent = `
            /* Dark Mode */
            [data-appearance="dark"] {
                --bg-primary: #1a1a2e;
                --bg-secondary: #16213e;
                --bg-card: #0f3460;
                --text-primary: #ffffff;
                --text-secondary: #a0aec0;
                --border-color: #2d3748;
            }
            body.dark-mode {
                background-color: #1a1a2e !important;
                color: #ffffff !important;
            }
            body.dark-mode .bg-white {
                background-color: #16213e !important;
            }
            body.dark-mode .bg-gray-50,
            body.dark-mode .bg-gray-100 {
                background-color: #1a1a2e !important;
            }
            body.dark-mode .bg-gray-200 {
                background-color: #2d3748 !important;
            }
            body.dark-mode .text-gray-900,
            body.dark-mode .text-gray-800,
            body.dark-mode .text-gray-700 {
                color: #ffffff !important;
            }
            body.dark-mode .text-gray-600,
            body.dark-mode .text-gray-500 {
                color: #a0aec0 !important;
            }
            body.dark-mode .border-gray-200,
            body.dark-mode .border-gray-300 {
                border-color: #2d3748 !important;
            }
            body.dark-mode nav.bg-white {
                background-color: #16213e !important;
                border-color: #2d3748 !important;
            }
            body.dark-mode .shadow-sm,
            body.dark-mode .shadow {
                box-shadow: 0 1px 3px rgba(0,0,0,0.5) !important;
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
            body.high-contrast .bg-gray-100 {
                background-color: #000000 !important;
            }
            body.high-contrast .text-gray-900,
            body.high-contrast .text-gray-800,
            body.high-contrast .text-gray-700,
            body.high-contrast .text-gray-600,
            body.high-contrast .text-gray-500 {
                color: #ffffff !important;
            }
            body.high-contrast .border-gray-200,
            body.high-contrast .border-gray-300 {
                border-color: #ffffff !important;
                border-width: 2px !important;
            }
            body.high-contrast nav {
                background-color: #000000 !important;
                border-color: #ffffff !important;
                border-width: 2px !important;
            }
            body.high-contrast a,
            body.high-contrast button {
                text-decoration: underline !important;
            }
            body.high-contrast .shadow-sm,
            body.high-contrast .shadow {
                box-shadow: 0 0 0 2px #ffffff !important;
            }
        `;
        document.head.appendChild(style);
    }

    // Load saved settings immediately
    function loadSettings() {
        injectAppearanceCSS();
        const savedTheme = localStorage.getItem('selectedTheme') || 'default';
        const savedAppearance = localStorage.getItem('appearanceMode') || 'light';
        applyTheme(savedTheme);
        applyAppearance(savedAppearance);
    }

    // Add controls to the Interactive Mode banner
    function addControlsToBanner() {
        const banner = document.querySelector('.tooltip-help-banner');
        if (!banner) return;

        // Check if already added
        if (document.getElementById('theme-select')) return;

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
                ">
                    <option value="default" style="color: #333;">NewPOPSys</option>
                    <option value="shelfsync" style="color: #333;">ShelfSync</option>
                    <option value="merchpulse" style="color: #333;">MerchPulse</option>
                    <option value="fieldforge" style="color: #333;">FieldForge</option>
                    <option value="nexova" style="color: #333;">Nexova</option>
                    <option value="prism" style="color: #333;">PRISM</option>
                </select>
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
                    <option value="light" style="color: #333;">Light</option>
                    <option value="dark" style="color: #333;">Dark</option>
                    <option value="high-contrast" style="color: #333;">High Contrast</option>
                </select>
            </div>
        `;

        // Append to banner
        banner.appendChild(container);

        // Set current values and add change handlers
        const themeSelect = document.getElementById('theme-select');
        themeSelect.value = localStorage.getItem('selectedTheme') || 'default';
        themeSelect.addEventListener('change', function() {
            applyTheme(this.value);
        });

        const appearanceSelect = document.getElementById('appearance-select');
        appearanceSelect.value = localStorage.getItem('appearanceMode') || 'light';
        appearanceSelect.addEventListener('change', function() {
            applyAppearance(this.value);
        });
    }

    // Update logo on page load
    function updateLogoOnLoad() {
        const savedTheme = localStorage.getItem('selectedTheme') || 'default';
        const theme = themes[savedTheme] || themes.default;

        const logoContainer = document.getElementById('brand-logo');
        if (logoContainer) {
            logoContainer.innerHTML = `<img src="${theme.logo}" alt="${theme.name}" style="height: 32px; width: auto;">`;
        }

        const brandName = document.getElementById('brand-name');
        if (brandName) {
            brandName.textContent = theme.name;
        }
    }

    // Run immediately
    loadSettings();

    // Add controls and update logo when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            addControlsToBanner();
            updateLogoOnLoad();
        });
    } else {
        addControlsToBanner();
        updateLogoOnLoad();
    }

    // Expose for external use
    window.setTheme = applyTheme;
    window.setAppearance = applyAppearance;
    window.themes = themes;
})();
