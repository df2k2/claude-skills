<!-- source: https://docs.hyva.io/hyva-enterprise/getting-started/index.html -->

# Hyvä Enterprise Installation & Configuration

Hyvä Enterprise extends Hyvä Themes and Hyvä Checkout with compatibility modules for Adobe Commerce enterprise features like B2B, Live Search, and Product Recommendations. This guide walks you through system requirements and installation for all Hyvä Enterprise metapackages.

Hyvä Enterprise is a stand-alone commercial product

A separate Hyvä Enterprise license is required in addition to your Hyvä Commerce and/or Hyvä Checkout licenses.

## System Requirements Overview

Before installing Hyvä Enterprise, check that your environment meets the requirements below. Only install the prerequisites for the features you actually plan to use.

### Core Platform Requirements

These requirements apply to all Hyvä Enterprise installations:

- **Adobe Commerce** 2.4.4 or higher - The current implementation targets 2.4.6. Versions 2.4.4 and 2.4.5 have not been fully tested and may have issues. B2B currently requires 2.4.6+.
- **[Hyvä Themes](../../hyva-themes/getting-started/index.html)** 1.2.9, 1.3.10, or higher - Some older Hyvä Enterprise versions support earlier 1.3.x releases.
- **[Hyvä Checkout](../../hyva-checkout/getting-started/index.html)** 1.3.0 or higher - Only required for checkout features. Requires a Hyvä Checkout license. Some older versions support 1.1.x and 1.2.x.
- **PHP** 8.0 or newer

Release notes for related products:

