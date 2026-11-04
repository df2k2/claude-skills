<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/custom.html -->

# Creating a Custom Hyvä Alpine.js Plugin

This guide will walk you through creating a custom inline Alpine.js plugin for your Hyvä theme. For a detailed guide on how to write a plugin, please refer to the official Alpine.js documentation on [extending Alpine.js](https://alpinejs.dev/advanced/extending).

### Step 1: Create the plugin file

First, create a `.phtml` file in your module's `view/frontend/templates` directory. For example:

`app/code/Acme/Module/view/frontend/templates/page/js/plugins/custom.phtml`

### Step 2: Add the plugin code

Inside the `custom.phtml` file, add your Alpine.js plugin code within `<script>` tags.
Here is a basic boilerplate to get you started:

```
<script>
    (() => {
        const yourPlugin = (alpine) => {
            alpine.directive('your-directive', (el, { expression }, { evaluate }) => {
                console.log(evaluate(expression));
            });
        };

        document.addEventListener("alpine:init", () => {
            window.Alpine.plugin(yourPlugin);
        });
    })();
</script>
```

You can either write your own plugin logic inside the `yourPlugin` constant or copy the code from an existing plugin.

### Step 3: Load the plugin via layout XML

Finally, to load your inline script, add the following block to your theme's layout XML file (e.g., `default.xml`):

```
<referenceBlock name="script-alpine-js">
    <block name="alpine-plugin-custom" template="Acme_Module::page/js/plugins/custom.phtml"/>
</referenceBlock>
```

This will inject your script right after Alpine.js is initialized, making your custom plugin available on all pages where the `script-alpine-js` block is present.
