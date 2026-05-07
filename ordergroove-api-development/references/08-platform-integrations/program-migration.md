# Migrate my data to Ordergroove

Ordergroove uses newline delimited JSON file where each customer's data is its own JSON object on its own line. Use one line per customer. Addresses and payments and subscriptions are connected using their IDs in the origin object.

***

## Example: Single Customer JSON Object

You need to create the below object for each customer and put each object on a new line in a file:

```Text JSON
{
    "customer": {
        "merchant" : "n83hg5fm7d82345f727dk203",
        "merchant_user_id": "2398573030",
        "first_name": "Sam",
        "last_name": "Smith",
        "email": "sam.smith@ordergroove.com",
        "live": true,
        "phone_number": null,
        "extra_data": null,
        "price_code": null,
        "created": "2021-02-26 18:15:07",
        "origin": {
            "id": "3452345784"
        }
    },
    "addresses": [
        {
            "customer": "2398573030",
            "address_type": "billing_address",
            "first_name": "Sam",
            "last_name": "Smith",
            "address": "1 Fifth Ave",
            "city": "New York",
            "state_province_code": "NY",
            "zip_postal_code": "10003",
            "country_code": "US",
            "live": true,
            "phone": "555-123-4567",
            "origin": {
                "id": "3452277044"
            }
        },
        {
            "customer": "2398573030",
            "address_type": "shipping_address",
            "first_name": "Sam",
            "last_name": "Smith",
            "address": "1 Fifth Ave",
            "city": "New York",
            "state_province_code": "NY",
            "zip_postal_code": "10003",
            "country_code": "US",
            "live": true,
            "phone": "555-123-4567",
            "origin": {
                "id": "61377044"
            }  
        }
    ],
    "payments": [
        {
            "customer": "2398573030",
            "live": true,
            "token_id": "274573947",
            "cc_holder": "Sam Smith",
            "cc_type": 2,
            "cc_exp_date": "09/2022",
            "created": "2021-02-26 18:15:07",
            "origin": {
                "id": "567563456",
                "billing_address": "3452277044"       
            }
        } 
    ],
    "subscriptions": [
        {
            "customer": "2398573030",
            "product": "3g2375g385",
            "offer": "b6b8cf7c52346234652342b6aba89ec1ea9",
            "merchant_order_id": "18076256",
            "live": true,
            "every": 4,
            "every_period": "week",
            "quantity": 1,
            "price": "18.99",
            "start_date": "2020-07-21",
            "cancelled": null,
            "next_order_date": "2021-03-21",
            "multi_item_bundle_components": [
                {
                    "product": "44284019474619",
                    "quantity": 2
                },
                {
                    "product": "44284019343547",
                    "quantity": 1
                }
            ],
            "currency_code": "USD",
            "rotation_ordinal": 0,
            "origin": {
                "id": "56723446",
                "payment": "567563456",
                "shipping_address": "61377044"
            }
        },
        {
            "customer": "2398573030",
            "product": "09832ng9739",
            "offer": "b6b8cf7c52346234652342b6aba89ec1ea9",
            "merchant_order_id": "18076256",
            "live": false,
            "every": 3,
            "every_period": "month",
            "quantity": 1,
            "price": "48.99",
            "start_date": "2020-07-21",
            "cancelled": "2020-09-21 10:21:56",
            "next_order_date": null,
            "currency_code": "USD",
            "rotation_ordinal": 1,
        "origin": {
            "id": "2435764567",
            "payment": "567563456",
            "shipping_address": "61377044"
            }
        }
    ]
}
```

***

## Migration file fields

Below you'll find information about the data you'll need to populate the migration file.

> 🚧 Optional Fields
>
> Fields marked with a \* may be required during your migration. Please reach out to Ordergroove to confirm which fields are required for your subscription program.

