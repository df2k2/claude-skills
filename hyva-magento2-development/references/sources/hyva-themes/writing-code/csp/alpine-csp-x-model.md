<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-x-model.html -->

# Alpine CSP `x-model`

The `x-model` directive can't be used with Alpine CSP, as updating the bound property is done by creating and evaluating a JS expression.
Luckily, the workaround is rather simple. The details depend on the input type.

## For inputs with user-specified values

Any elements where the user can enter the value, that is the input types `text`, `email`, `date`, and so on.
Instead of `x-model`, we use two bindings: `:value="prop"` and `@input="setProp"`.

### Example `text` input

```
<script>
    window.addEventListener('alpine:init', () => {
        Alpine.data('initExample', () => ({
            prop: '',
            setProp() {
                this.prop = this.$event.target.value;
            }
        }))
    }, {once: true})

</script>
<form x-data="initExample">
    <input type="text" :value="prop" @input="setProp">
</form>
```

### Textarea inputs

The `textarea` is very similar to the above, except that the value is set as the element content and not an attribute:

```
<form x-data="initExample">
    <textarea @input="setProp" x-text="prop"></textarea>
</form>
```

## Radio buttons and Checkboxes

For checkbox, radio and select inputs use `@change` instead of `@input`, and instead of `:value` use `:checked="isChecked"`.

### Example `checkbox` example

```
<script>
    window.addEventListener('alpine:init', () => {
        Alpine.data('initExample', () => ({
            prop: [],
            updateSelection() {
                const checkbox = this.$event.target;
                if (checkbox.checked && ! this.prop.includes(checkbox.value)) {
                    this.prop.push(checkbox.value);
                }
                if (! checkbox.checked && this.prop.includes(checkbox.value)) {
                    this.prop.splice(this.prop.indexOf(checkbox.value), 1);
                }
            },
            isChecked() {
                return this.prop.includes(this.$el.value);
            }
        }))
    }, {once: true})
</script>
<form x-data="initExample">
    <input type="checkbox" name="example[]" value="1" @change="updateSelection" :checked="isChecked">
    <input type="checkbox" name="example[]" value="2" @change="updateSelection" :checked="isChecked">
</form>
```

## Select and multiple select inputs

Select and multiple select inputs work similarly to checkboxes, but the `selected` property on the option has to be bound instead of `checked`

```
<script>
    window.addEventListener('alpine:init', () => {
        Alpine.data('initExample', () => ({
            prop: '',
            updateSelection() {
                this.prop = this.$el.value;
            },
            isSelected() {
                return this.prop === this.item.id;
            }
        }))
    }, {once: true})
</script>
<form x-data="initExample">
    <select name="example" @change="updateSelection">
        <template x-for="item in items">
            <option value="item.id" :selected="isSelected" x-text="item.label"></option>
        </template>
    </select>
</form>
```

## `x-model` modifiers

To enforce the input to be a number, the utility method `hyva.safeParseNumber` is available - which uses the same code as the `.number` modifier in Alpine.

```
this.numericProp = hyva.safeParseNumber(this.$event.target.value);
```

At the time of writing there are no utility methods for the other `x-model` modifiers `.lazy`, `.boolean`, `.debounce`, `.throttle` and `.fill`.
