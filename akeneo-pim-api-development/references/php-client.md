# The official PHP client (`akeneo/api-php-client`)

`akeneo/api-php-client` is Akeneo's official PHP client for the PIM REST API. Namespace **`Akeneo\Pim\ApiClient`**; you build a client with **`AkeneoPimClientBuilder`** and call typed resource APIs off it (`$client->getProductApi()->…`). It is **PSR-18/PSR-17 based** — you bring your own HTTP client and message factories (auto-discovered via `php-http/discovery`). Every response is decoded to a **plain PHP array**; there are no DTOs. License is **OSL-3.0**, and it requires **PHP ≥ 8.2**.

> **This is the one and only client — the EE package is dead.** Community and Enterprise editions were **merged into this single unified `akeneo/api-php-client`**. The old `akeneo/api-php-client-ee` repository is **archived** and its endpoints (reference entities, Asset Manager, published products, …) now live in this package. Do **not** `require akeneo/api-php-client-ee`. Enterprise-only routes simply 404 on a Community PIM — same client, different server surface.

> **This is the library the Magento 2 connector depends on.** The Akeneo Connector for Magento 2 pins `akeneo/api-php-client` (currently `11.4.0`). If you work on that connector, use the `akeneo-magento2-connector` skill — but the client API documented here is exactly what it calls.

For auth models (Connection password grant vs App authorization-code flow) see `authentication.md`; for product/value shapes see `products-and-models.md`; for catalog codes see `catalog-structure.md`; for a broader tooling map see `sdks-and-tools.md`.

## Install

The client declares only PSR HTTP **interfaces** as dependencies (`psr/http-client`, `psr/http-factory`, `psr/http-message`, plus `php-http/discovery` and `php-http/multipart-stream-builder`). You must add a concrete PSR-18 client + PSR-17 factory. The README's canonical recipe uses Guzzle 7:

```bash
composer require akeneo/api-php-client \
    php-http/guzzle7-adapter:^1.0 \
    http-interop/http-factory-guzzle:^1.0
```

Any PSR-18 client + PSR-17 factory works — `php-http/discovery` finds whatever is installed. A common modern alternative is Symfony HTTP Client + Nyholm PSR-7:

```bash
composer require akeneo/api-php-client symfony/http-client nyholm/psr7
```

Requirements (from `composer.json`): **PHP ≥ 8.2**, `symfony/options-resolver`, `php-http/httplug ^2.0`, `php-http/discovery ^1.6`.

> The client is **backward compatible with older PIMs** but only exposes the endpoints that existed when its version was cut. Compatibility matrix (README): PIM v5 → client v6; **PIM v6/v7/SaaS → client ≥ v7 (up to the current major, e.g. 11.x)**. UUID product APIs require a v7+/SaaS PIM.

## Building an authenticated client

