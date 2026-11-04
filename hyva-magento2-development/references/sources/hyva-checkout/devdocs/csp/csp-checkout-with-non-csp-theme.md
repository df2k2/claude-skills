<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/csp/csp-checkout-with-non-csp-theme.html -->

# CSP Checkout without Migrating Your Full Theme

Hyvä Checkout enforces strict Content Security Policy (CSP) compliance even when your theme isn't fully CSP-compatible. You can enable CSP protection for checkout routes without rewriting your entire theme. However, any components shared between the theme and Hyvä Checkout must be CSP-compatible to function properly in a strict CSP environment.

Shared components include the authentication drawer, the cookie notice, footer elements, the newsletter subscriptions, and the messaging system. These appear on all pages of the store including the checkout pages, so they need CSP-compatible implementations.

## Inline Scripts Requiring CSP Registration

The Hyvä default theme (`hyva-themes/magento2-default-theme`) contains inline scripts used by both the theme and Hyvä Checkout. These scripts need CSP authorization to function in strict CSP mode. Learn more about the technical approach on the [How Hyvä works without `unsafe-inline`?](../../../hyva-themes/writing-code/csp/csp-compatibility.html#how-hyva-works-without-unsafe-inline) page.

Compatible since 1.3.15

Since `hyva-themes/magento2-default-theme` version 1.3.15 all scripts in components shared with Hyvä Checkout are compatible with strict CSP.
Themes base on earlier versions of Hyvä will require the changes described on this page.

Customizations may require more changes for CSP compatibility beyond the default shared components.

### Registering Inline Scripts for CSP

To authorize an inline script block in a CSP environment, add the `$hyvaCsp->registerInlineScript()` call immediately after the closing `</script>` tag. Apply this pattern to all inline script blocks:

```
-</script>
+</script>
+<?php $hyvaCsp->registerInlineScript() ?>
```

### Template Files with Inline Scripts

The following template files contain inline scripts that require CSP registration.

**Configurable Products and Swatches**

- `Magento_ConfigurableProduct::product/view/type/options/js/configurable-options.phtml`
- `Magento_Swatches::product/js/swatch-options.phtml`

**Analytics and ReCaptcha**

- `Magento_GoogleAnalytics::ga.phtml`
- `Magento_GoogleGtag::ads.phtml`
- `Magento_GoogleGtag::ga.phtml`
- `Magento_ReCaptchaFrontendUi::js/script_loader.phtml`
- `Magento_ReCaptchaFrontendUi::js/script_token.phtml`
- `Magento_ReCaptchaFrontendUi::js/script_token_invisible.phtml`
- `Magento_ReCaptchaFrontendUi::js/script_token_recaptcha.phtml`
- `Magento_ReCaptchaFrontendUi::recaptcha_checkbox.phtml`
- `Magento_ReCaptchaFrontendUi::recaptcha_invisible.phtml`

**Theme**

- `Magento_Theme::html/mobile-safari-bug-workaround.phtml`

## Alpine Components Requiring CSP Migration

The Hyvä default theme shares several Alpine.js components with Hyvä Checkout. These components must be migrated to use Alpine's CSP-compatible mode, which separates inline script execution from component markup. CSP-compatible Alpine components use `Alpine.data()` for registration and method references instead of inline expressions.

### Shared Alpine Components List

**Cookie Notice Component**

- `Magento_Cookie::notices.phtml`

**The Authentication Drawer**

- `Magento_Customer::account/authentication-popup.phtml`

**Footer Components** (Currency, Store, Language Selector, and Newsletter Subscription)

- `Magento_Directory::currency.phtml`
- `Magento_Newsletter::subscribe.phtml`
- `Magento_Store::switch/languages.phtml`
- `Magento_Store::switch/stores.phtml`

**Header Components** (Login as Customer Notice and Logout Link)

- `Magento_LoginAsCustomerFrontendUi::html/notices.phtml`
- `Magento_LoginAsCustomerFrontendUi::html/notices/logout-link.phtml`

**Messaging Component**

- `Magento_Theme::messages.phtml`

Depending on your checkout customizations and installed extensions, additional shared components may need CSP compatibility updates.

Alpine v2 is Not Compatible with CSP

Hyvä Themes using Alpine v2 cannot achieve CSP compatibility. You must upgrade to Alpine v3 first.

To check your Alpine version, open a page in a desktop browser, open the developer console, and type `Alpine.version`. If the version string starts with `2`, upgrade your theme before enabling CSP.

Refer to the [Hyvä Theme 1.2.0 upgrade notes](../../../hyva-themes/upgrading/upgrading-to-1-2-0.html#migration-scripts) for upgrade instructions.

## Migrating to the Hyvä Checkout CSP Without Migrating the Full Theme

### Update Required Packages

The required packages depend on the release line:

Checkout 3.x (Magewire 3)Checkout 1.x (Magewire 1)

First, update `hyva-themes/magento2-theme-module` to the latest version (Checkout 3.x requires `1.3.16` or newer). Then install Hyvä Checkout 3.x as described in the [installation instructions](../../getting-started/index.html#installing-hyva-checkout-with-a-license-key). Every Checkout 3.x release supports strict CSP. Composer also installs `magewirephp/magewire` 3.7 and the `hyva-themes/magento2-hyva-checkout-v1bc` module.

First, update `hyva-themes/magento2-theme-module` to the latest version. Then install the CSP version of `hyva-themes/magento2-hyva-checkout` as described in the installation instructions. This also upgrades `magewirephp/magewire` to at least 1.12.0.

### Make Shared Components CSP-Compatible

The primary shared components needing CSP migration are the messages component, authentication drawer, and newsletter form. Review the component list above for other components you may have enabled through extensions or checkout customizations.

## Alpine Component CSP Migration Patterns

All Alpine components follow the same CSP migration pattern. The following examples are from the `hyva-themes/magento2-default-theme-csp` package and show the key changes needed for CSP compatibility.

### Universal Alpine CSP Migration Pattern

Every Alpine component migration follows these five steps:

1. Add `HyvaCsp` view model to template dependencies
2. Register Alpine component data function with `Alpine.data()` instead of inline initialization
3. Change component method calls from inline expressions to method references (for example, `@click="open = false"` becomes `@click="close"`)
4. Register the inline script with `<?php $hyvaCsp->registerInlineScript() ?>`
5. Initialize components with `x-data="componentName"` instead of `x-data="componentName()"`

### Cookie Notice Banner Component

The cookie notice banner migration demonstrates how to register the Alpine component with `Alpine.data()`, add dedicated methods instead of inline expressions, and register the inline script with HyvaCsp.

```
--- a/Magento_Cookie/templates/notices.phtml
+++ b/Magento_Cookie/templates/notices.phtml
@@ -10,14 +10,16 @@ declare(strict_types=1);

 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\HeroiconsOutline;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\Store as StoreViewModel;
 use Magento\Cookie\Block\Html\Notices;
 use Magento\Framework\Escaper;
 use Magento\Cookie\Helper\Cookie;

 /** @var Notices $block */
-/** @var Escaper $escaper */
 /** @var Cookie $cookieHelper */
+/** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */

 /** @var HeroiconsOutline $heroicons */
@@ -56,6 +58,9 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
             checkAcceptCookies() {
                 this.showCookieBanner = ! isAllowedSaveCookie();
             },
+            hideCookieBanner() {
+                this.showCookieBanner = false;
+            },
             setAcceptCookies() {
                 const cookieExpires = this.cookieLifetime / 60 / 60 / 24;
                 hyva.setCookie(this.cookieName, this.cookieValue, cookieExpires);
@@ -64,15 +69,17 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
                 } else {
                     window.dispatchEvent(new CustomEvent('user-allowed-save-cookie'));
                 }
+                this.showCookieBanner = false;
             }
         }
     }
+    window.addEventListener('alpine:init', () => Alpine.data('initCookieBanner', initCookieBanner), {once: true})
 </script>
-
+    <?php $hyvaCsp->registerInlineScript() ?>
 <section id="notice-cookie-block"
          aria-label="<?= $escaper->escapeHtmlAttr(__('We use cookies to make your experience better.')) ?>"
-         x-data="initCookieBanner()"
-         x-init="checkAcceptCookies()"
+         x-data="initCookieBanner"
+         x-init="checkAcceptCookies"
          x-defer="idle"
 >
     <template x-if="showCookieBanner">
@@ -82,7 +89,7 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
                 border-t-2 border-container-darker"
         >
             <button
-                @click="showCookieBanner = false;"
+                @click="hideCookieBanner"
                 aria-label="<?= $escaper->escapeHtmlAttr(__('Close panel')) ?>"
                 title="<?= $escaper->escapeHtmlAttr(__('Close panel')) ?>"
                 class="absolute right-0 top-0 p-4"
@@ -108,7 +115,7 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
                     </a>
                 </p>
                 <div class="my-2">
-                    <button @click="setAcceptCookies(); showCookieBanner = false"
+                    <button @click="setAcceptCookies"
                             id="btn-cookie-allow"
                             class="btn btn-primary"
                     >
```

### Authentication Drawer Component

The authentication drawer migration shows how to handle event data within methods. Notice the conversion of inline method calls to method references and the use of `this.$event` to access event parameters.

```
--- a/Magento_Customer/templates/account/authentication-popup.phtml
+++ b/Magento_Customer/templates/account/authentication-popup.phtml
@@ -11,6 +11,7 @@ declare(strict_types=1);
 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\Customer\LoginButton;
 use Hyva\Theme\ViewModel\HeroiconsOutline;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\ReCaptcha;
 use Hyva\Theme\ViewModel\StoreConfig;
 use Magento\Framework\Escaper;
@@ -18,6 +19,7 @@ use Magento\Customer\Block\Account\Customer;

 /** @var Escaper $escaper */
 /** @var Customer $block */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */
 /** @var ReCaptcha $recaptcha */
 /** @var HeroiconsOutline $heroicons */
@@ -37,17 +39,20 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
     function initAuthentication() {
         return {
             open: false,
+            close() {
+                this.open = false;
+            },
             forceAuthentication: false,
             checkoutUrl: '<?= $escaper->escapeUrl($block->getUrl('checkout/index')) ?>',
             errors: 0,
             hasCaptchaToken: 0,
             displayErrorMessage: false,
             errorMessages: [],
-            setErrorMessages: function setErrorMessages(messages) {
-                this.errorMessages = [messages];
-                this.displayErrorMessage = this.errorMessages.length;
+            setErrorMessages(message) {
+                this.errorMessages = [message];
+                this.displayErrorMessage = true;
             },
-            submitForm: function () {
+            submitForm() {
                 // Do not rename $form, the variable is expected to be declared in the recaptcha output
                 const $form = document.querySelector('#login-form');
                 <?= $recaptcha ? $recaptcha->getValidationJsHtml('customer_login', 'auth-popup') : '' ?>
@@ -56,13 +61,17 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
                     this.dispatchLoginRequest($form);
                 }
             },
-            onPrivateContentLoaded: function (data) {
+            onPrivateContentLoaded() {
+                const data = this.$event.detail.data;
                 const isLoggedIn = data.customer && data.customer.firstname;
                 if (data.cart && !isLoggedIn) {
                     this.forceAuthentication = !data.cart.isGuestCheckoutAllowed;
                 }
             },
-            redirectIfAuthenticated: function (event) {
+            redirectIfAuthenticated() {
+                const event = this.$event;
+                this.open = this.forceAuthentication;
+
                 if (event.detail && event.detail.url) {
                     this.checkoutUrl = event.detail.url;
                 }
@@ -70,7 +79,10 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
                     window.location.href = this.checkoutUrl;
                 }
             },
-            dispatchLoginRequest: function(form) {
+            resetErrors() {
+                this.errors = 0;
+            },
+            dispatchLoginRequest(form) {
                 this.isLoading = true;
                 const username = this.$refs['customer-email'].value;
                 const password = this.$refs['customer-password'].value;
@@ -99,7 +111,7 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
                 ).then(response => {
                         return response.json()
                     }
-                ).then(data=> {
+                ).then(data => {
                     this.isLoading = false;
                     if (data.errors) {
                         this.setErrorMessages(data.message);
@@ -112,12 +124,15 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
             }
         }
     }
+
+    window.addEventListener('alpine:init', () => Alpine.data('initAuthentication', initAuthentication), {once: true})
 </script>
+<?php $hyvaCsp->registerInlineScript() ?>
 <section id="authentication-popup"
-         x-data="initAuthentication()"
-         @private-content-loaded.window="onPrivateContentLoaded($event.detail.data)"
-         @toggle-authentication.window="open = forceAuthentication; redirectIfAuthenticated(event)"
-         @keydown.window.escape="open = false"
+         x-data="initAuthentication"
+         @private-content-loaded.window="onPrivateContentLoaded"
+         @toggle-authentication.window="redirectIfAuthenticated"
+         @keydown.window.escape="close"
 >
     <div
         class="backdrop"
@@ -130,18 +145,18 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
         x-transition:leave="ease-in-out duration-500"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
-        @click="open = false"
+        @click="close"
     ></div>
     <div role="dialog"
          aria-modal="true"
-         @click.outside="open = false"
+         @click.outside="close"
          class="inset-y-0 right-0 z-30 flex max-w-full fixed"
          x-cloak
          x-show="open"
      >
         <div class="relative w-screen max-w-md pt-16 bg-container-lighter"
              x-show="open"
-             x-cloak=""
+             x-cloak
              x-transition:enter="transform transition ease-in-out duration-500 sm:duration-700"
              x-transition:enter-start="translate-x-full"
              x-transition:enter-end="translate-x-0"
@@ -151,7 +166,7 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
         >
             <div
                 x-show="open"
-                x-cloak=""
+                x-cloak
                 x-transition:enter="ease-in-out duration-500"
                 x-transition:enter-start="opacity-0"
                 x-transition:enter-end="opacity-100"
@@ -160,7 +175,7 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
                 x-transition:leave-end="opacity-0" class="absolute top-0 right-2 flex p-2 mt-2">
                 <button
                     type="button"
-                    @click="open = false;"
+                    @click="close"
                     aria-label="<?= $escaper->escapeHtmlAttr(__('Close panel')) ?>"
                     class="p-2 text-gray-300 transition duration-150 ease-in-out hover:text-black"
                 >
@@ -187,7 +202,7 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom

                         <form class="form form-login"
                               method="post"
-                              @submit.prevent="submitForm();"
+                              @submit.prevent="submitForm"
                               id="login-form"
                         >
                             <?= $recaptcha ? $recaptcha->getInputHtml('customer_login', 'auth-popup') : '' ?>
@@ -200,7 +215,7 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
                                         <input name="username"
                                                id="form-login-username"
                                                x-ref="customer-email"
-                                               @change="errors = 0"
+                                               @change="resetErrors"
                                                type="email"
                                                required
                                                autocomplete="<?= $isAutocompleteEnabled ? 'email' : 'off' ?>"
@@ -220,7 +235,7 @@ $isAutocompleteEnabled = $storeConfig->getStoreConfig('customer/password/autocom
                                                required
                                                x-ref="customer-password"
                                                autocomplete="<?= $isAutocompleteEnabled ? 'current-password' : 'off' ?>"
-                                               @change="errors = 0"
+                                               @change="resetErrors"
                                         >
                                     </div>
                                 </div>
```

### Currency Switcher Component

The currency switcher demonstrates using the `hyva.createBooleanObject()` helper for state management and data attributes to pass configuration to event handlers.

```
--- a/Magento_Directory/templates/currency.phtml
+++ b/Magento_Directory/templates/currency.phtml
@@ -11,6 +11,7 @@ declare(strict_types=1);
 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\Currency;
 use Hyva\Theme\ViewModel\HeroiconsSolid;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Magento\Framework\Escaper;
 use Magento\Framework\View\Element\Template;

@@ -18,6 +19,7 @@ use Magento\Framework\View\Element\Template;

 /** @var Template $block */
 /** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp   */
 /** @var ViewModelRegistry $viewModels */

 /** @var HeroiconsSolid $heroiconsSolid */
@@ -29,7 +31,7 @@ $currencyViewModel = $viewModels->require(Currency::class);
 <?php if ($currencyViewModel->getCurrencyCount() > 1): ?>
     <?php $currencies = $currencyViewModel->getCurrencies(); ?>
     <?php $currentCurrencyCode = $currencyViewModel->getCurrentCurrencyCode(); ?>
-    <div x-data="{ open: false }"
+    <div x-data="initCurrencySwitcher"
          class="w-full sm:w-1/2 md:w-full pr-4"
     >
         <h2
@@ -40,13 +42,13 @@ $currencyViewModel = $viewModels->require(Currency::class);
         </h2>
         <div class="relative inline-block text-left">
             <div>
-                <button @click.prevent="open = !open"
-                        @click.outside="open = false"
-                        @keydown.window.escape="open=false"
+                <button @click.prevent="toggleOpen"
+                        @click.outside="setOpenFalse"
+                        @keydown.window.escape="setOpenFalse"
                         type="button"
                         class="inline-flex justify-center w-full form-select px-4 py-2 bg-white focus:outline-none"
                         aria-haspopup="true"
-                        :aria-expanded="open"
+                        :aria-expanded="ariaExpanded"
                 >
                     <?= $escaper->escapeHtml($currentCurrencyCode) ?>
                     <?php if ($currencies[$currentCurrencyCode]): ?>
@@ -55,7 +57,7 @@ $currencyViewModel = $viewModels->require(Currency::class);
                     <?= $heroiconsSolid->chevronDownHtml("flex self-center h-5 w-5 -mr-1 ml-2", 25, 25) ?>
                 </button>
             </div>
-            <nav x-cloak=""
+            <nav x-cloak
                  x-show="open"
                  class="absolute right-0 top-full z-20 w-full lg:w-56 py-2 mt-1 overflow-auto origin-top-left rounded-sm shadow-lg sm:w-48 lg:mt-3 bg-container-lighter"
                  aria-labelledby="currency-heading"
@@ -67,7 +69,8 @@ $currencyViewModel = $viewModels->require(Currency::class);
                                role="link"
                                class="block px-4 py-2 lg:px-5 lg:py-2 hover:bg-gray-100"
                                aria-describedby="currency-heading"
-                               @click.prevent='hyva.postForm(<?= /* @noEscape */ $currencyViewModel->getSwitchCurrencyPostData($code) ?>)'
+                               @click.prevent="switchCurrency"
+                               data-currency-data="<?= $escaper->escapeHtmlAttr($currencyViewModel->getSwitchCurrencyPostData($code)) ?>"
                             >
                                 <?= $escaper->escapeHtml($code) ?> - <?= $escaper->escapeHtml($name) ?>
                             </button>
@@ -77,4 +80,18 @@ $currencyViewModel = $viewModels->require(Currency::class);
             </nav>
         </div>
     </div>
+    <script>
+        function initCurrencySwitcher() {
+            return hyva.createBooleanObject('open', false, {
+                ariaExpanded() {
+                    return this.open() ? 'true' : 'false';
+                },
+                switchCurrency() {
+                    hyva.postForm(this.$el.dataset.currencyData)
+                }
+            });
+        }
+        window.addEventListener('alpine:init', () => Alpine.data('initCurrencySwitcher', initCurrencySwitcher), {once: true})
+    </script>
+    <?php $hyvaCsp->registerInlineScript() ?>
 <?php endif; ?>
```

### Newsletter Subscription Form

The newsletter form migration follows the standard Alpine CSP pattern: register with `Alpine.data()`, use method references instead of inline calls, and register the script with HyvaCsp.

```
--- a/Magento_Newsletter/templates/subscribe.phtml
+++ b/Magento_Newsletter/templates/subscribe.phtml
@@ -8,12 +8,14 @@

 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\HeroiconsOutline;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\ReCaptcha;
 use Magento\Framework\Escaper;
 use Magento\Newsletter\Block\Subscribe;

 /** @var Subscribe $block */
 /** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */
 /** @var ReCaptcha $recaptcha */
 /** @var HeroiconsOutline $heroicons */
@@ -29,8 +31,8 @@ $recaptcha = $block->getData('viewModelRecaptcha');
         class="form subscribe"
         action="<?= $escaper->escapeUrl($block->getFormActionUrl()) ?>"
         method="post"
-        x-data="initNewsletterForm()"
-        @submit.prevent="submitForm()"
+        x-data="initNewsletterForm"
+        @submit.prevent="submitForm"
         id="newsletter-validate-detail"
         aria-label="<?= $escaper->escapeHtmlAttr(__('Subscribe to Newsletter')) ?>"
     >
@@ -98,5 +100,8 @@ $recaptcha = $block->getData('viewModelRecaptcha');
                 }
             }
         }
+
+        window.addEventListener('alpine:init', () => Alpine.data('initNewsletterForm', initNewsletterForm), {once: true})
     </script>
+    <?php $hyvaCsp->registerInlineScript() ?>
 </div>
```

### Language Switcher Component

The language switcher uses `hyva.createBooleanObject()` for simple open/close state management and applies the standard CSP migration pattern.

```
--- a/Magento_Store/templates/switch/languages.phtml
+++ b/Magento_Store/templates/switch/languages.phtml
@@ -9,6 +9,7 @@
 declare(strict_types=1);

 use Hyva\Theme\Model\ViewModelRegistry;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\Store;
 use Hyva\Theme\ViewModel\StoreSwitcher;
 use Magento\Framework\Escaper;
@@ -19,6 +20,7 @@ use Magento\Store\ViewModel\SwitcherUrlProvider;

 /** @var Template $block */
 /** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */

 /** @var SwitcherUrlProvider $switcherUrlProvider */
@@ -33,7 +35,7 @@ $currentStore = $storeSwitcherViewModel->getStore();
 $currentStore = $storeSwitcherViewModel->getStore();
 ?>
 <?php if (count($storeSwitcherViewModel->getStores()) > 1): ?>
-    <div x-data="{ open: false }"
+    <div x-data="initLanguageSwitcher"
          class="w-full sm:w-1/2 md:w-full"
     >
         <div class="title-font font-medium text-gray-900 tracking-widest text-sm mb-3 uppercase">
@@ -41,9 +43,9 @@ $currentStore = $storeSwitcherViewModel->getStore();
         </div>
         <div class="relative inline-block text-left">
             <div>
-                <button @click.prevent="open = !open"
-                        @click.outside="open = false"
-                        @keydown.window.escape="open=false"
+                <button @click.prevent="toggleOpen"
+                        @click.outside="setOpenFalse"
+                        @keydown.window.escape="setOpenFalse"
                         type="button"
                         class="form-select w-full pl-4"
                         aria-haspopup="true"
@@ -52,21 +54,28 @@ $currentStore = $storeSwitcherViewModel->getStore();
                     <?= $escaper->escapeHtml($currentStore->getName()) ?>
                 </button>
             </div>
-            <nav x-cloak=""
+            <nav x-cloak
                  x-show="open"
                  class="absolute right-0 top-full z-20 w-56 py-2 mt-1 overflow-auto origin-top-left rounded-sm shadow-lg sm:w-48 lg:mt-3 bg-container-lighter">
                 <div class="my-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
-                <?php foreach ($storeSwitcherViewModel->getStores() as $lang): ?>
-                    <?php if ($lang->getId() != $storeViewModel->getStoreId()): ?>
-                        <a href="<?= $escaper->escapeUrl($switcherUrlProvider->getTargetStoreRedirectUrl($lang)) ?>"
-                           class="block px-4 py-2 lg:px-5 lg:py-2 hover:bg-gray-100"
-                        >
-                            <?= $escaper->escapeHtml($lang->getName()) ?>
-                        </a>
-                    <?php endif; ?>
-                <?php endforeach; ?>
+                    <?php foreach ($storeSwitcherViewModel->getStores() as $lang): ?>
+                        <?php if ($lang->getId() != $storeViewModel->getStoreId()): ?>
+                            <a href="<?= $escaper->escapeUrl($switcherUrlProvider->getTargetStoreRedirectUrl($lang)) ?>"
+                               class="block px-4 py-2 lg:px-5 lg:py-2 hover:bg-gray-100"
+                            >
+                                <?= $escaper->escapeHtml($lang->getName()) ?>
+                            </a>
+                        <?php endif; ?>
+                    <?php endforeach; ?>
                 </div>
             </nav>
         </div>
     </div>
+    <script>
+        function initLanguageSwitcher() {
+            return hyva.createBooleanObject('open')
+        }
+        window.addEventListener('alpine:init', () => Alpine.data('initLanguageSwitcher', initLanguageSwitcher), {once: true})
+    </script>
+    <?php $hyvaCsp->registerInlineScript() ?>
 <?php endif; ?>
```

### Store Switcher Component

The store switcher applies the same CSP migration pattern as the language switcher component.

```
--- a/Magento_Store/templates/switch/stores.phtml
+++ b/Magento_Store/templates/switch/stores.phtml
@@ -9,6 +9,7 @@
 declare(strict_types=1);

 use Hyva\Theme\Model\ViewModelRegistry;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\Store;
 use Hyva\Theme\ViewModel\StoreSwitcher;
 use Magento\Framework\Escaper;
@@ -19,6 +20,7 @@ use Magento\Store\ViewModel\SwitcherUrlProvider;

 /** @var Template $block */
 /** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */

 /** @var SwitcherUrlProvider $switcherUrlProvider */
@@ -33,7 +35,7 @@ $storeSwitcherViewModel = $viewModels->require(StoreSwitcher::class);
 $currentStore = $storeSwitcherViewModel->getStore();
 ?>
 <?php if (count($storeSwitcherViewModel->getGroups()) > 1): ?>
-    <div x-data="{ open: false }"
+    <div x-data="initStoreSwitcher"
          class="w-full sm:w-1/2 md:w-full"
     >
         <div class="title-font font-medium text-gray-900 tracking-widest text-sm mb-3 uppercase">
@@ -43,9 +45,9 @@ $currentStore = $storeSwitcherViewModel->getStore();
             <div>
             <?php foreach ($storeSwitcherViewModel->getGroups() as $group): ?>
                 <?php if ($group->getId() == $storeSwitcherViewModel->getCurrentGroupId()): ?>
-                <button @click.prevent="open = !open"
-                        @click.outside="open = false"
-                        @keydown.window.escape="open=false"
+                <button @click.prevent="toggleOpen"
+                        @click.outside="setOpenFalse"
+                        @keydown.window.escape="setOpenFalse"
                         type="button"
                         class="form-select w-full pl-4"
                         aria-haspopup="true"
@@ -56,7 +58,7 @@ $currentStore = $storeSwitcherViewModel->getStore();
                 <?php endif; ?>
             <?php endforeach; ?>
             </div>
-            <nav x-cloak=""
+            <nav x-cloak
                  x-show="open"
                  class="absolute right-0 top-full z-20 w-56 py-2 mt-1 overflow-auto origin-top-left rounded-sm shadow-lg sm:w-48 lg:mt-3 bg-container-lighter">
                 <div class="my-1" role="menu" aria-orientation="vertical" aria-labelledby="options-menu">
@@ -73,4 +75,11 @@ $currentStore = $storeSwitcherViewModel->getStore();
             </nav>
         </div>
     </div>
+    <script>
+        function initStoreSwitcher() {
+            return hyva.createBooleanObject('open')
+        }
+        window.addEventListener('alpine:init', () => Alpine.data('initStoreSwitcher', initStoreSwitcher), {once: true})
+    </script>
+    <?php $hyvaCsp->registerInlineScript() ?>
 <?php endif; ?>
```

### Login as Customer Notice Component

The Login as Customer notice migration follows the same pattern as the cookie notice banner component.

```
--- a/Magento_Cookie/templates/notices.phtml
+++ b/Magento_Cookie/templates/notices.phtml
@@ -10,14 +10,16 @@ declare(strict_types=1);

 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\HeroiconsOutline;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\Store as StoreViewModel;
 use Magento\Cookie\Block\Html\Notices;
 use Magento\Framework\Escaper;
 use Magento\Cookie\Helper\Cookie;

 /** @var Notices $block */
-/** @var Escaper $escaper */
 /** @var Cookie $cookieHelper */
+/** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */

 /** @var HeroiconsOutline $heroicons */
@@ -56,6 +58,9 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
             checkAcceptCookies() {
                 this.showCookieBanner = ! isAllowedSaveCookie();
             },
+            hideCookieBanner() {
+                this.showCookieBanner = false;
+            },
             setAcceptCookies() {
                 const cookieExpires = this.cookieLifetime / 60 / 60 / 24;
                 hyva.setCookie(this.cookieName, this.cookieValue, cookieExpires);
@@ -64,15 +69,17 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
                 } else {
                     window.dispatchEvent(new CustomEvent('user-allowed-save-cookie'));
                 }
+                this.showCookieBanner = false;
             }
         }
     }
+    window.addEventListener('alpine:init', () => Alpine.data('initCookieBanner', initCookieBanner), {once: true})
 </script>
-
+    <?php $hyvaCsp->registerInlineScript() ?>
 <section id="notice-cookie-block"
          aria-label="<?= $escaper->escapeHtmlAttr(__('We use cookies to make your experience better.')) ?>"
-         x-data="initCookieBanner()"
-         x-init="checkAcceptCookies()"
+         x-data="initCookieBanner"
+         x-init="checkAcceptCookies"
          x-defer="idle"
 >
     <template x-if="showCookieBanner">
@@ -82,7 +89,7 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
                 border-t-2 border-container-darker"
         >
             <button
-                @click="showCookieBanner = false;"
+                @click="hideCookieBanner"
                 aria-label="<?= $escaper->escapeHtmlAttr(__('Close panel')) ?>"
                 title="<?= $escaper->escapeHtmlAttr(__('Close panel')) ?>"
                 class="absolute right-0 top-0 p-4"
@@ -108,7 +115,7 @@ if ($cookieHelper->isCookieRestrictionModeEnabled()): ?>
                     </a>
                 </p>
                 <div class="my-2">
-                    <button @click="setAcceptCookies(); showCookieBanner = false"
+                    <button @click="setAcceptCookies"
                             id="btn-cookie-allow"
                             class="btn btn-primary"
                     >
```

### Login as Customer Logout Link

The logout link component uses data attributes and method references to achieve CSP compatibility without inline scripts.

```
--- a/Magento_LoginAsCustomerFrontendUi/templates/html/notices/logout-link.phtml
+++ b/Magento_LoginAsCustomerFrontendUi/templates/html/notices/logout-link.phtml
@@ -8,23 +8,35 @@

 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\HeroiconsOutline;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Magento\Customer\Block\Account\AuthorizationLink;
 use Magento\Framework\Escaper;

 /** @var AuthorizationLink $block */
 /** @var Escaper $escaper */
 /** @var ViewModelRegistry $viewModels */
+/** @var HyvaCsp $hyvaCsp */

 /** @var HeroiconsOutline $heroicons */
 $heroicons = $viewModels->require(HeroiconsOutline::class);

 $dataPostParam = '';
 if ($block->isLoggedIn()) {
-    $dataPostParam = sprintf(" @click.prevent='hyva.postForm(%s)'", $block->getPostParams());
+    $dataPostParam = sprintf(' @click.prevent="closeSession"');
 }
 ?>
-
-<a
+<script>
+    function initCloseLoginAsCustomerSession() {
+        return {
+            closeSession() {
+                hyva.postForm(<?= /** @noEscape */ $block->getPostParams() ?>);
+            }
+        }
+    }
+    window.addEventListener('alpine:init', () => Alpine.data('initCloseLoginAsCustomerSession', initCloseLoginAsCustomerSession), {once: true})
+</script>
+<?php $hyvaCsp->registerInlineScript(); ?>
+<a x-data="initCloseLoginAsCustomerSession"
     class="-mr-1 flex p-2 rounded-md text-white"
     <?= /* @noEscape */ $block->getLinkAttributes() ?>
     <?= /* @noEscape */ $dataPostParam ?>
```

### Messages Component

The messages component demonstrates handling complex state management while maintaining CSP compatibility. The component displays and dismisses system messages.

```
--- a/Magento_Theme/templates/messages.phtml
+++ b/Magento_Theme/templates/messages.phtml
@@ -10,10 +10,12 @@ declare(strict_types=1);

 use Hyva\Theme\Model\ViewModelRegistry;
 use Hyva\Theme\ViewModel\HeroiconsOutline;
+use Hyva\Theme\ViewModel\HyvaCsp;
 use Hyva\Theme\ViewModel\StoreConfig;
 use Magento\Framework\Escaper;

 /** @var Escaper $escaper */
+/** @var HyvaCsp $hyvaCsp */
 /** @var ViewModelRegistry $viewModels */
 /** @var HeroiconsOutline $heroicons */
 /** @var StoreConfig $storeConfig */
@@ -38,8 +40,14 @@ $defaultSuccessMessageTimeout = $storeConfig->getStoreConfig('hyva_theme_general
                     }, true
                 )
             },
-            removeMessage(messageIndex) {
-                this.messages[messageIndex] = undefined;
+            hasMessages() {
+                return !this.isEmpty();
+            },
+            hasMessage() {
+                return !!this.message;
+            },
+            removeMessage() {
+                this.messages[this.index] = undefined;
             },
             addMessages(messages, hideAfter) {
                 messages.map((message) => {
@@ -74,31 +82,38 @@ $defaultSuccessMessageTimeout = $storeConfig->getStoreConfig('hyva_theme_general
                 ['@clear-messages.window']() {
                     this.messages = [];
                 }
+            },
+            getMessageUiId() {
+                return 'message-' + this.message.type;
             }
         }
     }
+
+    window.addEventListener('alpine:init', () => Alpine.data('initMessages', initMessages), {once: true})
 </script>
+<?php $hyvaCsp->registerInlineScript() ?>
 <section id="messages"
-         x-data="initMessages()"
+         x-data="initMessages"
          x-bind="eventListeners"
          aria-live="assertive"
          role="alert"
 >
-    <template x-if="!isEmpty()">
+    <template x-if="hasMessages">
         <div class="w-full">
             <div class="messages container mx-auto py-3">
                 <template x-for="(message, index) in messages" :key="index">
                     <div>
-                        <template x-if="message">
-                            <div class="message" :class="message.type"
-                                 :ui-id="'message-' + message.type"
+                        <template x-if="hasMessage">
+                            <div class="message"
+                                 :class="message.type"
+                                 :ui-id="getMessageUiId"
                             >
                                 <span x-html="message.text"></span>
                                 <button
                                     type="button"
                                     class="text-gray-600 hover:text-black"
                                     aria-label="<?= $escaper->escapeHtml(__('Close message')) ?>"
-                                    @click.prevent="removeMessage(index)"
+                                    @click.prevent="removeMessage"
                                  >
                                     <?= $heroicons->xHtml('stroke-current', 18, 18, ['aria-hidden' => 'true']); ?>
                                 </button>
```

## Related Topics

- **[CSP Script Authorization](csp-script-validation.html)** - How script authorization works with nonces under strict CSP
- **[Move Scripts to Page Load](csp-move-scripts-page-load.html)** - How to extract inline scripts from Magewire components for CSP compliance
- **[Strict CSP Mode in Checkout](csp-force-strict-mode-for-checkout.html)** - How strict CSP is enforced on checkout routes
