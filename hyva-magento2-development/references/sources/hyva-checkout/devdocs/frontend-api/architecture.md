<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/architecture.html -->

# Hyvä Checkout Frontend API Architecture

The Hyvä Checkout Frontend API lives at `window.hyvaCheckout` and gives you a structured JavaScript namespace for interacting with checkout functionality. This page covers the file structure, Layout XML organization, sub-namespace system, initialization process, and how to extend the API with your own code.

## Frontend API File and Directory Structure

The Hyvä Checkout Frontend API follows a predictable file structure within the `Hyva_Checkout` module. All API-related files reside in `Hyva_Checkout::page/js/api`.

| Name | Description |
| --- | --- |
| v1.phtml | The main API file defining the global `hyvaCheckout` namespace and all sub-namespaces. Located at `Hyva_Checkout::page/js/api/v1.phtml`. |
| init.phtml | API bootstrapping logic that initializes the checkout on `DOMContentLoaded`. |
| /alpinejs | AlpineJS-specific plugins used by checkout components. |
| /directive | **Deprecated** - Legacy AlpineJS directive implementations. |
| /evaluation | UX elements supporting the `hyvaCheckout.evaluation` sub-namespace. |
| /message | UX elements supporting the `hyvaCheckout.message` sub-namespace. |
| /navigation | UX elements supporting the `hyvaCheckout.navigation` sub-namespace. |

Each sub-namespace directory requires a file prefixed with `init-` (for example, `init-evaluation.phtml`) to ensure the `after` child container is added. This allows you to inject code that runs after a specific sub-namespace initializes.

Missing directories

Not every sub-namespace has a dedicated directory yet. Directories are added when specific UX additions are needed. Future directories will always match the sub-namespace name.

## Layout XML Structure for the Frontend API

The Hyvä Checkout Frontend API uses a hierarchical Layout XML structure defined primarily in `hyva_checkout_index_index.xml`. The checkout page itself is static (loaded once), while Magewire components handle dynamic updates. This design prevents redundant API loading.

### The hyva.checkout.api Block

The `hyva.checkout.api` block injects the versioned Frontend API into the page immediately after the checkout main component.

- **Type:** Block
- **Template:** `Hyva_Checkout::page/js/api/v1.phtml`
- **Parent:** main
- **After:** hyva.checkout.main

### The hyva.checkout.api-v1.after Container

The `hyva.checkout.api-v1.after` container prevents JavaScript from being added before the API is defined. All AlpineJS components and sub-namespace `init-` blocks go here.

- **Type:** Container
- **Alias:** after
- **Parent:** hyva.checkout.api

Each `init-` file (for example, `init-config.phtml` or `init-evaluation.phtml`) has its own `after` container for injecting sub-namespace-specific JavaScript.

Best Practice for API Extensions

Always include an `after` aliased container as a child when creating your own init blocks.

The following example shows how to add a custom analytics initialization block with proper structure.

Adding a Custom Init Block with After Container

```
<!-- File: view/frontend/layout/hyva_checkout_index_index.xml -->

<referenceContainer name="hyva.checkout.api-v1.after">
    <!-- Custom analytics init block -->
    <block name="hyva.checkout.init-analytics"
           template="Hyva_Checkout::page/js/api/v1/init-analytics.phtml"
    >
        <!-- Best practice: Include after container for downstream extensions -->
        <!-- Analytics phtml files go in: Module_Name::page/js/api/v1/analytics/ -->
        <container name="hyva.checkout.init-analytics.after" as="after"/>
    </block>
</referenceContainer>
```

Info

