# Build Your Own Box Subscriptions (Legacy)

Ordergroove supports subscriptions with multiple bundle components, allowing customers to have a subscription to a single product but configure a variety of items within that subscription for a set price.

Customers with subscriptions to bundles can easily manage their bundle with out-of-the-box capabilities from Ordergroove such as changing the upcoming order date, skipping, sending now, updating the frequency, and more.

For general information take a look at the [Knowledge Center](https://help.ordergroove.com/hc/en-us/articles/7050551420947-Build-Your-Own-Box-Subscriptions). In this guide we'll go through how to set it up.

> 📘 Platform Note
>
> For merchants on Shopify - the process looks a little different. Take a look at [Build Your Own Box Subscriptions on Shopify](https://developer.ordergroove.com/docs/build-your-own-box-subscriptions-on-shopify) for platform specific instructions.

***

## Background Information

* Ordergroove does a stock status check at the time of order placement, including the stock of bundle components. If one or more of those components is out of stock, the order will enter the OOS flow. If a customer updates their components at that point, it will not update the components on the order that is already in the OOS flow. You will need to call the [order item update API](https://og-restrpc.readme.io/reference#update-2) if you wish to update that order as well.
* If utilizing Ordergroove offers for bundle enrollment, customers are limited to a single bundle per checkout. Custom enrollment experiences can support multiple bundles in a single checkout.
* Ordergroove does not expose bundle components within Ordergroove. We recommend utilizing login-on-behalf functionality if your customer service agents need to manage bundles on behalf of customers.
* Ordergroove does not validate for the number of components, or which components, can be associated with a bundle. If all product IDs included in API requests exist in the Ordergroove database, bundle components will be created.

***

## Step 1: Enrollment

**Ordergroove creates the Bundle Subscription upon checkout completion**

The component IDs should correspond to the product\_id of products passed from your eCommerce system to Ordergroove via the product feed. Bundle components do not have a quantity attribute, so if a customer wishes to receive more than one of a single component product, it needs to be passed multiple times within the og-offer components tag.

When a customer completes checkout, you can pull the subscription information that Ordergroove has been tracking throughout the session by calling the function OG.getOptins(). This function will provide you with a products array that includes the subscription info as well as components set in the offer.

In this example, a subscription will be created for product A1234567. Product B987654 will get created as 2 bundle components, C000000 will get created as 5 bundle components, and D111111 as 4 bundle components.

```Text Example
<og-offer product="A1234567" product-components="["B987654","B987654","C000000","C000000","C000000","C000000","C000000","D111111","D111111","D111111","D111111"]">
```

***

## Step 2: Showing Bundle Components in the Subscription Manager

To show bundle components in the Subscription Managerto a customer, you will need to apply code in two places within the advanced editor.

Add a new function into **scripts/script.js**

Then add the following code anywhere in the script.js:

```javascript
const group_order_components = og.smi.memoize((components) => {
  return Object.values(
    (components || []).reduce((acc, cur) => {
      acc[cur.product] = acc[cur.product] || {
        component: cur.product,
        quantity: 0,
      };
      acc[cur.product].quantity++;
      return acc;
    }, {})
  );
});
const ensure_product_meta_data = og.smi.memoize((id) => {
  og.smi.request_product(id);
});
```

Add new liquid code into **orders-unsent.liquid**.

```liquid
{% set components_with_quantity = 'group_order_components(order_item.components)' | js %}
{% if components_with_quantity.length %}
  <div>
    {% for component, quantity in components_with_quantity %}
    {{ 'ensure_product_meta_data(component)' | js }}
    {% set product_component = products | find(id=component) %}
    {% if product_component %}
      {{quantity}} {{ product_component.name }} <br/>
    {% endif %}
    {% endfor %}
  </div>
{% endif %}
```

If you have an active account with a bundle you should see something like the image below in the Subscription Manager with the components of the bundle defined.

<Image align="center" width="600px" src="https://files.readme.io/3acdc2c-monica-SMI_-_Next_Shipment1.jpg" />

***

## Step 3: Receiving Subscription Orders Containing Bundle Subscriptions

In the order XML passed from Ordergroove to your platform, an additional \<components> node will be included under the applicable order item and will contain the product IDs of each component in the bundle. Similar to the Purchase POST, each component represents a single unit, and duplicate components will be listed individually. You can see an example of how components are sent in the order XML by visiting our [Recurring Order Placement](https://help.ordergroove.com/hc/en-us/articles/4970515154963-Recurring-Order-Placement#a2) article in the Knowledge Center.

***

## Step 4 (optional): Building a Customer-Facing Experience for Editing Components

**Retrieving Existing Bundle Configurations**

To build a front end experience to enable customers to manage their bundle components, you’ll first need to retrieve the components of the bundle subscription from the list of all items by order that are returned to the Subscription Manager frontend for a particular user. The items by order list will contain the id for the subscription that can be used to retrieve the components.

**Updating New Bundle Configurations**

To allow a customer to update their components within a bundle, you will need to expose a link or button for that subscription row that either links to an editor experience directly in the Subscription Manager (a popup for example), or redirect the customer to your bundle page to make changes. An action link or button will need to be added to the liquid template to direct the customer to the configuration experience.

Either option should collect the new components from the customer and then update them to Ordergroove by making a PATCH request to the [Update Subscription API](https://og-restrpc.readme.io/reference#update) using the subscription public\_id from the retrieve subscription step above. As this is a PATCH, anything passed in this request will update any existing values stored for bundle components and subscription extra data, so be sure to include any extra\_data that was retrieved in the previous request if required.