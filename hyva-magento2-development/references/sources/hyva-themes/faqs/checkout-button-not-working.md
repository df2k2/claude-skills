<!-- source: https://docs.hyva.io/hyva-themes/faqs/checkout-button-not-working.html -->

# Checkout Button not working

If the checkout button is not working in the cart or the mini-cart, the reason is probably that the `authentication-popup` block was removed from the header-content.

## How does the checkout button work?

Clicking the checkout buttons dispatches an event `toggle-authentication`, which is processed by the `authentication-popup` block template.

The `Magento_Customer/templates/account/authentication-popup.phtml` template triggers a login form before redirecting to the cart if guest checkout is disabled.

The `authentication-popup` block is declared in `Magento_Customer/layout/default.xml`

```
<block class="Magento\Customer\Block\Account\Customer" name="authentication-popup"
       as="authentication-popup"
       template="Magento_Customer::account/authentication-popup.phtml"/>
```

The `authentication-popup` template is rendered by the parent template `Magento_Theme/templates/html/header.phtml`.

## How do I find out if I'm missing the `authentication-popup`?

To check if the `authentication-popup` block is missing, compare the `Magento_Theme/templates/html/header.phtml` template in your theme to the original at

```
vendor/hyva-themes/magento2-default-theme/Magento_Theme/templates/html/header.phtml
```

The template in your theme is probably missing the line

```
<?= $block->getChildHtml('authentication-popup'); ?>
```
