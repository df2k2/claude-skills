# Preserve Analytics Tracking while Customizing Subscription Manager Templates

If you are making customizations to your Subscription Manager (SM) template, be careful not to remove or change elements that our library code relies on for front-end analytics. Here is a description of how our front-end tracking works so you can avoid making changes that stop tracking certain events.

Note: this guide assumes familiarity with HTML, CSS, and JS.

## DOM elements

The SM watches certain DOM elements to trigger tracking events. Most of these are **click** listeners to trigger a tracking event when a button or link are clicked. Certain events are also triggered when a given element becomes **visible** on screen, e.g. in a multi-step cancel flow. If you move or change the attributes on these elements, these events may no longer be fired.

Below is a list of the CSS selectors the SM watches, as well as what kind of interactions trigger a tracking event. If the element matches any of the selectors for an event, then the tracking event is fired. The selectors are based on the position of the elements that trigger these events in the default v0 and v25 templates. Some events have multiple selectors; if any of these match, the event is fired. The SM will always check every selector listed below; e.g. if you have a v25 template but a button matches a v0 selector, then the tracking event will still be fired.

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Event name
      </th>

      <th>
        Type
      </th>

      <th>
        CSS selectors (v25)
      </th>

      <th>
        CSS selectors (v0)
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        skuswap\_started
      </td>

      <td>
        click
      </td>

      <td>
        `[data-click-target^=og-sku-swap-dialog]`
      </td>

      <td>
        `.og-change-product-control > .og-link`
      </td>
    </tr>

    <tr>
      <td>
        skuswap\_exited
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-sku-swap-dialog] :is(.og-dialog-close, .og-dialog-footer button[type="button"])`

        `[id^=og-sku-swap-dialog] [data-dialog-close]`
      </td>

      <td>
        `dialog[id^="og-change-product"] button[type="reset"]`
      </td>
    </tr>

    <tr>
      <td>
        skuswap\_completed\_swapped
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-sku-swap-dialog] button[type="submit"]`
      </td>

      <td>
        `dialog[id^="og-change-product"] button[name="change_product"]`
      </td>
    </tr>

    <tr>
      <td>
        subscriptioncancel\_started
      </td>

      <td>
        click
      </td>

      <td>
        `[data-click-target^=og-cancel-sub-dialog]`
      </td>

      <td>
        `.og-cancel-subscription-button > .og-link`
      </td>
    </tr>

    <tr>
      <td>
        subscriptioncancel\_exited
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] .og-dialog-close`

        `[id^=og-cancel-sub-dialog] [data-dialog-close]`
      </td>

      <td>
        `.og-cancel-subscription-button button[type="reset"]`
      </td>
    </tr>

    <tr>
      <td>
        subscriptioncancel\_skuswap\_shown
      </td>

      <td>
        visibility
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="swap"]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_completed\_saved\_swapped
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="swap"] button[type="submit"]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_skuswap\_backedout
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="swap"] button[data-back-button]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_skip\_shown
      </td>

      <td>
        visibility
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="skip"]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_completed\_saved\_skipped
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="skip"] button[type="submit"]`
      </td>

      <td>
        `.og-cancel-subscription-button button[name="skip_subscription"]`
      </td>
    </tr>

    <tr>
      <td>
        subscriptioncancel\_skip\_backedout
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="skip"] button[data-back-button]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_pause\_shown
      </td>

      <td>
        visibility
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="pause"]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_completed\_saved\_paused
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="pause"] button[type="submit"]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_pause\_backedout
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="pause"] button[data-back-button]`
      </td>

      <td />
    </tr>

    <tr>
      <td>
        subscriptioncancel\_exitsurvey\_shown
      </td>

      <td>
        visibility (v25) / click (v0)
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="reason"]`
      </td>

      <td>
        `.og-cancel-subscription-button button[name="continue_cancel_subscription"]`
      </td>
    </tr>

    <tr>
      <td>
        subscriptioncancel\_exitsurvey\_backedout
      </td>

      <td>
        click
      </td>

      <td>
        `[id^=og-cancel-sub-dialog] [data-step="reason"] button[data-back-button]`
      </td>

      <td />
    </tr>
  </tbody>
</Table>

### Preventing DOM elements from firing tracking events

If you do not want an element matching one of these selectors to fire a tracking event, you can add a `data-og-no-track` attribute to it or to a parent element. Placing this attribute on a parent element will prevent interactions with any of its descendant elements from firing a tracking event.

## Form actions

Our code also fires certain tracking events from our SM library code when certain forms are submitted. For example, the change\_product form looks like this. This will automatically trigger a handler inside our SM library that will make the appropriate API calls and fire a tracking event.

```liquid
<form
  action="{{ 'change_product' | action }}"
  @success="{{ 'SMDialog.close' | js }}"
  @reset="{{ 'SMDialog.close' | js }}"
>
```

If instead of using the existing SM form elements, you directly make fetch calls from JavaScript, we will be missing these tracking events. To keep the existing tracking events, continue to use our forms.

| Tracking event                          | Form action attribute |
| :-------------------------------------- | :-------------------- |
| subscriptioncancel\_completed\_canceled | cancel\_subscription  |

## Making API calls

If you directly make fetch calls to Ordergroove APIs from your JavaScript code, add the `tracking-source: MSI` header. This allows us to attribute those actions to the SM (as opposed to a customer service agent or other processes).

## Verifying that tracking is working

If you want to check that events are being fired, use your browser's dev tools and look for requests to [https://staging.collect.ordergroove.com.](https://staging.collect.ordergroove.com.) You can see the event that was fired in the request.

Note: this API endpoint is not considered to be public and may have breaking changes at any time. Do not call this endpoint directly.

## Further customization

If you want additional control over when and where tracking events are fired, reach out to your Ordergroove representative. We don’t currently expose any JS APIs to directly fire tracking events, but are gathering feedback to guide our future roadmap.

If you find that a tracking event has gone missing after making SM changes, reach out to your Ordergroove representative for assistance.