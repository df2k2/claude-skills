# Base UI components (Preline + Tailwind)

This group is the atomic vocabulary every other INSPINIA Tailwind page is assembled from: buttons,
badges, alerts, cards, dropdowns, modals/offcanvas, tabs, accordions, tooltips/popovers, toasts,
pagination, list groups, progress, spinners, skeleton placeholders, carousel, scrollspy, avatars,
links, typography, embeds, and the colour/utility tokens behind them. There are **no page scripts**
for any of these 27 pages — all interactivity is Preline (`hs-*` classes + `data-hs-*` attributes,
auto-initialised from `vendors.min.js`) plus the card-action handlers in `app.js`. Reach for this
file whenever you need the exact class string for a variant (soft/outline/ghost/pill/size) or the
exact Preline wiring (which element carries `hs-overlay`, which id goes where, which
`[--placement:…]` CSS-variable options exist).

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Primary / secondary actions, toolbars, icon-only controls, button groups, split buttons | Buttons (`.btn` + colour utilities) | ui-buttons | none (`hs-dropdown` for split) |
| Status chips, counters on nav items, notification dots, labels in tables | Badges (`.badge`) | ui-badges | none |
| Inline feedback banners (success/error/warning), dismissible notices, callouts with actions | Alerts | ui-alerts | Preline `data-hs-remove-element` |
| Any panel: widget container, settings section, form wrapper, collapsible/refreshable/closable block | Cards (`.card`) | ui-cards | app.js `data-action="card-*"` |
| Row-action menus, "more" menus, user menus, filter pickers, inline login form | Dropdowns (`hs-dropdown`) | ui-dropdowns | Preline HSDropdown |
| Confirm/delete dialogs, edit forms in a dialog, wizards spanning several dialogs, fullscreen editors | Modals (`hs-overlay`) | ui-modals | Preline HSOverlay |
| Slide-in filter panel, cart drawer, detail inspector, mobile nav | Offcanvas / drawer (`hs-overlay`) | ui-offcanvas | Preline HSOverlay |
| Switch between views inside one card (Overview / Activity / Settings), vertical settings nav | Tabs (`data-hs-tab`) | ui-tabs | Preline HSTabs |
| FAQ, grouped settings, order line details, "one open at a time" sections | Accordions (`hs-accordion`) | ui-accordions | Preline HSAccordion |
| "Read more" toggles, advanced-options reveal, show/hide a filter form | Collapse (`hs-collapse`) | ui-collapse | Preline HSCollapse |
| Hint on an icon button, abbreviation explanation, truncated-cell full value | Tooltips (`hs-tooltip`) | ui-tooltips | Preline HSTooltip |
| Richer hover/click help card with title + body, "what's this?" affordances | Popovers (`hs-tooltip` + `[--trigger:click]`) | ui-popovers | Preline HSTooltip |
| "Saved", "New message", background job finished — transient toast messages | Notifications / toasts | ui-notifications | Preline `data-hs-remove-element` (no script) |
| Page through table rows, search results, gallery pages | Pagination | ui-pagination | none |
| Show where the user is in a hierarchy (Home › Library › Data) | Breadcrumb | ui-breadcrumb | none |
| Simple vertical lists: integrations, notification settings with checkboxes, inbox counts with badges | List group | ui-list-group | none |
| Upload progress, storage quota, task completion %, multi-segment capacity bars, step indicator | Progress | ui-progress | none |
| Loading state in a button, inline "fetching" indicator, card refresh overlay | Spinners | ui-spinners | none (app.js uses same for card-refresh) |
| Skeleton screens while data loads (card, table rows, text blocks) | Placeholders | ui-placeholders | none |
| Product image slider, onboarding slides, hero banner rotation | Carousel (`data-hs-carousel`) | ui-carousel | Preline HSCarousel (JSON options) |
| Sticky section nav that highlights as you scroll (docs, long settings page, policy text) | Scrollspy (`data-hs-scrollspy`) | ui-scrollspy | Preline HSScrollspy |
| User avatars (image or initials), avatar stacks, thumbnails, rounded media | Images & avatars | ui-images | none |
| Coloured / underlined links, emphasis links, hover opacity | Links | ui-links | none |
| Headings, inline text, lists, blockquotes — the base text scale | Typography | ui-typography | none |
| Responsive YouTube/Vimeo/video embeds at a fixed aspect ratio | Videos | ui-videos | none |
| Pick the right semantic colour / border token, understand dark-mode flips and skins | Colours & border tokens | ui-colors | none |
| Opacity, radius, overflow, positioning, shadows, object-fit, z-index, logical (RTL-safe) spacing | Utilities | ui-utilities | none |

## Buttons

**What it is.** `.btn` is the only template button class (padding, radius, font-weight 500,
transition, 1 px transparent border). Colour, shape and emphasis come entirely from Tailwind
utilities layered on top: solid, outline, soft, ghost, gradient, pill, sizes, icon-only.

**Use it when.**
- Primary/secondary form actions ("Save changes" solid primary + "Cancel" `bg-light`).
- Toolbars and table row actions (icon-only `btn-icon` or `size-7.5` buttons, soft variants for low emphasis).
- Segmented controls / button groups (`inline-flex` + `rounded-e-none`/`rounded-none`/`rounded-s-none`).
- Split buttons where the main action is immediate and extra options sit in a dropdown.
- Don't use a `.btn` as a toggle for tabs or accordions — those have their own Preline toggle classes (see Tabs, Accordions).

**Source.** `references/sources/pages/ui-buttons.html` (no script).

**Markup.**

```html
<!-- solid (default emphasis) -->
<button type="button" class="btn bg-primary hover:bg-primary-hover text-white">Primary</button>
<button type="button" class="btn border-default-300">Default</button>
<button type="button" class="btn bg-light text-dark hover:bg-light-hover">Light</button>

<!-- outline / soft / ghost / gradient -->
<button type="button" class="btn border-primary text-primary hover:bg-primary hover:text-white">Outline</button>
<button type="button" class="btn text-primary bg-primary/15 hover:bg-primary hover:text-white">Soft</button>
<button type="button" class="btn text-primary hover:bg-primary rounded hover:text-white">Ghost</button>
<button type="button" class="btn border-0 bg-linear-to-br from-purple-600 to-blue-500 text-white hover:bg-linear-to-bl">Gradient</button>

<!-- sizes / block / disabled -->
<button type="button" class="btn btn-lg bg-primary hover:bg-primary-hover text-white">Large</button>
<button type="button" class="btn btn-sm bg-success hover:bg-success-hover text-white">Small</button>
<button type="button" class="btn bg-primary hover:bg-primary-hover w-full text-white">Block</button>
<button type="button" class="btn bg-info text-white hover:bg-info-hover" disabled>Disabled</button>

<!-- icon-only and icon+text -->
<button type="button" class="btn btn-icon bg-primary hover:bg-primary-hover text-white"><i class="iconify tabler--star text-lg"></i></button>
<button type="button" class="btn bg-success hover:bg-success-hover size-7.5 rounded-full text-white"><i class="iconify tabler--settings text-xs"></i></button>
<button type="button" class="btn bg-danger hover:bg-danger-hover text-white"><i class="iconify tabler--tools text-base"></i> Tools</button>

<!-- button group (horizontal) with a trailing dropdown -->
<div class="inline-flex">
  <button type="button" class="btn bg-light hover:text-primary rounded-e-none">1</button>
  <button type="button" class="btn bg-primary hover:bg-primary-hover rounded-none text-white">2</button>
  <div class="hs-dropdown relative inline-flex">
    <button type="button" class="btn bg-light hover:text-primary rounded-s-none" aria-haspopup="menu" aria-expanded="false">Dropdown <i class="iconify tabler--chevron-down"></i></button>
    <div class="hs-dropdown-menu" role="menu"><a class="dropdown-item" href="#">Dropdown link</a></div>
  </div>
</div>
<!-- vertical group: inline-flex flex-col + rounded-b-none / rounded-none / rounded-t-none -->
```

Variant matrix (replace `primary` with `secondary success danger warning info dark`; `light` is the odd one out):

| Variant | Classes |
|---|---|
| Solid | `btn bg-{c} hover:bg-{c}-hover text-white` — light: `btn bg-light text-dark hover:bg-light-hover` — default/neutral: `btn border-default-300` |
| Solid rounded (pill) | add `rounded-full` |
| Outline | `btn border-{c} text-{c} hover:bg-{c} hover:text-white` — light: `btn border-light text-dark hover:bg-light hover:text-dark` |
| Outline rounded | add `rounded-full` |
| Soft | `btn text-{c} bg-{c}/15 hover:bg-{c} hover:text-white` (no light variant) |
| Soft rounded | add `rounded-full` |
| Ghost | `btn text-{c} hover:bg-{c} rounded hover:text-white` |
| Ghost rounded | `btn text-{c} hover:bg-{c} rounded-full hover:text-white` |
| Gradient | `btn border-0 bg-linear-to-br from-purple-600 to-blue-500 text-white hover:bg-linear-to-bl` (also `bg-linear-to-r from-cyan-500 to-blue-500`, `from-green-400 to-blue-600`, `from-purple-500 to-pink-500 hover:bg-linear-to-l`, `from-pink-500 to-orange-400`, `from-teal-200 to-lime-200 text-gray-900`, `from-red-200 via-red-300 to-yellow-200 text-gray-900`) |
| Gradient rounded | add `rounded-full` |
| Sizes | `btn-sm` / (default) / `btn-lg` |
| Block | `w-full` |
| Disabled | `disabled` attribute (Tailwind `disabled:opacity-50 disabled:pointer-events-none` is also used on dropdown toggles) |
| Icon-only | `btn btn-icon` (30 px square) or explicit `size-7.5` (icon `text-xs`) / `size-11.25` (icon `text-xl`); add `rounded-full` for circles |
| `<input type=button/submit/reset>` | needs `bg-primary! hover:bg-primary-hover!` (important modifier) because UA input styles win |
| `<a>` | `<a href class="btn …">` works unchanged |

**Gotchas.**
- `.btn` sets a `border` (1 px, transparent for solid variants); outline variants only add `border-{c}` — no extra `border` class needed, but `btn-icon` outline in the demo does add `border` (`btn btn-icon border-dark text-dark hover:bg-dark rounded-full border`).
- `hover:bg-{c}-hover` tokens exist for every semantic colour including `light` and `dark`; there is no `purple-hover` in the demo (use `hover:bg-purple/90`).
- Gradient buttons use Tailwind palette colours (`purple-600`, `cyan-500`…), not template tokens — they do not change with skin/dark mode.
- Card-header action buttons are a fixed recipe: `btn size-6 rounded-full bg-light text-dark hover:text-primary` + `data-action` (see Cards).

## Badges

**What it is.** `.badge` = `inline-flex items-center justify-center`, `0.75em` text, semibold, `padding .15em .5em`, template radius. Pill (`rounded-full`) widens padding to `.75em`; `.badge-label` squares the corners.

**Use it when.**
- Order/ticket status in a table cell (`badge bg-success/15 text-success rounded-full` = "Paid").
- Unread counts on a nav item or list row (`badge bg-primary text-white rounded-full`).
- A notification dot or "99+" pinned to the corner of a button.
- Numeric step markers (square/circle `size-4`).
- Don't use for interactive filters — use Soft buttons; for removable tags look at the forms group (`hs-select` tags).

**Source.** `references/sources/pages/ui-badges.html` (no script).

**Markup.**

```html
<div class="flex flex-wrap gap-2">
  <span class="badge border-default-300 border">Default</span>
  <span class="badge bg-primary text-white hover:bg-primary-hover">Primary</span>
  <span class="badge bg-primary rounded-full text-white">Pill</span>
  <span class="badge border-primary text-primary border">Outline</span>
  <span class="badge border-primary text-primary rounded-full border">Outline pill</span>
  <span class="badge bg-primary/15 text-primary">Soft</span>
  <span class="badge bg-primary/15 text-primary rounded-full">Soft pill</span>
  <span class="badge badge-label bg-primary text-white">Label</span>
  <span class="badge size-4 bg-primary text-white">1</span>                  <!-- square -->
  <span class="badge size-4 rounded-full bg-primary text-white">1</span>     <!-- circle -->
</div>

<!-- positioned on a button -->
<button type="button" class="btn bg-primary hover:bg-primary-hover relative text-white">
  Inbox <span class="badge bg-danger absolute -end-2 -top-2 rounded-full">99+</span>
</button>
<button type="button" class="btn bg-primary hover:bg-primary-hover relative text-white">
  Profile <span class="bg-danger absolute -end-1 -top-1 size-3 rounded-full border border-white px-0.75 py-0.5"></span>
</button>
<button type="button" class="btn bg-success hover:bg-success-hover text-white">
  Notifications <span class="badge bg-white text-black">4</span>
</button>
```

Variant matrix (`{c}` = `primary secondary success danger warning info dark`; `light` = `bg-light` / `bg-light text-dark`, default = `border border-default-300`):

| Variant | Classes |
|---|---|
| Solid | `badge bg-{c} text-white` |
| Solid pill | `badge bg-{c} rounded-full text-white` |
| Outline | `badge border-{c} text-{c} border` |
| Outline pill | `badge border-{c} text-{c} rounded-full border` |
| Lighten / soft | `badge bg-{c}/15 text-{c}` |
| Lighten pill | `badge bg-{c}/15 text-{c} rounded-full` |
| Label (square corners) | `badge badge-label bg-{c} text-white` |
| Square counter | `badge size-4 bg-{c} text-white` |
| Circle counter | `badge size-4 rounded-full bg-{c} text-white` |
| Positioned | parent `relative` + `badge … absolute -end-2 -top-2 rounded-full`; dot = `absolute -end-1 -top-1 size-3 rounded-full border border-white` |

