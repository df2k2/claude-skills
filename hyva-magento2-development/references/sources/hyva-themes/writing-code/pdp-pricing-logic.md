<!-- source: https://docs.hyva.io/hyva-themes/writing-code/pdp-pricing-logic.html -->

# PDP Pricing logic

Pricing logic mainly happens in:

`[NAMESPACE]/[THEMENAME]/Magento_Catalog/templates/product/view/price.phtml`

Product page logic happens in steps. We check for an available prices in this order:

- `calculatedFinalPriceWithCustomOptions`
- `calculatedFinalPrice`
- `initialFinalPrice`

Calculation of the price happens in opposite order

- `initialFinalPrice` is the server-side rendered final price.
- `calculatedFinalPrice` is calculated when a configurable option is selected or qty changes
- `calculatedFinalPriceWithCustomOptions` is calculated when custom-option prices are available and selected

The definitive displayed final price is then output using:

```
getFormattedFinalPrice() {
    return this.formatPrice(
        this.calculatedFinalPriceWithCustomOptions ||
        this.calculatedFinalPrice ||
        this.initialFinalPrice
    )
}
```

## Events:

The price box listens for the following events:

- `update-prices-[product-id]`
- `update-qty-[product-id]`
- `update-custom-option-active`
- `update-custom-option-prices`

### `update-prices-[product-id]` event

Receives an object with prices for selected configurable product:

```
activeProductsPriceData: {
    oldPrice: {
        amount: 75
    },
    basePrice: {
        amount: 50
    },
    finalPrice: {
        amount: 50
    },
    tierPrices: [{
        qty: 4
        price: 40
        percentage: 20
    },
    msrpPrice: {
        amount: null
    }
}
```

Then it triggers `calculateFinalPrice()` which calculates the new `calculatedFinalPrice` by looking at the lowest available price.

Then finally `calculateFinalPriceWithCustomOptions()` is called which calculates the new `calculatedFinalPriceWithCustomOptions`

### `update-qty-[product-id]` event

Updates the selected quantity value as `qty`, then recalculates `calculateFinalPrice()` followed by `calculateFinalPriceWithCustomOptions()`

### `update-custom-option-active` event

Updates an array that tracks active custom-options by option-id by calling `updateCustomOptionActive()`.

In case the custom-option has multiple fields (select, radio, checkbox) it tracks the ids as `[parent_child]` for example:

```
activeCustomOptions: ['1', '3_1', '3_2']
```

### `update-custom-option-prices` event

Updates an array of option prices for custom options by calling `updateCustomOptionPrices()`.

It tracks the prices of custom-options by option-id. Here too, child-options are tracked as `[parent_child]` for example:

```
customOptionPrices: {
    "1": "10.000000",
    "2": "5.000000",
    "3_1": "10.000000",
    "3_2": "15.000000",
    "3_3": "20.000000"
}
```

## Custom options

Custom-option price logic lives in `[NAMESPACE]/[THEMENAME]/Magento_Catalog/templates/product/view/options/options.phtml`

It listens to the event `update-product-final-price` which is fired in `[NAMESPACE]/[THEMENAME]/Magento_Catalog/templates/product/view/price.html` and calls `calculateOptionPrices()`

On initialization `calculateOptionPrices()` is also called (using `$nextTick` so that we’re sure all Alpine components and their event-listeners are loaded).

The method `calculateOptionPrices()` loops through the object `optionConfig` that is a server-side rendered object containing the initial custom-options configuration:

```
  optionConfig: {
    2: {
      prices: {
        oldPrice: { amount: -25, adjustments: [] },
        basePrice: { amount: -25 },
        finalPrice: { amount: -25 },
      },
      type: "fixed",
      name: "Custom print",
    },
    3: {
      1: {
        prices: {
          oldPrice: { amount: 5, adjustments: [] },
          basePrice: { amount: 5 },
          finalPrice: { amount: 5 },
        },
        type: "fixed",
        name: "wrap as gift",
      },
      2: {
        prices: {
          oldPrice: { amount: -5, adjustments: [] },
          basePrice: { amount: -5 },
          finalPrice: { amount: -5 },
        },
        type: "fixed",
        name: "don't wrap",
      },
    },
    9: {
      prices: {
        oldPrice: { amount: 5, adjustments: [] },
        basePrice: { amount: 5 },
        finalPrice: { amount: 5 },
      },
      type: "fixed",
      name: "file",
    },
  }
```

Prices from `optionConfig` are returned if there is no `productFinalPrice` that came from the `price` component. In case `productFinalPrice` has been set by the `update-product-final-price` event, prices need to be recalculated which happens by looping through the custom-options inside the component and retrieving their prices through data-set entries.

Example custom-option element:

```
<input type="text"
       id="options_2_text"
       ...
       data-price-amount="-25.000000"
       data-price-type="fixed"
       x-ref="option-2"
       x-on:input="updateCustomOptionValue($dispatch, '2', $event.target)"
>
```

Price calculation then happens as:

```
calculateOptionPrice: function calculateOptionPrice(
  customOption,
  customOptionId,
  childCustomOptionId
) {
  const customOptionCode =
    customOptionId + (childCustomOptionId ? "-" + childCustomOptionId : "");

  const optionElement = this.refs && this.refs["option-" + customOptionCode];

  let price = customOption.prices.finalPrice.amount;

  if (
    this.productFinalPrice &&
    optionElement &&
    optionElement.dataset.priceAmount &&
    optionElement.dataset.priceType
  ) {
    price =
      optionElement.dataset.priceType !== "percent"
        ? optionElement.dataset.priceAmount
        : this.productFinalPrice * (optionElement.dataset.priceAmount / 100);
  }

  return price;
}
```

When all prices have been updated, we trigger `update-custom-option-prices` which sends the prices to the main `price` component.
