<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp-example-component.html -->

# Alpine CSP example

Before we cover each difference in detail, here is an example component illustrating most differences.

```
<?php
$items = [
    ['name' => 'Foo', 'type' => 'a'],
    ['name' => 'Bar', 'type' => 'b'],
    ['name' => 'Buz', 'type' => 'c'],
    ['name' => 'Moo', 'type' => 'd'],
    ['name' => 'Qux', 'type' => 'c'],
    ['name' => 'Biz', 'type' => 'b'],
];
?>
<div x-data="exampleCspComponent"
     data-items="<?= $escaper->escapeHtmlAttr(json_encode($items))?>">
    <button type="button" class="btn" @click="toggle">Click</button>
    <span x-text="isActive"></span>
    <template x-if="isActive">
        <div>Hello</div>
    </template>
    <template x-if="isNotActive">
        <div>Bye</div>
    </template>
    <ul>
    <form>
        <label for="example">Input without x-model</label>
        <input type="text"
               id="example"
               @input="onInput"
               :value="value">
    </form>
    <template x-for="(item, index) in items">
        <li @click="registerClick" :class="listItemClasses">
            <span x-text="index">y</span>:
            <span x-text="item.name"></span>
        </li>
    </template>
    </ul>
</div>
<script>
    // Declare the function in "global" scope, so it can be customized.
    function exampleCspComponent() {
        return {
            isActive: true,
            items: [],
            value: '',
            init() {
                // Passing arguments is done via dataset attributes.
                this.items = JSON.parse(this.$root.dataset.items)
            },
            isNotActive() {
                // Transforming a value has to be done in a method.
                return ! this.isActive;
            },
            toggle() {
                // Mutations are done in methods
                this.isActive = !this.isActive;
            },
            listItemClasses() {
                // In x-for loops the vars become properties on the "this" object.
                return {
                    'border-gray-200': this.index % 2,
                    'border': this.index % 2,
                    'bg-red-500': this.item.name === 'Buz'
                }
            },
            onInput() {
                this.value = this.$event.target.value;
            },
            registerClick() {
                // Iteration context vars are preserved in method calls in Alpine CSP, just like regular Alpine.
                console.log(this.index)
            },
        };
    }
    window.addEventListener(
        'alpine:init',
        () => Alpine.data('exampleCspComponent', exampleCspComponent),
        {once: true}
    )
</script>
```