**Gotchas.**
- Badge font size is `em`-relative — it scales with the parent (`text-xs` parent gives a tiny badge).
- Inside the sidenav, `.badge` has different (menu) rules; this table is for content areas.

## Alerts

**What it is.** No `.alert` class — an alert is a `flex items-center rounded px-4 py-3` box with soft (`bg-{c}/15 text-{c}`) or solid (`bg-{c} text-white`) colouring, `role="alert"`, optionally dismissible through Preline's remove-element plugin.

**Use it when.**
- Form-level validation summary or success confirmation at the top of a card.
- Persistent system notices ("Your trial ends in 3 days") with a link or a "Got it" button.
- Non-blocking warnings inside a settings panel.
- For transient, auto-stacking messages use Notifications (toasts) instead; for blocking confirmation use a Modal.

**Source.** `references/sources/pages/ui-alerts.html` (no script).

**Markup.**

```html
<!-- soft (default) -->
<div class="bg-success/15 text-success flex items-center rounded px-4 py-3" role="alert">Success! Your operation was completed.</div>
<!-- solid -->
<div class="bg-danger flex items-center rounded px-4 py-3 text-white" role="alert">Error! Something went wrong.</div>
<!-- with link -->
<div class="bg-primary/15 text-primary flex items-center gap-1 rounded px-4 py-3" role="alert">
  Need more info? Check out <a href="#" class="font-bold">this primary link</a>.
</div>

<!-- additional content: heading, hr, action button, leading icon -->
<div class="bg-danger/15 text-danger flex gap-3 rounded p-6" role="alert">
  <i class="iconify tabler--phone-ringing size-8"></i>
  <div>
    <h4 class="text-danger mb-2 text-lg font-semibold">Notice!</h4>
    <p class="mb-4">Longer explanatory text…</p>
    <hr class="border-danger/20 my-4" />
    <button type="button" class="btn bg-danger btn-sm text-white">Got it</button>
  </div>
</div>

<!-- dismissible (Preline HSRemoveElement) -->
<div id="dismiss-alert" class="hs-removing:translate-x-5 hs-removing:opacity-0 transition duration-300 border-primary bg-primary/15 text-primary flex items-center rounded border px-4 py-3" role="alert">
  A primary alert you can dismiss.
  <button class="ms-auto" data-hs-remove-element="#dismiss-alert"><i class="iconify tabler--x text-2xl text-default-700"></i></button>
</div>
```

Variants:

| Variant | Classes (`{c}` = primary secondary success danger warning info dark) |
|---|---|
| Soft | `bg-{c}/15 text-{c} flex items-center rounded px-4 py-3` — light: `bg-light/40 text-dark` |
| Solid | `bg-{c} flex items-center rounded px-4 py-3 text-white` — light: `bg-light text-dark` |
| Bordered | add `border border-{c}` / `border-2 border-{c}` / `border-2 border-dashed border-{c}` / `border-b-2 border-{c}` |
| Custom close button | `ms-auto size-7.5 flex justify-center items-center rounded-full bg-warning text-white` + `data-hs-remove-element` |
| Custom icon | `<div class="flex gap-3 items-center"><i class="iconify tabler--alert-octagon text-xl"></i> text</div>` before the `ms-auto` button |
| Muted notice | `border-light bg-light/20 text-light flex items-center gap-base rounded border-2 p-6` + inner `text-default-400` |

**Gotchas.**
- Dismiss needs three things: a unique `id` on the alert, `data-hs-remove-element="#id"` on the button, and the `hs-removing:*` classes + `transition duration-300` on the alert (Preline adds `.hs-removing`, waits for the transition, then removes the node).
- Alerts injected after page load need `window.HSStaticMethods.autoInit()` (or `new HSRemoveElement(el)`) before the close button works.

## Cards

**What it is.** `.card` (bg `--color-card`, template shadow, radius; a 1 px border only when you add `.border`), `.card-header` (flex, space-between, dashed bottom border, `py-3.75 px-5`), `.card-title` (`text-md` semibold), `.card-body` (`p-5`), `.card-footer`. Header action buttons are wired by app.js through `data-action`.

**Use it when.**
- Every dashboard widget, form section, table wrapper, chart container.
- Collapsible/refreshable/closable panels (`data-action="card-toggle|card-refresh|card-close"`).
- Media cards (image top, horizontal image + text), equal-height card groups, cards with a tab nav in the header.
- Coloured KPI tiles (`card bg-primary!`).

**Source.** `references/sources/pages/ui-cards.html`; handlers in `references/sources/assets/js/app.js` (`App.initPortletCard`).

**Markup.**

```html
<!-- standard card with title + action tools -->
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Card with Action Tools</h4>
    <div class="flex gap-1">
      <button class="btn size-6 rounded-full bg-light text-default-700 hover:text-primary" data-action="card-toggle"><i class="iconify tabler--chevron-up text-base"></i></button>
      <button class="btn size-6 rounded-full bg-light text-default-700 hover:text-primary" data-action="card-refresh"><i class="iconify tabler--refresh text-base"></i></button>
      <button class="btn size-6 rounded-full bg-light text-default-700 hover:text-primary" data-action="card-close"><i class="iconify tabler--x text-base"></i></button>
    </div>
  </div>
  <div class="card-body">
    <p class="mb-4">With supporting text below as a natural lead-in to additional content.</p>
    <a href="javascript: void(0);" class="btn btn-sm bg-primary hover:bg-primary-hover text-white">Go somewhere</a>
  </div>
  <div class="card-footer text-default-400">2 days ago</div>
</div>

<!-- sub header -->
<div class="card-header block border-dashed">
  <h4 class="card-title mb-1.25">Card with Sub Header</h4>
  <h6 class="text-default-400 text-2xs">Card subtitle</h6>
</div>

<!-- coloured card: tools use white/25 -->
<div class="card bg-info!">
  <div class="card-header border-dashed">
    <h4 class="card-title text-white">Card with Action Tools & Background Colors</h4>
    <div class="flex gap-1">
      <button class="btn size-6 rounded-full bg-white/25 text-white/75 hover:text-white" data-action="card-toggle"><i class="iconify tabler--chevron-up text-base"></i></button>
    </div>
  </div>
  <div class="card-body"><p class="mb-4 text-white">…</p><a href="#" class="btn btn-sm hover:text-primary bg-white">Go somewhere</a></div>
</div>

<!-- horizontal card -->
<div class="card">
  <div class="grid grid-cols-1 items-center md:grid-cols-3">
    <div><img src="assets/images/stock/small-1.jpg" class="rounded-s-sm" alt="..." /></div>
    <div class="col-span-2"><div class="card-body">
      <h5 class="card-title mb-2.5">Card with Horizontal Mode</h5>
      <p class="mb-4">…</p><p><small class="text-default-400 text-2xs">Last updated 3 mins ago</small></p>
    </div></div>
  </div>
</div>

<!-- stretched link (whole card clickable) -->
<div class="card group"><a href="#"><img src="assets/images/stock/small-3.jpg" class="rounded-t-sm" alt="..." />
  <div class="card-body"><h5 class="card-title mb-2.5">Card with stretched link</h5>
    <a href="#" class="btn btn-sm bg-primary group-hover:bg-primary-hover mt-3 text-white">Button</a></div>
</a></div>

<!-- card group (joined, equal height) -->
<div class="grid grid-cols-1 gap-3 md:grid-cols-3 md:gap-0 mb-base">
  <div class="card h-full md:rounded-s-sm md:rounded-e-none"><div class="card-body flex-1">…</div><div class="card-footer">…</div></div>
  <div class="card h-full md:rounded-none">…</div>
  <div class="card h-full md:rounded-s-none md:rounded-e-sm">…</div>
</div>

<!-- nav in header -->
<div class="card">
  <div class="card-header border-dashed pb-0">
    <nav class="flex">
      <a href="#" class="text-primary border-default-300 rounded-t-lg border border-b-0 px-4 py-2 text-center text-sm font-medium">Active</a>
      <a href="#" class="text-default-600 px-4 py-2 font-medium">Link</a>
      <a href="#" class="px-4 py-2 font-medium" disabled>Disabled</a>
    </nav>
  </div>
  <div class="card-body">…</div>
</div>
```

Variants:

| Variant | Classes |
|---|---|
| Background colour | `card bg-primary!` / `bg-success!` (the `!` is required — `.card` sets its own background) with `text-white` on title/body and a `btn btn-sm bg-default-50 hover:text-primary` button |
| Coloured border | `card border-primary border` |
| Dashed border | `card border-primary border border-dashed` |
| Thick border | `card border-primary border-2` |
| Left accent bar | `card border-primary border-s-3` (also `border-dark`, `border-info`) |
| Header with no dashed line | `card-header border-dashed` is the default look; `.card-collapsed .card-header` removes the border |
| Code preview toggle | `data-action="code-collapse"` (`tabler--code`) toggles a sibling `<div class="code-body hidden"><pre><code class="language-markup">…` |

**Init / JS.** Handled by `app.js` on DOMContentLoaded — do not write your own:
- `card-close` → fades the `.card` out (opacity 0.3 s) then removes it.
- `card-toggle` → animates `.card-body` height to 0 and adds `.card-collapsed` to the card (CSS then hides the header border and rotates the chevron: `.card.card-collapsed [data-action=card-toggle] i{rotate:-180deg}`).
- `card-refresh` → injects `<div class="card-overlay">` with a `size-8 animate-spin rounded-full border-3 border-primary border-t-transparent` spinner for 1.5 s (`.card-overlay` is absolute, `primary/15` backdrop-blur). Hook your real fetch here if needed by listening to the click yourself.
- `code-collapse` → animates `.code-body` display/height.

**Gotchas.**
- Cards appended dynamically do not get the `data-action` handlers (app.js binds once at load); call `new App().initPortletCard()` is not exposed — re-bind manually or render cards server-side.
- `card-img-top` appears in the demo but has **no CSS rule**; use `rounded-t-sm` on the `<img>` instead.
- `card-toggle` collapses only `.card-body`; a `.card-footer` is pulled up via negative margin by `.card-collapsed` — keep footer content short.
- The second "Navigation with Card" example has a typo (`hrf="#"`); use `href`.

## Dropdowns

**What it is.** Preline HSDropdown. Wrapper `hs-dropdown relative inline-flex` → toggle `hs-dropdown-toggle` → menu `hs-dropdown-menu` (template CSS gives it background, border, shadow and the hidden/open behaviour). Items are `.dropdown-item`, separators `<hr class="dropdown-divider">`.

**Use it when.**
- Row "⋯" action menus in tables and cards, bulk-action menus.
- Topbar user menu, notification menu, language picker (also see layout group).
- Filter/sort pickers with a form inside (`[--auto-close:inside]`).
- Split buttons (primary action + secondary options).
- Don't use for selecting a value in a form — use `form-select` / `hs-select` from the forms group.

**Source.** `references/sources/pages/ui-dropdowns.html` (no script).

**Markup.**

```html
<div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
  <button type="button" class="hs-dropdown-toggle btn bg-light text-dark" aria-haspopup="menu" aria-expanded="false" aria-label="Dropdown">
    Choose Option <i class="iconify tabler--chevron-down hs-dropdown-open:rotate-180 transition-transform text-base"></i>
  </button>
  <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical">
    <h6 class="px-2.75 py-2">Dropdown header</h6>
    <a class="dropdown-item" href="#">Profile Settings</a>
    <a class="dropdown-item active" href="#">Notifications</a>
    <hr class="dropdown-divider" />
    <a class="dropdown-item" href="#">Logout</a>
  </div>
</div>

<!-- split button -->
<div class="inline-flex">
  <button type="button" class="btn bg-primary hover:bg-primary-hover rounded-e-none text-white">Primary</button>
  <div class="hs-dropdown relative inline-flex [--placement:bottom-left]">
    <button type="button" class="hs-dropdown-toggle btn bg-primary/90 hover:bg-primary-hover rounded-s-none px-2 text-white"><i class="iconify tabler--chevron-down text-base"></i></button>
    <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical">
      <a class="dropdown-item" href="#">Action</a>
      <hr class="dropdown-divider" />
      <a class="dropdown-item" href="#">Separated link</a>
    </div>
  </div>
</div>

<!-- form inside a menu -->
<div class="hs-dropdown relative inline-flex [--auto-close:inside] [--placement:bottom-end]">
  <button type="button" class="hs-dropdown-toggle btn bg-secondary hover:bg-secondary-hover text-white" aria-haspopup="menu" aria-expanded="false">Form <i class="iconify tabler--chevron-down text-base"></i></button>
  <div class="hs-dropdown-menu min-w-44" role="menu">
    <form class="px-7.5 py-5">
      <div class="mb-5"><label class="form-label">Email address</label><input class="form-input text-sm" type="email" placeholder="email@example.com" /></div>
      <div class="mb-4 flex items-center gap-2.5"><input type="checkbox" class="form-checkbox shrink-0" id="dropdownCheck" /><label for="dropdownCheck" class="text-default-500 ms-1 text-sm">Remember me</label></div>
      <button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Sign in</button>
    </form>
    <hr class="dropdown-divider" /><a class="dropdown-item" href="#">Forgot password?</a>
  </div>
</div>
```

Options are CSS custom properties set as arbitrary classes on the `.hs-dropdown` wrapper:

