# Limiting Future Dates in the Change Date Calendar

Customers can modify upcoming subscription order dates in the Subscription Manager. By default your customers can push out future orders as far as they want, but you can limit how far they can set future order dates with script.js.

Giving subscribers the opportunity to pause or skip their next order is a good retention strategy to help mitigate churn due to overstock, or other circumstances such as a temporary change of address. There's no one size fits all recommendation for this, some merchants limit it down to only a few weeks and encourage customers to skip a shipment instead, while other stores let customers postpone months in order to run out of product.

## Current - smi-templates 25.0.0+

To set a maximum amount of days a customer can select, simply add an attribute to `sm-datepicker` with the number of days as the value. For example, to limit selection to the next 30 days, update your `sm-datepicker` in `reactivate-subscription.liquid` to look like this:\
`<sm-datepicker data-max-date-offset-days="30">`

Similarly, you can set a minimum number of days from today by passing a value for `data-min-date-offset-days`. This will not allow a customer to select a date *before* the supplied number of days:

`<sm-datepicker data-min-date-offset-days="2">`

***

## Subscription Manager 0.33.3 - 0.41.1

### Accessing the Advanced Editor

We'll be using the advanced editor to modify the Subscription Manager. You can access it through your Ordergroove Admin:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to **Subscriptions** on the top toolbar, and select **Subscriptions Manager**
3. Toggle **Advanced** on the top left.

> 🚧 Support
>
> Some aspects of this article require technical expertise with coding languages. This is self-serve and outside of the normal support policy.

***

### The Subscription Manager Calendar

The Subscription Manager uses an HTML5 calendar. HTML5 calendars can make use of min and max dates; these values can be set within the date picker itself. A simple way to do this is hard to code the values to a min and max date.

```html
<input type="date" id="myDate" name="bday" min="2023-07-30" max="2023-10-31" />
```

In this example, the earliest date that a customer would be able to choose would be July 7th, 2023 and the furthest day out a customer could choose would be October 31st, 2023. All other dates within the calendar would be blocked.

This is not an ideal way to set a range of dates. It would take constant upkeep. A better way would be to set the date attributes dynamically. We can do this by utilizing the scripts.js file within the advanced editor.

***

### Using scripts.js to Modify the Calendar

Open up **Scripts** > **scripts.js**. Here we can set two constants for **minDate** and **maxDate** by using [Days.js](https://day.js.org/en/). Day.js is a minimalist JavaScript library that parses, validates, manipulates, and displays dates and times for modern browsers with a largely Moment.js-compatible API.

In the scripts.js file the following code can be added:

```javascript
const maxDate = ((window.og || {}).smi || {}).dayjs().add(120, 'days').format('YYYY-MM-DD');

const minDate = ((window.og || {}).smi || {}).dayjs().add(4, 'days').format('YYYY-MM-DD');
```

This would set a maxDate a customer could change their order to be 120 days from the current date. The minDate in this scenario would set the earliest date a customer could change their order to be 4 days from today’s date.

The next step to complete the date restrictions would be to call them in the date input div that lives in the change-date.liquid file. In this file scroll down to find the following code:

```html
<div class="og-dialog-body">
   <input type="hidden" name="order" value="{{ order.public_id }}" /> 
   <input type="date" name="shipment_date" max="{{ 'maxDate' | js }}" min="{{ 'minDate' | js }}" value="{{ order.place }}" />
</div>
```

Here we have added the min and max attributes to the `<input>` div. We set them equal to the values stored inside **const minDate** and **const maxDate**. The end result will look something like this:

**maxDate**

<Image align="center" width="300px" src="https://files.readme.io/75fdb81-Screen_Shot_2023-06-26_at_16.45.04.png" />

As you can see from the image, the dates circled in red have been grayed out, not allowing the customer to choose any date after October 24th, 2023.

**minDate** - today’s date in light blue

<Image align="center" width="300px" src="https://files.readme.io/d6376ff-Screen_Shot_2023-06-26_at_17.12.31.png" />

Here one can see that the earliest date that is available is June 30th, 2023. Since the minDate is set to: .*dayjs().add(4, 'days')*, the four days, including today’s date, are grayed out, not allowing the customer to change to one of those dates.

Adjusting the number value within the **.add(X, ‘days’)** will set the counter for the min and max. One last note, both the min and the max do not need to be set together. Either can be used independently of one another.

For more information on **Days.js**, take a look at the [Day.js technical documentation](https://day.js.org/en/).