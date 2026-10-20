# Tables: static tables, the custom-table.js grid, and DataTables

This group covers every way INSPINIA Tailwind renders tabular data: plain `.table` markup with utility-class
variants (tables-static), the template's own dependency-free list engine `assets/js/pages/custom-table.js`
driven entirely by `data-table-*` attributes (tables-custom, and the engine behind almost every `apps-*` list
page), and jQuery DataTables 2.x for large, remote, exportable or feature-heavy grids (15 `tables-datatables-*`
pages). Reach for a static table when the server renders a short list, for custom-table.js when a server-rendered
list needs search/sort/filter/select/paginate without a library, and for DataTables when you need ajax, export,
fixed columns/headers, child rows or thousands of rows.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Show a short server-rendered list (orders on a detail page, a settings matrix) | `.table-wrapper > table.table` + utility variants | tables-static | none (CSS only) |
| Striped / hover / bordered / borderless / compact / coloured rows & cells / nested / dark head / caption | variant classes listed under "Static tables" | tables-static | none |
| Row-level actions kebab menu in a cell | `.hs-dropdown` inside `td.text-end` | tables-static ("Custom Table") | Preline autoinit |
| Client-side search over a server-rendered list | `[data-table]` + `[data-table-search]` | tables-custom | `custom-table.js` (auto-init) |
| Check-all checkbox + bulk "Delete selected" with confirm modal | `[data-table-select-all]`, `[data-table-delete-selected]` | tables-custom | `custom-table.js` |
| Per-row delete with confirm modal | `[data-table-delete-row]` | tables-custom | `custom-table.js` |
| Paginate + rows-per-page select + "Showing 1 to 5 of 10 products" | `[data-table-pagination]`, `[data-table-set-rows-per-page]`, `[data-table-pagination-info]` | tables-custom | `custom-table.js` |
| Exact-match dropdown filters (status, category, role) | `select[data-table-filter="key"]` + `th[data-column="key"]` | tables-custom | `custom-table.js` |
| Price-bracket / date-preset filters (Today, Last 7 Days, $0-$50, $500+) | `select[data-table-range-filter="key"]` + `th[data-column="key"]` | tables-custom | `custom-table.js` |
| Click-to-sort columns (numbers, money, %, dates, ordinals) | `th[data-table-sort]` | tables-custom | `custom-table.js` |
| Sort on a cell that contains avatar + link + subtitle | `th[data-table-sort="key"]` + `[data-sort="key"]` in the cell | tables-custom | `custom-table.js` |
| A complete products/orders/users list page (everything above) | "Complete Custom Table" skeleton | tables-custom (+ all `apps-*` list pages) | `custom-table.js` |
| Decide between custom-table.js and DataTables | decision table | — | — |
| Shared DataTables setup (script order, jQuery, Tabler pager icons, markup) | `new DataTable(el, {...language})` | all tables-datatables-* | `datatables-dt/dataTables.min.js` + `dataTables.responsive.min.js` |
| Zero-config sortable/searchable/paged grid; two-row grouped header | `new DataTable('[data-tables="basic"]')` | tables-datatables-basic | `datatables-basic.js` |
| Copy / CSV / Excel / PDF / Print buttons, or an "Export" dropdown | Buttons extension | tables-datatables-export-data | `datatables-export-data.js` + buttons/jszip/pdfmake |
| Click rows to select (single, multi, OS-style cell selection) | Select extension `select:{style}` | tables-datatables-select | `datatables-select.js` + `dataTables.select.min.js` |
| Load rows from a JSON endpoint with a processing indicator | `ajax:"…json"`, `columns:[{data}]` | tables-datatables-ajax | `datatables-ajax.js` |
| Build the grid from a JS array (no `<tbody>` in HTML) | `data: dataSet`, `columns:[{title}]` | tables-datatables-javascript | `datatables-javascript-source.js` |
| Render cells as links, flag images, progress bars, coloured currency | `columns[].render(data, type)` | tables-datatables-rendering | `datatables-rendering.js` |
| Scroll a fixed-height body / scroll a wide table sideways | `scrollY`, `scrollX`, `scrollCollapse` | tables-datatables-scroll | `datatables-scroll.js` |
| Pin first and last column on a 17-column table | FixedColumns `fixedColumns:{start,end}` | tables-datatables-fixed-columns | `datatables-fixed-columns.js` + `dataTables.fixedColumns.min.js` |
| Keep the header visible while scrolling a long page | FixedHeader `fixedHeader:{headerOffset:65}` | tables-datatables-fixed-header | `datatables-fixed-header.js` + `dataTables.fixedHeader.min.js` |
| "Show/Hide Columns" dropdown of checkboxes | `table.column(i).visible(bool)` | tables-datatables-columns | `datatables-show-hide-columns.js` |
| Expand a row to show details (child row) | `row.child(html).show()` + `td.dt-control` | tables-datatables-child-rows | `datatables-child-rows.js` |
| One search box per column in the header | second `<tr>` of inputs + `column(i).search()` | tables-datatables-column-searching | `datatables-column-search.js` |
| Min / Max numeric filter (price between) | `table.search.fixed("range", fn)` | tables-datatables-range-search | `datatables-range-search.js` |
| "Add Row" button that appends rows programmatically | `table.row.add([...]).draw(false)` | tables-datatables-rows-add | `datatables-rows-add.js` |
| Checkbox column with header check-all (DataTables flavour) | `DataTable.render.select()` + `select:{style:"multi", selector}` | tables-datatables-checkbox-select | `datatables-checkbox-select.js` + `dataTables.select.min.js` |

## Static tables (tables-static)

**What it is.** The base `.table` component class plus the responsive `.table-wrapper`, and twelve demo
variants built almost entirely with Tailwind utilities on `<thead>`, `<tr>`, `<th>` and `<td>`. There is no
JavaScript on this page; the only interactive bit is the Preline kebab dropdown in the actions cell.

**Use it when.**
- A server-rendered list that fits on one screen: the last 5 orders on a customer page, a permissions matrix,
  an invoice line-item table, a pricing comparison, a settings/audit table.
- Any table inside a modal, offcanvas, tab or printable page where you do not want pagination or JS.
- Not for: lists the user must search/sort/paginate (use custom-table.js), or remote/large data (use DataTables).

**Source.** `references/sources/pages/tables-static.html` (no page script).

**What `.table` gives you (from app.min.css).** `width:100%; border-collapse:collapse; caption-side:bottom;`
every `tr` gets a 1px bottom border in `--color-light`; `thead th` is `py-3 px-2.5 text-start font-bold`;
`td` is `py-3 px-2.5 align-middle`; the first/last cell of a row gets `ps-4.5` / `pe-4.5` so content aligns
with `.card-body` padding; the last `tbody tr` has no border; `tfoot` gets a `default-400/50` background and
top border; `caption` is `text-default-400 text-sm mt-4`. `.table-wrapper` is `overflow:auto; position:relative;
width:100%` — it is the responsive horizontal-scroll container; always wrap tables in it.
Modifier classes compiled into app.min.css (put them on the `<table>`): `table-striped` (odd `tbody` rows
`light/45`), `table-hover` (`tbody tr:hover` `light/45`), `table-bordered` (full grid), `table-borderless`
(no row borders), `table-sm` (`th`/`td` padding 2), plus `thead-sm` on the `<thead>` (header padding 2) and
`table-custom` (`th { white-space:nowrap }`). Rows containing a checked `.form-checkbox` are tinted
`warning/10` automatically (`.table:has(.form-checkbox:checked) tr:has(.form-checkbox:checked)`).

**Markup (Basic Table — the canonical skeleton).**

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Basic Table</h4>
  </div>
  <div class="card-body">
    <div class="table-wrapper">
      <table class="table">
        <thead class="font-semibold text-xs">
          <tr><th>Product Name</th><th>Category</th><th>Price</th><th>Stock</th><th>Rating</th><th>Status</th><th>Actions</th></tr>
        </thead>
        <tbody>
          <!-- repeat per row -->
          <tr>
            <td class="font-medium">Wireless Headphones</td>
            <td>Electronics</td>
            <td>$99.00</td>
            <td>120</td>
            <td>4.5 ★</td>
            <td><span class="badge badge-label bg-success/10 text-success">Active</span></td>
            <td class="flex gap-1.5">
              <button class="btn btn-sm bg-primary text-white hover:bg-primary-hover">Edit</button>
              <button class="btn btn-sm bg-danger text-white hover:bg-danger-hover">Delete</button>
            </td>
          </tr>
          <tr>
            <td class="font-medium">Smartwatch</td><td>Wearables</td><td>$129.00</td><td>0</td><td>4.0 ★</td>
            <td><span class="badge badge-label bg-warning/10 text-warning">Out of Stock</span></td>
            <td class="flex gap-1.5">…</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
```

**Variants (one row per demo card; classes copied from the source).**

| Card | Where the classes go | Classes |
|---|---|---|
| Basic Table | `thead` | `font-semibold text-xs` |
| Custom Table (grey head, kebab actions, flush to card edge) | `thead`; the `.table-wrapper` sits directly in `.card` (no `.card-body`) | `thead.border-default-300.bg-default-100.border-b.font-semibold.text-xs`; last `th.text-end` |
| Variants of Table (coloured rows / cells) | `tr` or `td` | row: `tr.border-default-300.bg-primary/15.border-b`; cell: `td.bg-warning/15.px-2.25.py-3`, `td.bg-info/15.px-2.25.py-3`, `td.bg-danger/15.px-2.25.py-3`, `td.bg-light/15.px-2.25.py-3`, dark cell `td.bg-dark.px-2.25.py-3.font-medium.text-white` |
| Striped Rows | every `tbody tr` | `border-default-300 odd:bg-default-100 border-b` — or just put `table-striped` on the table (CSS: odd `tbody tr` get `light/45` background) |
| Striped Columns | alternate `th` / `td` | `th.bg-default-100.p-2.text-start`, `td.bg-default-100.px-2.25.py-3` |
| Hoverable Rows | `table` | `table table-hover` (CSS: `tbody tr:hover` → `light/45`) |
| Active Tables (highlight one row / one cell) | `tr` or `td` | row: `tr.border-default-300.bg-default-100.border-b`; cell: `td.bg-default-100.px-2.py-3` |
| Bordered Tables | `thead`, header `tr`, body `tr` — or just the table | demo: `thead.border-default-300.border` + `tr.divide-default-300.divide-x`; body `tr.border-default-300.divide-default-300.divide-x.border`. Shorter: `table table-bordered` (CSS: 1px `light` outer border + inline-end border on every `td`/`th` except the last, i.e. a full grid). |
| Tables without Borders | every `tbody tr` | `tr.border-0` — or `table-borderless` on the table (CSS: `tr` border none) |
| Small Tables | every `td` | `td.p-2` — or `table-sm` on the table (CSS: `thead th` and `tbody td` padding 2). `thead.thead-sm` compacts the header only. |
| Table Group Dividers (thick rule under head) | `thead` | `border-default-600 border-b-2 font-semibold text-xs` |
| Nesting | a full-width row | `<tr><td colspan="7" class="border-default-300 w-full border-b p-5"><table class="table">…</table></td></tr>` |
| Table Head (dark) | `thead` + its `tr` | `thead.bg-dark` + `tr.*:text-white!` (first `th.text-start`) |
| Captions | `table` + `caption` | `<table class="w-full table table-hover"><caption class="text-default-400 caption-bottom pt-3 text-start mt-0">List of Ecommerce Products</caption>` |

Column width hints used in the demo: `th.text-end.w-[1%]` or `style="width: 1%"` on the Actions column keeps
it as narrow as its content.

**Row-actions kebab (from "Custom Table"; reused by every variant).**

```html
<td class="text-end">
  <div class="hs-dropdown relative inline-flex">
    <button type="button" class="hs-dropdown-toggle flex h-7.5 w-11.25 items-center justify-center font-semibold"
            aria-haspopup="menu" aria-expanded="false" aria-label="Dropdown" hs-dropdown-placement="bottom-end">
      <i class="iconify tabler--dots-vertical text-xl"></i>
    </button>
    <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical">
      <a class="dropdown-item" href="#"><i class="iconify tabler--eye text-xs"></i> Overview</a>
      <a class="dropdown-item" href="#"><i class="iconify tabler--edit text-xs"></i> Edit</a>
      <a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash text-xs"></i> Delete</a>
    </div>
  </div>
