# Utility plugins (sortable, text diff, PDF viewer, i18n, sweet alerts, idle timer, password meter, live favicon, clipboard, tree view, loading buttons, masonry, tour, animation, video player) and icon sets

This group covers the small, single-purpose JavaScript utilities that INSPINIA Tailwind ships under `assets/plugins/` plus the template's own helpers in `app.js`, and the three icon sources (Tabler and Lucide via the Iconify Tailwind plugin, SVG country flags). Reach for these when a feature of an admin UI needs a behaviour that plain Tailwind + Preline does not give you: drag-to-reorder, "what changed" diffs, in-app document preview, multilingual labels, confirm dialogs, auto-lock on inactivity, password strength feedback, tab-badge counts, one-click copy, folder/permission trees, submit-with-progress buttons, pin-board layouts, onboarding tours, attention animations and media playback. Every plugin here is loaded per page (`assets/plugins/<lib>/…` + `assets/js/pages/<page>.js` after `vendors.min.js` and `app.js`); nothing in this group is auto-initialised by Preline except the collapse used on the password-condition box.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Let users drag items to reorder (menus, backlog, nested outline, kanban columns) | SortableJS on `.nested-sortable` / `.nested-sortable-handle` | `plugins-sortable.html` | `assets/plugins/sortablejs/Sortable.min.js` + `assets/js/pages/plugins-nestable.js` |
| Show "what changed" between two texts (config versions, CMS revisions, audit trail) | jsdiff word diff into `<ins>/<del>` | `plugins-text-diff.html` | `assets/plugins/diff/diff.min.js` + `assets/js/pages/plugins-text-diff.js` |
| Preview a PDF (invoice, contract, upload) inside the app with paging + zoom | pdf.js rendering to `<canvas>` | `plugins-pdf-viewer.html` | `assets/plugins/pdfjs/pdf.min.js` + `assets/js/pages/plugins-pdf-viewer.js` |
| Multilingual admin: translate labels/menu from JSON, language switcher, RTL for Arabic | Template `I18nManager` (`data-lang`, `data-translator-lang`) | `plugins-i18.html` | built into `assets/js/app.js` (no plugin) |
| Confirm destructive actions, success/error dialogs, async-request feedback, toasts | SweetAlert2 `Swal.fire()` | `plugins-sweet-alerts.html` | `assets/plugins/sweetalert2/sweetalert2.min.{css,js}` + `assets/js/pages/plugins-sweetalerts.js` |
| Auto-lock / warn / log out after inactivity (compliance, shared workstations) | Template `IdleDetector` class | `plugins-idle-timer.html` | `assets/js/pages/plugins-idle-timer.js` (no plugin) |
| Password strength bar + rule checklist on sign-up / change-password | Template `PasswordMeter` class + `.password-bar` / `.password-box` | `plugins-pass-meter.html` | `assets/js/pages/plugins-pass-meter.js` (no plugin) |
| Unread-count badge on the browser tab favicon | Tinycon `setBubble()` | `plugins-live-favicon.html` | `assets/plugins/tinycon/tinycon.min.js` + `assets/js/pages/plugins-tinycon.js` |
| One-click copy of API keys, coupon codes, invite links, snippets | clipboard.js via `data-clipboard-target` | `plugins-clipboard.html` (also `apps-api-keys.html`) | `assets/plugins/clipboard/clipboard.min.js` + `assets/js/pages/plugins-clipboard.js` |
| Folder tree, category hierarchy, permission tree with checkboxes, context menu, drag-drop, lazy-loaded nodes | jsTree (jQuery) with `types` icons | `plugins-tree-view.html` | `assets/plugins/jquery/jquery.min.js` + `assets/plugins/jstree/jstree.min.js` + `assets/js/pages/plugins-treeview.js` |
| Submit button that shows a spinner / progress while the request runs | Ladda `.ladda-button[data-style]` | `plugins-loading-buttons.html` | `assets/plugins/jquery/jquery.min.js` + `assets/plugins/ladda/{spin,ladda,ladda.jquery}.min.js` + `assets/js/pages/plugins-loading-button.js` |
| Pin-board / card gallery with uneven card heights (blog grid, media wall) | Masonry via `data-masonry` | `plugins-masonry.html` (also `apps-blog-grid.html`) | `assets/plugins/masonry/masonry.pkgd.min.js` + `assets/js/pages/plugins-masonry.js` |
| First-run onboarding walkthrough that spotlights UI elements | TourGuideJS `data-tg-*` + `TourGuideClient` | `plugins-tour.html` | `assets/plugins/tourguidejs/tour.js` + `assets/js/pages/plugins-tour.js` |
| Entrance / attention / exit effects on any element | Animate.css `animate__animated animate__<name>` | `plugins-animation.html` | CSS compiled into `app.min.css`; demo switcher `assets/js/pages/plugins-animation.js` |
| Play MP4, YouTube, Vimeo or audio with a themed player | Plyr `new Plyr('#id')` | `plugins-video-player.html` | `assets/plugins/plyr/plyr.min.js` + `assets/js/pages/plugins-plyr.js` |
| General UI icons (default set used by the whole template) | Tabler via Iconify classes `iconify tabler--<name>` | `icons-tabler.html` | none (CSS mask icons compiled into `app.min.css`) |
| Alternative icon style (rounder, 24px grid) | Lucide via Iconify classes `iconify lucide--<name>` | `icons-lucide.html` | none (CSS mask icons compiled into `app.min.css`) |
| Country flags for language pickers, locale columns, shipping addresses | `<img src="assets/images/flags/<iso2>.svg">` | `icons-flags.html` | `assets/js/pages/flags-listing.js` (country list + search demo) |

## Sortable (SortableJS)

**What it is.** SortableJS drag-and-drop reordering applied to plain `<div>` lists. The template convention is two marker classes: `.nested-sortable` (drag anywhere on the row) and `.nested-sortable-handle` (drag only by the `.sort-handle` grip icon). Nested lists inside a row become their own sortable group, so items can be moved between levels.

**Use it when.**
- Reordering navigation / menu builders, form-field order in a form designer, columns in a report builder.
- Prioritising a backlog or a to-do list; ranking items (top-N products, featured articles).
- Kanban-style movement between columns: every column is a `.nested-sortable` sharing `group: "nested"`, so cards drag across columns.
- Building a nested outline (sitemap, category tree with drag) — use the handle variant so rows with text inputs or links stay clickable.
- Not for large trees with lazy loading, checkboxes or context menus — use jsTree's `dnd` plugin (see Tree View) instead.

**Source.** `references/sources/pages/plugins-sortable.html`, `references/sources/assets/js/pages/plugins-nestable.js`, `assets/plugins/sortablejs/Sortable.min.js`.

**Markup.**

```html
<!-- Variant 1: drag anywhere on the row; nest another .nested-sortable inside a row for sub-levels -->
<div class="border-default-300 divide-default-300 nested-sortable divide-y rounded border font-medium">
  <div class="px-4 py-2.5">Design Phase</div>
  <div class="px-4 py-2.5"> Development Phase
    <div class="border-default-300 divide-default-300 nested-sortable divide-y rounded border">
      <div class="px-4 py-2.5">Frontend Implementation</div>
      <div class="px-4 py-2.5">Backend API Setup</div>
    </div>
  </div>
  <!-- repeat per row -->
</div>

<!-- Variant 2: drag only by the grip handle (rows can contain links/inputs) -->
<div class="border-default-300 divide-default-300 nested-sortable-handle divide-y rounded border font-medium">
  <div class="nested-1 px-4 py-2.5"><i class="iconify tabler--grip-horizontal sort-handle align-middle"></i> Project Alpha
    <div class="border-default-300 divide-default-300 nested-sortable-handle divide-y rounded border">
      <div class="nested-2 px-4 py-2.5"><i class="iconify tabler--grip-horizontal sort-handle align-middle"></i> Design Phase</div>
    </div>
  </div>
</div>

<!-- Variant 3: grouped lists with a heading + icon per group (kanban-ish columns sharing one group) -->
<div class="border-default-300 divide-default-300 divide-y divide-dashed rounded border border-dashed">
  <div class="px-4 py-2.5">
    <div class="mb-2.5 flex items-center gap-2.5">
      <div class="bg-default-100 flex size-6 shrink-0 items-center justify-center rounded-full"><i class="iconify tabler--layout-kanban text-primary text-sm"></i></div>
      <div><h5>Tasks</h5></div>
      <span class="ms-auto badge bg-primary/15 text-primary">Phase A</span>   <!-- optional label -->
    </div>
    <div class="nested-sortable">
      <div class="px-4 py-2.5"><i class="iconify tabler--check text-default-400 me-2.5 text-sm"></i> To Do</div>
      <div class="px-4 py-2.5"><i class="iconify tabler--info-circle text-default-400 me-2.5 text-sm"></i> In Progress</div>
    </div>
  </div>
  <!-- repeat per group (tabler--flag, tabler--users used for the other groups) -->
</div>
```

**Init / JS.** `assets/js/pages/plugins-nestable.js`:

```js
function initNestedSortables(selector, options) {
  document.querySelectorAll(selector).forEach(el => { new Sortable(el, options); });
}
initNestedSortables(".nested-sortable", {
  group: "nested",                 // same group name => items can move between any .nested-sortable
  ghostClass: "sortable-item-ghost",
  animation: 150,
  fallbackOnBody: true,
  swapThreshold: 0.65,
  onStart: e => e.item.classList.add("sortable-drag"),
  onEnd:   e => e.item.classList.remove("sortable-drag")   // read e.oldIndex / e.newIndex / e.to here to persist order
});
initNestedSortables(".nested-sortable-handle", {
  handle: ".sort-handle", ghostClass: "sortable-item-ghost", group: "nested",
  animation: 150, fallbackOnBody: true, swapThreshold: 0.65
});
```

**Gotchas.**
- `.sortable-item-ghost` is styled in `app.min.css` (`background: var(--color-default-100); border-radius: 4px`, and a warning tint when the dragged item is a `.card`). `.sortable-drag` has no CSS — it is only a hook for your own styles.
- `.nested-sortable .nested-sortable` and the handle variant get `margin-top: 10px` from the template CSS; nested lists must be *inside* the parent row element, not siblings.
- Every container is a separate `Sortable` instance; the shared `group: "nested"` is what lets items cross containers. Give each row a `data-id` and serialise on `onEnd` (`[...el.children].map(r => r.dataset.id)`) — the demo does not persist anything.
- If you inject new sortable lists after load, call `new Sortable(el, options)` again for them; nothing is auto-initialised.

## Text Diff (jsdiff)

**What it is.** A two-textarea compare tool: jsdiff's `Diff.diffWords()` computes a word-level diff and the template's `TextDiff` class renders it as `<ins>` (green tint) / `<del>` (red tint) / `<span>` into `.diff-output`, live on every keystroke.

**Use it when.**
- Comparing two versions of a config file, template, email body or policy text before publishing.
- CMS / knowledge-base revision history: "what changed between v3 and v4".
- Audit-trail or change-request review screens: highlight edits a user made to a record's notes/description.
- Diffing log entries or API payloads side by side in a support tool.
- Not for line-oriented code review of long files — jsdiff also has `Diff.diffLines()` / `Diff.createPatch()`; swap the call in `render()` if you need line granularity.

**Source.** `references/sources/pages/plugins-text-diff.html`, `references/sources/assets/js/pages/plugins-text-diff.js`, `assets/plugins/diff/diff.min.js`.

**Markup.**

