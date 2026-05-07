# Subscription Manager File Descriptions

The Subscription Manager is composed of a large number of individual files. In this guide we'll go through all of the files available and what they modify.

***

## Requirements

This article is intended for developers on Subscription Manager 2.0; shown as v25 templates and beyond. You should already have a thorough understanding of the fundamentals of HTML, CSS, and Javascript.

### How to tell what version you're on

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/0f5a3126136d00f63aed46b389aba7f3ac6835182c6447149a5bdd11d941341e-image2.png" />

***

## Advanced Editor Layout

The Subscription Manager has 5 folders in the advanced editor. This guide will go through each folder and how its contents fit into the overall Subscription Manager experience.

## Locales

As you browse the views files later on, you’ll notice that the Subscription Manager does not have text content written directly in the templates. Instead, there will be Nunjucks templating code retrieving text from the locales files.

This will look like the following: `{{ ‘locale_key’ | t }}`

That code looks for the key locale\_key in the locale file corresponding to the current language being used. For example, if locale\_key would say “Hello!” in English, you would find “Hello!” as the value for that key in the locale files starting with “en”, the code for English. In the locale file starting with “fr” on the other hand, you would see “Bonjour!” as the value for locale\_key.

When a user loads the page in a supported language, all of the content on the Subscription Manager will be filled with the appropriate content in that language. Out of the box, English, French, and Spanish are all available. If a matching language isn’t found, the SM will use the first of the available languages.

You can add as many languages as you want, but be sure that translations are added for all locale keys in the template to avoid blank spaces. Translations that are only used for accessibility (e.g. hidden labels) are prefixed with “a11y”.

## Views

The views folder holds files with extension liquid with Nunjucks-syntax templating code. Our custom implementation of Nunjucks is built to maximize readability and ease of development without compromising performance on your store.

The views folder is organized into subfolders representing different sections of the SM and their functionality. The following diagram shows some of the basic sections, which correspond to files and folders.

<Image align="center" width="85% " src="https://files.readme.io/4b373d288196387cc67d9bb6f034d9605844812bc5a6eee1467f37a52bd7ea83-image20.png" />

Here are some basic tips for navigating the views folder:

1. Check the above diagram to figure out where the section or feature you’re looking for is located on the base template. Check that folder and the files in that folder.
2. In some folders, the file main.liquid is the entry point for that folder. That’s the file that is referenced by include in another folder, and all the other files in the folder branch out from that file as a node.
   1. item-level-actions and order-level-actions are the exception to this rule – these features generally have buttons in the order-item and order folders, respectively, which include the corresponding file.
3. Most actions in the SM open some sort of dialog for the user to confirm and make selections before the API request is sent. Sometimes the button for the action and the dialog are in the same liquid file, and sometimes they aren’t, depending on other design considerations. If an action file has dialog suffixed, it only contains the dialog and not the action button that opens the dialog. If it does not have dialog, it should contain both the button and the action.

Here are some specific tips for developing in v25:

* The Subscription Manager files have global scoping, so you need to make sure that variables are defined before you use them, and not null if you’re trying to use a property of an object. At the beginning of every file in v25, a comment specifies any variables that are required to be not null, and any that are required to be set (but their value could be equal to null). If you change where a file is included, make sure all the variables it needs are already defined and non-null as necessary!
* The base template uses attributes and custom elements to add special interactivity and functionality. If you remove or edit any attributes, it may break functionality of your SM.
* Classes are only used for styling. You can remove or edit whatever classes you would like in conjunction with the less files in the styles folder.
* Some elements in the template have data-testid defined. These are just for Ordergroove’s use ensuring the base template is robust, and you can remove them in your version of your template if desired.

<br />

### inactive-subscriptions

This section displays the customers inactive subscriptions. Three files make up this section.

<Image align="center" src="https://files.readme.io/052f29b1d91cefe2e2da3ad94e3b55729c1bfde93498094d07ed72b54323d112-image15.png" />

* #### **main.liquid**

  * The code in this file is for the main inactive subscription section.

    <Image align="center" src="https://files.readme.io/dbd332a742104f3691a9f310f9eb79caf4072e240dbebb5b6a657b425ec4b99c-image5.png" />
