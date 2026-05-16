# Frontend JavaScript and UI Components (Luma stack)

Magento's classic frontend JS layer is built on **RequireJS** (AMD module loader), **jQuery** + jQuery UI widgets, **Knockout.js** for templating/binding, and **UI components** (a Magento abstraction layering JSON config + Knockout templates + jQuery widgets). It's complex and idiosyncratic. This file covers the patterns you'll actually encounter.

If the store uses Hyvä, none of this applies on the storefront — Hyvä replaces the entire stack with Alpine.js + Tailwind. Defer to the `hyva-magento2-development` skill. Backend/admin still uses this stack regardless.

## The four ways JS gets loaded

### 1. `<script src=...>` in layout XML
```xml
<head>
    <script src="Acme_Hello::js/manual-script.js"/>
</head>
```
Plain non-AMD script tag. Avoid unless integrating a third-party widget. Magento strongly prefers AMD/RequireJS.

### 2. `<script type="text/x-magento-init">` in templates
```php
<div id="my-widget" data-mage-init='{"acme/hello": {"option": "value"}}'>
    ...
</div>
```
Or the standalone form:
```html
<script type="text/x-magento-init">
{
    "#my-widget": {
        "acme/hello": {
            "option": "value"
        }
    }
}
</script>
```
At page load, Magento's `mage/apply/main` walks these and calls the named module/widget on each selector. The module must be defined as a jQuery widget or via `Magento_Ui/js/lib/core/component`.

For "apply this to body" / "no selector":
```html
<script type="text/x-magento-init">
{
    "*": {
        "Magento_Ui/js/core/app": { ... config ... }
    }
}
</script>
```

### 3. RequireJS `define`/`require` blocks
```js
define([
    'jquery',
    'mage/translate',
    'Magento_Customer/js/customer-data'
], function ($, $t, customerData) {
    'use strict';
    return function (config) {
        // ...
    };
});
```
Each `.js` file under `web/js/` is a RequireJS AMD module. They're loaded on-demand when something `require`s them.

### 4. UI components (the JSON config tree)
For complex admin grids/forms and storefront checkout flows. Covered in detail below.

## requirejs-config.js merging

Each module and theme can ship a `requirejs-config.js`. Magento merges them all into one config served at `/static/<area>/<theme>/<locale>/requirejs/require.js`. Locations:

```
vendor/magento/module-customer/view/frontend/requirejs-config.js
app/design/frontend/Acme/storefront/Magento_Customer/requirejs-config.js
app/design/frontend/Acme/storefront/requirejs-config.js   ← theme root
```

Each defines a `var config = { ... }`:

```js
var config = {
    map: {
        '*': {
            // Replace a known module with your own
            'Magento_Checkout/js/view/cart/totals': 'Acme_Theme/js/view/cart/totals'
        }
    },
    paths: {
        // Custom alias
        'acme/hello': 'Acme_Theme/js/hello'
    },
    shim: {
        // Non-AMD module declaring deps
        'legacy-script': {
            deps: ['jquery'],
            exports: 'LegacyGlobal'
        }
    },
    deps: [
        // Always load
        'Acme_Theme/js/always-load'
    ],
    config: {
        mixins: {
            // The mixin pattern — see below
            'Magento_Checkout/js/view/payment': {
                'Acme_Theme/js/mixin/payment-mixin': true
            }
        }
    }
};
```

After editing: `bin/magento cache:clean config` and clear browser cache. In production, `setup:static-content:deploy -f` rebuilds the merged file.

## Mixins — the "extend without forking" pattern

Mixins let you wrap or add to another module's RequireJS module without overriding it.

Declare in `requirejs-config.js`:
```js
var config = {
    config: {
        mixins: {
            'Magento_Checkout/js/view/summary/cart-items': {
                'Acme_Theme/js/mixin/cart-items-mixin': true
            }
        }
    }
};
```

Implement at `app/design/frontend/Acme/storefront/Acme_Theme/web/js/mixin/cart-items-mixin.js`:
```js
define([], function () {
    'use strict';
    return function (Component) {  // <- receives the original module
        return Component.extend({
            // Override or add methods
            displayCartItems: function () {
                console.log('cart-items mixed in');
                return this._super();   // call the original
            }
        });
    };
});
```

The mixin function receives the original module's export and returns a wrapped/extended version. For UI components (Knockout view models), `Component.extend({})` produces a subclass. For plain functions, you wrap and return.

