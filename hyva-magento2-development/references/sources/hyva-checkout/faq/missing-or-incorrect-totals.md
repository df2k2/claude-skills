<!-- source: https://docs.hyva.io/hyva-checkout/faq/missing-or-incorrect-totals.html -->

# Missing or Incorrect Totals in Hyvä Checkout

## Custom Total Segments Displaying Incorrect Totals

Hyvä Checkout may display inaccurate or incomplete totals when custom total segments are in use, such as those added by the Gift Card feature in Adobe Commerce.

To address this, Hyvä Checkout [version 1.1.23](../upgrading/upgrading-to-1.1.23.html) introduced a configuration option that recollects quote totals when total segments are retrieved. You can find this setting in the Magento admin at `Stores -> Settings -> Configuration -> Hyvä Themes -> Hyvä Checkout -> Developer -> Fixes & Workarounds -> Collect Totals During Segment Retrieval`. The option is enabled by default.

Caution

Recollecting totals multiple times during the same request may cause issues. If your installation contains customizations that recollect totals elsewhere, consider disabling this option in the admin to avoid unexpected behavior.

## Magento 2.4.3-p3 Missing or Incorrect Shipping Totals

This issue could only be reproduced in Magento `2.4.3-p3` and below.

In Magento `2.4.3-p3`, there is a known bug where shipping totals do not update correctly in Hyvä Checkout. The root cause is an inconsistency in how Magento collects totals during segment retrieval.

### Shipping Totals Bug Behavior in Magento 2.4.3-p3

The shipping totals fail to update unless the following configuration value is set to `Off`:

- `Hyvä Checkout > Experimental > Fixes & Workarounds > Collect Totals During Segment Retrieval`

When this setting is turned off, refreshing the checkout page causes the selected shipping method to reset to the previously selected option instead of keeping the current selection.

Shipping totals should update dynamically regardless of this configuration setting. The patch below fixes this by saving the quote with collected totals directly rather than relying on the shipping method management API.

To manually apply the fix, use the following patch for `Magewire/Checkout/Shipping/MethodList.php`:

```
--- a/src/Magewire/Checkout/Shipping/MethodList.php
+++ b/src/Magewire/Checkout/Shipping/MethodList.php
@@ -10,6 +10,7 @@ declare(strict_types=1);

 namespace Hyva\Checkout\Magewire\Checkout\Shipping;

+use Exception;
 use Hyva\Checkout\Model\Magewire\Component\EvaluationInterface;
 use Hyva\Checkout\Model\Magewire\Component\EvaluationResultFactory;
 use Hyva\Checkout\Model\Magewire\Component\EvaluationResultInterface;
@@ -19,6 +20,7 @@ use Hyva\Checkout\Exception\CheckoutException;
 use Magento\Framework\Exception\NoSuchEntityException;
 use Magento\Framework\Exception\StateException;
 use Magento\Quote\Api\CartRepositoryInterface;
+use Magento\Quote\Model\ResourceModel\Quote;
 use Magento\Quote\Model\ShippingMethodManagementInterface;
 use Magewirephp\Magewire\Component;
 use Psr\Log\LoggerInterface;
@@ -40,17 +42,20 @@ class MethodList extends Component implements EvaluationInterface
     protected CartRepositoryInterface $quoteRepository;
     protected ShippingMethodManagementInterface $shippingMethodManagement;
     protected LoggerInterface $logger;
+    protected Quote $quoteResourceModel;

     public function __construct(
         SessionCheckout $sessionCheckout,
         CartRepositoryInterface $quoteRepository,
         ShippingMethodManagementInterface $shippingMethodManagement,
-        LoggerInterface $logger
+        LoggerInterface $logger,
+        Quote $quoteResource
     ) {
         $this->sessionCheckout = $sessionCheckout;
         $this->quoteRepository = $quoteRepository;
         $this->shippingMethodManagement = $shippingMethodManagement;
         $this->logger = $logger;
+        $this->quoteResourceModel = $quoteResource;
     }

     public function boot(): void
@@ -76,14 +81,15 @@ class MethodList extends Component implements EvaluationInterface
             if ($rate === false) {
                 throw new CheckoutException(__('Invalid shipping method'));
             }
-            if ($this->shippingMethodManagement->set($quote->getId(), $rate->getCarrier(), $rate->getMethod())) {
-                $this->dispatchBrowserEvent('checkout:shipping:method-activate', ['method' => $value]);
-                $this->emit('shipping_method_selected');
-            }
-        } catch (CheckoutException $exception) {
-            $this->dispatchErrorMessage($exception->getMessage());
-        } catch (LocalizedException $exception) {
+
+            $shippingAddress->setShippingMethod($rate->getCode());
+            $this->quoteResourceModel->save($quote->collectTotals());
+
+            $this->dispatchBrowserEvent('checkout:shipping:method-activate', ['method' => $value]);
+            $this->emit('shipping_method_selected');
+        } catch (CheckoutException|Exception $exception) {
             $this->dispatchErrorMessage('Something went wrong while saving your shipping preferences.');
+            $this->logger->error($exception->getMessage());
         }

         return $value;
```
