<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/index.html -->

# 6. Compatibility Modules

Modules based on the Magento luma or blank themes require a *Compatibility Module* to work with Hyvä. A compatibility module re-implements the parts of a module that don’t work out of the box in a Hyvä store front.

The amount of work to create a compatibility module depends on the module in question, but for the most part it’s rather straight forward.

A list of compatibility modules that already are available and the state they are in can be found at the [Compatibility Module Tracker](https://gitlab.hyva.io/hyva-public/module-tracker/-/boards).

## Compat Module Development Videos

We have recorded the process of creating a compatibility module, starting with the setup of a development environment and all following steps.
If you prefer videos to written content, you might enjoy this tutorial series.

## Making Existing Modules Hyvä-Compatible

If you are not creating a new compatibility module but want to make an existing module Hyvä-compatible, you need to register it to be included in the `hyva-themes.json` file. This process is explained in the [Registering a module for inclusion in `hyva-themes.json`](technical-deep-dive.html#registering-a-module-for-inclusion-in-hyva-themesjson) section.

For a more detailed explanation of how to make existing modules compatible, please see the [Making Existing Modules Hyvä-Compatible](getting-started.html#making-existing-modules-hyva-compatible) section in our Getting Started documentation.
