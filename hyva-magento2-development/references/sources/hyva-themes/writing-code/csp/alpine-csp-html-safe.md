<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-html-safe.html -->

# Alpine CSP: x-html-safe

Standard Alpine.js ships an `x-html` directive that sets `el.innerHTML` directly from an expression, with no sanitization involved. Starting with **Alpine CSP 3.15**, the [Alpine CSP build](alpine-csp.html) removes `x-html` entirely, because rendering arbitrary HTML is exactly the kind of unrestricted capability a strict Content Security Policy is meant to prevent.

Starting with Hyvä 1.5.3, `hyva-themes/magento2-theme-module` ships a drop-in replacement: `x-html-safe`. It renders HTML through a fixed tag and attribute allowlist instead of setting `innerHTML` directly, so CSP themes can still render server-generated HTML fragments (price and tax markup, for example) without reintroducing the risk that removing `x-html` was meant to avoid. It also works on the standard, non-CSP Alpine build.

See the [`x-html-safe` plugin docs](../../working-with-alpinejs/alpine-plugins/x-html-safe.html) for usage, the sanitization model, the full allowlist, and how to migrate existing `x-html` templates.

## Related Topics

- **[Alpine CSP](alpine-csp.html)**: Overview of Alpine CSP build limitations and how to write compatible code
- **[Alpine CSP Example Component](alpine-csp-example-component.html)**: Complete working example of a CSP-compatible component
