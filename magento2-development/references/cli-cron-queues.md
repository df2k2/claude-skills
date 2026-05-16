# CLI Commands, Cron Jobs, and Message Queues

For background and offline work, Magento offers three mechanisms:

1. **CLI commands** — `bin/magento <command>`. Symfony Console under the hood. Run by humans or scripts.
2. **Cron jobs** — `crontab.xml` declarations, scheduled by `bin/magento cron:run`.
3. **Message queues** — async/bulk processing through `queue_*.xml`. Backed by MySQL by default, or RabbitMQ (Adobe Commerce on Cloud requires RabbitMQ).

## Custom CLI commands

Magento exposes its own Symfony Console application. Add a command by declaring it in `etc/di.xml`:

```xml
<type name="Magento\Framework\Console\CommandList">
    <arguments>
        <argument name="commands" xsi:type="array">
            <item name="acme_giftwrap_resync" xsi:type="object">
                Acme\GiftWrap\Console\Command\Resync
            </item>
        </argument>
    </arguments>
</type>
```

The array key (`acme_giftwrap_resync`) is just a unique-per-module slot; the actual command name comes from the class.

`app/code/Acme/GiftWrap/Console/Command/Resync.php`:
```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Console\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Magento\Framework\App\State;
use Magento\Framework\App\Area;

class Resync extends Command
{
    public function __construct(
        private readonly State $appState,
        private readonly \Acme\GiftWrap\Model\Resyncer $resyncer,
        ?string $name = null
    ) {
        parent::__construct($name);
    }

    protected function configure(): void
    {
        $this->setName('acme:giftwrap:resync')
             ->setDescription('Re-sync gift wrap messages to the external system')
             ->addArgument('from-date', InputArgument::OPTIONAL, 'YYYY-MM-DD start', '2024-01-01')
             ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Print but do not commit');
        parent::configure();
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        // Required for many Magento operations
        try {
            $this->appState->setAreaCode(Area::AREA_ADMINHTML);
        } catch (\Magento\Framework\Exception\LocalizedException $e) {
            // Area already set
        }

        $fromDate = $input->getArgument('from-date');
        $dryRun = (bool) $input->getOption('dry-run');

        try {
            $count = $this->resyncer->run($fromDate, $dryRun);
            $output->writeln("<info>Synced {$count} message(s).</info>");
            return Command::SUCCESS;
        } catch (\Throwable $e) {
            $output->writeln("<error>{$e->getMessage()}</error>");
            return Command::FAILURE;
        }
    }
}
```

Run with:
```
bin/magento acme:giftwrap:resync 2025-01-01 --dry-run
```

### Critical things
- **Set the area code** before doing anything Magento-y. Many configurations are area-scoped; `Area::AREA_ADMINHTML` is the usual choice. Skip this and you get "Area code is not set" or weird config lookups.
- Always return an int: `Command::SUCCESS` (0), `Command::FAILURE` (1), `Command::INVALID` (2). 0 vs nonzero is what shell scripts grep for.
- The constructor needs the optional `$name = null` arg passed to `parent::__construct($name)` for Symfony's chaining to work.
- Use `<info>`, `<comment>`, `<error>`, `<question>` style tags for colored output.

### Command discovery
`bin/magento` lists all commands. To group yours: name commands `vendor:module:action` and they auto-group.

### Argument validation
Symfony Console handles type coercion. Use `InputArgument::REQUIRED`, `OPTIONAL`, `IS_ARRAY`. Validate further in `execute()` and throw `InvalidArgumentException` (Magento catches and pretty-prints).

### Long-running commands
- Use `$output->writeln()` for progress.
- For progress bars: `new \Symfony\Component\Console\Helper\ProgressBar($output, $total)`.
- Memory: monitor `memory_get_usage()`. For batch processing, clear collections after each batch (`$collection->clear()`).

## Cron jobs — `etc/crontab.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Cron:etc/crontab.xsd">
    <group id="default">
        <job name="acme_giftwrap_resync"
             instance="Acme\GiftWrap\Cron\Resync"
             method="execute">
            <schedule>0 */6 * * *</schedule>
        </job>
    </group>

    <group id="acme_long_running">
        <job name="acme_giftwrap_nightly_cleanup"
             instance="Acme\GiftWrap\Cron\Cleanup"
             method="execute">
            <schedule>0 3 * * *</schedule>
        </job>
    </group>
</config>
```

- `<group id>` — Magento runs jobs in groups. Default groups: `default`, `index`, `consumers`, `staging` (Commerce), `magento_blueserver` (Adobe Commerce Saas). Custom groups are launched separately via `cron:run --group=<id>`.
- `<schedule>` — standard cron syntax. Magento also supports `<config_path>cron_path/expression</config_path>` to source the expression from system config.

Job class:
```php
namespace Acme\GiftWrap\Cron;

