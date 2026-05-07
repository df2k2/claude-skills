<!-- source: https://docs.hyva.io/hyva-themes/cms/full-bleed-cms-content.html -->

# Full Bleed CMS Content

By default, Hyvä applies a `container` class to all pages, ensuring a consistent and structured layout. However, there are instances where you might want to break free from this container to create a more immersive, full-width experience.

Down here you will find a few method to achieve this.

## Method 1: Leveraging the Page Builder

The Magento Page Builder provides a straightforward approach for full-width CMS content.

Simply switch the page layout design to "*Page -- Full Width*" and utilize the Page Builder "*Row*" block for sections requiring structured content.

## Method 2: The CSS Full Bleed methods

Before embarking on the CSS route, ensure you've installed the [CMS Tailwind JIT](cms-tailwind-jit-module.html) module.

This module enables the application of Tailwind classes directly from CMS content.

### Viewport full Bleed technique

Warning

This method introduces an overflow on the page and can lead to unexpected behavior in certain edge cases. It is considered the least recommended option.

First ensure the parent element of the full-width content has an overflow: hidden property, typically `.page-main` or `body`.

Apply the following classes to your element to break free from the container:

```
ml-[50%] w-screen -translate-x-1/2
```

### Border image technique

This technique utilizes border-image to break free from the container:

```
[border-image:conic-gradient(theme(colors.blue.400)_0_0)_fill_0//0_100vw]
```

This border image employs a clever trick to create a solid color, as border-image doesn't support solid colors directly.

Replace `theme(colors.blue.400)` with your desired color to match your branding.

This method eliminates the horizontal scrollbars introduced by the Viewport Full Bleed technique.

Additionally, border images allow for more creative patterns beyond simple colors.

## Method 3: CSS Grid method

This method requires modifying how the main page layout `.columns` container is handled.

It involves more CSS adjustments and assumes proficiency in CSS grid.

Code Sample: Applying CSS Grid to CMS Pages

```
.cms-page-view .columns {
    /* Unset the container */
    max-width: 100%;
    padding-inline: 0;
    margin-inline: 0;

    /* Apply grid based container on the main content wrapper */
    & .main {
        --max-width: var(--container-sm);
        --padding: --spacing(6);
        display: grid;
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

        & > * {
            grid-column-start: 2;
        }

        /* If the content needs to escape use full */
        & .fullbleed {
            width: 100%;
            grid-column: 1 / -1;
        }
    }
}
```

This code snippet applies CSS grid to only CMS pages, ensuring a consistent layout for non-CMS pages.

To ensure a seamless transition to this method, carefully test and refine your CSS code to achieve the desired full-width effect while maintaining overall page structure and responsiveness.
