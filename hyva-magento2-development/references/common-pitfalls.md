# Common Pitfalls in Hyvä Development

## When to read this

Something isn't working and you suspect a Hyvä-specific gotcha. Skim this list — it covers the issues that catch most developers at least once.

## Captcha not working

Hyvä doesn't support Magento's legacy captcha implementation. **Disable it explicitly:**

```bash
bin/magento config:set customer/captcha/enable 0
```

Hyvä supports Magento ReCaptcha (V3 invisible, V2 invisible, V2 "I'm not a robot"). Configure in **Stores > Configuration > Security > Google reCAPTCHA Storefront**.

## Styles missing after deploying

Likely causes (in order of frequency):

1. **Tailwind wasn't rebuilt.** Run from the child theme: `cd app/design/frontend/Acme/default/web/tailwind && npm run build`.
2. **Static content not deployed in production:** `bin/magento setup:static-content:deploy -f`.
3. **Magento cache stale:** `bin/magento cache:flush`.
4. **Theme not set at the Website level.** If only the Store View has Hyvä but Website is "-- No Theme --", weird fallback behavior happens.
5. **Parent theme path wrong in `hyva.config.json`.** Check that `tailwind.include[].src` points at the actual installed location of `magento2-default-theme` (or `-csp`).
6. **Class is dynamic** (built from a variable) and Tailwind purged it. See `tailwind-v4.md` "Dynamic class names" section.

## Checkout page is empty / broken

- Did you actually install Hyvä Checkout? It's a separate package: `composer require hyva-themes/magento2-hyva-checkout`.
- Is it enabled in **Stores > Configuration > Sales > Checkout > Hyvä Checkout**?
- Are required GraphQL modules enabled? (See `theme-setup.md`.)
- Is the page returning 200 in the network tab? If it's a 500, check `var/log/exception.log`.
- Is the browser blocking inline scripts due to CSP? Open the console — CSP violations are reported there.

If you customized the checkout XML, check that all referenced components exist as PHP classes.

## `x-data="..."` doesn't work in CSP-strict theme

Inline expressions are forbidden under CSP. Convert to `Alpine.data('name', () => ({...}))` and reference by name. See `alpine-csp.md`.

## Mini-cart count doesn't update after a custom add-to-cart

After your fetch POST, dispatch:
```js
window.dispatchEvent(new Event('reload-customer-section-data'));
```

Magento's `private_content_version` cookie is auto-updated on POST, so the next page-load would pick it up — but the dispatch makes it immediate.

## Section data is `null` / `undefined`

- Is the visitor logged in or has a session? For first-time visitors with no session, default section data is rendered into the page — most keys will be empty.
- Did you wait for `private-content-loaded`? Reading the data before the event fires gets stale/missing data.
- Is the section provider listed in `etc/frontend/sections.xml` for the action that updates it?
- For sections that should always be present (even default), declare in `di.xml`. See `section-data.md`.

## Tailwind classes from a third-party module aren't applied

Tailwind only scans paths listed in `hyva.config.json`. Add the third-party module's source path:

```json
{
  "tailwind": {
    "include": [
      { "src": "vendor/hyva-themes/magento2-default-theme" },
      { "src": "vendor/somevendor/some-module" }
    ]
  }
}
```

Then `npm run build`.

## `$viewModels->require(...)` throws "class not found"

- Check the namespace in your `<?php use ...; ?>` import.
- Check the class implements `Magento\Framework\View\Element\Block\ArgumentInterface`.
- Run `bin/magento setup:di:compile` if you're in production / compiled mode.
- Make sure the file is in a registered Magento module.

## Block override isn't applying

Magento's theme fallback prefers files in this order:
1. Active theme's module-relative path
2. Parent theme(s) up the chain
3. Vendor module's `view/frontend/templates/`

So your override at `app/design/frontend/Acme/default/Magento_Catalog/templates/product/list.phtml` will replace the parent's. Common reasons it doesn't:

- **Wrong theme is active.** Check **Content > Design > Configuration**.
- **Path mismatch.** Compare against the original carefully — typos like `Magento_Catalog/templates/...` vs. `Magento_Catalog/template/...` (singular) are easy to miss.
- **Cache.** `bin/magento cache:flush`.
- **Production mode static-content** wasn't redeployed.

## Layout XML override isn't applying

Hyvä-specific overrides should usually go in `hyva_*` handles, not the original handles. So override `hyva_catalog_product_view.xml`, not `catalog_product_view.xml`. See `templates-and-blocks.md`.

If you're doing `<referenceBlock name="..." remove="true"/>` and the block isn't going away, the block name might be different in Hyvä. Look at the XML in `vendor/hyva-themes/magento2-default-theme/Magento_*/layout/` to find the right name.

## `bin/magento setup:static-content:deploy` fails with CSS error

Magento's CSS minifier (Symfony/CssMinifier) sometimes can't parse the custom Tailwind output. Common fixes:

1. **Make sure Magento's CSS minification is OFF** for Hyvä store views (see `theme-setup.md`).
2. **Don't put the Tailwind output in a static-content-deploy path Magento tries to minify.** Hyvä builds to `web/css/styles.css` which is already minified — Magento should leave it alone if minification is disabled.
3. If you must deploy with Magento's minifier on, exclude the Tailwind output via `view.xml`.

