<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/fallback.html -->

# Hyvä CSS - Fallback Utilities

The `@hyva-themes/hyva-modules` package includes `css/fallback.css`, which re-adds deprecated Tailwind v2 and v3 utilities that were removed in Tailwind v4. These are included to keep third-party Hyvä-compatible modules working if they still reference the old utility names.

Safe to keep in your build

Tailwind v4 only includes utilities that are actually used in your templates. If none of these classes appear in your code or any installed module, they won't end up in the final CSS. You don't need to remove this import - it's here purely to provide compatibility for third-party modules that still reference the older class names.

Avoid using these in new code

These utilities exist for backward compatibility only. Prefer the Tailwind v4 equivalents in any new code you write.

## Included Utilities

### Opacity Utilities

Tailwind v4 dropped the separate `*-opacity-*` utilities in favor of the slash opacity syntax (e.g. `bg-black/50`). The following are re-added for compatibility:

| Utility | Tailwind v4 equivalent |
| --- | --- |
| `bg-opacity-{value}` | `bg-{color}/{value}` |
| `text-opacity-{value}` | `text-{color}/{value}` |
| `border-opacity-{value}` | `border-{color}/{value}` |
| `divide-opacity-{value}` | `divide-{color}/{value}` |
| `ring-opacity-{value}` | `ring-{color}/{value}` |
| `placeholder-opacity-{value}` | `placeholder-{color}/{value}` |

### Flex Utilities

Tailwind v4 renamed these to align with the CSS property names:

| Utility | Tailwind v4 equivalent |
| --- | --- |
| `flex-shrink` | `shrink` |
| `flex-shrink-0` | `shrink-0` |
| `flex-grow` | `grow` |
| `flex-grow-0` | `grow-0` |

### Text and Decoration Utilities

| Utility | Tailwind v4 equivalent |
| --- | --- |
| `overflow-ellipsis` | `text-ellipsis` |
| `decoration-slice` | `box-decoration-slice` |
| `decoration-clone` | `box-decoration-clone` |
