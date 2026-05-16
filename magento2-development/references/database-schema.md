# Database Schema in Magento 2

Magento 2.3+ uses **declarative schema**: you describe tables in `etc/db_schema.xml`, Magento diffs the XML against the live DB on `setup:upgrade` and applies changes (CREATE, ALTER, DROP). Pre-2.3 code (`InstallSchema.php`, `UpgradeSchema.php`) still works but is deprecated — don't write new ones.

For **data** changes (inserts, updates) and one-off **structural** changes that declarative schema can't express, use **patches**: `Setup/Patch/Data/*` and `Setup/Patch/Schema/*`.

## Declarative schema — `etc/db_schema.xml`

```xml
<?xml version="1.0"?>
<schema xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Setup/Declaration/Schema/etc/schema.xsd">
    <table name="acme_giftwrap_message" resource="default" engine="innodb" comment="Gift wrap messages">
        <column xsi:type="int" name="entity_id" padding="10" unsigned="true" nullable="false" identity="true"
                comment="Entity ID"/>
        <column xsi:type="int" name="order_id" padding="10" unsigned="true" nullable="false" comment="Order ID"/>
        <column xsi:type="varchar" name="message" length="255" nullable="true" comment="Message text"/>
        <column xsi:type="boolean" name="is_active" nullable="false" default="true" comment="Is active"/>
        <column xsi:type="decimal" name="price" scale="4" precision="20" nullable="false" default="0"
                comment="Wrap fee"/>
        <column xsi:type="timestamp" name="created_at" on_update="false" nullable="false"
                default="CURRENT_TIMESTAMP" comment="Created at"/>
        <column xsi:type="timestamp" name="updated_at" on_update="true" nullable="false"
                default="CURRENT_TIMESTAMP" comment="Updated at"/>

        <constraint xsi:type="primary" referenceId="PRIMARY">
            <column name="entity_id"/>
        </constraint>
        <constraint xsi:type="unique" referenceId="ACME_GIFTWRAP_MESSAGE_ORDER_ID">
            <column name="order_id"/>
        </constraint>
        <constraint xsi:type="foreign"
                    referenceId="ACME_GIFTWRAP_MESSAGE_ORDER_ID_SALES_ORDER_ENTITY_ID"
                    table="acme_giftwrap_message" column="order_id"
                    referenceTable="sales_order" referenceColumn="entity_id"
                    onDelete="CASCADE"/>
        <index referenceId="ACME_GIFTWRAP_MESSAGE_IS_ACTIVE" indexType="btree">
            <column name="is_active"/>
        </index>
    </table>

    <!-- Add a column to an existing table -->
    <table name="sales_order">
        <column xsi:type="varchar" name="gift_wrap_message" length="255" nullable="true"
                comment="Gift wrap message text"/>
    </table>
</schema>
```

### Column types

| `xsi:type` | SQL equivalent | Required attrs | Common options |
| --- | --- | --- | --- |
| `int` / `smallint` / `tinyint` / `bigint` | `INT(...)` etc. | `name` | `padding`, `unsigned`, `nullable`, `identity`, `default` |
| `boolean` | `TINYINT(1)` | `name` | `nullable`, `default` (`true`/`false`) |
| `decimal` | `DECIMAL(p,s)` | `name`, `precision`, `scale` | `nullable`, `default`, `unsigned` |
| `float` | `FLOAT` | `name` | `nullable`, `default` |
| `real` | `DOUBLE` | `name` | `nullable`, `default` |
| `varchar` | `VARCHAR(n)` | `name`, `length` | `nullable`, `default` |
| `varbinary` | `VARBINARY(n)` | `name`, `length` | `nullable`, `default` |
| `text` / `mediumtext` / `smalltext` | `TEXT` | `name` | `nullable`, `default` |
| `blob` / `mediumblob` / `smallblob` | `BLOB` | `name` | `nullable` |
| `date` | `DATE` | `name` | `nullable`, `default` |
| `datetime` | `DATETIME` | `name` | `nullable`, `default`, `on_update` |
| `timestamp` | `TIMESTAMP` | `name` | `nullable`, `default` (often `CURRENT_TIMESTAMP`), `on_update` |
| `json` | `JSON` | `name` | `nullable` |

