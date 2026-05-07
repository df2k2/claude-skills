# Orders Unsent Section

This article contains information about the Orders Unsent Section in the Subscription Manager. For an overview of all elements, take a look at [Subscription Manager Components & Containers.](https://developer.ordergroove.com/docs/subscription-manager-components-containers)

***

The **order-unsent.liquid** file can be broken down into three sections:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #000000;"></span>
    <strong>Header </strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #919191;"></span>
    <strong>Body </strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #942192;"></span>
    <strong>Footer </strong></a>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/42bd126-Screen_Shot_2023-06-16_at_09.41.48.png" />

***

## Header

In this section:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #000000;"></span>
    <strong>Next Order Date</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #96D35F;"></span>
    <strong>Order Action Buttons</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/f253127-Screen_Shot_2023-06-15_at_18.52.21.png" />

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #000000;"></span>
    <strong>Next Order Date</strong>
  </p>
  `}
</HTMLBlock>

It can be found here:

```html
<div class="og-shipment-info">
	<span class="og-shipment-on og-desktop">{{ 'shipment_unsent_header' | t }}</span>
	{{ order.place | date }}

	<div class="og-mobile">
		{% include 'change-date' %}
	</div>
</div>
```

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #96D35F;"></span>
    <strong>Order Action Buttons</strong>
  </p>
  `}
</HTMLBlock>

The order action buttons in the header can be found in this part of the code

```html
{# Shipment controls #}
	<div class="og-shipment-header-controls og-desktop">
		{% include 'change-date' %}
		{% include 'send-now' %}
		{% include 'skip' %}
	</div>
```

Furthermore, each button has its own liquid file.

* Change Date - \{% include 'change-date' %} -> **change-date.liquid**
* Send Now - \{% include 'send-now' %} -> **send-now\.liquid**
* Skip - \{% include 'skip' %} -> **skip.liquid**

***

## Body

Like the header, this section is broken down into following smaller sub sections.

<HTMLBlock>
  {`
  <h4 id="h_01HHNG2TQFZCB47RRS9HJPZWVR">
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #008CB4;"></span>
    <strong>OG Product</strong>
  </h4>
  `}
</HTMLBlock>

This section contains

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #0056D6;"></span>
    <a style="color: #000000;" href="#h_01H32FC2615GS7Z88DPQ7DCJ9Z" target="_self"><strong>Product Image Container</strong></a><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #FFAA01;"></span>
    <a style="color: #000000;" href="#h_01H32FCBHC1CB2PM84VZRGT8C3" target="_self"><strong>Product Name and Price Container</strong></a><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #D9EB37;"></span>
    <a style="color: #000000;" href="#h_01H32FCNG4N38K3Y9HGSF9XEZE" target="_self"><strong>Product and Controls</strong></a><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #371A94;"></span>
    <a style="color: #000000;" href="#h_01H32FCZB9HT08D69W1FTV2ZKX" target="_self"><strong>Product Description</strong></a><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #9929BD;"></span>
    <a style="color: #000000;" href="#h_01H32FD8SDC4G43PMP865PPKK4" target="_self"><strong>Frequency and Quantity Controls</strong></a><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #B92D5D;"></span>
    <a style="color: #000000;" href="#h_01H32FDJJVSY9QPEXXJTM1HCWV" target="_self"><strong>Remove Action Controls</strong></a><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #FF6151;"></span>
    <a style="color: #000000;" href="#h_01H32FDW77AMC6DFA12T5G537V" target="_self"><strong>Price</strong></a>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/8c54b8b-Screen_Shot_2023-06-15_at_18.58.31.png" />

The section can be found here:

```html
<div class="og-product" og-item-id="{{ order_item.public_id }}" og-subscription-id="{{ order_item.subscription }}">
```

