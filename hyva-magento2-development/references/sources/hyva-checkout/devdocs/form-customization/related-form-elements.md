<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/form-customization/related-form-elements.html -->

# Related Form Elements in Hyva Checkout

Form elements in Hyva Checkout can be grouped together as **related form elements**. Related form elements share a parent-child relationship where one element acts as the **ancestor** and the others are its **relatives**. By default, relatives render below their ancestor and, for fields, share a combined array value on the Magewire component. How exactly related elements are rendered depends on the ancestor field type (for example, street fields use a grid layout).

A common example is the address street field. The primary street input is the ancestor, while the second, third, and fourth street lines are relatives of that ancestor.

## Ancestor and Relative Relationships

When form element B is assigned as a relative of form element A, form element A becomes the **ancestor** of form element B. By default, form element B renders below form element A in the form layout.

Both `EntityFormElementInterface` fields and non-field form elements support the related elements pattern:

- **Fields**: The ancestor field value and all relative field values are combined into a single array on the Magewire component property. Each field value becomes one record in the array.
- **Non-field elements**: The relationship only controls rendering position. The relative element renders below its ancestor.

## Assigning and Removing Relatives

Use `assignRelative()` and `removeRelative()` on the ancestor element to manage related form element relationships.

The following example assigns `$formElementB` as a relative of `$formElementA`:

```
// Both variables are EntityFormElementInterface instances
$formElementA->assignRelative($formElementB);
```

To retrieve all relatives assigned to an ancestor element, call `getRelatives()` on the ancestor:

```
$relatives = $formElementA->getRelatives();
```

To remove a relative from its ancestor, call `removeRelative()` on the ancestor and pass the relative element:

```
$formElementA->removeRelative($formElementB);
```

## Nesting Levels for Related Elements

Related form elements can be nested more than one level deep. To determine how many ancestors a given element has, call `getLevel()` on the element:

```
$level = $element->getLevel();
```

A top-level element returns `0`. An element that is a relative of a top-level element returns `1`, and so on.

## How Ancestor Field Values Become Arrays

Ancestor field values change type when relatives are assigned

Assigning a field as a relative to an ancestor field changes the ancestor field value type from a string to an array on the Magewire component.
The ancestor field value becomes the first array item. Each relative field value follows as subsequent items in the array.

Example: address street fields

Consider the address street fields in Hyva Checkout. Depending on system configuration, the street consists of between one and four fields.
The first street input field is the ancestor. The second, third, and fourth street input fields are relatives of the first.

If the street uses a single field, the Magewire component `address.street` property is a string.
If the street uses two or more fields, `address.street` becomes an array.

To validate or style the street lines individually, see [Validating and Styling Street Address Lines](street-address-lines.html).

## Restrictions on Changing Related Element Relationships

Do not change element relationships in `form:build:magewire` callbacks

The `form:build:magewire` hook fires after the form structure has been finalized. Changing the element hierarchy inside `form:build:magewire` callbacks causes unwanted effects such as fields rendering twice.

Modify related element relationships only in earlier form build hooks, before the form structure is finalized.

Use `assignRelative()` and `removeRelative()` instead of direct ancestor methods

The `EntityFormElementInterface` also exposes `assignAncestor(EntityFormElementInterface $ancestor)` and `removeAncestor()` for direct ancestor manipulation. However, calling these methods directly can leave the form field hierarchy in an inconsistent state.

Always prefer `assignRelative()` and `removeRelative()` on the ancestor element, as these methods keep all related properties consistent.
