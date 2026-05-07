# Start Here

The Ordergroove REST API is a resource-oriented JSON API that lets developers programmatically manage subscription commerce data — customers, subscriptions, items, and orders. It uses standard HTTP verbs and status codes, supports API key or HMAC authentication, and runs on environment-specific base URLs (`restapi.ordergroove.com` for production, `staging.restapi.ordergroove.com` for staging), with separate subdomains for subscription creation and legacy endpoints.

***

## Base URL

API requests use different base URLs depending on the endpoint and environment:

* Production: `https://restapi.ordergroove.com`
* Staging: `https://staging.restapi.ordergroove.com`

Unless otherwise specified in the documentation, all endpoints use the `restapi` subdomain. Note that these APIs are rate limited—see the [Rate Limits](https://og-restrpc.readme.io/reference/ordergroove-api-rate-limits) page for details.

***

## Data Structure

Subscriptions in Ordergroove are tied to items, not orders:

<Image align="center" width="60% " src="https://files.readme.io/cbb5f6bf0d5ba5ef83268c652921c7950d43ca729993168af1de1a0ec29a3cf0-Ordergroove_Data_Model.png" />

### Core Data Objects

Our data model centers on four core objects: Customer, Subscription, Item, and Order. This diagram illustrates how subscriptions generate items and orders over time. Note that Ordergroove only creates the next upcoming order, subsequent orders are created as necessary.

For complete details, see [Data Model at a Glance](https://developer.ordergroove.com/docs/data-model-at-a-glance).

<Image align="center" src="https://files.readme.io/f91acca4f3276e26999d036e1174db3f973c88740180b179110c9ea22cc1e9c3-image2.png" />

***

## Response Codes

The Ordergroove API returns JSON responses. All responses include standard HTTP status codes. Codes in the 2xx range indicate success, while codes in the 4xx and 5xx range indicate client errors.

```
200 OK - Request succeeded
201 Created - Resource created successfully
204 No Content - Request succeeded with no response body
400 Bad Request - Invalid request parameters
401 Unauthorized - Invalid or missing API key
403 Access Denied - Insufficient permissions
404 Not Found - Resource not found
423 Resource is currently in use. Please try again shortly. - Happens when concurrent requests are made that attempt to perform operation on the same resource
429 Too Many Requests - Rate limit exceeded
500 Internal Server Error
502 Bad Gateway
503 Service Unavailable
```

***

## Additional URLS

### Subscription Creation URL

Some endpoints for subscription creation use alternate base URLs:

Subscription Creation API

* Production: `https://sc.ordergroove.com`
* Staging: `https://staging.sc.ordergroove.com`

### Legacy URL

If you're currently using the legacy API at `https://api.ordergroove.com`, please note that these URLs are not interchangeable with the current API. We recommend upgrading your integration to use the endpoints documented here.