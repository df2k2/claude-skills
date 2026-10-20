# Vendored INSPINIA Tailwind sources — index

Snapshot of https://webapplayers.com/inspinia/tailwind/ (see `FETCHED.txt`). Re-fetch with
`bash scripts/inspinia/fetch_pages.sh` from the skill root.

Read pages with `python3 -I scripts/inspinia/extract_main.py references/sources/pages/<page>.html` — never cat a page;
~130 KB of each is the shared shell. Each row links the page to the curated reference that explains it.

| Directory | Contents |
|---|---|
| `pages/` | 233 demo pages |
| `assets/js/config.js` | layout/skin config applied before paint |
| `assets/js/app.js` | template runtime: App, Plugins, LayoutCustomizer, I18nManager, CustomApexChart/EChart/ChartJs |
| `assets/js/pages/*.js` | 97 per-page init scripts (minified) |
| `assets/css/app.min.css` | compiled Tailwind v4.3 build with all skins/themes (grep only) |
| `MANIFEST-pages.txt`, `MANIFEST-page-scripts.txt`, `MANIFEST-plugins.txt`, `MANIFEST-page-deps.txt` | inventories; `page-deps` maps page → scripts → plugin libs |

Third-party plugin libraries under `assets/plugins/` are **not** vendored (all on npm/CDN); `MANIFEST-plugins.txt` lists the 52 files the demo loads.


## Dashboards & landing  → `references/dashboards-and-widgets.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `dashboard-analytics.html` | Analytics Dashboard | `custom-table.js` `dashboard-analytics.js` | apexcharts |
| `dashboard-ecommerce.html` | eCommerce Dashboard | `custom-table.js` `dashboard-ecommerce.js` | echarts, jsvectormap |
| `index.html` | Project Dashboard | `dashboard-projects.js` | echarts |
| `landing.html` | One Page Landing |  |  |
| `metrics.html` | Metrics | `metrics.js` | echarts |
| `widgets.html` | Widgets |  |  |

## E-commerce apps  → `references/apps-ecommerce.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `apps-ecommerce-attributes.html` | Attributes | `custom-table.js` |  |
| `apps-ecommerce-cart.html` | Cart |  |  |
| `apps-ecommerce-categories.html` | Categories | `custom-table.js` |  |
| `apps-ecommerce-checkout.html` | Checkout | `form-inputmask.js` | inputmask |
| `apps-ecommerce-customers.html` | Customers | `custom-table.js` |  |
| `apps-ecommerce-marketplace.html` | Marketplace |  |  |
| `apps-ecommerce-order-add.html` | Add/Edit Order |  |  |
| `apps-ecommerce-order-details.html` | Order Details |  |  |
| `apps-ecommerce-orders.html` | Orders | `custom-table.js` |  |
| `apps-ecommerce-product-add.html` | Add Product | `ecommerce-product-add.js` | dropzone, quill |
| `apps-ecommerce-product-details.html` | Product Details | `custom-table.js` |  |
| `apps-ecommerce-product-stocks.html` | Stocks | `custom-table.js` |  |
| `apps-ecommerce-product-views.html` | Product Views | `custom-table.js` `ecommerce-product-views.js` | apexcharts |
| `apps-ecommerce-products-grid.html` | Products Grid | `ecommerce-products.js` | nouislider |
| `apps-ecommerce-products.html` | Products | `custom-table.js` |  |
| `apps-ecommerce-purchased-orders.html` | Purchased Orders | `custom-table.js` |  |
| `apps-ecommerce-refunds.html` | Refunds | `custom-table.js` |  |
| `apps-ecommerce-reviews.html` | Reviews | `custom-table.js` `ecommerce-reviews.js` | apexcharts |
| `apps-ecommerce-sales.html` | Product Stocks | `custom-table.js` `ecommerce-sales.js` | apexcharts |
| `apps-ecommerce-seller-details.html` | Seller Details | `custom-table.js` `ecommerce-seller-details.js` | apexcharts |
| `apps-ecommerce-sellers.html` | Sellers | `custom-table.js` `ecommerce-product-views.js` | apexcharts |
| `apps-ecommerce-settings.html` | Shop Settings |  |  |
| `apps-ecommerce-warehouse.html` | Warehouse | `custom-table.js` |  |

