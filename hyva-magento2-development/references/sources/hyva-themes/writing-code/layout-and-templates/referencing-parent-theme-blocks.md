<!-- source: https://docs.hyva.io/hyva-themes/writing-code/layout-and-templates/referencing-parent-theme-blocks.html -->

# Referencing parent-theme blocks

Often, while customizing a theme, blocks declared in a parent theme like Hyva/default are moved or changed.

A common mistake of beginners is to copy the layout declaration from the parent theme and make the required adjustments.
This approach usually works initially, but can have unintended effects.

## TLDR; use `referenceBlock` in child themes

In a nutshell: instead of using `<block name="example">` tags in child themes to customize blocks that already exist in the parent theme, use `<referenceBlock name="example">` instead.

## Background

To understand the reason for this recommendation, it is important to know a little about how pages are generated.
Magento processes Layout instructions starting at the lowest priority fallback theme, working up to the current theme, which has the highest priority.

When the process finds a `<block>` tag, it registers it using the block name as an identifier together with all arguments and the parent reference as a class to be instantiated.
When the process finds another `<block>` tag with the same block name, it discards already existing records for that block and replaces them with the new one.

A `<referenceBlock>` tag on the other hand update the existing record for the block instead of completely replacing it.

**What can using `block` instead of `referenceBlock` cause?**

The problem with copying block declarations into a child theme is it makes upgrades more complex.
If block arguments are added or changed in the parent theme, the copy of the block in the child theme masks the change.
This can lead to subtle bugs that cost a long time to debug.

If `referenceBlock` is used, any new block arguments added in new versions of the parent theme will apply automatically.
