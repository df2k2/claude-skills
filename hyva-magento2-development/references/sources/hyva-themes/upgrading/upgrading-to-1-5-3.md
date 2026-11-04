<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrading-to-1-5-3.html -->

# Upgrading to 1.5.3

Hyvä Theme 1.5.3 is a feature and maintenance release that builds on 1.5.2.
The Default Theme no longer depends on GraphQL, fonts can be configured through the new Font API, and the `x-html-safe` Alpine plugin gives CSP themes a sanitized alternative to `x-html`.
It also carries the MSRP security fix and the CSP safe MSRP templates from [1.4.11](upgrading-to-1-4-11.html), and a long list of storefront fixes.

Update the Theme Module together with the Default Theme

The Default Theme 1.5.3 uses the `x-html-safe` plugin and the `Hyva\Theme\ViewModel\Product\Options` view model, which are introduced in the `Hyva_Theme` module 1.5.3.
Update `hyva-themes/magento2-theme-module` to 1.5.3 or later when you update the Default Theme.

Safe Module Update

Updating only the `Hyva_Theme` module to 1.5.3 is safe, but it changes two defaults that also apply to an older theme.
The cart page shows the newest items first, and autocomplete on the login forms is enabled.
See [Backward compatibility](#backward-compatibility) for how to keep the previous behavior.
The new `x-html-safe` mapping setting defaults to Disabled, so it changes nothing until you opt in.

## Notable news

### GraphQL is no longer required by the Default Theme

The Default Theme used GraphQL in three places, which forced every Hyvä storefront to keep the `/graphql` endpoint reachable.
All three now use a server side alternative, so stores that do not use GraphQL for anything else can block the `/graphql` route.

- **Product review form**:
  `Magento_Review::form.phtml` posts to Magento's `review/product/post` controller with a form key, instead of sending a `createProductReview` mutation.
  Validation uses the native `required` attributes, and the result is shown in Magento's message area after the redirect.
  reCAPTCHA is posted as the standard `g-recaptcha-response` field instead of an `X-ReCaptcha` header.
- **Customer product review list**:
  `Magento_Review::customer/list.phtml` renders server side from `Magento\Review\Block\Customer\ListCustomer`, with the pager from that block.
  Compared to the GraphQL version, the list no longer shows a product image, and shows a single star rating from the review summary instead of a breakdown per rating.
- **Recently viewed products widget**:
  The widget always reads the products from the browser storage.
  Hyvä never synchronized viewed products to the server, so the GraphQL fetch only returned what the browser already held.

The `composer.json` of the Default Theme no longer requires `hyva-themes/magento2-graphql-view-model`, `hyva-themes/magento2-graphql-tokens` and five `magento/module-*-graph-ql` packages.
The Magento GraphQL modules stay installed and enabled, because the `Hyva_Theme` module still requires `magento/module-quote-graph-ql` for backward compatibility. The storefront no longer calls them.
The two Hyvä packages keep working, but are no longer pulled in by the theme (see [Backward compatibility](#backward-compatibility)).

In the Theme Module, the view model members that only served this GraphQL code are deprecated, but nothing is removed:

- `Customer\ReviewList::getCustomerReviewsGraphQlQuery()`
- `RecentlyViewedProducts::isFetchRecentlyViewedEnabled()`
- The `XML_VIEWED_PRODUCTS_SYNC_BACKEND_PATH` constant in `ProductPage` and in `RecentlyViewedProducts`

The admin setting `catalog/recently_products/synchronize_with_backend` now shows a note, because it does not switch anything in Hyvä.

The GraphQL code used by the optional `hyva-themes/magento2-graphql-cart` extension is unchanged.

### Font API

The `generate` script of the Default Theme now runs `npx hyva-fonts`, which ships with `@hyva-themes/hyva-modules` v1.5.
Fonts configured in `hyva.config.json` are downloaded from a provider such as Fontsource or Google Fonts, or taken from local files, and written to `generated/hyva-fonts.css`.
The API also generates fallback font metrics to prevent layout shift, and can generate a preload snippet.

See the [Font API documentation](../working-with-tailwindcss/using-hyva-modules/fonts.html) for the configuration options.

To use the Font API in an existing child theme, update the npm package and add the command and the import:

```
npm install @hyva-themes/hyva-modules@latest
```

web/tailwind/package.json

```
"generate": "npx hyva-sources && npx hyva-tokens && npx hyva-fonts",
```

web/tailwind/tailwind-source.css

```
@import "./generated/hyva-source.css";
@import "./generated/hyva-tokens.css";
@import "./generated/hyva-fonts.css";
```

### The `x-html-safe` Alpine plugin

The Theme Module ships a new [`x-html-safe`](../working-with-alpinejs/alpine-plugins/x-html-safe.html) Alpine plugin.
It renders HTML through a fixed tag and attribute allowlist instead of setting `innerHTML` directly, and works on both the standard and the CSP Alpine build.
This gives CSP themes an alternative to `x-html`, which the Alpine CSP build does not support.

All `x-html` usage in the Default Theme is migrated to `x-html-safe`.
If your child theme overrides templates that use `x-html`, migrate those overrides as well.

The new setting **Stores > Configuration > Hyvä Themes > Developer > HTML Safe > Map x-html-safe to x-html** can also render `x-html` usage in your own templates and third-party modules through the sanitized path, on CSP pages only or on all pages.
It defaults to Disabled. Review the [mapping documentation](../working-with-alpinejs/alpine-plugins/x-html-safe.html#mapping-x-html-to-x-html-safe) before enabling it, because the allowlist can change the output of existing markup.

### Heroicons replaced with Lucide icons

The remaining templates that used the `HeroiconsOutline` and `HeroiconsSolid` view models now use `LucideIcons`.
No template in the Default Theme references Heroicons anymore. The Heroicons view models are still available for your own templates.

Lucide has a single outline set, so icons that came from `HeroiconsSolid` are now outlined.
The most visible change is the show and hide password toggle on the login, register, account edit and reset password forms.
Lucide also uses a thinner stroke, so all icons render slightly lighter than before.

Renamed icons

| Heroicons | Lucide |
| --- | --- |
| `xCircle` | `circleX` |
| `exclamationCircle` | `circleAlert` |
| `checkCircle` | `circleCheck` |
| `questionMarkCircle` | `circleQuestionMark` |
| `pencilAlt` | `pencil` |
| `refresh` | `refreshCw` |
| `documentDownload` | `fileDown` |
| `sortAscending` | `arrowUpNarrowWide` |
| `sortDescending` | `arrowDownWideNarrow` |

## Security fix

### Cross-site scripting in the MSRP templates

Both MSRP templates escaped values for HTML while rendering them into JavaScript.
In the price template this allowed a crafted product name to break out of the string and run script on the storefront, because the browser decodes the HTML entities in the `x-data` attribute before Alpine evaluates it.
In the popup template the HTML escaping of the MSRP explanation messages prevented a break-out, but a crafted message could still break the popup script.
Both templates now escape these values for JavaScript.

The issue is rated low severity, because exploiting it requires write access to product data.
For details, see the [Security Changelog](security-changelog.html#cross-site-scripting-in-the-msrp-price-and-popup-templates).

The release also hardens a number of other templates against XSS, see [merge request #1548](https://gitlab.hyva.io/hyva-themes/magento2-default-theme/-/merge_requests/1548).

## Short description fallback

When a product has no short description, `ProductPage::getShortDescription()` and `getShortDescriptionForProduct()` fall back to an excerpt of the product description.
The excerpt is the first paragraph or the first sentence, and is shown on the product page and in product lists.
This can now be turned off with **Stores > Configuration > Hyvä Themes > Catalog > Product Details > Use Description as Short Description Fallback**, per website and store view.
The setting is enabled by default, so the current output does not change.

Both `getShortDescription()` and `getShortDescriptionForProduct()` accept an optional `?bool $descriptionFallback` argument to override the setting for a single template.

## Cart item order

The cart page and the mini cart now show the items in the same order.
Previously the mini cart showed the newest items first and the cart page the oldest first.

The order is set with **Stores > Configuration > Hyvä Themes > General > Cart > Show Newest Items First**, which is also available under **Sales > Checkout > Shopping Cart**.
It defaults to Yes.
Templates read the setting with `Hyva\Theme\ViewModel\Cart\ItemOrder::isShowNewestItemsFirst()`.
The cart page items are sorted on the collection, so the order is also correct when the cart is paginated.

## Accessibility

Navigation landmarks, the mobile menu, the store and language switchers and the items per page select now have accessible names.
The registration name fields have `autocomplete` attributes, and autocomplete is enabled on the storefront login forms by default, so password managers and browsers can fill them in.

## reCAPTCHA

The Google reCAPTCHA script now only loads when a shopper interacts with a form that uses reCAPTCHA.
Previously it loaded on the first input in any form, such as the search or newsletter form.

## Extending the ProductList view model

`Hyva\Theme\ViewModel\ProductList::getLinkTypeModel()` and `ProductList::createProductLinkCollection()` are now public, which opens the view model up for extension without a class preference:

- **Custom product link types**:
  Modules that add their own product link type can load the linked products through `ProductList`, the same way as related, upsell and cross-sell products.
- **Plugins on the link collection**:
  Magento plugins only work on public methods, so you can now add a plugin to `createProductLinkCollection()` to filter or modify the collection before it is loaded.

For more information, see [issue #534](https://gitlab.hyva.io/hyva-themes/magento2-theme-module/-/issues/534) and [issue #527](https://gitlab.hyva.io/hyva-themes/magento2-theme-module/-/issues/527).

## Bug fixes

This release contains many smaller fixes for the product page, cart, messages and layered navigation. Two are worth calling out:

- Configurable options without enabled child products are omitted again, instead of being rendered as disabled. This regression was introduced in 1.5.1.
- Product sliders now purge the full page cache when a listed product changes.

See the [changelogs](#changelogs) for the full list.

## Backward compatibility

This release is backward compatible for most stores. Check the following points if they apply to your project.

- **Modules that rely on the Hyvä GraphQL packages**:
  A module that uses the `GraphqlViewModel` view model, or the `signin_token` of the `customer` section, must add `hyva-themes/magento2-graphql-view-model` or `hyva-themes/magento2-graphql-tokens` to its own `require`.
  Until now these packages were always installed through the Default Theme.
- **Overrides of the review and recently viewed templates**:
  Overrides of `Magento_Review::form.phtml`, `Magento_Review::customer/list.phtml` or the recently viewed products widget keep using GraphQL until you update them. They keep working as long as the GraphQL endpoint and packages are available.
- **Customer product review list**:
  The list no longer shows a product image, and shows a single star rating instead of a breakdown per rating.
  The `review_customer_index.xml` layout no longer adds the `loading` child block, so an override that calls `getChildHtml('loading')` renders no loading spinner.
- **Classes extending `ProductPage`**:
  If your class overrides `getShortDescription()` or `getShortDescriptionForProduct()`, add the `?bool $descriptionFallback = null` argument to the signature. Existing calls, and before and after plugins, are unaffected.
- **Around plugins on `getShortDescription()` or `getShortDescriptionForProduct()`**:
  An around plugin that only declares the old arguments keeps working, but drops the `$descriptionFallback` argument of the template. Forward the new argument to `$proceed`.
- **Cart page item order**:
  The cart page now shows the newest items first by default, like the mini cart.
  Set **Show Newest Items First** to No to show the oldest items first on both.
  This also applies when only the `Hyva_Theme` module is updated. With an older theme, the setting only changes the cart page, because the mini cart template of the older theme keeps its own order.
- **Autocomplete on the login forms**:
  **Customers > Customer Configuration > Password Options > Enable Autocomplete on login/forgot password forms** now defaults to Yes.
  Stores that rely on the Magento default of No have to set it to No explicitly.
- **Child themes and the Font API**:
  The Font API is optional. Child themes only need `@hyva-themes/hyva-modules` v1.5 when they add `npx hyva-fonts` to their `generate` script.
- **Overrides of templates with icons**:
  Overrides keep rendering the Heroicons they reference. Update them if you want the storefront to look consistent.
- **Overrides of the MSRP templates**:
  Overrides of `Magento_Msrp/templates/popup.phtml` or `Magento_Msrp/templates/product/price/msrp.phtml` receive neither the security fix nor the CSP changes.
  The new `msrp.phtml` uses the `initMsrpPrice` component, which is registered in the new `popup.phtml`.
  If you override only `popup.phtml` with an older copy, the "Click for price" and "What's this?" buttons stop working, so always update both templates together.
  Base your copies on the new templates, see [merge request #1547](https://gitlab.hyva.io/hyva-themes/magento2-default-theme/-/merge_requests/1547).

## Changelogs

Changelogs are available from the CHANGELOG.md in the codebase, or here:

- [Changelog Default Theme](changelog-default-theme.html#153-2026-10-12)
- [Changelog Theme Module](changelog-theme-module.html#153-2026-10-12)

## Tooling

Check the [Hyvä Theme upgrade docs](index.html) for helpful information on how to upgrade.
