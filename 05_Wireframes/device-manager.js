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
            }

            body.device-mobile .phone-container {
                background-color: #333;
                padding: 20px;
            }

            /* Tablet Portrait (iPad) */
            body.device-tablet #phone {
                width: 820px;
                height: 1180px;
                border-radius: 24px;
                border: 14px solid #1a1a1a;
            }

            body.device-tablet .phone-container {
                background-color: #333;
                padding: 20px;
                min-height: calc(100vh - 50px);
                overflow: auto;
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
            body.device-tablet-landscape #phone {
                width: 1024px;
                height: 768px;
                border-radius: 24px;
                border: 14px solid #1a1a1a;
                box-shadow: 0 0 50px rgba(0, 0, 0, 0.5);
                margin: auto;
            }

            body.device-tablet-landscape .phone-container {
                background-color: #333;
                padding: 40px;
                min-height: calc(100vh - 50px);
                display: flex;
                align-items: center;
                justify-content: center;
                overflow: auto;
            }

            body.device-tablet-landscape .safe-area-top {
                height: 48px;
                padding: 0 24px;
                border-bottom: 1px solid #e5e7eb;
            }

            body.device-tablet-landscape .screen {
                height: auto !important;
                padding: 24px !important;
                overflow-y: auto;
            }

            /* Ensure content fits */
            body.device-tablet-landscape .bottom-nav {
                height: 70px;
                padding-bottom: 12px;
            }

            body.device-tablet-landscape .dashboard-campaigns {
                grid-template-columns: repeat(2, 1fr);
            }

            body.device-tablet-landscape .bottom-nav {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                height: 64px;
                padding-bottom: 8px;
                background: white;
                border-top: 1px solid #e5e7eb;
                box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
                width: 100%;
                box-sizing: border-box;
            }

            body.device-tablet-landscape .screen {
                max-width: 1000px;
                margin: 0 auto;
                padding: 32px !important;
                padding-bottom: 100px !important;
                min-height: calc(100vh - 170px);
                width: 100%;
                box-sizing: border-box;
            }

            body.device-tablet-landscape .dashboard-campaigns {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                gap: 16px;
            }

            /* Desktop (Full Screen) */
            body.device-desktop {
                background-color: #f3f4f6;
            }

            body.device-desktop .phone-container {
                background-color: transparent;
                padding: 0;
                min-height: auto;
                display: block;
            }

            body.device-desktop #phone {
                width: 100%;
                height: auto;
                min-height: calc(100vh - 50px);
                border-radius: 0;
                border: none;
                box-shadow: none;
            }

            body.device-desktop .safe-area-top {
                height: 56px;
                background: white;
                border-bottom: 1px solid #e5e7eb;
                padding: 0 32px;
                font-size: 16px;
                width: 100%;
                box-sizing: border-box;
            }

            body.device-desktop .bottom-nav {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                height: 64px;
                padding-bottom: 8px;
                background: white;
                border-top: 1px solid #e5e7eb;
                box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
                width: 100%;
                box-sizing: border-box;
            }

            body.device-desktop .screen {
                max-width: 1200px;
                margin: 0 auto;
                padding: 32px !important;
                padding-bottom: 100px !important;
                min-height: calc(100vh - 170px);
                width: 100%;
                box-sizing: border-box;
            }

            body.device-desktop .dashboard-campaigns {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                gap: 16px;
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
