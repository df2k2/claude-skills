<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/accessibility.html -->

# Accessibility

Online stores are available to all users of the world wide web, including users with temporary or permanent limitations using assistive technologies (AT) to access web content.

The Hyvä Theme (release 1.3.0 and later) implements accessibility (a11y) features according to [WCAG (Web Content Accessibility Guideline) 2.1](https://www.w3.org/TR/WCAG21/) level AA requirements.

## Supported accessibility features:

- Keyboard support
- Support for Assistive Technologies
- Colors, spacing, and fonts
- Responsiveness – the page adjusts for different devices and various screen widths
- Alternative content

Introduction to Accessibility

Please refer to our blog-post series on accessibility if you are interested in a general introduction into the topic.

- [Accessibility for eCommerce Business Case](https://www.hyva.io/blog/experts-insights/accessibility-the-business-case.html)
- [Accessibility: 10 simple tips for your eCommerce Website](https://www.hyva.io/blog/experts-insights/accessibility-10-simple-tips-for-your-ecommerce-website.html)

## How to work with accessibility in Hyvä?

Accessibility features were released in Hyvä 1.3.0

Care needs to be taken not to degrade accessibility while customizing Hyvä.
This is true both for installed extensions and theme-related changes.

To ensure your store is accessible for all users, a11y features should be implemented and maintained in your theme customization.

Here's a list of tips you may find useful:

### Use semantic HTML

Don't use only `div` and `span` to build the front end. Instead, use HTML landmarks and headings in proper order.
Use buttons and links instead of `div`s or `span`s with an onclick event.
Use lists, paragraphs, and tables. Such semantic tags indicate the role and function of an element without additional code.

### Buttons and links without visible text (with image or icon content) require a label

Use the `aria-label` or the `aria-labelledby` attribute or visually hidden text (via the `sr-only` tailwind class) to supply textual labels. Remember to translate it.

### Focus management

All elements that can receive focus should have a visible outline to indicate their focus state.
Focus order should be logical and consistent.
For modals, remember to move focus inside a modal after it opens and move back to trigger when it closes. Modals implemented with the [Hyvä modal library](../view-utilities/modal-dialogs/index.html) do this automatically, but for other modals (for example sliders) this needs to be implemented.

Since release 1.2.6 Hyvä includes the JavaScript methods [`hyva.trapFocus`](../writing-code/the-window-hyva-object.html#hyvatrapfocuselement-rootelement) and [`hyva.releaseFocus`](../writing-code/the-window-hyva-object.html#hyvareleasefocuselement-rootelement) for this purpose.

### Aria-expanded for collapsible elements

When content in a collapsible component is displayed, use the `aria-expanded` attribute on the trigger element to indicate if the element is collapsed or expanded.
As a reference, see the template `Magento_Customer/templates/header/customer-menu.phtml` in the default theme.

### Live region

When you update a section dynamically on the client side (without page reload), use the `aria-live` attribute on the container to indicate changes and announce them to AT users.
One example of this is the price of bundled products. Please refer to the template `Magento_Bundle/templates/catalog/product/view/price.phtml` for an example.

## How to test the accessibility of your Store?

### Base accessibility testing during development:

- Check your store using automatic tests in your browser using [axe devtools browser plugin](https://chrome.google.com/webstore/detail/axe-devtools-web-accessib/lhdoppojpmngadmnindnejefpokejbdd?utm_source=deque.com&utm_medium=referral&utm_campaign=axe-devtools_overview).
- Shop on the site only using your keyboard - check if new or customized features can be used without a mouse or trackpad.
- Review your code in [DevTools](https://developer.chrome.com/docs/devtools/accessibility/reference/) - check what the accessibility tree looks like and what properties are generated.

### More advanced tests:

- Test with a screen reader - VoiceOver for Mac, NVDA for Windows, or ChromeVox as a browser plugin
- Use [ANDI Accessibility Testing tools](https://www.ssa.gov/accessibility/andi/help/install.html) to check accessibility features in your browser manually

## Does a store built with Hyvä Themes comply with WCAG 2.1 level AA? Is it fully accessible?

Not exactly. The Hyvä Theme provides an accessible frontend template, but that is only part of what makes up a store.
To make an eCommerce store fully accessible, you need to ensure that all content is accessible too (simple language, alternative text for images, audio transcription, and video captions).
All template customizations, both regarding design and functionality, should be tested for accessibility, too.
