<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/capistrano-deployment.html -->

# Capistrano Deployment

Deploying a Hyvä theme with Capistrano requires configuring custom Rake tasks to generate the Tailwind CSS production stylesheet during deployment. `capistrano-magento2` is a Ruby-based deployment tool commonly used for Magento projects that provides hooks into the deployment lifecycle.

This guide covers creating a custom Rake task for Tailwind compilation, configuring theme paths, and ensuring Node.js is available on your deployment servers.

## Prerequisites

- [capistrano-magento2](https://github.com/davidalger/capistrano-magento2) configured for your project
- Node.js and npm installed on deployment servers (see [Server Requirements](#server-requirements))
- Your Hyvä theme's `web/tailwind` directory containing `package.json` and Tailwind configuration

## Tailwind Stylesheet Generation

When the production Tailwind CSS stylesheet is not committed to version control, Capistrano must build it during deployment before the static content deployment phase runs.

### Step 1: Create the Tailwind Rake Task

Create a file named `tailwind.rake` in your project's `lib/capistrano/tasks` directory. This custom Rake task iterates through configured theme paths, installs npm dependencies, and runs the Tailwind build command:

lib/capistrano/tasks/tailwind.rake

```
namespace :deploy do
  desc 'Build tailwindCSS'
  task :hyva_tailwind_build do
    on roles(:all) do
      # Iterate through each configured Hyvä theme path
      fetch(:hyva_tailwind_paths, []).each do |tailwind_path|
        within release_path + tailwind_path do
          # Install exact versions from package-lock.json (reproducible builds)
          execute :npm, :ci, "--ignore-scripts"
          # Generate minified production stylesheet at ../css/styles.css
          execute :npm, :run, "build"
        end
      end
    end
  end
end
```

### Step 2: Configure Theme Paths

In your `config/deploy.rb` file, define the `hyva_tailwind_paths` variable with the paths to your Hyvä theme's Tailwind directories. Each path should point to the `web/tailwind` directory within your theme, where `package.json` and `tailwind.config.js` are located:

config/deploy.rb - Single theme

```
# Path relative to Magento root where npm commands will run
set :hyva_tailwind_paths, [
  'app/design/frontend/Vendor/ThemeName/web/tailwind'
]
```

For multiple Hyvä themes, add each theme's Tailwind path to the array:

config/deploy.rb - Multiple themes

```
set :hyva_tailwind_paths, [
  'app/design/frontend/Vendor/ThemeOne/web/tailwind',
  'app/design/frontend/Vendor/ThemeTwo/web/tailwind'
]
```

### Step 3: Register the Task in the Deployment Lifecycle

In the same `config/deploy.rb` file, register the Tailwind build task to run before Magento's static content deployment. This ensures the generated `styles.css` exists before Magento copies theme assets to `pub/static`:

config/deploy.rb - Task registration

```
# Run Tailwind build before static content is deployed
before 'magento:setup:static-content:deploy', 'deploy:hyva_tailwind_build'
```

## Verifying the Deployment

After deployment completes, verify that the Tailwind stylesheet was generated correctly:

1. **Check the generated file exists**: The build should create `web/css/styles.css` in each configured theme directory
2. **Check the deployed file**: After static content deployment, verify the stylesheet exists at `pub/static/frontend/Vendor/ThemeName/{locale}/css/styles.css`
3. **Check the file size**: A successful production build typically produces a minified file between 30KB and 150KB depending on theme customizations

If the deployment fails during the Tailwind build step, check that Node.js and npm are installed and accessible on the deployment server (see [Server Requirements](#server-requirements)).

## Server Requirements

The Tailwind build process requires Node.js and npm to be installed on your deployment servers. The Rake task uses `npm ci --ignore-scripts` to install dependencies and `npm run build` to generate the production stylesheet.

## Optional: Managing Node.js Versions with NVM

If your deployment servers use NVM (Node Version Manager) to manage multiple Node.js versions, you can integrate Capistrano with NVM using the [capistrano-nvm](https://github.com/koenpunt/capistrano-nvm) gem. This allows you to specify which Node.js version to use during deployment.

### Step 1: Add the NVM Gem

Add the capistrano-nvm gem to your `Gemfile`:

```
gem 'capistrano-nvm', :git => 'https://github.com/koenpunt/capistrano-nvm.git', require: false
```

### Step 2: Require the Module

Add the NVM module to your `Capfile`:

```
require 'capistrano/nvm'
```

### Step 3: Configure NVM Settings

Add NVM configuration to your `config/deploy.rb` file. Set `nvm_type` to `:user` for per-user NVM installations or `:system` for system-wide installations:

```
set :nvm_type, :user
set :nvm_node, 'v20.19.5'
```
