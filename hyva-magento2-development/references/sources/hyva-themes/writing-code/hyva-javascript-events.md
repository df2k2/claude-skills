<!-- source: https://docs.hyva.io/hyva-themes/writing-code/hyva-javascript-events.html -->

# Hyvä JavaScript Events

Events are used a lot in Hyvä. That is how decoupled components on a page communicate state changes with each other.

Event/Subscriber is a really useful pattern, because it helps to create decoupled and extensible components.

The following list of events is not complete. It only contains the most commonly used events.

## private-content-loaded

In contrast to how luma works, Hyvä always loads all customer section data together. It is loaded as a single data structure, and then - when the data is available - the event `private-content-loaded` is dispatched.

All components that require section data subscribe to this event.

A subscription can be made either using native JavaScript

```
window.addEventListener('private-content-loaded', event => myFunc(event.detail.data));
```

or using Alpine.js.

```
<div @private-content-loaded.window="prop=event.detail.data.sectionname" />
```

All section data is available in the `event.detail.data` object.
The object keys are the section names.

Important

Hyvä **does not** use Knockout.js, so the section data is **not** made of Knockout.js observables.
Changes to section data are propagated only through the `private-content-loaded` event.

## reload-customer-section-data

Components can dispatch this event to reload the customer section data. There is no automatic section invalidation or reload like in Luma.

Even though this at first might seem like a missing feature, it actually helps to make code a lot simpler and (easier to debug).

```
window.dispatchEvent(new Event('reload-customer-section-data'));
```

To invalidate existing private content section data without immediately reloading it, use

```
const browserStorage = hyva.getBrowserStorage();
if (browserStorage) {
    browserStorage.removeItem('mage-cache-storage');
}
```

More information can be found on the page [Working with sectionData](working-with-sectiondata.html).

## toggle-mobile-menu

On small devices, the top navigation menu overlays the full page.

Components can dispatch this event to show and hide the menu overlay. On larger displays this event has no visible effect.

```
window.dispatchEvent(new Event('toggle-mobile-menu'));
```

## toggle-authentication

This event triggers the Hyvä equivalent of the Luma authentication popup.
The effect this event has depends on

- whether the customer is logged in and
- if guest checkout is enabled or not

If guest checkout is allowed, or the customer is logged in, the `trigger-authentication` event redirects the customer to the checkout page.

If the customer is not logged in, and guest checkout is disabled, the event opens the authentication slider.
If the authentication slider already is open, further toggle-authentication events do not hide the slider again.

```
window.dispatchEvent(new Event('toggle-authentication'));
```

After the customer logs in with the authentication slider form, they are redirected to the checkout page.
It is possible to supply an alternative URL as the redirect target by setting detail.url on the event argument:

```
window.dispatchEvent(new CustomEvent('toggle-authentication', {detail: {url: '/'}}));
```

## toggle-cart

Components can dispatch this event to show the mini-cart.
Once the mini-cart is visible, consecutive toggle-cart events do not hide the mini-cart again.

```
window.dispatchEvent(new Event('toggle-cart')); // open mini-cart drawer
```

Since Hyvä 1.3.0 it is possible to close the mini-cart by adding `{isOpen: false}` to the payload:

Available since Hyvä 1.3.0

```
window.dispatchEvent(new CustomEvent('toggle-cart', {detail: {isOpen: false}}));
```

Please note this event would still open the mini-cart in earlier versions of Hyvä.

## clear-messages

Clears all splash messages rendered by the message component.

Available since Hyvä 1.1.2

```
window.dispatchEvent(new Event('clear-messages'))
```

There is no payload.

## configurable-selection-changed

Available since Hyvä 1.1.4

This event is dispatched whenever a configurable product option is selected on a product detail page.
The event payload is

```
{
  productId: (string) the configurable productId,
  optionId: (string) the newly selected optionId,
  value: (string) the newly selected option value,
  productIndex: (string) productId of the simple product used to display the image,
  selectedValues: (array) map of selected optionIds to option values,
  candidates: (array) productIds matching the current selection,
}
```

If there is only one product ID in the `candidates` array, all required options have been selected.
If there are multiple candidates, the selection is incomplete.

This event can be observed to update parts of the page whenever a configurable product option is selected.

## listing-configurable-selection-changed

Available since Hyvä 1.2.4

This event is dispatched whenever a configurable product option is selected on a product listing page.
The event payload is

```
{
  productId: (string) the configurable productId,
  optionId: (string) the newly selected optionId,
  value: (string) the newly selected option value,
  productIndex: (string) productId of the simple product used to display the image,
  selectedValues: (array) map of selected optionIds to option values,
  candidates: (array) productIds matching the current selection,
}
```

If there is only one product ID in the `candidates` array, all required options have been selected.
If there are multiple candidates, the selection is incomplete.

This event can be observed to update parts of the page whenever a configurable product option is selected.

## update-product-final-price

This event is only relevant on product detail pages.
It is dispatched when a visitor selects product options that influence the product price.

The product options component observes the event, and recalculates option price changes accordingly.
Components that need access to the current final price can also observe this event.

```
<input @update-product-final-price.window="recalculateWithFinalPrice(event.detail)">
```

## update-prices-= (int)$product-getId() ?>

This event is only relevant on product detail pages and product listing pages.

It is dispatched when a visitor selects product options that select a different associated simple product.

The products price is updated accordingly.

On product detail pages the values are given using the keys `oldPrice` and `finalPrice` if the price is including tax, and `baseOldPrice` and `basePrice` if the price is displayed excluding tax.

On product listing pages such as categories, the keys always are `finalPrice` and `oldPrice`.

For example:

```
window.dispatchEvent(
  new CustomEvent(
    'update-prices-68',
    {
      detail: {
        tierPrices: [],
        basePrice: {amount: 5},
        baseOldPrice: {amount: 15}
      }
    }
  )
)
```

On a product detail page of a product with the ID 68 this will update the displayed price to 5 in whatever the current currency is.

Note: if no tier prices are set for a product, the `tierPrices` key still has to be set to an empty array on the event payload as shown in the example above.

More information on product price logic can be found on the [PDP price logic](pdp-pricing-logic.html) page.

## update-qty-= (int)$product-getId() ?>

This event is only relevant on product detail pages.

It is dispatched, whenever the quantity for the add-to-cart input changes. The new quantity is passed in `event.detail`.

The product detail page observes this event, and recalculates the products final price accordingly.

Components that also need the quantity field value can observe the event:

```
const eventName = 'update-qty-<?= (int)$product->getId() ?>';
window.addEventListener(eventName, event => this.currentQty = event.detail);
```

## update-gallery

The `update-gallery` event is only relevant on product detail pages.
It is dispatched to change the images in the product gallery.

The event payload contains an array with objects describing the new images to display.
Those image objects in the event.detail array have the following structure:

```
{
    thumb: "https://...small image url",
    img: "https://...medium image url",
    full: "https://...large image url",
    caption: "the image label",
    position: 1,
    isMain: false,
    type: "image",    // or 'video',
    videoUrl: null    // or 'https://…youtube or vimeo video url'
}
```

Components can dispatch the `update-gallery` event to update the visible product images, or observe the event to be able to react to image changes.

To revert the gallery to the initial records, dispatch the event with an empty images array:

```
window.dispatchEvent(new CustomEvent('update-gallery', {detail: []}));
```
