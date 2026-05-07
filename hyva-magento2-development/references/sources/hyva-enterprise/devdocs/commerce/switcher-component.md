<!-- source: https://docs.hyva.io/hyva-enterprise/devdocs/commerce/switcher-component.html -->

# Switcher Component

Available in `Hyva_Enterprise` since 1.0.7

In an attempt to both simplify and unify the various action switchers available to customers throughout Adobe Commerce,
the `Hyva_Enterprise` module now contains an abstract implementation that aims to make adding, editing, and removing
actions from these action lists as easy as possible. The purpose of this document is to provide an overview of how the
component works and highlight an example implementation from our own codebase.

For reference, the switcher component template can be found in `Hyva_Enterprise::form/actions/switcher.phtml` and the
various code snippets included in this document come directly from our `Magento_NegotiableQuote` compatibility module.

## Reference

In short; a switcher is simply a container for a set of actions and is responsible for orchestrating both the rendering
and invocation of their business logic. In order to be presented as part of a switcher, an action must
[register](#registration) itself with that switcher - providing a callback function to execute when the action is selected by the customer.

### Switcher Layout XML

You can use layout XML to add a new action switcher component. No special block class is required - simply assign the
`Hyva_Enterprise::form/actions/switcher.phtml` template and provide the necessary arguments.

```
<block name="quote_items.mass_actions.switcher"
       template="Hyva_Enterprise::form/actions/switcher.phtml">
    <arguments>
        <argument name="switcher_name" xsi:type="string">quoteItems</argument>
        <argument name="target_element_id" xsi:type="string">form-quote-items-update</argument>
        <argument name="item_selector" xsi:type="string">input[type="checkbox"][name^="quote-item-"]:checked</argument>
    </arguments>
</block>
```

#### Arguments

Arguments marked with an asterisk (`*`) are required.

##### switcher\_name \*

The name of your action switcher. This value is used to help differentiate *this* switcher from others on the same page.
The value of this argument is used to:

- Prefix the component name
- Prefix the components [`x-ref`](https://alpinejs.dev/directives/ref) directive
- Define a switcher-specific event listener

##### target\_element\_id

The `id` of the element associated with the switcher. This is typically going to be a `<form>` but can be anything
containing a set of elements you're interested in performing actions with.

##### item\_selector

A [query selector](https://developer.mozilla.org/en-US/docs/Web/API/Document/querySelector) that can be applied to the
[target element](#target_element_id) in order to fetch the subset of elements your actions will be interested in.

##### label

The value of this argument is output as a label above the switcher and is parsed by the translation function.

### Actions Layout XML

Layout XML is also used to add, edit, and remove the various actions housed within the switcher. Each action block must
be assigned a template which houses the logic to invoke when applying the associated action.

```
<block name="quote_items.mass_actions.switcher"
       template="Hyva_Enterprise::form/actions/switcher.phtml">
    <arguments>...</arguments>

    <block name="quote_items.mass_actions.remove"
           template="Hyva_MagentoNegotiableQuote::quote/item/actions/mass/remove.phtml">
        <arguments>
            <argument name="action_name" xsi:type="string">removeItems</argument>
        </arguments>
    </block>
</block>
```

#### Arguments

Arguments marked with an asterisk (`*`) are required.

##### action\_name \*

The name of your action. The value of this argument is used to both register and execute the action callback function.

### Registration

There are two ways for an action to register itself with a switcher - either directly as a child of the switcher or
indirectly through the dispatching of a JavaScript event. When registering an action you must provide its name and a
callback function. The callback function will automatically receive the following data:

- `targetElement`
  - The HTML element associated with the ID provided by the switcher `<block>`s `target_element_id` layout argument
- `items`
  - The subset of HTML elements obtained by the switcher `<block>`s `item_selector` layout argument
    i.e. `targetElement.querySelectorAll(item_selector)`

#### Self-Registering Children

Because actions added as children of the switcher automatically inherit its properties and functions, they can be
registered using the `registerAction(name, callback)` function by defining themselves as their own Alpine component and
using the [`x-init`](https://alpinejs.dev/directives/init) directive to perform this registration.

```
<div x-data="actionComponentFoo"
     x-init="init">
    <?= $escaper->escapeHtml(__('Foo')); ?>
</div>
<script>
    'use strict';

    function actionComponentFoo()
    {
        return {
            init()
            {
                this.registerAction('foo', (targetElement, items) => {
                    ...
                });
            },
        }
    }
</script>
```

#### External Registration

Each switcher has an event listener that can be used in order to register an action. This event name follows the pattern
`register-{{switcher_name}}-action` where `{{switcher_name}}` is the value of the switcher `<block>`s layout XML
argument of the same name.

Info

Because HTML attributes do not support camelCasing, the event name will always be lowercase regardless of the
capitalisation used in the `switcher_name` argument e.g. `fooSwitcher` becomes `fooswitcher`.

```
window.dispatchEvent(new CustomEvent(
    'register-fooswitcher-action',
    {
        detail: {
            name: 'foo',
            callback: (targetElement, items) => { ... },
        },
    }
));
```

### Execution

Similarly to [action registration](#registration), there are also two ways for an actions callback function to be
executed by the switcher. Executing [self-registered](#self-registering-children) actions is taken care of automatically
by a click handler attached to the containing element of each action in the switcher.

#### External Execution

Each switcher has an event listener that can be used in order to execute an action, provided it has previously been
registered. This event name follows the pattern `execute-{{switcher_name}}-action` where `{{switcher_name}}` is the
value of the switcher `<block>`s layout XML argument of the same name.

Info

Because HTML attributes do not support camelCasing, the event name will always be lowercase regardless of the
capitalisation used in the `switcher_name` argument e.g. `fooSwitcher` becomes `fooswitcher`.

```
window.dispatchEvent(new CustomEvent(
    'execute-fooswitcher-action',
    {
        detail: {
            name: 'foo',
        },
    }
));
```

### Modals

Modals are commonly displayed in response to selecting an action, often to surface an error message or warning, so, for
the convenience of developers implementing actions, the switcher component is
[merged with the `hyva.modal()` view utility](../../../hyva-themes/view-utilities/modal-dialogs/index.html#merge-hyvamodal-with-your-code)
to ensure it is available to them by default.

### Removing Actions

Because actions are added as [children of the switcher via layout XML](#actions-layout-xml), removing an action from a
switcher can be done using the `remove` directive.

```
<referenceBlock name="quote_items.mass_actions.remove" remove="true"/>
```
