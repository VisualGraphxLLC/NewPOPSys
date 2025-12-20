/**
 * Theme Configuration - Single Source of Truth
 * All brand themes, colors, and logos defined here
 */

window.THEME_CONFIG = {
    brands: {
        default: {
            name: 'NewPOPSys v1',
            shortName: 'NewPOPSys',
            tagline: 'Current codename',
            logo: 'logos/newpopsys-logo.svg',
            colors: {
                primary: '#1e3a5f',
                primaryLight: '#2d5a87',
                primaryDark: '#0f1f33',
                accent: '#3b82f6',
                accentLight: '#60a5fa',
                textOnPrimary: '#ffffff',
                textMuted: '#94a3b8'
            },
            // Inline SVG for index.html nav
            logoSvg: `<svg viewBox="0 0 32 32" fill="none"><rect width="32" height="32" rx="6" fill="#1e3a5f"/><text x="16" y="21" text-anchor="middle" fill="white" font-size="14" font-weight="bold">N</text></svg>`
        },
        shelfsync: {
            name: 'ShelfSync',
            shortName: 'ShelfSync',
            tagline: 'Teal + Yellow energy',
            logo: 'logos/shelfsync-logo.svg',
            colors: {
                primary: '#012D3A',
                primaryLight: '#00ABB9',
                primaryDark: '#011820',
                accent: '#FCD732',
                accentLight: '#FDE68A',
                textOnPrimary: '#ffffff',
                textMuted: '#94a3b8'
            },
            logoSvg: `<svg viewBox="0 0 32 32" fill="none">
                <rect width="32" height="32" rx="6" fill="url(#ss-grad)"/>
                <defs><linearGradient id="ss-grad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#012D3A"/><stop offset="1" stop-color="#00ABB9"/></linearGradient></defs>
                <rect x="4" y="8" width="24" height="4" rx="1" fill="#FCD732"/>
                <rect x="4" y="14" width="24" height="4" rx="1" fill="white"/>
                <rect x="4" y="20" width="24" height="4" rx="1" fill="#FCD732"/>
                <circle cx="24" cy="16" r="5" fill="white" stroke="#00ABB9" stroke-width="2"/>
                <path d="M22 16h4M24 14v4" stroke="#00ABB9" stroke-width="1.5"/>
            </svg>`
        },
        merchpulse: {
            name: 'MerchPulse',
            shortName: 'MerchPulse',
            tagline: 'Purple + Citrus vibrant',
            logo: 'logos/merchpulse-logo.svg',
            colors: {
                primary: '#5B21B6',
                primaryLight: '#7C3AED',
                primaryDark: '#3B0F7A',
                accent: '#F59E0B',
                accentLight: '#FBBF24',
                textOnPrimary: '#ffffff',
                textMuted: '#94a3b8'
            },
            logoSvg: `<svg viewBox="0 0 32 32" fill="none">
                <rect width="32" height="32" rx="6" fill="url(#mp-grad)"/>
                <defs><linearGradient id="mp-grad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#5B21B6"/><stop offset="1" stop-color="#7C3AED"/></linearGradient></defs>
                <circle cx="16" cy="16" r="10" stroke="#F59E0B" stroke-width="2" fill="none"/>
                <circle cx="16" cy="16" r="5" fill="#F59E0B"/>
                <path d="M16 6v3M16 23v3M6 16h3M23 16h3" stroke="white" stroke-width="2"/>
            </svg>`
        },
        fieldforge: {
            name: 'FieldForge',
            shortName: 'FieldForge',
            tagline: 'Navy + Emerald power',
            logo: 'logos/fieldforge-logo.svg',
            colors: {
                primary: '#1E40AF',
                primaryLight: '#3B82F6',
                primaryDark: '#1E3A8A',
                accent: '#10B981',
                accentLight: '#34D399',
                textOnPrimary: '#ffffff',
                textMuted: '#94a3b8'
            },
            logoSvg: `<svg viewBox="0 0 32 32" fill="none">
                <rect width="32" height="32" rx="6" fill="url(#ff-grad)"/>
                <defs><linearGradient id="ff-grad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#1E40AF"/><stop offset="1" stop-color="#3B82F6"/></linearGradient></defs>
                <path d="M16 4L4 10v12l12 6 12-6V10L16 4z" fill="#10B981"/>
                <path d="M16 4v24M4 10l12 6 12-6" stroke="white" stroke-width="1.5"/>
                <circle cx="16" cy="16" r="4" fill="white"/>
            </svg>`
        },
        nexova: {
            name: 'Nexova',
            shortName: 'Nexova',
            tagline: 'Dark + Cyan modern',
            logo: 'logos/nexova-logo.svg',
            colors: {
                primary: '#0F172A',
                primaryLight: '#334155',
                primaryDark: '#020617',
                accent: '#06B6D4',
                accentLight: '#22D3EE',
                textOnPrimary: '#ffffff',
                textMuted: '#94a3b8'
            },
            logoSvg: `<svg viewBox="0 0 32 32" fill="none">
                <rect width="32" height="32" rx="6" fill="url(#nx-grad)"/>
                <defs><linearGradient id="nx-grad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#0F172A"/><stop offset="1" stop-color="#334155"/></linearGradient></defs>
                <path d="M16 4L6 9v9c0 6.5 4.5 12.5 10 14 5.5-1.5 10-7.5 10-14V9l-10-5z" fill="#06B6D4"/>
                <path d="M11 16l4 4 6-7" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>`
        },
        prism: {
            name: 'PRISM',
            shortName: 'PRISM',
            tagline: 'Monochrome + Teal clarity',
            logo: 'logos/prism-logo.svg',
            colors: {
                primary: '#18181B',
                primaryLight: '#3F3F46',
                primaryDark: '#09090B',
                accent: '#14B8A6',
                accentLight: '#2DD4BF',
                textOnPrimary: '#ffffff',
                textMuted: '#94a3b8'
            },
            logoSvg: `<svg viewBox="0 0 32 32" fill="none">
                <rect width="32" height="32" rx="6" fill="url(#pr-grad)"/>
                <defs><linearGradient id="pr-grad" x1="0" y1="0" x2="32" y2="32"><stop stop-color="#18181B"/><stop offset="1" stop-color="#3F3F46"/></linearGradient></defs>
                <polygon points="16,4 28,26 4,26" fill="none" stroke="#14B8A6" stroke-width="2"/>
                <polygon points="16,12 22,22 10,22" fill="#14B8A6"/>
            </svg>`
        }
    },

    appearances: {
        light: { name: 'Light', icon: 'sun' },
        dark: { name: 'Dark', icon: 'moon' },
        'high-contrast': { name: 'High Contrast', icon: 'contrast' }
    },

    // Generate CSS variables string for a theme
    getCSSVariables: function(themeName) {
        const theme = this.brands[themeName] || this.brands.default;
        return `
            --primary: ${theme.colors.primary};
            --primary-light: ${theme.colors.primaryLight};
            --primary-dark: ${theme.colors.primaryDark};
            --accent: ${theme.colors.accent};
            --accent-light: ${theme.colors.accentLight};
            --text-on-primary: ${theme.colors.textOnPrimary};
            --text-muted: ${theme.colors.textMuted};
        `;
    }
};
