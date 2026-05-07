<!-- source: https://docs.hyva.io/hyva-commerce/features/cms/index.html -->

# Hyvä CMS

Hyvä CMS is our fully re-imagined content management system for [Hyvä Commerce](https://www.hyva.io/hyva-commerce.html) that is designed to make content creation easier, faster, and more flexible in Magento.

[![Liveview Editor](images/editor-screenshot.png)](images/editor-screenshot.png)

Key features include:

- Live Preview – Instantly see changes as you make them, eliminating the guesswork with the Hyvä CMS Liveview editor.
- Content Workflow – Create, edit, and preview content in draft mode before publishing to your live site.
- Reusable Components – Use prebuilt Hyvä UI elements for consistency and faster content creation.
- Custom Components – Easily add your own components or customize existing ones to meet specific needs.
- Version Control – Easily save, restore, and compare previous drafts of your content.
- Support for pages and blocks (support for more content types to follow).
- And More – Numerous merchant and developer-friendly tools that streamline content management workflows.

For more details on upcoming (and previously released) features, see the [Hyvä Commerce Roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).

## FAQs

Where can I use Hyvä CMS to manage content?

At present, Hyvä CMS is supported on CMS Pages and CMS Blocks. We have plans to support category and product attributes as part of our [roadmap](https://www.hyva.io/roadmap?product=hyva-commerce). In addition, developers can add support to any custom entity (e.g. blog modules), following our [extension guidelines](extending-for-other-content-types.html).

Is Hyvä CMS required when using Hyvä Commerce?

No. As with all features included with Hyvä Commerce, their usage is up to your individual needs and preferences.

Does Hyvä CMS replace Page Builder (or the default Magento WYSIWYG Editor)?

Our aim is for Hyvä CMS to be the default CMS solution for all Hyvä Commerce builds, but on a technical level both Hyvä CMS and Page Builder (or the WYSIWYG editor) can co-exist. Hyvä CMS can be enabled on a page-by-page (or block-by-block) basis, which will replace the output of the CMS Page/Block. Disabling it will revert back to the old (e.g. Page Builder/WYSIWYG) content, as this is not removed when enabling Hyvä CMS.

Can I migrate content from Page Builder (or the default Magento WYSIWYG Editor)?

Yes. We offer 2 main options for migrating content. The first is to manually recreate content page-by-page/block-by-block, enabling Hyvä CMS on each page/block once content is ready to be switched from the current Page Builder/WYSIWYG content. The second option allows you to migrate existing content into the Hyvä CMS editor, so you can update and add content around it (as well as replace it when ready).

Can I disable/remove Page Builder when using Hyvä CMS?

Hyvä CMS does not have hard dependencies on Page Builder, so in theory it is possible to completely disable/remove/uninstall Page Builder via config, disabling modules or using the composer replace approach. However, please note that we do not provide guidance or support on how to achieve this.

Can I schedule content with Hyvä CMS?

Yes, this is a key feature of Hyvä CMS. Please, note that Hyvä CMS does not work with the regular Scheduled Content feature of Adobe Commerce. That said, Hyvä CMS and Adobe content scheduling can coexist; you can’t schedule Hyvä CMS content using Adobe’s solution, you’ll need to use our feature.

Does Hyvä CMS work with Adobe Commerce's Content Staging (Schedule & Preview) functionality?

Hyvä CMS works with Adobe Commerce and can co-exist with Adobe's content staging functionality. However, Hyvä CMS content cannot be scheduled using Adobe's functionality, only other CMS Page/Block settings. Once Hyvä CMS is active for a CMS Page/Block it replaces any default scheduled content output (e.g. Page Builder). Scheduling content for Hyvä CMS will be provided as a native feature. For the latest updates see our [roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).

Can I translate content when using Hyvä CMS?

Hyvä CMS will provide the ability to offer content translations (and other content overrides) without having to maintain duplicate structure (and pages/blocks) very soon. For the latest updates see our [roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).

Can I create reusable templates for my content with Hyvä CMS?

At present, this is possible by using our copy/paste and import/export functionality. However, we are working on a full template/snippet management tool. For the latest updates see our [roadmap](https://www.hyva.io/roadmap?product=hyva-commerce).
