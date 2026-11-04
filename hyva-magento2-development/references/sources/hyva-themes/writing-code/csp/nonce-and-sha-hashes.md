<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/nonce-and-sha-hashes.html -->

# Nonce and SHA Hashes for CSP in Magento

## What Is a CSP Nonce in Magento (Adobe Commerce)?

In Magento (Adobe Commerce) **Content Security Policy (CSP)**, a **nonce** ("number used once") is a **cryptographically secure, random token** generated **per HTTP request**. Magento adds this nonce to the CSP response header and uses it to **authorize specific inline** `<script>` and `<style>` blocks.

Without a nonce, **inline scripts and styles are blocked by default** under a strict CSP, because inline code is a common XSS attack vector.

## Why CSP Needs Nonces to Allow Inline Scripts

CSP is designed to reduce the impact of attacks like:

- **Cross-Site Scripting (XSS)**
- **Injection of malicious inline JavaScript**
- **Execution of unauthorized scripts**

A nonce allows the browser to run *only the inline code you explicitly authorize*.

## How a CSP Nonce Works in Magento

**1) Magento generates a random nonce per request**

Example nonce value: `abc123xyz456`

**2) Magento sends the nonce in the CSP header**

```
Content-Security-Policy: script-src 'self' 'nonce-abc123xyz456';
```

**3) Inline scripts must include the matching nonce**

```
<script nonce="abc123xyz456">
    console.log('Hyvä supports CSP');
</script>
```

**4) The browser validates the nonce**

The browser checks:

- Does the `<script>` tag include a `nonce` attribute?
- Does the nonce **exactly match** the one in the CSP header?

If it matches: **the script executes**
If it doesn't: **the script is blocked** (and you'll see a CSP violation in the browser console)

## Default Magento Nonce Generation

Magento added CSP enforcement in **2.3.5+**, and tightened it further in **2.4+**. Magento's CSP system typically:

- generates a nonce per request
- exposes the nonce during rendering
- injects the nonce into the CSP header

### Luma Nonce Example: Secure Inline Script Rendering

In Luma (non-Hyvä) themes, you use Magento's `$secureRenderer` to output inline scripts with a nonce:

```
<?= $secureRenderer->renderTag('script', [], 'console.log("Luma supports CSP")', false); ?>
```

### Registering Inline Scripts for CSP in Hyvä Themes

In Hyvä Themes, you **don't manually output a nonce or CSP hash**. Instead, you register each inline script block and Hyvä applies the correct CSP authorization automatically.

Place `$hyvaCsp->registerInlineScript()` **immediately after** the closing `</script>` tag:

```
<script>
    // Your JavaScript code here
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Rule of thumb

Call `$hyvaCsp->registerInlineScript()` right after **every** inline script block that must run under strict CSP.

## SHA-256 Hashes in Magento CSP (for Cached Pages)

Magento CSP also supports **SHA-256 script hashes** as an alternative to nonces. A **CSP hash** allows a browser to execute an inline script **only if the script content matches a hash listed in the CSP header**.

SHA-256 hashes are especially useful for **cached HTML pages** (for example **FPC** or reverse-proxy caches like **Varnish**) because:

- A nonce is **different on every request**, which makes "byte-identical HTML" harder (or impossible) to cache safely.
- A SHA-256 hash is **stable as long as the inline script content is identical**, which plays nicely with cached responses.

Nonce vs hash: quick mental model

- **Nonce**: "This inline script is allowed because the server said so *for this request*."
- **SHA-256 hash**: "This inline script is allowed because its content matches *exactly* what the policy expects."

### How a SHA-256 CSP Hash Works

**1) The CSP header includes a `sha256-...` source expression**

**2) The browser hashes the inline script content**

The browser computes SHA-256 over the inline script **bytes** (the exact characters as delivered in the HTML).

**3) The browser compares the computed hash to the CSP header**

- If the hash matches: **the inline script executes**
- If it doesn't match: **the inline script is blocked** (CSP violation in the console)

### CSP Header Format with Multiple SHA-256 Hashes

You can allow more than one inline script by adding multiple `sha256-...` entries to the `script-src` directive. Each `sha256-...` value corresponds to one exact inline script block (based on its exact bytes, including whitespace and line breaks).

```
Content-Security-Policy: script-src 'self' 'sha256-hash1' 'sha256-hash2'; base-uri 'self';
```

If you also need external scripts, keep the hashes and add the required sources:

```
Content-Security-Policy: script-src 'self' https://example-cdn.invalid 'sha256-hash1' 'sha256-hash2'; base-uri 'self';
```

Hash matching is strict

A SHA-256 CSP hash must match the inline script content exactly as delivered in the HTML. Changing indentation, adding a newline, or minifying the script changes the hash and will cause a CSP violation until you update the header.

### When to Prefer SHA-256 Hashes over Nonces

Use SHA-256 hashes when:

- you need strict CSP **and** the page HTML is served from a cache
- the inline script is **static and identical** across cached responses
- you want a policy that is independent of per-request nonce generation

Use nonces when:

- the inline script content is **dynamic** or depends on server-side rendering
- you want to avoid "hash maintenance" when scripts change frequently

## Common CSP Gotchas (Why Scripts "Stop Working")

- A nonce is **unique per request** — you can't reuse it between requests.
- The nonce must **match exactly** between the CSP header and the script tag.
- SHA-256 hashes must match the inline script **exactly** (byte-for-byte as delivered in the HTML).
  - Changing whitespace, indentation, line endings, or adding/removing a trailing newline changes the hash.
- Hashes are a poor fit for **dynamic inline scripts**.
  - If the script contains per-request data (prices, form keys, URLs, timestamps, translations, personalization, etc.), the hash changes on every request and the browser blocks the script unless the CSP header is updated to match.
- You usually need **one hash per inline `<script>` block**.
  - If you split one script into two blocks, you need to add a second hash to the CSP header.
- Neither a nonce nor a hash authorizes **external** scripts automatically.
  - External domains must be allowed via `csp_whitelist.xml`.

Silent failures are common

Under strict CSP, unauthorized scripts simply won't execute. Always check the browser console for CSP violation messages when debugging.

## Related Topics

- **[CSP overview](index.html)** - Entry point for Hyvä's CSP documentation
- **[CSP Script Authorization](../../../hyva-checkout/devdocs/csp/csp-script-validation.html)** - How strict mode works and what it blocks
- **[Content Security Policy Allowlist](content-security-policy-allowlist.html)** - Optimizing which `csp_whitelist.xml` files are loaded
- **[CSP and Block Caching](csp-and-block-caching.html)** - How CSP interacts with Magento full-page and block caching
- **[Magento CSP Configuration](csp-magento-configuration.html)** - Where CSP is configured in Magento and which settings matter
- **[CSP compatibility](csp-compatibility.html)** - Tips for dealing with third-party extensions under strict CSP
