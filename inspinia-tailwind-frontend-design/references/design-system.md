# Design system: tokens, colours, typography, skins, dark mode, component classes

INSPINIA Tailwind is a **Tailwind CSS v4.3** build with a thin layer of template component classes on top
(`.card`, `.btn`, `.badge`, `.form-input`, …). Everything visual is driven by CSS custom properties
declared in `@theme` and re-declared per **skin** (`html[data-skin=…]`) and per **mode**
(`html[data-theme=dark]`). You never hard-code hex values in page markup: you use the semantic
utilities (`bg-primary`, `text-default-400`, `border-default-300`, `bg-card`) and let the skin/theme
supply the actual colour.

Source of truth: `references/sources/assets/css/app.min.css` (compiled, ~700 KB — grep it, do not read it).

## Quick reference

| Need | Use |
|---|---|
| Brand / action colour | `bg-primary text-white hover:bg-primary-hover` (also `secondary success info warning danger purple light dark`) |
| Soft tint of a colour | `bg-primary/10 text-primary` (opacity modifier on the token) |
| Outline / ghost button | `border border-primary text-primary hover:bg-primary hover:text-white` / `text-primary hover:bg-primary/10` |
| Neutral text (muted, placeholder, label) | `text-default-400` (muted), `text-default-500`, `text-default-700` (strong) |
| Neutral borders / dividers | `border-default-300`, `divide-default-300`, `border-dashed` (template signature) |
| Surfaces | `bg-card` (card/panel), `bg-body-bg` (page bg), `bg-light` (subtle fill), `bg-default-100` |
| Body text colour | inherits `--color-body-color`; override with `text-body-color` |
| Spacing between cards in a grid | `gap-base` (= `--spacing-base`) |
| Rounded corners | `rounded` → `var(--radius)` which each skin sets (4 px default, up to 1 rem for *retro*) |
| Shadows | `shadow` → `var(--shadow)` per skin; cards have no shadow by default (border + dashed header) |
| Dark mode | automatic via tokens; add `dark:` variants only for images/illustrations (`<img class="flex dark:hidden">`) |
| RTL | logical utilities: `ms-* me-* ps-* pe-* start-* end-*`, `rtl:rotate-180` on chevrons |
| Icon | `<i class="iconify tabler--<name> text-base"></i>` |
| Avatar | `<img class="size-9 rounded-full">`, group: `flex -space-x-2` + `ring-2 ring-card` |

## Colour tokens

Declared on `:root` (skin *default*) and overridden per skin. All exist as Tailwind utilities
(`bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*`, `from-*`/`to-*`, with `/NN` opacity).

| Token | Default skin | Utility examples |
|---|---|---|
| `primary` / `primary-hover` | `#1ab394` / `#179f84` | `bg-primary hover:bg-primary-hover`, `text-primary`, `border-primary` |
| `secondary` / `-hover` | `#1c84c6` / `#1977b2` | |
| `success` / `-hover` | `#0acf97` / `#09ba88` | status "active / paid / delivered" |
| `info` / `-hover` | `#23c6c8` / `#20b2b4` | status "processing / shipped" |
| `warning` / `-hover` | `#f8ac59` / `#e19950` | status "pending / low stock" |
| `danger` / `-hover` | `#ed5565` / `#d54d5b` | status "cancelled / failed", destructive buttons |
| `purple` / `-hover` | `#7b70ef` | extra accent |
| `light` / `light-hover` | `#eef2f7` / `#d6dbe0` | subtle fills, "Light" button, card-header action buttons (`bg-light text-dark`) |
| `dark` / `dark-hover` | `#313a46` / `#2c3440` | "Dark" button, strong text (`text-dark`) |
| `default-50 … default-900` | `#f6f7fb` … `#313a46` (slate-ish) | neutral scale: `text-default-400` muted text, `border-default-300` borders, `bg-default-100` |
| `card` | `#fff` | `bg-card` |
| `body-bg` | `#f1f2f7` | `bg-body-bg` |
| `body-color` | `#4c4c5c` | `text-body-color` |
| `chart-primary/secondary/alpha/beta/gamma/delta/zeta/gray/dark` | per skin | consumed by charts via `data-colors="primary,alpha"` (see charts-and-maps.md) |
| `chart-border-color`, `chart-title-color` | per skin | chart grid/axis colours |

Tailwind's stock palette (`blue-500`, `zinc-800`, …) is also present but the demo barely uses it;
prefer the semantic tokens so skins and dark mode keep working.

### Status badge vocabulary (as used across the app pages)

