<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-3.0.1.html -->

# Upgrading to 3.0.1

This is a maintenance release focused on bug fixes for integrations written for Checkout 1.x, such as Stripe and PayPal. It also updates the Magewire 1 backward compatibility module `hyva-themes/magento2-hyva-checkout-v1bc` to `1.0.1`.

Please refer to the [changelog](changelog.html#301-2026-11-02) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä Checkout first.

Then, to upgrade, run the commands:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:3.0.1
bin/magento setup:upgrade
```

If you're upgrading from Checkout 1.x or from a 3.0.0 or 1.4.0 beta, follow [Upgrading to 3.0.0](upgrading-to-3.0.0.html) instead: its `composer require` command installs the latest 3.0.x release.

## Compiled Magewire Views Are Cleared

Checkout 3.0.1 changes how Magewire compiles component templates whose first HTML sits inside an `if`, a loop or a `switch`. So that every template is compiled again, `setup:upgrade` deletes the compiled Magewire views of the storefront once.

Where `setup:upgrade` can't delete them, it logs a warning. In that case, clear them yourself:

```
bin/magento magewire:compile:clear --area=frontend
```

Also run this command on every server whose `var/magewire` directory isn't shared with the server that runs `setup:upgrade`, and reset OPcache where it doesn't check file timestamps.

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

- No Deprecations.

## Template changes

- No template changes.

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html#301-2026-11-02).