```html
<div class="card">
  <div class="card-header"><h4 class="card-title">jsdiff</h4></div>
  <div class="card-body">
    <div class="grid xl:grid-cols-2 gap-base">
      <div>
        <h5 class="mb-3 uppercase">Original Text</h5>
        <textarea class="diff-original form-textarea" rows="8">On a rainy Monday morning …</textarea>
      </div>
      <div>
        <h5 class="mb-3 uppercase">Changed Text</h5>
        <textarea class="diff-changed form-textarea" rows="8">On a rainy Monday morning …</textarea>
      </div>
      <div class="lg:col-span-2">
        <h5 class="mb-3 uppercase">Results</h5>
        <div class="bg-light/15 border-default-300 rounded border border-dashed p-6 leading-7">
          <div class="diff-output diff"></div>   <!-- <ins>/<del>/<span> are injected here -->
        </div>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/plugins-text-diff.js` (auto-runs on DOMContentLoaded):

```js
class TextDiff {
  constructor(orig = ".diff-original", changed = ".diff-changed", out = ".diff-output") {
    this.originalInput = document.querySelector(orig);
    this.changedInput  = document.querySelector(changed);
    this.diffOutput    = document.querySelector(out);
    this.bindEvents(); this.render();
  }
  bindEvents() {
    this.originalInput?.addEventListener("input", () => this.render());
    this.changedInput?.addEventListener("input",  () => this.render());
  }
  render() {
    const parts = Diff.diffWords(this.originalInput.value, this.changedInput.value);
    const frag = document.createDocumentFragment();
    parts.forEach(p => {
      const el = document.createElement(p.added ? "ins" : p.removed ? "del" : "span");
      el.textContent = p.value; frag.appendChild(el);
    });
    this.diffOutput.innerHTML = ""; this.diffOutput.appendChild(frag);
  }
}
document.addEventListener("DOMContentLoaded", () => { new TextDiff(); });
```

**Gotchas.**
- Colours come from `app.min.css`: `.diff-output ins { background: color-mix(var(--color-success) 10%) }` and `.diff-output del { … var(--color-danger) 10% }` — the output container *must* carry `diff-output` (the extra `diff` class is unused). Works in dark mode because the tints are token-based.
- The class only wires the first match of each selector; for several diff widgets on one page instantiate `new TextDiff(".a-orig", ".a-changed", ".a-out")` per widget.
- For read-only "revision" views, drop the textareas and call `Diff.diffWords(oldStr, newStr)` yourself, rendering into any element with class `diff-output`.

## PDF Viewer (pdf.js)

**What it is.** A minimal pdf.js viewer: one `<canvas>`, a dark button group (prev / next / zoom in / zoom out / 100 %) and a page-number input with a "/ N" counter. The page script loads `assets/data/demo.pdf`, renders the current page at `scale` (1.5 default, ±0.25 per zoom step) and queues re-renders.

**Use it when.**
- Previewing invoices, quotes, contracts or statements from an order / billing screen without leaving the app.
- Viewing uploaded attachments (tickets, HR documents, KYC files) with page navigation.
- Print-preview of generated reports before download.
- Not for annotation, text selection or search — those need the full pdf.js viewer (`viewer.html`) or a `<iframe>`/`<embed>`; this is a render-only canvas.

**Source.** `references/sources/pages/plugins-pdf-viewer.html`, `references/sources/assets/js/pages/plugins-pdf-viewer.js`, `assets/plugins/pdfjs/pdf.min.js`.

**Markup.**

```html
<div class="card">
  <div class="card-body">
    <div class="text-center">
      <div class="inline-flex text-nowrap">
        <button id="prev"    class="btn bg-dark rounded-e-none text-white"><i class="iconify tabler--arrow-left"></i><span class="hidden sm:inline">Previous</span></button>
        <button id="next"    class="btn bg-dark rounded-none text-white"><i class="iconify tabler--arrow-right"></i><span class="hidden sm:inline">Next</span></button>
        <button id="zoomin"  class="btn bg-dark rounded-none text-white"><i class="iconify tabler--zoom-in"></i><span class="hidden sm:inline">Zoom In</span></button>
        <button id="zoomout" class="btn bg-dark rounded-none text-white"><i class="iconify tabler--zoom-in"></i><span class="hidden sm:inline">Zoom Out</span></button>
        <button id="zoomfit" class="btn bg-dark rounded-s-none text-white">100%</button>
        <div class="flex">
          <input type="number" class="form-input ms-3 rounded-e-none!" id="page_num" style="width: 50px" />
          <span class="border-default-300 flex rounded-e border border-s-0 px-3 py-1.5 bg-light/15" id="page_count">/ 00</span>
        </div>
      </div>
    </div>
    <div class="mt-3 flex justify-center overflow-auto text-center">
      <canvas id="the-canvas" class="pdfcanvas border-default-300 rounded-lg border"></canvas>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/plugins-pdf-viewer.js` (trimmed):

```js
let url = "assets/data/demo.pdf", pdfDoc = null, pageNum = 1, pageRendering = false,
    pageNumPending = null, scale = 1.5, zoomRange = 0.25,
    canvas = document.getElementById("the-canvas"), ctx = canvas.getContext("2d"),
    pageCountEl = document.getElementById("page_count"), pageNumInput = document.getElementById("page_num");

function renderPage(num) {
  pageRendering = true;
  pdfDoc.getPage(num).then(page => {
    const viewport = page.getViewport({ scale });
    canvas.width = viewport.width; canvas.height = viewport.height;
    page.render({ canvasContext: ctx, viewport }).promise.then(() => {
      pageRendering = false;
      if (pageNumPending !== null) { renderPage(pageNumPending); pageNumPending = null; }
    });
  });
  pageNumInput.value = num;
}
function queueRenderPage(n) { pageRendering ? (pageNumPending = n) : renderPage(n); }
prev.onclick    = () => pageNum > 1 && queueRenderPage(--pageNum);
next.onclick    = () => pageNum < pdfDoc.numPages && queueRenderPage(++pageNum);
zoomin.onclick  = () => { scale += zoomRange; queueRenderPage(pageNum); };
zoomout.onclick = () => { if (scale > zoomRange) { scale -= zoomRange; queueRenderPage(pageNum); } };
zoomfit.onclick = () => { scale = 1; queueRenderPage(pageNum); };
pageNumInput.addEventListener("change", e => { const n = Number(e.target.value);
  (n >= 1 && n <= pdfDoc.numPages) ? queueRenderPage(pageNum = n) : (e.target.value = pageNum); });

pdfjsLib.getDocument(url).promise.then(doc => {
  pdfDoc = doc; pageCountEl.textContent = "/ " + doc.numPages; renderPage(pageNum);
}).catch(err => { console.error("Failed to load PDF:", err); alert("Error loading PDF document."); });
```

**Gotchas.**
- The demo never sets `pdfjsLib.GlobalWorkerOptions.workerSrc`. Depending on the pdf.js build this either silently falls back to a slow "fake worker" or throws; in production point it at the matching worker file (`assets/plugins/pdfjs/pdf.worker.min.js` if shipped — the `assets/plugins` folder is not vendored locally, so verify the filename).
- The zoom-out button reuses `tabler--zoom-in`; `tabler--zoom-out` is **not** in the compiled icon set (see Icons: Tabler), so either keep it or add the icon to your Tailwind build.
- `.pdfcanvas` has no CSS; the canvas is sized by pdf.js. The wrapper's `overflow-auto` is what makes zoomed pages scrollable instead of breaking the card.
- Serving PDFs from another origin needs CORS headers; `getDocument(url)` also accepts `{ data: arrayBuffer }` for blobs fetched with auth.

## i18n (template I18nManager)

**What it is.** The template's own translator, built into `app.js` (`class I18nManager`), not a third-party plugin. Elements marked `data-lang="key"` get their `innerHTML` replaced from `assets/data/translations/<lang>.json`; any element with `data-translator-lang="xx"` switches language on click; the chosen language is persisted in `sessionStorage.__THEME_LANG__`; choosing `ar` flips the layout to RTL. The demo page shows flag buttons that drive the same switcher as the topbar language dropdown.

**Use it when.**
- Multilingual back-office: translate sidebar menu, page titles, button labels and static help text without a framework.
- Region-specific tenants (one build, per-tenant default language via `defaultLang`).
- RTL support for Arabic/Hebrew tenants (the `ar` code triggers `changeLayoutDirection("rtl")`).
- Not for dynamic data (table rows, user content) or pluralisation/number formatting — it is string replacement only; keep API data untranslated or translate server-side.

**Source.** `references/sources/pages/plugins-i18.html`, `references/sources/assets/js/app.js` (`I18nManager`, lines around the `LayoutCustomizer` init). Translation JSON files live at `assets/data/translations/*.json` (not vendored locally).

**Markup.**

```html
<!-- 1. Mark translatable text with data-lang keys (the template's own sidebar uses ~287 keys this way) -->
<li class="menu-title" data-lang="main">Main</li>
<span class="menu-text" data-lang="dashboards">Dashboards</span>
<p data-lang="demo-text"></p>                          <!-- empty until the JSON loads -->

<!-- 2. Switchers anywhere: buttons (demo page) ... -->
<div class="flex flex-wrap gap-2.5">
  <button class="btn bg-light text-dark inline-flex items-center gap-1.5" data-translator-lang="en">
    <img src="assets/images/flags/us.svg" alt="" class="me-1.5 h-4.5 rounded" data-translator-image /><span class="align-middle">English</span>
  </button>
  <button class="btn bg-light text-dark inline-flex items-center gap-1.5" data-translator-lang="es">
    <img src="assets/images/flags/es.svg" alt="" class="me-1.5 h-4.5 rounded" data-translator-image /><span class="align-middle">Spanish</span>
  </button>
  <!-- demo also has hi (in.svg), it, ru; the topbar adds de and ar -->
</div>

<!-- ... or the topbar dropdown (present on every demo page) -->
<div id="language-selector" class="topbar-item hs-dropdown relative sm:inline-flex hidden [--placement:bottom-right]">
  <button class="topbar-link hs-dropdown-toggle font-bold relative flex items-center" type="button">
    <img src="assets/images/flags/us.svg" alt="" class="me-3 size-4.5 rounded" id="selected-language-image">
    <span id="selected-language-code">EN</span>
  </button>
  <div class="hs-dropdown-menu" role="menu">
    <a href="javascript:void(0);" class="dropdown-item" data-translator-lang="en" title="English">
      <img src="assets/images/flags/us.svg" alt="English" class="me-1 size-4 rounded" data-translator-image="">
      <span class="align-middle">English</span>
    </a>
    <!-- repeat per language: de, it, es, ru, hi, ar -->
  </div>
</div>
```

```json
// assets/data/translations/es.json — flat keys; dotted keys ("menu.home") are resolved as nested objects
{ "dashboards": "Paneles", "dashboard-one": "Panel v.1", "dashboard-two": "Panel v.2", "demo-text": "…" }
```

**Init / JS.** Nothing to add — `app.js` runs `(new I18nManager).init(layoutCustomizer)` on DOMContentLoaded. The class (reconstructed from `app.js`):

```js
class I18nManager {
  constructor({ defaultLang = "en", langPath = "assets/data/translations/",
                langImageSelector = "#selected-language-image", langCodeSelector = "#selected-language-code",
                translationKeySelector = "[data-lang]", translationKeyAttribute = "data-lang",
                languageSelector = "[data-translator-lang]" } = {}) {
    this.selectedLanguage = sessionStorage.getItem("__THEME_LANG__") || defaultLang; /* … */ }
  async init(layout) { if (this.selectedLanguage === "ar") layout.changeLayoutDirection("rtl");
    await this.applyTranslations(); this.updateSelectedImage(); this.updateSelectedCode(); this.bindLanguageSwitchers(layout); }
  async loadTranslations() { const r = await fetch(this.langPath + this.selectedLanguage + ".json"); return r.ok ? r.json() : {}; }
  async applyTranslations() { const dict = await this.loadTranslations();
    document.querySelectorAll("[data-lang]").forEach(el => { const key = el.getAttribute("data-lang");
      const val = key.split(".").reduce((o, k) => o?.[k] ?? null, dict);
      val ? (el.innerHTML = val) : console.warn("Missing translation for key: " + key); }); }
  setLanguage(code) { this.selectedLanguage = code; sessionStorage.setItem("__THEME_LANG__", code);
    this.applyTranslations(); this.updateSelectedImage(); this.updateSelectedCode(); }
  // bindLanguageSwitchers: click on [data-translator-lang] -> setLanguage + changeLayoutDirection(code === "ar" ? "rtl" : "ltr")
}
```

