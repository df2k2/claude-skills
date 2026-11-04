<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/server-side-setup.html -->

# Setting Up the Compiler Daemon

This page covers installing and running the server-side compiler for [server-side CMS Tailwind compilation](server-side-compilation.html). For the concept and configuration overview, start there.

What you actually need

A working setup is three things: [install the modules](#installing-the-modules), make sure each theme's [`web/tailwind/` directory is deployed](#theme-deployment-requirements), and choose how the daemon starts under [Daemon Management](#daemon-management). Everything after that — running under a process manager, connection tuning, and the standalone endpoint — is for production tuning and specific environments, and can be skipped at first.

## Installing the Modules

Install the compiler daemon and the bridge that connects it to the admin UI:

```
composer require hyva-themes/magento2-cms-tailwind-jit-bridge
```

The compiler is a dependency of the bridge, so the two are always installed together — Composer pulls in `magento2-cms-tailwind-compiler` automatically. Enable the modules and apply schema changes:

```
bin/magento setup:upgrade
```

The daemon's production Node dependencies ship bundled with the compiler module, so no `npm install` is needed to run it.

Theme Tailwind dependencies install automatically

Separate from the daemon's own bundled runtime dependencies, each theme's Tailwind dependencies are resolved per theme. When a theme has no `node_modules` of its own, the daemon installs them automatically into `var/hyva_cms_tailwind_deps/` on first compile (see [Theme Deployment Requirements](#theme-deployment-requirements)).

To also recompile existing CMS content in bulk after switching, install the recompile module as well — see [Recompiling CMS Content](recompiling-cms-content.html).

## Theme Deployment Requirements

The daemon compiles against each theme's own Tailwind toolchain, so each Hyvä theme's `web/tailwind/` directory must be deployed. This includes `package.json`, the Tailwind config (`tailwind-source.css` for v4 themes or `tailwind.config.js` for v3 themes), and any local CSS files the config references.

The `node_modules/` directory is **not** required. If a theme already has its own `web/tailwind/node_modules`, the daemon uses it directly; only when it is missing does the daemon auto-install that theme's dependencies into `var/hyva_cms_tailwind_deps/` (configurable via `deps_dir`) on first use.

Deployments that strip `web/tailwind/`

Build pipelines that deploy only `web/css/` and remove `web/tailwind/` must be adjusted to keep `web/tailwind/` (excluding `node_modules/`). Without it, the daemon cannot compile for that theme.

### Generated Sources

Each theme also needs `generated/hyva-source.css` and `generated/hyva-tokens.css` in its `web/tailwind/` directory so compilation includes module CSS and design tokens. These are produced by the `hyva-sources` and `hyva-tokens` scripts from `@hyva-themes/hyva-modules`.

If the generated files are missing, the daemon runs the scripts automatically on first compile. If they exist but are **stale** (for example, after a new module was added), the daemon reuses the outdated files. Regenerate them and restart the daemon:

```
cd vendor/hyva-themes/magento2-default-theme/web/tailwind
npx hyva-sources && npx hyva-tokens
```

Repeat for each Hyvä child theme.

## Daemon Management

The **Daemon Management** dropdown under `Stores → Configuration → Hyvä Themes → System → CMS Tailwind Compilation` controls whether the daemon starts automatically:

- **Off** (default) — Start the daemon manually, or with the Start button on the same configuration screen.
- **Cron** — A cron job checks every minute and starts the daemon if it is not running.
- **Start on-demand** — The daemon is started automatically on the first compile request that needs it, gated by a spawn lock so concurrent triggers do not race.

The same configuration screen shows the current daemon status and provides Start and Restart buttons.

The first compilation per theme is slower

The daemon loads and caches each theme's Tailwind compiler the first time it compiles for that theme after starting (and, when needed, auto-installs the theme's dependencies and generates its source files). That first compilation can therefore take noticeably longer. Subsequent compilations for the same theme reuse the cached compiler and are much faster.

Permissions for cron + php-fpm

The daemon state file (`var/hyva_cms_tailwind_daemon.json`) is written with mode `0660` because it holds the daemon's bearer token. The cron user and the php-fpm user must be the same user or share a group so both can read the token.

## The Auth Token

The daemon authenticates every compile request with a bearer token, so that only Magento can reach the compiler. The daemon and Magento's PHP side read that token from **different places**, and both must carry the **same value**:

- The **daemon** reads the token *only* from the `TAILWIND_COMPILER_AUTH_TOKEN` environment variable. It **refuses to start** if the variable is not set.
- The **PHP side** (the admin compile controller and the standalone `pub/cms-tailwind.php` endpoint) reads it *only* from the `auth_token` field of `var/hyva_cms_tailwind_daemon.json`. It never reads an environment variable or a config value.

The token is a **random secret**, not a value derived from your Magento configuration.

When Magento starts the daemon itself — the admin Start button, **Cron**, or **Start on-demand** — it generates the token and writes it to both places automatically, so there is nothing to configure. You only have to establish the shared value manually when you start the daemon yourself (systemd, supervisor, system cron, or by hand — typically because PHP's `shell_exec`/`proc_open` are disabled).

### Obtaining the Token

Use the `hyva:cms-tailwind:token` command to obtain the token. It generates one on first run, persists it to the state file (so the PHP side can authenticate), and prints it so you can set it in the daemon's environment. Re-running returns the same token, so a running daemon keeps working:

```
TOKEN=$(bin/magento hyva:cms-tailwind:token)
```

Only the token is written to stdout, so it is safe to capture into a variable; advisory messages go to stderr.

- `--export` prints the value as `TAILWIND_COMPILER_AUTH_TOKEN=<token>` instead of the bare token, which is handy for a systemd `EnvironmentFile`.
- `--regenerate` (or `-f`) rotates the token. After rotating, you must restart the daemon with the new value.

`401 Unauthorized` from compile requests

If PHP compile requests come back as `401 Unauthorized`, the token in the state file and the one in the daemon's environment have diverged. Re-run `bin/magento hyva:cms-tailwind:token` and restart the daemon with the printed token.

## Starting the Daemon via the CLI

Supply the [auth token](#the-auth-token) in the daemon's environment. Without `TAILWIND_COMPILER_AUTH_TOKEN` the daemon refuses to start:

```
TOKEN=$(bin/magento hyva:cms-tailwind:token)
TAILWIND_COMPILER_AUTH_TOKEN="$TOKEN" \
    node vendor/hyva-themes/magento2-cms-tailwind-compiler/node/daemon.mjs
```

A custom TCP port or a Unix socket can be specified:

```
TAILWIND_COMPILER_AUTH_TOKEN="$TOKEN" \
    node vendor/hyva-themes/magento2-cms-tailwind-compiler/node/daemon.mjs --port 3200
TAILWIND_COMPILER_AUTH_TOKEN="$TOKEN" \
    node vendor/hyva-themes/magento2-cms-tailwind-compiler/node/daemon.mjs --socket /tmp/hyva-cms-tailwind.sock
```

## Running in Production with a Process Manager

If PHP can spawn processes (`shell_exec`/`proc_open` are available), the built-in [Daemon Management](#daemon-management) options (**Cron** or **Start on-demand**) are perfectly fine in production and need no external process manager — Magento starts the daemon, generates the [auth token](#the-auth-token), and writes the state file for you.

Running the daemon under a system process manager is an **alternative**, primarily for hosts where PHP cannot spawn processes. In that case, leave Daemon Management set to **Off**, and note that the unit must supply `TAILWIND_COMPILER_AUTH_TOKEN` — the same token that is written to `var/hyva_cms_tailwind_daemon.json` (see [The Auth Token](#the-auth-token)). Keep the secret out of the unit file itself by loading it from a root-owned `EnvironmentFile` (mode `0600`).

Adobe Commerce Cloud

On Adobe Commerce Cloud the daemon persists only on **Pro Staging and Production** (dedicated IaaS nodes), and only in **Cron** mode. On all Starter environments and on Pro Integration it is reaped seconds after starting, so use the in-browser fallback there. See [Running Node Daemons on Adobe Commerce Cloud](../../building-your-theme/adobe-cloud-node-daemons.html).

Example systemd unit:

```
[Unit]
Description=Hyvä CMS Tailwind Compiler Daemon
After=network.target

[Service]
Type=simple
Environment=MALLOC_ARENA_MAX=2
# TAILWIND_COMPILER_AUTH_TOKEN=... — keep the secret in this file (chmod 600).
EnvironmentFile=/etc/hyva-cms-tailwind.env
WorkingDirectory=/var/www/html/vendor/hyva-themes/magento2-cms-tailwind-compiler/node
ExecStart=/usr/bin/node daemon.mjs
Restart=always
User=www-data

[Install]
WantedBy=multi-user.target
```

Populate the `EnvironmentFile` with the token from the CLI command:

```
bin/magento hyva:cms-tailwind:token --export | sudo tee /etc/hyva-cms-tailwind.env
sudo chmod 600 /etc/hyva-cms-tailwind.env
```

Why `MALLOC_ARENA_MAX=2`?

When Magento starts the daemon (cron, on-demand, or the admin button), it sets `MALLOC_ARENA_MAX=2` in the daemon's environment. The Tailwind compiler produces many small, short-lived allocations, and glibc rarely returns freed memory to the OS — on multi-core hosts this can push the daemon's resident memory into the tens of GB even though the working set is small. Capping glibc's allocator arenas at 2 bounds this overhead, typically reducing long-term memory by an order of magnitude.

The variable is harmless on platforms that do not use glibc (musl/Alpine, macOS, BSD). When running the daemon under a service manager, add it to the unit's environment as shown above.

## Connection Settings

Connection and transport settings live in `app/etc/env.php`:

```
'hyva' => [
    'node_binary' => '/usr/local/bin/node'  // default: 'node' (from $PATH)
],
'hyva_cms_tailwind' => [
    'transport' => 'tcp',                            // 'tcp' or 'unix_socket'
    'tcp_host' => '127.0.0.1',                       // default
    'tcp_port' => 3200,                              // default
    'socket_path' => '/tmp/hyva-cms-tailwind.sock',  // default (unix_socket mode)
    'connect_timeout_ms' => 100,                     // default
    'read_timeout_ms' => 2500,                       // default
    // 'deps_dir' => '/path/to/var/hyva_cms_tailwind_deps', // default: var/hyva_cms_tailwind_deps
    // 'standalone_endpoint_url' => '/cms-tailwind.php',    // see Standalone Endpoint below
]
```

The connection and read timeouts are also editable in the admin under the **CMS Tailwind Compilation** group, and from the command line:

```
bin/magento config:set hyva_cms_tailwind/general/connect_timeout_ms 100
bin/magento config:set hyva_cms_tailwind/general/read_timeout_ms 2500
```

By default `config:set` writes to the database. Add `--lock-env` to write the value into `app/etc/env.php` instead, so it can be committed and deployed:

```
bin/magento config:set --lock-env hyva_cms_tailwind/general/connect_timeout_ms 100
```

### Other connection settings (deployment configuration)

The remaining settings — `transport`, `tcp_host`, `tcp_port`, `socket_path`, `node_binary`, `deps_dir`, and `standalone_endpoint_url` — are read directly from `app/etc/env.php` as deployment configuration. Magento core has no `bin/magento` command to write arbitrary `env.php` paths, so either edit `env.php` directly (as shown above) or use [n98-magerun2](https://github.com/netz98/n98-magerun2)'s `config:env:set`, which takes a `/`-separated path:

```
magerun2 config:env:set hyva_cms_tailwind/transport tcp
magerun2 config:env:set hyva_cms_tailwind/tcp_host 127.0.0.1
magerun2 config:env:set hyva_cms_tailwind/tcp_port 3200
magerun2 config:env:set hyva_cms_tailwind/socket_path /tmp/hyva-cms-tailwind.sock
magerun2 config:env:set hyva/node_binary /usr/local/bin/node
```

## Standalone Endpoint (Optional)

For maximum performance, the compiler module includes a standalone PHP file (`pub/cms-tailwind.php`) that bypasses Magento's bootstrap, reducing the per-request auth overhead from roughly 20 ms to about 1 ms. It is deployed automatically via Composer when the module is installed through the Magento Composer installer.

The endpoint is **only used when it is configured** in `app/etc/env.php`. Until then, the JS API uses the default Magento admin controller, so this section is entirely optional.

Not an open compilation server

The standalone endpoint requires a valid Magento admin session — it cannot be called without one — so exposing it does not create an open, unauthenticated compilation service.

To enable it, configure the endpoint in `app/etc/env.php`:

```
'hyva_cms_tailwind' => [
    'standalone_endpoint_url' => '/cms-tailwind.php',
    // ... other settings
]
```

Most web server setups execute any `.php` file under `pub/` and need no further configuration. Some hardened setups — such as Magento's sample nginx config, which only whitelists specific entry points — need an explicit location so `cms-tailwind.php` is allowed to run. For nginx:

```
# Hyvä CMS Tailwind Compiler standalone endpoint
location = /cms-tailwind.php {
    fastcgi_pass   fastcgi_backend;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}
```

## When to Restart the Daemon

The daemon caches each theme's Tailwind compiler for the lifetime of the process. Restart it after:

- Changing a theme's Tailwind configuration (`tailwind.config.js` for v3, `tailwind-source.css` for v4)
- Changing a theme's `postcss.config.js` (v3 only)
- Switching a theme's Git branch (for example between major versions)
- Adding or removing Tailwind plugins in a theme's `package.json`
- Running `npm install` in a theme's `web/tailwind/` directory
- Deleting and regenerating `generated/hyva-source.css` or `generated/hyva-tokens.css`

Changes to `web/css/styles.css` do **not** require a restart — the daemon watches that file and reloads its selector cache automatically.