## Productivity apps  → `references/apps-productivity.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `apps-api-keys.html` | API Keys | `custom-table.js` `apps-api-keys.js` | apexcharts, clipboard |
| `apps-blog-add.html` | Create Article | `form-quilljs.js` | quill |
| `apps-blog-article.html` | Article |  |  |
| `apps-blog-grid.html` | Blog Grid | `apps-blog-grid.js` | masonry |
| `apps-blog-list.html` | List |  |  |
| `apps-calendar.html` | Calendar | `apps-calendar.js` | fullcalendar |
| `apps-chat.html` | Chat | `apps-chat.js` |  |
| `apps-clients.html` | Clients | `custom-table.js` |  |
| `apps-companies.html` | Companies |  |  |
| `apps-email-compose.html` | New Email (Compose) | `apps-email-compose.js` | quill |
| `apps-email-details.html` | Email Details |  |  |
| `apps-email-inbox.html` | Inbox (77) | `custom-table.js` `apps-email.js` |  |
| `apps-file-manager.html` | File Manager | `custom-table.js` |  |
| `apps-forum-post.html` | Forum Post |  |  |
| `apps-forum-view.html` | Forum |  |  |
| `apps-invoice-create.html` | Create Invoice | `apps-create-invoice.js` |  |
| `apps-invoice-details.html` | Invoice Details |  |  |
| `apps-invoice-list.html` | Invoices list | `custom-table.js` |  |
| `apps-issue-tracker.html` | Issue List | `custom-table.js` |  |
| `apps-manage.html` | Manage Apps |  |  |
| `apps-outlook.html` | Outlook View | `custom-table.js` |  |
| `apps-pin-board.html` | Pin Board |  |  |
| `apps-projects-activity.html` | Activity Stream |  |  |
| `apps-projects-details.html` | Project Overview |  |  |
| `apps-projects-grid.html` | Projects |  |  |
| `apps-projects-kanban.html` | Kanban | `apps-kanban.js` | sortablejs |
| `apps-projects-list.html` | Projects List | `custom-table.js` |  |
| `apps-projects-team-board.html` | Team Board |  |  |
| `apps-social-feed.html` | Social Feed |  |  |
| `apps-users-contacts.html` | Contacts |  |  |
| `apps-users-permissions.html` | Permissions | `custom-table.js` |  |
| `apps-users-role-details.html` | Role Details | `custom-table.js` |  |
| `apps-users-roles.html` | Roles | `custom-table.js` |  |
| `apps-vote-list.html` | Vote List |  |  |

## Utility pages  → `references/pages-auth-and-errors.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `pages-account-settings.html` | Account Settings |  |  |
| `pages-coming-soon.html` | Coming Soon | `coming-soon.js` |  |
| `pages-empty.html` | Empty |  |  |
| `pages-faq.html` | FAQS |  |  |
| `pages-gallery.html` | Gallery | `pages-gallery.js` | glightbox, muuri, web-animations |
| `pages-pricing.html` | Pricing |  |  |
| `pages-privacy-policy.html` | Privacy Policy |  |  |
| `pages-profile.html` | Profile |  |  |
| `pages-search-results.html` | Search Results |  |  |
| `pages-sitemap.html` | Sitemap |  |  |
| `pages-terms-conditions.html` | Terms & Conditions |  |  |
| `pages-timeline.html` | Timeline |  |  |

