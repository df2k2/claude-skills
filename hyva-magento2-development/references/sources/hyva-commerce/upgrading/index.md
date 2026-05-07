<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/index.html -->

# How to Upgrade

This document gives a general overview over the Hyvä Commerce upgrade process.
Please be sure to check the version specific upgrade notes.

Metapackage Instructions Only

This upgrade guide applies only to using the Hyvä Commerce Metapackage, and not for manging upgrades of individual modules/packages when installed separately (i.e. not using the metapackage).

## The Upgrade Process

1. Check version specific upgrade notes here in the docs for the Commerce version you wish to upgrade to. If there are any backward incompatible changes they will be listed there.
2. Check the [changelog](changelog.html) for the new version.
3. Upgrade the Hyvä Commerce metapackage (see below).
4. Apply required changes from step 2. to files customized in your project where needed.

## Upgrading the Hyvä Commerce Metapackage

### Upgrading to the latest version

To update the Hyvä Commerce metapackage with all dependencies to the latest version, run the command:

```
composer update --with-dependencies hyva-themes/commerce
```

Pre General Availability Upgrades

For some of our earlier releases and alpha/beta versions, the `composer update` command will not work if you wish to upgrade to the latest version. This applies to when we bump the minor version number (e.g. `0.1.x` to `0.2.x`), as Composer considers these pre-release updates like major version changes. In this case, the `composer require` command should be run instead:

```
composer require --with-dependencies hyva-themes/commerce
```

### Upgrading to a specific version

To update to a specific version, use the following command, replacing `x.y.z` with the desired version.

```
composer update --with-dependencies hyva-themes/commerce:x.y.z
```
