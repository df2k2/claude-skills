# Dynamic Tailwind Classes in Hyvä 1.4 - Why `bg-<?= $color ?>-100` Doesn't Work

## TL;DR

Tailwind's compiler (JIT/PurgeCSS) only generates CSS for classes it can **see as complete, static strings** in your source files. When you concatenate a class name from a PHP variable like `bg-<?= $color ?>-100`, Tailwind never sees the full strings `bg-red-100`, `bg-green-100`, or `bg-blue-100` — so they get tree-shaken out of `styles.css`. There is no Tailwind setting that enables runtime class concatenation; this is a fundamental design constraint of the engine.

You have to give Tailwind static, complete class strings somewhere in a scanned source file. The cleanest fixes are: (1) a **safelist**, (2) a **lookup map in PHP** that returns whole class strings, or (3) **CSS variables / inline styles** for truly arbitrary color values.

---

## Why It Fails — The Mechanics

Hyvä 1.4 ships with Tailwind CSS (Hyvä 1.x typically uses Tailwind v2.x with the JIT engine; later Hyvä versions move to v3). Tailwind compiles your stylesheet by **scanning source files** listed under `purge` (Tailwind v2) or `content` (Tailwind v3) in `tailwind.config.js`. It uses a regex-based class extractor that finds candidate class strings as **literal substrings** in those files. Anything that isn't a complete literal is invisible to it.

Your code:

```php
<div class="bg-<?= $escaper->escapeHtmlAttr($category->getColor()) ?>-100">
```

…produces this when Tailwind scans the `.phtml` file:

```
class="bg-          -100"
```

There is no `bg-red-100` substring, no `bg-blue-100` substring, no `bg-green-100` substring anywhere in your sources. The compiler has no idea those classes will ever appear in rendered HTML, so it strips them. This is true for every Tailwind utility — `text-{color}-{shade}`, `border-{color}-{shade}`, `from-{color}-{shade}`, etc.

The output `<div class="bg-red-100">` is correct in the browser; the class simply has no matching CSS rule because the rule was never generated.

---

## Where Hyvä's Tailwind Config Lives

In a Hyvä 1.4 child theme, Tailwind sources live under:

```
app/design/frontend/<Vendor>/<theme>/web/tailwind/
├── tailwind.config.js
├── tailwind-source.css
└── postcss.config.js
```

The compiled output goes to:

```
app/design/frontend/<Vendor>/<theme>/web/css/styles.css
```

