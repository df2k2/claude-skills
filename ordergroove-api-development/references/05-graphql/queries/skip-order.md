# Skip Order

This article details one component in a larger series about the Subscription Manager. For an overview take a look at [Subscription Manager Components & Containers](https://developer.ordergroove.com/docs/subscription-manager-components-containers).

***

**Skip Order** allows a customer to skip their next upcoming order. The code for the pop up modal can be found in **skip-liquid**.

```liquid
<div class="og-skip-shipment-button">
<button class="og-button" type="button" @click={{ 'show_closest_modal' | js }} >
{{ 'shipment_skip_button' | t }}
</button>

<dialog aria-hidden="true">

<form action="{{ 'skip_shipment' | action }}" @success={{ 'close_closest_modal' | js }} @reset={{ 'close_closest_modal' | js }} >

<div class="og-dialog-header">
<h5 class="og-dialog-title">{{ 'modal_skip_header' | t }}</h5>
<button class="og-button og-button-close" type="reset" aria-label="{{ 'modal_close' | t }}">
{{ 'modal_close' | t }}
</button>
</div>{# /og-dialog-header #}

<div class="og-dialog-body">
<input type="hidden" name="order" value="{{order.public_id}}"/>
{{ 'modal_skip_body' | t }}
</div>{# /og-dialog-body #}

<div class="og-dialog-footer">
<button class="og-button" type="submit" name="skip_shipment">{{ 'modal_skip_shipment_save' | t }}</button>
</div>{# /og-dialog-footer #}
</form>

</dialog>
</div>
```

<Image align="center" src="https://files.readme.io/87e0288-Screen_Shot_2023-06-28_at_16.01.02.png" />