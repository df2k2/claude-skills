# Operations and Deploy Workflow

Magento has an unusually elaborate deploy step. Get the order wrong and pages 404, layout XML changes don't take effect, or admin shows the unstyled-grid-of-doom. This file is the cheat sheet for the operational lifecycle.

## The three modes

```
bin/magento deploy:mode:show
bin/magento deploy:mode:set developer      # dev
bin/magento deploy:mode:set default        # mixed (rare)
bin/magento deploy:mode:set production     # prod
```

| | developer | default | production |
| --- | --- | --- | --- |
| Error display | Full | Logged + masked | Logged + masked |
| Static content | Generated on-demand | Mostly on-demand | MUST pre-deploy |
| DI compilation | On-demand | Auto | MUST `setup:di:compile` |
| `pub/static/_cache/` | Generated | Generated | Locked |
| Symlinks for view files | Yes | Yes | No |
| Translation lookup | On-demand | Cached | Cached |
| Best for | Local dev | Staging/QA | Prod |

In **developer** mode you can usually skip `setup:di:compile` and `setup:static-content:deploy` — Magento handles it on-demand at slow first-hit speed. In **production** both are mandatory.

`bin/magento deploy:mode:set production` does NOT compile DI or deploy static content for you. You must follow up:
```
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f en_US
bin/magento cache:flush
```

## `app/etc/config.php` vs `app/etc/env.php`

Two configuration files at the root. The difference matters.

### `config.php` — committed to git

```php
<?php
return [
    'modules' => [
        'Magento_Store' => 1,
        'Acme_GiftWrap' => 1,
        // ...
    ],
    'app_env' => [
        'system' => [
            'default' => [
                'acme_giftwrap' => [
                    'general' => [
                        'enabled' => '1',
                    ],
                ],
            ],
        ],
    ],
];
```

- Module enabled/disabled state.
- Non-sensitive system config values "pinned" via `config:set`.
- Anything you want shared across environments.

Commit it. `bin/magento app:config:dump` exports the current DB config into this file.

### `env.php` — NOT committed

```php
<?php
return [
    'backend' => ['frontName' => 'admin'],
    'queue' => ['amqp' => ['host' => '...', 'port' => '5672', ...]],
    'crypt' => ['key' => '0123abc...'],     // encryption key — KEEP THIS
    'db' => [
        'connection' => [
            'default' => [
                'host' => 'db',
                'dbname' => 'magento',
                'username' => 'magento',
                'password' => 'redacted',
                'model' => 'mysql4',
                'engine' => 'innodb',
                'active' => '1'
            ]
        ]
    ],
    'cache' => [
        'frontend' => [
            'default' => [...],
            'page_cache' => [...]
        ]
    ],
    'session' => [...],
    'install' => ['date' => 'Wed, 1 Jan 2025 00:00:00 +0000'],
    'MAGE_MODE' => 'production',
    'system' => [
        'default' => [
            'acme_giftwrap' => [
                'general' => [
                    'api_key' => '0:3:abcd1234...'    // encrypted, sensitive
                ]
            ]
        ]
    ],
    'cron_consumers_runner' => [...],
    'mview' => ['threads' => 4],
    'static_content_on_demand_in_production' => 0,
];
```

- DB credentials, encryption key, Redis hosts, RabbitMQ creds.
- Sensitive system config values set via `bin/magento config:sensitive:set`.

**NEVER commit `env.php`.** Add to `.gitignore` if not already.

### Pinning a config value

```bash
# Non-sensitive — goes to DB by default, optionally write to config.php
bin/magento config:set acme_giftwrap/general/enabled 1
bin/magento config:set acme_giftwrap/general/enabled 1 --lock-config       # also write to config.php

# Sensitive — goes to env.php
bin/magento config:sensitive:set acme_giftwrap/general/api_key "secret"

# Env-specific (writes ${ACME_GIFTWRAP_API_KEY} reference)
bin/magento config:set acme_giftwrap/general/api_key "${ACME_GIFTWRAP_API_KEY}" --lock-env
```

