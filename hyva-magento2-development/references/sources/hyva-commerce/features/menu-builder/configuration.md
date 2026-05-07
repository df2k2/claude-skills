<!-- source: https://docs.hyva.io/hyva-commerce/features/menu-builder/configuration.html -->

# Menu Builder Configuration

Currently available in beta

Menu Builder is currently available in beta, which means some of the features, specifications, and details provided herein are subject to change. We recommend checking back regularly for the most up-to-date information and viewing our [roadmap](https://www.hyva.io/roadmap) in regard to the general availability release.

This page shows you how to create menus in the Magento admin and render them on your Hyvä storefront. You'll learn the different ways to display Menu Builder menus, from simple configuration settings to custom template code.

## Creating a Menu

Hyvä Menu Builder menus are created and managed in the Magento admin panel. You'll find the menu management interface under **Content > Elements > Menus**.

To create a new menu:

1. **Open the menu manager**: Go to **Content > Elements > Menus** in your Magento admin
2. **Start a new menu**: Click **Add New Menu**
3. **Build your structure**: Use the Hyvä CMS editor to build your menu structure—add links, nested items, category trees, category imports, and more
4. **Save your menu**: Click Save to make your menu available for rendering

Once you've created a menu, you can render it on your storefront using any of the methods below.

## Rendering a Menu

Menu Builder gives you flexible options for displaying menus on your Hyvä storefront. You can use simple admin configuration for header and footer menus, add menus through the CMS editor, or integrate them with custom code. Pick the approach that fits your use case.

### Using Design Configuration

Design Configuration is the easiest way to set up your main header navigation and footer menu. This approach requires no code—just select your menu from a dropdown in the admin.

You can configure these Menu Builder menus through Design Configuration:

- **Header Topmenu Navigation** - Your main site navigation
- **Footer Menu** - Links in your site footer

To configure these menus, go to **Content > Design > Configuration** in your Magento admin. Pick your store view, then expand the Header and Footer sections to select which menu you want to display in each location.

### Using the Hyvä CMS Editor

The Hyvä CMS Editor lets you add menus directly to CMS pages and blocks. This is perfect for landing pages or custom content areas where you want a menu to appear.

To add a menu in the CMS editor, click the "Add Component" button and select "CMS Menu" from the content section. Then pick which menu you want to display from the dropdown. That's it.

### Using Magento Widgets

Magento widgets give you flexibility to place Menu Builder menus in specific page layouts without touching template files. Use this method when you want to add a menu to sidebars, content areas, or other widget-compatible containers.

To create a Menu Builder widget:

1. **Open the widget manager**: Go to **Content > Elements > Widgets** in your Magento admin
2. **Create the widget**: Click Add Widget and choose **Hyvä CMS Menu** as the type
3. **Set the location**: Fill in the Storefront properties and add a layout update to control where the widget appears
4. **Select your menu**: In the widget options section, pick which menu to render

### Using Widget Shortcodes

Widget shortcodes let you embed Menu Builder menus directly in CMS content, static blocks, or anywhere else that processes Magento widget directives. This is handy when you're editing content and want to quickly drop in a menu without creating a formal widget.

Here's the shortcode syntax for rendering a Menu Builder menu:

```
{{widget type="Hyva\MenuBuilder\Block\Widget\Menu" menu_identifier="my_menu"}}
```

Replace `my_menu` with your menu's identifier. You can paste this shortcode into any CMS page or block content.

### Using Layout XML

Layout XML gives you precise control over where menus appear and how they integrate with your theme's structure. Use this method when you need to add a menu to a specific container or position it relative to other blocks.

This example adds a Menu Builder menu to the main content container:

```
<referenceContainer name="content">
    <block class="Hyva\MenuBuilder\Block\Menu">
        <arguments>
            <argument name="menu_identifier" xsi:type="string">my_menu</argument>
        </arguments>
    </block>
</referenceContainer>
```

The `menu_identifier` argument specifies which menu to render. Replace `my_menu` with your menu's identifier, and change the container reference to match where you want the menu to appear.

### Using phtml Templates

When you're building custom templates, you can render Menu Builder menus directly in your phtml files. You have two approaches: define the menu block in layout XML and reference it in your template, or create the block dynamically in the template itself.

#### Approach 1: Define in Layout XML

This is the cleaner approach when you want to render a menu in a custom template. Define the menu block in your layout XML file:

your\_module/view/frontend/layout/default.xml

```
<block class="Hyva\MenuBuilder\Block\Menu" name="hyva_menu_block">
    <arguments>
        <argument name="menu_identifier" xsi:type="string">my_menu</argument>
    </arguments>
</block>
```

Then reference the child block in your phtml template:

your\_module/view/frontend/templates/example.phtml

```
<?= $block->getChildHtml('hyva_menu_block') ?>
```

This keeps your layout structure visible in XML and makes the template code simpler.

Enable shared menu block caching across pages

Add `ttl` when you want shared ESI/Varnish block caching across pages. If you do not want shared block caching the the menu will still be cached as part of each page.

Add `ttl` on the Menu block itself, for example:

```
<block class="Hyva\MenuBuilder\Block\Menu" name="hyva_menu_block" ttl="3600">
    <arguments>
        <argument name="menu_identifier" xsi:type="string">my_menu</argument>
    </arguments>
</block>
```

If you choose to add shared ESI/Varnish caching, you need to use `getChildHtml()` in the template to render the block. This ensures Magento renders through the layout pipeline (`renderElement`) where PageCache can process ESI placeholders. Calling `getChildBlock(...)->toHtml()` bypasses that ESI processing path.

#### Approach 2: Create Block Dynamically

If you need to create a menu block on the fly without layout XML, you can do it directly in your phtml template:

your\_module/view/frontend/templates/example.phtml

```
<?= $block->getLayout()
    ->createBlock(\Hyva\MenuBuilder\Block\Menu::class)
    ->setMenuIdentifier('my_menu')
    ->toHtml(); ?>
```

This approach is useful when the menu identifier is dynamic or determined at runtime. Just replace `my_menu` with your menu's identifier or a variable containing it.
