# OrderGroove REST API Endpoint Index

A complete index of every REST endpoint, grouped by resource. Each row gives method + path + the local reference file you can read for full request/response specs (body fields, query parameters, examples, error codes, OpenAPI schema).

**Base URLs**

- REST API (default): `https://restapi.ordergroove.com` (staging: `https://staging.restapi.ordergroove.com`)
- Subscription Creation API: `https://sc.ordergroove.com` (staging: `https://staging.sc.ordergroove.com`)
- 1-Click Actions: signed URLs are returned in webhook payloads; not called with API key

For authentication and rate limit details see [`../01-getting-started/authentication.md`](../01-getting-started/authentication.md) and [`../01-getting-started/ordergroove-api-rate-limits.md`](../01-getting-started/ordergroove-api-rate-limits.md). For pagination see [`../01-getting-started/pagination.md`](../01-getting-started/pagination.md).

---

## Customers

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET    | `/customers/`                                    | List                | [customers/customers-list.md](customers/customers-list.md) |
| GET    | `/customers/{merchant_user_id}/`                 | Retrieve            | [customers/customers-retrieve.md](customers/customers-retrieve.md) |
| POST   | `/customers/create/`                             | Create              | [customers/customers-create.md](customers/customers-create.md) |
| PATCH  | `/customers/{merchant_user_id}/update`           | Update              | [1-click-actions/update.md](1-click-actions/update.md) |
| PATCH  | `/customers/{merchant_user_id}/set_contact_details` | Set Contact Details | [customers/customers-set-contact-details.md](customers/customers-set-contact-details.md) |

> Note: `update.md` is filed under `1-click-actions/` because it documents both the regular customer update and the 1-click variant.

---

## Subscriptions

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET    | `/subscriptions/`                                                   | List                            | [subscriptions/subscriptions-list.md](subscriptions/subscriptions-list.md) |
| GET    | `/subscriptions/{subscription_id}/`                                 | Retrieve                        | [subscriptions/subscriptions-retrieve.md](subscriptions/subscriptions-retrieve.md) |
| POST   | `/subscriptions/create_from_item/`                                  | Create From Item                | [subscriptions/subscriptions-create-from-item.md](subscriptions/subscriptions-create-from-item.md) |
| POST   | `/subscriptions/iu/`                                                | Create In Order                 | [subscriptions/subscriptions-create-in-order.md](subscriptions/subscriptions-create-in-order.md) |
| PATCH  | `/subscriptions/{subscription_id}/update/`                          | Update                          | [subscriptions/subscriptions-update.md](subscriptions/subscriptions-update.md) |
| PATCH  | `/subscriptions/{subscription_id}/cancel/`                          | Cancel                          | [subscriptions/subscriptions-cancel.md](subscriptions/subscriptions-cancel.md) |
| PATCH  | `/subscriptions/{subscription_id}/reactivate/`                      | Reactivate                      | [subscriptions/subscriptions-reactivate.md](subscriptions/subscriptions-reactivate.md) |
| PATCH  | `/subscriptions/{subscription_id}/change_quantity/`                 | Change Quantity                 | [subscriptions/subscriptions-change-quantity.md](subscriptions/subscriptions-change-quantity.md) |
| PATCH  | `/subscriptions/{subscription_id}/change_shipping/`                 | Change Shipping Address         | [subscriptions/subscriptions-change-shipping-address.md](subscriptions/subscriptions-change-shipping-address.md) |
| PATCH  | `/subscriptions/{subscription_id}/change_payment/`                  | Change Payment                  | [subscriptions/subscriptions-change-payment.md](subscriptions/subscriptions-change-payment.md) |
| PATCH  | `/subscriptions/{subscription_id}/change_email_reminder/`           | Change Email Reminder           | [subscriptions/subscriptions-change-email-reminder.md](subscriptions/subscriptions-change-email-reminder.md) |
| PATCH  | `/subscriptions/{subscription_id}/change_frequency/`                | Change Frequency                | [subscriptions/subscriptions-change-frequency.md](subscriptions/subscriptions-change-frequency.md) |
| PATCH  | `/subscriptions/{subscription_public_id}/change_product/`           | Change Product (SKU swap)       | [subscriptions/subscriptions-change-product.md](subscriptions/subscriptions-change-product.md) |
| PATCH  | `/orders/{order_id}/skip_subscription/`                             | Skip Subscription (next order)  | [subscriptions/skip-subscription.md](subscriptions/skip-subscription.md) |
| GET    | `/merchant/cancel_reason/`                                          | List Cancellation Reasons       | [subscriptions/list-cancellation-reasons.md](subscriptions/list-cancellation-reasons.md) |

---

