<!-- source: https://docs.hyva.io/hyva-themes/faqs/javascript-files-and-compilers.html -->

# Can we use JS files and compilers?

Yes. Hyvä does not prevent you from adding a build process, a `main.js` file, or any other JavaScript tooling on top of the default theme. The default theme is intentionally lightweight, but you can add anything to it.

That said, Hyvä itself does not use a compiler or separate JS files by default. This is a deliberate design decision.

## Why Hyvä does not use a build process by default

Running JavaScript through a compiler or bundler introduces trade-offs that work against Hyvä's goals:

1. **Added complexity**: a build step adds tooling that every developer working on the project needs to understand and maintain.
2. **Larger bundles**: polyfilled or transpiled output is larger than the original source and replaces native browser functionality with emulated versions.
3. **Reduced debuggability**: compiled output is harder to read and debug in the browser. Source maps help, but they add another layer of indirection.
4. **Dead code**: bundled files tend to include more code than any single page actually uses. This grows over time as features are added and old code is kept for backwards compatibility.

Modern browsers support everything Hyvä needs natively. There is no technical requirement for a compiler.

## Why Hyvä uses inline JavaScript

Inline JavaScript, written directly in `.phtml` templates alongside HTML, is the core architectural choice that makes Hyvä work the way it does.

1. **Component isolation**: JavaScript, HTML, and Tailwind classes live together in one template. There is no need to trace across files to understand or debug a component.
2. **Only load what is rendered**: if a component is not on the page, its JavaScript is not loaded or evaluated. This mirrors exactly how Tailwind handles CSS.
3. **No dead code**: because the JavaScript is written specifically for one component, it contains only the methods that component actually uses. A generic slider library bundles every effect it supports regardless of what you need.
4. **Replaceable templates**: a well-written `.phtml` template has no external dependencies. You can move the cart drawer, messages bar, or PDP gallery anywhere on the page and they continue to work. Replacing a component means replacing a single file.

These properties combine to make the development experience fast, predictable, and easy to reason about.
