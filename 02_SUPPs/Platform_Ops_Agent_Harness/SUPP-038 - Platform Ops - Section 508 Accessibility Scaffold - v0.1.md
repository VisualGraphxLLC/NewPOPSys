# SUPP-038 — Section 508 Accessibility Scaffold

> **Version**: v0.1
> **Status**: Draft (v1.1 Target)
> **Updated**: 2025-12-20
> **Dependencies**: All UI SUPPs (SUPP-036, SUPP-037)

---

## Purpose

Define accessibility requirements for Federal Government marketing readiness. This document scaffolds v1 development patterns that enable full WCAG 2.0 Level AA compliance in v1.1.

**Target:** Section 508 of the Rehabilitation Act (29 U.S.C. 794d) — required for Federal agency contracts.

---

## v1 Scaffold Requirements (Build Now)

These patterns MUST be implemented in v1 to avoid costly retrofitting in v1.1.

### 1. Semantic HTML Structure

| Requirement | v1 Implementation | v1.1 Audit |
|-------------|-------------------|------------|
| Use semantic elements | `<header>`, `<nav>`, `<main>`, `<footer>`, `<section>`, `<article>` | Verify no `<div>` soup |
| Heading hierarchy | `<h1>` → `<h2>` → `<h3>` (no skips) | Automated heading audit |
| Landmark regions | All pages have main landmark | Screen reader navigation test |
| Lists | Use `<ul>`, `<ol>` for lists, not styled divs | Semantic validation |
| Tables | Use `<table>` with `<th>`, `<caption>` for data | Table structure audit |

**Component Library:**
```tsx
// v1: Enforce semantic structure in shared components
<PageLayout>
  <header role="banner">...</header>
  <nav role="navigation">...</nav>
  <main role="main" id="main-content">...</main>
  <footer role="contentinfo">...</footer>
</PageLayout>
```

### 2. Keyboard Navigation Foundation

| Requirement | v1 Implementation | v1.1 Audit |
|-------------|-------------------|------------|
| Tab order | Use native focus order; avoid `tabindex > 0` | Tab order test |
| Focus visible | Never `outline: none` without alternative | Visual focus test |
| Skip link | First focusable element: "Skip to main content" | Screen reader test |
| Focus trap modals | Modals trap focus; Escape closes | Modal keyboard test |
| No keyboard traps | All interactive elements keyboard-escapable | Keyboard-only navigation |

**v1 Component Pattern:**
```tsx
// Skip link component - add to layout
<a href="#main-content" className="sr-only focus:not-sr-only">
  Skip to main content
</a>

// Focus visible styles (Tailwind)
className="focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
```

### 3. Form Accessibility

| Requirement | v1 Implementation | v1.1 Audit |
|-------------|-------------------|------------|
| Labels | Every `<input>` has associated `<label>` | Label association test |
| Error identification | Errors linked via `aria-describedby` | Error announcement test |
| Required fields | `aria-required="true"` + visual indicator | Required field test |
| Error prevention | Confirmation for destructive actions | UX review |
| Input purpose | `autocomplete` attributes for user data | Autocomplete audit |

**v1 Form Pattern:**
```tsx
<div>
  <label htmlFor="store-name" id="store-name-label">
    Store Name <span aria-hidden="true">*</span>
  </label>
  <input
    id="store-name"
    aria-labelledby="store-name-label"
    aria-describedby={error ? "store-name-error" : undefined}
    aria-required="true"
    aria-invalid={!!error}
  />
  {error && (
    <span id="store-name-error" role="alert">
      {error}
    </span>
  )}
</div>
```

### 4. Color and Contrast

| Requirement | v1 Implementation | v1.1 Audit |
|-------------|-------------------|------------|
| Text contrast | 4.5:1 minimum (standard text) | Contrast checker |
| Large text | 3:1 minimum (18pt+ or 14pt bold) | Contrast checker |
| UI components | 3:1 for borders, icons, focus indicators | Component contrast audit |
| Color independence | Never use color alone to convey meaning | UX review + colorblind test |

**v1 Design Token Compliance:**
```css
/* Accessible color pairs (pre-validated) */
--text-primary: #1f2937;      /* gray-800 on white: 12.6:1 */
--text-secondary: #4b5563;    /* gray-600 on white: 7.0:1 */
--text-on-primary: #ffffff;   /* white on blue-600: 4.5:1 */
--error-text: #991b1b;        /* red-800 on white: 9.4:1 */
--success-text: #166534;      /* green-800 on white: 7.1:1 */

/* Status badges: always include icon + text, not just color */
```

### 5. Interactive Component Patterns