## Orders

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET    | `/orders/`                                          | List                       | [orders/orders-list.md](orders/orders-list.md) |
| GET    | `/orders/{order_id}/`                               | Retrieve                   | [orders/orders-retrieve.md](orders/orders-retrieve.md) |
| PATCH  | `/orders/{order_id}/update/`                        | Update                     | [orders/orders-update.md](orders/orders-update.md) |
| PATCH  | `/orders/{order_id}/cancel/`                        | Cancel                     | [orders/orders-cancel.md](orders/orders-cancel.md) |
| PATCH  | `/orders/{order_id}/send_now/`                      | Send Now                   | [orders/orders-send-now.md](orders/orders-send-now.md) |
| PATCH  | `/orders/{order_id}/change_shipping/`               | Change Shipping Address    | [orders/orders-change-shipping-address.md](orders/orders-change-shipping-address.md) |
| PATCH  | `/orders/{order_id}/change_payment/`                | Change Payment             | [orders/orders-change-payment.md](orders/orders-change-payment.md) |
| PATCH  | `/orders/{order_id}/change_place_date/`             | Change Place Date          | [orders/orders-change-place-date.md](orders/orders-change-place-date.md) |
| —      | —                                                   | Order Status Codes (ref)   | [orders/order-status-codes.md](orders/order-status-codes.md) |

---

## Items

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET    | `/items/`                                  | List                | [items/items-list.md](items/items-list.md) |
| GET    | `/items/{item_id}/`                        | Retrieve            | [items/items-retrieve.md](items/items-retrieve.md) |
| POST   | `/items/create/`                           | Create              | [items/items-create.md](items/items-create.md) |
| POST   | `/items/iu/`                               | Create in Order     | [items/items-create-in-order.md](items/items-create-in-order.md) |
| PATCH  | `/items/{item_id}/update/`                 | Update              | [items/items-update.md](items/items-update.md) |
| DELETE | `/items/{item_id}/delete/`                 | Delete              | [items/items-delete.md](items/items-delete.md) |
| PATCH  | `/items/{item_id}/change_quantity/`        | Change Quantity     | [items/items-change-quantity.md](items/items-change-quantity.md) |
| PATCH  | `/items/{item_id}/change_price/`           | Change Price        | [items/items-change-price.md](items/items-change-price.md) |

The `/items/{item_id}/change_product/` PATCH (one-time SKU swap on an item) is documented under [products/product-change.md](products/product-change.md).

---

## Addresses

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/addresses/`                              | List               | [addresses/addresses-list.md](addresses/addresses-list.md) |
| GET   | `/addresses/{address_id}/`                 | Retrieve           | [addresses/addresses-retrieve.md](addresses/addresses-retrieve.md) |
| POST  | `/addresses/create/`                       | Create             | [addresses/addresses-create.md](addresses/addresses-create.md) |
| PATCH | `/addresses/{address_id}/update/`          | Update             | [addresses/addresses-update.md](addresses/addresses-update.md) |
| POST  | `/addresses/{address_public_id}/use_for_all/` | Use For All     | [addresses/use-address-for-all.md](addresses/use-address-for-all.md) |

---

## Payments

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/payments/`                              | List          | [payments/payments-list.md](payments/payments-list.md) |
| GET   | `/payments/{payment_id}/`                 | Retrieve      | [payments/payments-retrieve.md](payments/payments-retrieve.md) |
| POST  | `/payments/create/`                       | Create        | [payments/payments-create.md](payments/payments-create.md) |
| PATCH | `/payments/{payment_id}/update/`          | Update        | [payments/payments-update.md](payments/payments-update.md) |
| POST  | `/payments/{payment_id}/use_for_all/`     | Use For All   | [payments/use-payment-for-all.md](payments/use-payment-for-all.md) |
| —     | —                                         | Credit Card Type IDs (ref) | [payments/credit-card-types.md](payments/credit-card-types.md) |

---

## Products

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/products/`                                       | List              | [products/products-list.md](products/products-list.md) |
| GET   | `/products/{product_id}/`                          | Retrieve          | [products/products-retrieve.md](products/products-retrieve.md) |
| PATCH | `/products/{external_product_id}/`                 | Update            | [products/products-update.md](products/products-update.md) |
| GET   | `/products/{product_id}/{group_type}/{group_name}` | Group Check       | [products/products-group-check.md](products/products-group-check.md) |
| GET   | `/products/{product_id}/relationships/`            | Relationships     | [products/product-relationships.md](products/product-relationships.md) |
| PATCH | `/items/{item_id}/change_product/`                 | Item Product Change (SKU swap on a single item) | [products/product-change.md](products/product-change.md) |

---

## Product Groups

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/product_groups/`                            | List   | [product-groups/product-groups-list.md](product-groups/product-groups-list.md) |
| POST  | `/product_groups/create/`                     | Create | [product-groups/product-groups-create.md](product-groups/product-groups-create.md) |
| PATCH | `/product_groups/{group_type}/{name}/`        | Update | [product-groups/product-groups-update.md](product-groups/product-groups-update.md) |

