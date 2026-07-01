# Running Imports

Three ways to trigger an Akeneo → Magento import: the **CLI** command, the **admin grid**, and **cron**. All three funnel through the same `Akeneo\Connector\Executor\JobExecutor`, run the same step pipeline, and record state in the `akeneo_connector_job` table. This file is about *launching and monitoring* runs. For what each job/step actually does, see `jobs-and-imports.md`; for why runs fail, see `troubleshooting.md`; for the module wiring, see `architecture.md`.

> The connector deliberately reuses Magento's cron/CLI/indexer machinery. This file covers the connector-specific surface; for generic `bin/magento` mechanics, cron setup, and reindexing, defer to the **`magento2-development`** skill.

## The five job codes

The jobs are seeded once at `setup:upgrade` by `Setup/Patch/Data/CreateJobs.php` into `akeneo_connector_job`, each with a fixed **position** that defines run order:

| Position | Code | Name | Job class |
| --- | --- | --- | --- |
| 0 | `category` | Category | `Akeneo\Connector\Job\Category` |
| 1 | `family` | Family | `Akeneo\Connector\Job\Family` |
| 2 | `attribute` | Attribute | `Akeneo\Connector\Job\Attribute` |
| 3 | `option` | Option | `Akeneo\Connector\Job\Option` |
| 4 | `product` | Product | `Akeneo\Connector\Job\Product` |

**Canonical order is category → family → attribute → option → product** (structure before data). The `product` job runs the product pipeline **once per family** (`getFamiliesToImport()`); if no family qualifies it stops with *"No family to import"*. See `jobs-and-imports.md`.

## 1. CLI — `akeneo_connector:import`

Defined in `Console/Command/AkeneoConnectorImportCommand.php`, registered in `etc/di.xml` under `Magento\Framework\Console\CommandList` (item `import`). It runs the job **synchronously and immediately** in the foreground (it forces area code `adminhtml`), streaming step output to your terminal — it does *not* schedule anything for cron.

### Run one job

```bash
bin/magento akeneo_connector:import --code=category
```

### Chain several jobs in one command

The `--code` option (a required value) accepts **comma-separated** codes:

```bash
# Full catalog, structure first then products
bin/magento akeneo_connector:import --code=category,family,attribute,option,product
```

Codes run **in position order regardless of the order you type them** — the executor calls `sortJobs()`, which reloads the codes from `akeneo_connector_job` ordered by `position ASC`, then runs each in turn (`Executor/JobExecutor::execute()`). So `--code=product,category` still runs `category` before `product`. If you genuinely need a non-canonical order, issue separate commands sequentially instead.

### Discover the available codes

Run with **no `--code`** and the command prints usage — the option, every registered job code, and an example (`usage()` in the command; codes come from `JobRepository::getList()`):

```bash
bin/magento akeneo_connector:import
```

```
Options:
--code

Available codes:
category
family
attribute
option
product

Example:
akeneo_connector:import --code=category
```

### Exit codes and console output

- Each step prints a timestamped line, e.g. `[14:03:21] Start import`, then a completion/`<error>` message. The `[HH:MM:SS]` prefix comes from `Helper/Output::getPrefix()`.
- Returns **0** on success; **1** on an Akeneo `HttpException` (API failure) — in which case the current job is set to **Error** and the message is printed in red.
- Returns **1** with *"Area code already set"* if the area code was pre-set by the calling context.
- Guard rails (from `JobExecutor::execute()` / `checkStatusConditions()`):
  - Missing credentials → *"API credentials are missing. Please configure the connector and retry."* (see `configuration.md`).
  - Unknown code → *"Job code not found"*.
  - Job already **Processing** → *"The job … is already running"*; already **Scheduled** → *"The job … is already scheduled"*.

## 2. Admin grid — Jobs

