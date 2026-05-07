<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/supported-versions.html -->

# Supported TailwindCSS Versions

Hyvä aims to support the latest stable TailwindCSS release.

## Updating TailwindCSS

Updating TailwindCSS isn't always straightforward.
We consider several factors, including backward and browser compatibility, before updating Tailwind in a Hyvä Theme release.

If you plan to update TailwindCSS in your child theme for a specific feature, consider the following:

- **Is the update necessary?**
  We strive to provide alternative solutions.
  Remember, TailwindCSS is a tool, and plain CSS might solve your issue.
- **Understand Node and NPM:**
  Updating TailwindCSS can lead to Node script errors.
  Familiarity with these tools is crucial for debugging.
- **Be aware of potential breaking changes:**
  There's often a reason we haven't updated yet.
  Minor updates might be simple,
  but major version bumps can introduce breaking changes.

### TailwindCSS v4 (current)

TailwindCSS v4 introduces greater flexibility for sizing options,
improved CSS component extensibility,
and the use of CSS variables.

It replaces the JavaScript configuration with a CSS configuration, further aligning it with CSS.

Hyvä Theme releases 1.4.x use TailwindCSS v4.

### TailwindCSS v3

This version enhances TailwindCSS v2 features and fully leverages the JIT compiler,
significantly improving the developer experience.

The JIT compiler eliminates the need for `@variants` configuration, as all variants (and more) are now supported.

Learn more about v3 features at [v3.tailwindcss.com/](https://v3.tailwindcss.com/).

Hyvä Theme releases 1.2.x and 1.3.x used TailwindCSS v3.

### TailwindCSS v2

This was the first supported TailwindCSS version in Hyvä.
It added support for modern browser features and dropped IE support.

This version was used in Hyvä Theme releases 1.0.x and 1.1.x.

Learn more about v2 features at [v2.tailwindcss.com/](https://v2.tailwindcss.com/).
