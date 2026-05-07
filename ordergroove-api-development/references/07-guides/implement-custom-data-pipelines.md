# Implement Custom Data Pipelines

This article provides a guide on how to set up your own custom data pipelines to sync Ordergroove data using Ordergroove Rest APIs. This article provides a detailed walk through of fetching data, handling pagination, scheduling ETL jobs.

***

## Architecture Template

Ordergroove recommends the following steps around how to architect the ingestion:

1. Schedule a job that triggers an Ordergroove data sync.
2. Configure a separate thread for each endpoint (subscriptions, items, orders, etc.), call the API with `updated_start` set to the start time of the last sync as a cutoff timestamp.
3. Page through all results using the cursor-based pagination until all new data is retrieved.
4. Load the data into the warehouse, upserting into destination tables.
5. Store the start time of this job in your system to use it as an update timestamp filter for the next run.

***

## API Access and Prerequisites

Before you can sync data, make sure you have the proper API access:

1. **API Key**: Ordergroove uses API key authentication for its APIs. See [Authentication](https://developer.ordergroove.com/reference/authentication#key-retrieval-and-sample-code) for more information.
2. **Permissions**: Your API key must have the “Bulk” scope/permissions to read the data for data syncing. Test your key with a simple call (e.g., list customers) to verify access. If you receive 401/403 errors, check that the key is correct and has read permissions.
3. **Testing Environment**: If you have a staging Ordergroove environment, you might first test your pipelines against the test environment.
4. **Data Model Understanding**: Familiarize yourself with the JSON structure of each endpoint by reviewing the [Ordergroove API reference](https://developer.ordergroove.com/reference/introduction) or making sample calls. Understanding these fields helps in designing your warehouse schema (e.g. you might have separate tables for orders and order\_items, linked by an order ID).
5. **Logging and Monitoring**: Implement logging for each sync run, including the number of records fetched and timestamps. This helps in troubleshooting if something goes wrong (e.g., if an expected update was missed, you can check if it was fetched or not).

***

## Reference – API Endpoints and Capabilities

Below is a reference table of the main Ordergroove API endpoints for data sync, indicating which support the incremental fetch using `updated_start` filter for incremental loads and which support cursor-based pagination (API v2):

| Endpoint (GET list)                                                                                   | Supports Incremental Fetch updated\_start                                                       | [Cursor-Based Pagination](https://developer.ordergroove.com/reference/pagination#:~:text=Fetching%20Additional%20Results%20with%20Cursor,Pagination) |
| :---------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------- |
| [Customers](https://developer.ordergroove.com/reference/customers-list) (/customers/)                 | Yes – filter by updated datetime is available.                                                  | Yes                                                                                                                                                  |
| [Subscriptions](https://developer.ordergroove.com/reference/subscriptions-list) (/subscriptions/)     | Yes – filter by updated datetime is available.                                                  | Yes                                                                                                                                                  |
| [Orders](https://developer.ordergroove.com/reference/orders-list) (/orders/)                          | Yes – filter by updated datetime is available.                                                  | Yes                                                                                                                                                  |
| [Items](https://developer.ordergroove.com/reference/items-list) (/items/)                             | Yes – filter by updated datetime is available - the filter is named **“order\_updated\_start”** | Yes                                                                                                                                                  |
| [Addresses](https://developer.ordergroove.com/reference/addresses-list) (/addresses/)                 | Yes – filter by updated datetime is available                                                   | Yes                                                                                                                                                  |
| [Payments](https://developer.ordergroove.com/reference/payments-list) (/payments/)                    | **No** – `updated_start` not supported (must fetch all).                                        | Yes                                                                                                                                                  |
| [Products](https://developer.ordergroove.com/reference/products-list) (/products/)                    | **No** – `updated_start` not supported (must fetch all).                                        | Yes                                                                                                                                                  |
| [Offer Profiles](https://developer.ordergroove.com/reference/offer-profile-list) (/offer\_profiles/)  | **No** – `updated_start` not supported (must fetch all).                                        | Yes                                                                                                                                                  |
| [One-Time Incentives](https://developer.ordergroove.com/reference/otd-list) (/one\_time\_incentives/) | **No** – `updated_start` not supported (must fetch all).                                        | Yes                                                                                                                                                  |

**Notes:**

* For Products and Payments since Ordergroove keeps a copy of what’s already in the ecommerce system, you should not need to sync this data
* All “Yes” for cursor-based pagination assumes you include the `X-OG-API-VERSION: 2` header on your requests ​[developer.ordergroove.com](https://developer.ordergroove.com/reference/pagination#:~:text=Cursor%20Based%20Pagination%20in%20List,Endpoints). Without that, the API might default to an older page-index method **(not recommended)**.

***

## Use Incremental Fetch Logic with `updated_start field`

Incremental sync means fetching only records that have changed (created or updated) since your last sync run, rather than pulling all data every time. Using incremental fetch will allow you run the job faster and will cost less in terms of time and resources to keep your data fresh. Ordergroove’s list endpoints support filtering by an update timestamp except Payments and Products list endpoints. The key query parameter is `updated_start`, which accepts a date-time (CST timezone) and returns all objects updated *on or after* that timestamp. This allows you to pick up new and modified records incrementally.

**How to use updated\_start**: For each API resource, specify `?updated_start=<datetime>` in the request. For example, to fetch subscriptions updated since January 1, 2025, you would call:

`GET /subscriptions/?updated_start=2025-01-01T12:00:00`

This would return all subscriptions whose `updated` date is 2025-01-01 (CST) or later. On initial creation, an object’s updated timestamp is set to its created date, so newly created records are captured by the filter as well. Typically, you would store the start time of the last sync timestamp in your system, and on the next run use that as the `updated_start` to fetch changes.

**Exceptions:**

**Products, Payments, OfferProfiles and OneTimeDiscounts** list endpoints do not provide incremental fetch options, so if you need to pull these you will need to do a full refresh.

This is due to a combination of practical usage patterns and data volume considerations:

* Products and Payments are typically sourced directly from the merchant's commerce platform (e.g., Shopify, Salesforce, etc.), and are often available in the merchant’s primary system of record. As a result, most merchants do not rely on Ordergroove as the authoritative source for this data, and incremental sync for these endpoints has not been prioritized.
* Offer Profiles and One-Time Discounts are relatively lightweight datasets, and their size makes it feasible to retrieve the full set on each sync. A full refresh is efficient and does not pose performance concerns.

Support for incremental sync on these endpoints may be considered in the future based on demand and evolving merchant use cases, but as of now, full refresh is the recommended approach.

***

## How to set up Initial Sync and Full Refresh

> 📘 Not all merchants need to backfill data. If you're launching a new subscription program or don't have historical subscription data to import, you can skip this step.

In order to set up an initial sync (or any full refresh), you simply omit the `updated_start` parameter to fetch all records from an endpoint. This will retrieve the entire history/dataset for that resource. In practice, the API call is the same as incremental – e.g. `GET /orders/ `without any date filters will return all orders.

If you experience longer response times (e.g >20s), you might perform the initial load in segments (for instance, by using `updated_start and updated_end` with yearly, or monthly ranges) to reduce response time but otherwise using the pagination (discussed next) is sufficient. After the initial load, you’ll switch to using `updated_start` with the last updated timestamp from your warehouse to only get new/changed records going forward.

### Pagination (Cursor-Based)

You should only use cursor based pagination with Rest APIs for data syncing use case, which ensures stable paging even as data changes. By default, a list request returns 10 results if not specified, but you can control the page size up to 100 records using the `page_size` parameter​ [developer.ordergroove.com](https://developer.ordergroove.com/reference/pagination#:~:text=By%20default%2C%20List%20endpoints%20return,results). When there are more records to fetch, the response will include a `next` URL (and a `previous` URL if applicable) containing a `cursor` parameter ​[developer.ordergroove.com](https://developer.ordergroove.com/reference/pagination#:~:text=Fetching%20Additional%20Results%20with%20Cursor,Pagination). To get the subsequent page of results, you simply make a request to the `next` URL provided. This `cursor` is an opaque pointer that the server uses to maintain your position in the dataset.

You can read more on how to use Cursor based pagination [here](https://developer.ordergroove.com/reference/pagination#:~:text=Fetching%20Additional%20Results%20with%20Cursor,Pagination).

**Do not use page-index based pagination** (e.g. `?page=2`) as it is deprecated and can lead to inconsistencies – always stick to the cursor method with API v2. Cursor pagination ensures you won’t miss or duplicate records if new updates arrive during paging​

### ETL Scheduling and Automation

We recommend scheduling an incremental daily data sync between 12pm CST and 8pm CST, when most order placement activity has completed. This helps ensure you capture a full day of data. If more fresh insights are needed you can schedule it twice a day.

Many teams use orchestrators like [Airflow](https://airflow.apache.org/docs/) or simple cron jobs to run incremental syncs.

***

## Handling Deleted Data (API Limitations)

In certain cases, Ordergroove will delete future, unprocessed Order and Item records from the system. This happens when a customer takes an action that changes the lifecycle of a subscription or an order, e.g:

* A customer cancels their subscription, and any upcoming orders that haven’t yet been processed are removed.
* A subscription’s next order date is skipped or delayed, causing previously scheduled (but not yet fulfilled) items or orders to be deleted.

While these deletions are expected and part of normal subscription management behavior, one key limitation of the Ordergroove REST API is that deleted Order and Item records that item will no longer appear in list API and there’s no “tombstone” flag via the API to indicate it was removed. That means if you're syncing data via API polling, these deletions won't be reflected in your warehouse or destination system unless you capture them separately through webhooks. Support for syncing deleted records is on the roadmap and expected by the end of 2025.

**Solution – Webhooks for Order and Item deletions**: Ordergroove provides a robust Webhooks system that can notify your application of events in real-time. We recommend that your systems subscribe to the two webhook events “order.delete” and “item.remove” (in addition to your API sync) to account for these  deletions and removals.

* *Order.Delete*: You can subscribe to a “Order.Delete” or “subscription expired” event​ which tells you an order was deleted. Upon receiving this, you could mark that Order as deleted in your system.
* *Item.Remove*: This will tell you when an item is deleted. Use this to delete or flag the item record in your database.

By capturing webhook payloads, you can perform a soft delete or flagging of records in your warehouse that are no longer active. This approach complements the incremental API sync: the API keeps your data updated for new and modified records, while webhooks inform you of removals that the next API poll might not catch.

***

## Best Practices

If you're building a custom data pipeline with Ordergroove's APIs, keep these tips in mind to ensure reliable, efficient syncing:

* Use Cursor-Based Pagination
* Do Incremental Fetch with Timestamps
* Implement Upsert Logic
* Test with Smaller Time Window
* Logging and Monitoring
* No Concurrent requests for the same object
* Don’t Assume Deleted Data via API
* Rate Limit Awareness