**Menu:** *System → Akeneo Connector → Jobs* (`etc/adminhtml/menu.xml`). Route front name is `akeneo_connector` (`etc/adminhtml/routes.xml`), so the grid is `admin/akeneo_connector/job/index`; the UI component is `view/adminhtml/ui_component/akeneo_job_listing.xml`. ACL resource: `Akeneo_Connector::akeneo_connector_job`.

The grid lists the five jobs with **Code, Name, Status, Scheduled At, Last executed date, Last success date**, plus a color-coded **Status** column (`Ui/Component/JobListing/Column/Status.php`) and per-row actions (`ActionsColumn.php`): **Schedule Job** and **View Logs**.

### Important: the grid schedules; cron runs

Neither the row action nor the mass action executes the import inline. **They set the job's status to `Scheduled`** (`Controller/Adminhtml/Job/MassSchedule.php` → `setJobStatus(JOB_SCHEDULED)`), which stamps `scheduled_at`. The actual run happens when the **cron** job `LaunchScheduledJob` next fires (every minute). The success message reflects this:

> *"Job Category correctly scheduled. Please refresh the page in a few minutes to check the progress."*

So **the admin path requires Magento cron to be running.** If cron is not running, jobs sit at `Scheduled` forever. (For a truly immediate run, use the CLI.)

- **Mass actions:** *Schedule* (→ `Scheduled`) and *Reset* (`MassReset.php` → `Pending`). Reset is how you clear a stuck `Processing`/`Scheduled`/`Error` row.
- Scheduling refuses a job already `Processing` (*"already running"*) or `Scheduled` (*"already scheduled"*) via `checkStatusConditions()`.
- **View Logs** links to the Logs grid pre-filtered to that job's code (see *Logs* below).

## 3. Cron — the `akeneo_connector` group

The connector ships its own cron group and two jobs.

**`etc/cron_groups.xml`** (group `akeneo_connector`):

| Setting | Value | Effect |
| --- | --- | --- |
| `use_separate_process` | `1` | Each run forks its own PHP process — imports don't block the `default` group or each other. |
| `schedule_generate_every` | `1` | Schedule regenerated every 1 min. |
| `schedule_ahead_for` | `4` | Schedule 4 min ahead. |
| `schedule_lifetime` | `2` | A missed slot is skipped after 2 min. |
| `history_cleanup_every` | `10` | Prune `cron_schedule` history every 10 min. |
| `history_success_lifetime` / `history_failure_lifetime` | `60` / `600` | Keep succeeded/failed cron rows 60 / 600 min. |

**`etc/crontab.xml`** (group `akeneo_connector`):

| Cron job name | Class | Schedule | Purpose |
| --- | --- | --- | --- |
| `akeneo_connector_launch_scheduled_job` | `Cron\LaunchScheduledJob` | `*/1 * * * *` (every minute) | Picks up and runs `Scheduled` jobs. |
| `akeneo_connector_clean_logs` | `Cron\CleanLogs` | `0 2 * * *` (02:00 daily) | Deletes old DB import-log rows. |

### How a scheduled job actually runs

`Cron/LaunchScheduledJob::execute()` every minute:
1. Loads all `akeneo_connector_job` rows with status **`Scheduled`**, ordered by `position`.
2. Concatenates their codes and calls `JobExecutor::execute()` — so multiple scheduled jobs run **in canonical position order** in a single sweep, exactly like a chained CLI run.

That is the whole scheduling model: **grid/API "schedule" = flip status to `Scheduled`; this cron = drain the `Scheduled` queue.** Because the group uses a separate process, a long product import won't stall the minute tick.

`Cron/CleanLogs::execute()` at 02:00 is **gated by admin config** (*Advanced → Enable Job Logs Cleaning* + a day count). When enabled it deletes rows from `akeneo_connector_import_log` and `akeneo_connector_import_log_step` older than N days. It does **not** touch the `var/log/akeneo_connector/*.log` files.

> This assumes Magento's own cron is installed (`* * * * * bin/magento cron:run`). That setup is generic Magento — see `magento2-development`. You can also run the group directly: `bin/magento cron:run --group=akeneo_connector`.

## The `akeneo_connector_job` table

