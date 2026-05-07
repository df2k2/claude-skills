# Inactive Subscriptions Section

This article contains information about the Inactive Subscription Section. The Inactive Subscriptions Section can be found in the **inactive-subscriptions.liquid** file. For an overview of all elements, take a look at [Subscription Manager Components & Containers](https://developer.ordergroove.com/docs/subscription-manager-components-containers).

***

## Overview

The *Inactive Subscriptions Section* can be divided into 2 parts:

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; background: #ff4014; border-radius: 50%;"></span>
    <strong>Header</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; background: #5f2feb; border-radius: 50%;"></span>
    <strong>Products</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/ace7fd8-Screenshot_2023-06-16_at_1.06.54_PM.png" />

## Header

```html
<section id="og-inactive-subscriptions">
    {% for subscription in subscriptions | reject('live') %} {% if index === 0 %}
  </h1>
```

## Products

```html
<div class="og-inactive-subscription">
    {% set product = products | find(id=subscription.product) %} {% if product %}
    <div class="og-product">...</div>{# /og-product #} {% endif %}
  </div>
  {# /og-inactive-subscription #} {% endfor %}
</section>{# /og-inactive-subscriptions #}
```

***

## Individual Products

Each individual product is wrapped with

```html
<div class="og-product">
...
</div>{# /og-product #}
```

And each Product is broken out to

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; background: #76bb40; border-radius: 50%;"></span>
    <strong>Product Image</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; background: #AE8CFE; border-radius: 50%;"></span>
    <strong>Controls Container</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/1984afb-Screenshot_2023-06-16_at_1.17.52_PM.png" />

## Product Image

```html
<div class="og-product-image-container">
  <img class="og-product-image" loading="lazy" alt="{{ product.name }}" src="{{ product.image_url | if_defined }}" />
</div>
```

## Controls Container

```html
  <div class="og-name-price-controls-container">
    <div class="og-description-and-controls">
      <div class="og-product-description">
        <h3 class="og-product-name"><a href="{{ product.detail_url | if_defined }}">{{ product.name }}</a>
        </h3>
      <div class="og-subscription-quantity">{{ 'product_read_only_quantity' | t }}</div>
    </div>
  </div>
  <div class="og-inactive-subscription-actions">
    {% include 'reactivate-subscription' %}
    <div class="og-cancelled-text-date">
      <span class="og-cancelled-text">{{ 'subscription_inactive_cancelled_on' | t }}</span>
      <span class="og-cancelled-date">{{ subscription.cancelled | date }}</span>
    </div>
  </div>{# /og-inactive-subscription-actions #}
```

Within the Controls Container, the Description Controls are broken into **2 parts**

<HTMLBlock>
  {`
  <p>
    <span style="display: inline-block; height: 10px; width: 10px; background: #ffaa5b; border-radius: 50%;"></span>
    <strong>Product Description</strong><br>
    <span style="display: inline-block; height: 10px; width: 10px; background: #575758; border-radius: 50%;"></span>
    <strong>Reactivate Subscription</strong>
  </p>
  `}
</HTMLBlock>

<Image align="center" src="https://files.readme.io/fb83ddc-Screenshot_2023-06-16_at_1.24.16_PM.png" />

## Product Description - name & quantity

```html
  <div class="og-description-and-controls">
    <div class="og-product-description">
      <h3 class="og-product-name">
        <a href="{{ product.detail_url | if_defined }}">{{ product.name }}</a>
      </h3>
      <div class="og-subscription-quantity">{{ 'product_read_only_quantity' | t }}</div>
    </div>
  </div>
```

## Reactivate Subscription

```html
  <div class="og-inactive-subscription-actions">
    {% include 'reactivate-subscription' %}
    <div class="og-cancelled-text-date">
      <span class="og-cancelled-text">{{ 'subscription_inactive_cancelled_on' | t }}</span>
      <span class="og-cancelled-date">{{ subscription.cancelled | date }}</span>
    </div>
  </div>{# /og-inactive-subscription-actions #}
```

## Reactivate Subscription Modal

<Image align="center" src="https://files.readme.io/38594ff-Screenshot_2023-07-06_at_7.58.33_AM.png" />

The code for this modal is found in the reactivate-subscription.liquid file

```html
<div class="og-reactivate-subscription-button">
<button
class="og-button"
type="button"
@click={{ 'show_closest_modal' | js }}
>
{{ 'subscription_reactivate_button' | t }}
</button>

<dialog aria-hidden="true">
<form 
action="{{ 'reactivate_subscription' | action }}" 
name="og_subscription_reactivate"
@success={{ 'close_closest_modal' | js }}
@reset={{ 'close_closest_modal' | js }}
>
<div class="og-dialog-header">
<h5 class="og-dialog-title">{{ 'modal_subscription_reactivate_header' | t }}</h5>
<button type="reset" aria-label="{{ 'modal_close' | t }}" class="og-button og-button-close">{{ 'modal_close' | t }}</button>
</div>{# /og-dialog-header #}

<div class="og-dialog-body">
{{ 'modal_subscription_reactivate_body' | t }}
</div>{# /og-dialog-body #}

<div class="og-dialog-footer">
<input type="hidden" name="subscription" value="{{ subscription.public_id }}"/>
<input type="hidden" name="every" value="{{ subscription.every }}"/>
<input type="hidden" name="every_period" value="{{ subscription.every_period }}"/>
<button name="reactivate_subscription" type="submit" class="og-button">
{{ 'modal_reactivate_save' | t }}
</button>
</div>{# /og-dialog-footer #}

</form>
</dialog>
</div>{# /og-reactivate-subscription-button #}
```