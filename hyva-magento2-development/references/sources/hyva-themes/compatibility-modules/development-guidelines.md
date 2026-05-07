<!-- source: https://docs.hyva.io/hyva-themes/compatibility-modules/development-guidelines.html -->

# Development Guidelines

Note

This guide is for creating **new** Compatibility Modules from scratch.

For making existing modules Hyvä-compatible

For a detailed explanation on how to make an existing module Hyvä-compatible without creating a new compatibility module, please see the [Making Existing Modules Hyvä-Compatible](getting-started.html#making-existing-modules-hyva-compatible) section in our Getting Started documentation.

## Where to Begin Coding

This page describes the process of creating a Compatibility Module. It assumes you already have the new, empty, compatibility module installed in your development instance.

The process of creating a compatibility module is slightly different every time, depending on the original module. We are trying to provide an overview here for you to adjust as needed.

1. Choose a page that includes some functionality offered by the module.
2. Open the page in a private browser window and switch to a Luma theme reference store view.
3. Open the same page in your browser for the Hyvä theme store view.
4. Open the Browser Console in the Hyvä store view and look for any errors (e.g. `require is not defined`).
5. Locate the template containing the feature that is causing the error in the original module.
6. Copy the template into the compatibility module to the same location in `view/frontend/templates`.
7. Open the copy in the IDE.
8. Inline any JavaScript code and convert it to vanilla JavaScript and Alpine.js. Then style the component using Tailwind CSS. This whole process is described in more detail in the "[From Luma to Hyvä](from-luma-to-hyva/migrating-js-and-templates.html#from-data-mage-init-and-require-to-inline-scripts)" section.
9. Once the template renders without any errors and the feature works, take a moment to clean up the code, and then move on to the next template.

Tip

If there are several templates on a page causing errors, copy all of them to the compatibility module and short-circuit them with an early `<?php return; ?>` so it is possible to get one after the other working.

Important

Remember to try and take one small step after the other, instead of trying to tackle all at once.

## Naming Conventions

### Magento Module

The module name consists of the `Hyva` namespace and the concatenation of the original module namespace and module name.

- **Original**: `Smile_ElasticSuite`
- **Compat Module**: `Hyva_SmileElasticSuite`

### Composer Package

The composer vendor name is `hyva-themes`. The full package name is `hyva-themes/magento2-<original-module>`.

- **Original**: `smile/magento-elasticsuite`
- **Compat Module**: `hyva-themes/magento2-smile-elasticsuite`

Other Vendor Names

The naming convention described here applies to packages hosted on gitlab.hyva.io with the vendor name `hyva-themes`. For compatibility modules hosted in external repositories, for example on GitHub, another vendor name is used. In that case `hyva` should be included in the package name instead. For example, for an original module `my-org/magento-integration`, the Hyvä compatibility module should be something like `my-org/magento-hyva-integration`.

### Folder Structure

Hyvä modules and compatibility modules use the following folder structure and minimal set of files. The basic folder structure including the `LICENSE.md` and `README.md` files are already present in new Compatibility Module repositories.

```
magento2-example-module/
├── LICENSE.md
├── README.md
├── composer.json
└── src
    ├── etc
    │   ├── frontend
    │   │   └── di.xml
    │   └── module.xml
    └── registration.php
```

Any tests go into a `tests/` directory on the same level as `src/`. The `LICENSE.md` file is a copy of the Hyvä Themes Software User License and must not be changed. The `README.md` file contains basic information about the original module. You can add any additional information that might be required for the Compatibility Module to work.

## Coding Standards

Hyvä strives to follow the Magento 2 coding standard. All contributions and compatibility modules should do the same. This includes using tools like PHP CodeSniffer (`phpcs`) and PHP Mess Detector (`phpmd`).

If a given rule doesn't make sense in a specific circumstance, it is okay to disable it using the appropriate annotation (e.g., `// phpcs:disable Generic.Files.LineLength.TooLong`). When disabling a rule, always be as specific as possible.

### Template PHPDoc Variable Annotations

All values that are assigned to a template block should be annotated at the top of the template file, if they are used. We believe importing class names makes the code easier to understand.

```
<?php

declare(strict_types=1);

use Hyva\Theme\Model\ViewModelRegistry;
use Magento\Framework\Escaper;
use Magento\Framework\View\Element\Template;

/** @var Template $block */
/** @var Escaper $escaper */
/** @var ViewModelRegistry $viewModels */
```

## Copyright Annotations

Sometimes the question comes up, what copyright notice to use when creating a compatibility module?

- **Similar code:** When a file is very similar to one found in Hyvä core, retain the Hyvä copyright notice.

  ```
  /**
   * Hyvä Themes - https://hyva.io
   * Copyright © Hyvä Themes 2020-present. All rights reserved.
   * See https://hyva.io/license
   */
  ```
- **Unique code:** If the file content is created from scratch, feel free to use either the Hyvä copyright notice, or your own one. If you use your own, please add a line that allows the code to be used with Hyvä installations.

  ```
  /**
   * Example Company - https://example.io
   * Copyright © Example Company 2020-present. All rights reserved.
   * This code may be used in conjunction with the module example-company/original-module
   * See https://example.io/compat-module-license
   */
  ```