## "Module is not enabled" on a `Magento_*GraphQl` module

Hyvä uses GraphQL. If a fresh install ran Luma first, some GraphQL modules may be disabled. Check status:
```bash
bin/magento module:status Magento_QuoteGraphQl Magento_CatalogGraphQl
```

Enable any that are off:
```bash
bin/magento module:enable Magento_QuoteGraphQl Magento_CatalogGraphQl
bin/magento setup:upgrade
```

See `theme-setup.md` for the full list of required GraphQL modules.

## Inline `<script>` blocks blocked by CSP

Either:
- The store is using `Hyva/default-csp` and your inline script isn't whitelisted.
- The Magento CSP module is generating violations.

Solutions:
1. Move the JS into a separate file referenced from layout XML (then it's same-origin).
2. Register the inline script's hash with Magento's CSP nonce provider:
   ```php
   /** @var \Hyva\Theme\ViewModel\HyvaCsp $hyvaCsp */
   $hyvaCsp = $viewModels->require(\Hyva\Theme\ViewModel\HyvaCsp::class);
   $script = "console.log('hi');";
   $hyvaCsp->registerInlineScript($script);
   ?>
   <script><?= /* @noEscape */ $script ?></script>
   ```

## Form submits succeed but page doesn't redirect / show messages

Check that:
- You included `form_key=` in the body.
- Magento's redirect (302) is being followed by `fetch` (it does so by default unless you set `redirect: 'manual'`).
- If `response.redirected === true`, navigate manually:
  ```js
  if (r.redirected) window.location.href = r.url;
  ```
- For success/error messages, dispatch `reload-customer-section-data` so the `messages` section is repopulated.

## "Cannot use object of type Closure" in templates

Hyvä uses anonymous functions in some places (Heroicons output, etc.). If you migrated from Luma, delete any custom block class methods that override Hyvä's expected return types. Check the parent class signatures in `vendor/hyva-themes/magento2-theme-module/`.

## Performance regressed after upgrade

If the upgrade was 1.3.x → 1.4.x:
- New Tailwind v4 build might be larger if you didn't run `find-deprecated-classes.js` and there are old + new classes both present.
- Check that `web/css/styles.css` in production is the v4 build, not a leftover v3.
- Run Lighthouse before and after — sometimes the regression is a single image preload that broke.

## Compatibility module isn't recognized as Hyvä-compatible

Add to `composer.json`:
```json
"extra": {
    "hyva-themes": {
        "compat-module-for": ["ThirdParty_OriginalModule"]
    }
}
```

And run `composer dump-autoload`. See `compatibility-modules.md`.

## "There are too many files in this folder" or path-too-long errors on Windows

Magento + Hyvä's vendor tree can hit Windows path limits. Workarounds:

- Enable long paths in Windows: in registry, `HKLM\SYSTEM\CurrentControlSet\Control\FileSystem\LongPathsEnabled = 1`.
- Use Docker or WSL2 for Magento development on Windows.
- Move the project root closer to `C:\` to shorten paths.

## Tools to diagnose

- `bin/magento hyva:check` — runs a few sanity checks (if installed).
- Browser DevTools console — Alpine, CSP, and JS errors all log here.
- Magento exception log — `var/log/exception.log`.
- Network tab — confirm static assets return 200, not 404.
- `bin/magento dev:profiler:enable` — Magento's built-in PHP profiler.

## Ask the community

If you're stuck:
- [Hyvä Slack](https://hyva.io/slack) — fast responses, shared with experienced devs
- [Hyvä Docs](https://docs.hyva.io/) — keep handy
- [Compatibility Module Tracker](https://gitlab.hyva.io/hyva-public/module-tracker) — check before writing your own

## Original sources

The Hyvä FAQ section is a great gotcha resource. Bundled at:

- `references/sources/hyva-themes/faqs/troubleshooting.md` — general troubleshooting
- `references/sources/hyva-themes/faqs/static-content-deploy-fails-with-css-error.md` — the static-content-deploy CSS issue
- `references/sources/hyva-themes/faqs/checkout-button-not-working.md`
- `references/sources/hyva-themes/faqs/why-is-the-checkout-page-empty.md`
- `references/sources/hyva-themes/faqs/javascript-files-and-compilers.md` — JS pipeline
- `references/sources/hyva-themes/faqs/critical-css.md`
- `references/sources/hyva-themes/faqs/preselecting-configurable-options.md`
- `references/sources/hyva-themes/faqs/resolving-top-menu-varnish-issues.md`
- `references/sources/hyva-themes/faqs/footer-at-screen-bottom-if-short-content.md`
- `references/sources/hyva-themes/faqs/supported-browsers.md`
- `references/sources/hyva-themes/faqs/security-compliance.md`
- `references/sources/hyva-themes/faqs/rtl-text.md`
- `references/sources/hyva-themes/faqs/why-not-smaller-components.md` — design philosophy
- `references/sources/hyva-themes/faqs/hyva-roadmap.md`
- The full FAQ tree has 25+ entries — `Grep` in `references/sources/hyva-themes/faqs/` for keyword matches.
