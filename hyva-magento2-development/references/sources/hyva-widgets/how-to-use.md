<!-- source: https://docs.hyva.io/hyva-widgets/how-to-use.html -->

# How to use

## Creating Widget Instances

First, log into the Magento admin UI and navigate to `Content -> Pages -> e.g. Home page`.

1. Open the content section activate the Editor by clicking on the "Show/Hide" button.
   ![](img/widget_1.jpg)
2. Click on Insert Widget icon.
3. Pick a widget type from the dropdown e.g. Hyva content widget.
   ![](img/widget_2.jpg)
4. A widget popup will display with a list of options.
   ![](img/widget_3.jpg)
5. When finished editing, press "Insert Widget" in the top right corner and save the page.
   ![](img/widget_4.jpg)
6. In production mode, the Bllock HTML and Full Page Cache needs to be "Refreshd" in order for changes to be applied on the store front.
   ![](img/widget_5.jpg)
7. We can now safely navigate to the store front and check out the widget.
   ![](img/widget_6.jpg)

## Development

The module is located at `vendor/hyva-themes/magento2-hyva-widgets/src`

The module follows the standard Hyvä module structure. The source code can be found in the `src/` directory of the package.

1. The `Block` folder:
   This folder contains PHP block classes.
2. The `etc` folder:
   The main point of interest is the `widget.xml` file, where we can see how the different widgets are initialised. This is the primary place for developers to go to in order to add a field, or to add additional data or to create new widgets based on the blueprints provided by the module.
3. The `Observer` folder:
   It contains a fix to force generation of static urls for widget images. Magento 2 has an open issue with directives.
4. The `Plugin` folder:
   It contains a fix for the widget declaration, where widget rendering breaks on unescaped apostrophes. Possible cause is this <https://github.com/magento/magento2/commit/ae3d3df4752dfcac5256ddb5014ce02b19e8a529>, however we will investigate and propose a patch
5. The `ViewModel` folder:
   The directory contains the class `CategoryProducts`. It is used in the category slider widget to provide the products for the selected categories.
6. The `view/frontend` folder:
   It is the main folder that will be of interest to frontend developers. It contains:
   1. The `templates` folder:
      It contains the meat of where the frontend magic happens. The templates are built using vanilla JS, Tailwind and Alpine. They can be overridden in a theme by creating a folder `Hyva_Widgets/templates/widget/` and copying the template to override. This uses the native Magento 2 theme inheritance system.
   2. The `web` folder:
      The `web` folder contains library code for the slider widget.
