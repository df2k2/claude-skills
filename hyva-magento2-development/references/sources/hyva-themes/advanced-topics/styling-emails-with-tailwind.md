<!-- source: https://docs.hyva.io/hyva-themes/advanced-topics/styling-emails-with-tailwind.html -->

# Generating Email Styles with Tailwind CSS

Tailwind 4 and Email Styles

There is currently no good solution for generating email-compatible styles with Tailwind 4. The CSS output Tailwind 4 produces is too modern for email clients and requires a parser to convert it back to older, widely-supported styles.

The recommended approach is to use Tailwind v3 alongside v4 in your Hyvä theme for emails, or to add a post-build step that downgrades the CSS to older standards - for example, using a PostCSS plugin.

A community solution exists that resolves most CSS compatibility issues in Tailwind 4, though it does not address the CSS variables limitation. You can find it at [maizzle/tailwindcss](https://github.com/maizzle/tailwindcss).

Hyvä is also exploring options and will update this page when a reliable solution is available.

Magento email templates use LESS for styling, but Hyvä theme developers can use **Tailwind CSS utility classes** as the source for generating LESS-compatible email stylesheets. This approach lets you write email styles using familiar Tailwind `@apply` directives, then compile them to plain CSS that Magento's email system can process.

The technique uses **PostCSS** to compile Tailwind classes into standard CSS properties. PostCSS outputs a LESS file that Magento's email rendering system can consume directly.

Community Contribution

This approach was developed and shared by Lucas van Staden from ProxiBlue.

## Prerequisites for Tailwind Email Styling

Before starting, complete the email styling preparation steps in the [Styling Emails](../building-your-theme/styling-emails.html#preparing-custom-email-styling) documentation. Those steps copy the required LESS files into your Hyvä theme.

All file paths in this guide are relative to your theme folder (`app/design/frontend/Vendor/ThemeName`).

## Tailwind Email Configuration Steps

Tailwind v3 Only

These instructions are for Hyvä 1.3.x using Tailwind v3.
For Hyvä 1.4 and newer builds, the PostCSS and Tailwind configuration instructions will need to be adjusted.

### Create the Emails Directory in Your Hyvä Theme

Create a dedicated directory for email-related Tailwind configuration inside your theme's `web/tailwind` folder:

```
mkdir web/tailwind/emails
```

### Create the PostCSS Configuration for Email Compilation

Create the file `web/tailwind/emails/postcss.config.js` with the following content. This PostCSS configuration references a separate Tailwind config file specifically for email compilation:

web/tailwind/emails/postcss.config.js

```
module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss/nesting'),
    // Point to the email-specific Tailwind config
    require('tailwindcss')({ config: './emails/tailwind.email.config.js' }),
  ]
}
```

### Create the Email-Specific Tailwind Configuration

Create the file `web/tailwind/emails/tailwind.email.config.js` to extend your theme's existing Tailwind configuration. This email-specific Tailwind config disables RGBA color functions because Magento's LESS processor cannot parse RGBA syntax. All colors are output as HEX values instead:

web/tailwind/emails/tailwind.email.config.js

```
const defaultConfig = require('../tailwind.config.js');

module.exports = {
  ...defaultConfig,
  // Disable opacity plugins so colors compile to HEX, not RGBA
  corePlugins: {
    backdropOpacity: false,
    backgroundOpacity: false,
    borderOpacity: false,
    divideOpacity: false,
    ringOpacity: false,
    textOpacity: false
  }
};
```

### Install PostCSS CLI as a Development Dependency

Install the PostCSS command-line interface, which is required to run the email build script:

```
npm install --save-dev postcss-cli
```

### Add the Email Build Script to package.json

Add the following `build-email` script to your theme's `web/tailwind/package.json`:

```
"build-email": "npx postcss --config ./emails theme/email.css -o ../css/source/_theme.less"
```

This script reads the source CSS from `theme/email.css` and outputs compiled LESS to `web/css/source/_theme.less`. The output file overwrites the base `_theme.less` you copied during the email styling preparation step.

Exclude the Generated LESS File from Version Control

Add `web/css/source/_theme.less` to your `.gitignore` file. This file is regenerated each time `npm run build-email` executes, so it should not be committed.

## Writing and Building Tailwind Email Styles

Create the source file `web/tailwind/theme/email.css` and use Tailwind utility classes with the `@apply` directive to define your email styles:

web/tailwind/theme/email.css

```
.footer {
   @apply border-t-2 border-primary;
   .span {
       @apply bg-primary;
   }
}
```

Run the build command from the `web/tailwind` directory to generate the LESS output:

```
npm run build-email
```

The generated `web/css/source/_theme.less` file contains compiled CSS with HEX color values instead of Tailwind's default RGBA output:

web/css/source/\_theme.less (generated output)

```
.footer {
  border-top-width: 2px;
  border-color: #DEDEDE;
}

.footer .span {
  background-color: #001F43;
}
```

To verify your email styling, use the [Yireo Email Tester 2](https://github.com/yireo/Yireo_EmailTester2) extension to preview transactional emails in your Magento store.

## Known Limitations and Workarounds for Tailwind Email Styles

### Using Custom Background Images with LESS Variables

When using LESS variables in background image URLs within Tailwind email styles, wrap the URL path in single quotes. This ensures proper LESS variable interpolation during compilation:

```
background-image: url('@{baseDir}css/background/illustration_1.svg');
```

### Border Utility Classes in Email Styles

Some Tailwind border utilities like `border-b` and `border-t` may not compile correctly for email use. As a workaround, combine Tailwind `@apply` utilities with explicit border declarations:

```
.main-links a {
    @apply text-primary-headings border-bom_colors-charcoal-dark;
    /* Explicit border declaration as fallback for email clients */
    border-bottom: 1px solid;
}
```

## Related Topics

- [Styling Emails in Hyvä Themes](../building-your-theme/styling-emails.html) - Base email styling setup and LESS file preparation
