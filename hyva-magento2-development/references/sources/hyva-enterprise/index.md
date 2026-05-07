<!-- source: https://docs.hyva.io/hyva-enterprise/index.html -->

# Overview Hyvä Enterprise

Hyvä Enterprise is a stand-alone commercial product, currently available to Hyvä Themes licensees only.

A Hyvä Enterprise license can be purchased at [www.hyva.io/hyva-enterprise.html](https://www.hyva.io/hyva-enterprise.html).

Hyvä Enterprise provides compatibility with Adobe Commerce, the B2B suite add-on and Adobe Services (Live Search, Product Recommendations, and Data Connection) for [Hyvä Themes](../hyva-themes/getting-started/index.html) and [Hyvä Checkout](../hyva-checkout/index.html).

More on Adobe Services packages (and Sensei)

At the beginning of Hyvä Enterprise, we started out 3 initial sub-groups: Adobe Commerce, B2B and Sensei. These names were also used for the metapackages for each, and in the case of Sensei, this contained both Live Search and Product Recommendations together.

There are 2 separate triggers that caused us to stop using 'Sensei' and create new metapackages and rename things (without breaking BC):

1. In default Magento (e.g. when using Luma), there are separate metapackages for both Live Search and Product Recommendations, which can be used independently, and we've had multiple requests asking how people can just install one of these, which wasn't possible at that time.
2. Sensei as a name/group worked for Live Search and Product Recommendations, but in hindsight, there are many more Adobe SaaS services that are now available that are not Sensei-powered, such as Catalog Services and Data Connection (the Experience Platform Connector), plus more.

Firstly, that's why we've created the new Live Search and Product Recommendations metapackages - to provide choice on what to install.

Secondly, this is a wider change. We've renamed 'Sensei' to 'Services' everywhere but the GitLab group URLs (and composer paths) so we don't break BC.

The reason we've kept this in one group and not had a Sensei group and Services group, is that they are all 'services', and the non-Sensei services, also have shared dependencies (mainly the `Magento_DataServices` module, which is the basis for any 'services' based feature).

The 'Data Connection' is a further new metapackage, just for the data connection functionality that allows connection to Adobe's Experience Platform, and is again, independent from Live Search and Product Recommendations.

In summary, we're aligning with the metapackages Adobe provides, and providing a choice on what to install.

Hyvä Enterprise is sold as a single product (i.e. one license) via a yearly subscription, but is split into separate compatibility offerings for Hyvä Themes and Hyvä Checkout, each of which focus on 3 areas:

- Adobe Commerce - all base Adobe Commerce functionality
- B2B - all features from the B2B Suite
- Adobe Sensei - Live Search and Product Recommendations

For more details, including pricing, subscription options and FAQs, see [www.hyva.io/hyva-enterprise.html](https://www.hyva.io/hyva-enterprise.html).

Documentation status

The Hyvä Enterprise documentation is still being completed. Please check back frequently.
If you have any questions, please reach out in the `#hyva-enterprise` [Slack](https://www.hyva.io/slack) channel.

## Compatibility status

You can track the status of all Hyvä Enterprise offerings via our [Feature Matrix](https://www.hyva.io/hyva-enterprise-feature-matrix) and [Compatibility Tracker](https://gitlab.hyva.io/hyva-public/enterprise-compatibility-tracker/-/boards).

## Installation Guide

Please follow our [installation guide](getting-started/index.html).

## Providing feedback & getting help

While the status of modules is managed via our [Compatibility Tracker](https://gitlab.hyva.io/hyva-public/enterprise-compatibility-tracker/-/boards), bugs and feedback should be raised directly on the affected module or package in GitLab via the repositories 'Issues' section.

Merge Requests for bugs you've found (or enhancements) are also welcome, but should be accompanied by a linked issue (you may also need to request the relevant access in order to create a merge request).

For general help, guidance and assistance please reach out in the `#hyva-enterprise` Slack channel.

## Getting started with development & contributions

Extending, customising and contributing to Hyvä Enterprise follows the same process and guidelines as working with Hyvä Themes compatibility modules. For more details, see our [Compatibility Modules](../hyva-themes/compatibility-modules/index.html) guide.

How can I contribute / get access to the repos?

Currently, the only way to access the repos in GitLab is by [purchasing a Hyvä Enterprise license](https://www.hyva.io/hyva-enterprise.html). While we are not actively looking for contributions, due to building this solution ourselves in-house, please reach out in the `#hyva-enterprise` Slack channel if you're interested in contributing features for some or all of a particular module.
