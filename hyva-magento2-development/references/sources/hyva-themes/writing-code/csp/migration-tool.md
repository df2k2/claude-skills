<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/migration-tool.html -->

# CSP Migration tool

This script helps migrate existing code to CSP-compliant code.

Caution, Review Before Running

Never run this script in production! It modifies files in place, and the output will show the changes made.

Always review the output and verify the changes before pushing anything to production—don’t just **YOLO** it!

## Prerequisites

- PHP `8.1` and up.
- A `composer.json` with type `magento2-theme` or `magento2-module` is optional, but recommended.
- No full Magento installation is needed.

## Installation

If you have a valid license, you have access to our packagist and can install the upgrade helpers.

```
# Install in a module, theme or project
composer require --dev hyva-themes/upgrade-helper-tools:dev-main
# Install globally
composer global require --dev hyva-themes/upgrade-helper-tools:dev-main
```

## Running

After installation, execute the script.

```
# Install in a module, theme or project
composer exec hyva-csp-helper .
# or a specific directory if you are running it in a project
composer exec hyva-csp-helper app/code/Vendor/Module
# or theme
composer exec hyva-csp-helper app/design/frontend/MyTheme/default

## If globally installed

# Inside a module or theme
composer global exec hyva-csp-helper .
# or a specific directory if you are running it in a project
composer global exec hyva-csp-helper app/code/Vendor/Module
# or theme
composer global exec hyva-csp-helper app/design/frontend/MyTheme/default
```

Run it against multiple directories at once.

```
composer exec hyva-csp-helper app/design/frontend/MyTheme/default \
      app/design/frontend/MyTheme/child
```

## Output and redirecting output

Files are updated **in place**, and the output is written in Markdown on the screen.
This output details the changes made, so you don’t need to run a diff afterward.

- add `@DONE!` to indicate something works out-of-the-box.
- and `@TODO!` if you need to review something.

Use this output to understand what's updated and why.

### Writing output

Pipe the output to write the contents to a file in Markdown format.

Just append `| tee CSP-updates.md` to the command line, this creates or overwrites the existing file (for append `| tee -a CSP-updates.md`)

```
composer global exec hyva-csp-helper [...DIRECTORY] | tee CSP-updates.md
# or append
composer global exec hyva-csp-helper [...DIRECTORY] | tee -a CSP-updates.md
```

After that open and that in your favorite Markdown viewer.

## What it does

The steps are done in order, some steps depend on each other.