**Gotchas.**
- `I18nManager` is instantiated with defaults inside `app.js`; to change `langPath` / `defaultLang` you must edit that DOMContentLoaded block (or re-instantiate your own after it — the switch buttons would then be bound twice, so remove the original call).
- Missing keys only `console.warn` and leave the existing text, so always ship the fallback text inside the element. Keys are injected with `innerHTML` — never put untrusted strings in the JSON.
- The topbar `#selected-language-image` is updated by copying the `src` of the `[data-translator-image]` inside the clicked switcher — keep a flag `<img data-translator-image>` inside every switcher.
- Language persists only for the session (`sessionStorage`); use `localStorage` or a server-side preference if it must survive a new tab. `"ar"` is the only code that triggers RTL.

## SweetAlert2

**What it is.** SweetAlert2 modal dialogs styled with the template's `.btn` classes (`buttonsStyling: false` + `customClass`). The demo page is a table of trigger buttons; every alert is wired by `id` in `plugins-sweetalerts.js`. `app.min.css` restyles `.swal2-popup` with `--color-card` / `--color-body-color` so dialogs follow dark mode.

**Use it when.**
- Confirming destructive actions (delete record, cancel order, revoke key) with Confirm + Cancel and a follow-up success alert.
- Blocking feedback after async requests (`showLoaderOnConfirm` + `preConfirm` that returns a Promise) — e.g. "enter e-mail to invite", "re-enter password".
- Status dialogs (`icon: info|warning|error|success|question`) and auto-closing toasts positioned in a corner (`position`, `timer`).
- Branded dialogs (`imageUrl` logo, custom `background`, `width`, `padding`).
- Not for non-blocking notifications — use the template's toast markup (see Idle Timer) or Preline alerts; not for forms with several fields — use an `hs-overlay` modal.

**Source.** `references/sources/pages/plugins-sweet-alerts.html`, `references/sources/assets/js/pages/plugins-sweetalerts.js`, `assets/plugins/sweetalert2/sweetalert2.min.css` (in `<head>`), `assets/plugins/sweetalert2/sweetalert2.min.js`.

**Markup.** Only trigger buttons are needed; the dialog DOM is created by the library.

```html
<link href="assets/plugins/sweetalert2/sweetalert2.min.css" rel="stylesheet" />   <!-- head, before app.min.css -->

<button type="button" class="btn btn-sm bg-primary text-white hover:bg-primary-hover" id="sweetalert-basic">Click me</button>
<button type="button" class="btn btn-sm bg-secondary text-white hover:bg-secondary-hover" id="sweetalert-confirm-button">Delete…</button>
<div class="flex flex-wrap gap-3">
  <button type="button" id="sweetalert-info"    class="btn btn-sm bg-info text-white">Toggle Info</button>
  <button type="button" id="sweetalert-warning" class="btn btn-sm bg-warning text-white">Toggle Warning</button>
  <button type="button" id="sweetalert-error"   class="btn btn-sm bg-danger text-white hover:bg-danger-hover">Toggle Error</button>
  <button type="button" id="sweetalert-success" class="btn btn-sm bg-success text-white">Toggle Success</button>
</div>
<button class="btn btn-sm bg-primary text-white hover:bg-primary-hover" id="position-top-end">Top End</button>
<button type="button" id="ajax-alert" class="btn btn-sm bg-secondary text-white hover:bg-secondary-hover">Ajax</button>
```

**Init / JS.** `assets/js/pages/plugins-sweetalerts.js` (trimmed to the reusable patterns):

```js
const defaultButtonClasses = {
  confirmButton: "btn bg-primary text-white hover:bg-primary-hover mt-2",
  cancelButton:  "btn bg-danger text-white hover:bg-danger-hover mt-2"
};
const showAlert = opts => Swal.fire({ buttonsStyling: false,
  customClass: { confirmButton: defaultButtonClasses.confirmButton }, ...opts });

// Basic / titled / state alerts
showAlert({ title: "Simple Alert", text: "This is a basic SweetAlert dialog." });
showAlert({ title: "Notice", text: "…", icon: "question", showCloseButton: true });
showAlert({ text: "Heads up!", icon: "warning", confirmButtonText: "Got it",
  customClass: { confirmButton: "btn bg-warning text-white hover:bg-warning-hover" } });

// Confirm destructive action, then success
Swal.fire({ title: "Delete File?", text: "This action cannot be undone!", icon: "warning",
  showCancelButton: true, confirmButtonText: "Delete", cancelButtonText: "Cancel", showCloseButton: true,
  buttonsStyling: false,
  customClass: { confirmButton: defaultButtonClasses.confirmButton + " me-2", cancelButton: defaultButtonClasses.cancelButton }
}).then(r => {
  if (r.isConfirmed) showAlert({ title: "Deleted!", text: "The file has been deleted.", icon: "success" });
  else if (r.dismiss === Swal.DismissReason.cancel) showAlert({ title: "Action Cancelled", text: "Your file is safe.", icon: "error" });
});

// Corner toast, auto-close
Swal.fire({ position: "top-end", icon: "success", text: "Saved successfully!", showConfirmButton: false, timer: 1500,
  buttonsStyling: false, customClass: { confirmButton: defaultButtonClasses.confirmButton } });

// Countdown auto-dismiss
Swal.fire({ title: "Auto Dismiss", html: "Closing in <b></b> seconds...", timer: 2000, timerProgressBar: true,
  didOpen: () => { Swal.showLoading(); /* setInterval updating <b> from Swal.getTimerLeft() */ } });

// Logo header / custom background
showAlert({ title: "Custom Branding", text: "…", imageUrl: "assets/images/logo-sm.png", imageHeight: 40, showCloseButton: true });
showAlert({ title: '<h2 class="text-white">Custom Design.</h2>', html: '<p class="text-white">…</p>', width: 600,
  padding: "100px", color: "#fff", background: "url(assets/images/stock/small-2.jpg) no-repeat center" });

// Async request with validation
Swal.fire({ title: "<h4>Enter Your Email</h4>", input: "email", inputPlaceholder: "Enter your email address",
  showCancelButton: true, confirmButtonText: "Submit", showLoaderOnConfirm: true, showCloseButton: true,
  buttonsStyling: false, customClass: { confirmButton: "btn bg-primary text-white hover:bg-primary-hover me-2",
                                         cancelButton: "btn bg-danger text-white hover:bg-danger-hover" },
  preConfirm: email => new Promise((res, rej) => setTimeout(() =>
    email === "taken@example.com" ? rej("This email is already registered.") : res(email), 1500)),
  allowOutsideClick: false
}).then(r => { if (r.isConfirmed) Swal.fire({ icon: "success", title: "Submitted!", html: "Your email: " + r.value,
  buttonsStyling: false, customClass: { confirmButton: "btn bg-primary text-white hover:bg-primary-hover" } }); });
```

**Gotchas.**
- Always pass `buttonsStyling: false` + `customClass` — otherwise SweetAlert's own blue/red buttons appear and clash with the theme. Put `me-2` on the confirm button when a cancel button is shown; the demo's HTML alert adds `flex! items-center` to align an inline SVG in the button label.
- Theme CSS already overrides `.swal2-popup` (background `var(--color-card)`, width `28em`, padding `2rem`), `.swal2-footer` and icon colours (`question` → info colour) — do not re-theme with hard-coded colours.
- `preConfirm` rejection strings surface via `Swal.showValidationMessage`; return the resolved value and read it from `result.value`.
- The CSS link must be in `<head>` (the demo places it before `app.min.css`).

## Idle Timer

**What it is.** A vanilla `IdleDetector` class in the page script (the page prose mentions the jQuery idle-timer plugin, but the actual implementation is dependency-free). It counts seconds without `mousemove|keydown|scroll|click`; at `idleLimit` (5 s in the demo) it shows an inline `.idle-alert` and a warning toast (`#liveToast`); on the next activity it hides the alert and shows a "Welcome back" toast (`#backToast`).

**Use it when.**
- Auto-lock / auto-logout after N minutes for compliance (finance, healthcare, shared kiosks) — replace `setIdleState()` with a redirect to the lock screen (`auth-lock-screen.html`) or a session-expiry call.
- Pausing polling / live charts while the tab is idle to save API quota; resume in `resetTimer()`.
- "Are you still there?" warning before a server session expires (show a SweetAlert2 countdown instead of the toast).
- Presence indicators (mark the user away in chat after inactivity).

**Source.** `references/sources/pages/plugins-idle-timer.html`, `references/sources/assets/js/pages/plugins-idle-timer.js` (no third-party lib).

**Markup.**

```html
<div class="card">
  <div class="card-header"><h4 class="card-title">Idle Timer Plugin</h4></div>
  <div class="card-body">
    <!-- inline alert, hidden until idle -->
    <div class="bg-danger/15 text-danger idle-alert mb-4 hidden rounded px-4 py-3" role="alert">
      Your session has expired. Please move your mouse to resume your activity.
    </div>
    <div class="p-6 text-center">
      <i class="iconify tabler--fingerprint block mb-5 text-4xl mx-auto"></i>
      <h3 class="mb-2 text-2xl italic">Please stay idle for 5 seconds</h3>
    </div>

    <!-- fixed toast stack (top-end); reusable toast pattern -->
    <div class="fixed end-0 top-0 z-100 m-10">
      <div id="backToast" class="bg-success border-success mb-5 hidden w-xs max-w-full rounded shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="flex items-center gap-3 border-b border-white/20 px-3 py-2">
          <strong class="me-auto text-base text-white">Welcome Back</strong><small class="text-white">Now</small>
          <button type="button" class="flex text-white" aria-label="Close" data-hs-remove-element="#backToast"><i class="iconify tabler--x"></i></button>
        </div>
        <div class="p-4 text-white italic">We missed you! Welcome back!</div>
      </div>
      <div id="liveToast" class="bg-warning border-warning hidden w-xs max-w-full rounded shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="flex items-center gap-3 border-b border-white/20 px-3 py-2">
          <img src="assets/images/logo-sm.png" class="h-5" alt="..." />
          <strong class="me-auto text-base text-white">Idle Alert</strong><small class="text-white">Just now</small>
          <button type="button" class="flex text-white" aria-label="Close" data-hs-remove-element="#liveToast"><i class="iconify tabler--x"></i></button>
        </div>
        <div class="p-4 text-white italic">You've been inactive for too long. Please interact with the page to continue.</div>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/plugins-idle-timer.js`:

```js
class IdleDetector {
  constructor(o = {}) {
    this.idleLimit = o.idleLimit || 5;                 // seconds
    this.alertSelector = o.alertSelector || ".idle-alert";
    this.toastIdleId   = o.toastIdleId   || "liveToast";
    this.toastReturnId = o.toastReturnId || "backToast";
    this.events = o.events || ["mousemove", "keydown", "scroll", "click"];
    this.idleTime = 0; this.wasIdle = false; this.init();
  }
  init() {
    this.events.forEach(ev => window.addEventListener(ev, () => this.resetTimer()));
    this.interval = setInterval(() => { this.idleTime++; if (this.idleTime === this.idleLimit) this.setIdleState(); }, 1000);
  }
  resetTimer() { this.idleTime = 0; document.querySelector(this.alertSelector)?.classList.add("hidden");
    if (this.wasIdle) { this.showToast(this.toastReturnId); this.wasIdle = false; } }
  setIdleState() { this.wasIdle = true; document.querySelector(this.alertSelector)?.classList.remove("hidden"); this.showToast(this.toastIdleId); }
  showToast(id) { const el = document.getElementById(id); if (!el) return;
    el.classList.add("block"); el.classList.remove("hidden");
    setTimeout(() => { el.classList.remove("block"); el.classList.add("hidden"); }, 3000); }
}
document.addEventListener("DOMContentLoaded", () => { new IdleDetector({ idleLimit: 300 /* 5 min */ }); });
```

