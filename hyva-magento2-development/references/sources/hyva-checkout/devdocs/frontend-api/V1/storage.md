<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/V1/storage.html -->

# Browser Session Storage API for Hyvä Checkout

**Since:** 1.1.13

The `hyvaCheckout.storage` sub-namespace provides methods for storing and retrieving key-value pairs in the browser's session storage. The Hyvä Checkout storage API is essential for persisting payment and shipping data that needs to travel to the server-side Place Order Service when the order is placed.

## Built-in Hyvä Checkout Storage Groups

Hyvä Checkout uses two predefined storage groups that automatically transfer data to the backend Place Order Service PHP object:

- **`payment`** - Stores payment-related data (tokens, method-specific values, transaction IDs)
- **`shipping`** - Stores shipping-related data (carrier preferences, delivery instructions)

You can also define custom groups for your own module's data persistence needs.

## Storing Values with setValue

The `hyvaCheckout.storage.setValue()` method stores a value in session storage under a specified key, optionally within a named group. Values stored in the `payment` or `shipping` groups are automatically available in the Place Order Service on the backend.

**Parameters:**

- `key` (string, required) - The storage key identifier
- `value` (mixed, required) - The value to store (strings, numbers, objects, arrays)
- `group` (string, optional) - Group name for organizing related values

**Returns:**

- `Promise` (since v1.3.4) - Resolves with the stored value after successful storage
- `void` (before v1.3.4) - No return value in earlier versions

The following example demonstrates storing a payment PIN code that will be available to the Place Order Service on the backend:

Setting Storage Values with Groups

```
<script>
    (() => {
        const group = 'payment';
        const key = 'pin';
        const value = 123;

        // Wrap in hyvaCheckout.api.after when setting values on page load
        // This ensures the API is initialized before accessing storage
        // Not required for values set from user interactions (API already initialized)
        hyvaCheckout.api.after(() => {
            // Since v1.3.4: setValue returns a Promise
            hyvaCheckout.storage.setValue(key, value, group)
                .then(storedValue => {
                    if (storedValue === value) {
                        console.log('Value successfully stored in session storage.');
                    }
                });

            // Before v1.3.4: Use getValue to verify storage
            if (hyvaCheckout.storage.getValue(key, group) === value) {
                console.log('Value successfully stored in session storage.');
            }

            // Alternative: Check via getGroupData
            const groupData = hyvaCheckout.storage.getGroupData(group);
            if (groupData && groupData[key] === value) {
                console.log('Value found in group data.');
            }
        });
    })();
</script>
```

Wrap page-load storage calls in hyvaCheckout.api.after

Always wrap `hyvaCheckout.storage.setValue()` in `hyvaCheckout.api.after()` when setting values on page load. This ensures the storage API is fully initialized. For values set from user interactions like button clicks, the API is already initialized and wrapping is not required.

## Retrieving a Single Value with getValue

The `hyvaCheckout.storage.getValue()` method retrieves a single value from session storage by key and optional group.

**Parameters:**

- `key` (string, required) - The storage key identifier
- `group` (string, optional) - Group name to search within

**Returns:**

- `mixed`: The stored value if found
- `null`: If the key does not exist

The following example retrieves a previously stored payment PIN from the `payment` group:

Getting a Single Storage Value

```
<script>
    (() => {
        hyvaCheckout.api.after(() => {
            // Retrieve value from the payment group
            const pin = hyvaCheckout.storage.getValue('pin', 'payment');

            if (pin !== null) {
                console.log('Retrieved PIN:', pin);
            }
        });
    })();
</script>
```

## Retrieving All Group Values with getGroupData

The `hyvaCheckout.storage.getGroupData()` method retrieves all key-value pairs within a specified storage group as an object. This is useful when you need to inspect or process all stored values for a given group at once.

**Parameters:**

- `group` (string, required) - The group name to retrieve

**Returns:**

- `object`: All key-value pairs in the group (an empty object if the group exists but holds no values)
- `null`: If the group does not exist

The following example retrieves all values stored in the `payment` group:

Getting All Group Data

```
<script>
    (() => {
        hyvaCheckout.api.after(() => {
            // Get all payment-related stored values
            const paymentData = hyvaCheckout.storage.getGroupData('payment');

            if (paymentData) {
                console.log('Payment storage contents:', paymentData);
                // Example output: { pin: 123, token: 'abc123', method: 'credit_card' }
            }
        });
    })();
</script>
```

## Resetting a Value with setValue

The storage API has no method to remove a single key or a single group. To reset a value, store `null` with `setValue()`. Afterwards, `getValue()` returns `null` for that key, the same as for a key that was never set.

The following example resets the stored PIN in the `payment` group:

Resetting a Single Storage Value

```
<script>
    (() => {
        hyvaCheckout.api.after(() => {
            hyvaCheckout.storage.setValue('pin', null, 'payment')
                .then(() => {
                    console.log('PIN after reset:', hyvaCheckout.storage.getValue('pin', 'payment')); // null
                });
        });
    })();
</script>
```

## Clearing All Stored Values with clear

The `hyvaCheckout.storage.clear()` method removes all Hyvä Checkout values from session storage, across all groups, and dispatches the `checkout:storage:cleared` window event. Hyvä Checkout calls it on the order success page.

**Returns:**

- `Promise` - Resolves after the storage is cleared

Don't clear the storage during checkout

`clear()` also removes the record of the steps the customer completed, so call it only after the order is placed, as the success page does. On a multi-step Checkout 3.x checkout, an order placed after `clear()` is refused with the "Incomplete Checkout Process" dialog. On Checkout 1.x, reading or writing the storage fails until the next page load.

## Accessing Hyvä Checkout Storage Data in Place Order Service

Values stored in the `payment` and `shipping` groups are automatically passed to the server-side Place Order Service when the customer places an order. You don't need to manually transfer the storage data - Hyvä Checkout handles the handoff for you.

To access the stored values in your PHP Place Order Service implementation, use the appropriate service methods provided by the Place Order Service class.

## Related Topics

- **[Hyvä Checkout Frontend API](api.html)** - The main frontend API that the storage sub-namespace belongs to
- **[Hyvä Checkout Payment API](payment.html)** - Payment-specific frontend API methods that work alongside storage
- **[Hyvä Checkout Evaluation API](evaluation.html)** - Validation and evaluation methods for checkout fields
