<!-- source: https://docs.hyva.io/hyva-checkout/magewire/running-php-code-after-property-updates.html -->

# Running PHP Code after Magewire Property Updates

Magewire lets you run PHP logic automatically whenever a component property changes. This is handy when you need to persist the updated value to a database, save it in the session, or trigger side effects like recalculating totals.

## Using the `updated` Callback Method in Magewire

Magewire provides a naming-convention-based callback for reacting to property changes. When a property called `myProp` is updated through Magewire (for example via `$set()`), Magewire will automatically call a method named `updatedMyProp()` on your component if it exists.

Here's what that looks like:

```
// Magewire calls this method automatically after the "myProp" property is updated.
// The naming convention is: updated + PascalCase property name.
public function updatedMyProp(string $value): string
{
    // Run your logic here, for example
    // persist $this->myProp to the database or session.
    return $value;
}
```

The return value of the callback becomes the final value assigned to the property.

Only triggered by Magewire updates

The `updatedMyProp()` callback is only called when the property is updated through Magewire (for example via `$set()` in Alpine.js or a Magewire action). Direct PHP assignment like `$this->myProp = 'new value'` does **not** trigger the callback.

## Generic `updated()` Callback for All Magewire Properties

Magewire also provides a generic `updated($value, $prop)` lifecycle method that fires for every property update on the component, regardless of which property changed. The property-specific callback (like `updatedMyProp()`) is more common, but the generic version is useful when you want centralized handling for all property changes.

Both of these callbacks are Magewire lifecycle hook methods. You can find the full list of available hooks, including `updating()` variants that fire *before* the value is applied, in the [lifecycle hook methods documentation](lifecycle-hook-methods.html).

## Related Topics

- **[Magewire Lifecycle Hook Methods](lifecycle-hook-methods.html)** - Full reference of all available lifecycle hooks, including `updating`, `hydrate`, `mount`, and more
- **[Magewire Component Lifecycle](component-lifecycle.html)** - Understand the different phases a Magewire component goes through during preceding and subsequent requests
