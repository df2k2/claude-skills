<!-- source: https://docs.hyva.io/hyva-checkout/magewire/array-properties.html -->

# Working with Magewire Array Properties

Magewire array properties let you store and manipulate collections of related data in a Hyvä Checkout component. Any time a user interacts with a component that represents multiples of something (like address fields, cart items, or form options), those values are typically stored in an array property.

Magewire provides a dot-notation syntax for binding to individual items within arrays, and it works for nested arrays too.

## Example Magewire Component with an Array Property

The following Magewire component defines a public `$address` array property. The examples on this page all reference this component.

```
class ArrayPropertyExample extends \Magewirephp\Magewire\Component
{
    // Public array property - each key is bindable via dot notation
    public array $address = [
        'street' => 'Baggins Bvd. 2150',
        'city' => 'Hobbiton',
        'postcode' => '1',
        'country' => 'The Shire',
    ];
}
```

## Binding to Nested Array Keys with Dot Notation

To bind an input to a specific key inside a Magewire array property, use dot notation in the `wire:model` directive. This works for both reading and writing values on nested array keys.

The following template snippet shows two ways to target the `street` key inside the `$address` array property:

```
<!-- wire:model binds the input value to address.street ('Baggins Bvd. 2150' on init) -->
<input wire:model="address.street">

<!-- $set() updates a nested array key directly on click -->
<button wire:click="$set('address.street', 'Bag End')">Correct Street</button>
```

The `wire:model="address.street"` binding keeps the input in sync with `$address['street']` on the Magewire component. The `$set()` call updates the same nested key directly, without needing a dedicated PHP method.

## Lifecycle Hook Methods for Magewire Array Properties

Magewire fires lifecycle hook callbacks when array property values change. For nested properties, the hook method name uses camelCase built from the property name and the nested key.

For the `$address` array property, updating the `street` key triggers a method named `updatedAddressStreet`. This gives you a place to validate or transform the value before Magewire stores it.

```
// Lifecycle hook: fires when address.street is updated
public function updatedAddressStreet(string $value): string
{
    // Return the (optionally modified) value to be stored
    return $value;
}
```

Naming Convention for Nested Array Lifecycle Hooks

The method name pattern is `updated` + property name + nested key, all in camelCase. For example, `address.city` maps to `updatedAddressCity`, and `address.country` maps to `updatedAddressCountry`.
