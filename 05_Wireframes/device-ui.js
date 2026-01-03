/**
 * Device Manager for Store Execution Portal
 * Handles: Device frame simulation (Mobile, Tablet, Desktop)
 * Injects: CSS for device frames and UI controls for switching
 */

class DeviceManager {
    constructor() {
        this.currentDevice = localStorage.getItem('storeAppDevice') || 'mobile';
        this.init();
    }

    init() {
        this.injectCSS();
        this.injectControls();
        this.setDevice(this.currentDevice);
    }

    // ... (lines 19-386 remain unchanged) ...

    setDevice(device) {
        // Standard device switching
        // Update body class
        document.body.classList.remove('device-mobile', 'device-tablet', 'device-tablet-landscape', 'device-desktop');
        document.body.classList.add('device-' + device);
        
        // Save preference
        localStorage.setItem('storeAppDevice', device);
        this.currentDevice = device;

        // Update active button state
        document.querySelectorAll('.device-btn, .device-btn-header').forEach(btn => btn.classList.remove('active'));
        const activeBtn = document.querySelector(`.device-btn[onclick*="'${device}'"], .device-btn-header[onclick*="'${device}'"]`);
        if (activeBtn) activeBtn.classList.add('active');

        // Re-render icons if needed
        if (window.lucide) window.lucide.createIcons();
    }

    init() {
        this.injectCSS();
        this.injectControls();
        this.setDevice(this.currentDevice);
    }

