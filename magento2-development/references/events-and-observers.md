# Events and Observers

Magento dispatches **events** at meaningful moments. **Observers** subscribe to those events and react. Unlike plugins (which modify a specific method's args/return), observers are "fire and forget" — they receive context, do work, and return nothing.

## Anatomy

`etc/events.xml` (global), `etc/frontend/events.xml`, `etc/adminhtml/events.xml`, etc.:

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Event/etc/events.xsd">
    <event name="sales_model_service_quote_submit_before">
        <observer name="acme_giftwrap_copy_message"
                  instance="Acme\GiftWrap\Observer\CopyQuoteMessageToOrder"
                  disabled="false"
                  shared="true"/>
    </event>
</config>
```

- `<event name>` — event name. Magento dispatches dozens of events; the name must match exactly (snake_case, often `entity_action_when` like `sales_order_save_after`).
- `<observer name>` — unique-per-event identifier. Reusing a name elsewhere overrides the original observer's config (useful for disabling).
- `instance` — observer class FQCN.
- `disabled` — defaults to false. Set true to disable an inherited observer.
- `shared` — defaults to true. Set false to construct a new observer per dispatch (rare).

Observer class:

```php
<?php
namespace Acme\GiftWrap\Observer;

use Magento\Framework\Event\Observer;
use Magento\Framework\Event\ObserverInterface;

class CopyQuoteMessageToOrder implements ObserverInterface
{
    public function execute(Observer $observer): void
    {
        $quote = $observer->getEvent()->getQuote();
        $order = $observer->getEvent()->getOrder();
        $order->setData('gift_wrap_message', $quote->getData('gift_wrap_message'));
    }
}
```

The `$observer` arg always provides:
- `$observer->getEvent()` — a `\Magento\Framework\Event` object holding the event data.
- `$observer->getData('foo')` — direct shortcut to event data (`$observer->getEvent()->getFoo()` also works).

The available data per event is set by the dispatcher. For `sales_model_service_quote_submit_before`, the dispatcher passes `['quote' => $quote, 'order' => $order]`, so you read those keys.

## Areas matter

`etc/events.xml` fires in ALL areas. `etc/frontend/events.xml` fires only during frontend requests. `etc/adminhtml/events.xml` only in admin. Same for `webapi_rest`, `webapi_soap`, `graphql`, `crontab`.

A common bug: putting `customer_register_success` in `etc/events.xml` when you actually only want it on the storefront — works, but fires on REST registration too. If that's not desired, move it to `etc/frontend/events.xml`.

## Dispatching your own events

```php
namespace Acme\Hello\Service;

use Magento\Framework\Event\ManagerInterface as EventManager;

class Importer
{
    public function __construct(
        private readonly EventManager $eventManager
    ) {}

    public function import(array $row): void
    {
        // ...
        $this->eventManager->dispatch(
            'acme_hello_row_imported',
            ['row' => $row, 'imported_at' => time()]
        );
    }
}
```

Naming: `vendor_module_action_when` (snake_case). Document the event name and the data shape in the module's README so consumers know what to subscribe to.

## Discovering events

There's no central registry. Search the codebase:

```bash
# Search for all event dispatches in vendor/magento
grep -rn "->dispatch(" vendor/magento --include='*.php' | head -30
```

Plus the embedded docs:

```bash
grep -rln "_save_after\|_save_before\|_load_after" references/sources/devdocs-v2.4/extension-dev-guide/events-and-observers.md
```

Common high-traffic events:

| Event | When | Data |
| --- | --- | --- |
| `customer_register_success` | Customer finished registering (frontend) | `customer`, `account_controller` |
| `customer_login` | After successful login | `customer` |
| `customer_logout` | Before logout | `customer` |
| `controller_action_predispatch` | Before any controller action | `controller_action`, `request` |
| `controller_action_postdispatch` | After any controller action | `controller_action`, `request`, `response` |
| `sales_order_place_before` | Before order is placed | `order` |
| `sales_order_place_after` | After order is placed | `order` |
| `sales_order_save_before` / `_after` | Before/after order save | `order` |
| `sales_order_state_change_after` | Order state changed | `order` |
| `sales_quote_save_before` / `_after` | Quote (cart) save | `quote` |
| `sales_model_service_quote_submit_before` | Quote → order conversion | `quote`, `order` |
| `sales_model_service_quote_submit_success` | Quote → order conversion succeeded | `quote`, `order` |
| `checkout_cart_add_product_complete` | Product added to cart | `product`, `request`, `response` |
| `checkout_onepage_controller_success_action` | Order success page rendered | `order_ids` |
| `catalog_product_save_before` / `_after` / `_commit_after` | Product save | `product`, `data_object` |
| `catalog_category_save_before` / `_after` | Category save | `category`, `data_object` |
| `catalog_product_collection_load_before` | Product collection load | `collection` |
| `cms_page_save_after` | CMS page saved | `object` |
| `model_save_after` / `_before` | Universal (every AbstractModel save) | `object` |
| `model_load_after` | Universal (every AbstractModel load) | `object` |
| `model_delete_before` / `_after` | Universal delete | `object` |
| `*_save_commit_after` | After DB commit (use for triggering async work) | varies |
| `admin_user_authenticate_before` / `_after` | Admin login attempt | varies |
| `customer_address_save_after` | Customer address saved | `customer_address` |
| `theme_save_after` | Theme record saved (admin) | `theme` |
| `clean_cache_by_tags` | Cache invalidation by tag | `object` |
| `application_clean_cache` | Generic cache clean | `tags` |

For collection loads, the dispatcher also emits a "named" event: `_collection_load_before` becomes `<entity>_collection_load_before`, e.g. `catalog_product_collection_load_before` (you can modify the collection here — useful for adding fields/filters globally).

## Event vs. plugin — which to use?

Use **events/observers** when:
- A "notification" is enough; you don't need to alter what just happened.
- Multiple unrelated consumers might want to react.
- The hook point already dispatches an event (don't add a plugin if a perfect event exists).
- You want to be safe across Magento upgrades — events are part of the public contract more than internal classes are.

Use **plugins** when:
- You need to modify the arguments or return value of a specific method.
- No event exists at the spot you need.
- You need fine sort-order control vs. other modules' hooks.

Edge cases:
- **A plugin can dispatch an event that other modules then subscribe to.** This is a useful pattern for letting third parties extend your module without granting them a plugin on your code.
- **An observer can throw exceptions** to abort the dispatching action — but only some events catch them. `*_save_before` events typically do; `*_save_after` typically don't. Don't rely on aborting from an observer unless you've verified it.

## "Commit" events — the important distinction

For models using transactions (most), `*_save_after` fires INSIDE the transaction. If something downstream rolls back, your observer already ran. `*_save_commit_after` fires AFTER the transaction commits.

**Rule**: if your observer triggers external side effects (HTTP calls, emails, queue messages), subscribe to `*_save_commit_after`, NOT `*_save_after`. Otherwise you'll dispatch on rolled-back saves.

```xml
<event name="sales_order_save_commit_after">
    <observer name="acme_send_to_erp" instance="Acme\Erp\Observer\SendOrder"/>
</event>
```

## Observer best practices

- **One responsibility per observer**. Don't stuff multiple side effects into one class. Easier to disable/test.
- **Don't do heavy I/O synchronously**. If your work could take >100ms, enqueue a message and process it in a consumer.
- **Catch and log exceptions** unless you specifically want to abort the action. Uncaught exceptions in `*_save_before` observers will halt the save with an error visible to the user.
- **Don't modify the event data object's keys you didn't add**. Reading is fine; rewriting is fragile.
- **Use `disabled="true"` to switch off inherited observers** rather than deleting other modules' XML.

## Disabling another module's observer

```xml
<event name="checkout_onepage_controller_success_action">
    <observer name="ecommerce_admin_observer_name_from_third_party" disabled="true"/>
</event>
```

The observer name must match exactly. Add this to YOUR module's `events.xml`. Make sure your module is sequenced AFTER the one whose observer you're disabling.

## Common gotchas

### Observer fires twice
Two common causes:
1. Same observer XML declared in `events.xml` AND `frontend/events.xml` — Magento merges, and the observer runs once in frontend and once in non-frontend, both per request.
2. The event itself is dispatched twice (e.g., `model_save_after` and the specific `entity_save_after` for the same save).

### "Class … does not exist"
After creating the observer, in production you need `setup:di:compile`. Cache flush won't help by itself if compile output is stale.

### Observer doesn't fire
- Wrong area (check the folder).
- Wrong event name — `sales_order_save_after` vs `order_save_after` is not the same.
- Cache not cleared after editing `events.xml` (`cache:clean config`).
- Module not enabled.

### Modifying the order/quote after `place_after`
That's too late. The order is already placed and the success email is queued. Use `place_before` or earlier.

### Observer throws and breaks checkout
You forgot the try/catch. Wrap external calls. Log exceptions; don't bubble them up unless you want to abort the action.

## Example: dispatch + observe pattern in one module

`Acme\Newsletter\Service\Subscribe`:
```php
public function subscribe(string $email): void
{
    $this->repo->save($email);
    $this->eventManager->dispatch(
        'acme_newsletter_subscribed',
        ['email' => $email]
    );
}
```

`Acme\Newsletter\etc\events.xml`:
```xml
<event name="acme_newsletter_subscribed">
    <observer name="acme_newsletter_send_welcome"
              instance="Acme\Newsletter\Observer\SendWelcomeEmail"/>
</event>
```

`Acme\Newsletter\Observer\SendWelcomeEmail`:
```php
public function execute(Observer $observer): void
{
    $email = $observer->getEvent()->getEmail();
    $this->mailer->sendWelcome($email);
}
```

Now any third-party module can ALSO subscribe to `acme_newsletter_subscribed` and react — without you having to design a callback mechanism.

## Original sources

- `references/sources/commerce-php/development/components/events-and-observers/` — full event docs.
- `references/sources/devdocs-v2.4/extension-dev-guide/events-and-observers.md` — older guide.
- `references/sources/devdocs-v2.4/ext-best-practices/extension-coding/observers-bp.md` — best practices.
