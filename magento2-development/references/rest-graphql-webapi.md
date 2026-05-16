# REST, GraphQL, and Web APIs

Magento exposes three primary Web API interfaces:

- **REST** — `<base_url>/rest/<store_code>/V1/<resource>`. Declared in `etc/webapi.xml`.
- **SOAP** — same backend as REST, exposed via WSDL at `<base_url>/soap/<store_code>?wsdl`. Same `webapi.xml`.
- **GraphQL** — `<base_url>/graphql` (no store code in URL; selected by `Store` HTTP header). Declared via `etc/schema.graphqls` + resolver classes.

Authentication is decoupled: a single integration token can call REST and SOAP; GraphQL uses customer tokens or admin tokens.

## REST / SOAP — `etc/webapi.xml`

```xml
<?xml version="1.0"?>
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Webapi:etc/webapi.xsd">

    <route url="/V1/giftwrap/messages/:id" method="GET">
        <service class="Acme\GiftWrap\Api\MessageRepositoryInterface" method="getById"/>
        <resources>
            <resource ref="Acme_GiftWrap::messages"/>
        </resources>
    </route>

    <route url="/V1/giftwrap/messages" method="POST">
        <service class="Acme\GiftWrap\Api\MessageRepositoryInterface" method="save"/>
        <resources>
            <resource ref="Acme_GiftWrap::messages_write"/>
        </resources>
    </route>

    <route url="/V1/giftwrap/messages/search" method="GET">
        <service class="Acme\GiftWrap\Api\MessageRepositoryInterface" method="getList"/>
        <resources>
            <resource ref="Acme_GiftWrap::messages"/>
        </resources>
    </route>

    <route url="/V1/giftwrap/messages/:id" method="DELETE">
        <service class="Acme\GiftWrap\Api\MessageRepositoryInterface" method="deleteById"/>
        <resources>
            <resource ref="Acme_GiftWrap::messages_write"/>
        </resources>
    </route>

    <!-- Customer-self route: customer can call with their own bearer token -->
    <route url="/V1/giftwrap/mine/messages" method="GET">
        <service class="Acme\GiftWrap\Api\MyMessagesInterface" method="getMine"/>
        <resources>
            <resource ref="self"/>
        </resources>
        <data>
            <parameter name="customerId" force="true">%customer_id%</parameter>
        </data>
    </route>

    <!-- Guest route: anyone with a quote masked ID can call -->
    <route url="/V1/guest-carts/:cartId/totals" method="GET">
        <service class="Magento\Quote\Api\GuestCartTotalRepositoryInterface" method="get"/>
        <resources>
            <resource ref="anonymous"/>
        </resources>
    </route>
</routes>
```

### Anatomy
- `<route url="...">` — URL pattern. Path parameters use `:name` and bind to method args by name.
- `method` — HTTP method.
- `<service class="..." method="..."/>` — the Api interface and method to call. Magento introspects the method signature to derive request/response shape.
- `<resources>` — ACL resources required. Common values:
  - `Vendor_Module::resource` — custom ACL ID from your `acl.xml`.
  - `self` — caller must be a logged-in customer (uses customer token).
  - `anonymous` — no auth required.
  - `Magento_Catalog::products` etc. — Magento's own ACL.
- `<data>` — inject values into the service call. `%customer_id%` is replaced with the authenticated customer's ID. Used for "/mine/" endpoints.

### Routes auto-map to method params

For `Acme\GiftWrap\Api\MessageRepositoryInterface::getById(int $id)`:
- URL `/V1/giftwrap/messages/:id` binds `:id` to `$id`.
- Returns the JSON-encoded result.

For `save(MessageInterface $message)`:
- POST body is deserialized into `MessageInterface`. Magento uses the interface's `get*` methods to map JSON keys.

For `getList(SearchCriteriaInterface $searchCriteria)`:
- Query params like `?searchCriteria[filterGroups][0][filters][0][field]=is_active&searchCriteria[filterGroups][0][filters][0][value]=1` are auto-built into a SearchCriteria.

### How API Json keys are derived
`getEntityId()` → `entity_id`. `getIsActive()` → `is_active`. The interface's getter name (minus `get`) lowercased+snake_cased becomes the key. Always declare interface methods explicitly — `@method` PHPDoc tags WON'T work for API.

