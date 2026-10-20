# Layout shell, navigation, and the `data-*` theme configuration

Every admin page is the same shell: a fixed topbar, a left sidenav, a `.page-content` column holding
`<main>` and `<footer>`, plus the slide-in theme customizer. Layout *variants* (horizontal nav, boxed,
compact sidebar, dark topbar, RTL, …) are **not different templates** — they are attributes on `<html>`
that `assets/js/config.js` reads before first paint and `assets/js/app.js` (`LayoutCustomizer`) can change
at runtime. Build one shell, switch variants with attributes.

## Quick reference

| Need | Do |
|---|---|
| New blank admin page | copy `references/sources/pages/pages-empty.html`; replace `<main>` content |
| Page header with breadcrumb | `.page-title-head` block (below) |
| Horizontal top menu instead of sidebar | `<html data-layout="horizontal">` + `.topnav` markup from `layouts-horizontal.html` |
| Collapsed icon-only sidebar | `data-sidenav-size="condensed"` (expands on hover: `on-hover`; `on-hover-active` = hover + pinned open) |
| Narrow sidebar with text | `data-sidenav-size="compact"` (190 px) |
| Mobile-style drawer sidebar on desktop | `data-sidenav-size="offcanvas"` |
| Hide sidebar entirely | `data-sidenav-size="hidden"` |
| Sidebar colour | `data-menu-color="light|dark|gray|gradient|image"` |
| Topbar colour | `data-topbar-color="light|dark|gray|gradient"` |
| Boxed (max-width) layout | `data-layout-width="boxed"` |
| Non-sticky header/sidebar | `data-layout-position="scrollable"` |
| Dark mode | `data-theme="dark"` (or `system`) |
| Skin | `data-skin="saas"` (see design-system.md) |
| RTL | `dir="rtl"` — markup already uses logical utilities |
| Hide the user card at the top of the sidebar | omit `data-sidenav-user` (presence = show) |
| Full-page preloader | `<html data-layout="preloader">` + spinner div from `layouts-preloader.html` |
| Dashed guide lines in sub-menus / no menu icons | `<html class="sidebar-with-line">` / `class="sidebar-no-icons sidebar-with-line"` |
| Auth / error / landing page (no shell) | see pages-auth-and-errors.md — plain `<body>` with centered container |

## The page skeleton

```html
<!DOCTYPE html>
<html lang="en">                       <!-- data-skin / data-theme / data-sidenav-size / … go here -->
<head>
  <meta charset="utf-8" />
  <title>Orders | My App</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="shortcut icon" href="assets/images/favicon.ico" />
  <link href="assets/css/app.min.css" rel="stylesheet" type="text/css">
  <script src="assets/js/config.js"></script>     <!-- MUST be in <head>: applies layout attrs before paint -->
</head>
<body>
  <div class="wrapper">
    <header class="app-header"> … topbar … </header>        <!-- see "Topbar" -->
    <aside id="app-menu" class="app-menu"> … sidenav … </aside>   <!-- see "Sidenav" -->
    <div class="page-content">
      <main>
        <!-- Page Title -->
        <div class="page-title-head">
          <h4 class="page-main-title">Orders</h4>
          <div class="hidden items-center gap-1.25 text-sm md:flex">
            <a href="#" class="text-sm">Inspinia</a>
            <i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i>
            <a href="#" class="text-sm">Ecommerce</a>
            <i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i>
            <a href="#" class="text-default-400 text-sm" aria-current="page">Orders</a>
          </div>
        </div>
        <div class="container-fluid">            <!-- or .container for narrow reading-width pages -->
          <div class="grid grid-cols-1 xl:grid-cols-3 gap-base">
            <div class="card xl:col-span-2"> … </div>
            <div class="card"> … </div>
          </div>
        </div>
      </main>
      <footer class="footer">
        <div class="container-fluid">
          <div class="flex flex-wrap items-center">
            <div class="w-full md:w-1/2 text-center md:text-left">© <span data-current-year></span> Inspinia By <span class="font-semibold">WebAppLayers</span></div>
            <div class="w-full md:w-1/2"><div class="hidden md:block md:text-right">10GB of <span class="font-bold">250GB</span> Free.</div></div>
          </div>
        </div>
      </footer>
    </div>
  </div>

  <!-- Theme customizer (optional in production; the demo includes it on every page) -->
  <div id="theme-customization" class="hs-overlay hs-overlay-open:translate-x-0 bg-card hs-overlay-open:flex fixed inset-y-0 end-0 bottom-0 z-80 hidden w-full max-w-[400px] translate-x-full transform flex-col overflow-hidden transition-all duration-300 rtl:-translate-x-full"> … </div>

  <script src="assets/js/vendors.min.js"></script>   <!-- Preline, SimpleBar, flatpickr, Choices.js (jQuery & co. are per-page plugins) -->
  <script src="assets/js/app.js"></script>           <!-- App, Plugins, LayoutCustomizer, I18nManager, CustomApexChart/EChart -->
  <script src="assets/plugins/apexcharts/apexcharts.min.js"></script>   <!-- only what the page needs; jQuery (assets/plugins/jquery/) first if DataTables/select2/jsTree/Ladda -->
  <script src="assets/js/pages/orders.js"></script>  <!-- page init -->
</body>
</html>
```