* #### **no-subscriptions.liquid**
  * The code in this file controls what is displayed to a customer when they have no subscriptions.
* #### **reactivate-subscriptions.liquid**

  * The code in this file controls the reactivate subscription button that is displayed within the main.liquid file.

    <Image align="center" src="https://files.readme.io/f9f42a40a42eefe1f43a4d8fa1259714451b1223fca01296280bee9143111419-image23.png" />

<br />

### item-level-actions

* #### **cancel-reasons.liquid**

  * The code in this file displays the subscription cancel reasons.

    <Image align="center" width="85% " src="https://files.readme.io/28c8f9420cffc47e3acfcb16955951e381316a0eccebc799c8528e8272715f87-image47.png" />
* #### **cancel-subscription-dialog.liquid**

  * The code in this file controls the first pop-up dialog box of the subscription cancel flow.

    <Image align="center" width="85% " src="https://files.readme.io/7622f10626d02bfb03ce7561d326489e81b971c3e134829dfcd9d182aa3f4144-image46.png" />
* #### **pause-subscription-dialog.liquid**

  * The code in this file controls the Pause Subscription dialog box.

    <Image align="center" width="85% " src="https://files.readme.io/690b80addfd63d4e39dc70b6dc2bc06f7ce0d6972ac1b7365104c1fb7151c027-image19.png" />
* #### **pause-subscription-options.liquid**

  * The code in this file controls the date options displayed in the red box below.

    <Image align="center" width="85% " src="https://files.readme.io/ac43ab597e024546226685399ce2ff5c4b0b042fc9d276e4ebe480a583d3f3b7-image33.png" />
* #### **remove-item.liquid**

  * The code in this file controls the dialog box for removing a one-time item from an order.

    <Image align="center" width="85% " src="https://files.readme.io/d88432899cca4ce189cf7c79140b1d42adbfceefe7fa389d0d25823a585a9be4-image1.png" />
* #### **skip-item-dialog.liquid**

  * The code in this file controls the dialog box for skipping an item from an upcoming order.

    <Image align="center" width="85% " src="https://files.readme.io/ef82f5a279e110376b34909db49668cdd3220b117abc8a97f1310cf89be6288c-image22.png" />
* #### **sku-swap-product-change-dialog.liquid**

  * The code in this file controls the dialog box for the sku-swap. This only appears in the SM if sku-swap is enabled for the product in an order.

    <Image align="center" width="85% " src="https://files.readme.io/48e68e2922cdc80521c735d8ed3ac1835d8b68c98a13eed1af274cdcd88e427a-image16.png" />

<br />

### order-item

This represents the section for the individual items within an order.

<Image align="center" width="85% " src="https://files.readme.io/d8a3056d321c65aea82b114048f2cb0a99fe9bb8bad8bfa131a8350322d11ff8-image10.png" />

* #### **bundle-item-contents.liquid**

  * The code in this file controls the light blue “Bundles contents” box that shows for bundled subscriptions.

    <Image align="center" src="https://files.readme.io/6c35a0bb9232ab2302dd2018889c07f8b3dd3c9658e2ead7a8d1e313bb0fd3bf-image37.png" />
* #### **frequency-select.liquid**

  * The code in this file controls the frequency dropdown of the order item.

    <Image align="center" src="https://files.readme.io/ce238ed9b26bc8380ef6c4673816f7333a50472a96a17d3cd15a7f572ecfee59-image30.png" />
* #### **main.liquid**

  * The code in this file controls the order item section.

    <Image align="center" src="https://files.readme.io/e7d4d328963c7c5156cbbd0c82f3e8d41555e46024b19887d97effefeffdc918-image36.png" />
* #### **more-options-dropdown.liquid**

  * The code in this file controls the **More Options** button on the main order item section.

    <Image align="center" src="https://files.readme.io/6910f32c0910b48ee4af76c875d00467d20b79a8ac94b760b3deda558b5b0a19-image40.png" />