```html
<span class="badge bg-success/10 text-success">Active</span>      <!-- soft -->
<span class="badge bg-warning text-white">Pending</span>           <!-- solid -->
<span class="badge border border-danger text-danger">Failed</span> <!-- outline -->
<span class="badge bg-info/10 text-info rounded-full">Shipped</span> <!-- pill -->
```

## Dark mode

- `html[data-theme="dark"]` flips the tokens: `body-bg #17181e`, `card #1e1f27`, `light #252630`,
  `dark #4b4d5c`, the `default-*` scale inverts (`default-900` becomes near-white), `color-scheme: dark`.
- `data-theme="system"` is resolved by `config.js` to light/dark from `prefers-color-scheme`.
- The topbar button `#light-dark-mode` toggles it; the choice persists in `sessionStorage.__THEME_CONFIG__`.
- Because tokens flip, **markup written with semantic utilities needs no `dark:` classes**. Use `dark:`
  only for raster images / logos: `<img src="logo-black.png" class="flex dark:hidden"><img src="logo.png" class="hidden dark:flex">`.
- Tailwind's `dark:` variant is configured to key off `[data-theme=dark]`, not `prefers-color-scheme`.
- Things that DO need attention in dark mode: hard-coded `bg-white`/`text-black` (use `bg-card`/`text-dark`),
  third-party plugin CSS (DataTables, Quill, flatpickr get overrides in app.min.css; new plugins won't),
  chart colours (handled if you register charts through `CustomApexChart`/`CustomEChart`).

## Skins (`html[data-skin=…]`)

Eleven skins ship. A skin changes font, radius, base text size, body background and the whole colour
set; `config.js` also applies a per-skin **preset** of layout attributes (`window.skinPresets`).

| Skin | Font (Google Fonts, `@import`ed by the CSS) | Body bg | Primary | Radius | Base text | Preset (theme / topbar / sidenav / user card) |
|---|---|---|---|---|---|---|
| `default` | Open Sans | `#f1f2f7` | `#1ab394` | 4px | 0.8125rem | light / light / dark / yes |
| `saas` | Inter | `#f9fbfd` | `#7754f6` | 4px | 13px | light / light / dark / yes |
| `luxe` | TikTok Sans | `#f0f0f5` | `#1c9390` | 6px | 13px | light / **dark** / light / yes |
| `neon` | Hanken Grotesk | `#f1f1f5` | `#4557a3` | 10px | 0.875rem | light / gray / gray / no |
| `pixel` | Momo Trust Sans | `#f5f6fa` | `#8e7fe0` | 12px | 13px | light / light / **gradient** / yes |
| `retro` | Roboto Mono | `#f3f3f7` | `#2563eb` | 1rem | 13px | light / light / gradient / yes |
| `galaxy` | Play | `#f6f8fa` | `#6575f5` | 4px | 13px | **dark** / dark / light / yes |
| `modern` | Poppins | `#f7f6f7` | `#5e6cc1` | 4px | 13px | light / light / gradient / yes |
| `minimal` | IBM Plex Sans | `#fff` | `#1ab394` | 4px | 0.875rem | light / light / gray / no |
| `material` | Roboto | `#f3f3f4` | `#3c7de1` | 4px | 14px | light / dark / light / yes |
| `flat` | Nunito | `#fff` | `#1ab394` | (default) | 0.875rem | light / light / dark / no |

Set it with `<html data-skin="saas">` or let the customizer (`#theme-customization`) switch it at runtime.
Fonts are loaded by `@import url(https://fonts.googleapis.com/…)` inside `app.min.css` — if you must
work offline or have a CSP, self-host them and override `--font-body` / `--font-secondary`.

## Typography

- Base size `--text-body` (0.8125 rem default; skins vary 13–14 px). Headings `h1…h6` are styled by the
  base layer; the demo uses `h4.card-title` (14 px) for card headers and `h4.page-main-title` for page titles.
- Font weights are tokens too (`--font-weight-medium/semibold/bold`) and skins change them (galaxy makes
  everything 700; saas makes semibold = 500). Use `font-semibold`/`font-bold` and let the skin decide.
- Tailwind scale `text-xs … text-9xl` is standard. `ui-typography.html` shows display headings, inline
  elements, lists (`list-unstyled`, inline lists), blockquotes.
- Muted copy: `text-default-400`. Links: `text-primary underline underline-offset-4` or `link-reset`.

## Layout tokens

| Variable | Default | Meaning |
|---|---|---|
| `--topbar-height` | 65px | header height (the demo's `h-topbar` class has no rule; use `h-[var(--topbar-height)]` or `h-(--topbar-height)` if you need it) |
| `--sidenav-width` / `-md` / `-sm` | 235 / 190 / 75 px | default / compact / condensed sidebar widths |
| `--logo-lg-height` / `--logo-sm-height` | 24 / 26 px | logo sizing in sidebar |
| `--sidenav-item-*` | font-size .875rem, padding 10px, gap 12px | menu item metrics (skins tweak) |
| `--sidenav-bg`, `--sidenav-item-color`, `--sidenav-item-hover-bg`, `--sidenav-item-active-color` | per `data-menu-color` | sidebar palette |
| `--topbar-bg`, `--topbar-item-color`, `--topbar-search-bg` | per `data-topbar-color` | topbar palette |
| `--spacing-base` | ~1.5rem | used by `gap-base` between cards |

Arbitrary-value utilities reference them directly in the demo, e.g. `bg-(--sidenav-bg)`,
`text-(--topbar-item-color)/50!`, `border-(--topbar-search-border)!` (Tailwind v4 syntax; `!` suffix = important).

## Template component classes (the non-Tailwind part)

These are the classes defined in the template's `@layer components`. Everything else is plain Tailwind.

| Class | What it gives you | Notes |
|---|---|---|
| `.card` | `bg-card`, 1px `border-default-300`, `rounded`, flex column, `h-fit` | add `h-full` inside grids for equal height |
| `.card-header` | padded header, dashed bottom border, flex between | holds `h4.card-title` + action buttons |
| `.card-title` | 14px semibold | |
| `.card-body` | `p-5`, grows | collapsible via `data-action="card-toggle"` |
| `.card-footer` | padded, dashed top border | |
| `.btn` | inline-flex, gap-2, `rounded`, `text-sm`, 1px transparent border, px/py | colour via `bg-*`/`text-*`/`border-*` utilities |
| `.btn-sm` / `.btn-lg` | smaller / larger padding & text | |
| `.btn-icon` | square 9.25 (`size-9.25`), no padding | with `.btn-sm` → 7.5 |
| `.badge` | inline-flex, `.75em`, px/py, `rounded`, semibold | `rounded-full` for pill, `size-6` for circle counters |
| `.form-input`, `.form-select`, `.form-textarea` | styled inputs (Tailwind forms base + template tokens) | `-sm`/`-lg` sizes |
| `.form-checkbox`, `.form-radio`, `.form-switch` | styled controls, colour by `text-primary`/`checked:bg-primary` | `-sm`/`-lg`, `.form-checkbox-light` on dark bg |
| `.form-label` | block, `mb-2`, semibold, body colour | |
| `.input-group` + `.input-group-text` | addon layout | `.input-icon-group` + `.input-icon` for inline icons |
| `.table` + `.table-bordered .table-striped .table-hover .table-sm .table-borderless` | table variants | wrap in `.table-responsive`/`overflow-x-auto` |
| `.dropdown-item`, `.dropdown-divider`, `.dropdown-menu-columns` | Preline dropdown item styling | |
| `.nav`, `.nav-tabs`, `.nav-link`, `.nav-item` | tab navs (Preline `data-hs-tab`) | `.hs-tab-active:` variants for active style |
| `.pagination` | pager list | |
| `.progress` (+ `.progress-striped`) | progress track | |
| `.placeholder` | skeleton bar | with `animate-pulse` |
| `.avatar*` are NOT classes | avatars are plain utilities: `size-9 rounded-full` | |
| `.page-title-head`, `.page-main-title` | page header strip | see layout-and-theming.md |
| `.side-nav .menu-item .menu-link .menu-icon .menu-text .menu-arrow .menu-title .sub-menu` | sidebar menu | |
| `.topbar-item`, `.topbar-link` | topbar buttons | |
| `.app-header`, `.app-menu`, `.page-content`, `.footer`, `.wrapper`, `.logo-box`, `.topnav` | shell | |
| `.btn-link`, `.link-reset`, `.text-reset`, `.list-unstyled`, `.megamenu-list` | **no CSS rules** — they appear in the demo markup as semantic hooks only; styling comes from the utilities next to them | |

## Interactive behaviour = Preline UI

No Alpine, no Bootstrap JS. All stateful components are **Preline** (`hs-*`), bundled in `vendors.min.js`
and auto-initialised on `DOMContentLoaded`.

`vendors.min.js` = **Preline + SimpleBar (`data-simplebar`) + flatpickr + Choices.js + the Lucide JS**. Everything else
(jQuery, DataTables, noUiSlider, Dropzone, FilePond, Quill, ApexCharts, ECharts, SortableJS, …) is loaded per page from
`assets/plugins/<lib>/` — see `sources/MANIFEST-page-deps.txt`.

Key spellings (★ = the demo actually uses it; the others are in the Preline bundle but the demo reaches for a
third-party plugin instead):

| Component | Trigger / container | State class | Options |
|---|---|---|---|
| ★ Dropdown | `.hs-dropdown` wrapper, `.hs-dropdown-toggle` button, `.hs-dropdown-menu` panel | `hs-dropdown-open:` | `[--placement:bottom-right] [--auto-close:inside] [--strategy:absolute]` |
| ★ Modal / Offcanvas | `data-hs-overlay="#id"` on trigger; panel has `.hs-overlay hidden` + `hs-overlay-open:` transitions | `hs-overlay-open:` | `[--overlay-backdrop:static]`, `[--body-scroll:true]`; close/cancel buttons re-use `data-hs-overlay="#id"` (it toggles) — the demo never uses `data-hs-overlay-close` |
| ★ Collapse | `.hs-collapse-toggle` + `data-hs-collapse="#id"`, target `.hs-collapse hidden` | `hs-collapse-open:` | |
| ★ Accordion | `.hs-accordion-group > .hs-accordion > .hs-accordion-toggle + .hs-accordion-content` | `hs-accordion-active:` | `data-hs-accordion-always-open` |
| ★ Tabs | `[data-hs-tab="#panel"]` on nav links, `role="tablist"` | `hs-tab-active:` | `data-hs-tab-select` |
| ★ Tooltip / Popover | `.hs-tooltip` wrapper, `.hs-tooltip-toggle`, `.hs-tooltip-content` | `hs-tooltip-shown:` | `[--placement:top] [--trigger:click]` |
| ★ Carousel | `data-hs-carousel='{"loadingClasses":"opacity-0"}'` | `hs-carousel-active:` | |
| ★ Scrollspy | `[data-hs-scrollspy="#content"]` | `hs-scrollspy-active:` | |
| ★ Stepper (wizard) | `data-hs-stepper`, `data-hs-stepper-nav-item`, `data-hs-stepper-content-item` | `hs-stepper-active:` / `-success:` | |
| Select (custom) | `data-hs-select='{…json…}'` | | not used — demo uses **Choices.js** (`data-choices`, forms.md) |
| ★ Password toggle | `data-hs-toggle-password` | `hs-password-active:` | strength meters are template JS (`auth-password.js`, `plugins-pass-meter.js`), not `hs-strong-password` |
| ★ Remove element | `data-hs-remove-element="#id"` | `hs-removing:` | used by topbar notifications and toasts |
| Tree view | `data-hs-tree-view` | | not used — demo uses **jsTree** (jQuery) |
| DataTable wrapper | `data-hs-datatable` | | not used — demo initialises **DataTables** directly with jQuery (tables-and-datatables.md) |
| Copy markup / input number | `data-hs-copy-markup`, `data-hs-input-number` | | not used — demo uses clipboard.js and `data-touchspin` |

After injecting Preline markup with JS (modals rendered from templates, rows appended), call
`window.HSStaticMethods.autoInit()` (optionally with a list like `['dropdown','tooltip']`).

## Icons

- Primary set: **Tabler** through the Iconify Tailwind plugin — `<i class="iconify tabler--settings"></i>`.
  Size and colour with text utilities: `text-xl text-primary`. Names are Tabler's (`tabler--chevron-right`,
  `tabler--user-circle`, `tabler--basket`, `tabler--alert-triangle`, `tabler--point-filled`). Browse `icons-tabler.html`.
- Secondary: **Lucide**, same mechanism: `<i class="iconify lucide--camera"></i>` (`icons-lucide.html`). The Lucide JS
  in `vendors.min.js` is not used by any demo page.
- **Only the icons the demo uses are compiled** into `app.min.css`: 229 `tabler--*` and 52 `lucide--*` mask rules
  (full lists in plugins-and-icons.md). Any other name renders an empty box. To add icons: rebuild the CSS with the
  Iconify Tailwind plugin and the new names in your source, or drop in an inline SVG from tabler.io.
- Flags: SVG files in `assets/images/flags/`, listed by `assets/js/pages/flags-listing.js`.

## Original sources

- `references/sources/assets/css/app.min.css` (`@layer theme` block, `html[data-skin=*]`, `[data-theme=dark]`, `@layer components`)
- `references/sources/assets/js/config.js` (`skinPresets`), `references/sources/assets/js/app.js` (`theme()` helper)
- `references/sources/pages/ui-colors.html`, `ui-typography.html`, `ui-utilities.html`, `icons-tabler.html`, `icons-lucide.html`