Defined in `etc/db_schema.xml`. One row per job code — it is a **status/history record**, not a queue of individual runs (there is exactly one row per code, updated in place).

| Column | Type | Meaning |
| --- | --- | --- |
| `entity_id` | int, PK | Job ID. |
| `code` | varchar | Job code (`category` … `product`). |
| `status` | varchar (DB default `PENDING`) | Current state — see below. The connector writes the **numeric** status codes (1–5), not the literal string. |
| `scheduled_at` | datetime | When it was queued for cron (set on `Scheduled`). |
| `last_executed_date` | datetime | Start of the most recent run. |
| `last_success_date` | datetime | Last run that finished OK. |
| `job_class` | varchar | The `Job\*` class run for this code. |
| `name` | varchar | Display name. |
| `position` | int | Run-order priority (0–4). |
| `last_success_executed_date` | text | For `product`, a JSON map of last-success timestamps **per family** (incremental cursor). |

### Statuses

Constants in `Api/Data/JobInterface.php` (labels in `Model/Source/Status.php`, colors in `Ui/.../Column/Status.php`):

| Code | Status | Grid color | When set |
| --- | --- | --- | --- |
| 5 | **Pending** | pending (grey) | Seeded default; and after *Reset*. Idle, never queued. |
| 4 | **Scheduled** | minor (grey) | Queued from the grid/API; awaiting cron pickup. |
| 3 | **Processing** | processing (orange) | Running now (`beforeRun()`). |
| 1 | **Success** | notice (green) | Finished cleanly (`afterRun()`). |
| 2 | **Error** | critical (red) | Threw/failed (`afterRun(true)`, or a CLI `HttpException`). |

### Reading a failed run

1. In the Jobs grid, the row shows **Error** (red). `last_executed_date` is when it died; `last_success_date` is the last good run — the gap tells you what's un-synced. For `product`, inspect `last_success_executed_date` JSON to see which **families** last succeeded (the connector resumes per family).
2. A row stuck on **Processing** usually means the process was killed mid-run (OOM/timeout — see `troubleshooting.md`). Clear it with grid *Reset* (→ Pending) before retrying.
3. For the *step* that failed and its message, open the **Logs** (below) — the job-table row only carries status/dates, not the step trace.

Quick SQL peek:

```sql
SELECT code, status, last_executed_date, last_success_date
FROM akeneo_connector_job ORDER BY position;
```

(Status shows as `1`–`5` per the mapping above.)

## Logs

There are **two** log surfaces — know which one you're reading.

### A. DB import log (always on) — the admin *Logs* grid

Every run is recorded via events the executor dispatches (`akeneo_connector_import_step_start` / `_finish`), captured by `Observer/AkeneoConnectorImportStepStartObserver` and `…StepFinishObserver` into two tables (`etc/db_schema.xml`):

- **`akeneo_connector_import_log`** — one row per run: `identifier`, `code`, `name`, `status` (1 success / 2 error / 3 processing), `created_at`.
- **`akeneo_connector_import_log_step`** — one row per **step**: `number`, `method`, `message`, `continue`, `status`, `log_id` (FK, `ON DELETE CASCADE`).

View at *System → Akeneo Connector → **Logs*** (route `akeneo_connector/log`, ACL `Akeneo_Connector::akeneo_connector_log`), or via a job row's **View Logs** action (pre-filters by `code`). This is where you see **which step a run died on and the error message** — start here for any failure. These rows are what `CleanLogs` prunes.

### B. File logs (opt-in) — verbose Monolog traces

Gated by **Stores → Configuration → Catalog → Akeneo Connector → Advanced → "Enable Advanced Loging"** (`akeneo_connector/advanced/advanced_log`). When on, per-entity DEBUG logs are written by the handlers in `Logger/Handler/` to:

```
var/log/akeneo_connector/category-import.log
var/log/akeneo_connector/family-import.log
var/log/akeneo_connector/attribute-import.log
var/log/akeneo_connector/option-import.log
var/log/akeneo_connector/product-import.log
```

