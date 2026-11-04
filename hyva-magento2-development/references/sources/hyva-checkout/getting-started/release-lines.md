<!-- source: https://docs.hyva.io/hyva-checkout/getting-started/release-lines.html -->

# Hyvä Checkout Release Lines and Magewire Versions

Hyvä Checkout has two release lines. They share almost all checkout features and differ mainly in the Magewire version their components are written against:

| Release line | Versions | Magewire | PHP | Status |
| --- | --- | --- | --- | --- |
| **Checkout 3.x** | `3.0.0` and later, plus the `3.0.0` and `1.4.0` betas | Magewire 3 (`magewirephp/magewire ~3.7.2`) | 8.2 or newer | Current |
| **Checkout 1.x** | `1.3.x` (latest `1.3.15`) and older, plus the `1.3.1000` betas | Magewire 1 (`magewirephp/magewire ^1.13.3`) | 8.1 or newer | Previous |

Checkout 3.x installs the [v1bc module](../faq/what-is-v1bc.html), which keeps components, templates and integrations written for Checkout 1.x working on its checkout pages.

Checkout 1.3.15 and 3.0.0 share reCAPTCHA, postcode format validation, EAV address attributes, the coupon code form, positional step layout handles, Tailwind CSS 3 and 4 support, and the `hyva-themes/magento2-theme-module ^1.3.16` requirement.

## Running a Store on Checkout 3.x

- **Use Checkout 3.x for new projects, and upgrade existing stores.** Most stores upgrade without code changes. See [Upgrading to 3.0.0](../upgrading/upgrading-to-3.0.0.html).
- **Test every checkout integration after the upgrade**, on a development or staging environment. Code that reads the internals of core checkout components works through emulation.
- **Pages outside the checkout that render Magewire components**, for example a payment status page, need the `hyva_checkout_magewire_startup` layout handle. See [Components on a Module's Own Pages](../magewire/migrating-to-magewire-3.html#components-on-a-modules-own-pages).
- **Write new components for Magewire 3** and mark them with `#[HandleBackwardsCompatibility(enabled: false)]`. Follow the "Checkout 3.x" tabs in these docs.
- **Stay on Checkout 1.x only where something you depend on still requires it.**

Hyvä Enterprise and Checkout 3.x

Hyvä Enterprise projects on Checkout 3.x need the releases of `hyva-themes/magento2-ee-hyva-enterprise-checkout`, and of `hyva-themes/magento2-ee-hyva-enterprise-checkout-b2b` where used, that support Checkout 3. Earlier releases of these modules require Checkout 1.3.

## Maintaining an Extension for Checkout 1.x and 3.x

- **Keep your Magewire 1 code.** On Checkout 3.x it runs through v1bc, so the same code supports both release lines.
- **Check the short list of what does need a change**, such as components on a module's own pages and type hints in form modifiers: [Supporting Checkout 1.x and Checkout 3.x With v1bc](../magewire/migrating-to-magewire-3.html#supporting-checkout-1x-and-checkout-3x-with-v1bc), and for Checkout's own classes, [Customizations That Need a Change](../upgrading/upgrading-to-3.0.0.html#customizations-that-need-a-change).
- **Follow the "Checkout 1.x" tabs.** Their code also runs on Checkout 3.x checkout pages through v1bc, apart from the cases on that list. Where one piece of code works the same on both lines, the docs show it without tabs.
- **Test on both release lines**: on Checkout 1.x, and on Checkout 3.x with v1bc enabled.

## How Version Tabs Work in the Checkout Docs

Whenever an instruction or code example differs between the release lines, the Hyvä Checkout docs show it in two tabs:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

Instructions and code for Hyvä Checkout 3.x, including the 1.4.0 betas.

Instructions and code for Hyvä Checkout 1.x.

Pick your version once and every other tab set on docs.hyva.io follows your choice. Content outside the tabs applies to both release lines.

More conventions: "Checkout 1.x only" sections, the Magewire Intro pages and the "V1" JavaScript API

- **Sections marked "Checkout 1.x only"** describe behavior that doesn't exist on Checkout 3.x, such as the `wire:auto-save` directive. On Checkout 3.x, that code keeps working only through the v1bc module.
- **The Magewire Intro pages** document Magewire 1 in detail and show the Magewire 3 differences in tabs. For everything else about Magewire 3, see the official [Magewire documentation](https://docs.magewirephp.nl).
- **"V1" in the Frontend API docs** is the version of the `hyvaCheckout` JavaScript API, not of Hyvä Checkout. The JavaScript API v1 ships with both release lines.

## Finding Your Installed Hyvä Checkout Version

```
composer show hyva-themes/magento2-hyva-checkout | grep versions
```

A version starting with `3.` or `1.4.` means Checkout 3.x. Anything else starting with `1.` means Checkout 1.x.

Why the 1.4.0 betas belong to Checkout 3.x

Hyvä Checkout 3.0 started life as 1.4. The `1.4.0-beta1` to `1.4.0-beta6` releases already ran on Magewire 3, and the line was renamed to 3.0 to match the Magewire major version. If you're on a 1.4.0 beta, follow the "Checkout 3.x" instructions and upgrade to the latest 3.x release.

## Related Topics

- [Installing Hyvä Checkout](index.html): requirements and installation for both release lines
- [The Magewire 1 Backward Compatibility Module (v1bc)](../magewire/v1bc.html): running Magewire 1 code on Checkout 3.x
- [Magewire in Hyvä Checkout](../magewire/index.html): Magewire concepts and a Magewire 1 to Magewire 3 cheat sheet
- [Upgrading to 3.0.0](../upgrading/upgrading-to-3.0.0.html): moving from Checkout 1.x to 3.x
- [Checkout 3.x Changelog](../upgrading/changelog.html) and [Checkout 1.x Changelog](../upgrading/changelog-1.x.html)
