# Subscription Manager Theme Editor Overview

This document provides an overview of the Subscription Manager (SM) Theme Editor, explaining how to navigate both the landing page and theme editor, and offering guidance on available customization modes.

***

## SM Theme Editor: Landing Page Overview

When you access the SM Theme Editor, you will first see the landing page. This page provides key details about your themes and allows you to manage them. On the left, you will see your live theme, and on the right, a list of any draft themes. Only one theme can be live at a time, and this live theme is the one visible to your customers on your site.

<Image align="center" src="https://files.readme.io/ec9cf4bfd94723c9316377aa03e96f541487b13a03699d705fe8ea6eb22135ee-image6.png" />

From the landing page, you can manage your themes by performing several actions. You can publish a draft theme, which will make it live and automatically convert the current live theme into a draft. You can also rename your themes for internal reference, duplicate an existing theme to create a new version, or delete a theme if you no longer need it. The theme version is displayed both on the landing page and in the theme editor to help you keep track of the version you're working on.

***

## SM Theme Editor: Theme Customization Overview

After selecting a theme, you will enter the theme editor, where you can choose between two customization modes: Basic Mode and Advanced Mode. These modes offer different levels of control depending on your technical expertise. For more information on these two modes, take a look at the [Knowledge Center](https://help.ordergroove.com/hc/en-us/articles/34052245741843-Basic-and-Advanced-Editor-in-the-Subscription-Manager).

<Image align="center" width="90% " src="https://files.readme.io/7281ec84299910417f625e113db1dfdbbfc60622bf917194c635a53f5c732a58-image3.png" />

You can see if you’re working on a draft or your live theme via the tag next to your theme name.

<Image align="center" width="70% " src="https://files.readme.io/f56e45b7e0bf5e6d29c26b99008df63a19f3b1e1e584eba755f3f048b30e2d6a-image4.png" />

***

## Additional Theme Editor Features

The SM Theme Editor offers several additional features to help you manage your themes. If you need to reset your theme back to its default settings, you can either create a new theme from scratch or use the "diff" button in Advanced Mode to revert changes to individual files. This gives you the flexibility to restore specific parts of your theme without having to start over entirely.

<Image align="center" width="80% " src="https://files.readme.io/112ed5ebeb10fc337cc9fc77dafac1a2e096ed586099e32c45dec51b925bc094-image2.png" />

The base theme is mobile-compatible by default, with built-in media queries in the .less files. To preview how your theme looks on a mobile device, simply resize your browser window. Keep in mind, however, that there are no specific tools provided for cross-browser or device testing, so you will need to manually check the preview across different browsers and devices. If the theme you’re working on is not published (live), there is also an option to preview how the Subscription Manager will appear on your site. Click the preview button in the top right of your screen, then follow the instructions that appear.

<Image align="center" width="80% " src="https://files.readme.io/563587f61031502c224cbe69d3d7f380493b1bf309f79b9a1c3ed91e91567080-image7.png" />

If you want to apply custom fonts, you can do so by editing the `design-tokens.less` file or other relevant `.less` files in Advanced Mode. There is no limit to the amount of customization you can apply, giving you full control over how your Subscription Manager looks and functions.

For more information on advanced customization, take a look at [Edit Code with the Advanced Editor](https://developer.ordergroove.com/docs/edit-code-with-the-advanced-editor).

Finally, always keep track of the theme version you're working on. The version is displayed on both the landing page and the theme editor page, making it easy to identify the current draft or live theme.

<Image align="center" width="90% " src="https://files.readme.io/fd639d6ddbe950f17ec4526336f196b11c7e93009c5a3faf65b427a1046a7b71-image1.png" />

Remember, only one theme can be live at a time, and you can publish a theme to make it live directly from the landing page.

<Image align="center" width="80% " src="https://files.readme.io/a09798d05a3b112e4df79622e6d6cdf889ae38492dd8955ef74843e0ca279bcd-image5.png" />