## Authentication  → `references/pages-auth-and-errors.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `auth-card-delete-account.html` | Delete Account |  |  |
| `auth-card-lock-screen.html` | Lock Screen |  |  |
| `auth-card-login-pin.html` | Login Pin | `auth-two-factor.js` |  |
| `auth-card-new-pass.html` | New Password | `auth-two-factor.js` `auth-password.js` |  |
| `auth-card-reset-pass.html` | Reset Password |  |  |
| `auth-card-sign-in.html` | Sign In |  |  |
| `auth-card-sign-up.html` | Sign Up | `auth-password.js` |  |
| `auth-card-success-mail.html` | Success Mail |  |  |
| `auth-card-two-factor.html` | Two Factor | `auth-two-factor.js` |  |
| `auth-delete-account.html` | Delete Account |  |  |
| `auth-lock-screen.html` | Lock Screen |  |  |
| `auth-login-pin.html` | Login with Pin | `auth-two-factor.js` |  |
| `auth-new-pass.html` | New Password | `auth-two-factor.js` `auth-password.js` |  |
| `auth-reset-pass.html` | Reset Password |  |  |
| `auth-sign-in.html` | Sign in |  |  |
| `auth-sign-up.html` | Sign up | `auth-password.js` |  |
| `auth-split-delete-account.html` | Delete Account |  |  |
| `auth-split-lock-screen.html` | Lock Screen |  |  |
| `auth-split-login-pin.html` | Login Pin | `auth-two-factor.js` |  |
| `auth-split-new-pass.html` | New Password | `auth-two-factor.js` `auth-password.js` |  |
| `auth-split-reset-pass.html` | Reset Password |  |  |
| `auth-split-sign-in.html` | Sign In |  |  |
| `auth-split-sign-up.html` | Sign up | `auth-password.js` |  |
| `auth-split-success-mail.html` | Success Mail |  |  |
| `auth-split-two-factor.html` | Two Factor | `auth-two-factor.js` |  |
| `auth-success-mail.html` | Success Mail |  |  |
| `auth-two-factor.html` | Two Factor | `auth-two-factor.js` |  |

## Error pages  → `references/pages-auth-and-errors.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `error-400.html` | 400 Error |  |  |
| `error-401.html` | 401 Error |  |  |
| `error-403.html` | 403 Error |  |  |
| `error-404.html` | 404 Error |  |  |
| `error-408.html` | 408 Error |  |  |
| `error-500.html` | 500 Error |  |  |
| `error-maintenance.html` | Maintenance |  |  |

## Layout variants  → `references/layout-and-theming.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `layouts-boxed.html` | Boxed |  |  |
| `layouts-compact.html` | Compact |  |  |
| `layouts-horizontal.html` | Horizontal |  |  |
| `layouts-preloader.html` | Preloader |  |  |
| `layouts-scrollable.html` | Scrollable |  |  |
| `layouts-sidebar-compact.html` | Compact Sidebar |  |  |
| `layouts-sidebar-gradient.html` | Gradient Menu |  |  |
| `layouts-sidebar-gray.html` | Gray Menu |  |  |
| `layouts-sidebar-image.html` | Image Menu |  |  |
| `layouts-sidebar-light.html` | Light Menu |  |  |
| `layouts-sidebar-no-icons.html` | No Icons with Lines |  |  |
| `layouts-sidebar-offcanvas.html` | Offcanvas Menu |  |  |
| `layouts-sidebar-on-hover-active.html` | On Hover Active |  |  |
| `layouts-sidebar-on-hover.html` | On Hover Menu |  |  |
| `layouts-sidebar-with-lines.html` | Sidebar with Lines |  |  |
| `layouts-topbar-dark.html` | Topbar Dark |  |  |
| `layouts-topbar-gradient.html` | Topbar Gradient |  |  |
| `layouts-topbar-gray.html` | Topbar Gray |  |  |

## Base UI  → `references/ui-components.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `ui-accordions.html` | Accordions |  |  |
| `ui-alerts.html` | Alerts |  |  |
| `ui-badges.html` | Badges |  |  |
| `ui-breadcrumb.html` | Breadcrumb |  |  |
| `ui-buttons.html` | Buttons |  |  |
| `ui-cards.html` | Cards |  |  |
| `ui-carousel.html` | Carousel |  |  |
| `ui-collapse.html` | Collapse |  |  |
| `ui-colors.html` | Colors |  |  |
| `ui-dropdowns.html` | Dropdowns |  |  |
| `ui-images.html` | Images |  |  |
| `ui-links.html` | Links |  |  |
| `ui-list-group.html` | List Group |  |  |
| `ui-modals.html` | Modals |  |  |
| `ui-notifications.html` | Notifications |  |  |
| `ui-offcanvas.html` | Offcanvas |  |  |
| `ui-pagination.html` | Pagination |  |  |
| `ui-placeholders.html` | Placeholders |  |  |
| `ui-popovers.html` | Popover |  |  |
| `ui-progress.html` | Progress |  |  |
| `ui-scrollspy.html` | Scrollspy |  |  |
| `ui-spinners.html` | Spinners |  |  |
| `ui-tabs.html` | Tabs |  |  |
| `ui-tooltips.html` | Tooltips |  |  |
| `ui-typography.html` | Typography |  |  |
| `ui-utilities.html` | Utilities |  |  |
| `ui-videos.html` | Videos |  |  |

