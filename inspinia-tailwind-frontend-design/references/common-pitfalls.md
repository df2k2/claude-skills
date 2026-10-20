# Common pitfalls when building with INSPINIA Tailwind

Things that go wrong when an agent (or a developer coming from Bootstrap Inspinia / Luma / Hyvä) builds
on this template. Each entry: symptom → cause → fix.

## Stack confusion

| Symptom | Cause | Fix |
|---|---|---|
| `data-bs-toggle="modal"` / `data-bs-dismiss` does nothing | This is the **Tailwind** edition: no Bootstrap JS. The `<title>` still says "Bootstrap 5" but the markup is Preline. | Use Preline: `data-hs-overlay="#id"` (same attribute on open *and* close buttons), `data-hs-collapse`, `data-hs-tab`, `.hs-dropdown`. See design-system.md → "Interactive behaviour". |
| `x-data` / `@click` / Alpine idioms | No Alpine.js in the bundle. | Preline for state; plain JS or a page script in `assets/js/pages/` for logic. |
| `$('#el').modal('show')` | jQuery is not in `vendors.min.js`; the demo loads it per page only for DataTables / select2 / jsTree / Ladda. No Bootstrap jQuery plugins exist. | `HSOverlay.open(document.querySelector('#id'))` (Preline static API). |
| `tailwind.config.js` edits have no effect | Tailwind **v4**: configuration is CSS-first (`@theme`, `@utility`, `@source`). There is no JS config in the compiled demo. | Override tokens in your own CSS: `:root { --color-primary: #…; }` or `html[data-skin=mine] { … }`. |
| `bg-opacity-50`, `flex-shrink-0`, `overflow-ellipsis` | Tailwind v3 names. | v4: `bg-primary/50`, `shrink-0`, `text-ellipsis`. Arbitrary vars: `bg-(--sidenav-bg)` not `bg-[var(--sidenav-bg)]`. `!` goes at the **end**: `px-2.5!`. |
| `<i class="ti ti-home">` or `<i class="fa fa-home">` renders nothing | Icons are Iconify-Tailwind classes. | `<i class="iconify tabler--home"></i>` (double dash). Check the name exists in `icons-tabler.html`. |
| Icon shows as an empty square | The icon name is not among the 229 Tabler / 52 Lucide names compiled into `app.min.css` (Iconify Tailwind plugin only emits what the demo source used). | Pick a compiled name (lists in plugins-and-icons.md), rebuild the CSS with your names, or inline the SVG. |
| `$ is not defined` / `DataTable is not a constructor` | jQuery is **not** in `vendors.min.js`. | Load `assets/plugins/jquery/jquery.min.js` before DataTables / select2 / jsTree / Ladda, as the demo pages do. |
| `.avatar-sm`, `.btn-primary`, `.text-muted`, `.bg-soft-primary`, `.card-shadow` | Bootstrap-edition class names; not defined here. | Buttons: `btn bg-primary text-white hover:bg-primary-hover`. Soft: `bg-primary/10 text-primary`. Muted: `text-default-400`. Avatars: `size-9 rounded-full`. |

## Layout / shell

| Symptom | Cause | Fix |
|---|---|---|
| Flash of wrong theme/sidebar on load | `config.js` not in `<head>` (or loaded `defer`). | `<script src="assets/js/config.js"></script>` synchronous in `<head>`, before the stylesheet is applied is fine, but it must run before paint. |
| Sidebar menu never highlights the current page | `initSidenav()` compares `a.href` to `location.href` minus `?`/`#`. Links with query strings, trailing slashes or absolute vs relative mismatch fail. | Make hrefs match the real URL, or add `.active` to `.menu-item` and `.menu-link` server-side and open the ancestor `.hs-accordion` (`.active` + remove `hidden` on `.hs-accordion-content`). |
| Sidebar is condensed on a 1100 px laptop | `config.js` forces `condensed` ≤ 1140 px and `offcanvas` ≤ 767 px. | By design. Override by editing that breakpoint logic in config.js if needed. |
| Page content hidden under the sidebar | Missing `.page-content` wrapper (it carries `margin-inline-start: var(--sidenav-width)`). | Keep the `wrapper > header + aside + .page-content > main + footer` structure. |
| Dropdown panel clipped inside a card/table | Preline dropdown is absolutely positioned inside an `overflow-hidden` ancestor. | Add `[--strategy:fixed]` on `.hs-dropdown`, or remove `overflow-hidden` from the ancestor. |
| Modal opens but nothing is visible | Panel lacks `hs-overlay-open:` transition classes or is missing `hidden` initially; or the id has a typo. | Copy the modal skeleton from ui-components.md verbatim (`hs-overlay hidden … hs-overlay-open:opacity-100 hs-overlay-open:mt-7 …`). |
| Components injected via fetch/AJAX don't work | Preline initialises once on `DOMContentLoaded`. | After inserting markup: `window.HSStaticMethods.autoInit()`. For DataTables/Choices/flatpickr re-run their inits on the new nodes. |
| Horizontal layout still shows the sidebar | You added `data-layout="horizontal"` but kept `aside#app-menu`. | Remove the aside and add the `.topnav` block (layout-and-theming.md). |

## Theming / dark mode / RTL

