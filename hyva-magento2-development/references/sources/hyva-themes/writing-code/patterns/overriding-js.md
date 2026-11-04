<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/overriding-js.html -->

# Overriding JavaScript

The most straightforward approach to customizing JavaScript in Hyvä is to copy the .phtml template into a custom theme and change the code as needed.
This works, but if the code in the original file changes in a newer Hyvä release, the change will be masked by the template override in the child theme.

Merging changes in JavaScript into overridden templates can be cumbersome and make upgrades more expensive.

There is a better way to customize JavaScript, that allows changes in the default theme to automatically apply to child themes.

The approach is based on the JavaScript language feature allowing functions, methods, and object properties to be redeclared.

Instead of overriding all JavaScript in a template file, it is possible to only override the functions or properties that need to be changed.

To do so, a new template is added to the page that is rendered **after** the original template containing the JavaScript code to be customized.

## Step by step

Follow this recipe when overriding

1. Determine the template containing the original JS
2. Find the layout XML block declaration for that JS
3. Declare a new block that will be rendered after the original
4. Create the new template and confirm it is rendered after the original
5. Override only the function or method that needs changes while keeping as much as possible of the code in the original file active

## Example 1: hyva.formatPrice

One relatively common customization target is the `hyva.formatPrice` method.
This method is declared in the template `src/view/frontend/templates/page/js/hyva.phtml` of the `hyva-themes/magento2-theme-module` module.
It contains many important core functions. Sometimes it is updated in new releases to include bug fixes or new features, so overriding the whole file makes upgrades more expensive.

In this example, we want to customize the method to return `FREE!` if the price is zero.

Price formatting: JS & PHP

Please note that in a real project, it would not be enough to customize only the JavaScript `hyva.formatPrice` function.
All prices are initially rendered by PHP using the `\Magento\Framework\Pricing\PriceCurrencyInterface::format` function.
Customizing the PHP method is outside the scope of this article.

### Inject the new template for the override

The block rendering the `hyva.phtml` template is declared in the `Hyva_Theme` module using the page layout XML file `default_hyva.xml`

```
<referenceContainer name="head.additional">
    <block name="head.hyva-scripts" template="Hyva_Theme::page/js/hyva.phtml"/>
</referenceContainer>
```

We can add our new override template anywhere on the page after the original template.
One possibility would be adding it as a new child of the `head.additional`:

In our theme, in `Hyva_Theme/layout/default.xml`, add:

```
<referenceContainer name="head.additional">
    <block name="head.hyva-scripts.format-price-customization"
           after="head.hyva-scripts"
           template="Hyva_Theme::page/js/format-price-customization.phtml"/>
</referenceContainer>
```

Alternatively the `before.body.end` container would work, too, since it also is rendered after the original template.

### Override the code

Then we create the new template and add a script tag.

We have added comments to the code below to explain noteworthy aspects of the customization.

```
<script>
  // To keep the global scope tidy, we wrap everything in an IIFE (Immediately Invoked Function Expression).
  //  Otherwise, all variables and constants we declare would be globally visible.
  (() => {
    // Keep a reference to the original method
    const origFormatPrice = hyva.formatPrice;

    // Redeclare the method we are customizing.
    //  By using the `function` keyword instead of an arrow function we
    //  have access to the magic `arguments` variable to capture new
    //  arguments possibly added in the future.
    hyva.formatPrice = function (value, showSign, options = {}) {

      // If the value is larger than zero, call the original method
      if (value > 0) {

        // Call the original method using apply() to ensure all
        //  arguments are passed along.
        return origFormatPrice.apply(this, arguments)
      }

      // Return custom  value if applicable
      return '<?= $escaper->escapeJs(__('FREE!')) ?>';
    }
  })()
</script>
```

### Notes on the example

#### Calling the original function

It is not always possible to customize a function and still delegate to the original function.
In some cases, the function needs to be completely replaced.
For `hyva.formatPrice` this would be the case if the numeric formatting itself should be changed.

#### Testing the customization

To test the customization, we can call `hyva.formatPrice(1)` and `hyva.formatPrice(0)` on the browser console.

## Example 2: Customize an Alpine component

The previous example customized a simple object method.
However, in Hyvä, many functions return objects to be used as Alpine components.
The names of these functions conventionally start with `init*` and are called within an `x-data` attribute.

```
<div x-data="initCompareOnCompareSidebar()">
    ...
</div>
```

They can be considered constructor functions for Alpine components.
Customizations may need to be applied to methods or properties of the components, so replacing only the constructor function is not sufficient.
Instead, the returned Alpine instance needs to be mutated as shown in this example.

### Auto-select single-option attributes

Out of the box, if a configurable product has only a single available option for a variant, customers still need to select it before being able to add the product to the cart.

For this example scenario, we are going to customize the configurable options Alpine.js component to automatically select every configurable attribute with only a single available option.

### Step 1: Inject the template for the override

The original template containing the JavaScript we need to customize is `Magento_ConfigurableProduct::product/view/type/options/js/configurable-options.phtml`.
The block for the template is declared in the default theme `Magento_ConfigurableProduct/layout/catalog_product_view_type_configurable.xml` with:

```
<referenceContainer name="before.body.end">
    <block name="product.info.options.configurable.js"
           as="options_configurable_js"
           template="Magento_ConfigurableProduct::product/view/type/options/js/configurable-options.phtml"
    />
</referenceContainer>
```

The override template needs to be rendered later on the page, so we declare it in our theme using the same layout file name. We make it a sibling of the original block by using the same container and add an `after` attribute to ensure it renders behind the original.

```
<referenceContainer name="before.body.end">
    <block name="product.info.options.configurable.js-auto-select-single-options"
           after="options_configurable_js"
           template="Magento_ConfigurableProduct::product/view/type/options/js/auto-select-single-options.phtml"
    />
</referenceContainer>
```

