<!-- source: https://docs.hyva.io/hyva-themes/writing-code/building-urls-in-js.html -->

# Building URLs in JavaScript

In Luma the `mage/url` module is used prepend an URL path with the current store base URL.

With Hyvä it is much simpler: the `window.BASE_URL` variable can be used.

## BASE\_URL

For regular requests, use

```
BASE_URL + "example/path/action"
```

or the [template literal](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) version

```
`${BASE_URL}example/path/action`
```

The above is the equvalent to what the Luma `urlBuilder.build()` method does.

A alternative option is to render the base URL with PHP:

```
'<?= $escaper->escapeUrl($block->getBaseUrl()) ?>example/path/action'
```

There is no "better" or "worse" way to do this.

## CURRENT\_STORE\_CODE

If you need to add the store code to the request path, for example for Ajax requests, use

```
`${BASE_URL}/rest/${CURRENT_STORE_CODE}/example/path/action`
```

Or, the non-template literal version:

```
BASE_URL + 'rest/' + CURRENT_STORE_CODE + '/example/path/action'
```
