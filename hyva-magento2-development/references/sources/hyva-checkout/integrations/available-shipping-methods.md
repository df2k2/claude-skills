<!-- source: https://docs.hyva.io/hyva-checkout/integrations/available-shipping-methods.html -->

# Shipping Method Integrations for Hyvä Checkout

Hyvä Checkout supports a wide range of shipping providers through community members and vendors. Most shipping methods that do not implement extra frontend features work out of the box with no additional configuration. Shipping methods that add frontend elements - such as maps, forms, or address finders - require a dedicated Compatibility module.

This page lists tracked shipping integrations and links to their repositories. Updates are tracked on the [checkout integration tracker board](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/boards/87).

Checkout 3.x compatibility

Unless stated otherwise, the integrations listed here that are built on Magewire target Hyvä Checkout 1.x (Magewire 1). On Checkout 3.x checkout pages they run through the [Magewire 1 backward compatibility module (v1bc)](../faq/what-is-v1bc.html). Check with the vendor whether an integration supports Checkout 3.x.

Each shipping method that requires a Compatibility module also has a repository. These repositories are hosted by service providers, extension developers, or the Hyvä team. Repository addresses are listed on the relevant integration tracker tickets.

Support responsibility

The Hyvä team does not directly maintain most integrations. For first-line support, reach out to your provider or integrator. If you need help connecting with the right vendors, the Hyvä team is happy to guide you.

## Currently Available Shipping Integrations

Vendor and Community labels

The integration tracker uses `Vendor` and `Community` labels on each ticket to indicate who is responsible for the implementation and first-line support.

### Amasty Shipping Restrictions

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/27)
- [Compatibility module](https://amasty.com/shipping-restrictions-for-magento-2.html)

### Amasty Shipping Rules

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/28)
- [Compatibility module](https://amasty.com/shipping-rules-for-magento-2.html)

### Amasty Shipping Table Rates

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/26)
- [Compatibility module](https://amasty.com/shipping-table-rates-for-magento-2.html)

### InPost Paczkomaty

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/548)
- [Compatibility module](https://github.com/SnowdogApps/Hyva-Checkout-Inpost)

### In store pickup

Beta release - not for production use

The Hyvä Checkout In-Store Pickup module is in beta (`1.0.0-beta1`). It is intended for testing and evaluation only. Do **not** run it on a production store. Install it in a development or staging environment so you can validate it ahead of a stable release.

The Hyvä team maintains this module. It adds Magento's in-store pickup (Magento Inventory) to Hyvä Checkout: a **Ship to me** / **Pick up in store** choice above the shipping details and a store picker for the pickup method.

Requirements:

- **Hyvä Checkout 1.x:** version `1.3.15` or later.
- **Hyvä Checkout 3.x:** version `3.0.0` or later, with the [Magewire 1 backward compatibility module (v1bc)](../magewire/v1bc.html) enabled.
- **Magento:** the Magento Inventory in-store pickup modules enabled, and the **In-Store Pickup Delivery** shipping method enabled for the website.

Composer only installs the beta when the version constraint or your project's stability settings allow it, so require it with the `@beta` flag:

Installation

```
composer require hyva-themes/magento2-hyva-checkout-in-store-pickup:^1.0@beta
bin/magento setup:upgrade
```

After installing, rebuild the theme's Tailwind CSS so the module's styles are compiled.

### Post.nl

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/18)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-postnl
bin/magento setup:upgrade
```

### DHL eCommerce for Magento 2

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/683)
- [Compatibility module](https://github.com/dhlparcel/plugin-magento2-hyva-release)

Installation

```
composer require dhlparcel/magento2-plugin-hyva
bin/magento setup:upgrade
```

### DHL Pickup Locator

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/660)
- [Compatibility module](https://commercemarketplace.adobe.com/vconnect-dhl-pickup-locator-pro.html)

### Bring Pickup Locator

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/661)
- [Compatibility module](https://commercemarketplace.adobe.com/vconnect-bring-pickup-locator-pro.html)

### GLS Pickup Locator

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/662)
- [Compatibility module](https://commercemarketplace.adobe.com/vconnect-gls-pickup-locator-pro.html)

### PostNord Pickup Locator

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/663)
- [Compatibility module](https://commercemarketplace.adobe.com/vconnect-postnord-pickup-locator-pro.html)

### Colis Privé Pickup Locator

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/664)
- [Compatibility module](https://commercemarketplace.adobe.com/vconnect-colis-prive-pickup-locator-pro.html)

### Colissimo

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/640)

Installation

```
composer require controlaltdelete/magento2-colissimo-hyva-checkout
bin/magento setup:upgrade
```

### Postcode.nl

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/13)

Install the Hyvä Checkout Compatibility module for Postcode.nl with Composer:

Installation

```
composer require hyva-themes/magento2-hyva-checkout-postcodenl
bin/magento setup:upgrade
```

### ShipperHQ

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/17)

Install the Hyvä Checkout Compatibility module for ShipperHQ with Composer:

Installation

```
composer require hyva-themes/magento2-hyva-checkout-shipperhq
bin/magento setup:upgrade
```

#### ShipperHQ - Shipper

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/674)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-shipperhq-shipper
bin/magento setup:upgrade
```

#### ShipperHQ - Option

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/675)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-shipperhq-option
bin/magento setup:upgrade
```

#### ShipperHQ - Calendar

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/676)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-shipperhq-calendar
bin/magento setup:upgrade
```

#### ShipperHQ - Pickup

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/677)

Installation

```
composer require hyva-themes/magento2-hyva-checkout-shipperhq-pickup
bin/magento setup:upgrade
```

### Webshipper (Wexo)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/581)

Install the Hyvä Checkout Compatibility module for Webshipper with Composer:

Installation

```
composer require hyva-themes/magento2-hyva-checkout-wexo-webshipper
bin/magento setup:upgrade
```

### Calcurates (CSP Compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/649)

Install the Hyvä Checkout Compatibility module for Calcurates with Composer:

Installation

```
composer require hyva-themes/magento2-calcurates-module
bin/magento setup:upgrade
```

### SendCloud (CSP Compatible)

- [Integration tracker ticket](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/work_items/383)

Install the Hyvä Checkout Compatibility module for SendCloud with Composer:

Installation

```
composer require sendcloud/sencloud-magento-hyva
bin/magento setup:upgrade
```

## Integrations Not Listed Here

There are many more integrations in planned or in-progress states that may not appear in this list. You can find all tracked integrations on the [checkout integration tracker board](https://gitlab.hyva.io/hyva-public/checkout-integration-tracker/-/boards/87).

If you want to add or track a shipping method that is not listed yet, open a ticket on the tracker or ask in the `#hyva-checkout-support` channel on Slack.
