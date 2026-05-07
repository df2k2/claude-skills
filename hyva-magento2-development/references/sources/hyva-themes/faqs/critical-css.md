<!-- source: https://docs.hyva.io/hyva-themes/faqs/critical-css.html -->

# Critical CSS

Critical CSS is not supported by Hyvä

Enabling this feature without understanding the potential impact may cause loading and performance issues!

## What is Critical CSS?

Critical CSS is an outdated technique used to improve page load times by inlining essential CSS for above-the-fold content. However, this approach is now largely unnecessary and can even harm your page speed in most cases. There are only a few exceptions where Critical CSS might still be useful.

With Hyvä, you should generally avoid using Critical CSS. This is mainly due to the integration of **TailwindCSS**, which is designed to be lightweight and efficient.

### Why TailwindCSS Makes Critical CSS Obsolete

TailwindCSS automatically includes only the necessary styles for each page, avoiding unused CSS and keeping the CSS file size minimal. This drastically reduces render-blocking time compared to traditional approaches that load large, global CSS files.

## Understanding Critical CSS in Magento

In Magento's default Luma Theme (but not the Magento Blank Theme), Critical CSS support was introduced. Luma’s CSS could become quite large, as it included styles for various specific pages in a single global CSS file. This meant that unnecessary styles were loaded for every page, causing performance bottlenecks.

Hyvä addresses this problem by leveraging CSS utilities for global styles, minimizing unused styles to near-zero.

To better understand why Critical CSS is rarely needed today (not just in Hyvä), we recommend reading [this article](https://csswizardry.com/2022/09/critical-css-not-so-fast/) from CSS Wizardry.

## Why Was Critical CSS Used in the Past?

The primary purpose of Critical CSS was to eliminate render-blocking resources like CSS. Render-blocking resources delay the time it takes for a page to become interactive.

However, getting a **"render-blocking CSS"** warning in tools like Google Lighthouse doesn’t always mean something is fundamentally wrong. It often points to **excessive unused CSS** or a **large CSS file**.

### Inline CSS: Not Always the Best Solution

One solution to render-blocking warnings is inlining all critical styles, but this can lead to other issues, such as excessively large HTML files. There’s no one-size-fits-all solution, and you must find a balance that works best for your site.

**Our recommendation:**
Use a single global CSS file for most of your styles, and inline only the CSS needed for specific components or pages. This approach is reflected in our **JIT CMS module**, which loads CSS only for the content on that particular page.

## Adding Critical CSS in Hyvä (If Absolutely Necessary)

If, despite these recommendations, you still need to implement Critical CSS due to significant issues with your existing CSS (and fixing it isn't an option), follow these steps:

1. Add the following XML to your theme in the `Magento_Theme/layout/default_head_blocks.xml` file:

   ```
   <?xml version="1.0"?>
   <page
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
   >
       <body>
           <referenceBlock name="head.additional">
               <block
                   name="critical_css_block" as="critical_css"
                   template="Magento_Theme::html/header/criticalCss.phtml"
                   ifconfig="dev/css/use_css_critical_path"
               >
                   <arguments>
                       <argument
                           name="criticalCssViewModel"
                           xsi:type="object"
                       >Magento\Theme\Block\Html\Header\CriticalCss</argument>
                   </arguments>
               </block>
           </referenceBlock>
       </body>
   </page>
   ```
2. Create a `critical.css` file inside your theme’s `web/css` directory.
3. Once the file is created, enable Critical CSS in the Magento 2 Admin by navigating to:

   `Stores → Configuration → Advanced → Developer → CSS Settings → Use CSS critical path`.

## Related Topics

- **[Hyvä Performance Tips](../performance/hyva-performance-tips.html)** - Frontend optimization guide covering images, Alpine.js, CSS, and DOM size
