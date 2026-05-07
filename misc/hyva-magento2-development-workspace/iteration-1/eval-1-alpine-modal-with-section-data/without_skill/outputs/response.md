# Hyvä 1.4 — Once-Per-Session "Welcome Back" Modal for Logged-In Customers

This guide adds a small Alpine.js modal that appears **once per browser session** on the **homepage** for **logged-in customers**, displays the customer's first name from Magento's `customer` section data, and includes a close button. It targets the standard (non-CSP) Hyvä default theme.

---

## 1. Overview of the approach

Hyvä's recommended pattern for this kind of UI is:

- **Layout XML** — add a phtml block to the homepage only (`cms_index_index`).
- **One self-contained `.phtml` file** — wrap your Alpine component in `<div x-data="welcomeBackModal()" x-cloak>` and inline the component definition inside `<script>` (no CSP nonces needed because we're targeting the standard, non-CSP theme).
- **Use Hyvä's private content "section data"** — `window.hyva.getCustomer()` returns the same private-content `customer` section data Magento populates after login. It is read client-side from `localStorage`/the private content cookie, so you don't need a server round-trip and the page stays cacheable.
- **`sessionStorage`** is used to track "shown this session" so the modal appears at most once until the tab/browser session ends.

This avoids tampering with full-page cache, Varnish, or PHP block caching: the page stays fully cacheable and the personalisation happens entirely in the browser.

---

## 2. File locations

Assume your child theme is `app/design/frontend/Acme/default` (replace `Acme/default` with your actual `Vendor/theme`).

Create these two files:

```
app/design/frontend/Acme/default/
├── Magento_Cms/
│   └── layout/
│       └── cms_index_index.xml
└── Magento_Theme/
    └── templates/
        └── html/
            └── welcome-back-modal.phtml
```

Why these locations:

- `Magento_Cms/layout/cms_index_index.xml` is the layout handle for **the CMS homepage only** (`cms_index_index`). Putting the block here guarantees it never appears on category, product, cart, or checkout pages.
- The phtml lives under `Magento_Theme/templates/html/` because it's a generic UI component, not tied to any specific module's templates. (You could equally place it under your own custom module's templates if you have one — the layout reference in step 3 just needs to match.)

---

## 3. Layout XML — `cms_index_index.xml`

Create `app/design/frontend/Acme/default/Magento_Cms/layout/cms_index_index.xml`:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="after.body.start">
            <block name="welcome.back.modal"
                   template="Magento_Theme::html/welcome-back-modal.phtml"/>
        </referenceContainer>
    </body>
</page>
```

Notes:

- `after.body.start` is a Hyvä-defined container that renders right after `<body>` opens. It's a clean spot for overlays/modals so they don't get clipped by parent stacking contexts.
- Alternatively you can use `referenceContainer name="content"` if you'd prefer it to render inside the main content column.
- The block's `template` attribute uses the `Magento_Theme::` prefix, which matches the file's location under `Magento_Theme/templates/`.

---

## 4. The phtml component — `welcome-back-modal.phtml`

Create `app/design/frontend/Acme/default/Magento_Theme/templates/html/welcome-back-modal.phtml`:

```php
<?php
/**
 * Welcome-back modal for logged-in customers on the homepage.
 *
 * @var \Magento\Framework\View\Element\Template $block
 * @var \Magento\Framework\Escaper                $escaper
 */
?>
<div
    x-data="welcomeBackModal()"
    x-init="init()"
    x-show="open"
    x-cloak
    @keydown.escape.window="close()"
    role="dialog"
    aria-modal="true"
    aria-labelledby="welcome-back-title"
    class="fixed inset-0 z-50 flex items-center justify-center p-4"
>
    <!-- Backdrop -->
    <div
        x-show="open"
        x-transition.opacity
        class="absolute inset-0 bg-black/50"
        @click="close()"
        aria-hidden="true"
    ></div>

    <!-- Modal panel -->
    <div
        x-show="open"
        x-transition
        class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6"
        @click.stop
    >
        <button
            type="button"
            @click="close()"
            class="absolute top-3 right-3 text-gray-400 hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-primary rounded"
            aria-label="<?= $escaper->escapeHtmlAttr(__('Close')) ?>"
        >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                      d="M6 18L18 6M6 6l12 12"/>
            </svg>
        </button>

        <h2 id="welcome-back-title" class="text-2xl font-semibold mb-2">
            <?= $escaper->escapeHtml(__('Welcome back')) ?>,
            <span x-text="firstName"></span>!
        </h2>

        <p class="text-gray-600 mb-6">
            <?= $escaper->escapeHtml(__('Glad to see you again. Pick up where you left off.')) ?>
        </p>

        <div class="flex justify-end">
            <button
                type="button"
                @click="close()"
                class="btn btn-primary"
            >
                <?= $escaper->escapeHtml(__('Continue shopping')) ?>
            </button>
        </div>
    </div>
</div>

<script>
    function welcomeBackModal() {
        return {
            open: false,
            firstName: '',

            init() {
                // Wait for hyva private content to be available, then decide whether to show.
                // The 'private-content-loaded' event fires after Hyva loads section data.
                window.addEventListener('private-content-loaded', () => this.maybeShow());

                // Also try immediately in case section data is already populated
                // (e.g. on subsequent navigations within the same tab).
                this.maybeShow();
            },

            maybeShow() {
                // Already shown this session? Bail out.
                if (sessionStorage.getItem('welcomeBackShown') === '1') {
                    return;
                }

                const customer = window.hyva && window.hyva.getCustomer
                    ? window.hyva.getCustomer()
                    : null;

                // Not logged in (no firstname populated) — do nothing.
                if (!customer || !customer.firstname) {
                    return;
                }

                this.firstName = customer.firstname;
                this.open = true;

                // Mark as shown so it won't reappear until the browser session ends.
                sessionStorage.setItem('welcomeBackShown', '1');
            },

            close() {
                this.open = false;
            },
        };
    }
</script>
```

### Notes on the code

- **`x-cloak`** hides the wrapper until Alpine initialises so users never see a flash of unstyled markup. Hyvä's default theme already ships the matching `[x-cloak]{display:none!important}` CSS rule.
- **`window.hyva.getCustomer()`** is the documented Hyvä helper that reads the `customer` section from private content. It returns an object with at least `firstname`, `fullname`, `email`, and `customer_group_id` when the user is logged in; otherwise the relevant fields are empty/missing.
- **`private-content-loaded`** is the event Hyvä dispatches once private content has been fetched and stored. Listening for it ensures we don't try to read customer data before it exists. We also call `maybeShow()` once immediately for cases where private content was already in `localStorage` from a previous request (so the modal appears without a perceptible delay).
- **`sessionStorage`** persists for the lifetime of the browser tab/session — exactly the "once per session" semantics you asked for. Cleared automatically when the tab/browser closes.
- **`@keydown.escape.window`** lets users close with the Escape key.
- **`@click.stop` on the panel** prevents a click inside the panel from bubbling to the backdrop and closing the modal.
- **Tailwind classes** (`fixed inset-0 z-50`, `bg-black/50`, etc.) are stock Tailwind 3 utilities that Hyvä compiles. The `btn btn-primary` classes come from Hyvä's component layer (`@layer components` in `tailwind/components/buttons.css`); if your theme has renamed those, swap them for your own.
- **No CSP nonce** is added because the prompt specifies the standard (non-CSP) Hyvä default theme. If you ever switch to the CSP variant, change `<script>` to `<script <?= $secureRenderer->renderTag('script', [], '', false) ?>>` (using the `Magento\Framework\View\Helper\SecureHtmlRenderer`) or move the function definition into a separate JS file.
- **Escaping**: text strings are escaped via `$escaper->escapeHtml(...)` for translatable text and `$escaper->escapeHtmlAttr(...)` for the `aria-label`. The customer's name is rendered through Alpine's `x-text` binding, which sets `textContent`, so it's automatically safe from XSS.

---

## 5. Step-by-step instructions

1. **Create the layout file** at `app/design/frontend/Acme/default/Magento_Cms/layout/cms_index_index.xml` with the content from section 3.
2. **Create the template file** at `app/design/frontend/Acme/default/Magento_Theme/templates/html/welcome-back-modal.phtml` with the content from section 4.
3. **Clear caches and regenerate**:
   ```bash
   bin/magento cache:flush
   bin/magento cache:clean config full_page layout block_html
   ```
4. **Recompile Tailwind** so any new utility classes used in the phtml are included in the generated CSS:
   ```bash
   cd app/design/frontend/Acme/default/web/tailwind
   npm install        # only the first time
   npm run build-prod # or `npm run watch` during development
   ```
   Hyvä's Tailwind config scans your theme's `**/*.phtml`, so dropping the new file into the theme is enough — just rebuild.
5. **Static-content deploy in production mode** (skip in developer mode):
   ```bash
   bin/magento setup:static-content:deploy -f
   ```
6. **Test**:
   - Log out, visit the homepage — modal should not appear.
   - Log in as a customer, visit the homepage — modal appears with the first name.
   - Close the modal, refresh — modal should *not* re-appear.
   - Open a new tab and go to the homepage while still logged in — it should *not* re-appear (sessionStorage is shared across tabs of the same origin in most browsers; if you want per-tab, that's automatic since each new tab gets its own sessionStorage in some browsers — clarify the semantics you want).
   - Open a new private/incognito window — modal appears again (fresh sessionStorage).
   - Visit a category or product page — modal does **not** appear (layout handle scoped to `cms_index_index`).

---

## 6. Optional refinements

- **Reset on logout**: If you want to clear the "shown" flag when a customer logs out so the modal shows again next time they log in, add this small listener anywhere global (or extend the component's `init`):
  ```js
  window.addEventListener('customer-data-invalidate', () => {
      sessionStorage.removeItem('welcomeBackShown');
  });
  ```
  Hyvä invalidates the customer section on logout, which triggers section reload; you can hook into that lifecycle.

- **Delay the appearance**: If you want a brief delay so the modal doesn't appear on the first paint:
  ```js
  setTimeout(() => this.maybeShow(), 600);
  ```

- **Persist longer than a session**: Swap `sessionStorage` for `localStorage` and add a date check (e.g. show at most once per 24 hours).

- **Customer group targeting**: `window.hyva.getCustomer().customer_group_id` is available, so you can show a different message for group ID 1 (general), wholesale groups, etc.:
  ```js
  if (customer.customer_group_id === 3) { /* wholesale copy */ }
  ```

- **Escape key & focus trap**: For full a11y compliance, consider adding a focus trap so Tab cycles within the modal. Hyvä doesn't ship a built-in focus-trap helper, but Alpine's `<template x-trap.inert.noscroll="open">…</template>` from the `@alpinejs/focus` plugin (which Hyvä bundles) does the job:
  ```html
  <div x-data="welcomeBackModal()"
       x-trap.inert.noscroll="open"
       …>
  ```

- **Multi-language `firstName`**: `window.hyva.getCustomer().firstname` already comes from the customer record so it's whatever the customer entered.

---

## 7. Why this pattern fits Hyvä

| Concern | Why this works |
|---|---|
| Page cacheability | The phtml renders the same markup for everyone — the personalisation is purely client-side from `localStorage`-backed section data. Magento full-page cache and Varnish are unaffected. |
| Performance | One small inline component, no extra JS bundle, no XHR on page load (private content was already fetched). |
| Hyvä idioms | Uses Alpine `x-data`, `x-show`, `x-transition`, `x-cloak`, `@click`, `@keydown.escape.window`, and Tailwind utility classes — the standard Hyvä toolkit. |
| Scoping | `cms_index_index.xml` ensures the block is only on the homepage — no need for runtime checks. |
| Logged-in detection | `window.hyva.getCustomer().firstname` is empty/undefined for guests, so we just check truthiness. |
| Session-once behaviour | `sessionStorage` is the simplest correct primitive. |

That's everything you need. The two files above plus a Tailwind rebuild and cache flush will give you a fully-working, idiomatic Hyvä 1.4 welcome-back modal.
