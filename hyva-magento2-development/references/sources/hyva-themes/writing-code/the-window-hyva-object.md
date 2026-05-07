<!-- source: https://docs.hyva.io/hyva-themes/writing-code/the-window-hyva-object.html -->

# The window.hyva object

When a Hyvä theme is active, a `window.hyva` JavaScript object is available on every page with some very handy helper functions.

In case you want to look them up, the functions are mostly defined in
`vendor/hyva-themes/magento2-theme-module/src/view/frontend/templates/page/js/hyva.phtml`.

## hyva.getCookie(name)

As the name implies, `getCookie()` is a convenient way to get a given cookie value.

## hyva.setCookie(name, value, days, skipSetDomain)

The first two arguments of the `setCookie` method are required. The third and fourth arguments `days` and `skipSetDomain` are optional.

`skipSetDomain` will, as the name suggests, skip setting the domain on the cookie. Magento is inconsistent in its backend behavior, not always setting the domain on the cookie.

For example, in `Magento\Theme\Controller\Result\MessagePlugin::setCookie`, the domain is not set for the cookie `mage-messages`.

As a result, you end up with two cookies, if you were to set `mage-messages` without setting `skipSetDomain` to true.

Cookie consent

By default, cookies are only saved when the visitor has given their consent.
To force a cookie to be stored regardless of the visitor consenting to cookies, add the name to the `window.cookie_consent_groups.necessary` array.

```
window.addEventListener('load', () => {
  window.cookie_consent_config = window.cookie_consent_config || {};
  window.cookie_consent_config.necessary = window.cookie_consent_config.necessary || [];
  window.cookie_consent_config.necessary.push('my-new-cookie')
})
```

## hyva.setSessionCookie(name, value, skipSetDomain)

Available since Hyvä 1.2.9 and 1.3.5

The first two arguments of the `setSessionCookie` method are required. The third argument `skipSetDomain` is optional.

This method is identical to `hyva.setCookie` with the difference, that the cookie will have no expiry set, so it will be deleted when no more windows or tabs with the site are opened in the browser.

## hyva.getBrowserStorage()

The `getBrowserStorage` method returns either the native `localStorage`, if it is available, or tries to fall back to the `sessionStorage` object.

If neither is available (most notably with IOS Safari in private mode), a warning is logged to the console and `false` is returned.

Example usage:

```
const browserStorage = hyva.getBrowserStorage();
if (browserStorage) {
    const private_content_expire_key = 'mage-cache-timeout';
    const cacheTimeout = browserStorage.getItem(private_content_expire_key);
    browserStorage.removeItem(private_content_expire_key);
    browserStorage.setItem(private_content_expire_key, 3600);
}
```

## hyva.postForm(postParams)

The `postForm` method first creates a new `<form>` element, then adds hidden fields for a given data object, and finally submits the created form. It automatically adds the `uenc` and the `form_key` parameters (`uenc` is often used by Magento to redirect the visitor back to the page).

The argument `postParams` is an object with form configuration:

```
{
  action: "the form action url to post to",
  data: {
    field_a: "value A",
    field_b: "value B"
  },
  skipUenc: false,
}
```

The optional `skipUenc` option is available since Hyvä 1.2.4

Example: post form data by clicking a link (using Alpine.js)

```
<button @click.prevent="hyva.postForm({
  action: 'https://example.test/custom_quote/move/inQuote/',
  data: { id: '<?= $escaper->escapeJs($block->getQuoteId()) ?>' }
})">Request a Quote</button>
```

## hyva.getFormKey()

The `getFormKey` method returns the current form key value. It is fetched directly from the `form_key` cookie, or generated when that cookie does not exist.

## hyva.trapFocus(Element rootElement)

Available since Hyvä 1.2.6

The `trapFocus` method causes keyboard tab navigation to iterate only over focusable elements inside the given root element.
The first focusable element is selected automatically.
To release the focus, use `hyva.releaseFocus(rootElement)`. Alternatively the rootElement can be hidden or removed from page.

## hyva.releaseFocus(Element rootElement)

Available since Hyvä 1.2.6

The `releaseFocus` method removes the focus trap initiated by `hyva.trapFocus`.

## hyva.formatPrice(value, showSign, options = {})

The `formatPrice` method formats and returns the given value using the current currency.
The `showSign` argument is optional. If it is set to `true`, a `+` or `-` symbol is always rendered.

Otherwise, by default only `-` is rendered for negative values.

Available since Hyvä 1.3.6: options

