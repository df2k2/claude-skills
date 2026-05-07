# Welcome-back modal for logged-in customers (Hyvä 1.4, non-CSP)

A small once-per-session modal that:

- Listens for `private-content-loaded` and reads `customer.firstname` from section data
- Only opens for logged-in customers
- Uses `sessionStorage` so it shows once per browser session, on the homepage only
- Has a close button, traps focus, closes on `Esc` and outside-click
- Uses Tailwind utilities and a small `x-transition`

This is Hyvä 1.4 standard (non-CSP), so we can use inline `x-data` expressions. (If you ever switch to `Hyva/default-csp` for PCI pages, this same component needs to be re-expressed via `Alpine.data('welcomeBackModal', () => ({...}))` registered on `alpine:init`.)

---

## 1. File locations

Assuming your child theme is `app/design/frontend/Acme/default/` (replace `Acme/default` with your vendor and theme name):

```
app/design/frontend/Acme/default/
├── Magento_Theme/
│   ├── layout/
│   │   └── hyva_cms_index_index.xml          ← attach the block to the homepage
│   └── templates/
│       └── html/
│           └── welcome-back-modal.phtml      ← the modal markup + Alpine
```

Why `hyva_cms_index_index.xml`? Magento's homepage uses the `cms_index_index` handle. Hyvä also applies a `hyva_cms_index_index` handle right after, so layout XML in that file only runs on Hyvä storefronts. Using the `hyva_*` handle is the convention for Hyvä-specific layout changes — see `references/templates-and-blocks.md`.

---

## 2. The template

`app/design/frontend/Acme/default/Magento_Theme/templates/html/welcome-back-modal.phtml`:

```php
<?php
declare(strict_types=1);

/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */

// sessionStorage key — bump suffix if you change the message and want it to re-show
$storageKey = 'acme_welcome_back_shown_v1';
?>
<div
    x-data="{
        open: false,
        firstName: '',
        storageKey: '<?= $escaper->escapeJs($storageKey) ?>',
        receive(detail) {
            const customer = detail && detail.data && detail.data.customer;
            if (!customer || !customer.firstname) {
                return;
            }
            if (sessionStorage.getItem(this.storageKey) === '1') {
                return;
            }
            this.firstName = customer.firstname;
            this.open = true;
            sessionStorage.setItem(this.storageKey, '1');
        },
        close() {
            this.open = false;
        }
    }"
    @private-content-loaded.window="receive($event.detail)"
    @keydown.escape.window="open && close()"
    x-cloak
>
    <template x-if="open">
        <div
            class="fixed inset-0 z-50 flex items-center justify-center p-4"
            role="dialog"
            aria-modal="true"
            aria-labelledby="welcome-back-title"
        >
            <!-- Backdrop -->
            <div
                class="absolute inset-0 bg-black/50"
                @click="close()"
                aria-hidden="true"
            ></div>

            <!-- Dialog -->
            <div
                class="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6"
                x-trap.noscroll="open"
                x-transition:enter="transition ease-out duration-200"
                x-transition:enter-start="opacity-0 scale-95"
                x-transition:enter-end="opacity-100 scale-100"
                x-transition:leave="transition ease-in duration-150"
                x-transition:leave-start="opacity-100 scale-100"
                x-transition:leave-end="opacity-0 scale-95"
            >
                <button
                    type="button"
                    @click="close()"
                    class="absolute top-3 right-3 p-1 rounded hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-primary"
                    aria-label="<?= $escaper->escapeHtmlAttr(__('Close')) ?>"
                >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                </button>

                <h2 id="welcome-back-title" class="text-xl font-semibold mb-2">
                    <?= $escaper->escapeHtml(__('Welcome back,')) ?>
                    <span x-text="firstName"></span>!
                </h2>
                <p class="text-gray-700 mb-4">
                    <?= $escaper->escapeHtml(__('Great to see you again. Browse our latest arrivals and pick up where you left off.')) ?>
                </p>

                <div class="flex justify-end">
                    <button
                        type="button"
                        @click="close()"
                        class="btn btn-primary"
                    >
                        <?= $escaper->escapeHtml(__('Got it')) ?>
                    </button>
                </div>
            </div>
        </div>
    </template>
</div>
```

### Why this code looks the way it does

