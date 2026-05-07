<!-- source: https://docs.hyva.io/hyva-themes/writing-code/layout-and-templates/the-hyva_-layout-handles.html -->

# The hyva\_ Layout Handles

On store views using a Hyvä theme, for every layout update handle that is applied on a page, a new handle with an `hyva_` prefix is automatically applied, too.

For example, assume a page in a luma store loads the following layout handles:

- `default`
- `cms_index_index`
- `cms_page`
- `customer_logged_out`

In Hyvä, the following handles will also be loaded after the original handles:

- `hyva_default`
- `hyva_cms_index_index`
- `hyva_cms_page`
- `hyva_customer_logged_out`

The prefixed handles are always loaded after the regular handles, so any values from the original handle can be overridden in `hyva_*` handles.

This feature allows for compatibility modules to be installed in Magento instances with both Luma and Hyvä store views side by side at the same time, without interfering with the rendering of the Luma stores.

All the layout changes that need to be applied in Hyvä go into the `hyva_` prefixed layout handles, and thus are only applied if a Hyvä theme is active in the current store view.

If you’d be developing a module that supports both Luma as Hyvä out-of-the-box, you can add standard Luma blocks/phtml files with the default layout handles, and add additional `hyva_` layout files to provide Hyvä specific overrides.

In PHP Classes

The class `Hyva\Theme\Service\CurrentTheme` can be injected in any class and the method `$this->currentTheme->isHyva()` may be used to check if the current request is for a store with Hyvä.
