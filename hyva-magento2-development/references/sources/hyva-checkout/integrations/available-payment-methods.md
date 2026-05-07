<!-- source: https://docs.hyva.io/hyva-checkout/integrations/available-payment-methods.html -->

# Payment Integrations for Hyvä Checkout

Hyvä Checkout supports a wide range of payment providers through compatibility modules maintained by the Hyvä team, PSPs, and community contributors. This page lists tracked payment integrations with links to their repositories and integration tracker tickets.

- **Full feature overview**: [Checkout Feature Matrix](https://www.hyva.io/hyva-checkout-feature-matrix)
- **Live status tracking**: [Checkout integration tracker board](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/boards/87)

Who provides support?

Each integration tracker ticket is labeled `Vendor` or `Community` to indicate who is responsible for the implementation and first-line support. For most integrations, reach out to the payment provider or integration developer first. The Hyvä team is happy to help connect you with the right contact if needed.

Each payment method has a compatibility module repository. These repositories are often hosted by PSPs or extension developers, and sometimes by Hyvä directly. Repository addresses are listed on the integration tracker ticket descriptions.

If you are building a new Hyvä Checkout payment integration, see the [payment integration developer documentation](../devdocs/payments/payment-introduction.html) for guidance on developing compatibility modules.

## Available Payment Integrations

The following payment methods have tracked Hyvä Checkout integrations. Methods marked **CSP compatible** work with Magento's Content Security Policy restrictions enabled.

### Payment Services for Adobe Commerce and Magento Open Source

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/546)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-adobe-payments
bin/magento setup:upgrade
```

### Adyen (versions 10.x)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/10)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-adyen-payment-v2
bin/magento setup:upgrade
```

### Authorize.net

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/20)
- [Compatibility module repository](https://github.com/ParadoxLabs-Inc/authnetcim-hyva-checkout)

### Braintree

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/9)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-braintree
bin/magento setup:upgrade
```

### Brippo Stripe Integration

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/623)
- [Compatibility module repository](https://docs.brippo.com/#configure-checkout)

### Buckaroo

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/19)
- [Compatibility module repository](https://github.com/buckaroo-it/Magento2_Hyva_Checkout)

### Cardstream

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/600)
- [Compatibility module repository](https://github.com/magebitcom/magento2-hyva-checkout-cardstream-payment)

### Checkout.com

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/604)
- [Compatibility module repository](https://github.com/magebitcom/magento2-hyva-checkout-checkoutcom-payment)

### CodeCave EAN

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/582)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-codecave-ean
bin/magento setup:upgrade
```

### EcommPay (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/577)
- [Compatibility module repository](https://github.com/ITECOMMPAY/hyva-magento)

### ESTO Payments (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/650)
- Available on contact

### Frisbii Pay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/673)

Installation

```
composer require radarsofthouse/magento2-hyva-checkout-frisbii-pay
bin/magento setup:upgrade
```

### HiPay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/622)
- [Compatibility module repository](https://github.com/hipay/hipay-enterprise-magento2-hyva)

### Klarna (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/12)

Installation

```
composer require hyva-themes/magento2-klarna-kp
bin/magento setup:upgrade
```

### Lyra Payments

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/678)
- [Compatibility module repository](https://docs.lyra.com/en/collect/plugins/hyva/prerequisites.html)

Installation

```
composer require lyranetwork/magento2-hyva-checkout-lyra
bin/magento setup:upgrade
```

### Mollie (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/2)
- [Compatibility module repository](https://github.com/mollie/magento2-hyva-checkout)

### Mondu Payments (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/86)
- [Compatibility module repository](https://github.com/mondu-ai/magento2-hyva-checkout)

Installation

```
composer require mondu/magento2-hyva-payment
bin/magento setup:upgrade
```

### MultiSafepay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/3)
- [Compatibility module repository](https://github.com/MultiSafepay/magewire-checkout/)

### Nexi XPay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/595)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-iplusservice-x-pay
bin/magento setup:upgrade
```

### Novalnet (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/659)
- [Compatibility module repository](https://github.com/Novalnet-AG/Magento2-Hyva-Checkout-Integration-By-Novalnet)

Installation

```
composer require novalnet/hyva-checkout
bin/magento setup:upgrade
```

### Pay.nl

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/14)
- [Compatibility module repository](https://github.com/paynl/magento2-hyva-checkout)

### Payever

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/592)
- [Compatibility module repository](https://commercemarketplace.adobe.com/payever-magento2-payments.html)

### Payone

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/7)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-payone
bin/magento setup:upgrade
```

### PayPal (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/1)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-paypal
bin/magento setup:upgrade
```

### PayPo - Delayed Payment Method for the Polish Market

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/550)
- [Compatibility module repository](https://github.com/SnowdogApps/Hyva-Checkout-PayPo)

### Payplug

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/545)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-payplug
bin/magento setup:upgrade
```

### Paytrail

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/645)
- [Compatibility module repository](https://github.com/paytrail/paytrail-for-adobe-commerce-hyva-checkout)

### PensoPay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/580)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-pensopay-payment
bin/magento setup:upgrade
```

### Quickpay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/601)
- [Compatibility module repository](https://github.com/magebitcom/magento2-hyva-checkout-quickpay-gateway)

### Rabo Smart Pay

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/631)
- [Compatibility module repository](https://github.com/Vendic/hyva-checkout-omnikassa-payment)

### Rvvup

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/571)
- [Compatibility module repository](https://github.com/rvvup/magento-plugin)

### SagePay / Opayo

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/15)
- [Compatibility module](https://store.ebizmarts.com/opayo-sagepay-suite-pro-for-magento-2.html)

### Santander eRaty (Santander Bank Poland)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/551)
- [Compatibility module repository](https://github.com/SnowdogApps/Hyva-Checkout-Santander)

### SatisPay (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/652)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-satispay
bin/magento setup:upgrade
```

### ScalaPay (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/569)

Installation

```
composer require scalapay/scalapay-magento-2-hyva-adapter
bin/magento setup:upgrade
```

### Stripe (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/8)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-stripe
bin/magento setup:upgrade
```

### Super Payments

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/619)
- [Compatibility module repository](https://github.com/superpayments/magento-plugin-hyva)

### Svea Payments (CSP compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/642)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-svea-payment
bin/magento setup:upgrade
```

### TPay - Payment Gateway for the Polish Market

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/549)
- [Compatibility module repository](https://github.com/SnowdogApps/Hyva-Checkout-Tpay)

### Utrust

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/599)
- [Compatibility module repository](https://github.com/magebitcom/magento2-hyva-checkout-utrust-payment)

### Viva Smart Checkout

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/602)
- [Compatibility module repository](https://github.com/magebitcom/magento2-hyva-checkout-viva-payments)

### Worldline

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/559)
- [Compatibility module repository](https://github.com/wl-online-payments-direct/plugin-magento-hyva)

## Integrations in Progress

The following payment integration is currently being developed and will be released soon.

### Monta Checkout

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/560)

## More Integrations

This page covers the primary tracked integrations. You can find additional community-built integrations on the [Community Checkout integrations](community-checkout-extensions.html) page.

For integrations that are in a planning state or have stale status updates, check the [checkout integration tracker board](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/boards/87) directly. If you want to track a payment method that is not listed yet, open a ticket on the tracker or ask in the `#hyva-checkout-support` Slack channel.
