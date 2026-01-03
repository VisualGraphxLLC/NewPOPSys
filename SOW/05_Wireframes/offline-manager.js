/**
 * Offline Manager for Store Execution Portal
 * Centralizes offline/online status handling, PWA syncing simulation,
 * and UI status indicators.
 * 
 * Extracted from store_execution.html to be used across the Store module.
 */

class OfflineManager {
    constructor() {
        this.status = navigator.onLine ? 'online' : 'offline';
        this.syncQueue = [];
        this.lastSync = new Date();
        this.pendingUploads = 3; // Mock starting value
        
        this.init();
    }
    
    init() {
        window.addEventListener('online', () => this.handleConnectionChange('online'));
        window.addEventListener('offline', () => this.handleConnectionChange('offline'));
        
        // Check initial state
        this.handleConnectionChange(this.status);
        
        // Inject offline banner if doesn't exist
        this.injectBanner();
        
        // Expose to window for external access
        window.toggleOfflineMode = () => this.toggleOfflineMode();
    }
    
    injectBanner() {
        if (document.querySelector('.offline-banner')) return;
        
        const bannerStyles = `
            .offline-banner {
                position: relative;
                flex: 0 0 auto;
                z-index: 40;
                background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
                color: white;
                padding: 8px 16px;
                font-size: 12px;
                display: none;
            }

            body.offline-mode .offline-banner {
                display: block;
            }

            body.offline-mode [data-requires-connection] {
                opacity: 0.5;
                pointer-events: none;
                filter: grayscale(0.5);
            }
            
            .offline-icon { display: none; }
            body.offline-mode .offline-icon { display: inline-block; }
            body.offline-mode .online-icon { display: none; }
        `;
        
        const style = document.createElement('style');
        style.textContent = bannerStyles;
        document.head.appendChild(style);
        
        // Find insertion point - typically inside #phone or at top of body depending on layout
        const phone = document.getElementById('phone');
        const statusBar = document.querySelector('.safe-area-top');
        
        const banner = document.createElement('div');
        banner.className = 'offline-banner';
        banner.innerHTML = `
            <div class="flex justify-between items-center">
                <div class="flex items-center gap-2">
                    <i data-lucide="wifi-off" size="14"></i>
                    <span class="font-semibold">Working Offline</span>
                </div>
                <div class="flex items-center gap-3 text-xs">
                    <span>Last sync: 2 min ago</span>
                    <span class="bg-black/10 px-2 py-0.5 rounded-full flex items-center gap-1">
                        <i data-lucide="upload-cloud" size="10"></i>
                        <span>3 pending</span>
                    </span>
                </div>
            </div>
        `;
        
        if (phone && statusBar) {
            statusBar.after(banner);
        } else if (phone) {
            phone.prepend(banner);
        } else {
            // Fallback for non-phone layouts
            document.body.prepend(banner);
        }

        // AGENT FIX: Inject a second banner instance for Desktop View if it exists
        // This ensures visibility when Mobile View (and thus #phone) is hidden
        const desktopContainer = document.querySelector('.desktop-view-container');
        if (desktopContainer) {
            const desktopBanner = banner.cloneNode(true);
            // Insert at the very top of desert container, or before the nav
            desktopContainer.prepend(desktopBanner);
        }
        
        if (window.lucide) window.lucide.createIcons();
    }
    
    handleConnectionChange(status) {
        this.status = status;
        const isOffline = status === 'offline';
        
        if (isOffline) {
            document.body.classList.add('offline-mode');
        } else {
            document.body.classList.remove('offline-mode');
        }
        
        if (window.lucide) window.lucide.createIcons();
    }
    
    toggleOfflineMode() {
        const isCurrentlyOffline = document.body.classList.contains('offline-mode');
        if (isCurrentlyOffline) {
            this.handleConnectionChange('online');
            alert('🟢 Connection Restored\nSyncing pending items...');
        } else {
            this.handleConnectionChange('offline');
            alert('🟠 Offline Mode Active\nChanges will be saved locally.');
        }
    }
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => window.offlineManager = new OfflineManager());
} else {
    window.offlineManager = new OfflineManager();
}
