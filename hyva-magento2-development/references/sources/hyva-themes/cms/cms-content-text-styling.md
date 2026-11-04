<!-- source: https://docs.hyva.io/hyva-themes/cms/cms-content-text-styling.html -->

# Styling CMS Text Content

When you paste or write HTML into a CMS block or page, headings, paragraphs, and bullet lists often render as unstyled plain text on the storefront. This is a side effect of Tailwind CSS's base reset. The fix is the `prose` class from the Tailwind CSS Typography plugin.

## Tailwind CSS Reset and CMS Content

Like most CSS frameworks, Tailwind CSS starts with a reset of browser-native styles. This lets you apply styles consistently using utility classes, but it has a downside: all HTML elements lose their default styling and must be explicitly styled again. When writing HTML templates, that is not a problem. But content intended to look styled by default, such as CMS blocks and pages, no longer renders correctly.

You can see this immediately by creating a static CMS block with H2 headings, paragraphs, and bullet lists. None of them render as expected on the frontend without additional CSS.

## The `prose` Class

Since Hyvä 1.4, the `prose` utility class is provided by the `@hyva-themes/hyva-modules` package as part of its CSS layer. In earlier versions it came from the `@tailwindcss/typography` plugin.

Adding `prose` to a container element restores readable default styles for all standard HTML elements inside it: headings, paragraphs, lists, blockquotes, links, and code. The Hyvä prose implementation uses CSS custom properties and has lower specificity than utility classes, so Tailwind utilities applied inside a `prose` container work without needing `unset` overrides.

For a full comparison of the Hyvä implementation and the options available, see [Hyvä Prose Typography](../working-with-tailwindcss/using-hyva-modules/prose.html).

## Prose and Max-Width

The Hyvä `prose` implementation has no max-width by default. To constrain line length for readability, add `max-w-prose` or any other max-width utility to your container:

```
<div class="prose max-w-prose">
    <!-- CMS content here -->
</div>
```

Upgrading from Hyvä 1.3 or earlier?

The old `@tailwindcss/typography` plugin added a max-width by default, so projects on earlier versions often used `prose max-w-none` to remove it. That override is no longer needed and can be removed when upgrading to Hyvä 1.4.

## Applying `prose` to All Static Blocks Automatically

Out of the box, the `prose` class must be applied to each CMS block or page individually. To add it automatically to every static content block, override the appropriate template in your child theme.

For example, to apply `prose` to all CMS content rendered on category pages, override `Magento_Catalog/templates/category/cms.phtml` in your theme:

app/design/frontend/Vendor/Theme/Magento\_Catalog/templates/category/cms.phtml

```
<?php if ($block->isContentMode() || $block->isMixedMode()) :?>
    <div class="category-cms prose max-w-none">
        <?= $block->getCmsBlockHtml() ?>
    </div>
<?php endif; ?>
```

## Related Topics

- **[Using Tailwind Classes in CMS Content](tailwind-jit/index.html)** - How to use Tailwind utility classes inside CMS blocks and pages using the CMS Tailwind JIT module.
