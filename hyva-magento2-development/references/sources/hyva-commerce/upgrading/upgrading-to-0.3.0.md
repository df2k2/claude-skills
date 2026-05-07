<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-0.3.0.html -->

# Upgrading to Hyvä Commerce 0.3.0

This is a feature release for Hyvä CMS that introduces new components, enhanced validation capabilities, and CSP support, along with several bug fixes.

## Notable news

### Hyvä CMS

#### Backward incompatible changes

Only affects custom field types

This change only impacts projects that have added custom field type templates. If you haven't created any custom field types, you can skip this section.

Field types now require wrapping in a `#field-container-[uid]_[field name]` div for frontend validation. This affects any custom field type templates that may have been added to your project.

To update your custom field type templates, wrap the field content in a div with the required ID format. For example:

```
<div id="field-container-<?= $uid ?>_<?= $fieldName ?>">
    <!-- Your existing field template content -->
</div>
```

For proper display of validation messages, it's recommended to also include a container div with the following ID format:

```
<div id="validation-messages-<?= $escaper->escapeHtmlAttr("{$uid}_{$fieldName}") ?>"></div>
```

See the documentation for more information on how to create a [custom field type template](../features/cms/creating-custom-component-fields-types.html#creating-the-custom-field-type-template).

## Changelogs

The changelog is available [here](changelog.html#030-2025-05-06).

## Known Issues

See bugfixes in the [0.4.0 release](upgrading-to-0.4.0.html).
