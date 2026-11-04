<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-api/form-modification-hooks.html -->

# Form Modification Hooks

Hyvä Checkout form modification hooks let you customize forms at specific points in the form lifecycle. Each hook fires at a different stage, from initial construction through to final rendering, and provides different callback arguments. Understanding which hook to use is essential for making clean, targeted form customizations.

The hook set differs between the release lines. Checkout 3.x adds a `form:*:magewire` hook for every Magewire lifecycle step and keeps the Checkout 1.x address form hooks as deprecated legacy hooks, so most existing modifiers keep working. See [Hyvä Checkout Release Lines](../../getting-started/release-lines.html) for the background.

## Modification Guidelines

Form modifications are intended for **minor adjustments** such as changing labels, adding CSS classes, inserting an individual field, or modifying field properties. Modification hooks are not designed for major overhauls like adding many fields at once.

For extensive changes, consider creating separate custom forms and conditionally rendering them based on context. For example, you could use tabs to switch between different form layouts.

How to choose the right modification hook

Finding the right modification hook (and modifier sort order) may not be straightforward.

Not every type of form and field manipulation is possible in every hook, so the desired effect determines which hook to use.

When more than one modifier alters the same field, both the modifier `sortOrder` and the hook execution order influence the order in which callbacks run. For example, a `form:build` modifier with a high sort order still executes before a `form:build:magewire` modifier with a lower sort order, because `form:build` fires first in the lifecycle.

## Registering a Hook Listener

You register a listener inside a form modifier's `apply()` method with `registerModificationListener()`. The first argument is a listener name that must be unique per form (registering the same name twice throws a `FormException`), the second is the hook name, and the third is the callback.

```
$form->registerModificationListener(string $name, string $event, callable $listener);
```

Hyvä Checkout dispatches hooks on two layers:

- **Entity form hooks (`form:*`)** are dispatched by `Hyva\Checkout\Model\Form\AbstractEntityForm` during the form's own build pipeline. They fire for every form, whatever drives it. The listener receives the form as its first argument.
- **Magewire component hooks (`form:*:magewire`)** are dispatched by the Magewire form component `Hyva\Checkout\Magewire\Component\AbstractForm` on its lifecycle steps. They fire only for Magewire-driven forms. The listener receives the form, then the component, then any hook-specific arguments.

The address form hooks (`form:boot`, `form:updated`, `form:field:updated`, `form:action:edit`, `form:action:create` and their address type variants) come from the address form component:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

