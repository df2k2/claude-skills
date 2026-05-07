# First Order Place Date control for Shopify Merchants

Shopify merchants can control the date that the first order of a subscription will be sent. Specifically, this is the date the first order following the customer’s initial checkout.

To accomplish this, you must set a specific custom attribute, also referred to as a *line item property*, for each cart line item you want to control. There are two optional attributes you can set to pass this preference to Ordergroove at the time of subscription creation:

* **og\_first\_order\_place\_date**: with this option, the customer will be able to see this property among the information that is being displayed for the line item during checkout;

<Image align="center" src="https://files.readme.io/4ff0987-image1.png" />

An example from the cart:

<Image align="center" src="https://files.readme.io/a4bf45e-image3_clean.png" />

* **\_\_og\_first\_order\_place\_date**: setting this attribute produces  the same result, but the property will be  hidden from the customer during checkout;

<Image align="center" src="https://files.readme.io/775902d-image4.png" />

Example from the same cart, now with the property hidden:

<Image align="center" src="https://files.readme.io/15721b7-image5.png" />

Although you can see the custom attribute/property explicitly set only for the second line item, both line items will have the exact same behavior when it comes to setting the first order place date - assuming that the first line item was properly set.

<Image align="center" src="https://files.readme.io/ef317b7-image2.png" />

<Image align="center" src="https://files.readme.io/661836d-image6.png" />

For both options, you will need to provide the date you want the first subscription order to be placed. The value of the property must be a  string following the format YYYY-MM-DD that represents the date in the future that  the first order will be placed.