### Validate after editing `webapi.xml`
Run:
```
bin/magento cache:clean config config_webservice
```
The webapi config is heavily cached. Without this clean, your new endpoint will 404.

## ACL — `etc/acl.xml`

Defines admin/integration permissions used by `<resources>` in `webapi.xml` and admin menus.

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Acl/etc/acl.xsd">
    <acl>
        <resources>
            <resource id="Magento_Backend::admin">
                <resource id="Acme_GiftWrap::root"
                          title="Gift Wrap"
                          sortOrder="100">
                    <resource id="Acme_GiftWrap::messages"
                              title="View Messages"/>
                    <resource id="Acme_GiftWrap::messages_write"
                              title="Save / Delete Messages"/>
                </resource>
            </resource>
        </resources>
    </acl>
</config>
```

When an integration's token is created in admin, the admin picks which `resource` IDs the integration may use. The `<resource ref="Acme_GiftWrap::messages"/>` in `webapi.xml` checks against this list.

## Authentication

### REST/SOAP auth headers

`Authorization: Bearer <token>`

Three token types:
- **Admin token** — `POST /V1/integration/admin/token` with `{username, password}` → returns a short-lived token. Best for ad-hoc admin scripts.
- **Customer token** — `POST /V1/integration/customer/token` with `{username, password}` → token scoped to the customer (cannot access admin resources).
- **Integration token** — created in admin under **System → Integrations**. Long-lived, scoped to selected ACL resources. Best for server-to-server.

For `<resource ref="anonymous"/>` routes, no Authorization header is needed. For `<resource ref="self"/>`, send a customer token.

### Customer token endpoints
- `POST /rest/V1/integration/customer/token` — username/password → token.
- `POST /rest/V1/integration/customer/token/revoke` — invalidate. (Admin can also revoke from admin panel.)

### Token TTL
Configured in admin: **Stores → Configuration → Services → OAuth → Access Token Expiration**.

### OAuth 1.0a (legacy)
Magento still supports OAuth 1.0a for integrations. Modern setups use the bearer token API key path because OAuth 1.0a is complex.

## REST request/response examples

### Get a product
```
GET /rest/V1/products/MyProductSku HTTP/1.1
Authorization: Bearer <integration_token>
```
Response: full `ProductInterface` shape with attributes, prices, options, etc.

### SearchCriteria via query string
```
GET /rest/V1/products?
  searchCriteria[filter_groups][0][filters][0][field]=price
  &searchCriteria[filter_groups][0][filters][0][value]=10
  &searchCriteria[filter_groups][0][filters][0][condition_type]=gt
  &searchCriteria[sort_orders][0][field]=created_at
  &searchCriteria[sort_orders][0][direction]=DESC
  &searchCriteria[page_size]=20
  &searchCriteria[current_page]=1
```

Multiple filters in the same `filter_groups[N]` are OR'd; different groups are AND'd.

### Save a customer
```
PUT /rest/V1/customers/123 HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{
    "customer": {
        "id": 123,
        "email": "joe@example.com",
        "firstname": "Joe",
        "lastname": "Smith",
        "extension_attributes": {
            "loyalty_points": 500
        }
    }
}
```

The top-level key `customer` corresponds to the parameter name in `Magento\Customer\Api\CustomerRepositoryInterface::save(CustomerInterface $customer)`. Magento auto-builds the wrapper from the method's first arg's name.

### Bulk endpoints
Some endpoints have an `/async/bulk/` variant for batch processing:
```
POST /rest/all/async/bulk/V1/products
```
Body is an array of product objects. Magento queues each as a message, returns a `bulk_uuid` to poll. See `cli-cron-queues.md` for the async/bulk pattern.

## GraphQL

GraphQL uses an entirely separate stack — no `webapi.xml`. Schema is in `etc/schema.graphqls` files; resolvers are PHP classes implementing `ResolverInterface`.

### Schema — `etc/schema.graphqls`

```graphql
type Query {
    giftWrapMessage(id: Int! @doc(description: "Message ID")): GiftWrapMessage
        @resolver(class: "Acme\\GiftWrap\\Model\\Resolver\\GetMessage")
        @doc(description: "Retrieve a single gift wrap message by ID")
}

