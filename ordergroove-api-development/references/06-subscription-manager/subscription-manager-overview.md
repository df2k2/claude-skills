# Developing for Subscription Manager Overview

Ordergroove’s Subscription Manager provides a wide range of customizations both out of the box and directly in your Subscription Manager code. This article will link you out to crucial information you'll need to know for developing your Subscription Manager to get you up and running as quickly as possible.

***

## Tagging the Subscription Manager

To use the Subscription Manager on your site, you will need to add a link on your pages. This guide walks through how to [tag your Subscription Manager on Shopify](https://developer.ordergroove.com/docs/tagging-the-subscription-manager-on-shopify) .

***

## Subscription Manager versions

Your Subscription Manager version is frozen when you make changes to your Subscription Manager. In September 2024, we introduced v25 (also known as Subscription Manager 2.0). All merchants have access to v25 by creating a new theme in the Subscription Manager Theme Designer.

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/0f5a3126136d00f63aed46b389aba7f3ac6835182c6447149a5bdd11d941341e-image2.png" />

Our [Tour of Subscription Manager v25](https://developer.ordergroove.com/docs/tour-of-subscription-manager-v25) has all the information you need to find your way around our newest version of Subscription Manager. If you want information on an older version of Subscription Manager, check out our guides to customization on the [v0 templates](https://developer.ordergroove.com/edit/subscription-manager-components-containers).

***

## Basic vs Advanced Editor

Our Basic editor has many of the tools you need to create a customized Subscription Manager, while the Advanced editor allows you to fully customize the code of your Subscription Manager. Check out [this guide](https://help.ordergroove.com/hc/en-us/articles/34052245741843-Basic-and-Advanced-Editor-in-the-Subscription-Manager) to determine which editor is best for you.

***

## Editing your theme

Our Subscription Manager is built on a custom implementation of Nunjucks and lit-html. Before you start editing the code, it will be helpful to read through our [Subscription Manager Development Guide](https://developer.ordergroove.com/docs/subscription-manager-development-guide) which walks through the programming language. The folder of this guide also contains further details about the [objects](https://developer.ordergroove.com/docs/objects) available, how to [leverage Subscription Manager localizations](https://developer.ordergroove.com/docs/translations), and [debugging](https://developer.ordergroove.com/docs/debugging-with-redux) your code.

***

## API Requests

Developers creating custom flows in their Subscription Manager might need to make API requests to Ordergroove or external APIs. [This guide](https://developer.ordergroove.com/docs/call-rest-apis-from-within-subscription-manager) goes through different methods for calling Ordergroove’s API from the Subscription Manager, and [this guide](https://developer.ordergroove.com/docs/integrating-external-apis-in-the-subscription-manager) discusses how to integrate external APIs.