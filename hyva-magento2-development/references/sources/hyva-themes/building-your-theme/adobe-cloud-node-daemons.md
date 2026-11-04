<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/adobe-cloud-node-daemons.html -->

# Running Node Daemons on Adobe Commerce Cloud

Some Hyvä features are powered by long-running **Node.js daemons**. On Adobe Commerce Cloud, whether such a daemon stays alive comes down to one thing, and it is not the module configuration. It is the **infrastructure the environment runs on**.

The one rule for Hyvä Node daemons on Adobe Commerce Cloud

A Hyvä Node daemon persists **only on dedicated-IaaS environments - Adobe Commerce Cloud Pro Staging and Production - and only in Cron mode** (`daemon_management = cron`).

On every PaaS grid-container environment (**all Starter environments, including production/`master`, plus Pro Integration**) the daemon is reaped within seconds of starting. That is a property of the platform's process supervision, not a bug and not something you configured wrong. There is nothing to fix there: use the [graceful fallback](#running-without-the-daemon-the-graceful-fallback) instead.

So when a Hyvä daemon "will not stay up" on Cloud, the first question is never about the module settings. It is: **which environment architecture is this?**

## What a Hyvä Node Daemon Needs from the Environment

Two Hyvä modules currently ship a Node daemon: the **CMS Tailwind compiler** (`hyva-themes/magento2-cms-tailwind-compiler`) and the **response minifier** (`hyva-themes/magento2-minification`). On Adobe Commerce Cloud they behave identically, and everything on this page applies to either one. For what each daemon does and how to configure it in general, see [Related Topics](#related-topics) at the end.

Both place the same three demands on the environment:

- **Node.js 20 or newer at runtime.** The Cloud runtime container ships no `node` binary at all, so this has to be arranged deliberately.
- **A home in the web container.** php-fpm contacts the daemon on `127.0.0.1` or a Unix socket in `/tmp` while a page is being rendered, so the daemon has to sit in the same container. A Cloud **worker cannot be used**: a worker is a separate container that shares neither the web container's loopback nor its `/tmp`.
- **A launch context the platform does not reap.** This is the hard part on Cloud, and the subject of the rest of this page.

The storefront theme CSS is not a daemon concern

Hyvä's **storefront** Tailwind CSS is compiled at **build time** in the `build` hook and needs no runtime Node process. See [Adobe Commerce Cloud Deployment](adobe-commerce-cloud-deployment.html). Only dynamic CMS content and response minification use a daemon.

## Where the Daemon Persists: The Environment Matrix

Persistence on Adobe Commerce Cloud depends entirely on whether the environment is a dedicated VM or a PaaS grid container.

| Plan | Environment | Infrastructure | Daemon persists? |
| --- | --- | --- | --- |
| **Pro** | Production (3 nodes) | Dedicated IaaS | **Yes** ✅ |
| **Pro** | Staging / Staging2 (3 nodes each) | Dedicated IaaS | **Yes** ✅ |
| **Pro** | Integration | PaaS grid container | **No** ❌ |
| **Starter** | Production (`master`) | PaaS grid container | **No** ❌ |
| **Starter** | Staging | PaaS grid container | **No** ❌ |
| **Starter** | Integration | PaaS grid container | **No** ❌ |

This follows directly from Adobe's own architecture documentation: on Pro, "staging and production run on dedicated IaaS" while "the integration environment architecture does not match the Staging and Production architecture" ([Pro architecture](https://experienceleague.adobe.com/en/docs/commerce-on-cloud/user-guide/architecture/pro-architecture)), and on Starter "all environments are in PaaS containers ... on a grid of servers" ([Starter architecture](https://experienceleague.adobe.com/en/docs/commerce-on-cloud/user-guide/architecture/starter-architecture)).

On Starter there is no environment where the daemon persists

Not even Starter production. If a project needs the server-side Hyvä daemon, it has to be on **Pro**, and it will only run on Pro **Staging and Production** - never on Pro Integration.

### Why Dedicated IaaS Nodes Keep the Daemon Alive

A Pro Staging or Production node is a real VM with `systemd` as PID 1. The watchdog spawns the daemon with `setsid`, so it is reparented to PID 1, but it stays inside the `cron.service` control group. Measured on a live Pro production node:

```
# The daemon started by the Hyvä cron watchdog, seen from the Pro web node
$ ps -o pid,ppid,cmd -C node
PID       PPID  CMD
1166846   1     node .../daemon.mjs        # reparented to PID 1 by setsid

$ grep pids /proc/1166846/cgroup
11:pids:/app.slice/cron.service            # lives in the cron.service cgroup

$ systemctl show cron.service -p KillMode
KillMode=process                           # this is why the daemon survives
```

`KillMode=process` tells `systemd` to kill only the unit's **main process** when `cron.service` stops or restarts, never the rest of its control group. The daemon, detached by `setsid` and sitting in that cgroup, is simply left running when `bin/magento cron:run` exits. That single setting is the whole mechanism.

### Why PaaS Grid Containers Reap the Daemon

On a grid container the `KillMode` is inverted: cron runs as **`KillMode=control-group`**. When the scope that ran `cron:run` is torn down, the whole control group goes with it, and a `setsid`'d child process is inside that group. The result is that **everything the application spawns is killed when its scope ends**. A test on a Starter environment reproduced it precisely:

```
cron.log:  14:57:36  Launching 'php bin/magento cron:run'
pgrep:     14:57:38  1309 node .../daemon.mjs   (present)
pgrep:     14:57:43  1309 node .../daemon.mjs   (present)
pgrep:     14:57:44  (gone - killed as cron:run exited, ~6s after spawn)
```

The Hyvä watchdog dutifully respawns the daemon on the next cron cycle, and the platform reaps it again seconds later. The net result is a fresh PID every minute and a daemon that is never usable. `setsid` does not help, because the kill happens at the cgroup level and `setsid` changes the session, not cgroup membership.

## Identifying Your Cloud Environment

Two facts decide it: the **plan** (Starter or Pro) and, on Pro, **which environment** (Integration, or Staging/Production).

Environment type alone is not enough

`type: production` does not mean a dedicated VM. Starter's production branch (`master`) reports `type: production` and is still a grid container. Always combine plan **and** environment: *Pro + Staging/Production = dedicated VM (daemon works); everything else = grid container (daemon reaped).*

### Quick Tells from Outside the Container

- **SSH endpoint format.** A dedicated VM (Pro Staging/Production) uses **numbered** nodes: `1.ent-<project>-<env>-<hash>@ssh...`, and `magento-cloud ssh` offers a choice of three nodes. A grid container uses a single instance, `<project>-<env>-<hash>--<app>@ssh...`, and its shell prompt ends in `.0` (for example `web@<app>.0:~$`).
- **Node count.** Three selectable nodes means a dedicated VM. One instance means a grid container.

**Checking the plan.** A bare `magento-cloud subscription:info` prints a very large property table, so ask it for just the property that matters:

```
magento-cloud subscription:info plan            # the plan identifier, e.g. magento/pro_core24
magento-cloud environment:info -e <env> type    # development | staging | production
magento-cloud environment:list                  # all branches and their types
```

The `plan` value is a plan identifier, not the words "Starter" or "Pro". Only the `magento/pro_*` plans get dedicated IaaS nodes:

| `plan` value | What it is | Daemon can persist? |
| --- | --- | --- |
| `magento/pro_core12`, `..._core24`, `..._core48`, `..._core96`, `..._core120`, `magento/pro_trial` | Pro | Yes, but only on Staging and Production ✅ |
| `magento/starter`, `magento/starter_large`, `magento/starter_xlarge`, `magento/starter_trial` | Starter | **No**, on any environment ❌ |
| `magento/development`, `magento/extension_developer`, `magento/sales_demo` | Partner, developer, and demo sandboxes | **No**, on any environment ❌ |

If your plan is not listed, apply the rule behind the table: anything that is not a `magento/pro_*` plan runs on PaaS grid containers, where a Hyvä daemon cannot persist.

Partner and sandbox projects are neither Starter nor Pro

A Hyvä or Adobe partner sandbox usually reports `plan: magento/development`. That is a third category, and it runs on PaaS grid containers just like Starter does, so the daemon cannot persist there. On a sandbox this is the expected result, not a sign that something is misconfigured. Develop against the [graceful fallback](#running-without-the-daemon-the-graceful-fallback) and validate the daemon on a Pro Staging environment.

**Checking the environment.** Pro Integration branches report `type: development`, Pro Staging reports `staging`, and Production/`master` reports `production`. Remember that `type` on its own settles nothing: you need the plan as well. Both the plan and the environment list are also on the Cloud Console project overview page.

### Definitive Checks Inside the Container

One check settles it: **which `KillMode` the cron service uses.** That single value is what decides whether a daemon launched by the cron watchdog survives, so it beats any inference about the infrastructure underneath it. Run it over SSH:

```
systemctl show cron.service -p KillMode 2>/dev/null || echo "systemctl unavailable"
```

| Output | What it means | Daemon persists? |
| --- | --- | --- |
| `KillMode=process` | Only the cron main process is killed, so the detached daemon is left running | **Yes** ✅ |
| `KillMode=control-group` | The entire cron control group is killed, daemon included | **No** ❌ |
| No output, or `systemctl unavailable` | systemd is not reachable for the application user, and the platform supervisor reaps the scope | **No** ❌ |

A working systemd does not mean you are on a dedicated VM

Plenty of grid containers run a perfectly healthy systemd. On a partner sandbox (`plan: magento/development`), `systemctl is-system-running` reports `running` and `systemctl show cron.service -p KillMode` answers `KillMode=control-group`. So the presence of systemd, or the fact that `systemctl` replies at all, tells you nothing about daemon persistence. Read the **`KillMode` value**: only `process` means a Hyvä daemon can survive.

**Corroborating signals.** These fill in the picture, but they vary between environment flavors, so treat them as supporting evidence rather than the verdict:

```
cat /proc/self/cgroup                  # dedicated VM -> systemd slices (/app.slice/..., /system.slice/...)
                                       #   grid -> often root paths ("N:<ctrl>:/", "0::/")
hostname                               # dedicated nodes have distinct per-node hostnames
```

On a **dedicated VM** (Pro Staging or Production) the daemon's cgroup lives under a systemd slice and `cron.service` reports `KillMode=process`. That is what lets the Hyvä daemon survive. Anywhere `KillMode` is not `process`, the daemon will be reaped, and no amount of module configuration changes that.

## Cron Mode Is the Only Safe Mode on Cloud

The `daemon_management` setting has three values: `off`, `cron`, and `on_demand`. On Adobe Commerce Cloud, **only `cron` is safe**.

In `cron` mode the Hyvä watchdog (`DaemonWatchdog`, scheduled `* * * * *`) runs inside `bin/magento cron:run`, checks whether the daemon is healthy, and spawns it if it is not. On a Pro Staging or Production node, `cron.service` is `KillMode=process`, so the daemon it launched keeps running.

Never use on\_demand on Adobe Commerce Cloud

In `on_demand` mode the daemon is spawned by a **web request**, which means php-fpm is its parent scope. On Pro Staging and Production, php-fpm is supervised under **runit with `KillMode=control-group`**, so any php-fpm reload or restart kills the entire php-fpm cgroup - including the daemon. It will look like it works, then vanish on the next deploy or reload. Always configure `cron`.

## Setting Up a Hyvä Node Daemon on Pro Staging and Production

The setup below is for a Pro Staging or Production environment. On grid containers, skip it and go to [Running Without the Daemon](#running-without-the-daemon-the-graceful-fallback).

### 1. Make Node.js Available at Runtime

The Cloud runtime container has no `node` binary. The simplest fix is to declare Node as a platform dependency in `.magento.app.yaml`, which puts `node` and `npm` on `PATH` at build time **and** at runtime:

```
dependencies:
    php:
        composer/composer: '2.x'
    nodejs:
        npm: "*"
```

Verify it after a deploy:

```
magento-cloud ssh -e <env> -- 'node -v; command -v node'
```

Alternative: copy a Node binary into the build artifact

This approach has been verified end to end on a live Pro production environment. Install Node with `nvm` during the build, copy the binary into the artifact, then remove `nvm`:

```
unset NPM_CONFIG_PREFIX
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"
nvm install 20
npm --prefix vendor/hyva-themes/magento2-minification/node install --ignore-scripts --no-audit --no-fund
cp "$(which node)" /app/bin/node && chmod +x /app/bin/node
rm -rf ~/.nvm
```

The `/app` prefix is rewritten to the real application root at runtime, so configuring `node_binary` as `/app/bin/node` resolves correctly with no project ID hardcoded anywhere.

### 2. Install the Daemon's Node Dependencies in the Build Hook

The CMS Tailwind compiler ships its production Node dependencies pre-bundled, so it needs no install step. The response minifier does not: it depends on `@swc/html` and needs an `npm install`. Because the runtime filesystem is read-only, run that install in the **`build` hook** so `node_modules` is baked into the image:

```
hooks:
    build: |
        set -e
        composer install --no-dev
        # ... storefront Tailwind build ...
        npm --prefix vendor/hyva-themes/magento2-minification/node install --ignore-scripts
        php ./vendor/bin/ece-tools run scenario/build/generate.xml
        php ./vendor/bin/ece-tools run scenario/build/transfer.xml
```

Never commit a locally-built node\_modules

`@swc/html` ships its native binary as **platform-specific optional dependencies** (`@swc/html-linux-x64-gnu` and friends), and npm resolves only the one matching the machine it runs on. A `node_modules` installed on macOS or on arm64 will fail to load on Cloud's linux-x64 container, and the daemon crashes on startup. Always run the install in the **Cloud build hook** so the correct binary is fetched for the runtime platform, and keep `node_modules` git-ignored - the module's `node/.gitignore` already does this.

### 3. Configure the Daemon with Environment Variables

On Adobe Commerce Cloud, `app/etc` is a shared mount, so avoid deploy-time writes to `app/etc/env.php`. Configure both daemons through Magento's configuration environment variables in `.magento.app.yaml` instead:

```
# .magento.app.yaml
variables:
    env:
        # Deployment config (the env.php equivalent, resolved at runtime)
        MAGENTO_DC_HYVA_MINIFICATION__NODE_BINARY: '/app/bin/node'
        MAGENTO_DC_HYVA_MINIFICATION__TRANSPORT: 'unix_socket'
        MAGENTO_DC_HYVA_MINIFICATION__SOCKET_PATH: '/tmp/hyva-minifier.sock'
        # Scope config (core_config_data) - survives app:config:import
        CONFIG__DEFAULT__HYVA_MINIFICATION__GENERAL__ENABLED: '1'
        CONFIG__DEFAULT__HYVA_MINIFICATION__GENERAL__DAEMON_MANAGEMENT: 'cron'
```

Enabling the daemon through `CONFIG__DEFAULT__` rather than the admin toggle means the setting cannot be lost to an `app:config:import`. Prefer a **Unix socket in `/tmp`**, which is writable and node-local on Cloud: php-fpm and the daemon share the container, so there is no reason to occupy a TCP port. On Pro, cron runs on every web node, so you get **one daemon and one socket per node** - three per environment.

### Configuration Path Reference

Both daemons take the same settings, each under its own configuration namespace. The response minifier paths are shown here:

| Setting | Config type | Config path | Environment variable |
| --- | --- | --- | --- |
| `enabled` | scope | `hyva_minification/general/enabled` | `CONFIG__DEFAULT__HYVA_MINIFICATION__GENERAL__ENABLED` |
| `daemon_management` | scope | `hyva_minification/general/daemon_management` | `CONFIG__DEFAULT__HYVA_MINIFICATION__GENERAL__DAEMON_MANAGEMENT` |
| `node_binary` | deployment | `hyva_minification/node_binary` | `MAGENTO_DC_HYVA_MINIFICATION__NODE_BINARY` |
| `transport` | deployment | `hyva_minification/transport` | `MAGENTO_DC_HYVA_MINIFICATION__TRANSPORT` |
| `tcp_host` / `tcp_port` | deployment | `hyva_minification/tcp_host`, `.../tcp_port` | `MAGENTO_DC_HYVA_MINIFICATION__TCP_HOST`, `..._TCP_PORT` |
| `socket_path` | deployment | `hyva_minification/socket_path` | `MAGENTO_DC_HYVA_MINIFICATION__SOCKET_PATH` |

The CMS Tailwind compiler uses the same shape under `hyva_cms_tailwind/...`. For the handful of points where the two daemons diverge on Cloud, see [What Differs Between the Two Daemons on Cloud](#what-differs-between-the-two-daemons-on-cloud).

## Running Without the Daemon: The Graceful Fallback

On every environment where the daemon cannot persist - all Starter environments and Pro Integration - both modules degrade gracefully. The storefront keeps working, it just does the work in the browser or skips the optimization:

- **Response minifier.** Logs a warning and serves the response **unminified**. No error, no broken page.
- **CMS Tailwind compiler.** Set `compilation_strategy` to `in-browser` and Tailwind compiles **client-side**.

This is the recommended path on any grid-container environment, and setting expectations around it beats chasing a daemon the platform will not let live. It also covers the gap after a deploy on Pro, before the watchdog has restarted the daemon.

## What to Expect in Production on Pro

These figures come from a Hyvä customer running both daemons on live Pro production nodes:

- **Memory is stable at roughly 350 MB RSS** per daemon under production traffic, and 76-90 MB on low-traffic staging. The watchdog sets `MALLOC_ARENA_MAX=2` to bound glibc arena growth, which keeps it flat. **47 days of continuous running with no leak** was observed.
- **The daemon only dies on a deploy** (container restart) or a manual `cron.service` restart. No daily platform event takes it down.
- **The watchdog restarts it within 2 to 4 minutes.** During that window the graceful fallback serves unminified responses. Post-deploy watchdog latency is really the only thing worth tuning.

## Troubleshooting a Daemon That Will Not Stay Up

Work through this in order. Step one is not optional: identifying the architecture first saves debugging a problem that has no solution.

**1. Identify the environment architecture.** Use the [checks above](#definitive-checks-inside-the-container). On a **grid container** (any Starter environment, or Pro Integration) this is expected behavior - stop debugging and switch to the [graceful fallback](#running-without-the-daemon-the-graceful-fallback), or move to Pro Staging/Production if server-side compilation is genuinely needed. On a **dedicated VM** (Pro Staging/Production) it should work, so continue.

**2. Check the setup on the dedicated VM.** These commands cover every common cause, using the minifier as the example:

```
php bin/magento config:show hyva_minification/general/daemon_management  # must be 'cron', not on_demand or off
php bin/magento config:show hyva_minification/general/enabled            # 1
ls -l /app/bin/node && /app/bin/node -v                                  # node binary present and runnable
ls vendor/hyva-themes/magento2-minification/node/node_modules >/dev/null && echo deps-ok
pgrep -af daemon.mjs                                                     # is the daemon running?
ls -l /tmp/hyva-minifier.sock                                            # is the socket there?
tail -n 40 var/log/hyva_minifier_daemon.log                              # startup errors, or the "listening" line
grep -E 'cron:run|Killed' /var/log/cron.log | tail                       # watchdog firing, and any OOM kills
systemctl show cron.service -p KillMode                                  # expect KillMode=process
```

**3. Interpret what you found.**

- Daemon absent and `daemon_management = on_demand` - wrong mode, switch to `cron`.
- Daemon dies only on deploys and reloads - normal. Check watchdog latency, nothing more.
- `node: not found`, or a missing `node_modules` - the build hook did not install Node or the daemon dependencies.
- Socket missing, or connection refused - a `transport` and `socket_path` mismatch, or the daemon crashed at startup. Read the daemon log for a stacktrace; this is often a native-binary architecture error caused by a committed `node_modules`.
- `cron.log` shows `Killed` alongside memory pressure - that is an out-of-memory kill, not scope reaping. The two look alike, so go by the fingerprint: an OOM kill coincides with memory pressure, while scope reaping kills the daemon precisely when `cron:run` exits, with the box otherwise idle.

A frequent aggravator: pinned full-page cache application

OOM pressure on Cloud very often traces back to `bin/magento app:config:dump` being run on a local environment that uses Varnish. That captures `system/full_page_cache/caching_application => 2` (Varnish/Fastly) into the shared `app/etc/config.php`, where it is then applied on **every** environment - including those with no Fastly in front, since Fastly is a Pro Staging/Production facility. There, the value disables Magento's built-in Redis full-page cache and hands caching to a Varnish that is not there, so nothing caches at all. Every response becomes a full PHP render, php-fpm workers get OOM-killed under any concurrency, and you get intermittent `502`s.

The tell is internal headers leaking to the client (`X-Magento-Tags`, `Set-Cookie: PHPSESSID`, `Pragma: cache`) on a repeated guest request. When the built-in cache is active it strips those headers before responding, so if they reach the client, it never ran. The fix is to remove the key from the shared `config.php` and let each environment resolve it for itself:

```
grep -n caching_application app/etc/config.php                          # should NOT be pinned
php bin/magento config:show system/full_page_cache/caching_application   # empty or 1 on Fastly-less envs
```

## What Differs Between the Two Daemons on Cloud

Almost nothing about the Cloud setup differs between the two Hyvä daemons. These four points do:

|  | CMS Tailwind compiler | Response minifier |
| --- | --- | --- |
| Config namespace | `hyva_cms_tailwind` | `hyva_minification` |
| Enable switch | `hyva_cms_tailwind/hyva_cms_bridge/compilation_strategy` = `daemon` | `in-browser` | `hyva_minification/general/enabled` = `1` | `0` |
| Node dependencies in the build hook | Pre-bundled, no `npm install` needed | `npm install --ignore-scripts` required |
| Daemon log | `var/log/hyva_cms_tailwind_daemon.log` | `var/log/hyva_minifier_daemon.log` |

## Related Topics

- **[Setting Up the Compiler Daemon](../cms/tailwind-jit/server-side-setup.html)** - Full install and configuration for the CMS Tailwind compiler daemon.
- **[Hyvä Response Minification and Merging](../performance/hyva-minification-readme.html)** - Full install and configuration for the response minifier daemon.
- **[Adobe Commerce Cloud Deployment](adobe-commerce-cloud-deployment.html)** - Build-time Tailwind CSS compilation of the storefront theme on Cloud.
