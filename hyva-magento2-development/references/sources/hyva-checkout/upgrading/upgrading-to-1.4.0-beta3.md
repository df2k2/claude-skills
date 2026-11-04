<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.4.0-beta3.html -->

# Upgrading to 1.4.0-beta3

This is the third beta release of Magewire v3 for Hyvä Checkout

Hyvä Checkout `1.4.0-beta3` focuses on **expanded EAV attribute support** in the checkout address forms, together with a redesigned admin configuration experience for address fields.

Beta release - not for production use

Hyvä Checkout `1.4.0-beta3` is a beta intended for testing and evaluation only. Do **not** run it on a production store. Install it in a development or staging environment so you can validate the Magewire v3 architecture and the new EAV attribute behavior ahead of a stable release.

## Expanded EAV Attribute Support in the Checkout Address Forms

Hyvä Checkout `1.4.0-beta3` renders and validates additional customer and customer address EAV attributes in the billing and shipping address forms. These frontend input types are supported:

- Text Field
- Text Area
- Date
- Dropdown
- Yes/No (boolean)
- Multiple Select
- Multiline

File and Image input types are **not** supported. For a walkthrough of creating an address attribute and assigning it to the `customer_register_address` form, see [Adding Custom Address Attributes](../devdocs/form-customization/adding-custom-address-attributes.html).

Hyvä Checkout `1.4.0-beta3` also ships the two address form configuration data patches, `MigrateAddressConfig` and `RemoveCustomerAttributesFromAddressConfig`, along with the console command that reverts them. Their behavior is documented in [Address Form Configuration Data Migration](upgrading-to-1.3.1000-beta1.html#address-form-configuration-data-migration).

The [changelog](changelog.html#140-beta3-2026-08-03) has the full list of changes in this release.

## Installing Hyvä Checkout 1.4.0-beta3

Check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä Checkout first. Then run:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.4.0-beta3
```

Composer only installs pre-release packages when your project's stability settings allow it. If the beta refuses to install, check the `minimum-stability` and `prefer-stable` settings in your `composer.json`, or require the beta version explicitly.

Upgrade guide coming soon

We're preparing a comprehensive upgrade guide that will cover the recommended upgrade process and migration steps for Magewire v3.

## Related Topics

- **[Upgrading to 1.3.1000-beta1](upgrading-to-1.3.1000-beta1.html)** - The same EAV attribute support on the `1.3.x` branch, including the address form configuration data migration and the templates that changed
- **[Adding Custom Address Attributes](../devdocs/form-customization/adding-custom-address-attributes.html)** - Create an EAV address attribute and get it rendering in the checkout address forms

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html#140-beta3-2026-08-03).
