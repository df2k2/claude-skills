# Troubleshooting Webhooks

Troubleshoot Webhooks from the Developers > <Anchor label="Webhooks" target="_blank" href="https://rc3.ordergroove.com/webhooks/">Webhooks</Anchor> section of the Ordergroove admin. It includes a Deliveries Search filterable by Customer ID, Customer Email, Event ID, Object ID, delivery status (Pending, Success, Canceled, Failed), and event type, plus a Metrics Summary covering Failed, Successful, Successful Retries, and Pending Deliveries for each webhook route.

***

## Searching deliveries sent to webhook route

If users need to track down and analyze specific webhook event deliveries, our system has a search tool that helps with this task.

This becomes especially useful when troubleshooting an error in delivery, verifying the status of a recent event or conducting a routine audit of the webhook traffic. The tool offers a wide range of filters in order to narrow down the results and make the searching process easier.

In order to search for deliveries happening in the context of a given webhook, follow these steps:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to Developers > Webhooks.
3. Locate the webhook you want to enable, click the **3 dots**, and select **Details**.

<Image align="center" src="https://files.readme.io/e098914-image7_details_clean.png" />

4. Under the “Deliveries Search” section there is a search bar that helps the user track down the desired webhooks deliveries by providing filters on different fields.

* **Customer ID**: Customer identifier in the client’s system that is involved in the event being looked for.
* **Customer Email**: Customer email that is involved in the event being looked for.
* **Event ID**: Internal Ordergroove identifier of an event. Normally useful when getting the id in a previous search and need to quickly jump to a specific event to resume inspecting it.
* **Object ID**: Subscription public ID, order public ID, item public ID or customer id involved in the event. The first three refer to Ordergroove public ids for the different entities (these are widely used in our REST APIs) while the last one is the customer identifier in the client’s system. For example, if we are searching for events tied to subscription ID X, the results can include a `subscription.cancel` event tied to the corresponding subscription whose webhook was successfully delivered 5 minutes ago.

<Image align="center" src="https://files.readme.io/26efebe-image5.png" />

5. **Select** the desired filter, **enter** the value to search by, and **click the magnifying glass** button at the right of the search bar to see the results.
6. Two extra filters can be applied by selecting the icons in the first two columns of the results table. These let you filter by:

* **Delivery status**: Possible options are:
  * Pending: Deliveries currently in transit. This includes both first-time deliveries and those being retried.
  * Success: Deliveries successfully transmitted to the target.
  * Canceled: Deliveries that were in transit at the webhook route was disabled or deleted and had to be canceled.
  * Failed: Deliveries that failed to be transmitted to the target.
* **Event type**: Filter will display the currently existing event types the user can filter by.

<Image align="center" width="60% " src="https://files.readme.io/3c8f5b1-image2.png" />

<Image align="center" width="70% " src="https://files.readme.io/f44fd0f-image1.png" />

7. When you click on a row of the displayed results, a card is displayed to show the details of the selected delivery. These include useful information such as the request sent to the target, the response received, the number of attempts that had to be made, among others.

<Image align="center" width="80% " src="https://files.readme.io/a7b0dbd-image8.png" />

***

## Watching webhook route metrics

Ordergroove makes available some high level metrics for each of the existing webhook routes so that the user can have a quick summary on how the webhooks are performing.

You can view the metrics from the webhooks dashboard:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to Developers > Webhooks.
3. Locate the webhook you want to enable, click the **3 dots**, and select **Details**.

<Image align="center" src="https://files.readme.io/e098914-image7_details_clean.png" />

4. In the *Metrics Summary* section of the selected webhook route, users can access various key metrics related to webhook deliveries.

* **Failed Deliveries**: This metric shows the number of webhook events that failed to reach the target, either due to initial sending failures or successive error responses from the target. It includes events that have been retried but ultimately failed, in line with our [retry policy](https://developer.ordergroove.com/docs/configuring-your-server-for-ordergroove-webhooks#retry-policy). A high number in this category may indicate issues with the integration, such as network problems or misconfigurations at the target endpoint. In such cases, reviewing the target endpoint’s error logs and configurations is recommended.
* **Successful Deliveries**: Represents the total number of webhook events that were successfully delivered to the target. This indicates the events that were received and acknowledged by the target without any issues.
* **Successful Retries**: A subset of the 'Successful Deliveries', this metric counts the deliveries that were initially unsuccessful but eventually succeeded upon retrying. This figure can be useful for identifying transient issues that may affect delivery success.
* **Pending Deliveries**: These are deliveries currently in transit. This includes both first-time deliveries and those being retried. Pending status indicates that these deliveries are either awaiting response from the target or are scheduled to be retried according to the retry policy.