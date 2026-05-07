<!-- source: https://docs.hyva.io/hyva-widgets/getting-started.html -->

# Getting Started with Hyvä Widgets

Hyvä Widgets let you add interactive, Alpine.js-powered components to your Magento store through the standard Magento widget system. You can place them via `Content > Widgets` in the Admin, or drop them into any WYSIWYG editor or PageBuilder content.

This guide walks you through installing, enabling, and configuring Hyvä Widgets in your Hyva Theme.

## Requirements

Before installing Hyvä Widgets, make sure your environment meets these requirements:

- Magento 2.4.4 or newer
- Hyva Themes version 1.1.10 or higher
- Access to Hyva Themes via Private Packagist or [gitlab.hyva.io](https://gitlab.hyva.io)

## Installing Hyvä Widgets via Composer

Install the Hyvä Widgets package using Composer with a valid Hyva Theme packagist.com key:

```
composer require hyva-themes/magento2-hyva-widgets
```

### Installing from GitLab for Contributors and Technology Partners

If you're contributing to Hyvä Widgets or are a technology partner, you can install directly from the GitLab repository. This requires GitLab access.

Note

Your public SSH key must be set on your [GitLab profile](https://gitlab.hyva.io) before running these commands.

Add the Hyvä Widgets VCS repository to your Composer configuration and require the development branch:

```
composer config repositories.hyva-themes/magento2-hyva-widgets vcs git@gitlab.hyva.io:hyva-themes/magento2-hyva-widgets.git
composer require hyva-themes/magento2-hyva-widgets:dev-main
```

## Enabling the Hyvä Widgets Module

After installing the package, enable the `Hyva_Widgets` module and run the Magento setup upgrade:

```
bin/magento module:enable Hyva_Widgets
bin/magento setup:upgrade
```

## Placing Hyvä Widgets in Your Store

Once installed and enabled, you can place Hyvä Widgets in two ways:

- **Admin widget interface** - Go to `Content > Widgets` to create widget instances and assign them to specific pages or layout positions.
- **WYSIWYG editor / PageBuilder** - Insert widgets directly into CMS pages and blocks using the widget insertion button in any content editor.
