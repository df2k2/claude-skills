<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-theme/index.html -->

# Admin Theme

The [Hyvä Commerce](https://www.hyva.io/hyva-commerce.html) Admin Theme provides a modern and refreshed look and feel to the Magento admin panel. Our theme is based on the [Mage-OS M137 Admin Theme](https://github.com/mage-os-lab/theme-adminhtml-m137), thanks to the amazing work of Artem Kozynets and many others in the [Mage-OS](https://mage-os.org/) community.

[![Hyvä Commerce Admin Theme Login Page](images/hc-admin-login.png)](images/hc-admin-login.png)

[![Hyvä Commerce Admin Theme Product Grid](images/hc-admin-products.png)](images/hc-admin-products.png)

For more details on upcoming (and previously released) features, see the [Hyvä Commerce Roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).

## FAQs

Is the admin theme required when using Hyvä Commerce?

No, you can switch to using another admin theme via [configuration](configuration.html), or choose not to install our admin theme if you don't want to use it.

Can I switch back to the default theme?

Yes, you can switch to using another admin theme via [configuration](configuration.html).

Will the admin theme work with my custom or 3rd party modules?

Yes, there is no change to the tech stack (see below). At worst, you may encounter minimal styling bugs.

What is the tech stack of the admin theme?

The tech stack is the same as the default Magento and Mage-OS admin themes, i.e. LESS, RequireJS, Knockout and all other default libraries and approaches. This has been maintained to ensure compatibility with existing admin theme 3rd party extensions and customisations.

Can I customise the admin theme?

Yes, you can add custom logos in [configuration](configuration.html#admin-branding-logos). Or, for styling, layout and other code changes, you can customise it like any other default Magento theme. We recommend to create a new child admin theme and make our theme the parent theme. You can then make your customisations in your child theme and set it as the active theme in [configuration](configuration.html#active-theme).
