# Intro to v25 for Developers transitioning from v0

The new v25 base template is full of new features and organized to make advanced customizations easy. If you have customized our previous v0 template extensively in the past, this article will help you understand the differences and get started with v25.

***

## Requirements

These instructions are meant for developers who want to make advanced customizations in v25 and are already familiar with our previous template. If you are not familiar with coding, check our basic knobs \[link] section for out-of-the-box customizations.

> 🚧 SM Tracking Code
>
> If you use the Advanced Editor to customize your Subscription Manager, be careful not to remove or modify elements that Ordergroove's tracking library depends on. These changes can disrupt analytics and customer behavior tracking. For guidance, see [Customize your Subscription Manager](https://developer.ordergroove.com/docs/sm-template-customization-tracking) for more information.

### How to tell what version you're on

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/7ad2f64944811b4cba2c676ffa8d79d69787840575aa68288cd385f721cf4124-image4.png" />

***

## Identifying your customizations

If you have been developing on v0, you probably have made quite a few customizations to your v0 template that you want to transfer over. For every file in the Subscription Manager Theme Designer, there is a small button in the header bar of the editor that can be used to check the diff between that file and the base template you developed from.

<Image align="center" src="https://files.readme.io/7a1bd951f1643870d6377151fdabddfe6689d5c3443252978f6ff5e59f8ce503-image3.png" />

If the file hasn’t been modified from the original version, the button will be disabled. If you have made changes in that file, you can click the button to see exactly which change you made.

<Image align="center" src="https://files.readme.io/78e6a461bc13428553b5f0edb82ee38a732edc5c3c8096d927a5f34ca799c90d-image2.png" />

The base template code between v0 and v25 is different, but you can copy out your code to transfer it into its new location in v25.

The rest of this article will go through some basic differences between the two templates and suggestions for mapping customizations between them.

***

## Differences between the templates

### Template/Folder organization

A key feature for developers on v25 is our improved organization and folder structure in the views folder. Different files of the template are split into folders based on their functionality. The following diagram shows how different areas of the SM reflect the folder structure:

<Image align="center" src="https://files.readme.io/fbcc3786fa6bb9d177cb5045da28d46bff420c650c4fb8fcf7870a7cbcd50d31-image1.png" />

Some files, like `order-processing.liquid` and `upcoming-orders.liquid` have similar purposes as in v0, as entry-points to their sections, but we made an effort to cut down on file size and split the liquid files into smaller pieces to help you find the exact place you want to edit.

For more information about the organization of the views folder, check out our [guide to v25 template](https://developer.ordergroove.com/docs/tour-of-subscription-manager-v25).

### Script.js and Components

The `script.js` file is still where you add custom functionality with JavaScript. The beginning of the file, marked with the “Subscription Manager loading” header, contains some key functions for the Subscription Manager to load. *Do not edit these!*

Then, the “Custom Elements” section introduces key components we use throughout the Subscription Manager to encapsulate interaction-heavy functionality. The end of the section defines them as [custom HTML elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements). In general, you are unlikely to need to modify this section.

The final section is “Utilities” which has utility functions we use elsewhere in the scripts file and in the SM. This is where you should add any custom javascript functions.

### CSS Organization

In the v0 template, `globals.less` contained many of the variables used in other less files. In v25, this role is taken by `design-tokens.less` which contains all of the variables used across the other files and components.

Style changes from the basic editor are still reflected in `variables.less` and will override anything set in `design-tokens.less`.

`default-theme.less` now holds more extensive styles which are expected to be used in multiple components across the Subscription Manager.

The components folder contains the styles for components used across the SM, both HTML elements and custom components defined in the scripts file. The other folders contain custom styles for sections across the SM, corresponding to the views files in the same folder structure.

To transfer over your custom styles to the new Subscription Manager, we recommend thinking about the following questions:

1. Is the style a color, radius, font, or size change? Check `design-tokens.less` to see if we already have a corresponding variable.
2. Is the style for a specific section or element in the SM? If so, find this section in the `views` folder, and then look in the corresponding `less` file.
3. Is the style for a component used across the SM, like buttons or dialogs? Check the `components` and `ui-elements` folders.
4. Is the style meant to be globally applied across the SM? Check `default-theme.less`

Another development tip: we heard your feedback that you weren’t sure which classes were safe to remove from the `liquid` files. In v25, classes are only used for styling and not for functionality. With the exception of `variables.less`, which is controlled by our basic editor, you can add and remove whichever classes you like to develop your custom Subscription Manager.

### Locale customizations

The new base template has new locale strings in the `locales` folder, as well as many of the same keys. If you made customizations to the text on your Subscription Manager, we recommend searching these files for the key, and if it isn’t present, searching by text you expect or checking what key is being used in the relevant file of the template. The locales files are organized in alphabetical order by key.

As with the v0 template, you are always free to add your own locale keys.

### Controls

Controls are in `theme-settings.json` and serve as a way to surface functionality options to the basic editor. You shouldn’t need to edit these to make your customizations, but you may find them being used in the template (for example, `{% if ‘show_upgrade_to_subscription' | setting %}`).

When possible, we encourage you to use these variables to customize your subscription manager. This can make it easier to maintain your customizations when upgrading to newer versions in the future. Removing these variables and their hooks will remove the capability for users of the basic editor to easily make customizations, but your subscription manager will still function without them.

***

## Additional Reading

We hope this introduction to v25 was helpful. For more information on the new template and development tips, check out [Tour of Subscription Manager v25](https://developer.ordergroove.com/docs/tour-of-subscription-manager-v25).