**Mixin gotchas**:
- If the target isn't a `Component` (e.g., it's a plain object literal), `Component.extend` doesn't exist. Adapt accordingly.
- The cache (`config_webservice`, `view_preprocessed`) MUST be cleared after declaring a new mixin. In production, run `setup:static-content:deploy -f`.
- Mixins on `Magento_Customer/js/customer-data` etc. require the right load order — declare in a module sequenced after `Magento_Customer`.

## customer-data and section data

`Magento_Customer/js/customer-data` is the storefront's customer-section data manager. It's the system behind the minicart, customer welcome, compare lists — anything that needs per-customer data on a cached page. The pattern:

1. Backend declares sections in `etc/frontend/sections.xml` with the actions that invalidate them.
2. Customer-data subscribes to those sections; the browser stores the latest copy in `localStorage`.
3. When an action runs (e.g. add to cart), the response sets a cookie `section_data_ids`. The customer-data JS sees the cookie has new section IDs and re-fetches the listed sections from `/customer/section/load/`.
4. Bound Knockout view models update automatically.

To read in JS:
```js
define(['Magento_Customer/js/customer-data'], function (customerData) {
    var cart = customerData.get('cart');   // KO observable
    cart.subscribe(function (newCart) {
        // ...
    });
    // To force reload:
    customerData.reload(['cart'], false);
    // To invalidate (re-fetch on next request):
    customerData.invalidate(['cart']);
});
```

To add a custom section, see `etc/frontend/sections.xml`:
```xml
<config>
    <action name="customer/account/save">
        <section name="customer"/>
        <section name="acme-loyalty"/>
    </action>
</config>
```

And declare the section provider in `di.xml`:
```xml
<type name="Magento\Customer\CustomerData\SectionPoolInterface">
    <arguments>
        <argument name="sectionSourceMap" xsi:type="array">
            <item name="acme-loyalty" xsi:type="string">Acme\Loyalty\CustomerData\LoyaltyStatus</item>
        </argument>
    </arguments>
</type>
```

The class must implement `\Magento\Customer\CustomerData\SectionSourceInterface`:
```php
public function getSectionData(): array
{
    return ['points' => $this->getCurrentPoints()];
}
```

## UI Components — the Magento_Ui beast

A UI component is a JSON declaration of a Knockout view-model tree, plus optional PHP DataProviders backing it, with a strong convention-based rendering pipeline. Used heavily in admin (every grid, form, listing) and to some extent on the storefront (checkout).

### Anatomy of an admin UI component

```
view/adminhtml/ui_component/acme_hello_listing.xml      ← grid component
view/adminhtml/ui_component/acme_hello_form.xml         ← form component
view/adminhtml/layout/acme_hello_index_index.xml        ← layout that references the component
view/adminhtml/templates/...                             ← (rarely used; UI components have Knockout templates)
```

#### Layout file
```xml
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="content">
            <uiComponent name="acme_hello_listing"/>
        </referenceContainer>
    </body>
</page>
```

#### Listing component (grid)
```xml
<?xml version="1.0"?>
<listing xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Ui:etc/ui_configuration.xsd">
    <argument name="data" xsi:type="array">
        <item name="js_config" xsi:type="array">
            <item name="provider" xsi:type="string">acme_hello_listing.acme_hello_listing_data_source</item>
        </item>
    </argument>
    <settings>
        <spinner>acme_hello_columns</spinner>
        <deps>
            <dep>acme_hello_listing.acme_hello_listing_data_source</dep>
        </deps>
    </settings>
    <dataSource name="acme_hello_listing_data_source" component="Magento_Ui/js/grid/provider">
        <settings>
            <updateUrl path="mui/index/render"/>
            <storageConfig>
                <param name="indexField" xsi:type="string">id</param>
            </storageConfig>
        </settings>
        <aclResource>Acme_Hello::hello</aclResource>
        <dataProvider class="Magento\Framework\View\Element\UiComponent\DataProvider\DataProvider" name="acme_hello_listing_data_source">
            <settings>
                <requestFieldName>id</requestFieldName>
                <primaryFieldName>id</primaryFieldName>
            </settings>
        </dataProvider>
    </dataSource>
    <listingToolbar name="listing_top">
        <bookmark name="bookmarks"/>
        <columnsControls name="columns_controls"/>
        <filterSearch name="fulltext"/>
        <filters name="listing_filters"/>
        <paging name="listing_paging"/>
    </listingToolbar>
    <columns name="acme_hello_columns">
        <selectionsColumn name="ids">
            <settings>
                <indexField>id</indexField>
            </settings>
        </selectionsColumn>
        <column name="id">
            <settings>
                <filter>textRange</filter>
                <sorting>asc</sorting>
                <label translate="true">ID</label>
            </settings>
        </column>
        <column name="name">
            <settings>
                <filter>text</filter>
                <label translate="true">Name</label>
                <editor>
                    <editorType>text</editorType>
                </editor>
            </settings>
        </column>
        <actionsColumn name="actions" class="Acme\Hello\Ui\Component\Listing\Column\Actions">
            <settings>
                <indexField>id</indexField>
            </settings>
        </actionsColumn>
    </columns>
</listing>
```