---

## One-Time Discounts (OTDs / one_time_incentives)

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET    | `/one_time_incentives/`                              | List     | [otd/otd-list.md](otd/otd-list.md) |
| GET    | `/one_time_incentives/{one_time_incentive_id}/`      | Retrieve | [otd/otd-retrieve.md](otd/otd-retrieve.md) |
| POST   | `/one_time_incentives/create/`                       | Create   | [otd/otd-create.md](otd/otd-create.md) |
| PATCH  | `/one_time_incentives/{one_time_incentive_id}/update/` | Update | [otd/otd-update.md](otd/otd-update.md) |
| DELETE | `/one_time_incentives/{one_time_incentive_id}/delete/` | Delete | [otd/otd-delete.md](otd/otd-delete.md) |

---

## Cart

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/carts/{session_id}/`     | Retrieve | [cart/cart-retrieve.md](cart/cart-retrieve.md) |

---

## Purchase POST (Subscription Creation)

These endpoints use the alternate `https://sc.ordergroove.com` host (NOT `restapi`).

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| POST | `/subscription/create`                              | Purchase POST API (composite create) | [purchase-post/purchase-post-api.md](purchase-post/purchase-post-api.md) |
| GET  | `/subscription/{Subscription Request ID}/response`  | Purchase POST Status                  | [purchase-post/purchase-post-status.md](purchase-post/purchase-post-status.md) |
| —    | —                                                   | Conceptual overview of Purchase POST  | [purchase-post/purchase-post.md](purchase-post/purchase-post.md) |

---

## Bulk (Products)

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| POST  | `/products-batch/create/` | Bulk Create | [bulk/bulk-create.md](bulk/bulk-create.md) |
| PATCH | `/products-batch/update/` | Bulk Update | [bulk/bulk-update.md](bulk/bulk-update.md) |

---

## Bundles (Subscription Components)

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET  | `/subscriptions/components/{component_public_id}/`                    | Retrieve Component | [bundles/retrieve-component.md](bundles/retrieve-component.md) |
| POST | `/subscriptions/{subscription_public_Id}/components/bulk_operation/`  | Update Components  | [bundles/update-components.md](bundles/update-components.md) |
| —    | —                                                                     | Components conceptual overview | [bundles/bundle-components.md](bundles/bundle-components.md) |

---

## Free Trials

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| —      | —                                                                  | Configuration / overview | [free-trials/free-trials-configuration.md](free-trials/free-trials-configuration.md) |
| GET    | (via products list/retrieve `?include_product_free_trials=true`)   | List free trial configs  | [free-trials/free-trials-list.md](free-trials/free-trials-list.md) |
| POST   | `/products/{product_id}/free_trials/create/`                       | Create                   | [free-trials/free-trials-create.md](free-trials/free-trials-create.md) |
| PATCH  | `/products/{product_id}/free_trials/{free_trial_id}/update/`       | Update                   | [free-trials/free-trials-update.md](free-trials/free-trials-update.md) |
| DELETE | `/products/{product_id}/free_trials/{free_trial_id}/delete/`       | Delete                   | [free-trials/free-trials-delete.md](free-trials/free-trials-delete.md) |

---

## Prepaid Subscriptions

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| —     | —                                                                                  | Conceptual / data model | [prepaid/prepaid-subscriptions.md](prepaid/prepaid-subscriptions.md) |
| PATCH | `/subscriptions/{subscription_id}/upgrade_to_prepaid/`                              | Upgrade to Prepaid                  | [prepaid/upgrade-to-prepaid-subscription.md](prepaid/upgrade-to-prepaid-subscription.md) |
| PATCH | `/subscriptions/{subscription_id}/change_renewal_behavior/`                         | Change Renewal Behavior             | [prepaid/change-prepaid-subscription-renewal-behavior.md](prepaid/change-prepaid-subscription-renewal-behavior.md) |
| PATCH | `/subscriptions/{subscription_id}/update_prepaid_context/`                          | Update Prepaid Context              | [prepaid/update-prepaid-subscription-context.md](prepaid/update-prepaid-subscription-context.md) |
| POST  | `/products/{product_id}/resource_grants/manage/`                                    | Manage Digital Plan Product         | [prepaid/manage-digital-plan-product.md](prepaid/manage-digital-plan-product.md) |

---

