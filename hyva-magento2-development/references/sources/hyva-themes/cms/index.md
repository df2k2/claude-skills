<!-- source: https://docs.hyva.io/hyva-themes/cms/index.html -->

# CMS Content and Hyvä

Magento offers several ways to manage and render CMS content, and Hyvä supports all of them. This chapter covers how to style CMS text, use Tailwind classes in database-managed content, and create full-bleed layouts that break out of the page container.

Third-party headless CMS integrations like [Prismic](https://github.com/elgentos/magento2-prismicio) and [Storyblok](https://www.slideshare.net/mzeis/headless-cms-for-magento-using-hyv-and-storyblok) are also available. For many projects, the built-in CMS Pages, Blocks, PageBuilder, and Widgets are sufficient.

Looking for the most integrated CMS experience?

[Hyvä CMS](../../hyva-commerce/features/cms/index.html) is part of Hyvä Commerce and is the recommended choice for projects that need a powerful, native content editing experience. See the [Hyvä Commerce page](https://www.hyva.io/hyva-commerce.html) for licensing details.

## What is in this chapter

- [Styling CMS Text Content](cms-content-text-styling.html): using the `prose` class to restore default browser styles for HTML managed in CMS blocks and pages.
- [Full Bleed CMS Content](full-bleed-cms-content.html): three techniques for breaking content out of the page container to achieve full-width layouts.
- **CMS Tailwind JIT Module**: the module that enables Tailwind CSS classes in CMS-managed content.
  - [Overview](tailwind-jit/index.html): what the module is, how it works, and supported content types.
  - [Installation](tailwind-jit/installation.html): installing the module, selecting the Tailwind compiler version (v3 or v4), and configuring instances without PageBuilder.
  - [Configuration](tailwind-jit/configuration.html): per-theme Tailwind configuration for in-browser compilation, for both Tailwind v3 and v4.
  - [Server-Side Compilation](tailwind-jit/server-side-compilation.html): moving Magento CMS Tailwind compilation to a server-side daemon, with bulk recompilation.
  - [Alpine.js and Single-Quoted Classes](tailwind-jit/alpine-js.html): escaping single quotes in Alpine.js `:class` bindings.
  - [Extending to Custom Content Types](tailwind-jit/extending.html): the JavaScript API and integration steps for custom content types.
