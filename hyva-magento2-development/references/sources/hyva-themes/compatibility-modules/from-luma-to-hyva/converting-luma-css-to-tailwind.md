<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/from-luma-to-hyva/converting-luma-css-to-tailwind.html -->

# Converting Luma CSS to Tailwind

Besides JavaScript, all Luma CSS also needs to be converted to [Tailwind CSS](https://tailwindcss.com/) so it works with Hyvä.

There are several ways modules implement CSS styles in Luma, and as such the right approach to convert them can differ.

This section of the documentation aims to shed some light on the best way forward in each case.

## Replacing Luma Styles

When converting `.phtml` templates written for Luma to Hyvä, all CSS styles need to be replaced with Tailwind CSS classes.

Please refer to [Working with Tailwind CSS](../../working-with-tailwindcss/index.html) for resources to get you started if you are new to this CSS utility class framework.

**Example**

Luma Code:

```
<ul class="compare wrapper">
    <li class="item link compare">
        <a class="action compare no-display" title="Compare products">
```

Hyvä Code:

```
<div class="flex items-center">
    <a
        id="compare-link"
        class="relative hidden md:inline-flex btn bg-transparent border-transparent p-1 invisible"
        aria-label="Compare Products"
    >
```

## Additional .less styles

Some modules include additional CSS files compiled by the Magento LESS compiler.

These CSS files are usually included with layout XML. They need to be removed and replaced with inline Tailwind CSS classes.

Example removal of an additional LESS based CSS file with layout XML:

```
<remove src="Some_Module::css/styles.css"/>
```

## External Non-Luma CSS

Some modules include CSS files that are independent on Magento and the Magento LESS system.

Commonly these are style are bundled with JavaScript libraries.

When deciding how to deal with them multiple factors need to be taken into account:

- Is the file part of an external JavaScript library and the library will be removed by the compatibility module?
  If yes, remove the CSS file, too.

  ```
  <remove src="Some_Module::css/some.css"/>
  ```
- Is the CSS part of the Critical Rendering Path?
  If yes, consider removing the file and using inline Tailwind CSS classes instead.

  ```
  <remove src="Some_Module::css/some.min.css"/>
  ```
- Is the CSS NOT used in the Critical Rendering Path and independent of Magento Luma?
  In this case we suggest using the external CSS inside of Hyvä, but consider loading it when needed instead of always loading it automatically.
  The following example loads the CSS file on demand on the first user interaction with the page.

  ```
  document.addEventListener('init-external-scripts', () => {
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.type = 'text/css';
      link.href = '<?= $escaper->escapeUrl($block->getViewFileUrl('Some_Module::css/some.css')) ?>';
      document.head.append(link);
  }, {once: true});
  ```

## Automatic Conversion of styles to Tailwind CSS

Converting existing styles to Tailwind CSS can be done manually, but BeyondCode created a great utility that helps make the process a lot faster.

It is a [browser plugin called windy](https://usewindy.com/?ref=hyva) (at the time of writing the price is 49 EUR). The plugin works with any Chrome or Firefox based browser.

The result isn’t perfect, but it does make the process faster.

Watch this 4 minute video to see how it works:

One small but sometimes useful feature of windy that isn’t mentioned in the video is that when holding the Shift key while clicking on a DOM section, the plugin will copy only the tailwind styles for the target element, not the HTML + Tailwind CSS classes.
