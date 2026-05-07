<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/ci-cd-hyva-installation.html -->

# CI/CD Hyvä Installation

The `app/etc/hyva-themes.json` file contains the information which modules should be included when generating a themes `styles.css` file.

More information on the automatic `tailwind.config.js` merge process can be found at the ["Module tailwind.config.js merging" documentation](../compatibility-modules/technical-deep-dive.html#tailwind-asset-merging-for-compatibility-modules).

## Hyvä 1.1.14 and newer

The `app/etc/hyva-themes.json` file used during the compilation of a themes `styles.css` file is generated automatically after one of the commands

- `bin/magento setup:install`
- `bin/magento setup:upgrade`
- `bin/magento module:enable`
- `bin/magento module:disable`

This will usually be enough to take care of all scenarios automatically, so you don't have to worry about it during CI/CD builds.

With Hyvä version 1.1.14 on Magento 2.4.7 or newer this command needs to be run after a compat module is installed

Since Hyvä 1.1.15 this usually happens automatically through one of the commands listed above.

Before automatic `tailwind.config.js` merging was introduced, the purge content configuration in a theme would need to be adjusted to include the new theme.

Now no manual configuration changes are required.

## Hyvä 1.1.13 and older

The `app/etc/hyva-themes.json` file used during the compilation of a themes `styles.css` file is generated automatically after one of the commands

- `bin/magento setup:upgrade`
- `bin/magento module:enable`
- `bin/magento module:disable`

However, in Hyvä versions 1.1.13 and older, the `bin/magento setup:install` command does not cause the `hyva-themes.json` file to be created.

Because of this, if you run `bin/magento setup:install` while the Hyvä packages are already present, be sure to run the command `bin/magento hyva:config:generate` afterward, before you [generate the `styles.css` during the build](deploying-hyva-to-production.html#step-1-generate-the-production-stylesheet).

This will usually be the case during CI/CD builds.
