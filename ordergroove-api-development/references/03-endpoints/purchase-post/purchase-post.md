# Purchase POST

This composite endpoint facilitates the creation of subscriptions, addresses, payments and customers with a single POST.

* Can be used with, without and at the same time as OrderGroove's cart tracking system.
* POST must be made to OrderGroove with every purchase/checkout regardless of whether or not a subscription is to be created.
* If subscription information is being sent, Payment becomes a required object in the payload. If a subscription is not being created with the transaction you may omit the payment object.

The `customer`, `address`, and `payment` information given will be matched to existing customer records, so there should be no concerns around duplicating customer information on repeat requests. Some fields listed\
as optional here can actually be required working with your OrderGroove specialist(s).

### URL

Because this endpoint handles payment information, it uses a *different* host: `https://sc.ordergroove.com`.

### Authentication

<Callout icon="🔐" theme="default">
  ### Authentication

  ✔️ Application API Scope

  ✔️ Storefront API Scope
</Callout>

### Request Body

This POST body is different from all the other post bodies. It's not a simple JSON object, but an HTTP Form body where the only field sent is called `create_request` and its value is a JSON string of the object. **The JSON string should also be URL-encoded to avoid issues with special characters.**

For example:

In javascript, you can do using the [request](https://www.npmjs.com/package/request) http client:

```javascript
import request from 'request';

const payload = {
  merchant_id: 'test merchant',
  session_id: 'session identifier',
  merchant_order_id: 'order ID associated with the purchase'
  // ...etc...
};

// the payload must also be url encoded.
const json = encodeURIComponent(JSON.stringify(payload));

request({
  url: 'https://sc.ordergroove.com/subscription/create/',
  body: `create_request=${json}`
});
```

> 📘 URL Encoded Request Body
>
> Pay attention for the fact that the request body must always be URL encoded prior to any Purchase POST Request, otherwise you may have unexpected behavior due to incorrect data deserialization on OrderGrooves end. You can read more about URL Encoding [here](https://www.w3schools.com/tags/ref_urlencode.ASP)

```javascript
create_request={
  "merchant_id": "test merchant",
  "session_id": "session identifier",
  "merchant_order_id": "order ID associated with the purchase",
  ...etc...
}
```

> 📘 Request content-type
>
> Note that even though the body is a form body, the `content-type` for your request should still be`application/json`

### Asynchronous

Our standard integration processes Purchase Post requests asynchronously.  Some of the data provided will however be validated before the response.

If there are no errors, the response will contain an object with a field called `subs_req_id`. The value of this field can be used to retrieve the result of this operation later using the endpoint named Purchase POST Status.

If there are any errors, they will be found in the `errors` object of the response. Some examples:

```json
400 - no records will be created
{"error": "Invalid Merchant MERCHANT_PUBLIC_ID"}
{"error": "Merchant ID must be a string"}
{"error_message": "Merchant order id cannot be null"}
{"error_message": "Session id cannot be null"}
{"error_message": "Session ID must be a string"}
{"error_message": "Missing payment data to create record"}
{"error_message": "The credit card encryption is not valid"}
{"error_message": "Expiration date is not valid, received: "}
{"error_message": "Paymetric tokenization error"}
```

### Synchronous Response Body

This workflow has been deprecated please contact your solutions specialist if you are or would like to use synchronous processing.