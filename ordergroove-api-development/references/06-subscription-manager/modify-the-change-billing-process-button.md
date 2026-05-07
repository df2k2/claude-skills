# Modify the Change Billing Process Button

Customers on Shopify have to click a button to trigger a Change Billing Information email. Shopify emails them a secure link that directs the customer to a checkout-like page where they can update their credit card information.

In this article, we discuss updating the Subscription Manager so that your style changes affect the Change Billing Process button and keep your brand consistent.

***

## Styling issue

The *Change Billing Process* button used to sit right below, outside, the Subscription Manager. This meant that it could not be styled alongside the Subscription Manager and would be confusing for customers trying to update their payment methods.

As of June 2023, we have moved this button into the Subscription Manager directly. There will now be a Change Billing link located under the Billing section by order.

<Image align="center" width="400px" src="https://files.readme.io/6319176-image1.png" />

This link will open up a modal titled *Replace Payment Method*. A customer will be able to see all subscriptions associated with that payment method. They can then opt to update that payment method by clicking the *Send Email* button.

Shopify will then send the customer an email with next steps.

<Image align="center" width="600px" src="https://files.readme.io/d7776e4-image2.png" />

If your Subscription Manager uses a legacy theme version, please follow the instructions below to switch to the latest experience.

***

## Update your Subscription Manager with the Advanced Editor