| Option | Values seen in demo | Effect |
|---|---|---|
| `[--placement:…]` | `bottom-right`, `bottom-left`, `bottom-end`, `bottom` (centered), `top`, `top-left`, `left-start` (dropstart), `right-end` (dropend) | menu position relative to toggle (default `bottom-left`) |
| `[--trigger:hover]` | `hover` | open on hover instead of click |
| `[--auto-close:…]` | `inside`, `outside`, `false` | `inside` keeps open on outside click (closes on item click); `outside` closes only on outside click; `false` = manual |
| `[--strategy:…]` / `[--adaptive:…]` | `static`/`fixed`, `none`/`adaptive`, responsive `lg:[--strategy:fixed]` | positioning strategy (scrollspy navbar example) |
| `data-theme="dark"` on `.hs-dropdown-menu` | — | dark menu regardless of page theme |

Other variants: toggle can be any button variant (`btn bg-primary …`, `btn btn-sm`, `px-6 py-2 text-lg` for large); `<a class="hs-dropdown-toggle btn …" role="button">` works; text-only menu `hs-dropdown-menu w-44 p-4`; `.dropdown-item.active` for current, `disabled` attribute for inactive.

**Gotchas.**
- The menu element carries **only** `class="hs-dropdown-menu"` — the template CSS supplies Preline's `hidden`/`opacity`/`.open` rules and the dark-skin borders. Do not paste Preline-docs class strings (`hs-dropdown-open:opacity-100 opacity-0 hidden min-w-60 …`) on top; they fight the template styling.
- `hs-dropdown-open:rotate-180` on the chevron is the only state class you need on the toggle; `aria-expanded` is managed by Preline.
- Split/dropstart: the wrapper with `[--placement:left-start]` goes **before** the main button in DOM order so the chevron sits on the left.
- Demo's "Disabled link" uses `class="dropdown-item active" … disabled` on an `<a>` — `disabled` is not valid on anchors; prefer `pointer-events-none opacity-50` (or `aria-disabled`).

## Modals

**What it is.** Preline HSOverlay. A trigger with `data-hs-overlay="#id"` toggles a fixed `.hs-overlay` container (`z-80`) that fades in via `hs-overlay-open:*` classes; inside, an `hs-overlay-animation-target` wrapper sets size/position and a `.card`-styled panel holds header / body / footer. Backdrop is injected by Preline (`.hs-overlay-backdrop`, `default-900` at 50 %).

**Use it when.**
- Confirm destructive actions ("Delete 3 users?") — small modal, static backdrop for irreversible ones.
- Create/edit forms that don't warrant a page (large or fullscreen modal with scrollable body).
- Multi-step flows: chain modals with "Next" buttons that open the next `#id` (toggle-between).
- Previews (image, document) — full-width or fullscreen.
- Side panels (filters, details) are better as Offcanvas.

**Source.** `references/sources/pages/ui-modals.html` (no script).

**Markup.**

```html
<button type="button" class="btn bg-primary hover:bg-primary-hover rounded text-white"
        aria-haspopup="dialog" aria-expanded="false" aria-controls="standard-modal" data-hs-overlay="#standard-modal">Standard Modal</button>

<div id="standard-modal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto opacity-0 transition-all"
     role="dialog" tabindex="-1" aria-labelledby="standard-modal-label">
  <div class="hs-overlay-animation-target m-3 sm:mx-auto sm:w-full sm:max-w-lg">          <!-- size / position wrapper -->
    <div class="border-default-300 pointer-events-auto flex flex-col rounded-md border card">   <!-- panel -->
      <div class="border-default-300 flex items-center justify-between border-b p-6">
        <h3 id="standard-modal-label" class="text-base font-semibold">Modal Heading</h3>
        <button type="button" aria-label="Close" data-hs-overlay="#standard-modal"><span class="sr-only">Close</span><i class="iconify tabler--x text-xl"></i></button>
      </div>
      <div class="overflow-y-auto card-body">
        <h5 class="mb-2">Text in a modal</h5>
        <p class="mb-4">Duis mollis, est non commodo luctus, nisi erat porttitor ligula.</p>
      </div>
      <div class="border-default-300 flex items-center justify-end border-t p-4">
        <button type="button" class="btn bg-light hover:text-primary m-1" data-hs-overlay="#standard-modal">Close</button>
        <button type="button" class="btn bg-primary hover:bg-primary-hover m-1 rounded text-white">Save changes</button>
      </div>
    </div>
  </div>
</div>
```

Variants — change only the parts named:

