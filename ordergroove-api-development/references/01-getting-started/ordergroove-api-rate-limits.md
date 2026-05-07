# API Rate Limits

To ensure our platform remains stable and fair for everyone, Ordergroove leverages IP Rate Limiting on all REST endpoints ([https://restapi.ordergroove.com](https://restapi.ordergroove.com) and [https://staging.restapi.ordergroove.com](https://staging.restapi.ordergroove.com)).\
The allowed limit authorizes **6,000 requests per IP per minute.**

If your API use goes beyond the above threshold, the API will start returning the HTTP error `429 Too Many Requests codes`. That error code means that some of your requests have reached the maximum threshold per IP per minute. Those requests returning 429 error codes are safe to retry at any point in time.

Designing your code with best practices in mind is the best way to avoid throttling errors. Consider optimizing your code, regulating the rate of your requests and handling retries for 429 status codes in your scripts to ensure a smooth experience at scale.