Log into [Ordergroove](https://rc3.ordergroove.com/) and go to Subscriptions > [Subscription Manager](https://rc3.ordergroove.com/subscriptions/manager).

Click the ‘Advanced’ tab on the left side of the screen. Our new advanced editor allows you to modify the files which make up the Subscription Manager. CSS styles, Liquid HTML templates, locale files, and even custom scripts.

### 1. /views/billing-shipping-details.liquid

Scroll down the left-hand side to find the **billing-shipping-details.liquid** file under the **Views** folder.

Find and delete the following lines of code:

```liquid
{% if 'external_payment_enabled' | setting %}
	<a class="og-link og-edit-payment" href="{{ 'external_payment_url' | setting }}">{{ 'shipment_unsent_footer_billing_edit' | t }}</a>
{% endif %}
```

And replace it with the code below:

```liquid
{% include 'change-billing-shopify-only' %}
```

### 2. /views/change-billing-shopify-only.liquid

Create a new view file and name it **change-billing-shopify-only.liquid**.

Copy and paste the below code to this new file and click **Save**.

```liquid
{# This modal and button are only used for merchants on the Shopify integration. #}

<div class="og-change-billing-button">

<a class='og-link' @click={{ 'show_closest_modal' | js }}>
{{ 'shipment_unsent_footer_billing_edit' | t }}
</a>

<dialog aria-hidden="true">
<form
action="{{ 'send_payment_email' | action }}"
@success={{ 'close_closest_modal' | js }}
@reset={{ 'close_closest_modal' | js }}>
<div class="og-dialog-header">
<span class="og-dialog-title-big">{{ 'modal_billing_header' | t }}</span>
<button
class="og-button og-button-close"
type="reset"
aria-label="{{ 'modal_close' | t }}">{{ 'modal_close' | t }}</button>
</div>{# /og-dialog-header #}

<div class="og-dialog-body">
<input
type='hidden'
value='{{ payment.token_id }}'
name='payment_token' />
<input
type='hidden'
value='{{ customer.sig_field }}'
name='customer' />

{% if payment %}
{% set payment_method_names = 'payment_method_names' | t %}

<div class="og-text-header">
<span>
{{ 'modal_billing_current_display' | t }} -
</span>
<span og-payment-id="{{payment.public_id}}">
<span class="og-payment-type">{{ payment.cc_type }} {{ payment_method_names[payment.payment_method] }}</span>
{% if payment.cc_number_ending %}
<span class="og-payment-last-4">{{ 'form_billing_ending_in' | t }}</span>
{% endif %}
</span>
</div>{# /og-text-header #}
{% endif %}

<div class="og-text-header">{{ 'modal_billing_subscriptions_display_header' | t }}:</div>
<div class="og-subscription-display">
{% set subscriptions_payment = subscriptions | select(payment=payment.public_id) %}
<div class="og-billing-list-subscriptions">
{% for subscription in subscriptions_payment | select('live') %}
{% set product = products | find(id=subscription.product) %}
{% if product %}
<div class="og-billing-subscription">
<div class="og-product-image-container-billing">
<img
class="og-product-image"
loading="lazy"
alt="{{ product.name }}"
src="{{ product.image_url | if_defined }}" />
</div>
<div class="og-subscription-info">
<div>{{ product.name }}</div>
<div>{{ 'product_read_only_quantity' | t }}, {{ 'modal_billing_frequency_display' | t }} {{ 'frequency_period' | t(every=subscription.every, period=subscription.every_period) }}</div>
</div>
</div>
{% endif %}
{% endfor %}
</div>
<div class="og-billing-list-subscriptions og-inactive">
{% for subscription in subscriptions_payment | reject('live') %}
{% set product = products | find(id=subscription.product) %}
{% if product %}
<div class="og-billing-subscription">
<div class="og-product-image-container-billing">
<img
class="og-product-image"
loading="lazy"
alt="{{ product.name }}"
src="{{ product.image_url | if_defined }}" />
</div>
<div class="og-subscription-info">
<div>{{ product.name }}
<span class="og-cancelled">({{ 'modal_billing_cancelled' | t }})</span>
</div>
<div>{{ 'product_read_only_quantity' | t }}, {{ 'modal_billing_frequency_display' | t }} {{ 'frequency_period' | t(every=subscription.every, period=subscription.every_period) }}
</div>
</div>
</div>
{% endif %}
{% endfor %}
</div>
</div>

<div class="og-info">
<svg
width="18"
height="18"
viewBox="0 0 18 18"
fill="none"
xmlns="http://www.w3.org/2000/svg">
<path d="M8.99984 0.666664C4.39779 0.666664 0.666504 4.39929 0.666504 9C0.666504 13.6034 4.39779 17.3333 8.99984 17.3333C13.6019 17.3333 17.3332 13.6034 17.3332 9C17.3332 4.39929 13.6019 0.666664 8.99984 0.666664ZM8.99984 4.3629C9.77927 4.3629 10.4111 4.99476 10.4111 5.77419C10.4111 6.55363 9.77927 7.18548 8.99984 7.18548C8.2204 7.18548 7.58855 6.55363 7.58855 5.77419C7.58855 4.99476 8.2204 4.3629 8.99984 4.3629ZM10.8816 12.8978C10.8816 13.1205 10.701 13.3011 10.4783 13.3011H7.52134C7.29866 13.3011 7.11812 13.1205 7.11812 12.8978V12.0914C7.11812 11.8687 7.29866 11.6882 7.52134 11.6882H7.92457V9.53763H7.52134C7.29866 9.53763 7.11812 9.35709 7.11812 9.13441V8.32795C7.11812 8.10527 7.29866 7.92473 7.52134 7.92473H9.67188C9.89456 7.92473 10.0751 8.10527 10.0751 8.32795V11.6882H10.4783C10.701 11.6882 10.8816 11.8687 10.8816 12.0914V12.8978Z" fill="#474747" />
</svg>
<div>
<div class="og-info-header">{{ 'modal_billing_info_header' | t }}</div>
<span>{{ 'modal_billing_info_text' | t }}</span>
</div>
</div>

</div>{# /og-dialog-body #}

<div class="og-dialog-footer">
<button
class="og-button"
type="submit"
name="send_payment_email">{{ 'modal_billing_confirm' | t }}</button>
</div>{# /og-dialog-footer #}
</form>
</dialog>
</div>{# /og-change-billing-button #}
```

## 3. styles/billing-display.less

Create a new view file and name it **billing-display.less**

Copy and paste the below code to this new file and click **Save**.

```css
.og-change-billing-button {
dialog {

.og-subscription-display {
overflow: auto;
max-height: 30vh;
.og-billing-list-subscriptions {
display: flex;
flex-direction: column;
row-gap: 20px;
.og-billing-subscription {
display: flex;
flex-direction: row;
font-size: 12px;
line-height: 150%;
.og-product-image-container-billing {
padding-right: 10px;
padding-left: 10px;
img {
object-fit: contain;
width: 60px;
height: 60px;
}
}
.og-subscription-info {
align-self: center;

.og-cancelled {
text-transform: uppercase;
}
}
}
}
.og-inactive {
opacity: 50%;
}
}
}

}
```

## 4. styles/dialogs.less

Scroll down the left-hand side to find the **dialogs.less** file under the **Styles** folder.

Find *.og-dialog-title \{* and delete the following two lines of code:

```css
padding-right: 1em;
margin: 0;
```

Find *.og-cancel-title \{*, delete the line and replace it with the following:

```
.og-dialog-title-big {
font-size: 20px;
margin-bottom: 0px;
font-weight: bold;
}

.og-dialog-title,
.og-dialog-title-big {
margin: 0;
padding-right: 1em;
}

.og-text-header {
margin-bottom: 30px;
}

.og-info {
border-radius: 8px;
border: 1px solid rgba(0, 0, 0, 0.5);
padding: 15px 60px 15px 5px;
color: #113243;
font-size: 12px;
line-height:18px;
font-weight: 400;
margin-top: 40px;
display: flex;
flex-direction: row;

.og-info-header {
font-weight: 600;
line-height: 20px;
margin-block-start: 0px;
margin-block-end: 5px;
font-size: 14px;
}

svg {
margin: 5px 10px;
}
}
```

## 5. styles/main.less

Scroll down the left-hand side to find the main.less file under the Styles folder.

Add the following line of code:

```css
@import './billing-display.less';
```

## 6. locales/en-US.json

Scroll down the left-hand side to find the **en-US.json** file under the **Locales** folder.

Find *"modal\_shipping\_header": "Change Shipping Address"*, and add the following lines of code:

```json
"modal_billing_header": "Replace Payment Method",
"modal_billing_current_display": "Current payment method",
"modal_billing_subscriptions_display_header": "Subscriptions associated with the payment method above",
"modal_billing_frequency_display": "Frequency: Every",
"modal_billing_cancelled": "Cancelled",
"modal_billing_info_header": "We will send you an email to update your payment.",
"modal_billing_info_text": "This will replace your current payment method on the subscriptions above.",
"modal_billing_confirm": "Send Email",
```

Locate *"pause\_subscription\_error": "An error occurred while pausing your subscription. Please try again later."* - add a comma after the line, and add the following after:

```json
"change_billing_send_email_success": "Success! You will receive an email from us shortly to update your payment information.",
"change_billing_send_email_error": "An error occurred while sending your payment update email. Please try again later."
```

## 7. locales/en-CA.json

Scroll down the left-hand side to find the **en-CA.json** file under the **Locales** folder.

Find *"modal\_shipping\_header": "Change Shipping Address"*, and add the following lines of code:

```json
"modal_billing_header": "Replace Payment Method",
"modal_billing_current_display": "Current payment method",
"modal_billing_subscriptions_display_header": "Subscriptions associated with the payment method above",
"modal_billing_frequency_display": "Frequency: Every",
"modal_billing_cancelled": "Cancelled",
"modal_billing_info_header": "We will send you an email to update your payment.",
"modal_billing_info_text": "This will replace your current payment method on the subscriptions above.",
"modal_billing_confirm": "Send Email",
```

Locate *"pause\_subscription\_error": "An error occurred while pausing your subscription. Please try again later."* - add a comma after the line, and add the following after:

```
"change_billing_send_email_success": "Success! You will receive an email from us shortly to update your payment information.",
"change_billing_send_email_error": "An error occurred while sending your payment update email. Please try again later."
```

## 8. locales/es-ES.json

Scroll down the left-hand side to find the **es-ES.json** file under the **Locales** folder.

Find "*modal\_shipping\_header": "Cambiar las opciones de envío"*, and add the following lines of code:

```json
"modal_billing_header": "Reemplazar método de pago",
"modal_billing_current_display": "Método de pago actual",
"modal_billing_subscriptions_display_header": "Suscripciones asociadas con este método de pago",
"modal_billing_frequency_display": "Frecuencia: Cada",
"modal_billing_cancelled": "Cancelada",
"modal_billing_info_header": "Le enviaremos un correo electrónico para actualizar su forma de pago.",
"modal_billing_info_text": "Esto reemplazará su forma de pago en estas suscripciones.",
"modal_billing_confirm": "Enviar correo electrónico",
```

Locate *"pause\_subscription\_error": "Ocurrió un error pausando la suscripción. Por favor, vuelva a intentarlo más tarde."*, - add a comma after the line, and add the following after:

```json
"change_billing_send_email_success": "En breve recibirá un correo electrónico nuestro para actualizar su información de pago.",
"change_billing_send_email_error": "Ocurrió un error al enviar el correo electrónico de actualización de pago. Por favor, inténtelo de nuevo más tarde."
```

## 9. locales/fr-CA.json

Scroll down the left-hand side to find the fr-CA.json file under the Locales folder.

Find *"modal\_shipping\_header": "Modifier l'addresse de livraison"*, and add the following lines of code:

```json
"modal_billing_header": "Remplacer le mode de paiement",
"modal_billing_current_display": "Mode de paiement actuel",
"modal_billing_subscriptions_display_header": "Abonnements associés au mode de paiement ci-dessus",
"modal_billing_frequency_display": "Fréquence : tous les",
"modal_billing_cancelled": "Annulé",
"modal_billing_info_header": "Nous vous enverrons un e-mail pour mettre à jour votre paiement.",
"modal_billing_info_text": "Celle-ci remplacera votre carte actuelle sur les abonnements ci-dessus.",
"modal_billing_confirm": "Envoyer l’e-mail",
```

Locate *"pause\_subscription\_error": "Une erreur s'est produite, SVP réessayer de pauser votre abonnement plus tard."* - add a comma after the line, and add the following after:

```json
"change_billing_send_email_success": "Succès ! Vous recevrez sous peu un e-mail de notre part pour mettre à jour vos informations de paiement.",
"change_billing_send_email_error": "Une erreur s’est produite lors de l’envoi de votre e-mail de mise à jour de paiement. Veuillez réessayer plus tard."
```

***

## Additional Assistance

If you followed the above steps and still do not see it, please submit a ticket to [help@ordergroove.com](mailto:help@ordergroove.com).