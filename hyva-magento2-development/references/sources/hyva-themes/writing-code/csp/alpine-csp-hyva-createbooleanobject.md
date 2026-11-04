<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-hyva-createbooleanobject.html -->

# Alpine CSP boolean components

A common use case for Alpine components is to control the visibility of a UI element, for example, modal dialogs, accordions, tooltips, and such.
These are very convenient with regular Alpine, but with Alpine CSP they require more boilerplate code to set and toggle the property.
Because they are so common, Hyvä provides a utility method `hyva.createBooleanObject`.

```
hyva.createBooleanObject(name, value = false, additionalMethods = {})
```

This method provides an object that can be used for such cases.
It takes up to three arguments:

- `name`: the name of the property, for example, "hidden", "open", "active" - whatever suits your component.
- `value`: the initial value of the property, `true` or `false`. If not specified, it defaults to `false`.
- `additionalMethods`: this optional object will be merged into the returned result. It can be used to extend the boolean object with custom methods.

## Creating a boolean object

The boolean object provides methods matching the property to access the component state.
For example, if the property name `hidden` is used, the state can be accessed with `hidden` and `notHidden`.

```
<script>
  Alpine.data('example', () => hyva.createBooleanObject('hidden', true))
</script>
<div x-data="example">
    <template x-if="hidden">
        <div>Show if hidden</div>
    </template>
    <template x-if="notHidden">
        <div>Show if visible</div>
    </template>
    <input type="checkbox" :checked="!hidden" @change="toggleHidden" />
*  </div>
```

Use *notHidden* instead of *!hidden*

For your code to be compatible with both, the CSP and the non-CSP version of Alpine, use `notHidden`.
The deprecated `!hidden` expression will work in the CSP version, but will not work in the non-CSP version.

The code is evaluated differently in Alpine CSP and non-CSP. Therefore we recommend using only the **notHidden** version.

## Changing a boolean state

There also are three additional methods to set the state of the property.
Replace "Name" with your property name.

- `toggleName`: flips the state
- `setNameTrue`: set the state to `true`
- `setNameFalse`: set the state to `false`

## CamelCasing values

If the property name contains underscores, the setters, and the toggle methods will use CamelCase.

For example, `hyva.createBooleanObject('is_hidden')`, will result in the method names

- `is_hidden`
- `notIsHidden`
- `toggleIsHidden`,
- `setIsHiddenTrue`, and
- `setIsHiddenFalse`

## Examples

### Example `hidden` component

```
hyva.createBooleanObject('hidden', true)
// results in
{
    hidden(): true,
    notHidden(): false,
    toggleHidden(),
    setHiddenTrue(),
    setHiddenFalse()
}
```

### Example `visible` component

This is like the previous one, except only the property name is specified. The default initial value is `false`.

```
hyva.createBooleanObject('visible')
// results in
{
    visible(): false,
    notVisible(): true,
    toggleVisible(),
    setVisibleTrue(),
    setVisibleFalse()
}
```

### Example `text` or `password` switcher

This is an example of specifying additional methods.

```
hyva.createBooleanObject('showPassword', false, {textOrPassword() {return !this.showPassword() ? 'text' : 'password'}})
```

The custom method could be used on an input field: `<input type="password" :type="textOrPassword">`

### Example class bindings

The custom method `cardClasses` returns a class-map depending on the state of the object.

```
hyva.createBooleanObject('hidden', false, {cardClasses() {return {'hidden': this.hidden()}}})
```

It could be used like this: `<div :class="cardClasses">`

### Example computing text of an element

Another common scenario is switching labels based on the state of the component:

```
hyva.createBooleanObject('password', false, {
    innerText() {
        return !this.password()
          ? '<?= __('Show password') ?>'
          : '<?= __('Hide password') ?>'
        }
})
```

This could be used as the label on a button: `<button type="button" x-text="innerText">`
