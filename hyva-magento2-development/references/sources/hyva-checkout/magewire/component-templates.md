<!-- source: https://docs.hyva.io/hyva-checkout/magewire/component-templates.html -->

# Magewire Component Templates

## Template File Naming Conventions

Magewire component templates reside in the `view/frontend/templates/magewire/` directory of your module.

Component and template names follow a matching convention. For example, a component class `My\Module\Magewire\ExampleForm` uses the template file `view/frontend/templates/magewire/example-form.phtml`.

If a block with a Magewire view model is not assigned a template, Magewire will automatically default to a template name following this naming convention.

Inside Magewire component templates, the component instance is available as the **`$magewire`** template variable. You don't need to call `$block->getData('magewire')` and assign the instance to a variable yourself.

## Single Root Element Requirement for Magewire Templates

Every Magewire component template must have exactly one root DOM element. If multiple root elements are present, Magewire won't properly update the component section after values change.

The following template is **correct** because it wraps everything in a single `<div>` root element:

```
<!-- Correct: single root <div> wrapping all content -->
<div>
    <ul>
        <?php foreach ($magewire->items as $item): ?>
        <li><?= $escaper->escapeHtml($item->getName()) ?></li>
        <?php endforeach; ?>
    </ul>
    <div>Total count: <?= (int) count($magewire->items) ?></div>
</div>
```

Invalid: Multiple Root Elements

The following template is **wrong** because it has two sibling `<div>` root elements:

```
<!-- Wrong: two root <div> elements side by side -->
<div>
    <ul>
        <?php foreach ($magewire->items as $item): ?>
        <li><?= $escaper->escapeHtml($item->getName()) ?></li>
        <?php endforeach; ?>
    </ul>
</div>
<div>
    Total count: <?= (int) count($magewire->items) ?>
</div>
```

Invalid: Leading Text as a Second Root Node

Text before the root element also counts as a root node. This template is invalid because the leading text creates a second root:

```
<!-- Wrong: leading text counts as a second root node -->
Total count: <?= (int) count($magewire->items) ?>
<div>
    <ul>
        <?php foreach ($magewire->items as $item): ?>
        <li><?= $escaper->escapeHtml($item->getName()) ?></li>
        <?php endforeach; ?>
    </ul>
</div>
```

## Rendering Magewire Component Values in Templates

Inside a Magewire template, you can interact with any methods and properties on the `$magewire` instance.

### Calling Magewire Component Methods

You can call any component method and render its return value directly in the template:

```
<div>
    <?= __('A method return value: %1', $magewire->loadSomeData()) ?>
</div>
```

### Reading Magewire Component Properties

Magewire provides several ways to read component properties in templates:

```
<div>
    <!-- Direct property access -->
    <?= __('Using direct access: %1', $magewire->myprop) ?>
</div>
<div>
    <!-- Magic getter method -->
    <?= __('Via magic getter: %1', $magewire->getMyprop()) ?>
</div>
<div>
    <!-- Magic "has" method, works like isset() -->
    <?= __('The magic "has" method, analog to isset(): %1', $magewire->hasMyprop()) ?>
</div>
```

Magewire Has No Magic Setter Methods

If you're familiar with Magento backend development, it might be surprising that Magewire provides magic `get` and `has` methods for properties, but no magic `set` method.

```
$component->setFoo($newValue); // WILL NOT WORK
```

Instead, use direct assignment:

```
$component->foo = $newValue;
```

The reason there are no magic setters is because Magewire matches the behavior of Livewire components, which also only provide magic `get` and `has` methods.

## Related Topics

- **[Introduction to Magewire Components](component-intro.html)** - Learn the basics of creating Magewire components
- **[Magewire Component Lifecycle](component-lifecycle.html)** - Understand the lifecycle hooks available in Magewire components
- **[Using Alpine.js with Magewire](alpine-js.html)** - Combine Alpine.js interactivity with Magewire components
- **[Magewire Component Interaction](component-interaction.html)** - How Magewire components communicate with each other
