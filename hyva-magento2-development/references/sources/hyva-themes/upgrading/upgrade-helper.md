<!-- source: https://docs.hyva.io/hyva-themes/upgrading/upgrade-helper.html -->

# Hyvä Upgrade Helper Tools

The `hyva-themes/upgrade-helper-tools` composer package provides a set of command-line scripts to help automate parts of the Hyvä Themes upgrade process.

Use in Development Only

These scripts are intended for development use only and should **never** be run on a production environment. Always review the changes made by a script before deploying them.

The scripts are not applicable to all upgrades. Always check the official upgrade guide for a specific version to see if using a script is recommended.

## Installation

The easiest way to use these tools is to add them to your project as a dev-dependency.

```
composer require --dev hyva-themes/upgrade-helper-tools:dev-main
```

Alternatively, you can install the package globally:

```
composer global require --dev hyva-themes/upgrade-helper-tools:dev-main
```

For Manual Use (Gitlab Access is needed!)

If you prefer not to use Composer, you can clone the [repository](https://github.com/hyva-themes/upgrade-helper-tools) or copy a single script to your local machine.

## Migrating from Tailwind CSS v3 to v4

This set of scripts helps automate migrating a Hyvä theme from Tailwind CSS v3 to v4 (for Hyvä 1.4.0 and newer).
The recommended method is to use the main wrapper script, which runs the helpers in the correct order.

**Usage:**

```
./vendor/bin/update-to-tailwind-v4.js <path-to-your-theme>
```

The wrapper script executes the following helpers, which can also be run individually.

### 1. `convert-to-tailwind-v4.js`

This script replaces your theme's Tailwind styles with the new v4 version from the Hyvä Default Theme.

**What it does:**
1. **Backs up** your entire `web/tailwind` directory to `web/tailwind.backup.DATE`.
2. **Copies** the new Tailwind v4 styles from `vendor/hyva-themes/magento2-default-theme/web/tailwind` into your theme's `web/tailwind` directory.

**Prerequisites:**
\* Your `hyva-themes/magento2-default-theme` or `hyva-themes/magento2-default-theme-csp` package must be updated to a version that uses Tailwind v4 (e.g., 1.4.0 or newer).

**Usage:**

```
./vendor/bin/convert-to-tailwind-v4.js <path-to-your-theme>
```

After running the script, you will need to manually migrate any custom styles from your backup into the new Tailwind structure.

### 2. `convert-tailwind-config.js`

This script converts your Tailwind v3 `tailwind.config.js` settings into the new CSS variable format used by Tailwind v4.

**What it does:**
\* Reads your existing `tailwind.config.js`.
\* Generates a new file at `web/tailwind/generated/tailwind.config.css` containing your theme values as CSS variables.

**Example:**

A `tailwind.config.js` like this:

```
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          lighter: colors.blue['300'],
          "DEFAULT": colors.blue['800'],
          darker: colors.blue['900']
        },
      }
    }
  }
};
```

Will be converted into:

```
/* web/tailwind/generated/tailwind.config.css */
@theme {
  --colors-primary-lighter: #93c5fd;
  --colors-primary-default: #1e40af;
  --colors-primary-darker: #1e3a8a;
}
```

**Usage:**

```
./vendor/bin/convert-tailwind-config.js <path-to-your-tailwind.config.js> <path-to-your-theme/web/tailwind>
```

After generating `tailwind.config.css`, integrate your old theme values by importing the file into `web/tailwind/tailwind-source.css`:

```
/* tailwind-source.css */
@import "./generated/hyva-tokens.css";
@import "./generated/tailwind.config.css"; /* <= Add this line */
```

### 3. `find-deprecated-classes.js`

This script scans your theme files for deprecated Tailwind CSS classes and generates a report of where they are used.

**What it does:**
\* Scans `.phtml` and `.xml` files in a given directory.
\* Checks for a predefined list of deprecated class patterns.
\* Generates a `tailwind-deprecated-report.md` file listing the file, line number, deprecated class, and a recommended fix.

**Default Deprecated Patterns:**
The script checks for patterns based on the [Tailwind CSS v4 upgrade guide](https://tailwindcss.com/docs/upgrade-guide#removed-deprecated-utilities):
\* Opacity modifiers (`bg-opacity-*`, `text-opacity-*`, etc.)
\* `flex-shrink-*` & `flex-grow-*`
\* `overflow-ellipsis`
\* `decoration-slice` & `decoration-clone`

**Usage:**

```
./vendor/bin/find-deprecated-classes.js <directory-to-scan>
```

**Options:**
\* `--console`: Prints the report to the console instead of creating a file.
\* `--config <path-to-config.json>`: Use a custom JSON file to define deprecated class patterns.

#### Automated Fixing with AI

After generating the `tailwind-deprecated-report.md`, you can use an AI assistant to automate the fixing process.
Provide the following prompt to a capable AI model to guide it through the report and fix the deprecated classes.

Instructions for the AI

```
Hello! You are an expert front-end developer tasked with refactoring a Magento 2 project to remove deprecated Tailwind CSS classes.
Your guide is the `tailwind-deprecated-report.md` file.

Your goal is to intelligently apply the fixes by using the information in the report and analyzing the surrounding code.

**Your step-by-step process:**

1.  **Analyze the Deprecation Report:**
    Begin by thoroughly reading the `tailwind-deprecated-report.md` file.
    You will notice it contains three key pieces of information for each issue:
    *   The **file path, line, and column** of the deprecated class.
    *   The specific **deprecated class** (e.g., `bg-opacity-25`).
    *   A **"Suggestions"** section at the end. This is the most important part, as it tells you the new, correct syntax.
        For example: `bg-opacity-* is deprecated. Use the new slash syntax for opacity, e.g. bg-blue-500/50`.

2.  **Process Each Deprecation:**
    Iterate through each entry in the report and perform the following actions for each one:
    a.  **Read the Source File:** Open the file specified in the report.
    b.  **Locate the Class:** Go to the line number indicated.
    c.  **Find the Full Context:** The report points you to the line, but you need to find the full context.
        The deprecated class will be inside a `class="..."` attribute on an HTML element.
        This class attribute may span multiple lines.
        You must read the full list of classes applied to that element.
    d.  **Apply the Suggested Fix Intelligently:**
        *   **If the suggestion is for opacity (e.g., `bg-opacity-*`)**:
            The suggestion (e.g., "Use... `bg-blue-500/50`") implies you need to find a corresponding color class on the same element.
            *   Search the element's class list for a base class (e.g., `bg-black`, `bg-red-500`).
            *   Combine the base class with the opacity value from the deprecated class.
                For example, if you find `bg-black` and the deprecated class is `bg-opacity-25`, the new class is `bg-black/25`.
            *   Replace *both* `bg-black` and `bg-opacity-25` with the single `bg-black/25`.
        *   **If the suggestion is for a renamed class (e.g., `flex-grow`)**: The fix is a direct replacement.
            *   For example, the suggestion says, "Use `grow` or `grow-0` instead." Replace `flex-grow` with `grow`.
        *   **Handle Edge Cases from Suggestions**:
            *   For `ring-opacity-*`, the suggestion mentions `ring-black/50`.
                If you find `ring-opacity-50` but no other `ring-` color on the element,
                you should use `ring-black/50` as the replacement.

3.  **Update the File:**
    After constructing the correct replacement,
    modify the file content by replacing the old class or classes with the new one.
    Be careful to preserve all other classes and the surrounding HTML structure.

4.  **Finalize:**
    Once you have processed all the entries in the report for a file, save your changes and move to the next file.
```

This AI prompt is designed for HTML classes only. A different prompt is required for classes within XML files or code comments.

## Hyvä CMS 0.6.0 Children Field Migration

This script migrates the `children` field in `components.json` files for Hyvä CMS.

**Usage:**

```
./bin/hyva-cms-0.6.0-migrate-children-field.js [path/to/components.json] ...
```

Pass the paths to one or more `components.json` files as arguments.

## Hyvä 1.3.11 CSP and Hyvä Checkout 1.3.0

This PHP script helps with CSP (Content Security Policy) adjustments for Alpine v3.

**Usage:**

```
./bin/hyva-csp-helper [...DIRECTORY] | tee CSP-migration.md
```

Pass one or more directories to scan as arguments. The script outputs a Markdown report, which you can pipe to a file for review.

## Hyvä 1.2.0 Tailwind and Alpine Migration

This script runs helpers to migrate from Tailwind CSS v2 to v3 and from Alpine v2 to v3.

**Usage:**

```
./bin/hyva-1.2.0-tailwind-and-alpine.js <directory-to-scan>
```

Pass the directories to process recursively as arguments. Check each individual script for usage instructions by running it with the `--help` flag.
