<!-- source: https://docs.hyva.io/hyva-commerce/features/admin-dashboard/devdocs/index.html -->

# Developer Documentation

One of the goals when developing the admin dashboard and the widget system was to provide an extensible framework which developers could use to create their own widgets. The pages within this chapter of our documentation provide technical details and tutorials about the admin dashboard and its widget system.

## Widgets

When talking about admin dashboard widgets, these fall into one of two categories:

### Widget Types

Widget *types* are generic, reusable components that determine the functionality and appearance of a dashboard widget. They are defined in code (using an XML file and a PHP class implementing `WidgetTypeInterface`) and act as a sort of template for a particular type of dashboard content. Each widget *type* can have many widget *instances*.

- [A list of available widget types](./available-widget-types.html)
- [The PHP implementation guide](./widget-php.html)
- [The legacy PHP implementation guide](./legacy-api.html), for widgets that have not yet been migrated to the composition API

### Widget Instances

Widget *instances* are a particular instantiation of a widget *type*, complete with specific configuration values chosen by the admin user during creation. They are stored in the database and are what the admin user sees rendered on their dashboard. Each widget *instance* relates to a single widget *type* and belongs to a single [Dashboard View](../dashboard-views.html).

[More information about widget instances can be found here](./widget-instances.html).

## Reference

- [Module Structure](./module-structure.html)
- [Dashboard API](./dashboard-api.html)
- [Widget XML Configuration](./widget-xml.html)
- [Configurable Inputs](./configurable-inputs.html)
- [Styling Widgets](./styles.html)
- [Layout Handles](./layout-handles.html)
- [Dashboard Cache](./dashboard-cache.html)
- [Event Reference](./events.html)
- [Tutorials](./tutorials.html)
- [Legacy API](./legacy-api.html)
