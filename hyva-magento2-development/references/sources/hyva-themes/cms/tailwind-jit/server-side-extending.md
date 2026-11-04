<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/server-side-extending.html -->

# Extending Server-Side Compilation to Custom Content Types

For module developers

This page is only needed if you build a module with its own admin-managed HTML content type and want it compiled by the server-side daemon. Most integrations do not need it — see the note below.

[Server-side compilation](server-side-compilation.html) can be reused for your own admin-managed HTML content types. The compiler module exposes a JavaScript API that sends HTML to the daemon and returns compiled CSS per theme.

Already using the in-browser API? You may not need this

If your custom entity follows the [in-browser integration](extending.html) — the `tailwind_jit` layout handle plus `window.tailwindCSS.process()` — the bridge module **already reroutes it to the daemon** when server-side compilation is active, with no code changes. Use the direct compiler API described below only for a standalone integration that does not go through the `tailwind_jit` handle.

A complete custom-entity integration has two halves:

1. **Compile on save** — compile the content in the admin when the entity is edited, and store the result. This page covers that.
2. **Bulk recompile** — register the entity so its stored CSS can be recompiled in bulk after a configuration change. See [Extending to Custom Entities](recompiling-cms-content.html#extending-to-custom-entities) on the recompile page.

## Loading the Compiler JS API on Admin Pages

Add the compiler config block to the adminhtml layout XML for your entity's edit page handle (for example `cms_page_edit.xml`):

view/adminhtml/layout/my\_custom\_entity\_edit.xml

```
<referenceContainer name="before.body.end">
    <block class="Magento\Framework\View\Element\Template"
           name="hyva.cms.tailwind.compiler.config"
           template="Hyva_CmsTailwindCompiler::compile-config.phtml">
        <arguments>
            <argument name="view_model" xsi:type="object">Hyva\CmsTailwindCompiler\ViewModel\CompileConfig</argument>
        </arguments>
    </block>
</referenceContainer>
```

This renders the endpoint URL, authentication token, and the active Hyvä themes into the page, then loads the API at `window.HyvaCmsTailwindCompiler`.

## Compiling HTML to CSS

Call `HyvaCmsTailwindCompiler.compile()` with your content. It returns a Promise resolving to a map of theme code to compiled CSS:

```
HyvaCmsTailwindCompiler.compile({
    html: '<div class="text-blue-600 p-4 hover:bg-red-500">Content</div>',
    scopeSelector: '.hcms-myentity-42'
    // themes: optional, defaults to all active Hyvä themes
}).then(function (result) {
    // result = { "Hyva/default": ".hcms-myentity-42 .text-blue-600 { ... }" }
    // Store each theme's CSS in a hidden form field so it submits with the entity.
});
```

**Options:**

- `html` (required) — the HTML to scan for Tailwind classes.
- `scopeSelector` (optional) — a CSS selector the compiled rules are scoped under, for example `.hcms-myentity-{id}`. When omitted, the daemon returns raw, unscoped delta CSS.
- `themes` (optional) — a map of theme code to the theme's `web/tailwind` path. Defaults to all active Hyvä themes from the config block.
- `previewTheme` (optional) — a theme code to request full CSS (including preflight, no delta) for an admin preview pane.

The daemon returns only **delta CSS** — the utility classes used in the content that are not already present in the theme's compiled `styles.css` — compiled with each theme's actual Tailwind version and configuration.

## Scoping and Storage

When you pass a `scopeSelector`, the returned CSS is already scoped with that selector as an ancestor (`.hcms-myentity-42 .text-blue-600 { … }`). On the frontend, wrap the entity content in a matching container so the styles apply only there:

```
<div class="hcms-myentity-42">
    <!-- entity content, class attributes unchanged -->
</div>
```

This requires no class-attribute rewriting. The integration steps are otherwise the same as for the in-browser compiler:

1. Capture the compiled CSS (per theme) in a hidden form field so it submits with the content.
2. Create a database table to persist the compiled CSS, indexed by entity ID and theme.
3. Use an observer or plugin to store the submitted CSS on entity save.
4. On the frontend, inject the stored CSS in a `<style>` tag before the content and wrap the content in the matching scope container.

Use the same `scopeSelector` value as the `scopePattern` you register for [bulk recompilation](recompiling-cms-content.html#extending-to-custom-entities), so the admin save path and the bulk recompile path produce identically scoped CSS.
