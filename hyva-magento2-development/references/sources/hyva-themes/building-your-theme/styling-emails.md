<!-- source: https://docs.hyva.io/hyva-themes/building-your-theme/styling-emails.html -->

# Styling Emails

Hyvä does not apply styles to Magento's transactional emails by default. To add email styling, use the `hyva-themes/magento2-email-module` package, which is automatically installed as a dependency of `hyva-themes/magento2-default-theme`.

The `hyva-themes/magento2-email-module` reactivates Luma's CSS functionality specifically for emails in Hyvä-based themes. It does not switch your storefront to Luma—only the email rendering uses it.

Note

This is different from the **luma-checkout** or **theme-fallback** modules, which replace the full Hyvä theme with Luma. The email module only affects email styling.

## Preparing Custom Email Styling

To apply custom email styles in a Hyvä theme, copy the following LESS files from the email module into your active theme.

Copy these files to `web/css/` in your theme:

- `vendor/hyva-themes/magento2-email-module/src/view/frontend/web/css/email.less`

Copy these files to `web/css/source/` in your theme:

- `vendor/hyva-themes/magento2-email-module/src/view/frontend/web/css/source/_email-extend.less`
- `vendor/hyva-themes/magento2-email-module/src/view/frontend/web/css/source/_email-variables.less`

For sales-specific emails to pick up styling, also copy these files to `Magento_Sales/web/css/source/` in your theme:

- `vendor/magento/theme-frontend-luma/Magento_Sales/web/css/source/_email.less`
- `vendor/magento/theme-frontend-luma/Magento_Sales/web/css/source/_module.less`

Using Tailwind CSS for email styles

If you prefer to write email styles using Tailwind utility classes, see [Generating Email Styles with Tailwind CSS](../advanced-topics/styling-emails-with-tailwind.html).

## Customizing the Email Header

To customize the email header, add a `Magento_Email/email/header.html` template to your Hyvä theme. Magento picks this up automatically via the standard template override mechanism.

For reference, here is the default `header.html` from the `Magento_Email` module:

```
<!--@subject {{trans "Header"}} @-->
<!--@vars {
"var logo_url":"Email Logo Image URL",
"var logo_alt":"Email Logo Alt Text",
"var logo_height":"Email Logo Image Height",
"var logo_width":"Email Logo Image Width",
"var template_styles|raw":"Template CSS"
} @-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="initial-scale=1.0, width=device-width" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <style type="text/css">
        {{var template_styles|raw}}

        {{css file="css/email.css"}}
    </style>
</head>
<body>
{{inlinecss file="css/email-inline.css"}}

<!-- Begin wrapper table -->
<table class="wrapper" width="100%">
    <tr>
        <td class="wrapper-inner" align="center">
            <table class="main" align="center">
                <tr>
                    <td class="header">
                        <a class="logo" href="{{store url=""}}">
                            <img
                                {{if logo_width}}
                                    width="{{var logo_width}}"
                                {{else}}
                                    width="180"
                                {{/if}}

                                {{if logo_height}}
                                    height="{{var logo_height}}"
                                {{/if}}

                                src="{{var logo_url}}"
                                alt="{{var logo_alt}}"
                                border="0"
                            >
                        </a>
                    </td>
                </tr>
                <tr>
                    <td class="main-content">
                    <!-- Begin Content -->
```

To use a custom logo image for emails, place it at `Magento_Email/web/logo_email.png` in your theme. The default logo is at `vendor/magento/module-email/view/frontend/web/logo_email.png`.

## Customizing the Email Footer

To add a custom footer, add a `Magento_Email/email/footer.html` template to your Hyvä theme.

For reference, here is the `footer.html` from the Luma theme:

```
<!--@subject {{trans "Footer"}} @-->
<!--@vars {
"var store.frontend_name":"Store Name",
"var url_about_us":"About Us URL",
"var url_customer_service":"Customer Service URL",
"var store_phone":"Store Phone",
"var store_hours":"Store Hours",
"var store.formatted_address|raw":"Store Address"
} @-->

                    <!-- End Content -->
                    </td>
                </tr>
                <tr>
                    <td class="footer">
                        <table>
                            <tr>
                                <td>
                                    {{depend url_about_us}}
                                    <p>
                                        {{trans '<a href=%url_about_us>About Us</a>' url_about_us=$url_about_us |raw}}
                                    </p>
                                    {{/depend}}
                                    {{depend url_customer_service}}
                                    <p>
                                        {{trans '<a href=url_customer_service>Customer Service</a>' url_customer_service=$url_customer_service |raw}}
                                    </p>
                                    {{/depend}}
                                </td>
                                <td>
                                    {{depend store_phone}}
                                        <p class="phone">
                                            {{trans '<a href="tel:%store_phone">%store_phone</a>' store_phone=$store_phone |raw}}
                                        </p>
                                    {{/depend}}
                                    {{depend store_hours}}
                                        <p class="hours">
                                            {{trans 'Hours of Operation:<br /><span class="no-link">%store_hours</span>.' store_hours=$store_hours |raw}}
                                        </p>
                                    {{/depend}}
                                </td>
                                <td>
                                    <p class="address">
                                        {{var store.formatted_address|raw}}
                                    </p>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<!-- End wrapper table -->
</body>
```
