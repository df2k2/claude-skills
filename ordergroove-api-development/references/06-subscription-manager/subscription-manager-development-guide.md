# Subscription Manager Development Guide

Ordergroove’s Subscription Manager is built with a custom implementation of Nunjucks to maximize readability and ease of development without compromising performance on your store. This guide is aimed at developers with a good understanding of HTML, CSS, and JavaScript who are looking to customize their Subscription Manager.

***

## Requirements

This guide is relevant for developers working on either v0 or v25 of the Subscription Manager. Any examples will be taken from v25 of Subscription Manager.

***

## Overview

Ordergroove’s Subscription Manager is built on a custom implementation of Nunjucks which transpiles into a [lit-html web component](https://lit.dev/docs/libraries/standalone-templates/) to be sent to the customer. This implementation enables the Subscription Manager to be built with the intuitive feel of a templating language, while maximizing DOM responsiveness to changes by the customer without necessitating a full-page refresh.

During development pre-compilation, the Subscription Manager templates are written as a combination of Nunjucks and lit-html.

***

## Fundamentals

This section will walk you through the fundamentals of Ordergroove’s Subscription Manager templating language.

### Nunjucks Tags and Expressions

The primary means of logic in the Subscription Manager are Nunjucks tags and expressions. Key tags that are implemented are `if`, `set`, `for`, and `include`. These tags are used in brackets `{% %}`, just like in Nunjucks, and can be used to add logic around variables and what  you want to render.

Example of `if` and `set`:

```
{% if not subscription %}
 {% set badge_class = "og-badge-one-time" %}
{% elseif subscription.prepaid_subscription_context %}
 {% set badge_class = "og-badge-prepaid" %}
{% else %}
 {% set badge_class = "og-badge-pay-as-you-go" %}
{% endif %}
```

Example of `for` and `include`:

```
{% for order in orders %}
  {% include 'order/main' %}
{% endfor %}
```

The `set` keyword can be used to set variables to primitives or objects. The `include` keyword is used to inject another `liquid` file into that location. When a file is included, it is inserted into the code as if its code was placed there instead of the `include`. You always need to include the absolute folder path of the partial from the base views folder in your `include` path, even if you’re referencing a file from the same subfolder.

Nunjucks variables and expressions can be displayed or inserted using `{{ }}` brackets. For example, if you wanted to display the value of `badge_class` from the example above, you could write `<p>{{badge_class}}</p>` to display it in a paragraph.

### Objects

The Subscription Manager relies on objects containing customer subscription data that needs to be displayed. On load, the subscription manager retrieves all of the data for the customer and stores everything in the Redux store. Objects from the Redux store can be accessed directly through the Nunjucks template.

Some objects are documented [here](https://developer.ordergroove.com/docs/object-reference), but the Redux store itself is an excellent place to check to see what is available for your customers, since some features may be enabled on your store that aren’t shown in the documentation. Take a look at our [Debugging with Redux](https://developer.ordergroove.com/docs/debugging-with-redux) guide for more information.

### Filters and Pipes

Nunjucks filters are used with pipes to modify and manipulate objects, variables, and strings. To use a filter, place a pipe and the filter inside Nunjucks brackets. For example, the `t` filter indicates that the string preceding it should be passed to the `locales` files to be matched with text content in the current language. `{{ ‘cancel_subscription_button’ | t }}` indicates that the translation for the “cancel\_subscription\_button” key in the locales file should be inserted there.

Filters can be chained left to right, with the output of the left-most filter serving as the input for the next filter, and so on.

Another key filter is `| js`, which takes in a Javascript function. It can be passed either the name of a Javascript function in `script.js`, or an inline function as a string, like `’(e) => console.log(e)’ | js`. The next section will discuss lit-html event bindings, the primary usage for this filter.

The `| action` filter is used to wire up a form to a JavaScript handler that validates the data and submits it to Ordergroove's APIs. These handler functions are not available to external developers.

The other filters that are implemented are described in the table below. More details on the filters can be found at [https://static.ordergroove.com/@ordergroove/smi-core/latest/docs/index.html](https://static.ordergroove.com/@ordergroove/smi-core/latest/docs/index.html), in the *Filters* folder.

| Filter      | Usage                                                                                                                                                                                                                                                                                                        |
| :---------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| currency    | Returns a localized currency number. Internally using [NumberFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat)                                                                                                                                     |
| date        | Returns a localized date in specified format. Formats are following dayjs with the full format documentation [here](https://day.js.org/docs/en/display/format). See our [SM date documentation](https://developer.ordergroove.com/docs/working-with-dates-in-the-subscription-manager) for more information. |
| dump        | Stringifies the passed value                                                                                                                                                                                                                                                                                 |
| entries     | Returns the result of JavaScript's Object.entries function                                                                                                                                                                                                                                                   |
| find        | Implements [lodash find](https://lodash.com/docs/4.17.15#find)                                                                                                                                                                                                                                               |
| first       | Implements [lodash first](https://lodash.com/docs/4.17.15#first)                                                                                                                                                                                                                                             |
| get         | Implements [lodash get](https://lodash.com/docs/4.17.15#get)                                                                                                                                                                                                                                                 |
| if\_defined | Implements `ifDefined` from [lit-html](https://lit-html.polymer-project.org/guide/template-reference#ifdefined)                                                                                                                                                                                              |
| key         | Extends the given list with a key, to allow efficient updates when the list changes                                                                                                                                                                                                                          |
| last        | Implements [lodash last](https://lodash.com/docs/4.17.15#last)                                                                                                                                                                                                                                               |
| reject      | Implements [lodash reject](https://lodash.com/docs/4.17.15#reject). Used to limit the contents of an array to items which don’t meet the passed criteria                                                                                                                                                     |
| select      | Creates an identity function based on an optional filter function. If no filter function is provided and the argument is a string of 32 length, a default filter function using public\_id will be used.                                                                                                     |
| shuffle     | Creates an array of shuffled values, using a version of the [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher-Yates_shuffle)                                                                                                                                                                       |
| sort        | Implements [lodash sort](https://lodash.com/docs/4.17.15#sort)                                                                                                                                                                                                                                               |
| until       | Implements [lit-html until](https://lit.dev/docs/v1/lit-html/template-reference/#until)                                                                                                                                                                                                                      |

If you need a filter which is not already implemented, please create a ZenDesk ticket with the filter and desired functionality.

### Lit-HTML Expressions

Because Subscription Manager files ultimately compile to lit-html, many of lit-html’s expressions are available in addition to Nunjucks-style templating.

**Event Listeners**

The Ordergroove Subscription Manager supports adding event listeners to HTML elements with @ expressions through lit-element. Lit’s documentation on this process is available [here](https://lit.dev/docs/components/events/#adding-event-listeners-in-the-element-template).

For example, `@click="{{ 'SMDialog.open' | js }}"` means that on the “click” event, the javascript method `open` from `SMDialog` custom element will be called.

**Boolean Checks**

Boolean attributes in lit-element allow conditional setting of HTML attributes. They are set  with ? at the beginning of the attribute. Lit’s documentation on this process is available [here](https://lit.dev/docs/templates/expressions/#boolean-attribute-expressions).

**Property Setting**

Lit-html’s property syntax allows setting a property on an element instead of the attribute. Lit’s documentation on this process is available [here](https://lit.dev/docs/templates/expressions/#property-expressions).

For example, `<input .value=${value}>` sets the `value` property directly and not the attribute, which would only set the default value. This is useful when you want to set a complex data property like an array or an object or when setting the property of an element is different than setting the attribute of an element.

### Comments

Comments in the Subscription Manager are marked within `{# #}` brackets. Anything within these brackets will not be displayed in the DOM.

***

## Common Mistakes

**Property accesses on null objects**

It’s important to note that in the Subscription Manager, variables have global scope but are not always defined when the subscription manager loads. This can lead to inconsistent loading states if a variable is being used without checking whether it is defined. The most common example is accessing a property on an object, like product.name, without first establishing that product is defined and not-null. If you have made customizations to your SM and start running into loading issues, check all of the property accesses and make sure the object is non-null.

**Duplicate IDs**

Some subscription manager liquid files render inputs with specific IDs. For example, `sku-swap-product-change-dialog.liquid` includes `<label>` elements with a `for` attribute set to the `id` of the corresponding `<input>`.

```html
<input
  required
  type="radio"
  name="product"
  value="{{alt_product_id}}"
  class="visually-hidden"
  id="alternative-product-{{alt_product_id}}-for-{{product.external_product_id}}-in-{{order_item.public_id}}"
>
<label
  data-product-name="{{ alt_product.name }}"
  for="alternative-product-{{alt_product_id}}-for-{{product.external_product_id}}-in-{{order_item.public_id}}"
>
```

In HTML, IDs are global. If you include this file multiple times on your theme when making customizations, you may have multiple `<input>` elements with the same ID. This may cause issues with interacting with those input elements -- if you're having trouble selecting a radio input option, check that it's the only input on the page with that ID.