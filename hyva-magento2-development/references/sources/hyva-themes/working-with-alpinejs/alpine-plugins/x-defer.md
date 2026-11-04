<!-- source: https://docs.hyva.io/hyva-themes/working-with-alpinejs/alpine-plugins/x-defer.html -->

# The Alpine.js x-defer plugin

Available since Hyvä 1.3.7

The `x-defer` directive is a custom Hyvä Alpine.js plugin that allows deferring the initialization of Alpine components.
The attribute is placed on the same element that also holds the `x-data` directive.
The value determines when the component will be initialized.
Possible values are:

- `intersect`
- `interact`
- `idle`
- `event:eventname`

Deferring the initialization of components that are not needed immediately can increase the interactivity of a page and reduce the main thread blocking time.
Used correctly it will improve the core web vitals score.

The type of trigger to choose depends on the component.

## What components can be deferred?

Depending on when a component is initialized, some common events may be missed, since event subscribers won't be called until the component is initialized.
The most common scenario is components requiring access to the customer section data missing the `private-content-loaded` event.

A possible workaround is to dispatch the `reload-customer-section-data` event in the components init method.
This will cause the `private-content-loaded` event to be dispatched again, and this time the component is able to receive it.

For example:

```
<div
    x-data="{cart: null}"
    x-defer="intersect"
    x-init="$dispatch('reload-customer-section-data')"
    @private-content-loaded="cart = $event.details.data.cart"
>
```

## Values for x-defer

### `x-defer="intersect"`

This is the most common `x-defer` type. It will hold off initializing a component until it enters the viewport.
If it is in the viewport at the time the page loads, it will be initialized immediately.

```
<div x-data x-defer="intersect">
    <span x-text="`This component is initialized when it enters the viewport.`"></span>
</div>
```

### `x-defer="interact"`

This x-defer value will initialize a component as soon as a user interacts with the page, that is, one of the `touchstart`, `mouseover`, `wheel`, `scroll`, or `keydown` events is dispatched.

```
<div x-data x-defer="interact">
    <span x-text="`This component is initialized on user interaction.`"></span>
</div>
```

### `x-defer="idle"`

The component will be initialized at the convenience of the browser via `window.requestIdleCallback`.
A timeout can be set in the system configuration after which the component will be initialized in case the browser does not trigger the callback.
This setting can be found at *Hyvä Themes > General > Deferred Alpine.js Components > Defer until idle timeout*
The default timeout is 4000ms.

```
<div x-data x-defer="idle">
    <span x-text="`This component is initialized when the browser is idle or after 4s.`"></span>
</div>
```

### `x-defer="event:eventname"`

By specifying an `event:` prefix, component initialization can be deferred until arbitrary events.
The event is observed on the `window` object.

```
<div x-data x-defer="event:toggle-cart">
    <span x-text="`This component is initialized when the toggle-cart event is dispatched.`"></span>
</div>
```

## Configurable component defer rules

The `x-defer` attribute can be added to .phtml templates directly, or it can be injected into the page through JavaScript.

These rules can be specified through layout XML and through the backend system configuration.

### Injecting x-defer rules with layout XML

Defer rules can be configured in layout XML by specifying the items in the `deferred_components` array argument to the `alpine-defer-rules` block.

```
<referenceBlock name="alpine-defer-rules">
  <arguments>
    <argument name="deferred_components" xsi:type="array">
      <item name=".product-slider > div > section[x-data]" xsi:type="string">intersect</item>
    </argument>
  </arguments>
</referenceBlock>
```

The item keys are used as selectors with `document.querySelectorAll`, and the values will be set as the `x-defer` attribute value.
At the time of writing, there are no default rules configured in layout XML.

### Injecting x-defer rules through backend configuration

To improve core web vitals of existing custom themes with minimal effort, the most useful defer rules are automatically injected into components based on configurable selectors specified in the system configuration found at
*Hyvä Themes > General > Deferred Alpine.js Components > Defer components*

At the time of writing, the `x-defer` attribute default configuration specifies the following selectors:

- `.product-slider section[x-data]`
  This defers product sliders like the ones on the default homepage.
- `.product-info [x-data]`
  This matches all components in items on product listings
- `#filters-content [x-data]`
  This matches all layered navigation filter components
- `#review_form`
  This matches the product review form on the product detail pages
- `section[x-data^=initRecentlyViewedProductsComponent]`
  This matches the recently viewed products widget
- `div[x-data^=initBundleOptions]`
  This defers bundled product option components
- `#product_addtocart_form [x-data]`
  This defers swatches and options on product detail pages
- `#notice-cookie-block`
  This matches the cookie notice

Tip

Since 1.3.7 the `hyva-themes/magento2-default-theme` already contains all `x-defer` attributes in .phtml templates.
The default x-defer injection rules are superfluous. They only serve a purpose when used with a theme based on older releases.

When creating a new custom theme based on the default-theme 1.3.7 or newer, the default backend x-defer rules can be removed.
This can help to reduce the TBT even further.

### Disabling defer rules injection

To disable the `x-defer` injection in a theme completely, remove the `alpine-defer-rules` block with layout XML.

```
<referenceBlock name="alpine-defer-rules" remove="true"/>
```
