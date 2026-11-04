<!-- source: https://docs.hyva.io/hyva-themes/cms/full-bleed-cms-content.html -->

# Full Bleed CMS Content

By default, Hyvä applies a `container` class to all pages to keep content within a consistent max-width. Sometimes you want a section to break out of that container and span the full browser viewport. This page covers three techniques for achieving a full-bleed layout in CMS content.

## Method 1: Page Builder Full-Width Layout

The quickest option if you're already using Page Builder. Switch the page layout to "Page -- Full Width" in the page design settings, then use a Page Builder Row block for any sections that need a constrained container. Everything outside the Row stretches edge to edge.

## Method 2: CSS Full-Bleed Techniques

These CSS-based approaches require the [CMS Tailwind JIT module](tailwind-jit/index.html) so that Tailwind utility classes used in CMS content are compiled and injected automatically.

### Viewport Full-Bleed Technique

This technique uses negative margins and viewport-width sizing to break an element out of its container.

Warning

This method adds horizontal overflow to the page and can cause unexpected behavior in some edge cases. It is the least recommended of the CSS approaches.

First, ensure the parent element has `overflow: hidden` set. This is typically `.page-main` or `body`. Then apply these Tailwind classes to the element you want to be full-width:

```
ml-[50%] w-screen -translate-x-1/2
```

### Border Image Technique

This technique uses `border-image` with a conic gradient to paint a background color across the full viewport width. Apply this Tailwind arbitrary value to the element:

```
[border-image:conic-gradient(theme(colors.blue.400)_0_0)_fill_0//0_100vw]
```

Replace `theme(colors.blue.400)` with any color from your theme. The conic gradient is used because `border-image` does not support solid colors directly. This approach avoids the horizontal scrollbar that the Viewport Full-Bleed technique can introduce, and border images support more creative patterns beyond simple solid colors.

## Method 3: CSS Grid Full-Bleed

This approach restructures the `.columns` container using CSS grid, giving you fine-grained control over which elements break out of the centered column. It requires familiarity with CSS grid.

The grid creates three columns: two equal outer columns and one centered content column. All direct children of `.main` default to the center column. Any child with the `.fullbleed` class spans all three columns to achieve full-width.

CSS Grid full-bleed implementation for CMS pages

```
/* Apply grid-based layout only to CMS pages */
.cms-page-view .columns {
    /* Remove the default container constraints */
    max-width: 100%;
    padding-inline: 0;
    margin-inline: 0;

    /* Apply a three-column grid to the main content wrapper */
    & .main {
        --max-width: var(--container-sm);
        --padding: --spacing(6);
        display: grid;
        /* Center column is constrained by max-width; outer columns fill remaining space */
        grid-template-columns:
            1fr
            min((var(--max-width) - (var(--padding) * 2)), calc(100% - (var(--padding) * 2)))
            1fr;
        column-gap: var(--padding);

        @screen md {
            --max-width: var(--container-md);
        }

        @screen lg {
            --max-width: var(--container-lg);
        }

        @screen xl {
            --max-width: var(--container-xl);
        }

        @screen 2xl {
            --max-width: var(--container-2xl);
        }

        /* All direct children sit in the center column by default */
        & > * {
            grid-column-start: 2;
        }

        /* Add .fullbleed to any element that should span the full viewport width */
        & .fullbleed {
            width: 100%;
            grid-column: 1 / -1;
        }
    }
}
```

## Related Topics

- **[CMS Tailwind JIT Module](tailwind-jit/index.html)** - Required for Methods 2 to apply Tailwind classes in CMS content.
- **[Installing the CMS Tailwind JIT Module](tailwind-jit/installation.html)** - How to install and configure the CMS Tailwind JIT module.
