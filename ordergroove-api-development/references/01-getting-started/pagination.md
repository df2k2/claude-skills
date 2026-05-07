# Cursor Pagination

How to traverse large data sets

Ordergroove's APIs support cursor-based pagination, which we strongly recommend for fetching data from List endpoints. Cursor-based pagination ensures consistent response times and avoids potential issues with data integrity.

***

## Why Use Cursor-Based Pagination?

**Consistent Performance**
Cursor-based pagination provides stable response times, even for large datasets. In contrast, page number-based pagination slows down as the page number increases.

**Data Integrity**
It eliminates the risk of duplicate or missing records caused by data updates while the dataset is being retrieved.

***

## Enabling Cursor-Based Pagination

To use cursor-based pagination, include the following header in your request:

```json
{
  "x-api-key": "{YOUR_KEY_HERE}",
  "X-OG-API-VERSION": "2"
}
```

### Page Size

By default, List endpoints return 10 results per response. You can adjust this using the `page_size` parameter, up to a maximum of 100 results.

***

## Fetching Additional Results

When there are more results than the page\_size limit, the response includes `next` and `previous` attributes, which contain URLs with a cursor parameter for fetching subsequent or previous pages.

```
{
"next":"https://restapi.ordergroove.com/subscriptions/?cursor=cD0yMDI0LTA0LTEwKzEwJTNBMjElM0EwMQ%3D%3D&updated_end=2024-06-26&updated_start=2024-06-24",
"previous":null,
"results":[{
  	"public_id": "f9cb2f93e1c845eb9de9eff46ddb3cbf",
        ...
        }]
}
```

To fetch the next set of results, use the URL provided in the `next` attribute. To fetch the previous set, use the URL from the `previous` attribute.

***

## Recommendation for Count

Cursor-based pagination does not provide the `count` attribute in the response which represents the total number of records matching the filters used on the endpoint.

For user-facing interfaces (e.g., paginating orders or subscriptions), we recommend:

* Allowing users to navigate to the next and previous pages of results
* Avoiding direct navigation to arbitrary page numbers, which is not supported with cursor-based pagination