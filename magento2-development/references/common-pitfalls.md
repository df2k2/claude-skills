# Common Pitfalls

A grab bag of mistakes that bite Magento developers regularly. Organized by symptom — "X isn't working, why?"

## "My change isn't appearing"

The single most common Magento problem. Run through this checklist before debugging deeper:

1. **Cache** — `bin/magento cache:flush`. Most fixes start here.
2. **Mode** — `bin/magento deploy:mode:show`. In `production`, code changes need `setup:di:compile`. View changes need `setup:static-content:deploy -f`.
3. **DI compile output stale** — `rm -rf generated/code generated/metadata && bin/magento setup:di:compile`.
4. **OPcache** — `service php-fpm reload`, or `opcache_reset()` (some hosts disable this), or restart php-fpm.
5. **Module enabled?** — `bin/magento module:status` lists disabled too. New modules in `app/code/` aren't enabled by default.
6. **`setup:upgrade` run?** — for new/changed modules.
7. **Static content version** — `pub/static/version` was bumped but the new files haven't synced to the webserver.
8. **Wrong area** — `etc/frontend/di.xml` won't affect admin requests. `etc/adminhtml/events.xml` won't fire on GraphQL.
9. **Theme override not at the right path** — `app/design/frontend/Vendor/theme/Magento_X/templates/foo.phtml` mirrors the module's path; case matters on Linux.
10. **Composer install** — third-party module file present but not autoloaded? `composer dump-autoload`.
11. **Browser cache** — hard refresh (Ctrl-Shift-R). Production mode hashes static URLs but the HTML referencing them might be cached.
12. **Varnish** — issue a PURGE or `varnishadm "ban ..."`.

## "Class … does not exist"

- DI compile output is stale or missing. `rm -rf generated/code generated/metadata && bin/magento setup:di:compile`.
- Namespace typo in the class declaration.
- File case mismatch — `Foo.php` vs `foo.php` on a Linux server.
- Module not enabled — `bin/magento module:enable Vendor_Module`.
- `composer.json` autoload entry missing or out of sync. `composer dump-autoload`.

## "Area code is not set"

You're calling Magento APIs from a CLI script or test without setting the area:
```php
$this->appState->setAreaCode(\Magento\Framework\App\Area::AREA_ADMINHTML);
```

For cron jobs, use `Area::AREA_CRONTAB`. For frontend simulation, `Area::AREA_FRONTEND`. Wrap in try/catch — if already set, an exception is thrown and you can swallow it.

## "Error 503 / Service Unavailable / Maintenance Mode"

- `var/.maintenance.flag` is present. `bin/magento maintenance:disable` or `rm var/.maintenance.flag`.
- A previous deploy left it. Common in CI/CD races.

## "Plugin not firing"

