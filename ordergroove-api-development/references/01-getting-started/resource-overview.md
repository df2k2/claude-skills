# Resource Overview

Ordergroove’s data model is built around four core resources: Customers, Subscriptions, Orders, and Items. Resource Extensions allow you to enrich a primary resource with its related data, reducing the need for multiple API calls and providing a more complete picture of a customer's state in a single interaction.

By using extensions, you can "link" resources together—for example, including a customer’s saved addresses and payment methods when retrieving their subscription details.

***

## Core Resources at a Glance

* Customers: The central profile containing contact info, linked addresses, and payment methods.
* Subscriptions: The recurring logic that dictates when and how often a customer receives a product.
* Orders: The records created by subscriptions that are sent to your eCommerce platform for fulfillment.
* Items: The individual products contained within an order or tied to a subscription.

***

## Enriching Webhook Payloads

While Resource Extensions can be used across the Ordergroove platform, they are most commonly configured to enrich Webhook payloads. By configuring extensions in your Ordergroove Dashboard, you can ensure that every event notification includes the specific related data your system needs to process the update.

### The Snapshot Object

When extensions are enabled for webhooks, the payload includes a `snapshot` object containing the selected resources.

* **Single Objects**: The `customer` resource is always returned as a single object within the snapshot.
* **List Objects**: All other resources—such as `subscriptions`, `orders`, and `items`—are returned as list objects, even if only a single record exists.

For an example payload, see [Installing Webhooks 2.0](https://developer.ordergroove.com/reference/webhooks-20).

***

## Available Resources

The table below outlines the core resources, the endpoints used to access them, and the related data available through Resource Extensions.

<Table align={["left","left","left","left","left"]}>
  <thead>
    <tr>
      <th>
        Resource
      </th>

      <th>
        Endpoints
      </th>

      <th>
        Webhook Events
      </th>

      <th>
        Webhook Expansions
      </th>

      <th>
        Filtering
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        **Customers**
      </td>

      <td>
        `GET /customers/`\
        `GET /customers/{id}/`
      </td>

      <td>
        subscriber.create\
        subscriber.cancel\
        subscriber.subscriptions\_created
      </td>

      <td>
        Subscriptions\
        Addresses\
        Payments\
        Products
      </td>

      <td>
        updated\
        created\
        updated\_start\
        updated\_end\
        created\_start\
        created\_end
      </td>
    </tr>

    <tr>
      <td>
        **Subscriptions**
      </td>

      <td>
        `GET /subscriptions/`\
        `GET /subscriptions/{id}/`
      </td>

      <td>
        subscription.created\
        subscription.cancel\
        subscription.sku\_swap\
        subscription.change\_live\
        subscription.change\_frequency\
        subscription.change\_components\
        subscription.change\_quantity\
        subscription.change\_shipping\_address\
        subscription.change\_payment\
        subscription.refresh\_one\_click\_token
      </td>

      <td>
        Customer\
        Addresses\
        Payments\
        Products
      </td>

      <td>
        updated\
        created\
        updated\_start\
        updated\_end\
        created\_start\
        created\_end\
        customer
      </td>
    </tr>

    <tr>
      <td>
        **Orders**
      </td>

      <td>
        `GET /orders/`\
        `GET /orders/{id}/`
      </td>

      <td>
        order.change\_shipping\_address\
        order.change\_payment\
        order.change\_next\_order\_date\
        order.skip\_order\
        order.send\_now\
        order.cancel\
        order.success\
        order.delete\
        order.generic\_error\
        order.reject\
        order.reminder\
        order.retryable\_placement\_failure\
        order.refresh\_one\_click\_token
      </td>

      <td>
        Customer\
        Subscription\
        Items\
        Addresses\
        Payments\
        Products
      </td>

      <td>
        updated\
        created\
        updated\_start\
        updated\_end\
        created\_start\
        created\_end\
        status\
        customer
      </td>
    </tr>

    <tr>
      <td>
        **Items**
      </td>

      <td>
        `GET /items/`\
        `GET /items/{id}/`
      </td>

      <td>
        item.create\
        item.change\_quantity\
        item.remove\
        item.item\_subscribe\
        item.update\_price\
        item.successfully\_placed\
        item.out\_of\_stock
      </td>

      <td>
        Customer\
        Subscription\
        Orders\
        Addresses\
        Payments\
        Products
      </td>

      <td>
        order\_updated\
        order\_updated\_start\
        order\_updated\_end\
        product\
        order\
        omit\_price\_calculation\
        subscription
      </td>
    </tr>
  </tbody>
</Table>

<br />