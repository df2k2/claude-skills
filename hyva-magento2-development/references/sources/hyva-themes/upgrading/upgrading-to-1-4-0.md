<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-4-0.html -->

# Upgrading to 1.4.0

We're excited to announce Hyvä version 1.4.0! This release modernizes our frontend with Tailwind v4 and Design Tokens, enhances HTML structures, and improves the UI. BFCache is now natively supported, and formerly experimental features like Speculation Rules and View Transitions are enabled by default.

When updating the Hyvä Theme to version 1.4.0, please always update the `hyva-themes/magento2-theme-module` to the latest version.

Even if not updating the Default Theme to 1.4.0, it is safe to update the `Hyva_Theme` module to the latest version (package `hyva-themes/magento2-theme-module`).

Please refer to the changelogs for details about the bugfixes.

## Notable news

### Replacing `hyva-themes/magento2-reset-theme` with `hyva-themes/magento2-base-layout-reset`

This change improves the TTFB for requests hitting a cold layout cache.
Instead of a reset-theme undoing all the block declarations found in the layout files of modules, the new `hyva-themes/magento2-base-layout-reset` module generates a version of those layout instructions without block declarations on the fly.
This means the reset-theme is no longer necessary. The benefits of this approach over the reset-theme are

1. Fewer layout XML files have to be loaded and processed, saving time on requests hitting a cold layout cache.
2. More future-proof because new core Magento modules will be automatically included in the reset.

The introduction of the generated base layout reset is **backward compatible**.

Existing themes extending directly from the reset-theme will continue to function, as long as the `hyva-themes/magento2-reset-theme` remains installed.
In case it is removed by the upgrade, because it was only installed as a transitive dependency of the default-theme, it will need to be re-installed explicitly until the custom Hyvä base themes have been migrated to use the generated base layout reset, too.

Please note, this step is not required. It is possible to keep existing themes extending from the reset-theme.
Please refer to the [generated base layout docs](../advanced-topics/generated-base-layout-resets.html) for details on the required migration steps and tooling.

Third party extension compatibility

