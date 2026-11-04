<!-- source: https://docs.hyva.io/hyva-checkout/faq/what-is-v1bc.html -->

# What Is the v1bc Module in Hyvä Checkout?

The v1bc module keeps the checkout extensions and customizations you already have working on Hyvä Checkout 3.x in almost all cases. Hyvä Checkout 3.x installs it for you, so there's nothing to install, configure or decide. Despite its technical name, v1bc is a regular, supported part of Hyvä Checkout 3.x, not a beta and not a leftover.

## What the Name v1bc Means

"v1bc" is short for "Magewire **v**ersion **1** **b**ackward **c**ompatibility". Magewire is the library that lets Hyvä Checkout update parts of the page, such as the shipping methods and the totals, without reloading it.

Hyvä Checkout 1.x is built on Magewire 1, and Hyvä Checkout 3.x is built on Magewire 3. Extensions written for Checkout 1.x, such as many payment and shipping integrations, expect Magewire 1. The v1bc module lets most of them run on Checkout 3.x without changes, next to code written for Magewire 3.

You'll see the module under these names:

- `hyva-themes/magento2-hyva-checkout-v1bc` in `composer.json` and `composer.lock`
- `Hyva_CheckoutV1bc` in `app/etc/config.php` and in the output of `bin/magento module:status`

## Do I Need to Do Anything About the v1bc Module?

No. Keep the v1bc module enabled. Stores on Hyvä Checkout 1.x don't have it: it comes with Checkout 3.x.

After upgrading to Checkout 3.x, have your developers test the checkout extensions on a staging environment, see [After the Upgrade](../upgrading/upgrading-to-3.0.0.html#after-the-upgrade).

Once none of the store's extensions and customizations need Magewire 1 anymore, your developers can disable the module. [Disabling the v1bc Module](../magewire/v1bc.html#disabling-the-v1bc-module) lists what they check first. The module stays installed even then, because Hyvä Checkout 3.x requires it.

## Related Topics

- **[The Magewire 1 Backward Compatibility Module (v1bc)](../magewire/v1bc.html)** - the developer reference: what v1bc covers, its known differences, and disabling it
- **[Hyvä Checkout Release Lines and Magewire Versions](../getting-started/release-lines.html)** - Checkout 1.x and 3.x, and how to find out which one your store runs