The address forms are driven by `Hyva\Checkout\Magewire\Component\AbstractAddressForm` (concretely `ShippingDetailsForm` and `BillingDetailsForm`). It re-emits the Checkout 1.x address form hooks with the same names and arguments as **deprecated legacy hooks**, so existing listeners keep firing. New code should listen on the `form:*:magewire` hooks instead. See [Legacy Hooks on Checkout 3.x](#legacy-hooks-on-checkout-3x).

The address forms are driven by `Hyva\Checkout\Magewire\Checkout\AddressView\AbstractMagewireAddressForm`, which dispatches the address form hooks directly.

## Hook Lifecycle Order

The hooks fire in this order during the form lifecycle:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

1. **`form:init`**: form construction, after the fields are populated and the modifiers are applied
2. **`form:populate`**: right after `form:init`
3. **`form:construct:magewire`**: the component constructs its base structure, add fields and elements up front here
4. **`form:loaded:magewire`**: once per request, after the field values are loaded and before they sync to the component's data property
5. **`form:boot:magewire`**: end of the component's `boot()` (address forms also emit the legacy `form:boot`)
6. **`form:hydrate:magewire`**: subsequent requests only
7. **`form:booted:magewire`**: after boot and hydrate
8. **`form:updating:magewire`** and **`form:updated:magewire`** with their `:data` variants: when a property changes (subsequent requests only, address forms also emit the legacy `form:updated` and `form:field:updated`)
9. **`form:before:trigger:<method>:magewire`**, **`form:trigger:<method>:magewire`**, **`form:submitting:magewire`** and **`form:trigger:submit:magewire`**: when the customer triggers an action or the form is submitted
10. **`form:build`**: render time, from the entity form
11. **`form:build:magewire`**: render time, Magewire-specific attributes
12. **`form:dehydrate:magewire`**: end of the request, after the form's automatic save

The address forms also dispatch `form:action:edit:magewire` and `form:action:create:magewire` (plus the legacy `form:action:edit` and `form:action:create`) when the customer opens the edit or new address modal.

1. **`form:init`**: form construction, add or remove fields
2. **`form:populate`**: after field population and built-in modifiers have been applied
3. **`form:boot`**: after initialization, all fields filled with data
4. **`form:build`**: visual changes before rendering
5. **`form:build:magewire`**: Magewire-specific attributes before rendering
6. **`form:updated`**: when field values change (subsequent requests only)
7. **`form:field:updated`**: when a specific field value changes (subsequent requests only)
8. **`form:action:edit`**: when the "Edit Address" button is clicked
9. **`form:action:create`**: when the "New Address" button is clicked

## Magewire Component Hooks

Every form driven by `Hyva\Checkout\Magewire\Component\AbstractForm` (the guest details form, the coupon code form, and your own Magewire-driven forms) dispatches `form:*:magewire` hooks on its lifecycle steps. The listener signature is `($form, $component, ...$args)`.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, the address forms (`ShippingDetailsForm`, `BillingDetailsForm`) extend `AbstractForm` too, so these hooks fire for them as well.

| Hook | Fires | Extra arguments | Use it for |
| --- | --- | --- | --- |
| `form:construct:magewire` | During form initialization, after the base structure is constructed | None | Add fields or elements before any other modification runs |
| `form:loaded:magewire` | Once per request in `boot()`, after the values are filled and before the data property is synced | None | Derive field values or options from the loaded data. Replaces the deprecated `form:fill` |
| `form:boot:magewire` | End of `boot()`, every request | None | Boot-time setup that needs the data property in place |
| `form:booted:magewire` | After boot and hydrate | None | Late initialization |
| `form:hydrate:magewire` | Subsequent requests only | None | React to a component being restored from its snapshot |
| `form:dehydrate:magewire` | End of the request, after the automatic save | None | Cleanup |
| `form:updating:magewire` | A public property is about to change | `property`, `value` | Inspect any property update |
| `form:updating:data:magewire` | A form data property is about to change | `value`, `path` | Logic before any form field changes |
| `form:updating:data:<path>:magewire` | A specific form field is about to change, for example `form:updating:data:country_id:magewire` or `form:updating:data:street.1:magewire` | `path`, `from`, `to` | Field-specific logic before the change |
| `form:updated:magewire` | A public property has changed | `property`, `value` | React to any property update |
| `form:updated:data:magewire` | A form data property has changed | `value`, `path` | Logic after any form field changes |
| `form:updated:data:<path>:magewire` | A specific form field has changed, for example `form:updated:data:country_id:magewire` | None | Field-specific logic, such as rebuilding dependent options |
| `form:submitting:magewire` | In `submit()`, after the form is filled with the submitted data and before validation and saving | None | Adjust values before saving, or throw an `AcceptableException` to cancel the submission |
| `form:before:trigger:<method>:magewire` | Before the trigger hooks, when a clickable form element method is invoked | Element arguments | Guard an action. Throw a `FormModificationHaltException` to veto it |
| `form:trigger:<method>:magewire` | A clickable form element method is invoked | Element arguments | Handle a specific button or action |
| `form:trigger:magewire` | Any clickable form element method is invoked | `method`, `arguments` | Catch-all action handler |
| `form:trigger:submit:magewire` | In `submit()`, after the save attempt, also a failed one (`exception` is then set). Not when the validation or a `form:submitting:magewire` listener stopped the submission | `result`, `data`, `exception` | Logic after a save attempt |
| `form:build:magewire` | At render time, after the updates of the request | None | Render-time field and element preparation |

The data path is relative to the component's data property: `data` for plain forms, `address` for the address forms (see `AbstractForm::formDataKey()`).

The address forms add two hooks of their own:

| Hook | Fires | Extra arguments |
| --- | --- | --- |
| `form:action:create:magewire` | The customer opens the new address modal | `type` (address type) |
| `form:action:edit:magewire` | The customer opens the edit address modal | `type`, `address` |

These Checkout 1.x names are **deprecated aliases** that still fire on Checkout 3.x, so 1.x listeners keep working:

| Deprecated hook | Replacement |
| --- | --- |
| `form:mount:magewire` (fires during the page render only) | `form:boot:magewire`, which fires on every request |
| `form:data:updating:magewire` | `form:updating:data:magewire` |
| `form:data:updated:magewire` | `form:updated:data:magewire` |
| `form:updating:data:street:1:magewire` (1.x name of a nested path) | `form:updating:data:street.1:magewire` |
| `form:before:execute:<method>:magewire` | `form:before:trigger:<method>:magewire` (a veto on the deprecated hook also stops the trigger hooks) |
| `form:execute:<method>:magewire` | `form:trigger:<method>:magewire` |
| `form:execute:submit:magewire` | `form:trigger:submit:magewire` |

On Checkout 1.x, the address forms don't extend `AbstractForm`. They dispatch only `form:build:magewire` and `form:<address_type>:build:magewire` from this list, next to the address form hooks described further down.

| Hook | Fires | Extra arguments |
| --- | --- | --- |
| `form:construct:magewire` | When the base structure is constructed in `boot()` | None |
| `form:boot:magewire` | During `boot()`, every request | None |
| `form:mount:magewire` | Initial page render only, not on step navigation | None |
| `form:booted:magewire` | After the form is filled with the previously entered data | None |
| `form:hydrate:magewire` | Subsequent requests only | None |
| `form:dehydrate:magewire` | End of the request, before the automatic save | None |
| `form:updating:magewire` | A public property is about to change | `property`, `value` |
| `form:updated:magewire` | A public property has changed | `property`, `value` |
| `form:data:updating:magewire` | The form data is about to change | None |
| `form:updating:data:<path>:magewire` | A specific form field is about to change | `path`, `from`, `to` |
| `form:data:updated:magewire` | The form data has changed | None |
| `form:before:execute:<method>:magewire` | Before `execute`, when a clickable form element method is invoked | Element arguments |
| `form:execute:<method>:magewire` | A clickable form element method is invoked | Element arguments |
| `form:execute:submit:magewire` | After `submit()` ran | `result`, `data`, `exception` |
| `form:build:magewire` | At render time | None |

## `form:init` Hook

The `form:init` hook fires whenever a form is constructed. Use `form:init` to add or remove form fields, or to adjust the form itself along with its fields and values.

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form` | Yes | Yes | 1.1.0 | `form:populate` |

## `form:populate` Hook

The `form:populate` hook fires immediately after `form:init`, once all fields have been populated and all built-in modifiers have been applied. Use `form:populate` to make additional modifications to the form after the standard initialization is complete.

| Callback Parameters | Preceding | Subsequent | Since |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form` | Yes | Yes | 1.1.0 |

## `form:boot` Hook

The `form:boot` hook fires after a form is fully constructed and all fields have been filled with their intended data. Use `form:boot` to alter field values right after initialization is complete.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `form:boot` is a deprecated legacy hook that the address forms re-emit from `form:boot:magewire`. Use `form:boot:magewire` for new code, or `form:loaded:magewire` if you derive field values from the loaded data.

| Callback Parameters | Preceding | Subsequent | Associated hooks |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `AbstractAddressForm $addressComponent` | Yes | Yes | `form:[ADDRESS_NAMESPACE]:boot` |

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `MagewireAddressFormInterface $addressComponent` | Yes | Yes | 1.1.2 | `form:[ADDRESS_NAMESPACE]:boot` |

## `form:build` Hook

The `form:build` hook fires before the form is rendered. Use `form:build` to make **visual-only changes** such as adding extra CSS classes or styles to fields.

Mostly visual changes

The `form:build` hook is meant for visual changes. Add structural fields in `form:init` (or `form:construct:magewire` on Checkout 3.x) when they don't depend on other field values. Fields you remove in `form:build` are pruned right after the hook, which is why [Interdependent Fields](../form-customization/interdependent-fields.html) uses it on Checkout 1.x to add or remove fields based on another field's value.

On both release lines, `form:build` fires once per render, from the entity form itself. The Checkout 3.x address forms don't re-emit it.

| Callback Parameters | Preceding | Subsequent | Since |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form` | Yes | Yes | 1.1.0 |

## `form:build:magewire` Hook

The `form:build:magewire` hook is an additional build-phase hook for Magewire-specific adjustments. Use `form:build:magewire` to add or modify Magewire attributes like `wire:model` or `wire:target`.

Magewire-driven forms only

Not all Hyvä Checkout forms are Magewire forms, although the address forms are. This hook only applies to Magewire-driven forms.

Internally, Hyvä Checkout uses the `form:build:magewire` hook to add all necessary Magewire attributes. Use this hook when you need to modify or remove a Magewire attribute that was added by core.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

| Callback Parameters | Preceding | Subsequent | Associated hooks |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `AbstractForm $component` | Yes | Yes | `form:[ADDRESS_NAMESPACE]:build:magewire` |

The bare `form:build:magewire` hook no longer passes the address type as a third argument. Read it from `$component->getAddressType()` instead. The address forms still re-emit `form:[ADDRESS_NAMESPACE]:build:magewire` with `($form, $component)`.

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. The Magewire component   3. `string $addressType` (address forms only) | Yes | Yes | 1.1.0 | `form:[ADDRESS_NAMESPACE]:build:magewire` |

## `form:updated` Hook

The `form:updated` hook fires when form field values change during subsequent (non-initial) requests. In addition to the generic `form:updated` hook, address-specific hooks `form:shipping:updated` and `form:billing:updated` are available.

Use `form:updated` to alter the value of fields based on the values of other fields.

Subsequent requests only

The `form:updated` hook does not fire on the initial page load. It only triggers during subsequent Magewire requests when field values change.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `form:updated` and `form:[ADDRESS_NAMESPACE]:updated` are deprecated legacy hooks that the address forms re-emit from `form:updated:magewire` when an address field changes. For new code, listen on `form:updated:data:<path>:magewire` for one field or `form:updated:data:magewire` for any field.

| Callback Parameters | Preceding | Subsequent | Associated hooks |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `AbstractAddressForm $addressComponent` | No | Yes | `form:[ADDRESS_NAMESPACE]:updated` |

The following example auto-fills the street field from the postcode by calling an external API. Register the modifier on the billing address form (see [Entity Form Modifiers](../form-customization/entity-form-modifiers.html)) and listen for postcode changes:

```
$form->registerModificationListener(
    'applyMyBillingModifications',
    'form:updated:data:postcode:magewire',
    function (AbstractEntityForm $form, ...$rest) use ($apiCall) {
        // Get the current postcode field value.
        $postcodeValue = $form->getField('postcode')->getValue();

        // Call an external API to look up the street by postcode.
        $streetValue = $apiCall->getStreetByZipcode($postcodeValue);

        if ($streetValue) {
            $form->getField('street')->setValue($streetValue);
        }
    }
);
```

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `MagewireAddressFormInterface $addressComponent` | No | Yes | 1.1.2 | `form:[ADDRESS_NAMESPACE]:updated` |

The following example shows how to use the `form:billing:updated` hook to auto-fill a street field based on the postcode value by calling an external API:

```
$form->registerModificationListener(
    'applyMyBillingModifications',
    'form:billing:updated',
    // Leave $addressComponent untyped, so the listener also runs on Checkout 3.x.
    function (EntityFormInterface $form, $addressComponent) use ($apiCall) {
        // Get the current postcode field value.
        $postcodeValue = $form->getField('postcode')->getValue();

        // Call an external API to look up the street by postcode.
        $streetValue = $apiCall->getStreetByZipcode($postcodeValue);

        if ($streetValue) {
            $form->getField('street')->setValue($streetValue);
        }

        return $form;
    }
);
```

## `form:field:updated` Hook

The `form:field:updated` hook fires when a specific field value is updated during subsequent requests. Use `form:field:updated` to transform or validate a single field's value at the moment it changes.

Subsequent requests only

Like `form:updated`, the `form:field:updated` hook only triggers during subsequent Magewire requests, not on the initial page load.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `form:field:updated`, `form:[FIELD_ID]:updated` and `form:[ADDRESS_NAMESPACE]:[FIELD_ID]:updated` are deprecated legacy hooks that the address forms re-emit from `form:updated:data:magewire`. For new code, listen on `form:updated:data:[FIELD_ID]:magewire`.

| Callback Parameters | Preceding | Subsequent | Associated hooks |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `EntityFieldInterface $field`   3. `AbstractAddressForm $addressComponent`   4. `string $addressType` (`form:field:updated` only) | No | Yes | 1. `form:[FIELD_ID]:updated`  2. `form:[ADDRESS_NAMESPACE]:[FIELD_ID]:updated` |

The following example capitalizes the first letter of the postcode whenever it changes. Register the modifier on the shipping address form:

```
$form->registerModificationListener(
    'applyMyShippingPostcodeModifications',
    'form:updated:data:postcode:magewire',
    function (AbstractEntityForm $form, ...$rest) {
        $form->modifyField('postcode', function (EntityFieldInterface $field) {
            $field->setValue(ucfirst((string) $field->getValue()));
        });
    }
);
```

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `EntityFieldInterface $field`   3. `MagewireAddressFormInterface $addressComponent` | No | Yes | 1.1.0 | 1. `form:[FIELD_ID]:updated`  2. `form:[ADDRESS_NAMESPACE]:[FIELD_ID]:updated` |

The following example shows how to use the `form:shipping:postcode:updated` hook to capitalize the first letter of the postcode value whenever it changes:

```
$form->registerModificationListener(
    'applyMyShippingPostcodeModifications',
    'form:shipping:postcode:updated',
    // Leave $addressComponent untyped, so the listener also runs on Checkout 3.x.
    function (EntityFormInterface $form, EntityFieldInterface $field, $addressComponent) {
        $field->setValue(ucfirst($field->getValue()));

        return $form;
    }
);
```

## `form:action:edit` Hook

The `form:action:edit` hook fires when a visitor clicks the shipping or billing "Edit Address" button. Use `form:action:edit` to customize form behavior when an existing address is loaded for editing.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `form:action:edit` and `form:[FORM_NAMESPACE]:action:edit` are deprecated legacy hooks that the address forms re-emit from `form:action:edit:magewire`, with the same arguments as on Checkout 1.x. The type-scoped hook passes the component as a third argument. For new code, listen on `form:action:edit:magewire`.

| Callback Parameters | Preceding | Subsequent | Associated hooks |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `AddressInterface $address` | No | Yes | `form:[FORM_NAMESPACE]:action:edit` |

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form`   2. `AddressInterface $address` | No | Yes | 1.1.0 | `form:[FORM_NAMESPACE]:action:edit` |

## `form:action:create` Hook

The `form:action:create` hook fires when a visitor clicks a shipping or billing "New Address" button. Use `form:action:create` to customize form behavior when a blank address form is opened.

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

On Checkout 3.x, `form:action:create` and `form:[FORM_NAMESPACE]:action:create` are deprecated legacy hooks that the address forms re-emit from `form:action:create:magewire`. The type-scoped hook passes the component as a second argument. For new code, listen on `form:action:create:magewire`.

| Callback Parameters | Preceding | Subsequent | Associated hooks |
| --- | --- | --- | --- |
| 1. `EntityFormInterface $form` | No | Yes | `form:[FORM_NAMESPACE]:action:create` |

| Callback Parameters | Preceding | Subsequent | Since | Associated hooks |
| --- | --- | --- | --- | --- |
| 1. `EntityFormInterface $form` | No | Yes | 1.1.0 | `form:[FORM_NAMESPACE]:action:create` |

## Legacy Hooks on Checkout 3.x

Checkout 3.x only

This section applies to Hyvä Checkout 3.x (Magewire 3). On Checkout 1.x, the hooks in this table are the regular address form hooks described above.

`AbstractAddressForm` re-emits the Checkout 1.x address form hooks, without the `:magewire` suffix, so existing third-party modifiers keep working. Each legacy hook mirrors a modern one:

| Legacy hook | Re-emitted from | Arguments after `$form` |
| --- | --- | --- |
| `form:boot`, `form:<address_type>:boot` | `form:boot:magewire` | `$component` |
| `form:<address_type>:build:magewire` | `form:build:magewire` | `$component` |
| `form:updating` | `form:updating:magewire` (address data only) | The full form array |
| `form:updated`, `form:<address_type>:updated` | `form:updated:magewire` (address data only) | `$component` |
| `form:field:updated` | `form:updated:data:magewire` | `$field`, `$component`, `$addressType` |
| `form:<path>:updated`, `form:<address_type>:<path>:updated` | `form:updated:data:magewire` | `$field`, `$component` |
| `form:execute:<method>` | `form:trigger:magewire` | The element arguments |
| `form:action:create` | `form:action:create:magewire` | None |
| `form:<address_type>:action:create` | `form:action:create:magewire` | `$component` |
| `form:action:edit` | `form:action:edit:magewire` | `$address` |
| `form:<address_type>:action:edit` | `form:action:edit:magewire` | `$address`, `$component` |

The bare `form:build` hook isn't in this list because the entity form already dispatches it natively on both release lines. It fires once per render, so don't expect a second call. The entity form hook `form:fill` is deprecated on Checkout 3.x: it fires from many places per request, so use `form:loaded:magewire` instead.

### Listener Type Hints on Checkout 3.x

Type-hint the component argument of your listeners carefully. A listener that throws (for example with a `TypeError`) is caught and logged by `dispatchModificationHook()`, so it silently stops running.

Listeners typed on the Checkout 1.x address form classes don't run on Checkout 3.x

Leave the component parameter of your listener untyped: that works on both release lines. On Checkout 3.x, the component passed to the address form hooks is a `Hyva\Checkout\Magewire\Component\AbstractAddressForm` (`ShippingDetailsForm` or `BillingDetailsForm`). It is neither an `AbstractMagewireAddressForm` nor a `Hyva\Checkout\Magewire\Checkout\AddressView\MagewireAddressFormInterface`, so a listener with one of those parameter types fails with a `TypeError`, which the form logs and skips. Code for Checkout 3.x only can type it `AbstractAddressForm`.

Keep these points in mind when you port a Checkout 1.x listener:

- **Methods of the deprecated component are gone.** Listeners that call methods of `AbstractMagewireAddressForm`, such as `store()`, `save()`, `autosave()`, `getSaveDateTime()`, `populateAddressProperty()`, `getDifferences()` or `emitByAddressType()`, or read `$component->modal['shown']`, fail on Checkout 3.x. Use modification hooks instead.
- **Accept extra arguments.** Several `:magewire` hooks pass their extra arguments as PHP named arguments (for example `property` and `value`). On Checkout 3.x, a listener gets the arguments it declares by name and the others in parameter order, so its parameter names don't have to match the hook's. Code that also runs on Checkout 1.x keeps a trailing `...$rest`.

The following listener works on both release lines because it leaves the component untyped and accepts any extra arguments:

```
$form->registerModificationListener(
    'myShippingBootListener',
    'form:shipping:boot',
    function (EntityFormInterface $form, $addressComponent = null, ...$rest) {
        // Your modification.
    }
);
```

### Logging Deprecated Hook Usage

Checkout 3.x can log every listener that is still registered on a deprecated hook. Enable **Stores > Configuration > Hyvä Checkout > General > Developer > Shipping- & Billing Forms > Log Deprecated Form Hook Usage** (config path `hyva_themes_checkout/developer/shipping_billing_form/log_deprecated_hooks`).

When a deprecated hook with a registered listener fires, Hyvä Checkout writes a warning to `var/log/system.log` that names the listener and the hook to migrate to. The setting has no effect in production mode. The deprecated aliases of the `AbstractForm` hooks, such as `form:mount:magewire` and `form:execute:submit:magewire`, are logged in developer mode only.

## Choosing a Hook on Checkout 3.x

Checkout 3.x only

This section applies to Hyvä Checkout 3.x (Magewire 3). On Checkout 1.x, use the hooks described in the sections above.

Pick the hook by what your modifier does:

- **Build options or derive a field value from the loaded data**: `form:loaded:magewire`. It runs before the data property sync, so resolved values reach the frontend.
- **React to one field changing**: `form:updated:data:<field>:magewire`.
- **Rebuild dependent fields when a controlling field changes** (for example region options when the country changes): `form:updated:data:country_id:magewire`.
- **Adjust data or cancel before saving**: `form:submitting:magewire`.
- **Run logic after a save attempt**: `form:trigger:submit:magewire`. It also fires after a failed save, so check `$exception` to tell whether the save succeeded.
- **Add fields or elements up front**: `form:construct:magewire`.
- **Avoid** `form:fill` and `form:execute:submit:magewire`, which are deprecated.

The core region modifier (`WithRegionModifier`) combines these hooks. The following listeners build the region options on load, keep a `form:build:magewire` listener for the deprecated Checkout 1.x address form components, and rebuild the options when the country changes:

```
// Build region <select> options before the data property is synced, so the saved
// region resolves to its region_id and wire:model pre-selects it on load.
$form->registerModificationListener('applyRegionOptionsByCountryValueOnLoad', 'form:loaded:magewire',
    fn (AbstractEntityForm $form) => $this->applyRegionOptionsByCountryValue($form));

// Kept for the deprecated AbstractMagewireAddressForm components (no form:loaded:magewire). Idempotent.
$form->registerModificationListener('applyRegionOptionsByCountryValue', 'form:build:magewire',
    fn (AbstractEntityForm $form) => $this->applyRegionOptionsByCountryValue($form));

// Rebuild the options when the country changes during the request.
$form->registerModificationListener('applyRegionOptionsByCountryValueOnCountryUpdate',
    'form:updated:data:country_id:magewire',
    fn (AbstractEntityForm $form) => $this->applyRegionOptionsByCountryValue($form));
```

The complete hook reference ships with the module in `vendor/hyva-themes/magento2-hyva-checkout/src/Model/Form/EntityFormModifier/form_hooks.md`.