<HTMLBlock>
  {`
  <h4 id="h_01H32FC2615GS7Z88DPQ7DCJ9Z">
    <span style="color: #0056d6; font-size: 24px;">• </span><strong>Product Image Container</strong>
  </h4>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/53ebce4-Screen_Shot_2023-06-16_at_09.25.31.png" />

This section holds the product image and can be found here

```html
<div class="og-product-image-container">
	<img class="og-product-image" loading="lazy" alt="{{ product.name }}" src="{{ product.image_url | if_defined }}" />
</div>
```

<HTMLBlock>
  {`
  <h4 id="h_01H32FCBHC1CB2PM84VZRGT8C3">
    <span style="color: #ffaa01; font-size: 24px;">• </span><strong>Product Name and Price Container</strong>
  </h4>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/8959b35-Screen_Shot_2023-06-16_at_09.25.31.png" />

The section can be found here:

```html
<div class="og-name-price-controls-container">
```

<HTMLBlock>
  {`
  <h4 id="h_01H32FCNG4N38K3Y9HGSF9XEZE">
    <span style="color: #d9eb37; font-size: 24px;">• </span><strong>Product and Controls</strong>
  </h4>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/85113c4-Screen_Shot_2023-06-16_at_09.25.31.png" />

```html
<div class="og-description-and-controls">
```

<HTMLBlock>
  {`
  <h4 id="h_01H32FCZB9HT08D69W1FTV2ZKX">
    <span style="color: #371a94; font-size: 24px;">• </span><strong>Product Description</strong>
  </h4>
  `}
</HTMLBlock>

This section contains:

* Product Name
* SKU Swap
* Item Price For Mobile

<Image align="center" src="https://files.readme.io/aba116c-Screen_Shot_2023-06-16_at_09.25.31.png" />

The section can be found here:

```html
<div class="og-product-description" ?data-prepaid="{{ is_prepaid }}">
	<h3 class="og-product-name">
		<a href="{{ product.detail_url | if_defined }}">{{ product.name }}</a>
	</h3>
	<h4 class="og-product-display-name">{{ product.display_name }}</h4>
	{% if subscription %}
		{# Change product control #}
		{% include 'change-product' %}
	{% endif %}
	<div class="og-mobile">
		{% include 'order-item-price' %}
	</div>
</div>
```

<HTMLBlock>
  {`
  <h4 id="h_01H32FD8SDC4G43PMP865PPKK4">
    <span style="color: #9929bd; font-size: 24px;">• </span><strong>Frequency and Quantity Controls</strong>
  </h4>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/17a992e-Screen_Shot_2023-06-16_at_09.25.31.png" />

The section can be found here:

```html
<div class="og-freq-quantity-controls">
	{% if subscription %}
	{# Quantity control #}
		{% include 'change-quantity'%}

	{# Frequency control #}
	<div class="og-freq">
		<span>{{ 'item_controls_every' | t }}</span>
		{% include 'change-subscription-frequency' %}
	</div>
{% else %}
	<div class="og-freq-quantity-controls">
		{# Quantity control #}
		{% include 'change-quantity'%}
		{# One Time Frequency Display #}
		<div class="og-freq">
			<span>{{ 'one_time_notice' | t }}</span>
		</div>
	</div>
{% endif %}
</div>{# /og-freq-quantity-controls #}
```

<HTMLBlock>
  {`
  <h4 id="h_01H32FDJJVSY9QPEXXJTM1HCWV">
    <span style="color: #b92d5d; font-size: 24px;">• </span><strong>Remove Action Controls</strong>
  </h4>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/ea772ca-Screen_Shot_2023-06-16_at_09.25.31.png" />

The section can be found here:

```html
<div class="og-item-remove-actions">

{# If the order item has a subscription, display subscription controls #}
{% if subscription %}
{# Cancel subscription control #}
{% include 'cancel-subscription' %}

{# Pause subscription control #}
{% include 'pause-subscription' %}
{% endif %}

{# If the order item is one time or belongs to an order with more than one order item, display delete item control #}
{% if current_order_items.length > 1 or not subscription %}
{% include 'delete-item' %}
{% endif %}

</div>
```

Furthermore, cancel subscription, pause subscription, and remove item each have their own liquid file.

* Cancel Subscription -  \{% include 'cancel-subscription' %} -> **cancel-subscription.liquid**
* Pause Subscription - \{% include 'pause-subscription' %} -> **pause-subscription.liquid**
* Remove Item - \{% include 'delete-item' %} -> **delete-item.liquid**\\

<HTMLBlock>
  {`
  <h4 id="h_01H32FDW77AMC6DFA12T5G537V">
    <span style="color: #ff6151; font-size: 24px;">• </span><strong>Price</strong>
  </h4>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/fc427d5-Screen_Shot_2023-06-16_at_09.25.31.png" />

The section can be found here:

```html
<div class="og-desktop">
	{% include 'order-item-price' %}
</div>
```

**Note**: This is for desktop only.

***

## Footer

This section contains:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #52D5FD;"></span>
    <strong>Billing and Shipping</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #874EFE;"></span>
    <strong>Order Price Summary</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/10ceb55-Screen_Shot_2023-06-15_at_16.21.34.png" />

The code can be found here:

```html
<div class="og-shipment-footer">
<details class="og-mobile og-mobile-payment-shipping">

<div class="og-payment-shipping">
{% include 'billing-shipping-details' %}
</div>
<div class="og-total-table-mobile">
{% include 'order-total' %}
</div>
<summary>
<div>
{{ 'billing_total_header' | t }} - {{ order.total | currency }}
</div>
</summary>
</details>{# /og-mobile-payment-shipping #}
<div class="og-payment-shipping og-desktop">

{% include 'billing-shipping-details' %}
{% include 'order-total' %}

</div>{# /og-payment-shipping #}
</div>{# /og-shipment-footer #}
```

* Billing and Shipping - \{% include 'billing-shipping-details' %} -> **billing-shipping-details.liquid**
* Order Price Summary - \{% include 'order-total' %} -> **order-total.liquid**