</td>
```

**Gotchas.**
- `.table-wrapper` is `overflow:auto`; a Preline dropdown near the bottom of a short table gets clipped. Add
  `[--strategy:fixed]` to that `.hs-dropdown` (see common-pitfalls.md) or give the wrapper extra bottom padding.
- `thead` has no background by default; use `bg-default-100` (grey) or `bg-dark` + `*:text-white!` (dark). In dark
  mode `bg-default-100` flips with the token, `bg-dark` does not (it stays dark on dark) — prefer the grey variant.
- `badge-label` makes the badge square-cornered (`border-radius:0`); drop it for the default pill badge.
- Do not mix `.table-sm` with custom `td.p-2` — pick one.

## custom-table.js: the template's own table engine (overview and public API)

**What it is.** `assets/js/pages/custom-table.js` (14 KB, no dependencies beyond Preline's `HSOverlay` for the
confirm modal). It defines two classes — `CustomTable` (the parent/config instance) and `Table` (one per matched
container) — and self-initialises on `DOMContentLoaded` with `new CustomTable()`. Everything is declared with
`data-table-*` attributes in the HTML; there is no per-page JavaScript to write. It is what powers 28 demo pages
including every e-commerce/users/projects/invoices list and the two dashboards' tables.

**Use it when.**
- A server-rendered list of up to a few hundred rows needs search, sort, exact/range filters, check-all +
  bulk delete, per-row delete, rows-per-page and pagination — products, orders, customers, invoices, API keys,
  roles/permissions, issue tracker, file manager, inbox.
- You want rich cells (avatar + name + subtitle, star ratings, badges, action buttons) with no renderer code.
- Not for: data that arrives after load or changes via AJAX (rows are captured once at init; there is no
  `refresh()`), tens of thousands of rows, export to CSV/PDF, fixed columns/headers, child rows — use DataTables.

**Source.** `references/sources/pages/tables-custom.html` + `references/sources/assets/js/pages/custom-table.js`.
Page script order: `config.js`, `vendors.min.js`, `app.js`, `assets/js/pages/custom-table.js` (nothing else).

**How it is instantiated.** The last line of the script is
`document.addEventListener("DOMContentLoaded", () => { new CustomTable })`. The instance is not assigned to a
global. The constructor takes an options object whose keys are the selectors/attributes below; call it yourself
only if you rename attributes, and then remove the auto-init line or every `[data-table]` gets bound twice:

```js
// Defaults — copied from the CustomTable constructor. All are selectors except the *Attribute keys and numbers.
new CustomTable({
  tableSelector:          "[data-table]",
  checkAllSelector:       "[data-table-select-all]",
  searchSelector:         "[data-table-search]",
  filterSelector:         "select[data-table-filter], input[data-table-filter]",
  rangeFilterSelector:    "select[data-table-range-filter], input[data-table-range-filter]",
  rowsPerPageSelector:    "[data-table-set-rows-per-page]",
  rowsPerPageAttribute:   "data-table-rows-per-page",
  paginationSelector:     "[data-table-pagination]",
  sortSelector:           "[data-table-sort]",
  sortAttribute:          "data-table-sort",
  paginationInfoSelector: "[data-table-pagination-info]",
  paginationInfoAttribute:"data-table-pagination-info",
  deleteSelectedSelector: "[data-table-delete-selected]",
  deleteRowSelector:      "[data-table-delete-row]",
  rowsPerPage: 10,
  currentPage: 1
});
```

**Public API — attributes the engine looks for (all queried *inside* the `[data-table]` container).**

| Attribute | Put it on | Behaviour (from the source) |
|---|---|---|
| `data-table` | The container that wraps the `<table>` AND all its controls — in every demo this is the `.card` | One `Table` instance per match. The engine takes the first `thead`/`tbody` inside it (`querySelector`), so do not nest a second table inside the container. Rows = all `tbody > tr` at init. |
| `data-table-rows-per-page="8"` | same container | Page size. Default 10. Demo values: 5, 8, 10, 15. |
| `data-table-search` | `<input type="search">` | `keyup`: case-insensitive substring match against the `textContent` of every `td` in the row; resets to page 1. |
| `data-table-select-all` | `<input type="checkbox">` inside `thead` | Click sets `checked` on the first `input[type=checkbox]` of every row. Any row checkbox `change` toggles the `hidden` class on the delete-selected button (only wired when a select-all checkbox exists). |
| `data-table-delete-selected` | a `<button>` that starts with class `hidden` | Click → confirm modal → removes every row whose checkbox is checked, re-hides the button, unchecks select-all. |
| `data-table-delete-row` | a button/link inside each row | Click → confirm modal → removes `closest('tr')`. |
| `data-table-filter="key"` | `<select>` (or `<input>`) | `change`: keeps rows whose cell under `th[data-column="key"]` has `textContent.trim()` equal (case-insensitive) to the select value. Value `""` or exactly `"All"` = no filter. If no `th[data-column="key"]` exists the filter is ignored. Every filter select is re-evaluated on each change (AND). |
| `data-table-range-filter="key"` | `<select>` | `change`: same column lookup. If `key` contains "date": cell parsed with `new Date(text)`; option values must be exactly `Today`, `Last 7 Days`, `Last 30 Days`, `This Year` (anything else passes). Otherwise numeric: cell text stripped to `[\d.-]` then `parseFloat`; option `"500+"` = `>= 500`, `"51-150"` = inclusive range. `""`/`"All"` = no filter. |
| `data-column="key"` | `<th>` | Names a column for filters/range filters. Index is derived from `thead th` order, so keep one `<th>` per column (no colspans). |
| `data-table-sort` | `<th>` | Makes the header clickable (cursor:pointer), appends an up/down arrows SVG (unless the `th` already contains an `<i>`), toggles `data-direction` asc/desc on click, sorts the currently filtered rows, resets to page 1. |
| `data-table-sort="key"` + `data-sort="key"` | `<th>` + an element inside each cell | Sort uses the `textContent` of the `[data-sort="key"]` descendant instead of the cell's first text node — for cells like avatar + `<a data-sort="product">Name</a>` + subtitle. |
| `data-table-set-rows-per-page` | `<select>` with numeric `<option>`s | Options are rebuilt (numeric, ascending; the container's page size is inserted if missing) and the current size pre-selected; `change` re-renders. |
| `data-table-pagination` | empty `<div>` | Receives `ul.pagination.justify-center > li.page-item(.active|.disabled) > a.page-link` with prev/next chevron SVGs and one button per page. Hidden (`display:none`) when there are no rows. |
| `data-table-pagination-info="products"` | empty `<div>` | Gets `class="text-default-400"` (overwrites any class you set) and `Showing <b>1</b> to <b>5</b> of <b>10</b> products`; the noun defaults to `entries`. Demo nouns: products, orders, customers, invoices, roles, permissions, issues, clients, apis, categories, refunds, reviews, sellers, projects. |

**Sort value parsing (what `th[data-table-sort]` understands).** Text is trimmed and whitespace-collapsed, then
tried in this order: `(1,234)` → negative number (accounting style — note the demo's `(87)` review counts
therefore sort as -87); `12.5%` → 0.125; `$1,399.00`, `€`, `₹` with optional `K`/`M`/`B` suffix → number scaled
by 1e3/1e6/1e9; `1st`/`2nd` → ordinal integer; plain number; anything `new Date()` can parse → timestamp;
otherwise lower-cased string with `localeCompare`. Numbers only compare with numbers and strings with strings;
a mixed column keeps its order.

**Empty state and confirm modal (injected by the engine; style hooks you can target).**

```html
<!-- rendered into tbody when nothing matches -->
<tr class="no-results"><td colspan="11" class="text-center text-default-400 py-3">Nothing found.</td></tr>

<!-- appended to <body> and opened with HSOverlay.open() on delete; re-created on every click -->
<div id="confirm-delete-modal" class="hs-overlay pointer-events-none fixed start-0 top-0 z-80 hidden size-full overflow-x-hidden overflow-y-auto" tabindex="-1" aria-hidden="true">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 m-3 flex min-h-[calc(100%-56px)] scale-95 items-center opacity-0 transition-all duration-200 ease-in-out sm:mx-auto sm:w-full sm:max-w-lg">
    <div class="border-default-300 pointer-events-auto flex w-full flex-col rounded-md border bg-card">
      <div class="border-default-300 flex items-center justify-between border-b p-6">
        <h4 id="confirm-delete-modalLabel" class="text-base font-bold">Confirm Deletion</h4>
        <button type="button" aria-label="Close" data-hs-overlay="#confirm-delete-modal"><i class="close-icon size-5"></i></button>
      </div>
      <div class="overflow-y-auto p-5"><p>Are you sure you want to delete this row?</p></div>
      <div class="border-default-300 flex items-center justify-end gap-x-2 border-t p-5">
        <button type="button" class="btn bg-light hover:text-primary" data-hs-overlay="#confirm-delete-modal">Cancel</button>
        <button type="button" class="btn bg-danger text-white hover:bg-danger-hover" id="confirm-delete">Delete</button>
      </div>
    </div>
  </div>
</div>
```

The three messages (`itemNotFoundMessage = "Nothing found."`, `deleteRowMessage`, `deleteMultipleRowsMessage`)
are properties on each `Table` instance, not constructor options; to change them edit the script or subclass
`Table`. Deletion is DOM-only — wire your own `fetch()` to the `#confirm-delete` click if the server must know.

**Pagination CSS (already in app.min.css).** `.pagination` is `inline-flex items-center` with 1.5 spacing;
`.page-item .page-link` is a `7.5 x 7.5` bordered (`default-300`) rounded square; `.page-item.active .page-link`
→ `bg-primary text-white`; `.page-item.disabled .page-link` → `opacity:60%; pointer-events:none`; in RTL
`.pagination svg` is mirrored automatically.

