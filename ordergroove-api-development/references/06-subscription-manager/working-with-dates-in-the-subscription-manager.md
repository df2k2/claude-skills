# Working with dates in the Subscription Manager

The Subscription Manger exposes several helper functions that make it easy to display and calculate dates.

## Formatting dates

In Liquid files, you can use the `date` [filter](https://developer.ordergroove.com/docs/subscription-manager-development-guide#filters-and-pipes) to format a date string (e.g. "2025-02-16") for display.

```liquid
<h1>Subscription Start Date: {{ subscription.start_date | date }}</h1>
```

This will display "Subscription Start Date: February 16, 2025".

If you want to specify how the date can be formatted, you can pass a format string. The `date` filter uses  [dayjs](https://day.js.org/en/) to parse and format dates, so refer to their documentation for the [available formats](https://day.js.org/docs/en/display/format). For example:

```liquid
<p> {{ subscription.start_date | date('YYYY-MM-DD') }} - will display 2025-02-16</p>
<p> {{ subscription.start_date | date('MMM D, YYYY') }} - will display Feb 16, 2025</p>
```

## Computing dates

You can also use the dayjs library in the subscription manager to manipulate date values. By using dayjs, you don't have to do the date computations yourself.

For example, to calculate a date 15 days after the subscription start date, add this function to your script.js:

```javascript
function get15DaysAfterSubscriptionStart(subscription) {
  return typeof dayjs === 'function' ? dayjs(subscription.start_date).add(15, 'day') : null;
}
```

And then display it in a liquid file like so:

```liquid
{% set expiry_date = 'get15DaysAfterSubscriptionStart(subscription)' | js %}
<p>{{ expiry_date | date }}</p>
```

Refer to the [dayjs docs](https://day.js.org/docs/en/manipulate/manipulate) for documentation on the available methods.