| Symptom | Cause | Fix |
|---|---|---|
| White boxes in dark mode | Hard-coded `bg-white`, `text-black`, `border-gray-200`. | `bg-card`, `text-dark`, `border-default-300` — the tokens flip. |
| Logo invisible in dark mode | Single logo image. | Two images: `class="flex dark:hidden"` + `class="hidden dark:flex"`; sidebar uses `.logo-light` / `.logo-dark` spans. |
| Chart colours don't change with skin / dark mode | Chart created with raw `new ApexCharts()` and literal hex colours. | Register through `new CustomApexChart({selector, options})` and pass colours as `data-colors="primary,secondary,alpha"` on the element (resolved from CSS vars; re-rendered by the MutationObserver). See charts-and-maps.md. |
| Apex tooltip/axis `formatter` or `events` silently ignored | `CustomApexChart.render()` deep-clones options with `JSON.parse(JSON.stringify())`, which drops functions. | Keep formatters out of the wrapper (use `CustomEChart`, or `new ApexCharts()` + your own re-render on the `data-theme` MutationObserver). Also note demo scripts call `theme("chart-order-color")` / `theme("bg-card")` — typos that resolve to `""`; the real tokens are `chart-border-color` and `card`. |
| Vector map (jsVectorMap) keeps light colours in dark mode | The demo's map observer watches `data-bs-theme` (Bootstrap leftover), not `data-theme`. | Re-create the map inside your own `MutationObserver` on `data-theme`/`data-skin`, or patch the observer attribute. |
| Modal / password toggle / year stamp dead on an auth or error page | Those 36 pages load only `config.js` + a page script — no `vendors.min.js`, no `app.js`. | Add both scripts if you need Preline or app.js hooks there, or keep them static. |
| ECharts canvas overflows after sidebar collapse | Not registered → no resize hook. | Use `CustomEChart` (it listens for `data-sidenav-size` changes) or call `chart.resize()` yourself. |
| Chevrons point the wrong way in RTL | Physical rotation classes. | `rtl:rotate-180` on directional icons; use `ms-/me-/ps-/pe-/start-/end-` instead of `ml-/mr-/left-/right-`. |
| Fonts don't load behind a CSP / offline | Skins `@import` Google Fonts from inside `app.min.css`. | Self-host the font and set `--font-body` / `--font-secondary` in your CSS override. |
| Customizer choices "stick" between pages/users | `sessionStorage.__THEME_CONFIG__` wins over `<html>` attributes after first change. | In production remove the customizer, or clear the key when rendering server-side preferences; `config.js` also honours `?data-theme=dark`-style query params. |

## Forms, tables, data

| Symptom | Cause | Fix |
|---|---|---|
| Date input is a plain text box | Forgot `data-provider="flatpickr"` (app.js `Plugins.initFlatPicker` is attribute-driven). | Add the attribute + `data-date-format="Y-m-d"` etc. (see layout-and-theming.md hook table or forms.md). |
| `custom-table.js` search/pagination inert | Page didn't load `assets/js/pages/custom-table.js`, or the table lacks the selectors it looks for. | Load the script after app.js; follow the wrapper/selector contract in tables-and-datatables.md. |
| DataTables styling looks unthemed | Loaded DataTables' own CSS, or used DataTables' default `dom`/class names instead of the template's. | Don't load dt CSS; app.min.css already styles the `dt-*` output — copy the `<table>` skeleton, `dom` string and shared language block from a `tables-datatables-*.html` page script (tables-and-datatables.md). |
| Export buttons (CSV/Excel/PDF) missing | Needs `dataTables.buttons`, `buttons.html5`, `jszip`, `pdfmake`, `vfs_fonts` in that order. | Copy the script list from `tables-datatables-export-data.html` (MANIFEST-page-deps.txt). |
| Quill editor toolbar unstyled / icons missing | Quill CSS not loaded; the demo relies on app.min.css overrides + `assets/plugins/quill/quill.js`. | Copy from `form-text-editors.html`; keep the `#snow-editor` / `#bubble-editor` container structure. |
| Choices.js select renders inside a 0-height box | Initialised before the element was visible (inside a hidden tab/modal). | Init on tab/modal open, or init all then call `choices.refresh()`; same for ApexCharts in hidden tabs (render on `hs-tab` show). |
| `<select class="form-select">` plus Choices = double arrow | Both the Tailwind forms background-image and Choices chrome. | Use the demo's wrapper markup (`data-choices` attributes) from form-select.md — it removes the native arrow. |

## Assets / production

| Symptom | Cause | Fix |
|---|---|---|
| 404s for `assets/images/users/user-1.jpg` etc. | Demo images are not vendored in this skill (only pages, CSS, JS). | Use your own images; the demo paths tell you the expected aspect ratios (users: square; products: 4:3/square; layouts previews: 16:10). |
| Translations warn `Missing translation for key` | `assets/data/translations/*.json` is not in the public demo. | Create the JSON (dotted keys) or remove `data-lang` attributes. |
| Google Maps page blank | Needs an API key; the demo uses a placeholder. | Supply `key=` in the Maps script URL; prefer Leaflet (no key) unless you need Google-specific features. |
| Charts pages pull `apexcharts.com/samples/...` or `cdn.jsdelivr.net/npm/echarts/map/js/world.js` | Demo sample data / world map loaded from CDN. | Self-host the world map JSON and generate your own data. |
| Huge page weight | Every demo page carries the full sidebar (233 links), mega menus, customizer, and demo dropdown data. | Trim the sidebar to your IA, drop the customizer, lazy-load dropdown lists. |

## Original sources

- `references/sources/assets/js/config.js`, `references/sources/assets/js/app.js`
- `references/sources/pages/index.html`, `ui-modals.html`, `ui-dropdowns.html`, `form-pickers.html`, `tables-datatables-export-data.html`