You build it with (run from the theme's `web/tailwind` directory):

```bash
npm install
npm run build-prod      # production (purged + minified)
# or
npm run watch           # development (rebuilds on file change)
```

After any config change, you also typically need to clear Magento's view cache:

```bash
bin/magento cache:flush
rm -rf pub/static/frontend/<Vendor>/<theme>/*
rm -rf var/view_preprocessed/*
bin/magento setup:static-content:deploy -f
```

---

## Option 1 — Safelist (Quickest Fix, Recommended When Color Set Is Small & Known)

Tell Tailwind to keep specific classes regardless of whether it sees them in source. This is the right answer for your case because you've said the values come from a small finite set (`red`, `green`, `blue`).

### Hyvä 1.4 with Tailwind v2 (`purge` API)

Edit `app/design/frontend/<Vendor>/<theme>/web/tailwind/tailwind.config.js`:

```js
const { colors } = require('tailwindcss/defaultTheme');

module.exports = {
    purge: {
        content: [
            '../../**/*.phtml',
            '../../**/*.html',
            '../../Magento_Theme/layout/**/*.xml',
            // ...existing entries from the Hyvä default config
        ],
        // safelist: classes never purged, even if not found in source
        safelist: [
            'bg-red-100',
            'bg-green-100',
            'bg-blue-100',
            // add hover/focus/dark variants here too if you use them
            'hover:bg-red-200',
            'hover:bg-green-200',
            'hover:bg-blue-200',
        ],
        options: {
            // Hyvä's default extractor — keep whatever was already there
        },
    },
    theme: { /* ... */ },
    variants: { /* ... */ },
    plugins: [ /* ... */ ],
};
```

### Tailwind v3 (`content` + top-level `safelist`)

If your project uses v3 (some upgraded Hyvä themes do):

```js
module.exports = {
    content: [
        '../../**/*.phtml',
        '../../**/*.html',
    ],
    safelist: [
        'bg-red-100',
        'bg-green-100',
        'bg-blue-100',
    ],
    // ...
};
```

### Pattern-based safelist (v3 only) — useful if the set grows

```js
safelist: [
    {
        pattern: /bg-(red|green|blue)-(100|200|300)/,
        variants: ['hover', 'focus'],
    },
],
```

**Important:** A pattern-based safelist is convenient but balloons your CSS file. Prefer an explicit list when possible.

After editing, rebuild:

```bash
cd app/design/frontend/<Vendor>/<theme>/web/tailwind
npm run build-prod
```

Then redeploy static content as shown above.

---

## Option 2 — Class Map in PHP (Best for Maintainability)

Instead of building a class name from fragments, return a **complete, literal class string** from PHP. Tailwind sees the full strings in the `.phtml` file, so they survive purging without a safelist.

### In your `.phtml` (block template)

```php
<?php
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Vendor\Module\ViewModel\CategoryColors $viewModel */

$colorMap = [
    'red'   => 'bg-red-100 text-red-900 border-red-300',
    'green' => 'bg-green-100 text-green-900 border-green-300',
    'blue'  => 'bg-blue-100 text-blue-900 border-blue-300',
];

$key     = $category->getColor();
$classes = $colorMap[$key] ?? 'bg-gray-100 text-gray-900 border-gray-300';
?>
<div class="<?= $escaper->escapeHtmlAttr($classes) ?> rounded p-4">
    <!-- ... -->
</div>
```

Tailwind's extractor finds `bg-red-100`, `bg-green-100`, `bg-blue-100`, `text-red-900`, etc. as literal substrings in the `.phtml`, so they're all retained.

### Cleaner: extract to a ViewModel

`app/code/Vendor/Module/ViewModel/CategoryColors.php`:

```php
<?php
declare(strict_types=1);

namespace Vendor\Module\ViewModel;

use Magento\Framework\View\Element\Block\ArgumentInterface;

class CategoryColors implements ArgumentInterface
{
    /**
     * Map of category-color keys to complete Tailwind class strings.
     * Keep these as literal strings so Tailwind's purger can find them.
     */
    private const COLOR_CLASSES = [
        'red'   => 'bg-red-100 text-red-900 border-red-300 hover:bg-red-200',
        'green' => 'bg-green-100 text-green-900 border-green-300 hover:bg-green-200',
        'blue'  => 'bg-blue-100 text-blue-900 border-blue-300 hover:bg-blue-200',
    ];

    private const DEFAULT_CLASSES = 'bg-gray-100 text-gray-900 border-gray-300 hover:bg-gray-200';

    public function getClassesFor(?string $colorKey): string
    {
        if ($colorKey === null) {
            return self::DEFAULT_CLASSES;
        }
        return self::COLOR_CLASSES[$colorKey] ?? self::DEFAULT_CLASSES;
    }
}
```

Wire the ViewModel in your block's layout XML:

```xml
<!-- app/design/frontend/<Vendor>/<theme>/Magento_Catalog/layout/catalog_category_view.xml -->
<referenceBlock name="category.products">
    <arguments>
        <argument name="category_colors_view_model" xsi:type="object">
            Vendor\Module\ViewModel\CategoryColors
        </argument>
    </arguments>
</referenceBlock>
```

Then in the template:

```php
<?php
/** @var Vendor\Module\ViewModel\CategoryColors $colorVm */
$colorVm = $block->getData('category_colors_view_model');
$classes = $colorVm->getClassesFor($category->getColor());
?>
<div class="<?= $escaper->escapeHtmlAttr($classes) ?> rounded p-4">
    <!-- ... -->
</div>
```

This works without any Tailwind config changes. Tailwind just compiles the literal strings it sees in the ViewModel's PHP file (assuming you list `*.php` in `content` — see "Caveat" below) **or in the `.phtml` if you keep the map there**.

### Caveat — does Tailwind scan `.php`?

Hyvä's default `tailwind.config.js` typically scans `.phtml` and `.xml` but **not always `.php`**. Check the `purge.content` (v2) or `content` (v3) array. If your map lives in a `.php` ViewModel, **add `.php` to the scanned globs**:

```js
purge: {
    content: [
        '../../**/*.phtml',
        '../../**/*.html',
        '../../**/*.xml',
        '../../../../code/**/*.php',  // <-- adjust path to your app/code
    ],
},
```

Or — easier — keep the array of class strings inside the `.phtml`, since `.phtml` is already scanned by default.

---

## Option 3 — Inline Styles or CSS Variables (Best for Truly Arbitrary Colors)

If the color set is unbounded (e.g., admin-configurable hex codes), Tailwind classes are the wrong tool. Use an inline `style` attribute or CSS custom properties.

### Inline style (simplest)

```php
<?php
$cssColors = [
    'red'   => '#fee2e2',  // tailwind red-100
    'green' => '#dcfce7',  // tailwind green-100
    'blue'  => '#dbeafe',  // tailwind blue-100
];
$bg = $cssColors[$category->getColor()] ?? '#f3f4f6';
?>
<div class="rounded p-4" style="background-color: <?= $escaper->escapeHtmlAttr($bg) ?>;">
    <!-- ... -->
</div>
```

### CSS variable + Tailwind arbitrary value (Tailwind v3)

```php
<div class="rounded p-4 bg-[var(--cat-bg)]"
     style="--cat-bg: <?= $escaper->escapeHtmlAttr($bg) ?>;">
    <!-- ... -->
</div>
```

`bg-[var(--cat-bg)]` is a **literal class string** Tailwind will see and compile (in v3 with arbitrary values). The custom property is set per-element. Note: Tailwind v2 doesn't support arbitrary-value brackets.

---

## Why Other "Fixes" Don't Work

A few approaches that look promising but fail:

1. **Adding `bg-red-100 bg-green-100 bg-blue-100` in a hidden `<div>` somewhere.** This *does* work mechanically — Tailwind sees the literals — but it's brittle and easy to delete by accident. Use a safelist instead; it's the supported way to express the same intent.

2. **`@apply bg-red-100;` inside `@layer` in `tailwind-source.css` based on a class.** That generates the rule, but only for the `.my-helper-class` you `@apply` it inside, which doesn't help if you still want to write `bg-red-100` as a class.

3. **String interpolation tricks like `<?= "bg-{$color}-100" ?>`.** Same problem — Tailwind never sees the assembled string at build time.

4. **Disabling purge / setting `safelist: { greedy: true }`.** Disabling purge makes the file gigantic (~3MB+). Don't do this in production.

5. **Using `tailwindcss/colors` in `theme.extend.colors` with the same name.** This adds the color to Tailwind's palette, but utilities are still only generated for combinations Tailwind sees in source — adding to the palette alone doesn't materialize the classes.

---

## My Recommendation for Your Case

Given the constraint as stated — a closed set of three values (`red`, `green`, `blue`) coming from `$category->getColor()`:

**Use Option 2 (PHP class map) as the primary, and add the safelist (Option 1) as belt-and-suspenders if these classes are also used elsewhere.**

The class map approach:
- Works without touching `tailwind.config.js`
- Makes the styling intent explicit in PHP, where the data lives
- Fails safe (returns a default class set for unknown values)
- Is the easiest to extend when a designer adds a fourth color — just edit one PHP file and rebuild.

If `getColor()` is ever going to expand to dozens of options, switch to Option 3 with CSS variables.

---

## Step-by-Step: Fixing Your Current Code

1. **Pick an option** (recommendation: Option 2 + small safelist).

2. **Edit your `.phtml`** (the category card template) to use a literal class map:

   ```php
   <?php
   $colorClasses = [
       'red'   => 'bg-red-100',
       'green' => 'bg-green-100',
       'blue'  => 'bg-blue-100',
   ];
   $bgClass = $colorClasses[$category->getColor()] ?? 'bg-gray-100';
   ?>
   <div class="<?= $escaper->escapeHtmlAttr($bgClass) ?>">
       <!-- card content -->
   </div>
   ```

3. **(Optional, defensive)** add a safelist entry in `app/design/frontend/<Vendor>/<theme>/web/tailwind/tailwind.config.js`:

   ```js
   purge: {
       content: [ /* ...existing... */ ],
       safelist: ['bg-red-100', 'bg-green-100', 'bg-blue-100'],
   },
   ```

4. **Rebuild Tailwind**:

   ```bash
   cd app/design/frontend/<Vendor>/<theme>/web/tailwind
   npm run build-prod
   ```

5. **Clear Magento static content / cache**:

   ```bash
   rm -rf pub/static/frontend/<Vendor>/<theme>/*
   rm -rf var/view_preprocessed/*
   bin/magento cache:flush
   bin/magento setup:static-content:deploy -f en_US
   ```

6. **Hard-reload your browser** (Ctrl+Shift+R) to bypass any cached `styles.css`.

7. **Verify** in DevTools: inspect the element, confirm the class is applied, confirm the rule exists in `styles.css` (search for `.bg-red-100 {`).

---

## Quick Reference: How to Spot This Bug Next Time

Any time you see one of these patterns in a `.phtml`, `.html`, or template, the resulting class will *probably* be purged out:

```php
class="bg-<?= $color ?>-100"          <!-- BAD -->
class="text-<?= $variant ?>"          <!-- BAD -->
class="<?= 'p-' . $size ?>"           <!-- BAD -->
class="grid-cols-<?= $count ?>"       <!-- BAD -->
```

The fix is always: emit a **complete, literal class string** from PHP, and choose it from a finite map.

```php
class="<?= $escaper->escapeHtmlAttr($mappedClasses) ?>"   <!-- GOOD -->
```

This rule is universal across Tailwind v2/v3/v4 and applies to every framework that uses Tailwind, not just Hyvä.
