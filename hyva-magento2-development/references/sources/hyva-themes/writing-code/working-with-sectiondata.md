<!-- source: https://docs.hyva.io/hyva-themes/writing-code/working-with-sectiondata.html -->

# Working with sectionData

What is section data?

"Customer Section Data" is how Magento makes data from a server side session available to the browser JavaScript on pages stored in the full page cache.

We’ve greatly simplified the logic of private section data retrieval and invalidation compared to Luma based frontend.

Compared to stock Magento, its become a lot simpler to understand and work with.

This page covers the key things you should know about private section data in Hyvä.

## sectionData in a Nutshell

- **Customer Section Data** is loaded via Ajax and stored in local storage.
- On **every page load** it is **broadcast** with the JS event `private-content-loaded`.
- The data is **automatically invalidated** after HTTP POST requests. A fresh version is loaded after the next page load.
- Following **Ajax POST** requests, refresh the section data manually without a new page load by dispatching the `reload-customer-section-data` event.
- To **force a refresh** even without a POST request, run `hyva.setCookie('mage-cache-sessid', '', -1, true);` before dispatching `reload-customer-section-data`.

Read on for more details.

Note

We use the terms "private section data", "section data", "private data" and "private content" interchangeably.

Important

In Hyvä it is not possible to subscribe to specific sections. All sections are always combined in one data object.

## Initialization of sectionData

The initialization of `sectionData` is triggered in the footer of every page.

If a visitor has no `private_content_version` cookie, section data with default values is used.
Once the cookie is set after the visitor has triggered any HTTP POST action, the section data is requested via Ajax and stored in LocalStorage.

