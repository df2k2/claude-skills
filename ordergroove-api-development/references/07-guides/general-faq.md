# General FAQ

<HTMLBlock>
  {`
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "Is Ordergroove a fully API-based platform?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>All subscription integration touchpoints — with the exception of Product catalog updates, which are uploaded in an offline feed via SFTP — are powered by our API.</p><p>The remaining nuance belongs to Subscription Enrollment actions, which are carried out via API calls to the Purchase Post endpoint for customers who choose to host their frontend content, or automatically by the Ordergroove system for customers who tag Ordergroove's javascript.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Should I read the API response status codes exclusively, or rely on the error messages?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>We recommend you build your retry logic based solely on the API status codes (400, 401, 403, etc.). The accompanying error messages are human-readable and subject to change and thus not appropriate for use in error handling. These messages can be logged and used for troubleshooting.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "What value should I set for API timeout intervals?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>The Service Level Agreement for most of our APIs is 1 second, but we recommend a 3-second interval to be safe. Visit the <a href=\"https://og-restrpc.readme.io/reference\">API documentation</a> for more detail about which API responses warrant a retry and which fail permanently.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Why do some of Ordergroove's APIs have an authorization header, whereas others have HMAC auth in the URL parameters or the request body?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>Ordergroove's older suite of APIs (those at api.ordergroove.com, as well as some at sc.ordergroove.com) do not have authorization headers, instead passing in authentication in the body of the request, or via URL parameters in rare instances. Our newer APIs (those at restapi.ordergroove.com, and some at sc.ordergroove.com) have an HMAC auth header.</p>"
        }
      }
    ]
  }
  </script>
  `}
</HTMLBlock>

## Is Ordergroove a fully API-based platform?

All subscription integration touchpoints — with the exception of Product catalog updates, which are uploaded in an offline feed via SFTP — are powered by our API.

The remaining nuance belongs to Subscription Enrollment actions, which are carried out via API calls to the Purchase Post endpoint for customers who choose to host their frontend content, or automatically by the Ordergroove system for customers who tag Ordergroove’s javascript.

***

## Should I read the API response status codes exclusively, or rely on the error messages?

We recommend you build your retry logic based solely on the API status codes (400, 401, 403, etc.). The accompanying error messages are human-readable and subject to change and thus not appropriate for use in error handling. These messages can be logged and used for troubleshooting.

***

## What value should I set for API timeout intervals?

The Service Level Agreement for most of our APIs is 1 second, but we recommend a 3-second interval to be safe. Visit the [API documentation](https://og-restrpc.readme.io/reference) for more detail about which API responses warrant a retry and which fail permanently.

***

## Why do some of Ordergroove’s APIs have an authorization header, whereas others have HMAC auth in the URL parameters or the request body?

Ordergroove’s older suite of APIs (those at api.ordergroove.com, as well as some at sc.ordergroove.com) do not have *authorization* headers, instead of passing in authentication in the body of the request, or via URL parameters in rare instances. Our newer APIs (those at restapi.ordergroove.com, and some at sc.ordergroove.com) have an *HMAC* auth header.