`AkeneoPimClientBuilder` takes the **PIM base URL** (not `api.akeneo.com` — that's the docs site) and an optional options array, then exposes three `buildAuthenticated…` methods. All three are confirmed in `src/AkeneoPimClientBuilder.php`.

| Build method | Auth model | Signature | Use when |
| --- | --- | --- | --- |
| `buildAuthenticatedByPassword` | **Connection** (password grant) | `(string $clientId, string $secret, string $username, string $password)` | Connectors / back-office (ERP, the Magento connector) |
| `buildAuthenticatedByToken` | Connection, reusing a token | `(string $clientId, string $secret, string $token, string $refreshToken)` | Reuse an existing access+refresh token across processes |
| `buildAuthenticatedByAppToken` | **App** (App Store / custom App) | `(string $token)` | You already obtained a non-expiring App access token |

### Connection — password grant (most integrations)

```php
<?php
require_once __DIR__ . '/vendor/autoload.php';

use Akeneo\Pim\ApiClient\AkeneoPimClientBuilder;

$clientBuilder = new AkeneoPimClientBuilder('https://my-pim.cloud.akeneo.com/');
$client = $clientBuilder->buildAuthenticatedByPassword(
    'client_id', 'secret', 'api_username', 'api_password'
);

// First call:
$product = $client->getProductUuidApi()->get('1cf1d135-26fe-4ac2-9cf5-cdb69ada0547');
echo $product['uuid'];
```

The token is fetched **lazily** on the first API call (via `POST {pim}/api/oauth/v1/token`, `grant_type=password`, with `client_id:secret` Base64-encoded into a `Basic` header — see `AuthenticationApi::authenticateByPassword`). Because a fresh token is requested per process, this is the simplest but least efficient mode for high-process-count apps.

### Connection — reuse a stored token

To avoid re-authenticating in every PHP process (e.g. a web app), get a token once and persist it. After any call you can read the current tokens:

```php
$token        = $client->getToken();        // AkeneoPimClientInterface::getToken()
$refreshToken = $client->getRefreshToken(); // AkeneoPimClientInterface::getRefreshToken()

// Later / another process:
$client = $clientBuilder->buildAuthenticatedByToken('client_id', 'secret', $token, $refreshToken);
```

It's your responsibility to store the token/refresh token (file, cache, DB). Access tokens live ~1 hour; the client refreshes them automatically on a 401 (see *Exceptions & token refresh* below).

### App — pass an already-issued App token

```php
$client = $clientBuilder->buildAuthenticatedByAppToken('app_access_token');
```

> **Important: the client does NOT run the App authorization-code exchange.** `AuthenticationApi` only implements `authenticateByPassword` and `authenticateByRefreshToken` — there is **no** `code_challenge`/`code_identifier` handling in this library. You must complete the App OAuth flow yourself (see `authentication.md` / `apps-and-connections.md`), obtain the non-expiring access token, then hand it to `buildAuthenticatedByAppToken()`. App tokens don't expire but **cannot be auto-refreshed** (there is no refresh token) — if a PIM user revokes the token you get a 401 and must re-authorize.

### Builder options

- **Custom headers** (second constructor arg; headers must be `string[]`, and defaults can be overridden — see `Client/Options.php`):
  ```php
  $clientBuilder = new AkeneoPimClientBuilder(
      'https://my-pim.cloud.akeneo.com/',
      ['headers' => ['X-Custom-Header' => 'value']]
  );
  ```
- **Inject your own PSR components** instead of discovery: `setHttpClient(ClientInterface $c)`, `setRequestFactory(RequestFactoryInterface $f)`, `setStreamFactory(StreamFactoryInterface $f)`, `setFileSystem(FileSystemInterface $fs)` — each returns `$this` (fluent).
- **Response caching** for structural resources: `enableCache()` / `disableCache()` (off by default). When enabled, structural APIs (categories, attributes, families, channels, locales, currencies, association types…) are wrapped in an LRU cache; products and media are never cached.

## The resource APIs (client getters)

Every endpoint family is a getter on `AkeneoPimClientInterface` returning a typed `*Api` object. Names below are verified against `src/AkeneoPimClientInterface.php`.

| Domain | Getter(s) |
| --- | --- |
| Products (identifier) | `getProductApi()` |
| Products (UUID, v7+/SaaS) | `getProductUuidApi()` |
| Product models | `getProductModelApi()` |
| Published products (EE) | `getPublishedProductApi()` |
| Product drafts (EE) | `getProductDraftApi()`, `getProductDraftUuidApi()`, `getProductModelDraftApi()` |
| Product media files | `getProductMediaFileApi()` |
| Families / variants | `getFamilyApi()`, `getFamilyVariantApi()` |
| Attributes | `getAttributeApi()`, `getAttributeOptionApi()`, `getAttributeGroupApi()` |
| Categories | `getCategoryApi()`, `getCategoryMediaFileApi()` |
| Channels / locales / currencies | `getChannelApi()`, `getLocaleApi()`, `getCurrencyApi()` |
| Measurements | `getMeasurementFamilyApi()`, `getMeasureFamilyApi()` *(legacy)* |
| Association types | `getAssociationTypeApi()` |
| Reference entities (EE/SaaS) | `getReferenceEntityApi()`, `getReferenceEntityRecordApi()`, `getReferenceEntityAttributeApi()`, `getReferenceEntityAttributeOptionApi()`, `getReferenceEntityMediaFileApi()` |
| Asset Manager (EE/SaaS) | `getAssetManagerApi()`, `getAssetFamilyApi()`, `getAssetAttributeApi()`, `getAssetAttributeOptionApi()`, `getAssetMediaFileApi()` |
| App Catalogs | `getAppCatalogApi()`, `getAppCatalogProductApi()` |
| System info | `getSystemInformationApi()` |
| Tokens | `getToken()`, `getRefreshToken()` |

> **Deprecated (legacy PAM) getters:** `getAssetApi()`, `getAssetCategoryApi()`, `getAssetTagApi()`, `getAssetReferenceFileApi()`, `getAssetVariationFileApi()` are marked `@deprecated` ("route unavailable in latest PIM versions, removed in v12") — these are the **old** Product Asset Manager, not the modern Asset Manager. For assets on modern PIMs use `getAssetManagerApi()` / `getAssetFamilyApi()`.

## Reading resources

Each resource API exposes the same read surface (from `Api/Operation/GettableResourceInterface` + `ListableResourceInterface`):

- `get(string $code, array $queryParameters = []): array` — single resource (`getProductUuidApi()->get($uuid)`, `getProductApi()->get($identifier)`).
- `listPerPage(int $limit = 100, bool $withCount = false, array $queryParameters = []): PageInterface` — one page (offset pagination).
- `all(int $pageSize = 100, array $queryParameters = []): ResourceCursorInterface` — a **cursor** you iterate; it fetches subsequent pages for you.

### Cursor (recommended for big collections)

```php
$products = $client->getProductUuidApi()->all(100);
foreach ($products as $product) {
    echo $product['uuid'];
}
```

For products, product models and published products, `all()` **forces `pagination_type=search_after`** (the scalable cursor method) internally — you cannot get a total count or go backwards. This is the recommended way to export products.

### Pages (offset pagination, backward navigation, counts)

```php
$firstPage = $client->getProductUuidApi()->listPerPage(50, true); // withCount = true
$total = $firstPage->getCount();                                   // null unless withCount

foreach ($firstPage->getItems() as $product) { /* … */ }

if ($firstPage->hasNextPage()) {
    $second = $firstPage->getNextPage();
}
if ($second->hasPreviousPage()) {
    $first = $second->getPreviousPage();
}
```

`PageInterface` (verified in `Pagination/PageInterface.php`) offers: `getItems()`, `getCount()` (nullable — only populated when `withCount=true`, which **hurts performance**), `getFirstPage()`, `getNextPage()`/`getPreviousPage()`, `hasNextPage()`/`hasPreviousPage()`, `getNextLink()`/`getPreviousLink()`.

> **`page` vs `search_after`.** `listPerPage()` uses classic offset pages (supports counts + backward nav, doesn't scale). `all()` uses the `search_after` cursor (scales, no count, forward-only). Prefer `all()` for products/large sets; use `listPerPage()` for small structural lists where you want a count. See `rest-api-overview.md`.

### Filtering with SearchBuilder

Filters go in the `search` query parameter. Build them with `Akeneo\Pim\ApiClient\Search\SearchBuilder` and the `Operator` constants:

```php
use Akeneo\Pim\ApiClient\Search\SearchBuilder;
use Akeneo\Pim\ApiClient\Search\Operator;

$sb = new SearchBuilder();
$sb->addFilter('enabled', Operator::EQUAL, true);
$sb->addFilter('categories', Operator::IN, ['winter_collection']);
$sb->addFilter('name', Operator::STARTS_WITH, 'Sweat', ['locale' => 'en_US', 'scope' => 'ecommerce']);

$products = $client->getProductApi()->all(100, ['search' => $sb->getFilters()]);
```

`addFilter(string $property, string $operator, $value = null, array $options = []): self` — the 4th arg carries `locale`/`scope` for localizable/scopable attributes. `Operator` provides `EQUAL`, `NOT_EQUAL`, `IN`, `NOT_IN`, `IN_CHILDREN`, `GREATER_THAN`, `LOWER_THAN`, `BETWEEN`, `STARTS_WITH`, `CONTAINS`, `IS_EMPTY`, `NOT_EMPTY`, `SINCE_LAST_N_DAYS`, completeness operators, etc. (full list in `Search/Operator.php`). You can also pass raw arrays in `queryParameters` (`scope`, `locales`, `attributes`, `with_count`, …).

## Creating, upserting, deleting

Write operations come from `Api/Operation/{CreatableResourceInterface, UpsertableResourceInterface, UpsertableResourceListInterface, DeletableResourceInterface}`.

```php
// Create (POST) — 422 if the resource already exists. Returns HTTP status (201).
$client->getProductApi()->create('top', ['enabled' => true]);

// Upsert (PATCH) — create-or-update, partial merge at value level. Returns 201 (created) or 204 (updated).
$client->getProductApi()->upsert('top', [
    'family' => 'tshirt',
    'values' => [
        'name' => [
            ['locale' => 'en_US', 'scope' => null, 'data' => 'Top'],
        ],
    ],
]);

// Delete (DELETE). Returns 204.
$client->getProductApi()->delete('top');
```

Upsert is the workhorse — most Akeneo writes are PATCH upserts (see `products-and-models.md` for the `{locale, scope, data}` value shape, the #1 source of 422s).

### Bulk upsert (line-delimited)

`upsertList()` sends a newline-delimited JSON collection and returns a `\Traversable` — **one response entry per line** (each with its own `status_code` / `identifier` / errors), so you must iterate the result to detect per-line failures (a bulk call can return 200 overall while individual lines fail):

```php
$responses = $client->getProductApi()->upsertList([
    ['identifier' => 'top', 'family' => 'tshirt'],
    ['identifier' => 'cap', 'categories' => ['hat']],
]);

foreach ($responses as $line) {
    if ($line['status_code'] >= 400) {
        // inspect $line['identifier'], $line['errors']
    }
}
```

The default PIM cap is **100 resources per bulk call**.

### Products by UUID vs identifier vs product model

- **`getProductApi()`** keys products by **identifier** (SKU-like `$code`): `get/create/upsert/delete($code)`, plus `upsertList`.
- **`getProductUuidApi()`** keys the same products by **UUID** (v7+/SaaS): `get/create/upsert/delete($uuid)`, plus `upsertList`. Pick one family and stay consistent for a given product.
- **`getProductModelApi()`** keys by `code`; `create`/`upsert` reject a `code` inside `$data` (it's set from the first arg). Same for UUID/product APIs with their `uuid`/`identifier` key.

### Async writes

Every writable API also exposes `upsertAsync()` / `upsertAsyncList()` returning a `GuzzleHttp\Promise\PromiseInterface|Http\Promise\Promise` for concurrent writes (requires an async-capable adapter). Confirmed on `ProductApi`, `ProductUuidApi`, `ProductModelApi`.

## Media / file upload

Product media go through **`getProductMediaFileApi()`** — `create($mediaFile, array $data): string` where `$mediaFile` is a **file path or a PHP resource**, and `$data` associates the file with a product or product model. It uploads multipart and returns the **new media code** (parsed from the `Location` header):

```php
// Attach a new image to a product's "picture" attribute:
$code = $client->getProductMediaFileApi()->create(
    '/path/to/front.jpg',
    [
        'identifier' => 'medium_boot',  // product SKU
        'attribute'  => 'side_view',
        'scope'      => 'ecommerce',    // null if the attribute isn't scopable
        'locale'     => 'en_US',        // null if the attribute isn't localizable
    ]
);
// $code is the media-file code you then reference in product values.
// For a product MODEL, pass 'code' => '<model_code>' and 'type' => 'product_model' instead of 'identifier'.

// Download a media file (returns a PSR-7 ResponseInterface with filename + mime type):
$response = $client->getProductMediaFileApi()->download($code);
```

Reference-entity and Asset-Manager media use a simpler `create($mediaFile): string` (no association array) — `getReferenceEntityMediaFileApi()->create($path)` and `getAssetMediaFileApi()->create($path)`. See `reference-entities-and-assets.md`. If a path can't be opened the client throws `RuntimeException`/`UnreadableFileException`.

## Exceptions & token refresh

Every request can throw an exception under `Akeneo\Pim\ApiClient\Exception`. All HTTP failures extend **`HttpException`** (itself a `RuntimeException`); the handler maps status codes to concrete subclasses (`Client/HttpExceptionHandler.php`). All implement the marker `ExceptionInterface`.

| HTTP | Exception class | Notes / extra methods |
| --- | --- | --- |
| 3xx | `RedirectionHttpException` | |
| 400 | `BadRequestHttpException` | Malformed JSON (rare via the client — it encodes for you) |
| 401 | `UnauthorizedHttpException` | Triggers automatic token refresh (below) |
| 403 | `ForbiddenHttpException` | Missing permission/scope |
| 404 | `NotFoundHttpException` | Unknown code **or** EE resource on a CE PIM |
| 405 | `MethodNotAllowedHttpException` | |
| 406 | `NotAcceptableHttpException` | |
| 415 | `UnsupportedMediaTypeHttpException` | |
| 422 | `UnprocessableEntityHttpException` | **`getResponseErrors(): array`** → per-property validation errors |
| 429 | `TooManyRequestsHttpException` | **`getRetryAfter(): int`** → seconds to wait (from `Retry-After`) |
| 4xx (other) | `ClientErrorHttpException` | Base for all 4xx |
| 5xx | `ServerErrorHttpException` | |

`HttpException` exposes `getRequest()`, `getResponse()`, `getCode()` (the status code), and `getMessage()`. Handle validation errors on writes:

```php
use Akeneo\Pim\ApiClient\Exception\UnprocessableEntityHttpException;
use Akeneo\Pim\ApiClient\Exception\TooManyRequestsHttpException;

try {
    $client->getProductApi()->upsert('top', $data);
} catch (UnprocessableEntityHttpException $e) {
    foreach ($e->getResponseErrors() as $error) {
        echo $error['property'] . ': ' . $error['message'] . "\n";
    }
} catch (TooManyRequestsHttpException $e) {
    sleep($e->getRetryAfter());
    // retry…
}
```

> **Automatic token refresh.** `AuthenticatedHttpClient` sets `Authorization: Bearer <token>` on every request. On a **401** it transparently calls `authenticateByRefreshToken` (using the stored `client_id`/`secret`/refresh token) and **retries once**; if the refresh itself fails (422) it rethrows the original 401. This means password/token-built clients self-heal expired access tokens — but **App-token clients cannot refresh** (no refresh token), so a revoked App token surfaces as an `UnauthorizedHttpException` you must handle by re-authorizing. See `authentication.md`.

## Gotchas

- **Responses are arrays, not objects.** Index into `$product['values']['name'][0]['data']`, etc. Nothing is typed.
- **`getCount()` is null** unless you pass `withCount = true` to `listPerPage`, and setting it true is slow on large collections. Cursors (`all()`) never provide a count.
- **Bulk `upsertList` can partially fail** with an overall 2xx — always iterate the returned `\Traversable` and check each line's `status_code`.
- **Don't require `akeneo/api-php-client-ee`** — it's archived and merged here (see top).
- **`create()` fails (422) if the resource exists**; use `upsert()` for idempotent create-or-update.
- **Stale docs prose:** the embedded `php-client/getting-started.md` still says "PHP ≥ 7.4" and "Guzzle v6 / HTTPlug" — the shipped `composer.json` is the source of truth (**PHP ≥ 8.2**, PSR-18/17). Trust `composer.json` and `src/`.

## Original sources

- `references/sources/api-php-client-source/src/AkeneoPimClientBuilder.php` — build methods, PSR discovery, options, cache
- `references/sources/api-php-client-source/src/AkeneoPimClientInterface.php` — all `get*Api()` getters (source of truth for names)
- `references/sources/api-php-client-source/src/Api/ProductApi.php`, `ProductUuidApi.php`, `ProductModelApi.php`, `ProductMediaFileApi.php` — read/write/media methods
- `references/sources/api-php-client-source/src/Api/AuthenticationApi.php`, `src/Client/AuthenticatedHttpClient.php`, `src/Security/Authentication.php` — token flow + auto-refresh
- `references/sources/api-php-client-source/src/Api/Operation/*.php` — Gettable/Listable/Creatable/Upsertable/Deletable contracts
- `references/sources/api-php-client-source/src/Pagination/PageInterface.php`, `ResourceCursor.php` — pagination
- `references/sources/api-php-client-source/src/Search/SearchBuilder.php`, `Operator.php` — filtering
- `references/sources/api-php-client-source/src/Exception/*.php`, `src/Client/HttpExceptionHandler.php` — exception hierarchy
- `references/sources/api-php-client-source/README.md`, `composer.json`, `CHANGELOG.md`
- `references/sources/akeneo-official-docs/php-client/` — `getting-started.md`, `authentication.md`, `list-resources.md`, `exception.md`, `http-client.md`, `introduction.md`, `resources/`
- Public docs: https://api.akeneo.com/php-client/introduction.html — Packagist: https://packagist.org/packages/akeneo/api-php-client