- [Applies composer requirements](#composer-requirements)
- [Applies Alpine CSP compatibility](#alpine-csp-compatibility)
- [Checkout: Move scripts to footer](#checkout-move-scripts-to-footer)
- [Add RegisterInlineScript](#register-inline-scripts)

## What it doesn't do

This script will only review frontend `*.phtml` files.

PHP files, such as Models or ViewModels, require manual migration.

This script specifically searches for `(x-|@|:).*=".*"` to find and replace Alpine attributes.
PHP arrays, such as `[":class" => "hello"]` are not handled by this script. This pattern is commonly used for adding SVGs, so these cases must be updated manually.

## Composer Requirements

At least version `1.3.11` of `hyva-themes/magento2-theme-module` is required in `composer.json`

**For checkout**, if `hyva-themes/magento2-hyva-checkout` is found in `composer.json`
or `etc/module.xml` contains `Hyva_Checkout`, it requires at least version `1.3.0` and up for `hyva-themes/magento2-hyva-checkout`.

## Alpine CSP Compatibility

Inspect all Alpine JS attributes in frontend `*.phtml` files and converts them to CSP-compatible ones.

### Remove `x-spread` operators

Remove all references to `x-spread`, which is only in the theme for Alpine v2 backward compatibility. It has been [replaced by `x-bind`](https://alpinejs.dev/upgrade-guide#x-spread-now-x-bind) since Alpine v3.0.

To manually migrate `x-spread` to `x-bind` be aware that you don't get duplicate `x-bind` attributes.

```
grep -Rl 'x-spread=' src/view/frontend/templates \
    | xargs sed -i 's/x-spread=/x-bind=/'
```

### Replace `x-model`

In Alpine CSP it is not possible to use `x-model=`, as it throws an error.
A simple replacement is a combination of `:value=` and `@change`

Example of a migration: `awesome.phtml`

```
-<input x-model="value" />
+<input :value="value" @change="value = $el.value" />
```

This pattern needs to be adjusted accordingly for select, checkbox and radio input types.
Please see the dedicated [x-model replacement documentation](./alpine-csp-x-model.html) for details.

### Migrate empty `x-data`

This is a preparation and makes sure that the `x-data` initialization is correctly handled with Alpine CSP, it is replaced with `x-data="{}"`.

### Move inline PHP into dataset attributes

Because we are decoupling the script- and html components, in-context PHP could become out of context/scope when moved.
Moving inline PHP to `data-*` attributes keeps them on the same line as the original code and preserves the context/scope.

- migrated attributes are logged
- data attributes are prefixed with `hyvacsp` and numbered
- `$escaper->escapeJs` is migrated to `$escaper->escapeHtmlAttr`
- if PHP code contains `json`, `JSON.parse(...)` is applied for decoding
- if PHP code contains `(int)`, `parseInt(...)` is applied for decoding
- if PHP contains `true|false`, `(... === true)` is applied for decoding
- be aware that moving to datasets migrates values to strings

Example: `awesome.phtml`

```
-<button @click="hello('<?= $escaper->escapeJs('World') ?>')">
+<button @click="hello(`$el.dataset.hyvacsp1`)" data-hyvacsp1="<?= $escaper->escapeHtmlAttr('World') ?>">
```

Multiple occurrences are replaced with multiple references.
Example: `awesome.phtml`

```
-<button @click="hello('<?= $escaper->escapeJs('World') ?>', <?= $escaper->escapeJs(1) ?>)">
+<button @click="hello(`$el.dataset.hyvacsp1`, $el.dataset.hyvacsp2)" data-hyvacsp1="<?= $this->escapeHtmlAttr('World') ?>" data-hyvacsp2="<?= $escaper->escapeHtmlAttr(1) ?>">
```

If the PHP is part of a resulting word, this is not migrated, otherwise the result would need evaluation itself, which is prohibited under strict CSP.

## Create Alpine script component

This step adds `<script>`s to the file, replaces attribute values with strict CSP-compliant alternatives, and moves inline code to the Javascript component.

Naming

The naming of a component or attribute is based on the module name or theme name, so the filename is unique.
Use these references during manual refactoring and reviewing to restore context.

The script tries its best to add `this.*` to resolve values/methods inside the Alpine components correctly.

- Created Components are logged
- Migrated attributes are logged
- `this.` is added using migration rules
- simple evaluations are not migrated `xyz` and `!xyz` (if `()` it is migrated because it is a method call)

### First example

file: `awesome.phtml` before migration:

```
<div x-data="{visible: false, level: {up: 'Some content'}}">

    <button @click="visible = !visible" />

    <template x-show="visible">
        <div x-text="level.up"></div>
    </template>
    <template x-show="!visible">
        <div x-html="level.up"></div>
    </template>
</div>
```

After migration: (*comments added inline for clarity, not in the real output*)

```
<!-- this is a unique reference for this file and module -->
<div x-data="AwesomeModuleAwesome">

    <!-- the same prefix is used, type Event, Click for the type of event and a unique reference within this run -->
    <button @click="AwesomeModuleAwesomeEventClick1" />

    <!-- visible is a simple value and therefore not replaced -->
    <template x-show="visible">
        <!-- this is a getter, so Value is used, Text for the type and a unique numbered reference -->
        <div x-text="AwesomeModuleAwesomeValueText2"></div>
    </template>
    <!-- !visible is a simple value and therefore not replaced but javascript is added for its execution -->
    <template x-show="!visible">
        <!-- this is a getter, so Value is used, Html for the type, and a unique numbered reference -->
        <div x-html="AwesomeModuleAwesomeValueHtml3"></div>
    </template>
</div>

<script>
    // The script is always assigned to the global scope, this makes it open for change
    function AwesomeModuleAwesome() {
        return Object.assign(
                // This is the original object defined in x-data
                {visible: false, level: {up: 'Some content'}},
                {
                    // The code from the modules is updated and got these references where needed
                    ['AwesomeModuleAwesomeEventClick1'](event) {return this.visible = !this.visible},
                    ['AwesomeModuleAwesomeValueText2']() {return this.level.up},
                    ['AwesomeModuleAwesomeValueHtml3']() {return this.level.up},
                    ['!visible']() {return !this.visible},
                }
        );
    }
    window.addEventListener('alpine:init', () => Alpine.data('AwesomeModuleAwesome', AwesomeModuleAwesome), {once: true});
</script>
```

Whereas `x-data="initMyComponent()"` is migrated to the following js.

```
function AwesomeModuleAwesome() {
    return Object.assign(
        initMyComponent()
    )
// ...
}
```

### Alpine scoped reference

`x-data="initMyComponent"` is migrated and `.call(this)` is added, so the object context is preserved.

```
function AwesomeModuleAwesome() {
    return Object.assign(
        initMyComponent.call(this)
    )
// ...
}
```

### Moving inline PHP

If PHP (FI `x-data="initFunction<?= $magicNumber ?>()"`) is part of the attribute value, it will be moved to the Alpine component script.

```
?>
<script>
function AwesomeModuleAwesome() {
    return Object.assign(
        initFunction<?= $magicNumber ?>()
)
//...
}
</script>
```

#### Avoid unique scripts

Writing code with references could result in multiple unique versions of *almost* the same code.
This can result in "Header too large" errors, as every unique script will add an extra `sha256-hash`.

Experimental: Inline JS merging with `hyva-themes/magento2-minification`

The `hyva-themes/magento2-minification` module can merge inline JS besides minifying HTML, JS, and CSS with better results than the native Magento minification. This means only a single `sha256-hash` is added to the CSP header, avoiding "Header too large" errors. The module is currently experimental but can be tested already. For more information, see the [module readme](../../performance/hyva-minification-readme.html).

This can sometimes be avoided by using dataset attributes as explained in the following example.

Original: `awesome.phtml`

```
?>
<div x-data="myFunction_<?= $escaper->escapeJS($block->getProductId()) ?>">
</div>
<script>
function myFunction_<?= $escaper->escapeJS($block->getProductId()) ?>() {
    return {
        id: <?= $escaper->escapeJS($block->getProductId()) ?>,
        config: <?= $escaper->escapeJs($block->getJsonConfig()) ?>
    }
}
</script>
```

Updated: `awesome.phtml`

```
?>
<div x-data="myFunction"
     data-product-id="<?= $escaper->escapeHtmlAttr($block->getProductId()) ?>"
     data-config="<?= $escaper->escapeHtmlAttr($block->getJsonConfig()) ?>"
     >
</div>
<script>
function myFunction() {
    return {
        id: parseInt(this.$el.dataset.productId),
        config: JSON.parse(this.$el.dataset.config)
    }
}
</script>
```

### Bind Alpine JS components to the global scope

Inline components cannot be extended, the migration tool will bind these functions to the window/global scope so it can be extended.

```
-Alpine.data('hyvaExpandSavedAddress', () => ({}))
+Alpine.data('hyvaExpandSavedAddress', window['hyvaExpandSavedAddress'] = () => ({}))
```

This allowes customizing the function as described in [Overriding JavaScript](../patterns/overriding-js.html).

## Checkout: Move scripts to footer

This is for checkout modules only

Either `composer.json` requires `hyva-themes/magento2-hyva-checkout` or `etc/module.xml` depends on `Hyva_checkout`.

Magewire loads content dynamically, it is impossible to dynamically load scripts into a page.
For instance, previously, you would write your javascript in the same file as your component, which would be loaded via XHR and evaluated.

More on this topic

Read more on why scripts are loaded on the initial pageload in our checkout documentation
[Move scripts to the initially loaded page content](../../../hyva-checkout/devdocs/csp/csp-move-scripts-page-load.html)

Example: `page/awesome.phtml`

```
<div x-data="awesome">
</div>
<script>
    function awesome() {
        return {}
    }
</script>
```

Must be split into the component `page/awesome.phtml`

```
<div x-data="awesome">
</div>
```

and script `page/awesome-csp-js.phtml`

```
<script>
    function awesome() {
        return {}
    }
</script>
```

and add or update the `layout/hyva_checkout.xml`

```
<!-- .... -->
<referenceContainer name="magewire.plugin.scripts">
    <block name="page.awesome"
           template="Awesome_Module::page/awesome-csp-js.phtml"
    />
</referenceContainer>
<!-- .... -->
```

### Inline variables

This will always result in a @TODO, we will move the script unmodified and add a AlpineJS component will be added to help with migration.

Example: `page/with-php.phtml`

```
?>
<script>
window.addEventListener('blah', () => {
    <?= $escaper->escapeJs($variable->doSomething()) ?>)
})
</script>
```

Migrated to `page/with-php.phtml`

```
<div x-data="PageWithPhp">
<?php /** Moved variables previously here to "page/with-php-csp-js.phtml" */ ?>
<?php /** References ($variable->doSomething()) */ ?>
</div>
```

And `page/with-php-csp-js.phtml`

```
<script>
window.addEventListener('blah', () => {
    <?= $escaper->escapeJs($variable->doSomething()) ?>)
})
</script>
<script>
function PageWithPhp() {
    const el = this.$el,
          wire = this.$wire;

    // @todo Implement interaction with the original code ^^
<?php /** Variables from "page/with-php.phtml" */ ?>
<?php /** References ($variable->doSomething()) */ ?>

    return {
        init() {}
    }
}
window.addEventListener('alpine:init', () => Alpine.data('PageWithPhp', PageWithPhp), {once: true});
</script>
```

## Register Inline Scripts

Make sure each script is registered and added with the correct CSP header. Add `<?php $hyvaCsp->registerInlineScript() ?>` after the script closing will handle this for each script. Make sure to test if only trusted scripts are added.

```
-</script>
+</script>
+<?php $hyvaCsp->registerInlineScript() ?>
```