Since 1.3.6 an optional `options = {}` parameter is accepted that is passed to [the `NumberFormat` constructor](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/NumberFormat/NumberFormat#locale_options).
It can be used to enforce a minimum or maximum number of fraction digits (amongst other things).
This is possible with a small override function in a custom theme, as shown in this example:

```
<script>
  (() => {
    const origFormatPrice = hyva.formatPrice;
    hyva.formatPrice = function (value, showSign, options = {}) {
      options.maximumFractionDigits = 0; // remove fractions
      return origFormatPrice.call(null, value, showSign, options);
    }
  })()
</script>
```

Available since Hyvä 1.3.10: `options.groupSeparator` and `options.decimalSeparator`

Since 1.3.6 the non-standard options `groupSeparator` and `decimalSeparator` are available.

```
hyva.formatPrice(price, false, {groupSeparator: '-', decimalSeparator: ' .oOo.: '})
```

For a more in-depth example please see the [Overriding JavaScript docs](patterns/overriding-js.html).

## hyva.str(string, ...args)

Available since Hyvä 1.1.17

The `str` function replaces positional parameters like `%1` with the additional argument in the matching position.
The first additional argument replaces `%1`, the second `%2`, and so on.

Example:

```
hyva.str('%2 %1 %3', 'a', 'b', 'c') // => "b a c"
```

To insert a literal `%` symbol followed by a number duplicate the `%`.
For example `%%2` is returned as `%2`.

The behavior of `hyva.str` is similar to the Magento PHP function `__()` in regard to the positional parameters.
This allows using some translation phrases with positional parameters in PHP and in JavaScript.

```
// JavaScript
hyva.str('Welcome %1', customer.firstName);
```

```
// PHP
__('Welcome %1', $customer->getFirstname())
```

## hyva.strf(string, ...args)

Available since Hyvä 1.1.14

The `strf` function replaces positional parameters like `%0` in the first argument with additional arguments in the matching position.
The first additional argument replaces `%0`, the second `%1`, and so on.

Example:

```
hyva.strf('%1 %0 %2', 'a', 'b', 'c') // => "b a c"
```

To insert a literal `%` symbol followed by a number duplicate the `%`.
For example `%%2` is returned as `%2`.

`hyva.str` vs `hyva.strf`

`hyva.strf` is almost identical to `hyva.str`, except that for `hyva.strf` the first additional argument replaces `%0`, while for `hyva.str` it replaces `%1`.

In general, using `hyva.str` is preferable, because it behaves similar to the Magento PHP function `__()`, which also uses `%1` to refer to the first additional argument.
This means existing translation phrases which are also used with the PHP function `__()` may be reused with `hyva.str`.

## hyva.replaceDomElement(targetSelector, content)

Available since Hyvä 1.1.14

The `replaceDomElement` method replaces the DOM element specified by `targetSelector` with the innerHTML of the same selector from the string `content`.

This is useful to replace a part of the page with the same part from a HTML response to an Ajax request.
The function extracts `<script>` tags from the returned content and adds them to the page head to ensure they are executed.

Example:

```
window.fetch(url, {
  method: 'POST',
  body: payload
})
.then(result => result.text())
.then(body => {
  hyva.replaceDomElement('#maincontent', body)
})
.catch(error => {
  console.error(error);
  window.location.reload()
})
```

## hyva.activateScripts(node)

Available since Hyvä 1.3.6

The `hyva.activateScripts` method takes an `Element` instance as an argument, extracts all script child elements and adds them to the document head, so they are parsed by the browser.

The `activateScripts` method is useful when part of the page is updated with an HTML snippet from an Ajax request.
The browser will not process `<script>` tags in the new content.
To ensure scripts are processed, pass the new content as an Element to `activateScripts` before it is injected into the page.

Example:

```
const contentNode = document.createElement('div');
contentNode.innerHTML = htmlSnippet;
hyva.activateScripts(contentNode)
// Inject the new content into the page
document.querySelector(targetSelector).replaceWith(contentNode);
```

## hyva.getUenc()

Available since Hyvä 1.1.17

The `getUenc` method is intended to be used to supply the value for the `uenc` query arguments that is commonly used in Magento.
It allows Magento to redirect the visitor back to the previous page.

```
"body": "form_key=" + hyva.getFormKey() + "&uenc=" + hyva.getUenc(),
```

The method returns a properly encoded version of `window.location.href`.
Besides base64 encoding the current URL, it also takes care of the special characters `+`. `/` and `=` in a way compatible with `\Magento\Framework\Url\Encoder::encode()`.

## hyva.alpineInitialized(callback)

Available since Hyvä 1.2.8 and 1.3.4

The `alpineInitialized` method takes a callback argument that is executed after Alpine.js is loaded and initialized, regardless of the Alpine version.
It can be a useful alternative to the document `load` event, which can be triggered before Alpine is initialized on cached pages in mobile Safari.

With Alpine.js v3, it is the same as using

```
window.addEventListener('alpine:initialized', callback, {once: true})
```

With Alpine.js v2, the callback is executed using

```
const initAlpine = window.deferLoadingAlpine || ((startAlpine) => startAlpine())
window.deferLoadingAlpine = (startAlpine) => {
    initAlpine(startAlpine)
    Promise.resolve().then(() => callback())
}
```

## hyva.createBooleanObject(name, value = false, additionalMethods = {})

Available since Hyvä 1.3.11

This convenience method provides an object for Alpine components that toggle state. It is useful when writing strict CSP-compatible components.
The method takes up to three arguments:

- `name`: the name of the property, for example, "hidden", "open", "active" - whatever suits your component.
- `value`: the initial value of the property, `true` or `false`. If not specified, it defaults to `false`.
- `additionalMethods`: this optional object will be merged into the returned result. It can be used to extend the boolean object with custom methods.

The boolean object provides methods matching the property name to access the component state.
For example, if the property name `hidden` is used, the state can be accessed with `hidden` and `!hidden`.
For more information, please refer to the detailed [`hyva.createBooleanObject` method documentation in the CSP docs](csp/alpine-csp-hyva-createbooleanobject.html).

## hyva.safeParseNumber(rawValue)

Available since Hyvä 1.3.11

With strict CSP the Alpine `x-model` directive can't be used, and input or change events have to be used instead to set the value.
With regular alpine, the `x-model.number` allows enforcing the value to be a number. To maintain this functionality the function here is included, so that it can be used in the event callback.