**App pages that reuse custom-table.js (from MANIFEST-page-deps.txt).** Full feature set (search, filters,
sort, select-all, delete, pagination, info): apps-ecommerce-products, -orders (+ date range filter),
-product-stocks (+ range), -purchased-orders, -refunds, -categories, -attributes, -warehouse, -customers,
-reviews, -seller-details, apps-invoice-list, apps-clients, apps-api-keys, apps-projects-list (+ range),
apps-users-roles, apps-users-role-details. Partial: apps-ecommerce-sellers and -product-views (range filter,
no per-row delete), apps-ecommerce-sales and -product-details (sort + pagination), apps-file-manager (search,
filter, sort, select-all, bulk delete, no pagination), apps-users-permissions (sort + pagination + row delete),
apps-issue-tracker (search, pagination, row delete), apps-email-inbox (search + rows-per-page only),
dashboard-analytics and dashboard-ecommerce (pagination + info on a widget table). apps-outlook loads the script
but has no `[data-table]` container. Study apps-ecommerce-products for the richest real-world toolbar.

**Gotchas.**
- The `[data-table]` container must enclose the controls as well as the table: a search box in the page header
  outside the `.card` will not be found.
- Search and filters do not combine: typing in the search box recomputes the row set from all rows (ignoring
  active filters), and changing a filter ignores the search text. Sorting does respect the current filtered set.
- Filter option values are compared as exact strings. The demo page has typos you must not copy:
  `<option value=" All">` (leading space — once any filter changes, this select hides every row because
  `" All" !== "All"`), `data-table-filter="statu"` and `<option value=" Published">` in the "Complete" card. Use
  `value=""` for the "any" option and make option values match the cell text exactly.
- Changing rows-per-page keeps `currentPage`; jumping from page 3 of 5-per-page to 20-per-page can land on an
  empty page until the user clicks a page number.
- Rows removed by delete are gone from the DOM and from the engine's arrays; rows you append later with JS are
  invisible to the engine (no refresh API) — re-run `new CustomTable()` only if you also removed the auto-init.
- `data-table-pagination-info` overwrites its element's `class` with `text-default-400`; wrap it if you need layout
  classes (the demo puts it inside `.card-footer`).
- Date range filters parse the whole cell text, e.g. `18 Apr, 2025 <small>12:24 PM</small>` → `new Date("18 Apr,
  2025 12:24 PM")`. Keep cell dates in a format `Date.parse` accepts, or the row fails every date preset.

## Custom table: search, select-all and delete (with confirm modal)

**What it is.** The three smallest cards on tables-custom: a search input, a header check-all with row
checkboxes, and per-row + bulk delete buttons that open the engine's confirm modal.

**Use it when.** An inbox/file list where users tick rows and delete them; an API-keys table with per-row
revoke; a client list with a quick filter box.

**Source.** `references/sources/pages/tables-custom.html` cards "Custom Table with Search", "Custom table with
checkbox select", "Custom table with delete buttons"; `assets/js/pages/custom-table.js`.

**Markup.**

```html
<div data-table class="card">
  <div class="card-header">
    <h4 class="card-title">Custom table with delete buttons</h4>
  </div>
  <div class="card-header">
    <div class="flex gap-2">
      <div class="input-icon-group">
        <i class="iconify tabler--search input-icon"></i>
        <input data-table-search type="search" placeholder="Search product name..." class="form-input" />
      </div>
      <!-- starts hidden; the engine un-hides it when any row checkbox is checked -->
      <button data-table-delete-selected class="hidden btn bg-danger text-white hover:bg-danger-hover">Delete</button>
    </div>
  </div>
  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="font-semibold">
        <tr class="bg-light/15 text-2xs uppercase">
          <th class="py-2 ps-4.5 pe-2 text-start"><input data-table-select-all class="form-checkbox bg-light size-4.25" type="checkbox" /></th>
          <th class="p-2 text-start">Product</th><th class="p-2 text-start">SKU</th><th class="p-2 text-start">Category</th>
          <th class="p-2 text-start">Stock</th><th class="p-2 text-start">Price</th><th class="p-2 text-start">Orders</th>
          <th class="p-2 text-start">Rating</th><th class="p-2 text-start">Status</th><th class="p-2 text-start">Published</th>
          <th class="p-2 text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <!-- repeat per row -->
        <tr>
          <td><input class="form-checkbox bg-light size-4.25" type="checkbox" /></td>
          <td>
            <div class="flex">
              <div><div class="me-base size-5 lg:size-9"><img src="assets/images/products/1.png" alt="Product" class="size-5 rounded lg:size-9" /></div></div>
              <div>
                <h5 class="text-default-800 hover:text-primary mb-1.25"><a href="ecommerce-product-details.html">Wireless Earbuds</a></h5>
                <p class="text-default-400 text-2xs">by: My Furniture</p>
              </div>
            </div>
          </td>
          <td>WB-10245</td>
          <td>Electronics</td>
          <td><h5>56</h5></td>
          <td>$59.99</td>
          <td>124</td>
          <td>
            <span class="text-warning"><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star"></i></span>
            <span class="ms-1.25"><a href="ecommerce-reviews.html" class="hover:text-primary font-semibold">(87)</a></span>
          </td>
          <td><span class="badge text-2xs bg-success/15 text-success">Published</span></td>
          <td>18 Apr, 2025 <small class="text-default-400">12:24 PM</small></td>
          <td>
            <div class="flex justify-center gap-1.25">
              <a href="#" class="btn bg-light btn-icon btn-sm text-default-800 hover:text-primary size-7.5 rounded-full"><i class="iconify tabler--eye text-base"></i></a>
              <a href="#" class="btn bg-light btn-icon btn-sm text-default-800 hover:text-primary size-7.5 rounded-full"><i class="iconify tabler--edit text-base"></i></a>
              <button type="button" class="btn btn-icon btn-sm rounded-full size-7.5 bg-danger text-white hover:bg-danger-hover" data-table-delete-row><i class="iconify tabler--trash text-base"></i></button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
```

Status badge colours used across the list pages: `bg-success/15 text-success` (Published), `bg-warning/15
text-warning` (Pending), `bg-danger/15 text-danger` (Out of Stock). The apps pages use
`form-checkbox form-checkbox-light size-4.5` for the checkboxes and bordered icon buttons
(`btn btn-icon btn-sm border border-default-300 hover:border-default-400`) with `<a data-table-delete-row>`.

**Init / JS.** None — `custom-table.js` auto-binds on `DOMContentLoaded`.

**Gotchas.**
- The select-all checkbox must live inside `<thead>`; the engine looks it up with `thead.querySelector(...)`.
- Each row's *first* `input[type=checkbox]` is the selection checkbox; do not put another checkbox before it.
  With `data-table-delete-selected` present, *every* row needs a checkbox — the handler calls
  `row.querySelector('input[type="checkbox"]').checked` and throws on a row without one.
- The bulk Delete button toggling only works when a select-all checkbox exists in the same container.
- Checked rows highlight automatically: app.min.css has `.table:has(.form-checkbox:checked) tr:has(.form-checkbox:checked)`
  → `bg-warning/10`. Use `form-checkbox` on the row checkboxes to get it.
- Search listens to `keyup` only; the native clear (x) of `type="search"` and mouse-paste do not trigger it.
- The confirm modal is a Preline overlay; `HSOverlay` must be loaded (it is, via `vendors.min.js`).

## Custom table: pagination, rows-per-page and pagination info

**What it is.** Client-side paging rendered by the engine into an empty `[data-table-pagination]` div, a
`[data-table-set-rows-per-page]` select the engine rebuilds, and a "Showing x to y of z" line.

**Use it when.** Any list longer than ~8 rows; dashboard widget tables that show 5 rows at a time
(dashboard-analytics / dashboard-ecommerce use exactly this: pagination + info with `data-table-rows-per-page`).

**Source.** tables-custom cards "Custom table with pagination", "Custom table with pagination info".

**Markup.**

```html
<div data-table data-table-rows-per-page="5" class="card">
  <div class="card-header">
    <h4 class="card-title">Custom table with pagination info</h4>
  </div>
  <!-- toolbar: search + bulk delete on the left, page size on the right -->
  <div class="border-default-300 flex flex-wrap justify-between gap-2.5 border-b border-dashed px-5 py-4">
    <div class="flex gap-2">
      <div class="input-icon-group">
        <i class="iconify tabler--search input-icon"></i>
        <input data-table-search type="search" placeholder="Search product name..." class="form-input" />
      </div>
      <button data-table-delete-selected class="hidden btn bg-danger text-white hover:bg-danger-hover">Delete</button>
    </div>
    <div>
      <select data-table-set-rows-per-page class="form-select">
        <option value="5" selected>5</option><option value="10">10</option><option value="15">15</option><option value="20">20</option>
      </select>
    </div>
  </div>
  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="font-semibold">
        <tr class="bg-light/15 text-2xs uppercase"> … same header as above … </tr>
      </thead>
      <tbody> <!-- all rows, server-rendered; the engine shows 5 at a time --> </tbody>
    </table>
  </div>
  <div class="card-footer">
    <div data-table-pagination-info="products"></div>   <!-- "Showing 1 to 5 of 10 products" -->
    <div data-table-pagination></div>                    <!-- ul.pagination injected here -->
  </div>
</div>
```

The pagination-only card uses `<div class="card-footer flex justify-end"><div data-table-pagination></div></div>`.
`.card-footer` lays the two divs out side by side in the demo (info left, pager right).

**Init / JS.** None. What the engine renders into `[data-table-pagination]`:

```html
<ul class="pagination justify-center">
  <li class="page-item disabled"><a href="#" class="page-link"><!-- chevron-left svg --></a></li>
  <li class="page-item active"><a href="#" class="page-link">1</a></li>
  <li class="page-item"><a href="#" class="page-link">2</a></li>
  <li class="page-item"><a href="#" class="page-link"><!-- chevron-right svg --></a></li>
</ul>
```

**Gotchas.**
- Every page is rendered as a button (no ellipsis/windowing); with 100 pages you get 100 `li`s — keep page size
  reasonable or switch to DataTables.
- `data-table-rows-per-page` must be one of the select's options or the engine inserts it (sorted) for you.
- Pager + info are hidden entirely when the filtered set is empty (the "Nothing found." row shows instead).

## Custom table: dropdown filters and range filters

**What it is.** Exact-match `<select data-table-filter>` controls and bracket/preset `<select
data-table-range-filter>` controls, each bound to a column via `th[data-column]`.

**Use it when.** Orders list filtered by payment status + order status + date preset (apps-ecommerce-orders);
products by category + status + price bracket (apps-ecommerce-products); stock by warehouse location/status;
projects by status + date; roles by type.

**Source.** tables-custom cards "Custom table with filters", "Custom table with range filters".

**Markup.**