`identity="true"` on an int column → `AUTO_INCREMENT`. `unsigned="true"` is standard for entity IDs (`int(10) unsigned`).

### Constraints

```xml
<constraint xsi:type="primary" referenceId="PRIMARY">
    <column name="entity_id"/>
</constraint>

<constraint xsi:type="unique" referenceId="MY_UNIQUE_REF">
    <column name="sku"/>
    <column name="store_id"/>    <!-- composite -->
</constraint>

<constraint xsi:type="foreign"
            referenceId="MY_FK_REF"
            table="acme_message" column="order_id"
            referenceTable="sales_order" referenceColumn="entity_id"
            onDelete="CASCADE"/>   <!-- or SET NULL, NO ACTION -->
```

**`referenceId` MUST be unique across the entire DB**. Convention: `<TABLE>_<COLUMN>_<REFTABLE>_<REFCOLUMN>` for FKs (long uppercase). Magento generates these automatically when omitted, but explicit names are easier to diff and predictable across regenerations.

### Indexes
```xml
<index referenceId="ACME_MESSAGE_CREATED_AT" indexType="btree">
    <column name="created_at"/>
</index>
<index referenceId="ACME_MESSAGE_NAME_FULLTEXT" indexType="fulltext">
    <column name="name"/>
    <column name="description"/>
</index>
```
`indexType` values: `btree` (default), `fulltext`, `hash`. Spatial indexes aren't supported declaratively as of 2.4.x.

### Disabling a column / dropping a table

Declarative schema applies diffs. **To drop a column or table, REMOVE it from `db_schema.xml`**. Magento sees it's gone from XML and DROPs it (after confirming via the whitelist — see below).

```xml
<!-- Drop the whole table by removing the <table> declaration -->
<!-- Drop a column by removing the <column> declaration -->
```

If you accidentally remove a column without intending to drop, the next `setup:upgrade` will permanently drop it. Be careful.

### Disabling a column you can't change (third-party module)
You can't `xsi:type="false"` a column out of existence in another module's schema. Use a schema patch (see below) to ALTER TABLE.

## `db_schema_whitelist.json` — the safety brake

Declarative schema is destructive. By default, Magento WILL NOT drop columns/tables/indexes/constraints unless they appear in the module's **whitelist file**: `etc/db_schema_whitelist.json`.

Generate it after every `db_schema.xml` change:

```
bin/magento setup:db-declaration:generate-whitelist --module-name=Acme_GiftWrap
```

This regenerates `etc/db_schema_whitelist.json` listing every entity (table, column, constraint, index) the module has EVER introduced. Without this entry, Magento refuses to drop the entity even if it's removed from XML.

**Always commit the whitelist with your `db_schema.xml`.** It's the source of truth for "did we ever own this?"

Example whitelist:
```json
{
    "acme_giftwrap_message": {
        "column": {
            "entity_id": true,
            "order_id": true,
            "message": true,
            "is_active": true
        },
        "constraint": {
            "PRIMARY": true,
            "ACME_GIFTWRAP_MESSAGE_ORDER_ID": true,
            "ACME_GIFTWRAP_MESSAGE_ORDER_ID_SALES_ORDER_ENTITY_ID": true
        },
        "index": {
            "ACME_GIFTWRAP_MESSAGE_IS_ACTIVE": true
        }
    }
}
```

### Dry-run a schema diff
```
bin/magento setup:db-declaration:generate-patch --type=schema my_dry_run
```
…actually generates a patch (see below). To preview the SQL Magento WOULD run:
```
bin/magento setup:upgrade --dry-run    # 2.4+
```
This logs the SQL to `var/log/` without executing.

## Data and schema patches

For things declarative schema can't do (insert rows, modify data, run an arbitrary ALTER, drop a column with a specific migration plan), write a **patch**.

### Data patch
Inserts/updates rows. Implements `\Magento\Framework\Setup\Patch\DataPatchInterface`.

`app/code/Acme/GiftWrap/Setup/Patch/Data/AddDefaultWraps.php`:
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Setup\Patch\Data;

