<!-- source: https://docs.hyva.io/hyva-themes/faqs/how-about-ie11-support.html -->

# How about IE11 support?

Archived

IE11 support was dropped from Hyvä early on.
This page is kept for historical context.
Internet Explorer is officially retired by Microsoft and no longer supported by Magento since 2.4.0.

Hyvä started out with IE11 support. Using the compatibility version of AlpineJs, we included some polyfills mainly for promises and `<template>`tags.

But we ran into several issues:

1. Backticks won't work in IE and can't be polyfilled.
2. Also, arrow functions and functions as properties in an object are also not supported by IE11.
   For example, you can't do `{ someVariable: 'value', doThing() { //doThing }`, but have to use `{ someVariable: 'value', doThing: function doThing() { //doThing }` instead.
3. Certain scripts don't work with the `<template>` polyfills.
   For example, anything that does not belong in a `<tr>` or `<select>` is stripped, meaning `<template>` is thrown out even before AlpineJS is able to run code on it. This means it is impossible to dynamically fill `<tr><td/></tr>` or `<select><option/></select>`.
   We implemented workarounds, but they were nasty. It was liberating to get rid of them when we decided to drop IE support.
4. There were several reported bugs with IE/AlpineJS, and it slowed us down in rewriting code, while making it much more nasty than without IE11 support.
5. Tailwind CSS v2 does not support IE11
6. Everyone is dropping IE support, even Microsoft (November 2021) and [Magento itself (since 2.4.x)](https://experienceleague.adobe.com/en/docs/commerce-operations/release/notes/magento-open-source/2-4-0#:~:text=Infrastructure-,The%20Internet%20Explorer%2011.x%20browser%20is%20no%20longer%20supported.,-The%20validation%20logic)
7. It already lost support for Facebook, Twitter, Linkedin, Youtube and many other mainstream websites, so market share will drop even more in 2020
8. See [death-to-ie11.com](https://death-to-ie11.com/) for more arguments

So in short, you *can* make it work in IE11, but it's a pain, and you have to do it yourself.

Supported Browsers

Related: see our list of [supported browsers](supported-browsers.html)
