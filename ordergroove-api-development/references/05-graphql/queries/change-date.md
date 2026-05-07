# Change Date

This article details one component in a larger series about the Subscription Manager. For an overview take a look at [Subscription Manager Components & Containers](https://developer.ordergroove.com/docs/subscription-manager-components-containers).

***

**Change Date** allows a customer to change the date of their upcoming order. The code that controls the modal can be found in **change-date.liquid**.

```liquid
<div class="og-change-shipment-date-button">
<button class="og-button" type="button" @click={{ 'show_closest_modal' | js }}>
{{ 'shipment_change_date_button' | t }}
</button>

<dialog aria-hidden="true">
<form action="{{ 'change_shipment_date' | action }}" @success={{ 'close_closest_modal' | js }} @reset={{ 'close_closest_modal' | js }}>
<div class="og-dialog-header">
<h5 class="og-dialog-title">{{ 'modal_change_date_header' | t }}</h5>
<button class="og-button og-button-close" type="reset" aria-label="{{ 'modal_close' | t }}" >{{ 'modal_close' | t }}</button>
</div>{# /og-dialog-header #}

<div class="og-dialog-body">
<input type="hidden" name="order" value="{{ order.public_id }}"/>
<input type="date" name="shipment_date" value="{{ order.place }}"/>
</div>{# /og-dialog-body #}

<div class="og-dialog-footer">
<button class="og-button" type="submit" name="change_shipment_date">{{ 'modal_change_date_save' | t }}</button>
</div>{# /og-dialog-footer #}
</form>
</dialog>
</div>
```

<Image align="center" src="https://files.readme.io/20310f0-CleanShot_2024-01-24_at_11.53.19.png" />