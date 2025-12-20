/**
 * Document Modal - Opens SUPP documents in a modal overlay
 * Include this script and call initDocModal() after DOM is ready
 */

function initDocModal() {
    // Create modal HTML
    const modalHTML = `
    <div id="doc-modal" class="fixed inset-0 z-[100] hidden">
        <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeDocModal()"></div>
        <div class="absolute inset-4 md:inset-8 lg:inset-16 bg-white rounded-xl shadow-2xl flex flex-col overflow-hidden">
            <div class="flex items-center justify-between px-6 py-4 border-b bg-gray-50">
                <h3 id="doc-modal-title" class="font-semibold text-gray-900 truncate">Loading...</h3>
                <div class="flex items-center gap-3">
                    <a id="doc-modal-link" href="#" target="_blank" class="text-sm text-blue-600 hover:text-blue-800">Open in new tab</a>
                    <button onclick="closeDocModal()" class="p-2 hover:bg-gray-200 rounded-lg transition-colors">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                        </svg>
                    </button>
                </div>
            </div>
            <div id="doc-modal-content" class="flex-1 overflow-auto p-6 md:p-8 prose prose-sm md:prose-base max-w-none">
                <div class="flex items-center justify-center h-32">
                    <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                </div>
            </div>
        </div>
    </div>`;

    // Create style element
    const styleHTML = `
    <style id="doc-modal-styles">
        .prose h1 { font-size: 1.875rem; font-weight: 700; margin-bottom: 1rem; color: #111827; }
        .prose h2 { font-size: 1.5rem; font-weight: 600; margin-top: 2rem; margin-bottom: 0.75rem; color: #1f2937; border-bottom: 1px solid #e5e7eb; padding-bottom: 0.5rem; }
        .prose h3 { font-size: 1.25rem; font-weight: 600; margin-top: 1.5rem; margin-bottom: 0.5rem; color: #374151; }
        .prose p { margin-bottom: 1rem; line-height: 1.7; color: #4b5563; }
        .prose ul, .prose ol { margin-bottom: 1rem; padding-left: 1.5rem; }
        .prose li { margin-bottom: 0.25rem; color: #4b5563; }
        .prose code { background: #f3f4f6; padding: 0.125rem 0.375rem; border-radius: 0.25rem; font-size: 0.875em; }
        .prose pre { background: #1f2937; color: #e5e7eb; padding: 1rem; border-radius: 0.5rem; overflow-x: auto; margin-bottom: 1rem; }
        .prose pre code { background: none; padding: 0; color: inherit; }
        .prose table { width: 100%; border-collapse: collapse; margin-bottom: 1rem; font-size: 0.875rem; }
        .prose th, .prose td { border: 1px solid #e5e7eb; padding: 0.5rem 0.75rem; text-align: left; }
        .prose th { background: #f9fafb; font-weight: 600; }
        .prose blockquote { border-left: 4px solid #3b82f6; padding-left: 1rem; margin: 1rem 0; color: #6b7280; font-style: italic; }
        .prose a { color: #2563eb; text-decoration: underline; }
        .prose a:hover { color: #1d4ed8; }
        .prose hr { border: none; border-top: 1px solid #e5e7eb; margin: 2rem 0; }
    </style>`;

    // Inject modal and styles
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    document.head.insertAdjacentHTML('beforeend', styleHTML);

    // Close on Escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeDocModal();
    });

    // Intercept SUPP document links
    document.addEventListener('click', (e) => {
        const link = e.target.closest('a[href*="SUPP-"]');
        if (link && link.href.endsWith('.md')) {
            e.preventDefault();
            const title = link.textContent || link.href.split('/').pop().replace('.md', '');
            openDocModal(link.href, title);
        }
    });
}

function openDocModal(url, title) {
    const modal = document.getElementById('doc-modal');
    const content = document.getElementById('doc-modal-content');
    const titleEl = document.getElementById('doc-modal-title');
    const linkEl = document.getElementById('doc-modal-link');

    titleEl.textContent = title || 'Loading...';
    linkEl.href = url;
    content.innerHTML = '<div class="flex items-center justify-center h-32"><div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div></div>';
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    fetch(url)
        .then(response => {
            if (!response.ok) throw new Error('Failed to load document');
            return response.text();
        })
        .then(markdown => {
            content.innerHTML = marked.parse(markdown);
            // Extract title from first H1 if not provided
            const h1 = content.querySelector('h1');
            if (h1) {
                titleEl.textContent = h1.textContent;
            }
        })
        .catch(err => {
            content.innerHTML = `<div class="text-red-600 p-4 bg-red-50 rounded-lg">
                <p class="font-semibold">Could not load document</p>
                <p class="text-sm mt-1">${err.message}</p>
                <a href="${url}" target="_blank" class="text-blue-600 text-sm mt-2 inline-block">Open directly →</a>
            </div>`;
        });
}

function closeDocModal() {
    document.getElementById('doc-modal').classList.add('hidden');
    document.body.style.overflow = '';
}

// Auto-initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDocModal);
} else {
    initDocModal();
}
