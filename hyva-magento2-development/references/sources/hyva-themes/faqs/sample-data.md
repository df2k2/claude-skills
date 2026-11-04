<!-- source: https://docs.hyva.io/hyva-themes/faqs/sample-data.html -->

# Is there Hyvä Sample Data?

Yes. Hyvä has its own sample data, the **Koti** sample data, a demo catalog and CMS content built for Hyvä themes.

The Luma and Venia sample data can also be used with Hyvä.

## Installing the Koti Sample Data

The Koti sample data uses Magento's `magento/module-sample-data`, which is part of a standard Magento installation (present unless it has been removed with a Composer replace). Deploy the Hyvä sample data with the CLI, then run a setup upgrade:

```
bin/magento hyva:sampledata:deploy
bin/magento setup:upgrade
```

There are several installation modes depending on whether you already have Luma sample data installed — a fresh install, replacing Luma, installing alongside Luma on a separate website, and reinstalling. To remove it again, use `bin/magento hyva:sampledata:remove`.

For the full installation options and details, see [Hyvä Sample Data (Koti)](../getting-started/sample-data.html).

## Removing Luma Sample Data styles.css

If you use the **Luma** sample data, it includes a `styles.css` file that is loaded on every page directly from the `pub/media` folder. This CSS file is loaded in addition to the Hyvä styles and can cause layouts to not render as expected.

To prevent this CSS file from loading, open the design configuration, choose the store view with your Hyvä theme, and remove the contents of the input field found at "*Other Settings > HTML Head > Scripts and Style Sheets*".
Then save the configuration and clear the cache.

Alternatively you can remove the file programmatically by running the SQL query:

```
DELETE FROM core_config_data WHERE path='design/head/includes' AND scope='default' AND scope_id=0;
```

Also clear the cache after executing the SQL command.