```html
<div data-table data-table-rows-per-page="5" class="card">
  <div class="card-header"><h4 class="card-title">Custom table with filters</h4></div>
  <div class="border-default-300 flex flex-wrap justify-between gap-2.5 border-b border-dashed px-5 py-4">
    <div class="flex gap-2">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search product name..." class="form-input" /></div>
      <button data-table-delete-selected class="hidden btn bg-danger text-white hover:bg-danger-hover">Delete</button>
    </div>
    <div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap">
      <span class="me-2.5 font-semibold text-nowrap">Filter By:</span>
      <!-- exact-match filter: option values must equal the cell text under th[data-column="category"] -->
      <div class="input-icon-group">
        <i class="iconify tabler--tag input-icon"></i>
        <select data-table-filter="category" class="form-select">
          <option value="">Category</option>
          <option value="Electronics">Electronics</option><option value="Fashion">Fashion</option>
          <option value="Home">Home</option><option value="Sports">Sports</option><option value="Beauty">Beauty</option>
        </select>
      </div>
      <div class="input-icon-group">
        <i class="iconify tabler--box input-icon"></i>
        <select data-table-filter="status" class="form-select">
          <option value="">Status</option>
          <option value="Published">Published</option><option value="Pending">Pending</option><option value="Out of Stock">Out of Stock</option>
        </select>
      </div>
      <!-- numeric range filter: "lo-hi" inclusive or "lo+" -->
      <div class="input-icon-group">
        <i class="iconify tabler--currency-dollar input-icon"></i>
        <select data-table-range-filter="price" class="form-select">
          <option value="">Price Range</option>
          <option value="0-50">$0 - $50</option><option value="51-150">$51 - $150</option>
          <option value="151-500">$151 - $500</option><option value="500+">$500+</option>
        </select>
      </div>
      <!-- date range filter: key contains "date" → preset names are the values -->
      <div class="input-icon-group">
        <i class="iconify tabler--calendar input-icon"></i>
        <select data-table-range-filter="date" class="form-select">
          <option value="All">Date Range</option>
          <option value="Today">Today</option><option value="Last 7 Days">Last 7 Days</option>
          <option value="Last 30 Days">Last 30 Days</option><option value="This Year">This Year</option>
        </select>
      </div>
      <div>
        <select data-table-set-rows-per-page class="form-select">
          <option value="5" selected>5</option><option value="10">10</option><option value="15">15</option><option value="20">20</option>
        </select>
      </div>
    </div>
  </div>
  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="font-semibold">
        <tr class="bg-light/15 text-2xs uppercase">
          <th class="py-2 ps-4.5 pe-2 text-start"><input data-table-select-all class="form-checkbox bg-light size-4.25" type="checkbox" /></th>
          <th class="p-2 text-start">Product</th>
          <th class="p-2 text-start">SKU</th>
          <th data-column="category" class="p-2 text-start">Category</th>
          <th class="p-2 text-start">Stock</th>
          <th data-column="price" class="p-2 text-start">Price</th>
          <th class="p-2 text-start">Orders</th>
          <th class="p-2 text-start">Rating</th>
          <th data-column="status" class="p-2 text-start">Status</th>
          <th data-column="date" class="p-2 text-start">Published</th>
          <th class="p-2 text-center">Actions</th>
        </tr>
      </thead>
      <tbody> … rows as in the search/delete example … </tbody>
    </table>
  </div>
  <div class="card-footer">
    <div data-table-pagination-info="products"></div>
    <div data-table-pagination></div>
  </div>
</div>
```

Column keys seen in the apps pages: `status`, `price`, `category`, `date`, `order-status`, `payment-status`,
`refund-status`, `warehouse-location`, `warehouse-status`, `type`, `roles`, `region`, `country`, `orders`,
`revenue`, `performance`, `attri-type`. Only the `date` key triggers date-preset mode (substring "date",
case-insensitive).

**Init / JS.** None.

**Gotchas.**
- Exact-match compares the *whole* cell text (`textContent.trim()`), so a status cell must contain only the badge
  text — an icon with text is fine, extra words are not.
- Numeric range strips everything but digits, `.` and `-`: `$1,399.00` → `1399.00`, `48,374,838` → `48374838`,
  `+0.82%` → `0.82`. A cell with two numbers (`24 / 100`) becomes `24/100` → `parseFloat` → 24.
- The demo's `<option value=" All">` with a leading space is a bug (see engine gotchas); use `value=""`.
- The engine listens to `change`; Choices.js-enhanced selects still fire native `change`, so `data-provider`
  selects work, but keep `data-table-filter` on the real `<select>`.

## Custom table: sorting (simple and complex cells)

**What it is.** Click-to-sort headers. `data-table-sort` (no value) sorts on the cell's own text; `data-table-
sort="key"` sorts on the text of a `[data-sort="key"]` element inside the cell.

**Use it when.** Any list where users sort by price, stock, date, name, rating, orders. Use the keyed form for
the "Product"/"Customer"/"User" column that renders avatar + link + subtitle, and for the rating column whose
visible text is five star icons plus a `(87)` count.

**Source.** tables-custom cards "Custom table with sort", "Custom table with sort (for complex cell)".

**Markup.**

```html
<thead class="font-semibold">
  <tr class="bg-light/15 text-2xs uppercase">
    <th class="py-2 ps-4.5 pe-2 text-start"><input data-table-select-all class="form-checkbox bg-light size-4.25" type="checkbox" /></th>
    <th data-table-sort="product" class="p-2 text-start">Product</th>      <!-- keyed: reads [data-sort="product"] -->
    <th class="p-2 text-start">SKU</th>
    <th data-table-sort data-column="category" class="p-2 text-start">Category</th>   <!-- sort + filter on same column -->
    <th data-table-sort class="p-2 text-start">Stock</th>                 <!-- "56" → number -->
    <th data-table-sort data-column="price" class="p-2 text-start">Price</th>         <!-- "$1,399.00" → 1399 -->
    <th data-table-sort class="p-2 text-start">Orders</th>
    <th data-table-sort="rating" class="p-2 text-start">Rating</th>        <!-- keyed: reads "(87)" → -87 -->
    <th data-table-sort data-column="status" class="p-2 text-start">Status</th>
    <th data-table-sort class="p-2 text-start">Published</th>             <!-- "18 Apr, 2025 12:24 PM" → Date -->
    <th class="text-center pe-4.5 py-2 ps-2" style="width: 1%">Actions</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td><input class="form-checkbox bg-light size-4.25" type="checkbox" /></td>
    <td>
      <div class="flex">
        <div><div class="me-base size-5 lg:size-9"><img src="assets/images/products/1.png" alt="Product" class="size-5 rounded lg:size-9" /></div></div>
        <div>
          <h5 class="text-default-800 hover:text-primary mb-1.25"><a data-sort="product" href="ecommerce-product-details.html">Wireless Earbuds</a></h5>
          <p class="text-default-400 text-2xs">by: My Furniture</p>
        </div>
      </div>
    </td>
    …
    <td>
      <span class="text-warning"><i class="iconify tabler--star-filled"></i>…</span>
      <span class="ms-1.25"><a data-sort="rating" href="ecommerce-reviews.html" class="hover:text-primary font-semibold">(87)</a></span>
    </td>
    …
  </tr>
</tbody>
```

Keys used in the apps pages: `product`, `name`, `customer`, `user`, `owner`, `project`, `task`, `reviewer`,
`seller`, `rating`.

**Init / JS.** None. The engine injects a 13px up-down arrows SVG (`<span class="inline-flex align-middle
h-3.75">…</span>`) after the header text and swaps it for arrow-up / arrow-down on each click.

**Gotchas.**
- Without a key, the sort value is the first non-empty *direct text node* of the `td`; a cell whose text is
  entirely inside child elements (e.g. `<td><h5>56</h5></td>`) falls back to the whole cell text — fine for one
  value, wrong for avatar + name + subtitle. Use the keyed form there.
- If the `th` already contains an `<i>` (your own icon) the engine reuses it as the arrow slot and overwrites its
  innerHTML.
- Sorting is applied to `filteredRows` only; a later search/filter change rebuilds the list in original DOM order.
- A `th` with `data-table-sort` *and* `data-column` is normal (sort + filter on one column).

## Complete custom table (copy-ready list page)

**What it is.** The last card on tables-custom: every feature combined in the exact layout the `apps-*` list
pages use (toolbar row with dashed bottom border, table, footer with info + pager).

**Use it when.** Starting any new list page: products, orders, customers, invoices, tickets, users, roles.
Copy this, rename the columns/keys, drop the controls you do not need.

**Source.** tables-custom card "Complete Custom Table" (typos corrected: `data-table-filter="statu"` →
`"status"`, `value=" All"`/`" Published"` → `""`/`"Published"`, duplicated `data-table-select-all` removed).

**Markup.**

```html
<div data-table data-table-rows-per-page="5" class="card">
  <div class="card-header">
    <h4 class="card-title">Products</h4>
  </div>

  <div class="border-default-300 flex flex-wrap justify-between gap-2.5 border-b border-dashed px-5 py-4">
    <div class="flex gap-2">
      <div class="input-icon-group">
        <i class="iconify tabler--search input-icon"></i>
        <input data-table-search type="search" placeholder="Search product name..." class="form-input" />
      </div>
      <button data-table-delete-selected class="hidden btn bg-danger text-white hover:bg-danger-hover">Delete</button>
    </div>
    <div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap">
      <span class="me-2.5 font-semibold text-nowrap">Filter By:</span>
      <div class="input-icon-group">
        <i class="iconify tabler--tag input-icon"></i>
        <select data-table-filter="category" class="form-select">
          <option value="">Category</option>
          <option value="Electronics">Electronics</option><option value="Fashion">Fashion</option><option value="Home">Home</option>
        </select>
      </div>
      <div class="input-icon-group">
        <i class="iconify tabler--box input-icon"></i>
        <select data-table-filter="status" class="form-select">
          <option value="">Status</option>
          <option value="Published">Published</option><option value="Pending">Pending</option><option value="Out of Stock">Out of Stock</option>
        </select>
      </div>
      <div class="input-icon-group">
        <i class="iconify tabler--currency-dollar input-icon"></i>
        <select data-table-range-filter="price" class="form-select">
          <option value="">Price Range</option>
          <option value="0-50">$0 - $50</option><option value="51-150">$51 - $150</option><option value="151-500">$151 - $500</option><option value="500+">$500+</option>
        </select>
      </div>
      <div>
        <select data-table-set-rows-per-page class="form-select">
          <option value="5" selected>5</option><option value="10">10</option><option value="15">15</option><option value="20">20</option>
        </select>
      </div>
    </div>
  </div>

  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="font-semibold">
        <tr class="uppercase bg-light/15 text-2xs">
          <th class="ps-4.5 pe-2 py-2 text-start" style="width: 1%"><input data-table-select-all class="form-checkbox bg-light size-4.25" type="checkbox" /></th>
          <th data-table-sort="product" class="p-2 text-start">Product</th>
          <th class="p-2 text-start">SKU</th>
          <th data-table-sort data-column="category" class="p-2 text-start">Category</th>
          <th data-table-sort class="p-2 text-start">Stock</th>
          <th data-table-sort data-column="price" class="p-2 text-start">Price</th>
          <th data-table-sort class="p-2 text-start">Orders</th>
          <th data-table-sort="rating" class="p-2 text-start">Rating</th>
          <th data-table-sort data-column="status" class="p-2 text-start">Status</th>
          <th data-table-sort class="p-2 text-start">Published</th>
          <th class="text-center pe-4.5 py-2 ps-2" style="width: 1%">Actions</th>
        </tr>
      </thead>
      <tbody>
        <!-- repeat per row (server-rendered; render ALL rows, the engine pages them) -->
        <tr>
          <td><input class="form-checkbox bg-light size-4.25" type="checkbox" /></td>
          <td>
            <div class="flex">
              <div><div class="me-base size-5 lg:size-9"><img src="assets/images/products/1.png" alt="Product" class="size-5 rounded lg:size-9" /></div></div>
              <div>
                <h5 class="text-default-800 hover:text-primary mb-1.25"><a data-sort="product" href="ecommerce-product-details.html">Wireless Earbuds</a></h5>
                <p class="text-default-400 text-2xs">by: My Furniture</p>
              </div>
            </div>
          </td>
          <td>WB-10245</td>
          <td>Electronics</td>
          <td><h5>56</h5></td>
          <td>$59.99</td>
          <td>124</td>
          <td>
            <span class="text-warning"><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star-filled"></i><i class="iconify tabler--star"></i></span>
            <span class="ms-1.25"><a data-sort="rating" href="ecommerce-reviews.html" class="hover:text-primary font-semibold">(87)</a></span>
          </td>
          <td><span class="badge text-2xs bg-success/15 text-success">Published</span></td>
          <td>18 Apr, 2025 <small class="text-default-400">12:24 PM</small></td>
          <td>
            <div class="flex justify-center gap-1.25">
              <a href="#" class="btn btn-icon btn-sm rounded-full size-7.5 bg-light text-dark hover:text-primary"><i class="iconify tabler--eye text-base"></i></a>
              <a href="#" class="btn btn-icon btn-sm rounded-full size-7.5 bg-light text-dark hover:text-primary"><i class="iconify tabler--edit text-base"></i></a>
              <button type="button" class="btn btn-icon btn-sm rounded-full size-7.5 bg-danger text-white hover:bg-danger-hover" data-table-delete-row><i class="iconify tabler--trash text-base"></i></button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="card-footer">
    <div data-table-pagination-info="products"></div>
    <div data-table-pagination></div>
  </div>
</div>

<!-- before </body>, after app.js -->
<script src="assets/js/pages/custom-table.js"></script>
```

