# Authentication

Ordergroove API Authentication is the access control system developers use to authorize requests to Ordergroove's REST APIs over HTTPS. It supports two scopes: Application API Scope, which uses an `x-api-key` header for server-to-server calls (up to 10 keys per merchant, optionally with Bulk Operations permission), and Storefront API Scope, which uses an HMAC-SHA256 signature for client-side calls scoped to a single customer, with optional Trust Level support for recognized-but-not-logged-in users.

***

## API Scope

Ordergroove's APIs support two versions of authentication:

**Application API Scope** - Authentication via an x-api-key header that uses one of 10 keys available for your store. These keys (up to 10 per merchant) should only be used for server-to-server requests and not exposed on the client side.

* Within Application API Scope, some keys may be granted the permission for "Bulk Operations". This means the key will be able to return records across multiple customers when using the List endpoints. Without this permission, the key will only return records within the scope of a single customer.

**Storefront API Scope** - Authentication via a generated signature to call Ordergroove's APIs straight from the client within the context of a single customer. The key itself should not be exposed on the client side.

* Within Storefront API Scope, you can optionally use **Trust Level Authentication** for customers who are in a recognized state but not fully logged into your site. This limits the given signature to a small subset of available actions and requires a different signature generation process.

### Application API Scope

All requests use [HTTP Basic Auth](http://en.wikipedia.org/wiki/Basic_access_authentication) and must be made over [HTTPS](http://en.wikipedia.org/wiki/HTTP_Secure). Calls made over plain HTTP and calls without authentication will fail.

Be sure to keep your keys secure, and only provide Application API keys to users that you trust.

Here is an example built in JavaScript:

```javascript
const url = "https://restapi.ordergroove.com/subscriptions/";

const headers = {
  "x-api-key": "<REPLACE_ME_WITH_APPLICATION_API_KEY>",
};

const queryString = new URLSearchParams({
  customer: "<REPLACE_ME_WITH_CUSTOMER_ID>",
});

// Make the GET request with fetch
fetch(`${url}?${queryString}`, { headers: headers })
  .then((response) => {
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.json();
  })
  .then((data) => {
    console.log(data); // Logs the data received from the API
  })
  .catch((error) => {
    console.error("Error:", error);
  });

```

### Storefront API Scope

All requests use [HTTP Basic Auth](http://en.wikipedia.org/wiki/Basic_access_authentication) and must be made over [HTTPS](http://en.wikipedia.org/wiki/HTTP_Secure). Calls made over plain HTTP and calls without authentication will fail.

Never expose the Storefront API Key itself, but rather use a generated signature to communicate with Ordergroove's APIs from the client.

#### Standard Customer Authentication

For fully authenticated customers, use the following format:

```javascript
// Constants
const MERCHANT_ID = "<REPLACE_ME_WITH_MERCHANT_ID>";
const STOREFRONT_API_KEY = "<REPLACE_ME_WITH_STOREFRONT_API_KEY>";

// This function generates the OG Authorization header for a fully authenticated customer
async function generateOGAuthorization(customerId) {
  const ts = Math.floor(Date.now() / 1000);
  const encoder = new TextEncoder();
  const keyData = encoder.encode(STOREFRONT_API_KEY);
  const messageData = encoder.encode(`${customerId}|${ts}`);

  // Import the key for HMAC-SHA256
  const key = await crypto.subtle.importKey(
    "raw",
    keyData,
    { name: "HMAC", hash: "SHA-256" },
    false,
    ["sign"]
  );

  // Sign the message
  const signature = await crypto.subtle.sign("HMAC", key, messageData);

  // Convert to Base64
  const sig = btoa(String.fromCharCode(...new Uint8Array(signature)));

  return JSON.stringify({
    public_id: MERCHANT_ID,
    sig_field: customerId,
    ts,
    sig,
  });
}
```

#### Using Trust Level (Optional)

If your site can recognize a customer but the customer isn't fully logged in, you can still authenticate limited actions by providing a `trust_level` field in the authorization header.

```json
{  
    "public_id": "merchant_id",
    "ts": "timestamp",
    "sig_field": "customer_id",
    "sig": "HMAC_signature",
    "trust_level": "recognized"
}
```

> **Important:** If you include a `trust_level`, you must update the string used to generate the signature.

#### Signature Generation

Use HMAC-SHA256 to sign a string using your Storefront API private key. The string format depends on whether you're using trust level:

* Without trust level:\
  `customer_id|timestamp`
* With trust level:\
  `customer_id|trust_level|timestamp`

Example in JavaScript:

```javascript
const baseString = `${customerId}|recognized|${timestamp}`; // Include trust_level if used
const key = "<YOUR_PRIVATE_KEY>";
const signature = createHMAC(baseString, key); // HMAC-SHA256, Base64 encoded
```

This signature is valid for **2 hours**.

***

## Key Retrieval and Sample Code

To retrieve the keys for your store as well as view code snippets in additional languages, please visit [https://rc3.ordergroove.com/keys/](https://rc3.ordergroove.com/keys/).