The `dataProvider` references a collection registered in `etc/di.xml`:
```xml
<type name="Magento\Framework\View\Element\UiComponent\DataProvider\CollectionFactory">
    <arguments>
        <argument name="collections" xsi:type="array">
            <item name="acme_hello_listing_data_source" xsi:type="string">
                Acme\Hello\Model\ResourceModel\Hello\Grid\Collection
            </item>
        </argument>
    </arguments>
</type>
```

That collection extends `\Magento\Framework\View\Element\UiComponent\DataProvider\SearchResult` and wires up your model's table.

#### Form component
```xml
<?xml version="1.0"?>
<form xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Ui:etc/ui_configuration.xsd">
    <argument name="data" xsi:type="array">
        <item name="js_config" xsi:type="array">
            <item name="provider" xsi:type="string">acme_hello_form.acme_hello_form_data_source</item>
        </item>
        <item name="label" xsi:type="string" translate="true">Hello Item</item>
    </argument>
    <settings>
        <buttons>
            <button name="save" class="Acme\Hello\Block\Adminhtml\Edit\SaveButton"/>
            <button name="delete" class="Acme\Hello\Block\Adminhtml\Edit\DeleteButton"/>
        </buttons>
        <namespace>acme_hello_form</namespace>
        <dataScope>data</dataScope>
        <deps>
            <dep>acme_hello_form.acme_hello_form_data_source</dep>
        </deps>
    </settings>
    <dataSource name="acme_hello_form_data_source">
        <argument name="data" xsi:type="array">
            <item name="js_config" xsi:type="array">
                <item name="component" xsi:type="string">Magento_Ui/js/form/provider</item>
            </item>
        </argument>
        <settings>
            <submitUrl path="*/*/save"/>
        </settings>
        <dataProvider class="Acme\Hello\Model\Hello\DataProvider" name="acme_hello_form_data_source">
            <settings>
                <requestFieldName>id</requestFieldName>
                <primaryFieldName>id</primaryFieldName>
            </settings>
        </dataProvider>
    </dataSource>
    <fieldset name="general">
        <settings>
            <label translate="true">General</label>
        </settings>
        <field name="name" formElement="input">
            <settings>
                <validation>
                    <rule name="required-entry" xsi:type="boolean">true</rule>
                </validation>
                <label translate="true">Name</label>
                <dataScope>name</dataScope>
            </settings>
        </field>
        <field name="is_active" formElement="checkbox">
            <settings>
                <dataType>boolean</dataType>
                <dataScope>is_active</dataScope>
                <label translate="true">Active</label>
            </settings>
            <formElements>
                <checkbox>
                    <settings>
                        <valueMap>
                            <map name="false" xsi:type="number">0</map>
                            <map name="true" xsi:type="number">1</map>
                        </valueMap>
                    </settings>
                </checkbox>
            </formElements>
        </field>
    </fieldset>
</form>
```

The DataProvider returns the row data and metadata; the form binds it via Knockout. See `references/admin-area.md` for the full grid+form pattern.

## Knockout templates

UI components reference Knockout HTML templates from a JS component or KO `template` binding. The HTML template files live at `view/<area>/web/template/<some>.html` and are pulled by RequireJS via the `text!` plugin:

```html
<!-- view/frontend/web/template/cart/item/default.html -->
<div class="cart-item" data-bind="attr: {id: 'product-' + product_id}">
    <span data-bind="text: product_name"></span>
    <span data-bind="text: getFormattedPrice()"></span>
</div>
```

```js
define(['Magento_Checkout/js/view/cart/item/default'], function (Default) {
    return Default.extend({
        defaults: {
            template: 'Magento_Checkout/cart/item/default'   // resolves to <module>/web/template/cart/item/default.html
        },
        getFormattedPrice: function () {
            return '$' + (this.price() / 100).toFixed(2);
        }
    });
});
```

Common KO bindings used in Magento: `text`, `html`, `attr`, `css`, `visible`, `if`, `foreach`, `with`, `template`, `event` (`click`), `submit`, `value`, `checked`, `enable`. Plus Magento extensions: `i18n` (translation), `mageInit` (apply a Magento JS widget), `priceBox` (price display).

