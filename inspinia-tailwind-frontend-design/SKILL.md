---
name: inspinia-tailwind-frontend-design
description: "Design and build admin dashboards, back-office tools, SaaS control panels, CRM/CMS/PIM screens and internal web apps with the INSPINIA Tailwind admin template (WebAppLayers, webapplayers.com/inspinia/tailwind) — Tailwind CSS v4 + Preline UI + Iconify/Tabler icons, 11 skins, dark mode, RTL, ApexCharts/ECharts, DataTables, and 60+ ready app pages. Use this skill whenever the user mentions Inspinia, INSPINIA+, WebAppLayers, Wrapmarket admin template, or asks to build / restyle / extend an admin UI, dashboard, data table, form wizard, file manager, kanban board, chat/email/calendar/invoice/e-commerce back-office page, auth screen, error page, stat widget, KPI tile, sidebar/topbar layout, theme customizer, or any page that should look like the Inspinia demo. Trigger on data-skin, data-theme, data-sidenav-size, data-menu-color, data-topbar-color, data-layout=horizontal, hs-overlay / hs-dropdown / data-hs-* (Preline), iconify tabler--, .card-title/.page-title-head, custom-table.js, CustomApexChart, app.min.css, config.js, vendors.min.js, or when choosing which Inspinia page, plugin (text diff, sortable, PDF viewer, SweetAlert2, tour, tree view, idle timer, clipboard, password meter, masonry, Plyr, Ladda, FullCalendar, Dropzone/FilePond, Quill, flatpickr, Choices.js, noUiSlider, Inputmask, Typeahead, Leaflet, jsVectorMap) or widget fits a product need. Also trigger when porting a Bootstrap-era Inspinia / Luma / generic Bootstrap admin to the Tailwind edition, or when an agent needs reference markup for a dashboard-style page even if no template is named."
---

# INSPINIA Tailwind — frontend design & build reference

INSPINIA (by WebAppLayers) is a long-running admin dashboard template. This skill covers its
**Tailwind edition**: Tailwind CSS v4.3 utilities, a thin set of template component classes, **Preline UI**
for all interactive behaviour (no Bootstrap JS, no Alpine), Tabler icons through Iconify, eleven skins,
dark/system theme, RTL, and ~230 demo pages (3 dashboards, 57 app pages, 27 auth screens, 7 error pages,
27 base-UI pages, 10 form pages, 17 table pages, 34 chart/map pages, 15 utility-plugin pages, 18 layout
variants). The whole demo is vendored under `references/sources/` so you can lift real markup instead of
guessing.

The skill's job is twofold: (1) tell you **which Inspinia page / component / plugin / widget solves a
given product need** and (2) give you the **exact markup, classes, data-attributes and init code** so what
you build matches the template and keeps working across skins, dark mode and RTL.

## Critical things to know up-front

1. **It is Tailwind v4 + Preline, not Bootstrap.** The page `<title>` still says "Bootstrap 5"; ignore it.
   Modals/dropdowns/tabs/accordions/tooltips/offcanvas/stepper are Preline (`hs-*` classes, `data-hs-*`
   attributes). `data-bs-*`, jQuery plugins, and Alpine `x-data` do nothing here.
2. **Colours are semantic tokens, never hex.** `bg-primary hover:bg-primary-hover text-white`,
   `bg-success/10 text-success`, `text-default-400` (muted), `border-default-300`, `bg-card`, `bg-body-bg`.
   Skins (`html[data-skin]`) and dark mode (`html[data-theme=dark]`) swap the variables; markup written
   with tokens needs no `dark:` classes (only images do).
3. **Layout is configured by attributes on `<html>`**, read by `assets/js/config.js` in `<head>`:
   `data-skin`, `data-theme` (light|dark|system), `data-sidenav-size` (default|compact|condensed|on-hover|
   on-hover-active|offcanvas|hidden), `data-menu-color` (light|dark|gray|gradient|image),
   `data-topbar-color` (light|dark|gray|gradient), `data-layout-width` (fluid|boxed),
   `data-layout-position` (fixed|scrollable), `data-layout` (horizontal|preloader), `dir` (ltr|rtl),
   `data-sidenav-user`. One shell, every variant.
4. **Page skeleton:** `body > .wrapper > header.app-header + aside#app-menu.app-menu + .page-content > main + footer.footer`.
   Inside `<main>`: `.page-title-head` (h4.page-main-title + breadcrumb) → `.container-fluid` → `.grid … gap-base` → `.card`s
   (`.card-header > h4.card-title` + `.card-body`). Start new pages from `references/sources/pages/pages-empty.html`.
5. **Icons:** `<i class="iconify tabler--chevron-right text-base"></i>` (double dash; Lucide the same way: `iconify lucide--camera`).
   **Only the 229 Tabler + 52 Lucide icons the demo uses are compiled** into `app.min.css`; any other name is an empty box
   until you rebuild the CSS (lists in plugins-and-icons.md).
