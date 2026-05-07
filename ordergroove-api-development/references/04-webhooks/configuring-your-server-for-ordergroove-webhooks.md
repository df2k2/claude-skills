# Configuring Your Server for Ordergroove Webhooks

After successfully creating a webhook route, requests will begin to be sent to the configured target. Below, we provide comprehensive details on the structure and behavior of these webhook requests being delivered from Ordergroove. A thorough understanding of these aspects is critical for appropriately configuring your servers to effectively receive, interpret, and process these requests, while also ensuring their secure handling.

### Protocol

HTTPS is used for all webhook requests, ensuring secure transmission of data.

### HTTP verb

POST.

### Payload

The JSON payload's content will depend on user configuration.

### Headers

Each request includes a custom header, Ordergroove-Signature, to verify that the request is authentically from Ordergroove.

### Retry policy

If a webhook request fails to deliver, it triggers a retry policy. This includes retries in response to specific server response codes, like 5xx errors, at increasing intervals (e.g., 1 minute, 3 minutes, 10 minutes), up to a maximum of 5 attempts.

### Duplicates requests

Duplicate requests may occur due to network retries or system errors. While measures are in place to minimize this, clients should implement logic to handle potential duplicates.

### Ordering of requests with respect to original events

Due to network latencies and varying processing times, Ordergroove cannot guarantee the sequential order of webhook delivery in 100% of the cases. Clients should design their systems to accommodate the potential non-sequential arrival of webhook events.

### Timeout Policy

Webhook requests have a timeout policy, timing out if no response is received within 5 seconds. Subsequent retries may occur as per our retry policy. Clients should be prepared for possible multiple deliveries of the same event due to timeouts and retries.