class Resync
{
    public function __construct(
        private readonly \Acme\GiftWrap\Model\Resyncer $resyncer,
        private readonly \Psr\Log\LoggerInterface $logger
    ) {}

    public function execute(): void
    {
        try {
            $this->resyncer->run();
        } catch (\Throwable $e) {
            $this->logger->error('Resync cron failed: ' . $e->getMessage(), ['exception' => $e]);
        }
    }
}
```

The method on the job is whatever you put in `method=""`. Convention: `execute()`.

### How cron actually runs

Magento's cron has TWO layers:
1. **The OS cron** runs `bin/magento cron:run` every minute (set up at install time, see below).
2. `cron:run` **schedules** future jobs (computes next run times, writes rows to `cron_schedule`) and **executes** any pending jobs whose next run time has arrived.

Setup the OS-level cron once:
```
bin/magento cron:install
```
Adds entries to crontab for the magento user. Three lines: default group, update group, setup group. You can also do it manually:
```
* * * * * /usr/bin/php /var/www/magento/bin/magento cron:run 2>&1 | grep -v "Ran jobs by schedule" >> /var/www/magento/var/log/magento.cron.log
* * * * * /usr/bin/php /var/www/magento/update/cron.php >> /var/www/magento/var/log/update.cron.log
* * * * * /usr/bin/php /var/www/magento/bin/magento setup:cron:run >> /var/www/magento/var/log/setup.cron.log
```

### Triggering a single cron job manually
```
bin/magento cron:run --group=default --bootstrap=standaloneProcessStarted=1
```
Or directly call the cron job:
```php
$objectManager = \Magento\Framework\App\ObjectManager::getInstance();
$objectManager->create(\Acme\GiftWrap\Cron\Resync::class)->execute();
```

### Cron schedule tuning
- `default` group runs every minute, executes whatever's due.
- Schedule generation happens up to 4 hours ahead. So changing `<schedule>` doesn't always take effect immediately. Truncate `cron_schedule` if you need a fresh start (`DELETE FROM cron_schedule WHERE status='pending'`).
- Stuck cron: check `cron_schedule.status` for `running` rows that never finished. Magento has a timeout (default 4 hours) after which they're marked `error`.

### Disable a cron job
In `events.xml`-style way:
```xml
<job name="acme_giftwrap_resync" disabled="true"/>
```
Or set the schedule to something far in the future like `0 0 31 2 *` (Feb 31).

Some Magento jobs have system config toggles — check `system.xml` of the module that owns them.

## Message queues — async background work

Magento supports two queue backends:
- **MySQL** (default, no setup) — fine for low/medium volume.
- **RabbitMQ** — required for Adobe Commerce on Cloud; better for high volume.

### Anatomy

Three config files:

**`etc/communication.xml`** — topics and their data shapes.
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework-message-queue:etc/communication.xsd">
    <topic name="acme.giftwrap.process" request="string">
        <handler name="acme_giftwrap_process_handler"
                 type="Acme\GiftWrap\Model\Queue\ProcessHandler"
                 method="process"/>
    </topic>
</config>
```

- `request="string"` — the topic accepts a string payload. Other valid values: `int[]`, an interface FQCN for a complex payload.
- `<handler>` — what runs when a consumer pops the message.

**`etc/queue_topology.xml`** — RabbitMQ-specific (exchanges, bindings).
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework-message-queue:etc/topology.xsd">
    <exchange name="acme-giftwrap-exchange" type="topic" connection="amqp">
        <binding id="acmeGiftwrapBinding"
                 topic="acme.giftwrap.process"
                 destinationType="queue"
                 destination="acme.giftwrap.process"/>
    </exchange>
</config>
```

**`etc/queue_publisher.xml`** — which exchange a publisher posts to.
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework-message-queue:etc/publisher.xsd">
    <publisher topic="acme.giftwrap.process">
        <connection name="amqp" exchange="acme-giftwrap-exchange"/>
        <!-- Fallback to MySQL queue if AMQP unavailable -->
        <connection name="db" exchange="acme-giftwrap-exchange"/>
    </publisher>
</config>
```

**`etc/queue_consumer.xml`** — register the consumer that processes a queue.
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework-message-queue:etc/consumer.xsd">
    <consumer name="acmeGiftwrapProcessor"
              queue="acme.giftwrap.process"
              connection="amqp"
              handler="Acme\GiftWrap\Model\Queue\ProcessHandler::process"
              maxMessages="100"/>
</config>
```

For MySQL-only setups, use `connection="db"` everywhere instead of `amqp`.

### Publishing
```php
namespace Acme\GiftWrap\Model;

use Magento\Framework\MessageQueue\PublisherInterface;

class Service
{
    public function __construct(
        private readonly PublisherInterface $publisher
    ) {}