type Mutation {
    saveGiftWrapMessage(input: GiftWrapMessageInput!): GiftWrapMessage
        @resolver(class: "Acme\\GiftWrap\\Model\\Resolver\\SaveMessage")
}

type GiftWrapMessage {
    id: Int
    order_id: Int!
    message: String
    is_active: Boolean!
    created_at: String
}

input GiftWrapMessageInput {
    id: Int
    order_id: Int!
    message: String
    is_active: Boolean
}

# Extending a Magento core type:
type Customer {
    loyalty_points: Int @doc(description: "Customer loyalty points balance")
        @resolver(class: "Acme\\Loyalty\\Model\\Resolver\\CustomerLoyaltyPoints")
}
```

### Resolver class

```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Model\Resolver;

use Magento\Framework\GraphQl\Config\Element\Field;
use Magento\Framework\GraphQl\Exception\GraphQlInputException;
use Magento\Framework\GraphQl\Exception\GraphQlNoSuchEntityException;
use Magento\Framework\GraphQl\Query\ResolverInterface;
use Magento\Framework\GraphQl\Schema\Type\ResolveInfo;
use Acme\GiftWrap\Api\MessageRepositoryInterface;
use Magento\Framework\Exception\NoSuchEntityException;

class GetMessage implements ResolverInterface
{
    public function __construct(
        private readonly MessageRepositoryInterface $messageRepository
    ) {}

    public function resolve(
        Field $field,
        $context,
        ResolveInfo $info,
        array $value = null,
        array $args = null
    ) {
        if (!isset($args['id']) || !$args['id']) {
            throw new GraphQlInputException(__('"id" is required.'));
        }
        try {
            $message = $this->messageRepository->getById((int) $args['id']);
        } catch (NoSuchEntityException $e) {
            throw new GraphQlNoSuchEntityException(__('Message not found.'));
        }
        return [
            'id' => $message->getEntityId(),
            'order_id' => $message->getOrderId(),
            'message' => $message->getMessage(),
            'is_active' => $message->getIsActive(),
        ];
    }
}
```

Resolvers MUST return an array (or scalar) matching the GraphQL schema. Magento's GraphQL layer doesn't auto-introspect — you map manually.

### Customer-scoped resolvers (require customer token)

```php
public function resolve(...): array
{
    if (!$context->getUserId() || $context->getUserType() === 4) {
        throw new \Magento\Framework\GraphQl\Exception\GraphQlAuthorizationException(
            __('You must be logged in.')
        );
    }
    $customerId = (int) $context->getUserId();
    // ...
}
```

`$context->getUserType()` returns:
- `1` — guest
- `2` — customer
- `3` — admin
- `4` — integration

### GraphQL headers

```
POST /graphql HTTP/1.1
Authorization: Bearer <customer_token>
Content-Type: application/json
Store: default
```

`Store` header selects the store view (instead of URL path).

### GraphQL caching

Magento auto-caches GraphQL responses. Cache **identity** is computed by:
- The query string (after normalization).
- The HTTP headers `Store`, `Content-Currency`, customer group ID if logged in.

For queries that depend on customer state, set `cache_identity` and `cache_tags`:
```graphql
type Query {
    customer: Customer @resolver(class: "...")
        @cache(cacheIdentity: "Magento\\CustomerGraphQl\\Model\\Resolver\\Customer\\Identity")
}
```

Or implement `CacheIdentityInterface` and `CacheableQueryInterface` to fine-tune. Without this, dynamic queries (customer, cart) will be served stale.

### Query batching

```json
[
    { "query": "{ products(search:\"shoe\"){ items{ sku } } }" },
    { "query": "{ categoryList{ id } }" }
]
```
Posted to `/graphql`. Magento processes each in order.

## Authentication for GraphQL

Same tokens as REST:
- **Customer token** (from `POST /V1/integration/customer/token` or GraphQL mutation `generateCustomerToken(email, password)`).
- **Admin token** (from `POST /V1/integration/admin/token`).
- No token → request runs as guest (with quote masked id for cart access).

## Common patterns

### "Mine" endpoints — caller is the customer
```xml
<route url="/V1/customers/me/billingAddress" method="GET">
    <service class="Magento\Customer\Api\AccountManagementInterface" method="getDefaultBillingAddress"/>
    <resources>
        <resource ref="self"/>
    </resources>
    <data>
        <parameter name="customerId" force="true">%customer_id%</parameter>
    </data>
