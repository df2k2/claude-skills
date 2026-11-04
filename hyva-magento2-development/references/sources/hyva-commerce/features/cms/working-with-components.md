<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/working-with-components.html -->

# Working with Hyvä CMS Components

Hyvä CMS component development allows you to create custom components or override existing components to match your project's design system. Developers can build reusable content blocks with custom fields, template variants, and validation rules that content editors use through the visual drag-and-drop interface.

For developers

This section is developer documentation for building and customizing Hyvä CMS components in code. Merchants do not work with these files directly: they build content from the components you provide, using the [Liveview Editor](editor.html).

## Ways to Customize Hyvä CMS Components

Hyvä CMS supports three approaches to component customization:

**[Creating new components](creating-components.html):** Build custom components from scratch with project-specific fields, templates, and functionality. Create components when you need content blocks that don't exist in the [base component library](built-in-components.html) or when you want components tailored to your design system.

**[Overriding existing components](overriding-existing-components.html):** Modify base components provided by Hyvä CMS through template overrides (for visual changes) or component definition overrides (for structural changes). Override components when you want to customize how existing components look or behave.

**[Creating instance components](features/instance-components.html):** Create database-backed components from the editor when a trusted admin user needs a reusable component or variant without a deployment. Instance components are useful for quick site-specific reuse, but code-defined components remain the preferred approach for long-lived design-system components.

## Choosing the Right Approach

Use this decision framework to determine which approach fits your needs:

- **Need a new content type?** Create a new component
- **Want to change component styling or HTML structure only?** Override the component template in your theme
- **Need to add fields or change component behavior?** Override the component definition in a custom module
- **Need an input type the built-in fields don't cover?** [Create a custom field type](creating-custom-component-fields-types.html)
- **Building a custom design system?** Create custom components using base components as reference examples
- **Need a reusable admin-created section quickly?** Create an instance component, then move it into code later if it becomes part of the permanent design system

Best Practice: Design Components for Content Editors, Not Developers

When building or customizing Hyvä CMS components, merchants should never need to add CSS classes or understand JavaScript code to create content.

Build components with specific fields and variant templates so content editors choose how to display content through simple dropdown options and form fields, not by manually adding CSS classes or code snippets to content fields.

This approach creates a consistent design system and significantly better user experience for content editors compared to traditional page builder tools.

## Component Development Philosophy

Hyvä CMS base components serve as quick-start examples and reference implementations for common content types. Most projects require only 20-30 well-designed components to support their content needs. Creating custom Hyvä CMS components is fast and straightforward, making it practical to build project-specific component libraries rather than relying entirely on base components.

Component Count as Design Signal

Adding too many components to a Hyvä CMS installation indicates inconsistent content structure and design decisions. Excessive components make the interface difficult for content editors to navigate. Aim for a focused set of well-designed components rather than a large library of specialized variations.

## In This Section

- [Built-in Components](built-in-components.html): the base component library included with Hyvä CMS.
- [Creating Components](creating-components.html): build a component from scratch, its declaration and template.
- [Component Fields and Validation](component-fields.html): field validation and input attributes, reusable field includes, and style variants.
- [Parent-Child Components](component-nesting.html): nesting child components and restricting where components can be added.
- [Component Templates](component-templates.html): the `Element` block helper methods and rendering patterns for links, children, images, and CSS classes.
- [Component Declaration Schema Reference](component-declaration-schema.html): the full reference for every component and field property.
- [Overriding Existing Components](overriding-existing-components.html): customize, replace, or disable base components.