Plugins only intercept:
- **public** methods.
- on **non-final** classes (final classes/methods can't be intercepted).
- of objects resolved via the **DI container** (`new Foo()` bypasses).
- when the plugin's `<type>` matches what's actually injected somewhere — plugin on an interface fires on the implementation when the interface is used.

Verify:
- `bin/magento setup:di:compile` after creating the plugin (in production mode).
- The plugin XML is in the right area (`etc/di.xml` for global, `etc/frontend/di.xml` for frontend only).
- The plugin class name in XML matches the file exactly.
- No same-named plugin in another module set to `disabled="true"`.
- The target method is being called via DI — not as a constructor call or static method.

## "Observer not firing"

Same area/cache/typing rules as plugins. Plus:

- **Event name typo** — `sales_order_save_after` ≠ `order_save_after`. Names are exact.
- **Event not dispatched at the time you expect** — `*_save_after` runs INSIDE the transaction. If you need post-commit, use `*_save_commit_after`.
- **`shared="false"` on observers is rare** — leave default `true`.

## "Layout XML change isn't reflected"

- `bin/magento cache:clean layout block_html full_page`.
- File path wrong — handle name must match the actual handle (`catalog_product_view` not `catalog_product`).
- Module sequence — your layout XML merges AFTER the target's, so module load order matters.
- Production mode — `setup:static-content:deploy -f` regenerates layout/template fallback in `pub/static/`.

## "Template override doesn't work"

- Path mismatch. Magento's template at `vendor/magento/module-customer/view/frontend/templates/form/login.phtml` is overridden at:
  ```
  app/design/frontend/Acme/storefront/Magento_Customer/templates/form/login.phtml
  ```
  Note: `templates/` not `template/`. The path INSIDE `view/frontend/` is preserved exactly.
- Theme not set as active — `bin/magento config:show design/theme/theme_id`.
- Parent theme path different than expected — check `theme.xml` `<parent>`.

## "DI compilation fails with cryptic error"

- Missing argument names — a constructor parameter has no type hint AND no `<argument>` in `di.xml` AND no default.
- Cyclic dependency — A → B → A at construction. Add a Proxy on one of the legs.
- Plugin on a non-existent class.
- `<preference for>` points at a non-existent class/interface.
- Generated code dir not writable — check `generated/` permissions.
- Compilation hits memory limit — `php -d memory_limit=4G bin/magento setup:di:compile`.

Run `bin/magento setup:di:compile --debug` for more output.

## "Collection returns wrong size"

`$collection->getSize()` runs a separate COUNT query without limits — gives the total.
`$collection->count()` runs the full query and counts rows. With paging, this returns the page size.

Use `getSize()` for pagination totals; `count()` is rarely what you want.

## "n+1 queries on the storefront"

Symptom: page load takes 5 seconds and the slow query log fills up.

Common cause: looping over a product collection and calling `$product->getAttributeName()` for each, where the attribute wasn't preloaded.

```php
// Bad — N queries
foreach ($collection as $product) {
    echo $product->getDescription();   // each call → JOIN
}

// Good — pre-select
$collection->addAttributeToSelect(['description']);
foreach ($collection as $product) {
    echo $product->getDescription();   // already loaded
}
```

Also common: loading a category in a loop, loading the related products of each product in a loop.

## "Foreign key constraint fails on `setup:upgrade`"

- Referenced table doesn't exist yet — your module's `<sequence>` in `module.xml` doesn't list the parent module. Add it.
- Existing rows in the table violate the new FK — write a data patch BEFORE the schema change to clean orphans.
- `onDelete="CASCADE"` from your table to `sales_order` will cascade-delete on order deletion. Probably not what you want.

## "Patch ran in dev but not in production"

- `patch_list` row exists in dev DB but not prod. Both environments need their own DB tracking.
- Patch class was renamed without `getAliases()` returning the old name. Magento re-applies as a different patch.
- Patch class is unreadable (file permission, syntax error). Check `var/log/system.log` after `setup:upgrade`.

## "REST endpoint returns 404"

- `etc/webapi.xml` not in the global `etc/` (it's a multi-area file, not `etc/frontend/`).
- `cache:clean config config_webservice` not run.
- URL path doesn't include `/rest/V1/` prefix.
- HTTP method mismatch — endpoint declares POST but you're sending GET.

## "REST endpoint returns 401 / 403"

- `<resource ref="anonymous"/>` missing.
- Bearer token expired or revoked.
- Token doesn't have permission for the resource (integration tokens are scoped).
- Customer token used against admin endpoint.

## "GraphQL returns null for non-nullable field"

- Resolver returned the wrong shape (missing key, or array of wrong type).
- Resolver threw an exception that was swallowed.
- Cache `config_webservice` not cleared after schema change.

Add a `@cache(cacheIdentity: "...")` to dynamic queries or they'll get cached as the FIRST customer's result.

## "Add to cart doesn't update minicart"

- `sections.xml` doesn't include the action that's being POSTed.
- Customer-data isn't being invalidated by the response — check the `Set-Cookie` for `section_data_ids` after the add-to-cart request.
- JS console errors swallowed — open the browser console.

## "Indexer:reindex hangs forever"

- A row in `cron_schedule` for this indexer is stuck `running`. Kill it.
- Memory limit — raise CLI's `memory_limit` to 4G+.
- MEMORY engine table for an EAV indexer ran out — convert to InnoDB.
- DB deadlock — `SHOW ENGINE INNODB STATUS`.

## "I deleted a column from `db_schema.xml` and Magento didn't drop it"

The column isn't in `etc/db_schema_whitelist.json`. Run:
```
bin/magento setup:db-declaration:generate-whitelist --module-name=Vendor_Module
```
Then `bin/magento setup:upgrade`. (Don't forget to commit the updated whitelist.)

## "I dropped a column then changed my mind"

If `setup:upgrade` already ran, the column is gone. Restore from backup or recreate via a schema patch.

## "Translations not appearing"

- `i18n/<locale>.csv` not in the module root.
- Wrong encoding (must be UTF-8 without BOM).
- `cache:clean translate` not run.
- In production, `setup:static-content:deploy <locale>` must include your locale.
- Test with `__('Source')` — the source string must MATCH the first column exactly (whitespace, punctuation).

## "JS error: `mage` is not defined"

The mage init script didn't load. Causes:
- `requirejs-config.js` missing or broken syntax.
- Wrong area — frontend RequireJS config won't load in admin.
- Static content deploy didn't run after edits.

## "JavaScript mixin not applied"

- `requirejs-config.js` not in the right place (`view/<area>/requirejs-config.js`).
- Mixin function signature wrong — should be `function (Component) { return Component.extend({...}) }`.
- Cache `view_preprocessed` not cleared. `rm -rf var/view_preprocessed pub/static/<area>/<theme>/<locale>/.js/`.

## "Admin grid is empty"

- DataProvider class typo'd.
- Collection isn't registered in `di.xml` for `CollectionFactory`'s `collections` array.
- `_idFieldName` mismatch with `primaryFieldName` in the listing XML.
- `is_active` filter excluding all rows.

## "Form save says success but nothing changed"

- Save controller catches an exception silently — check logs.
- DataProvider's `getData()` returns wrong shape — Magento can't map fields back.
- `dataScope` in form XML doesn't match the model's data keys.
- `Save` controller doesn't actually call `setData($data)` on the model.

## "Sensitive config value lost after deploy"

`config:sensitive:set` writes to `env.php`. If your CI overwrites `env.php` from a template, the value is gone. Either:
- Re-set after every deploy.
- Use environment variables (`bin/magento config:set ... --lock-env`).

## "Encryption key regenerated, encrypted values now garbage"

The encryption key in `env.php` `crypt/key` must match what was used to encrypt the values. If you regenerated and didn't `bin/magento encryption:key:change`, the old encrypted values can't be decrypted.

Restore the old key (separated by `\n` from the new, allowing both during transition).

## "Cron isn't running"

- `bin/magento cron:install` not run.
- `/etc/cron.d/...` entries reverted by a deploy.
- The cron user can't read/write `var/`.
- Multiple cron processes overlap (cron jobs taking >60s) — use a lock file or systemd timer.
- `cron_schedule` clogged — `DELETE FROM cron_schedule WHERE status='pending'`.

## "Queue consumer says it's running but nothing happens"

- Topic name typo in `communication.xml` or in the publisher.
- Cache `config` not cleared.
- Wrong `connection` in `queue_consumer.xml` — `amqp` doesn't exist on a DB-only setup.
- Handler method's signature doesn't match the topic's `request=` type.

## "Magento web installer doesn't load"

(Don't use the web installer in production.) Use CLI:
```
bin/magento setup:install ...
```

The web installer hasn't been a supported install path since 2.4.

## "Composer require fails with `repo.magento.com` 401"

Your `auth.json` is missing or has stale keys. Get fresh ones from the Marketplace and:
```
{
    "http-basic": {
        "repo.magento.com": {
            "username": "<public_key>",
            "password": "<private_key>"
        }
    }
}
```
At `~/.composer/auth.json` or `<magento>/auth.json`.

## "Hyvä storefront — generic Magento JS advice doesn't work"

If the store uses Hyvä, Knockout/RequireJS/UI components are NOT loaded on the storefront. Use the **`hyva-magento2-development`** skill. The PHP layer is the same; only the JS/CSS layer differs.

## "Saves are slow (5+ seconds)"

- An indexer is in `realtime` mode. Switch to `schedule`.
- Many observers/plugins on `*_save_after`. Profile to find the slow one.
- DB write lock contention. Check `SHOW PROCESSLIST`.
- A `setup:di:compile` hasn't been run, so a Factory is being generated on every request.

## "Logs say `Notice: Undefined index 'foo'` on every page"

Some module is reading a missing config/data key. Look at the call stack in `system.log`. Often a third-party module added a config value and didn't ship the schema patch to default it.

## "Magento Marketplace EQP scan rejects my extension"

- Missing or weak escaping in templates. Use `$escaper->escapeHtml/escapeUrl/escapeHtmlAttr` everywhere.
- `$this->_objectManager` references anywhere except constructors of certain bootstrap classes.
- `var_dump`, `print_r`, `error_log` left in code.
- Direct SQL in templates.
- Hardcoded URLs.
- Mixing `use` and FQCN in the same class.
- See `references/sources/commerce-php/coding-standards/` for the full set.

## Final fallback: read the logs

```
tail -f var/log/exception.log
tail -f var/log/system.log
tail -f var/log/debug.log         # enable with: bin/magento setup:config:set --enable-debug-logging=true
tail -f var/log/magento.cron.log
```

Plus PHP logs (`/var/log/php-fpm.log` or per-distro) and the webserver's error log.

## Original sources

- `references/sources/commerce-php/best-practices/` — best practices.
- `references/sources/commerce-php/coding-standards/` — code style.
- `references/sources/devdocs-v2.4/ext-best-practices/` — older best practices.
- `references/sources/devdocs-v2.4/coding-standards/` — older style.
- `references/sources/commerce-php/development/security/` — security guide.