For more details about extending the API, see the [Extending the Hyvä Checkout Frontend API](#extending-the-hyva-checkout-frontend-api) section below.

## The Frontend API Core File

**File:** `Hyva_Checkout::page/js/api/v1.phtml`

The Hyvä Checkout Frontend API core file defines all fundamental sections in a single file. This file is intentionally not split to prevent accidental overwrites and is marked as `@internal`.

### Frontend API Sub-namespaces

The Hyvä Checkout Frontend API organizes functionality into sub-namespaces under the `hyvaCheckout` global object. Each sub-namespace contains standalone methods for a specific domain.

The following example demonstrates accessing the `storage` sub-namespace to store a value.

Using a Sub-namespace Method

```
// Store "bar" with key "foo" in group "documentation" using the storage sub-namespace
hyvaCheckout.storage.setValue('foo', 'bar', 'documentation')
```

Keep sub-namespace access single-layer deep

If you add custom sub-namespaces to `hyvaCheckout`, keep them one level deep.

**Incorrect pattern:**

```
hyvaCheckout.storage.local.setValue('foo', 'bar', 'documentation')
```

**Correct pattern:**

```
hyvaCheckout.storage.setLocalValue('foo', 'bar', 'documentation')
```

### Frontend API Initialization Process

The Hyvä Checkout Frontend API initializes on the `DOMContentLoaded` window event. The `main` sub-namespace orchestrates initialization of all other sub-namespaces.

API Initialization in init.phtml

```
// File: Hyva_Checkout::page/js/api/V1/init.phtml

window.addEventListener('DOMContentLoaded', () => {
    hyvaCheckout.main.init(
        // Main Magewire wrapper component ID
        'hyva-checkout-main',
        // Content container holding all checkout step components
        'hyva-checkout-container',
        // Callback for handling initialization failures
        exception => console.log(exception)
    )
})
```

The `init()` method iterates over all sub-namespaces within `hyvaCheckout`. For each sub-namespace, the method checks if the value is an object with methods or a function. If an object has an `initialize()` method, that method is executed with the backend config object.

### Sub-namespace Initialization Events

After each sub-namespace initializes, the Hyvä Checkout Frontend API dispatches a window event for that sub-namespace, regardless of whether the sub-namespace is part of the core or is custom.

The Sub-namespace initialization event is dispatched for every sub-namespace

```
window.dispatchEvent(new CustomEvent(`checkout:init:${ subnamespace }`))
```

You can listen to these events to execute code right after a specific sub-namespace is ready.

Listening for Sub-namespace Initialization

```
// Execute code right after the storage sub-namespace initializes
window.addEventListener('checkout:init:storage', event => {
    console.log('Storage sub-namespace initialized successfully.');
});
```

After all sub-namespaces initialize, the Hyvä Checkout Frontend API is marked as active and dispatches `checkout:init:after` on the `window`. If an exception occurs during initialization, the exception is passed to the `exceptionCallback` provided to `init()`.

## Extending the Hyvä Checkout Frontend API

Extend the Hyvä Checkout Frontend API when the existing options do not meet your needs. Extensions should be abstract enough for reuse across different scenarios. For very specific requirements, use an AlpineJS plugin instead.

Extension Rule: No Direct DOM Targeting

Never target specific page elements by `id`, `class`, or `data-` attribute in API extensions. The checkout is dynamic, so elements may not exist when your code runs. Instead, ensure your functions receive required elements as arguments.

### Adding a New Sub-namespace to the Frontend API

To add a completely new sub-namespace, create a block in the API layout container. The following example adds a custom analytics sub-namespace to the Hyvä Checkout Frontend API.

Layout XML for New Sub-namespace

```
<!-- File: view/frontend/layout/hyva_checkout_index_index.xml -->

<referenceBlock name="hyva.checkout.api-v1.after">
    <block name="hyva.checkout.utils-extend"
           template="My_Example::page/js/hyva-checkout/api/v1/company-name-analytics.phtml"/>
</referenceBlock>
```

The following example phtml implementation defines a new sub-namespace and its methods.

Sub-namespace Implementation (company-name-analytics.phtml)

```
<!-- File: My_Example::page/js/hyva-checkout/api/v1/company-name-analytics.phtml -->

<script>
    'use strict';

    // Check if hyvaCheckout exists and sub-namespace is not already defined
    if (hyvaCheckout && !hyvaCheckout.hasOwnProperty('companyNameAnalytics')) {
        hyvaCheckout.companyNameAnalytics = {
            // Internal state for tracking click history
            clicksHistory: [],
            clicksHistoryInterval: null,

            /**
             * Called automatically during API initialization.
             * Sets up document-level click tracking.
             */
            initialize() {
                document.addEventListener('click', event => this.clicksHistory.push(event.target));
            },

            /**
             * Returns the array of clicked elements since last clear.
             * @returns {Array} Array of DOM elements
             */
            getClicksHistory() {
                return this.clicksHistory;
            },

            /**
             * Clears the click history array.
             */
            clearClicksHistory() {
                this.clicksHistory = [];
            },

            /**
             * Starts interval logging of click history every 5 seconds.
             * Each log clears the history.
             */
            tailClicksHistory() {
                this.clicksHistoryInterval = setInterval(() => {
                    console.log('Clicks log', hyvaCheckout.companyNameAnalytics.getClicksHistory());
                    this.clearClicksHistory();
                }, 5000);
            },

            /**
             * Stops the click history logging interval.
             */
            disableClicksHistory() {
                clearInterval(this.clicksHistoryInterval);
                console.log('Clicks history tailing disabled. Restart using tailClicksHistory().');
            }
        };
    }

    // Example usage (remove in production)
    hyvaCheckout.companyNameAnalytics.tailClicksHistory();
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

### Adding Methods to Existing Sub-namespaces

When you need additional methods on an existing sub-namespace, the best approach is to submit a pull request to the core. However, you can also add methods locally using the sub-namespace's `after` container.

The following example adds a `stepToFirst` method to the existing `navigation` sub-namespace.

Layout XML for Method Extension

```
<!-- File: view/frontend/layout/hyva_checkout_index_index.xml -->

<referenceContainer name="hyva.checkout.init-navigation.after">
    <block name="hyva.checkout.navigation.to-first-step"
           template="My_Example::page/js/hyva-checkout/api/v1/navigation/step-to-first.phtml"
    />
</referenceContainer>
```

The phtml template uses the Navigation ViewModel to get the first step route, then defines the new method on the existing sub-namespace.

Method Extension Implementation (step-to-first.phtml)

```
<!-- File: My_Example::page/js/hyva-checkout/api/v1/navigation/step-to-first.phtml -->

<?php
/** @var \Hyva\Theme\Model\ViewModelRegistry $viewModels */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Hyva\Checkout\ViewModel\Navigation $viewModel */

// Get the Navigation ViewModel to access checkout step information
$viewModel = $viewModels->require(\Hyva\Checkout\ViewModel\Navigation::class);
$navigator = $viewModel->getNavigator();
// Retrieve the first step of the active checkout configuration
$first = $navigator->getActiveCheckout()->getFirstStep();
?>
<script>
    'use strict';

    // Only add if navigation sub-namespace exists and method is not defined
    if (hyvaCheckout.navigation) {
        if (!hyvaCheckout.navigation.hasOwnProperty('stepToFirst')) {
            /**
             * Navigate to the first checkout step.
             * Uses server-rendered route from the Navigation ViewModel.
             */
            hyvaCheckout.navigation.stepToFirst = function () {
                hyvaCheckout.navigation.stepTo(
                    '<?= $escaper->escapeJs($first->getRoute()) ?>',
                    false  // Do not push to browser history
                );
            };
        }
    }
</script>
<?php $hyvaCsp->registerInlineScript() ?>
```

Tip

Separate each method extension into its own phtml file for maintainability.

### Complementary UX Elements for Frontend API Methods

Complementary elements provide UX components that respond to Hyvä Checkout Frontend API method calls without being part of the API itself. The API dispatches window events that complementary elements listen for.

For example, calling `hyvaCheckout.message.dialog()` dispatches a `checkout:dialog:new` event. A separate AlpineJS component listens for that event and renders the dialog UI.

The following example shows how an API method dispatches an event for complementary elements to handle.

API Method Dispatching Event (v1.phtml)

```
// File: Hyva_Checkout::page/js/api/v1.phtml

message = {
    /**
     * Displays a dialog with the specified title.
     * Dispatches event for complementary UX element to render.
     * @param {string} title - Dialog title (defaults to 'Something went wrong')
     */
    dialog(title) {
        window.dispatchEvent(
            new CustomEvent('checkout:dialog:new', {
                detail: { title: title || 'Something went wrong' }
            })
        );
    }
}
```

Complementary elements live in a sub-namespace directory, with one phtml file per API method. Here is the Layout XML showing where to place the dialog complementary element.

Layout XML for Complementary Element

```
<!-- File: view/frontend/layout/hyva_checkout_index_index.xml -->

<referenceContainer name="hyva.checkout.init-message.after">
    <block name="hyva.checkout.message.dialog"
           template="Hyva_Checkout::page/js/api/v1/message/dialog.phtml"
    />
</referenceContainer>
```

The phtml file contains an AlpineJS component that listens for the event and renders the UI. The component must be CSP-compliant, using a registered Alpine component function instead of inline expressions.

Complementary Element Implementation (dialog.phtml) - CSP Compliant

```
<!-- File: Hyva_Checkout::page/js/api/v1/message/dialog.phtml -->

<!-- Register the Alpine component with Alpine.data() for strict CSP compatibility -->
<script>
    'use strict';

    /**
     * Alpine CSP-compatible component for checkout dialog.
     * Uses Alpine.data() registration instead of inline x-data object.
     */
    function initCheckoutDialog() {
        return {
            show: false,
            title: null,

            /**
             * Handle the checkout:dialog:new window event.
             * Called via x-on directive with method reference (CSP-safe).
             * @param {CustomEvent} event - The dialog event with title in detail
             */
            handleDialogNew(event) {
                this.show = true;
                this.title = event.detail.title;
            },

            /**
             * Close the dialog and reset state.
             */
            close() {
                this.show = false;
                this.title = null;
            }
        };
    }
    window.addEventListener(
        'alpine:init',
        () => Alpine.data('initCheckoutDialog', () => ({
            open: false
        })),
        {once: true}
    )

</script>
<?php $hyvaCsp->registerInlineScript() ?>

<!-- AlpineJS component using CSP-safe patterns -->
<!-- x-data references registered function, x-on uses method reference -->
<div x-data="initCheckoutDialog"
     x-on:checkout:dialog:new.window="handleDialogNew"
     x-show="show"
>
    <template x-if="title">
        <h3 x-text="title"></h3>
    </template>
</div>
```

CSP Compliance Requirements

Hyvä Checkout runs in strict CSP mode. All Alpine components must:

- Use registered component functions (`x-data="initComponentName"`) instead of inline objects
- Use method references (`x-on:event="methodName"`) instead of inline expressions
- Register inline scripts with `$hyvaCsp->registerInlineScript()` for nonce authorization

There should be only one complementary element per API method. This keeps the architecture structured and predictable for other developers.

## Related Topics

- **[Frontend API Overview](index.html)** - Full list of sub-namespaces and what each one does
- **[Frontend API Events](events.html)** - Complete reference for all checkout JavaScript events
- **[Frontend API Backport Module](backport.html)** - Bring latest API features to older Hyvä Checkout versions
