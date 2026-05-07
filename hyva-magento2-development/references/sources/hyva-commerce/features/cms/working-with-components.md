<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/working-with-components.html -->

# Working with Hyvä CMS Components

Hyvä CMS component development allows you to create custom components or override existing components to match your project's design system. Developers can build reusable content blocks with custom fields, template variants, and validation rules that content editors use through the visual drag-and-drop interface.

## Two Ways to Customize Hyvä CMS Components

Hyvä CMS supports two approaches to component customization:

**Creating new components** - Build custom components from scratch with project-specific fields, templates, and functionality. Create components when you need content blocks that don't exist in the base component library or when you want components tailored to your design system.

**Overriding existing components** - Modify base components provided by Hyvä CMS through template overrides (for visual changes) or component definition overrides (for structural changes). Override components when you want to customize how existing components look or behave.

## Choosing the Right Approach

Use this decision framework to determine which approach fits your needs:

- **Need a new content type?** Create a new component
- **Want to change component styling or HTML structure only?** Override the component template in your theme
- **Need to add fields or change component behavior?** Override the component definition in a custom module
- **Building a custom design system?** Create custom components using base components as reference examples

Best Practice: Design Components for Content Editors, Not Developers

When building or customizing Hyvä CMS components, merchants should never need to add CSS classes or understand JavaScript code to create content.

Build components with specific fields and variant templates so content editors choose how to display content through simple dropdown options and form fields, not by manually adding CSS classes or code snippets to content fields.

This approach creates a consistent design system and significantly better user experience for content editors compared to traditional page builder tools.

## Component Development Philosophy

Hyvä CMS base components serve as quick-start examples and reference implementations for common content types. Most projects require only 20-30 well-designed components to support their content needs. Creating custom Hyvä CMS components is fast and straightforward, making it practical to build project-specific component libraries rather than relying entirely on base components.

Component Count as Design Signal

Adding too many components to a Hyvä CMS installation indicates inconsistent content structure and design decisions. Excessive components make the interface difficult for content editors to navigate. Aim for a focused set of well-designed components rather than a large library of specialized variations.

## Related Topics

- **[Creating Components](creating-components.html)** - Complete guide to building custom Hyvä CMS components with fields, templates, variants, and validation
- **[Overriding Existing Components](overriding-existing-components.html)** - How to customize base components through template overrides and component definition overrides
- **[Component Declaration Schema](component-declaration-schema.html)** - Reference documentation for all component configuration options and field types
