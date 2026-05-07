# Customizing calendars and dates in v25

Ordergroove uses the cally and dayjs libraries to provide an optimized experience for users changing and selecting dates. This guide will give more information about how to customize the functionality of calendars and dates in v25.

***

## Requirements

* This article is intended for developers on v25 templates.
* You should already have a thorough understanding of the fundamentals of HTML, CSS, and Javascript.

### How to tell what version you're on

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/cfe070f0266bd0482a7177855e224ac3dd4c4c13d241b9b1c260bcb9dc30de24-image1.png" />

***

## Customizing the Datepicker

Ordergroove’s datepicker is used to change the date of an order or to change the starting date of a renewed subscription. If you want to change the datepicker, the template code can be found in `ui-elements/datepicker-popover.liquid`, which is wrapped in the custom element `sm-datepicker` with JavaScript in `script.js` to add save and close functionality that feels natural to the user.

The datepicker uses the [library cally](https://wicky.nillia.ms/cally/) for functionality and styling, with additional styles being added in `datepicker.less`.

If you want to customize the appearance of the datepicker, you can refer to [cally’s theming guide](https://wicky.nillia.ms/cally/guides/theming/) for help.

***

## Customizing Date Displays

Anywhere the Subscription Manager shows a date, Ordergroove is using dayjs to format it. The [dayjs formatting guide will](https://day.js.org/docs/en/display/format) be helpful if you want to change how a date is being displayed.

In the templates from the `views` folder, dates are formatted with the `date` filter, which takes in a dayjs formatting string. For example, the code `{{ next_order_date | date('L') }}` displays the next order date variable with the shorthand localized locale.

Ordergroove’s backend makes [dayjs](https://day.js.org/en/) available through `window.og.smi.dayjs` on the page where the Subscription Manager is loaded, and this is used in the `script.js` file to format dates in JavaScript. For example, `dayjs(order.place).add(increment, unit)` parses the string `order.place` into a date and then adds a specified timeframe (for example, 10 days) to the date.

## Limiting Dates

To limit the amount of days a customer can select, please follow this guide: [https://developer.ordergroove.com/docs/limiting-future-dates-in-the-change-date-calendar](https://developer.ordergroove.com/docs/limiting-future-dates-in-the-change-date-calendar)