## Forms  → `references/forms.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `form-elements.html` | Basic Elements |  |  |
| `form-fileuploads.html` | File Upload | `form-fileupload.js` | dropzone, filepond |
| `form-layout.html` | Layouts |  |  |
| `form-other-plugin.html` | Other Plugins | `form-inputmask.js` `form-typehead.js` | handlebars, inputmask, jquery, typeahead |
| `form-pickers.html` | Pickers | `form-date-range-picker.js` `form-colorpickr.js` | daterangepicker, jquery, moment, pickr |
| `form-range-slider.html` | Range Slider | `form-range-slider.js` | nouislider, wnumb |
| `form-select.html` | Select | `form-choice.js` `form-select2.js` | jquery, select2 |
| `form-text-editors.html` | Text Editors | `form-quilljs.js` | quill |
| `form-validation.html` | Validation | `form-validation.js` |  |
| `form-wizard.html` | Form Wizard | `form-wizard.js` |  |

## Tables  → `references/tables-and-datatables.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `tables-custom.html` | Custom Tables | `custom-table.js` |  |
| `tables-datatables-ajax.html` | Ajax | `datatables-ajax.js` | datatables-dt, jquery |
| `tables-datatables-basic.html` | Datatables basic | `datatables-basic.js` | datatables-dt, jquery |
| `tables-datatables-checkbox-select.html` | Checkbox Select | `datatables-checkbox-select.js` | datatables-dt, jquery |
| `tables-datatables-child-rows.html` | Child Row | `datatables-child-rows.js` | datatables-dt, jquery |
| `tables-datatables-column-searching.html` | Column Searching | `datatables-column-search.js` | datatables-dt, jquery |
| `tables-datatables-columns.html` | Show & Hide Columns | `datatables-show-hide-columns.js` | datatables-dt, jquery |
| `tables-datatables-export-data.html` | Export Data | `datatables-export-data.js` | datatables-dt, jquery |
| `tables-datatables-fixed-columns.html` | Fixed Columns | `datatables-fixed-columns.js` | datatables-dt, jquery |
| `tables-datatables-fixed-header.html` | Fixed Header | `datatables-fixed-header.js` | datatables-dt, jquery |
| `tables-datatables-javascript.html` | Javascript Source | `datatables-javascript-source.js` | datatables-dt, jquery |
| `tables-datatables-range-search.html` | Range Search | `datatables-range-search.js` | datatables-dt, jquery |
| `tables-datatables-rendering.html` | Data Rendering | `datatables-rendering.js` | datatables-dt, jquery |
| `tables-datatables-rows-add.html` | Add Rows | `datatables-rows-add.js` | datatables-dt, jquery |
| `tables-datatables-scroll.html` | Datatables Scroll | `datatables-scroll.js` | datatables-dt, jquery |
| `tables-datatables-select.html` | Datatables Select | `datatables-select.js` | datatables-dt, jquery |
| `tables-static.html` | Static Tables |  |  |

