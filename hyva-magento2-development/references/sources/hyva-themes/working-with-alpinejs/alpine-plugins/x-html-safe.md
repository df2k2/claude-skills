<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/x-html-safe.html -->

# Rendering Sanitized HTML with x-html-safe

Available since Hyvä 1.5.3

Standard Alpine.js ships an `x-html` directive that sets `el.innerHTML` directly from an expression, with no sanitization involved. The developer is responsible for making sure that content is safe. Starting with **Alpine CSP 3.15**, the [Alpine CSP build](../../writing-code/csp/alpine-csp.html) removes `x-html` entirely, because rendering arbitrary HTML is exactly the kind of unrestricted capability a strict Content Security Policy is meant to prevent.

That's a real gap for Hyvä themes that lean on `x-html`, most commonly for price and tax markup fragments and other server-rendered HTML snippets. `x-html-safe` closes it. It's an Alpine plugin, built into Hyvä Theme, that renders HTML through a fixed tag and attribute allowlist instead of setting `innerHTML` directly, so you can still inject content without reintroducing the risk that removing `x-html` was meant to avoid.

Ships with hyva-themes/magento2-theme-module

`x-html-safe` loads automatically alongside Alpine, the same way the `intersect` and `htmldialog` plugins do. There's nothing to install. It works on both the standard and CSP Alpine builds.

You don't have to wait for a full template migration to benefit

