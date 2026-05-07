<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/deploying-hyva-to-production.html -->

# Deploying a Hyvä Theme to Production

Deploying a Hyvä theme to production requires three steps: generating the minified Tailwind CSS stylesheet, running Magento's static content deployment to copy assets to `pub/static`, and transferring the compiled files to your production server. Unlike development mode where Tailwind generates CSS on-the-fly using a watcher process, production mode requires a pre-built, minified `styles.css` file.

This page covers the standard manual deployment workflow suitable for traditional hosting environments. For automated deployments, see [Adobe Commerce Cloud Deployment](adobe-commerce-cloud-deployment.html) or [Capistrano Deployment](capistrano-deployment.html).

## Build Environment Recommendations

Generate the production stylesheet on a development, staging, or CI/CD build environment rather than on the production server. Installing Node.js and build tools on production servers introduces unnecessary security risk.

For automated CI/CD pipelines, use `npm ci` instead of `npm install` to ensure reproducible builds. The `npm ci` command installs the exact package versions specified in `package-lock.json`, while `npm install` may upgrade to newer compatible versions.

## Step 1: Generate the Production Stylesheet

Run the Tailwind build command from your theme's `web/tailwind` directory to generate the minified production stylesheet at `web/css/styles.css`:

```
cd app/design/frontend/My/theme/web/tailwind
npm run build
```

Alternatively, use the `--prefix` flag to run the build from the Magento root directory:

```
npm --prefix app/design/frontend/My/theme/web/tailwind run build
```

Build Command History

Hyvä versions 1.1.x used `npm run build-prod`. Current versions use `npm run build`.

## Step 2: Deploy Static Content

Run Magento's static content deployment command to copy the generated stylesheet and other theme assets to the `pub/static` directory. This step copies `web/css/styles.css` to `pub/static/frontend/Your/theme/{locale}/css/styles.css` where browsers can load it in production mode:

```
bin/magento setup:static-content:deploy
```

### Optimizing Static Content Deployment

Hyvä themes do not require LESS compilation, JavaScript bundling, or HTML minification. Disabling these features significantly reduces deployment time. The following example deploys the admin theme only for `en_US`, then deploys the frontend theme for multiple locales with unnecessary processing disabled:

```
# Deploy backend assets for en_US only
bin/magento setup:static-content:deploy -j 2 -f --no-parent --theme=Magento/backend en_US

# Deploy frontend theme for nl_NL and de_DE, skipping LESS and bundling
bin/magento setup:static-content:deploy -j 2 -f --area=frontend --no-parent --no-less --no-js-bundle --no-html-minify --theme=Vendor/theme nl_NL de_DE
```

Experimental: On-the-fly minification

The `hyva-themes/magento2-minification` module minifies HTML, JS, and CSS on the fly with better results than the native Magento minification, rather than during static content deployment. It is currently experimental but can be tested already. For more information, see the module readme.

## Step 3: Transfer Assets to Production

Transfer the `pub/static/` directory to your production server using your deployment method (rsync, SCP, CI/CD pipeline, etc.).

After deployment, visitors will see your updated Hyvä theme with the production-optimized stylesheet.

## Verifying the Deployment

After completing the deployment, verify your Hyvä theme is working correctly:

1. **Clear all caches**: Run `bin/magento cache:flush` on the production server
2. **Check the stylesheet loads**: Open your site and verify `css/styles.css` loads in the browser's Network tab
3. **Verify no 404 errors**: Check the browser console for missing asset errors
4. **Test responsive styles**: Resize the browser to verify Tailwind responsive classes work correctly

If styles appear broken or missing, verify that:

- The `npm run build` command completed without errors
- The `web/css/styles.css` file was generated in your theme directory
- Static content deployment completed successfully
- The correct theme is configured in Magento admin under Content → Design → Configuration

## Troubleshooting Common Issues

| Symptom | Likely Cause | Solution |
| --- | --- | --- |
| Styles completely missing | `styles.css` not generated | Run `npm run build` in theme's `web/tailwind` directory |
| Old styles showing | Browser cache or CDN cache | Clear browser cache, purge CDN/Varnish cache |
| Some Tailwind classes not working | Classes not in source files during build | Ensure all templates are saved, rebuild with `npm run build` |
| 404 for `styles.css` | Static content not deployed | Run `bin/magento setup:static-content:deploy` |
