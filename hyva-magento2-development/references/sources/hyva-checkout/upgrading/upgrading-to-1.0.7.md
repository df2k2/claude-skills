<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.0.7.html -->

# Upgrading to 1.0.7

This backwards compatible maintenance release fixes a number of issues.
Please refer to the [changelog](changelog.html#107-2023-06-19) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.
Then, to upgrade, run the command

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.0.7
```

## Magewire pinned to 1.10.4

From this release onward Hyvä Checkout will require a specific version of Magewire.
This ensures stability of the current release while Magewire is developed further.

### Using a different version of Magewire

To override the pinned version of Magewire, you can add it as a root dependency with an inline alias.

Magewire 1.10.4 security vulnerability

The release 1.10.4 of Magewire contains a security issue that has been resolved in 1.10.5.
If you are using Hyvä Checkout 1.0.7, be sure to override the required Magewire version to use a secure release!

After upgrading to Hyvä Checkout 1.0.7, be sure to run the following command to install a secure version of Magewire:

```
composer require "magewirephp/magewire:1.10.5 as 1.10.4"
```

### Using an older version of Magewire

For example, if you prefer to keep using Magewire 1.9.2, run the following command before upgrading the checkout:

```
composer require "magewirephp/magewire:1.9.2 as 1.10.4"
```

This will install version 1.9.2 of Magewire, while allowing Hyvä Checkout 1.0.7 to be installed despite it's dependency on Magewire 1.10.4.

Use at your own risk

Please be aware that you are responsible for the stability of your checkout when using inline aliasing to install an older version of Magewire.
We only test the checkout with the pinned version of `magewirephp/magewire` listed in the Hyvä Checkout `composer.json` file in the `require` section.

## Backward incompatible changes

This release contains no backwards incompatible changes.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