## Charts & maps  → `references/charts-and-maps.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `charts-apex-area.html` | Area Apexchart | `chart-apex-area.js` | apexcharts, moment |
| `charts-apex-bar.html` | Bar Apexchart | `chart-apex-bar.js` | apexcharts |
| `charts-apex-boxplot.html` | Boxplot Apexchart | `chart-apex-boxplot.js` | apexcharts |
| `charts-apex-bubble.html` | Bubble Apexchart | `chart-apex-bubble.js` | apexcharts |
| `charts-apex-candlestick.html` | Candlestick Apexchart | `chart-apex-candlestick.js` | apexcharts |
| `charts-apex-column.html` | Column Apexchart | `chart-apex-column.js` | apexcharts |
| `charts-apex-funnel.html` | Funnel Apexcharts | `chart-apex-funnel.js` | apexcharts, moment |
| `charts-apex-heatmap.html` | Heatmap Apexchart | `chart-apex-heatmap.js` | apexcharts |
| `charts-apex-line.html` | Line Apexchart | `chart-apex-line.js` | apexcharts |
| `charts-apex-mixed.html` | Mixed Apexchart | `chart-apex-mixed.js` | apexcharts |
| `charts-apex-pie.html` | Pie Apexchart | `chart-apex-pie.js` | apexcharts |
| `charts-apex-polar-area.html` | Polar Area Apexchart | `chart-apex-polar-area.js` | apexcharts |
| `charts-apex-radar.html` | Radar Apexchart | `chart-apex-radar.js` | apexcharts |
| `charts-apex-radialbar.html` | RadialBar Apexchart | `chart-apex-radialbar.js` | apexcharts |
| `charts-apex-range.html` | Range Apexcharts | `chart-apex-range.js` | apexcharts, moment |
| `charts-apex-scatter.html` | Scatter Apexchart | `chart-apex-scatter.js` | apexcharts |
| `charts-apex-slope.html` | Slope Apexcharts | `chart-apex-slope.js` | apexcharts, moment |
| `charts-apex-sparklines.html` | Sparkline Apexcharts | `chart-apex-sparklines.js` | apexcharts |
| `charts-apex-timeline.html` | Timeline Apexchart | `chart-apex-timeline.js` | apexcharts, moment |
| `charts-apex-treemap.html` | Treemap Apexchart | `chart-apex-treemap.js` | apexcharts |
| `charts-echart-area.html` | Area Echart | `chart-echart-area.js` | echarts |
| `charts-echart-bar.html` | Bar Echart | `chart-echart-bar.js` | echarts |
| `charts-echart-candlestick.html` | Candlestick Echart | `chart-echart-candlestick.js` | echarts |
| `charts-echart-gauge.html` | Gauge Echart | `chart-echart-gauge.js` | echarts |
| `charts-echart-geo-map.html` | GEO Maps | `chart-echart-geo-map.js` | echarts |
| `charts-echart-heatmap.html` | Heatmap Echart | `chart-echart-heatmap.js` | echarts |
| `charts-echart-line.html` | Line Echart | `chart-echart-line.js` | echarts |
| `charts-echart-other.html` | Other Echart | `chart-echart-other.js` | echarts |
| `charts-echart-pie.html` | Pie Echart | `chart-echart-pie.js` | echarts |
| `charts-echart-radar.html` | Radar Echart | `chart-echart-radar.js` | echarts |
| `charts-echart-scatter.html` | Scatter Echart | `chart-echart-scatter.js` | echarts |
| `maps-google.html` | Google |  |  |
| `maps-leaflet.html` | Leaflet Maps | `maps-leaflet.js` | leaflet |
| `maps-vector.html` | Vector Maps | `maps-vector.js` | jsvectormap |

## Plugins & icons  → `references/plugins-and-icons.md`

| Page | Title | Page script | Plugin libs |
|---|---|---|---|
| `icons-flags.html` | Flags | `flags-listing.js` |  |
| `icons-lucide.html` | Lucide |  |  |
| `icons-tabler.html` | Tabler |  |  |
| `plugins-animation.html` | Animation | `plugins-animation.js` |  |
| `plugins-clipboard.html` | Clipboard | `plugins-clipboard.js` | clipboard |
| `plugins-i18.html` | i18 Support |  |  |
| `plugins-idle-timer.html` | Idle Timer | `plugins-idle-timer.js` |  |
| `plugins-live-favicon.html` | Live Favicon | `plugins-tinycon.js` | tinycon |
| `plugins-loading-buttons.html` | Loading Buttons | `plugins-loading-button.js` | jquery, ladda |
| `plugins-masonry.html` | Masonry | `plugins-masonry.js` | masonry |
| `plugins-pass-meter.html` | Password Meter | `plugins-pass-meter.js` |  |
| `plugins-pdf-viewer.html` | PDF Viewer | `plugins-pdf-viewer.js` | pdfjs |
| `plugins-sortable.html` | Sortable | `plugins-nestable.js` | sortablejs |
| `plugins-sweet-alerts.html` | SweetAlert2 | `plugins-sweetalerts.js` | sweetalert2 |
| `plugins-text-diff.html` | Text Diff | `plugins-text-diff.js` | diff |
| `plugins-tour.html` | Tour | `plugins-tour.js` | tourguidejs |
| `plugins-tree-view.html` | Tree View | `plugins-treeview.js` | jquery, jstree |
| `plugins-video-player.html` | Video Player | `plugins-plyr.js` | plyr |
