# Translations

## What is localization?

Localization allow you to serve the Subscription Manager in a language that is currently in use by your ecommerce store. Ordergroove has built in extensive i18n support to ensure that all of the pieces of the Subscription Manager can be translated to many different languages to match the rest of your site.

***

## How does it work?

Upon initialization, the Subscription Manager looks for the standard lang attribute on the `html` node of your ecommerce store. If there is no lang attribute, then a default of `en` is used. (i.e. `<html lang='en'>`)

Please note that because the Subscription Manager is built as a single page application, it will also listen for any changes to the lang attribute on the `html` node and update itself to render the content with the currently selected locale. This means that the Subscription Manager localization support will work with both ajax and page refresh/redirect standard methods of changing the site locale.

***

## Where can I change my localized content?

***

All localizable content is stored within JSON-formatted files. You can alter existing locale files or even add your own. The Subscription Manager will always attempt to load a file that matches the current lang attribute being set on the html node. For example, if the current locale is set to zh-cn then the Subscription Manager will attempt to load translation values from the zh-cn.json file.

You can find and manage these files in the locale folder:

<Image align="center" src="https://files.readme.io/efae155-eddc749-Screen_Shot_2021-06-09_at_5.05.47_AM.png" />