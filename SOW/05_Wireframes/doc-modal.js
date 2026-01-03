/**
 * Document & Diagram Modal - Opens documents and diagrams in modal overlays
 * Supports: Markdown files (.md) with Mermaid diagrams, and SVG files (.svg)
 */

// Track if Mermaid is loaded
let mermaidLoaded = false;

// Track the base URL of the currently loaded document (for resolving relative links)
let currentDocBaseUrl = null;

function loadMermaid() {
    return new Promise((resolve) => {
        if (mermaidLoaded) {
            resolve();
            return;
        }
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js';
        script.onload = () => {
            mermaid.initialize({
                startOnLoad: false,
                theme: 'default',
                securityLevel: 'loose',
                flowchart: { useMaxWidth: true, htmlLabels: true }
            });
            mermaidLoaded = true;
            resolve();
        };
        document.head.appendChild(script);
    });
}

function initDocModal() {
    // Create modal HTML
    const modalHTML = `
    <div id="doc-modal" class="fixed inset-0 z-[100] hidden">
        <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" onclick="closeDocModal()"></div>
        <div class="absolute inset-4 md:inset-8 lg:inset-12 bg-white rounded-xl shadow-2xl flex flex-col overflow-hidden">
            <div class="flex items-center justify-between px-6 py-4 border-b bg-gray-50">
                <h3 id="doc-modal-title" class="font-semibold text-gray-900 truncate">Loading...</h3>
                <button onclick="closeDocModal()" class="p-2 hover:bg-gray-200 rounded-lg transition-colors text-gray-700">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>
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
        .prose h4 { font-size: 1.125rem; font-weight: 600; margin-top: 1.25rem; margin-bottom: 0.5rem; color: #374151; }
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
        .diagram-container { display: flex; align-items: center; justify-content: center; min-height: 400px; background: #fafafa; border-radius: 0.5rem; }
        .diagram-container object, .diagram-container img { max-width: 100%; max-height: 70vh; }
        .mermaid-diagram { background: #fafafa; border-radius: 0.5rem; padding: 1rem; margin: 1rem 0; overflow-x: auto; }
        .mermaid-diagram svg { max-width: 100%; height: auto; }
    </style>`;

    // Inject modal and styles
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    document.head.insertAdjacentHTML('beforeend', styleHTML);

    // Close on Escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeDocModal();
    });

    // Intercept markdown and SVG links
    document.addEventListener('click', (e) => {
        const link = e.target.closest('a');
        if (!link) return;

        const href = link.getAttribute('href');
        if (!href) return;

        // Skip external links and anchors
        if (href.startsWith('http') || href.startsWith('#')) return;

        // Strip hash/anchor to check file extension
        const hrefWithoutHash = href.split('#')[0];

        // Handle markdown files (including those with anchors like file.md#section)
        if (hrefWithoutHash.endsWith('.md')) {
            e.preventDefault();
            const title = link.textContent?.trim() || hrefWithoutHash.split('/').pop().replace('.md', '');

            // Check if this link is inside the modal content
            const isInsideModal = link.closest('#doc-modal-content');
            let resolvedUrl;

            if (isInsideModal && currentDocBaseUrl) {
                // Resolve relative to the currently loaded document
                resolvedUrl = new URL(href, currentDocBaseUrl).href;
            } else {
                // Resolve relative to the page
                resolvedUrl = link.href;
            }

            openDocModal(resolvedUrl, title, 'markdown');
            return;
        }

        // Handle YAML files
        if (hrefWithoutHash.endsWith('.yaml') || hrefWithoutHash.endsWith('.yml')) {
            e.preventDefault();
            const title = link.textContent?.trim() || hrefWithoutHash.split('/').pop();

            const isInsideModal = link.closest('#doc-modal-content');
            let resolvedUrl;

            if (isInsideModal && currentDocBaseUrl) {
                resolvedUrl = new URL(href, currentDocBaseUrl).href;
            } else {
                resolvedUrl = link.href;
            }

            openDocModal(resolvedUrl, title, 'yaml');
            return;
        }

        // Handle SVG diagrams
        if (hrefWithoutHash.endsWith('.svg')) {
            e.preventDefault();
            const title = link.querySelector('h3')?.textContent ||
                          link.textContent?.trim() ||
                          hrefWithoutHash.split('/').pop().replace('.svg', '').replace(/_/g, ' ');

            // Check if this link is inside the modal content
            const isInsideModal = link.closest('#doc-modal-content');
            let resolvedUrl;

            if (isInsideModal && currentDocBaseUrl) {
                resolvedUrl = new URL(href, currentDocBaseUrl).href;
            } else {
                resolvedUrl = link.href;
            }

            openDocModal(resolvedUrl, title, 'svg');
            return;
        }
    });
}

