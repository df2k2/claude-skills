<!-- source: https://docs.hyva.io/hyva-commerce/faqs/installing-beta-releases.html -->

# Installing Beta Releases

Some Hyvä Commerce modules publish a beta version ahead of their stable release. Check the [changelog](../upgrading/changelog.html) to see whether a beta is available for the module you need, and what it includes.

Beta releases are pre-release

Beta versions are not final and may still change before the stable release. Review the linked changelog entry for what's included and any known issues before using a beta build.

Hyvä CMS `1.3.0`, [Form Builder](../features/form-builder/installation.html) and [Email & Newsletter Templates](../features/email-templates/installation.html) are now stable. If you installed one of their betas, remove the beta pins as described in [Upgrading to Hyvä Commerce 1.4.0](../upgrading/upgrading-to-1.4.0.html#before-upgrading-hyva-cms).

## Installing a Beta Version

To upgrade a single module to its beta version, require the exact beta tag:

```
composer require 'hyva-themes/commerce-module-<module>:<version>-beta<N>'
```

If you have the Hyvä Commerce metapackage installed, alias the beta version to satisfy the metapackage's version constraint, using the module's current stable version as the alias target:

```
composer require 'hyva-themes/commerce-module-<module>:<version>-beta<N> as <current-stable-version>'
```

**Note:** This assumes you are on the latest version of the metapackage.
