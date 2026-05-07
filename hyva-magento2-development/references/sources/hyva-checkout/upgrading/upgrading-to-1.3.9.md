<!-- source: https://docs.hyva.io/hyva-checkout/upgrading/upgrading-to-1.3.9.html -->

# Upgrading to 1.3.9

This release introduces pre-populated name fields for logged-in customers and improved multi-tab checkout stability with stale data and empty cart detection, along with a number of important bugfixes.

Please refer to the [changelog](changelog.html#139-2026-02-20) for details.

Please check the [upgrade process overview](index.html#hyva-checkout-upgrade-process) for Hyvä-Checkout first.

Then, to upgrade, run the command:

```
composer update --with-dependencies hyva-themes/magento2-hyva-checkout:1.3.9
```

## Backward Incompatible Changes

- No Backward Incompatible Changes.

## Deprecations

This template has been replaced by the deferrable push pattern. Dialogs and redirects are now registered via `Hyva\Checkout\Magewire\Main::pushDeferrables()`
and triggered through the evaluation results factory, making this hardcoded template redundant. See `Hyva\Checkout\Magewire\Main::pushDeferrables()` for changes.

- src/view/frontend/templates/page/js/api/v1/evaluation/multi-tabs-compatibility.phtml

## Template changes

- src/view/frontend/templates/page/js/api/v1/evaluation/deferable-dialog-events.phtml
- src/view/frontend/templates/page/js/magewire/plugin/error.phtml

## Changelogs

Changelogs are available from the `CHANGELOG.md` in the codebase, or [here in the docs](changelog.html).