Fresh section data is requested if the data in LocalStorage is deleted, one hour has passed, or the `private_content_version` cookie changed on the next page load and stored in LocalStorage.
To update the section data before the next page load, for example after sending an Ajax POST request, [the `reload-customer-section-data` event](#client-side) needs to be dispatched manually.

After the section data is loaded, the event `private-content-loaded` is dispatched.

```
// this happens in the footer of every page

{
  function dispatchPrivateContent(data) {
    const privateContentEvent = new CustomEvent('private-content-loaded', {
      detail: {
        data: data
      }
    });
    window.dispatchEvent(privateContentEvent);
  }

  function loadSectionData() {
    // 1. load privateContent from localStorage or default values for visitors without a session.
    //
    // 2. determine if privateContent is valid.
    //    invalidation happens after 1 hour,
    //    or if the private_content_version cookie changed.
    //
    // 3. fetch privateContent from /customer/section/load if needed
    //
    // 4. dispatch privateContent event
    dispatchPrivateContent(data);
  }

  window.addEventListener('load', loadSectionData);
  window.addEventListener('reload-customer-section-data', loadSectionData);
}
```

## Receiving customer data in Alpine.js components

We can receive customer data in Alpine.js by listening to the `private-content-loaded` event on the window:

```
<div x-data @private-content-loaded.window="console.log($event.detail.data)">
```

Here’s an example component that receives the customer and cart data and displays the customer name:

```
<script>
    function initComponent() {
        return {
            cart: false,
            customer: false,
            receiveCustomerData(data) {
                if (data.cart) {
                    this.cart = data.cart;
                }
                if (data.customer) {
                    this.customer = data.customer;
                }
            }
        }
    }
</script>

<div
    x-data="initComponent()"
    @private-content-loaded.window="receiveCustomerData($event.detail.data)"
>
  <template x-if="customer">
    <div>Welcome, <span x-text="customer.firstname"></span></div>
  </template>

  <template x-if="!customer">
    <div>Welcome Guest</div>
  </template>
</div>
```

## Receiving the customer data in native JavaScript

```
<script>
    function initGTM(event) {
    const sectionData = event.detail.data;
        if (sectionData.customer && sectionData.customer.firstname) {
            console.log('Welcome, ' + sectionData.customer.firstname);
        }
    }

    window.addEventListener('private-content-loaded', initGTM);
</script>
```

## See it in action

To see the available data that is dispatched with the `private-content-loaded`, event, run the following code in the browser console:

```
addEventListener('private-content-loaded', event => console.log(event.detail.data));
dispatchEvent(new Event('reload-customer-section-data'));
```

## Reloading / Invalidating sectionData

### Client side

Reloading customer section data can be done by triggering the `reload-customer-section-data` event.

Important

In contrast to Magento Luma themes, in Hyvä private content sections are **not** invalidated individually.

The whole section data is only reloaded from the server if the current data is older than 1 hour, or the private content version cookie is changed.

This can be either after a POST-request, or when the data is more than 1 hour old.

Reload the customer-section-data by dispatching the event

```
window.dispatchEvent(new Event('reload-customer-section-data'));
```

Dispatching the `reload-customer-section-data` event will cause the section data to be reloaded if it is expired and the private content version is changed. Then the `private-content-loaded` event will be triggered again.

If you want to force-reload the section-data, this can be done by removing the `mage-cache-sessid` before dispatching the `reload-customer-section-data` event:

```
hyva.setCookie('mage-cache-sessid', '', -1, true); // remove the cookie
window.dispatchEvent(new CustomEvent("reload-customer-section-data")); // reload the data
```

Do not manually remove `private_content_version` or `cookieVersion` cookies

These cookies are used internally by Hyvä's caching mechanism. While the documented method for forcing a reload involves removing the `mage-cache-sessid` cookie, the `private_content_version` and `cookieVersion` cookies must be left intact. Removing them will prevent section data from reloading correctly.

The `private-content-loaded` event will always be triggered after reloading the sectionData, regardless if it was requested from the server or read from local storage.

### Server side

To force the frontend to refresh the section data from the backend, either the `mage-cache-sessid` cookie or the `private_content_version` cookie need to be deleted.

The latter is [done by Magento](https://github.com/magento/magento2/blob/2.4-develop/lib/internal/Magento/Framework/App/PageCache/Version.php#L78-L89) on any frontend or GraphQL POST request (but not for the REST api).

To do the same in custom PHP code during any POST request, inject `Magento\Framework\App\PageCache\Version` and call `$version->process()`.

To force the refresh in a GET request, copy the code from `Version::process`.
(keep in mind that GET request responses are usually cached in the FPC).

```
$publicCookieMetadata = $this->cookieMetadataFactory->createPublicCookieMetadata()
    ->setDuration(self::COOKIE_PERIOD)
    ->setPath('/')
    ->setSecure($this->request->isSecure())
    ->setHttpOnly(false);
$this->cookieManager->setPublicCookie(self::COOKIE_NAME, $this->generateValue(), $publicCookieMetadata);
```

## Declaring default section data values

Since Hyvä 1.3.6

As long as a visitor has no server-side session, default section data is dispatched. The default section data is not loaded through Ajax but instead rendered in the page source.
This reduces the number of requests to the section data API and thus the server load.
The rationale is that visitors without a session can't have any individual section data, since they have not interacted with the server in a way that updates the server state.
A session is created with the first HTTP POST request.

Some extensions may require section data to always be fully populated.
In such cases, the default value for the required section can be configured in the modules `etc/frontend/di.xml` file.

For example, the following configuration causes the `directory-data` section not to be emptied in the default section data, and, the wishlist section data is set to contain an empty `items` array.

```
<type name="Hyva\Theme\ViewModel\CustomerSectionData">
    <arguments>
        <argument name="defaultSectionDataKeys" xsi:type="array">
            <item name="directory-data" xsi:type="boolean">true</item>
            <item name="wishlist" xsi:type="string">{"items": []}</item>
        </argument>
    </arguments>
</type>
```

All other sections that are not explicitly listed in the configuration will be set to an empty array in the default data.
