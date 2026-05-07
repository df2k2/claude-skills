<!-- source: https://docs.hyva.io/hyva-checkout/magewire/form-components.html -->

# Magewire Form Components and Validation

Forms are one of the most important types of interaction on websites, and Magewire makes them straightforward.
With Magewire form components, input element values are mapped directly to Magewire component properties.

One of the big wins here: you don't have to duplicate validation rules on the front end using JavaScript and again in the backend using PHP.
With Magewire, you declare validation rules once in the PHP component, and they still get applied on the front end in an interactive way.

Under the hood, Magewire uses the [rakit/validation](https://github.com/rakit/validation) library to apply validation rules to properties. This section gives you everything you need to get started with Magewire form validation.

## Magewire Form Component Base Class

Magewire form components extend `\Magewirephp\Magewire\Component\Form` instead of the regular `\Magewirephp\Magewire\Component`.

The `Form` base class provides the ability to declare validation rules for component properties, handle validation errors, and display failure messages.

## Declaring Validation Rules on a Magewire Form Component

Validation rules are declared on the Magewire form component using a `protected $rules` array property.
The `$rules` array maps property names to their validation rule strings.

The following example shows a Magewire form component with three properties and their corresponding validation rules:

```
class MyComponent extends \Magewirephp\Magewire\Component\Form
{
    // Public properties bound to form input elements via wire:model
    public $email;
    public $userName;
    public $vatId;

    // Validation rules map: property name => pipe-separated rule string
    protected $rules = [
        'email'    => 'required|email',
        'userName' => 'required|min:4',
        'vatId'    => 'required|regex:/^(?:NL)?[a-z0-9]{9}B[a-z0-9]{2}$/i',
    ];
}
```

You can find a [list of all available validation rules](https://github.com/rakit/validation#available-rules) in the rakit/validation readme file.

## Triggering Magewire Property Validation

Declaring validation rules alone is not enough. You need to call the `validate()` method to actually trigger the validation.

When to call `validate()` depends on the use case. Here are the two most common approaches.

### Validating Properties Immediately After Change

If properties should be validated right after they change, call `validate()` in one of the `updated` lifecycle hook methods:

```
// Validate all properties whenever any property changes
public function updated($value, $prop)
{
    $this->validate();
    return $value;
}
```

### Validating Properties on Form Submission

If validation should happen when a form is submitted, call `validate()` in a custom `save` method on the Magewire component:

```
// Validate all properties when the form is submitted
public function save()
{
    $this->validate();

    // Only reached if all validation rules pass
    $this->repository->save($this);
}
```

How Magewire validation works under the hood

If a rule does not pass, the `validate()` method throws a `Magewirephp\Magewire\Exception\AcceptableException`.

These exceptions are special - they do not break the Magewire component lifecycle. However, they will abort the method that triggered `validate()`.

## Displaying Magewire Validation Error Messages

Magewire validation failure messages are not shown automatically. You need to add the display code to your templates wherever the messages should appear.

For the best user experience, display validation error messages next to the corresponding input element. The `$magewire->hasError()` and `$magewire->getError()` methods let you conditionally render error messages per field:

```
<form>
    <!-- Check if the 'name' property has a validation error -->
    <input type="text" wire:model="name"
        <?php if ($magewire->hasError('name')): ?>
        aria-invalid="true" aria-errormessage="name-error"
        <?php endif ?>
    >

    <!-- Display the validation error message for 'name' -->
    <?php if ($magewire->hasError('name')): ?>
    <span class="text-red-800" id="name-error">
        <?= $escaper->escapeHtml($magewire->getError('name')) ?>
    </span>
    <?php endif ?>
</form>
```

If you need to display all validation messages combined in one location, use the `$magewire->getErrors()` method. It returns all failure messages as an array.

## Customizing Magewire Validation Failure Messages

Each validation rule comes with a default failure message. You can customize these messages by providing alternatives in the `protected $messages` array property on the Magewire form component.

The `$messages` array maps a combination of attribute name and rule ID to a custom message string. For example, to customize the message when no value is provided for the required `vatId` field, use the key `vatId:required`.

You can include dynamic placeholders in custom messages:

- `:value` - replaced with the current invalid value
- `:attribute` - replaced with the property name

The following example shows custom failure messages for the `vatId` property:

```
// Validation rules for the VAT ID field
protected $rules = [
    'vatId' => 'required|regex:/^[a-z0-9]+$/i',
];

// Custom failure messages: 'property:rule' => message string
protected $messages = [
    'vatId:required' => (string) __('Please specify a valid EU VAT ID to proceed'),
    'vatId:regex'    => (string) __('":value" is not a valid EU VAT ID'),
];
```

You can use the regular Magento translation function `__()` to localize error messages, as shown in the example above.

## Related Topics

- **[Magewire Overview](index.html)** - Introduction to Magewire and how it works in Hyvä Checkout
