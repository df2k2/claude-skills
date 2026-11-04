<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/hyva-svg-icon-modules/payment-icons.html -->

# Hyvä Payment Icons

Our custom icon pack adds payment logos to display in your store, showcasing the payment options your store supports.

## Installation

Install the package via:

```
composer require hyva-themes/magento2-payment-icons
bin/magento setup:upgrade
```

*This icon pack requires a Hyvä theme license to use.*

## How to use

Usage example:

```
<?php

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\PaymentIcons\ViewModel\PaymentIconsClean;

/** @var ViewModelRegistry $viewModels */

/** @var PaymentIconsClean $paymentIcons */
$paymentIcons = $viewModels->require(PaymentIconsClean::class);
```

and use the PaymentIcons just as the LucideIcons in your phtml:

```
<?= $paymentIcons->paypalHtml('', 48, 32, ["aria-label" => "Pay with PayPal"]) ?>
```

### Using SVG icons in CMS content

The icons can also be rendered in CMS content, using the `{{icon}}` directive.

Find the path of the SVG inside `view/frontend/web/svg`, and remove the `.svg` at the end.

For instance, `view/frontend/web/svg/payment-icons/clean/paypal.svg` can be used as `payment-icons/clean/paypal`.

Usage example in CMS pages:

```
{{icon "payment-icons/clean/paypal" classes="inline-block" width=48 height=32 title="Pay with PayPal"}}
```

### Extend and Customization

Please refer to the Hyvä Docs for information about [SvgIcon usage in Hyvä Themes](../../writing-code/working-with-view-models/svgicons.html).

## Available icons

There are currently 5 implementations: **Clean**, **Light**, **Dark**, **Mono** and **Outline**.

The available icon render methods can be found at `src/ViewModel/PaymentIconsInterface.php`,
but they will also autocomplete in your editor (if php intellisense is supported by your editor).

List of Available Payment logos in each Icon Style
affirm • afterpay • algorand • alipay • alma • amazon-pay-2 • amazon-pay • american-express-2 • american-express • apple-pay • atome • atone • au-pay • bancomat • bancontact • bankaxept • belfius • billie • bitcoin • bitpay • blik • boleto • boost-wallet • cartes-bancaires • cash-app • clearpay • click-to-pay • creditcard • dankort • dash • diners-club • discover • divido • eftpos • elo • eps • ethereum • famipay • fonix • forbrugsforeningen • fpx • gcash • giropay • google-pay • gopay • grabpay • hiper • hipercard • ideal • ideal-wero • in3 • interac • invoice • iwocapay • jcb • kakao • kbc • klarna • korean-cards • kriya • line-pay • link • litecoin • mastercard-securecode • mastercard • merpay • mobilepay • mondu • monero • naver-pay • nexi-pay • octopus • oney • oxxo • paidy • payco • payconiq • payment-on-delivery • paynow • paypal-2 • paypal • paypay • paypo • paysafecard • picpay • pix • planpay • pledg • postepay • postfinance • prepayment • przelewy24 • rakuten-pay • reown • revolut-pay • ripple • riverty • sage-pay • samsung-pay • satispay • scalapay • sepa • sodexo • sofort • spei • swish • touch-n-go • troy • truelayer • trustly • twint • uatp • unionpay • venmo • vipps • visa-secure • visa • vpay • walley • wechat-pay • wero • western-union • yoco • younited • zapper • zip

## Figma

We also provide a Figma file containing each payment icon. Check it out on our [Figma Page](https://www.figma.com/@hyva).
