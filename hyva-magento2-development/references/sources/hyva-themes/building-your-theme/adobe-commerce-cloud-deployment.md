<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/adobe-commerce-cloud-deployment.html -->

# Adobe Commerce Cloud Deployment

Deploying a Hyvä theme to Adobe Commerce Cloud requires special build configuration to generate Tailwind CSS stylesheets during the Cloud deployment process. Adobe Commerce Cloud uses a containerized build environment that differs from traditional hosting: Node.js is not pre-installed, the build phase runs before Magento is fully initialized, and generated files must be created during specific build hooks or they won't be included in deployed static assets.

This guide explains how to configure Adobe Commerce Cloud deployment for Hyvä themes. You'll learn to declare Node.js as a platform dependency, configure `.magento.app.yaml` build hooks for Tailwind CSS compilation, set up Composer authentication for Hyvä private packagist packages, commit required configuration files that can't be generated during Cloud builds, and fix `.gitignore` compatibility issues for Tailwind v4 source path resolution.

Running Hyvä Node daemons on Cloud

This page covers the build-time Tailwind CSS compilation of the storefront theme. If you also run a Hyvä Node daemon at runtime (the CMS Tailwind compiler or the response minifier), that needs a separate setup, and it only stays up on Pro Staging and Production. See [Running Node Daemons on Adobe Commerce Cloud](adobe-cloud-node-daemons.html).

## Tailwind CSS Stylesheet Generation in Build Hooks

Tailwind v4 Compatibility