**Init / JS.** None beyond including the script. Several `[data-table]` cards on one page are fine — each gets
its own `Table` instance (apps-ecommerce-product-details has two).

**Gotchas.** See the engine section. Also: the "Published" column is sortable as a date but is not given
`data-column="date"` here; add it if you also want the date range filter.

## Choosing custom-table.js vs DataTables

| Criterion | custom-table.js | DataTables |
|---|---|---|
| Data origin | Server-rendered `<tbody>` only | HTML, JS array, or `ajax` JSON (with `processing` indicator); server-side processing possible |
| Row count | Comfortable up to a few hundred (every page button is rendered, all rows stay in memory) | Thousands+; windowed pager; `scrollY`/`scroller` |
| Dependencies | None (Preline `HSOverlay` for the confirm modal) | jQuery + `dataTables.min.js` (+ responsive/buttons/select/fixedColumns/fixedHeader as needed) |
| Rich cells | Free — you write the HTML | Via `columns[].render` |
| Search / sort / filter | Substring search; typed sort; exact + range filters; search and filters do not combine | Global + per-column search, `search.fixed` custom filters, multi-column ordering, all combinable |
| Selection / delete | Check-all + bulk delete + row delete with confirm modal built in | Select extension (row/cell/checkbox); deletion you implement with `row().remove().draw()` |
| Export / print | No | Buttons extension (copy/csv/excel/pdf/print) |
| Fixed header / columns, child rows, column visibility, add rows at runtime | No | Yes (dedicated pages below) |
| Styling | Template classes as-is | Template ships full `dt-*` skinning in app.min.css (`.dt-container`, `.dt-input`, `.dt-paging-button`, `.dt-column-order` Tabler arrows, `tr.selected` → `warning/10`) |
| Typical pages | apps-* list pages, dashboard widget tables | reports, admin data browsers, anything remote or exportable |

Rule of thumb: start with custom-table.js for a CRUD list page; move to DataTables the moment you need ajax,
export, more than ~500 rows, or any feature in the DataTables sections below. Do not run both on one table.

## DataTables: loading and the shared init pattern

**What it is.** jQuery DataTables 2.x (`new DataTable(el, opts)`, `DataTable.render.*`, `search.fixed`, `dt-*`
classes) initialised from small page scripts. Preline's `hs-datatable` wrapper is bundled but **none of the 233
demo pages use it** (grep for `hs-datatable`/`data-hs-datatable` finds nothing); the template drives DataTables
directly, and all skinning for `.dt-container`, `.dt-layout-row`, `.dt-input`, `.dt-paging-button`,
`.dt-column-order`, `.dt-button-collection`, `.dt-processing`, `.dt-select-checkbox`, `.dtfc-fixed-*`,
`.fixedHeader-floating` is already compiled into `app.min.css` — no extra DataTables CSS link.

**Use it when.** See the decision table above.

**Source.** every `tables-datatables-*.html` + `assets/js/pages/datatables-*.js`. Script order before `</body>`
(from the pages):

```html
<script src="assets/js/vendors.min.js"></script>
<script src="assets/js/app.js"></script>
<script src="assets/plugins/jquery/jquery.min.js"></script>                       <!-- the pages load jQuery explicitly here -->
<script src="assets/plugins/datatables-dt/dataTables.min.js"></script>
<script src="assets/plugins/datatables-dt/dataTables.responsive.min.js"></script> <!-- on every DT page -->
<!-- extensions only where needed: dataTables.select.min.js | dataTables.fixedColumns.min.js | dataTables.fixedHeader.min.js |
     dataTables.buttons.min.js + jszip.min.js + pdfmake.min.js + vfs_fonts.js + buttons.html5.min.js + buttons.print.min.js -->
<script src="assets/js/pages/datatables-basic.js"></script>
```

The `assets/plugins/` folder is not vendored in `references/sources` (only `css/` and `js/`), so take the file
names from the manifest and ship DataTables 2.x yourself. Every DT page shows a dismissible note card:
`<strong>Note:</strong> This is a jQuery-based plugin, so you need to include jQuery for it to work.` —
`datatables-basic.js` even starts with `window.jQuery = window.$ = $;`.

**Markup (shared table skeleton).**

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Basic DataTable</h4>
    <a href="https://datatables.net/examples/basic_init/zero_configuration.html" target="_blank" class="group text-primary font-semibold hover:text-primary-hover">
      View Docs <i class="iconify tabler--arrow-right group-hover:translate-x-1 transform-3d transition-transform duration-300 align-middle text-base"></i>
    </a>
  </div>
  <div class="card-body">
    <div class="table-wrapper -mb-4">                                  <!-- -mb-4 absorbs DataTables' bottom row margin -->
      <table id="my-table" class="table table-striped">                 <!-- or data-tables="basic" / dt-responsive … -->
        <thead class="thead-sm uppercase text-2xs">                     <!-- or: text-2xs font-semibold uppercase -->
          <tr><th scope="col">Company</th><th scope="col">Symbol</th><th scope="col">Price</th><th scope="col">Change</th><th scope="col">Volume</th><th scope="col">Market Cap</th><th scope="col">Rating</th><th scope="col">Status</th></tr>
        </thead>
        <tbody>
          <!-- repeat per row -->
          <tr><td>Apple Inc.</td><td>AAPL</td><td>$2109.53</td><td>-0.42%</td><td>48,374,838</td><td>$53.59B</td><td>4.7 ★</td><td><span class="badge bg-danger/15 text-danger">Bearish</span></td></tr>
          <tr><td>Alphabet Inc.</td><td>GOOGL</td><td>$2803.77</td><td>+0.68%</td><td>22,545,332</td><td>$1.88T</td><td>4.6 ★</td><td><span class="badge bg-success/15 text-success">Bullish</span></td></tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
```

Table class combinations seen: `table table-striped` (most), `table table-bordered` (complex header),
`dt-responsive table align-middle` (select), `table-striped dt-responsive table align-middle` (ajax, JS source),
`table table-striped stripe align-middle nowrap` (fixed columns — `stripe`/`nowrap` are DataTables' own helper
classes), `table` alone (column searching). `dt-responsive` has no CSS rule; it is the marker class the
Responsive extension auto-initialises on.

**Init / JS (the part every page script repeats).** All 15 scripts replace the pager text with Tabler chevron
SVGs through `language.paginate`; most also set `lengthMenu`/`info`. Define it once:

```js
// assets/js/pages/datatables-*.js — identical block in every script
const dtLang = {
  paginate: {
    first:    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M11 7l-5 5l5 5" /><path d="M17 7l-5 5l5 5" /></svg>',   // tabler chevrons-left
    previous: '<svg … same attrs …><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M15 6l-6 6l6 6" /></svg>',                        // tabler chevron-left
    next:     '<svg … same attrs …><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M9 6l6 6l-6 6" /></svg>',                         // tabler chevron-right
    last:     '<svg … same attrs …><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M7 7l5 5l-5 5" /><path d="M13 7l5 5l-5 5" /></svg>' // tabler chevrons-right
  },
  // used by select / ajax / js-source / scroll pages:
  lengthMenu: "_MENU_ Companies per page",
  info: 'Showing <span class="font-semibold">_START_</span> to <span class="font-semibold">_END_</span> of <span class="font-semibold">_TOTAL_</span> Companies'
};

document.addEventListener("DOMContentLoaded", () => {
  const el = document.getElementById("my-table");
  el && new DataTable(el, { language: dtLang /* + feature options from the sections below */ });
});
```

Several pages use the legacy `dom:` layout string with Tailwind classes as the wrapper classes, e.g.
`"<'md:flex justify-between items-center mb-3'Bf>rt<'md:flex justify-between items-center mt-4'ip>"`
(`B` buttons, `f` filter box, `r` processing, `t` table, `i` info, `p` pager, `l` length). It still works in
DataTables 2 but `layout:{}` is the modern equivalent; keep `dom` if you copy the demo verbatim.

**Gotchas.**
- `.dt-control:before { display:none !important }` in app.min.css hides DataTables' default child-row "+" icon;
  provide your own via `defaultContent` (child-rows page).
- `.column-search-input-bar .dt-column-order { display:none }` is the only page-specific CSS hook; the rest
  is generic.
- In RTL only the custom-table `.pagination svg` chevrons are mirrored by CSS (`html[dir=rtl]`); there is no such
  rule for `.dt-paging-button`, so supply mirrored `language.paginate` SVGs yourself on RTL builds.
- Dark mode: `.dt-input`, `.dt-button-collection`, `.dt-paging-button` use `--color-card` / `--color-default-300`
  tokens, so they flip; `tr.selected` uses `warning/10`.
- `.table-wrapper -mb-4` on DT pages pulls the info/pager row up to the card edge; without it you get an extra
  gap under the pager.

## DataTables basic + complex header (tables-datatables-basic)

**What it is.** Zero-configuration DataTable (sort, global search, length menu, pager) on a server-rendered
table, plus a second table with a two-row grouped header (`colspan`).

**Use it when.** A reporting grid with grouped column headers (Company Info | Rate | More | Other); any quick
sortable/searchable table with ~50-5000 rows and no custom controls.

**Source.** `tables-datatables-basic.html` + `datatables-basic.js`.

**Markup.** The shared skeleton with `data-tables="basic"` on *both* tables; complex header:

```html
<table data-tables="basic" class="table table-bordered">
  <thead class="thead-sm text-2xs uppercase">
    <tr><th colspan="2">Company Info</th><th colspan="2">Rate</th><th colspan="2">More</th><th colspan="2">Other</th></tr>
    <tr><th scope="col">Company</th><th scope="col">Symbol</th><th scope="col">Price</th><th scope="col">Change</th><th scope="col">Volume</th><th scope="col">Market Cap</th><th scope="col">Rating</th><th scope="col">Status</th></tr>
  </thead>
  <tbody>…</tbody>
