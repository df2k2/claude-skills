<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/dynamic-tailwind-classes.html -->

# Dynamic Tailwind CSS Classes

Dynamic Tailwind classes are CSS utility classes constructed at runtime using PHP or JS variables or conditional logic. In Hyvä themes, developers often need to generate Tailwind classes dynamically for configurable UI components like grids, columns, or responsive layouts.

## Why Dynamic Tailwind Classes Are Not Generated

When you build Tailwind CSS using `npm run build` or `npm run watch`, dynamically constructed classes are missing from the output. This happens because the Tailwind compiler scans source files for complete class names — it cannot evaluate PHP variables or expressions.

The following example demonstrates the problem with dynamic Tailwind classes:

Example of dynamically generated Tailwind classes

```
<!-- Tailwind cannot detect these dynamic classes -->
<ul class="
    gap-8
    columns-<?= $responsiveColumnsNumber ?>
    xl:columns-<?= $columnsNumber ?>
"></ul>
```

Tailwind sees `columns-<?=` as a literal string, not as `columns-1`, `columns-2`, or `columns-3`. Since the compiler only generates CSS for classes it finds in the source files, the dynamic variations are not included in the build output.

## Using Dynamically Set CSS Variables

The recommended solution for dynamic Tailwind classes in Hyvä is to use Tailwind CSS variables.
Instead of using the dynamic value directly in the CSS class name, it refers to a CSS variable.
The dynamic value is then assigned to the CSS variable.

Example of dynamic Tailwind classes with CSS Variables in Tailwind v4

```
<ul class="
      gap-8
      columns-(--responsive-columns-number)
      xl:columns-(--columns-number)
    "
    style="
      --responsive-columns-number: <?= $responsiveColumnsNumber ?>;
      --columns-number: <?= $columnsNumber ?>;
    "></ul>
```

See [CSS Variables + TailwindCSS](css-variables-plus-tailwindcss.html#setting-css-variables-with-php) for another example.

## Declaring Dynamic Classes in PHP Comments

Another solution for dynamic Tailwind classes in Hyvä is to declare all possible class values in a PHP comment near where they are used. Tailwind scans all text content in source files, including comments, so classes listed in comments will be included in the CSS build.

This approach keeps the class declarations close to their usage, which improves maintainability. When the template is removed, the class declarations are also removed.

The following example shows how to declare dynamic Tailwind classes using a PHP comment:

```
<?php
// Declare possible values for Tailwind:
// columns-1 columns-2 columns-3 xl:columns-1 xl:columns-2 xl:columns-3
?>
<ul class="
    gap-8
    columns-<?= $responsiveColumnsNumber ?>
    xl:columns-<?= $columnsNumber ?>
"></ul>
```

Best Practice

Use PHP comments to declare dynamic classes whenever all possible values are known. This keeps the declaration co-located with the usage and ensures automatic cleanup when templates are removed.

## Safelisting Dynamic Classes in Tailwind Configuration

When dynamic class values cannot be declared in comments (for example, when values come from database configuration or external sources), you can force Tailwind to generate specific classes using the safelist feature. Safelisted classes are always included in the CSS output, regardless of whether they appear in source files.

Tailwind 4Tailwind v3

In Tailwind v4, add a `@source inline()` directive to your theme's `tailwind-source.css` file. This directive tells Tailwind to generate CSS for the specified class patterns.

tailwind-source.css

```
/* Generate columns-1, columns-2, columns-3 with and without xl: prefix */
@source inline("{xl:,}columns-{1,2,3}");
```

See the [Tailwind v4 documentation on safelisting utilities](https://tailwindcss.com/docs/detecting-classes-in-source-files#safelisting-specific-utilities) for more pattern syntax options.

In Tailwind v3, add classes to the `safelist` array in your `tailwind.config.js` file. You can use regex patterns to match multiple class variations.

tailwind.config.js

```
module.exports = {
  safelist: [
    {
      // Match columns-1, columns-2, columns-3
      pattern: /columns-(1|2|3)/,
      // Also generate lg: variant for each
      variants: ['lg'],
    },
  ]
  // ...
}
```

See the [Tailwind v3 documentation on safelisting classes](https://v3.tailwindcss.com/docs/content-configuration#safelisting-classes) for more configuration options.

Safelist Considerations

Safelisted classes are always generated, even if unused. This increases CSS file size. Prefer the PHP comment approach when possible, and use safelisting only when class values are truly dynamic or externally configured.
