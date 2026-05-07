<!-- source: https://docs.hyva.io/hyva-checkout/faq/404-component-not-found.html -->

# Magewire Request 404 Error

## Magewire Ajax Requests Return 404 on Staging Environments

**Problem**: All Magewire Ajax requests to the Magewire controller return a `404` HTTP response on a staging environment, even though the Hyva Checkout components work correctly on the production store.

**Cause**: The reason is most likely conflicting PHP session cookies between the production store and the staging environment, which cause PHP to lose the session during Magewire POST requests.

This conflict happens when the production store uses a bare top-level domain (for example `test.com`) and the staging environment uses a subdomain of that same domain (for example `staging.test.com`). In that setup, two `PHPSESSID` cookies exist: one set by the production store on `test.com` and one set by the staging store on `staging.test.com`.

Because PHP receives both cookies, the session is lost during the Magewire POST requests. The checkout step configuration is no longer present in the PHP session, so the Magewire checkout component is unknown to the server, which results in the `404` error response.

**Solution**: Delete the `PHPSESSID` cookie for the production store (the one without the subdomain) from your browser, then recreate the checkout session on the staging subdomain by reloading the page.

## Preventing the Magewire 404 Error Permanently

To permanently prevent conflicting `PHPSESSID` cookies, choose one of the following approaches:

### Option 1: Use a subdomain for the production store

Change the production store URL to include a subdomain, for example `www.test.com` instead of `test.com`. When both sites use subdomains, their session cookies no longer conflict.

### Option 2: Use a different top-level domain for staging

Configure the staging environment on a completely separate domain (for example `test-staging.com`) so the cookies are isolated by default.

### Option 3: Automatically clean parent-domain cookies

Install the `blackbird/cookie-domain-cleaner` Composer package to remove parent-domain cookies automatically.

Tip

The `blackbird/cookie-domain-cleaner` extension was contributed by the developers at Blackbird Agency. See [github.com/blackbird-agency/cookie-domain-cleaner](https://github.com/blackbird-agency/cookie-domain-cleaner) for installation instructions.