## Fields For Each Customer

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Field
      </th>

      <th>
        Required
      </th>

      <th>
        Format
      </th>

      <th>
        Notes
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        merchant
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        String. Your program's unique ID within Ordergroove
      </td>
    </tr>

    <tr>
      <td>
        merchant\_user\_id
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        String. The customer ID in the e-commerce platform you've installed Ordergroove on. We use this to identify your subscriber in that system
      </td>
    </tr>

    <tr>
      <td>
        email
      </td>

      <td>
        *
      </td>

      <td>
        string
      </td>

      <td>
        Used to send transactional emails.
      </td>
    </tr>

    <tr>
      <td>
        first\_name
      </td>

      <td>
        *
      </td>

      <td>
        string
      </td>

      <td />
    </tr>

    <tr>
      <td>
        last\_name
      </td>

      <td>
        *
      </td>

      <td>
        string
      </td>

      <td />
    </tr>

    <tr>
      <td>
        live
      </td>

      <td>
        Y
      </td>

      <td>
        boolean
      </td>

      <td>
        Indicates if a customer has been manually deactivated
      </td>
    </tr>

    <tr>
      <td>
        phone\_number
      </td>

      <td>
        N
      </td>

      <td>
        string

        Format: [E.164](https://en.wikipedia.org/wiki/E.164)
      </td>

      <td />
    </tr>

    <tr>
      <td>
        created
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        Format: YYYY-MM-DD HH:MM:SS
      </td>
    </tr>

    <tr>
      <td>
        extra\_data
      </td>

      <td>
        N
      </td>

      <td>
        JSON as string
      </td>

      <td>
        Used in rare cases, can be ignored
      </td>
    </tr>

    <tr>
      <td>
        origin
      </td>

      <td>
        Y
      </td>

      <td>
        object
      </td>

      <td>
        Identifiers from the platform(s) you're migrating from
      </td>
    </tr>
  </tbody>
</Table>

## Fields For the Customer Origin Component

| Field | Required | Format | Notes                                                                                 |
| :---- | :------- | :----- | :------------------------------------------------------------------------------------ |
| ID    | Y        | string | The ID of the customer you will use in other origin objects to refer to this customer |

## Fields For Each Subscription

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Field
      </th>

      <th>
        Required
      </th>

      <th>
        Format
      </th>

      <th>
        Notes
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        customer
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        The customer ID in the e-commerce platform you've installed Ordergroove on. We use this to identify your subscriber in that system. \[merchant\_user\_id]
      </td>
    </tr>

    <tr>
      <td>
        start\_date
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        The date when the subscription was created or the date it was most recently reactivated after having been cancelled.

        Format: YYYY-MM-DD
      </td>
    </tr>

    <tr>
      <td>
        cancelled
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        The date when the subscription was most recently cancelled
      </td>
    </tr>

    <tr>
      <td>
        next\_order\_date
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        When we import this subscription this will be the date on which we create its next order.

        Format: YYYY-MM-DD HH:MM:SS

        * \*Note\*\*: If the migrated date is in the past, Ordergroove will update it to the *next date orders* can be *placed*. This is usually *tomorrow*.
      </td>
    </tr>

    <tr>
      <td>
        live
      </td>

      <td>
        Y
      </td>

      <td>
        boolean
      </td>

      <td>
        Whether or not the subscription is active.\
        For 'Paused' subscriptions please use false.
      </td>
    </tr>

    <tr>
      <td>
        merchant\_order\_id
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        The ID of the e-commerce order with which the subscription was originally created (when they enrolled).  This will be used to ensure accuracy and avoid duplicate subscriptions.
      </td>
    </tr>

    <tr>
      <td>
        product
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        The ID of the product in your e-commerce system.  Before you start the migration, this product's information must be included in the recurring [product feed](https://developer.ordergroove.com/docs/integrating-with-a-custom-platform) sent to Ordergroove. This is how we will identify the subscription product when placing orders.
      </td>
    </tr>

    <tr>
      <td>
        every
      </td>

      <td>
        Y
      </td>

      <td>
        integer
      </td>

      <td>
        How often, in frequency periods, to send the subscription item. For example, if a subscription comes every four weeks this field would be "4"
      </td>
    </tr>

    <tr>
      <td>
        every\_period
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        The frequency period to use when calculating the next order. Options: day, week, month

        For example, if a subscription comes every four weeks this field would be "week"
      </td>
    </tr>

    <tr>
      <td>
        price
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        Can be set to null, or you may provide a price. Keep in mind however that the key is required.
      </td>
    </tr>

    <tr>
      <td>
        quantity
      </td>

      <td>
        Y
      </td>

      <td>
        integer
      </td>

      <td>
        How many pieces of the product the subscriber has subscribed to for each order
      </td>
    </tr>

    <tr>
      <td>
        offer
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        This will be provided to you when your account is created. It identifies the incentive profile for this subscription.
      </td>
    </tr>

    <tr>
      <td>
        shipping\_address
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        The address to which the subscription will be shipped.
      </td>
    </tr>

    <tr>
      <td>
        extra\_data
      </td>

      <td>
        N
      </td>

      <td>
        JSON as string
      </td>

      <td>
        Used in rare cases, can be ignored.
      </td>
    </tr>

    <tr>
      <td>
        components
      </td>

      <td>
        N
      </td>

      <td>
        object
      </td>

      <td>
        If the subscription is a bundle, include the data for each component product to migrate to the Legacy Bundle integration. See below for more information on the old integration. **To migrate to the New Bundles Integration[check this section](https://help.ordergroove.com/hc/en-us/articles/6351678016403-View-migration-file-structure-information#h_01HCHXBYBFN2BGSD8KB55PRVQK)**
      </td>
    </tr>

    <tr>
      <td>
        currency\_code
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        The three letter ISO 4217 currency code of the subscription.
      </td>
    </tr>

    <tr>
      <td>
        rotation\_ordinal
      </td>

      <td>
        N
      </td>

      <td>
        integer
      </td>

      <td>
        An integer value greater than or equal to 0 used to determine the current progress of the rotating ordinal subscription.
      </td>
    </tr>

    <tr>
      <td>
        origin
      </td>

      <td>
        Y
      </td>

      <td>
        object
      </td>

      <td>
        Identifiers from the platform(s) you're migrating from.
      </td>
    </tr>
  </tbody>
</Table>

## Prepaid subscription fields

Prepaid subscriptions have an additional field:

* ***prepaid\_subscription\_context*** - A JSON object that contains information about prepaid subscriptions. Required if the subscription is prepaid.

This is an object containing information about prepaid subscriptions, and is only required if the subscription is prepaid. To use this field, you must have the prepaid feature flag enabled by Ordergroove. Otherwise, you will get errors during the migration process.

Example:

```
{
 // other migration fields
 "subscriptions": [
   {
    // other subscription fields
    "prepaid_subscription_context": {
     "prepaid_orders_remaining": 3,
     "prepaid_orders_per_billing": 6,
     "renewal_behavior": "autorenew"
    }
  }
 ]
}
```

There are three properties, all three are required. If errors are present, they will be returned in the `error` property of the `subscription`.

<Table align={["left","left","left"]}>
  <thead>
    <tr>
      <th>
        Property
      </th>

      <th>
        Type
      </th>

      <th>
        Notes
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        *prepaid\_orders\_per\_billing*
      </td>

      <td>
        integer
      </td>

      <td>
        The number of orders the customer prepays for at once. Must be an integer greater than 1.
      </td>
    </tr>

    <tr>
      <td>
        *prepaid\_orders\_remaining*
      </td>

      <td>
        integer
      </td>

      <td>
        How many prepaid orders are left in the current billing cycle. Must be a positive integer or 0.
      </td>
    </tr>

    <tr>
      <td>
        *renewal\_behavior*
      </td>

      <td>
        string
      </td>

      <td>
        What should happen at the end of a prepaid billing cycle. A strong with values:

        * 'autorenew' - after all prepaid orders have been placed, the next order will charge the customer for another `prepaid_orders_per_billing` orders
        * 'cancel' - the subscription will be canceled
        * 'downgrade' - the subscription will be downgraded to a pay-as-you-go subscription
      </td>
    </tr>
  </tbody>
</Table>

## Fields For Each Subscription Component of a Legacy Bundle

| Field   | Required | Format | Notes                                                                                                                                                                                                                                                                                                                                                |
| :------ | :------- | :----- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| product | Y        | string | The ID of the product in your e-commerce system.  Before you start the migration this product's information must be included in the recurring [product feed](https://developer.ordergroove.com/docs/integrating-with-a-custom-platform) sent to Ordergroove. This is how we will identify the subscription's component products when placing orders. |

## Fields For Each Subscription Origin Component

| Field             | Required | Format | Notes                                                                                                                                                                                                              |
| :---------------- | :------- | :----- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ID                | Y        | string | The ID you'll use to identify this address in the rest of this customer's JSON object.  It can be the ID of the address in your e-commerce system, subscription platform, or something you generate for migration. |
| payment           | Y        | string | The ID of the payment method for this subscription. This should be the same as the origin ID provided for this payment method in this JSON object.                                                                 |
| shipping\_address | Y        | string | The ID of the shipping address for this subscription. This should be the same as the origin ID provided for this shipping address in this JSON object.                                                             |

## Fields For Each Payment Method

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Field
      </th>

      <th>
        Required
      </th>

      <th>
        Format
      </th>

      <th>
        Notes
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        customer
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        The customer ID in the e-commerce platform you've installed Ordergroove on. We use this to identify your subscriber in that system. \[merchant\_user\_id]
      </td>
    </tr>

    <tr>
      <td>
        cc\_holder
      </td>

      <td>
        *
      </td>

      <td>
        string
      </td>

      <td>
        Name of the credit cardholder. If you're unable to access this data you can turn it off as required for the migration and back on if desired.

        [Check your settings](https://developer.ordergroove.com/hc/en-us/articles/360041560073-Order-Placement-Subscription-Creation-Validation-Settings#h_01EGP2Z1BAW6XXNVTZ20JADBPZ) to see if required by your Ordergroove program.

        *Please also check the requirements of your e-commerce store. If this field is required outside of Ordergroove but not present in the data you migrate it could cause errors during the import or orders not to place down the line.*
      </td>
    </tr>

    <tr>
      <td>
        cc\_type
      </td>

      <td>
        *
      </td>

      <td>
        string
      </td>

      <td>
        Options:\
        Visa: 1\
        MasterCard: 2\
        American Express: 3\
        Discover: 4\
        Diners: 5\
        JCB: 6

        If you're unable to access this data you can turn it off as required for the migration and back on if desired however please note subscribers will not see this with their subscription payment information.

        [Check your settings](https://developer.ordergroove.com/hc/en-us/articles/360041560073-Order-Placement-Subscription-Creation-Validation-Settings#h_01EGP2Z1BAW6XXNVTZ20JADBPZ) to see if required by your Ordergroove program.

        *Please also check the requirements of your e-commerce store. If this field is required outside of Ordergroove but not present in the data you migrate it could cause errors during the import or orders not to place down the line.*
      </td>
    </tr>

    <tr>
      <td>
        cc\_exp\_date
      </td>

      <td>
        *
      </td>

      <td>
        string
      </td>

      <td>
        If you're unable to access this data you can turn it off as required for the migration and back on if desired however please note subscribers will not see this with their subscription payment information. In addition, we will not be able to.

        Format: MM/YYYY

        [Check your settings](https://developer.ordergroove.com/hc/en-us/articles/360041560073-Order-Placement-Subscription-Creation-Validation-Settings#h_01EGP2Z1BAW6XXNVTZ20JADBPZ) to see if required by your Ordergroove program.

        *Please also check the requirements of your e-commerce store. If this field is required outside of Ordergroove but not present in the data you migrate it could cause errors during the import or orders not to place down the line.*
      </td>
    </tr>

    <tr>
      <td>
        created
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        Format: YYYY-MM-DD HH:MM:SS
      </td>
    </tr>

    <tr>
      <td>
        token\_id
      </td>

      <td>
        Y
      </td>

      <td>
        string
      </td>

      <td>
        Either:

        1. The credit card token used when placing orders for this subscription

        2. A unique identifier used by your e-commerce system to charge the subscriber (such as a customer ID).For BigCommerce send the customer ID as the tokenTo migrate to Shopify payments leave this blank and continue to the origin components below
      </td>
    </tr>

    <tr>
      <td>
        live
      </td>

      <td>
        Y
      </td>

      <td>
        boolean
      </td>

      <td>
        If the payment method is still active and usable by the customer
      </td>
    </tr>

    <tr>
      <td>
        origin
      </td>

      <td>
        Y
      </td>

      <td>
        object
      </td>

      <td>
        Identifiers from the platform(s) you're migrating from
      </td>
    </tr>
  </tbody>
</Table>

## Fields For Each Payment Method > Origin Component

| Field              | Required | Format | Notes                                                                                                                                                                                                                              |
| :----------------- | :------- | :----- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ID                 | Y        | string | The ID you'll use to identify this payment method in the rest of this customer's JSON object.  It can be the ID of the payment method in your e-commerce system, a subscription platform, or something you generate for migration. |
| billing\_address   | Y        | string | The ID of the billing address for this subscription. This should be the same as the origin ID provided for this billing address in this JSON object.                                                                               |
| payment\_processor | N        | string | Information on payment processor being migrated                                                                                                                                                                                    |

## Fields For Each Payment Method > Origin > Payment Processor Component

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Field
      </th>

      <th>
        Required
      </th>

      <th>
        Format
      </th>

      <th>
        Notes
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        type
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        Options: PayPal, Stripe

        Required when migrating to Shopify Payment
      </td>
    </tr>

    <tr>
      <td>
        data
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        Data specific to the type of payment process
      </td>
    </tr>
  </tbody>
</Table>

## Fields For Each Payment Method > Origin > Payment Processor > Data (Stripe Type)

| Field     | Required | Format | Notes                                                                                                                                           |
| :-------- | :------- | :----- | :---------------------------------------------------------------------------------------------------------------------------------------------- |
| token\_id | N        | string | The Stripe token to be migrated. Please provide the [Customer Profile ID](https://docs.stripe.com/api/customers) only. For example: cus\_abc123 |

## Fields For Each Payment Method > Origin > Payment Processor > Data

(PayPal Type)

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Field
      </th>

      <th>
        Required
      </th>

      <th>
        Format
      </th>

      <th>
        Notes
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        token\_id
      </td>

      <td>
        N
      </td>

      <td>
        string
      </td>

      <td>
        The PayPal billing agreement ID to be migrated

        [Deprecated PayPal Docs](https://developer.paypal.com/docs/api/payments.billing-agreements/v1/)

        [Braintree Docs](https://developer.paypal.com/braintree/docs/reference/response/paypal-account#billing_agreement_id)
      </td>
    </tr>
  </tbody>
</Table>

## Fields For Each Shipping or Billing Addresses

<HTMLBlock>
  {`
  <table style="height: 381px; width: 794px;" border="#000000">
    <tbody>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="width: 125.438px; background-color: #dddddd; height: 21px;">
          <p>
            <strong>Field</strong>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; background-color: #dddddd; height: 21px;">
          <p>
            <strong>Required</strong>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 128.312px; background-color: #dddddd; height: 21px;">
          <p>
            <strong>Format</strong>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 379.562px; background-color: #dddddd; height: 21px;">
          <p>
            <strong>Notes</strong>
          </p>
        </td>
      </tr>
      <tr style="height: 65px;">
        <td class="wysiwyg-text-align-center" style="height: 65px; width: 125.438px;">
          <p>
            <span>customer</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 65px;">
          <p>
            <span>Y</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 65px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
        <td style="height: 65px; width: 379.562px;">
          The customer ID in the e-commerce platform you've installed Ordergroove
          on. We use this to identify your subscriber in that system. [merchant_user_id]
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>address_type</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span>Y</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
          <p>
            <span>Options: billing_address, shipping_address</span>
          </p>
        </td>
        <td style="height: 21px; width: 379.562px;">&nbsp;</td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>first_name</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
        <td style="height: 210px; width: 379.562px;" rowspan="10">
          <p>&nbsp;</p>
          <p>
            Check with Ordergroove to see if these fields are required by
            your subscription program.
          </p>
          <p>&nbsp;</p>
          <p>
            <em>Please also check the requirements of your e-commerce store. If any of these fields are required </em><em>outside</em><em> of Ordergroove but not present in the data you migrate it could cause errors during the import or orders not to place down the line.</em><br>
            <br>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>last_name</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>company</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>address</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>address2</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <span>string</span>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>city</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>state</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
          <p>
            <a href="https://static.ordergroove.com/@ordergroove/i18n-data/0.1.3/i18n_country_data.json" target="_self"><span>Validation</span></a>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>zip_code</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>country</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <a href="https://static.ordergroove.com/@ordergroove/i18n-data/0.1.3/i18n_country_data.json" target="_self"><span>Validation</span></a>
          </p>
        </td>
      </tr>
      <tr style="height: 21px;">
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 125.438px;">
          <p>
            <span>phone</span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="width: 115.688px; height: 21px;">
          <p>
            <span><strong><span class="wysiwyg-color-red">*</span></strong></span>
          </p>
        </td>
        <td class="wysiwyg-text-align-center" style="height: 21px; width: 128.312px;">
          <p>
            <span>string</span>
          </p>
          <p>
            <span>Format: <a href="https://en.wikipedia.org/wiki/E.164" target="_self">E.164</a></span>
          </p>
        </td>
      </tr>
      <tr style="height: 43px;">
        <td style="height: 43px; width: 125.438px;">
          <p class="wysiwyg-text-align-center">
            <span>live</span>
          </p>
        </td>
        <td style="width: 115.688px; height: 43px;">
          <p class="wysiwyg-text-align-center">
            <span>Y</span>
          </p>
        </td>
        <td style="height: 43px; width: 128.312px;">
          <p class="wysiwyg-text-align-center">
            <span>boolean</span>
          </p>
        </td>
        <td style="height: 43px; width: 379.562px;">
          Whether or not this address is still active and usable by the customer
        </td>
      </tr>
      <tr style="height: 21px;">
        <td style="height: 21px; width: 125.438px;">
          <p class="wysiwyg-text-align-center">
            <span>origin</span>
          </p>
        </td>
        <td style="width: 115.688px; height: 21px;">
          <p class="wysiwyg-text-align-center">
            <span>Y</span>
          </p>
        </td>
        <td style="height: 21px; width: 128.312px;">
          <p class="wysiwyg-text-align-center">
            <span>object</span>
          </p>
        </td>
        <td style="height: 21px; width: 379.562px;">
          <span>Identifiers from the platform(s) you're migrating from</span>
        </td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

## Fields For Each Address Origin Component

| Field | Required | Format | Notes                                                                                                                                                                                                              |
| :---- | :------- | :----- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ID    | Y        | string | The ID you'll use to identify this address in the rest of this customer's JSON object.  It can be the ID of the address in your e-commerce system, subscription platform, or something you generate for migration. |

***

## Migrating to Shopify & Shopify Payments

If needed, the Ordergroove migration system can import certain types of payment methods into Shopify Payments. Please reach out to Ordergroove for your specific payment migration needs. The following example is a record for migrating a Stripe payment to Shopify Payments when using the Stripe Legacy Gateway feature on Shopify:

```
{
  ...
  "payments": [
     {
        "customer": "11112222334455",
        "live": true,
        "token_id": "cus_ABCDEFG1234567",
        "billing_address": null,
        "public_id": null,
        "cc_number": "1111",
        "label": null,
        "cc_holder": null,
        "cc_type": 2,
        "cc_exp_date": "12/2030",
        "payment_method": "credit card",
        "created": null,
        "last_updated": null,
        "origin": {
          "id": "payment-0",
          "billing_address": "billing-0",
          "payment_processor": {
            "type": "stripe",
            "data": {
              "token": "cus_ABCDEFG1234567",              "stripe_payment_method_id": "..."
            }
          }
        }
     },
     ...
  ]
}
```

The origin object provides a “payment\_processor” field which is where you can populate the data necessary to migrate your customer’s payment Shopify Payments. Here are the different payment types supported and their accompanying field requirements:

### Stripe

```
{   ...  "payment_processor": {
    "type": "stripe",
    "data": {
        "token": "STRIPE_CUSTOMER_TOKEN",
        "stripe_payment_method_id": "..."
    }  }
}
```

### Paypal

```
{
  ...
  "token_id": "PAYPAL_BILLING_AGREEMENT_ID", 
  "payment_method": "paypal",
  ...
  "origin": {
    ...
    "payment_processor": {
      "type": "paypal",
      "data": {
        "token": "PAYPAL_BILLING_AGREEMENT_ID"
      }
    }
  }
}
```

### Auth.net

**Note**: Auth.net as a legacy subscription payment gateway is currently supported as a beta feature by Shopify. To use this feature, enable the legacy\_subscriptions\_authnet beta flag in your store. Please see this article for additional detail: [https://shopify.dev/apps/subscriptions/migrate/customers#migrating-from-authorize-net](https://shopify.dev/apps/subscriptions/migrate/customers#migrating-from-authorize-net)

```
{   ...  "payment_processor": {
    "type": "authorize",
    "data": {
        "token": "AUTH_NET_CUSTOMER_TOKEN",
        "customer_payment_profile_id": "..." // Optional, but recommended to specify
    	}   
	} 
}
```

### Braintree

**Note**: Braintree as a legacy subscription payment gateway is currently supported as a beta feature by Shopify. To use this feature, enable the legacy\_subscriptions\_braintree beta flag in your store. Please see this article for additional detail: [https://shopify.dev/apps/subscriptions/migrate/customers#migrating-from-braintree](https://shopify.dev/apps/subscriptions/migrate/customers#migrating-from-braintree)

```
{
  ...
  "payment_processor": {
    "type": "braintree",
    "data": {
      "token": "BT_CUSTOMER_TOKEN",
      "payment_method_token": "BT_PAYMENT_METHOD_TOKEN"
    }
  }
}
```