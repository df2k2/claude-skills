# Objects

## What is an object?

Every Subscription Manager template has access to objects. These objects represent the data that is stored in Ordergroove. For example, the customer's upcoming orders, subscriptions, addresses, etc. You can find a full list of all available objects in the <a href="object-reference">Object Reference</a>

***

## Scoped objects vs global objects

Please note that all objects listed in the <a href="object-reference">Object Reference</a> are global objects and can be referenced and used within any template file.

If you use `{% set my_variable = "foo" %}` syntax to create your own variable, then that variable will be made available to all template code that comes after this declaration, including other included templates.

Using `{% for item in items %}` syntax will create the `item` variable and make it only available within the loop and until the code reaches a matching `{% endfor %}` block.\ <br />

***

## What can you do with objects?

An object is a powerful concept that is leveraged to control the layout and functionality of the Subscription Manager. You can leverage objects to customize existing functionality or even add support for your own very custom business rules. We have provided some hypothetical examples below to help you get started.\ <br />

> 📘 Please Note
>
> Examples below are provided for demonstration purposes only. You may need to modify this code further to make it work with your specific configuration.

***

## Sample: Improve subscription reactivation rates

Let's say that you're noticing that a specific product in your catalog has a high rate of subscription cancellations. One thing that you can do is improve the reactivation rate for certain products by offering an additional promotion on this product. This will help you with new subscribers but how do you target existing subscribers who have already canceled? You can utilize the **product object** to display additional messaging to customers, enticing them to reactivate their subscription to B6 Vitamins.

```less reactivate-subscription.liquid
{% set product = product_by_id[subscription.product] %}
{% if product.name == "B6 Vitamin" %}
<h1>Reactivate {{ product.name }} today and receive an extra discount on recurring orders!</h1>
{% endif %}
```

***

## Sample: Hide and show controls

One of the most frequent customizations which we often see is the need to hide or show controls depending on certain criteria. For example, let's say that you wanted to prevent gaming on discounts on lower-margin items. One way that you can accomplish this is by removing the customer's ability to cancel their subscription via the Subscription Manager for subscription items under a certain dollar amount and prompting them to call in to cancel the item instead.

> ❗️ Compliance with Click-to-Cancel
>
> The [FTC’s Click-to-Cancel rule](https://www.ftc.gov/news-events/news/press-releases/2024/10/federal-trade-commission-announces-final-click-cancel-rule-making-it-easier-consumers-end-recurring) requires businesses to provide a simple and immediate way for consumers to cancel recurring subscriptions and stop charges.
>
> Before hiding or disabling the cancellation option in the Subscription Manager, consult your legal counsel to ensure compliance. Doing so may violate FTC regulations.

```less cancel-subscription.liquid
{% for order_item in order_items %}
{% if order_item.total_price >= 10  %}
	<a>{{ 'cancel_subscription_button' | t }}</a>
{% else %}
  <p>
  We're sorry but you cannot cancel this subscription via our website.<br/>
  Please contact our support at 555-555-5555
  </p>
{% endif %}
```

***

## Sample: Content and styling based on website locale

The Subscription Manager comes out of the box with text that will be automatically changed depending on the locale of the website. However, sometimes you may want to show additional content or style your Subscription Manager differently depending on where the user is currently located. This can be achieved by using the global `locale` key. In the example below, we are going to be forcing our button to appear red when the site is being viewed with a locale targeting Chinese customers.

```less send-now.liquid
<button class="btn btn-primary {{ "red" if locale == "zh-cn" }}" type="button">
{{ 'shipment_send_now_button' | t }}
</button>
```

Now all you would have to do is add a CSS class `red` to your styles and the button will magically appear red only for customers who happen to be viewing your site with this locale.