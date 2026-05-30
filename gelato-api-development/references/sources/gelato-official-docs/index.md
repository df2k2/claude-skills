<!-- Source: https://dashboard.gelato.com/docs/
     Retrieved: 2026-05-30 (live, latest) -->

# Overview

# Overview

## Introduction

The Gelato API is organized around [REST](http://en.wikipedia.org/wiki/Representational_State_Transfer). Our API has predictable, resource-oriented URLs, and uses HTTP response codes to indicate API errors. We use built-in HTTP features, like HTTP authentication and HTTP verbs, which are understood by off-the-shelf HTTP clients. [JSON](http://www.json.org/) is returned by all API responses, including errors.

Base URL: [https://order.gelatoapis.com](https://order.gelatoapis.com)

If you have any questions or need help a great place to start is the [help center](https://support.gelato.com/en/).

## Authentication

Before you can use the Gelato API you will need to generate an API key via our API Portal. Read more [here](https://support.gelato.com/en/articles/8996574-how-do-i-add-remove-deactivate-or-replace-an-api-key).

You authenticate your account by including your secret key in all API requests. Your API key carries privileges to create and manage your orders, so **be sure to keep them secure!** Do not share your secret API keys in publicly accessible areas such as GitHub, client-side code, and so forth.

To use your API key, you need to provide it in an `X-API-KEY` header with each call.

All API requests must be made over [HTTPS](http://en.wikipedia.org/wiki/HTTP_Secure). Calls made over plain HTTP will fail. API requests without a valid API key will also fail.

## Errors

The Gelato API uses conventional HTTP response codes to indicate the success or failure of an API request. In general: Codes in the 2xx range indicate success. Codes in the 4xx range indicate an structural or data error in the request (e.g., a required parameter was omitted, shipment prices are not found, etc.). Codes in the 5xx range indicate an error with Gelato's API servers (these are rare).

> | Error Code | Meaning |
> | --- | --- |
> | 200 | OK -- Everything worked as expected. |
> | 400 | Bad Request -- The request was unacceptable, often due to missing a required parameter. |
> | 401 | Unauthorized -- No valid API key provided. |
> | 404 | Not Found -- The requested resource doesn't exist. |
> | 429 | Too Many Requests -- Too many requests hit the API too quickly. We recommend an exponential backoff of your requests. |
> | 500 | Internal Server Error -- We had a problem with our server. Try again later. |
> | 502, 503, 504 | Server Errors -- Something went wrong on Gelato's API end. (These are rare.). |