After `config:set --lock-config`, the value is in `config.php` and CAN'T be edited in admin until you `config:set --unlock-config` or `--lock-env`.

`bin/magento app:config:import` reads `config.php` and applies it to the DB. Useful for deploys: edit config.php, push, deploy → magento applies on `setup:upgrade`.

## Composer workflow

Magento is Composer-installed. Update modules with:

```bash
composer require vendor/module-foo:^1.2
composer update vendor/module-foo
composer remove vendor/module-foo
composer install --no-dev --optimize-autoloader   # production
```

After Composer changes:
```
bin/magento module:enable Vendor_ModuleFoo   # if not auto-enabled
bin/magento setup:upgrade
bin/magento setup:db-declaration:generate-whitelist     # if schema changed
bin/magento setup:di:compile        # default/production
bin/magento setup:static-content:deploy -f              # production
bin/magento cache:flush
```

### `auth.json` for paid Magento packages

For Adobe Commerce or paid third-party modules, you need auth in `~/.composer/auth.json` (or `<magento>/auth.json`):

```json
{
    "http-basic": {
        "repo.magento.com": {
            "username": "<public_key>",
            "password": "<private_key>"
        }
    }
}
```

Get keys from the Magento Marketplace.

### Pinning Magento version

```json
{
    "require": {
        "magento/product-community-edition": "2.4.7-p5",
        "magento/composer-root-update-plugin": "^2.0"
    }
}
```

The `composer-root-update-plugin` is **required** for safe Magento upgrades — it merges your customizations with the new Magento root composer.json instead of overwriting.

## Full deploy sequence

Standard deploy of a Magento store to production:

```bash
# On the developer machine — build artifact
git pull
composer install --no-dev --optimize-autoloader
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f en_US fr_FR de_DE
# Tar up: vendor/, generated/, pub/static/, app/etc/config.php

# On production
ssh prod
bin/magento maintenance:enable
# upload the tarball, replace files atomically
bin/magento app:config:import        # apply pinned config changes
bin/magento setup:upgrade            # apply schema patches, register new modules
bin/magento setup:db-declaration:generate-whitelist     # only if you edited schema this deploy
bin/magento cache:flush
bin/magento maintenance:disable
```

If using zero-downtime deploys (symlink-swap), the order changes — the build artifact is staged in a new release dir, then the symlink `current` is swapped, then maintenance is briefly engaged for `setup:upgrade` (or use `app:config:import` with `--no-interaction` if there are no patches).

### Adobe Commerce on Cloud (ECE-Tools)

For Adobe Commerce on Cloud, the workflow is fully automated:

```
magento-cloud environment:branch <name>
git push origin <name>      # triggers a build and deploy
```

`ece-tools` handles the steps via `.magento.env.yaml`:
- `build` — `composer install`, `setup:di:compile`, `setup:static-content:deploy`.
- `deploy` — pull pre-built artifact, `app:config:import`, `setup:upgrade`, cache, etc.
- `post-deploy` — warm caches.

You can customize the order and which static content to deploy via `.magento.env.yaml`. The defaults are good for most stores.

## Magento Bin commands cheat sheet

