<!-- source: https://docs.hyva.io/hyva-themes/advanced-topics/generated-base-layout-resets.html -->

# Generated Base Layout Resets

Available since Hyvä 1.3.21

## Rationale

In Hyvä default-theme versions up to the 1.3.21, a parent "reset-theme" was used to override and remove block layout declarations from module folders.

Starting with version 1.3.21, Hyvä Themes use the `hyva-themes/magento2-base-layout-reset` module instead, which dynamically generates base layout declarations in `var/hyva-layout-resets/`.

This approach improves:

- Performance, on page requests hitting a cold layout cache.
- Maintainability, by removing the need to update the reset theme when a new Magento core module is released.

## Generating the base layout resets

The base layout resets are generated on the fly.

It is also possible to trigger generation by running the command

```
bin/magento hyva:base-layout-resets:generate
```

## Installation

The `magento2-base-layout-reset` module is automatically installed as a composer dependency when installing or upgrading `hyva-themes/magento2-default-theme` (or `-csp`) to 1.3.21.

To explicitly install it, for example to upgrade a custom Hyvä base theme, run

```
composer require hyva-themes/magento2-base-layout-reset
bin/magento module:enable Hyva_BaseLayoutReset
bin/magento setup:upgrade
```

If your custom theme inherits from `Hyva/default` or `Hyva/default-csp`, no additional steps are required.

## Configuring the generation folder

A custom path for the generated layout files can be specified in `app/etc/env.php` using the `hyva_layout_resets_generation_directory` key.
Please note, an absolute file path has to be used (that is, starting with `/`).

**Example**

```
return [
    'hyva_layout_resets_generation_directory' => '/var/www/html/generated/code/hyva-layout-resets/',
    ...
```

## What determines if a theme is a Hyvä Theme

In prior versions of Hyvä, a theme is considered a Hyvä-based theme if its inheritance chain contains a theme with a name starting with `Hyva/`.

This was always true when using the `Hyva/reset` theme. However, when using the generated base layouts instead, this detection no longer works.

To ensure proper detection, base Hyvä themes must be added to the constructor argument `$hyvaBaseThemes` of `Hyva\Theme\Service\HyvaThemes` via `di.xml`.

The Hyvä default themes are already listed in the `hyva-themes/magento2-base-layout-reset` module.
If you have a custom Hyvä base theme, directly extending from `Hyva/reset`, and you want to migrate it to use the generated base layout resets, it needs to be added to the array, too.
It is recommended to do so in `di.xml` file a custom module.

```
<type name="Hyva\Theme\Service\HyvaThemes">
    <arguments>
        <argument name="hyvaBaseThemes" xsi:type="array">
            <item name="Hyva/reset" xsi:type="boolean">true</item>
            <item name="Hyva/default" xsi:type="boolean">true</item>
            <item name="Hyva/default-csp" xsi:type="boolean">true</item>
        </argument>
    </arguments>
</type>
```

## Migrating custom Hyvä base themes

If you maintain a custom Hyvä base theme that directly extends `Hyva/reset`, you can migrate it to use the generated base layout reset.

**NOTE**: *This migration is optional - existing themes can continue using the reset theme without issues.*

**Migration Steps**

1. Add `<update handle="default_hyva"/>` to `Magento_Theme/layout/default.xml`.
2. Copy `Magento_Theme/templates/root.phtml` from the reset theme into the Hyvä theme.
3. Remove `<parent>Hyva/reset</parent>` from `theme.xml`.
4. Update the `theme` table in the database, setting the `parent_id` of your theme to `NULL`.
5. Add your theme code to the `hyvaBaseThemes` array in the constructor argument for `Hyva\Theme\Service\HyvaThemes` within `di.xml`.
6. Clear the cache.

The `hyva-themes/magento2-base-layout-reset` provides commands to help with these steps.

#### List Hyvä Theme reset information

To list all Hyvä themes and see their migration status, run:

```
bin/magento hyva:base-layout-resets:info
```

#### Base Layout Reset migration command

To automatically migrate a Hyvä base theme to the generated layout reset, run:

```
bin/magento hyva:base-layout-resets:migrate Vendor/theme
```

Replace `Vendor/theme` with your theme code.

**NOTE**: This command will update `app/etc/di.xml`, adding your theme to the `hyvaBaseThemes` argument of
`Hyva\BaseLayoutReset\Service\HyvaThemes`.
If you prefer not to modify `app/etc/di.xml`, you can move this declaration into a `di.xml` file inside your custom module.

*Be aware that many projects do not keep `app/etc/di.xml` in version control, and any changes may be lost. We recommend adding the declaration to a custom module `di.xml` instead.*

## Third Party Extension Compatibility

Some third party extensions may determine if a given theme is a Hyvä theme by iterating over its parents and checking if one of those has a code starting with `Hyva/` (like `Hyva/reset`).
This approach no longer works with the generated base layout, as Hyvä base themes now have no parent theme.

To determine if a theme is a Hyvä theme, the class `\Hyva\Theme\Service\HyvaThemes` should be used.
This class is available since the `hyva-themes/magento2-theme-module` release 1.3.18.

The easiest way to ensure it exists, is by adding a composer dependency on the theme-module to the extension, that is `"hyva-themes/magento2-theme-module": ">=1.3.21"`.

However, if the goal is to make an extension check for a Hyvä theme without requiring a Hyvä installation, or to stay compatible with older versions of Hyvä that don't yet have the class, the best approach is to check if the class exists, and if so, to use it.
If it doesn't exist, fall back to the existing code that checks the theme parent hierarchy names.

```
if (class_exists(HyvaThemes::class)) {
    $service = ObjectManager::getInstance()->get(HyvaThemes::class);
    return $service->isHyvaTheme($theme)
} else {
    // existing code checking the parent themes
}
```

If the subject of the check is a theme instance, the method

```
isHyvaTheme(ThemeInterface $theme)
```

is the best way to go. However, if the subject of the check is a string theme code, the method

```
isHyvaThemeCode(string $themeCode)
```

is available on the `HyvaThemes` class.
