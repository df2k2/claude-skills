<!-- source: https://docs.hyva.io/hyva-commerce/upgrading/upgrading-to-1.0.0.html -->

# Upgrading to Hyvä Commerce 1.0.0

This is the first General Availability release for Hyvä Commerce that includes various features, bug fixes and improvements.

## Notable news

### General Availability is here

This release marks the end of the Early Access phase of Hyvä Commerce, and includes the first stable versions (`1.0.0`) of Hyvä CMS, the Admin Theme and Image Editor. Read our [blog post](https://www.hyva.io/blog/news/hyva-commerce.html) for all the details.

While each of the features in this release contain a variety of minor new features, enhancements and bug fixes, the main change is that they now adhere to same versioning and backwards compatibility pledge of Hyvä's other products. For more details see the [Release Process page](../release-process-status.html).

### Hyvä CMS

#### Backward incompatible changes

##### Added Head Assets to Liveview Editor

Skip if you have not extended the Hyvä CMS Liveview Editor

Only affects projects which have extended the Hyvä CMS Liveview Editor with advanced customisations.

If you have extended the Hyvä CMS Liveview Editor by adding custom JavaScript or CSS assets to the admin panel via XML layout handles,
you will need to add them to the `allowedAssets` argument for the `Hyva\CmsLiveviewEditor\Plugin\PageConfigStructurePlugin` via `di.xml`.

See the [Adding Head Assets to Hyvä CMS Liveview Editor](../features/cms/adding-assets-to-liveview-editor.html) guide for more information.

## Changelogs

The changelog is available [here](changelog.html#100-2025-07-11).

## Known Issues

- None so far
