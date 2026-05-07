<!-- source: https://docs.hyva.io/hyva-themes/faqs/why-not-smaller-components.html -->

# Why doesn't Hyvä use smaller components?

With other ecosystems and frameworks it is common to compose views from small atomic components like input fields and buttons.
Since Hyvä rebuilt the Magento frontend theme from scratch, why doesn't it use a similar approach?

Hyvä uses .phtml templates as the smallest components. In the context of Magento, this has several benefits:

- Each template file is a self-contained component that includes styles (thanks to Tailwind), JavaScript (thanks to Alpine), and HTML.
- This allows swapping out UI components like banners, menus, footers, swatches and such on a template file level,
- Template level components are better when making existing Magento extensions compatible with Hyvä.
- More familiarity for Magento developers, which allows faster on-boarding.
