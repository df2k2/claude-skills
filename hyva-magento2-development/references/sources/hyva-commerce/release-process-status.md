<!-- source: https://docs.hyva.io/hyva-commerce/release-process-status.html -->

# Hyvä Commerce Release Process & Status

## What is the Hyvä Commerce release process?

[Hyvä Commerce](https://www.hyva.io/hyva-commerce.html) is our product suite that builds on top of Magento Open Source (or Adobe Commerce). This is delivered as a suite of modules (and a theme) that can be installed as a whole (via composer metapackage) or individually.

Our main metapackage contains generally available features, but as we will constantly be adding new features, and value your feedback, we will also offer access to early versions of features via a combination of using feature flags and alpha and beta releases.

This approach means you can get familiar with all new features ahead of their general release, and you can share feedback and report issues that will help us shape our product offering and prioritise the features you, or your merchants, need.

To get alpha/beta access to features, you still need to purchase a [Hyvä Commerce](https://www.hyva.io/hyva-commerce.html) license.

## General Availability vs Alpha and Beta Releases

The main metapackage we offer only includes stable Hyvä Commerce packages that are tagged as `1.0.0` or higher, following the same versioning methodology as Hyvä Theme. This metapackage along with all the included packages (which can also be installed separately), form our general availability offering. General availability adheres to same quality, performance and commitment to avoid backwards incompatible changes as all other Hyvä products.

As we introduce new features these will be initially included as either:

- For new standalone features (e.g. new modules):
  - As a separately installable composer package as an alpha and/or beta version.
- For new features for existing packages:
  - Included within a general release behind a feature flag, meaning it can easily be disabled (and may even be disabled by default), ensuring it does not impact existing functionality, or
  - Made available via a separate alpha/beta version of the package.

As with standard usage in software development, Alpha denotes very early versions of a feature, while Beta denotes more stable, but still not finalized releases of features.

Additional Notes:

- Alpha Releases:
  - In most cases, will only be available to select agency (Gold/Platinum) and technology partners.
  - May have substantial missing or incomplete functionality.
  - Are likely to have many breaking changes in future updates.
  - Should never be used in production, only for testing and providing feedback.
- Beta Releases:
  - Will be available to all Hyvä Commerce licensees.
  - May still incur some backwards incompatible changes and have minor missing/incomplete features.
  - While we don't recommend they are used in production, they can be, with the consideration that substantial updates may be required in the future.
- Alpha and beta releases will be distributed:
  - As `0.x.x` versions for new packages.
  - As `x.y.z-alphaX`/`x.y.z-betaX` versions for new features within existing packages.
  - Alpha offerings may be provided without being tagged.
- Alpha/Beta versions of the main metapackage may be made available if we feel it is relevant to do so.

Will RC (Release Candidate) releases be provided?

Not for the majority of releases, but we may consider this in future for larger releases ahead of a general release.

## Current Release Status

The following list outlines the high-level features that have reached general availability, those currently available in alpha or beta, as well as those still under development. For a preview of upcoming features, along with additional functionality planned for existing features, please see our [roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).

### General Availability

- [Admin Theme](features/admin-theme/index.html)
- [Hyvä CMS](features/cms/index.html)
- [Image Editor](features/image-editor/index.html)

### Alpha/Beta Availability

- [Admin Dashboard](features/admin-dashboard/index.html)

### Under Development

Items being worked on that are not currently available in any form.

- [Media Optimisation](features/media-optimization/index.html)

### Coming Later

See the [Hyvä Commerce Roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).

## FAQs

How can I be notified about new releases and updates

You can keep up to date on the status for all our Hyvä Commerce offerings via our updates in the `#hyva-commerce` and `#update-notifications` Slack channels.

How can I provide feedback & get help?

See our [Overview page](index.html#providing-feedback-getting-help).

What is Early Access?

Early Access referred to our initial releases of Hyvä Commerce before any features had been released for General Availability (i.e. no `1.0.0` versions existed). Early Access for Hyvä Commerce has now ended.
