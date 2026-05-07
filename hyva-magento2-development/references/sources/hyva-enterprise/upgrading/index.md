<!-- source: https://docs.hyva.io/hyva-enterprise/upgrading/index.html -->

# How to Upgrade

This document gives a general overview over the Hyvä Enterprise upgrade process.
Please be sure to check the version specific upgrade notes.

## The Upgrade Process

1. Check version specific upgrade notes here in the docs for the Enterprise package(s) you wish to update (e.g. Adobe Commerce, B2B or Adobe Sensei (Live Search & Product Recommendations), and for either Hyvä Theme or Hyvä Checkout). If there are any backward incompatible changes they will be listed there.
2. Check the changelog for the new version.
3. Upgrade the relevant packages (see below).
4. Apply required changes from step 2. to files customized in your project.

## Upgrading packages

To update the Hyvä Enterprise metapackages for Hyvä Theme and Hyvä Checkout, see the relevant instructions below.

### Hyvä Theme

#### Adobe Commerce

Only required when installing base Adobe Commerce packages on their own (i.e. not using B2B or Sensei)

```
composer update --with-dependencies hyva-themes/magento2-hyva-enterprise-commerce
```

#### B2B

Will also update base Adobe Commerce packages

```
composer update --with-dependencies hyva-themes/magento2-hyva-enterprise-b2b
```

#### Adobe Sensei (Live Search & Product Recommendations)

Will also update base Adobe Commerce packages

```
composer update --with-dependencies hyva-themes/magento2-hyva-enterprise-sensei
```

### Hyvä Checkout

#### Adobe Commerce

Only required when installing base Adobe Commerce packages on their own (i.e. not using B2B or Sensei)

```
composer update --with-dependencies hyva-themes/magento2-hyva-enterprise-commerce-checkout
```

#### B2B

Will also update base Adobe Commerce packages

```
composer update --with-dependencies hyva-themes/magento2-hyva-enterprise-b2b-checkout
```

### Upgrading to a specific version

To update to a specific version, use the following command, while replacing `<package-name>` with the relevant package name and `x.y.z` with the desired version.

```
composer update --with-dependencies <package-name>:x.y.z
```

## Finding and applying Hyvä default theme changes

Changes are occasionally made to files in the default theme that are required for certain areas to properly function or visually display correctly.

However, we do not add version constraints on the default theme, only the theme module. Therefore, when upgrading Hyvä Enterprise for Hyvä Theme it is usually to know which changes have been made so they can be reviewed and implemented in your custom/child theme where necessary.

A full list of issues (that link to the relevant merge requests) can be found by filtering by the `Enterprise` labeled issues in the **Default Theme** repository. In most cases these issues also highlight the milestone they were part of, which corresponds to the release version of the Default Theme.

While not specifically relevant to the above, the same can also be applied for the **Theme Module** repository.