* #### **order-controls.liquid**

  * The code in this file controls the section that has the quantity and frequency dropdowns.

    <Image align="center" src="https://files.readme.io/6b1491e069355787480460bfe0c78586a6eefacc4e2e759af729ae4c431c00f4-e1098416edee0b8c905a9fadce37985835927af41cca10ab36b283135ea697f5-image26.png" />
* #### **order-item-badge.liquid**

  * The code in this file controls the badge displayed above the order item image.

    <Image align="center" src="https://files.readme.io/7fa61d80f498297ae1fffb15a71fd61a56adbd84b9919e5aeeac763ee05f918e-image8.png" />
* #### **order-item-buttons.liquid**

  * The code in this file controls the buttons for SKU-swap, skip product, pause, and cancel subscription.

    <Image align="center" src="https://files.readme.io/1c52c0008439dbb58f4bf33e948891c4202e2e380efc86e5cd48d58297b2c54c-image12.png" />
* #### **prepaid-controls.liquid**

  * The code in this file controls the prepaid information displayed on the order item.

    <Image align="center" src="https://files.readme.io/a3439842d06ba6b51db06371013a8cac1a48e822058a2dd04d21d32d4ccb7944-image11.png" />
* #### **price-display.liquid**

  * The code in this file controls the order item price.

    <Image align="center" src="https://files.readme.io/0ccfe3dbb852b9bfe517603d1b27b9f0fb4e365aef3c15926594529e71eaa333-image42.png" />
* #### **quantity-select.liquid**

  * The code in this file controls the quantity dropdown on the order item.

    <Image align="center" src="https://files.readme.io/3e9f4b413863e4b92980afaa333451c73975bfb9a235491e24e6f7f66bb19b77-image21.png" />
* #### **upgrade-one-time-to-subscription.liquid**

  * The code in this file controls the upgrade to subscription option for one-time items that is displayed on the order item.

    <Image align="center" src="https://files.readme.io/773648fb1514bccf4dbd47e4506125b73507f020d78275b9829834b7686f8161-image49.png" />
* #### **upgrade-subscription-to-prepaid.liquid**

  * The code in this file controls the upgrade to prepaid option for subscription items.

    <Image align="center" src="https://files.readme.io/6d572f9cbe132165a7b4cada89a168ae3645220d05320c29c43a1dcc6a6b8348-image32.png" />

<br />

### order-level-actions

This section contains the order level actions. These actions affect all order items in an order.

<Image align="center" width="85% " src="https://files.readme.io/28e7df98354f7fe8e5166f048690dbd4376a0860b6f1682e0321c2a34b9ef2e8-image39.png" />

* #### **change-order-date.liquid**

  * The code in this file controls the Change Order Date button in the order header.

    <Image align="center" src="https://files.readme.io/7c7f780ef1027114cc24bcb9f227a3009c26de6fe04eae909e0d3ec83d3b256a-06d6efb497e67c025dffc2f57a792142e1cd2bd6b2d1fc7edabb967446f0ef47-image24.png" />
* #### **send-order-now\.liquid**

  * The code in this file controls the Send Now button in the order header.

    <Image align="center" src="https://files.readme.io/5a069d4091d0e6244a0ab6b316335a47b27520697ab7e967de1bf18dc5f3af2b-image29.png" />
* #### **skip-order.liquid**

  * The code in this file controls the Skip Order button in the order header.

    <Image align="center" src="https://files.readme.io/648ff20fcbf9e6ce6b971a77a631a063468ac118d9a33f4c78b4a130a43ddff6-image9.png" />

<br />

### order-summary

This section contains the order shipping address,billing address, and the order price summary.

<Image align="center" width="85% " src="https://files.readme.io/94a8fa4d3911256d2a4d18c8964172d770cc21f92fbf0b2a12089790d30eaf9f-image44.png" />

* #### **change-billing-shopify.liquid**

  * The code in this file controls the Billing section of the order summary for merchants on Shopify.

    <Image align="center" src="https://files.readme.io/2ef50ad0853efc0a4099addf7ae89857714a45cd0a4fb958b5e68243cc4ba473-image27.png" />