</table>
```

**Init / JS.**

```js
window.jQuery = window.$ = $;
document.addEventListener("DOMContentLoaded", () => {
  new DataTable('[data-tables="basic"]', { language: dtLang });   // one call initialises every matching table
});
```

**Gotchas.** A selector string initialises all matches at once; use ids when the tables need different options.
The grouped header row is not sortable (DataTables binds ordering to the last header row).

## DataTables export: Buttons with jszip + pdfmake (tables-datatables-export-data)

**What it is.** Buttons extension: a row of Copy/CSV/Excel/Print/PDF buttons, or a single "Export" dropdown
(`collection`) styled as a Preline-looking dropdown.

**Use it when.** Finance/sales reports, audit logs, any grid where the user needs the data in Excel or a
printable PDF; a compact "Export" menu in a crowded toolbar.

**Source.** `tables-datatables-export-data.html` + `datatables-export-data.js`; scripts
`dataTables.buttons.min.js`, `jszip.min.js` (Excel), `pdfmake.min.js` + `vfs_fonts.js` (PDF),
`buttons.html5.min.js` (copy/csv/excel/pdf), `buttons.print.min.js`.

**Markup.** Shared skeleton with `data-tables="export-data"` and `data-tables="export-data-dropdown"`; the
buttons are rendered by DataTables into the `B` slot of `dom`.

**Init / JS.**

```js
// Button row
new DataTable('[data-tables="export-data"]', {
  dom: "<'md:flex justify-between items-center mb-3'Bf>rt<'md:flex justify-between items-center mt-4'ip>",
  responsive: true,
  buttons: [
    { extend: "copy",  className: "btn btn-sm bg-secondary text-white hover:bg-secondary-hover" },
    { extend: "csv",   className: "btn btn-sm bg-secondary text-white active" },
    { extend: "excel", className: "btn btn-sm bg-secondary text-white hover:bg-secondary-hover" },
    { extend: "print", className: "btn btn-sm bg-secondary text-white active" },
    { extend: "pdf",   className: "btn btn-sm bg-secondary text-white hover:bg-secondary-hover" }
  ],
  language: dtLang
});

// Single "Export" dropdown
new DataTable('[data-tables="export-data-dropdown"]', {
  dom: "<'md:flex justify-between items-center mb-3'<'hs-dropdown relative'B>f>rt<'md:flex justify-between align-center mt-4'ip>",
  responsive: true,
  buttons: [{
    extend: "collection",
    text: '<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="me-1 align-baseline"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2 -2v-2" /><path d="M7 11l5 5l5 -5" /><path d="M12 4l0 12" /></svg> Export',   // tabler download
    className: "btn btn-sm bg-secondary text-white *:flex hs-dropdown-toggle",
    autoClose: true,
    buttons: [
      { extend: "copy", text: "Copy" }, { extend: "csv", text: "CSV" }, { extend: "excel", text: "Excel" },
      { extend: "print", text: "Print" }, { extend: "pdf", text: "PDF" }
    ]
  }],
  language: dtLang
});
```

**Gotchas.**
- `div.dt-button-collection` is skinned in app.min.css (`bg-card`, `border-default-300`, rounded, `w-28`,
  shadow, flex-col) so the collection looks like a `.hs-dropdown-menu` without Preline being involved; the
  `hs-dropdown`/`hs-dropdown-toggle` classes in the demo are cosmetic — DataTables handles open/close.
- Excel needs jszip, PDF needs pdfmake + vfs_fonts, loaded *before* `buttons.html5.min.js`.
- `extend:"csv"`/`"print"` carry `active` in the demo only to show the pressed style; remove it.
- Rendered HTML in cells (badges) is exported as its text; use `exportOptions:{orthogonal:'export'}` with a
  render function if you need clean values.

## DataTables select: single, multi and cell selection (tables-datatables-select)

**What it is.** The Select extension with three styles on three tables: `single` (one row), `multi` (toggle
rows), `os` with `items:"cell"` (click/shift/ctrl like a desktop file manager, on cells).

**Use it when.** Pick one row to load into a detail panel; multi-select rows for a bulk action toolbar;
spreadsheet-like cell picking for a comparison or copy feature.

**Source.** `tables-datatables-select.html` + `datatables-select.js` + `dataTables.select.min.js`.

**Markup.** `<table id="single-select" class="dt-responsive table align-middle">` (and `#multi-select`,
`#cell-select`) with `<thead class="thead-sm text-2xs uppercase">`; status cells use `badge badge-label …`.

**Init / JS.**

```js
function initSelectableDataTable(selector, select = {}) {
  const el = document.querySelector(selector);
  el && new DataTable(el, {
    pageLength: 7,
    lengthMenu: [7, 10, 25, 50, -1],
    select,
    language: dtLang   // includes lengthMenu "_MENU_ Companies per page" and the "Showing … Companies" info
  });
}
document.addEventListener("DOMContentLoaded", function () {
  initSelectableDataTable("#single-select", { style: "single" });
  initSelectableDataTable("#multi-select",  { style: "multi" });
  initSelectableDataTable("#cell-select",   { style: "os", items: "cell" });
});
```

**Gotchas.**
- Selected rows/cells get `tr.selected` / `td.selected` → `bg-warning/10` (template override of DataTables'
  blue). The `select-info` / `select-item` counters render in `.dt-info`.
- Read selections with `table.rows({ selected: true }).data()`; the demo does nothing with them.
- `-1` in `lengthMenu` is "All".

## DataTables ajax source (tables-datatables-ajax)

**What it is.** Table whose `<tbody>` is absent in HTML; rows come from a JSON file/endpoint with a
"Processing…" overlay, and one column rendered as a badge.

**Use it when.** Any list that comes from an API: stock tickers, server logs, order history for a customer;
when the HTML page must stay small.