### Step 2: Override the code

Now we can create the `auto-select-single-options.phtml` and test it renders as desired.
We have added comments in the code example below to explain noteworthy aspects of the customization.

```
<script>
  // To keep the global scope tidy, we wrap everything in an IIFE (Immediately Invoked Function Expression).
  //  Otherwise, all variables and constants we declare would be globally visible.
  (() => {
    // Keep a reference to the original initConfigurableOptions method
    const origInitConfigurableOptions = initConfigurableOptions;

    // Redeclare the constructor function, so we can customize the return value
    //  By using the `function` keyword instead of an arrow function we
    //  have access to the magic `arguments` variable to capture new
    //  arguments possibly added in the future.
    window.initConfigurableOptions = function () {
      // Call the original method using apply() to ensure all
      //  arguments are passed along.
      const instance = origInitConfigurableOptions.apply(this, arguments)

      // Keep a reference to the original init method
      const origInit = instance.init;
      // Redeclare the method we are customizing
      instance.init = function () {

        // Call the original method, using `instance` as the object context
        origInit.apply(instance, arguments)

        // Add custom logic to auto-select single options
        for (const [attributeId, options] of Object.entries(instance.allowedAttributeOptions)) {
          if (options.length === 1) {
            instance.changeOption(attributeId, Object.values(options)[0].id)
          }
        }
      }

      // Return the modified component
      return instance;
    }
  })()
</script>
```

### Notes on the example

#### Multiple modules customizing the same method

By calling the original method reference, a function or method can be customized by multiple modules without conflict.

## JavaScript Proxy

Overriding specific methods can be done using explicit references to the original method, like in the examples above, or with the help of [JavaScript Proxies](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy).
Technically both approaches are equivalent - there is nothing one solution allows doing the other doesn't.

For reference, here are versions of the examples above using a Proxy:

### Customizing hyva.formatPrice with a Proxy

The following example achieves the same as the code for the first example.
Using a `Proxy` may look a lot shorter, but it isn't.
It looks shorter because there are fewer comments.
We don't need to wrap the code in an IIFE since no variable would be available globally.

```
<script>
  hyva.formatPrice = new Proxy(hyva.formatPrice, {
    // Intercept method calls
    apply(target, thisArg, argArray) {
      if (value > 0) {
        // Call the original method, passing along any arguments
        return target.apply(thisArg, argArray)
      }
      return '<?= $escaper->escapeJs(__('FREE!')) ?>';
    }
  })
</script>
```

Note the `apply(target, thisArg, argArray)` method of the Proxy handler is different from the `apply` method of Functions.

### Customizing an Alpine component with a Proxy

The following code does the same as the second example above:

```
<script>
  window.initConfigurableOptions = new Proxy(initConfigurableOptions, {
    // Intercept function calls
    apply(target, thisArg, argArray) {
      // Call the original constructor function
      const instance = target.apply(thisArg, argArray);

      instance.init = new Proxy(instance.init, {
        // Intercept init method calls
        apply(target, thisArg, argArray) {
          // Call the original method, passing along any arguments
          target.apply(thisArg, argArray);

          for (const [attributeId, options] of Object.entries(thisArg.allowedAttributeOptions)) {
            if (options.length === 1) {
              thisArg.changeOption(attributeId, Object.values(options)[0].id)
            }
          }
        }
      })
      return instance;
    }
  })
</script>
```

## Overriding Object Properties

The examples above show how to customize methods.
However, many Alpine components consist not only of methods but also properties.
These can be customized similarly.

For example, the object returned by `initConfigurableOptions()` has an `itemId` property, which is dynamically set when the instance is created:

```
itemId: (new URLSearchParams(window.location.search)).get('id') || findPathParam('id'),
```

In the simplest case, it can be enough to override the constructor function and change the initial value on the instance property before returning the instance.

```
<script>
  (() => {
    const origInitConfigurableOptions = initConfigurableOptions;
    window.initConfigurableOptions = function () {
      const instance = origInitConfigurableOptions.apply(this, arguments)

      instance.itemId = 42; // Custom logic to set the property

      return instance;
    }
  })()
</script>
```

However, if custom logic needs to be involved, either [`Object.defineProperty`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty) or a [`Proxy`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy) can be used.

From a technical perspective, both approaches work equally well.

### Declaring property accessors with Object.defineProperty

Here is an example of how the `itemId` property can be customized using `Object.defineProperty`:

```
<script>
    (() => {
        const origInitConfigurableOptions = initConfigurableOptions;
        let customItemId = 42; // some custom value
        window.initConfigurableOptions = function () {
          const instance = origInitConfigurableOptions.apply(this, arguments);
          // Redeclare itemId property with custom accessor methods
          Object.defineProperty(instance, 'itemId', {
            get() {
              return customItemId;
            },
            set(value) {
              customItemId = value;
            }
          });
          return instance;
        }
    })()
</script>
```

### Declaring property accessors with a Proxy

Customizing the `itemId` property with custom logic using a `Proxy` would look something like this:

```
<script>
  (() => {
    let customItemId = 42;
    window.initConfigurableOptions = new Proxy(initConfigurableOptions, {
        // Intercept function calls
        apply(target, thisArg, argArray) {
          // Call the original constructor and add a Proxy to intercept property access
          return new Proxy(target.apply(thisArg, argArray), {
            get(target, prop, receiver) {
              if (prop === 'itemId') {
                return customItemId;
              }
              return Reflect.get(...arguments);
            },
            set(target, prop, value, receiver) {
              if (prop === 'itemId') {
                return (customItemId = value);
              }
              return Reflect.set(...arguments);
            }
          })
        }
    })
  })()
</script>
```