* #### **change-shipping-buttons.liquid**
  * The code in this file controls the Add New Address button.
* #### **change-shipping-dialog.liquid**

  * The code in this file controls both the Add and Edit Shipping dialog boxes.

    <Image align="center" width="75% " src="https://files.readme.io/57c11f9092799dd921ce5b83e0aa65e6c11ce16f7362c345a2883ab923861699-image17.png" />

    <Image align="center" width="75% " src="https://files.readme.io/1de18c1a35e55020e3b02294c3ce9d10f1f05076e782e540205b404b70f6f8c2-image13.png" />
* #### **discount-code-form.liquid**

  * The code in this file controls the form for applying discount codes. This section is only available for merchants on Shopify.

    <Image align="center" src="https://files.readme.io/71107d5f2350e30d8e70605f9fcac6c83ccc9e8125d1e195dcd323d994afc12c-image25.png" />
* #### **discount-codes.liquid**

  * The code in this file controls the section that displays the discount codes that have been applied. This section is only available for merchants on Shopify.

    <Image align="center" src="https://files.readme.io/25a184a3fb1766a1277f072db19881e5ec000e11f259e642f5ae3e6795162fef-image51.png" />
* #### **main.liquid**

  * The code in this file controls

    <Image align="center" width="85% " src="https://files.readme.io/51b51577346ddda7ae671e7696a5a196b94fa2d542b52f2f7f42da190eb6f3b2-image18.png" />
* #### **payment-details.liquid**

  * The code in this file controls the payment for the order.

    <Image align="center" src="https://files.readme.io/be18659a5543bd9d6d10dab87db1f978fa7466ea4b45ad056a979ac02ae2bb2b-image7.png" />
* #### **price-details.liquid**

  * The code in this file controls the price details section for the order.

    <Image align="center" src="https://files.readme.io/dd8f8915ad8170089c7b3a93fd446d297a866762475a11aa67b4f58a470e3bb2-CleanShot_2025-02-04_at_22.18.40.png" />
* #### **shipping-address-card.liquid**

  * The code in this file controls

    <Image align="center" src="https://files.readme.io/576dd2fc563aec87bab510f3511ff494030e487fe18604158b787b83143b93dc-image48.png" />
* #### **shipping-details.liquid**

  * The code in this file controls

    <Image align="center" src="https://files.readme.io/fb421bb0d534e697a69e037c2ad932ba75addc081185b5d5b65d5ea5566d154d-image14.png" />

<br />

### order

This section's files control the main body of the order and the header.

<Image align="center" width="85% " src="https://files.readme.io/b2d45715540d6d158b5db59ea377be9cd125d625b68e4a651f6c1fd34fba87d9-image45.png" />

* #### **main.liquid**

  * The code in this file controls the main section of the order and references the **order/order-header**, **order-item/main**, and **order-summary/main** files.

    <Image align="center" src="https://files.readme.io/b9f48430f1b7629d61133af776c46fe027de8b9d04267be5fd732bf5ecd863cf-image31.png" />
* #### **order-header.liquid**

  * The code in this file controls the header section within the order.

    <Image align="center" src="https://files.readme.io/a5c89eb716b771b019fcf1e4d92ee65c43387bf9aaea00654c90b37e38c2b517-image28.png" />

<br />

### iu-elements

This section contains the files for the datepicker, SM icons, and notifications.

* #### **datepicker-popover.liquid**

  * The code in this file controls the calendar datepicker.

    <Image align="center" width="25% " src="https://files.readme.io/593bbfcd87a9b65cf6c097f266645e2d2a255f2c31753c973882165a422b4dad-image35.png" />
* #### **icons.liquid**

  * The code in this file controls the various icons used throughout the Subscription Manager. Some of the icons are highlighted below.

    <Image align="center" src="https://files.readme.io/bd1f87fc1b826eda87387e9b4448281a09e835b5b748b3ba20763887c81b9994-image43.png" />
* #### **notifications.liquid**
  * The code in this file controls the notifications for successes and errors.

<br />

### dialog-header.liquid

The code in this file controls the header of the dialogs boxes.