| Variant | What changes |
|---|---|
| Large | wrapper `hs-overlay-animation-target m-3 sm:mx-auto lg:w-full lg:max-w-3xl` |
| Small | wrapper `m-3 sm:mx-auto lg:w-full lg:max-w-xs` |
| Full width | wrapper `… sm:mx-auto lg:w-full lg:max-w-full` |
| Scrollable body | body `<div class="h-150 overflow-y-auto p-5">` instead of `card-body` (fixed height, inner scroll) |
| Top (default) | container `fixed start-0 top-0` + opacity classes as above |
| Bottom | container `hs-overlay pointer-events-none fixed start-0 bottom-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto` (no opacity classes); wrapper `hs-overlay-animation-target m-3 flex min-h-[calc(100%-56px)] items-end sm:mx-auto sm:w-full sm:max-w-lg` |
| Centered | same container as bottom; wrapper `… flex min-h-[calc(100%-56px)] items-center …` |
| Multiple / toggle between | a button inside modal A with `data-hs-overlay="#modal-b"` (+ `aria-controls`) — Preline closes A and opens B; "Back" button in B points at `#modal-a` |
| Fullscreen | wrapper `hs-overlay-animation-target m-3 h-full max-h-full sm:mx-auto sm:w-full sm:max-w-full`; panel adds `h-full max-h-full max-w-full`; body `<div class="h-full overflow-y-auto p-5">` |
| Fullscreen below breakpoint | wrapper `hs-overlay-open:mt-0 hs-overlay-animation-target hs-overlay-open:opacity-100 hs-overlay-open:duration-500 sm:hs-overlay-open:mt-10 mt-10 h-full max-h-full max-w-full opacity-0 transition-all sm:mx-auto sm:mt-0 sm:h-auto sm:max-h-none sm:max-w-lg` (container drops its opacity classes); panel `pointer-events-auto flex h-full max-h-full max-w-full flex-col card md:h-auto md:max-h-none md:max-w-lg md:rounded-xl md:border md:shadow-2xs` — swap `sm:`/`md:`/`lg:`/`xl:` for the breakpoint |
| Static backdrop | add `[--overlay-backdrop:static]` to the container (click outside / Esc won't close) |

**Gotchas.**
- The id must appear in three places: container `id`, trigger `data-hs-overlay="#id"`, and every close button `data-hs-overlay="#id"`. The demo's "Full Screen Below sm/md/lg/xl/xxl" header close buttons omit the `#` (`data-hs-overlay="exampleModalFullscreenSm"`) — that is a bug; always include `#`.
- `pointer-events-none` on the container + `pointer-events-auto` on the panel is what lets backdrop clicks close the modal — keep both.
- `z-80` is the template's overlay layer (dropdowns/popovers use `z-70`, sidebar/topbar lower). Toasts should sit above with `z-80` or higher.
- Tailwind v4 has no `xxl:` screen; the demo's "xxl" modal reuses `xl:` classes. Use `2xl:` if you really need it.
- Opening a modal from inside a dropdown menu: put `[--auto-close:inside]` on the dropdown or the menu closes first and the click is lost.
- Modals injected dynamically need `window.HSStaticMethods.autoInit()`; to open programmatically use `HSOverlay.open(document.querySelector('#id'))`.

## Offcanvas

**What it is.** Same Preline HSOverlay as modals, but the container itself is the panel: `fixed` to an edge, translated off-screen, slid in with `hs-overlay-open:translate-x-0` / `translate-y-0`. Four placements, optional backdrop and body-scroll control, dark variant.

**Use it when.**
- Filter sidebars on list pages (right drawer with a form + Apply/Reset footer).
- Record detail inspector that keeps the table visible behind it.
- Mobile navigation drawer, shopping cart, notification center.
- Bottom sheet on mobile (`offcanvasBottom`).
- Not for blocking confirmations — use a Modal.

**Source.** `references/sources/pages/ui-offcanvas.html` (no script).

**Markup.**

```html
<button data-hs-overlay="#offcanvasRight" class="btn bg-primary hover:bg-primary-hover text-white" aria-haspopup="dialog" aria-expanded="false" aria-controls="offcanvasRight">Toggle right offcanvas</button>

<div id="offcanvasRight" class="hs-overlay hs-overlay-open:translate-x-0 bg-card border-default-300 fixed end-0 top-0 z-80 hidden h-full w-full max-w-sm translate-x-full transform border-s transition-all duration-300"
     role="dialog" tabindex="-1" aria-labelledby="offcanvasRightLabel">
  <div class="flex items-center justify-between p-5">
    <h3 id="offcanvasRightLabel">Offcanvas right</h3>
    <button type="button" aria-label="Close" data-hs-overlay="#offcanvasRight"><span class="sr-only">Close</span><i class="iconify tabler--x text-xl"></i></button>
  </div>
  <div class="p-5">
    <div>Some text as placeholder.</div>
    <h5 class="mt-5 mb-2">List</h5>
    <ul class="mb-4 list-disc ps-5"><li>Nemo enim ipsam voluptatem</li><li>Neque porro quisquam est</li></ul>
  </div>
</div>
```

Placement + option classes on the container:

| Placement | Classes (replace the position/transform part) |
|---|---|
| Left (start) | `hs-overlay-open:translate-x-0 … fixed start-0 top-0 z-80 hidden h-full w-full max-w-sm -translate-x-full transform border-e` |
| Right (end) | `hs-overlay-open:translate-x-0 … fixed end-0 top-0 z-80 hidden h-full w-full max-w-sm translate-x-full transform border-s` |
| Top | `hs-overlay-open:translate-y-0 … fixed inset-x-0 top-0 z-80 hidden size-full max-h-60 -translate-y-full transform border-b` |
| Bottom | `hs-overlay-open:translate-y-0 … fixed inset-x-0 bottom-0 z-80 hidden size-full max-h-60 translate-y-full transform border-t` |
| Allow body scroll | add `[--body-scroll:true]` |
| No backdrop | add `[--overlay-backdrop:false]` |
| Dark drawer | add `dark` class (or `data-theme="dark"`) to the container; header `text-default-700`, body `text-default-900` so text flips with the local theme |

All variants keep `bg-card border-default-300 transition-all duration-300`, `role="dialog" tabindex="-1" aria-labelledby`.

**Gotchas.**
- Width is `w-full max-w-sm` (24 rem). For a wide inspector use `max-w-lg`/`max-w-2xl`; keep `w-full` so it is full-width on phones.
- The panel has no internal scroll by default — add `overflow-y-auto` to the body div (or wrap it in `data-simplebar`) for long filter forms.
- Left/right drawers use logical `start`/`end` and `-translate-x-full`; Preline flips them in RTL automatically, no extra classes.

## Tabs

**What it is.** Preline HSTabs. A `<nav role="tablist">` of `<button data-hs-tab="#panel" role="tab">` buttons; the one with class `active` is shown first. Panels are plain `div`s with the matching `id`, `role="tabpanel"`, and `hidden` on the non-active ones. Style the active state with `hs-tab-active:*` variants.

**Use it when.**
- Sectioned detail pages: Overview / Activity / Settings inside a card.
- Vertical settings navigation (pills on the left, content on the right).
- Compact icon tabs on mobile that expand to icon + label at `md:`.
- Tabs in the card header (`nav-tabs` + `nav-link`) when the card title and tabs share a row.
- For URL-driven navigation between pages use links in the sidenav, not tabs.

**Source.** `references/sources/pages/ui-tabs.html` (no script).

**Markup.**

```html
<!-- default boxed tabs -->
<nav class="flex flex-wrap" aria-label="Tabs" role="tablist" data-hs-tab-select="#tab-select">
  <button type="button" class="hs-tab-active:border-b-transparent hs-tab-active:bg-card border-default-300 hs-tab-active:border hs-tab-active:text-primary hover:text-primary active inline-flex items-center rounded-t border-b px-4 py-2 text-center font-medium focus:outline-hidden disabled:pointer-events-none disabled:opacity-50"
          id="overview" aria-selected="true" data-hs-tab="#default-overview" aria-controls="default-overview" role="tab">Overview</button>
  <button type="button" class="hs-tab-active:border-b-transparent hs-tab-active:bg-card border-default-300 hs-tab-active:border hs-tab-active:text-primary hover:text-primary inline-flex items-center rounded-t border-b px-4 py-2 text-center font-medium focus:outline-hidden disabled:pointer-events-none disabled:opacity-50"
          id="activity" aria-selected="false" data-hs-tab="#default-activity" aria-controls="default-activity" role="tab">Activity</button>
  <button type="button" class="… same …" id="disabled" data-hs-tab="#default-Disabled" role="tab" disabled>Disabled</button>
</nav>
<div class="mt-5">
  <div id="default-overview" role="tabpanel" aria-labelledby="overview"><p>Overview content…</p></div>
  <div id="default-activity" role="tabpanel" class="hidden" aria-labelledby="activity"><p>Activity content…</p></div>
</div>

<!-- vertical pills (left nav, right content) -->
<div class="grid grid-cols-1 md:grid-cols-4 gap-base">
  <nav aria-label="Tabs" role="tablist">
    <button type="button" class="hs-tab-active:bg-primary hs-tab-active:text-white hover:text-primary active inline-flex w-full items-center rounded px-4 py-2 text-center font-medium focus:outline-hidden disabled:pointer-events-none disabled:opacity-50" id="vertical-overview" data-hs-tab="#v-pills-home-tab" aria-controls="v-pills-home-tab" role="tab">Overview</button>
    <!-- repeat per tab -->
  </nav>
  <div class="md:col-span-3">
    <div id="v-pills-home-tab" role="tabpanel" aria-labelledby="vertical-overview">…</div>
    <div id="v-pills-profile-tab" class="hidden" role="tabpanel">…</div>
  </div>
</div>

<!-- tabs in the card header -->
<div class="card">
  <div class="card-header border-dashed">
    <h4 class="card-title">Card with Tabs</h4>
    <nav class="nav-tabs" aria-label="Tabs" role="tablist">
      <button type="button" class="nav-link hs-tab-active:border-b hs-tab-active:border-primary hs-tab-active:text-primary hover:text-primary active" id="summary" data-hs-tab="#home-ct" aria-controls="home-ct" role="tab">
        <i class="iconify tabler--smart-home block md:hidden"></i><div class="hidden md:block">Summary</div>
      </button>
      <!-- repeat -->
    </nav>
  </div>
  <div class="card-body">
    <div id="home-ct" role="tabpanel" aria-labelledby="summary">…</div>
  </div>
</div>
```

Variants (tab button classes; always keep `inline-flex items-center px-4 py-2 text-center font-medium focus:outline-hidden disabled:pointer-events-none disabled:opacity-50`):

| Variant | nav classes | button active/hover classes |
|---|---|---|
| Default boxed | `flex flex-wrap` | `hs-tab-active:border-b-transparent hs-tab-active:bg-card border-default-300 hs-tab-active:border hs-tab-active:text-primary hover:text-primary rounded-t border-b` |
| Justified | `flex flex-wrap md:flex-nowrap` | boxed classes + `w-auto justify-center md:w-full` |
| Vertical pills (left or right column) | plain `<nav>` inside `grid md:grid-cols-4` (put `nav` after the `md:col-span-3` panel div for right-side nav) | `hs-tab-active:bg-primary hs-tab-active:text-white hover:text-primary w-full rounded` (secondary: `hs-tab-active:bg-secondary hover:text-secondary`) |
| Bordered (underline) | `border-default-300 flex flex-wrap border-b` | `hs-tab-active:border-b hs-tab-active:border-primary hs-tab-active:text-primary hover:text-primary` |
| Bordered coloured | `border-default-300 flex border-b` | same with `danger` / `success`; icon + `<div class="hidden md:block">Label</div>`, `w-auto justify-center gap-1 md:w-full` |
| Icon-only | `border-default-300 flex flex-wrap border-b` | bordered classes; content `<i class="iconify tabler--smart-home size-5.5"></i>` |
| Card header | `nav-tabs` (template class: flex, `gap-2`, negative margins to sit flush in `.card-header`) | `nav-link` + `hs-tab-active:border-b hs-tab-active:border-primary hs-tab-active:text-primary hover:text-primary` |

**Gotchas.**
- Preline keys the initial tab off the **`active` class**, not `aria-selected`. The demo has `aria-selected="true"` on the first button but `active` on the second — Preline shows the second. Keep `active`, `aria-selected="true"`, and the un-`hidden` panel on the same tab.
- `data-hs-tab-select="#tab-select"` points to an optional `<select>` for mobile; no such select exists on the page, the attribute is harmless but you can drop it.
- Ids must be unique per page; the demo reuses `home-icon`, `profile-icon` etc. across two cards — rename when copying more than one example.
- Tab panels are not lazy; charts inside hidden panels need a re-render on `click` of the tab (listen on the button) because they measure a `display:none` container at init.

## Accordions

**What it is.** Preline HSAccordion. `hs-accordion-group` → `hs-accordion` items (class `active` = open) → `hs-accordion-toggle` button + `hs-accordion-content` region. State styling through `hs-accordion-active:*` variants (`bg-default-100` on the toggle, `rotate-180` on the chevron).

**Use it when.**
- FAQ / help pages, policy sections.
- Grouped settings where only one group should be open at a time.
- Order or invoice line-item details, shipment timeline sections.
- Always-open variant (independent toggles) for multi-section forms where several may be expanded.
- For a single "show more" use Collapse instead.

**Source.** `references/sources/pages/ui-accordions.html` (no script).

**Markup.**

```html
<div class="hs-accordion-group divide-default-300 border-default-300 divide-y rounded border overflow-hidden">
  <div class="hs-accordion active" id="headingOne">
    <button class="hs-accordion-toggle hs-accordion-active:bg-default-100 font-secondary flex w-full items-center justify-between px-5 py-4 font-semibold transition"
            aria-expanded="true" aria-controls="collapseOne">
      Accordion Item #1
      <i class="iconify tabler--chevron-down hs-accordion-active:rotate-180 transition-transform text-base"></i>
    </button>
    <div id="collapseOne" class="hs-accordion-content border-default-300 w-full overflow-hidden border-t transition-[height] duration-300" role="region" aria-labelledby="headingOne">
      <div class="px-5 py-4"><strong>This is the first item's accordion body.</strong> …</div>
    </div>
  </div>
  <div class="hs-accordion" id="headingTwo">
    <button class="hs-accordion-toggle hs-accordion-active:bg-default-100 font-secondary flex w-full items-center justify-between px-5 py-4 font-semibold transition" aria-expanded="false" aria-controls="collapseTwo">
      Accordion Item #2 <i class="iconify tabler--chevron-down hs-accordion-active:rotate-180 transition-transform text-base"></i>
    </button>
    <div id="collapseTwo" class="hs-accordion-content border-default-300 hidden w-full overflow-hidden border-t transition-[height] duration-300" role="region" aria-labelledby="headingTwo">
      <div class="px-5 py-4">…</div>
    </div>
  </div>
  <!-- repeat per item -->
</div>
```

Variants:

| Variant | Change |
|---|---|
| Default | group `hs-accordion-group divide-default-300 border-default-300 divide-y rounded border overflow-hidden`; content has `border-t` |
| Flush | group `hs-accordion-group rounded`; each item `hs-accordion border-default-300 border-b`; content **without** `border-t` |
| Always open (independent) | drop `hs-accordion-group` — wrap items in a plain `div class="divide-default-300 border-default-300 divide-y rounded border"`; each `hs-accordion` toggles on its own |
| Without arrow | omit the `<i>` in the toggle |
| Bordered (separated) | group `hs-accordion-group`; each item `hs-accordion border border-default-300 rounded` + `mt-2` on all but the first |
| Custom icon | `<i class="iconify tabler--plus hs-accordion-active:hidden text-base"></i><i class="iconify tabler--minus hs-accordion-active:flex hidden text-base"></i>` |

**Gotchas.**
- The `id` lives on the `.hs-accordion` item (not the button) and is referenced by the content's `aria-labelledby`; the content `id` is referenced by the button's `aria-controls`. Preline needs both pairs.
- Initially-closed content must have `hidden`; initially-open item needs `active` on the item **and** no `hidden` on the content.
- `font-secondary` on the toggle switches to the skin's secondary font (Open Sans by default) — drop it if you want body font.
- The demo sets `aria-expanded="true"` on every toggle; Preline rewrites it, but set the real initial value when generating markup.

## Collapse

**What it is.** Preline HSCollapse: a toggle with `data-hs-collapse="#target"` and class `hs-collapse-toggle` animates a `.hs-collapse` target's height. Text/icon swaps use `hs-collapse-open:*` variants (which apply when either the toggle or the target has `.open`).

**Use it when.**
- "Read more / Read less" on long descriptions.
- Reveal advanced filters or optional form fields.
- Expand a code/preview block under a card.
- For grouped exclusive sections use Accordions.

**Source.** `references/sources/pages/ui-collapse.html` (no script).

**Markup.**

```html
<!-- button toggle, initially open -->
<button class="hs-collapse-toggle btn bg-primary hover:bg-primary-hover text-white open" data-hs-collapse="#collapseExample">Collapse Button</button>
<div id="collapseExample" class="hs-collapse open w-full overflow-hidden shadow transition-[height] duration-300">
  <div class="card border border-dashed border-light card-body">Anim pariatur cliche reprehenderit…</div>
</div>

<!-- read more / read less, initially closed -->
<div id="show-hide-collapse-heading" class="hs-collapse hidden w-full overflow-hidden transition-[height] duration-300" aria-labelledby="show-hide-collapse">
  <p class="mt-2">Hidden paragraph…</p>
</div>
<p class="mt-2">
  <button type="button" class="hs-collapse-toggle inline-flex items-center gap-x-1 text-sm font-semibold rounded-lg border border-transparent text-primary decoration-2 hover:underline focus:outline-hidden focus:underline"
          id="show-hide-collapse" aria-expanded="false" aria-controls="show-hide-collapse-heading" data-hs-collapse="#show-hide-collapse-heading">
    <span class="hs-collapse-open:hidden">Read more</span>
    <span class="hs-collapse-open:block hidden">Read less</span>
    <i class="iconify tabler--chevron-up hs-collapse-open:rotate-180 shrink-0 text-base"></i>
  </button>
</p>
```

**Gotchas.**
- Initial state: closed = `hidden` on the target (no `open` anywhere); open = `open` on **both** toggle and target, and no `hidden`.
- `transition-[height] duration-300` + `overflow-hidden` on the target are required for the animation; without them it snaps.
- The demo's `hover:primary-hover` / `focus:primary-hover` classes are typos (not valid utilities) — use `hover:text-primary-hover`.

## Tooltips

**What it is.** Preline HSTooltip. Wrapper `hs-tooltip inline-block [--placement:top]`, trigger `hs-tooltip-toggle`, and a `hs-tooltip-content` span (absolute, `invisible opacity-0`, shown via `hs-tooltip-shown:*`). Dark pill by default; colour variants swap `bg-dark`.

**Use it when.**
- Icon-only buttons in toolbars (edit/delete/download) — always add a tooltip.
- Explain a metric or abbreviation inline in text (`<button class="hs-tooltip-toggle text-primary">`).
- Show the full value of a truncated table cell.
- Use Popovers when you need a title + paragraph or click-to-open.

**Source.** `references/sources/pages/ui-tooltips.html` (no script).

**Markup.**

```html
<div class="hs-tooltip inline-block [--placement:top]">
  <button type="button" class="hs-tooltip-toggle btn bg-info hover:bg-info-hover text-white">
    Tooltip on top
    <span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible bg-dark invisible absolute z-10 inline-block rounded py-2 px-3 text-sm font-medium text-white opacity-0 shadow-2xs transition-opacity" role="tooltip">Tooltip on top</span>
  </button>
</div>

<!-- inline in prose -->
<span class="hs-tooltip inline-block [--placement:top]">
  <button type="button" class="hs-tooltip-toggle text-primary"> custom dashboards
    <span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible bg-dark invisible absolute z-10 inline-block rounded py-2 px-3 text-sm font-medium text-white opacity-0 shadow-2xs transition-opacity" role="tooltip">Manage your dashboard easily</span>
  </button>
</span>
```

Variants:

| Variant | Change |
|---|---|
| Placement | `[--placement:top|bottom|left|right]` on the wrapper; omit for auto-flip |
| Colour | swap `bg-dark` for `bg-primary`/`bg-danger`/`bg-info`/`bg-success`/`bg-secondary`/`bg-warning`; add `w-46` for a fixed-width multi-line tip |
| HTML content | any inline HTML inside the content span (`<em>`, `<u>`, `<b>`, `<br />`) |
| Disabled trigger | the demo puts `hs-tooltip-toggle` on the `disabled` button; disabled buttons don't fire hover, so for a reliable tip move `hs-tooltip-toggle` + `tabindex="0"` to a wrapping `<span>` (as Popovers do) |

**Gotchas.**
- The content span **must be inside** the `hs-tooltip-toggle` element (not a sibling) in this markup pattern.
- `z-10` is fine inside cards; inside a modal use `z-80`/`z-90` or the tip renders under the dialog.
- Tooltips on elements added after load need `window.HSStaticMethods.autoInit()`.

## Popovers

**What it is.** The same Preline HSTooltip plugin configured as a popover: `[--trigger:click]` (or `hover`), a `div.hs-tooltip-toggle` wrapper with `tabindex="0"` around the button, and a card-like content box (`w-70`, header + body) at `z-70`.

**Use it when.**
- "Need help?" / "What's this?" affordances next to form fields with a title and a sentence of guidance.
- Feature hints on hover for a toolbar.
- Lightweight contextual info on a disabled control (works because the toggle is the wrapper, not the button).
- Dismiss-on-next-click behaviour is the default for click trigger (outside click closes).

**Source.** `references/sources/pages/ui-popovers.html` (no script).

**Markup.**

```html
<div class="hs-tooltip inline-block [--placement:right] [--trigger:click]">
  <div class="hs-tooltip-toggle block text-center" tabindex="0">
    <button type="button" class="btn bg-info hover:bg-info-hover text-white disabled:pointer-events-none disabled:opacity-50">Get Support Info</button>
    <div class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible border-default-300 invisible absolute z-70 hidden w-70 rounded-md border bg-card text-start opacity-0 transition-opacity" role="tooltip">
      <div class="bg-default-100 border-default-300 border-b px-3.5 py-3"><h3>Need Help?</h3></div>
      <div class="p-5">Click here to get support from our team. We're here 24/7 to assist you.</div>
    </div>
  </div>
</div>

<!-- coloured popover -->
<div class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible invisible absolute z-70 hidden w-55 text-start text-white opacity-0 transition-opacity" role="tooltip">
  <div class="bg-primary rounded-t-md px-3.5 py-3"><h3>Primary Popover</h3></div>
  <div class="bg-primary rounded-b-md px-4 py-2">This is a primary-themed popover.</div>
</div>

<!-- body-only popover (e.g. on a disabled button) -->
<div class="hs-tooltip inline-block [--placement:top] [--trigger:click]">
  <div class="hs-tooltip-toggle block text-center" tabindex="0">
    <button type="button" class="btn bg-primary text-white" disabled>Disabled Button</button>
    <div class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible border-default-300 invisible absolute z-70 hidden w-70 rounded-md border bg-card p-5 text-start opacity-0 transition-opacity" role="tooltip">This button is disabled, but the popover still works.</div>
  </div>
</div>
```

Variants: `[--trigger:click]` (default popover) or `[--trigger:hover]`; `[--placement:top|bottom|right|left]`; colours `primary success danger info dark secondary` (`w-55 text-white`, header `bg-{c} rounded-t-md`, body `bg-{c} rounded-b-md`).

**Gotchas.**
- Popover content is `hidden` + `invisible` (tooltip content is only `invisible`) — keep `hidden` so the box doesn't take layout space before first open.
- `hs-tooltip-toggle` is a `div` with `tabindex="0"` here; the button inside is purely visual. Keyboard users open it with Enter/Space on the wrapper.
- `z-70` sits above cards and dropdown menus but below modals (`z-80`); bump it when used inside a modal.

## Notifications (toasts)

**What it is.** Static toast markup — a bordered `bg-default-100` box with a header row (brand icon, title, timestamp, close) and a body — dismissed with Preline `data-hs-remove-element`. There is **no toast JS** in the template (no page script, nothing in app.js): placement and stacking are plain Tailwind positioning.

**Use it when.**
- "Saved", "Copied", "3 files uploaded" confirmations after an action.
- Background job completed / new message arrived notifications (stack top-right).
- Toasts with an action ("Undo", "View") — the custom-content variant with `btn btn-sm` buttons.
- For messages that must stay until acknowledged use Alerts inside the page.

**Source.** `references/sources/pages/ui-notifications.html` (no script).

**Markup.**

```html
<!-- basic toast -->
<div id="dismiss-toast" class="hs-removing:translate-x-5 hs-removing:opacity-0 bg-default-100 border-default-300 max-w-xs rounded-md border shadow transition duration-300" role="alert" tabindex="-1" aria-labelledby="dismiss-button-label">
  <div class="border-default-300 flex items-center border-b px-3 py-2">
    <p id="dismiss-button-label" class="text-default-600 flex items-center gap-1.5 text-sm"><img src="assets/images/logo-sm.png" alt="brand-logo" class="size-4" /><strong class="me-auto font-semibold">BRAND</strong></p>
    <div class="ms-auto flex items-center gap-2">
      <span class="text-default-400 text-xs">11 mins ago</span>
      <button type="button" class="flex items-center justify-center opacity-50 hover:opacity-100 focus:opacity-100 focus:outline-hidden" aria-label="Close" data-hs-remove-element="#dismiss-toast"><i class="iconify tabler--x text-default-800 size-6"></i></button>
    </div>
  </div>
  <div class="p-3 text-sm">Hello, world! This is a toast message.</div>
</div>

<!-- placement: demo centers it inside a relative card; for a real app use a fixed stack -->
<div class="fixed top-5 end-5 z-80 space-y-base">      <!-- stacking container (space-y-base = 20px) -->
  <div id="toast-1" class="hs-removing:translate-x-5 hs-removing:opacity-0 bg-default-100 border-default-300 w-60 rounded-md border shadow transition duration-300 md:w-80" role="alert">…</div>
  <div id="toast-2" …>…</div>
</div>

<!-- custom content: solid colour, and one with action buttons -->
<div id="Custom-toast2" class="hs-removing:translate-x-5 hs-removing:opacity-0 bg-primary border-default-300 max-w-xs rounded-md border transition duration-300" role="alert">
  <div class="border-default-300 flex items-center border-b p-3 text-white">
    <p class="flex items-center gap-1.5 text-sm">Hello, world! This is a toast message.</p>
    <div class="ms-auto flex items-center gap-2"><button type="button" class="flex items-center justify-center opacity-50 hover:opacity-100" aria-label="Close" data-hs-remove-element="#Custom-toast2"><i class="iconify tabler--x text-2xl"></i></button></div>
  </div>
</div>
<div id="Custom-toast3" class="hs-removing:translate-x-5 hs-removing:opacity-0 bg-default-100 border-default-300 max-w-xs rounded-md border p-3 transition duration-300" role="alert">
  <div class="border-default-300 text-default-600 flex items-center border-b pb-3"><p class="flex items-center gap-1.5 text-sm">Hello, world! This is a toast message.</p></div>
  <div class="mt-3 flex items-center gap-1">
    <button class="btn btn-sm bg-primary hover:bg-primary-hover text-white">Take action</button>
    <button class="btn btn-sm bg-secondary hover:bg-secondary-hover text-white" aria-label="Close" data-hs-remove-element="#Custom-toast3">Close</button>
  </div>
</div>
```

**Init / JS.** Nothing ships. To show a toast programmatically: build the markup string with a unique id, append it to a fixed container (`fixed top-5 end-5 z-80 space-y-base`), then call `window.HSStaticMethods.autoInit(['remove-element'])` so the close button binds; auto-hide with `setTimeout(() => el.classList.add('hs-removing'), 4000)` followed by `el.remove()` after 300 ms, or instantiate `new HSRemoveElement(btn)` and trigger its click.

**Gotchas.**
- The "Placement" demo uses `absolute start-1/2 top-45 -translate-x-1/2` inside the card purely for illustration; use `fixed` + `z-80` (above modals) in production.
- `hs-removing:translate-x-5` animates to the right — on RTL pages Preline still uses `translate-x`, so consider `hs-removing:opacity-0` only.

## Pagination

**What it is.** No pagination component class is used in the demo (a `.pagination` helper exists in the CSS but only centers and flips icons for RTL). A pagination is a `<nav aria-label="Pagination">` of `<button>`s styled as joined (`-space-x-px` + `first:rounded-s-md last:rounded-e-md`) or boxed (`gap-1.5` + fixed `size-*`) items.

**Use it when.**
- Below any table/list that pages server-side (DataTables pages have their own; use this for custom lists).
- Gallery, search results, log viewers.
- Small variant inside card footers; boxed/rounded variants for marketing-style pages.

**Source.** `references/sources/pages/ui-pagination.html` (no script).

**Markup.**

```html
<!-- default joined pagination with prev/next, disabled + active -->
<nav class="flex items-center -space-x-px" aria-label="Pagination">
  <button type="button" class="text-default-400 border-default-300 inline-flex items-center justify-center gap-x-1.5 border px-3 py-1.5 first:rounded-s-md last:rounded-e-md" aria-label="Previous" disabled><span>Previous</span></button>
  <button type="button" class="border-default-300 hover:bg-default-100 hover:text-primary flex items-center justify-center border px-3 py-1.5 transition-all duration-300 first:rounded-s-md last:rounded-e-md" aria-current="page">1</button>
  <button type="button" class="border-default-300 bg-primary hover:bg-default-100 hover:text-primary flex items-center justify-center border px-3 py-1.5 text-white transition-all duration-300">2</button>   <!-- active -->
  <button type="button" class="border-default-300 hover:bg-default-100 hover:text-primary flex items-center justify-center border px-3 py-1.5 transition-all duration-300 first:rounded-s-md last:rounded-e-md">3</button>
  <button type="button" class="border-default-300 hover:bg-default-100 hover:text-primary inline-flex items-center justify-center gap-x-1.5 border px-3 py-1.5 transition-all duration-300 first:rounded-s-md last:rounded-e-md" aria-label="Next"><span>Next</span></button>
</nav>

<!-- boxed with icons -->
<nav class="flex items-center gap-1.5" aria-label="Pagination">
  <button type="button" class="border-default-300 hover:bg-default-100 hover:text-primary flex size-8.75 items-center justify-center gap-x-1.5 rounded border transition-all duration-300" aria-label="Previous"><i class="iconify tabler--chevron-left"></i></button>
  <button type="button" class="border-default-300 hover:bg-default-100 hover:text-primary flex size-8.75 items-center justify-center rounded border transition-all duration-300" aria-current="page">1</button>
  <button type="button" class="bg-primary flex size-8.75 items-center justify-center rounded text-white">2</button>   <!-- active -->
  <button type="button" class="border-default-300 hover:bg-default-100 hover:text-primary flex size-8.75 items-center justify-center gap-x-1.5 rounded border transition-all duration-300" aria-label="Next"><i class="iconify tabler--chevron-right"></i></button>
</nav>
```

Variant matrix:

| Variant | nav | item | active item |
|---|---|---|---|
| Default (joined) | `flex items-center -space-x-px` | `border-default-300 hover:bg-default-100 hover:text-primary flex items-center justify-center border px-3 py-1.5 transition-all duration-300 first:rounded-s-md last:rounded-e-md` | add `bg-primary text-white` |
| Alignment | add `justify-center` / `justify-end` to nav | — | — |
| Disabled | — | `text-default-400 border-default-300 …` + `disabled` (drop hover classes) | — |
| Large / small (joined) | same | `px-6 py-3 text-base` / `px-2 py-1` | — |
| Boxed | `flex items-center gap-1.5` | `… flex size-8.75 items-center justify-center rounded border …` | `bg-primary flex size-8.75 items-center justify-center rounded text-white` |
| Boxed sizes | same | `size-12.5 text-base` (lg) / `size-8.75` / `size-7.25` (sm) | same size |
| Rounded (circles) | `flex items-center gap-1.5` | boxed classes with `rounded-full` | `bg-primary … rounded-full text-white` |
| Soft | same | boxed classes with `hover:text-danger` | `text-danger bg-danger/10 flex size-8.75 items-center justify-center rounded` |
| Custom colour | same | boxed | `bg-info` / `bg-secondary` + `text-white` |
| Icons | — | `tabler--chevron-left/right`, `tabler--arrow-left/right`, or `«` / `»` text (`<span>«</span>`) | — |

**Gotchas.**
- The demo's active items keep `hover:bg-default-100 hover:text-primary`, so hovering the active page washes it out — drop the hover classes on the active item.
- Use `<a href>` instead of `<button>` for crawlable server-side paging; classes are identical.
- Wrap with `.pagination` only if you want the RTL icon flip and centering it provides.

## Breadcrumb

**What it is.** `<nav><ol class="flex items-center whitespace-nowrap">` with `<li class="inline-flex items-center">` links separated by `tabler--chevron-right` icons; the current item is `text-default-400 … aria-current="page"`. The page-title breadcrumb (in `.page-title-head`) is the same idea with `gap-1.25 text-sm`.

**Use it when.**
- Page header (already in the page skeleton: `.page-title-head` → `hidden items-center gap-1.25 text-sm md:flex`).
- File-manager path, category drill-down, settings sub-pages.
- Inside a card header with a light background (`bg-light/50 p-2.5`).

**Source.** `references/sources/pages/ui-breadcrumb.html` (no script).

**Markup.**

```html
<nav class="py-2.5">
  <ol class="flex items-center whitespace-nowrap">
    <li class="inline-flex items-center">
      <a class="text-default-600 hover:text-primary flex items-center font-medium" href="#">Home</a>
      <i class="iconify tabler--chevron-right text-default-400 m-0.75 text-base pe-1"></i>
    </li>
    <li class="inline-flex items-center">
      <a class="text-default-600 hover:text-primary flex items-center font-medium" href="#">Library</a>
      <i class="iconify tabler--chevron-right text-default-400 m-0.75 text-base pe-1"></i>
    </li>
    <li class="text-default-400 inline-flex items-center truncate font-medium" aria-current="page">Data</li>
  </ol>
</nav>

<!-- with icons, on a light strip -->
<nav class="bg-light/50 p-2.5 mb-2.5">
  <ol class="flex items-center whitespace-nowrap">
    <li class="inline-flex items-center">
      <a class="hover:text-primary flex items-center font-medium" href="#"><i class="iconify tabler--smart-home me-1.25"></i> Home</a>
      <i class="iconify tabler--chevron-right text-default-400 m-0.75 text-base pe-1"></i>
    </li>
    <li class="text-default-400 inline-flex items-center truncate font-medium" aria-current="page">Library</li>
  </ol>
</nav>

<!-- page-title variant (what every page uses) -->
<div class="page-title-head">
  <h4 class="page-main-title">Breadcrumb</h4>
  <div class="hidden items-center gap-1.25 text-sm md:flex">
    <a href="#" class="text-sm">Inspinia</a><i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i>
    <a href="#" class="text-sm">Base UI</a><i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i>
    <a href="#" class="text-default-400 text-sm" aria-current="page">Breadcrumb</a>
  </div>
</div>
```

**Gotchas.**
- Add `rtl:rotate-180` to the chevron (the page-title variant does; the card examples don't) if you ship RTL.
- `truncate` on the current item plus `whitespace-nowrap` on the `ol` keeps long titles on one line — give the `ol` `overflow-hidden` if it can overflow.

## List group

**What it is.** No list-group class — a bordered `ul`/`div` with `divide-y` and padded `flex items-center gap-1.25 px-4 py-2.5` rows. Active/disabled/contextual states, link/button rows, badges, checkboxes, and custom multi-line content are all utility combinations.

**Use it when.**
- Integrations / connected apps lists, notification preference lists (checkbox/radio rows).
- Inbox-style counts with trailing badges, "top products" ranked lists.
- Simple navigation within a card (link rows with `hover:bg-default-100`).
- Horizontal chip rows (`inline-flex divide-x`).
- For sortable or large data use Tables / DataTables instead.

**Source.** `references/sources/pages/ui-list-group.html` (no script).

**Markup.**

```html
<ul class="border-default-300 divide-default-300 divide-y rounded border">
  <li class="bg-default-100 flex items-center gap-1.25 px-4 py-2.5">GitHub Repository</li>             <!-- active -->
  <li class="flex items-center gap-1.25 px-4 py-2.5">Figma Design Tool</li>
  <li class="bg-default-100 text-default-400 flex items-center gap-1.25 px-4 py-2.5">Disabled item</li>  <!-- disabled -->
</ul>

<!-- links and buttons -->
<div class="border-default-300 divide-default-300 divide-y rounded border">
  <a href="#" class="bg-default-100 flex items-center gap-1.25 px-4 py-2.5">Stripe Payment Integration</a>
  <a href="#" class="hover:bg-default-100 flex items-center gap-1.25 px-4 py-2.5">Dropbox Cloud Service</a>
  <button type="button" class="hover:bg-default-100 focus:bg-default-100 flex w-full items-center gap-1.25 px-4 py-2.5">Slack Communication</button>
</div>

<!-- with badges -->
<li class="flex items-center justify-between gap-1.25 px-4 py-2.5">Urgent Tickets <span class="badge bg-danger text-white rounded-full">99+</span></li>

<!-- checkbox / radio rows -->
<div class="divide-default-300 border-default-300 divide-y rounded border">
  <div class="flex items-center gap-2 px-4 py-2.5"><input type="checkbox" class="form-checkbox size-4.25" id="newsletterCheckbox" /><label for="newsletterCheckbox">Subscribe to newsletter</label></div>
  <div class="flex items-center gap-2 px-4 py-2.5"><input type="radio" name="n" class="form-checkbox size-4.25 rounded-full" id="emailRadio" checked /><label for="emailRadio">Notify by Email</label></div>
</div>

<!-- custom content -->
<a href="#" class="hover:bg-default-100 focus:bg-default-100 block px-4 py-2.5">
  <div class="flex items-center justify-between"><h5 class="mb-2">List group item heading</h5><small class="text-2xs">3 days ago</small></div>
  <p class="mb-1">Donec id elit non mi porta gravida at eget metus.</p><small class="text-2xs">Donec id elit non mi porta.</small>
</a>

<!-- numbered -->
<li class="flex justify-between gap-1.25 px-4 py-2.5">
  <div class="flex gap-3"><div>1.</div><div><div class="font-bold">Admin Dashboard Pro</div> A premium admin dashboard.</div></div>
  <div><span class="badge bg-primary text-white rounded-full">865</span></div>
</li>
```

Variants:

| Variant | Classes |
|---|---|
| Flush | plain `<ul>` (no border/divide), same `li` padding |
| Horizontal | `ul class="divide-default-300 border-default-300 inline-flex divide-x rounded border"` + `li class="px-4 py-2.5"` |
| Contextual | `li class="text-{c} bg-{c}/15 border-{c} border border-t-0 px-4 py-2.5"` inside `ul class="border-default-300 rounded border"`; light: `bg-light/15 text-default-400 border-light` |
| Contextual links | `a class="hover:bg-{c}/40 bg-{c}/15 border-{c} block border border-t-0 px-4 py-2.5"` |

**Gotchas.**
- Rows use `gap-1.25` (5 px) and `py-2.5`; match these in custom rows so lists line up across cards.
- Radios reuse `form-checkbox` + `rounded-full` (there is a `form-radio` class in the forms group; both render fine).

## Progress

**What it is.** Track `bg-default-100 flex h-4 w-full overflow-hidden rounded` + bar `bg-{c} … transition duration-500` with inline `style="width: N%"` and ARIA values. Stripes come from the template classes `progress-striped` and `animate-progress-stripes`. A step indicator is a flex `ul` of numbered circles joined by `h-0.5` connectors.

**Use it when.**
- Upload / import progress, storage or quota usage, profile completeness.
- Multi-segment bars (used vs reserved vs free) with several bars in one track.
- Thin `h-0.75`/`h-1.25` bars under KPI numbers in widgets.
- Numbered step headers for wizards (pair with `hs-stepper` from the forms group for real step logic).

**Source.** `references/sources/pages/ui-progress.html` (no script).

**Markup.**

```html
<div class="bg-default-100 flex h-4 w-full overflow-hidden rounded" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
  <div class="bg-primary flex flex-col justify-center overflow-hidden text-center whitespace-nowrap transition duration-500" style="width: 25%"></div>
</div>

<!-- with label -->
<div class="bg-default-100 flex h-4 w-full overflow-hidden rounded" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100">
  <div class="bg-primary flex flex-col justify-center overflow-hidden text-center text-2xs whitespace-nowrap text-white" style="width: 25%">25%</div>
</div>

<!-- multiple bars -->
<div class="bg-default-100 flex h-4 w-full overflow-hidden rounded">
  <div class="bg-primary flex flex-col justify-center overflow-hidden whitespace-nowrap" style="width: 15%" role="progressbar" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100"></div>
  <div class="bg-success flex flex-col justify-center overflow-hidden whitespace-nowrap" style="width: 30%" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
  <div class="bg-info flex flex-col justify-center overflow-hidden whitespace-nowrap" style="width: 20%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
</div>

<!-- striped + animated -->
<div class="bg-default-100 h-4 w-full overflow-hidden rounded">
  <div class="bg-primary progress-striped h-4 animate-progress-stripes" style="width: 75%" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100"></div>
</div>

<!-- steps -->
<ul class="flex w-full items-center justify-between">
  <li class="flex w-full items-center"><span class="bg-primary flex size-9 shrink-0 items-center justify-center rounded-full font-medium text-white">1</span><div class="bg-primary h-0.5 flex-1"></div></li>
  <li class="flex w-full items-center"><span class="bg-primary flex size-9 shrink-0 items-center justify-center rounded-full font-medium text-white">2</span><div class="bg-default-100 h-0.5 flex-1"></div></li>
  <li class="flex items-center"><span class="bg-default-100 text-default-800 flex size-9 shrink-0 items-center justify-center rounded-full font-medium">3</span></li>
</ul>
```

Variants: heights `h-px h-0.75 h-1.25 h-2 h-3 h-3.75 h-4`; colours `bg-primary bg-secondary bg-success bg-info bg-warning bg-danger bg-dark`; long overflowing label: bar `relative flex h-4 items-center overflow-visible text-2xs font-medium whitespace-nowrap`.

**Gotchas.**
- The "Striped" demo card uses `class="bg-primary progress h-4"` — `.progress` has **no rule** in app.min.css, so those bars render plain. The working class is `progress-striped` (45° white/15 % gradient, 1 rem tile); add `animate-progress-stripes` for motion.
- Update progress by setting `style.width` and `aria-valuenow` — the `transition duration-500` on the bar animates it.
- Flexbox track (`flex`) is what makes multi-segment bars line up; a non-flex track (`h-4 w-full overflow-hidden rounded`) is fine for single bars.

## Spinners

**What it is.** Pure Tailwind: border spinner = `inline-block size-8 animate-spin rounded-full border-3 border-{c} border-t-transparent`; growing spinner = `size-8 animate-[spinner-grow_0.75s_linear_infinite] rounded-full bg-{c}` (the `spinner-grow` keyframe is defined in app.min.css).

**Use it when.**
- Inside a submit button while saving (`size-4 border-2 border-white`).
- Inline "Loading…" rows, empty-state placeholders while fetching.
- Card refresh overlay (app.js already does this for `data-action="card-refresh"`).
- For whole-page/skeleton loading use Placeholders.

**Source.** `references/sources/pages/ui-spinners.html` (no script).

**Markup.**

```html
<!-- border spinner -->
<div class="border-primary inline-block size-8 animate-spin rounded-full border-3 border-t-transparent" role="status" aria-label="loading"><span class="sr-only">Loading...</span></div>
<!-- growing spinner -->
<span class="bg-primary size-8 animate-[spinner-grow_0.75s_linear_infinite] rounded-full"></span>

<!-- in buttons -->
<button class="btn btn-icon bg-primary"><div class="inline-block size-4 animate-spin rounded-full border-2 border-white border-t-transparent" role="status" aria-label="loading"><span class="sr-only">Loading...</span></div></button>
<button class="btn bg-primary">
  <div class="flex items-center gap-3">
    <div class="inline-block size-4 animate-spin rounded-full border-2 border-white border-t-transparent" role="status" aria-label="loading"></div>
    <span class="text-white">Loading..</span>
  </div>
</button>
<button class="btn btn-icon bg-primary rounded-full"><span class="size-4 animate-[spinner-grow_0.75s_linear_infinite] rounded-full bg-white"></span></button>

<!-- alignment -->
<div class="flex gap-base flex-wrap items-center"><strong>Loading...</strong><div class="border-dark ms-auto inline-block size-8 animate-spin rounded-full border-3 border-t-transparent" role="status"></div></div>
<div class="flex items-center justify-center gap-base"><div class="border-dark inline-block size-8 animate-spin rounded-full border-3 border-t-transparent" role="status"></div></div>
```

Variants: colours `border-primary border-secondary border-success border-danger border-warning border-info border-light border-dark` (grow: `bg-*`, plus `bg-purple`, `bg-default-200`); sizes `size-4 border-2`, `size-7`, `size-9`, `size-11` (`border-3`); grow sizes `size-4 size-6 size-7 size-11`.

**Gotchas.**
- `border-t-transparent` is what creates the gap; in RTL it stays on top, no change needed.
- The card-refresh overlay spinner in app.js is `size-8 animate-spin rounded-full border-3 border-primary border-t-transparent` — same recipe, so custom loaders match.

## Placeholders (skeletons)

**What it is.** Grey blocks (`bg-default-300` / `bg-default-400`, `block h-3.5 cursor-wait`) laid out with grid columns to mimic the eventual content, animated with `animate-pulse` or a shimmer (`animate-ping` gradient). A disabled `.btn` with `invisible` text stands in for buttons.

**Use it when.**
- Skeleton version of a card/list/table while the first fetch runs.
- Lazy-loaded widget bodies on dashboards.
- Not for short actions — use a Spinner.

**Source.** `references/sources/pages/ui-placeholders.html` (no script).

**Markup.**

```html
<div class="card border-default-300 border">
  <svg…/>   <!-- image stand-in: any fixed-height grey block, e.g. <div class="bg-default-300 h-40 w-full"></div> -->
  <div class="card-body">
    <h5 class="card-title mb-2.5 grid grid-cols-2"><span class="bg-default-300 block h-5.5 animate-pulse cursor-wait">&nbsp;</span></h5>
    <p class="card-text mb-4 grid grid-cols-12 gap-3">
      <span class="bg-default-300 col-span-7 block h-3.25 animate-pulse cursor-wait"></span>
      <span class="bg-default-300 col-span-4 block h-3.25 animate-pulse cursor-wait"></span>
      <span class="bg-default-300 col-span-4 block h-3.25 animate-pulse cursor-wait"></span>
      <span class="bg-default-300 col-span-6 block h-3.25 animate-pulse cursor-wait"></span>
    </p>
    <div class="grid grid-cols-2"><a class="btn bg-primary disabled col-span-1" aria-disabled="true"><span class="invisible">Read Only</span></a></div>
  </div>
</div>

<!-- shimmer -->
<p class="relative overflow-hidden">
  <span class="bg-default-400 relative block h-3.5 w-full overflow-hidden">
    <span class="from-default-400 via-default-300 animate-ping to-default-300 absolute inset-0 bg-linear-to-r"></span>
  </span>
</p>
```

Variants: colour `bg-{c}/60` (primary secondary success danger warning info light dark) or `bg-default-400`; widths via `col-span-N` in `grid grid-cols-12 gap-2` or `w-*`; heights `h-4` (lg) `h-3.5` `h-2.75` (sm) `h-2` (xs); animation `animate-pulse` or the shimmer above.

**Gotchas.**
- A `.placeholder` class exists in the template CSS vocabulary, but the demo page never uses it — stick to the utility recipe above so skeletons match the shipped look.
- Keep skeleton block heights equal to the real text line heights (`h-3.25` ≈ 13 px body text, `h-5.5` ≈ card title) so the layout doesn't jump when data arrives.

## Carousel

**What it is.** Preline HSCarousel configured via a JSON `data-hs-carousel` attribute on the outer `relative` wrapper. Inside: `.hs-carousel` viewport (`min-h-94 overflow-hidden`) → `.hs-carousel-body` (absolute flex row, `opacity-0` until loaded) → `.hs-carousel-slide`s. Optional `.hs-carousel-prev/next` buttons and an empty `.hs-carousel-pagination` div that Preline fills with dots styled by `dotsItemClasses`.

**Use it when.**
- Product/property image galleries, onboarding or announcement slides, testimonial rotation.
- Hero banner on a landing/marketing page.
- Not for data (use tables) and not for tab-like content (use Tabs).

**Source.** `references/sources/pages/ui-carousel.html` (no script; options inline).

**Markup.**

```html
<div data-hs-carousel='{ "loadingClasses": "opacity-0", "dotsItemClasses": "hs-carousel-active:bg-white bg-white/50 w-7.5 h-0.75 cursor-pointer", "isAutoPlay": true }' class="relative">
  <div class="hs-carousel relative min-h-94 w-full overflow-hidden bg-white">
    <div class="hs-carousel-body absolute start-0 top-0 bottom-0 flex flex-nowrap opacity-0 transition-transform duration-700">
      <div class="hs-carousel-slide"><img src="assets/images/stock/small-3.jpg" alt="First slide" /></div>
      <div class="hs-carousel-slide relative"><img src="assets/images/stock/small-2.jpg" alt="Second slide" />
        <div class="absolute bottom-0 w-full pt-4 pb-4">                       <!-- caption -->
          <h3 class="mb-2 text-center text-2xl text-white">Second slide label</h3>
          <p class="mb-4 text-center text-white">Lorem ipsum dolor sit amet.</p>
        </div>
      </div>
      <!-- repeat per slide -->
    </div>
  </div>
  <button type="button" class="hs-carousel-prev hs-carousel-disabled:opacity-50 hs-carousel-disabled:pointer-events-none absolute inset-y-0 start-5 inline-flex items-center justify-center"><i class="iconify tabler--chevron-left size-8 text-white"></i><span class="sr-only">Previous</span></button>
  <button type="button" class="hs-carousel-next hs-carousel-disabled:opacity-50 hs-carousel-disabled:pointer-events-none absolute inset-y-0 end-5 inline-flex items-center justify-center"><i class="iconify tabler--chevron-right size-8 text-white"></i><span class="sr-only">Next</span></button>
  <div class="hs-carousel-pagination absolute start-0 end-0 bottom-3 flex justify-center gap-x-2"></div>
</div>
```

**Init / JS.** Preline reads the JSON on autoinit. Options used by the demo: `"loadingClasses": "opacity-0"` (removed once ready — matches the `opacity-0` on `.hs-carousel-body`), `"dotsItemClasses"` (classes for each generated dot: `"size-3 rounded-full cursor-pointer"` for round dots, `"hs-carousel-active:bg-white bg-white/50 w-7.5 h-0.75 cursor-pointer"` for bars, `"hs-carousel-active:bg-dark bg-dark/50 …"` for the dark variant), `"isAutoPlay": true`. Other HSCarousel options (`speed`, `isInfiniteLoop`, `isDraggable`, `slidesQty`) are not exercised by the demo.

Variants: slides only (no buttons/pagination); with controls; with indicators (add the `.hs-carousel-pagination` div); captions (`relative` slide + absolute bottom block); dark variant (dark dots + `text-dark` captions, controls without `text-white`).

**Gotchas.**
- The "Individual Interval" card uses the **same** JSON as the others — the demo does not actually implement per-slide intervals.
- `min-h-94` fixes the viewport height; images must be sized to fill it (use `object-cover h-full w-full` on `<img>` for mixed aspect ratios).
- Hidden-at-load carousels (inside a collapsed tab) measure 0 width — call `HSCarousel.getInstance(el).recalculateWidth()` (or re-init) when the tab shows.

## Scrollspy

**What it is.** Preline HSScrollspy: a nav container with `data-hs-scrollspy="#content"` (and `data-hs-scrollspy-scrollable-parent="#scrollbox"` when the content scrolls inside an element rather than the window) whose `href="#section"` links get `hs-scrollspy-active:*` styling as the matching ids scroll into view. `[--scrollspy-offset:N]` tunes the trigger line; `data-hs-scrollspy-group` on an `li` keeps a parent active while its children are.

**Use it when.**
- Long settings/profile pages with a sticky section nav on the left.
- Documentation / legal pages, release notes.
- In-page navbar on a landing page (navbar example with a dropdown).

**Source.** `references/sources/pages/ui-scrollspy.html` (no script).

**Markup.**

```html
<div id="scrollspy-scrollable-parent-2" class="max-h-75 overflow-y-auto">
  <div class="grid grid-cols-1 md:grid-cols-4 lg:grid-cols-6 gap-base">
    <div class="border-default-300 md:border-e md:pe-2 lg:pe-7.5">
      <ul class="sticky top-0" data-hs-scrollspy="#scrollspy-2" data-hs-scrollspy-scrollable-parent="#scrollspy-scrollable-parent-2">
        <li data-hs-scrollspy-group="">
          <a href="#item-1" class="focus:text-primary hs-scrollspy-active:bg-primary hs-scrollspy-active:text-white active mb-1 block rounded px-4 py-2 font-medium focus:outline-hidden">Item 1</a>
          <ul>
            <li class="ms-6"><a href="#item-1-1" class="group focus:text-primary hs-scrollspy-active:bg-primary hs-scrollspy-active:text-white mb-1 block rounded px-4 py-2 text-sm leading-6 focus:outline-hidden">Item 1-1</a></li>
          </ul>
        </li>
        <li><a href="#item-2" class="focus:text-primary hs-scrollspy-active:bg-primary hs-scrollspy-active:text-white mb-1 block rounded px-4 py-2 font-medium focus:outline-hidden">Item 2</a></li>
      </ul>
    </div>
    <div class="md:col-span-3 lg:col-span-5">
      <div id="scrollspy-2" class="space-y-4">
        <h4 id="item-1" class="text-default-700 mb-2 text-lg font-bold">Item 1</h4><p>…</p>
        <h5 id="item-1-1" class="text-default-700 mb-2 text-sm font-bold">Item 1-1</h5><p>…</p>
        <h4 id="item-2" class="text-default-700 mb-2 text-lg font-bold">Item 2</h4><p>…</p>
      </div>
    </div>
  </div>
</div>

<!-- navbar variant: sticky header inside the scroll box, offset per breakpoint, dropdown with static strategy on mobile -->
<div data-hs-scrollspy="#scrollspy-example" data-hs-scrollspy-scrollable-parent="#navbar-example2" class="flex flex-wrap items-center justify-center [--scrollspy-offset:220] md:justify-end md:[--scrollspy-offset:70]">
  <a class="text-default-700 hover:text-default-500 focus:text-primary hs-scrollspy-active:text-white hs-scrollspy-active:bg-primary active rounded px-4 py-2 text-sm leading-6 focus:outline-hidden" href="#fat">@fat</a>
  <div class="hs-dropdown [--adaptive:none] [--strategy:static] lg:[--adaptive:adaptive] lg:[--placement:bottom-right] lg:[--strategy:fixed]">
    <button type="button" class="group hs-scrollspy-active:text-white hs-scrollspy-active:bg-primary text-default-700 inline-flex items-center gap-x-1 rounded px-4 py-2 text-sm" aria-haspopup="menu" aria-expanded="false">Dropdown <i class="iconify tabler--chevron-down"></i></button>
    <div class="hs-dropdown-menu" role="menu"><a class="dropdown-item" href="#one">one</a><hr class="dropdown-divider" /><a class="dropdown-item" href="#three">three</a></div>
  </div>
</div>
```

Variants: list-style nav `ul class="border-default-300 sticky top-0 rounded border"` with links `hs-scrollspy-active:bg-default-100 border-default-300 block rounded border-b px-4.75 py-3 font-medium` (sections are `div`s with the ids instead of headings).

**Gotchas.**
- Links must be `href="#id"` — Preline resolves targets from the hash; target ids must be **inside** the element named by `data-hs-scrollspy`.
- When spying on the window instead of a box, omit `data-hs-scrollspy-scrollable-parent` and account for the fixed topbar with `[--scrollspy-offset:70]`.
- Mark the first link `active` so something is highlighted before the first scroll event.

## Images & avatars

**What it is.** Plain `<img>`/`<div>` with size + radius utilities. Avatars are `size-6 … size-12` (xs–xl) with `rounded` or `rounded-full`; initials avatars are flex-centred boxes (`bg-primary text-white` or soft `bg-primary/15 text-primary`); avatar stacks use `flex -space-x-3` with a hover lift.

**Use it when.**
- User cells in tables, comment threads, assignee pickers (`size-8`/`size-9`).
- Profile headers (`size-11`/`size-12`), team member stacks with a `9+` overflow counter.
- Product thumbnails with a bordered frame (`bg-default-100 border-default-300 rounded border p-1`).

**Source.** `references/sources/pages/ui-images.html` (no script).

**Markup.**

```html
<!-- shapes -->
<img src="assets/images/stock/small-2.jpg" alt="image" class="rounded" />
<img src="assets/images/users/user-5.jpg" alt="image" class="mx-auto rounded-full" />
<img src="assets/images/stock/small-5.jpg" alt="image" class="bg-default-100 border-default-300 rounded border p-1" />   <!-- thumbnail -->

<!-- avatar sizes (image / solid initials / soft initials) -->
<img src="assets/images/users/user-4.jpg" alt="image" class="mx-auto size-9 rounded-full" />
<div class="bg-primary mx-auto flex size-9 items-center justify-center rounded-full font-medium text-white">md</div>
<div class="bg-primary/15 text-primary mx-auto flex size-9 items-center justify-center rounded-full font-medium">md</div>

<!-- avatar group -->
<div class="flex -space-x-3">
  <img src="assets/images/users/user-10.jpg" alt="" class="size-12 transform rounded-full duration-300 hover:-translate-y-0.5" />
  <div class="bg-info flex size-12 transform items-center justify-center rounded-full font-medium text-white duration-300 hover:-translate-y-0.5">D</div>
  <img src="assets/images/users/user-7.jpg" alt="" class="size-12 transform rounded-full duration-300 hover:-translate-y-0.5" />
  <div class="bg-danger flex size-12 transform items-center justify-center rounded-full text-lg font-medium text-white duration-300 hover:-translate-y-0.5">9+</div>
</div>
<!-- soft initials stack with z-lift -->
<div class="bg-primary/15 text-primary relative flex size-11 transform items-center justify-center rounded-full font-semibold backdrop-blur-sm duration-300 hover:z-10 hover:-translate-y-0.5">K</div>
```

Sizes: `size-6` xs (24 px), `size-8` sm, `size-9` md, `size-11` lg, `size-12` xl; square = `rounded`, circle = `rounded-full`.

**Gotchas.**
- An `.avatar` class exists in the template vocabulary (used by other pages) but this page builds everything with `size-*`; both approaches coexist — prefer `size-*` for one-offs.
- Later siblings overlap earlier ones in `-space-x-3`; add `relative hover:z-10` (as the soft stack does) if hover should bring one to the front.

## Links

**What it is.** Anchor colour utilities `text-{c} hover:text-{c}-hover`, emphasis `text-default-700 hover:text-default-500`, plus Tailwind decoration/opacity utilities for underline colour, underline opacity and hover effects.

**Use it when.**
- Inline links inside alerts/paragraphs that must match the alert colour.
- "View all", "Edit", "Remove" text actions in cards and table cells (danger link for destructive).
- Breadcrumb / footer links with muted emphasis.

**Source.** `references/sources/pages/ui-links.html` (no script).

**Markup.**

```html
<a href="#" class="text-primary hover:text-primary-hover">Primary link</a>
<a href="#" class="text-danger hover:text-danger-hover underline">Danger link (underlined)</a>
<a href="#" class="text-default-700 hover:text-default-500">Emphasis link</a>
<a href="#" class="text-primary hover:text-primary-hover opacity-50">Link opacity 50</a>
<a href="#" class="text-primary hover:text-primary-hover hover:opacity-75">Hover opacity 75</a>
<a href="#" class="decoration-success text-primary hover:text-primary-hover underline">Success underline</a>
<a href="#" class="decoration-primary/25 text-primary hover:text-primary-hover underline">Underline opacity 25</a>
<a href="#" class="text-primary hover:text-primary-hover hover:underline">Underline on hover</a>
```

Colour set: `primary secondary success danger warning info light dark` (+ `-hover` variants); opacities `opacity-10/25/50/75/100`; underline colours `decoration-{c}`; underline opacity `decoration-primary/0 … /75`.

**Gotchas.**
- The "Underline Offset" card does not actually use offset classes (all three are just `underline`); Tailwind's `underline-offset-2/4/8` work if you need them.
- `text-light` links are invisible on light backgrounds — only use on dark/coloured surfaces.

## Typography

**What it is.** Tailwind's text scale (`text-xs … text-9xl`) plus two template sizes (`text-2xs` = 11 px, `text-md` = 15 px), semantic headings, inline elements, list utilities, and blockquote/figcaption patterns. Body font is `--font-body`; `font-secondary` switches to the skin's secondary face (Open Sans in the default skin).

**Use it when.**
- Setting page/card copy: captions `text-default-400 text-2xs`, lead text `text-lg font-light`, highlighted text `<mark class="bg-warning/15 p-1">`.
- Feature/instruction lists (`list-inside list-disc space-y-1`, nested `ms-10`), ordered steps (`list-decimal`).
- Testimonials / quotes (`<blockquote>` + `<figcaption class="text-default-400">`).

**Source.** `references/sources/pages/ui-typography.html` (no script).

**Markup.**

```html
<h1 class="text-3xl">text-3xl</h1>                      <!-- scale: text-xs sm base lg xl 2xl … 9xl -->
<p class="text-lg font-light">Your title goes here</p>
<p class="font-light">You can use the mark tag to <mark class="bg-warning/15 p-1">highlight</mark> text.</p>
<p class="font-light"><del>deleted</del> <s>no longer accurate</s> <ins>addition</ins> <u>underlined</u> <small>fine print</small> <strong>bold</strong> <em>italic</em> <abbr title="attribute">attr</abbr></p>

<ul class="list-inside list-disc space-y-1">
  <li>Fully responsive design</li>
  <li>Multiple form elements
    <ul class="ms-10 list-inside list-disc"><li>Rich input controls</li></ul>
  </li>
</ul>
<ol class="list-inside list-decimal space-y-1"><li>Install all dependencies</li></ol>
<ul class="list-none"><li>Unstyled item</li></ul>
<ul class="flex items-center gap-4"><li>HTML</li><li>CSS</li><li>JavaScript</li></ul>   <!-- inline list -->

<figure class="mb-5 text-center">
  <blockquote><p class="mb-1 text-lg">"Design is not just what it looks like and feels like. Design is how it works."</p></blockquote>
  <figcaption class="text-default-400">-Steve Jobs in <cite title="Steve Jobs Biography">Steve Jobs Biography</cite></figcaption>
</figure>
<blockquote class="text-end"><p class="text-lg">"Simplicity is the soul of efficiency."</p></blockquote>
<figcaption class="mt-1 mb-5 text-default-400 text-end">— Austin Freeman in <cite class="italic">Efficiency in Design</cite></figcaption>
```

**Gotchas.**
- `.list-inline-item` and `.blockquote` appear in the demo but are Bootstrap-era names with no dedicated CSS; the inline list works because of `flex gap-4`, the blockquote because of the `<p class="text-lg">`.
- Headings have template defaults (`.card-title` is `text-md` semibold); pass an explicit `text-*` when you need a different size rather than relying on `h1`–`h6` defaults.

## Videos

**What it is.** A `relative aspect-* w-full` box with an `iframe class="h-full w-full"` — Tailwind aspect-ratio utilities replace Bootstrap's `ratio` helper.

**Use it when.**
- Help-center / onboarding video embeds, product demo in a landing section, media attachments in a ticket.

**Source.** `references/sources/pages/ui-videos.html` (no script).

**Markup.**

```html
<div class="relative aspect-video w-full">           <!-- 16:9 -->
  <iframe src="https://www.youtube.com/embed/zpOULjyy-n8?rel=0" class="h-full w-full"></iframe>
</div>
```

Ratios: `aspect-21/9`, `aspect-video` (16:9), `aspect-4/3`, `aspect-square` (1:1).

**Gotchas.**
- Add `allowfullscreen` and a `title` to the iframe for accessibility; the demo omits both.
- Works for `<video>` tags too: give the video `h-full w-full object-cover`.

## Colours & border tokens

**What it is.** The semantic colour system every component above relies on. Tokens are CSS variables (`--color-*`) consumed through standard Tailwind utilities (`bg-`, `text-`, `border-`, `decoration-`, `from-`/`to-`, opacity suffixes). Dark mode (`[data-theme=dark]` on `<html>`) and skins (`html[data-skin=saas|modern|material|flat]`) redefine the variables, so markup never changes.

**Use it when.**
- Choosing a status colour: `success` = done/paid, `danger` = error/destructive, `warning` = pending/attention, `info` = neutral info, `secondary` = alternative accent (blue), `purple` = extra accent for charts/badges.
- Borders and dividers: always `border-default-300` / `divide-default-300` (never a hard-coded grey) so dark mode works.
- Surfaces: `bg-card` for panels, `bg-body-bg` for page background, `bg-default-100` for subtle hover/active rows, `bg-light` for muted buttons.

**Source.** `references/sources/pages/ui-colors.html`; values from `references/sources/assets/css/app.min.css`.

**Markup.**

```html
<!-- swatch (demo) -->
<div class="card"><div class="card-body"><div class="bg-primary rounded" style="height: 100px"></div><div class="mt-5 text-center"><h6>Primary</h6></div></div></div>

<!-- border utilities -->
<div class="border-default-300 bg-light/50 size-9 border"></div>        <!-- all sides -->
<div class="border-default-300 bg-light/50 size-9 border-t"></div>      <!-- border-t / border-e / border-b / border-s -->
<div class="border-primary bg-light/50 size-9 border"></div>            <!-- colour -->
<div class="border-default-300 bg-light/50 size-9 border-3"></div>      <!-- width: border border-2 border-3 border-4 border-5 -->
<div class="border-primary/15 bg-light/50 size-9 border"></div>         <!-- colour opacity -->
<div class="border-default-300 bg-light/50 size-9 border border-t-0"></div>   <!-- remove one side: border-none, border-t-0/e-0/b-0/s-0 -->
<div class="border-primary/50 mb-2.5 border p-2.5">50% opacity accent border</div>
```

Token table (default skin; dark value where it differs):

| Token | Light | Dark | Utilities |
|---|---|---|---|
| `primary` / `primary-hover` | `#1ab394` / `#179f84` | same | `bg-primary text-primary border-primary hover:bg-primary-hover bg-primary/15` |
| `secondary` / `-hover` | `#1c84c6` | same | as above |
| `success` | `#0acf97` | same | |
| `info` | `#23c6c8` | same | |
| `warning` | `#f8ac59` | same | |
| `danger` | `#ed5565` | same | |
| `purple` | `#7b70ef` | same | `bg-purple text-purple` (no `-hover` in demo) |
| `light` / `light-hover` | `#eef2f7` / `#d6dbe0` | `#252630` / `#8a969c` | muted surfaces, `bg-light text-dark` buttons |
| `dark` / `dark-hover` | `#313a46` / `#2c3440` | `#4b4d5c` / `#343a40` | dark buttons/tooltips |
| `default-50 … default-900` | slate scale (`default-300` = `#e7e9eb`, `default-900` = `#313a46`) | flipped (`default-50` = `#22232c`, `default-300` = `#293036`, `default-900` = zinc-100) | text `text-default-400/500/600/700/800`, borders `border-default-300`, hover rows `bg-default-100` |
| `card` | `#fff` | `#1e1f27` | `bg-card` (modal panels, popovers, offcanvas) |
| `body-bg` / `body-color` | `#f1f2f7` / `#4c4c5c` | `#17181e` / `#aab8c5` | page background / base text |
| `--spacing-base` | 20 px | — | `gap-base mb-base space-y-base` |
| `--radius` | 4 px | — | `rounded` on `.btn`, `.card`, `.badge` |
| `--text-2xs` / `--text-md` | 11 px / 15 px | — | `text-2xs` captions, `text-md` card titles |
| `--font-secondary` | "Open Sans" | — | `font-secondary` (accordion toggles) |

Skins override the palette (e.g. `data-skin=saas` sets primary `#7754f6`, secondary `#0070ff`, Inter font; `modern` sets IBM Plex Sans; `flat` uses Nunito) — design with tokens, never hex.

**Gotchas.**
- Opacity suffixes are the soft-variant mechanism everywhere: `/15` for soft backgrounds, `/10` for soft pagination, `/20` for alert `hr`s, `/40` for contextual hover, `/60` for placeholders.
- `text-white` on solid `warning`/`info` is the template convention even though contrast is low; keep it for consistency with the demo.
- `bg-light` is near-white in light mode and dark grey in dark mode — pair it with `text-dark` (which flips too), not `text-white`.

## Utilities

**What it is.** The handful of Tailwind utility families the demo documents because the template leans on them: background/text opacity, element opacity, border radius sizes and sides, user-select, overflow, absolute positioning with logical `start/end` offsets and translate-centering, shadows, fractional heights, object-fit, z-index.

**Use it when.**
- Positioning badges/dots/close buttons on a `relative` parent (`absolute -end-2 -top-2`, centered `start-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2`).
- Fitting images in fixed boxes (`object-cover size-12`), scroll regions (`overflow-y-auto h-25`), stacking overlays (`z-10` … `z-30`; template reserves `z-70` popovers/dropdowns, `z-80` overlays).
- Elevation: cards already carry `--shadow`; use `shadow-sm` / `shadow` / `shadow-lg` only on floating elements (toasts, menus).
- RTL-safe spacing with logical utilities: `ms-/me-`, `ps-/pe-`, `start-/end-`, `rounded-s-/rounded-e-`, `border-s/border-e`, `divide-x` auto-flips.

**Source.** `references/sources/pages/ui-utilities.html` (no script).

**Markup.**

```html
<!-- colour + background pairs -->
<div class="bg-primary p-3 text-white">Primary with contrasting color</div>
<div class="bg-default-200 text-default-700 p-3">Light with contrasting color</div>
<!-- background / text opacity, element opacity -->
<div class="bg-primary/75 p-3 text-white">75% opacity primary background</div>
<div class="bg-primary/25 text-default-700 p-3">25% opacity primary background</div>
<div class="text-primary/50">50% opacity primary text</div>
<div class="btn bg-primary opacity-50 p-3 font-bold text-white">50%</div>

<!-- radius -->
<img src="assets/images/users/user-2.jpg" class="size-11 rounded-md" alt="" />    <!-- rounded rounded-md rounded-lg rounded-2xl rounded-4xl rounded-full -->
<img src="assets/images/users/user-2.jpg" class="size-11 rounded-e-md" alt="" />  <!-- rounded-t-md rounded-e-md rounded-b-md rounded-s-md -->

<!-- select / overflow -->
<p class="select-all">Entirely selected when clicked.</p> <p class="select-none">Not selectable.</p>
<div class="bg-default-100 h-25 overflow-y-auto p-5">…</div>   <!-- overflow-hidden overflow-visible overflow-scroll -->

<!-- positioning -->
<div class="border-default-300 bg-default-100 relative m-5 rounded-md border p-20">
  <div class="bg-dark absolute start-0 top-0 size-6 rounded"></div>
  <div class="bg-dark absolute end-0 bottom-0 size-6 rounded"></div>
  <div class="bg-dark absolute start-1/2 top-1/2 size-6 -translate-x-1/2 -translate-y-1/2 rounded"></div>   <!-- true center -->
  <div class="bg-dark absolute start-full top-full size-6 -translate-x-1/2 -translate-y-1/2 rounded"></div> <!-- on the corner -->
  <div class="bg-dark absolute start-1/2 bottom-0 size-6 -translate-x-1/2 rounded"></div>                  <!-- axis-centered -->
</div>

<!-- shadows / heights / object-fit / z-index -->
<div class="rounded p-3 shadow-sm">Small shadow</div> <div class="rounded p-3 shadow">Regular</div> <div class="rounded p-3 shadow-lg">Larger</div>
<div class="flex flex-wrap gap-base items-start h-63.75"><div class="h-1/4 p-3 bg-light">25%</div><div class="h-1/2 p-3 bg-light">50%</div><div class="h-full p-3 bg-light">100%</div><div class="h-auto p-3 bg-light">auto</div></div>
<img src="assets/images/stock/small-1.jpg" class="object-cover border border-default-200 rounded size-12 mx-auto" alt="" />   <!-- object-contain object-fill object-scale-down object-none -->
<div class="relative h-55">
  <div class="z-30 absolute p-18 rounded-xl bg-primary"></div>
  <div class="z-20 absolute p-18 m-3 rounded-xl bg-success"></div>
  <div class="-z-10 absolute p-18 m-18 rounded-xl bg-info"></div>
</div>
```

**Gotchas.**
- Arbitrary fractional sizes (`size-8.75`, `h-63.75`, `p-18`, `top-45`) are valid Tailwind v4 spacing multiples — the compiled CSS contains them; don't "fix" them to standard steps.
- `z-index` only applies to positioned elements; the template's own layers are: dropdown/popover `z-70`, overlays (modal/offcanvas) `z-80` — put toasts at `z-80`+.
- Prefer logical utilities (`start/end`, `ms/me`) over `left/right`, `ml/mr` everywhere; the whole template is RTL-ready through them.

## Original sources

- `references/sources/pages/ui-accordions.html`
- `references/sources/pages/ui-alerts.html`
- `references/sources/pages/ui-badges.html`
- `references/sources/pages/ui-breadcrumb.html`
- `references/sources/pages/ui-buttons.html`
- `references/sources/pages/ui-cards.html`
- `references/sources/pages/ui-carousel.html`
- `references/sources/pages/ui-collapse.html`
- `references/sources/pages/ui-colors.html`
- `references/sources/pages/ui-dropdowns.html`
- `references/sources/pages/ui-images.html`
- `references/sources/pages/ui-links.html`
- `references/sources/pages/ui-list-group.html`
- `references/sources/pages/ui-modals.html`
- `references/sources/pages/ui-notifications.html`
- `references/sources/pages/ui-offcanvas.html`
- `references/sources/pages/ui-pagination.html`
- `references/sources/pages/ui-placeholders.html`
- `references/sources/pages/ui-popovers.html`
- `references/sources/pages/ui-progress.html`
- `references/sources/pages/ui-scrollspy.html`
- `references/sources/pages/ui-spinners.html`
- `references/sources/pages/ui-tabs.html`
- `references/sources/pages/ui-tooltips.html`
- `references/sources/pages/ui-typography.html`
- `references/sources/pages/ui-utilities.html`
- `references/sources/pages/ui-videos.html`
- `references/sources/MANIFEST-page-deps.txt` (confirms no page scripts for any `ui-*` page)
- `references/sources/assets/js/app.js` (`initPortletCard`: `card-close` / `card-toggle` / `card-refresh` / `code-collapse` handlers; `initCounter`)
- `references/sources/assets/css/app.min.css` (component rules for `.btn`, `.badge`, `.badge-label`, `.card*`, `.nav-tabs`/`.nav-link`, `.dropdown-item`, `.dropdown-divider`, `.progress-striped`, `animate-progress-stripes`, `spinner-grow` keyframes, `.hs-overlay-backdrop`, `.card-collapsed`, `.card-overlay`, colour tokens and `[data-theme=dark]` overrides)