use Magento\Framework\Setup\ModuleDataSetupInterface;
use Magento\Framework\Setup\Patch\DataPatchInterface;
use Magento\Framework\Setup\Patch\PatchRevertableInterface;

class AddDefaultWraps implements DataPatchInterface, PatchRevertableInterface
{
    public function __construct(
        private readonly ModuleDataSetupInterface $moduleDataSetup
    ) {}

    public static function getDependencies(): array
    {
        // Other patches this one needs to run AFTER
        return [];
    }

    public function getAliases(): array
    {
        // Old class names this patch replaces — prevents re-running
        return [];
    }

    public function apply(): self
    {
        $this->moduleDataSetup->startSetup();
        $conn = $this->moduleDataSetup->getConnection();
        $conn->insertMultiple(
            $this->moduleDataSetup->getTable('acme_giftwrap_message'),
            [
                ['order_id' => 0, 'message' => 'Happy Birthday', 'is_active' => 1],
                ['order_id' => 0, 'message' => 'Thank you', 'is_active' => 1],
            ]
        );
        $this->moduleDataSetup->endSetup();
        return $this;
    }

    public function revert(): void
    {
        // Optional. Run when the module is uninstalled.
        $this->moduleDataSetup->getConnection()->delete(
            $this->moduleDataSetup->getTable('acme_giftwrap_message'),
            ['message IN (?)' => ['Happy Birthday', 'Thank you']]
        );
    }
}
```

- `apply()` runs once. Magento records the FQCN in `patch_list` after success. It won't run again.
- `getDependencies()` — list FQCNs of other patches that MUST run first.
- `getAliases()` — list old FQCNs this patch replaces (e.g., you renamed the class). Prevents Magento from re-applying.
- `PatchRevertableInterface::revert()` — runs on `module:uninstall` (requires patch to be revertable). Optional.

Trigger with: `bin/magento setup:upgrade`. Patches discovered via `Setup/Patch/Data/*.php`.

### Schema patch
Same shape as Data patch, but lives under `Setup/Patch/Schema/`. Implements `SchemaPatchInterface`. Used for structural changes you don't want in `db_schema.xml` (one-off ALTERs, complex migrations).

```php
namespace Acme\GiftWrap\Setup\Patch\Schema;

use Magento\Framework\Setup\Patch\SchemaPatchInterface;

class RenameLegacyColumn implements SchemaPatchInterface
{
    public function __construct(
        private readonly \Magento\Framework\Setup\SchemaSetupInterface $schemaSetup
    ) {}

    public static function getDependencies(): array { return []; }
    public function getAliases(): array { return []; }

    public function apply(): self
    {
        $this->schemaSetup->getConnection()->changeColumn(
            $this->schemaSetup->getTable('acme_giftwrap_message'),
            'old_column_name',
            'new_column_name',
            [
                'type' => \Magento\Framework\DB\Ddl\Table::TYPE_TEXT,
                'length' => 255,
                'nullable' => true,
            ]
        );
        return $this;
    }
}
```

### Patches run order

1. Magento scans `Setup/Patch/Schema/` first (or Data — depends on `setup:upgrade` mode), respects `getDependencies()`.
2. Each successful `apply()` is recorded in the `patch_list` DB table.
3. Re-running `setup:upgrade` skips already-applied patches.

To force re-run: DELETE the row from `patch_list` (or use the unofficial `bin/magento setup:patch:revert` extensions). Don't do this casually — patches are not idempotent unless you wrote them that way.

## Legacy: `InstallSchema`, `UpgradeSchema`, `InstallData`, `UpgradeData`

Pre-2.3 module setup. Still works, still occasionally found in third-party modules. Triggered by `setup_version` in `module.xml`:

```php
// app/code/Acme/Hello/Setup/InstallSchema.php
namespace Acme\Hello\Setup;

use Magento\Framework\Setup\InstallSchemaInterface;
use Magento\Framework\Setup\ModuleContextInterface;
use Magento\Framework\Setup\SchemaSetupInterface;

class InstallSchema implements InstallSchemaInterface
{
    public function install(SchemaSetupInterface $setup, ModuleContextInterface $context): void
    {
        // $setup->getConnection()->newTable(...)->addColumn(...)
    }
}
```

**Don't write new ones.** Use declarative schema + patches. The framework deliberately makes legacy patches harder to debug.

## Multiple DB connections

Magento supports splitting `quote_*` and `sales_*` tables to separate databases (deprecated in 2.4.2, removed in 2.4.7 — single DB is now standard). The `resource` attribute on `<table>` selects which connection:

```xml
<table name="quote" resource="checkout">...</table>
<table name="sales_order" resource="sales">...</table>
```

Use `resource="default"` for everything in modern installs.

## ResourceModel — reading/writing without an ORM-like collection

For raw access, inject `\Magento\Framework\App\ResourceConnection`:
```php
public function __construct(
    private readonly \Magento\Framework\App\ResourceConnection $resourceConnection
) {}

public function getActiveCount(): int
{
    $conn = $this->resourceConnection->getConnection();
    $table = $this->resourceConnection->getTableName('acme_giftwrap_message');
    return (int) $conn->fetchOne(
        $conn->select()->from($table, 'COUNT(*)')->where('is_active = ?', 1)
    );
}
```

Methods on the connection (`Magento\Framework\DB\Adapter\Pdo\Mysql`):
- `select()` → query builder.
- `fetchOne`, `fetchRow`, `fetchAll`, `fetchPairs`, `fetchAssoc`, `fetchCol`.
- `insert`, `insertOnDuplicate`, `insertMultiple`.
- `update`, `delete`.
- `query` (last resort — raw SQL with `?` bind params).

**Always bind parameters** (`?` + array) to avoid SQL injection. Don't concat user input into queries.

But for application code, prefer **Models + ResourceModels + Repositories** (see `eav-models-repositories.md`). Raw access is for migrations and maintenance scripts.

## Adobe Commerce: split-DB removed in 2.4.7

If you maintain a module that previously declared `resource="sales"` or `resource="checkout"`, those resources now alias to `default`. The XML still validates. No code change required, but plan a cleanup pass.

## Common gotchas

### "Cannot drop column" on setup:upgrade
The column you removed from `db_schema.xml` isn't in `db_schema_whitelist.json`. Run `bin/magento setup:db-declaration:generate-whitelist --module-name=Acme_X` first.

### Patches reapply on every `setup:upgrade`
You forgot to commit `patch_list` from staging to production (or its rows). Or the patch FQCN changed and `getAliases()` doesn't list the old one.

### "There has been an error processing your request" with no detail
Check `var/log/exception.log` and `var/log/system.log`. Patch failures and declarative schema diffs log there. Permissions issues on `var/` will mask errors too.

### Foreign key fails on `setup:upgrade`
- Referenced table doesn't exist yet — fix module sequence (`<sequence>`).
- Existing rows violate the constraint — write a data patch to clean them first.
- `onDelete="CASCADE"` against `sales_order` could massively cascade-delete. Think carefully before using it on volatile tables.

### Decimal precision/scale mismatches
`decimal scale="4" precision="20"` vs `scale="2" precision="12"` — Magento will issue an ALTER even for a precision change. Match Magento's conventions when extending core tables (e.g., for prices, `scale="4" precision="20"` is standard).

### Schema change rolled back silently
A failed declarative schema diff can leave the DB partially migrated. Always check `var/log/system.log` after `setup:upgrade`. In production, run `setup:upgrade --dry-run` first.

### Whitelist out of date
Forget to regenerate the whitelist → Magento "ignores" the drop, your column lingers, and tests pass locally. Run the whitelist generator as part of CI.

### Index name limit (64 chars in MariaDB/MySQL 8)
Long `referenceId` values get truncated and conflict. Keep names under 64 characters.

## Original sources

- `references/sources/commerce-php/development/components/declarative-schema/` — full declarative schema docs.
- `references/sources/commerce-php/development/components/declarative-schema/db-schema.md`
- `references/sources/commerce-php/development/components/declarative-schema/data-patches.md`
- `references/sources/commerce-php/development/components/declarative-schema/whitelist.md`
- `references/sources/devdocs-v2.4/extension-dev-guide/declarative-schema/` — older guide.
- `references/sources/devdocs-v2.4/extension-dev-guide/declarative-schema/dynamic-data.md` — data patches.