    injectCSS() {
        if (document.getElementById('device-manager-styles')) return;

        const style = document.createElement('style');
        style.id = 'device-manager-styles';
        style.textContent = `
            /* Device Manager UI Controls - Floating Fallback */
            .device-controls {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background: white;
                padding: 8px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                display: flex;
                gap: 8px;
                z-index: 1000;
                border: 1px solid #e5e7eb;
            }

            .device-btn {
                padding: 8px;
                border: 1px solid #e5e7eb;
                background: #f9fafb;
                border-radius: 8px;
                cursor: pointer;
                color: #6b7280;
                transition: all 0.2s;
            }

            .device-btn:hover {
                background: #f3f4f6;
                color: #374151;
            }

            .device-btn.active {
                background: #eff6ff;
                border-color: #3b82f6;
                color: #2563eb;
            }

            /* Device Frame CSS (Extracted from store_execution.html) */
            
            /* Base Mobile Overrides */
            body.device-mobile #phone {
                width: 393px;
                height: 852px;
                border-radius: 47px;
                border: 12px solid #1a1a1a;
                flex-shrink: 0; /* Prevent shrinking */
            }

            body.device-mobile .phone-container {
                background-color: #333 !important;
                padding: 20px;
                display: flex !important;
                justify-content: center !important;
                width: 100%;
                box-sizing: border-box;
                min-height: 100vh;
            }

            /* Tablet Portrait (iPad) */
            body.device-tablet #phone {
                width: 820px;
                height: 1180px;
                border-radius: 24px;
                border: 14px solid #1a1a1a;
                flex-shrink: 0;
            }

            body.device-tablet .phone-container {
                background-color: #333 !important;
                padding: 20px;
                min-height: calc(100vh - 50px);
                overflow: auto;
                display: flex !important;
                justify-content: center !important;
                width: 100%;
                box-sizing: border-box;
            }

            body.device-tablet .safe-area-top {
                height: 48px;
                padding: 0 24px;
            }

            body.device-tablet .bottom-nav {
                height: 70px;
                padding-bottom: 12px;
            }

            body.device-tablet .card {
                padding: 20px;
            }

            body.device-tablet h1 {
                font-size: 2rem;
            }

            body.device-tablet .screen {
                height: auto !important;
                padding: 24px !important;
            }

            /* Tablet Landscape (iPad) - Similar to Desktop */
            /* Tablet Landscape (iPad) */
            /* Tablet Landscape (iPad) */
            body.device-tablet-landscape #phone {
                width: 1024px;
                height: 768px;
                border-radius: 24px;
                border: 14px solid #1a1a1a;
                box-shadow: 0 0 50px rgba(0, 0, 0, 0.5);
                margin: auto;
                position: relative; /* Ensure absolute children stay inside */
                flex-shrink: 0;
                overflow: hidden; /* Clip content to rounded corners */
            }

            body.device-tablet-landscape .phone-container {
                background-color: #333 !important;
                padding: 40px;
                min-height: 100vh;
                display: flex !important;
                align-items: center !important;
                justify-content: center !important;
                overflow: auto;
                width: 100%;
                box-sizing: border-box;
            }

            body.device-tablet-landscape .safe-area-top {
                height: 48px;
                padding: 0 24px;
                border-bottom: 1px solid #e5e7eb;
            }

            body.device-tablet-landscape .screen {
                height: calc(100% - 48px - 70px) !important; /* Total - header - nav */
                overflow-y: auto !important;
                padding: 24px !important;
                padding-bottom: 24px !important;
            }

            body.device-tablet-landscape .bottom-nav {
                position: absolute;
                bottom: 0;
                left: 0;
                width: 100%;
                height: 70px;
                background: white;
                border-top: 1px solid #e5e7eb;
                display: flex;
                justify-content: space-around;
                align-items: center;
                padding-bottom: 0; /* Reset */
                z-index: 10;
            }

            body.device-tablet-landscape .dashboard-campaigns {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 16px;
            }
            
            /* Tablet Landscape Specific Column Layout */
            body.device-tablet-landscape .tablet-col-layout {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 24px;
                align-items: start;
            }
            
            body.device-tablet-landscape .mt-6.tablet\:mt-0 {
                margin-top: 0 !important;
            }

            /* Desktop (Full Screen) */
            /* Desktop (Full Screen Web Layout) */
            /* Desktop (Full Screen Web Layout) */
            body.device-desktop {
                background-color: #f3f4f6;
                overflow-y: auto;
            }

            /* View Toggling - The Clean Approach */
            /* Default: Mobile Container Visible, Desktop Hidden */
            .desktop-view-container {
                display: none !important;
            }
            .mobile-view-container {
                display: flex !important; /* Or block depending on layout */
            }

            /* Desktop Mode: Switch Visibility */
            body.device-desktop .mobile-view-container {
                display: none !important;
            }
            body.device-desktop .desktop-view-container {
                display: block !important;
            }

            /* Basic Desktop Resets */
            body.device-desktop .phone-container {
                display: none; /* redundant safety */
            }


            body.device-desktop .tooltip-help-banner {
                position: sticky;
                top: 0;
                z-index: 1001; /* Above nav */
            }

            /* REMOVED LEGACY STRETCHING CSS TO PREVENT 'BIG PHONE' LOOK */
            
            /* Hide Mobile Status Bar */
            body.device-desktop .safe-area-top {
                display: none;
            }

            /* Transform Bottom Nav into Top Navigation Bar */
            body.device-desktop .bottom-nav {
                order: -1; /* Move to top */
                position: sticky;
                top: 32px; /* Below banner (approx) */
                z-index: 1000;
                height: 64px;
                background: white;
                border-top: none;
                border-bottom: 1px solid #e5e7eb;
                padding: 0 40px;
                display: flex;
                justify-content: flex-start; /* Left align items */
                gap: 40px;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            }

            body.device-desktop .nav-item {
                flex-direction: row; /* Horizontal layout */
                gap: 8px;
                font-size: 14px;
                font-weight: 500;
                padding: 8px 16px;
                border-radius: 6px;
                transition: all 0.2s;
            }

            body.device-desktop .nav-item:hover {
                background-color: #f3f4f6;
                color: var(--primary);
            }

            body.device-desktop .nav-item.active {
                color: var(--primary);
                background-color: #eff6ff; 
            }
            
            /* Add logos or spacers if needed, but for now we re-purpose existing items */

            /* Main Content Area */
            body.device-desktop .screen {
                order: 2; /* Below nav */
                max-width: 1280px; /* Standard Desktop Container */
                margin: 0 auto;
                padding: 40px !important;
                padding-bottom: 100px !important;
                height: auto !important;
                overflow: visible !important;
                background: transparent !important; /* Let body bg show */
                width: 100%;
                box-sizing: border-box;
            }

            /* Specific Page Overrides for Desktop */
            
            /* Dashboard Grid */
            body.device-desktop .dashboard-campaigns {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 24px;
            }

            /* Profile Page Alignment */
            body.device-desktop #screen-profile {
                max-width: 800px;
            }

            /* Tasks List */
            body.device-desktop #screen-tasks .task-container {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
        `;
        document.head.appendChild(style);
    }

