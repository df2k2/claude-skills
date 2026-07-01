# Upgrade & Versions

Version compatibility, how the connector is versioned, how to upgrade safely, migrating from PIMGento 2, and a digest of the 105.x CHANGELOG. The embedded source is pinned at **v105.1.2**.

## Version / compatibility matrix

Pick the connector line by your Magento **and** PHP version (from the module README):

| Connector line | Magento / Adobe Commerce | PHP | Status | Notes |
| --- | --- | --- | --- | --- |
| **103.x** | ≥ 2.3.7 && < 2.4.4 | ≥ 7.4 | **EOL** | No fixes. 103.0.0 moved to Symfony HTTP Client + Akeneo API client v9. |
| **104.x** | ≥ 2.4.4 && < 2.4.7 | ≥ 8.0 | **Bug fixes only** | 104.0.0 bumped Akeneo API client to 11.2.0; added single-store mode, InnoDB temp tables. |
| **105.x** | ≥ 2.4.7 | ≥ 8.2 | **Current** | Embedded here at **v105.1.2**. Akeneo API client 11.4.0; PHP 8.4 compatible. |

- **Akeneo PIM ≥ 3.2** (CE & EE; EE-specific features not imported). DB charset **UTF-8**. See `getting-started.md` for full requirements.
- **Trust this matrix, not the `composer.json` constraints.** The 105.1.2 `composer.json` declares loose bounds (`"php": ">=8.0"`, `"magento/framework": ">=102.0.0"`), so Composer may permit an unsupported combo. The rows above are the supported combinations.

### `psr/http-message` caveat (105.x vs 104.x)

`akeneo/api-php-client` (11.4.0, used by 105.x) requires **`psr/http-message ≥ 2.0`**. If another package in your project pins `psr/http-message` to 1.x and Composer can't resolve it, drop to **connector 104.x**, which uses an older client (11.2.0) and the 1.x line. This is the single most common upgrade blocker on the 105.x line.

## How versioning works (the confusing part)

- The module is released as **git tags** `103.x.x`, `104.x.x`, `105.x.x` (semver per line). The embedded copy is `v105.1.2`; see `.source-tag` and the `version` field in `composer.json`.
- The **help-center docs live under `help.akeneo.com/magento2-connector/v100/`**. That `v100` is the **documentation-site slug, not a module version.** Do not read "v100" as "connector 100.x." (Some newer CHANGELOG links drop the `/v100/` segment entirely.)
- Module internals: module name `Akeneo_Connector`, `etc/module.xml` `setup_version` `1.0.5` (independent of the composer/package version).

## Upgrade steps

1. **Back up** the database and code, and **test in staging first.** Some connector upgrades carry compatibility breaks (see below).
2. **Update the constraint** to the target line and pull it:

   ```bash
   composer require "akeneo/module-magento2-connector-community:~105.1"
   # (or edit composer.json, then: composer update akeneo/module-magento2-connector-community)
   ```

3. **Apply and rebuild:**

   ```bash
   bin/magento setup:upgrade
   bin/magento setup:di:compile          # production mode
   bin/magento setup:static-content:deploy   # production mode
   bin/magento cache:flush
   bin/magento indexer:reindex
   ```

4. **Re-check configuration** under *Stores → Configuration → Catalog → Akeneo Connector* (`configuration.md`) — some releases add/rename settings (Akeneo Edition selector, status mode, cache/index-flush choices) that need to be set after upgrading.
5. **Run a category → family → attribute → option → product import in staging** and verify the *Jobs* grid / `akeneo_connector_job` table before promoting. See `running-imports.md`.

`setup:upgrade`, `di:compile`, mode switching, and reindex are generic Magento mechanics — see the **`magento2-development`** skill.

### Upgrade hazards worth knowing (from CHANGELOG "Warning" notes)

Crossing these releases requires manual action, so an upgrade from an old install may need more than a Composer bump:

- **102.0.0** — introduced the **asynchronous import system** (`akeneo_connector_job` table + the `akeneo_connector_launch_scheduled_job` cron). **Magento cron must be running** or scheduled jobs never launch.
- **101.0.0** — merged the old **"Product Model"** and **"Family Variant"** jobs into the **`product`** job (per-family import). **Remove any old cron entries** for those two jobs and audit customizations against the compatibility break.
- **100.4.4** — class reformatting / scope changes: recompile, flush cache, and audit custom code after upgrading.

## Migrating from PIMGento 2

This connector is the **successor to PIMGento 2** (both by Agence Dn'D). Migrating from a legacy PIMGento 2 install is not a plain Composer swap — table names, job structure, and configuration differ. Follow the vendor migration guides at **https://help.akeneo.com/magento2-connector/v100/articles/upgrade-connector.html** (linked from the README "Migration" section). Back up and test in staging; expect to re-map configuration and re-run a full category→…→product import afterward.

## 105.x CHANGELOG digest

The 105.x line is a **maintenance / hardening line** on top of 104.x — dependency bumps, newer-PHP support, and security-oriented cleanup rather than new import features:

- **105.0.0** — Akeneo PHP API client updated to **11.4.0**.
- **105.0.1** — fix module setup under Magento security patches (PGTO-526).
- **105.1.0** — code cleanup; **removed unnecessary API calls to media**; prevent an API-client error on **empty families during the product import**.
- **105.1.1** — **PHP 8.4 compatibility**; functional test suite added.
- **105.1.2** — **all template output escaped** (XSS hardening across `.phtml` templates); this is the embedded tag.

For the exhaustive per-version history (100.x → 105.x), read `CHANGELOG.md` in the embedded source — it is the authoritative changelog; the digest above only summarizes the current line.

## Original sources

- `references/sources/magento2-connector-source/README.md` — the compatibility matrix and `psr/http-message` note.
- `references/sources/magento2-connector-source/CHANGELOG.md` — full per-version history; source of the 105.x digest and the "Warning" upgrade hazards.
- `references/sources/magento2-connector-source/composer.json` — package version 105.1.2, `akeneo/api-php-client` 11.4.0, license OSL-3.0 / AFL-3.0.
- `references/sources/magento2-connector-source/etc/module.xml` + `.source-tag` — module `setup_version` 1.0.5, pinned tag v105.1.2.
- Vendor upgrade/migration docs: https://help.akeneo.com/magento2-connector/v100/articles/upgrade-connector.html
