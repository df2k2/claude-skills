<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.7.html -->

# Upgrading to 1.3.7

Hyvä Checkout `1.3.7` improves payment method initialization, Magewire component handling outside checkout, and the display of prices and shipping totals.
It also enhances checkout form styling, message handling, and theme `^1.4.0` compatibility, with an updated Magewirephp version.

Please refer to the [changelog](changelog.html#137-2025-12-02) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.7
```

Available patch

We've identified a regression that hides shipping prices on the shipping method label when tax display is set to `Excluding tax`.
This does not affect checkout functionality, but to avoid the hidden price, apply the following.
The fix will also be included in the next patch release

```
From 933ade18bf3d279bdeaf59fb557540814476a603 Mon Sep 17 00:00:00 2001
Date: Wed, 3 Dec 2025 11:17:09 +0000
Subject: [PATCH] Excluding tax price logic change.

---
.../templates/checkout/shipping/method-list.phtml      | 10 +++++++---
1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/src/view/frontend/templates/checkout/shipping/method-list.phtml b/src/view/frontend/templates/checkout/shipping/method-list.phtml
index 8958d340..454921c8 100644
--- a/src/view/frontend/templates/checkout/shipping/method-list.phtml
+++ b/src/view/frontend/templates/checkout/shipping/method-list.phtml
@@ -80,9 +80,13 @@ $methods = $viewModel->getList();
</span>
<?php endif ?>

-                                        <?php if ($method->getPriceExclTax() !== $method->getPriceInclTax()
-                                            && ($taxHelper->displayShippingPriceExcludingTax() || $taxHelper->displayShippingBothPrices())): ?>
-                                            <span class="price-excluding-tax" data-label="<?= $escaper->escapeHtmlAttr(__('Excl. Tax')) ?>">
+                                        <?php if ($taxHelper->displayShippingPriceExcludingTax()
+                                            || ($taxHelper->displayShippingBothPrices() && $method->getPriceExclTax() !== $method->getPriceInclTax())): ?>
+                                            <span class="price-excluding-tax"
+                                                <?php if ($taxHelper->displayShippingBothPrices()): ?>
+                                                    data-label="<?= $escaper->escapeHtmlAttr(__('Excl. Tax')) ?>"
+                                                <?php endif; ?>
+                                            >
                                                 <span class="price">
                                                     <?= /* @noEscape */ $formatterViewModel->currencyWithLabelingConditions($method->getPriceExclTax(), 'shipping-list-item') ?>
                                                 </span>
--
GitLab
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No deprecations

## Notable Template Changes

These templates include key frontend logic updates that must be applied during the upgrade.

- src/view/frontend/templates/page/js/api/v1/alpinejs/component-messenger.phtml
- src/view/frontend/templates/page/messenger.phtml
- src/view/frontend/templates/checkout/shipping/method-list.phtml

## Template changes

- src/view/frontend/templates/breadcrumbs/signin-register.phtml
- src/view/frontend/templates/checkout/address-view/address-list/grid.phtml
- src/view/frontend/templates/checkout/payment/method/purchaseorder.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/grand-total-tax-details.phtm
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/shipping-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/subtotal-tax-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/extension-attributes/tax-grandtotal-details.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/discount.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/grand-total.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/shipping.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/subtotal.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/tax.phtml
- src/view/frontend/templates/checkout/price-summary/total-segments/weee.phtml
- src/view/frontend/templates/checkout/price-summary/cart-items.phtml
- src/view/frontend/templates/checkout/customer-comment.phtml
- src/view/frontend/templates/checkout/shipping-summary.phtml
- src/view/frontend/templates/page/js/api/v1/init-payment.phtml
- src/view/frontend/templates/page/js/api/v1.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
