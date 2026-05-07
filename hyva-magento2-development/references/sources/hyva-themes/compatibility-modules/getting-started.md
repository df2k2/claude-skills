<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/getting-started.html -->

# Getting Started with Compatibility Modules

This documentation gives you everything you need to know to get started with making Magento Modules compatible with Hyvä. You will also learn how to contribute code to the compatibility module pool.

## Prerequisites

These documents assume you are familiar with the following topics:

- Magento 2 frontend development
- PHP
- JavaScript
- git
- Hyvä Theme installation and setup
- Alpine.js basics
- Tailwind CSS basics

Please also read through the pages nested within our general [Hyvä Theme development documentation](../building-your-theme/index.html) - all of them apply to creating compatibility modules, too.

## Useful Tools & Tips

The following tips will enable you to get prepared so you can work more efficiently.

### Set up a Luma reference store view

It helps to have a second store view running with a Magento Luma theme next to the store view using Hyvä. This allows checking how exactly some aspect of a module works in Luma while making it work in Hyvä.

### Install IDE Plugins and Extensions

We recommend installing helpful utilities like these:

- **Alpine.js devtools** extension for Chrome or Firefox
- **Alpine.js Support** and **Tailwind CSS** PHPStorm plugins
- **Alpine.js** and **Tailwind CSS IntelliSense** VSCode extensions (if you use VS code)

**Commercial Tools**

- [**Windy**](https://usewindy.com/) extension for Chrome and Firefox
- [**DevTools for Tailwind**](https://devtoolsfortailwind.com/) extension for Chrome

## Contribution Process Overview

There are several areas you can contribute to:

- Compatibility Modules (commercial Hyvä license required for access on [gitlab.hyva.io](http://gitlab.hyva.io))
- Hyvä React Checkout (open-source license, free on [github.com](https://github.com/hyva-themes/magento2-react-checkout))
- Hyvä Admin (open-source license, free on [github.com](https://github.com/hyva-themes/magento2-hyva-admin))

This text focuses on contributing to Compatibility Modules. The open-source projects follow the usual contribution process on GitHub and are not covered in this document. The Hyvä core contribution process is described in the [Hyvä contribution guidelines](../faqs/hyva-contribution-guideline.html).

Please note, in the following, **GitLab** refers to [gitlab.hyva.io](http://gitlab.hyva.io).

**If you feel lost during any of the following steps, please ask for help in Slack. We are happy to help you!**

### Step-by-step contribution process:

1. If you want to contribute a new Compatibility Module, let a Hyvä team member know, so they can create a repository with a skeleton compatibility module in the **Hyvä Compat** group on GitLab for you. You will receive a link to the new repository when it is ready. You will have write privileges to this new repository.
2. If there is no ticket for the original module in the [Compatibility Module Tracker](https://gitlab.hyva.io/hyva-public/module-tracker/-/boards), please create a new issue using the “Module Request” issue template, and let the Hyvä team know, so they can add the “In Progress” label.
3. Now you will want to clone the repository to your development environment.
4. Create a git branch in your working copy to contain the changes.
5. Now, finally, you get to work on the code!
6. Commit your changes. Go to step 5 and repeat until done.
7. Push the changes to a new branch on GitLab and create a merge request.
8. Since you are assigned as the maintainer, feel free to merge your feature branch directly into `main` when it is ready. If you would like to have someone look over the code, please request a code review from within your team, or from the Hyvä team (on Slack), but that is not required for compatibility modules.
9. When the compatibility module is done, please add a 1.0.0 tag so it can be installed via [packagist.com](http://packagist.com). Please also notify the Hyvä team so they can change the label for the module in the [Compat Module Tracker](https://gitlab.hyva.io/hyva-public/module-tracker/-/boards) to “Published”.

## Cloning the Repository

There are many possible ways to work on Magento modules within a development instance. Usually it boils down to one of the following three approaches:

1. Clone the module into `app/code`
2. Add the repository as a composer git source and install the module into vendor with `composer require --prefer-source`
3. Clone the repository to a local directory (e.g., `local-src/`), add that folder as a path repository to the Magento `composer.json` file, and install the module with composer.

Each of the approaches works fine and has its benefits and drawbacks. We recommend the third option.

### Setting up a local path composer repository

The following steps describe how to set up a local path composer repository in your development environment.

1. First, create the directory you want to store your local code in. A common practice is a folder called `local-src/` within the Magento base directory.

   ```
   mkdir local-src
   ```
2. Clone the Compatibility Module repository into the directory.

   ```
   cd local-src
   git clone git@gitlab.hyva.io:hyva-themes/hyva-compat/magento2-your-module.git
   cd ..
   ```
3. Add the `local-src` subdirectories as a composer path repository.

   ```
   composer config repositories.local-src path 'local-src/*'
   ```

   Then open your root `composer.json` file and move the `local-src` repository to the top of the repository list, so it takes precedence over any remote repositories:

   ```
   "repositories": {
       "local-src": {
           "type": "path",
           "url": "local-src/*"
       },
       "private-packagist": {
           "type": "composer",
           "url": "https://hyva-themes.repo.packagist.com/CUSTOMERNAME/"
       },
       "0": {
           "type": "composer",
           "url": "https://repo.magento.com/"
       }
   }
   ```
4. Install the module with composer. Composer will create a symlink from the `local-src/magento2-your-module` folder to `vendor/hyva-themes/magento2-your-module`.

   ```
   composer require hyva-themes/magento2-your-module
   ```

   If you get an error that the package does not match the configured minimum-stability, tell composer what branch to install by adding the `:dev-[BRANCH]` suffix, e.g. `composer require hyva-themes/magento2-your-module:dev-main`.
5. Exclude one of the directories from your IDE index to avoid confusion. For PHPStorm, it is usually easiest to right-click on the `local-src` folder and select **Mark Directory as > Excluded**. Then remove the exclusion of the `vendor/hyva-themes/magento2-your-module` in the **PHPStorm Settings** under **Directories**.

### Troubleshooting Composer Path Repositories

If you chose the `path` composer repository approach, you might get an error that the package exists in multiple repositories with different priorities. This can occur in virtualized development environments (like Warden) when the `.git` directory is not synchronized into the container, preventing composer from determining the package version.

There are a number of possible solutions:

- You can clone the repository *inside* the container instead of on the host system.
- You can add the version for a given package to the `local-src` repository configuration in the root `composer.json`:

  ```
  {
      "type": "path",
      "url": "local-src/*",
      "options": {
          "versions": {
              "hyva-themes/your-module": "dev-main"
          }
      }
  }
  ```
- You can add `"version": "dev-main"` to the package's `composer.json` file. This is **not recommended** as it can lead to inconsistencies.

## Making Existing Modules Hyvä-Compatible

Making an existing module compatible with Hyvä is almost the same as creating a full compatibility module. The main difference is that you need to manually register your module for inclusion in the `hyva-themes.json` file. This process is explained in detail in the [Registering a module for inclusion in `hyva-themes.json`](technical-deep-dive.html#registering-a-module-for-inclusion-in-hyva-themesjson) section. This allows your theme to scan for and import the necessary CSS from your module.

For the rest, you follow most of the same steps. However, you now need to ensure that the `phtml`, CSS, and JavaScript code is compatible with both Luma and Hyvä themes.

For Hyvä-specific `phtml` and JavaScript, you can load logic by using layout XML files with the `hyva_` prefix. This ensures that a Luma theme ignores these layouts and they are only used for Hyvä, as explained in [The `hyva_` Layout Handles](../writing-code/layout-and-templates/the-hyva_-layout-handles.html) documentation.
