# Sync Ordergroove Data into Internal Systems

<HTMLBlock>
  {`
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {
        "@type": "Question",
        "name": "Why is a Subscription not directly linked to an Order, but instead through Items?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>An Order in Ordergroove represents a shipment — a \"box\" — which can include items from multiple subscriptions, as long as they're shipping to the same customer, at the same address, and using the same payment method. Because of this, the Item is the direct link between a Subscription and an Order. A single order can include items from multiple subscriptions, but each item belongs to only one subscription.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Why does the Item object not have its own updated timestamp?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>When an Item is changed, Ordergroove automatically recalculates the associated Order, and the Order's updated timestamp is updated to reflect that change. This means the updated field on the Order represents the last change to any of its associated Items.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "When are future Items and Orders created?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>Ordergroove maintains a single upcoming Item and Order for each subscription. A new future item or order is created just before the current scheduled order is processed.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Why do I see a large number of Orders updated during overnight or early morning hours?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>Order placement is a background system process, not triggered by user activity. Based on your configuration, Ordergroove will process scheduled orders in bulk, often during the middle of the night, resulting in many Orders receiving updated timestamps even if there was no customer interaction at that time.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "How often should I schedule an incremental refresh?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>We recommend syncing data once per day. If your business requires fresher data, you can schedule a second incremental sync twice a day. Refer to the ETL Scheduling section for more details.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "What time of day should I schedule my sync?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>We recommend scheduling your main daily sync between 12PM CST and 8PM CST, after most order processing is complete. This helps ensure you capture a full day of updates. Be sure to adjust for your local time zone, as Ordergroove data is timestamped in EST.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Why should I start from the start time of the last job, not the end time?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>To avoid missing records, always begin your next incremental sync using the start time of the previous job. This ensures you don't skip any objects created or updated just after the previous sync began but before it completed.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Can I make concurrent API requests to speed up syncing?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>Do not parallelize API requests for the same object type. Ordergroove's API uses cursor-based pagination, which must be consumed sequentially. You can fetch different object types (e.g., Subscriptions and Customers) in parallel, but each individual resource should be synced with a single-threaded process. If performance is a concern, please contact the Ordergroove support team.</p>"
        }
      },
      {
        "@type": "Question",
        "name": "Are deleted Orders and Items available through the API?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "<p>No, deleted Orders and Items are not accessible via the API. Once removed, they won't appear in list endpoints and there's no flag to indicate deletion. To handle deletions, we recommend subscribing to webhook events like <code>order.delete</code> and <code>item.remove</code>. See the Deleted Records section for full details.</p>"
        }
      }
    ]
  }
  </script>
  `}
</HTMLBlock>

Syncing Ordergroove data into your data warehouse or external systems unlocks deeper analysis and connects your subscription data to the rest of your business. This guide is for data engineers and analysts building a reliable pipeline to extract Ordergroove data and upsert it into a warehouse for analytics and operational use. It walks through the Ordergroove data model and covers best practices for incremental fetching, pagination, and edge cases — so your integration is efficient, resilient, and aligned with how our APIs are designed.

***

## Ordergroove’s Data Model

