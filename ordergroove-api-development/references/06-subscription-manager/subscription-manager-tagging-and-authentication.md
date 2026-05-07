# Subscription Manager Tagging and Authentication

## Subscription Page Tagging

The Subscription Manager is where a customer can interact with their subscriptions. In order for this interface to exist, please create a new page under your site's My Account section to hold the Subscription Manager content. This URL should redirect to the login page if the user is not logged in. Please provide the relative path of this page in the Ordergroove Subscription Settings.

> 📘 Subscription Manager vs MSI
>
> Please note that in the code examples the Subscription Manager is written as MSI which is our legacy name. When writing this code, MSI is the correct method.

Please add the following div to the page

```html
<div id="og-msi" ng-jq=""></div>
```

Please add the following JS tag

Front-end Statatic Domains:\
Staging: [https://staging.static.ordergroove.com](https://staging.static.ordergroove.com)\
Production: [https://static.ordergroove.com](https://static.ordergroove.com)

```javascript
<script type="text/javascript" src="<STATIC_DOMAIN>/<MERCHANT_ID>/msi.js"></script>
```

***

## Authentication Page

You'll need to create an authentication page for Ordergroove to retrieve a cookie containing elements to validate that a user is logged into your site securely. **This page should not require logging in to view it and must be HTTPS**.

Please provide the relative path of this page in the Ordergroove Subscription Settings.

**Cookie and Signature Creation**

When the authentication page loads, you should create a signature and set it as a "secure" cookie and not HTTP only. Please refer to the [HMAC instructions](https://developer.ordergroove.com/docs/hmac-and-aes-authentication) from the Authentication and Encryption article.

* Only set the og\_auth cookie if the user is logged in and set it to a 2-hour expiry. If the user is not logged in, the auth page should still load but no cookie should be set. Please delete this cookie whenever the user logs out to ensure that access to the customer's subscription has been terminated when the user's session ends.
* Do not URL encode this cookie
* The merchant\_user\_id in the cookie should be the value you use to identify the customer in your system
* Seconds since epoch should not include milliseconds. This will be a 10-digit number

The cookie contents will have the following format:

```Text Cookie
<MERCHANT_USER_ID>|<SECONDS_SINCE_EPOCH>|<SIGNATURE>
```

***

## Steps for Ordergroove to load the Subscription Manager

1. The browser loads Subscription Manager by visiting the Subscription Manager URL. **It must be HTTPS**.
2. Merchant's server returns the Subscription Manager page with Ordergroove javascript and **if the user is logged in**.
3. Ordergroove's javascript, on the Subscription Manager browser page, loads a hidden iframe to the merchant's authentication page. **The authentication page must be HTTPS and on the same root domain as the Subscription Manager page**.
4. On authentication page load, the merchant creates a signature with the user\_id and timestamp as specified in the [Authentication and Encryption](https://developer.ordergroove.com/docs/hmac-and-aes-authentication) article. The merchant sets the signature, the user\_id and the timestamp as a "secure" cookie, but not an "HTTP only" cookie. **The path of the cookie should be "/"**.
5. The Subscription Manager browser page retrieves the signature from the secure cookie and uses it to make API calls
6. The Ordergroove server returns the appropriate response if the signature matches and the timestamp is within the last 2 hours.

<Image align="center" src="https://files.readme.io/fe65c24-Screen_Shot_2023-06-22_at_12.24.14_PM.png" />