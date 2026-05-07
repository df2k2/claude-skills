<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/loading-indicator.html -->

# Loading Indicator

The Hyvä theme comes with an animated full page loader that can be used with custom Alpine.js components.

At the time of writing, the loader is only used on the cart page.

To use it, two steps are required.

## 1. Render the required HTML in the component

First, the template `Hyva_Theme::ui/loading.phtml` must be rendered within your component.

This is most easily done by adding a child block in layout XML:

```
<block name="my-component" template="My_Module::my-template.phtml">
    <block name="loading" template="Hyva_Theme::ui/loading.phtml"/>
</block>
```

The child block must be rendered within the Alpine.js component:

```
<?= $block->getChildHtml('loading') ?>
```

## 2. Set the `isLoading` property on your Alpine.js component

Next, the Alpine.js component needs a property `isLoading`.

Whenever the property is set to `true`, the loader will be visible.

## Example

```
<script>
    'use strict';

    function initMyComponent() {
        return {
            isLoading: true,
            extractSectionData(cartData) {
                // Do something with the data
                // When ready, hide the loader
                this.isLoading = false;
            }
        }
    }
</script>
<section x-data="initMyComponent()"
         @private-content-loaded.window="extractSectionData($event.detail.data)"
>
    <?= $block->getChildHtml('loading') ?>
    <template x-if="!isLoading">
        <div> ... render the component content ...</div>
    </template>
</section>
```