    public function queueIt(string $messageId): void
    {
        $this->publisher->publish('acme.giftwrap.process', $messageId);
    }
}
```

### Handling
```php
namespace Acme\GiftWrap\Model\Queue;

class ProcessHandler
{
    public function __construct(
        private readonly \Acme\GiftWrap\Api\MessageRepositoryInterface $repo,
        private readonly \Psr\Log\LoggerInterface $logger
    ) {}

    public function process(string $messageId): void
    {
        try {
            $message = $this->repo->getById((int) $messageId);
            // do the work
        } catch (\Throwable $e) {
            // re-throw to nack & retry, or swallow to ack-and-drop
            $this->logger->error('Process failed: ' . $e->getMessage());
            throw $e;
        }
    }
}
```

### Running consumers
```
bin/magento queue:consumers:list                 # list all consumers
bin/magento queue:consumers:start acmeGiftwrapProcessor       # run in foreground
bin/magento queue:consumers:start acmeGiftwrapProcessor --max-messages=100 --single-thread
```

In production, run consumers as long-lived processes via systemd or supervisord. Magento also supports auto-running via cron when `queue_consumers_cron_enabled = 1` in `env.php`:

```php
// env.php
'cron_consumers_runner' => [
    'cron_run' => true,
    'max_messages' => 1000,
    'consumers' => [],
    'multiple_processes' => ['acmeGiftwrapProcessor' => 2]
]
```

Magento's `default` cron group (and its job `consumers_runner`) then starts/restarts consumers.

### Async / Bulk REST endpoints (free with `webapi.xml`)
Any REST endpoint can be called via:
```
POST /rest/all/async/V1/<original-path>
POST /rest/all/async/bulk/V1/<original-path>
```
- `/async/` — synchronous-looking, queues to a topic.
- `/async/bulk/` — accepts an array, queues each.

Magento auto-generates topics from your `webapi.xml` for these. Inspect with `bin/magento queue:consumers:list`.

The bulk operation returns a `bulk_uuid`. Track progress:
```
GET /rest/V1/bulk/<bulk_uuid>/status
```

Returns counts of `complete`, `failed`, and `open` (pending) operations. Useful for batch product imports, inventory updates, etc.

To configure async/bulk, you don't need to write a consumer — Magento auto-registers `async.operations.all` consumer with handler `Magento\WebapiAsync\Model\OperationProcessor`. Just run that consumer.

## Common gotchas

### "Area code is not set" in CLI
Add `$this->appState->setAreaCode(Area::AREA_ADMINHTML)` in `execute()`. For background scripts, `Area::AREA_CRONTAB` is correct.

### Cron job doesn't run
- OS-level cron not installed (`bin/magento cron:install`).
- `cron_schedule` has stuck `running` rows blocking new schedule generation. Truncate `WHERE status='pending'` to refresh.
- Group is custom and you forgot to run `bin/magento cron:run --group=custom_group`.
- Magento's cron blacklist (`var/log/magento.cron.log`) — check for errors.

### Cron job runs but does nothing visible
- Method is `public`.
- Exception is being swallowed silently — wrap in try/catch and log.
- Check `cron_schedule.messages` for errors.

### Queue consumer silently dies
- `maxMessages` reached — by design. Restart it.
- Memory limit. Long-running consumers leak memory; `--max-messages=100` and let supervisord respawn is the standard pattern.
- DB connection drop (MySQL `wait_timeout`). Connection persists across messages; killed after idle. Magento re-establishes but logs a warning. Use a shorter `--max-messages`.

### "Topic … is not declared"
- `etc/communication.xml` typo in topic name.
- `cache:clean config` not run after editing.
- Module sequence missing — your module's `<sequence>` doesn't include `Magento_MessageQueue`.

### MySQL queue is slow / locks
With high volume on the default MySQL backend, the `queue_message` table grows and queue lookups slow down. Switch to RabbitMQ or aggressively prune `queue_message` for completed messages.

### CSV imports of products — use async/bulk
Magento's classic CSV import (`bin/magento import:product`) is single-threaded. For volume, use the REST POST `/V1/products` via `async/bulk/` — many parallel consumers can process.

### Bulk endpoints don't appear in REST schema
Bulk endpoints are generated, not listed in `webapi.xml` directly. They show up at `<base_url>/swagger?type=rest` under `/async/bulk/` paths.

## Original sources

- `references/sources/commerce-php/development/components/message-queues/` — message queue guide.
- `references/sources/commerce-php/development/components/async-operations.md` — async/bulk pattern.
- `references/sources/commerce-php/development/cli-commands/` — CLI command development.
- `references/sources/devdocs-v2.4/extension-dev-guide/cron/` — cron docs.
- `references/sources/devdocs-v2.4/extension-dev-guide/message-queues/` — older message queue docs.
- `references/sources/devdocs-v2.4/extension-dev-guide/cli-cmds/` — CLI command docs.