**Source.** `tables-datatables-ajax.html` + `datatables-ajax.js`. The demo file `assets/data/datatables.json`
is not vendored; from the `columns` config its shape is
`{ "data": [ { "company", "symbol", "price", "change", "volume", "market_cap", "rating", "status" }, … ] }`
(DataTables' default `dataSrc` is `data`).

**Markup.**

```html
<div class="table-wrapper -mb-4">
  <table id="datatables-ajax" class="table-striped dt-responsive table align-middle">
    <thead class="thead-sm text-2xs uppercase">
      <tr><th>Company</th><th>Symbol</th><th>Price</th><th>Change</th><th>Volume</th><th>Market Cap</th><th>Rating</th><th>Status</th></tr>
    </thead>
    <!-- no tbody -->
  </table>
</div>
```

**Init / JS.**

```js
new DataTable(document.getElementById("datatables-ajax"), {
  ajax: "assets/data/datatables.json",
  processing: true,
  columns: [
    { data: "company" }, { data: "symbol" }, { data: "price" }, { data: "change" },
    { data: "volume" }, { data: "market_cap" }, { data: "rating" },
    { data: "status", render: (d) =>
        `<span class="badge rounded-none ${d === "Bullish" ? "bg-success/15 text-success" : "bg-danger/15 text-danger"}">${d}</span>` }
  ],
  language: dtLang
});
```

**Gotchas.** `.dt-processing` is skinned (bordered box, primary dots). For `serverSide:true` add
`ajax:{url, type:"POST"}` and return `draw/recordsTotal/recordsFiltered` — not shown in the demo.

## DataTables JavaScript array source (tables-datatables-javascript)

**What it is.** Same as ajax but the rows are an in-page array of arrays; column headers come from
`columns[].title`.

**Use it when.** Data already embedded by the server as JSON in the page; demos/prototypes; tables rebuilt from
a client-side store.

**Source.** `tables-datatables-javascript.html` + `datatables-javascript-source.js`.

**Markup.** Identical to the ajax page (`id="datatables-javascript-source"`, thead only, no tbody).

**Init / JS.**

```js
let dataSet = [
  ["Apple Inc.", "AAPL", "174.55", "+0.82%", "75214350", "2.80T", "Buy", "Bullish"],
  ["Tesla Inc.", "TSLA", "680.75", "-2.10%", "28954320", "800B", "Sell", "Bearish"]
  // …
];
new DataTable(document.getElementById("datatables-javascript-source"), {
  columns: [
    { title: "company" }, { title: "symbol" }, { title: "price" }, { title: "change" },
    { title: "volume" }, { title: "market_cap" }, { title: "rating" },
    { title: "status", render: (d) =>
        `<span class="badge rounded-none ${d === "Bullish" ? "bg-success/15 text-success" : "bg-danger/15 text-danger"}">${d}</span>` }
  ],
  data: dataSet,
  language: dtLang
});
```

**Gotchas.** The demo's first `dataSet` entry is a header row (`["Company","Symbol",…]`) that renders as data —
do not copy that. `columns[].title` overwrites the `<th>` text (the demo shows lower-case keys, upper-cased by
the `uppercase` thead class).

## DataTables data rendering (tables-datatables-rendering)

**What it is.** `columns[].render(data, type)` examples: a link whose target depends on the value, an office
column with a flag image, a progress bar from a number, and a currency column coloured by threshold.

**Use it when.** Any grid where raw values need formatting: money, percentages, status pills, avatars, progress,
links to detail pages.

**Source.** `tables-datatables-rendering.html` + `datatables-rendering.js`; data `assets/data/datatables-
rendering.json` (not vendored) shaped `{ "data": [ { "name", "position", "office", "extn", "start_date", "salary" } ] }`.

**Markup.** `<table id="datatable-rendering" class="table table-striped"><thead class="text-2xs font-semibold
uppercase"><tr><th>Name</th><th>Position</th><th>Office</th><th>Progress</th><th>Start date</th><th>Salary</th></tr></thead></table>`.

**Init / JS.**

```js
const flags = { Argentina: "ar", Gujarat: "in", Germany: "de", London: "gb", "New York": "us", "San Francisco": "us", Sydney: "au", Tokyo: "jp" };

new DataTable(document.getElementById("datatable-rendering"), {
  language: dtLang,
  ajax: "assets/data/datatables-rendering.json",
  columns: [
    { data: "name" },
    { data: "position", render: (d, type) => {
        if (type !== "display") return d;                       // sort/filter on the raw value
        let url = "https://datatables.net";
        if (d[0] < "H") url = "https://cloudtables.com"; else if (d[0] < "S") url = "https://editor.datatables.net";
        return `<a href="${url}">${d}</a>`;
      } },
    { data: "office", className: "flex items-center", render: (d, type) => type === "display"
        ? `<span class="flag ${flags[d] || ""}"><img class="size-6 rounded me-3" src="assets/images/flags/${flags[d] || ""}.svg" alt="${d}" /></span> ${d}`
        : d },
    { data: "extn", render: (d, type) => type === "display"
        ? `<div class="flex w-full bg-default-100 h-2 rounded overflow-hidden" role="progressbar" aria-label="Basic example" aria-valuenow="${d}" aria-valuemin="0" aria-valuemax="9999" style="height:8px">
             <div class="flex flex-col justify-center overflow-hidden bg-primary text-center whitespace-nowrap transition duration-500" style="width: ${d / 9999 * 100}%"></div>
           </div>`
        : d },
    { data: "start_date" },
    { data: "salary", render: (d, type) => {
        const num = DataTable.render.number(",", ".", 2, "$").display(d);   // "$1,234.00"
        if (type !== "display") return num;
        const colour = d < 250000 ? "red" : d < 500000 ? "orange" : "green";
        return `<span style="color:${colour}">${num}</span>`;
      } }
  ]
});
```

**Gotchas.**
- Always branch on `type === "display"` so sorting/searching use raw values.
- `className: "flex items-center"` on the office column makes the `<td>` a flex container (works, but the cell
  loses table-cell semantics; use an inner `<div class="flex items-center">` in your own code).
- `.flag` has no CSS rule in app.min.css; it is a plain hook class.

## DataTables scroll: vertical and horizontal (tables-datatables-scroll)

**What it is.** A fixed-height scrolling body (`scrollY`, paging off) and a horizontally scrolling wide table
(`scrollX`).

**Use it when.** A log/ticker panel of fixed height inside a dashboard card; a wide report that must not wrap
on tablets.

**Source.** `tables-datatables-scroll.html` + `datatables-scroll.js`.

**Markup.** `<table id="vertical-scroll" class="table table-striped w-full align-middle">` and
`<table id="horizontal-scroll" class="table-striped table align-middle">`, both with the standard thead/tbody.

**Init / JS.**

```js
new DataTable(document.getElementById("vertical-scroll"), {
  paging: false,
  scrollCollapse: true,     // shrink the box when fewer rows than scrollY
  scrollY: "250px"
});
new DataTable("#horizontal-scroll", {
  scrollX: true,
  language: dtLang
});
```

**Gotchas.** With `scrollX`/`scrollY` DataTables clones the header into `.dt-scroll-head`; column widths are
measured on init, so initialise after the card is visible (not inside a hidden tab) or call
`table.columns.adjust()` when the tab opens. The vertical demo keeps the default pager text because paging is off.

## DataTables fixed columns (tables-datatables-fixed-columns)

**What it is.** FixedColumns extension pinning the first and last column of a 17-column, horizontally
scrolling table.

**Use it when.** Wide financial/inventory sheets where the identifier (company, SKU) and the action/owner
column must stay visible while scrolling sideways.

**Source.** `tables-datatables-fixed-columns.html` + `datatables-fixed-columns.js` + `dataTables.fixedColumns.min.js`.

**Markup.**

```html
<table id="fixed-columns" class="table table-striped stripe align-middle nowrap">
  <thead class="text-2xs font-semibold uppercase">
    <tr><th>Company</th><th>Symbol</th><th>Price</th><th>Change</th><th>Volume</th><th>Market Cap</th><th>Rating</th><th>Status</th><th>Sector</th><th>Industry</th><th>Employees</th><th>Founded</th><th>P/E Ratio</th><th>Dividend</th><th>52W High</th><th>52W Low</th><th>CEO</th></tr>
  </thead>
  <tbody>
    <tr><td>Apple Inc.</td><td>AAPL</td><td>$2109.53</td><td>-0.42%</td><td>48,374,838</td><td>$53.59B</td><td>4.7 ★</td><td><span class="badge bg-danger/15 text-danger">Bearish</span></td><td>Technology</td><td>Consumer Electronics</td><td>160,000</td><td>1976</td><td>28.5</td><td>0.65%</td><td>$2150</td><td>$1200</td><td>Tim Cook</td></tr>
  </tbody>
</table>
```

**Init / JS.**

```js
new DataTable(document.getElementById("fixed-columns"), {
  fixedColumns: { start: 1, end: 1 },
  paging: false,
  scrollCollapse: true,
  scrollX: true,
  scrollY: 300,
  language: dtLang
});
```

**Gotchas.** `nowrap` (DataTables helper) is what keeps cells on one line so the table actually overflows;
pinned cells get `.dtfc-fixed-start/.dtfc-fixed-end` with `--dtfc-thead-cell_background` /
`--dtfc-tbody-cell_background` backgrounds (set by the plugin from the table background — verify in dark mode).
`stripe` is DataTables' own odd-row class (styled in app.min.css) and is needed because `table-striped`'s
`:where(:nth-child(odd))` does not apply to the cloned fixed cells.

## DataTables fixed header (tables-datatables-fixed-header)

**What it is.** FixedHeader extension: the `<thead>` floats at the top of the viewport while the page scrolls
through a 25-row page.

**Use it when.** Long single-table pages (user directory, inventory) where the column labels must stay visible.

**Source.** `tables-datatables-fixed-header.html` + `datatables-fixed-header.js` + `dataTables.fixedHeader.min.js`.

**Markup.** `<table id="fixed-header-data" class="table table-striped"><thead class="text-2xs font-semibold uppercase">…` (no note card on this page).

**Init / JS.**

```js
new DataTable(document.getElementById("fixed-header-data"), {
  fixedHeader: { header: true, headerOffset: 65 },   // 65px = the sticky topbar height
  pageLength: 25,
  language: dtLang
});
```

**Gotchas.** `headerOffset` must equal the template topbar height or the floating header hides under it; the
clone gets `table.fixedHeader-floating` with `background-color: var(--color-body-bg)` from app.min.css. Does
not combine with `scrollY` (use the scroll page's approach instead).

## DataTables show/hide columns (tables-datatables-columns)

**What it is.** A "Show/Hide Columns" Preline dropdown of checkboxes injected into the `dom` layout that toggles
`column(i).visible()`.

**Use it when.** Dense reports where users want to hide Volume/Market Cap on small screens or for printing;
user-configurable list views.

**Source.** `tables-datatables-columns.html` + `datatables-show-hide-columns.js`.

**Markup.** `<table id="show-hide-column" class="table table-striped">` with the standard 8-column header; the
dropdown is created by the script into the `.columnToggleWrapper` slot declared in `dom`.

**Init / JS.**

```js
const el = document.getElementById("show-hide-column");
if (el) {
  const table = new DataTable(el, {
    responsive: true,
    dom: "<'md:flex justify-between items-center mb-3'<'columnToggleWrapper'B>f>rt<'md:flex justify-between items-center mt-base'lp>",
    language: dtLang
  });
  const cols = ["Company", "Symbol", "Price", "Change", "Volume", "Market Cap", "Rating", "Status"];
  const host = document.querySelector(".columnToggleWrapper");
  if (host) {
    const dd = document.createElement("div");
    dd.className = "hs-dropdown [--auto-close:inside] relative inline-flex";   // stays open while ticking boxes
    dd.innerHTML = `
      <button class="hs-dropdown-toggle btn btn-sm bg-secondary text-white" type="button">Show/Hide Columns</button>
      <ul class="hs-dropdown-menu" id="columnToggleMenu">
        ${cols.map((c, i) => `
          <li class="dropdown-item">
            <div class="flex items-center gap-2">
              <input class="form-checkbox form-checkbox-light mt-0 toggle-vis" type="checkbox" data-column="${i}" id="colToggle${i}" checked>
              <label class="form-check-label font-medium" for="colToggle${i}">${c}</label>
            </div>
          </li>`).join("")}
      </ul>`;
    host.appendChild(dd);
    document.getElementById("columnToggleMenu").addEventListener("change", (e) => {
      if (e.target.classList.contains("toggle-vis"))
        table.column(parseInt(e.target.dataset.column, 10)).visible(e.target.checked);
    });
  }
}
```

**Gotchas.**
- The dropdown is injected after Preline's `DOMContentLoaded` autoinit; if it does not open in your build call
  `window.HSStaticMethods.autoInit()` right after `host.appendChild(dd)`.
- `B` in `dom` does nothing here (Buttons extension is not loaded on this page); the wrapper div is what matters.
  Alternatively use Buttons' built-in `colvis` button.
- `responsive:true` may itself hide columns on narrow screens; the checkbox state then disagrees with what is
  visible.

## DataTables child rows (tables-datatables-child-rows)

**What it is.** An expand/collapse control column; clicking it opens a child row rendered from the row's data
(`row.child(html).show()`).

**Use it when.** Order rows that expand to show line items; a user row that expands to show roles/permissions;
any master-detail without leaving the list.

**Source.** `tables-datatables-child-rows.html` + `datatables-child-rows.js` (ajax from `assets/data/datatables.json`).

**Markup.** Header has an empty first `<th>` for the control column:

```html
<table id="child-rows-data" class="table table-striped">
  <thead class="text-2xs font-semibold uppercase">
    <tr><th></th><th>Company</th><th>Symbol</th><th>Price</th><th>Change</th><th>Volume</th><th>Market Cap</th></tr>
  </thead>
</table>
```

**Init / JS.**

```js
function format(d) {   // d = row data object
  return `<div class="grid md:grid-cols-3 items-center">
    <div><h5 class="mb-1">Rating:</h5><div>${d.rating}</div></div>
    <div><h5 class="mb-1">Status:</h5>
      <span class="badge rounded-none ${d.status === "Bullish" ? "bg-success/15 text-success" : "bg-danger/15 text-danger"}">${d.status}</span></div>
    <div><h5 class="mb-1">Extra info:</h5><div>And any further details here (images etc)...</div></div>
  </div>`;
}

const table = new DataTable(document.getElementById("child-rows-data"), {
  ajax: "assets/data/datatables.json",
  columns: [
    { className: "dt-control dt-child-rows-btn", orderable: false, data: null,
      defaultContent: '<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="currentColor" class="text-primary"><path stroke="none" d="M0 0h24v24H0z" fill="none"/><path d="M4.929 4.929a10 10 0 1 1 14.141 14.141a10 10 0 0 1 -14.14 -14.14zm8.071 4.071a1 1 0 1 0 -2 0v2h-2a1 1 0 1 0 0 2h2v2a1 1 0 1 0 2 0v-2h2a1 1 0 1 0 0 -2h-2v-2z" /></svg>' },  // tabler circle-plus-filled
    { data: "company" }, { data: "symbol" }, { data: "price" }, { data: "change" }, { data: "volume" }, { data: "market_cap" }
  ],
  order: [[1, "asc"]],
  language: dtLang
});

table.on("click", "td.dt-control", (e) => {
  const row = table.row(e.target.closest("tr"));
  row.child.isShown() ? row.child.hide() : row.child(format(row.data())).show();
});
```

**Gotchas.** The demo's `format()` has a `text-succes` typo and Bootstrap leftovers (`col-md-4`, `fs-base`)
that do not exist in this build — corrected above. `.dt-control:before` is suppressed globally, so the SVG in
`defaultContent` is the only indicator; it does not change to a minus when open (add a class toggle on
`tr.dt-hasChild` if you need that). `dt-child-rows-btn` has no CSS; it is a hook.

## DataTables column searching (tables-datatables-column-searching)

**What it is.** A second header row of `form-input form-input-sm` fields, one per column, wired to
`column(i).search()`.

**Use it when.** Power-user grids (admin user list, product catalogue) where filtering by several columns at
once beats one global search box.

**Source.** `tables-datatables-column-searching.html` + `datatables-column-search.js`.

**Markup.**

```html
<table id="column-search-data" class="table">
  <thead class="text-2xs font-semibold uppercase">
    <tr><th>Company</th><th>Symbol</th><th>Price</th><th>Change</th><th>Volume</th><th>Market Cap</th><th>Rating</th><th>Status</th></tr>
    <tr id="column-search-inputs" class="column-search-input-bar">
      <th><input type="text" placeholder="Company" class="form-input form-input-sm bg-default-50! border-light" /></th>
      <th><input type="text" placeholder="Symbol" class="form-input form-input-sm bg-default-50! border-light" /></th>
      <!-- one <th><input> per column, placeholder = column name -->
    </tr>
  </thead>
  <tbody>…</tbody>
</table>
```

**Init / JS.**

```js
new DataTable(document.getElementById("column-search-data"), {
  language: dtLang,
  initComplete: function () {
    const api = this.api();
    // stop header clicks on the input row from toggling sort
    document.querySelectorAll("#column-search-inputs th").forEach((th) => th.addEventListener("click", (e) => e.stopPropagation()));
    document.querySelectorAll("#column-search-inputs th input").forEach((input, i) => {
      input.addEventListener("click", (e) => e.stopPropagation());
      input.addEventListener("keyup", function () {
        if (api.column(i).search() !== this.value) api.column(i).search(this.value).draw();
      });
    });
  }
});
```

**Gotchas.** `.column-search-input-bar .dt-column-order { display:none }` (app.min.css) hides the sort arrows
on the input row. DataTables binds its ordering listeners to the *bottom* header row (`orderCellsTop:false`
default), i.e. to the inputs row — that is why the demo stops propagation on those `th`s and inputs; the
cleaner alternative is `orderCellsTop: true` (listeners on the label row) and no `stopPropagation` calls.
Use `type="text"` as the demo does; a `type="search"` clear button would not fire `keyup`.

## DataTables range search (tables-datatables-range-search)

**What it is.** Min/Max inputs injected into a `dom` slot and a `search.fixed("range", fn)` filter on the Price
column (index 2), redrawn on every keystroke.

**Use it when.** Price between, quantity between, score between; any numeric bracket on a column that renders
with currency symbols/commas.

**Source.** `tables-datatables-range-search.html` + `datatables-range-search.js`.

**Markup.** `<table id="range-search-data" class="table-striped table">` with the standard header; the inputs
are generated into `.filter-range`.

**Init / JS.**

```js
const table = new DataTable(document.getElementById("range-search-data"), {
  dom: "<'md:flex justify-between items-center mb-3'<'filter-range me-2'>f>rt<'md:flex justify-between items-center mt-base'ip>",
  language: dtLang
});
const host = document.querySelector(".filter-range");
host.innerHTML = `
  <div class="flex items-center gap-2 my-2">
    <label class="font-semibold">Price: </label>
    <input type="text" class="form-input form-input-sm" placeholder="Min" id="min">
    <input type="text" class="form-input form-input-sm" placeholder="Max" id="max">
  </div>`;
const minEl = document.getElementById("min"), maxEl = document.getElementById("max");

table.search.fixed("range", (searchStr, rowData) => {     // DataTables 2 API (replaces $.fn.dataTable.ext.search.push)
  const min = parseFloat(minEl.value) || NaN;
  const max = parseFloat(maxEl.value) || NaN;
  const price = parseFloat((rowData[2] || "").replace(/[^0-9.]/g, "")) || 0;   // "$2109.53" → 2109.53
  return (isNaN(min) && isNaN(max)) || (isNaN(min) && price <= max) || (min <= price && isNaN(max)) || (min <= price && price <= max);
});
minEl.addEventListener("input", () => table.draw());
maxEl.addEventListener("input", () => table.draw());
```

**Gotchas.** `rowData[2]` is positional — change it when the price column moves. `parseFloat("0") || NaN`
treats a typed `0` as "no bound"; use `Number.isNaN(parseFloat(v))` checks if 0 is a valid bound in your data.

## DataTables add rows (tables-datatables-rows-add)

**What it is.** An "Add Row" button injected into the toolbar that appends a generated row with
`row.add([...]).draw(false)`.

**Use it when.** Live feeds (new orders/tickets arriving via polling or websockets), inline "add line item"
editors, demo data generators.

**Source.** `tables-datatables-rows-add.html` + `datatables-rows-add.js`.

**Markup.** `<table id="add-rows-data" class="table-striped table">` with the standard header and a few seed rows.

**Init / JS.**

```js
let n = 1;
const table = new DataTable("#add-rows-data", {
  dom: "<'md:flex justify-between items-center mb-3'<'btn-toolbar'<'addRowBtn me-3'>><'dropdown'B>f><'row'<'col-sm-12'tr>><'md:flex justify-between items-center mt-base'ip>",
  language: dtLang,
  columns: [{ title: "Company" }, { title: "Symbol" }, { title: "Price" }, { title: "Change" }, { title: "Volume" }, { title: "Market Cap" }, { title: "Rating" }, { title: "Status" }]
});
const host = document.querySelector(".addRowBtn");
const btn = document.createElement("button");
btn.id = "addRow";
btn.className = "btn bg-primary text-white btn-sm hover:bg-primary-hover";
btn.textContent = "Add Row";
host.appendChild(btn);
btn.addEventListener("click", () => {
  table.row.add([
    "New Company " + n, "SYM" + n,
    "$" + (Math.random() * 1000 + 1000).toFixed(2),
    (Math.random() > .5 ? "+" : "-") + (Math.random() * 2).toFixed(2) + "%",
    Math.floor(Math.random() * 1e6).toLocaleString(),
    `$${(Math.random() * 100).toFixed(2)}B`,
    (Math.random() * 5).toFixed(1) + " ★",
    `<span class="badge rounded-none ${Math.random() > .5 ? "bg-success/15 text-success" : "bg-danger/15 text-danger"}">${Math.random() > .5 ? "Bullish" : "Bearish"}</span>`
  ]).draw(false);   // false = stay on the current page
  n++;
});
```

**Gotchas.** The `dom` string carries Bootstrap-era wrappers (`row`, `col-sm-12`, `dropdown`) and a `B` with no
Buttons extension loaded — harmless, but trim to `"<'md:flex justify-between items-center mb-3'<'addRowBtn'>f>rt<'md:flex justify-between items-center mt-base'ip>"`.
Row arrays must match the column count exactly.

## DataTables checkbox select (tables-datatables-checkbox-select)

**What it is.** Select extension in checkbox mode: `DataTable.render.select()` draws a checkbox in column 0 of
every row plus a check-all in the header; clicking the box toggles `tr.selected`.

**Use it when.** Bulk actions on a DataTables grid (export selected, assign, delete) — the DataTables
counterpart of custom-table.js's `data-table-select-all`.

**Source.** `tables-datatables-checkbox-select.html` + `datatables-checkbox-select.js` + `dataTables.select.min.js`.

**Markup.** An empty, narrow first column in both header and rows:

```html
<table id="checkbox-select-data" class="table-striped table align-middle">
  <thead class="thead-sm text-2xs uppercase">
    <tr><th class="text-sm" style="width: 1%"></th><th>Company</th><th>Symbol</th><th>Price</th><th>Change</th><th>Volume</th><th>Market Cap</th><th>Rating</th><th>Status</th></tr>
  </thead>
  <tbody>
    <tr><td class="text-sm" style="width: 1%"></td><td>Apple Inc.</td><td>AAPL</td><td>$2109.53</td><td>-0.42%</td><td>48,374,838</td><td>$53.59B</td><td>4.7 ★</td><td><span class="badge badge-label bg-danger/15 text-danger">Bearish</span></td></tr>
  </tbody>
</table>
```

**Init / JS.**

```js
new DataTable(document.getElementById("checkbox-select-data"), {
  columnDefs: [{ orderable: false, render: DataTable.render.select(), targets: 0 }],
  select: { style: "multi", selector: 'td:first-child input[type="checkbox"]' },   // only the box toggles selection, not the row
  order: [[1, "asc"]],
  language: dtLang
});
```

**Gotchas.** The generated `input.dt-select-checkbox` is restyled in app.min.css to look like `.form-checkbox`
(card background, `default-300` border, rounded) with an indeterminate state for the header box; selected rows
turn `warning/10`. Get the selection with `table.rows({ selected: true }).ids()` / `.data()`.

## Original sources

- `references/sources/pages/tables-static.html`
- `references/sources/pages/tables-custom.html`
- `references/sources/pages/tables-datatables-basic.html`
- `references/sources/pages/tables-datatables-export-data.html`
- `references/sources/pages/tables-datatables-select.html`
- `references/sources/pages/tables-datatables-ajax.html`
- `references/sources/pages/tables-datatables-javascript.html`
- `references/sources/pages/tables-datatables-rendering.html`
- `references/sources/pages/tables-datatables-scroll.html`
- `references/sources/pages/tables-datatables-fixed-columns.html`
- `references/sources/pages/tables-datatables-fixed-header.html`
- `references/sources/pages/tables-datatables-columns.html`
- `references/sources/pages/tables-datatables-child-rows.html`
- `references/sources/pages/tables-datatables-column-searching.html`
- `references/sources/pages/tables-datatables-range-search.html`
- `references/sources/pages/tables-datatables-rows-add.html`
- `references/sources/pages/tables-datatables-checkbox-select.html`
- `references/sources/assets/js/pages/custom-table.js`
- `references/sources/assets/js/pages/datatables-basic.js`
- `references/sources/assets/js/pages/datatables-export-data.js`
- `references/sources/assets/js/pages/datatables-select.js`
- `references/sources/assets/js/pages/datatables-ajax.js`
- `references/sources/assets/js/pages/datatables-javascript-source.js`
- `references/sources/assets/js/pages/datatables-rendering.js`
- `references/sources/assets/js/pages/datatables-scroll.js`
- `references/sources/assets/js/pages/datatables-fixed-columns.js`
- `references/sources/assets/js/pages/datatables-fixed-header.js`
- `references/sources/assets/js/pages/datatables-show-hide-columns.js`
- `references/sources/assets/js/pages/datatables-child-rows.js`
- `references/sources/assets/js/pages/datatables-column-search.js`
- `references/sources/assets/js/pages/datatables-range-search.js`
- `references/sources/assets/js/pages/datatables-rows-add.js`
- `references/sources/assets/js/pages/datatables-checkbox-select.js`
- `references/sources/assets/css/app.min.css` (grepped for `.table*`, `.pagination`, `.page-*`, `.dt-*`, `.dtfc-*`, `.fixedHeader-*`, `.column-search-input-bar`, `.badge-label`, `.input-icon-group`)
- `references/sources/MANIFEST-page-deps.txt` (custom-table.js and datatables-dt usage)
- `references/sources/pages/apps-ecommerce-orders.html` (grepped only, to confirm real-world `data-table-*` usage)