</route>
```

The `force="true"` substitution prevents the caller from passing their own `customer_id` and reading another user's data.

### Guest endpoints — masked quote ID
```xml
<route url="/V1/guest-carts/:cartId/totals" method="GET">
    <service class="Magento\Quote\Api\GuestCartTotalRepositoryInterface" method="get"/>
    <resources>
        <resource ref="anonymous"/>
    </resources>
</route>
```

`:cartId` is the **masked quote ID** (an opaque hex string) — not the integer DB ID. Magento auto-creates these for guest carts. Never expose the integer ID to anonymous callers.

### Versioning
Magento uses `/V1` for all endpoints. There's no V2. To "version" your API, name new methods/routes with version suffixes (e.g., `/giftwrap/v2/messages`) and keep V1 working.

## Inspect what's exposed

REST schema (Swagger-style): `<base_url>/swagger?type=rest`.
SOAP WSDL: `<base_url>/soap/<store_code>?wsdl_list=1`.
GraphQL introspection: `POST /graphql` with `{ __schema { types { name } } }`.

Or embedded:
- `references/sources/commerce-webapi-openapi/admin-schema-2.4.9.yaml` — full OpenAPI 3 spec for admin (integration token) endpoints in 2.4.9.
- `references/sources/commerce-webapi-openapi/customer-schema-2.4.9.yaml` — customer-scoped endpoints.
- `references/sources/commerce-webapi-openapi/guest-schema-2.4.9.yaml` — guest endpoints.

## Common gotchas

### 404 on a new endpoint after adding `webapi.xml`
`cache:clean config config_webservice`. Plus restart of php-fpm if op-cached.

### "Resource is not allowed" 401 / 403
The integration token doesn't have access to the resource ID, OR the customer token is being used against an admin-only resource. Check the `<resource ref="">` and the token's allowed resources.

### Customer token can call admin endpoints (it shouldn't)
Probably the route's `<resource>` is `anonymous`. Audit routes — `anonymous` exposes to the world.

### `Magento_Catalog::categories` returns full catalog tree to anonymous callers
Yes — this is by design. Catalog visibility is enforced at the data layer (category permissions, product visibility), not at the route layer. If you need private categories, gate them with Adobe Commerce Category Permissions, or add a custom plugin.

### GraphQL resolver returns null for non-nullable field → silent failure
GraphQL just returns `null` and adds an error. Make sure your resolver always returns the expected shape; throw `GraphQlInputException`/`GraphQlNoSuchEntityException` for explicit error responses.

### Schema cache stale after editing `schema.graphqls`
`bin/magento cache:clean config` (sometimes `setup:upgrade` is needed for big schema changes). In production, also `setup:di:compile` if you added new resolver classes.

### REST GET requests get cached at varnish
Magento doesn't set varnish-blocking headers on REST GETs by default. If you're behind varnish, add a vcl rule to bypass `/rest/` if you don't want caching, or rely on Magento's cache tags (which work for Page Cache, not generic varnish).

### Big GraphQL query → timeout
Each resolver runs per matching item. For 1000 products, `items { my_complex_field }` calls your resolver 1000 times. Use `dataLoader` patterns (batch resolvers) — or denormalize the field into the product entity.

## Original sources

- `references/sources/commerce-webapi/rest/` — REST guide and reference.
- `references/sources/commerce-webapi/graphql/` — GraphQL guide and reference.
- `references/sources/commerce-webapi/get-started/` — authentication, versioning.
- `references/sources/commerce-webapi-openapi/*.yaml` — OpenAPI schemas per version.
- `references/sources/commerce-php/development/components/web-api/` — webapi.xml architecture.
- `references/sources/commerce-php/development/components/service-contracts/` — service contracts (the substrate for REST/SOAP).
- `references/sources/devdocs-v2.4/graphql/` — older but extensive GraphQL guide.
- `references/sources/devdocs-v2.4/rest/` — older REST docs.
