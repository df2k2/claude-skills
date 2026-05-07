<!-- source: https://docs.hyva.io/hyva-checkout/magewire/index.html -->

# What is Magewire?

Magewire is a port of the popular [Laravel Livewire](https://laravel-livewire.com/) library to Magento. It lets you interact with PHP class properties and methods directly from the browser - no custom JavaScript or PHP glue code needed. Magewire powers the interactive components in Hyvä Checkout.

This section teaches you just enough about Magewire to get started building and customizing Hyvä Checkout components. For deeper coverage, check out the [Magewire documentation on GitHub](https://github.com/magewirephp/magewire/blob/main/docs/Features.md), and once you're comfortable with the basics, the [Livewire API Reference](https://laravel-livewire.com/docs/2.x/reference) is a great companion resource.

Magewire is installed as a dependency of Hyvä Checkout

You don't need to install Magewire separately. Composer pulls it in automatically when you install Hyvä Checkout.

See the [Hyvä Checkout installation instructions](../getting-started/index.html) for details.

## Declaring a Magewire Component in Magento Layout XML

Any Magento block can become a Magewire component by adding a block argument named `magewire` in layout XML. If you've worked with Magento PHP ViewModels before, this pattern will feel familiar - it's the same approach for injecting an object instance into a block.

The following layout XML example turns a block into a Magewire component by declaring the `magewire` argument with a PHP class reference:

```
<!-- Declaring a Magewire component in Magento layout XML -->
<block name="checkout.shipping-details" template="Hyva_Checkout::component/shipping-details.phtml">
    <arguments>
        <!-- The argument name "magewire" is the key that activates the Magewire library -->
        <argument name="magewire" xsi:type="object">
            \Hyva\Checkout\Magewire\ShippingDetails
        </argument>
    </arguments>
</block>
```

The special argument name `magewire` is what tells the Magewire library to treat this block's view model as a Magewire component. This `magewire` view model is the PHP class that the front end can interact with.

To render values in the HTML page, the `.phtml` template calls view model methods as usual. The difference is that Magewire adds a special binding syntax that lets the browser call methods on the PHP view model via Ajax. Those method calls can update the view model's properties, and Magewire re-renders the template to update the page automatically.

## How Magewire Works Under the Hood

When Magento renders a block that has a `magewire` view model, the Magewire library adds a few extra HTML attributes to the block's output. The front-end Magewire JavaScript library uses these attributes to initialize a JavaScript object for each Magewire component on the page.

When a visitor interacts with a Magewire component (clicking a button, filling in a field), the JavaScript object sends an Ajax request back to the server. The server invokes the specified view model methods and properties, re-renders the block's template, and sends the updated HTML back to the browser.

### Magewire Request Lifecycle and Hooks

During this process, Magewire calls lifecycle hook methods on components (if they are defined). Magewire also provides ways to send messages between components and other useful utilities.

The Magewire library distinguishes between two types of requests:

- **Preceding request** - The initial HTTP request during which a Magewire component is rendered for the first time.
- **Subsequent request** - Any follow-up request triggered by Magewire after a visitor interacts with a component on the page.

Explore the Livewire API Reference

Once you're familiar with Magewire basics, the [Livewire API Reference](https://laravel-livewire.com/docs/2.x/reference) is a handy resource for looking up available methods, properties, and lifecycle hooks.

## Related Topics

- **[Magewire Features Documentation](https://github.com/magewirephp/magewire/blob/main/docs/Features.md)** - Full Magewire feature reference on GitHub
- **[Hyvä Checkout Installation](../getting-started/index.html)** - Getting Hyvä Checkout (and Magewire) installed