```
# Mode
bin/magento deploy:mode:show
bin/magento deploy:mode:set developer|default|production [--skip-compilation]

# Modules
bin/magento module:status
bin/magento module:enable Vendor_Module [--clear-static-content]
bin/magento module:disable Vendor_Module
bin/magento module:uninstall Vendor_Module    # Composer-installed only

# Setup
bin/magento setup:upgrade [--keep-generated]
bin/magento setup:upgrade --dry-run             # 2.4+
bin/magento setup:di:compile
bin/magento setup:static-content:deploy [-f] [--theme=...] [--area=...] [<locale> ...]
bin/magento setup:db-declaration:generate-whitelist --module-name=Vendor_Module
bin/magento setup:db-data:upgrade
bin/magento setup:db-schema:upgrade
bin/magento setup:store-config:set --base-url=https://example.com/

# Cache
bin/magento cache:status
bin/magento cache:enable [type ...]
bin/magento cache:disable [type ...]
bin/magento cache:clean [type ...]              # invalidate
bin/magento cache:flush [type ...]              # nuke

# Maintenance
bin/magento maintenance:enable [--ip=1.2.3.4]
bin/magento maintenance:disable
bin/magento maintenance:status

# Indexers
bin/magento indexer:info
bin/magento indexer:status
bin/magento indexer:show-mode
bin/magento indexer:set-mode realtime|schedule [<id> ...] [--all]
bin/magento indexer:reindex [<id> ...]
bin/magento indexer:reset

# Cron
bin/magento cron:install [--force]
bin/magento cron:remove
bin/magento cron:run [--group=default]

# Queue
bin/magento queue:consumers:list
bin/magento queue:consumers:start <name> [--max-messages=N] [--single-thread]

# Config
bin/magento config:show
bin/magento config:show <path>                  # e.g. web/secure/base_url
bin/magento config:set <path> <value> [--scope=default|website|store] [--scope-code=<code>] [--lock-config] [--lock-env]
bin/magento config:sensitive:set <path> <value>
bin/magento config:reference                    # list every known config path

# Catalog
bin/magento catalog:images:resize
bin/magento catalog:product:attributes:cleanup
bin/magento catalog:reindex:reset

# Customer
bin/magento customer:hash:upgrade

# Encryption
bin/magento encryption:key:change [--key=<new_key>]

# Admin user
bin/magento admin:user:create --admin-user=joe --admin-password=Joe1234! --admin-email=joe@x.com --admin-firstname=Joe --admin-lastname=Smith
bin/magento admin:user:unlock joe

# Info
bin/magento info:adminuri
bin/magento info:backups:list
bin/magento info:currency:list
bin/magento info:dependencies:show-modules
bin/magento info:language:list
bin/magento info:timezone:list

# Dev
bin/magento dev:source-theme:deploy <files> [--type=less] [--locale=en_US] [--theme=Vendor/theme]
bin/magento dev:tests:run [type]
bin/magento dev:profiler:enable|disable

# Sample data (Open Source / Adobe Commerce)
bin/magento sampledata:deploy
bin/magento sampledata:remove
bin/magento sampledata:reset
```

`bin/magento list` shows every command, with descriptions.

## Logs

Magento writes to `var/log/`:

| File | What |
| --- | --- |
| `exception.log` | Uncaught exceptions |
| `system.log` | INFO/NOTICE-level messages, indexer activity |
| `debug.log` | DEBUG messages (only in developer mode by default) |
| `support_report.log` | Internal reporting |
| `cron.log` | Cron job output (when shell runs `bin/magento cron:run`) |
| `payment.log` | Payment integration debug (Stripe, Braggart, etc.) |
| `update.log` | Magento Web Setup Wizard (rarely used) |

Custom loggers can target their own file via virtual types — see `dependency-injection.md`.

To enable debug logging in production temporarily:
```
bin/magento setup:config:set --enable-debug-logging=true
```

## Maintenance mode

`bin/magento maintenance:enable` writes `var/.maintenance.flag`. Magento webserver entrypoints check this file and serve `pub/errors/503.phtml` if present.

```
bin/magento maintenance:enable --ip=1.2.3.4,5.6.7.8   # let your IPs through
bin/magento maintenance:disable
bin/magento maintenance:status
```

Maintenance mode does NOT stop cron, consumer processes, or CLI work. It only halts HTTP requests for non-allowed IPs.

## Backups (deprecated)

`bin/magento setup:backup` and `bin/magento setup:rollback` are deprecated. Use server-level tools (`mysqldump`, `rsync`, snapshots).

## Two-factor auth