**Gotchas.**
- The `===` check fires `setIdleState()` exactly once per idle period; the counter keeps climbing, so a second warning needs your own logic. `touchstart` is not in the default event list — add it for tablets.
- The toasts are plain divs toggled with `hidden`/`block`; `data-hs-remove-element` on the close button **removes the node**, so a toast closed manually can never show again — swap for a `hidden` toggle if the toast must be reusable.
- Idle counting runs in every open tab independently; for a real logout, confirm server-side.

## Password Meter

**What it is.** Two template helpers in `plugins-pass-meter.js` (no third-party lib, and it does not use Preline's `hs-strong-password` — that attribute appears on no demo page): (1) a 4-segment strength bar — `.password-bar` after any `input[type=password]` is filled with four `.strong-bar` divs coloured `bar-active-1…4` (danger → warning → primary → success) as length ≥ 8, uppercase, digit, symbol rules pass; (2) a "recipe" checklist (`.password-box`) whose `<p>` rows toggle `valid` / `invalid` (✔ / ✖ pseudo-content) as the user types, revealed via Preline `hs-collapse` when the field is focused.

**Use it when.**
- Sign-up, invite-accept and change-password forms; admin "create user" dialogs.
- Password-policy enforcement screens where the rules must be visible (length / case / digit / symbol).
- Pair the bar with the `pattern` attribute (demo: `(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}`) so native validation blocks submit; pair with `hs-toggle-password` (forms references) for show/hide.

**Source.** `references/sources/pages/plugins-pass-meter.html`, `references/sources/assets/js/pages/plugins-pass-meter.js`, styles in `app.min.css` (`.password-bar`, `.strong-bar`, `.bar-active-N`, `.password-box p.valid/.invalid`).

**Markup.**

```html
<!-- A. Strength bar: .password-bar must be the input's NEXT sibling -->
<div class="card-body">
  <input type="password" class="form-input mb-3" placeholder="Password" />
  <div class="password-bar mb-3"></div>     <!-- 4 x <div class="strong-bar"> injected at init -->
  <p class="text-default-400 text-2xs">Use 8 or more characters with a mix of letters, numbers & symbols.</p>
</div>

<!-- B. Rule checklist, shown on focus via hs-collapse; ids are fixed by the script -->
<div>
  <label class="form-label hs-collapse-toggle" for="password-input" id="password-collapse-toggle" data-hs-collapse="#passwordBox">Magic Password ✨ (Click Here)</label>
  <input type="password" class="form-input hs-collapse-toggle" placeholder="Enter password" id="password-input"
         pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" data-hs-collapse="#passwordBox" />
  <div class="text-default-400 mt-1 text-2xs">Use 8 or more characters with a mix of letters, numbers & symbols.</div>
  <div class="password-box hs-collapse hidden w-full overflow-hidden transition-[height] duration-300" id="passwordBox">
    <div class="p-3">
      <h5 class="mb-2 text-sm">Password Recipe:</h5>
      <p id="pass-length" class="invalid fs-xs mb-2"> Minimum <b>8 characters</b></p>
      <p id="pass-lower"  class="invalid fs-xs mb-2"> At <b>lowercase</b> letter (a-z) </p>
      <p id="pass-upper"  class="invalid fs-xs mb-2"> At least <b>uppercase</b> letter (A-Z) </p>
      <p id="pass-number" class="invalid fs-xs"> A least <b>number</b> (0-9) </p>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/plugins-pass-meter.js` (auto-runs):

```js
class PasswordMeter {
  constructor(inputSelector = 'input[type="password"]', barClass = "strong-bar", meterWrapperClass = "password-bar", passwordBoxId = "password-input") { /* store */ }
  init() { this.initProgressBar(); this.initPasswordBox(); }
  initProgressBar() {
    document.querySelectorAll(this.inputSelector).forEach(input => {
      const wrap = input.nextElementSibling;                       // must be .password-bar
      if (!wrap?.classList.contains(this.meterWrapperClass)) return;
      wrap.innerHTML = ""; for (let i = 0; i < 4; i++) { const d = document.createElement("div"); d.classList.add(this.barClass); wrap.appendChild(d); }
      const bars = wrap.querySelectorAll("." + this.barClass);
      input.addEventListener("input", () => { const score = this.getPasswordScore(input.value);
        bars.forEach(b => b.className = this.barClass);
        bars.forEach((b, i) => { if (i < score) b.classList.add("bar-active-" + score); }); });
    });
  }
  getPasswordScore(v) { let s = 0; if (v.length >= 8) s++; if (/[A-Z]/.test(v)) s++; if (/\d/.test(v)) s++; if (/[\W_]/.test(v)) s++; return s; }
  initPasswordBox() {   // needs #password-input, one .password-box and the four rule ids below
    const input = document.getElementById(this.passwordBoxId), box = document.querySelector(".password-box");
    const rules = { lower: document.getElementById("pass-lower"), upper: document.getElementById("pass-upper"),
                    number: document.getElementById("pass-number"), length: document.getElementById("pass-length") };
    if (!input || !box || !Object.values(rules).every(Boolean)) return;
    input.addEventListener("keyup", () => { const v = input.value;
      this.toggleValidity(rules.lower, /[a-z]/.test(v)); this.toggleValidity(rules.upper, /[A-Z]/.test(v));
      this.toggleValidity(rules.number, /[0-9]/.test(v)); this.toggleValidity(rules.length, v.length >= 8); });
  }
  toggleValidity(el, ok) { el.classList.toggle("valid", ok); el.classList.toggle("invalid", !ok); }
}
document.addEventListener("DOMContentLoaded", () => { new PasswordMeter().init(); });
```

**Gotchas.**
- The bar is wired to **every** `input[type=password]` whose next sibling is `.password-bar`; the checklist is hard-wired to the ids `password-input`, `pass-lower`, `pass-upper`, `pass-number`, `pass-length` and a single `.password-box` — change the constructor args / ids if you have two forms on a page.
- All four bars take the same colour class (`bar-active-<score>`), i.e. 2 of 4 segments orange, 4 of 4 green — that is intentional.
- `fs-xs` is a Bootstrap leftover with no CSS; use `text-xs`. The ✔/✖ glyphs are CSS `::before` content on `.password-box p.valid/.invalid` and use `inset-inline-start`, so they work in RTL.
- The `hs-collapse-toggle` on the input itself means every click on the field toggles the box; use `focus` + `HSCollapse.show()` if that feels jumpy.

## Live Favicon (Tinycon)

**What it is.** Tinycon draws a coloured bubble with a number or short text onto the page favicon (and falls back to prefixing the document title where canvas favicons are unsupported). The demo wires four buttons to `Tinycon.setOptions({background})` + `Tinycon.setBubble(value)`.

**Use it when.**
- Unread message / notification counts on the browser tab (chat, inbox, ticket queue).
- Pending-approval or failed-job counters in ops dashboards that users keep in a background tab.
- "Recording"/"live" state indicators (`setBubble("In")`-style short text).
- Clear with `Tinycon.setBubble(0)` / `Tinycon.reset()` when the user reads the items.

**Source.** `references/sources/pages/plugins-live-favicon.html`, `references/sources/assets/js/pages/plugins-tinycon.js`, `assets/plugins/tinycon/tinycon.min.js`.

**Markup.**

```html
<div class="p-6 text-center *:me-1">
  <a href="#" class="btn bg-light text-dark hover:text-primary" id="iconExample1">Set Icon to 1</a>
  <a href="#" class="btn bg-light text-dark hover:text-primary" id="iconExample2">Set Icon to 1000</a>
  <a href="#" class="btn bg-light text-dark hover:text-primary" id="iconExample3">Set Icon to "In"</a>
  <a href="#" class="btn bg-primary text-white hover:bg-primary-hover" id="iconExample4">Set Icon with Custom Color</a>
</div>
```

**Init / JS.** `assets/js/pages/plugins-tinycon.js`:

```js
const setTinycon = (id, value, background) => {
  document.getElementById(id)?.addEventListener("click", e => {
    e.preventDefault();
    Tinycon.setOptions({ background });   // other options: width, height, font, colour, fallback, abbreviate
    Tinycon.setBubble(value);             // number or short string; 1000 renders as "1k" when abbreviate is on
  });
};
setTinycon("iconExample1", 1, "#f03d25");
setTinycon("iconExample2", 1000, "#f03d25");
setTinycon("iconExample3", "In", "#f03d25");
setTinycon("iconExample4", 8, "#e0913b");
```

**Gotchas.**
- Needs a real `<link rel="shortcut icon" href="assets/images/favicon.ico">` in `<head>` (every demo page has one); Tinycon reads and redraws it.
- Option spelling is British: `colour` (text colour), `background`. Options persist between `setBubble` calls.
- Favicon canvases are tainted if the icon is served cross-origin; keep it same-origin or set CORS.

## Clipboard (clipboard.js)

**What it is.** clipboard.js bound to every element with `data-clipboard-target`; the attribute points at the element whose text/value is copied. `data-clipboard-action="cut"` removes the text from an input/textarea after copying. The same pattern is used in the real `apps-api-keys.html` table (readonly input + icon button inside `.input-group`).

**Use it when.**
- Copy API keys, tokens, webhook secrets (API-keys page), invite / share links, referral codes.
- Copy coupon / discount codes in promotions and checkout screens.
- Copy install commands, code snippets and HTML embed templates in developer settings.
- Copy e-mail addresses / usernames from profile cards. Use `cut` for one-time tokens that should disappear from the field.

**Source.** `references/sources/pages/plugins-clipboard.html`, `references/sources/pages/apps-api-keys.html`, `references/sources/assets/js/pages/plugins-clipboard.js`, `assets/plugins/clipboard/clipboard.min.js`.

**Markup.**

```html
<!-- copy from any element -->
<p class="text-primary mb-4 font-normal" id="copytext">Click the button to copy this promotional text.</p>
<button class="btn btn-sm bg-primary hover:bg-primary-hover text-white" data-clipboard-target="#copytext">
  <i class="iconify tabler--copy me-1"></i> Copy Text
</button>

<!-- cut from a textarea / input -->
<textarea class="form-textarea" id="cuttext">This content will be cut…</textarea>
<button class="btn btn-sm bg-primary hover:bg-primary-hover mt-5 text-white" data-clipboard-action="cut" data-clipboard-target="#cuttext"><i class="iconify tabler--copy me-1"></i> Cut Content</button>

<input type="text" id="cutInput" class="form-input" value="Temporary token: 8GDF-393K-L99Z" />
<button class="btn btn-sm bg-danger hover:bg-danger-hover mt-2 text-white" data-clipboard-action="cut" data-clipboard-target="#cutInput"><i class="iconify tabler--copy me-1"></i> Cut Token</button>

<!-- input group with icon button (share link, discount code, API key) -->
<div class="input-group flex">
  <input type="text" class="form-input" id="copyLink" value="https://example.com/invite?ref=12345" readonly />
  <button class="btn btn-icon bg-secondary text-white hover:bg-secondary-hover rounded-s-none" type="button" data-clipboard-target="#copyLink"><i class="iconify tabler--copy text-lg"></i></button>
</div>
<div class="input-group flex">
  <input type="text" id="discountCode" class="form-input" value="SAVE20NOW" readonly />
  <button class="btn btn-icon bg-warning text-white" type="button" data-clipboard-target="#discountCode"><i class="iconify tabler--copy text-lg"></i></button>
</div>

<!-- apps-api-keys.html table cell variant -->
<div class="input-group">
  <input type="text" class="form-input form-input-sm" id="keyOne" readonly value="e4A7Fc98z120XYz776abc90MNZ" />
  <button class="btn btn-sm btn-icon border-default-300" type="button" data-clipboard-target="#keyOne"><i class="iconify tabler--copy text-lg"></i></button>
</div>

<!-- code snippet -->
<pre><code id="codeSnippet">npm install clipboard --save</code></pre>
<button class="btn btn-sm bg-success hover:bg-success-hover mt-4 text-white" data-clipboard-target="#codeSnippet"><i class="iconify tabler--copy me-1"></i> Copy Command</button>
```

**Init / JS.** `assets/js/pages/plugins-clipboard.js` — the whole script:

```js
let elements = document.querySelectorAll("[data-clipboard-target]");
if (elements && elements.length > 0) new ClipboardJS(elements);
```

Add feedback yourself (not in the demo):

```js
const cb = new ClipboardJS("[data-clipboard-target], [data-clipboard-text]");
cb.on("success", e => { e.clearSelection(); /* swap icon to tabler--check or show a Swal toast */ });
cb.on("error",   e => { /* fall back: select the text so the user can Ctrl+C */ });
```

**Gotchas.**
- Target ids must be unique per page (table rows: `keyOne`, `keyTwo`, …). The demo selects only `[data-clipboard-target]`; buttons using clipboard.js's `data-clipboard-text="literal"` need the wider selector shown above.
- `cut` only works on `<input>`/`<textarea>`; on other elements it behaves like copy.
- Clipboard writes require a secure context (HTTPS or localhost) and a user gesture.
- Copy buttons placed in dynamically rendered table rows (e.g. after DataTables redraw) are covered because the instance is bound to a selector string, not to the elements existing at init — prefer the string form over the NodeList form the demo uses.

## Tree View (jsTree)

**What it is.** Six jsTree instances (`#jstree-1` … `#jstree-6`) showing: an HTML-defined tree, custom icons + clickable link nodes, a checkbox tree from JSON, a context-menu tree (`check_callback: true`), a drag-and-drop tree, and an Ajax-loaded tree (`core.data.url`). All use the `types` plugin with the template's `treeview-*` icon classes (CSS background SVGs in `app.min.css`). Theme overrides make `.jstree-clicked`, `.jstree-hovered`, `.jstree-wholerow` follow the colour tokens. The page is jQuery-based: `assets/plugins/jquery/jquery.min.js` is loaded explicitly and the page script starts with `window.jQuery = window.$ = $;`. Preline's `hs-tree-view` is not used on any demo page.

**Use it when.**
- File manager / document library folder trees (basic + ajax for large repos).
- Product category or org-chart hierarchies with drag-and-drop re-parenting (`dnd`).
- Permission / role editors where every node is a checkbox with tri-state parents (`checkbox` + `wholerow`).
- Admin "create / rename / delete" of nodes via right-click (`contextmenu`) — remember `core.check_callback: true` or edits are refused.
- Navigation trees where selecting a node opens a URL (`select_node.jstree` handler reading the `<a href>`).
- Use SortableJS instead for flat lists; use Preline `hs-accordion` for a static, non-interactive hierarchy.

**Source.** `references/sources/pages/plugins-tree-view.html`, `references/sources/assets/js/pages/plugins-treeview.js`, `assets/plugins/jquery/jquery.min.js`, `assets/plugins/jstree/jstree.min.js`. Ajax demo data: `assets/data/treeview-data.json` (not vendored).

**Markup.**

```html
<!-- 1. HTML-defined tree: nested <ul><li>; per-node state via data-jstree JSON -->
<div id="jstree-1">
  <ul>
    <li> Dashboard
      <ul>
        <li data-jstree='{ "selected": true }'><a href="javascript:;">Overview</a></li>
        <li>Analytics</li>
        <li data-jstree='{ "opened": true }'> Reports
          <ul>
            <li data-jstree='{ "disabled": true }'>Archived Report</li>
            <li data-jstree='{ "type": "file" }'>Current Report</li>
          </ul>
        </li>
      </ul>
    </li>
    <li data-jstree='{ "type": "link" }'><a href="https://www.example.com" target="_blank">External Resource</a></li>
  </ul>
</div>

<!-- 2. Custom icons per node (treeview-* classes + text colour utilities) -->
<div id="jstree-2">
  <ul>
    <li> Main Category
      <ul>
        <li data-jstree='{ "selected" : true, "icon": "treeview-star text-primary text-base" }'><a href="javascript:;">Favorite Item</a></li>
        <li data-jstree='{ "icon" : "treeview-file text-success text-base" }'>Documentation Files</li>
        <li data-jstree='{ "opened" : true, "icon" : "treeview-folder-open text-warning text-base" }'> Project Resources
          <ul>
            <li data-jstree='{ "disabled" : true, "icon": "treeview-icon-ban text-default-400 text-base" }'>Restricted Access</li>
            <li data-jstree='{ "type" : "file", "icon": "treeview-file text-base" }'>Final Report.pdf</li>
          </ul>
        </li>
        <li data-jstree='{ "icon" : "treeview-icon-user text-danger text-base" }'>Team Member Info</li>
      </ul>
    </li>
    <li data-jstree='{ "type" : "link", "icon": "treeview-icon-link text-info" }'><a href="#!">Buy <span class="text-danger font-semibold italic">MyAdmin</span></a></li>
  </ul>
</div>

<!-- 3-6. JSON / ajax trees: empty containers -->
<div id="jstree-3"></div>   <!-- checkbox -->
<div id="jstree-4"></div>   <!-- context menu -->
<div id="jstree-5"></div>   <!-- drag & drop -->
<div id="jstree-6"></div>   <!-- ajax -->
```

Icon classes available in `app.min.css` (all confirmed): `treeview-folder-filled`, `treeview-folder-open`, `treeview-article`, `treeview-star`, `treeview-file`, `treeview-icon-ban`, `treeview-icon-user`, `treeview-icon-link`, `treeview-icon-database`, `treeview-icon-arrow`.

**Init / JS.** `assets/js/pages/plugins-treeview.js` (trimmed):

```js
window.jQuery = window.$ = $;
const defaultTypes = { default: { icon: "treeview-folder-filled text-base text-warning" }, file: { icon: "treeview-article text-base" } };

function initTree(sel, opt) {
  const el = document.querySelector(sel); if (!el) return;
  $(el).jstree({ core: { themes: { responsive: false }, ...(opt.core || {}) },
                 plugins: opt.plugins || ["types"], types: opt.types || defaultTypes, ...(opt.state && { state: opt.state }) });
}
// 1 & 2: HTML trees + make link nodes navigate
initTree("#jstree-1", { types: defaultTypes });
$("#jstree-1").on("select_node.jstree", (e, data) => {
  const a = document.querySelector(`#${data.selected} a`); if (!a) return;
  const href = a.getAttribute("href"), target = a.getAttribute("target");
  if (href && href !== "#" && href !== "javascript:;") { target === "_blank" ? window.open(href, "_blank") : (window.location.href = href); return false; }
});
// 3: checkboxes from JSON
initTree("#jstree-3", { plugins: ["wholerow", "checkbox", "types"], types: defaultTypes,
  core: { themes: { responsive: false }, data: [
    { text: "Sample Nodes with Checkboxes", children: [
      { text: "Item initially selected", state: { selected: true } },
      { text: "Custom feedback icon", icon: "treeview-icon-database text-base text-danger" },
      { text: "Folder opened by default", icon: "treeview-folder-open text-base text-default", state: { opened: true }, children: ["Subfolder item", "Another subfolder item"] },
      { text: "Node with disabled state", icon: "treeview-file", state: { disabled: true } } ] },
    "And wholerow selection" ] } });
