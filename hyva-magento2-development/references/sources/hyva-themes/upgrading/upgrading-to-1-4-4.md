<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-4.html -->

# Upgrading to 1.4.4

Hyvä Theme 1.4.4 focuses on stability, polishing features, and squashing bugs.
We've cleaned up the cart, product page, forms, and more, while also boosting performance and accessibility.

If you're making the case for upgrading: this release makes Hyvä Theme more reliable and polished.
It means fewer rough edges and a smoother, faster experience for shoppers.

Safe Module Updates

Even if you aren't ready to update the Default Theme to 1.4.4 just yet,
it's completely safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

Please refer to the changelogs for details about the bugfixes.

## Notable news

### New features

We've added a few quality-of-life improvements to make the theme even better out of the box.

- **reCAPTCHA Legal Notice Customization**: The reCAPTCHA legal notice text is now customizable.
- **Product Rich Snippet Improvements**: The product structured data snippet now includes `availability` and `priceValidUntil` fields for better SEO.
- **Keyboard Shortcut for Search**: Shoppers can now open the search panel with `Cmd+K` (macOS) or `Ctrl+K` (Windows/Linux). This follows conventions used by popular search interfaces.

### Performance Improvements

We're always looking for ways to make Hyvä faster. In 1.4.4, we focused on image loading and option lookups.

- **Gallery Image Preloading**: The gallery main image is now preloaded on the Product Detail Page (PDP). This noticeably improves Largest Contentful Paint (LCP) scores.
- **Optimized Product Selection**: Configurable product option lookups are faster, making variant selection feel snappier.

### Accessibility Improvements

- Improved keyboard accessibility for the PDP gallery.
- Fixed an invalid `aria-label` on the authentication popup.
- CMS content icons now support the `aria-hidden` attribute.

## Notable Behavior Changes

Be aware of these changes when upgrading to 1.4.4, as they might affect your custom theme's styling or animations.

### Scrollbar Color Uses System Preset

In Hyvä Theme 1.4.4, the `--scrollthumb-color` CSS variable is now **unset by default**.

This allows the scrollbar thumb to inherit the operating system's native style,
which is often preferred for accessibility and consistency.

If your custom theme relied on this variable being set,
you can easily restore it by setting the `--scrollthumb-color` CSS variable in your CSS:

```
:root {
    --scrollthumb-color: var(--color-primary);
}
```

### View Transition to Gallery is Optional

The view transition animation that plays when navigating from the product listing page to the product gallery is now **optional and configurable**.
Previously, this transition was always active.

If your theme depends on this transition being enabled,
you can turn it back on.

Configure it in the Magento Admin under **Stores > Configuration > Hyvä Themes > General > Animations and Transitions > Enable View Transition Gallery**,
or enable it via the CLI:

```
bin/magento config:set hyva_theme_general/animations/enable_view_transition_gallery 1
```

### Review Stars Resized and Colored Yellow

We've updated the review star icons.
They have been resized and their default color changed back to to yellow as seen in prevoius Hyvä versions.

If your theme relied on the stars using the primary color, you can restore that look by setting the `--color-rating` CSS variable:

```
:root {
    --color-rating: var(--color-primary);
}
```

## Tailwind Tooling: hyva-modules-tailwind-js 1.3.0

[`hyva-modules-tailwind-js` v1.3.0](https://github.com/hyva-themes/hyva-modules-tailwind-js/releases/tag/1.3.0) ships alongside this release.
It adds several new `hyva.config.json` options and a handy new `keepSource` flag for Tailwind `exclude` entries.

### Using keepSource with Tailwind 4 Incompatible Modules

The `keepSource` flag is exactly what you need if you have third-party modules that haven't been updated for Tailwind 4 yet.

It lets you keep scanning a module's templates for class names (which preserves the `@source` statement) while skipping its CSS imports.

This avoids compatibility issues while still giving you the utility classes you need.

hyva.config.json

```
{
    "tailwind": {
        "exclude": [
            {
                "src": "vendor/hyva-themes/magento2-hyva-checkout/src",
                "keepSource": true
            }
        ]
    }
}
```

### Prose Element Modifier Variants

We've added prose modifier variants to `prose.css`. This allows your Tailwind utilities to be scoped to specific child elements inside a `.prose` block.

```
<div class="prose prose-headings:text-primary prose-a:underline">...</div>
```

Check out the [full release notes](https://github.com/hyva-themes/hyva-modules-tailwind-js/releases/tag/1.3.0) for all the details.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#144-2026-03-03)
- [Changelog Theme Module](changelog-theme-module.html#144-2026-03-03)
- [Changelog Default CSP Theme](changelog-default-theme.html#144-csp-2026-03-03)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