    injectControls() {
        // Prevent duplicate injection
        if (document.querySelector('.device-controls-header')) return;

        const banner = document.querySelector('.tooltip-help-banner');
        
        // Create controls container
        const container = document.createElement('div');
        container.className = 'device-controls-header';
        
        const btnStyle = `
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 4px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
            height: 24px;
            width: 24px;
        `;

        container.style.cssText = `
            display: flex;
            align-items: center;
            gap: 6px;
            margin-left: 16px;
            padding-left: 16px;
            border-left: 1px solid rgba(255,255,255,0.3);
        `;

        container.innerHTML = `
            <button class="device-btn-header" onclick="deviceManager.setDevice('mobile')" title="Mobile" style="${btnStyle}">
                <i data-lucide="smartphone" size="14"></i>
            </button>
            <button class="device-btn-header" onclick="deviceManager.setDevice('tablet')" title="Tablet Portrait" style="${btnStyle}">
                <i data-lucide="tablet" size="14"></i>
            </button>
            <button class="device-btn-header" onclick="deviceManager.setDevice('tablet-landscape')" title="Tablet Landscape" style="${btnStyle}">
                <i data-lucide="tablet" size="14" style="transform: rotate(90deg)"></i>
            </button>
            <button class="device-btn-header" onclick="deviceManager.setDevice('desktop')" title="Desktop" style="${btnStyle}">
                <i data-lucide="monitor" size="14"></i>
            </button>
        `;

        if (banner) {
            banner.appendChild(container);
        } else {
            // Fallback to floating if no banner exists (though we should add banners)
            container.className = 'device-controls'; // Use old class for floating style
            container.style.cssText = '';
            // Reset button styles for floating
            const floatBtnStyle = ''; 
            container.innerHTML = container.innerHTML.replace(/style="[^"]*"/g, ''); // Strip inline styles for floating fallback
            
            // Re-add floating specific structure if needed, or just revert to old method for fallback
            // For now, let's keep it simple: if no banner, use the old floating fixed implementation
            const floatContainer = document.createElement('div');
            floatContainer.className = 'device-controls';
            floatContainer.innerHTML = `
                <button class="device-btn" onclick="deviceManager.setDevice('mobile')" title="Mobile"><i data-lucide="smartphone" size="20"></i></button>
                <button class="device-btn" onclick="deviceManager.setDevice('tablet')" title="Tablet Portrait"><i data-lucide="tablet" size="20"></i></button>
                <button class="device-btn" onclick="deviceManager.setDevice('tablet-landscape')" title="Tablet Landscape"><i data-lucide="tablet" size="20" style="transform: rotate(90deg)"></i></button>
                <button class="device-btn" onclick="deviceManager.setDevice('desktop')" title="Desktop"><i data-lucide="monitor" size="20"></i></button>
            `;
            document.body.appendChild(floatContainer);
            if (window.lucide) window.lucide.createIcons();
            return;
        }

        if (window.lucide) window.lucide.createIcons();
        
        // Add active state handling style
        const activeStyle = document.createElement('style');
        activeStyle.textContent = `
            .device-btn-header.active {
                background: white !important;
                color: var(--primary) !important;
                border-color: white !important;
            }
        `;
        document.head.appendChild(activeStyle);
    }

    setDevice(device) {
        // Standard device switching
        // Update body class
        document.body.classList.remove('device-mobile', 'device-tablet', 'device-tablet-landscape', 'device-desktop');
        document.body.classList.add('device-' + device);
        
        // Save preference
        localStorage.setItem('storeAppDevice', device);
        this.currentDevice = device;

        // Update active button state
        document.querySelectorAll('.device-btn, .device-btn-header').forEach(btn => btn.classList.remove('active'));
        const activeBtn = document.querySelector(`.device-btn[onclick*="'${device}'"], .device-btn-header[onclick*="'${device}'"]`);
        if (activeBtn) activeBtn.classList.add('active');

        // Re-render icons if needed
        if (window.lucide) window.lucide.createIcons();
    }
}

// Initialize
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => window.deviceManager = new DeviceManager());
} else {
    window.deviceManager = new DeviceManager();
}
