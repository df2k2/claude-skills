<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-browser-sync.html -->

# Using browser-sync

[Browser-sync](https://browsersync.io/) is a tool that helps you test and develop themes on multiple devices at once, and auto-reloads all browsers when a file has changed on your machine.

## Using browser-sync on your host machine

You can run browser-sync directly on your machine.

Make sure browser-sync is installed locally, or install it with:

```
npm install -g browser-sync
```

You can run browser-sync from your Hyvä theme:

```
cd path/to/project/app/design/frontend/Acme/default/web/tailwind
npm run browser-sync
```

Set the `PROXY_URL` environment variable to the host name you use to access your Magento development instance in the browser.

Or, you can run it directly with:

```
browser-sync start --proxy "https://your-magento.test" --https --files 'app/**/*.phtml, app/**/*.xml, app/**/*.css, app/**/*.js'
```

`CTRL-C` will stop the watcher.

## browser-sync with Docker

You may prefer to run browser-sync in Docker, for example if you don’t have your theme files mounted from your local machine but only inside your docker containers.

You can start browser-sync through a Docker container to initiate hot-reload on theme-changes by running:

```
docker run -dt
    --name browser-sync
    --host
    -p 3000:3000
    -p 3001:3001
    -v $(PWD):/source
    -w /source ustwo/browser-sync
    start --proxy "yourdomain.localhost" --files 'app/**/*.phtml, app/**/*.xml, app/**/*.css, app/**/*.js'
```

## Troubleshooting

If you don’t see changes when the browser reloads, check if caches are disabled, e.g. `full_page`, `blocks_html`, `layout`.

Tip

If you have issues with caching during development, consider using [Magento Cache Clean](https://github.com/mage-os/magento-cache-clean).
Magento Cache Clean has a built-in watcher, so you don't have to worry about caching again.