Tailwind v4 source merging does not work with the default Adobe Commerce Cloud `.gitignore` file.
See [The .gitignore file for Tailwind 4 support](#troubleshooting-fixing-gitignore-for-tailwind-v4-compatibility) for the solution.

When the production Tailwind CSS stylesheet (`styles.css`) is not committed to version control, Adobe Commerce Cloud must generate it during the build phase using build hooks in `.magento.app.yaml`. The Tailwind CSS build process requires Node.js to compile the stylesheet from source files, but Adobe Commerce Cloud containers don't include Node.js by default, so it must be made available before the build hook runs.

### Installing Node.js via Platform Dependencies

Rather than downloading Node.js in the build hook, declare it as a platform dependency in `.magento.app.yaml`. This is simpler and faster (no per-build Node download), and it makes the same Node available **at runtime** — which is required for Hyvä's server-side Node daemons (the CMS Tailwind compiler and the response minifier).

```
dependencies:
    php:
        composer/composer: '2.x'
    nodejs:
        npm: "*"
```

Declared dependencies are added to `PATH` **during the build and at runtime**. Verify after a deploy:

```
magento-cloud ssh -e <environment> -- 'node -v; command -v node'
```

At the time of writing this provisions a current LTS (Node 24). `npm: "*"` simply pulls in `npm` (and therefore Node); if you rely on global CLI tools you can list them here instead.

Runtime availability

Unlike a Node installed ad-hoc with `nvm` in the build hook (which exists only during the build), a `dependencies.nodejs` Node is also present at runtime. That is what lets Hyvä's server-side Node daemons run on Cloud — see [Running Node Daemons on Adobe Commerce Cloud](adobe-cloud-node-daemons.html).

Alternative: install Node.js only during the build (no Node at runtime)

If you do not run any Hyvä Node daemons and prefer to keep Node.js off the production server entirely, you can install it with NVM inside the build hook instead of declaring `dependencies.nodejs`. This Node exists only during the build and is removed afterwards. Add the following at the start of the Tailwind build steps, before the `npm` calls:

```
# Install Node.js via NVM (Node Version Manager)
# Unset NPM_CONFIG_PREFIX to avoid conflicts with system npm
unset NPM_CONFIG_PREFIX
# Download and execute NVM installation script
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
# Load NVM into the current shell session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh"  ] && . "$NVM_DIR/nvm.sh"
# Install Node.js 20 LTS (required for Tailwind CSS CLI)
nvm install 20
```

Remove the downloaded Node.js after the build to reduce the deployed artifact size, by adding this after the `node_modules` cleanup:

```
# Remove NVM installation (Node.js not needed after build)
rm -rf ~/.nvm/
```

### Configuring the Build Hook for Tailwind CSS Compilation

The following `.magento.app.yaml` build hook configuration performs the complete Tailwind CSS build process during Adobe Commerce Cloud deployment. It uses the Node.js provided by `dependencies.nodejs` (on `PATH` at build time), creates the required output directory for compiled CSS, installs Tailwind dependencies from `package.json`, runs the Tailwind build script to generate the production stylesheet, and removes the `node_modules` directory to reduce the deployed artifact size.

Replace `{VENDOR}` and `{THEME}` with your theme's vendor name and theme name:

```
...

hooks:
    # build hooks run before the application has been packaged
    build: |
        ...

        # Build the Hyvä Tailwind CSS using the Node.js provided by
        # `dependencies.nodejs` (already on PATH at build time)
        echo "Building Hyvä Tailwind CSS with node $(node -v) / npm $(npm -v)"

        # Create output directory for compiled CSS file
        # Adobe Commerce Cloud build containers don't include theme directories by default
        mkdir -p app/design/frontend/{VENDOR}/{THEME}/web/css/

        # Install Tailwind CSS and PostCSS dependencies from package.json
        npm --prefix app/design/frontend/{VENDOR}/{THEME}/web/tailwind/ install --no-audit --no-fund --ignore-scripts

        # Run the Tailwind CSS build script to compile styles.css
        # This executes the "build" script defined in package.json
        npm --prefix app/design/frontend/{VENDOR}/{THEME}/web/tailwind/ run build

        # Clean up to reduce deployed artifact size
        # Remove node_modules directory (dependencies not needed at runtime)
        # NOTE: Remove this line if you run the CMS Tailwind Compiler daemon —
        # deploying the theme's node_modules lets it compile CMS Tailwind classes
        # without re-installing dependencies at runtime.
        rm -rf app/design/frontend/{VENDOR}/{THEME}/web/tailwind/node_modules/
        ...
```

The build log will show the version in use, e.g. `Building Hyvä Tailwind CSS with node v24.18.0 / npm 12.0.1`, confirming it is using the `dependencies.nodejs` Node.

Keep node\_modules when using the CMS Tailwind Compiler

If you run the [CMS Tailwind Compiler daemon](adobe-cloud-node-daemons.html), remove the `rm -rf …/node_modules/` line above. Deploying the theme's `node_modules` folder means the daemon can compile CMS Tailwind classes at runtime without having to re-install dependencies first.

Tip

If `npm --prefix … install` errors on the prefix (some hosts set `NPM_CONFIG_PREFIX`), add `unset NPM_CONFIG_PREFIX` before the `npm` calls.

### Integrating Tailwind CSS Build with ECE-Tools

When using Adobe Commerce Cloud's ECE-Tools, the Hyvä Tailwind CSS build must execute BEFORE the static content deployment phase. If the stylesheet is generated after `ece-tools run scenario/build/generate.xml` runs, the CSS file will not be discovered by static content deployment and won't be included in the deployed static assets.

The following example shows the complete build hook configuration with Composer install, Hyvä Tailwind CSS build steps (inserted at the correct position), and ECE-Tools scenarios in the proper execution order:

```
...

hooks:
    # build hooks run before the application has been packaged
    build: |
        set -e
        composer --no-ansi --no-interaction install --no-progress --prefer-dist --optimize-autoloader --no-dev

        ... steps from above ...

        php ./vendor/bin/ece-tools run scenario/build/generate.xml
        php ./vendor/bin/ece-tools run scenario/build/transfer.xml
    deploy: |
        ...
```

## Composer Authentication for Hyvä Packages

Adobe Commerce Cloud requires authentication credentials to download Hyvä packages from the private Hyvä packagist repository during `composer install`. There are two approaches to provide these credentials: **committing an `auth.json` file** or using **environment variables**.

### Option 1: Commit auth.json with Repository Configuration

Add a repository entry in `composer.json` for the Hyvä private packagist, then commit the `auth.json` file containing your Hyvä license credentials. Replace `{{MERCHANT-ID}}` with your Hyvä merchant ID from the license portal:

```
...
"repositories": {
    ...
    "hyva-private-packagist": {
        "type": "composer",
        "url": "https://hyva-themes.repo.packagist.com/{{MERCHANT-ID}}/",
        "only": [
            "hyva-themes/*"
        ]
    },
    ...
},
...
```

### Option 2: Use COMPOSER\_AUTH Environment Variable

If you prefer not to commit credentials to the repository, set the `COMPOSER_AUTH` environment variable at the PROJECT level (not the ENVIRONMENT level) in the Adobe Commerce Cloud console. This variable should contain the JSON-encoded authentication credentials that would otherwise be in `auth.json`.

## Committing the hyva-themes.json Configuration File

The `app/etc/hyva-themes.json` file contains the Tailwind CSS source path configuration for all installed Hyvä modules. Normally this file is generated by running `bin/magento hyva:config:generate` after Magento is installed.

On Adobe Commerce Cloud, the build phase runs before Magento is fully installed, so this file cannot be generated during deployment. The solution is to commit `app/etc/hyva-themes.json` to your repository after generating it locally. Without this file, the Tailwind build process will not find the required source files and the stylesheet compilation will fail.

## Prerequisites for Build-Time Static Content Deployment

`ece-tools run scenario/build/generate.xml` only performs static content deployment during the **build** if it can determine the store/theme/locale matrix — which it reads from `app/etc/config.php`. If that file contains only the `modules` list, build-time SCD is skipped and no `pub/static/deployed_version.txt` is produced, and the store returns `Unable to retrieve deployment version of static files from the file system` at runtime.

Use Configuration Management so the build has what it needs:

```
bin/magento app:config:dump   # writes scopes, themes, system, i18n into app/etc/config.php
```

Commit the resulting `app/etc/config.php` (env-specific values such as base URLs go to `env.php`, which is not committed).

## Troubleshooting: Fixing .gitignore for Tailwind v4 Compatibility

Tailwind v4 introduces the `@source` directive for automatic content path discovery in source CSS files. This directive respects `.gitignore` patterns when determining which files to scan for Tailwind classes. Adobe Commerce Cloud's default `.gitignore` file uses an "allow-list" approach that conflicts with Tailwind v4's source path resolution, causing build failures.

### The Problem: Allow-List .gitignore Blocks Tailwind v4 Source Resolution

Adobe Commerce Cloud's default `.gitignore` file starts with a wildcard `*` pattern to ignore all files, then selectively un-ignores specific files and directories using `!` negation patterns. This allow-list approach creates a problem for Tailwind v4: the initial `*` pattern matches everything including the `vendor/` directory, and Tailwind v4 interprets this literally when resolving `@source` paths.

When your Hyvä child theme's `tailwind-source.css` uses `@source` to include parent theme files from `vendor/hyva-themes/magento2-default-theme`, Tailwind v4 cannot access those files because `.gitignore` marks the entire `vendor/` directory as ignored. This causes the Tailwind CSS build to fail during Adobe Commerce Cloud deployment.

### The Solution: Use Deny-List .gitignore Pattern

Replace the Adobe Commerce Cloud `.gitignore` file with a "deny-list" approach that explicitly lists files and directories to ignore, rather than ignoring everything by default and then selectively un-ignoring paths. Use the [standard Magento 2 .gitignore](https://raw.githubusercontent.com/magento/magento2/refs/heads/2.4-develop/.gitignore) as a starting point, which lists specific paths to ignore (generated files, caches, IDE files) without using a catch-all wildcard at the beginning.

This deny-list approach allows Tailwind v4's `@source` directive to correctly resolve vendor paths for parent theme files while still excluding generated files and build artifacts from version control.
