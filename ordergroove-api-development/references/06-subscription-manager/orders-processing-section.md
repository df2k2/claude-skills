# Orders Processing Section

This section controls the grouping of all items that are about to be sent to the customer. Editing this section should be done in Views > orders-processing.liquid.

For an overview of all elements, take a look at [Subscription Manager Components & Containers](https://developer.ordergroove.com/docs/subscription-manager-components-containers).

***

## Main Area

The Main area is divided into 2 parts:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #874efe;"></span>
    <strong>Header</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #4f7a28;"></span>
    <strong>Sent-shipment</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/e377ecc-Screenshot_2023-06-29_at_7.10.06_AM.png" />

```html
{# Upcoming orders entry point #}
 <section id="og-sent-shipments" aria-labelledby="shipments-sent-header">
 {# Iterate over all orders #}
 {% for order in orders | select(status='SEND_NOW') %}
 {# The markup within this if block is displayed for all sent orders #}
 {# If at least one sent order exists, display a sent shipment header #}
{% if index == 0 %}
  <h1 class="og-title" id="shipments-sent-header">{{ 'shipment_sent_processing' | t }}</h1>
<div class="og-sent-shipment-info"></div>
{% endif %}
 {% set current_order_items = order_items | select(order=order.public_id) %}
 {% set payment = payments | find(id=order.payment) %}
 {% set shipping_address = addresses | find(id=order.shipping_address) %}
<div class="og-sent-shipment">
{# Shipment body #}
...
</div>{# /og-sent-shipment #}
{% endfor %}
</section>
```

## Sent Shipment

**Sent Shipment** contains 2 sub areas:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #ffa57d;"></span>
    <strong>shipment-body</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #006d8f;"></span>
    <strong>shipment-footer</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/ceb27dc-Screenshot_2023-06-29_at_7.12.54_AM.png" />

```html
<div class="og-shipment-body">
 {# Iterate over all order items in the order #}
 {% for order_item in current_order_items %}
 {% set product = products | find(id=order_item.product) %}
 {% set subscription = subscriptions | find(id=order_item.subscription) %}
 {# Order item #}
 <div class="og-product" og-item-id="{{ order_item.public_id }}" og-subscription-id="{{ order_item.subscription }}">
 {% if product %}
 <div class="og-product-image-container">
 <img class="og-product-image" loading="lazy" alt="{{ product.name }}" src="{{ product.image_url | if_defined }}" />
 </div>
 <div class="og-name-price-controls-container">
 <div class="og-description-and-controls">
 <div class="og-product-description">
 <h3 class="og-product-name">
 <a href="{{ product.detail_url | if_defined }}">{{ product.name }}</a>
 </h3>
 <h5 class="og-product-display-name">{{ product.display_name }}</h5>
 </div>{# /og-product-description #}
 <div class="og-price">
 {# The markup within this if block is displayed if the final #}
 {# price represents a discount from the original price #}
 {% if order_item.show_original_price %}
 <span class="og-base-unit-price">{{ order_item.price | currency }}</span>
 {% endif %}
 <span class="og-final-unit-price">{{ (order_item.total_price / order_item.quantity) | currency }}</span>
 <span>{{ 'product_price_each' | t }}</span>
 </div>{# /og-price #}
 </div>{# /og-description-and-controls #}
 {# Quantity control #}
 <div class="og-freq-quantity-controls">
 <div class="og-quantity og-wrapper">
 {{ 'item_controls_sending' | t }}
 <span>{{ order_item.quantity }}</span>
 </div>
 </div>{# /og-freq-quantity-controls #}
 </div>{# /og-name-price-controls-container #}
 {% endif %}
 </div>{# /og-product #}
 {% endfor %}
</div>{# /og-shipment-body #}
{# Shipment footer #}
<div class="og-shipment-footer">
 <details class="og-mobile og-mobile-payment-shipping">
 <div class="og-payment-shipping">
 {% include 'billing-shipping-details' %}
 </div>
 <div class="og-total-table-mobile">
 {% include 'order-total' %}
 </div>
 <summary>
 {{ 'billing_total_header' | t }} - {{ order.total | currency }}
 </summary>
 </details>{# /og-mobile-payment-shipping #}
 <div class="og-payment-shipping og-desktop">
 {% include 'billing-shipping-details' %}
 {% include 'order-total' %}
 </div>{# /og-payment-shipping #}
</div>{# /og-shipment-footer #}
```

## Shipment-body

The **Shipment-body** section has 2 sub areas:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #5a1c00;"></span>
    <strong>product image</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #f4a4c0;"></span>
    <strong>name-price controls container</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/ce1ab5a-Screenshot_2023-06-29_at_7.14.09_AM.png" />

```html
<div class="og-product-image-container">
 <img class="og-product-image" loading="lazy" alt="{{ product.name }}" src="{{ product.image_url | if_defined }}" />
</div>
<div class="og-name-price-controls-container">
 <div class="og-description-and-controls">
 <div class="og-product-description">
 <h3 class="og-product-name">
 <a href="{{ product.detail_url | if_defined }}">{{ product.name }}</a>
 </h3>
 <h5 class="og-product-display-name">{{ product.display_name }}</h5>
 </div>{# /og-product-description #}
 <div class="og-price">
 {# The markup within this if block is displayed if the final #}
 {# price represents a discount from the original price #}
 {% if order_item.show_original_price %}
 <span class="og-base-unit-price">{{ order_item.price | currency }}</span>
 {% endif %}
 <span class="og-final-unit-price">{{ (order_item.total_price / order_item.quantity) | currency }}</span>
 <span>{{ 'product_price_each' | t }}</span>
 </div>{# /og-price #}
 </div>{# /og-description-and-controls #}
 {# Quantity control #}
 <div class="og-freq-quantity-controls">
 <div class="og-quantity og-wrapper">
 {{ 'item_controls_sending' | t }}
 <span>{{ order_item.quantity }}</span>
 </div>
 </div>{# /og-freq-quantity-controls #}
</div>{# /og-name-price-controls-container #}
```

***

## Shipment footer

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #ff6a00;"></span>
    <strong>og-billing</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #b1de8c;"></span>
    <strong>og-shipping</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #53d5fd;"></span>
    <strong>og-total-table</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/07b8e7b-Screenshot_2023-06-29_at_7.18.18_AM.png" />

```html
{# Shipment footer #}
<div class="og-shipment-footer">
 <details class="og-mobile og-mobile-payment-shipping">
 <div class="og-payment-shipping
 {% include 'billing-shipping-details' %}
 </div>
 <div class="og-total-table-mobile">
 {% include 'order-total' %}
 </div>
 <summary>
 {{ 'billing_total_header' | t }} - {{ order.total | currency }}
 </summary>
 </details>{# /og-mobile-payment-shipping #}
 <div class="og-payment-shipping og-desktop">
 {% include 'billing-shipping-details' %}
 {% include 'order-total' %}
 </div>{# /og-payment-shipping #}
</div>{# /og-shipment-footer #}
```

## og-billing

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #000000;"></span>
    <strong>footer-header</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #c4bc01;"></span>
    <strong>billing-details-container</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #f4a4c0;"></span>
    <strong>change-billing-button</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/bc30140-Screenshot_2023-06-29_at_7.19.35_AM.png" />

```html
<details class="og-mobile og-mobile-payment-shipping">
 <div class="og-payment-shipping">
 {% include 'billing-shipping-details' %}
 </div>
 <div class="og-total-table-mobile">
 {% include 'order-total' %}
 </div>
 <summary>
 {{ 'billing_total_header' | t }} - {{ order.total | currency }}
 </summary>
</details>{# /og-mobile-payment-shipping #}
```

This section is pulling in the file `billing-shipping-details.liquid` and it will output in place of this snippet `{% include 'billing-shipping-details' %}`

```html
{% if payment %}
 {% set payment_will_be_expired = (payment.orders | find(id=order.public_id)) | get('payment_will_be_expired') %}
 {% set payment_method_names = 'payment_method_names' | t %}
 <div class="og-billing">
 <div class="og-footer-header">
 {{ 'shipment_unsent_footer_billing_header' | t }}
 </div>
 <div class="og-billing-details-container">
 {% if not 'cc_recycling_enabled' | setting %}
 {% if payment.is_expired %}
 <div class="og-payment-is-expired">
 {{ 'payment_is_expired' | t }}
 </div>
 {% elseif payment_will_be_expired %}
 <div class="og-payment-will-be-expired">
 {{ 'payment_will_be_expired' | t }}
 </div>
 {% elseif payment.is_expiring %}
 <div class="og-payment-is-expiring">
 {{ 'payment_is_expiring' | t }}
 </div>
 {% endif %}
 {% endif %}
 <div og-payment-id="{{payment.public_id}}">
 <span class="og-payment-type">{{ payment.cc_type }} {{ payment_method_names[payment.payment_method] }}</span>
 {% if payment.cc_number_ending %}
 <span class="og-payment-last-4">{{ 'form_billing_ending_in' | t }}</span>
 {% endif %}
 </div>
 <div class="og-payment-expiration-date">
 {% if payment.public_id %}
 <span class="og-exp-date">{{ 'form_billing_expiration_date' | t }}</span>
 {% endif %}
 </div>
 </div>{# /og-billing-details-container #}
 {% if 'external_payment_enabled' | setting %}
 <a class="og-link og-edit-payment" href="{{ 'external_payment_url' | setting }}">{{ 'shipment_unsent_footer_billing_edit' | t }}</a>
 {% elseif 'platform' | setting('shopify') == 'shopify' %}
 {% include 'change-billing-shopify-only' %} 
 {% endif %}
 </div>{# /og-billing #}
{% endif %}
```

## og-shipping

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #ffaa00;"></span>
    <strong>footer-header</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #ff4726;"></span>
    <strong>shipping-address-container </strong><br>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/a1afd87-Screenshot_2023-06-29_at_7.21.05_AM.png" />

```html
<div class="og-payment-shipping og-desktop">
 {% include 'billing-shipping-details' %}
</div>{# /og-payment-shipping #}
```

This section is pulling in the file `billing-shipping-details.liquid` and from that file will output the following:

```html
{# Shipping info #}
{% if shipping_address %}
 <div class="og-shipping">
 <div class="og-footer-header">
 {{ 'shipment_unsent_footer_shipping_header' | t }}
 </div>
 <div class="og-shipping-address-container" og-address-id="{{shipping_address.public_id}}">
 <div class="og-address-name">{{ shipping_address.first_name }}
 {{ shipping_address.last_name }}</div>
 <div class="og-address-line-1">{{ shipping_address.address }}</div>
 <div class="og-address-line-2">{{ shipping_address.address2 }}</div>
 <div class="og-address-city-state-zip">
 {{ shipping_address.city }}, {{ shipping_address.state_province_code }}
 {{ shipping_address.zip_postal_code }}
 </div>
 </div>
 {% include 'change-shipment-address' %}
 </div>{# /og-shipping #}
{% endif %}
```

## og-total-table

<HTMLBlock>
  {`
  <p>
    <strong>price grid code is found in order-total.liquid</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #929292;"></span>
    <strong>footer-header</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #d764fe;"></span>
    <strong>og-shipment-discount-total</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #ffaa00;"></span>
    <strong>og-shipment-sub-total</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #AD3E03;"></span>
    <strong>og-shipment-shipping-total</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #76bb41;"></span>
    <strong>og-shipment-total</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; border-radius: 50%; background: #008cb4;"></span>
    <strong>shipment-total-footer</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/455e166-Screenshot_2023-06-29_at_7.22.37_AM.png" />

The order total table is pulled in from the `order-total.liquid` file and it's output will happen in place of `{% include 'order-total' %}`

```html
<div class="og-payment-shipping og-desktop">
 {% include 'order-total' %}
</div>{# /og-payment-shipping #}
```

That output from the `order-total.liquid` file will look like this:

```html
{# Order pricing details #}
<div class="og-total-table">
<div class="og-footer-header og-desktop">{{ 'shipment_sent_price_total' | t }}</div>
<table role="grid" class="og-table">
<tr class="og-pricing-line og-shipment-discount-total">
<th class="og-total-label" scope="row">{{ 'shipment_sent_price_autosave' | t }}</th>
<td class="og-total-value">{{ order.discount_total | currency }}</td>
</tr>
<tr class="og-pricing-line og-shipment-sub-total">
<th class="og-total-label" scope="row">{{ 'shipment_sent_price_subtotal' | t }}</th>
<td class="og-total-value">{{ order.sub_total | currency }}</td>
</tr>
<tr class="og-pricing-line og-shipment-shipping-total">
<th class="og-total-label" scope="row">{{ 'shipment_sent_price_shipping' | t }}</th>
<td class="og-total-value">{{ order.shipping_total | currency }}</td>
</tr>
<tr class="og-pricing-line og-shipment-total">
<th class="og-total-label" scope="row">{{ 'shipment_sent_price_total' | t }}*</th>
<td class="og-total-value">{{ order.total | currency }}</td>
</tr>
</table>
<div class="og-shipment-total-footer">{{ 'total_box_disclaimer' | t }}</div>
</div>{# /og-total-table #}
```