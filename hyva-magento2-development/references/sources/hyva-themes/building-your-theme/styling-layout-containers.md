<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/styling-layout-containers.html -->

# Styling Magento Layout Containers with Tailwind CSS in Hyvä Themes

Hyvä themes allow you to style Magento layout XML containers using Tailwind CSS utility classes. By adding `htmlTag` and `htmlClass` attributes to container elements in layout XML, you can apply Tailwind classes directly to structural page elements without creating custom templates.

Using Tailwind classes in Magento layout XML presents two challenges: Magento's XML schema restricts which characters are allowed in class names, and Tailwind's content scanning must be configured to include XML files. This page covers both issues and their solutions.

## How Magento Container HTML Attributes Work in Layout XML

When a Magento layout XML container includes the `htmlTag` attribute, Magento renders that container as an HTML element. The `htmlClass` attribute sets the `class` attribute on the rendered element.

The following layout XML example creates a `div` element with three Tailwind utility classes:

```
<container name="example" htmlTag="div" htmlClass="container mx-auto px-4">
```

Magento renders the container above as a standard HTML `div`:

```
<div class="container mx-auto px-4">...</div>
```

## XML Schema Validation Errors with Tailwind Class Names

Magento's layout XML schema uses a strict regex pattern for `htmlClass` values. Many Tailwind CSS utility classes contain characters like `/`, `:`, `[`, `]`, and `.` that violate the Magento schema pattern. Using these Tailwind classes in layout XML triggers a validation error.

For example, the Tailwind class `w-1/3` contains a forward slash, which the Magento schema does not allow:

```
<container name="columns" htmlTag="div" htmlClass="columns order-2 w-1/3">
```

Magento throws the following validation exception for the `w-1/3` class:

```
Exception #0 (MagentoFrameworkConfigDomValidationException):
Element 'container', attribute 'htmlClass': [facet 'pattern']
The value 'columns order-2 w-1/3' is not accepted by the pattern
'[a-zA-Z][a-zA-Z\d\-_]*(\s[a-zA-Z][a-zA-Z\d\-_]*)*'.
```

Two workarounds exist for this Magento XML schema limitation: patching the schema, or moving styles to CSS.

### Patching the Magento XML Schema to Allow Tailwind Classes

A [pull request](https://github.com/magento/magento2/pull/36452) to fix the Magento XML schema was merged in February 2023 but has not been included in all Magento releases. You can apply the following patch to your Magento installation to widen the allowed character set in `htmlClass` values (contributed by Arjen Miedema).

The patch modifies the `htmlClassType` regex pattern in the Magento framework's `elements.xsd` file:

```
@package magento/framework

diff --git View/Layout/etc/elements.xsd View/Layout/etc/elements.xsd
index 51f1931..14baa00 100644
--- View/Layout/etc/elements.xsd
+++ View/Layout/etc/elements.xsd
@@ -119,7 +119,7 @@

     <xs:simpleType name="htmlClassType">
         <xs:restriction base="xs:string">
-            <xs:pattern value="[a-zA-Z][a-zA-Z\d\-_]*(\s[a-zA-Z][a-zA-Z\d\-_]*)*"/>
+            <xs:pattern value="[a-zA-Z\d\-_/:.\[\]&amp;@()! ]*"/>
         </xs:restriction>
     </xs:simpleType>
```

Check your Magento version first

If your Magento version already includes the upstream fix, you do not need this patch. Test by adding a Tailwind class with a special character (like `w-1/2`) to a container's `htmlClass` and checking whether validation passes.

### Using Custom CSS Instead of Tailwind Classes in Layout XML

Instead of patching Magento's XML schema, you can avoid the validation issue entirely by defining container styles in your Hyvä theme's CSS file. The file `web/tailwind/theme/page-layout.css` is specifically designed for page structure styling in Hyvä themes.

With this approach, you assign a simple class name in layout XML and use Tailwind's `@apply` directive in CSS to compose the utility classes. The layout XML only needs a basic, schema-safe class name:

```
<container name="columns" htmlTag="div" htmlClass="columns">
```

Then define the Tailwind utility styles for the `columns` class in your theme's `page-layout.css` file:

```
/* web/tailwind/theme/page-layout.css */
.columns {
    @apply order-2 w-1/3;
}
```

The CSS-based approach offers several advantages for Hyvä theme development:

- **No Magento patches required** - the solution works across all Magento versions without modifying core files
- **Easier to maintain** - structural layout styles live in one CSS file rather than being scattered across layout XML files
- **Better readability** - complex Tailwind class combinations are easier to read and update in CSS than in XML attributes
- **Forward compatible** - no risk of patch conflicts when upgrading Magento

## Configuring Tailwind Content Scanning for Layout XML Files

Hyvä version 1.2.x and later automatically includes layout XML files in the Tailwind content path. Tailwind scans these XML files during stylesheet generation, so any utility classes in `htmlClass` attributes are detected and included in the compiled CSS.

For Hyvä projects using version 1.0.x or 1.1.x, Tailwind does not scan layout XML files by default. You need to manually add layout XML file patterns to your Tailwind content configuration to ensure classes used in `htmlClass` attributes appear in the production stylesheet.

Related Topics

- [Tailwind CSS Purging Settings](../working-with-tailwindcss/tailwind-purging-settings.html) covers how to configure which files Tailwind scans for class names.
- [Using Tailwind Classes in CMS Content](../cms/using-tailwind-classes-in-cms-content.html) addresses a similar challenge of using Tailwind in non-template contexts.