## jQuery widgets

Magento ships a jQuery widget framework for legacy components. To declare:
```js
define(['jquery', 'jquery/ui'], function ($) {
    'use strict';
    $.widget('mage.acmeHello', {
        options: { greeting: 'Hi' },
        _create: function () {
            this.element.html(this.options.greeting);
        }
    });
    return $.mage.acmeHello;
});
```

Then init via `data-mage-init`:
```html
<div data-mage-init='{"acmeHello": {"greeting": "Hello"}}'></div>
```

Or via `<script type="text/x-magento-init">`:
```html
<script type="text/x-magento-init">
{ "#my-el": { "acme/hello-widget": { "greeting": "Hello" } } }
</script>
```

jQuery widgets are being phased out in favor of UI components on the frontend, but the cart, checkout, and many admin features still use them.

## Common storefront JS patterns

### Validate a form
```js
define(['jquery', 'mage/validation'], function ($) {
    $('#my-form').validation();
    if ($('#my-form').validation('isValid')) {
        // submit
    }
});
```

### Show a confirmation modal
```js
define(['Magento_Ui/js/modal/confirm'], function (confirm) {
    confirm({
        title: 'Are you sure?',
        content: 'This cannot be undone.',
        actions: {
            confirm: function () { /* yes */ },
            cancel: function () { /* no */ }
        }
    });
});
```

### Ajax form post
```js
define(['jquery', 'Magento_Customer/js/customer-data'], function ($, customerData) {
    $.ajax({
        url: '/customer/account/editPost',
        type: 'POST',
        dataType: 'json',
        data: $('#form').serialize(),
        success: function (response) {
            customerData.invalidate(['customer']);
        }
    });
});
```

### Trigger price-box update
Magento dispatches `prices_changed` etc. on `priceBox` widgets. Inspect `vendor/magento/module-catalog/view/frontend/web/js/price-box.js` for the events.

## Bundling and minification

In production, Magento can bundle all JS modules into a single download to reduce HTTP requests. Configure in **Stores → Configuration → Advanced → Developer → JavaScript Settings**:
- Enable JavaScript Bundling: Yes
- Minify JavaScript Files: Yes

Then `setup:static-content:deploy -f` produces `pub/static/.../js/bundle/bundle*.js`. The bundle is divided per `view.xml` `<bundle_size>` setting.

**Bundling is often turned off** for real-world Magento sites because the bundles are big (Magento 2's JS surface is large) and HTTP/2 makes per-file requests cheap. Many sites use Webpack/Vite outside the standard pipeline instead. Hyvä eliminates the issue by replacing the stack entirely.

## Common gotchas

### "X is not defined" / module loads twice
Two RequireJS modules registered the same alias in `paths` — last write wins, but the order isn't deterministic. Audit `requirejs-config.js` for collisions.

### Mixin doesn't fire
- Wrong key spelling in `mixins:` — must EXACTLY match the module being targeted.
- Missing `cache:clean config` after declaring the mixin.
- `setup:static-content:deploy` not run in production.

### "JS error: customer-data is not a function"
You called `customerData('cart')` instead of `customerData.get('cart')`. Read the API; it's an object with methods, not a function.

### Knockout binding silently does nothing
The binding name is misspelled (`vissible` instead of `visible`), or the property isn't a KO observable (`this.foo()` requires `foo` to be `ko.observable`).

### Section data isn't refreshing
- The `sections.xml` action doesn't match the URL of the request you're trying to invalidate after.
- `cache:clean config` not run.
- Browser still has stale localStorage. Hard-refresh or clear storage.

### `<script type="text/x-magento-init">` JSON is invalid
Magento parses it strictly. Trailing commas, unquoted keys, single quotes for strings — all break it silently. Validate JSON.

### "Cannot read property 'extend' of undefined" in mixin
The mixin receives `undefined` because the target file doesn't actually export a component constructor — it exports a function or object. Adapt the mixin signature.

## Original sources

- `references/sources/commerce-frontend-core/javascript/` — JS development.
- `references/sources/commerce-frontend-core/ui-components/` — UI components.
- `references/sources/commerce-frontend-core/javascript/custom_js.md` — custom JS.
- `references/sources/devdocs-v2.4/javascript-dev-guide/` — older JS guide (more depth).
- `references/sources/devdocs-v2.4/ui_comp_guide/` — older UI components guide.
- `references/sources/commerce-frontend-core/javascript/js_mixins.md` — mixins.
