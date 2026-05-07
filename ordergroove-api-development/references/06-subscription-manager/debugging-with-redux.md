# Debugging with Redux

The Subscription Manager (SM) uses a Redux store to manage the state of the customer’s subscriptions and orders. If you are making custom changes to the SM, checking the Subscription Manager Redux store directly may help with debugging or understanding the objects being used.

***

## Requirements

This guide is for developers already working on customizations to their SM.

***

## Install Redux DevTools

First, you should install a browser extension that gives you insight into the Redux store. Redux DevTools is available on [Chrome](https://chromewebstore.google.com/detail/redux-devtools/lmhkpmbekcpmknklioeibfkpmmfibljd?hl=en) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/reduxdevtools/).

***

## Inspect the Subscription Manager

With Redux DevTools installed, we can get more insight into the Subscription Manager. Navigate to the Subscription Manager on your store, and enter the browser inspector. Then, navigate to the new tab for Redux.

The image below shows what you should see. Make sure that the Store selector has “Ordergroove SMI” selected.

<Image align="center" src="https://files.readme.io/eab3c9868d2e179c4111b6002ced5dfe37ec297e827036f4f2e5df9f7b25de50-image1.png" />

The panel on the left has all of the actions being dispatched. You can play around with taking different actions on the SM and see what actions happen in Redux. The right panel has the state at the end of each action. The state in Redux reflects the exact objects the Subscription Manager templates have available by default. If in the templates, you type `{{ orders }}`, you are accessing the `orders` from the Redux state.

In the above image, the first actions that are visible are all for loading the Subscription Manager. The state available after each action may be minimal as a result. To check the final state after load, scroll to the bottom of the actions and click on the last action that occurred.

***

## How to use Redux

### Checking available objects and properties

If you’re making custom features for the Subscription Manager, you may be accessing our objects and properties on those objects differently from how the base template already does. If you check the state on the Subscription Manager after loading, you can see exactly what is available and determine how different objects can be connected together to create your custom experience. There could also be properties available that we haven’t used that will be useful for your custom experience.

### Debugging errors

If you make a customization and your Subscription Manager is having difficulty loading, you may be accessing properties or objects that don’t exist. You can verify through the state preview exactly what objects and accesses are available.

You also may create custom JavaScript functions which trigger actions in Ordergroove, such as if you call any of the functions in [this guide](https://developer.ordergroove.com/docs/call-rest-apis-from-within-subscription-manager#option-2---leverage-the-existing-api-calls-via-windowogsmi). If you run into issues, you may find it helpful to check the expected action in the Redux store and see if the expected inputs are being passed into it in the “Action” tab on the right panel, based on the actions that run successfully in the base template.