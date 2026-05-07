# Why `bg-<?= $category->getColor() ?>-100` doesn't work in Hyvä 1.4 (Tailwind v4)

## The root cause: Tailwind only ships classes it can find as literal strings

Tailwind CSS — both v3 and v4 — generates CSS only for classes it discovers as **literal, intact strings** in scanned files. The Hyvä build scanner reads the `*.phtml`, `*.xml`, and `*.html` files in the paths declared under `tailwind.include` in `web/tailwind/hyva.config.json` and emits one CSS rule for every class name it can see.

Your template:

```php
<div class="bg-<?= $escaper->escapeHtmlAttr($category->getColor()) ?>-100">
```

After the scanner reads the file (it does **not** execute PHP), all it ever sees is the substring `bg-` and `-100`. The strings `bg-red-100`, `bg-green-100`, `bg-blue-100` never appear in any source file, so Tailwind has no reason to compile them. They get purged out of `web/css/styles.css` and the colors disappear at runtime.

This is the single most common Tailwind gotcha for Luma developers moving to Hyvä, and it's documented as the "Dynamic class names — purging gotcha" in the Hyvä Tailwind v4 reference.

A few related notes specific to Hyvä 1.4 / Tailwind v4 before we get to fixes:

- There is no `tailwind.config.js` in v4. Configuration is split between `web/tailwind/hyva.config.json` (paths, plugins, simple tokens) and `@theme {}` blocks inside CSS. So a `safelist: []` array in JS config doesn't exist — the safelist pattern is achieved with a literal-string comment instead (option 1 below).
- After **any** of the fixes below, you must rebuild the stylesheet from the child theme's `web/tailwind/` directory:
  ```bash
  npm run build        # one-shot
  # or
  npm run watch        # rebuild on change during development (alias: npm start)
  ```
  Then in production: `bin/magento cache:flush` and `bin/magento setup:static-content:deploy -f`.

---

## Your options, ranked from most to least recommended

### Option 1 (recommended): Map the value to a literal class name in PHP

This is the cleanest, most maintainable, and most "Tailwind-native" fix. Decide the full class name in PHP using a lookup, then write it as a single string into the markup. The class is then literally present in the scanned file, so Tailwind compiles it normally.

```php
<?php
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Magento\Framework\View\Element\Template $block */

$colorClasses = [
    'red'   => 'bg-red-100',
    'green' => 'bg-green-100',
    'blue'  => 'bg-blue-100',
];
$colorKey = (string) $category->getColor();
$cardBg   = $colorClasses[$colorKey] ?? 'bg-gray-100';
?>
<div class="<?= $escaper->escapeHtmlAttr($cardBg) ?> rounded p-4">
    <h3 class="text-lg font-semibold">
        <?= $escaper->escapeHtml($category->getName()) ?>
    </h3>
</div>
```

Why this is preferred:
- Tailwind sees `bg-red-100`, `bg-green-100`, `bg-blue-100`, `bg-gray-100` as literal strings — they are guaranteed to be in the build.
- You get a defensive default (`bg-gray-100`) if the model ever returns an unexpected value.
- It's auditable: a future developer can grep for `bg-red-100` and find every place it's used.
- It works identically with hover/focus variants (`hover:bg-red-200`) — just add them to the map.

If you also want hover or border variants:

```php
$colorClasses = [
    'red'   => 'bg-red-100 hover:bg-red-200 border-red-300',
    'green' => 'bg-green-100 hover:bg-green-200 border-green-300',
    'blue'  => 'bg-blue-100 hover:bg-blue-200 border-blue-300',
];
```

### Option 2: Whitelist via a safelist comment in a scanned file

If you really want to keep the original interpolation — for example because the colors are coming from an external system and the set is expected to grow — make sure the literal class names appear *somewhere* the scanner reads.

In any scanned `.phtml` (or even the same template as a comment), or in a CSS comment:

```php
<?php /* safelist: bg-red-100 bg-green-100 bg-blue-100 */ ?>
<div class="bg-<?= $escaper->escapeHtmlAttr($category->getColor()) ?>-100">
    ...
</div>
```

Or in `web/tailwind/tailwind-source.css` (or any imported CSS file):

```css
/* safelist: bg-red-100 bg-green-100 bg-blue-100 */
```

The "safelist:" prefix is just a convention for human readers — what matters is that `bg-red-100`, `bg-green-100`, `bg-blue-100` appear as literal substrings in a scanned file. The scanner doesn't care if they're inside a comment.

This works but it's the weakest option because:
- It silently couples one file's content to another file's runtime behavior. Someone deleting the comment will break colors with no obvious cause.
- It scales poorly if the value space is large (every `bg-{color}-{shade}` combination has to be listed).
- New colors require both a content change and a CSS rebuild.

