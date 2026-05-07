<!-- source: https://docs.hyva.io/hyva-themes/faqs/adding-more-levels-to-the-menus.html -->

# Adding More Levels to the Menus

By default, **Hyvä** supports up to two levels in both the desktop and mobile menus.

This design choice is intentional for two main reasons:

1. **Performance**: Adding more menu levels increases the complexity of parsing the category structure,
   which can negatively impact the rendering performance of the menu.
2. **Simplicity**: Keeping the menu structure simple ensures a better default user experience.
   If more levels are required, the menu can be customized to meet specific needs.

The standard category structure used in the menus is the same as in default Magento.

However, if you need a more complex menu structure,
there are alternative methods and data sources available.

For simpler cases, adding a static list to the category structure can resolve your requirements.

This is the approach taken in the **Hyvä UI Library**,
where static links (such as links to CMS pages like the Contact page) are prepended and appended to the menu.

## Alternative Solutions Without Increasing Menu Depth

If your site requires many menu levels and multiple menu links,
consider using **in-page links** rather than forcing everything into the main menu.

For example, use landing pages or product listing pages to present deeper navigation options.

In Hyvä UI, the menu depth is generally limited to 4 or 5 levels,
depending on the style.

Going beyond this limit is not recommended for both performance and user experience (UX) reasons.

A good example of this is the **Product Listing Page (PLP)**,
which provides links to individual products without overcrowding the main menu.

For larger navigation needs,
create landing pages with well-structured lists or grids of links to guide visitors to the desired pages.

## Hyvä UI Menus

If you need deeper menu levels with the appropriate styles and functionality,
consider using the **Hyvä UI** library.

Hyvä UI offers both **Mega Menus** and **Drilldown Menus** for desktop and mobile,
providing a flexible and fully customizable solution for more complex menu requirements.

For detailed information on how to implement and customize these menus,
visit [Hyvä UI Menus](../../hyva-ui-library/menus.html).