| Component | v1 ARIA Pattern | Notes |
|-----------|-----------------|-------|
| **Buttons** | `<button>` or `role="button"` + `tabindex="0"` | Never div-as-button |
| **Links** | `<a href="...">` with descriptive text | No "click here" |
| **Modals** | `role="dialog"` + `aria-modal="true"` + `aria-labelledby` | Focus trap required |
| **Tabs** | `role="tablist"` + `role="tab"` + `role="tabpanel"` | Arrow key navigation |
| **Dropdowns** | `role="listbox"` or native `<select>` | Keyboard selectable |
| **Alerts** | `role="alert"` for important messages | Auto-announces |
| **Loading** | `aria-live="polite"` + `aria-busy` | Announce completion |
| **Progress** | `role="progressbar"` + `aria-valuenow` | Screen reader friendly |

### 6. Image and Media

| Requirement | v1 Implementation | v1.1 Audit |
|-------------|-------------------|------------|
| Alt text | All `<img>` have `alt` attribute | Automated audit |
| Decorative images | `alt=""` or `role="presentation"` | Manual review |
| Complex images | `aria-describedby` linking to description | Screen reader test |
| Icons | Icon-only buttons have `aria-label` | Icon audit |

**v1 Pattern:**
```tsx
// Informative image
<img src="..." alt="Store #1042 front window installation" />

// Decorative image
<img src="..." alt="" role="presentation" />

// Icon button
<button aria-label="Close modal">
  <XIcon aria-hidden="true" />
</button>
```

### 7. Mobile/PWA Accessibility (Store Module)

| Requirement | v1 Implementation | v1.1 Audit |
|-------------|-------------------|------------|
| Touch targets | Minimum 44x44px | Component audit |
| Text resize | Content readable at 200% zoom | Zoom test |
| Orientation | Works in portrait and landscape | Orientation test |
| Motion | Respect `prefers-reduced-motion` | Motion test |

**v1 Touch Target Pattern:**
```css
/* Minimum touch target size */
.touch-target {
  min-width: 44px;
  min-height: 44px;
  padding: 12px;
}

/* Respect motion preferences */
@media (prefers-reduced-motion: reduce) {
  * {
    animation: none !important;
    transition: none !important;
  }
}
```

---

## v1.1 Full Compliance (Implement Later)

These requirements need v1 scaffolding but full implementation in v1.1:

### Screen Reader Testing
- [ ] VoiceOver (iOS/macOS) testing pass
- [ ] NVDA (Windows) testing pass
- [ ] JAWS (Windows) testing pass
- [ ] TalkBack (Android) testing pass

### Automated Testing Suite
- [ ] axe-core integration in CI/CD
- [ ] Lighthouse accessibility audits
- [ ] Pa11y automated testing
- [ ] Custom WCAG 2.0 AA checklist

### Documentation
- [ ] VPAT (Voluntary Product Accessibility Template)
- [ ] Accessibility Statement page
- [ ] Keyboard shortcuts documentation
- [ ] Screen reader user guide

### Advanced Features
- [ ] High contrast mode support
- [ ] Custom focus indicator themes
- [ ] Text spacing compliance (WCAG 1.4.12)
- [ ] Reflow at 400% zoom (WCAG 1.4.10)

---

## Component Checklist (v1 Scaffold)

Every new component MUST include:

```tsx
// Component accessibility checklist
// [ ] Semantic HTML element (not div for interactive)
// [ ] Keyboard accessible (Tab, Enter, Space, Escape)
// [ ] Focus visible indicator
// [ ] ARIA labels/descriptions where needed
// [ ] Color contrast compliant
// [ ] Touch target size (mobile)
// [ ] Screen reader tested (basic)
```

---

## Testing in v1

### Minimum v1 Testing
1. **Keyboard-only navigation**: Complete all workflows without mouse
2. **Focus order**: Tab through page, verify logical order
3. **Color contrast**: Run automated contrast checker on all pages
4. **Zoom test**: 200% browser zoom, verify no content loss

### v1 CI/CD Gate
```yaml
# Add to PR checks
- name: Accessibility Check
  run: |
    npx axe-core --tags wcag2a,wcag2aa
    # Fail on critical/serious issues
```

---

## Federal Procurement Language

When PopSystem achieves v1.1 compliance, marketing materials can include:

> "PopSystem is designed to meet Section 508 accessibility requirements and
> WCAG 2.0 Level AA success criteria, enabling Federal agencies to deploy
> the platform in compliance with accessibility mandates."

**Required artifact:** VPAT (Voluntary Product Accessibility Template) documenting compliance status for each WCAG criterion.

---

## Related Documents

| Document | Purpose |
|----------|---------|
| [WCAG 2.0 Guidelines](https://www.w3.org/TR/WCAG20/) | Full specification |
| [Section 508 Standards](https://www.access-board.gov/ict/) | Federal requirements |
| [VPAT Template](https://www.itic.org/policy/accessibility/vpat) | Compliance documentation |

---

*End of SUPP-038*
