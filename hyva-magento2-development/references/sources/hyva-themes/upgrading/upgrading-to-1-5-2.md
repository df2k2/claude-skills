<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-5-2.html -->

# Upgrading to 1.5.2

Hyvä Theme 1.5.2 is a maintenance release that builds on 1.5.1. It carries all the fixes from [1.4.10](upgrading-to-1-4-10.html) and adds a `snap-slider` update, a `@hyva-themes/hyva-modules` upgrade with new design token tooling, and several improvements to the product gallery, configurable swatches, and PLP filters.

Safe Module Updates

Even if you aren't ready to update the Default Theme to 1.5.2 just yet,
it's completely safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

## Notable news

### Hyva Modules NPM package updated to v1.4

The [`@hyva-themes/hyva-modules` npm package is updated to v1.4](https://github.com/hyva-themes/hyva-modules-tailwind-js/releases/tag/1.4.0).

Run `npm install @hyva-themes/hyva-modules@latest` in your child theme to pull in the update.

The Default Theme `.npmrc` also sets `min-release-age` to `1 day`, down from the `7 days` introduced in 1.5.1. The original value made it harder to install freshly released packages. The new default matches **pnpm**'s default and still provides protection against supply chain attacks, if the infected package is discovered and taken offline within 24 hours. If your `.npmrc` still has `7 days`, and you notice the new version of the package isn't being installed, update it and try running the install command again.

#### Google Stitch Markdown support

`tokens.src` in `hyva.config.json` can now point directly at a Google Stitch Markdown export instead of a JSON file. Google Stitch is a design token tool that lets designers export tokens straight from their design environment as a Markdown file with YAML frontmatter.

This closes the gap between design and development. Instead of manually converting or maintaining a separate JSON token file, you can point Hyvä directly at the Stitch export and your design tokens flow into the build automatically. Only the YAML frontmatter is read, and the `colors` group is renamed to `color` automatically to match Hyvä's naming convention, so no extra configuration is needed for that.

#### `stripPrefix` and `rename` options

New options in `hyva.config.json` for the `tokens` config let you unwrap key paths and align group naming without a custom build step.

#### `ink` and `ink-muted` tokens

Two new design tokens, `ink` and `ink-muted`, are added alongside the existing `fg` and `fg-secondary`. `ink` pairs naturally with `surface` (the ink sits on a surface). The Default Theme CSS is updated to use the new token names, but the phtml templates still reference the old names. Both old names continue to work for now, but a future release will remove them. If your child theme overrides any phtml templates that use `fg` or `fg-secondary` class names, it's worth updating those references to `ink` and `ink-muted`.

#### Default `theme.css`

A fallback design-token palette is now provided out of the box, covering `primary`, `secondary`, `background`, `surface`, `ink`, and `ink-muted`. Colors are defined in `oklch`, with lighter and darker tints derived automatically via `color-mix()`.

This is particularly useful when importing tokens from Google Stitch. Stitch exports often only define the base color values and omit the `lighter` and `darker` variants that Hyvä uses for hover states and UI accents. With the default `theme.css` in place, those tints are computed from your base color automatically, so nothing breaks even when the variants are missing from your token file.

### `snap-slider` updated to v2.2.3

The bundled `snap-slider` Alpine plugin is updated to v2.2.3. This release adds a `forcePager` option that keeps the pager visible even when the slider has no overflow. In the Alpine integration it is available as the `x-snap-slider.force-pager` modifier, or via the `data-force-pager` HTML attribute.

## Product gallery

The product gallery pager now stays visible for configurable products regardless of the selected variant. The release also removes an unnecessary y-axis scroll lock that was preventing users from scrolling the page while dragging or scrolling through the gallery.

## Configurable product swatches

Fixed swatch tooltips from appearing on touch devices.

The rendering of the selected swatch option is also made CSP safe. The previous implementation passed a PHP-rendered attribute ID directly into an Alpine.js expression, which a strict Content Security Policy could block. The fix moves the attribute ID to a `data-attribute-id` attribute and reads it from the element in a dedicated `getSelectedOption()` method.

If your child theme overrides `Magento_Swatches/templates/product/view/renderer.phtml`, apply these changes to your override as well.

View the full diff for `Magento_Swatches/templates/product/view/renderer.phtml`

```
             return Object.assign(
                 configurableOptionsComponent,
-                swatchOptionsComponent
+                swatchOptionsComponent,
+                {
+                    getSelectedOption() {
+                        return this.selectedOptions[this.$el.dataset.attributeId];
+                    }
+                }
             );

-            <span class="font-medium" x-text="selectedOptions[<?= (int) $attributeId ?>]"></span>
+            <span
+                class="font-medium"
+                data-attribute-id="<?= (int) $attributeId ?>"
+                x-text="getSelectedOption"
+            ></span>
```

## Layered navigation and PLP

The PLP filter panel now uses the native HTML `<details>` element instead of a custom collapse implementation. Previously only the label text was clickable to expand a filter group. The switch to `<details>` makes the entire header area clickable, matching the expected UX and improving accessibility.

A pagination bug where clicking Next on the last page redirected back to the first page is also resolved.

## Backward compatibility

This release is backward compatible.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#152-2026-07-10)
- [Changelog Theme Module](changelog-theme-module.html#152-2026-07-10)

## Tooling

Check the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
