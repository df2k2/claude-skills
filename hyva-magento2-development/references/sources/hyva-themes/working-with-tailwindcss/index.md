<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/index.html -->

# Working with TailwindCSS in Hyva

Since release 1.4.0 Hyva uses Tailwind v4.

Hyva uses the [TailwindCSS](https://tailwindcss.com/) utility-first CSS framework to build templates that are easy to customize, look great on all devices, and produce minimal CSS output - reducing the amount of data your visitors need to download.

## What Is TailwindCSS?

TailwindCSS is a utility-based CSS framework. Instead of writing custom CSS classes, you compose the design of each element directly in your markup using predefined utility classes. This approach keeps your styles visible right where they are used, making templates faster to scan and easier to maintain.

Here is a quick TailwindCSS example showing how utility classes map to traditional CSS:

```
<div class="m-4 mt-8 p-2 bg-primary border border-secondary w-full md:w-1/2">
```

The TailwindCSS utility classes above translate to this equivalent CSS:

```
div {
    margin: 1rem;          /* m-4 */
    margin-top: 2rem;      /* mt-8 */
    padding: 0.5rem;       /* p-2 */
    background-color: #f1f1f1; /* bg-primary - color defined in Hyva config */
    border-width: 1px;     /* border */
    border-color: #c9c9c9; /* border-secondary - color defined in Hyva config */
    width: 100%;           /* w-full */
}

@media (min-width: 768px) {
    div {
        width: 50%;        /* md:w-1/2 */
    }
}
```

If the example above makes sense to you, you will find it very easy to work with the design concepts in Hyva templates.

Learn TailwindCSS First

It is highly recommended to look into the [TailwindCSS documentation](https://tailwindcss.com/docs) before getting started with your Hyva theme.

The Hyva Default Theme ships with different TailwindCSS versions depending on the release:

- **TailwindCSS v4.x** - Default Theme v1.4.x
- **TailwindCSS v3.x** - Default Theme v1.2.x and v1.3.x
- **TailwindCSS v2.x** - Default Theme v1.0.x and v1.1.x

## TailwindCSS Documentation and Learning Resources

### Official TailwindCSS Documentation

- TailwindCSS v4 Docs: [tailwindcss.com/docs](https://tailwindcss.com/docs)
- TailwindCSS v3 Docs: [v3.tailwindcss.com/docs](https://v3.tailwindcss.com/docs)
- TailwindCSS v2 Docs: [v2.tailwindcss.com/docs](https://v2.tailwindcss.com/docs)

### Learning TailwindCSS

- TailwindCSS Cheatsheet: [tailwindcheatsheets.com](https://tailwindcheatsheets.com/)

IDE and Editor Support for TailwindCSS

TailwindCSS plugins are available for popular IDEs and editors. Check the [Editor Setup documentation](editor-setup.html) for PHPStorm and VSCode configuration, including Intellisense support that makes writing TailwindCSS classes much easier.

Share Your Learning Resources

If you have learning material that could help other Hyva developers, feel free to share it on the Hyva Slack or create an issue on the [Hyva Docs GitLab page](https://gitlab.hyva.io/hyva-themes/hyva-docs).

## Related Topics

- [Generating CSS with TailwindCSS](generating-css.html) - How to compile TailwindCSS in your Hyva theme
- [Hyva Theme CSS Files](hyva-theme-css-files.html) - Understanding the CSS file structure in Hyva
- [Editor Setup for TailwindCSS](editor-setup.html) - Configure your IDE for TailwindCSS development
- [Dynamic Tailwind Classes](dynamic-tailwind-classes.html) - Working with dynamic class names in Hyva templates
