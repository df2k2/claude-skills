<!-- source: https://docs.hyva.io/hyva-themes/cms/cms-content-text-styling.html -->

# Styling CMS text content

## CSS Reset

Like most other CSS frameworks, Tailwindcss starts with a reset of the browser-native styles.
This allows applying styles consistently using Tailwindcss classes, but it has a downside:
all HTML elements lose their default styling and have to be styled again. When writing HTML content that is not a problem,
but content that is intended to be styled by default no longer looks right.

This can be seen first-hand by creating a static CMS block with some H2 headers, paragraphs, bullet lists etc: none of them render correctly on the frontend.

## The prose class

Tailwinds solution to this issue is the [tailwindcss/typography](https://tailwindcss.com/docs/typography-plugin) plugin (which is installed with Hyvä by default).
It provides the `prose` utility classes.

The `prose` class makes normal text content render nicely. It also comes in presets to allow the text styles to matched to a sites look and feel.

## Prose max-width

Each `prose` size preset has a max-width set, to keep text readable.

To override the max-width on the prose-class, you have to use prose max-w-none, for example `class="prose max-w-none"`

## Adding prose to all static blocks

Out of the box, the `prose` class needs to be applied to each static CMS block or page individually.
If you want to add it to every static content block automatically, the appropriate template needs to be overridden in your child theme.

For example, to automatically add the `prose` class to all CMS content rendered on category pages, override the `Magento_Catalog/templates/category/cms.phtml` in your theme to add the classes:

```
<?php if ($block->isContentMode() || $block->isMixedMode()) :?>
    <div class="category-cms prose max-w-none">
        <?= $block->getCmsBlockHtml() ?>
    </div>
<?php endif; ?>
```
