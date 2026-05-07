<!-- source: https://docs.hyva.io/hyva-themes/upgrading/index.html -->

# How to Upgrade

## Introduction

Hyvä has two main components, the `hyva-themes/magento2-default-theme` and the `hyva-themes/magento2-theme-module`.

### The default-theme

The default-theme contains the templates, styles, and layout instructions that define the visual representation of a website.
When creating a custom theme, customized copies of files within the default-theme will need to be created.
Files that are not customized are loaded from the default-theme through the Magento theme fallback.

The more files are customized, the more work an upgrade becomes.

Usually, you only have to update customized templates that have relevant DOM structure changes.
A diff will allow you to quickly scan the changes made to a file and move on to the next if only class name changes were made.

### The theme-module

The theme-module provides utilities and required infrastructure code used by all Hyvä based themes.
The files within the theme-module are rarely customized when creating a custom theme.
We (Hyvä) try very hard to avoid backward compatibility-breaking changes for the theme-module.

This means it is always safe to update the theme-module to the latest version. Even if a theme itself isn't updated (yet), it will continue to work with a newer version of the theme-module.

### The reset-theme

For hyva-theme 1.3.17 or older only

Since release 1.3.18 the Hyvä Theme no longer uses a reset-theme parent.

hyva-theme 1.3.17 and Magento 2.4.8 compatibility

After updating to Magento 2.4.8, also update to version 1.1.10 of `hyva-themes/magento2-reset-theme` to fix the issue of Hyvä styles that are no longer applied by running:

```
composer require hyva-themes/magento2-reset-theme:1.1.10
```

If you have overwritten the root.phtml, adds the following two extra lines to get the CSS to be included in your html head output as shown here:

```
<?= /* @noEscape */ $headCritical ?? '' ?>
<?= /* @noEscape */ $headAssets ?? '' ?>
```

## Full upgrade or theme-module only?

We recommend always upgrading the theme-module. Because of the commitment to backward compatibility, that should not introduce breaking changes. Be sure to read the upgrade notes just in case.
Theme-module upgrades tend to be smooth and fast.

Upgrading a child theme to integrate all chances in a Hyvä default theme release is not always necessary. Partial upgrades are possible, too.
Depending on the requirements of a given instance, an existing theme can often stay as it is for a long time.

## Security

If a release contains security-related changes, we will make that clear in the upgrade announcement and the released notes.
If necessary, we will also provide a patch of the security-related changes only, excluding any other changes that may be included in the release.

## Long Term Support

Once in a while, the ecosystem in which Hyvä exists requires changes that require changes to existing child themes, for example, a new Tailwindcss, Alpine.js, or a new Magento version with backward incompatible changes.
When that happens, Hyvä will continue to maintain old branches of the theme and the theme-module and still make releases with security-related changes.
Sometimes selected new features will also be included in these new releases of older versions of Hyvä, to allow extension vendors to support a larger Hyvä version range.
At the time of writing, the duration of security releases for old versions of Hyvä is unspecified.

## The Upgrade Process

1. Check version-specific upgrade notes here in the docs. If there are any backward incompatible changes they will be listed there.
2. Check the changelog for the new version for both the theme-module and the default-theme here in the docs or GitLab.
3. Upgrade the theme-module.
4. For every customized theme file, inspect the changes made in the default-theme for the new version. See below for helpful tooling.
5. Upgrade the default-theme.
6. Apply the required changes from step 4. to your customized theme.

## Upgrade Tooling

Good tooling can help with this step, for example, the

- [Hyvä Upgrade Helper Tools](upgrade-helper.html).
- [Ampersand Magento2 Upgrade Patch Helper](https://github.com/AmpersandHQ/ampersand-magento2-upgrade-patch-helper)
- [Elgentos Magento2 Upgrade GUI](https://github.com/elgentos/magento2-upgrade-gui).

Good old `git` can be used, too:
First, copy the changed theme to some temporary folder and run
`git init && git commit -m"Initial commit`.
Then delete everything and copy in the updated version of the default-theme.
Now a `git diff` will reveal all changes.

Try this command to see a nicely formatted patch (thanks to Peter Jaap Blaakmeer from Elgentos):

```
git format-patch -1 HEAD --no-notes --no-cover-letter --no-stat --no-prefix --no-signature
```