// 4: right-click create/rename/delete/cut/copy/paste; state persisted in localStorage under key
initTree("#jstree-4", { plugins: ["contextmenu", "state", "types"], types: defaultTypes,
  core: { check_callback: true, themes: { responsive: false }, data: staticData }, state: { key: "demo2" } });
// 5: drag & drop re-parenting
initTree("#jstree-5", { plugins: ["dnd", "state", "types"],
  types: { default: { icon: "treeview-folder-filled text-success text-base" }, file: { icon: "treeview-file text-primary text-base" } },
  core: { check_callback: true, themes: { responsive: false }, data: tree5Data }, state: { key: "demo2" } });
// 6: lazy / ajax children — url + params per expanded node
initTree("#jstree-6", { plugins: ["dnd", "state", "types"],
  types: { default: { icon: "treeview-folder-filled text-primary text-base" }, file: { icon: "treeview-article" } },
  core: { check_callback: true, themes: { responsive: false },
          data: { url: node => "assets/data/treeview-data.json", data: node => ({ id: node.id }) } },
  state: { key: "demo3" } });
```

Reading results: `$("#jstree-3").jstree("get_checked")` (ids) / `get_selected(true)` (full nodes); listen to `changed.jstree`, `move_node.jstree`, `rename_node.jstree`, `delete_node.jstree` to persist.

**Gotchas.**
- Load order matters: `jquery.min.js` → `jstree.min.js` → page script. jQuery is **not** exposed by `vendors.min.js` on these pages (the page itself warns "include jQuery").
- `contextmenu` and `dnd` silently refuse create/rename/move unless `core.check_callback: true` (or a function that validates the operation).
- `state` plugin stores open/selected nodes in `localStorage` per `state.key`; two trees sharing `"demo2"` will share state — give each tree its own key.
- Icon classes are plain CSS background images; `text-*` colour utilities on them do **not** recolour the SVG (the colours are baked into the data-URI) — the `types` icons are fixed colour.
- jsTree's CSS is compiled into `app.min.css` (`.jstree-default`, `.jstree-checkbox`, `.vakata-context`) with token overrides, so no extra stylesheet; dark mode is handled.

## Loading Buttons (Ladda)

**What it is.** Ladda turns a `.ladda-button` into a button with an embedded spinner / progress bar while an action runs. `data-style` picks the animation (`expand-left|right|up|down`, `contract`, `contract-overlay`, `zoom-in|out`, `slide-left|right|up|down`); `data-size="xs"` / `"s"` are the only size variants present in the compiled CSS (pair them with `.btn-sm`). Three init modes in the demo: auto-stop after a timeout, driven progress bar, manual `start()/stop()`.

**Use it when.**
- Form submit buttons (login, checkout, save settings) — give instant feedback and prevent double submits (Ladda disables the button while loading).
- Long-running actions with known progress (file upload, report generation) using `setProgress(0..1)`.
- Row-level actions in tables ("Sync", "Resend invite") where a spinner inside the button is clearer than a page overlay.
- Not for card-level refresh — the template already does that with `data-action="card-refresh"` (app.js injects `.card-overlay`).

**Source.** `references/sources/pages/plugins-loading-buttons.html`, `references/sources/assets/js/pages/plugins-loading-button.js`, `assets/plugins/jquery/jquery.min.js`, `assets/plugins/ladda/spin.min.js`, `assets/plugins/ladda/ladda.min.js`, `assets/plugins/ladda/ladda.jquery.min.js`. Ladda CSS is compiled into `app.min.css`.

**Markup.**

```html
<button class="ladda-button btn bg-primary hover:bg-primary-hover text-white" data-style="expand-left">Submit</button>
<button class="ladda-button btn bg-warning hover:bg-warning-hover text-white" data-style="contract">Submit</button>
<button class="ladda-button btn bg-info hover:bg-info-hover text-white" data-style="slide-up">Submit</button>
<!-- progress-driven: wrap in .progress-demo (demo selector) -->
<div class="progress-demo">
  <button class="ladda-button btn bg-danger hover:bg-danger-hover text-white" data-style="expand-right">Submit</button>
