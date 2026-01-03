/**
 * Document Sidebar - Contextual SOW document navigator
 * Shows relevant documents based on current section or wireframe page
 */

(function() {
    'use strict';

    // Document mappings by context
    const DOC_MAPPINGS = {
        // Index page sections
        'overview': {
            title: 'Project Overview',
            icon: '📋',
            docs: [
                { id: 'MASTER', name: 'Master SOW', path: '../01_Main_SOW/MASTER_SOW_COMPILED.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' },
                { id: 'SUPP-002', name: 'Functional Requirements', path: '../02_SUPPs/Shared_Foundations/SUPP-002 - Shared Foundations - Functional Requirements.md' }
            ]
        },
        'personas': {
            title: 'Personas & Roles',
            icon: '👥',
            docs: [
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' },
                { id: 'SUPP-003', name: 'Role Permissions Matrix', path: '../02_SUPPs/Shared_Foundations/SUPP-003 - Shared Foundations - Role Permissions Matrix.md' }
            ]
        },
        'lifecycle': {
            title: 'Campaign Lifecycle',
            icon: '🔄',
            docs: [
                { id: 'SUPP-015', name: 'Campaigns, Kits, Assignment', path: '../02_SUPPs/Brand_Admin_Module/SUPP-015 - Brand Admin Module - Campaigns Kits Assignment.md' },
                { id: 'SUPP-016', name: 'Orders, Shipments, Batches', path: '../02_SUPPs/PSP_Operations_Module/SUPP-016 - PSP Operations Module - Orders Shipments Batches PSP Ops.md' },
                { id: 'SUPP-017', name: 'Store Execution, Proof Capture', path: '../02_SUPPs/Store_Execution_Module/SUPP-017 - Store Execution Module - Store Execution Proof Capture.md' }
            ]
        },
        'wireframes': {
            title: 'Wireframes Overview',
            icon: '🖼️',
            docs: [
                { id: 'SUPP-036', name: 'Screens & Interfaces', path: '../02_SUPPs/Screens_Interfaces/SUPP-036 - Screens - Interfaces - Screens Onboarding and Store Foundation.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        },
        'diagrams': {
            title: 'Architecture',
            icon: '📐',
            docs: [
                { id: 'SUPP-004', name: 'Data Model & Schema', path: '../02_SUPPs/Shared_Foundations/SUPP-004 - Shared Foundations - Data Model and Schema.md' },
                { id: 'SUPP-005', name: 'API Design', path: '../02_SUPPs/Shared_Foundations/SUPP-005 - Shared Foundations - API Design.md' },
                { id: 'SUPP-006', name: 'Integration Specs', path: '../02_SUPPs/Shared_Foundations/SUPP-006 - Shared Foundations - Integration Specifications.md' }
            ]
        },
        'questions': {
            title: 'Open Questions',
            icon: '❓',
            docs: [
                { id: 'MASTER', name: 'Master SOW', path: '../01_Main_SOW/MASTER_SOW_COMPILED.md' }
            ]
        },

        // Individual wireframe pages
        'psp_ops': {
            title: 'PSP Operations',
            icon: '👷',
            color: 'yellow',
            docs: [
                { id: 'SUPP-016', name: 'Orders, Shipments, Batches', path: '../02_SUPPs/PSP_Operations_Module/SUPP-016 - PSP Operations Module - Orders Shipments Batches PSP Ops.md' },
                { id: 'SUPP-018', name: 'Verification, Photo Review', path: '../02_SUPPs/PSP_Operations_Module/SUPP-018 - PSP Operations Module - Verification Photo Review Retake.md' },
                { id: 'SUPP-019', name: 'Issues, Reorders, Deinstall', path: '../02_SUPPs/PSP_Operations_Module/SUPP-019 - PSP Operations Module - Issues Reorders Expiration Deinstall.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        },
        'psp_admin': {
            title: 'PSP Admin Portal',
            icon: '⚙️',
            color: 'yellow',
            docs: [
                { id: 'SUPP-003', name: 'Role Permissions Matrix', path: '../02_SUPPs/Shared_Foundations/SUPP-003 - Shared Foundations - Role Permissions Matrix.md' },
                { id: 'SUPP-010', name: 'Tenant & Brand Onboarding', path: '../02_SUPPs/Shared_Foundations/SUPP-010 - Shared Foundations - Tenant and Brand Onboarding.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        },
        'admin_portal': {
            title: 'Brand Admin Portal',
            icon: '🖥️',
            color: 'purple',
            docs: [
                { id: 'SUPP-013', name: 'Stores, Regions, Groups', path: '../02_SUPPs/Brand_Admin_Module/SUPP-013 - Brand Admin Module - Stores Regions Groups.md' },
                { id: 'SUPP-014', name: 'Survey Builder, Photo Rules', path: '../02_SUPPs/Brand_Admin_Module/SUPP-014 - Brand Admin Module - Survey Builder Layout Photo Rules.md' },
                { id: 'SUPP-015', name: 'Campaigns, Kits, Assignment', path: '../02_SUPPs/Brand_Admin_Module/SUPP-015 - Brand Admin Module - Campaigns Kits Assignment.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        },
        'regional_dashboard': {
            title: 'Regional Dashboard',
            icon: '🗺️',
            color: 'purple',
            docs: [
                { id: 'SUPP-013', name: 'Stores, Regions, Groups', path: '../02_SUPPs/Brand_Admin_Module/SUPP-013 - Brand Admin Module - Stores Regions Groups.md' },
                { id: 'SUPP-018', name: 'Verification, Photo Review', path: '../02_SUPPs/PSP_Operations_Module/SUPP-018 - PSP Operations Module - Verification Photo Review Retake.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        },
        'store_portal': {
            title: 'Store Manager Portal',
            icon: '🏪',
            color: 'teal',
            docs: [
                { id: 'SUPP-017', name: 'Store Execution, Proof Capture', path: '../02_SUPPs/Store_Execution_Module/SUPP-017 - Store Execution Module - Store Execution Proof Capture.md' },
                { id: 'SUPP-036', name: 'Onboarding & Store Screens', path: '../02_SUPPs/Screens_Interfaces/SUPP-036 - Screens - Interfaces - Screens Onboarding and Store Foundation.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        },
        'mobile_app': {
            title: 'Store Mobile App',
            icon: '📱',
            color: 'blue',
            docs: [
                { id: 'SUPP-017', name: 'Store Execution, Proof Capture', path: '../02_SUPPs/Store_Execution_Module/SUPP-017 - Store Execution Module - Store Execution Proof Capture.md' },
                { id: 'SUPP-011', name: 'Offline & Sync Strategy', path: '../02_SUPPs/Store_Execution_Module/SUPP-011 - Store Execution Module - Offline and Sync Strategy.md' },
                { id: 'SUPP-036', name: 'Onboarding & Store Screens', path: '../02_SUPPs/Screens_Interfaces/SUPP-036 - Screens - Interfaces - Screens Onboarding and Store Foundation.md' },
                { id: 'SUPP-001', name: 'Persona Workflows & JTBD', path: '../02_SUPPs/Shared_Foundations/SUPP-001 - Shared Foundations - Persona Workflows JTBD Screens.md' }
            ]
        }
    };

    let currentContext = null;
    let sidebarOpen = false;

    function getColorClasses(color) {
        const colors = {
            yellow: { bg: 'bg-yellow-100', border: 'border-yellow-400', text: 'text-yellow-800', hover: 'hover:border-yellow-500' },
            purple: { bg: 'bg-purple-100', border: 'border-purple-400', text: 'text-purple-800', hover: 'hover:border-purple-500' },
            blue: { bg: 'bg-blue-100', border: 'border-blue-400', text: 'text-blue-800', hover: 'hover:border-blue-500' },
            teal: { bg: 'bg-teal-100', border: 'border-teal-400', text: 'text-teal-800', hover: 'hover:border-teal-500' },
            gray: { bg: 'bg-gray-100', border: 'border-gray-400', text: 'text-gray-800', hover: 'hover:border-gray-500' }
        };
        return colors[color] || colors.gray;
    }

    function detectContext() {
        // Check if we're on a specific wireframe page
        const pageName = window.location.pathname.split('/').pop().replace('.html', '');
        if (DOC_MAPPINGS[pageName]) {
            return pageName;
        }

        // On index page, detect by scroll position
        if (pageName === 'index' || pageName === '' || window.location.pathname.endsWith('/')) {
            const sections = ['overview', 'personas', 'lifecycle', 'wireframes', 'diagrams', 'questions'];
            const scrollPos = window.scrollY + 200; // Offset for better detection

            for (let i = sections.length - 1; i >= 0; i--) {
                const section = document.getElementById(sections[i]);
                if (section && section.offsetTop <= scrollPos) {
                    return sections[i];
                }
            }
            return 'overview';
        }

        return null;
    }

    function createSidebar() {
        // Create toggle button
        const toggleBtn = document.createElement('button');
        toggleBtn.id = 'doc-sidebar-toggle';
        toggleBtn.innerHTML = `
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
            </svg>
            <span class="text-xs font-medium">Docs</span>
        `;
        toggleBtn.className = 'fixed right-0 top-1/2 -translate-y-1/2 z-50 flex flex-col items-center gap-1 px-2 py-3 bg-blue-600 text-white rounded-l-lg shadow-lg hover:bg-blue-700 transition-all';
        toggleBtn.onclick = toggleSidebar;

        // Create sidebar panel
        const sidebar = document.createElement('div');
        sidebar.id = 'doc-sidebar';
        sidebar.className = 'fixed right-0 top-0 h-full w-80 bg-white shadow-2xl z-[90] transform translate-x-full transition-transform duration-300 flex flex-col';
        sidebar.innerHTML = `
            <div id="doc-sidebar-header" class="px-4 py-3 border-b bg-gray-50 flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span id="doc-sidebar-icon" class="text-lg">📄</span>
                    <h3 id="doc-sidebar-title" class="font-semibold text-gray-900 text-sm">Related Documents</h3>
                </div>
                <button onclick="window.toggleDocSidebar()" class="p-1.5 hover:bg-gray-200 rounded-lg transition-colors">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
            </div>
            <div id="doc-sidebar-content" class="flex-1 overflow-y-auto p-4">
                <p class="text-gray-500 text-sm">Loading...</p>
            </div>
            <div class="px-4 py-3 border-t bg-gray-50 text-xs text-gray-500">
                Documents update as you scroll
            </div>
        `;

        document.body.appendChild(toggleBtn);
        document.body.appendChild(sidebar);

        // Add styles
        const style = document.createElement('style');
        style.id = 'doc-sidebar-styles';
        style.textContent = `
            #doc-sidebar.open {
                transform: translateX(0);
            }
            #doc-sidebar-toggle.hidden-toggle {
                transform: translateX(100%);
            }
            .doc-item {
                display: block;
                padding: 0.75rem;
                border-radius: 0.5rem;
                border: 1px solid #e5e7eb;
                margin-bottom: 0.5rem;
                transition: all 0.15s;
                cursor: pointer;
                text-decoration: none;
            }
            .doc-item:hover {
                border-color: #3b82f6;
                background-color: #f0f9ff;
            }
            .doc-item-id {
                font-size: 0.625rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.05em;
                margin-bottom: 0.25rem;
            }
            .doc-item-name {
                font-size: 0.875rem;
                color: #1f2937;
            }

            /* Dark mode styles */
            body.dark-mode #doc-sidebar {
                background-color: #1e293b !important;
            }
            body.dark-mode #doc-sidebar-header {
                background-color: #334155 !important;
                border-color: #475569 !important;
            }
            body.dark-mode #doc-sidebar-title {
                color: #f1f5f9 !important;
            }
            body.dark-mode #doc-sidebar-content {
                color: #e2e8f0 !important;
            }
            body.dark-mode .doc-item {
                background-color: #334155 !important;
                border-color: #475569 !important;
            }
            body.dark-mode .doc-item:hover {
                border-color: #60a5fa !important;
                background-color: #1e3a5f !important;
            }
            body.dark-mode .doc-item-name {
                color: #f1f5f9 !important;
            }
            body.dark-mode #doc-sidebar .border-t {
                border-color: #475569 !important;
                background-color: #334155 !important;
                color: #94a3b8 !important;
            }

            /* High contrast styles */
            body.high-contrast #doc-sidebar {
                background-color: #000000 !important;
                border-left: 2px solid #ffffff !important;
            }
            body.high-contrast #doc-sidebar-header {
                background-color: #000000 !important;
                border-color: #ffffff !important;
            }
            body.high-contrast #doc-sidebar-title {
                color: #ffffff !important;
            }
            body.high-contrast .doc-item {
                background-color: #000000 !important;
                border: 2px solid #ffffff !important;
            }
            body.high-contrast .doc-item:hover {
                background-color: #333333 !important;
            }
            body.high-contrast .doc-item-id,
            body.high-contrast .doc-item-name {
                color: #ffffff !important;
            }
            body.high-contrast #doc-sidebar .border-t {
                border-color: #ffffff !important;
                background-color: #000000 !important;
                color: #ffffff !important;
            }
        `;
        document.head.appendChild(style);
    }

    function toggleSidebar() {
        const sidebar = document.getElementById('doc-sidebar');
        const toggle = document.getElementById('doc-sidebar-toggle');

        sidebarOpen = !sidebarOpen;

        if (sidebarOpen) {
            sidebar.classList.add('open');
            toggle.classList.add('hidden-toggle');
            updateSidebarContent();
        } else {
            sidebar.classList.remove('open');
            toggle.classList.remove('hidden-toggle');
        }
    }

    function updateSidebarContent() {
        const context = detectContext();
        if (!context || !DOC_MAPPINGS[context]) return;

        const mapping = DOC_MAPPINGS[context];
        const content = document.getElementById('doc-sidebar-content');
        const title = document.getElementById('doc-sidebar-title');
        const icon = document.getElementById('doc-sidebar-icon');

        if (context === currentContext) return;
        currentContext = context;

        title.textContent = mapping.title;
        icon.textContent = mapping.icon;

        const colorClasses = getColorClasses(mapping.color || 'gray');

        let html = '';
        mapping.docs.forEach(doc => {
            html += `
                <a href="${doc.path}" class="doc-item">
                    <div class="doc-item-id ${colorClasses.text}">${doc.id}</div>
                    <div class="doc-item-name">${doc.name}</div>
                </a>
            `;
        });

        content.innerHTML = html;
    }

    function init() {
        createSidebar();

        // Update on scroll (debounced)
        let scrollTimeout;
        window.addEventListener('scroll', () => {
            if (!sidebarOpen) return;
            clearTimeout(scrollTimeout);
            scrollTimeout = setTimeout(updateSidebarContent, 100);
        });

        // Initial update if sidebar is opened
        updateSidebarContent();
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    // Expose toggle function globally
    window.toggleDocSidebar = toggleSidebar;

})();
