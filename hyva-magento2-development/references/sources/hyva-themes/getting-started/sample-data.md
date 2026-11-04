<!-- source: https://docs.hyva.io/hyva-themes/getting-started/sample-data.html -->

# Hyvä Sample Data (Koti)

Hyvä ships its own sample data, the **Koti** sample data: a demo catalog and CMS content built for Hyvä themes.

The sample data is managed with two CLI commands provided by `Hyva_Theme`:

- `bin/magento hyva:sampledata:deploy` adds the Koti sample data Composer packages
- `bin/magento hyva:sampledata:remove` removes them again

After deploying (or changing) the packages, always run `bin/magento setup:upgrade` to apply the sample data.

## Prerequisites

A Hyvä Theme license key (free or commercial) is required.

The `bin/magento hyva:sampledata:deploy` and `bin/magento hyva:sampledata:remove` commands are provided by the Hyvä theme module (`Hyva_Theme`) starting from version **1.4.7**.

The Koti sample data builds on Magento's `magento/module-sample-data`, which is part of a standard Magento installation. It is present unless it was removed with a [Composer replace](https://getcomposer.org/doc/04-schema.md#replace). If it is missing, `hyva:sampledata:deploy` stops with an error and you need to reinstall `magento/module-sample-data` first.

## Installation Scenarios

The right command depends on whether the store already has the Luma sample data installed. `hyva:sampledata:deploy` detects this and guides you to the correct option.

### Fresh install (no Luma sample data)

On a store without any Luma sample data, deploy directly:

```
bin/magento hyva:sampledata:deploy
bin/magento setup:upgrade
```

### Replace the Luma sample data

To remove the Luma sample data and install Koti in its place, use `--replace-luma`:

```
bin/magento hyva:sampledata:deploy --replace-luma
bin/magento setup:upgrade
```

Destructive

`--replace-luma` removes all Luma sample data modules and clears existing catalog data: **all products, orders, and customers are deleted** before Koti is installed. Only use it on a demo or development store.

### Alongside the Luma sample data (side-by-side)

To keep the existing Luma store untouched and install Koti on a **separate website**, use `--keep-luma`:

```
bin/magento hyva:sampledata:deploy --keep-luma
bin/magento setup:upgrade
```

The default website keeps the Luma sample data; the Koti sample data is created on a new, separate website with the store view code `koti` so you can compare both. `--keep-luma` and `--replace-luma` are mutually exclusive.

The Koti website has no separate domain configured, so switch to its store view with the `?___store=koti` query parameter. The default Luma store view stays at the site root. Alternatively, if store codes in URLs are enabled (Stores > Configuration > General > Web > Url Options > Add Store Code to Urls), the Koti store view is reachable at the `/koti/` path.

### Reinstall / Update

To reset the sample data so the next `setup:upgrade` recreates all catalog data, use `--reinstall`:

```
bin/magento hyva:sampledata:deploy --reinstall
bin/magento setup:upgrade
```

Running these commands will also update the sample data packages to the latest version.

Destructive

`--reinstall` resets the sample data and recreates the catalog on the next `setup:upgrade`, which **removes all products, orders, and customers**.

To migrate an existing Koti installation onto a separate website, combine both flags:

```
bin/magento hyva:sampledata:deploy --reinstall --keep-luma
bin/magento setup:upgrade
```

## Finding Products to Test With

The Koti catalog contains one product for each Magento product property combination, from configurables with image swatches to fixed-price bundles, tier prices and out-of-stock selections.

The [Koti Sample Data Product Reference](sample-data-product-reference.html) lists which product exercises which property, together with the URL path to open it directly on your development instance.

## Removing the Hyvä Sample Data

Remove all Koti sample data Composer packages:

```
bin/magento hyva:sampledata:remove
bin/magento setup:upgrade
```

## Controlling the Composer step

Both commands run `composer update` in-process to update `composer.json`. Pass `--no-update` to write the changes to `composer.json` **without** running `composer update`, so you can run the Composer update yourself (for example in a controlled deployment or CI pipeline):

```
bin/magento hyva:sampledata:deploy --no-update
composer update
bin/magento setup:upgrade
```

`--no-update` is available on both `hyva:sampledata:deploy` and `hyva:sampledata:remove`.

## Command Reference

### `hyva:sampledata:deploy`

Adds the Koti sample data Composer packages (replaces the Luma sample data by default).

| Option | Effect |
| --- | --- |
| `--replace-luma` | Remove all Luma sample data modules and clear existing data. **Destructive:** removes all products, orders, and customers. |
| `--keep-luma` | Install the Koti sample data on a separate website, leaving the default website untouched. Mutually exclusive with `--replace-luma`. |
| `--reinstall` | Reset the sample data so the next `setup:upgrade` recreates all catalog data. **Destructive.** |
| `--no-update` | Update `composer.json` without executing `composer update`. |

### `hyva:sampledata:remove`

Removes all Koti sample data packages from `composer.json`.

| Option | Effect |
| --- | --- |
| `--no-update` | Update `composer.json` without executing `composer update`. |
