<!-- source: https://docs.hyva.io/hyva-themes/faqs/sample-data.html -->

# Is there Hyvä Sample Data?

At the time of writing, there is no Hyvä specific sample data.
Either the original Luma sample data or the Venia sample data can be used with Hyvä.

However, since the CMS data contained in the sample data refers to CSS classes from Luma or PWA Studio respectively, that content will not work cleanly with Hyvä and will require manual fixing.

## Removing Luma Sample Data styles.css

The Luma sample data includes a `styles.css` file that will be loaded on every page directly from the `pub/media` folder.
This CSS file is loaded in addition to the Hyvä styles and can cause layouts to not render as expected.

To prevent this CSS file from loading, open the design configuration, choose the store view with your Hyvä theme, and remove the contents of the input field found at "*Other Settings > HTML Head > Scripts and Style Sheets*".
Then save the configuration and clear the cache.

Alternatively you can remove the file programmatically by running the SQL query:

```
DELETE FROM core_config_data WHERE path='design/head/includes' AND scope='default' AND scope_id=0;
```

Also clear the cache after executing the SQL command.
