/**
 * Theme Loader for NewPOPSys Wireframes
 * Loads saved theme from localStorage and adds theme selector to Interactive Mode banner
 */

(function() {
    // Theme definitions
    const themes = {
        default: { name: 'NewPOPSys' },
        shelfsync: { name: 'ShelfSync' },
        merchpulse: { name: 'MerchPulse' },
        fieldforge: { name: 'FieldForge' },
        nexova: { name: 'Nexova' },
        prism: { name: 'PRISM' }
    };

    // Apply theme to document
    function applyTheme(themeName) {
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
    }

    // Load saved theme immediately
    function loadTheme() {
        const savedTheme = localStorage.getItem('selectedTheme') || 'default';
        applyTheme(savedTheme);
    }

    // Add theme selector to the Interactive Mode banner
    function addThemeSelectorToBanner() {
        const banner = document.querySelector('.tooltip-help-banner');
        if (!banner) return;

        // Check if already added
        if (document.getElementById('theme-select')) return;

        // Create theme selector container
        const container = document.createElement('div');
        container.style.cssText = `
            display: flex;
            align-items: center;
            gap: 8px;
            margin-left: 24px;
            padding-left: 24px;
            border-left: 1px solid rgba(255,255,255,0.3);
        `;

        container.innerHTML = `
            <span style="font-size: 12px; opacity: 0.9;">Brand:</span>
            <select id="theme-select" style="
                background: rgba(255,255,255,0.2);
                border: 1px solid rgba(255,255,255,0.4);
                color: white;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
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
        `;

        // Append to banner
        banner.appendChild(container);

        // Set current value and add change handler
        const select = document.getElementById('theme-select');
        select.value = localStorage.getItem('selectedTheme') || 'default';
        select.addEventListener('change', function() {
            applyTheme(this.value);
        });
    }

    // Run immediately
    loadTheme();

    // Add selector when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', addThemeSelectorToBanner);
    } else {
        addThemeSelectorToBanner();
    }

    // Expose for external use
    window.setTheme = applyTheme;
})();
