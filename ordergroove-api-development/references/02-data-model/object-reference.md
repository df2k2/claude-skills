# Object Reference

Below is a list of all objects which are available for you to use to help you modify your Subscription Manager experience.

> ❗️ Security
>
> Field keys marked with a:lock:icon should not be used in your templates for the purpose of being rendered to the page. They should be treated as private information.

***

## locale

This `value` will represent the current locale being set on the website. The value is pulled form the lang attribute of the html node. For example `<html lang='en'>`

| Key    | Sample Value | Type   |
| :----- | :----------- | :----- |
| locale | 'en'         | String |

***

## customer

This `object` represents the current customer who is logged into your site that is viewing the Subscription Manager.

<Table align={["left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Key
      </th>

      <th>
        Sample Value
      </th>

      <th>
        Description
      </th>

      <th>
        Type
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        sig\_field
      </td>

      <td>
        'customer123'
      </td>

      <td>
        This field represents your customer's id. This id is used to map the customer between Ordergroove and your ecommerce system.
      </td>

      <td>
        string
      </td>
    </tr>

    <tr>
      <td>
        ts
      </td>

      <td>
        1619545753
      </td>

      <td>
        Timestamp used to generate the authentication signature.
      </td>

      <td>
        integer
      </td>
    </tr>

    <tr>
      <td>
        :lock:

        sig
      </td>

      <td>
        'abc123zky=='
      </td>

      <td>
        HMAC Signature used to authenticate the customer's current session.
      </td>

      <td>
        string
      </td>
    </tr>

    <tr>
      <td>
        authorized
      </td>

      <td>
        true
      </td>

      <td>
        Indicates whether a user who is viewing the Subscription Manager is successfully authenticated.
      </td>

      <td>
        boolean
      </td>
    </tr>

    <tr>
      <td>
        public\_id
      </td>

      <td>
        'abc1234556zyx'
      </td>

      <td>
        This id is used to identify you as the merchant.
      </td>

      <td>
        string
      </td>
    </tr>
  </tbody>
</Table>

***

## merchant\_id

This `value` is used to identify you as the merchant and is the same value that you would find under the `customer.public_id` key above.

| Key          | Sample Value    | type   |
| :----------- | :-------------- | :----- |
| merchant\_id | 'abc1234556zyx' | string |

***

## environment

This `object` represents the environment that the application is currently running in. You typically will not need to interact with this object unless you're instructed to by an Ordergroove representative.

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 9.71429%;">key</th>
        <th style="width: 35.2857%;">sample value</th>
        <th style="width: 47.5714%;">description</th>
        <th style="width: 7.28571%;">type</th>
      </tr>
      <tr>
        <td style="width: 9.71429%;">name</td>
        <td style="width: 35.2857%;">'prod'</td>
        <td style="width: 47.5714%;">
          The name of the Ordergroove environment where the Subscription Manager
          is currently running.
        </td>
        <td style="width: 7.28571%;">string</td>
      </tr>
      <tr>
        <td style="width: 9.71429%;">api_url</td>
        <td style="width: 35.2857%;">
          '<a href="https://api.ordergroove.com/" target="_self">https://api.ordergroove.com</a>'
        </td>
        <td style="width: 47.5714%;">
          URL of the legacy Ordergroove API cluster that the Subscription Manager
          is using to retrieve data.
        </td>
        <td style="width: 7.28571%;">string</td>
      </tr>
      <tr>
        <td style="width: 9.71429%;">lego_url</td>
        <td style="width: 35.2857%;">
          '<a href="https://restapi.ordergroove.com/" target="_self">https://restapi.ordergroove.com</a>'
        </td>
        <td style="width: 47.5714%;">
          URL of the Ordergroove REST API cluster that the Subscription Manager
          is using to retrieve data.
        </td>
        <td style="width: 7.28571%;">string</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## orders

This `array` represents the list of all of the customer's upcoming orders. Each item in this list is an order `object` and contains the following fields:

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%; height: 220px;" border="1">
    <tbody>
      <tr style="height: 22px;">
        <th style="height: 22px; width: 22%;">key</th>
        <th style="height: 22px; width: 20%;">sample value</th>
        <th style="height: 22px; width: 48.4286%;">description</th>
        <th style="height: 22px; width: 9.42857%;">type</th>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">merchant</td>
        <td style="height: 44px; width: 20%;">'abc1234556zyx'</td>
        <td style="height: 44px; width: 48.4286%;">This id is used to identify you as the merchant.</td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">customer</td>
        <td style="height: 67px; width: 20%;">'customer123'</td>
        <td style="height: 67px; width: 48.4286%;">
          This field represents your customer's id. This id is used to map
          the customer between Ordergroove and your ecommerce system.
        </td>
        <td style="height: 67px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">payment</td>
        <td style="height: 44px; width: 20%;">'pay123abc'</td>
        <td style="height: 44px; width: 48.4286%;">
          This is the id of the payment record associated with the order.
        </td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">shipping_address</td>
        <td style="height: 44px; width: 20%;">'ship123abc'</td>
        <td style="height: 44px; width: 48.4286%;">
          This is the id of the shipping address record associated with the
          order.
        </td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 22px;">
        <td style="height: 22px; width: 22%;">public_id</td>
        <td style="height: 22px; width: 20%;">'order123abc'</td>
        <td style="height: 22px; width: 48.4286%;">This is the order id.</td>
        <td style="height: 22px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">sub_total</td>
        <td style="height: 67px; width: 20%;">'0.00'</td>
        <td style="height: 67px; width: 48.4286%;">
          This is the order sub total. Inclusive of discounts but does not
          include tax and shipping costs.
        </td>
        <td style="height: 67px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 89px;">
        <td style="height: 89px; width: 22%;">tax_total</td>
        <td style="height: 89px; width: 20%;">'0.00'</td>
        <td style="height: 89px; width: 48.4286%;">
          Any tax which was already applied to the order. (Please note that
          Ordergroove typically does not calculate tax so this value will most
          likely be '0.00')
        </td>
        <td style="height: 89px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">shipping_total</td>
        <td style="height: 44px; width: 20%;">'0.00'</td>
        <td style="height: 44px; width: 48.4286%;">Any shipping cost which was already applied to the order.</td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">discount_total</td>
        <td style="height: 44px; width: 20%;">'0.00'</td>
        <td style="height: 44px; width: 48.4286%;">The total discount amount being applied to the order.</td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">total</td>
        <td style="height: 67px; width: 20%;">'0.00'</td>
        <td style="height: 67px; width: 48.4286%;">
          The total cost of the order, inclusive of any applicable discounts,
          taxes and shipping costs.
        </td>
        <td style="height: 67px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">created</td>
        <td style="height: 44px; width: 20%;">'2021-04-04 09:19:52'</td>
        <td style="height: 44px; width: 48.4286%;">
          The date and time that the order was created by the Ordergroove system.
        </td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">place</td>
        <td style="height: 44px; width: 20%;">'2021-05-10'</td>
        <td style="height: 44px; width: 48.4286%;">
          The date that the order will be placed into the ecommerce system
          for fulfillment.
        </td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 22px;">
        <td style="height: 22px; width: 22%;">cancelled</td>
        <td style="height: 22px; width: 20%;">null</td>
        <td style="height: 22px; width: 48.4286%;">The date that the order was cancelled.</td>
        <td style="height: 22px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">tries</td>
        <td style="height: 67px; width: 20%;">0</td>
        <td style="height: 67px; width: 48.4286%;">
          The amount of times that the Ordergroove system attempted to place
          this order into the ecommerce system.
        </td>
        <td style="height: 67px; width: 9.42857%;">integer</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">generic_error_count</td>
        <td style="height: 67px; width: 20%;">0</td>
        <td style="height: 67px; width: 48.4286%;">
          An internal counter to determine how many times an order failed to
          place due to a unknown error.
        </td>
        <td style="height: 67px; width: 9.42857%;">integer</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">type</td>
        <td style="height: 67px; width: 20%;">1</td>
        <td style="height: 67px; width: 48.4286%;">
          A order type. In most cases this value will be set to 1 to indicate
          that this is a subscription order.
        </td>
        <td style="height: 67px; width: 9.42857%;">integer</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">order_merchant_id</td>
        <td style="height: 67px; width: 20%;">null</td>
        <td style="height: 67px; width: 48.4286%;">
          This field is updated after the order is successfully placed with
          the id of the resulting order in the ecommerce system.
        </td>
        <td style="height: 67px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">rejected_message</td>
        <td style="height: 44px; width: 20%;">null</td>
        <td style="height: 44px; width: 48.4286%;">
          The reason that an order failed to place into the ecommerce system.
        </td>
        <td style="height: 44px; width: 9.42857%;">string</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">extra_data</td>
        <td style="height: 44px; width: 20%;">null</td>
        <td style="height: 44px; width: 48.4286%;">
          This field is reserved to hold any meta data tied to the order.
        </td>
        <td style="height: 44px; width: 9.42857%;">object</td>
      </tr>
      <tr style="height: 67px;">
        <td style="height: 67px; width: 22%;">locked</td>
        <td style="height: 67px; width: 20%;">false</td>
        <td style="height: 67px; width: 48.4286%;">
          This field will be set to true if the order has been locked and is
          no longer in an editable state.
        </td>
        <td style="height: 67px; width: 9.42857%;">boolean</td>
      </tr>
      <tr style="height: 44px;">
        <td style="height: 44px; width: 22%;">oos_free_shipping</td>
        <td style="height: 44px; width: 20%;">false</td>
        <td style="height: 44px; width: 48.4286%;">
          This field is used for internal purposes and can be ignored.
        </td>
        <td style="height: 44px; width: 9.42857%;">boolean</td>
      </tr>
      <tr style="height: 246px;">
        <td style="height: 246px; width: 22%;">status</td>
        <td style="height: 246px; width: 20%;">'UNSENT'</td>
        <td style="height: 246px; width: 48.4286%;">
          This field is used to determine the current status of the order.
          List of possible order status which are important to note:<br>
          <br>
          <br>
          <strong>'UNSENT'</strong><span></span>- Order will be placing some
          time in the future.<br>
          <br>
          <br>
          <strong>'SEND_NOW'</strong><span></span>- Order is currently processing
          and will be sent as soon as possible.
        </td>
        <td style="height: 246px; width: 9.42857%;">string</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## items\_by\_order

This `object` represents the mapping of all of the items which make up the customer's current set of orders. This list is arranged by the `order.public_id` to make it easier for you to link items back to the order that they belong to. Each value in this list contains an `array` of item `objects`. In order to help visualize this, we have provided a sample json object in addition to the description of each item `object` key representation below:

```json
items_by_order: {
'order123abc': [
{
order: 'order123abc',
offer: null,
subscription: 'sub123abc',
product: 'prod123abc',
components: [],
quantity: 1,
public_id: 'item123abc',
product_attribute: null,
extra_cost: '0',
one_time: false,
frozen: true,
first_placed: '..',
price: '0.00',
total_price: '0.00',
show_original_price: false
},
{
order: 'order123abc',
offer: null,
subscription: 'sub456def',
product: 'prod456def',
components: [],
quantity: 1,
public_id: 'item456def',
product_attribute: null,
extra_cost: '0',
one_time: false,
frozen: true,
first_placed: '..',
price: '0.00',
total_price: '0.00',
show_original_price: false
}
]
}
```

Each line item in the map above contains the following keys

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 21.5714%;">key</th>
        <th style="width: 15.2857%;">sample value</th>
        <th style="width: 53.5714%;">description</th>
        <th style="width: 9.42857%;">type</th>
      </tr>
      <tr>
        <td style="width: 21.5714%;">order</td>
        <td style="width: 15.2857%;">'order123abc'</td>
        <td style="width: 53.5714%;">This is the order id.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">offer</td>
        <td style="width: 15.2857%;">'offer123abc'</td>
        <td style="width: 53.5714%;">
          This is the id of an offer which is tied to this line item. Please
          note that this field is blank unless the item was added via the Instant
          Upsell feature.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">subscription</td>
        <td style="width: 15.2857%;">'sub123abc'</td>
        <td style="width: 53.5714%;">
          This is the id of the subscription that this line item is associated
          with. Please note that this field might be blank if the item was
          added via the Instant Upsell feature.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">product</td>
        <td style="width: 15.2857%;">'prod123abc'</td>
        <td style="width: 53.5714%;">
          This is the product id which is associated with this item. This is
          typically the same product id which you can use to find the product
          in your ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">components</td>
        <td style="width: 15.2857%;">[ ]</td>
        <td style="width: 53.5714%;">
          This is a list of product ids which make up this line item, if the
          line item happens to be a legacy bundle product.
        </td>
        <td style="width: 9.42857%;">array</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">quantity</td>
        <td style="width: 15.2857%;">1</td>
        <td style="width: 53.5714%;">
          This is the quantity of this product that the customer will be receiving
          as part of their order.
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">public_id</td>
        <td style="width: 15.2857%;">'item123abc'</td>
        <td style="width: 53.5714%;">This is the id of the item</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">
          product_attribute<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 15.2857%;">null</td>
        <td style="width: 53.5714%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">
          extra_cost<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 15.2857%;">null</td>
        <td style="width: 53.5714%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">one_time</td>
        <td style="width: 15.2857%;">false</td>
        <td style="width: 53.5714%;">
          This field is set to false if an item is tied to a subscription.
          If the item was added as a one-time item via Instant Upsell, then
          the value will be true.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">frozen</td>
        <td style="width: 15.2857%;">false</td>
        <td style="width: 53.5714%;">Internal to Ordergroove</td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">first_placed</td>
        <td style="width: 15.2857%;">null</td>
        <td style="width: 53.5714%;">Internal to Ordergroove</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">price</td>
        <td style="width: 15.2857%;">'0.00'</td>
        <td style="width: 53.5714%;">Individual price of an item</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">total_price</td>
        <td style="width: 15.2857%;">'0.00'</td>
        <td style="width: 53.5714%;">Price of an item after a discount has been applied to it.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 21.5714%;">show_original_price</td>
        <td style="width: 15.2857%;">true</td>
        <td style="width: 53.5714%;">
          This value is there to help determine if a pre-discount item price
          should be displayed in the <strong>Subscription Manager</strong>
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## subscriptions

This `array` represents the list of all of the customer's subscriptions. Each item in this list is a subscription `object` and contains the following fields:

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 24.2857%;">key</th>
        <th style="width: 19.1429%;">sample value</th>
        <th style="width: 47%;">description</th>
        <th style="width: 9.42857%;">type</th>
      </tr>
      <tr>
        <td style="width: 24.2857%;">customer</td>
        <td style="width: 19.1429%;">'customer123'</td>
        <td style="width: 47%;">
          This field represents your customer's id. This id is used to map
          the customer between Ordergroove and your ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">merchant</td>
        <td style="width: 19.1429%;">'abc1234556zyx'</td>
        <td style="width: 47%;">This id is used to identify you as the merchant.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">product</td>
        <td style="width: 19.1429%;">'prod123abc'</td>
        <td style="width: 47%;">
          This is the product id which is associated with this item. This is
          typically the same product id which you can use to find the product
          in your ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">payment</td>
        <td style="width: 19.1429%;">'pay123abc'</td>
        <td style="width: 47%;">
          This is the id of the payment record associated with the order.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">shipping_address</td>
        <td style="width: 19.1429%;">'ship123abc'</td>
        <td style="width: 47%;">
          This is the id of the shipping address record associated with the
          order.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">offer</td>
        <td style="width: 19.1429%;">'offer123abc'</td>
        <td style="width: 47%;">
          This is the id of an offer which is tied to this line item. Please
          note that this field is blank unless the item was added via the Instant
          Upsell feature.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">subscription_type</td>
        <td style="width: 19.1429%;">'replenishment'</td>
        <td style="width: 47%;">
          This field identifies the subscription based on a specific type.
          This is a subset of the raw_subscription_type field below. This field
          will return 'replenishment' for the following raw types:<br>
          <br>
          <br>
          - replenishment<br>
          - IU replenishment<br>
          - CSA replenishment
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">raw_subscription_type</td>
        <td style="width: 19.1429%;">'replenishment'</td>
        <td style="width: 47%;">
          This field identifies the subscription based on a specific type.
          List of possible subscription types which are important to note:<br>
          <br>
          <br>
          <strong>replenishment'</strong><span></span>- Subscription created
          via a customer's checkout<br>
          <br>
          <br>
          <strong>'IU replenishment'</strong><span></span>- Subscription created
          via the Instant Upsell feature<br>
          <br>
          <br>
          <strong>CSA replenishment</strong><span></span>- Subscriptions created
          via the customer service tool in RC3.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">components</td>
        <td style="width: 19.1429%;">[ ]</td>
        <td style="width: 47%;">
          Legacy Bundle Components.
          This is a list of product ids which make up this line item, if the
          line item happens to be a bundle product.
        </td>
        <td style="width: 9.42857%;">array</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">components</td>
        <td style="width: 19.1429%;">
          [
            {
              "public_id": "79d2dc76245111eeb185acde48001122",
              "quantity": 1,
              "product": "0070067690"
            },
            {
              "public_id": "7eeaa504245111eeb185acde48001122",
              "quantity": 3,
              "product": "0070067691"
            }
          ]
        </td>
        <td style="width: 47%;">
          New Bundle components list of objects
        </td>
        <td style="width: 9.42857%;">
          array of objects: 
         {
          public_id:string
          quantity:integer
          product:string
        }
        </td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">extra_data</td>
        <td style="width: 19.1429%;">{ }</td>
        <td style="width: 47%;">
          This field is reserved to hold any meta data tied to the subscription.
        </td>
        <td style="width: 9.42857%;">object</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">public_id</td>
        <td style="width: 19.1429%;">'sub123abc'</td>
        <td style="width: 47%;">This is the id of the subscription.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">
          product_attribute<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">quantity</td>
        <td style="width: 19.1429%;">1</td>
        <td style="width: 47%;">
          This is the quantity of this product that the customer will be receiving.
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">price</td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">
          This will indicate a subscription price<span></span><strong>only</strong><span></span>in
          cases where a customer is locked into a specific price. In most cases
          this value will be null and can be ignored.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">frequency_days</td>
        <td style="width: 19.1429%;">28</td>
        <td style="width: 47%;">
          The amount of days that a customer will go before their next shipment
          is placed
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">reminder_days</td>
        <td style="width: 19.1429%;">10</td>
        <td style="width: 47%;">
          This number will indicate how far ahead do we want to send the order
          reminder to the customer. For example a value of 10 means that we
          will send the order reminder email 10 days before this order is actually
          placed.
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">every</td>
        <td style="width: 19.1429%;">4</td>
        <td style="width: 47%;">
          This indicates how frequently this subscription will be placed. It
          is used together with the every_period field to determine the cadence.
          For example:<br>
          <br>
          <br>
          every: 4<br>
          every_period: 2<br>
          <br>
          Means that the subscription will place every 4 weeks.
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">every_period</td>
        <td style="width: 19.1429%;">2</td>
        <td style="width: 47%;">
          This indicates a time period.<br>
          <br>
          <br>
          1 = Days<br>
          2 = Weeks<br>
          3 = Months
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">start_date</td>
        <td style="width: 19.1429%;">'2021-04-04'</td>
        <td style="width: 47%;">This is the date when the subscription was first started.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">cancelled</td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">This is the date when the subscription was cancelled.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">cancel_reason</td>
        <td style="width: 19.1429%;">'Feeling overstocked'</td>
        <td style="width: 47%;">
          This is the reason that the consumer gave for why they decided to
          cancel their subscription.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">cancel_reason_code</td>
        <td style="width: 19.1429%;">1</td>
        <td style="width: 47%;">Code for the cancel reason. You can ignore this field</td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">
          iteration<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">
          sequence<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">session_id</td>
        <td style="width: 19.1429%;">'session123abc'</td>
        <td style="width: 47%;">
          The session id which was assigned to the customer during their checkout.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">merchant_order_id</td>
        <td style="width: 19.1429%;">'mid123abc'</td>
        <td style="width: 47%;">
          This is the id of the order in your ecommerce system which resulted
          in the creation of this subscription.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">
          customer_rep<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">
          club<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 19.1429%;">null</td>
        <td style="width: 47%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">created</td>
        <td style="width: 19.1429%;">'2021-04-04 10:13:26'</td>
        <td style="width: 47%;">
          The time stamp of when this subscription record was created.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">updated</td>
        <td style="width: 19.1429%;">'2021-05-10 16:50:17'</td>
        <td style="width: 47%;">
          The time stamp of when this subscription record was last updated
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 24.2857%;">live</td>
        <td style="width: 19.1429%;">true</td>
        <td style="width: 47%;">
          Determines if this subscription is still active. Once a customer
          decides to cancel their subscription, this flag will be set to false.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## localized\_product\_by\_id

This `object` represents the mapping of all of the products which the customer is currently subscribed to. This list is arranged by `product.id` and it contains the product details, translated to the current website locale. In order to help visualize this, we have provided a sample json object in addition to the description of each item `object` key representation below:

```json
localized_product_by_id: {
'prod123abc': {
merchant: 'abc1234556zyx',
groups: [{
group_type: 'sku_swap',
name: 'swap-size'
},
{
group_type: 'eligibility',
name: 'subscription'
}
],
name: 'B6 Vitamin',
price: '1.99',
image_url: 'https://mystore.com/images/b6vitamin.png',
detail_url: 'http://mystore.com/vitamins/b6vitamin',
external_product_id: 'prod123abc',
sku: '1',
autoship_enabled: true,
premier_enabled: 1,
created: '2014-05-19 18:13:43',
last_update: '2020-08-11 12:58:43',
live: true,
discontinued: false,
offer_profile: null,
extra_data: {
i18n_display: {
'fr-CA': {
name: 'B6 Vitamine',
image_url: 'https://mystore.com/fr/images/b6vitamin-fr.png',
detail_url: 'http://mystore.com/fr/vitamins/b6vitamin'
}
}
},
incentive_group: null,
product_type: 'standard',
autoship_by_default: false,
every: null,
every_period: null
}
}
```

Each product in the object above contains the following keys

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 22%;">key</th>
        <th style="width: 20.2857%;">sample value</th>
        <th style="width: 48.1429%;">description</th>
        <th style="width: 9.42857%;">type</th>
      </tr>
      <tr>
        <td style="width: 22%;">merchant</td>
        <td style="width: 20.2857%;">'abc1234556zyx'</td>
        <td style="width: 48.1429%;">This id is used to identify you as the merchant.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">groups</td>
        <td style="width: 20.2857%;">[ ]</td>
        <td style="width: 48.1429%;">
          This will contain all of the groups that a product currently belongs
          to. There are some complex use-cases within the Ordergroove system
          like sku swap that make use of this field
        </td>
        <td style="width: 9.42857%;">array</td>
      </tr>
      <tr>
        <td style="width: 22%;">name</td>
        <td style="width: 20.2857%;">'B6 Vitamins'</td>
        <td style="width: 48.1429%;">
          The name of the product. Please note that this field is localized
          so the value may be different, depending on the currently active
          website locale.
        </td>
        <td style="width: 9.42857%;">'string'</td>
      </tr>
      <tr>
        <td style="width: 22%;">price</td>
        <td style="width: 20.2857%;">'0.00'</td>
        <td style="width: 48.1429%;">
          The base price of the item as it appears in your ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">image_url</td>
        <td style="width: 20.2857%;">
          '<a href="https://.../" target="_self">https://...</a>'
        </td>
        <td style="width: 48.1429%;">
          The url of the product image. Please note that this field is localized
          so the value may be different, depending on the currently active
          website locale.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">detail_url</td>
        <td style="width: 20.2857%;">
          '<a href="https://.../" target="_self">https://...</a>'
        </td>
        <td style="width: 48.1429%;">
          The url of the product detail page. Please note that this field is
          localized so the value may be different, depending on the currently
          active website locale.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">external_product_id</td>
        <td style="width: 20.2857%;">'prod123abc'</td>
        <td style="width: 48.1429%;">
          The id of the product. This should be the same id that you use to
          identify products in your ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">sku</td>
        <td style="width: 20.2857%;">'prod_sku123abc'</td>
        <td style="width: 48.1429%;">The sku id of the product.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">autoship_enabled</td>
        <td style="width: 20.2857%;">true</td>
        <td style="width: 48.1429%;">
          This field determines if a product is currently marked as eligible
          for subscription. If this field is marked is false then visitors
          on your website will not be able to create new subscriptions tied
          to this product.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 22%;">
          premier_enabled<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 20.2857%;">null</td>
        <td style="width: 48.1429%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 22%;">created</td>
        <td style="width: 20.2857%;">'2014-05-19 18:13:43'</td>
        <td style="width: 48.1429%;">
          The time stamp of when the product was first created in our system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">last_update</td>
        <td style="width: 20.2857%;">'2020-08-11 12:58:43'</td>
        <td style="width: 48.1429%;">
          The time stamp of when the product was lasted updated in our system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">live</td>
        <td style="width: 20.2857%;">true</td>
        <td style="width: 48.1429%;">
          Determines if the product is currently in-stock in your ecommerce
          system.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 22%;">discontinued</td>
        <td style="width: 20.2857%;">false</td>
        <td style="width: 48.1429%;">Determines if the product has been discontinued.</td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 22%;">
          offer_profile<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 20.2857%;">null</td>
        <td style="width: 48.1429%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 22%;">extra_data</td>
        <td style="width: 20.2857%;">{ }</td>
        <td style="width: 48.1429%;">
          This field is reserved to hold any meta data tied to the product.
          A common data element which can be found here would be the localization
          of product name, image and url.
        </td>
        <td style="width: 9.42857%;">object</td>
      </tr>
      <tr>
        <td style="width: 22%;">incentive_group</td>
        <td style="width: 20.2857%;">null</td>
        <td style="width: 48.1429%;">Any custom incentive group that this product may belong to.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 22%;">product_type</td>
        <td style="width: 20.2857%;">'standard'</td>
        <td style="width: 48.1429%;">
          This field will return 'standard' for regular products and 'bundle'
          for products that contain other product components for legacy bundles.
  				New bundles integration uses 'dynamic price bundle' and 'static price bundle'
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22%;">autoship_by_default</td>
        <td style="width: 20.2857%;">false</td>
        <td style="width: 48.1429%;">
          If this field is set to true, then the default choice for a customer
          when they are browsing the product on a product detail page will
          be to subscribe to this product.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 22%;">
          every<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 20.2857%;">null</td>
        <td style="width: 48.1429%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 22%;">
          every_period<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 20.2857%;">null</td>
        <td style="width: 48.1429%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## address\_by\_id

This `object` represents the mapping of all of the customer addresses records, keyd to the address id. In order to help visualize this, we have provided a sample json object in addition to the description of each item `object` key representation below:

```json
address_by_id: {
'address123abc': {
customer: 'customer123',
public_id: 'address123abc',
label: null,
first_name: 'Harry',
last_name: 'Potter',
company_name: 'Hogwarts',
address: 'Platform 9¾',
address2: 'Kings Cross Station',
city: 'London',
state_province_code: null,
zip_postal_code: 'N1 9AP',
phone: '555-555-5555',
fax: null,
country_code: 'GB',
live: true,
created: '2021-04-26 16:40:00',
token_id: null,
store_public_id: null
}
}
```

Each address in the object above contains the following keys

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 22.2857%;">key</th>
        <th style="width: 19.8571%;">sample value</th>
        <th style="width: 48.2857%;">description</th>
        <th style="width: 9.42857%;">type</th>
      </tr>
      <tr>
        <td style="width: 22.2857%;">customer</td>
        <td style="width: 19.8571%;">'customer123'</td>
        <td style="width: 48.2857%;">
          This field represents your customer's id. This id is used to map
          the customer between Ordergroove and your ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">public_id</td>
        <td style="width: 19.8571%;">'address123abc'</td>
        <td style="width: 48.2857%;">The id of this address record.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">label</td>
        <td style="width: 19.8571%;">'home'</td>
        <td style="width: 48.2857%;">A custom label for the address if one exists.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">first_name</td>
        <td style="width: 19.8571%;">'Harry'</td>
        <td style="width: 48.2857%;">
          The first name of person for whom the shipment is meant for.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">last_name</td>
        <td style="width: 19.8571%;">'Potter'</td>
        <td style="width: 48.2857%;">The last name of person for whom the shipment is meant for.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">company_name</td>
        <td style="width: 19.8571%;">'Hogwarts'</td>
        <td style="width: 48.2857%;">The name of the company tied to the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">address</td>
        <td style="width: 19.8571%;">'Platform 9¾'</td>
        <td style="width: 48.2857%;">
          The first line of the address which typically includes a street names
          and house number.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">address2</td>
        <td style="width: 19.8571%;">'Kings Cross Station'</td>
        <td style="width: 48.2857%;">
          The second line of the address which is typically used to specify
          additional address details such as apartment number.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">city</td>
        <td style="width: 19.8571%;">'London'</td>
        <td style="width: 48.2857%;">The city of the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">state_province_code</td>
        <td style="width: 19.8571%;">null</td>
        <td style="width: 48.2857%;">The state, province or region of the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">zip_postal_code</td>
        <td style="width: 19.8571%;">'N1 9AP'</td>
        <td style="width: 48.2857%;">The zip or postal code of the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">phone</td>
        <td style="width: 19.8571%;">'555-555-5555'</td>
        <td style="width: 48.2857%;">The phone number tied to the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">fax</td>
        <td style="width: 19.8571%;">null</td>
        <td style="width: 48.2857%;">The fax number tied to the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">country_code</td>
        <td style="width: 19.8571%;">'GB'</td>
        <td style="width: 48.2857%;">The two-letter country code tied to the address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">live</td>
        <td style="width: 19.8571%;">true</td>
        <td style="width: 48.2857%;">
          Determines if an address is currently actively tied to an upcoming
          order or subscription.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">created</td>
        <td style="width: 19.8571%;">'2021-04-04 16:40:00'</td>
        <td style="width: 48.2857%;">The time stamp of when the address record was created.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">
          token_id<br>
          <strong>DEPRECATED</strong>
        </td>
        <td style="width: 19.8571%;">null</td>
        <td style="width: 48.2857%;">This field is no longer in use.</td>
        <td style="width: 9.42857%;">&nbsp;</td>
      </tr>
      <tr>
        <td style="width: 22.2857%;">store_public_id</td>
        <td style="width: 19.8571%;">'store123'</td>
        <td style="width: 48.2857%;">The id of the physical store that is tied to this address.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>

***

## payment\_by\_id

This `object` represents the mapping of all of the customer payment records, keyed to the payment id. In order to help visualize this, we have provided a sample json object in addition to the description of each item `object` key representation below:

```
payment_by_id: {
'payment123abc': {
customer: 'customer123',
billing_address: 'address123abc',
cc_number_ending: '1111',
public_id: 'payment123abc',
label: null,
token_id: 'token123',
cc_holder: 'Harry Potter',
cc_type: 1,
cc_exp_date: '12/2023',
payment_method: 1,
live: true,
created: '2021-04-04 09:46:38',
last_updated: '2021-05-10 14:29:38'
}
}
```

Each payment record in the object above contains the following keys

<HTMLBlock>
  {`
  <table style="border-collapse: collapse; width: 100%;" border="1">
    <tbody>
      <tr>
        <th style="width: 20.7143%;">key</th>
        <th style="width: 21.1429%;">sample value</th>
        <th style="width: 48.5714%;">description</th>
        <th style="width: 9.42857%;">type</th>
      </tr>
      <tr>
        <td style="width: 20.7143%;">customer</td>
        <td style="width: 21.1429%;">'customer123'</td>
        <td style="width: 48.5714%;">The id of the customer tied to this payment record.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">billing_address</td>
        <td style="width: 21.1429%;">'address123abc'</td>
        <td style="width: 48.5714%;">The id of the billing address tied to this billing record.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">cc_number_ending</td>
        <td style="width: 21.1429%;">'1111'</td>
        <td style="width: 48.5714%;">The last four digits of the credit card number.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">public_id</td>
        <td style="width: 21.1429%;">'payment123abc'</td>
        <td style="width: 48.5714%;">The id of the payment record.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">label</td>
        <td style="width: 21.1429%;">null</td>
        <td style="width: 48.5714%;">A custom label for the address if one exists.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">token_id</td>
        <td style="width: 21.1429%;">'token123'</td>
        <td style="width: 48.5714%;">
          The payment token id that is stored in the ecommerce system.
        </td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">cc_holder</td>
        <td style="width: 21.1429%;">'Harry Potter'</td>
        <td style="width: 48.5714%;">The name of the account holder.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">cc_type</td>
        <td style="width: 21.1429%;">1</td>
        <td style="width: 48.5714%;">
          The credit cart issuer that this payment record is associated with.
          You can find the full list below:<br>
          <br>
          <strong>1</strong><span></span>- Visa<br>
          <strong>2</strong><span></span>- Mastercard<br>
          <strong>3</strong><span></span>- American Express<br>
          <strong>4</strong><span></span>- Discover<br>
          <strong>5</strong><span></span>- Diners<br>
          <strong>6</strong><span></span>- JCB
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">cc_exp_date</td>
        <td style="width: 21.1429%;">'12/2023'</td>
        <td style="width: 48.5714%;">The month and year of that the credit card expires.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">payment_method</td>
        <td style="width: 21.1429%;">1</td>
        <td style="width: 48.5714%;">
          The payment method tied to this payment record. You can find the
          fully list below:<br>
          <br>
          <strong>1</strong><span></span>- Credit Card<br>
          <strong>2</strong><span></span>- PayPal
        </td>
        <td style="width: 9.42857%;">integer</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">live</td>
        <td style="width: 21.1429%;">true</td>
        <td style="width: 48.5714%;">
          Determines if this payment record is currently tied to an upcoming
          order or subscription.
        </td>
        <td style="width: 9.42857%;">boolean</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">created</td>
        <td style="width: 21.1429%;">'2021-04-04 09:46:38'</td>
        <td style="width: 48.5714%;">The time stamp of when the payment record was created.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
      <tr>
        <td style="width: 20.7143%;">last_updated</td>
        <td style="width: 21.1429%;">'2021-05-10 14:29:38'</td>
        <td style="width: 48.5714%;">The time stamp of when the payment record was last updated.</td>
        <td style="width: 9.42857%;">string</td>
      </tr>
    </tbody>
  </table>
  `}
</HTMLBlock>