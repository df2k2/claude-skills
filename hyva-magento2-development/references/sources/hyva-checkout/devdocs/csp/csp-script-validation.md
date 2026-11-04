<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/csp/csp-script-validation.html -->

# CSP Script Authorization

Strict Content Security Policy (CSP) requires scripts to be explicitly authorized before execution. Unauthorized scripts will not execute, and the browser logs CSP violation errors to the console. Script authorization applies to inline scripts and external third-party scripts equally.

## How Script Authorization Works

CSP script authorization uses cryptographic nonces (a number used once) to identify legitimate scripts. Each inline script requires a `nonce` attribute that matches the value specified in the `Content-Security-Policy` HTTP header. Nonces must be unique for every request to prevent replay attacks and maintain security.

The nonce mechanism works by:

1. Server generates a unique nonce value for the current request
2. Server includes the nonce in the CSP HTTP header
3. Inline scripts include the matching nonce attribute
4. Browser compares nonce values and executes only authorized scripts

## Evaluated Code and Inline Event Handlers

Strict CSP prohibits dynamically evaluated code, including inline event handlers like `onclick`, `onload`, or `onerror`. The `unsafe-eval` policy prevents the browser from executing code passed to `eval()`, `setTimeout()` with string arguments, `Function()` constructor, and inline event attributes.

### Migrating Inline Event Handlers

Consider a button with an `onclick` event handler to navigate to the homepage:

```
<button onclick="window.location = '/'">Bring me home</button>
```

The browser evaluates the inline event callback when the button is clicked. If the `unsafe-eval` policy is disabled under strict CSP, the event handler will not execute. To maintain the behavior with strict CSP, migrate the code to a script block with a valid nonce:

```
<button id="bring-me-home">Bring me home</button>

<!-- a header Content-Security-Policy: script-src 'nonce-fdaef31321' must be included -->
<script nonce="fdaef31321">
    document.getElementById('bring-me-home').addEventListener('click', () => {
        window.location = '/';
    }
</script>
```

If you want to know more about nonce generation, take a look in the [CSP Nonce and SHA hashes](../../../hyva-themes/writing-code/csp/nonce-and-sha-hashes.html) section.

## Injected Scripts and Dynamic Content

With strict CSP, inline scripts cannot be added to the page content once the page is loaded. The browser will refuse to execute any script element inserted into the DOM after the initial page load, even if it has a valid nonce attribute. This is especially relevant to Magewire component templates.

All scripts used by Magewire components must be extracted into separate templates and included in the initial page load. The script authorization happens during the initial page render, not during dynamic component updates.

More information on extracting scripts is available in the [Move scripts to page load](csp-move-scripts-page-load.html) section.

## Authorization of Inline Scripts

To authorize an inline script for execution under strict CSP, add a `<?php $hyvaCsp->registerInlineScript() ?>` statement directly after the closing `</script>` tag. The HyvaCsp view model automatically adds the nonce attribute with the correct value for the current request.

This registration pattern applies to all inline script blocks in your templates:

```
<script>
    // Your JavaScript code here
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

The `registerInlineScript()` method must be called immediately after each script block that needs authorization. The method injects a nonce attribute into the preceding script tag, allowing the browser to execute the script under strict CSP.

## Loading Scripts from External Sources

External scripts loaded from third-party domains must also be authorized under strict CSP. In Magento, external script sources are authorized by adding the domain to the `csp_whitelist.xml` configuration file.

For detailed instructions on authorizing external script sources, refer to the Magento documentation: [add domains to the whitelist](https://developer.adobe.com/commerce/php/development/security/content-security-policies#add-a-domain-to-the-whitelist).

Better way to handle whitelisting

Install our CSP Allowlist module to automatically detect which external script sources are used for a specific page.

More information on the module is available in the [Content Security Policy Allowlist](../../../hyva-themes/writing-code/csp/content-security-policy-allowlist.html).