- **`@private-content-loaded.window`** — Hyvä broadcasts customer/cart data as a `CustomEvent` on `window`. The `.window` modifier subscribes from inside the component. Source: `references/section-data.md`.
- **`customer.firstname`** — that's the actual key shape Hyvä exposes. There's also `customer.fullname`, `customer.custom_attributes`, etc. To inspect the full object once: open devtools console and run `addEventListener('private-content-loaded', e => console.log(e.detail.data)); dispatchEvent(new Event('reload-customer-section-data'))`.
- **Guest check** — section data for guests has no `firstname`, so the `if (!customer || !customer.firstname) return` line is the "logged-in" gate. Don't render anything server-side that depends on customer state, otherwise FPC will cache the wrong variant.
- **`sessionStorage` (not `localStorage`)** — once-per-session means it resets when the tab closes. If you wanted "once ever" use `localStorage`; if you wanted "once per day" store a timestamp.
- **`x-cloak`** — keeps the empty wrapper invisible during the brief window before Alpine initializes. Hyvä's base CSS already has `[x-cloak] { display: none !important; }`.
- **`<template x-if="open">`** — using `x-if` (not `x-show`) means the modal isn't even in the DOM until needed. This matters because focus-trap and transitions behave better when the element is freshly mounted, and any stray scripts inside don't run for users who never see it.
- **`x-trap.noscroll`** — `@alpinejs/focus` ships with Hyvä. `x-trap` confines tab navigation inside the dialog and the `.noscroll` modifier locks the body from scrolling while the modal is open. Source: `references/window-hyva-helpers.md`.
- **`@click="close()"` on the backdrop and `@keydown.escape.window`** — standard modal a11y. The escape handler is gated on `open` so it doesn't swallow Escape keys when nothing is open.
- **No data passed from PHP** — the customer's first name comes from the client-side section-data event, not from the rendered HTML. That's deliberate: the homepage HTML is FPC-cached and shared across all visitors. Pulling the name from PHP would either bust FPC or leak Customer A's name to Customer B.
- **`btn btn-primary`** — those are Hyvä's default theme component classes. If your child theme doesn't extend them, swap for plain Tailwind utilities (e.g. `bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded`).

---

## 3. The layout XML

`app/design/frontend/Acme/default/Magento_Theme/layout/hyva_cms_index_index.xml`:

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="after.body.start">
            <block name="acme.welcome.back.modal"
                   template="Magento_Theme::html/welcome-back-modal.phtml"/>
        </referenceContainer>
    </body>
</page>
```

`after.body.start` is a Hyvä container that renders right after `<body>` opens — a good spot for overlays/modals so they sit above page content in the DOM. If your theme doesn't have it (it does in Hyvä 1.4), `before.body.end` works equally well.

If you only want the modal on the configured CMS homepage (and not on any CMS page that someone might set as homepage), `cms_index_index` is the correct handle — it's specific to the storefront default home route.

---

## 4. Build & deploy

After saving the files:

```bash
# Pick up new layout XML / phtml
bin/magento cache:flush

# Rebuild Tailwind so any new utility classes (bg-black/50, max-w-md, etc.)
# are present in the compiled CSS. Run from your child theme:
cd app/design/frontend/Acme/default/web/tailwind
npm run build
# (or `npm run watch` while iterating)

# In production also run:
bin/magento setup:static-content:deploy -f
```

If classes don't appear after the build, it's almost always Tailwind's content scanner not finding them. The default `tailwind.config.js` content globs already include `**/*.phtml`, so this template is picked up automatically.

---

## 5. Quick sanity-test plan

1. Log in as a customer and visit `/` (the homepage). The modal should appear once.
2. Reload the homepage in the same tab — modal should *not* re-appear.
3. Close the tab, reopen it, log in, hit the homepage — modal appears again (new session).
4. Visit any non-homepage URL — modal block isn't loaded there, so nothing renders.
5. Log out, visit the homepage — section data has no `firstname`, so `receive()` exits early, `open` stays `false`, modal never appears.
6. Tab through the modal: focus stays inside; press Escape: closes; click outside the dialog: closes.

If the modal isn't firing for a logged-in customer, run this in the console:

```js
addEventListener('private-content-loaded', e => console.log(e.detail.data.customer));
dispatchEvent(new Event('reload-customer-section-data'));
```

You should see `{firstname: "Jane", fullname: "Jane Doe", ...}`. If `customer` is `false` or empty, FPC may have cached an anonymous version of the page or the customer cookie isn't being sent — both are environmental, not template issues.

---

## 6. Variations you might want

- **Once per day** — replace `sessionStorage` calls with a `localStorage` write that stores a timestamp:
  ```js
  const last = parseInt(localStorage.getItem(this.storageKey) || '0', 10);
  if (Date.now() - last < 86_400_000) return;
  // ...show modal...
  localStorage.setItem(this.storageKey, String(Date.now()));
  ```
- **Limit to first N pageloads** — store an integer in `sessionStorage` and increment.
- **Show on every page (not only homepage)** — move the block declaration to `hyva_default.xml` instead.
- **CSP-strict version** — see `references/alpine-csp.md`. The component body becomes a registered `Alpine.data('welcomeBackModal', () => ({ ... }))` and `x-data="welcomeBackModal"`. Inline expressions like `open && close()` need to be method calls instead.

That's it — drop in the two files, flush cache, rebuild Tailwind, and you have a per-session welcome-back modal driven entirely by Hyvä's section-data flow.