6. **Script order:** `config.js` (head) → `vendors.min.js` → `app.js` → plugin libs → `assets/js/pages/<page>.js`.
   `vendors.min.js` = Preline + SimpleBar + flatpickr + Choices.js; jQuery, DataTables, noUiSlider, Dropzone, Quill,
   ApexCharts, ECharts, SortableJS, … are per-page `assets/plugins/` scripts (see `sources/MANIFEST-page-deps.txt`).
   Auth / error / coming-soon pages load neither `vendors.min.js` nor `app.js` (only `config.js` + a page script).
   `app.js` gives you card actions (`data-action="card-toggle|card-refresh|card-close"`), animated counters
   (`data-target`), declarative flatpickr (`data-provider="flatpickr"`), touchspin, fullscreen, i18n, the
   layout customizer, and theme-aware chart wrappers (`CustomApexChart`, `CustomEChart`).
7. **Charts must be registered through the wrappers** (`new CustomApexChart({selector, options: () => ({...})})` with
   `data-colors="primary,alpha"`) or they will not follow skin/dark-mode changes. `options` is a **function** (tokens are
   re-read on every re-render), and `CustomApexChart` deep-clones it via JSON, so Apex `formatter`/`events` callbacks are
   dropped — use `CustomEChart` or a raw `new ApexCharts()` when you need callbacks (charts-and-maps.md).
8. **Lists in app pages use the template's own `custom-table.js`** (search, sort, filter, paginate,
   checkbox-select, delete — no jQuery). Reach for DataTables only for export/ajax/fixed columns.
9. **Anything injected after load needs `window.HSStaticMethods.autoInit()`** (Preline) and a re-init of
   any plugin on the new nodes.
10. **Read pages with the helper, not `cat`:** every demo page is 180-300 KB and ~130 KB of it is the shared
    shell. `python3 -I scripts/inspinia/extract_main.py references/sources/pages/<page>.html [--list | --card "Title" | --id someModal | --overlays | --body]`
    prints only the page's own content.

## Product need → where to look

| The user wants… | Use | Reference |
|---|---|---|
| A new admin page / the shell / sidebar / topbar / breadcrumb | `pages-empty.html` skeleton; sidenav + topbar markup; `data-*` layout attrs | layout-and-theming.md |
| Horizontal menu, boxed, compact, scrollable, preloader, dark/gray/gradient topbar or sidebar | `layouts-*.html` → one `<html>` attribute each | layout-and-theming.md |
| Brand colours / a custom skin / dark mode / fonts / spacing / radius | token table, skin table, `@theme` overrides | design-system.md |
| Buttons, badges, alerts, cards, modals, offcanvas, dropdowns, tabs, accordions, tooltips, popovers, toasts, pagination, progress, spinners, placeholders, carousel, list group, breadcrumb, typography, utilities | base UI catalogue with Preline wiring | ui-components.md |
| Inputs, input groups, floating labels, checks/switches, form layouts, date/time/colour pickers, selects (Choices.js), tag inputs, file upload (Dropzone/FilePond), rich text (Quill), range sliders, input masks, typeahead, validation, multi-step wizard | forms catalogue | forms.md |
| Static tables, searchable/sortable/paginated lists, bulk select + delete, export CSV/Excel/PDF, ajax tables, fixed header/columns, child rows, column toggles, range filters | `custom-table.js` API + DataTables recipes | tables-and-datatables.md |
| Any chart (line/area/bar/column/pie/donut/radial/gauge/heatmap/treemap/funnel/timeline-Gantt/candlestick/sparkline/geo map) or map (Leaflet, vector, Google) | ApexCharts/ECharts registry + variant table | charts-and-maps.md |
| KPI/stat tiles, dashboard grid recipes, widgets (traffic sources, top countries, inventory, activity, calendar card, team list, CTA card) | widget catalogue | dashboards-and-widgets.md |
| File manager / media library / attachment picker; email inbox, thread, compose; chat; calendar (FullCalendar); social feed; projects grid/list/details; kanban (drag & drop); team board; activity stream/audit log; contacts; roles & permissions (RBAC); invoices list/detail/create; blog list/grid/article/editor (CMS); forum; clients; companies; Outlook 3-pane; vote list; issue/ticket tracker; API keys; integrations/manage apps; pin board | app page layouts + reusable snippets | apps-productivity.md |
| Storefront/back-office: marketplace, products list/grid/details/add, categories, orders list/details/create, customers, cart, checkout, sellers, refunds, reviews, warehouse, stock, purchase orders, product views, sales reports, attributes, shop settings | e-commerce page layouts | apps-ecommerce.md |
| Sign in/up, reset/new password, 2FA code entry, lock screen, PIN login, delete account, success mail (basic / card / split layouts); profile, account settings, FAQ, pricing, timeline, gallery/lightbox, sitemap, search results, coming soon, privacy/terms; 400/401/403/404/408/500/maintenance pages | utility + auth + error pages | pages-auth-and-errors.md |
| Diff two texts / log entries / config versions (jsdiff); drag-to-reorder lists (SortableJS); in-app PDF preview (pdf.js); multilingual UI (`data-lang` + JSON); confirm/success/async dialogs (SweetAlert2); auto-lock on idle; password strength meter; unread badge in the favicon (Tinycon); copy-to-clipboard; tree views (folders, categories, permission trees, context menu, drag & drop, ajax); loading/progress buttons (Ladda); masonry grids; onboarding tours; animate.css effects; video/audio player (Plyr); icon sets (Tabler, Lucide, flags) | utility plugins with use-cases | plugins-and-icons.md |
| "Why doesn't X work" (Preline attrs, dark-mode white boxes, charts not theming, sidebar not highlighting, v3 class names, Bootstrap habits) | symptom → cause → fix | common-pitfalls.md |
| Which demo page has what; which plugin/script each page loads | page map + manifests | sources/INDEX.md, sources/MANIFEST-page-deps.txt |

