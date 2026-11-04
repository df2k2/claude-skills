<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/running-code-once-when-private-data-is-loaded.html -->

# Running code once when private data is loaded

In Luma, sometimes custom initialization code executes when private section data has been loaded. This code only needs to be run once, not every time the data is reloaded.

The Hyvä version of this pattern looks like this:

```
<script>
    const initMyCode = (event) => {
        // event.detail.data contains the entire sectionData
        const sectionData = event.detail.data;

        const isLoggedIn = sectionData.customer && !!sectionData.customer.firstname;
        // other code...

        const cartSummaryCount = sectionData.cart ? sectionData.cart.summary_count : 0;
    };

    window.addEventListener('private-content-loaded', initMyCode, { once: true });
</script>
```

Note

Note the third argument to `window.addEventListener` in the example above: `{ once: true }`.

Only executing an event subscriber once is part of the native Browser events API:
By passing a third argument `{ once: true }` to the `addEventListener()` method the callback will automatically be unregistered after it is executed once.
