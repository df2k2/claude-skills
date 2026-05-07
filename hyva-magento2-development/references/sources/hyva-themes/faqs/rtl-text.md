<!-- source: https://docs.hyva.io/hyva-themes/faqs/rtl-text.html -->

# Right to Left Text (RTL)

Enabling RTL support in Hyvä requires minimal modifications.

Hyvä generally works well with RTL languages, except for static properties like margins and text alignments that need to be adjusted to accommodate a right-to-left layout.

## Specifying HTML Text Direction

Before applying RTL styles, ensure the `dir` attribute is added to the HTML tag alongside the `lang` attribute.

By adding `dir="rtl"` or `dir="ltr"` (the default value) to the HTML tag, the text direction is applied globally to the entire page.

> For information on the `dir` attribute see the [developer mozilla docs](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/dir)

### Method 1: Static, set by the theme

The simplest approach is to set the `dir` tag statically using XML via your theme's `default_head_blocks.xml` file:

```
<?xml version="1.0"?>
<page
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
>
    <html>
        <attribute name="dir" value="rtl"/>
    </html>
</page>
```

Tip

While some examples recommend adding the `dir` attribute to the body tag,
it is recommended to place it on the `html` tag along with the `lang` tag for proper document semantics.

### Method 2: Conditionally, based on the store language

To add the `dir` attribute to the HTML tag conditionally based on the current language,
you'll need to create a module with an observer.

Create a module with an `etc/frontend/events.xml` file:

```
<?xml version="1.0"?>
<config
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd"
>
    <event name="layout_load_before">
        <observer
            name="<VENDOR>_<MODULE>_add_dir_support"
            instance="<VENDOR>\<MODULE>\Observer\AddDirSupport"
        />
    </event>
</config>
```

Create the `Observer/AddDirSupport.php` file in your module:

Code Sample for the Observer AddDirSupport

```
<?php

declare(strict_types=1);

namespace <VENDOR>\<MODULE>\Observer;

use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;
use Magento\Framework\Locale\ResolverInterface;
use Magento\Framework\View\Page\Config as PageConfig;

class AddDirSupport implements ObserverInterface
{
    private $localeResolver;
    private $pageConfig;

    public function __construct(
        ResolverInterface $localeResolver,
        PageConfig $pageConfig
    ) {
        $this->localeResolver = $localeResolver;
        $this->pageConfig = $pageConfig;
    }

    /**
     * @inheritDoc
     */
    public function execute(Observer $observer)
    {
        $currentLang = strtolower(substr($this->localeResolver->getLocale(), 0, 2));
        $rtlLanguages = array('ar', 'arc', 'dv', 'fa', 'ha', 'he', 'khw', 'ks', 'ku', 'ps', 'ur', 'yi');
        $isRtl = in_array($currentLang, $rtlLanguages);
        $this->pageConfig->setElementAttribute(
            PageConfig::ELEMENT_TYPE_HTML,
            'dir',
            $isRtl ? 'rtl' : 'ltr'
        );
    }
}
```

## Using RTL Tailwind Utilities

Starting with Tailwind v3.0, you can add specific styles for RTL direction using the rtl modifier.

For example, to add margin to the left and remove margin from the right in RTL: `mr-4 rtl:mr-0 rtl:ml-4`.

For more details on usage, [refer to the Tailwind documentation](https://tailwindcss.com/docs/hover-focus-and-other-states#rtl-support)

## Using Direction-Aware Tailwind Utilities

Tailwind v3.3 introduced direction-aware utilities, allowing you to maintain consistent styling across LTR and RTL text directions with less effort.

Instead of using the traditional `pl-4` for left padding in RTL, you can simply employ `ps-4`, which automatically applies `pl-4` for LTR and `pr-4` for RTL.

This functionality relies on the introduction of new utility classes using `s` for "start" direction and `e` for "end" direction.

For instance, instead of using `pl-2` for left padding in RTL, you can utilize `ps-2`, ensuring consistent styling regardless of text direction.

To delve deeper into this feature, refer to the Tailwind v3.3 release blog post: [tailwindcss.com/blog/tailwindcss-v3-3#simplified-rtl-support-with-logical-properties](https://tailwindcss.com/blog/tailwindcss-v3-3#simplified-rtl-support-with-logical-properties).

For those still using an earlier Tailwind version, the Tailwind RTL Plugin: <https://www.npmjs.com/package/tailwindcss-rtl> community plugin offers backward compatibility and provides direction-aware utilities.
