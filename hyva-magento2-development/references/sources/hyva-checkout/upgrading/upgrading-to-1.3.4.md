<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.4.html -->

# Upgrading to 1.3.4

This release is a maintenance release, mostly focused on bug fixes.

Please refer to the [changelog](changelog.html#134-2025-07-16) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.4
```

Available patch

We've identified a regression that triggers an `Uncaught ReferenceError: message is not defined` error in the console.
This does not affect checkout functionality, but to avoid the console error, apply the following.
The fix will also be included in the next patch release

```
From 33b2da2c21465bb751ebaee351b6e11444ad7d0a Mon Sep 17 00:00:00 2001
Date: Thu, 17 Jul 2025 13:31:40 +0100
Subject: [PATCH] Correct component-messenger
 this.options.messagesSuccessListener

---
 .../page/js/api/v1/alpinejs/component-messenger.phtml     | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml b/src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
index ef0f26d0..77c6b635 100644
--- a/src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
+++ b/src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
@@ -60,11 +60,11 @@ use Magento\Framework\View\Element\Template;
                             this.resetMessage(message.id)
                         }
                     })
-                })

-                <?php /* Listen for a success event to provide a counterbalance, enabling the reset of the message. */ ?>
-                window.addEventListener(options.messagesSuccessListener, event => {
-                    this.resetMessage(message.id)
+                    <?php /* Listen for a success event to provide a counterbalance, enabling the reset of the message. */ ?>
+                    window.addEventListener(this.options.messagesSuccessListener, event => {
+                        this.resetMessage(message.id)
+                    })
                 })
             },

--
GitLab
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Template changes

- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml
- src/view/frontend/templates/page/js/checkout-form-telephone-validation.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items/type/default.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/grand-total-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/shipping-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/subtotal-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/discount.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/grand-total.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/shipping.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/subtotal.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/weee.phtml
- src/view/frontend/templates/form/field/select.phtml
- src/view/frontend/templates/main/place-order/redirect.phtml
- src/view/frontend/templates/checkout/address-view/address-list/list.phtml
- src/view/frontend/templates/page/js/api/v1/alpinejs/address-view/address-list.phtml

## Translation changes

### Added

- "%1 Excl. Tax","%1 Excl. Tax"
- "Back to Cart","Back to Cart"
- "Cart","Cart"
- "Checkout Main","Checkout Main"
- "Confirmation","Confirmation"
- "Discount code","Discount code"
- "Free","Free"
- "Review Your Order","Review Your Order"
- "Show all","Show all"
- "Show less","Show less"
- "You are being redirected. Please wait...","You are being redirected. Please wait..."
- "Sorry, an unexpected error occurred","Sorry, an unexpected error occurred"
- "Evaluation Malfunction","Evaluation Malfunction"
- "Force","Force"
- "Something went wrong while trying to load the checkout.","Something went wrong while trying to load the checkout."
- "Step not found.","Step not found."
- """%1"" is a required field.","""%1"" is a required field."

### Removed

We removed the admin translations from this release.

- "Automatically selects and enables the first available payment method as the default during checkout. Note: If the first payment method is initialized via JavaScript, this may cause errors in the payment process. If such errors occur, please disable this setting.","Automatically selects and enables the first available payment method as the default during checkout. Note: If the first payment method is initialized via JavaScript, this may cause errors in the payment process. If such errors occur, please disable this setting."
- "Automatically selects and enables the first available shipping method as the default during checkout. Note: If the first shipping method is initialized via JavaScript, this may cause errors in the shipping process. If such errors occur, please disable this setting.", "Automatically selects and enables the first available shipping method as the default during checkout. Note: If the first shipping method is initialized via JavaScript, this may cause errors in the shipping process. If such errors occur, please disable this setting."
- "%s is a required field.","%s is a required field."

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
