<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/prose.html -->

# Hyvä CSS - Prose (Typography)

Since Hyvä 1.4, the `prose` utility class is provided by the `@hyva-themes/hyva-modules` package as a direct CSS import, replacing the `@tailwindcss/typography` plugin. The Hyvä implementation is smaller, easier to customize, and removes friction points that came up regularly in real projects.

## How the Hyvä Prose Module Works

The `prose` class works the same way as before: apply it to a container, and all HTML inside renders with sensible default typography for headings, paragraphs, lists, blockquotes, links, tables, and code.

The Hyvä implementation differs from `@tailwindcss/typography` in a few intentional ways.

**No default max-width.** The official plugin sets a `max-width` on every prose size preset, which frequently required pairing it with `max-w-none` to allow full-width layouts. The Hyvä version has no max-width by default. Add `max-w-prose` when you want to constrain the line length.

**Lower specificity.** Prose styles use `:where()` selectors, so they do not override Tailwind utility classes. You can apply utilities directly on elements inside a `prose` container without needing complex `unset` overrides.

**CSS variable-based customization.** Every prose style is controlled by a CSS custom property, making it easy to adjust directly in your theme CSS.

**Smaller footprint.** The complex unset overrides included in `@tailwindcss/typography` are not present, keeping the generated CSS lean.

## CSS Variables

All prose styles are controlled by CSS custom properties. Set them inside a `.prose` selector in your theme CSS to change the defaults globally:

web/tailwind/tailwind-source.css

```
.prose {
    --link-color: var(--color-primary);
    --h-weight: 700;
    --h1-size: 2.5em;
}
```

**Spacing**

| Variable | Default | Controls |
| --- | --- | --- |
| `--text-flow` | `1em 1rem` | Margin block for text elements (headings, paragraphs, lists) |
| `--separator-flow` | `2.5em` | Margin block for blockquotes, figures, and `<hr>` |
| `--list-flow` | `0.5em` | Spacing between list items |

**Headings**

| Variable | Default | Controls |
| --- | --- | --- |
| `--h-color` | `initial` | Heading color |
| `--h-family` | `initial` | Heading font family |
| `--h-weight` | `600` | Heading font weight |
| `--h-line` | `1.1` | Heading line height |
| `--h1-size` | `3em` | `<h1>` font size |
| `--h2-size` | `2em` | `<h2>` font size |
| `--h3-size` | `1.625em` | `<h3>` font size |
| `--h4-size` | `1.375em` | `<h4>` font size |

**Lists, Links, and Blockquotes**

| Variable | Default | Controls |
| --- | --- | --- |
| `--marker-color` | `var(--color-primary)` | List bullet and number color |
| `--link-color` | `var(--color-primary)` | Link text color |
| `--link-weight` | `500` | Link font weight |
| `--blockquote-color` | `var(--color-primary)` | Blockquote left border color |

**Tables**

| Variable | Default | Controls |
| --- | --- | --- |
| `--table-py` | `spacing(3)` | Table cell vertical padding |
| `--table-px` | `spacing(2)` | Table cell horizontal padding |
| `--table-stroke` | `var(--color-gray-400)` | Table border color |
| `--table-bg` | `canvas` | Table cell background |
| `--table-color` | `canvastext` | Table cell text color |

## Prose Variants

The prose module registers Tailwind custom variants for targeting specific child elements with utility classes. This lets you scope styles to elements inside a `prose` container directly in your HTML:

```
<div class="prose prose-headings:text-gray-900 prose-a:text-blue-600 prose-img:rounded-lg">
    ...
</div>
```

Prefer CSS variables over prose variants

Each prose variant you use adds CSS to your global bundle. For broader style changes, overriding a CSS variable in a custom modifier class is the cleaner solution - one rule, no extra selectors generated per usage.

```
.prose-brand {
    --link-color: var(--color-brand);
    --h-color: var(--color-gray-900);
}
```

```
<div class="prose prose-brand">...</div>
```

Available variants

| Variant | Targets |
| --- | --- |
| `prose-headings:` | `h1` through `h6` |
| `prose-h1:` | `h1` |
| `prose-h2:` | `h2` |
| `prose-h3:` | `h3` |
| `prose-h4:` | `h4` |
| `prose-h5:` | `h5` |
| `prose-h6:` | `h6` |
| `prose-lead:` | `.lead` elements |
| `prose-p:` | `p` |
| `prose-a:` | `a` |
| `prose-blockquote:` | `blockquote` |
| `prose-strong:` | `strong` |
| `prose-em:` | `em` |
| `prose-code:` | `code` |
| `prose-pre:` | `pre` |
| `prose-ul:` | `ul` |
| `prose-ol:` | `ol` |
| `prose-li:` | `li` |
| `prose-hr:` | `hr` |
| `prose-table:` | `table` |
| `prose-th:` | `th` |
| `prose-td:` | `td` |
| `prose-img:` | `img` |
| `prose-figure:` | `figure` |
| `prose-figcaption:` | `figcaption` |
| `prose-video:` | `video` |
| `prose-iframe:` | `iframe` |

## The Lead Class

Add the `lead` class to a paragraph for a larger introductory text size (`1.25em`):

```
<div class="prose">
    <p class="lead">Introductory paragraph in a larger size.</p>
    <p>Regular paragraph text continues here.</p>
</div>
```

## Why Hyvä Replaced @tailwindcss/typography

Hyvä 1.4 added Tailwind v4 support. Tailwind v4 moves configuration from JavaScript to CSS, and while JS plugins are still technically supported in v4, a CSS-native implementation lowers complexity: one `@import` line in your CSS file, no plugin registration step, and customization done directly in CSS without a config file.

The switch also resolved two friction points reported by the community: the default max-width that required constant `max-w-none` overrides, and CSS specificity high enough to block utility class overrides inside prose containers.

## Reverting to @tailwindcss/typography

If you prefer the official plugin, you can swap back. The Hyvä prose styles are bundled into the `@import "@hyva-themes/hyva-modules/css"` line in your `tailwind-source.css`. To exclude them, replace that single import with the individual package imports. The full list of individual imports is documented in the [hyva-modules-tailwind-js README](https://github.com/hyva-themes/hyva-modules-tailwind-js).

Once the Hyvä prose styles are removed, install `@tailwindcss/typography` and follow the [official plugin documentation](https://github.com/tailwindlabs/tailwindcss-typography) to register it in your Tailwind setup.