## Rotating Products (Curation / Time-Window / Ordinal)

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| —      | —                                                                                       | Time-window rotating product overview      | [rotating-products/rotating-product.md](rotating-products/rotating-product.md) |
| —      | —                                                                                       | Ordinal rotating product overview           | [rotating-products/ordinal-based-rotating-product.md](rotating-products/ordinal-based-rotating-product.md) |
| GET    | `/products/{product_id}/rotating_delivery_product/`                                     | Retrieve Rotating Delivery Product          | [rotating-products/rotating-products.md](rotating-products/rotating-products.md) |
| POST   | `/products/{product_id}/selection_rules/time_window/manage/`                            | Manage Time-Window Rotating Product         | [rotating-products/manage-time-window-rotating-product.md](rotating-products/manage-time-window-rotating-product.md) |
| POST   | `/products/{product_id}/selection_rules/ordinal/manage/`                                | Manage Ordinal Rotating Product             | [rotating-products/manage-ordinal-rotating-product.md](rotating-products/manage-ordinal-rotating-product.md) |
| PATCH  | `/subscriptions/{subscription_id}/rotation_ordinal/update/`                             | Set Subscription Ordinal for Rotating Product | [rotating-products/set-subscription-ordinal-for-rotation-product.md](rotating-products/set-subscription-ordinal-for-rotation-product.md) |
| GET    | `/subscriptions/{subscription_id}/rotation_ordinal/{product_id}`                        | Retrieve Ordinal Subscription Context        | [rotating-products/retrieve-ordinal-subscription-context.md](rotating-products/retrieve-ordinal-subscription-context.md) |

---

## 1-Click Actions

These are signed-link endpoints used in emails/SMS — they consume tokens issued by Ordergroove webhooks. See [`../07-guides/using-webhooks-for-1-click-actions.md`](../07-guides/using-webhooks-for-1-click-actions.md) for the flow.

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/one_click/skip`                                                | Skip                       | [1-click-actions/1-click-skip-1.md](1-click-actions/1-click-skip-1.md) |
| GET   | `/one_click/delay`                                               | Delay (next order)         | [1-click-actions/1-click-delay.md](1-click-actions/1-click-delay.md) |
| GET   | `/one_click/reactivate`                                          | Reactivate                 | [1-click-actions/1-click-reactivate.md](1-click-actions/1-click-reactivate.md) |
| PATCH | `/subscriptions/{subscription_id}/change_next_order_date/`       | Change Next Order Date     | [1-click-actions/change-next-order-date.md](1-click-actions/change-next-order-date.md) |
| PATCH | `/customers/{merchant_user_id}/update`                           | Update (customer)          | [1-click-actions/update.md](1-click-actions/update.md) |
| —     | —                                                                | Modify (entitlements/extensions) | [1-click-actions/modify.md](1-click-actions/modify.md) |

---

## Entitlements

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/entitlements/`                                                 | List              | [entitlements/entitlements-list.md](entitlements/entitlements-list.md) |
| POST  | `/entitlements/{entitlement.public_id}/modify_expiration/`       | Modify Expiration | [1-click-actions/modify.md](1-click-actions/modify.md) |

For entitlements webhook events see [`../04-webhooks/entitlements-events.md`](../04-webhooks/entitlements-events.md).

---

## Offers

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/offer_profiles/`     | List | [offers/offer-profile-list.md](offers/offer-profile-list.md) |

For offer/incentive types & payloads see GraphQL types under `../05-graphql/types/` (`incentivetype.md`, `discountincentivetype.md`, `giftincentivetype.md`, `onetimeincentivetype.md`).

---

## Resource Extensions (generic)

Resource Extensions enrich primary resource responses (e.g. include addresses+payments when listing customers). See conceptual overview at [`../01-getting-started/resource-overview.md`](../01-getting-started/resource-overview.md).

| Method | Path | Operation | Reference file |
|--------|------|-----------|----------------|
| GET   | `/resources/`                                | List     | [resources/resource-list.md](resources/resource-list.md) |
| GET   | `/resources/{resource_public_id}/`           | Retrieve | [resources/resource-retrieve.md](resources/resource-retrieve.md) |
| POST  | `/resources/create/`                         | Create   | [resources/resource-create.md](resources/resource-create.md) |
| PATCH | `/resources/{resource_public_id}/update/`    | Update   | [resources/resource-update.md](resources/resource-update.md) |

---

## How to use this index

When the user asks about a specific endpoint:

1. Find the row in this index.
2. Open the linked reference file — it contains the **full request body fields, query params, response body definition, examples, error responses, and OpenAPI schema** for that endpoint.
3. If authentication or pagination is relevant, also read [`../01-getting-started/authentication.md`](../01-getting-started/authentication.md) or [`../01-getting-started/pagination.md`](../01-getting-started/pagination.md).
4. For event payloads (e.g. "what does a `subscription.cancel` webhook look like"), see `../04-webhooks/`.
5. For GraphQL field types and shapes, see `../05-graphql/`.
