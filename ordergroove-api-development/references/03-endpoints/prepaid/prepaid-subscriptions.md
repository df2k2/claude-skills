# Prepaid subscriptions

After [enabling prepaid subscriptions](https://help.ordergroove.com/hc/en-us/articles/13542233192467-Enabling-Prepaid-Subscriptions-from-start-to-finish), you will be able to use all prepaid endpoints to control the prepaid subscription

# Prepaid subscriptions data

The field called **prepaid\_subscription\_context** is present on subscription objects. It represents the information about the subscription the customer prepaid. In cases where the subscription is not a prepaid subscription, this field will be null.

Those are the additional fields in a prepaid subscription:

* **prepaid\_orders\_remaining**: An integer value representing the number of shipments the customer is still owed before their prepaid subscription should renew. For example, if the value of this field is 0, the next order placed that contains an item for this subscription will renew the prepaid subscription.
* **prepaid\_orders\_per\_billing**: An integer value representing the length of the prepaid subscription cycle in terms of number of shipments the customer will receive per instance they are billed. For example, if the value of this field is 3, that means they are billed for 3 shipments every time they are charged and will receive 2 shipments free of charge for each occasion they are charged.
* **renewal\_behavior**: A string field representing what action will occur when the customer has received their last free shipment.
* **last\_renewal\_revenue**: A float value representing how much the customer paid for in the last prepaid renewal order placed. The renewal order can be either the checkout order that captured the initial funds or the subsequent prepaid renewal orders
* **prepaid\_origin\_merchant\_order\_id**: A string field representing the merchant order id (the ecommerce platform order id) for the order that was responsible for capturing the funds for the current prepaid subscription cycle.

Prepaid subscription **renewal\_behavior** options:

* **autorenew**: Renew and bill the customer a full prepaid cycle after all orders are placed. The renewal happens when the first order of the next cycle is placed.
* **cancel**: When all orders are placed the subscription is cancelled. Customers can reactivate it to start a new prepaid cycle
* **downgrade**: Turns the prepaid subscription to a normal subscription when all orders are placed. The next order placed for the subscription will have the price of a single shipment.