Ordergroove’s platform centers around subscriptions and recurring orders. For a more detailed look, see [Data Model at a Glance](https://developer.ordergroove.com/docs/data-model-at-a-glance).

**ERD Flowchart (click to view full size)**

<Image align="center" src="https://files.readme.io/b1620826831e8092a63af7dc4f79c42193c24cb007b000b15dc61b256862c797-OG-ERD.png" />

***

## Objects and Events

Objects represent the current state of entities in your Ordergroove program—such as subscriptions, customers, or orders. You can access this data by polling the Ordergroove API, which returns a snapshot of an object at the time of the request. However, this method doesn't show how that state came to be. For example, if a customer cancels a subscription and later reactivates it, the API response will simply show the current live status as `true`.

Events, on the other hand, capture each meaningful change that occurs. Ordergroove emits events when key actions happen—like when a subscription is created, canceled, or reactivated—and delivers them to your server via webhooks in near real time. By subscribing to these webhooks, you gain visibility into the sequence of actions that led to the current state, such as receiving both `subscription.change_live` and `subscription.reactivate` events for the scenario above.

***

## Syncing Data across Ordergroove and an Internal Systems

There are several ways to sync data between the two systems, depending on the type of data you want to receive.

<Table align={["left","left","left"]}>
  <thead>
    <tr>
      <th>
        Use Case
      </th>

      <th>
        Recommended Method
      </th>

      <th>
        Alternative Method
      </th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td>
        [Sync entities](https://developer.ordergroove.com/docs/implement-custom-data-pipelines)
      </td>

      <td>
        • Build your own Data Pipelines using APIs\
        • Use pre built Ordergroove Connectors
      </td>

      <td>
        • SFTP file drops

        * *Note:*\* Available only for ongoing deltas, no full historic backfill
      </td>
    </tr>

    <tr>
      <td>
        [Sync events](https://developer.ordergroove.com/docs/sync-events)
      </td>

      <td>
        • Webhooks
      </td>

      <td>
        • Reach out to a solutions team member via [help@ordergroove.com](mailto:help@ordergroove.com)  if the webhook option does not work for your team
      </td>
    </tr>
  </tbody>
</Table>

***

## FAQ

**Q: Why is a Subscription not directly linked to an Order, but instead through Items?**\
An Order in Ordergroove represents a shipment, a “box”,  which can include items from multiple subscriptions, as long as they're shipping to the same customer, at the same address, and using the same payment method. Because of this, the Item is the direct link between a Subscription and an Order. A single order can include items from multiple subscriptions, but each item belongs to only one subscription.

**Q: Why does the Item object not have its own updated timestamp?**\
When an Item is changed, Ordergroove automatically recalculates the associated Order, and the Order’s updated timestamp is updated to reflect that change. This means the updated field on the Order represents the last change to any of its associated Items.

**Q: When are future Items and Orders created?**\
Ordergroove maintains a single upcoming Item and Order for each subscription. A new future item/order is created just before the current scheduled order is processed.

**Q: Why do I see a large number of Orders updated during overnight or early morning hours?**\
Order placement is a background system process, not triggered by user activity. Based on your configuration, Ordergroove will process scheduled orders in bulk, often during middle of the night, resulting in many Orders receiving updated timestamps even if there was no customer interaction at that time.

**Q: How often should I schedule an incremental refresh?**\
We recommend syncing data once per day. If your business requires fresher data, you can schedule a second incremental sync twice a day. Refer to the ETL Scheduling section for more details.

**Q: What time of day should I schedule my sync?**\
We recommend scheduling your main daily sync between 12PM CST  and 8PM CST, after most order processing is complete. This helps ensure you capture a full day of updates. Be sure to adjust for your local time zone, as Ordergroove data is timestamped in EST.

**Q: Why should I start from the start time of the last job, not the end time?**\
To avoid missing records, always begin your next incremental sync using the start time of the previous job. This ensures you don’t skip any objects created or updated just after the previous sync began but before it completed.

**Q: Can I make concurrent API requests to speed up syncing?**\
Do not parallelize API requests for the same object type. Ordergroove’s API uses cursor-based pagination, which must be consumed sequentially. You can fetch different object types (e.g., Subscriptions and Customers) in parallel, but each individual resource should be synced with a single threaded process. If performance is a concern, please contact the Ordergroove support team.

**Q: Are deleted Orders and Items available through the API?**\
No, deleted Orders and Items are not accessible via the API. Once removed, they won’t appear in list endpoints and there's no flag to indicate deletion. To handle deletions, we recommend subscribing to webhook events like order.delete and item.remove. See the Deleted Records section for full details.

***

## References

* [Data Model ERD](https://developer.ordergroove.com/docs/data-model-at-a-glance#api-erd)