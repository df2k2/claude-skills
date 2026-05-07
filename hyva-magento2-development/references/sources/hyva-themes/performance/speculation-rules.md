<!-- source: https://docs.hyva.io/hyva-themes/performance/speculation-rules.html -->

# Speculation Rules

The Speculation Rules API allows developers to define rules that tell the browser which pages to prefetch or prerender before a user clicks on a link. This can lead to near-instant page loads.

Available from Hyvä Default Theme 1.4

Speculation Rules are a stable feature from Hyvä Default Theme 1.4 and enabled by default.

By default, Hyvä is configured to `prefetch` links when a user hovers over them.

## Configuration

The speculation rules can be configured in the Magento 2 admin under `Stores → Configuration → Hyvä Themes → General → Speculation Rules`.

### Method

The available options are:

- `prefetch` (default)
- `prerender`
- `Disabled (no speculative loading)`

### Eagerness

The eagerness of the speculation rules can also be configured. The available options are:

- `immediate`
- `eager`
- `moderate` (default)
- `conservative`

## Prerendering: Benefits and Considerations

Choosing `prerender` can create a truly instant navigation experience for users, but it comes with trade-offs that you should be aware of.

### Benefits

When a browser prerenders a page, it does everything needed to render the page in a background tab: it downloads all resources, executes JavaScript, and prepares the page for display. When the user clicks the link, the prerendered page is swapped into the foreground almost instantly. This provides the fastest possible navigation experience.

### Resource Consumption

Prerendering is more resource-intensive than prefetching. It consumes more memory and CPU on the client's device and can increase server load, as the browser will request and process all the resources for a page that the user may not even visit. It is best used for pages that have a very high probability of being the user's next navigation.

### Analytics

Prerendering can interfere with analytics. When a page is prerendered, analytics scripts (like Google Analytics) may execute and record a "page view," even if the user never actually views the page. This can lead to inflated and inaccurate metrics.

Some analytics platforms are aware of prerendering and handle it automatically. For others, you may need to add custom logic to your analytics tracking code to check if the page is being prerendered and only fire page view events upon activation (i.e., when the user actually navigates to the page).

To handle this, you can use the `document.prerendering` property and the `prerenderingchange` event to control when your code executes.

JavaScript: Deferring execution until page activation

```
const initAnalytics = () => {
  console.log('Page is now visible. Firing analytics.');
  // Place your analytics initialization or page view tracking code here
  // For example: gtag('event', 'page_view', { ... });
};

if (document.prerendering) {
  // Page is being prerendered. Wait for it to be activated.
  document.addEventListener('prerenderingchange', initAnalytics);
} else {
  // Page was not prerendered, so initialize analytics right away.
  initAnalytics();
}
```

This code ensures that your analytics tracking will only be initialized after the page is actually visible to the user, whether it was prerendered or not.

## Excluding Paths

You can prevent speculation for specific URL paths. This is useful for pages like `customer/account/logout` or cart-related actions that should not be prefetched.

This can be done through Layout XML or your module's `frontend/di.xml`.

### Layout XML

In your theme, you can add paths to the exclude list by passing arguments to the `speculationrules` block in a layout XML file.

Example of excluding paths via layout.xml

```
<referenceBlock name="speculationrules">
    <arguments>
        <argument name="exclude_list" xsi:type="array">
            <item name="logout_path" xsi:type="string">customer/account/logout</item>
            <item name="add_to_cart_path" xsi:type="string">checkout/cart/add</item>
        </argument>
    </arguments>
</referenceBlock>
```

### frontend/di.xml

You can achieve the same result by adding paths to the `excludeFromPreloading` argument of the `Hyva\Theme\ViewModel\SpeculationRules` view model in your module's `frontend/di.xml`.

In this configuration, the path you want to exclude is the `name` of the item, and the value should be set to `true`.

This method also allows you to disable the default excluded paths, but be aware of the consequences, as it might affect frontend behavior.

Example of excluding paths via frontend/di.xml

```
<type name="Hyva\Theme\ViewModel\SpeculationRules">
    <arguments>
        <argument name="excludeFromPreloading" xsi:type="array">
            <item name="my/dynamic/url" xsi:type="boolean">true</item>
        </argument>
    </arguments>
</type>
```

## Resources & Articles

- Caniuse Support: [Caniuse Speculation Rules](https://caniuse.com/mdn-http_headers_speculation-rules)
- Mozilla Developer Docs: [Speculation Rules API](https://developer.mozilla.org/en-US/docs/Web/API/Speculation_Rules_API)
- Chrome Developer Docs: [Chrome Dev - Preload Pages](https://developer.chrome.com/docs/web-platform/prerender-pages)