async function renderMermaidDiagrams(container) {
    // Find all code blocks with class 'language-mermaid' (marked.js format)
    const mermaidBlocks = container.querySelectorAll('code.language-mermaid');

    if (mermaidBlocks.length === 0) return;

    // Load Mermaid if not already loaded
    await loadMermaid();

    // Process each mermaid block
    for (let i = 0; i < mermaidBlocks.length; i++) {
        const codeBlock = mermaidBlocks[i];
        const preBlock = codeBlock.parentElement;
        const mermaidCode = codeBlock.textContent;

        try {
            const { svg } = await mermaid.render(`mermaid-${Date.now()}-${i}`, mermaidCode);
            const wrapper = document.createElement('div');
            wrapper.className = 'mermaid-diagram';
            wrapper.innerHTML = svg;
            preBlock.replaceWith(wrapper);
        } catch (err) {
            console.warn('Mermaid render error:', err);
            // Leave original code block on error
        }
    }
}

function openDocModal(url, title, type = 'markdown') {
    const modal = document.getElementById('doc-modal');
    const content = document.getElementById('doc-modal-content');
    const titleEl = document.getElementById('doc-modal-title');

    // Parse URL for anchor
    const urlObj = new URL(url, window.location.href);
    const anchor = urlObj.hash;
    const baseUrl = url.split('#')[0];

    // Store the base URL for resolving relative links in the loaded content
    currentDocBaseUrl = baseUrl;

    titleEl.textContent = title || 'Loading...';
    content.innerHTML = '<div class="flex items-center justify-center h-32"><div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div></div>';
    modal.classList.remove('hidden');
    document.body.style.overflow = 'hidden';

    if (type === 'svg') {
        // Display SVG diagram
        content.innerHTML = `
            <div class="diagram-container">
                <object data="${baseUrl}" type="image/svg+xml" style="width: 100%; height: auto;">
                    <img src="${baseUrl}" alt="${title}" />
                </object>
            </div>`;
        content.classList.remove('prose');
    } else if (type === 'yaml') {
        // Fetch and display YAML as code
        content.classList.add('prose');
        fetch(baseUrl)
            .then(response => {
                if (!response.ok) throw new Error('Failed to load YAML file');
                return response.text();
            })
            .then(yaml => {
                // Escape HTML entities for safe display
                const escaped = yaml.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                content.innerHTML = `<pre style="background: #1f2937; color: #e5e7eb; padding: 1rem; border-radius: 0.5rem; overflow-x: auto; font-size: 0.875rem; line-height: 1.5;"><code>${escaped}</code></pre>`;
            })
            .catch(err => {
                content.innerHTML = `<div class="text-red-600 p-4 bg-red-50 rounded-lg">
                    <p class="font-semibold">Could not load YAML file</p>
                    <p class="text-sm mt-1">${err.message}</p>
                    <a href="${url}" target="_blank" class="text-blue-600 text-sm mt-2 inline-block">Open directly →</a>
                </div>`;
            });
    } else {
        // Fetch and render markdown
        content.classList.add('prose');
        fetch(baseUrl)
            .then(response => {
                if (!response.ok) throw new Error('Failed to load document');
                return response.text();
            })
            .then(async markdown => {
                content.innerHTML = marked.parse(markdown);
                // Extract title from first H1
                const h1 = content.querySelector('h1');
                if (h1) {
                    titleEl.textContent = h1.textContent;
                }
                // Render any Mermaid diagrams
                await renderMermaidDiagrams(content);

                // Scroll to anchor if present
                if (anchor) {
                    const targetId = anchor.substring(1); // Remove #
                    const targetEl = content.querySelector(`#${CSS.escape(targetId)}`);
                    if (targetEl) {
                        // Small delay to ensure rendering is complete
                        setTimeout(() => {
                            targetEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
                            // Highlight the section briefly
                            targetEl.style.backgroundColor = '#fef3c7';
                            setTimeout(() => {
                                targetEl.style.transition = 'background-color 1s';
                                targetEl.style.backgroundColor = '';
                            }, 500);
                        }, 100);
                    }
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
}

function closeDocModal() {
    const modal = document.getElementById('doc-modal');
    const content = document.getElementById('doc-modal-content');
    modal.classList.add('hidden');
    document.body.style.overflow = '';
    content.classList.add('prose'); // Reset for next use
    currentDocBaseUrl = null; // Clear the base URL
}

// Auto-initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDocModal);
} else {
    initDocModal();
}