</div>
<!-- overlay style needs a z-index above neighbours -->
<button class="ladda-button btn bg-danger hover:bg-danger-hover text-white" data-style="contract-overlay" style="z-index: 1000">Submit</button>
<!-- manual API -->
<button class="ladda-button ladda-button-demo btn bg-primary hover:bg-primary-hover text-white" data-style="zoom-in">Submit</button>
```

| `data-style` values | Notes |
|---|---|
| `expand-left`, `expand-right`, `expand-up`, `expand-down` | button grows to make room for the spinner |
| `contract`, `contract-overlay` | button shrinks to a circle; overlay dims the page (needs z-index) |
| `zoom-in`, `zoom-out` | label zooms out, spinner zooms in |
| `slide-left`, `slide-right`, `slide-up`, `slide-down` | label slides away |

**Init / JS.** `assets/js/pages/plugins-loading-button.js`:

```js
// auto-stop after timeout (ms)
document.querySelectorAll(".ladda-button:not(.progress-demo .ladda-button):not(.ladda-button-demo)")
  .forEach(btn => Ladda.bind(btn, { timeout: 2000 }));
// progress bar driven by callback
document.querySelectorAll(".progress-demo .ladda-button").forEach(btn => {
  Ladda.bind(btn, { callback: instance => { let p = 0;
    const t = setInterval(() => { p = Math.min(p + Math.random() * 0.1, 1); instance.setProgress(p);
      if (p === 1) { instance.stop(); clearInterval(t); } }, 200); } });
});
// manual control — the pattern for real requests
const btn = document.querySelector(".ladda-button-demo");
const l = Ladda.create(btn);
btn.addEventListener("click", () => { l.start(); fetch("/api/save", { method: "POST" }).finally(() => l.stop()); });
```

**Gotchas.**
- Keep `.ladda-button` *and* the template `.btn` colour classes; Ladda wraps the label and injects the `.ladda-spinner` element itself at bind/create time — do not pre-render those. Only `.ladda-button[data-style…]` / `.ladda-spinner` rules are compiled; there is no `.ladda-label` styling to hook into.
- `Ladda.bind(selectorOrElement, { timeout, callback })` binds the click; `Ladda.create(el)` gives you `start() / stop() / setProgress(n) / isLoading()`. Use `Ladda.stopAll()` on page errors.
- The demo loads `spin.min.js` + `ladda.min.js` + `ladda.jquery.min.js` and jQuery; the vanilla `Ladda` global only needs the first two, the jQuery adapter (`$(...).ladda()`) is optional.
- Spinner colour follows `currentColor`, so white text buttons get a white spinner; on `bg-light` buttons use `data-spinner-color="#000"` (Ladda option, not in demo).

## Masonry

**What it is.** Masonry (desandro) laid over a Tailwind flex-wrap grid: the container has `data-masonry='{"percentPosition": true}'`, children are width-utility columns (`*:md:w-1/2 *:xl:w-1/4`) each wrapping a `.card.mx-3`; the page script instantiates `new Masonry(el, JSON.parse(el.dataset.masonry))` 100 ms after load. `apps-blog-grid.html` uses the identical pattern.

**Use it when.**
- Blog / article card grids where excerpt length varies (the demo).
- Pin-board style galleries, testimonial walls, note/widget boards, media libraries with mixed aspect ratios.
- Dashboards of unequal-height cards where CSS grid rows would leave gaps.
- Not needed when cards are equal height — use `grid … gap-base` with `h-full` cards; not for drag-to-arrange (combine with SortableJS or use a dedicated gridstack).

**Source.** `references/sources/pages/plugins-masonry.html`, `references/sources/pages/apps-blog-grid.html`, `references/sources/assets/js/pages/plugins-masonry.js` (identical to `apps-blog-grid.js`), `assets/plugins/masonry/masonry.pkgd.min.js`.

**Markup.**

```html
<!-- negative margin + per-item mx-3 gives the gutter; *: targets direct children -->
<div class="flex flex-wrap *:mb-base *:md:w-1/2 *:xl:w-1/4 -mx-3" data-masonry='{"percentPosition": true }'>
  <div>
    <article class="card mx-3">
      <div class="card-body">
        <h6 class="card-title mb-2.5 text-base"><a href="#!" class="hover:text-primary">Mastering Figma: 7 Pro Tips for Better UI Design</a></h6>
        <p class="text-default-400 mb-5">Unlock advanced techniques in Figma that can speed up your workflow…</p>
        <div>
          <a href="#!" class="badge badge-label border border-default-300">Figma</a>
          <a href="#!" class="badge badge-label border border-default-300">UX</a>
        </div>
      </div>
      <div class="card-footer flex justify-between border-0!">
        <div class="flex items-center justify-start gap-2.5">
          <div class="size-6"><img src="assets/images/users/user-6.jpg" alt="avatar-6" class="img-fluid rounded-full" /></div>
          <div><h5 class="lh-base text-sm text-nowrap"><a href="#!" class="hover:text-primary">Emma Blake</a></h5></div>
        </div>
        <a class="flex items-center gap-1 text-primary font-semibold hover:text-primary-hover" href="#!">Read more <i class="iconify tabler--arrow-right"></i></a>
      </div>
    </article>
  </div>
  <div>
    <article class="card mx-3">
      <div class="card-body">
        <blockquote class="blockquote"><p class="text-lg">A well-known quote, contained in a blockquote element.</p></blockquote>
        <figcaption class="blockquote-footer text-default-400">Someone famous in <cite title="Source Title">Source Title</cite></figcaption>
      </div>
      <!-- same footer -->
    </article>
  </div>
  <!-- repeat per card -->
</div>
```

`apps-blog-grid.html` variant of the wrapper: `class="flex flex-wrap *:w-full md:*:w-1/2 xl:*:w-1/4 -mx-3"` (explicit full width on mobile).

**Init / JS.** `assets/js/pages/plugins-masonry.js`:

```js
setTimeout(() => {
  document.querySelectorAll("[data-masonry]").forEach(el => {
    new Masonry(el, JSON.parse(el.getAttribute("data-masonry")));   // {"percentPosition": true}
  });
}, 100);
```

**Gotchas.**
- `percentPosition: true` is what lets the Tailwind width utilities define column width; do not pass `columnWidth`/`itemSelector` unless you change the markup.
- Masonry measures once; cards whose images load later overlap. Keep a reference and call `msnry.layout()` on `window.load` / after images or ajax inserts (`msnry.appended(nodes)`). imagesLoaded is not bundled.
- `img-fluid`, `blockquote`, `blockquote-footer`, `lh-base` are Bootstrap leftovers with no CSS in `app.min.css` — use `max-w-full h-auto`, `text-lg`, `text-default-400`, `leading-normal`.
- Each item **must** be a plain wrapper `<div>` (the width column) around the card; putting `mx-3` on the column breaks the percent maths.

## Tour (TourGuideJS)

**What it is.** TourGuideJS onboarding: any element carrying `data-tg-tour="text"` (+ `data-tg-title`, `data-tg-order`) becomes a step with a spotlight backdrop and a dialog; extra steps without a target (welcome / finish) are added with `addSteps()`. The theme compiles the `.tg-*` styles into `app.min.css` and overrides `.tg-dialog` (`--color-card`, `--color-body-color`) and `.tg-dialog-btn` (`--color-primary`) so the dialog matches the skin and dark mode.

**Use it when.**
- First-login onboarding of an admin panel ("here is your sidebar, here is the create button").
- Feature announcements after a release (point at the new control, remember completion).
- Guided setup wizards across a settings page (order steps with `data-tg-order`).
- Contextual help button ("Show me around") on complex screens such as the report builder or kanban.

**Source.** `references/sources/pages/plugins-tour.html`, `references/sources/assets/js/pages/plugins-tour.js`, `assets/plugins/tourguidejs/tour.js`.

**Markup.**

```html
<div class="mt-7.5 flex flex-wrap justify-center gap-2.5">
  <button id="tourTrigger" class="btn bg-primary hover:bg-primary-hover text-white"><i class="iconify tabler--player-play me-1"></i> Start Guided Tour</button>
  <a href="#!" class="btn bg-dark hover:bg-dark-hover text-white"
     data-tg-order="1" data-tg-title="Getting Started"
     data-tg-tour="Click here to get started and explore our framework-rich admin panel. 🚀"><i class="iconify tabler--compass me-1"></i> Discover Features</a>
  <a href="#!" target="_blank" class="btn bg-danger hover:bg-danger-hover text-white"
     data-tg-order="2" data-tg-title="Buy Now"
     data-tg-tour="Ready to supercharge your project? Click here to purchase the template!"><i class="iconify tabler--shopping-cart me-1"></i> Get the Template</a>
</div>

<!-- a whole section can be a step -->
<div data-tg-order="3" data-tg-title="Core Features" data-tg-tour="Learn more about the versatile services and modules we provide to enhance development.">
  <div class="grid xl:grid-cols-4 gap-base">
    <div class="card h-full p-2.5">
      <div class="card-body pb-0">
        <div class="mb-5"><span class="avatar-title bg-secondary flex size-12 items-center justify-center rounded-full text-2xl text-white"><i class="iconify tabler--device-desktop"></i></span></div>
        <h4 class="mb-2.5 text-lg font-semibold">Multiple Frameworks</h4>
        <p class="text-default-400 mb-5">Support for Bootstrap, Tailwind, React, Vue, Angular, Laravel, and more.</p>
      </div>
      <div class="card-footer border-0 pt-0"><a class="text-primary font-semibold hover:text-primary-hover" href="#">Know more <i class="iconify tabler--arrow-right ms-1 align-middle"></i></a></div>
    </div>
    <!-- repeat (tabler--layout, tabler--brush, tabler--rocket) -->
  </div>
</div>
```

**Init / JS.** `assets/js/pages/plugins-tour.js`:

```js
try {
  const tg = new tourguide.TourGuideClient({
    keyboardControls: true,
    rememberStep: true,                      // resumes at the last step visited
    dialogZ: 1005,                           // above the fixed topbar/sidebar
    backdropColor: "rgba(76, 76, 92, 0.75)"
  });
  tg.onFinish(() => { console.warn("Tour finished"); });        // persist "tour done" flag here
  tg.onAfterStepChange(() => { console.warn("Tour step changed"); });
  tg.addSteps([
    { title: "👋 Welcome to the Dashboard Tour", order: 0,
      content: '<p class="mb-3">Take a quick tour to explore the key features of our admin dashboard.</p><p>Use your keyboard or click "Next" to continue.</p>' },
    { title: "You're All Set!", order: 999,
      content: '<p class="mb-3">You’re ready to make the most of your admin panel 🎉</p><p class="mb-3 text-default-400">Click anywhere outside the tour to exit.</p>' }
  ]);
  document.getElementById("tourTrigger")?.addEventListener("click", () => { tg.start(); });
} catch { console.warn("Some thing went wrong with the tour."); }
```

**Gotchas.**
- Steps are collected from `[data-tg-tour]` at `start()`, ordered by `data-tg-order`; `addSteps` entries without `target` render centred. Targets hidden by `hidden`/collapsed sidebars cannot be highlighted — open them in `onBeforeStepChange` or skip.
- `dialogZ: 1005` is needed because the template's fixed topbar/sidenav sit above the default z-index; keep it ≥ 1005.
- `rememberStep` uses browser storage — with it on, re-running the tour continues where the user left off; turn it off (or clear storage) when the trigger should always restart from step 0.
- The content strings are HTML: Tailwind classes work inside (`mb-3`, `text-default-400`). `avatar-title` in the feature cards is a Bootstrap leftover (no CSS); the `flex size-12 …` utilities do the work.

## Animation (Animate.css)

**What it is.** Animate.css is compiled into `app.min.css`: add `animate__animated` plus one `animate__<effect>` class. The demo page has an accordion of effect buttons (`.animation_select[data-animation]`) that re-applies the classes to `#animation_box` so you can preview each effect; the only JS is that switcher.

