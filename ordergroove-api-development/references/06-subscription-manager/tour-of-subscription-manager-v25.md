# Tour of Subscription Manager v25

This article provides an overview of the design of v25 of the Subscription Manager for advanced users planning to make code customizations. It includes folder and file organization and tips and tricks for navigation. If you’re new to developing on Subscription Manager, this article will tell you everything you need to find your way around the base template with confidence.

***

## Requirements

This article is intended for developers on Subscription Manager 2.0; shown as v25 templates and beyond. You should already have a thorough understanding of the fundamentals of HTML, CSS, and Javascript.

### How to tell what version you’re on

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/0f5a3126136d00f63aed46b389aba7f3ac6835182c6447149a5bdd11d941341e-image2.png" />

***

## Advanced Editor Layout

The Subscription Manager has 5 folders in the advanced editor. This guide will go through each folder and how its contents fit into the overall Subscription Manager experience.

> 🚧 SM Tracking Code
>
> If you use the Advanced Editor to customize your Subscription Manager, be careful not to remove or modify elements that Ordergroove's tracking library depends on. These changes can disrupt analytics and customer behavior tracking. For guidance, see [Customize your Subscription Manager](https://developer.ordergroove.com/docs/sm-template-customization-tracking) for more information.

### Locales

As you browse the `views` files later on, you’ll notice that the Subscription Manager does not have text content written directly in the templates. Instead, there will be Nunjucks templating code retrieving text from the locales files.

This will look like the following:`{{ ‘locale_key’ | t }}`

That code looks for the key `locale_key` in the locale file corresponding to the current language being used. For example, if `locale_key` would say “Hello!” in English, you would find “Hello!” as the value for that key in the locale files starting with “en”, the code for English. In the locale file starting with “fr” on the other hand, you would see “Bonjour!” as the value for `locale_key`.

When a user loads the page in a supported language, all of the content on the Subscription Manager will be filled with the appropriate content in that language. Out of the box, English, French, and Spanish are all available. If a matching language isn’t found, the SM will use the first of the available languages.

You can add as many languages as you want, but be sure that translations are added for all locale keys in the template to avoid blank spaces. Translations that are only used for accessibility (e.g. hidden labels) are prefixed with “a11y”.

### Views

The views folder holds files with extension `liquid` with Nunjucks-syntax templating code. Our custom implementation of Nunjucks is built to maximize readability and ease of development without compromising performance on your store.

The views folder is organized into subfolders representing different sections of the SM and their functionality. The following diagram shows some of the basic sections, which correspond to files and folders.

<Image align="center" src="https://files.readme.io/249250963e89566ea5d1a51162ffe625fe99cbc8ab0c3a6304618a01eb9fac2e-image1.png" />

Here are some basic tips for navigating the `views` folder:

1. Check the above diagram to figure out where the section or feature you’re looking for is located on the base template. Check that folder and the files in that folder.
2. In some folders, the file `main.liquid` is the entrypoint for that folder. That’s the file that is referenced by `include` in another folder, and all the other files in the folder branch out from that file as a node.
   1. `item-level-actions` and `order-level-actions` are the exception to this rule – these features generally have buttons in the `order-item` and `order` folders, respectively, which include the corresponding file.
3. Most actions in the SM open some sort of dialog for the user to confirm and make selections before the API request is sent. Sometimes the button for the action and the dialog are in the same liquid file, and sometimes they aren’t, depending on other design considerations. If an action file has `dialog` suffixed, it only contains the dialog and not the action button that opens the dialog. If it does not have `dialog`, it should contain both the button and the action.

Here are some specific tips for developing in v25:

* The Subscription Manager files have global scoping, so you need to make sure that variables are defined before you use them, and not null if you’re trying to use a property of an object. At the beginning of every file in v25, a comment specifies any variables that are required to be not null, and any that are required to be set (but their value could be equal to null). If you change where a file is included, make sure all the variables it needs are already defined and non-null as necessary!
* The base template uses attributes and custom elements to add special interactivity and functionality. If you remove or edit any attributes, it may break functionality of your SM.
* Classes are only used for styling. You can remove or edit whatever classes you would like in conjunction with the `less` files in the `styles` folder.
* Some elements in the template have `data-testid` defined. These are just for Ordergroove’s use ensuring the base template is robust, and you can remove them in your version of your template if desired.

### Styles

The styles folder contains all of the `less` files containing the CSS styling for the Subscription Manager. The folder structure mirrors the `views` folder to make it easy to find the styles you want to edit when making customizations to a particular liquid file.

The only additional folder compared to the `views` folder is the `components` folder. This folder contains styling for the custom elements defined in the `script.js` file (to be discussed in the next section) and styling for some HTML elements used across the SM, such as buttons.

The other folders contain section and functionality specific styling modifications that correspond to the folder and liquid files in views. Batches of styles that only relate to one liquid file are inside a corresponding `less` file with the exact same name and folder location as the `liquid` file. If some styles span multiple liquid files which share a folder in the views folder, they will share a more generically-named file in the corresponding styles folder.

Outside the folders, several files are intended to modify the styling across the entire Subscription Manager. Their purposes are explained below:

* `design-tokens.less` holds Less variables used across the theme to set colors, sizes, radii, and more. If you just want to make simple color changes, the basic editor or `design-tokens.less` should be your starting point to see if a variable corresponds to the customization you want to make.
* `default-theme.less` holds styling for elements that create the “theming” of the Subscription Manager across components and sections. For example, you would find info box styling in this file.
* `main.less` is the entrypoint of the Less files into the subscription manager. It needs to import all less files used for styling the Subscription Manager. If you add a Less file, you also need to add it here!
* `page-title.less` contains styling for the title block of the Subscription Manager.
* `page.less` contains styling that is not meant to be limited to the Subscription Manager, but instead should target other elements on the page the Subscription Manager is loaded on. In general, you probably don’t want to edit this file.
* `reset.less` reduces browser inconsistencies.
* `utility.less` holds some basic utility classes used across the SM to quickly apply font size and other styling.
* `variables.less` is used by the basic editor to override values in design-tokens.less to make quick, code-free changes to the theme of the SM. This file is automatically generated by Ordergroove when you make changes with the basic editor.

### Scripts

The scripts folder solely holds `script.js`. The beginning of the file, marked with the “Subscription Manager loading” header, contains some key functions for the Subscription Manager to load. Do not edit these!

Then, the “Custom Elements” section introduces key components we use throughout the Subscription Manager to encapsulate interaction-heavy functionality. The end of the section defines them as [custom HTML elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements). In general, you are unlikely to need to modify this section.

The final section is “Utilities” which has utility functions we use elsewhere in the scripts file and in the SM. This is where you should add any custom javascript functions.

You can reference javascript functions in the `liquid` files using the `js` filter. For example, a custom function `callNewApi` could be added as an onClick method for a button with the code `@click="{{ 'callNewApi' | js }}"`.

### Controls

The controls folder contains `theme-settings.json` This file serves to surface functionality options to the basic editor. You shouldn’t need to edit these to make your customizations, but you may find them being used in the template (for example, `{% if ‘show_upgrade_to_subscription' | setting %}`).

In this case, it’s completely up to you whether you want to maintain that functionality for basic editor users in your organization or remove the reference and disable the basic knob.