### Option 3: Arbitrary values with a hex code

Bypass the named-color system entirely and feed a hex (or any CSS color) through an arbitrary value. Tailwind v4 still sees `bg-[#ffe4e4]` as a literal class and compiles it on demand:

```php
<?php
$bgHex = [
    'red'   => '#fee2e2',
    'green' => '#dcfce7',
    'blue'  => '#dbeafe',
][(string) $category->getColor()] ?? '#f3f4f6';
?>
<div class="bg-[<?= $escaper->escapeHtmlAttr($bgHex) ?>] rounded p-4">
    ...
</div>
```

Caveat: the **string** `bg-[#fee2e2]` still has to appear literally in a scanned file for the scanner to pick it up, so this only really helps if the set of hexes is small and you list them in the PHP map (the example above does). If you build the bracket expression at runtime from a variable hex, you're back to the same purge problem.

Use this when you want to break out of the design system colors entirely (e.g. merchant-defined colors stored on each category in admin).

### Option 4: CSS custom properties for truly runtime-dynamic colors

When the color is genuinely arbitrary at render time (admin-defined, per-merchant, etc.) and you don't want a PHP map, use a CSS variable through inline `style`:

```php
<?php
$colorVar = (string) $category->getColor(); // 'red', 'green', '#ff8800', etc.
?>
<div
    style="--cat-color: <?= $escaper->escapeHtmlAttr($colorVar) ?>;"
    class="bg-[var(--cat-color)] rounded p-4"
>
    ...
</div>
```

The class `bg-[var(--cat-color)]` is literal, so Tailwind compiles it once and the variable resolves per element at runtime. Note that with Hyvä's CSP build (`Hyva/default-csp`) inline `style` attributes need a CSP nonce or a static-class fallback, so this option fits a non-CSP storefront better.

### Option 5: Define the values as theme tokens

If `red`, `green`, `blue` here actually mean *brand-meaningful* names (like "danger", "success", "info"), encode them in your design tokens so they become first-class Tailwind classes that you reference statically:

`web/tailwind/tailwind-source.css` (or `theme/index.css`):

```css
@theme {
    --color-cat-red:   #fee2e2;
    --color-cat-green: #dcfce7;
    --color-cat-blue:  #dbeafe;
}
```

That gives you `bg-cat-red`, `bg-cat-green`, `bg-cat-blue` etc. — and you'd then use Option 1's mapping pattern to pick which one. It's the most "design-system" approach, though for three category colors it may be overkill.

---

## What I'd actually do for this case

For a small, fixed set of three colors hard-coded in your data, **Option 1 is the right answer**. Replace the line in your category card with:

```php
<?php
$colorClasses = [
    'red'   => 'bg-red-100',
    'green' => 'bg-green-100',
    'blue'  => 'bg-blue-100',
];
$cardBg = $colorClasses[(string) $category->getColor()] ?? 'bg-gray-100';
?>
<div class="<?= $escaper->escapeHtmlAttr($cardBg) ?>">
    ...
</div>
```

Then, from the child theme's `web/tailwind/`:

```bash
npm run build
```

And clear caches / redeploy static content as needed:

```bash
bin/magento cache:flush
bin/magento setup:static-content:deploy -f   # production only
```

You should see `.bg-red-100 { … }`, `.bg-green-100 { … }`, `.bg-blue-100 { … }`, and `.bg-gray-100 { … }` rules appear in `web/css/styles.css` after the build, and the colors will render correctly on the storefront.

## Quick troubleshooting checklist if it still doesn't work after fixing

1. **Did you rebuild?** Tailwind output is static — no CSS regenerates until `npm run build` (or `npm run watch`) runs again.
2. **Are you running the build in the right child theme?** The build that matters is the one in `app/design/frontend/<Vendor>/<theme>/web/tailwind/`, not the parent `vendor/hyva-themes/magento2-default-theme/`.
3. **Is the template's directory included in `hyva.config.json`?** If the phtml lives in a module under `app/code/Acme/Categories/view/frontend/templates/`, the build needs `{ "src": "app/code/Acme/Categories" }` (or similar) in `tailwind.include` to scan it. The file is read for class names, not just rendered.
4. **Magento cache flushed?** `bin/magento cache:flush`.
5. **Production: static content redeployed?** `bin/magento setup:static-content:deploy -f`.
6. **Stale `web/css/styles.css` from a previous build?** Delete it and rebuild to be sure you're not looking at an outdated file.
7. **Browser cache.** Open dev tools, check the Network tab for `styles.css`, confirm the new rules are present in the served file.