There are a few third party extensions checking if a given theme is a Hyvä theme, by iterating over the parents to check if one of those starts with the string `Hyva/`.
This approach will no longer work. Instead, the new service class `\Hyva\Theme\Service\HyvaThemes` should be used (available since Hyvä 1.3.18).
Please refer to the generated base layout [extension compatibility docs](../advanced-topics/generated-base-layout-resets.html#third-party-extension-compatibility) for how to do so while remaining compatible with older versions of the Hyvä theme.

### Easier Styling and Future-Proofing

Version 1.4 introduces significant improvements to our styling workflow, making it easier to customize your theme while preparing for future advancements.

#### Tailwind v4 and Simplified Build Process

With Tailwind CSS v4 support now integrated into the Hyvä UI library, we are bringing this future-ready capability to the Default Theme itself.
We are confident this will work with most existing themes and modules but the syntax has changed a lot, so if you not sure where to start then please check the new [Updating to Tailwind 4 docs](../working-with-tailwindcss/updating-to-tailwind-4.html) to get you started.

This version also simplifies the Node.js build process. We now use a custom collection of Node scripts to handle parent theme and module CSS merging, reducing the complexity of building your styles.

> Hyvä Checkout v1.3.6+ and Hyvä CMS v1.0.2+ support Tailwind 4 and work without manual adjustments.

If you encounter Tailwind v4 warnings such as `Unknown at rule: @screen`, see the [TailwindCSS Troubleshooting → `Unknown at rule: @screen`](../working-with-tailwindcss/troubleshooting.html#unknown-at-rule-screen-on-tailwind-v4-builds) for fixes.

Modules that don't yet support Tailwind v4

If a module uses older Tailwind syntax or has custom CSS with `@import` statements that don't use relative paths (`./` or `../`),
it will not be compatible with Tailwind v4.

To resolve this, you must:
1. Exclude the module from the build process in your `hyva.config.json` file. See the exclude list documentation for instructions.
2. Manually add the paths to the module's templates in your theme's CSS file using `@source`.

For example, to include an older version of the Hyvä Checkout module, you would add:

```
@source "../../../../../../../vendor/hyva-themes/magento2-hyva-checkout/src/**/*.phtml";
@source "../../../../../../../vendor/hyva-themes/magento2-hyva-checkout/src/**/*.xml";
```

[For more details, please refer to the TailwindCSS Troubleshooting page](../working-with-tailwindcss/troubleshooting.html).

#### Design Tokens

We've added support for Design Tokens, which allow you to use a design system (like Figma) as the single source of truth for style values like colors, spacing, and fonts. This works similarly to how you previously used the `tailwind.config.js` file, but with enhanced support for integrating with professional design systems.

For more information, please see the documentation on [what Design Tokens are](../working-with-tailwindcss/design-tokens/faq.html) and our [Node script for tokens](../working-with-tailwindcss/using-hyva-modules/tokens.html).

#### CSS Components

This release introduces CSS Components, which make it easier to adjust the theme's appearance without altering the HTML structure. Combined with Design Tokens, this approach significantly reduces the need for template overrides when creating a custom theme. This feature is a work in progress, and we plan to expand it further.

#### Reworked Tailwind CSS Folder Structure

To align with the upcoming Tailwind CSS v4, we've reorganized our CSS source folders.

The new structure is named after Tailwind's `@layer` directives: `base`, `components`, and `utilities`. This provides a more logical and intuitive organization.

Please see the [CSS files documentation](../working-with-tailwindcss/hyva-theme-css-files.html) for a complete overview of the new structure.

### Bfcache Support Added

Hyvä now supports the browser's back/forward cache (bfcache) to provide instant back-and-forth page loads.
This feature is disabled by default to ensure backward compatibility.

To enable bfcache, two things are required:

1. **Default Theme Adjustments**
   Support for bfcache is included automatically in version 1.4.0.
   If you are using an older version, you will need to make manual adjustments.
2. **Varnish/Fastly Configuration**
   A manual configuration change is required for stores using Varnish or Fastly.
   By default, Magento 2 prevents bfcache from working.

Varnish/Fastly Prerequisite

At the time of writing, Magento 2 does not support bfcache and sends a `no-store` header that disables it.
While the community is working on a core solution (see the [open issue on the Magento 2 repo](https://github.com/magento/magento2/issues/38376)),
a workaround is necessary.

We provide a patch to remove this header from the default Magento 2 Varnish configuration.
This should only be applied if you understand the implications.

For complete instructions on enabling bfcache in your theme and applying the Varnish patch, please see our dedicated [bfcache documentation](../performance/bfcache.html).

### Speculation Rules & View Transitions Promoted

Previously experimental features, Speculation Rules and View Transitions, are now stable and fully integrated into the theme.

#### Speculation Rules

The Speculation Rules API is now fully integrated into the Theme module and can be configured to your needs.
It is enabled by default using `prefetch` instead of `prerender` to avoid issues with analytics tools.

We have also resolved a bug where the minicart would not update correctly on a prerendered page after an item was added via AJAX (e.g., using the Hyvä UI Ajax ATC Component), preventing out-of-sync issues.

#### View Transitions

View Transitions are now a core, CSS-based feature of the theme. If you wish to disable this feature, you can do so by removing the corresponding import from your CSS.

### Introducing New Sliders and Carousels

As showcased in the first [Hyvä Bytes](https://youtu.be/DZG4XUd3kRY?si=YgaRnSJ6fomLdQNb), the new [Snap Slider](../working-with-alpinejs/alpine-plugins/x-snap-slider.html) is now part of Hyvä and no longer exclusive to Hyvä UI.

This AlpineJS plugin is inspired by modern CSS-only carousels. For more information, see the [Chrome Dev Blog post on CSS-only Carousels](https://developer.chrome.com/blog/carousels-with-css).

To ensure broad browser support while using modern techniques, we've built a progressively enhanced CSS carousel. This allows you to build a CSS-only slider and then use a small amount of JavaScript to add features like navigation buttons, a pager, and making non-visible slides inert for better performance and accessibility.

This approach makes the carousel more robust and accessible than most JavaScript-based carousels.

This upgrade also resolves many issues found in the Magento PageBuilder Slider, which used the older Glider JS library.
From v1.4, all sliders in Hyvä are powered by a single Alpine plugin that can be used with simple markup:

```
<section x-data x-snap-slider>
    <div data-track>
        <!-- Slides go here -->
    </div>
</section>
```

The new [Snap Slider](../working-with-alpinejs/alpine-plugins/x-snap-slider.html) follows the ARIA Authoring Practices Guide (APG). While the slider attempts to add correct roles and ARIA attributes where they are missing, you should still write semantic HTML for the best results.

If you prefer the older Page Builder Slider

If you want to continue using the previous Page Builder slider, you'll need to copy the following files into your own theme before updating:

- `vendor/hyva-themes/magento2-default-theme/web/tailwind/components/page-builder.css`
- `vendor/hyva-themes/magento2-default-theme/web/tailwind/components/slider.css`
- `vendor/hyva-themes/magento2-default-theme/Magento_PageBuilder/web/js/glider.js`
- `vendor/hyva-themes/magento2-default-theme/Magento_PageBuilder/web/js/glider.min.js`
- `vendor/hyva-themes/magento2-default-theme/Magento_PageBuilder/templates/carousel-nav.phtml`
- `vendor/hyva-themes/magento2-default-theme/Magento_PageBuilder/templates/widgets/parallax.phtml`
- `vendor/hyva-themes/magento2-default-theme/Magento_PageBuilder/templates/widgets/carousel.phtml`
- `vendor/hyva-themes/magento2-default-theme/Magento_PageBuilder/templates/catalog/product/widget/content/carousel.phtml`

With this change, we are also introducing a new CSS component to make styling easier.
The `slider.css` file now contains the styles for all sliders used by Hyvä.
To customize sliders to match your brand, you only need to modify this one CSS file to affect all sliders.

We are also replacing the ViewModel slider with a simpler, XML-based one.
This follows the same method as the product slider, allowing you to create a slider with just a small snippet of XML:

```
<block name="block-slider" template="Hyva_Theme::elements/slider.phtml">
    <!-- Your Slides -->
</block>
```

This slider uses the same XML arguments and requires no extra input other than passing it child blocks. Each direct child block will be treated as a slide.

It's that simple.

### Introducing New Modals and Off-canvases using the native HTML Dialog

With this release, we are replacing our custom modal implementation with a new one based on the native HTML `<dialog>` element. This modern approach offers better performance, improved accessibility, and a more streamlined developer experience.

This change also introduces a new AlpineJS plugin, `x-htmldialog`, which simplifies the creation of modals and off-canvas elements.

The new implementation resolves many issues from the previous version and reduces the amount of JavaScript needed. From v1.4 onwards, all modals and off-canvases in Hyvä are powered by this single Alpine plugin, which can be used with simple, semantic markup:

```
<div x-data="{ open: false }">
    <button class="btn" @click="open = true">
        Open Dialog
    </button>

    <dialog x-htmldialog="open = false">
        <h3 class="text-lg font-medium">Dialog Title</h3>
        <p>This is the content of the dialog.</p>
        <button class="btn" @click="open = false">
            Close
        </button>
    </dialog>
</div>
```

The new dialogs follow the ARIA Authoring Practices Guide (APG) for dialogs, ensuring they are accessible out of the box.

We are not yet replacing the existing ViewModel-based modals, which will continue to function as before. However, we plan to integrate them with the new HTML `<dialog>` element in a future release.

## Breaking change regarding Adobe Cloud deployments

Tailwind v4 merging does not work with the default `.gitignore` from Adobe Cloud.
This approach can cause problems with Tailwind v4's `@source` feature, which ignores files listed in `.gitignore`.
To resolve this, you should use a `.gitignore` file that explicitly lists the files and directories to be ignored,
rather than ignoring everything and then un-ignoring.

Please refer to our [Adobe Commerce Cloud Deployment](../building-your-theme/adobe-commerce-cloud-deployment.html#troubleshooting-fixing-gitignore-for-tailwind-v4-compatibility) for more details.

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#140-2025-11-10)
- [Changelog Theme Module](changelog-theme-module.html#140-2025-11-10)
- [Changelog Default CSP Theme](changelog-default-theme.html#140-csp-2025-11-10)

## Tooling

Please refer to the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
