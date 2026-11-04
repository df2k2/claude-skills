# CSP-Compatible Alpine.js in Hyvä

## When to read this

The store uses `Hyva/default-csp`, payment pages need PCI-DSS 4.0 compliance, or any time you're building a component that must run under strict CSP (no `unsafe-eval`, no `unsafe-inline`).

Hyvä Checkout always runs under strict CSP — its components must be CSP-compatible.

## Why CSP needs different code

Alpine's standard build evaluates expressions like `x-data="{ open: false }"` at runtime — it parses the string and runs it, which requires `eval` or `Function()`. Strict CSP forbids both. So Alpine's CSP build:

- Cannot accept inline expressions in attributes (`x-data="{}"` won't work)
- Requires components to be **registered up front** via `Alpine.data('name', () => ({...}))`
- Limits what you can put in `x-show`, `@click`, etc. to **property accesses** and method calls, not arbitrary JS

The pre-PCI-DSS unsafe-inline allowance was deprecated April 1, 2025 for payment pages.

## Registering a component

Standard Alpine (won't work under CSP):
```html
<div x-data="{ open: false, toggle() { this.open = !this.open; } }">
    <button @click="toggle()">Toggle</button>
    <div x-show="open">Content</div>
</div>
```

CSP-safe variant:
```html
<div x-data="myToggle">
    <button @click="toggle">Toggle</button>
    <div x-show="open">Content</div>
</div>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('myToggle', () => ({
            open: false,
            toggle() { this.open = !this.open; }
        }));
    });
</script>
```

Three things changed:
1. `x-data="myToggle"` is now just a name — Alpine looks up the registered component.
2. `@click="toggle"` is a method reference, not an expression to evaluate.
3. The component is defined as data registered on `alpine:init`.

## What you can and can't put in attributes under CSP

**Allowed** (property/method access):
```html
<div x-show="open">…</div>
<button @click="toggle">…</button>
<button @click="setStatus('success')">…</button>
<input :value="user.name">
<div :class="cssClass">…</div>
```

**Forbidden** (inline JS expressions):
```html
<!-- ❌ Operators -->
<div x-show="open && !disabled">…</div>

<!-- ❌ Object/array literals -->
<button @click="items = [1,2,3]">…</button>

<!-- ❌ String concatenation -->
<span x-text="'Hello ' + name">…</span>

<!-- ❌ Ternary -->
<span x-text="open ? 'yes' : 'no'">…</span>

<!-- ❌ Negation in @click -->
<button @click="open = !open">…</button>
```

Move all of that into methods or computed properties on the component:

```js
Alpine.data('foo', () => ({
    open: false,
    disabled: false,
    items: [],
    name: 'world',
    get isVisible() { return this.open && !this.disabled; },
    get greeting() { return 'Hello ' + this.name; },
    get statusText() { return this.open ? 'yes' : 'no'; },
    toggle() { this.open = !this.open; },
    setItems() { this.items = [1, 2, 3]; }
}));
```

```html
<div x-data="foo">
    <div x-show="isVisible">…</div>
    <span x-text="greeting"></span>
    <span x-text="statusText"></span>
    <button @click="toggle">Toggle</button>
</div>
```

## `x-model` doesn't work under CSP

Standard Alpine: `<input x-model="name">` → handles two-way binding by parsing the expression. CSP build: `x-model` is unavailable (or limited).

The CSP-safe alternative:
```html
<input
    type="text"
    :value="name"
    @input="setName"
>
```

```js
Alpine.data('foo', () => ({
    name: '',
    setName(e) { this.name = e.target.value; }
}));
```

For numeric input (replacement for `x-model.number`):
```js
setQty(e) { this.qty = hyva.safeParseNumber(e.target.value); }
```

`hyva.safeParseNumber` is available since Hyvä 1.3.11 specifically for this use case.

## `x-html` is gone under CSP — use `x-html-safe` (Hyvä 1.5.3+)

The **Alpine CSP build removes `x-html` entirely from 3.15 on**, so on CSP pages an `x-html` binding renders nothing. Hyvä's theme module (1.5.3+) ships an `x-html-safe` directive. It is a drop-in replacement that rebuilds the HTML from a tag and attribute **allowlist**:
- The input is parsed inert via `DOMParser`; disallowed tags are dropped but their text is kept.
- `x-*` / `:*` / `@*` attributes never survive, so injected content can't add Alpine behavior.
- It loads automatically and works on both the standard and CSP builds.

```html
<div x-data="productInfo">
    <div x-html-safe="description"></div>
</div>
```

For templates not migrated yet, **Stores → Configuration → Hyvä Themes → Developer → HTML Safe → "Map x-html-safe to x-html"** routes plain `x-html` through the same sanitizer. Its values:
- **Disabled** (default)
- **On CSP pages only**
- **On all pages**, which also sanitizes `x-html` on the regular build

## Toggling boolean state cleanly: `hyva.createBooleanObject`

Inverting a boolean (`open = !open`) is forbidden under CSP. Hyvä provides a helper that returns an object with a method to flip the value:

```js
Alpine.data('myComponent', () => ({
    menu: hyva.createBooleanObject('open', false),
}));
```

Then in the template:
```html
<button @click="menu.toggle">Toggle</button>
<div x-show="menu.open">…</div>
<div x-show="!menu.open">Closed</div>  <!-- ❌ negation forbidden -->
<div x-show="menu.notOpen">Closed</div>  <!-- ✓ generated negated accessor -->
```

`createBooleanObject('open', false)` produces `{ open: false, notOpen: true, toggle: …, openTrue: …, openFalse: … }`. Read both `open` and `notOpen` — no `!` needed. Names: `<name>`, `not<Name>`, `<name>True`, `<name>False`, `toggle`.

To pre-set the state and provide additional methods:
```js
Alpine.data('myComponent', () => ({
    panel: hyva.createBooleanObject('expanded', true, {
        async load() { /* … */ }
    }),
}));
```

## `x-for` with CSP

Standard:
```html
<template x-for="(item, i) in items" :key="i">
    <li x-text="item.name"></li>
</template>
```

CSP build supports `x-for` but is stricter. The expression must be a simple `item in collection`. Computed iterables go through a getter:

```js
Alpine.data('list', () => ({
    rawItems: [],
    get visibleItems() { return this.rawItems.filter(i => i.active); }
}));
```
```html
<template x-for="item in visibleItems" :key="item.id">
    <li x-text="item.name"></li>
</template>
```

## Including CSP nonces on inline scripts

In a CSP-strict environment Magento adds a nonce to allowed inline scripts. Hyvä provides a view model for this:

```php
<?php
/** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
$hyvaCsp = $viewModels->require(\Hyva\Theme\ViewModel\HyvaCsp::class);

// register the inline script's hash with the CSP nonce provider:
$inline = "document.addEventListener('alpine:init', () => { /* … */ });";
$hyvaCsp->registerInlineScript($inline);
?>
<script><?= /* @noEscape */ $inline ?></script>
```

In practice you usually use `$hyvaCsp->registerInlineScriptCallback(function() use ($escaper, $data) { return "..."; })` so the body is captured once and emitted with the right hash. See `vendor/hyva-themes/magento2-default-theme-csp/` for examples.

## Migrating standard Alpine code to CSP-safe

Hyvä ships a migration helper:
```bash
./bin/hyva-csp-helper [DIRECTORY] | tee CSP-migration.md
```

This scans your theme for inline expressions and produces a Markdown report with conversion suggestions. It's not 100% automatic but covers most of the conversion mechanically.

There's also a more recent CSP migration tool — see `references/upgrading.md` for the latest tooling details.

## A complete CSP-safe component

```php
<?php /** @var \Magento\Framework\Escaper $escaper */ ?>

<div x-data="newsletterSignup">
    <form @submit.prevent="submit" class="space-y-2">
        <label for="email" class="block">
            <?= $escaper->escapeHtml(__('Email address')) ?>
        </label>
        <input
            id="email"
            type="email"
            required
            :value="email"
            @input="setEmail"
            :disabled="isSubmitting"
            class="form-input"
        >
        <button
            type="submit"
            :disabled="isSubmitting"
            class="btn btn-primary"
        >
            <span x-text="buttonLabel"></span>
        </button>
    </form>
    <div x-show="successPanel.shown" class="text-green-600">
        <?= $escaper->escapeHtml(__('Thanks — check your inbox.')) ?>
    </div>
</div>

<script>
    document.addEventListener('alpine:init', () => {
        Alpine.data('newsletterSignup', () => ({
            email: '',
            isSubmitting: false,
            successPanel: hyva.createBooleanObject('shown', false),
            get buttonLabel() {
                return this.isSubmitting ? 'Submitting…' : 'Subscribe';
            },
            setEmail(e) { this.email = e.target.value; },
            async submit() {
                this.isSubmitting = true;
                try {
                    const r = await fetch('/newsletter/subscriber/new/', {
                        method: 'POST',
                        body: new URLSearchParams({
                            form_key: hyva.getFormKey(),
                            email: this.email
                        })
                    });
                    if (r.ok) this.successPanel.toggle();
                } finally {
                    this.isSubmitting = false;
                }
            }
        }));
    });
</script>
```

In a CSP-strict theme, that inline `<script>` needs to be registered with the CSP nonce provider — wrap it via `$hyvaCsp->registerInlineScript(...)` or move the registration into a separate JS file referenced from layout XML.

## A few common gotchas

- **`@click="open = false"` is forbidden** — use a `close` method.
- **`@private-content-loaded.window="customer = $event.detail.data.customer"` is forbidden** — define `receiveCustomerData(e)` and use `@private-content-loaded.window="receiveCustomerData"` (note: `$event` becomes the first argument).
- **`x-show="someArray.length > 0"` is forbidden** — use a `get hasItems()` getter.
- **Conditional class with ternary is forbidden** — `:class="active ? 'on' : 'off'"` won't run. Use a getter or `:class="cssClass"` returning the string.
- **Magic properties like `$store` and `$dispatch` work normally** — those are part of the runtime, not evaluated expressions.
- **`x-html` silently renders nothing** on CSP pages (Alpine CSP 3.15+) — switch to `x-html-safe`, or enable the "Map x-html-safe to x-html" setting.
- **Negation shortcut:** you can declare a method named with a leading `!` (e.g. `['!deleted']() { return !this.deleted; }`), so `x-show="!deleted"` keeps working under CSP. Handy when converting existing components.

## Original sources

- `references/sources/hyva-themes/writing-code/csp/index.md` — full CSP overview, PCI-DSS background, and links to all CSP topics
- One page per topic in `references/sources/hyva-themes/writing-code/csp/`:
  - Alpine CSP: `alpine-csp.md`, `alpine-csp-properties.md`, `alpine-csp-property-mutation.md`, `alpine-csp-x-model.md`, `alpine-csp-x-for.md`, `alpine-csp-hyva-createbooleanobject.md`, `alpine-csp-html-safe.md`, `alpine-csp-constructor-functions.md`, `alpine-csp-example-component.md`
  - Setup and tooling: `csp-compatibility.md`, `hyva-default-theme-csp-installation.md`, `csp-magento-configuration.md`, `content-security-policy-allowlist.md`, `nonce-and-sha-hashes.md`, `csp-and-block-caching.md`, `csp-in-context-payment-buttons.md`, `migration-tool.md`
- `references/sources/hyva-themes/working-with-alpinejs/alpine-plugins/x-html-safe.md` — the sanitizer, allowlist, and the mapping setting
- `references/sources/hyva-checkout/devdocs/` — Hyvä Checkout CSP-specific documentation (checkout always runs strict CSP)
- `references/sources/hyva-themes/upgrading/upgrade-helper.md` — covers `hyva-csp-helper` migration script

If you're searching for a specific Alpine-CSP pattern, `Grep` for it in `references/sources/hyva-themes/writing-code/csp/` — there are detailed pages on each constraint.
