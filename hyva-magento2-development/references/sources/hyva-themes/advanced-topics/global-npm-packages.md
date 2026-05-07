<!-- source: https://docs.hyva.io/hyva-themes/advanced-topics/global-npm-packages.html -->

# Centralized NPM Dependencies for Multi-Theme Projects

This guide explains how to centralize NPM dependencies and Tailwind CSS build configuration at the Magento project root for building multiple Hyvä themes. Instead of maintaining separate Node.js installations and `package.json` files in each theme's `web/tailwind/` directory, this approach consolidates all build dependencies (Tailwind CSS, PostCSS, Autoprefixer) into a single NPM project. This centralized NPM build configuration mirrors workflows familiar from Luma-based SCSS tooling like Snowdog Frontools, where all frontend build dependencies are managed centrally rather than duplicated in each theme directory.

Advanced Configuration

This setup requires understanding of Node.js package management, Tailwind CSS content configuration, and multi-theme build workflows. Basic setup support is not provided—contact support only for bugs, not configuration assistance.

## When to Use Centralized NPM Dependencies

Use centralized NPM dependencies when managing multiple Hyvä themes that share build tooling. This approach is beneficial for projects with multiple theme variations (different brands, storeviews, or seasonal themes) that all require the same build pipeline. Centralizing dependencies ensures consistent Tailwind CSS versions across themes and simplifies dependency updates.

For simpler use cases where themes only need to share CSS variables or utility classes without consolidating build tooling, the [Shared CSS documentation](../working-with-tailwindcss/sharing-common-css-between-themes.html) offers a less complex solution.

## Using System-Wide Global Packages

Some development tools like [BrowserSync](https://browsersync.io/) work well as system-wide global installations, available to all projects on your machine. This is appropriate for CLI tools you use across many projects.

### Installing BrowserSync Globally

Remove BrowserSync from your theme's local dependencies and install it globally:

```
# Remove from theme's package.json
npm rm browser-sync

# Install globally (available system-wide)
npm install -g browser-sync
```

After global installation, the `browser-sync` command is available in any directory without per-theme installation.

Global Installation Considerations

Not all packages are suitable for global installation. Build tools like Tailwind CSS should remain project-local to ensure version consistency across team members and CI/CD environments.

## Project-Root NPM Installation for Multi-Theme Builds

Move all NPM dependencies to the Magento project root, enabling centralized management of Tailwind CSS build tooling for multiple themes. This mirrors the Luma/Frontools workflow where a single `package.json` at the project root contains build scripts for all themes, eliminating duplicate `node_modules` directories and ensuring consistent dependency versions.

### Alternative: Wrapper Scripts for Per-Theme Builds

Instead of centralizing dependencies at the project root, you can create bash or PHP wrapper scripts that execute `npm run build` within each theme's `web/tailwind/` directory. This approach keeps dependencies isolated per-theme while providing a single entry point for builds. Use this alternative if you need a different Tailwind CSS version per theme.

### Setting Up Centralized NPM Dependencies

The following steps move NPM build configuration from individual theme directories to the Magento project root, then configure per-theme build scripts that reference theme-specific source files and Tailwind configuration.

#### Step 1: Copy Build Configuration to Project Root

Copy the following build configuration files from any Hyvä theme's `web/tailwind/` directory to your Magento project root. These files define NPM dependencies and BrowserSync settings:

- `package.json` — NPM dependencies and scripts
- `package-lock.json` — Locked dependency versions
- `browser-sync.config.js` — BrowserSync configuration

For Tailwind v3 themes, also copy `postcss.config.js` (not present in Tailwind v4 projects).

#### Step 2: Install Dependencies at Project Root

Install all NPM dependencies at the Magento project root. This creates a single `node_modules` directory containing Tailwind CSS and all build tooling dependencies:

```
npm install
```

After installation, the `node_modules` directory at the project root contains all build dependencies for all themes.

#### Step 3: Configure Per-Theme Build Scripts

Update the root `package.json` to include separate build and watch scripts for each theme. Each script must specify the correct paths to that theme's source CSS file, output CSS file, and Tailwind configuration file. Use absolute paths from the project root to avoid path resolution issues.

### Example Multi-Theme package.json with Build Scripts

The following examples show a root `package.json` configured for building multiple Hyvä themes. Each configuration defines build and watch scripts for two themes (`default` and `anvil`).

Tailwind v4Tailwind v3

Tailwind v4 handles configuration in CSS via the `@theme` directive:

```
{
  "name": "magento-themes",
  "scripts": {
    "build-default": "npx @tailwindcss/cli -i app/design/frontend/Acme/default/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/default/web/css/styles.css --minify",
    "build-anvil": "npx @tailwindcss/cli -i app/design/frontend/Acme/anvil/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/anvil/web/css/styles.css --minify",
    "watch-default": "npx @tailwindcss/cli -i app/design/frontend/Acme/default/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/default/web/css/styles.css --watch",
    "watch-anvil": "npx @tailwindcss/cli -i app/design/frontend/Acme/anvil/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/anvil/web/css/styles.css --watch",
    "build-all": "npm run build-default && npm run build-anvil"
  }
}
```

Tailwind v4 CLI flags:

- `-i` (input): Source CSS file path containing `@import "tailwindcss"` and `@theme` directives
- `-o` (output): Compiled CSS output file path
- `--minify`: Produces minified CSS for production
- `--watch`: Monitors source files and rebuilds on changes

Tailwind v3 requires the `--postcss` flag and a `-c` flag pointing to the theme's `tailwind.config.js` file:

```
{
  "name": "magento-themes",
  "scripts": {
    "build-default": "npx tailwindcss --postcss -i app/design/frontend/Acme/default/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/default/web/css/styles.css -c app/design/frontend/Acme/default/web/tailwind/tailwind.config.js --minify",
    "build-anvil": "npx tailwindcss --postcss -i app/design/frontend/Acme/anvil/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/anvil/web/css/styles.css -c app/design/frontend/Acme/anvil/web/tailwind/tailwind.config.js --minify",
    "watch-default": "npx tailwindcss --postcss -i app/design/frontend/Acme/default/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/default/web/css/styles.css -c app/design/frontend/Acme/default/web/tailwind/tailwind.config.js --watch",
    "watch-anvil": "npx tailwindcss --postcss -i app/design/frontend/Acme/anvil/web/tailwind/tailwind-source.css -o app/design/frontend/Acme/anvil/web/css/styles.css -c app/design/frontend/Acme/anvil/web/tailwind/tailwind.config.js --watch",
    "build-all": "npm run build-default && npm run build-anvil"
  }
}
```

Tailwind v3 CLI flags:

- `-i` (input): Source CSS file path containing `@tailwind` directives
- `-o` (output): Compiled CSS output file path
- `-c` (config): Theme-specific Tailwind configuration file
- `--postcss`: Enables PostCSS processing (Autoprefixer, etc.)
- `--minify`: Produces minified CSS for production
- `--watch`: Monitors source files and rebuilds on changes

### Running Builds

After setup, run theme builds from the project root:

```
# Build a single theme
npm run build-default

# Watch a theme during development
npm run watch-anvil

# Build all themes
npm run build-all
```
