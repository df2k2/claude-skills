<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/csp-compatibility.html -->

# CSP Compatibility: Understanding unsafe-eval and unsafe-inline Restrictions

Content Security Policy (CSP) compatibility for Hyvä developers involves two distinct restrictions: the `unsafe-eval` directive that affects Alpine.js expressions, and the `unsafe-inline` directive that affects script tag execution. Understanding both restrictions is essential for building CSP-compliant Hyvä themes that meet PCI-DSS 4.0 requirements.

## The unsafe-eval Restriction

The `unsafe-eval` CSP directive controls whether JavaScript code can be dynamically created and executed at runtime. When `unsafe-eval` is disallowed (strict CSP mode), the following operations are forbidden:

- Using the `eval()` function
- Creating functions dynamically with the [`Function` constructor](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/Function)

**Why this affects Alpine.js:** Standard Alpine.js uses the `Function` constructor to evaluate attribute expressions like `:class="{'hidden': !open}"`. Each expression in the HTML is converted to a JavaScript function at runtime. This dependency on dynamic function creation means standard Alpine.js cannot work under strict CSP without `unsafe-eval`.

### How Hyvä Works Without unsafe-eval

Hyvä provides a CSP-compatible theme version that uses the Alpine CSP build instead of standard Alpine.js. The Alpine CSP build does not evaluate JavaScript expressions in HTML attributes. Instead, all bindings must reference pre-defined component properties or methods.

In the CSP-compatible theme, all attribute bindings that previously used inline expressions are converted to methods on the Alpine components. For example, `:class="{'hidden': !open}"` becomes `:class="hiddenClass"` where `hiddenClass` is a method that returns the appropriate class object.

See the [Alpine CSP documentation](./alpine-csp.html) for detailed migration guidance.

## The unsafe-inline Restriction

The `unsafe-inline` CSP directive controls whether inline `<script>` tags can execute. When `unsafe-inline` is disallowed, only explicitly authorized scripts are allowed to run. This protection prevents injected malicious scripts from executing, even if an attacker manages to insert them into the page HTML.

**Script authorization methods:** Scripts can be authorized in two ways:

1. **Nonce-based authorization**: A cryptographic nonce (number used once) is added to the script tag as an attribute, and the same nonce is included in the CSP HTTP header
2. **Hash-based authorization**: A SHA-256 hash of the script content is included in the CSP HTTP header

**Inline event handlers are also forbidden** without `unsafe-inline`. Code like `<a href="..." onclick='this.target="_blank"'>` will not execute under strict CSP.

### How Hyvä Works Without unsafe-inline

Hyvä uses a dual authorization strategy: nonce-based authorization on uncached pages, and SHA hash-based authorization on cached pages. This approach ensures CSP compliance while maintaining compatibility with Magento's full-page cache.

To authorize an inline script, call `$hyvaCsp->registerInlineScript()` immediately after the closing script tag:

Authorizing an inline script for CSP

```
<script>
    // Your JavaScript code here
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

The `$hyvaCsp` template variable is available in every Hyvä theme template, similar to `$block` and `$viewModels`.

Critical: Position of registerInlineScript()

The `$hyvaCsp->registerInlineScript()` call must appear directly after the closing `</script>` tag with no HTML in between. The method calculates the script hash based on the immediately preceding script content.

If a template contains multiple inline scripts, call `$hyvaCsp->registerInlineScript()` after each one.

Template Variable Availability

The `$hyvaCsp` template variable is available in **Hyvä theme** and **Hyvä Admin theme** templates only. On Luma-based storefronts, the variable is not defined.

When building modules that support both Hyvä and Luma themes, only reference `$hyvaCsp` in frontend templates declared within `hyva_*` layout handles to avoid undefined variable errors.

## Summary

| CSP Directive | What It Restricts | Hyvä Solution |
| --- | --- | --- |
| `unsafe-eval` | Dynamic JavaScript evaluation (`eval()`, `new Function()`) | Alpine CSP build with pre-defined methods instead of inline expressions |
| `unsafe-inline` | Inline script execution | Nonce/SHA authorization via `$hyvaCsp->registerInlineScript()` |
