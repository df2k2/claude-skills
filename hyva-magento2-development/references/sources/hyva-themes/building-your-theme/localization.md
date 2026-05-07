<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/localization.html -->

# Hyvä Theme Localization and Translation

Hyvä theme localization uses Magento's standard CSV translation dictionary system. The Hyvä Default Theme ships with an English dictionary file at `i18n/en_US.csv`, containing all Hyvä-specific translatable strings that are not part of core Magento. This `en_US.csv` file serves as the reference for creating translations of the Hyvä theme into other languages.

## Translation Methods for Hyvä Themes

Hyvä supports two standard Magento translation methods: theme-level CSV dictionaries and project-level language packs. Both methods work the same way in Hyvä as they do in Luma-based themes.

### Theme-Level Translation Dictionaries

The simplest way to translate a Hyvä theme is to add a CSV translation dictionary file in your child theme's `i18n/` directory. Place the dictionary file at the path matching the target locale, for example:

```
app/design/frontend/Vendor/ThemeName/i18n/de_DE.csv
```

Each line in the CSV file maps an English source string to a translated string. Hyvä theme translation dictionaries follow the exact same format as standard Magento theme dictionaries.

### Project-Level Language Packs

For projects that need clear separation between Magento core translations, Hyvä theme translations, and project-specific translations, a project-level language pack offers better organization. Create the language pack in `app/i18n/{projectname}/{locale}/`.

A Hyvä project-level language pack requires three components: a `registration.php` file, a `language.xml` file, and one or more CSV translation files.

> *Thanks to Pieter Hoste from Baldwin for sharing this knowledge gem.*

Creating a Project-Level Language Pack for Hyvä

A project-level language pack needs a `registration.php` file to register the language module with Magento. In the following example, `{project}` is a string like `mysite` and `{locale}` is a lowercase locale string like `de_de`:

```
<?php
// registration.php - registers the language pack with Magento
use Magento\Framework\Component\ComponentRegistrar;
ComponentRegistrar::register(ComponentRegistrar::LANGUAGE, '{project}_{locale}', __DIR__);
```

The language pack also requires a `language.xml` configuration file. In this file, `{locale}` uses the standard format like `de_DE` and `{project}` matches your project folder name:

```
<?xml version="1.0"?>
<!-- language.xml - defines the language pack metadata -->
<language xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="urn:magento:framework:App/Language/package.xsd">
    <code>{locale}</code>
    <vendor>{project}</vendor>
    <package>{locale}</package>
</language>
```

For complete documentation on creating Magento language packs, see the [Adobe Commerce Localization Guide](https://experienceleague.adobe.com/en/docs/commerce-operations/configuration-guide/cli/localization#create-directories-and-files).

## Pre-Built Hyvä Localization Modules

Hyvä provides pre-translated localization modules for many languages, available as Composer packages. Each Hyvä localization module contains complete translations of all Hyvä-specific strings and can be installed alongside standard Magento language packs.

### Available Hyvä Translation Languages

The following Hyvä localization modules are available, grouped by language family.

**Germanic languages:**

- de\_CH (Swiss German): `hyva-themes/i18n-de-ch`
- de\_DE (German): `hyva-themes/i18n-de-de`
- da\_DK (Danish): `hyva-themes/i18n-da-dk`
- nl\_BE (Belgian Dutch): `hyva-themes/i18n-nl-be`
- nl\_DI (Dutch, informal): `hyva-themes/i18n-nl-di`
- nl\_NL (Dutch): `hyva-themes/i18n-nl-nl`

**Romance languages:**

- ca\_ES (Catalan): `hyva-themes/i18n-ca-es`
- es\_ES (Spanish): `hyva-themes/i18n-es-es`
- fr\_FR (French): `hyva-themes/i18n-fr-fr`
- it\_IT (Italian): `hyva-themes/i18n-it-it`
- pt\_BR (Brazilian Portuguese): `hyva-themes/i18n-pt-br`
- ro\_RO (Romanian): `hyva-themes/i18n-ro-ro`

**Slavic languages:**

- bg\_BG (Bulgarian): `hyva-themes/i18n-bg-bg`
- pl\_PL (Polish): `hyva-themes/i18n-pl-pl`
- uk\_UA (Ukrainian): `hyva-themes/i18n-uk-ua`

**Uralic languages (Finnic branch):**

- et\_EE (Estonian): `hyva-themes/i18n-et-ee`

Note: Estonian is not a Baltic language; it belongs to the Finno-Ugric family.

**Baltic languages:**

- lt\_LT (Lithuanian): `hyva-themes/i18n-lt-lt`
- lv\_LV (Latvian): `hyva-themes/i18n-lv-lv`

**Koreanic languages:**

- ko\_KR (Korean): `hyva-themes/i18n-ko-kr`

### Installing a Hyvä Localization Module

Install a Hyvä localization module using Composer, then run Magento's `setup:upgrade` command. The following example installs the Italian Hyvä localization:

```
composer require hyva-themes/i18n-it-it
bin/magento setup:upgrade
```

### Completing the Hyvä Localization Setup

After installing the Hyvä localization module, complete the localization setup with these steps:

1. Install the corresponding Magento core language pack for the target locale
2. Configure the store view language in **Stores > Configuration > General > Locale Options**
3. Clear caches and deploy static content if running in production mode
