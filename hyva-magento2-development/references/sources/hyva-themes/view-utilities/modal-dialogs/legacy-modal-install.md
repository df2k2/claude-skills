<!-- source: https://docs.hyva.io/hyva-themes/view-utilities/modal-dialogs/legacy-modal-install.html -->

# Legacy Modal System

The modal system was rebuilt in Hyvä 1.5.0 on native `<dialog>` elements. Projects that cannot migrate immediately can install the compatibility module to restore the pre-1.5.0 behaviour alongside the new system.

## When do you need this module?

The new modal system relies on the browser (together with the `x-htmldialog` Alpine plugin) to handle Escape, click-outside, focus containment, and page interaction blocking. As a result, the document-level event listeners and focus trap calls were removed from the core modal script.

Modal markup written without the PHP Modal view model (see [Modals without PHP](modals-without-php.html)) and custom modal container templates based on the old default container continue to render after upgrading, but lose:

- closing with the Escape key
- closing by clicking outside the dialog
- keyboard focus trapping inside the open dialog
- focus restoration to the opening element
- page scroll locking while the dialog is open

This module restores those behaviours for legacy markup only, identified at runtime by the dialog element not being a native `<dialog>`. Native dialogs are not affected. The core modal script logs a console warning when legacy markup is detected and this module is not installed.

## Installation

```
composer require hyva-themes/magento2-legacy-modal-compatibility
bin/magento module:enable Hyva_LegacyModalCompatibility
bin/magento setup:upgrade
```

For migration steps, refer to the [1.5.1 upgrade guide](../../upgrading/upgrading-to-1-5-1.html#modal-system-modernized-to-native-html-dialog).

## Uninstall when migrated

This module is a temporary solution. Once your modal markup has been migrated to native `<dialog>` elements with [`x-htmldialog`](../../working-with-alpinejs/alpine-plugins/x-htmldialog.html), remove the module:

```
bin/magento module:disable Hyva_LegacyModalCompatibility
composer remove hyva-themes/magento2-legacy-modal-compatibility
```
