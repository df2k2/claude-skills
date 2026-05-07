# Curation Subscriptions: Rotating Box or Club

Ordergroove supports a subscription of rotating products. Customers receive a different box (products) each shipment.

For general information take a look at the [Knowledge Center](https://help.ordergroove.com/hc/en-us/articles/360054621814-Curation-Running-a-Rotating-Box-or-Club). In this guide we'll go through how to set it up.

> 📘 Platform
>
> There are two separate methods to add curation to your store, but Ordergroove cannot send custom components to all eCommerce platforms. For merchants on *BigCommerce*, you must use the first method - *Rotate The Product Downstream*.

***

## Method 1 - Rotate The Product Downstream of Ordergroove

This is the simplest integration with the Ordergroove platform. Merchants create a SKU to represent the box or club (e.g. BEAUTYBOX), and Ordergroove will pass that same SKU back to the e-commerce platform for each recurring order.

From there, the merchant can map that SKU to the fulfillable components for each order (e.g. LIPS1, EYES2, FOUNDATION3, etc.).

This mapping can take place within the e-commerce platform, OMS, or warehouse.

***

## Method 2 - Rotate The Products Using Ordergroove Subscription Components

This integration option allows you to store the box/club components directly within Ordergroove using the components array on the subscription model. In this scenario, Ordergroove will explicitly pass the fulfillable component SKUs (e.g. LIPS1, EYES2, FOUNDATION3, etc.) when creating the recurring order in the eCommerce platform.

The merchant is then responsible for rotating the subscription components by using Ordergroove’s REST APIs prior to the next order.

This data model can allow customers to select their own unique components for their box.