Rules the demo follows everywhere:

- `config.js` in `<head>`, synchronous. It reads the `data-*` attributes on `<html>`, merges
  `sessionStorage.__THEME_CONFIG__` and `?data-skin=…`-style query params, applies the skin preset, and
  writes the final attributes back. Missing it = flash of wrong layout + broken customizer.
- Script order at the end of `<body>`: `vendors.min.js` → `app.js` → plugin libs → page script.
- `data-current-year` spans are filled by app.js — only on pages that load it. The 36 chrome-less pages (auth-*, error-*,
  pages-coming-soon, maps-google) load **only `config.js` + their page script**, so Preline, app.js hooks and the year stamp
  are absent there (see pages-auth-and-errors.md).
- Scroll containers use SimpleBar: `<div class="size-full" data-simplebar>` (sidenav, dropdown lists, chat).
- `page-title-head` is the only place `h4.page-main-title` is used; card titles are `h4.card-title`.
- Content width: `container-fluid` for app pages (full width), `container` for docs-style/base-UI pages (Tailwind's responsive container: max-width = current breakpoint).

## Sidenav (`aside#app-menu.app-menu`)

```html
<aside id="app-menu" class="app-menu">
  <a href="index.html" class="logo-box">
    <span class="logo logo-light"><span class="logo-lg"><img src="assets/images/logo.png" alt="logo"></span><span class="logo-sm"><img src="assets/images/logo-sm.png" alt="small logo"></span></span>
    <span class="logo logo-dark"><span class="logo-lg"><img src="assets/images/logo-black.png" alt="dark logo"></span><span class="logo-sm"><img src="assets/images/logo-sm.png" alt="small logo"></span></span>
  </a>
  <div class="h-topbar justify absolute end-5 top-0 flex items-center">
    <button id="button-hover-toggle"><span class="btn-on-hover-icon"></span></button>   <!-- pin/unpin in on-hover mode -->
  </div>
  <div class="relative min-h-0 grow">
    <div class="size-full" data-simplebar="">
      <div id="user-profile-settings" class="sidenav-user p-5 bg-[url(../images/user-bg-pattern.svg)]"> … avatar, name, role, settings dropdown … </div>  <!-- shown only when html[data-sidenav-user] -->
      <ul class="side-nav hs-accordion-group px-2.5 pb-16.5">
        <li class="menu-title" data-lang="main"><span>Main</span></li>

        <!-- item with sub-menu (Preline accordion) -->
        <li class="menu-item hs-accordion">
          <a href="javascript:void(0)" aria-expanded="false" aria-controls="dashboards" class="hs-accordion-toggle menu-link">
            <span class="menu-icon"><i class="iconify tabler--dashboard"></i></span>
            <span class="menu-text" data-lang="dashboards">Dashboards</span>
            <span class="menu-arrow"></span>
          </a>
          <ul class="sub-menu hs-accordion-content hs-accordion-group hidden">
            <li class="menu-item"><a href="dashboard-ecommerce.html" class="menu-link"><span class="menu-text">Ecommerce</span></a></li>
            <!-- nested third level = another li.menu-item.hs-accordion inside -->
          </ul>
        </li>

        <!-- plain item -->
        <li class="menu-item">
          <a href="apps-file-manager.html" class="menu-link">
            <span class="menu-icon"><i class="iconify tabler--folder-open"></i></span>
            <span class="menu-text">File Manager</span>
          </a>
        </li>
      </ul>
    </div>
  </div>
</aside>
```

- app.js `initSidenav()` marks the `<a>` whose `href` equals the current URL as `.active`, opens every
  ancestor `.hs-accordion`, and smooth-scrolls it into view. So: **real hrefs, no trailing `?`/`#`** on the
  link that should light up, or set `.active` server-side.
- Badges in menu items: append `<span class="badge bg-danger/10 text-danger ms-auto">Hot</span>` after `menu-text`.
- `menu-title` rows are section labels (`Main`, `Apps`, `Components`, `Layouts`, …).
- Sidebar palette comes from `data-menu-color`. `dark` (#23303c) is the default preset; `light` (white),
  `gray` (#f1f2f7), `gradient` (navy gradient), `image` (gradient over `assets/images/sidenav-bg.jpg`).

### Sidenav sizes (`data-sidenav-size`)

| Value | Width | Behaviour |
|---|---|---|
| `default` | 235 px | full menu with icons + text |
| `compact` | 190 px | same, tighter; hides user-card icon |
| `condensed` | 75 px | icons only; sub-menus fly out on hover; `logo-sm` shown |
| `sm` | 75 px | like condensed (used internally) |
| `on-hover` | 75 → 235 px | condensed until hovered, then expands; `#button-hover-toggle` pins it |
| `on-hover-active` | 235 px | the pinned-open state of `on-hover` (hides `#button-toggle-menu`) |
| `offcanvas` | 0 | drawer; `#button-toggle-menu` slides it in with a backdrop |
| `hidden` | 0 | removed from flow, no toggle |

`config.js` forces `offcanvas` under 768 px and `condensed` under 1141 px (unless already offcanvas), so you
only choose the desktop behaviour.

## Topbar (`header.app-header`)

Left → right in the demo: logo (`.logo-topbar`, visible when sidebar is condensed/offcanvas),
`#button-toggle-menu` (sidenav toggle, `.sidenav-toggle-button btn btn-icon`), the horizontal-menu
collapse button (`#topnav-menu-collapse`, only for `data-layout="horizontal"`), `#search-box`
(`input#topbar-search.form-input` inside `.input-icon-group`), two **mega menus** (`#megamenu-header`,
`#megamenu-apps`: `hs-dropdown` with `.hs-dropdown-menu.p-0.md:min-w-3xl` and a 3-column grid of
`.megamenu-list`), then the right cluster of `.topbar-item`s:

| Item | Id / hook | Notes |
|---|---|---|
| Light/dark toggle | `#theme-toggler > #light-dark-mode` | handled by LayoutCustomizer |
| Apps grid dropdown | `#apps-dropdown-rounded` | `.hs-dropdown-menu.w-80.p-3` with 3×2 icon tiles |
| Messages dropdown | `#simple-messages-dropdown` | items `#message-N` removable via `data-hs-remove-element="#message-N"` (`hs-removing:` classes animate out) |
| Notifications dropdown | `#notification-dropdown-alert` | same pattern, `#notification-N` |
| Fullscreen | `#fullscreen-toggler [data-toggle="fullscreen"]` | app.js `initFullScreen` |
| Monochrome | `#monochrome-toggler > #monochrome-mode` | adds `.monochrome` to `<html>` (grayscale overlay) |
| Customizer | `.btn-theme-setting [data-hs-overlay="#theme-customization"]` | opens the right-hand panel |
| Language | `#language-selector` | `<a class="dropdown-item" data-translator-lang="de"><img data-translator-image …>` → `I18nManager` |
| User menu | `#simple-user-dropdown` | `.hs-dropdown-menu.min-w-48` with `dropdown-item`s + `dropdown-divider` |

Dropdowns in the topbar use `[--auto-close:inside] [--placement:bottom-right]` so clicks inside the panel
don't close it. Lists inside use `data-simplebar` with an inline `max-height`.

## Horizontal layout (`data-layout="horizontal"`)

`layouts-horizontal.html` drops `aside#app-menu` entirely and adds, inside/after the header, a
`div.topnav.top-topbar-height.fixed.z-30.flex.w-full.items-center.border-b.bg-(--sidenav-bg)` containing
`#topnav-menu` (a `.hs-collapse` on small screens) with `ul.navbar-nav > li.nav-item > a.nav-link` and
`hs-dropdown` sub-menus. The topnav takes the sidebar colour variables (`--sidenav-bg`), so
`data-menu-color` still themes it. Use it for apps with ≤ 8 top-level sections or when horizontal
space matters (wide tables, kanban).

## Other layout pages

| Page | What it demonstrates | How |
|---|---|---|
| `layouts-scrollable.html` | topbar + sidebar scroll with the page | `data-layout-position="scrollable"` |
| `layouts-compact.html` | tighter spacing | same shell; body content uses smaller gaps (no html attr) |
| `layouts-boxed.html` | centred max-width app | `data-layout-width="boxed" data-sidenav-size="on-hover"` |
| `layouts-preloader.html` | spinner overlay until load | `data-layout="preloader"` + `<div class="fixed inset-0 z-50 flex items-center justify-center bg-white animate-[preloader_1s_ease_forwards]"><div class="size-8 animate-spin rounded-full border-3 border-primary border-t-transparent"></div></div>` as first child of `<body>` |
| `layouts-sidebar-light.html`, `layouts-sidebar-gradient.html`, `layouts-sidebar-gray.html`, `layouts-sidebar-image.html` | each `data-menu-color` value | `data-menu-color="light|gradient|gray|image"` |
| `layouts-sidebar-compact.html`, `layouts-sidebar-on-hover.html`, `layouts-sidebar-on-hover-active.html`, `layouts-sidebar-offcanvas.html` | each `data-sidenav-size` value | `data-sidenav-size="compact|on-hover|on-hover-active|offcanvas"` |
| `layouts-sidebar-with-lines.html` / `layouts-sidebar-no-icons.html` | dashed tree lines in sub-menus; icon-less menu | `class="sidebar-with-line"` / `class="sidebar-no-icons sidebar-with-line"` on `<html>` |
| `layouts-topbar-dark.html`, `layouts-topbar-gray.html`, `layouts-topbar-gradient.html` | each `data-topbar-color` value | `data-topbar-color="dark|gray|gradient"` |

## The theme customizer (`#theme-customization`)

A Preline `hs-overlay` panel (right side, 400 px) with radio groups whose `name` equals the html
attribute and whose `value` is the attribute value: `data-skin` (11 skins with preview images),
`dir` (ltr/rtl), `data-sidenav-size` (default/compact/condensed/on-hover/on-hover-active/offcanvas),
`data-theme` (light/dark/system), `data-menu-color` (light/dark/gradient/gray/image),
`data-topbar-color` (light/dark/gradient/gray), `data-layout-width` (fluid/boxed),
`data-layout-position` (fixed/scrollable), plus a `#sidebaruser-check` switch for the user card and
Reset / Buy buttons. `LayoutCustomizer.initSwitchListener()` binds them; state persists in
`sessionStorage.__THEME_CONFIG__`. You can delete the panel in production and keep setting attributes
on `<html>` server-side (or per user, via a tiny inline script before `config.js`).

Programmatic API (after app.js loads): the `LayoutCustomizer` instance is created in the
`DOMContentLoaded` handler and not exposed globally; the simplest runtime switch is
`document.documentElement.setAttribute('data-theme','dark')` — a `MutationObserver` in app.js re-renders
registered charts on `data-skin` / `data-theme` / `dir` changes and resizes ECharts on
`data-sidenav-size` changes.

## i18n (`I18nManager`)

- Translatable text carries `data-lang="key.path"`; translations are JSON files at
  `assets/data/translations/<lang>.json` (not included in the public demo — `plugins-i18.html` shows
  `en.json` / `es.json` / `ru.json` examples). Keys are dotted paths into the JSON.
- Language switch links: `[data-translator-lang="de"]` with a child `[data-translator-image]`; the
  selected flag/code are written into `#selected-language-image` / `#selected-language-code`.
- Choosing `ar` flips `dir` to `rtl` automatically. Persisted in `sessionStorage.__THEME_LANG__`.
- Missing keys log `Missing translation for key: …` and keep the markup text — so author pages in English
  and add JSON later.

## app.js behaviours you get for free

| Hook | Effect |
|---|---|
| `[data-action="card-toggle"]` inside `.card` | collapses `.card-body` (adds `.card-collapsed`) |
| `[data-action="card-refresh"]` | shows a `.card-overlay` spinner on the card for 1.5 s (hook your reload into the click) |
| `[data-action="card-close"]` | fades out and removes the card |
| `[data-target="1250"]` | counts up from 0 when scrolled into view (commas/decimals preserved) |
| `[data-toggle="fullscreen"]` | toggles browser fullscreen |
| `[data-provider="flatpickr"]` + `data-date-format`, `data-enable-time`, `data-altFormat`, `data-minDate`, `data-maxDate`, `data-default-date`, `data-multiple-date`, `data-range-date`, `data-inline-date`, `data-disable-date="d1,d2"`, `data-week-number` | declarative date pickers |
| `[data-provider="timepickr"]` + `data-time-hrs` (24 h), `data-min-time`, `data-max-time`, `data-default-time`, `data-time-inline` | declarative time pickers |
| `[data-touchspin]` wrapper with `[data-minus]`, `[data-plus]`, `<input min max>` | quantity stepper |
| `[data-current-year]` | current year |
| `.chart` elements registered through `new CustomApexChart({selector, options, series})` / `new CustomEChart(…)` | theme-aware colours + auto re-render on skin/theme change |

## Original sources

- `references/sources/pages/index.html` (shell, topbar, sidenav, customizer, footer)
- `references/sources/pages/pages-empty.html` (blank page), `layouts-*.html` (18 variants)
- `references/sources/assets/js/config.js`, `references/sources/assets/js/app.js`
- `references/sources/assets/css/app.min.css` (`[data-sidenav-size=*]`, `[data-menu-color=*]`, `[data-topbar-color=*]`, `.topnav`, `.page-content`)
