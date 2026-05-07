# Bundle API Components

Ordergroove has APIs to manage multi-product subscriptions. Here is a high-level diagram of the different entities involved and how they relate to one another:

<Image align="center" src="https://files.readme.io/f4c3c6b-Understanding_Bundles.jpg" />

The *Order* entity represents a shipment the customer will receive or has received. Each Item associated with that order encapsulates a single product and its associated quantity within the shipment.

If you offer box-subscriptions, many items within a single order will be associated with a single **Subscription**. Further, each subscription will have an associated set of **Components**. Each component encapsulates a specific product and quantity the customer has subscribed to in their box subscription.

While each item in the box will be associated with a single subscription, each item will also be associated with a distinct component. You can think of **components** as line-items at the subscription level, while **items** are the line-items at the order level.

***

# Overview

> 📘 Version
>
> The endpoint changes listed in this doc refer to the new Bundles Suite. If you use Legacy Bundles, take a look at [Build your Own Box Subscriptions](https://developer.ordergroove.com/docs/build-your-own-box-subscriptions).

Bundles subscriptions, items, and components can be viewed or changed in these endpoints:

### Updating bundles endpoints

* [Subscription components update endpoint](https://developer.ordergroove.com/reference/update-components)  can manage all components in a subscription bundle. You can create, update, and delete bundle components

### Getting bundles information endpoints

* [Component endpoint](https://developer.ordergroove.com/reference/retrieve-component) returns all information of a bundle subscription component (public\_id, quantity, and product)
* [Subscription endpoints](https://developer.ordergroove.com/reference/subscriptions-list) return a `components` field that will return all components linked to that subscription. The components structure changes from legacy to new Bundles integration
* [Item endpoints](https://developer.ordergroove.com/reference/items-list) return the subscription\_component id of the component that controls it