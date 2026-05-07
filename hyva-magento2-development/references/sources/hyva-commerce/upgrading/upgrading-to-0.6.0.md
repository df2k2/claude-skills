<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-0.6.0.html -->

# Upgrading to Hyvä Commerce 0.6.0

This is a feature release for Hyvä CMS that includes various bug fixes and improvements.

## Notable news

### Hyvä CMS

#### Backward incompatible changes

##### Component children fields

Component children fields must now be declared in the root of the component declaration, in `hyva_cms/components.json`.
See [example here](../features/cms/creating-components.html#creating-parent-child-component-relationships).

If your project has **custom components** that use children fields, you will need to update them to the new format.
To help with this, there is a migration script that will help you with the upgrade.

The upgrade script and instructions to use it can be found in the README of: <https://gitlab.hyva.io/hyva-themes/upgrade-helpers>.

The script `./bin/hyva-cms-0.6.0-migrate-children-field.js` will update your `hyva_cms/components.json` files to use the correct schema. You may also need to update your frontend component templates to render children fields correctly with:

```
<?php if (count($block->getData('children'))): ?>
    <?php foreach ($block->getData('children') ?: [] as $elementData): ?>
        <?= $block->createChildHtml($elementData, 'your_component_child') ?>
    <?php endforeach; ?>
<?php else: ?>
```

##### CTA Component Deprecation

The CTA component has been merged into the Banner component. Existing CTA components will continue to display but cannot be edited through the CMS interface. To regain editing capability there are two options:

- Option 1: Migrate to Banner Component

  1. Remove the existing CTA component from their content from within the Hyvä CMS editor.
  2. Add a new Banner component with the desired configuration.
- Option 2: Recreate as Custom Component
  Add the below JSON declaration to your `etc/hyva_cms/components.json` file to recreate the CTA component.

  CTA Component JSON Declaration

  ```
  "cta": {
      "label": "CTA",
      "category": "Media",
      "icon": "Hyva_CmsBase::images/components/cta.svg",
      "template": "Hyva_CmsBase::elements/cta/image.phtml",
      "content": {
      "title": {
          "type": "richtext",
          "label": "Title",
          "default_value": "Excuses don't burn calories"
      },
      "subtitle": {
          "type": "richtext",
          "label": "Subtitle",
          "default_value": "Make sure each work-out is better than the last with our ProFit collection."
      },
      "image": {
          "type": "image",
          "label": "Image"
      },
      "desktop_image": {
          "type": "image",
          "label": "Desktop Image"
      },
      "children": {
          "type": "children",
          "label": "Buttons",
          "config": {
          "accepts": ["button"]
          }
      },
      "loading": {
          "type": "select",
          "label": "Loading",
          "default_value": "lazy",
          "options": [
          {
              "label": "Lazy",
              "value": "lazy"
          },
          {
              "label": "Eager",
              "value": "eager"
          }
          ]
      },
      "variants": {
          "type": "variant",
          "label": "Variant",
          "options": [
          {
              "label": "Image",
              "value": "Hyva_CmsBase::elements/cta/image.phtml"
          },
          {
              "label": "Text",
              "value": "Hyva_CmsBase::elements/cta/text.phtml"
          },
          {
              "label": "Split",
              "value": "Hyva_CmsBase::elements/cta/split.phtml"
          }
          ]
      }
      }
  }
  ```

  See the [creating components](../features/cms/creating-components.html) guide for more information on how to declare a custom component.

##### Hyvä CMS Integration Changes

Only affects custom integrations of Hyvä CMS with other content types

These changes only impact projects that have [extended Hyvä CMS for other content types](../features/cms/extending-for-other-content-types.html).

Projects that have extended Hyvä CMS for custom content types must update their `Hyva\CmsLiveviewEditor\Api\ProviderInterface` implementations and use the classes in `Hyva\CmsLiveviewEditor\Model\Tailwind` to be compatible with this version. For more information see the [extended Hyvä CMS for other content types](../features/cms/extending-for-other-content-types.html) doc.

## Changelogs

The changelog is available [here](changelog.html#060-2025-06-26).

## Known Issues

See bugfixes in the [1.0.0 release](upgrading-to-1.0.0.html).