<Image align="center" width="85% " src="https://files.readme.io/667634658bc18c61527014612575a18e2974baa4bd793adbf4a20e1fe4b26b16-image4.png" />

<br />

### main.liquid

The code in this file controls the Subscription Manager  layout. It references the following files; **order-processing**, **upcoming-orders**, **inactive-subscriptions/main**, **inactive-subscriptions/no-subscriptions**, **iu-elements/notifications**.

<Image align="center" width="85% " src="https://files.readme.io/14b0124ec4d9122659fa553cc2815b6854479edc84dfd97b83242a9725a2ee87-image34.png" />

<br />

### maintenance-mode.liquid

The code in this file controls the Maintenance Mode section on the Subscription Settings page.

<Image align="center" src="https://files.readme.io/3cb3c55788234026fbb2e621a20b552d57bb530873f078e9899f766ab86470c1-image41.png" />

<br />

### order-processing.liquid

The code in this file controls the section for **order-processing**.

<Image align="center" src="https://files.readme.io/8bf5a4b2ebe81d640dbd3d107c87e897e197e8a256c2ebbdf4178f79fb4cf133-image38.png" />

<br />

### Page-title.liquid

The code in this file controls the title section of the Subscription Manager.

<Image align="center" src="https://files.readme.io/b7ce8a62d774782f302f590748b8df527f0970e437e5706475ffce3b56e06308-image3.png" />

<br />

### upcoming-order.liquid

The code in this file controls the section for unsent orders. It references **order/main**.

***

## Styles

The styles folder contains all of the less files containing the CSS styling for the Subscription Manager. The folder structure mirrors the views folder to make it easy to find the styles you want to edit when making customizations to a particular liquid file.

The only additional folder compared to the views folder is the components folder. This folder contains styling for the custom elements defined in the script.js file (to be discussed in the next section) and styling for some HTML elements used across the SM, such as buttons.

The other folders contain section and functionality specific styling modifications that correspond to the folder and liquid files in views. Batches of styles that only relate to one liquid file are inside a corresponding less file with the exact same name and folder location as the liquid file. If some styles span multiple liquid files which share a folder in the views folder, they will share a more generically-named file in the corresponding styles folder.

Outside the folders, several files are intended to modify the styling across the entire Subscription Manager. Their purposes are explained below:

* **design-tokens.less** holds Less variables used across the theme to set colors, sizes, radii, and more. If you just want to make simple color changes, the basic editor or design-tokens.less should be your starting point to see if a variable corresponds to the customization you want to make.
* **default-theme.less** holds styling for elements that create the “theming” of the Subscription Manager across components and sections. For example, you would find info box styling in this file.
* **main.less** is the entrypoint of the Less files into the subscription manager. It needs to import all less files used for styling the Subscription Manager. If you add a Less file, you also need to add it here!
* **page-title.less** contains styling for the title block of the Subscription Manager.
* **page.less** contains styling that is not meant to be limited to the Subscription Manager, but instead should target other elements on the page the Subscription Manager is loaded on. In general, you probably don’t want to edit this file.
* **reset.less** reduces browser inconsistencies.
* **utility.less** holds some basic utility classes used across the SM to quickly apply font size and other styling.
* **variables.less** is used by the basic editor to override values in design-tokens.less to make quick, code-free changes to the theme of the SM. This file is automatically generated by Ordergroove when you make changes with the basic editor.

***

## Scripts

The scripts folder solely holds script.js. The beginning of the file, marked with the “Subscription Manager loading” header, contains some key functions for the Subscription Manager to load. Do not edit these!

Then, the “Custom Elements” section introduces key components we use throughout the Subscription Manager to encapsulate interaction-heavy functionality. The end of the section defines them as [custom HTML elements](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_custom_elements). In general, you are unlikely to need to modify this section.

The final section is “Utilities” which has utility functions we use elsewhere in the scripts file and in the SM. This is where you should add any custom javascript functions.

You can reference javascript functions in the liquid files using the js filter. For example, a custom function callNewApi could be added as an onClick method for a button with the code `@click="{{ 'callNewApi' | js }}"`.