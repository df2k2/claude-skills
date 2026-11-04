<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/recompiling-cms-content.html -->

# Recompiling CMS Content

When a theme's Tailwind configuration changes — new colors, modified spacing, updated plugins — the CSS already compiled and stored for CMS content becomes stale. The `hyva-themes/magento2-cms-tailwind-recompile` module recompiles all stored CMS CSS in bulk, so you do not have to open and save each entity individually.

It uses the [server-side compiler daemon](server-side-setup.html), so [server-side compilation](server-side-compilation.html) must be set up first.

## Installing

```
composer require hyva-themes/magento2-cms-tailwind-recompile
bin/magento setup:upgrade
```

The module registers the four core CMS entities — CMS blocks, CMS pages, catalog products, and catalog categories — through the bridge module. Other modules can register their own entity types (see [Extending to Custom Entities](#extending-to-custom-entities)).

## CLI Command

```
bin/magento hyva:cms-tailwind:recompile [--background|-b] [--theme=Hyva/default]
```

**Synchronous (default)** — Populates the queue and processes every entity immediately with a progress bar. It aborts on the first error so broken entities surface quickly. Suitable for deployments and CI pipelines where compilation must finish before proceeding.

```
bin/magento hyva:cms-tailwind:recompile
```

**Background (`--background` / `-b`)** — Populates the queue with every entity-and-theme combination that has compiled CSS and returns immediately. Cron processes the queue in the background.

```
bin/magento hyva:cms-tailwind:recompile --background
```

**Theme filter (`--theme`)** — Limits recompilation to a single theme instead of all active Hyvä themes.

```
bin/magento hyva:cms-tailwind:recompile --theme=Hyva/default
```

If the compiler daemon is not running, the command prints a warning. Recompilation is performed by the daemon, so start it first, or set **Daemon Management** to **Start on-demand** so it is launched automatically when needed (see [Daemon Management](server-side-setup.html#daemon-management)).

Concurrent synchronous run and cron

The synchronous CLI mode and the cron processor share one queue. If `--background` is omitted and cron fires while the CLI is running, cron may claim rows the CLI then never processes. The total processed count stays correct, but the CLI progress bar can end below its maximum and a cron-side failure will not affect the CLI exit code. For deterministic deployments, prefer `--background` together with the queue status, or disable the cron group while running the synchronous command.

Recompiles existing CSS only — not new store views

By default the module recompiles only entity-and-theme combinations that **already have** stored CSS. It reads the entity IDs to process from each theme's CSS storage table, so a theme with no stored rows yet is skipped.

This means adding a new store view (with a new theme) does **not** generate CSS for existing CMS content through this module — those entities have no CSS row for the new theme. To produce CSS for a new store view, re-save the affected entities in the admin, or register a custom [`EntityIdProviderInterface`](#extending-to-custom-entities) that returns the full set of entity IDs for the theme.

Recompiling existing CMS content for newly added themes is planned as a future feature.

## Cron Jobs and Queue

In background mode, the queue table (`hyva_cms_tailwind_recompile_queue`) is processed by cron:

| Job | Schedule | Description |
| --- | --- | --- |
| `hyva_cms_tailwind_recompile_process` | Every minute | Claims and processes up to 250 pending entities per run. Logs errors and continues. |
| `hyva_cms_tailwind_recompile_cleanup` | Daily at 3:00 AM | Removes completed entries older than 1 day and failed entries older than 7 days. |

Entries stuck in `processing` for more than 10 minutes are automatically reclaimed as `pending`.

Each queue entry moves through these statuses:

| Status | Meaning |
| --- | --- |
| `pending` | Scheduled, waiting to be picked up. |
| `processing` | Claimed by a cron run or CLI process. |
| `completed` | Successfully recompiled. |
| `failed` | Compilation failed; the error message is stored on the queue entry. |

## Extending to Custom Entities

For module developers

This section is only relevant if you build a module with its own CMS-like content type. The built-in CMS blocks, pages, products, and categories work out of the box.

A custom or third-party module can register its own content types for bulk recompilation by adding an `etc/tailwind_recompile_sources.xml` file. For a flat table with an HTML column:

etc/tailwind\_recompile\_sources.xml

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Hyva_CmsTailwindCompiler:etc/tailwind_recompile_sources.xsd">

    <entity name="my_entity" scopePattern=".hcms-myentity-{id}">
        <cssStorage table="my_entity_tailwindcss"
                    entityIdColumn="entity_id"
                    themeColumn="theme"
                    cssColumn="css"/>
        <htmlSources>
            <source table="my_entity" htmlColumn="content" joinColumn="entity_id"/>
        </htmlSources>
    </entity>

</config>
```

The `scopePattern` must start with `.` and use `{id}` as the entity-ID placeholder; it is used both as the scope selector passed to the daemon and as the wrapper class on the frontend.

For entities whose HTML cannot be read with a simple `SELECT` — for example EAV attributes with per-store values — set an `htmlMapper` attribute on `<entity>` pointing to a class that implements `Hyva\CmsTailwindCompiler\Api\HtmlSourceMapperInterface`, and omit `<htmlSources>`. The bridge module uses this approach for catalog products, whose `description` and `short_description` are store-scoped EAV attributes.

By default only entities that already have compiled CSS are recompiled (their IDs are read from the `cssStorage` table). To include entities that have never been compiled, set an `entityIdMapper` attribute pointing to a class that implements `Hyva\CmsTailwindCompiler\Api\EntityIdProviderInterface`.