- [Adobe Commerce release notes](https://experienceleague.adobe.com/en/docs/commerce-operations/release/notes/adobe-commerce/overview)
- [Hyvä default theme changelog](../../hyva-themes/upgrading/changelog-default-theme.html)
- [Hyvä theme module changelog](../../hyva-themes/upgrading/changelog-theme-module.html)

### B2B Suite Requirements

To use Adobe Commerce B2B features (company accounts, shared catalogs, requisition lists, quote templates, purchase orders), install and configure Adobe's B2B extension before installing Hyvä Enterprise B2B.

- **`magento/extension-b2b`** 1.4.0 or higher - Support for 1.3.x (Adobe Commerce 2.4.4/2.4.5 compatibility) is under review.

Follow Adobe's [B2B installation guide](https://experienceleague.adobe.com/en/docs/commerce-admin/b2b/install) to set up the B2B extension. See the [B2B release notes](https://experienceleague.adobe.com/en/docs/commerce-admin/b2b/release-notes) for version-specific details.

### Adobe Sensei Services Requirements

Adobe Sensei powers AI-driven search and product recommendations for Adobe Commerce. If you plan to use Live Search or Product Recommendations, install and configure the Adobe modules before installing Hyvä Enterprise Sensei compatibility.

#### Live Search

Live Search provides search results with faceted filtering powered by Adobe Sensei AI.

- **`magento/live-search`** 3.0.0 or higher

Follow Adobe's [Live Search installation guide](https://experienceleague.adobe.com/en/docs/commerce/live-search/install) to configure the service. See the [Live Search release notes](https://experienceleague.adobe.com/en/docs/commerce/live-search/release-notes) for version details.

#### Product Recommendations

Product Recommendations displays AI-driven product suggestions throughout your storefront.

- **`magento/product-recommendations`** 5.0.0 or higher
- **`magento/module-page-builder-product-recommendations`** 2.0.0 or higher
- **`magento/module-visual-product-recommendations`** 2.0.0 or higher

Follow Adobe's [Product Recommendations installation guide](https://experienceleague.adobe.com/en/docs/commerce/product-recommendations/getting-started/install-configure) to configure the service. See the [Product Recommendations release notes](https://experienceleague.adobe.com/en/docs/commerce/product-recommendations/release-notes) for version details.

### Adobe Data Connection Requirements

Adobe Data Connection enables behavioral data collection for Adobe Experience Platform integration. To send storefront event data to Adobe Experience Platform, install the Experience Connector before installing Hyvä Enterprise Data Connection compatibility.

- **`magento/module-experience-connector`**

Follow Adobe's [Data Connection installation guide](https://experienceleague.adobe.com/en/docs/commerce/data-connection/fundamentals/install) to configure the connector. See the [Data Connection release notes](https://experienceleague.adobe.com/en/docs/commerce/data-connection/release-notes) for version details.

## Installing Hyvä Enterprise for Hyvä Themes

Hyvä Enterprise for Hyvä Themes provides frontend compatibility for Adobe Commerce enterprise features. Install only the metapackages for the features you need. All packages come from your Hyvä packagist.com license key.

**Before you begin**, make sure you have:

1. Installed and configured [Hyvä Themes](../../hyva-themes/getting-started/index.html)
2. Installed any Adobe Commerce features you plan to use (B2B, Live Search, Product Recommendations, Data Connection)

Pick the metapackage(s) that match your feature requirements and run the corresponding Composer commands:

Adobe Commerce Base Features (GTM, customer attributes)

Install the base Hyvä Enterprise metapackage for Adobe Commerce compatibility:

Install Adobe Commerce compatibility metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-commerce
bin/magento setup:upgrade
```


B2B Features (company accounts, shared catalogs, quote templates, purchase orders)

Install the B2B metapackage for Adobe Commerce B2B compatibility. This package automatically includes the base metapackage as a dependency:

Install B2B metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-b2b
bin/magento setup:upgrade
```


Data Connection (Adobe Experience Platform integration)

Install the Data Connection metapackage for Adobe Experience Platform event tracking:

Install Data Connection metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-data-connection
bin/magento setup:upgrade
```


Live Search (Adobe Sensei search)

Install the Live Search metapackage for Adobe Sensei Live Search compatibility:

Install Live Search metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-live-search
bin/magento setup:upgrade
```


Product Recommendations (AI-driven product suggestions)

Install the Product Recommendations metapackage for Adobe Sensei Product Recommendations compatibility:

Install Product Recommendations metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-product-recommendations
bin/magento setup:upgrade
```


DEPRECATED: Adobe Sensei Combined Metapackage

The combined Adobe Sensei metapackage is deprecated. Install the Data Connection, Live Search, and Product Recommendations metapackages separately instead.

Deprecated Sensei metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-sensei
bin/magento setup:upgrade
```

Metapackage dependencies

The B2B and Sensei-related metapackages include the base Adobe Commerce metapackage as a dependency. You don't need to install the base metapackage separately when using B2B or Sensei features.

### Building Tailwind CSS After Hyvä Enterprise Installation

After installing any Hyvä Enterprise metapackage for Hyvä Themes, rebuild Tailwind CSS to include styles from the new compatibility modules. Replace the path below with the path to your theme's `web/tailwind` folder:

Build Tailwind CSS for Hyvä Themes

```
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
```

## Installing Hyvä Enterprise for Hyvä Checkout

Hyvä Enterprise for Hyvä Checkout provides checkout-specific compatibility for Adobe Commerce enterprise features. These packages extend Hyvä Checkout with B2B checkout flows and enterprise feature support.

Two metapackages are available - Adobe Commerce and B2B - both installable via your Hyvä packagist.com license key.

Adobe Sensei compatibility for checkout

Support for Live Search and Product Recommendations in checkout is under review. Currently, Sensei-related functionality is handled by the theme-level packages.

**Before you begin**, make sure you have:

1. Installed and configured [Hyvä Themes](../../hyva-themes/getting-started/index.html)
2. Installed and configured [Hyvä Checkout](../../hyva-checkout/index.html)
3. Installed any Adobe Commerce features you plan to use

Pick the metapackage(s) that match your feature requirements:

Adobe Commerce Checkout Features (custom customer attributes)

Install the Commerce Checkout metapackage for enterprise checkout features without B2B:

Install Commerce Checkout metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-commerce-checkout
bin/magento setup:upgrade
```


B2B Checkout Features (company checkout, purchase orders, quote templates)

Install the B2B Checkout metapackage for B2B-specific checkout features. This package automatically includes the Commerce Checkout metapackage as a dependency:

Install B2B Checkout metapackage

```
composer require hyva-themes/magento2-hyva-enterprise-b2b-checkout
bin/magento setup:upgrade
```

Metapackage dependencies

The B2B Checkout metapackage includes the base Commerce Checkout metapackage as a dependency. You don't need to install the Commerce Checkout metapackage separately when using B2B features.

### Building Tailwind CSS After Hyvä Enterprise for Hyvä Checkout Installation

After installing any Hyvä Enterprise package for Hyvä Checkout, rebuild Tailwind CSS to include styles from the new compatibility modules. Replace the path below with the path to your theme's `web/tailwind` folder:

Build Tailwind CSS for Hyvä Checkout

```
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ ci
npm --prefix vendor/hyva-themes/magento2-default-theme/web/tailwind/ run build
```

### Configuring Customer Custom Attributes in Hyvä Checkout

If you use [Customer Custom Attributes](https://experienceleague.adobe.com/en/docs/commerce-admin/customers/customer-accounts/attributes/attribute-properties) in Adobe Commerce, you can configure which attributes appear on checkout address forms.

Navigate to **Stores > Configuration > Hyvä Themes > Checkout > Components** and find the shipping/billing address groups to set up attribute display settings.

Customer Custom Attributes compatibility

Customer Custom Attributes is not yet fully supported at checkout. Check the [Hyvä Enterprise compatibility tracker](https://gitlab.hyva.io/hyva-public/enterprise-compatibility-tracker/-/boards/37) for current status and known limitations.