Hyvä Theme also ships a **Map x-html-safe to x-html** setting (see [Mapping x-html to x-html-safe](#mapping-x-html-to-x-html-safe) below) that makes existing, un-migrated `x-html` usage render through the sanitized path instead. You can turn this on today, before migrating any templates yourself, to make your site more secure against unsanitized `x-html` output. It defaults to **Disabled** so upgrading never changes anything on its own, but enabling it is a one-setting way to raise your site's baseline right away.

## Usage

Use `x-html-safe` in your templates exactly where you would have used `x-html`:

```
<div x-data="{ description: '<strong>Bold</strong> product details' }">
    <div x-html-safe="description"></div>
</div>
```

The expression is evaluated the same way `x-html`'s would be: whatever it returns gets sanitized and rendered as HTML. Reactive updates re-sanitize automatically, and identical input strings are served from an internal cache rather than re-parsed on every update.

## How Sanitization Works

`x-html-safe` doesn't try to blocklist dangerous patterns. Instead, it rebuilds the output from scratch using an allowlist:

1. The input string is parsed as inert HTML via `DOMParser`. Nothing in it executes: no `onerror` or `onload` handlers fire, even for elements like `<img>` or `<svg>`.
2. The parsed tree is walked recursively. Each node is one of:
   - **Text**: copied as-is.
   - **An allowed tag**: a new element is created, allowed attributes are copied (with validation where relevant), and its children are recursed into.
   - **A disallowed tag**: the tag itself is dropped, but its children are still recursed into and attached to the surrounding parent. Text content survives; the wrapping tag doesn't.
3. Alpine directives (`x-*`, `:*`, `@*`) are never in the attribute allowlist, so they can't survive sanitization. Injected content can't introduce new Alpine behavior, even if the plugin is loaded on the page.

This means an unrecognized tag doesn't need a corresponding blocklist entry. "Not on the allowlist" is the entire contract. A `<script>` or `<iframe>` gets stripped the same way an unknown or future tag would, with no separate list of "known bad" tags to maintain.

## Allowed Tags

```
a, b, i, em, strong, s, u, span, small, mark, abbr, cite, q, sup, sub, br,
code, kbd, samp, var, wbr,
p, div, h1, h2, h3, h4, h5, h6,
ul, ol, li, dl, dt, dd,
blockquote, pre, hr,
table, thead, tbody, tfoot, tr, th, td, caption, colgroup, col
```

Tags such as `img`, `picture`, `time`, and `data` are intentionally left out of this release. They need dedicated validation (resource loading, date and time formats) that hasn't been built yet.

`id`, `name`, and `style` are never allowed on any tag. `id` and `name` enable DOM clobbering, and `style` is a layout-attack vector.

`class` is allowed and copied through unvalidated, same as `data-*`. On sites using a CSS framework with a build-time class scanner (Tailwind's arbitrary-value syntax, `class="bg-[url(...)]"`, is the concrete example), an attacker-controlled `class` value can act as a resource-loading vector — but only when that scanner is actually active, and in that case the same risk exists anywhere else user content reaches a `class` attribute on the page, independent of this plugin. `x-html-safe` doesn't special-case any particular framework's scanner behavior.

## Allowed Attributes

These attributes are available on every allowed tag:

| Attribute | Notes |
| --- | --- |
| `title` |  |
| `aria-label` |  |
| `hidden` | Use in place of `aria-hidden`. It hides content from display and the accessibility tree in one attribute, with no value to inject. |
| `role` |  |
| `lang`, `dir` |  |
| `class` | Copied unvalidated. See the note above about CSS-framework class scanners. |
| `data-*` | Copied via the browser's `dataset` API. The sanitizer copies the values; validating them is the consuming component's responsibility. |

These attributes are available only on specific tags, each with its own validation:

| Tag | Attribute | Validation |
| --- | --- | --- |
| `a` | `href` | Must resolve to `https:`, `http:`, `mailto:`, or `tel:`. `javascript:` and `data:` URLs are rejected. |
| `a` | `target` | Restricted to `_blank`, `_self`, `_parent`, `_top` |
| `a` | `rel` | Passed through as authored |
| `blockquote`, `q` | `cite` | Same URL validation as `href` |
| `li` | `value` | Any valid integer, no spec-defined bound |
| `ol` | `start` | Any valid integer, including negative |
| `ol` | `reversed` | Boolean presence attribute |
| `td`, `th` | `colspan` | 1-1000 (WHATWG cap) |
| `td`, `th` | `rowspan` | 1-65534 (WHATWG cap, deliberately distinct from `colspan`'s) |
| `col` | `span` | 1-1000 |

### Cross-origin links get rel="noopener noreferrer" automatically

Any `<a>` whose `href` resolves to a different origin than the current page gets `noopener noreferrer` added to its `rel` attribute, regardless of what `target` is set to (or left unset).

This closes reverse-tabnabbing. A user can open any link in a new browsing context through ctrl/cmd-click, middle-click, or a context-menu "open in new tab", independent of the link's own `target` value, so the guard can't be conditioned on `target="_blank"`. Same-origin links are left untouched, since there's no trust boundary to protect from a page linking to itself.

## What's Not Handled

- **No developer configuration for the allowlist itself.** The tag and attribute allowlist is fixed. A misconfigured `allowTags: ['script']`-style escape hatch would defeat the sanitizer's entire premise, so there isn't one. If a real use case needs a tag or attribute that isn't covered, that's a change to the plugin, not a runtime option.
- **No Alpine directives in injected content.** `x-*`, `:*`, and `@*` attributes are stripped unconditionally. There's no "safe subset" of Alpine directives allowed through in this release.

## Mapping x-html to x-html-safe

By default, `x-html-safe` registers only itself. It doesn't touch `x-html`, so the same attribute keeps meaning exactly what the [upstream Alpine docs](https://alpinejs.dev/directives/html) say it means, everywhere, regardless of which build happens to be loaded. That matters because [Alpine CSP](../../writing-code/csp/alpine-csp.html) has no `x-html` directive at all: any template not yet migrated to `x-html-safe` renders nothing there, with no error to point at why.

To bridge that gap during migration, Hyvä Theme ships a setting that maps `x-html` onto the same sanitized rendering `x-html-safe` uses:

- Go to **Stores** -> **Configuration**
- Then **Hyvä Themes** -> **Developer** -> **HTML Safe**
  - **Map x-html-safe to x-html**
    - **Disabled** (default): `x-html-safe` is never mapped to `x-html`. Existing `x-html` behavior is left exactly as-is on both builds, so upgrading the theme module doesn't change anything on its own. Un-migrated `x-html` keeps rendering nothing on CSP pages until templates are updated to use `x-html-safe` directly, or this setting is turned on.
    - **On CSP pages only**: un-migrated `x-html` usage renders through the sanitized path on the CSP build, where `x-html` would otherwise render nothing. The regular build is untouched, since `x-html` already works there.
    - **On all pages**: also maps `x-html` to the sanitized behavior on the regular build. Existing `x-html` usage there switches from raw, unsanitized `innerHTML` to allowlist-filtered rendering.

This setting doesn't decide anything for Alpine itself, since a plugin doesn't get to unilaterally redefine what a directive Alpine ships means everywhere. It only affects Hyvä's own installation: the theme reads the setting and decides, at that layer, whether to also register `x-html-safe`'s handler under the name `html`.

Defaults to disabled on purpose

This setting defaults to **Disabled** rather than **On CSP pages only**, so upgrading the theme module never silently changes what an un-migrated `x-html` template renders. Turn the mapping on deliberately once you've reviewed what your un-migrated `x-html` templates actually render.

One handler behind both names shares one cache

Both `x-html-safe` and the `x-html` bridge (when enabled) call into the exact same sanitizer function, including its cache. Sanitizing the same HTML string once, whether through `x-html-safe` or the aliased `x-html`, serves the cached result to the other the next time that string comes up. There's no separate cache to keep in sync.

## Migrating Existing Templates

Hyvä's own default CSP theme is migrating its `x-html` usage to `x-html-safe` incrementally, template by template, rather than all at once. The confirmed-safe order of operations for any template:

1. Check what the bound expression actually returns. Plain text or markup that only uses [allowed tags/attributes](#allowed-tags) (styling classes included) can be renamed directly, with no visible change.
2. If the markup relies on a genuinely blocked attribute (`id`, `name`, `style`), decide whether that usage can be dropped or needs a different approach — these stay blocked because they enable real attacks ([DOM clobbering](https://developer.mozilla.org/en-US/docs/Web/Security/Attacks/DOM_Clobbering), layout injection), not because they're inconvenient.
3. If the content is dynamic or comes from a third party (AJAX responses, customer-data sections, other extensions), verify what it actually renders before migrating. A cart drawer's "extra actions" section, for example, can carry arbitrary HTML from any installed module, exactly the kind of untrusted content `x-html-safe` exists to handle safely, but it's worth confirming nothing currently depends on tags or attributes outside the allowlist before switching it over.

Un-migrated templates keep behaving exactly as they do today until they're migrated: still rendering nothing on CSP pages, since the bridge defaults to **Disabled**. Turn on **On CSP pages only** if you'd rather have them render sanitized content in the meantime while migration is in progress.

## Related Topics

- **[Alpine CSP: x-html-safe](../../writing-code/csp/alpine-csp-html-safe.html)**: Why the CSP build needs this plugin, in short
- **[Alpine CSP](../../writing-code/csp/alpine-csp.html)**: Overview of Alpine CSP build limitations and how to write compatible code
- **[Alpine CSP Example Component](../../writing-code/csp/alpine-csp-example-component.html)**: Complete working example of a CSP-compatible component