**Use it when.**
- Attention effects on a badge / notification bell when something new arrives (`pulse`, `heartBeat`, `tada`, `shakeX` on a failed login field).
- Entrance of injected content: new table row (`fadeInDown`), toast (`slideInRight`), modal content (`zoomIn`), empty-state illustration (`bounceIn`).
- Exit before removal: `fadeOutRight` then `remove()` on `animationend`.
- Not for layout transitions (use Tailwind `transition-*`) or Preline components, which animate themselves (`hs-overlay`, `hs-collapse`).

**Source.** `references/sources/pages/plugins-animation.html`, `references/sources/assets/js/pages/plugins-animation.js`; CSS already in `app.min.css` (no plugin file).

**Markup.**

```html
<!-- the element to animate -->
<div id="animation_box" class="animate__animated">
  <img src="assets/images/blog/blog-1.jpg" class="img-fluid rounded" alt="user" />
</div>

<!-- effect picker: Preline accordion groups + buttons (trimmed to one group) -->
<div class="hs-accordion-group divide-default-300 border-default-300 divide-y rounded border" id="animationAccordion">
  <div class="hs-accordion active">
    <button class="hs-accordion-toggle hs-accordion-active:bg-default-100 font-secondary flex w-full items-center justify-between px-5 py-4 font-semibold transition" type="button">
      Attention Seekers <i class="iconify tabler--chevron-down hs-accordion-active:rotate-180 transition-transform text-base"></i>
    </button>
    <div id="collapseAttention" class="hs-accordion-content border-default-300 w-full overflow-hidden border-t transition-[height] duration-300">
      <div class="flex flex-wrap gap-2.5 px-5 py-4">
        <a href="#" class="btn bg-light animation_select" data-animation="bounce">bounce</a>
        <a href="#" class="btn bg-light animation_select" data-animation="pulse">pulse</a>
        <!-- … -->
      </div>
    </div>
  </div>
  <!-- other groups: add "hidden" to .hs-accordion-content and "collapsed" to the toggle -->
</div>

<!-- real-world use: entrance on an injected element -->
<div class="card animate__animated animate__fadeInUp animate__faster">…</div>
```

Effect names in the demo (all exist in the compiled CSS):

| Group | `animate__…` |
|---|---|
| Attention seekers | `bounce flash pulse rubberBand shakeX shakeY headShake swing tada wobble jello heartBeat` |
| Bouncing entrances | `bounceIn bounceInDown bounceInLeft bounceInRight bounceInUp` |
| Fading entrances / exits | `fadeIn fadeInDown fadeInLeft fadeInRight fadeInUp` / `fadeOut fadeOutDown fadeOutLeft fadeOutRight fadeOutUp` |
| Flippers | `flip flipInX flipInY flipOutX flipOutY` |
| Light speed | `lightSpeedInLeft lightSpeedInRight lightSpeedOutLeft lightSpeedOutRight` |
| Rotate | `rotateIn rotateInDownLeft rotateInDownRight rotateInUpLeft rotateInUpRight` |
| Zoom | `zoomIn zoomInDown zoomInLeft zoomInRight zoomInUp zoomOut zoomOutDown zoomOutLeft zoomOutRight zoomOutUp` |
| Sliding | `slideInDown slideInLeft slideInRight slideInUp slideOutDown slideOutLeft slideOutRight slideOutUp` |
| Special | `hinge jackInTheBox rollIn rollOut` |
| Modifiers (also compiled) | `animate__delay-1s … animate__delay-5s`, `animate__fast`, `animate__faster`, `animate__slow`, `animate__infinite`, `animate__repeat-1/2/3` |

**Init / JS.** `assets/js/pages/plugins-animation.js` (preview switcher only):

```js
document.addEventListener("DOMContentLoaded", () => {
  const box = document.getElementById("animation_box");
  document.querySelectorAll(".animation_select").forEach(btn => {
    btn.addEventListener("click", e => { e.preventDefault();
      const name = btn.getAttribute("data-animation");
      box.className = "";                                      // reset so the same effect can replay
      box.classList.add("animate__animated", "animate__" + name);
    });
  });
});
// replay helper for app code
function animateOnce(el, name) {
  el.classList.add("animate__animated", "animate__" + name);
  el.addEventListener("animationend", () => el.classList.remove("animate__animated", "animate__" + name), { once: true });
}
```

**Gotchas.**
- `animate__animated` sets `animation-fill-mode: both` and `--animate-duration` (1 s); override duration with `style="--animate-duration: .4s"` or the `animate__fast(er)` modifiers.
- Re-adding the same class does not replay; remove it first (the demo wipes `className`) or force reflow.
- Exit animations leave the element in the DOM at opacity 0 — remove it on `animationend`.
- The demo accordion still carries Bootstrap `data-bs-toggle` / `data-bs-target` attributes; Preline ignores them — only the `hs-accordion*` classes matter.

## Video Player (Plyr)

**What it is.** Plyr media player with five demos: MP4 with poster, autoplay-muted-loop MP4, YouTube and Vimeo embeds (`data-plyr-provider` + `data-plyr-embed-id`), and an audio player. Accent colour per player via the inline CSS variable `--plyr-color-main`; Plyr's stylesheet is compiled into `app.min.css`.

**Use it when.**
- Training / help-centre videos inside the admin (course player, onboarding library).
- Product videos on e-commerce product-detail or product-add preview screens.
- Media library previews (uploaded MP4 / MP3) with a consistent, themed control bar.
- Podcast / call-recording playback (audio) in CRM or support tools.
- Embedding marketing YouTube/Vimeo clips without the host's branding (`modestbranding`, `byline: false`).

**Source.** `references/sources/pages/plugins-video-player.html`, `references/sources/assets/js/pages/plugins-plyr.js`, `assets/plugins/plyr/plyr.min.js`.

**Markup.**

```html
<!-- MP4 with poster -->
<video id="player1" class="plyr w-100" playsinline controls poster="https://media.w3.org/2010/05/sintel/poster.png" style="--plyr-color-main: #1ac266">
  <source src="https://media.w3.org/2010/05/sintel/trailer_hd.mp4" type="video/mp4" />
</video>

<!-- autoplay must be muted to be allowed by browsers -->
<video id="player3" class="plyr w-100" playsinline controls muted autoplay loop poster="…" style="--plyr-color-main: #1c84c6">
  <source src="…/trailer_hd.mp4" type="video/mp4" />
</video>

<!-- YouTube / Vimeo -->
<div id="yt1"    class="plyr w-100" data-plyr-provider="youtube" data-plyr-embed-id="bTqVqk7FSmY" style="--plyr-color-main: #f8ac59"></div>
<div id="vimeo1" class="plyr w-100" data-plyr-provider="vimeo"   data-plyr-embed-id="76979871"    style="--plyr-color-main: #ed5565"></div>

<!-- audio -->
<audio class="w-100" id="player-audio" controls style="--plyr-color-main: #7b70ef">
  <source src="https://cdn.plyr.io/static/demo/Kishi_Bashi_-_It_All_Began_With_a_Burst.mp3" type="audio/mp3" />
  <source src="https://cdn.plyr.io/static/demo/Kishi_Bashi_-_It_All_Began_With_a_Burst.ogg" type="audio/ogg" />
</audio>
```

**Init / JS.** `assets/js/pages/plugins-plyr.js`:

```js
const p1 = new Plyr("#player1"), p3 = new Plyr("#player3");
const ytPlayer    = new Plyr("#yt1",    { youtube: { modestbranding: 1, rel: 0, playsinline: 1 } });
const vimeoPlayer = new Plyr("#vimeo1", { vimeo: { byline: false, portrait: false, title: false } });
document.addEventListener("DOMContentLoaded", () => { if (window.Plyr) new Plyr("#player-audio"); });
// several players at once: Plyr.setup(".plyr")
```

**Gotchas.**
- One `new Plyr()` per element, before or after DOMContentLoaded (the script runs after the markup, so direct calls work). For dynamically inserted players call `new Plyr(el)` after insertion.
- `--plyr-color-main` is honoured by the compiled CSS (18 references); set it inline or on a wrapper for theme colours (`var(--color-primary)` works).
- YouTube/Vimeo need network access and the host's iframe API; autoplay only works muted.
- `w-100` exists in `app.min.css` but is a legacy utility — prefer `w-full`.

## Icons: Tabler (Iconify classes)

**What it is.** The template's primary icon set. Icons are **CSS mask images** generated by the Iconify Tailwind plugin: `<i class="iconify tabler--<name>"></i>`. The `.iconify` base rule is `display:inline-block; width:1em; height:1em; background-color: currentColor; mask-image: var(--svg)`, so size follows `font-size` (`text-sm … text-9xl`) or explicit `size-*`, and colour follows `text-*`.

**Use it when.**
- Everything by default: nav items, buttons, table actions, breadcrumbs (`tabler--chevron-right rtl:rotate-180`), stat cards, empty states. The sidebar, topbar and all app pages use Tabler, so staying with it keeps the UI consistent.
- Pick Lucide only when a page intentionally wants its softer stroke style, and flags for locale/country.

**Source.** `references/sources/pages/icons-tabler.html`; icon CSS in `references/sources/assets/css/app.min.css`.

**Markup.**

```html
<!-- usage -->
<i class="iconify tabler--phone text-2xl"></i>
<!-- colour -->
<i class="iconify tabler--camera text-primary text-2xl"></i>
<i class="iconify tabler--mail text-danger text-2xl"></i>
<i class="iconify tabler--user text-purple text-2xl"></i>
<!-- size by font-size … -->
<i class="iconify tabler--device-watch text-xs"></i> <i class="iconify tabler--device-watch text-base"></i> <i class="iconify tabler--device-watch text-4xl"></i>
<!-- … or by box size -->
<i class="iconify tabler--device-watch size-3.25"></i> <i class="iconify tabler--device-watch size-6"></i> <i class="iconify tabler--device-watch size-15"></i>
<!-- inside a button / list item -->
<button class="btn bg-primary text-white hover:bg-primary-hover"><i class="iconify tabler--plus me-1"></i> Add</button>
<!-- icon tile used on the demo page -->
<div class="border-default-300 flex size-20 flex-col items-center justify-center gap-3 truncate rounded border border-dashed">
  <i class="iconify tabler--headphones text-2xl"></i><span class="block w-full truncate text-center font-semibold">Headphones</span>
</div>
```

**Init / JS.** None — pure CSS.

**Gotchas.**
- **Only icons that were used somewhere in the demo are compiled into `app.min.css`** (229 Tabler names, listed below). Any other `tabler--*` class renders as an empty 1em box. To use more icons you must rebuild the Tailwind CSS with the Iconify plugin (`@iconify/tailwind` + `@iconify-json/tabler`), or inline the SVG. Check the list before choosing a name — e.g. `tabler--zoom-out`, `tabler--grip-vertical`, `tabler--brand-github` are **not** available.
- Icons are masks, so `fill`/`stroke` do nothing; use `text-<colour>` (or `bg-*` — the mask paints `background-color`). `rtl:rotate-180` is the template idiom for directional chevrons/arrows.
- Keep `iconify` and the `tabler--name` class together on an empty `<i>`; adding text inside the element breaks the mask box.