**Raising verbosity = enabling Advanced Log.** Two side effects called out by the config comment: it *"may slow down the imports"* and **temp/staging tables are not dropped** at the end of a run (handy for inspecting exactly what was staged — see `architecture.md`). Turn it off again once you've captured the failure.

> Cleanup config lives beside it: *Advanced → "Enable Job Logs Cleaning"* + a day count feed the `akeneo_connector_clean_logs` cron (DB log tables only).

## After an import: reindex & cache

Each job's step list (declared in `etc/di.xml`) already includes reindex/clean-cache steps for the entities it touched (see `architecture.md`). Even so, **"products imported but not showing on the storefront"** is almost always a stale index or cache, or a missing website/store-view assignment — not a failed import. Standard fix:

```bash
bin/magento indexer:reindex
bin/magento cache:flush
```

Indexer modes, scheduled ("Update by Schedule") reindexing, and cache types are **generic Magento** — defer to the **`magento2-development`** skill. Website/store-view mapping is in `configuration.md`; the visibility checklist is in `troubleshooting.md`.

## Running order & chaining — summary

- **Canonical order** (positions 0–4): `category → family → attribute → option → product`. Running `product` before its structure jobs yields incomplete mappings.
- **Chaining (CLI):** `--code=a,b,c` — always executed in **position order** (`sortJobs()`), whatever order you type.
- **Chaining (cron/admin):** schedule several jobs; the every-minute `LaunchScheduledJob` runs the whole `Scheduled` set in position order in one sweep.
- **Force a custom order:** the connector won't reorder for you — run separate CLI commands back to back.
- **CLI = run now (foreground); admin/API = schedule for cron.** Don't mix them on the same job at the same time (the second is refused as *already running/scheduled*).

## Original sources

- `references/sources/magento2-connector-source/Console/Command/AkeneoConnectorImportCommand.php` — the `akeneo_connector:import` CLI, `--code`, multi-code, no-`--code` usage output, area code, exit codes.
- `references/sources/magento2-connector-source/Executor/JobExecutor.php` — `execute()`, `sortJobs()`, `beforeRun/afterRun`, `setJobStatus`, `getCurrentJob`, `checkStatusConditions`, per-family product runs, credential guard.
- `references/sources/magento2-connector-source/Cron/LaunchScheduledJob.php`, `Cron/CleanLogs.php` — scheduled-job runner and log cleanup.
- `references/sources/magento2-connector-source/etc/crontab.xml`, `etc/cron_groups.xml` — the two cron jobs and the `akeneo_connector` group (`use_separate_process=1`, schedules).
- `references/sources/magento2-connector-source/etc/db_schema.xml` — `akeneo_connector_job`, `akeneo_connector_import_log`, `akeneo_connector_import_log_step` columns.
- `references/sources/magento2-connector-source/Api/Data/JobInterface.php`, `Model/Job.php`, `Model/Source/Status.php` — status constants (1–5) and labels.
- `references/sources/magento2-connector-source/Setup/Patch/Data/CreateJobs.php` — the five seeded job codes, names, classes, positions.
- `references/sources/magento2-connector-source/Controller/Adminhtml/Job/{MassSchedule,MassReset,Index}.php`, `Ui/Component/JobListing/Column/{Status,ActionsColumn}.php`, `view/adminhtml/ui_component/akeneo_job_listing.xml`, `etc/adminhtml/{menu,routes}.xml`, `etc/acl.xml` — the admin grid, actions, menu path, route, and ACL.
- `references/sources/magento2-connector-source/Logger/` (loggers + `Handler/*` file paths) and `Observer/AkeneoConnectorImportStep{Start,Finish}Observer.php` — file-log destinations and DB log-step persistence.
- `references/sources/magento2-connector-source/Helper/Config.php` + `etc/adminhtml/system.xml` (group `advanced`) — `advanced_log`, `enable_clean_logs`, `clean_logs` config keys and labels.