## Workflow for a build task

1. **Classify the need** with the table above and open the matching reference(s). Read the Quick index at
   the top of each reference first; it maps product needs to components.
2. **Pick a source page** closest to the target (the reference names it) and extract the section you need:
   `python3 -I scripts/inspinia/extract_main.py references/sources/pages/<page>.html --card "<Card title>"`
   (`--overlays` / `--id <modalId>` for the add/edit modals that app pages keep outside `<main>`).
   Trim demo prose, keep classes and `data-*` attributes exactly.
3. **Check the page's dependencies** in `references/sources/MANIFEST-page-deps.txt` and read the page script
   in `references/sources/assets/js/pages/` for the real init options.
4. **Assemble** inside the skeleton from layout-and-theming.md. Use tokens, logical (`ms-/me-/start-/end-`)
   utilities, and Preline attributes; register charts through the `Custom*Chart` wrappers.
5. **Verify** against the pitfalls list (Preline spellings, v4 syntax, no raw hex, `autoInit` after injection).
   If you can run a browser, load the page with `data-theme="dark"` and `dir="rtl"` once each.

## Things to avoid

- Bootstrap-era classes/attributes (`btn-primary`, `text-muted`, `data-bs-*`, `.modal fade`), Tailwind v3 names
  (`bg-opacity-*`, `flex-shrink-0`), Alpine/jQuery UI idioms. See common-pitfalls.md.
- Hard-coding hex colours or `bg-white`/`text-black` — breaks every skin and dark mode.
- `new ApexCharts(...)` directly — use `CustomApexChart` so colours track the skin.
- Reading whole demo pages into context — use `extract_main.py`.
- Copying the demo's 233-link sidebar, mega menus, and theme customizer into a product — trim to your IA;
  the customizer is a demo tool (keep attribute-driven theming, drop the panel).
- Assuming demo assets exist: images under `assets/images/*`, translation JSON, third-party plugin files
  under `assets/plugins/*` are **not** vendored here (plugin files are standard npm/CDN packages — see
  `references/sources/MANIFEST-plugins.txt`).

## How this skill is organised

```
inspinia-tailwind-frontend-design/
├── SKILL.md                         ← you are here
├── references/
│   ├── design-system.md             ← tokens, colours, skins, dark mode, component classes, Preline map, icons
│   ├── layout-and-theming.md        ← shell skeleton, sidenav/topbar markup, data-* config, layouts, customizer, i18n, app.js hooks
│   ├── ui-components.md             ← 27 base-UI pages
│   ├── forms.md                     ← 10 form pages
│   ├── tables-and-datatables.md     ← static tables, custom-table.js API, 15 DataTables recipes
│   ├── charts-and-maps.md           ← ApexCharts (20 pages), ECharts (11), Leaflet / vector / Google maps
│   ├── dashboards-and-widgets.md    ← 3 dashboards, metrics, widgets, landing
│   ├── apps-productivity.md         ← 34 app pages (file manager, email, chat, calendar, projects, users, invoices, blog, …)
│   ├── apps-ecommerce.md            ← 23 e-commerce pages
│   ├── pages-auth-and-errors.md     ← 12 utility pages, 27 auth screens, 7 error pages
│   ├── common-pitfalls.md           ← symptom → cause → fix
│   └── sources/                     ← vendored demo (see sources/INDEX.md)
│       ├── INDEX.md, FETCHED.txt, MANIFEST-*.txt
│       ├── pages/*.html             ← 233 pages
│       └── assets/{js/config.js, js/app.js, js/pages/*.js, css/app.min.css}
├── evals/evals.json                 ← retrieval scenarios used to test the skill
└── scripts/inspinia/
    ├── fetch_pages.sh               ← re-vendor the demo (bash scripts/inspinia/fetch_pages.sh)
    └── extract_main.py              ← read a page's own content without the shell (--list/--card/--id/--overlays/--body)
```

Each curated reference ends with an "Original sources" list pointing at the vendored files it was
written from, so you can go to the real markup when the summary isn't enough.