Compiled Tabler names (`tabler--` prefix omitted): activity ad-2 adjustments-horizontal alarm-snooze alert-circle alert-octagon alert-triangle apps archive arrow-back-up arrow-down arrow-down-left arrow-left arrow-right arrow-up article atom ban basket battery-charging bell bell-off bell-ringing bluetooth bold bolt book box brand-facebook brand-figma brand-instagram brand-whatsapp brand-x briefcase broadcast brush bug building building-skyscraper building-store building-warehouse bulb calendar calendar-clock calendar-event calendar-time camera caret-right-filled category chart-bar chart-donut chart-histogram chart-pie-2 check checklist checks chevron-down chevron-left chevron-right chevron-up circle circle-check circle-dashed-plus circle-filled clipboard-list clock clock-pause cloud cloud-upload code compass components confetti copy corner-up-left corner-up-right-double cpu credit-card credit-card-refund currency-dollar dashboard database device-desktop device-floppy device-gamepad device-speaker device-tablet device-watch discount dots dots-vertical download edit external-link eye eye-off file file-check file-export file-text file-type-pdf file-type-ppt file-type-zip file-upload file-zip files filter-2 fingerprint flag folder folder-open grip-horizontal hand-stop headphones headset heart heart-filled home home-dollar hourglass icons id inbox info-circle invoice italic key layout layout-bottombar layout-kanban layout-sidebar-inactive leaf lifebuoy link list-check list-details lock lock-password logout mail mail-fast mail-forward mail-opened mailbox map map-pin maximize medal menu-4 message message-circle message-circle-2 message-dots messages microphone minimize minus mood-smile moon movie music package palette paperclip password-user pencil phone phone-call phone-ringing photo photo-up pig-money pin plane player-play plug plus point-filled printer quote refresh repeat-once report robot rocket rss school search send-2 server-bolt settings settings-2 share shield shield-check shield-lock shopping-cart sitemap smart-home speakerphone square-rounded-x stack-2 star star-filled sun table-column tag thumb-down thumb-up tools trash trending-up truck usb user user-check user-circle user-hexagon user-plus users users-group video volume wallet wand wifi world x zoom-in

## Icons: Lucide (Iconify classes)

**What it is.** Lucide delivered the same way as Tabler — Iconify CSS mask classes `iconify lucide--<name>` — not via `<i data-lucide>` + `lucide.createIcons()`. No demo page uses `data-lucide`, and `vendors.min.js` is not vendored locally, so the runtime Lucide API could not be confirmed; treat the Iconify class form as the supported one.

**Use it when.**
- A page or widget family where you want Lucide's rounder, lighter strokes (marketing-style landing blocks, feature cards).
- Matching an existing product UI already built on Lucide/shadcn-style icons.
- Otherwise prefer Tabler — the compiled Lucide subset is much smaller (52 names).

**Source.** `references/sources/pages/icons-lucide.html`; icon CSS in `app.min.css`.

**Markup.**

```html
<i class="iconify lucide--camera text-2xl"></i>
<i class="iconify lucide--house text-primary text-2xl"></i>
<i class="iconify lucide--folder text-danger text-2xl"></i>
<!-- sizes by box -->
<i class="iconify lucide--phone size-8.75"></i> <i class="iconify lucide--monitor size-6"></i> <i class="iconify lucide--watch size-2.75"></i>
<!-- tile -->
<div class="border-default-300 flex size-20 flex-col items-center justify-center gap-3 truncate rounded border border-dashed">
  <i class="iconify lucide--mic text-xl"></i><span class="block w-full truncate text-center font-semibold">Microphone</span>
</div>
```

**Init / JS.** None.

**Gotchas.**
- Same compile-time limitation as Tabler: only these 52 Lucide names are in `app.min.css` (`lucide--` prefix omitted): arrow-down arrow-left arrow-right arrow-up badge-dollar-sign badge-percent bell bluetooth book briefcase calendar camera check circle-user cloud cloud-upload database file film flag folder gamepad-2 globe headphones headset heart house key layers lock mail message-circle mic monitor music paperclip phone printer refresh-ccw search settings share shield shopping-cart speaker star tablet upload usb user watch wifi. Anything else needs a CSS rebuild with `@iconify-json/lucide`.
- Lucide names differ from Tabler (`house` vs `home`, `mic` vs `microphone`, `gamepad-2` vs `device-gamepad`, `circle-user` vs `user-circle`); do not mix prefixes on one name.

## Icons: Flags (SVG)

**What it is.** A folder of ISO-3166 alpha-2 country flags at `assets/images/flags/<code>.svg`, used as `<img>`. The demo page renders a searchable two-column table of all ~250 countries from the array in `flags-listing.js` (`{name, code}`), building the path `assets/images/flags/${code}.svg` and falling back to `unknown.svg` on error. The topbar language dropdown and the i18n page use the same files (`us de it es ru in ar sa gb fr …`).

**Use it when.**
- Language / locale switchers (pair with `data-translator-lang`).
- Country columns in customer, order, shipping and analytics tables; "top countries" widgets.
- Phone-prefix or currency selectors with `hs-select` showing a flag per option.
- Store / warehouse location badges.

**Source.** `references/sources/pages/icons-flags.html`, `references/sources/assets/js/pages/flags-listing.js`. The SVG files themselves are not vendored locally; codes referenced across the demo pages: ar au br ca cn de es fr gb in it jp mx ru sa sg us.

**Markup.**

```html
<!-- inline flag in a button / dropdown item / table cell -->
<img src="assets/images/flags/us.svg" alt="United States" class="me-1.5 h-4.5 rounded" />
<img src="assets/images/flags/de.svg" alt="German" class="me-1 size-4 rounded" height="18" />

<!-- demo listing page: search box in the card header + table filled by JS -->
<div class="card">
  <div class="card-header">
    <div>
      <h4 class="card-title mb-1.5">Flags Listing (SVG)</h4>
      <p class="text-default-400">We offer a set of scalable SVG flags, perfect for language selectors and international content.</p>
    </div>
    <div class="relative flex items-center">
      <div class="pointer-events-none absolute inset-y-0 start-0 flex items-center ps-3"><i class="iconify tabler--search text-default-400 text-lg"></i></div>
      <input type="search" id="countrySearch" class="form-input w-57.5 ps-10" placeholder="Search country..." />
    </div>
  </div>
  <div class="card-body">
    <div class="table-responsive">
      <table id="flagTable" class="table-bordered table w-full text-center align-middle">
        <thead><tr class="text-xs font-bold"><th>Flag</th><th>Country Name</th><th>Path</th><th>Flag</th><th>Country Name</th><th>Path</th></tr></thead>
        <tbody></tbody>   <!-- rows injected: <td><img class="rounded h-4.5 mx-auto"></td><td>name</td><td><code>path</code></td> x2 -->
      </table>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/flags-listing.js` (trimmed):

```js
let countries = [{ name: "Aruba", code: "aw" }, { name: "Afghanistan", code: "af" }, /* … ~250 entries … */ { name: "Zimbabwe", code: "zw" }];
const tableBody = document.querySelector("#flagTable tbody"), searchInput = document.querySelector("#countrySearch");
function renderTable(list) {
  tableBody.innerHTML = "";
  if (!list.length) { tableBody.innerHTML = '<tr><td colspan="6" class="text-center table-danger" role="alert">No country name found…</td></tr>'; return; }
  for (let i = 0; i < list.length; i += 2) {
    const tr = document.createElement("tr");
    for (let j = 0; j < 2; j++) { const c = list[i + j]; if (!c) { tr.innerHTML += "<td></td><td></td><td></td>"; continue; }
      const src = `assets/images/flags/${c.code.toLowerCase().trim()}.svg`;
      tr.innerHTML += `<td><img src="${src}" alt="${c.name}" class="rounded h-4.5 mx-auto"
        onerror="this.onerror=null; this.src='/images/flags/unknown.svg'; this.alt='Not Found'; this.classList.add('border','border-danger');"></td>
        <td>${c.name}</td><td><code>${src}</code></td>`; }
    tableBody.appendChild(tr);
  }
}
renderTable(countries);
searchInput.addEventListener("input", () => { const q = searchInput.value.toLowerCase();
  renderTable(countries.filter(c => c.name.toLowerCase().includes(q))); });
```

**Gotchas.**
- Codes are lower-case alpha-2 (`gb`, not `uk`; `us.svg` is used for English). The demo's `onerror` fallback points at `/images/flags/unknown.svg` (root-relative, unlike everything else) — fix the path to `assets/images/flags/unknown.svg` in your copy.
- Size with `h-4.5`/`size-4` + `rounded`; flags are rectangular SVGs, so set height and let width follow (or `size-*` + `object-cover` for square avatars).
- The `countries` array in `flags-listing.js` is a handy source for a country `<select>`; copy it rather than hand-typing the list.

## Choosing an icon source

| Situation | Use |
|---|---|
| Any admin UI chrome, buttons, tables, nav | Tabler (`iconify tabler--*`) — biggest compiled set, matches the template |
| Marketing / feature blocks wanting a softer look, or parity with a Lucide-based product | Lucide (`iconify lucide--*`) — check the 52-name list first |
| Country, language, locale, shipping origin | Flag `<img>` from `assets/images/flags/` |
| Tree node icons inside jsTree | `treeview-*` classes (fixed-colour SVG backgrounds), not Iconify |
| An icon that is not compiled | Rebuild CSS with the Iconify Tailwind plugin, or paste the SVG inline with `class="size-4 fill-current"` |

## Original sources

- `references/sources/pages/plugins-sortable.html` + `references/sources/assets/js/pages/plugins-nestable.js`
- `references/sources/pages/plugins-text-diff.html` + `references/sources/assets/js/pages/plugins-text-diff.js`
- `references/sources/pages/plugins-pdf-viewer.html` + `references/sources/assets/js/pages/plugins-pdf-viewer.js`
- `references/sources/pages/plugins-i18.html` + `references/sources/assets/js/app.js` (`I18nManager`) + `references/sources/assets/js/config.js`
- `references/sources/pages/plugins-sweet-alerts.html` + `references/sources/assets/js/pages/plugins-sweetalerts.js`
- `references/sources/pages/plugins-idle-timer.html` + `references/sources/assets/js/pages/plugins-idle-timer.js`
- `references/sources/pages/plugins-pass-meter.html` + `references/sources/assets/js/pages/plugins-pass-meter.js`
- `references/sources/pages/plugins-live-favicon.html` + `references/sources/assets/js/pages/plugins-tinycon.js`
- `references/sources/pages/plugins-clipboard.html` + `references/sources/assets/js/pages/plugins-clipboard.js` (+ `references/sources/pages/apps-api-keys.html` for the in-app usage)
- `references/sources/pages/plugins-tree-view.html` + `references/sources/assets/js/pages/plugins-treeview.js`
- `references/sources/pages/plugins-loading-buttons.html` + `references/sources/assets/js/pages/plugins-loading-button.js`
- `references/sources/pages/plugins-masonry.html` + `references/sources/assets/js/pages/plugins-masonry.js` (+ `references/sources/pages/apps-blog-grid.html`, `references/sources/assets/js/pages/apps-blog-grid.js`)
- `references/sources/pages/plugins-tour.html` + `references/sources/assets/js/pages/plugins-tour.js`
- `references/sources/pages/plugins-animation.html` + `references/sources/assets/js/pages/plugins-animation.js`
- `references/sources/pages/plugins-video-player.html` + `references/sources/assets/js/pages/plugins-plyr.js`
- `references/sources/pages/icons-tabler.html`, `references/sources/pages/icons-lucide.html`
- `references/sources/pages/icons-flags.html` + `references/sources/assets/js/pages/flags-listing.js`
- `references/sources/MANIFEST-page-deps.txt` (plugin asset paths), `references/sources/assets/css/app.min.css` (class existence, compiled icon lists, plugin theme overrides)
