/**
 * Theme Loader for NewPOPSys Wireframes
 * Loads saved theme from localStorage and applies it to the page
 */

(function() {
    // Theme definitions
    const themes = {
        default: { name: 'NewPOPSys v1' },
        shelfsync: { name: 'ShelfSync' },
        merchpulse: { name: 'MerchPulse' },
        fieldforge: { name: 'FieldForge' },
        nexova: { name: 'Nexova' },
        prism: { name: 'PRISM' }
    };

    // Load and apply saved theme immediately
    function loadTheme() {
        const savedTheme = localStorage.getItem('selectedTheme') || 'default';

        if (savedTheme && savedTheme !== 'default') {
            document.documentElement.setAttribute('data-theme', savedTheme);
        }

        // Update page title if theme is not default
        if (savedTheme && themes[savedTheme]) {
            const themeName = themes[savedTheme].name;
            // Update title to reflect brand
            const currentTitle = document.title;
            if (savedTheme !== 'default' && !currentTitle.includes(themeName)) {
                document.title = currentTitle.replace(/^[^-]+/, themeName + ' ');
            }
        }
    }

    // Run immediately
    loadTheme();

    // Also run on DOMContentLoaded in case script loads before DOM
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', loadTheme);
    }
})();