Magento 2.4+ requires 2FA for the admin. To configure for a new install:
```
bin/magento module:enable Magento_TwoFactorAuth   # already enabled by default
# In admin: System → Permissions → 2FA → ...
```

To disable for dev (local-only):
```
bin/magento module:disable Magento_TwoFactorAuth
bin/magento setup:upgrade
bin/magento cache:flush
```

## Encryption key rotation

```
bin/magento encryption:key:change
```
Generates a new key, re-encrypts all encrypted config values. The OLD key is appended to `crypt/key` in env.php (as `\n`-separated) so historic data is still readable. Plan downtime — re-encryption can take minutes on big stores.

## `app:config:dump` and `app:config:import`

```
bin/magento app:config:dump
```
Exports the current DB system config into `app/etc/config.php`. Commit it. On other environments:
```
bin/magento app:config:import
```
Applies it to the DB. Useful for pinning config that should be version-controlled (e.g., enabled modules, currency settings, default email senders).

`config:dump` exports ALMOST everything by default. Use `bin/magento config:show` to inspect a specific path.

## Common gotchas

### "My production deploy 500s on every page"
99% of the time: missing `setup:di:compile`. Logs say "Class … does not exist" — the Interceptor wasn't generated. Run di:compile, flush cache, restart php-fpm.

### "I changed env.php and Magento still shows old values"
- OPcache. Restart php-fpm.
- `cache_types` table has the cache enable/disable state — `cache:enable` writes there. Restart Redis to confirm a clean state.

### "After `setup:upgrade` everything is broken"
- A patch failed silently (check `var/log/system.log` and `exception.log`).
- A schema patch left the DB partial. Roll back to a snapshot.
- A third-party module's `setup_version` is older than its actual schema — `module.xml` is wrong.

### "Module isn't auto-enabled after `composer require`"
Newer Magento doesn't auto-enable for safety. Run `bin/magento module:enable Vendor_Module && bin/magento setup:upgrade`.

### "I get `Class Acme\Module\Model\Foo\Interceptor does not exist`"
DI compile output is stale. `rm -rf generated/code/Acme generated/metadata/* && bin/magento setup:di:compile`.

### "`pub/static/version1234567890/` 404s"
Static content version file (`pub/static/version`) was bumped but the static deploy hasn't synced to the webserver yet. Wait, or re-deploy static content.

### "`setup:static-content:deploy` runs forever on Cloud"
Pass `--theme` to scope it. Adobe Commerce stores often have dozens of locales × themes. Deploy only the active ones.

### "Maintenance mode persists after `maintenance:disable`"
`var/.maintenance.flag` is still present (permissions issue or symlink target). Delete it manually.

### "`composer install` complains about plugins"
Magento 2.4.4+ uses `allow-plugins` in composer config. If you upgraded composer to 2.2+ and the root composer.json doesn't list Magento's plugins, `composer install` blocks. Add to root composer.json:
```json
"config": {
    "allow-plugins": {
        "magento/composer-dependency-version-audit-plugin": true,
        "magento/composer-root-update-plugin": true,
        "magento/inventory-composer-installer": true,
        "magento/magento-composer-installer": true,
        "dealerdirect/phpcodesniffer-composer-installer": true,
        "laminas/laminas-dependency-plugin": true
    }
}
```

### "Admin URL forgot / can't log in"
- `bin/magento info:adminuri` — shows the path.
- `bin/magento admin:user:create ...` — make a new admin.
- `bin/magento admin:user:unlock <user>` — unlock a locked admin.

## Original sources

- `references/sources/commerce-php/development/build/` — build process.
- `references/sources/commerce-php/development/configuration/` — env.php, config.php.
- `references/sources/commerce-php/development/cli-commands/` — every CLI command.
- `references/sources/devdocs-v2.4/config-guide/` — comprehensive config guide.
- `references/sources/devdocs-v2.4/comp-mgr/` — Component Manager (web UI for module enable/disable, deprecated).
- `references/sources/devdocs-v2.4/install-gde/` — installation guide.
