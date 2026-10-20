# E-commerce app pages: catalog, orders, customers, sellers, inventory, reports, settings

The 23 `apps-ecommerce-*` demo pages are complete back-office and storefront layouts for an online shop:
catalog (marketplace landing, product list/grid/details/add, categories, attributes), transactions (orders,
order details, order add, cart, checkout, refunds), people (customers, sellers, seller details, reviews),
inventory (warehouse, stocks, purchase orders) and reporting/config (product views, sales reports, shop
settings). Reach for them whenever a product needs a *record list with filters + a detail page + an add/edit
form* — the patterns transfer directly to CRMs, ticketing, booking, SaaS billing or any admin that manages
entities. Fifteen of the pages share one client-side list engine (`assets/js/pages/custom-table.js`,
documented first) and one visual vocabulary for stat tiles and status badges.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Searchable, sortable, filterable, paginated record list with bulk delete (no server) | Shared list engine: `[data-table]` card | any `apps-ecommerce-*` list page | `assets/js/pages/custom-table.js` |
| Consistent status colours + KPI tiles across the admin | Shared vocabulary: stat tiles, status badges, action icon trio | products / orders / refunds | app.js counters (`data-target`) |
| Storefront landing with category promos, product cards, brand strip | Marketplace | `apps-ecommerce-marketplace.html` | – |
| Admin product list with KPI row, category/status/price filters, grid/list toggle | Products | `apps-ecommerce-products.html` | custom-table.js |
| Shoppable catalog with faceted sidebar (category, brand, price slider, rating) | Products Grid | `apps-ecommerce-products-grid.html` | noUiSlider via `ecommerce-products.js` |
| Single product page: image carousel with thumbnails, meta grid, price, review manager | Product Details | `apps-ecommerce-product-details.html` | Preline `hs-carousel`, custom-table.js |
| Create/edit product form: rich-text description, image dropzone, pricing, organise | Product Add | `apps-ecommerce-product-add.html` | Quill + Dropzone via `ecommerce-product-add.js` |
| Taxonomy list with Add-in-modal (name, slug, image, status) | Categories | `apps-ecommerce-categories.html` | custom-table.js, `hs-overlay` |
| Attribute/option definitions (Color: Red, Blue…) with inline on/off switch | Attributes | `apps-ecommerce-attributes.html` | custom-table.js, `hs-overlay` |
| Transaction ledger with payment/delivery status + relative date filter | Orders | `apps-ecommerce-orders.html` | custom-table.js |
| Single order: line items + totals, shipping-activity timeline, customer / address / billing cards | Order Details | `apps-ecommerce-order-details.html` | – |
| Simple create/edit record form with date picker | Order Add/Edit | `apps-ecommerce-order-add.html` | flatpickr via app.js `data-provider` |
| People directory with export menu, flag column, Add-in-modal | Customers | `apps-ecommerce-customers.html` | custom-table.js, `hs-overlay`, flatpickr |
| Basket: quantity steppers, line totals, summary box, coupon, free-shipping meter | Cart | `apps-ecommerce-cart.html` | app.js `data-touchspin` |
| 4-step wizard: billing form → saved-address radio cards + shipping method → payment method + masked card → confirmation | Checkout | `apps-ecommerce-checkout.html` | Preline `hs-stepper`, Inputmask via `form-inputmask.js` |
| Vendor/partner list with numeric range filters and sparkline column | Sellers | `apps-ecommerce-sellers.html` | custom-table.js, ApexCharts via `ecommerce-product-views.js` |
| Vendor profile: sticky info card, KPI row, mixed revenue chart, "my products" table | Seller Details | `apps-ecommerce-seller-details.html` | ApexCharts via `ecommerce-seller-details.js`, custom-table.js |
| Approval queue: KPI tiles, approve/reject row actions, create-in-modal | Refunds | `apps-ecommerce-refunds.html` | custom-table.js, `hs-overlay`, flatpickr |
| Feedback moderation: score + distribution bars + 30-day trend, review rows | Reviews | `apps-ecommerce-reviews.html` | ApexCharts via `ecommerce-reviews.js`, custom-table.js |
| Multi-location facility list (manager, capacity, stock, status) with Add-in-modal | Warehouse | `apps-ecommerce-warehouse.html` | custom-table.js, `hs-overlay` |
| Inventory levels with low-stock thresholds and stock-status filter | Product Stocks | `apps-ecommerce-product-stocks.html` | custom-table.js |
| Supplier purchase orders (procurement) with 2 status dimensions + Add-in-modal | Purchased Orders | `apps-ecommerce-purchased-orders.html` | custom-table.js, `hs-overlay`, flatpickr |
| Per-item analytics table (views, orders, conversion, sparkline) | Product Views | `apps-ecommerce-product-views.html` | ApexCharts via `ecommerce-product-views.js`, custom-table.js |
| Period report: date-range picker, mixed chart with dual y-axis, daily rows | Sales Reports | `apps-ecommerce-sales.html` | ApexCharts + flatpickr via `ecommerce-sales.js`, custom-table.js |
| Settings hub: vertical section nav + per-section forms (12 sections) | Shop Settings | `apps-ecommerce-settings.html` | Preline `hs-stepper` |

## Shared list engine: `custom-table.js` (`[data-table]`)

**What it is.** A ~6 KB vanilla class (`CustomTable` → one `Table` per `[data-table]` element) that adds
search, column sort, select-filters, numeric/date range filters, rows-per-page, pagination, "Showing x to y
of z", select-all, bulk delete and per-row delete (with an injected Preline confirm modal) to a static HTML
table. No server round-trips: it reorders the `<tr>` nodes already in `<tbody>`. Used by products,
product-details (reviews), categories, attributes, orders, customers, sellers, seller-details, refunds,
reviews, warehouse, product-stocks, purchased-orders, product-views and sales.

**Use it when.**
- Any admin list up to a few hundred rows that is rendered server-side or injected once: orders, tickets,
  invoices, users, assets, audit rows.
- You want filters/sort/pagination with zero config and the template's look (`ul.pagination`, confirm modal).
- NOT for large or remote datasets, column reordering, export, or server-side paging — use the DataTables
  pages (`hs-datatable`) or Grid.js pages in the tables group instead.

**Source.** `references/sources/assets/js/pages/custom-table.js` (loaded after `app.js` on every list page).

**Markup.** The attributes are the whole API; the wrapper can be any element (the demos use the `.card`).

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i>
        <input data-table-search type="search" class="form-input" placeholder="Search product name..." /></div>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button>
    </div>
    <div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap">
      <span class="font-semibold me-5">Filter By:</span>
      <div class="input-icon-group"><i class="iconify tabler--tag input-icon"></i>
        <select data-table-filter="category" class="form-select">            <!-- exact text match on th[data-column="category"] -->
          <option value="All">Category</option><option value="Electronics">Electronics</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--currency-dollar input-icon"></i>
        <select data-table-range-filter="price" class="form-select">         <!-- numeric "a-b" or "a+" on th[data-column="price"] -->
          <option value="">Price Range</option><option value="0-50">$0 - $50</option><option value="500+">$500+</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--calendar input-icon"></i>
        <select data-table-range-filter="date" class="form-select">          <!-- name contains "date" → relative presets -->
          <option value="All">Date Range</option><option value="Today">Today</option><option value="Last 7 Days">Last 7 Days</option>
          <option value="Last 30 Days">Last 30 Days</option><option value="This Year">This Year</option></select></div>
      <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="10">10</option></select>
    </div>
  </div>
  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="thead-sm">
        <tr class="bg-light/25 text-2xs uppercase">
          <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
          <th data-table-sort="product">Product</th>          <!-- sorts on the cell's [data-sort="product"] element -->
          <th data-table-sort data-column="category">Category</th>   <!-- plain sort on first text node; data-column names it for filters -->
          <th data-table-sort data-column="price">Price</th>
          <th data-table-sort data-column="date">Date</th>
          <th class="text-center w-[1%]">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr><!-- repeat per row -->
          <td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
          <td><h5 class="mb-1.25"><a data-sort="product" href="#" class="hover:text-primary">Wireless Earbuds</a></h5></td>
          <td>Electronics</td><td>$59.99</td><td> 18 Apr, 2025 <small class="text-default-400">12:24 PM</small></td>
          <td><div class="flex justify-center gap-1.25">
            <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a>
          </div></td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="card-footer">
    <div data-table-pagination-info="products"></div>   <!-- value = noun: "Showing 1 to 8 of 20 products" -->
    <div data-table-pagination></div>                   <!-- engine renders ul.pagination > li.page-item > a.page-link -->
  </div>
</div>
```

**Init / JS.** `custom-table.js` self-initialises on `DOMContentLoaded` with `new CustomTable()`; the
constructor accepts overrides if you need different hooks:

```js
new CustomTable({
  tableSelector: "[data-table]", searchSelector: "[data-table-search]",
  filterSelector: "select[data-table-filter], input[data-table-filter]",
  rangeFilterSelector: "select[data-table-range-filter], input[data-table-range-filter]",
  rowsPerPageSelector: "[data-table-set-rows-per-page]", rowsPerPageAttribute: "data-table-rows-per-page",
  paginationSelector: "[data-table-pagination]", paginationInfoSelector: "[data-table-pagination-info]",
  sortSelector: "[data-table-sort]", deleteSelectedSelector: "[data-table-delete-selected]",
  deleteRowSelector: "[data-table-delete-row]", rowsPerPage: 10, currentPage: 1 });
```
Sorting parses `$1,299.00`, `12.5%`, `92.5k`/`1.2M`/`3B`, `(4.5)` (parenthesised → negative), `1st/2nd`,
plain numbers and anything `new Date()` can parse; everything else is `localeCompare`.

**Gotchas.**
- Filters match `th[data-column]` by index, so every filter name needs a matching `data-column` on a `<th>`;
  cell text must equal the option value exactly (case-insensitive) — `value="Maintenance"` will not match a
  cell reading "Under Maintenance". Options with `value=""` or `All` mean "no filter"; the Categories demo
  gives every status option `value=""`, so that filter is a no-op — fix the values.
- Range filters strip everything but digits from the cell (`$92.5k` → 92.5) and from the option bounds
  (`100k+` → 100), so keep the same unit on both sides. A range filter whose name contains `date` switches
  to the Today / Last 7 Days / Last 30 Days / This Year presets (relative to *now* — demo dates in 2025 will
  look empty).
- `data-table-select-all` must be on the `<input>` in `<thead>` (the Product Views demo puts it on the `<th>`,
  which silently breaks select-all). The delete button stays `hidden` until a row checkbox is ticked.
- The search box only works if it carries `data-table-search`; the Orders and Customers demos forgot it.
- Rows removed by delete are gone from `this.rows` for good (no undo); wire your own API call on the
  `#confirm-delete` click if you need persistence. The confirm modal is appended to `<body>` each time.
- Because rows are moved in the DOM, Preline widgets inside rows (dropdowns) keep working; charts inside rows
  (`data-chart="apex"`) are rendered once and survive paging.

## Shared vocabulary: stat tiles, status badges, action icons

**What it is.** The three KPI tile layouts, the badge colour conventions and the eye / edit / trash action
trio reused on every e-commerce page. Copy these rather than inventing new colours per page.

**Use it when.** Any admin page needing a KPI strip above a list (orders, tickets, leads, invoices) or a
status column. Keep the same colour → meaning mapping across your whole app.

**Source.** `apps-ecommerce-products.html` (tile A), `apps-ecommerce-orders.html` (tile B),
`apps-ecommerce-refunds.html` (tile C); badges from all list pages.

**Markup.** Tile A (title row + icon + counter + delta + footer metric), grid `lg:grid-cols-5 gap-1.25`:

```html
<div class="mb-1.25 grid grid-cols-1 gap-1.25 md:grid-cols-2 lg:grid-cols-5">
  <div class="card"><div class="card-body">
    <div class="mb-2 flex items-center justify-between">
      <h5 class="card-title text-sm">Products</h5><a href="#!"><i class="iconify tabler--external-link text-default-400 text-lg"></i></a></div>
    <div class="my-5 flex items-center gap-2.5">
      <div class="size-9 flex items-center justify-center bg-primary text-white rounded-full"><i class="iconify tabler--package size-5.5 text-2xl"></i></div>
      <h3 class="text-xl"><span data-target="2,240">0</span></h3>            <!-- app.js animates 0 → 2,240 -->
      <span class="ms-auto badge py-0 text-xs font-medium bg-success/15 text-success">+24 New</span></div>
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-1"><span class="text-primary"><i class="iconify tabler--circle-filled align-middle"></i></span>
        <span class="text-default-400 text-sm">Active Listings</span></div>
      <span class="font-semibold">980</span></div>
  </div></div>
  <!-- repeat: bg-secondary tabler--shopping-cart, bg-success tabler--currency-dollar ($<span data-target="17,854.22">0</span>),
       bg-info tabler--users, bg-warning tabler--chart-bar ($<span data-target="3.5">0</span>M, badge bg-danger/15 text-danger "-4.5%") -->
</div>
```

| Variant | Layout | Where |
|---|---|---|
| Tile B | `<h3 class="text-xl"><span data-target="93.7">0</span>k</h3>` left, icon circle `size-9 … bg-success rounded-full!` right, then `<span class="text-xs uppercase font-bold">Completed Orders</span>` + delta badge `ms-auto` | Orders |
| Tile C | icon circle + counter inline (`mb-5 flex items-center gap-2.5`), then plain label + delta badge | Refunds |
| Tile D | `card-title text-sm` + icon + static `<h3>`, footer "Total …" with `text-default-800` value | Seller Details |

Status badge: `<span class="badge text-2xs font-semibold bg-success/15 text-success">Published</span>`; add
`badge-label` for the square-cornered variant, `rounded-full py-1.5 px-3` for the pill on Product Details.
Colour → meaning as used across the pages (keep it consistent):

| Colour classes | Meanings seen |
|---|---|
| `bg-success/15 text-success` | Published, Delivered, Paid, Approved, Completed, Active, In Stock, Operational, Received(PO Paid) |
| `bg-warning/15 text-warning` | Pending, Processing (orders), Low Stock, Maintenance, Partially Received, Pending Delivery |
| `bg-info/15 text-info` | Shipped, Processing (PO), In Progress, Awaiting Delivery, Fully Refunded tile |
| `bg-danger/15 text-danger` | Cancelled, Rejected, Failed, Out of Stock, Closed, Overdue, Unpaid, Inactive |
| `bg-secondary/15 text-secondary` | Refunded, Awaiting Shipment |
| `bg-primary/15 text-primary` | Received, "Billing Details", informational |
| `bg-light text-dark font-semibold` | neutral counts (facet counts, rating-bar totals) |

Inline dot status (no badge), used for payment state in Orders:
`<div class="text-success flex items-center gap-1 font-semibold"><i class="iconify tabler--circle-filled text-success"></i> Paid </div>`
(`text-warning` Pending, `text-danger` Failed).

Row action trio (right-aligned `w-[1%]` column):
```html
<div class="flex justify-center gap-1.25">
  <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--eye text-base"></i></a>
  <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--edit text-base"></i></a>
  <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a>
</div>
```
Star rating (0-5): five `<i class="iconify tabler--star-filled">` / `tabler--star` inside `<span class="text-warning">`, followed by a
count link `<a class="hover:text-primary font-semibold">(87)</a>`.

**Gotchas.**
- `data-target` counters are animated by app.js on intersection; the span must start at `0` (Refunds leaves
  it empty — still works, but renders blank until scrolled into view). Prefix/suffix (`$`, `k`, `M`) go
  outside the span.
- `rounded-full!` (trailing `!`) is Tailwind v4 important syntax, used where `.btn-icon` would otherwise
  square the circle.

## Marketplace (storefront landing)

**What it is.** A customer-facing landing: three tinted category promo tiles, a headline with pill filter
chips, a 4-up product card grid with discount ribbons, a "View more" CTA and a brand logo strip. Uses the
narrow `.container`.

**Use it when.**
- Shop/marketplace home, B2B catalogue entry page, app-store or template-gallery landing.
- Any "browse by collection" page: courses by track, jobs by department, plugins by category.
- NOT for filtering/searching — that is Products Grid.

**Source.** `references/sources/pages/apps-ecommerce-marketplace.html` (no page script).

**Markup.** Skeleton + the promo tile and product card:

```html
<div class="container">
  <div class="grid grid-cols-1 pt-6 md:grid-cols-2 lg:grid-cols-3 gap-base mb-base">
    <div class="bg-primary/10 flex justify-between rounded px-6 pt-6">              <!-- bg-warning/10, bg-danger/10 for the others -->
      <div>
        <h5 class="mb-5 font-semibold">For Men</h5>
        <ul class="list-unstyled text-body"><li><a href="#" class="block py-1.5">Sports suits</a></li><!-- … --></ul>
        <a href="apps-ecommerce-products-grid.html" class="text-default-700 hover:text-primary my-5 inline-flex items-center gap-0.5 font-semibold">
          View All <i class="iconify tabler--arrow-right text-base"></i></a>
      </div>
      <img src="assets/images/products/man.png" alt="For men" class="mt-auto" style="max-height: 220px" />
    </div>
  </div>

  <div class="pt-7.5"><span class="text-default-400 block text-center">Discover styles tailored for everyone</span>
    <h3 class="mt-3 mb-7.5 text-center text-2xl font-bold"> Find Your <mark class="bg-warning/15 text-default-800">Perfect Style</mark></h3>
    <div class="flex justify-center gap-1.5 pt-1.5">
      <a href="#!" class="badge rounded-full border border-dark/20 text-xs text-dark px-6 py-1 font-semibold">Best Sellers</a>
      <a href="#!" class="badge rounded-full border border-dark/20 text-xs text-default-400 px-6 py-1 font-semibold">New Arrived</a>
    </div>
  </div>

  <div class="my-5 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-base">
    <div class="card relative h-full!">                                               <!-- product card, repeat -->
      <div class="badge py-0 badge-label rounded text-xs bg-success text-white absolute start-0 top-0 m-6">15% OFF</div>
      <div class="card-body h-full!">
        <div class="p-6"><img src="assets/images/products/1.png" alt="modern-sofa" class="img-fluid" /></div>
        <h6 class="card-title mb-3"><a href="apps-ecommerce-product-details.html" class="hover:text-primary">Modern Minimalist Fabric Sofa</a></h6>
        <div class="flex items-center gap-1.5"><span class="text-warning"><i class="iconify tabler--star-filled"></i><!-- x5 --></span>
          <span><a href="apps-ecommerce-reviews.html" class="hover:text-primary font-semibold">(45)</a></span></div>
      </div>
      <div class="card-footer border-dashed">
        <div class="flex w-full justify-between">
          <h4 class="text-success flex items-center gap-3 text-lg"><span class="text-default-400 line-through">$899.00</span> $764.15 </h4>
          <div><a class="btn btn-icon size-7.75 bg-primary text-white hover:bg-primary-hover" href="#!"><i class="iconify tabler--basket text-base"></i></a></div>
        </div>
      </div>
    </div>
  </div>
  <div class="text-end"><a href="apps-ecommerce-products-grid.html" class="btn bg-success mt-5 text-white hover:bg-success-hover"> View More products <i class="iconify tabler--arrow-right text-base"></i></a></div>

  <div class="mx-auto mt-7.5 mb-15 lg:w-5xl">
    <div class="flex gap-base flex-wrap justify-center">
      <div class="border-default-300 rounded border p-6"><a href="#!" class="block"><img src="assets/images/clients/01.svg" alt="logo" class="block h-10.5" /></a></div>
    </div>
  </div>
</div>
```

**Gotchas.**
- The discount ribbon is absolutely positioned, so the card needs `relative`; `h-full!` on card + body makes
  all cards in a grid row equal height.
- Sale price colour is semantic: `text-success` for the hero deal, `text-danger` for the rest — pick one rule.
- `list-unstyled`, `img-fluid` are not in the compiled CSS (Bootstrap leftovers) — harmless, but `ul` has no
  default bullets in Tailwind anyway and images are already `max-w-full h-auto` via preflight.

## Products (admin list)

**What it is.** Store-admin catalogue list: five KPI tiles, then a `[data-table]` card with search, bulk
delete, category / status / price-range filters, rows-per-page, grid⇄list toggle and "Add Product". Columns:
product (thumb + name + vendor), SKU, category, stock, price, orders, rating, status badge, published date,
actions. `container-fluid` (full width).

**Use it when.**
- Merchandiser's product catalogue, SKU master, digital-asset or course catalogue, plugin registry.
- Any list that needs a KPI strip + three filters; swap the columns.
- Use Products Grid instead when the user needs to *browse visually*; use Product Stocks for inventory ops.

**Source.** `references/sources/pages/apps-ecommerce-products.html` + `assets/js/pages/custom-table.js`.

**Markup.** Stat row = Tile A ×5 (see Shared vocabulary). The list card header and one product row:

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="text" class="form-input" placeholder="Search product name..." /></div>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button></div>
    <div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap">
      <div class="items-center md:flex"><span class="font-semibold me-5">Filter By:</span>
        <div class="input-icon-group"><i class="iconify tabler--tag input-icon"></i>
          <select data-table-filter="category" class="form-select"><option value="All">Category</option><option value="Electronics">Electronics</option></select></div></div>
      <div class="input-icon-group"><i class="iconify tabler--activity input-icon"></i>
        <select data-table-filter="status" class="form-select"><option value="">Status</option><option value="Published">Published</option><option value="Pending">Pending</option><option value="Out of Stock">Out of Stock</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--currency-dollar input-icon"></i>
        <select data-table-range-filter="price" class="form-select"><option value="">Price Range</option><option value="0-50">$0 - $50</option><option value="500+">$500+</option></select></div>
      <div><select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="10">10</option></select></div>
    </div>
    <div class="flex flex-wrap items-center gap-2.5">
      <nav class="flex items-center gap-1.25" aria-label="Tabs" role="tablist">
        <a href="apps-ecommerce-products-grid.html" class="btn btn-icon bg-primary/10 text-primary hover:bg-primary hover:text-white"><i class="iconify tabler--apps text-lg"></i></a>
        <a href="apps-ecommerce-products.html" class="btn btn-icon bg-primary text-white hover:bg-primary-hover"><i class="iconify tabler--list-check text-lg"></i></a></nav>
      <a href="apps-ecommerce-product-add.html" class="btn bg-danger text-white hover:bg-danger-hover"><i class="iconify tabler--plus"></i> Add Product </a></div>
  </div>
  <div class="table-wrapper">
    <table class="table table-hover">
      <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
        <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
        <th data-table-sort="product">Product</th><th>SKU</th><th data-table-sort data-column="category">Category</th><th data-table-sort>Stock</th>
        <th data-table-sort data-column="price">Price</th><th data-table-sort>Orders</th><th data-table-sort="rating">Rating</th>
        <th data-table-sort data-column="status">Status</th><th data-table-sort>Published</th><th class="text-center w-[1%]">Actions</th></tr></thead>
      <tbody>
        <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
          <td><div class="flex">
            <div class="me-5 size-9"><img src="assets/images/products/1.png" alt="Product" class="rounded" /></div>
            <div><h5 class="mb-1.25"><a data-sort="product" href="apps-ecommerce-product-details.html" class="hover:text-primary">Wireless Earbuds</a></h5>
              <p class="text-default-400 text-2xs">by: My Furniture</p></div></div></td>
          <td>WB-10245</td><td>Electronics</td><td><h5>56</h5></td><td>$59.99</td><td>124</td>
          <td><span class="text-warning"><i class="iconify tabler--star-filled"></i><!-- x5 --></span><span class="ms-1.5"><a data-sort="rating" href="apps-ecommerce-reviews.html" class="hover:text-primary font-semibold">(87)</a></span></td>
          <td><span class="badge py-0 font-semibold text-2xs bg-success/15 text-success">Published</span></td>
          <td> 18 Apr, 2025 <small class="text-default-400">12:24 PM</small></td>
          <td><!-- action trio --></td></tr>
      </tbody>
    </table>
  </div>
  <div class="card-footer"><div data-table-pagination-info="products"></div><div data-table-pagination></div></div>
</div>
```

**Gotchas.**
- Rating sort uses `data-table-sort="rating"` + `data-sort="rating"` on the `(87)` link, so it sorts by review
  count (parenthesised numbers parse as negative → descending-looking); use `(4.5)` style if you want score.
- The demo's `data-table-filter="status"` attribute is duplicated on the select — harmless, but write it once.
- `thead-sm` tightens header padding (`th{padding:calc(var(--spacing)*2)}`); `text-2xs uppercase` on the
  `<tr>` is what gives the small-caps header look.

## Products Grid (faceted catalog)

**What it is.** Shopper-facing catalog: toolbar card (mobile filter toggle, product count, grid/list toggle,
Add Product), then a `lg:grid-cols-4` layout — a filter sidebar (offcanvas below `lg`, static at `lg`) with
search, category and brand checklists with count badges, a noUiSlider price range and star-rating checklist —
and a `lg:col-span-3` product-card grid with a button-style pagination footer.

**Use it when.**
- Storefront category page, template/theme gallery, stock-photo browser, real-estate listings, job board.
- Any "cards + facets" browse page; the sidebar collapses into a drawer on tablets/phones.
- NOT for admin editing — it has no bulk actions; pair with Products list.

**Source.** `references/sources/pages/apps-ecommerce-products-grid.html` + `assets/js/pages/ecommerce-products.js`
+ `assets/plugins/nouislider/nouislider.min.js` (noUi CSS is compiled into `app.min.css`).

**Markup.** Skeleton with the responsive sidebar and one facet group; cards are the Marketplace card with
`text-sm` titles and `card-footer border-0!`.

```html
<div class="container-fluid">
  <div class="card mb-2.5"><div class="card-body">
    <div class="flex flex-wrap items-center justify-between gap-3">
      <div class="flex items-center gap-4">
        <div class="flex items-center gap-2 text-start lg:hidden">
          <button class="btn btn-icon border-default-300 border bg-white" aria-haspopup="dialog" aria-expanded="false"
                  aria-controls="productFillterOffcanvas" data-hs-overlay="#productFillterOffcanvas"><i class="iconify tabler--menu-4 text-default-600 text-2xl"></i></button></div>
        <h3 class="text-lg"><span data-target="1025">0</span> Products </h3></div>
      <div class="flex items-center gap-2.5 md:ms-auto"><!-- grid/list toggle nav + Add Product (see Products) --></div>
    </div>
  </div></div>

  <div class="grid grid-cols-1 gap-2.5 lg:grid-cols-4">
    <div>
      <div id="productFillterOffcanvas" role="dialog" tabindex="-1" aria-label="Sidebar"
           class="hs-overlay hs-overlay-open:translate-x-0 fixed start-0 top-0 bottom-0 z-90 h-full w-80 -translate-x-full transform rounded-lg transition-all duration-300 [--auto-close:lg] lg:static lg:end-auto lg:bottom-0 lg:block! lg:w-full lg:translate-x-0">
        <div class="card"><div class="card-body p-0">
          <div class="border-default-300 border-b border-dashed p-5">
            <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input type="search" class="form-input" placeholder="Search product name..." /></div></div>
          <div class="border-default-300 border-b border-dashed p-5">                     <!-- facet group, repeat for Brands -->
            <div class="mb-4.5 flex items-center justify-between"><h5>Category:</h5><a href="javascript: void(0);" class="font-semibold text-primary">View All</a></div>
            <div class="space-y-2.5 mt-1.5">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-1.5"><input type="checkbox" id="cat-electronics" class="form-checkbox" />
                  <label for="cat-electronics" class="text-default-400 font-normal">Electronics</label></div>
                <div><span class="badge bg-light text-dark font-semibold">8</span></div>
              </div>
            </div>
          </div>
          <div class="border-default-300 border-b border-dashed p-5">
            <h5 class="mb-4.5">Price:</h5>
            <div id="price-filter" data-slider-size="sm"></div>
            <div class="mt-5 w-full flex items-center gap-2">
              <div class="border border-default-300 rounded w-full text-center p-2" id="price-filter-low"></div>
              <span class="text-default-400 font-semibold">to</span>
              <div class="border border-default-300 rounded w-full text-center p-2" id="price-filter-high"></div></div>
          </div>
          <div class="border-default-300 p-5">
            <div class="mb-4.5 flex items-center justify-between"><h5>Ratings:</h5></div>
            <div class="space-y-2.5 mt-1.5">
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-1.5"><input type="checkbox" id="4star" class="form-checkbox" />
                  <label for="4star" class="flex items-center"><i class="iconify tabler--star-filled text-warning text-sm"></i><!-- x4 --><i class="iconify tabler--star-filled text-default-400 text-sm"></i>
                    <span class="text-default-400 ms-1.25 font-normal">4 Stars & Up</span></label></div>
                <div><span class="badge bg-light text-dark font-semibold">210</span></div></div>
            </div>
          </div>
        </div></div>
      </div>
    </div>
    <div class="lg:col-span-3">
      <div class="grid grid-cols-1 gap-2.5 md:grid-cols-2 lg:grid-cols-4"><!-- product cards --></div>
      <div class="my-5 flex flex-wrap items-center justify-center gap-2 md:justify-between">
        <span class="text-default-400 font-italic"> Last modification: <i class="iconify tabler--clock"></i> 4:55 pm - 22.04.2025 </span>
        <nav class="flex items-center gap-1.5" aria-label="Pagination">
          <button type="button" class="btn btn-icon border-default-300 hover:bg-default-100 hover:text-primary border bg-card transition-all duration-300" aria-label="Previous"><i class="iconify tabler--chevron-left"></i></button>
          <button type="button" class="btn btn-icon bg-primary text-white hover:bg-primary-hover">1</button>
          <button type="button" class="btn btn-icon border-default-300 hover:bg-default-100 hover:text-primary border bg-card transition-all duration-300">2</button>
          <button type="button" class="btn btn-icon border-default-300 hover:bg-default-100 hover:text-primary border bg-card transition-all duration-300" aria-label="Next"><i class="iconify tabler--chevron-right"></i></button></nav>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/ecommerce-products.js` (noUiSlider, formats as `$n`, mirrors values into the two boxes):

```js
const slider = document.getElementById("price-filter");
noUiSlider.create(slider, { connect: true, behaviour: "tap", start: [1000, 2500], range: { min: [1], max: [9999] },
  format: { to: v => "$" + Math.round(v), from: v => Number(v.replace("$", "")) } });
const out = [document.getElementById("price-filter-low"), document.getElementById("price-filter-high")];
slider.noUiSlider.on("update", (values, handle) => { out[handle].innerHTML = values[handle]; });
```

**Gotchas.**
- The sidebar is a Preline offcanvas that *becomes static* at `lg`: `[--auto-close:lg]` closes it on resize,
  `lg:static lg:block! lg:translate-x-0` neutralise the fixed/hidden state. Keep all three or it vanishes on
  desktop. `z-90` keeps it above the topbar on mobile.
- `data-slider-size="sm"` (or `lg`) styles the noUi track height; no extra CSS link is needed.
- The facets and pagination here are static markup — no filtering engine. Wire them to your own query or
  reuse `custom-table.js` on a hidden table if you only need client-side narrowing.

## Product Details

**What it is.** Single-product admin/storefront page: left sticky card with a Preline `hs-carousel` whose
pagination is a row of thumbnails, Edit / Delisting buttons; right (`lg:col-span-2`) stock pill + rating,
title, 4-column meta grid (SKU, Category, Stock, Published, Orders, Revenue), strike-through price with %
off, description + bullet specs, then a "Manage Reviews" `[data-table]` card with a ratings summary
(score, distribution progress bars) and a reviews table.

**Use it when.**
- Product / listing / asset detail with gallery; property or vehicle detail; app or template detail page.
- The review manager block is a reusable "rating summary + feedback list" for any entity that collects ratings
  (sellers, courses, support agents).
- Use Seller Details for a *profile*-style detail; use Order Details for a *transaction*-style detail.

**Source.** `references/sources/pages/apps-ecommerce-product-details.html` + `custom-table.js` (reviews table).

**Markup.** Skeleton + carousel + rating distribution:

```html
<div class="container-fluid"><div class="card"><div class="card-body">
  <div class="grid grid-cols-1 lg:grid-cols-3 gap-base">
    <div>
      <div class="card sticky top-20">
        <div data-hs-carousel='{ "loadingClasses": "opacity-0" }' class="relative">
          <div class="hs-carousel relative overflow-hidden w-full lg:min-h-120 min-h-90 rounded-lg">
            <div class="hs-carousel-body flex flex-nowrap transition-transform duration-700 opacity-0">
              <div class="hs-carousel-slide"><img src="assets/images/products/single-1.png" alt="" class="w-full" /></div>
              <div class="hs-carousel-slide"><img src="assets/images/products/single-2.png" alt="" class="w-full" /></div>
            </div>
            <div class="hs-carousel-pagination relative mt-5 z-10">
              <div class="flex flex-row items-center justify-center gap-4">
                <div class="hs-carousel-pagination-item shrink-0 border border-default-300 rounded overflow-hidden cursor-pointer opacity-50 hs-carousel-active:opacity-100"><img src="assets/images/products/single-1.png" alt="" class="w-12" /></div>
                <div class="hs-carousel-pagination-item shrink-0 border border-default-300 rounded overflow-hidden cursor-pointer opacity-50 hs-carousel-active:opacity-100"><img src="assets/images/products/single-2.png" alt="" class="w-12" /></div>
              </div>
            </div>
          </div>
        </div>
        <div class="my-5 flex justify-center gap-2">
          <a href="apps-ecommerce-product-add.html" class="btn bg-light hover:text-primary"><i class="iconify tabler--pencil text-base"></i> Edit </a>
          <a href="#" class="btn bg-danger text-white hover:bg-danger-hover"><i class="iconify tabler--circle-dashed-plus text-base"></i> Delisting </a></div>
      </div>
    </div>
    <div class="lg:col-span-2"><div class="md:p-7.5">
      <div class="mb-5 flex justify-between"><span class="badge bg-success/15 text-success rounded-full font-semibold text-sm py-1.5 px-3">In Stock</span>
        <div class="flex items-center text-base"><i class="iconify tabler--star-filled text-warning"></i><!-- x5 --><span><a href="apps-ecommerce-reviews.html" class="hover:text-primary ms-1 font-medium">(859 Reviews)</a></span></div></div>
      <div class="mt-5 mb-5 md:mb-7.5"><h4 class="text-lg">Apple iMac 24” M3 Chip – 4.5K Retina Display</h4></div>
      <div class="mb-5 grid grid-cols-2 md:mb-7.5 md:grid-cols-4 gap-x-base">
        <div><h6 class="text-default-400 text-xs mb-1.25 uppercase">SKU:</h6><p class="font-medium">IMAC-M3-24</p></div>
        <!-- Category, Stock, Published; second row items get class="mt-0 md:mt-7.5" -->
      </div>
      <h3 class="text-default-400 mb-7.5 flex items-center gap-3"><del class="text-default-400 text-lg">$1,499.00</del><span class="text-danger text-xl font-bold">$1,299.00</span><span class="text-default-400 text-lg">(13%)</span></h3>
      <h5 class="text-default-400 mb-2.5 text-xs uppercase">Product Info:</h5>
      <p class="mb-4">…</p>
      <ul class="mb-5 flex list-inside list-disc ps-4 flex-col gap-y-1.25"><li>24” 4.5K Retina Display with True Tone.</li></ul>
      <div class="mt-10 md:mt-15">
        <div data-table data-table-rows-per-page="5" class="card shadow-none border border-dashed border-default-300">
          <div class="card-header"><h4 class="card-title">Manage Reviews</h4></div>
          <div class="grid grid-cols-1 lg:grid-cols-12">
            <div class="lg:col-span-7"><!-- score block, see Reviews --></div>
            <div class="lg:col-span-5"><div class="space-y-2.5 p-7.5">
              <div class="flex items-center gap-2">                                                   <!-- repeat 5 → 1 Star -->
                <div class="text-default-800 text-sm text-nowrap">5 Star</div>
                <div class="bg-default-200 flex h-2 w-full overflow-hidden rounded-full" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100">
                  <div class="bg-primary flex flex-col justify-center overflow-hidden rounded-s-full text-center text-xs whitespace-nowrap text-white transition duration-500" style="width: 85%"></div></div>
                <div class="text-end"><span class="badge bg-light text-dark font-semibold">128</span></div>
              </div>
            </div></div>
          </div>
          <div class="table-wrapper"><table class="table table-hover text-wrap"><!-- Reviewer | Review | Date | Status | Actions (see Reviews) --></table></div>
          <div class="card-footer border-light"><div data-table-pagination-info="reviews"></div><div data-table-pagination></div></div>
        </div>
      </div>
    </div></div>
  </div>
</div></div></div>
```

**Gotchas.**
- `hs-carousel` is Preline-autoinit: the thumbnails must be `.hs-carousel-pagination-item` children of
  `.hs-carousel-pagination` *inside* the `data-hs-carousel` element; `hs-carousel-active:` styles the current one.
  `"loadingClasses": "opacity-0"` hides the body until Preline measures it — keep `opacity-0` on `.hs-carousel-body`.
- `sticky top-20` keeps the gallery pinned while the long right column scrolls; reset to `static` if the page
  is shorter than the viewport.
- The reviews card is a second `[data-table]` instance; several on one page are fine.

## Product Add / Edit

**What it is.** Two-column create form (`container`, `lg:grid-cols-3`): left `lg:col-span-2` with "Product
Information" (name, SKU, stock, Quill rich-text description) and "Product Image" (Dropzone with custom
preview template); right column "Pricing" (base price, discount type, discount value) and "Organize" (brand,
category, sub-category, status, tags). Footer: Discard / Save as Draft / Publish.

**Use it when.**
- Any create/edit screen with a long-text field and file uploads: product, blog post, course, listing,
  knowledge-base article, job posting.
- The right column pattern (short "settings" cards next to the main form) suits any form with metadata.

**Source.** `references/sources/pages/apps-ecommerce-product-add.html` + `assets/js/pages/ecommerce-product-add.js`
+ `assets/plugins/quill/quill.js` + `assets/plugins/dropzone/dropzone-min.js` (Quill/Dropzone CSS compiled into app.min.css).

**Markup.**

```html
<div class="container">
  <div class="grid grid-cols-1 lg:grid-cols-3 gap-base">
    <div class="space-y-base lg:col-span-2">
      <div class="card">
        <div class="card-header p-5"><div>
          <h4 class="card-title mb-1.25">Product Information</h4>
          <p class="text-default-400">To add a new product, please provide the necessary details in the fields below.</p></div></div>
        <div class="card-body">
          <div class="grid md:grid-cols-2 gap-base">
            <div class="col-span-2"><label for="productName" class="form-label"> Product Name <span class="text-danger">*</span></label>
              <input type="text" class="form-input" id="productName" placeholder="Enter product name" required /></div>
            <div class="col-span-2 md:col-span-1"><label for="skuId" class="form-label"> SKU <span class="text-danger">*</span></label><input type="text" class="form-input" id="skuId" placeholder="SOFA-10058" /></div>
            <div class="col-span-2 md:col-span-1"><label for="stockNumber" class="form-label"> Stock <span class="text-danger">*</span></label><input type="text" class="form-input" id="stockNumber" placeholder="250" /></div>
            <div class="col-span-2"><label class="form-label"> Product Description <span class="text-default-400">(Optional)</span></label>
              <div id="snow-editor" style="height: 140px"><p>Initial HTML content…</p></div></div>
          </div>
        </div>
      </div>
      <div class="card">
        <div class="card-header p-5"><div><h4 class="card-title mb-1.25">Product Image</h4><p class="text-default-400">…</p></div></div>
        <div class="card-body">
          <div class="border-2 border-dashed border-default-300 rounded-lg p-5">
            <form action="/" method="post" class="my-8" id="myAwesomeDropzone" data-plugin="dropzone"
                  data-previews-container="#file-previews" data-upload-preview-template="#uploadPreviewTemplate">
              <div class="dz-message needsclick">
                <div class="mx-auto mb-5 size-11"><span class="btn btn-icon bg-info/15 text-info size-11 rounded-full"><i class="iconify tabler--cloud-upload text-2xl"></i></span></div>
                <h4 class="mb-2.5 text-lg text-center">Drop files here or click to upload.</h4>
                <p class="text-default-400 mb-5 text-center italic">You can drag images here, or browse files via the button below.</p>
                <div class="flex justify-center"><button type="button" class="btn btn-sm border-default-300 border shadow">Browse Images</button></div>
              </div>
            </form>
          </div>
          <div class="dropzone-previews mt-5" id="file-previews"></div>
          <div class="hidden" id="uploadPreviewTemplate">
            <div class="card mt-1 border border-dashed border-default-300"><div class="p-3"><div class="flex items-center">
              <div class="px-3"><img data-dz-thumbnail src="#" class="size-8 rounded bg-light" alt="" /></div>
              <div><a href="javascript:void(0);" class="font-semibold text-primary" data-dz-name></a><p class="text-default-400" data-dz-size></p></div>
              <div class="ms-auto"><a href="#" class="btn btn-sm text-danger" data-dz-remove><i class="iconify tabler--x text-xl dropzone-close"></i></a></div>
            </div></div></div>
          </div>
        </div>
      </div>
    </div>
    <div class="space-y-base">
      <div class="card">
        <div class="card-header p-5"><div><h4 class="card-title mb-1.25">Pricing</h4><p class="text-default-400">…</p></div></div>
        <div class="card-body"><div class="space-y-base">
          <div><label for="basePrice" class="form-label"> Base Price <span class="text-danger">*</span></label>
            <div class="input-icon-group"><i class="iconify tabler--currency-dollar input-icon"></i><input type="text" class="form-input" id="basePrice" placeholder="Enter base price (e.g., 199.99)" /></div></div>
          <div><label for="discount" class="form-label"> Discount Type <span class="text-default-400">(Optional)</span></label>
            <div class="input-icon-group"><i class="iconify tabler--discount input-icon"></i>
              <select class="form-select" id="discount"><option selected>Choose Discount</option><option value="No Discount">No Discount</option><option value="Flat Discount">Flat Discount</option><option value="Percentage Discount">Percentage Discount</option></select></div></div>
          <div><label for="discountValue" class="form-label"> Discount Value</label>
            <div class="input-icon-group"><i class="iconify tabler--tag input-icon"></i><input type="text" class="form-input" id="discountValue" placeholder="Enter discount amount or percentage" /></div></div>
        </div></div>
      </div>
      <div class="card"><!-- Organize: brand (tabler--stack-2), category (tabler--category), sub-category (tabler--list-check),
                              status select Published/Inactive/Schedule/Draft (tabler--wand), tags (tabler--tag) — same input-icon-group pattern --></div>
    </div>
  </div>
  <div class="mt-7.5 mb-2.5 flex justify-center gap-2.5">
    <a href="#!" class="btn bg-danger text-white hover:bg-danger-hover">Discard</a>
    <a href="#!" class="btn bg-secondary text-white hover:bg-secondary-hover">Save as Draft</a>
    <a href="#!" class="btn bg-success text-white hover:bg-success-hover">Publish</a></div>
</div>
```

**Init / JS.** `assets/js/pages/ecommerce-product-add.js` (trimmed; it also swaps Quill's toolbar icons for Tabler SVGs):

```js
if (typeof Quill !== "undefined") {
  const el = document.getElementById("snow-editor");
  el && new Quill(el, { theme: "snow", modules: { toolbar: [["bold","italic","underline","strike","blockquote","code-block",{ list: "bullet" },"link","image"]] } });
  document.getElementById("bubble-editor") && new Quill("#bubble-editor", { theme: "bubble" });
}
// Dropzone: one instance per [data-plugin="dropzone"]; url = form action, images only
Dropzone.autoDiscover = false;
document.querySelectorAll('[data-plugin="dropzone"]').forEach(form => {
  const opts = { url: form.getAttribute("action") || "/", acceptedFiles: "image/*" };
  if (form.dataset.previewsContainer) opts.previewsContainer = form.dataset.previewsContainer;
  const tpl = form.dataset.uploadPreviewTemplate && document.querySelector(form.dataset.uploadPreviewTemplate);
  if (tpl) opts.previewTemplate = tpl.innerHTML;
  new Dropzone(form, opts);
});
```

**Gotchas.**
- Quill needs a fixed-height host (`style="height:140px"`); read the HTML back with `quill.root.innerHTML`.
- The preview template must stay in the DOM but hidden (`class="hidden"`); Dropzone fills `data-dz-thumbnail`,
  `data-dz-name`, `data-dz-size`, `data-dz-remove`. Change `acceptedFiles` for documents.
- Load order matters: `vendors.min.js` → `app.js` → `quill.js` → `dropzone-min.js` → `ecommerce-product-add.js`.
- There is no edit variant page; Product Details' "Edit" links here — pre-fill the same markup.

## Categories

**What it is.** A `[data-table]` card (no KPI row) listing taxonomy nodes: image + name, slug, products,
orders, earnings, last modified, Active/Inactive badge, actions; header has search, bulk delete, rows-per-page,
status filter and an "Add Category" button opening a Preline modal (`#addCategoryModal`, lives outside `<main>`).

**Use it when.**
- Categories, collections, tags, departments, folders, teams — any flat taxonomy with counts.
- The modal is the template's standard "add record" dialog: name + slug + image + status + description.

**Source.** `references/sources/pages/apps-ecommerce-categories.html` + `custom-table.js`.

**Markup.** Header + row (list engine as above) and the modal:

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search category..." class="form-input" /></div>
      <button data-table-delete-selected class="hidden btn bg-danger text-white hover:bg-danger-hover">Delete</button></div>
    <div class="flex items-center gap-1.25">
      <div><select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="8" selected>8</option><option value="10">10</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--circle input-icon"></i>
        <select data-table-filter="status" class="form-select"><option value="">All</option><option value="Active">Active</option><option value="Inactive">Inactive</option></select></div>
      <a href="#!" class="btn bg-primary text-white text-nowrap hover:bg-primary-hover ms-1.25" aria-haspopup="dialog" aria-expanded="false"
         aria-controls="addCategoryModal" data-hs-overlay="#addCategoryModal"><i class="iconify tabler--plus"></i> Add Category </a></div>
  </div>
  <div class="table-wrapper">
    <table class="w-full table table-hover table-custom">
      <thead class="thead-sm font-semibold"><tr class="bg-light/25 text-2xs uppercase">
        <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
        <th data-table-sort="product">Category Name</th><th data-table-sort>Slug</th><th data-table-sort>Products</th><th data-table-sort>Orders</th>
        <th data-table-sort>Earnings</th><th data-table-sort>Last Modify</th><th data-table-sort data-column="status">Status</th><th class="text-center w-[1%]">Actions</th></tr></thead>
      <tbody>
        <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
          <td><div class="flex gap-base items-center"><div><img src="assets/images/products/1.png" alt="" class="size-9" /></div>
            <h5><a data-sort="product" href="#!" class="hover:text-primary">Furnitures</a></h5></div></td>
          <td>furniture</td><td>5248</td><td>95.6k</td><td>$40.5M</td><td>18 Apr, 2025 <small class="text-default-400 ms-1"> 12:24 PM</small></td>
          <td><span class="badge text-2xs bg-success/15 text-success"> Active </span></td><td><!-- action trio --></td></tr>
      </tbody>
    </table>
  </div>
  <div class="card-footer"><div data-table-pagination-info="categories"></div><div data-table-pagination></div></div>
</div>

<!-- modal: place before </body>, outside <main> -->
<div id="addCategoryModal" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 hidden size-full fixed top-0 start-0 z-80 overflow-x-hidden overflow-y-auto pointer-events-none" role="dialog" tabindex="-1" aria-labelledby="addCategoryModalLabel">
  <div class="hs-overlay-animation-target hs-overlay-open:scale-100 hs-overlay-open:opacity-100 scale-95 opacity-0 ease-in-out transition-all duration-200 lg:max-w-3xl md:max-w-2xl md:w-full m-3 md:mx-auto min-h-[calc(100%-56px)] flex items-center">
    <div class="w-full flex flex-col card pointer-events-auto">
      <div class="card-header"><h3 id="addCategoryModalLabel" class="font-bold text-sm"> Add New Category </h3>
        <button type="button" aria-label="Close" data-hs-overlay="#addCategoryModal"><i class="iconify tabler--x text-xl"></i></button></div>
      <div class="card-body overflow-y-auto">
        <div class="grid grid-cols-2 gap-base">
          <div><label for="categoryName" class="form-label"> Category Name </label><input type="text" class="form-input" id="categoryName" placeholder="e.g. Electronics" required /></div>
          <div><label for="categorySlug" class="form-label"> Slug </label><input type="text" class="form-input" id="categorySlug" placeholder="e.g. electronics" required /></div>
          <div class="lg:col-span-2 col-span-1"><label for="categoryImage" class="form-label"> Category Image </label>
            <input type="file" id="categoryImage" class="block w-full border border-default-300 rounded disabled:opacity-50 disabled:pointer-events-none file:bg-default-100 file:border-0 file:me-4 file:py-2 file:px-3" /></div>
          <div><label for="categoryStatus" class="form-label"> Status </label>
            <select id="categoryStatus" class="form-input" required><option value="">Select Status</option><option value="active">Active</option><option value="inactive">Inactive</option></select></div>
          <div class="lg:col-span-2 col-span-1"><label for="categoryDescription" class="form-label"> Description (Optional) </label>
            <textarea id="categoryDescription" class="form-textarea" rows="3" placeholder="Brief description of the category..."></textarea></div>
        </div>
      </div>
      <div class="flex justify-end items-center gap-x-2 border-t border-default-300 card-body">
        <button type="button" class="btn bg-light hover:text-primary" data-hs-overlay="#addCategoryModal"> Cancel </button>
        <button type="button" class="btn bg-primary text-white hover:bg-primary-hover"> Add Category </button></div>
    </div>
  </div>
</div>
```

**Gotchas.**
- The demo's status filter options all carry `value=""` — give them real values (shown above) or the filter
  does nothing. Cell text has surrounding spaces (` Active `); the engine trims, so that is fine.
- `table-custom` only sets `th{white-space:nowrap}`; `table-select`/`table-centered` are not in the CSS.
- Modal lives outside `<main>`; `data-hs-overlay="#id"` on any element toggles it (Preline autoinit).
  To append a row after "Add Category", insert the `<tr>` and re-run `new CustomTable()` (or keep a reference
  and call `table.init()`), because the engine caches `rows` at init.

## Attributes

**What it is.** `[data-table]` list of product attributes (Color, Size…): name, type (Dropdown / Text /
Number), comma-separated values, an inline `form-switch` status, created / updated dates, "last modified by"
avatar, actions. Header filter by type; "Add Attribute" opens `#addAttributeForm` (modal outside `<main>`)
with name, type, values textarea and an Active switch.

**Use it when.**
- Variant/attribute definitions, custom-field schemas, form-builder field types, feature flags, enum
  registries — anything that is "name + type + allowed values + enabled".
- The inline switch column is the pattern for toggling a record without opening it.

**Source.** `references/sources/pages/apps-ecommerce-attributes.html` + `custom-table.js`.

**Markup.** Row cells that differ from the generic list, plus the modal body:

```html
<thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
  <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
  <th data-table-sort>Attribute Name</th><th data-table-sort data-column="attri-type">Type</th><th data-table-sort>Values</th><th>Status</th>
  <th data-table-sort>Created Date</th><th data-table-sort>Last Updated</th><th data-table-sort>Last Modified By</th><th class="text-center w-[1%]">Actions</th></tr></thead>
<tbody>
  <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
    <td><h6>Color</h6></td><td>Dropdown</td><td><span class="text-default-400">Red, Blue, Green, Black</span></td>
    <td><div class="form-check form-switch"><input class="form-switch" type="checkbox" checked /></div></td>
    <td> 04 Oct, 2025 <small class="text-default-400 text-xs">10:00 AM</small></td><td> 09 Oct, 2025 <small class="text-default-400 text-xs">11:30 AM</small></td>
    <td><div class="flex items-center gap-2.5"><div class="size-8"><img src="assets/images/users/user-4.jpg" alt="" class="rounded-full" /></div>
      <div><h6 class="text-xs font-semibold">Liam Becker</h6><p class="text-default-400 text-xs">Admin</p></div></div></td>
    <td><!-- action trio --></td></tr>
</tbody>

<!-- header filter -->
<select data-table-filter="attri-type" class="form-select"><option value="All">Type</option><option value="Dropdown">Dropdown</option><option value="Text">Text</option><option value="Number">Number</option></select>
<a href="#" class="btn bg-danger text-white hover:bg-danger-hover" data-hs-overlay="#addAttributeForm"><i class="iconify tabler--plus"></i> Add Attribute </a>

<!-- #addAttributeForm modal body (shell identical to Categories modal, md:max-w-2xl lg:max-w-3xl) -->
<div class="card-header p-5"><h3 id="addAttributeFormLabel" class="flex items-center font-semibold"><i class="iconify tabler--circle-dashed-plus me-2.5"></i> Add New Attribute </h3>
  <button type="button" aria-label="Close" data-hs-overlay="#addAttributeForm"><i class="iconify tabler--x text-2xl align-middle text-default-600"></i></button></div>
<div class="card-body"><div class="grid grid-cols-1 md:grid-cols-2 gap-base">
  <div><label for="attributeName" class="form-label"> Attribute Name </label><input type="text" id="attributeName" class="form-input" placeholder="e.g. Color, Size, Material" required /></div>
  <div><label for="attributeType" class="form-label"> Type </label>
    <select id="attributeType" class="form-input" required><option value="">Select Type</option><option value="Dropdown">Dropdown</option><option value="Text">Text</option><option value="Number">Number</option></select></div>
  <div class="col-span-1 md:col-span-2"><label for="attributeValues" class="form-label"> Values </label>
    <textarea id="attributeValues" class="form-textarea" rows="2" placeholder="Separate multiple values with commas (e.g. Red, Blue, Green)"></textarea>
    <small class="text-default-400 mt-1 block"> Applicable only for Dropdown or selectable attributes. </small></div>
  <div class="col-span-1 md:col-span-2"><div class="flex items-center gap-2"><input class="form-switch" type="checkbox" id="attributeStatus" checked />
    <label class="form-check-label font-semibold" for="attributeStatus"> Active </label></div></div>
</div></div>
<div class="border-default-300 flex items-center justify-end gap-2 border-t p-5">
  <button type="button" class="btn bg-light hover:text-primary" data-hs-overlay="#addAttributeForm"> Close </button>
  <button type="button" class="btn bg-danger text-white hover:bg-danger-hover"><i class="iconify tabler--device-floppy"></i> Save Attribute </button></div>
```

**Gotchas.**
- The toggle is `<input class="form-switch" type="checkbox">` — `form-switch` is the template class on the
  input itself; the wrapping `form-check form-switch` div is a Bootstrap leftover (not in the CSS).
- The Status column has no `data-table-sort` (switches have no text); sorting/filtering a boolean needs
  hidden text or a `data-sort` span.
- The demo's filter select repeats `data-table-filter` twice with different names; keep only `attri-type`
  (the one matching `th[data-column]`).

## Orders

**What it is.** The transactional ledger: five Tile-B KPIs (Completed / Pending / Canceled / New /
Returned) and a `[data-table]` with payment-status, delivery-status and *relative date* filters, rows-per-page
and "Add Order". Columns: order id link, date+time, customer (avatar, name, email), amount, payment status
(dot + text), order status badge, payment method (card logo + last 4), actions.

**Use it when.**
- Orders, invoices, payments, bookings, shipments, subscriptions — any list where two independent status
  dimensions (money vs. fulfilment) matter.
- Non-shop: support tickets (priority vs. state), job applications (stage vs. outcome), payouts.

**Source.** `references/sources/pages/apps-ecommerce-orders.html` + `custom-table.js`.

**Markup.** Tile B and the filter/row specifics:

```html
<div class="mb-1.25 grid grid-cols-1 gap-1.25 md:grid-cols-2 lg:grid-cols-5">
  <div class="card"><div class="card-body">
    <div class="mb-5 flex w-full items-center justify-between gap-3">
      <h3 class="text-xl"><span data-target="93.7">0</span>k</h3>
      <div class="size-9 flex items-center justify-center bg-success rounded-full!"><i class="iconify tabler--check size-5.5 text-white"></i></div></div>
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-1"><span class="text-xs uppercase font-bold">Completed Orders</span></div>
      <span class="badge bg-success/15 text-success ms-auto">+3.34%</span></div>
  </div></div>
  <!-- bg-warning tabler--hourglass "Pending Orders", bg-danger tabler--x "Canceled Orders", bg-info tabler--shopping-cart "New Orders", bg-primary tabler--refresh "Returned Orders" -->
</div>

<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="text" class="form-input" placeholder="Search order..." /></div>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button></div>
    <div class="flex flex-wrap items-center gap-2.5 lg:flex-nowrap"><div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap">
      <div class="items-center gap-2.5 md:flex"><span class="font-semibold text-nowrap me-2.5">Filter By:</span>
        <div class="input-icon-group"><i class="iconify tabler--credit-card input-icon"></i>
          <select data-table-filter="payment-status" class="form-select"><option value="All">Payment Status</option><option value="Paid">Paid</option><option value="Pending">Pending</option><option value="Failed">Failed</option><option value="Refunded">Refunded</option></select></div></div>
      <div class="input-icon-group"><i class="iconify tabler--truck input-icon"></i>
        <select data-table-filter="order-status" class="form-select"><option value="All">Delivery Status</option><option value="Processing">Processing</option><option value="Shipped">Shipped</option><option value="Delivered">Delivered</option><option value="Cancelled">Cancelled</option></select></div>
      <div class="input-icon-group"><i class="iconify tabler--calendar input-icon"></i>
        <select data-table-range-filter="date" class="form-select"><option value="All">Date Range</option><option value="Today">Today</option><option value="Last 7 Days">Last 7 Days</option><option value="Last 30 Days">Last 30 Days</option><option value="This Year">This Year</option></select></div>
      <div><select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="10">10</option></select></div>
    </div></div>
    <div class="flex items-center gap-2"><a href="apps-ecommerce-order-add.html" class="btn bg-danger text-white hover:bg-danger-hover"><i class="iconify tabler--plus"></i> Add Order </a></div>
  </div>
  <div class="table-wrapper"><table class="table table-hover">
    <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
      <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
      <th data-table-sort>Order ID</th><th data-table-sort data-column="date">Date</th><th data-table-sort="customer">Customer</th><th data-table-sort>Amount</th>
      <th data-table-sort data-column="payment-status">Payment Status</th><th data-table-sort data-column="order-status">Order Status</th><th>Payment Method</th><th class="text-center w-[1%]">Actions</th></tr></thead>
    <tbody>
      <tr><td><input class="form-checkbox form-checkbox-light size-4.5 align-middle" type="checkbox" value="option" /></td>
        <td><h5 class="text-sm font-medium"><a href="apps-ecommerce-order-details.html" class="hover:text-primary">#WB20100</a></h5></td>
        <td> 9 May, 2025 <small class="text-default-400">10:10 AM</small></td>
        <td><div class="flex items-center gap-2.5"><div><img src="assets/images/users/user-2.jpg" alt="" class="size-8 rounded-full" /></div>
          <div><h5>Mason Carter</h5><p class="text-default-400 text-xs">mason.carter@shopmail.com</p></div></div></td>
        <td>$129.45</td>
        <td><div class="text-success flex items-center gap-1 font-semibold"><i class="iconify tabler--circle-filled text-success"></i> Paid </div></td>
        <td><span class="badge bg-success/15 text-success">Delivered</span></td>
        <td><div class="flex items-center gap-2"><img src="assets/images/cards/visa.svg" alt="visa" class="h-7" /> xxxx 7832 </div></td>
        <td><!-- action trio --></td></tr>
    </tbody></table></div>
  <div class="card-footer"><div data-table-pagination-info="orders"></div><div data-table-pagination></div></div>
</div>
```

Status vocabulary: order status `Delivered` success · `Processing` warning · `Shipped` info · `Cancelled` danger;
payment dot `Paid` success · `Pending` warning · `Failed` danger (the filter also offers `Refunded`; style it
`text-secondary`). Card logos live in `assets/images/cards/{visa,mastercard,paypal,stripe,discover-card,payoneer}.svg`.

**Gotchas.**
- The demo search input lacks `data-table-search` — add it. The `customer` sort key needs a `data-sort="customer"`
  element in the cell (the demo has none, so the Customer column sorts on the first text node, i.e. the name — fine).
- `data-table-range-filter="date"` + `th[data-column="date"]` triggers the relative presets; the cell must parse
  with `new Date("9 May, 2025 10:10 AM")` — it does, but ISO strings are safer.
- In the demo the `card-footer` sits inside `.table-wrapper` (markup slip); put it after, as in Products.

## Order Details

**What it is.** One order, `container` + `lg:grid-cols-4`: left `lg:col-span-3` holds a header card
(order #, date, Paid / Shipped badges, Modify / Delete) with an "Order Summary" bordered table (line items,
subtotal, tax, discount, shipping, grand total) and a "Shipping Activity" vertical timeline; right column
stacks Customer Details (avatar + flag + dropdown + contact rows), Shipping Address (map iframe, address,
"Primary Address" badge, delivery-instructions callout) and Billing Details (address, card logo, Paid badge).

**Use it when.**
- Order / invoice / booking / shipment / subscription detail; any transaction with a line-item table and a
  fulfilment history.
- The timeline is a generic *activity log* (ticket history, deployment pipeline, approval chain); the right
  column cards are generic *related-entity* panels (customer, address, payment).
- NOT for editing — use Order Add/Edit.

**Source.** `references/sources/pages/apps-ecommerce-order-details.html` (no page script).

**Markup.** Summary table + timeline + one side card:

```html
<div class="container"><div class="grid grid-cols-1 lg:grid-cols-4 gap-base">
  <div class="space-y-base lg:col-span-3">
    <div class="card">
      <div class="card-header block items-start p-7.5 md:flex">
        <div><h3 class="mb-1.25 flex items-center text-lg">Order #WB20100</h3>
          <p class="text-default-400 mb-5"><i class="iconify tabler--calendar align-middle"></i> 24 Apr, 2025 <small class="text-default-400">10:10 AM</small></p>
          <div class="flex items-center gap-1">
            <span class="badge badge-label text-2xs font-semibold bg-success/15 text-success"><i class="iconify tabler--circle-filled text-sm"></i> Paid </span>
            <span class="badge badge-label text-2xs font-semibold bg-info/15 text-info"><i class="iconify tabler--truck text-sm"></i> Shipped </span></div></div>
        <div class="mt-4 md:ms-auto md:mt-0"><a href="#" class="btn bg-light hover:text-primary"><i class="iconify tabler--pencil text-sm"></i> Modify </a>
          <a href="#" class="btn bg-danger text-white hover:bg-danger-hover"><i class="iconify tabler--trash text-sm"></i> Delete </a></div>
      </div>
      <div class="card-body px-7.5!">
        <h4 class="mb-5">Order Summary</h4>
        <div class="table-wrapper"><table class="table table-bordered">
          <thead class="thead-sm text-2xs uppercase bg-light/25"><tr><th>Product</th><th>Price</th><th>QTY</th><th class="text-end">Total</th></tr></thead>
          <tbody>
            <tr><td><div class="flex items-start gap-base"><img src="assets/images/products/1.png" alt="" class="size-9 rounded-md" />
              <div><h5 class="text-default-800 font-medium mb-1.25"><a href="apps-ecommerce-product-details.html" class="hover:text-primary">Wireless Earbuds</a></h5>
                <p class="text-default-400 text-2xs">by: My Furniture</p></div></div></td><td>$79.99</td><td>2</td><td class="text-end font-medium">$159.98</td></tr>
            <tr class="border-default-300 border-t"><td colspan="3" class="text-default-800 px-4 py-3 text-right font-medium">Subtotal</td><td class="text-end">$507.48</td></tr>
            <tr><td colspan="3" class="text-default-800 px-4 py-3 text-right font-medium">Tax (10%)</td><td class="text-end">$50.75</td></tr>
            <tr><td colspan="3" class="text-default-800 px-4 py-3 text-right font-medium">Discount (5%)</td><td class="text-danger px-4 py-3 text-right font-semibold">- $25.37</td></tr>
            <tr><td colspan="3" class="text-default-800 px-4 py-3 text-right font-medium">Shipping Fee</td><td class="text-end">$10.00</td></tr>
            <tr class="border-default-300 border-t"><td colspan="3" class="text-end font-bold uppercase">Grand Total</td><td class="text-end font-bold bg-default-50">$543.86</td></tr>
          </tbody></table></div>
      </div>
    </div>

    <div class="card">
      <div class="card-header"><h4 class="card-title">Shipping Activity</h4></div>
      <div class="card-body p-7.5"><div>
        <div class="flex gap-x-base">                                                        <!-- timeline row, repeat; newest first -->
          <div class="w-15 text-end md:w-25"><span class="text-default-400">Today, 9:00 AM</span></div>
          <div class="after:border-default-300 relative after:absolute after:start-1/2 after:top-4 after:bottom-0 after:w-px after:border-e -ms-px after:border-dashed last:after:hidden">
            <div class="relative z-10 flex items-center justify-center"><div class="bg-success size-3.5 rounded-full"></div></div></div>   <!-- bg-light = not yet reached -->
          <div class="flex-1 pb-15">
            <h5 class="mb-1.25">Out for Delivery</h5>
            <p class="text-default-400 mb-1.25">Courier picked up the package for final delivery.</p>
            <p class="text-default-400 mb-1.25 text-2xs"> Tracking No: <a href="#!" class="text-primary underline">TRK123456789</a></p>
            <span class="text-xs font-semibold">By Local Courier</span></div>
        </div>
        <div class="flex gap-x-base">                                                        <!-- last row: no connector, no pb-15 -->
          <div class="w-15 text-end md:w-25"><span class="text-default-400">Last Friday, 5:00 PM</span></div>
          <div><div class="relative z-10 flex items-center justify-center"><div class="bg-success size-3.5 rounded-full"></div></div></div>
          <div class="flex-1"><h5 class="mb-1.25">Order Confirmed</h5><p class="text-default-400 mb-1.25">The order was successfully placed.</p></div>
        </div>
      </div></div>
    </div>
  </div>

  <div class="space-y-base">
    <div class="card">
      <div class="card-header"><h4 class="card-title">Customer Details</h4><a href="#!" class="btn btn-icon border-default-300 size-8! rounded-full border"><i class="iconify tabler--pencil text-lg"></i></a></div>
      <div class="card-body">
        <div class="mb-7.5 flex items-center">
          <div class="relative me-2.5"><img src="assets/images/users/user-5.jpg" alt="" class="size-11 rounded-full object-cover" /></div>
          <div><h5 class="flex items-center mb-1.25"><a href="#" class="text-default-800 hover:text-primary text-sm font-medium transition">Sophia Carter</a><img src="assets/images/flags/gb.svg" alt="UK" class="ms-2.5 size-4 rounded-full" /></h5>
            <p class="text-default-400 text-sm">Since 2020</p></div>
          <div class="relative ms-auto"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
            <button type="button" class="hs-dropdown-toggle btn btn-icon size-9.5 text-default-400 hover:bg-default-100" aria-haspopup="menu" aria-expanded="false"><i class="iconify tabler--dots-vertical text-xl"></i></button>
            <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#"><i class="iconify tabler--share"></i> Share </a><a class="dropdown-item text-danger" href="#"><i class="iconify tabler--trash"></i> Delete </a></div></div>
          </div></div>
        </div>
        <ul class="text-default-400 space-y-2.5">
          <li><div class="flex items-center gap-2.5"><span class="btn btn-icon bg-light text-default-800 size-6! rounded-full"><i class="iconify tabler--mail text-sm"></i></span>
            <h5><a href="#" class="text-default-400 hover:text-primary font-medium text-sm transition-all">sophia@designhub.com</a></h5></div></li>
          <!-- tabler--phone, tabler--map-pin -->
        </ul>
      </div>
    </div>
    <div class="card"><!-- Shipping Address: <iframe …maps/embed…> + name/badge row + address <p> + callout: -->
      <div class="bg-warning/15 rounded px-4 py-3 text-warning"><h6 class="mb-2.5 text-xs">Delivery Instructions:</h6><p class="italic">Please leave the package at the front door…</p></div>
    </div>
    <div class="card"><!-- Billing Details: address + <img src="assets/images/cards/mastercard.svg" class="size-8 rounded"> "Mastercard Ending in 4242" + badge Paid --></div>
  </div>
</div></div>
```

**Gotchas.**
- The timeline connector is pure CSS on the middle column (`after:` pseudo-element, dashed, `last:after:hidden`);
  the last row in the demo simply omits those classes. Dot colour encodes state: `bg-success` done, `bg-light` pending.
- The Google Maps iframe uses a demo API key — replace it or swap for a static map image.
- `size-8!`, `size-6!` override `.btn-icon`'s default size; `px-7.5!` overrides `.card-body` padding.

## Order Add / Edit

**What it is.** A single-card, two-column form (`container`, `md:grid-cols-2 gap-5`): disabled Order ID,
flatpickr order date, customer name / email, product select, quantity, amount, payment status, order status,
payment method, card last-4; centred Cancel / Save Order.

**Use it when.**
- Quick create/edit for any record with ~10 scalar fields: booking, expense, lead, manual invoice.
- For multi-line orders combine with the Order Details summary table or an invoice-style line editor.

**Source.** `references/sources/pages/apps-ecommerce-order-add.html` (flatpickr via app.js `data-provider`).

**Markup.**

```html
<div class="container"><div class="card">
  <div class="card-header"><h4 class="card-title">Create Order</h4></div>
  <div class="card-body">
    <div class="grid md:grid-cols-2 gap-5">
      <div><label for="orderId" class="form-label">Order ID</label><input type="text" class="form-input bg-default-100! font-semibold!" id="orderId" placeholder="#WB20100" disabled /></div>
      <div><label for="orderDate" class="form-label">Order Date</label>
        <input type="datetime-local" data-provider="flatpickr" data-altFormat="F j, Y" class="form-input flatpickr-input" id="orderDate" required /></div>
      <div><label for="customerName" class="form-label">Customer Name</label><input type="text" class="form-input" id="customerName" placeholder="Mason Carter" required /></div>
      <div><label for="customerEmail" class="form-label">Customer Email</label><input type="email" class="form-input" id="customerEmail" placeholder="mason.carter@shopmail.com" /></div>
      <div><label for="productName" class="form-label">Product Name</label>
        <select class="form-select" id="productName"><option value="" selected disabled>Select Product</option><option value="iPhone 15 Pro">iPhone 15 Pro</option></select></div>
      <div><label for="quantity" class="form-label">Quantity</label><input type="text" class="form-input" id="quantity" value="1" min="1" /></div>
      <div><label for="amount" class="form-label">Amount ($)</label><input type="text" class="form-input" id="amount" placeholder="129.45" /></div>
      <div><label for="paymentStatus" class="form-label">Payment Status</label>
        <select class="form-select" id="paymentStatus"><option value="Paid">Paid</option><option value="Pending">Pending</option><option value="Failed">Failed</option></select></div>
      <div><label for="orderStatus" class="form-label">Order Status</label>
        <select class="form-select" id="orderStatus"><option value="Ordered">Ordered</option><option value="Processing">Processing</option><option value="Delivered">Delivered</option><option value="Cancelled">Cancelled</option><option value="Returned">Returned</option></select></div>
      <div><label for="paymentMethod" class="form-label">Payment Method</label>
        <select class="form-select" id="paymentMethod"><option value="Visa">Visa</option><option value="Mastercard">Mastercard</option><option value="PayPal">PayPal</option><option value="COD">Cash on Delivery</option></select></div>
      <div><label for="cardNumber" class="form-label">Card Last 4 Digits</label><input type="text" class="form-input" id="cardNumber" placeholder="7832" /></div>
    </div>
    <div class="mt-5"><div class="text-center">
      <button type="button" class="btn bg-light me-2.5 hover:text-primary">Cancel</button>
      <button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Save Order</button></div></div>
  </div>
</div></div>
```

**Init / JS.** None page-specific. app.js `initFlatPicker()` initialises every `[data-provider="flatpickr"]`
with `{disableMobile:true, defaultDate:new Date}` and reads `data-date-format`, `data-enable-time`,
`data-altFormat` (sets `altInput`), `data-minDate`/`data-maxDate`, `data-default-date`, `data-multiple-date`,
`data-range-date`, `data-inline-date`, `data-disable-date` (comma list), `data-week-number`.
`data-provider="timepickr"` gives a time-only picker.

**Gotchas.**
- `data-altFormat` is camel-cased in the source and read via `attributes["data-altFormat"]` (case-insensitive in
  HTML), so either spelling works; `data-date-format` controls the value submitted.
- The disabled Order ID uses `bg-default-100! font-semibold!` to beat `.form-input`'s own disabled styling.
- Note the demo's "Order Status" options (Ordered/Processing/Delivered/Cancelled/Returned) differ from the
  Orders list badges (Processing/Shipped/Delivered/Cancelled) — unify in your app.

## Customers

**What it is.** `[data-table]` directory in a `container`: search, bulk delete, rows-per-page, an Export
dropdown (PDF / CSV / Excel) and "Add Customer" (modal `#addCustomerModal`). Columns: avatar + name, email,
phone, country (flag + name), joined, orders, total spend, actions. The modal collects full name, email,
phone, country, avatar file and a flatpickr join date.

**Use it when.**
- Customers, members, users, contacts, suppliers, students, patients — any people list.
- The Export dropdown is the template's standard "download as" affordance for any list.

**Source.** `references/sources/pages/apps-ecommerce-customers.html` + `custom-table.js`.

**Markup.** Header right side + a row + modal field block:

```html
<div class="flex gap-2.5 items-center flex-wrap md:flex-nowrap">
  <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="8" selected>8</option><option value="10">10</option></select>
  <div class="relative"><div class="hs-dropdown inline-flex [--placement:bottom-right]">
    <button type="button" class="hs-dropdown-toggle btn border border-default-300 text-default-800 hover:bg-default-100" aria-haspopup="menu" aria-expanded="false">
      <i class="iconify tabler--download text-sm"></i> Export <i class="iconify tabler--chevron-down align-middle ms-1"></i></button>
    <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5">
      <a class="dropdown-item" href="#"> Export as PDF </a><a class="dropdown-item" href="#"> Export as CSV </a><a class="dropdown-item" href="#"> Export as Excel </a></div></div>
  </div></div>
  <a href="#!" class="btn bg-primary text-white text-nowrap hover:bg-primary-hover" aria-haspopup="dialog" aria-expanded="false" aria-controls="addCustomerModal" data-hs-overlay="#addCustomerModal"><i class="iconify tabler--plus"></i> Add Customer </a>
</div>

<div class="overflow-x-auto whitespace-normal"><table class="table table-hover">
  <thead class="thead-sm bg-light/25"><tr class="uppercase text-2xs">
    <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
    <th data-table-sort="customer">Clients Name</th><th data-table-sort>Email</th><th data-table-sort>Phone</th><th data-table-sort>Country</th>
    <th data-table-sort>Joined</th><th data-table-sort>Orders</th><th data-table-sort>Total Spends</th><th class="text-center">Actions</th></tr></thead>
  <tbody>
    <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
      <td><div class="flex gap-2.5 items-center"><img src="assets/images/users/user-7.jpg" alt="" class="size-8 rounded-full" />
        <h5><a data-sort="customer" href="#!" class="hover:text-primary">Carlos Méndez</a></h5></div></td>
      <td>carlos@techlaunch.mx</td><td>+1 (415) 992-3412</td>
      <td><div class="flex gap-2.5 items-center"><div><img src="assets/images/flags/us.svg" alt="" class="size-4 rounded-full" /></div><p>United States</p></div></td>
      <td>2 Feb, 2024<small class="text-default-400 ms-1">08:34 AM</small></td><td>58</td><td>$198.25</td>
      <td><!-- action trio --></td></tr>
  </tbody></table></div>

<!-- #addCustomerModal body (shell as Categories modal) -->
<div class="grid lg:grid-cols-2 grid-cols-1 gap-base">
  <div><label for="customerName" class="form-label"> Full Name </label><input type="text" class="form-input" id="customerName" placeholder="e.g. Carlos Méndez" required /></div>
  <div><label for="customerEmail" class="form-label"> Email </label><input type="email" class="form-input" id="customerEmail" placeholder="e.g. carlos@domain.com" required /></div>
  <div><label for="customerPhone" class="form-label"> Phone </label><input type="tel" class="form-input" id="customerPhone" placeholder="+1 (415) 992-3412" required /></div>
  <div><label for="customerCountry" class="form-label"> Country </label>
    <select class="form-input" id="customerCountry" required><option value="">Select Country</option><option value="United States">🇺🇸 United States</option></select></div>
  <div><label for="customerAvatar" class="form-label"> Avatar </label>
    <input type="file" id="customerAvatar" class="block w-full border border-default-300 rounded disabled:opacity-50 disabled:pointer-events-none file:bg-default-100 file:border-0 file:me-4 file:py-2 file:px-3" /></div>
  <div><label for="joinedDate" class="form-label"> Join Date </label><input type="date" class="form-input" id="joinedDate" data-provider="flatpickr" data-date-format="d M, Y" required /></div>
</div>
```

**Gotchas.**
- Demo search input lacks `data-table-search`. The table wrapper here is `overflow-x-auto whitespace-normal`
  (not `.table-wrapper`) so long emails wrap instead of forcing a scrollbar — pick one deliberately.
- Flags are `assets/images/flags/{iso2}.svg` rendered `size-4 rounded-full`.
- Flatpickr inside a modal works with Preline's overlay because the calendar is appended to `<body>`; if it
  renders behind the modal, pass `appendTo` or raise `.flatpickr-calendar` z-index above `z-80`.

## Cart

**What it is.** Shopper basket: a free-shipping progress banner, then `lg:grid-cols-3` — "Shopping Cart"
card (`lg:col-span-2`) with a line-item table (thumb + variant lines, price with strike-through, touchspin
quantity, total, remove) and "Continue Shopping"; right column "Order Summary" (subtotal, saving, tax,
shipping, estimated total, full-width Proceed to Checkout) and "Apply Coupon Code".

**Use it when.**
- Cart, quote builder, seat/ticket selection, licence configurator — any "selected items + running total".
- The summary box is reusable as a pricing breakdown on checkout, invoices and plan upgrades.

**Source.** `references/sources/pages/apps-ecommerce-cart.html` (touchspin handled by app.js).

**Markup.**

```html
<div class="container">
  <div class="bg-info/10 border border-info/25 text-info mb-4 rounded px-4 py-3">
    <h6 class="text-xs mb-2.5">Buy <span class="text-warning font-bold">$250</span> more to get <span class="font-semibold">Free Shipping</span></h6>
    <div class="bg-default-100 h-1 w-full overflow-hidden rounded-full"><div class="bg-warning h-1 w-[70%] transition-all"></div></div>
  </div>
  <div class="grid grid-cols-1 lg:grid-cols-3 gap-base">
    <div class="lg:col-span-2"><div class="card">
      <div class="card-header flex justify-between"><h4 class="card-title">Shopping Cart</h4><a href="#" class="text-primary font-medium underline underline-offset-4">Clear cart</a></div>
      <div class="card-body">
        <div class="table-wrapper"><table class="table min-w-full border-collapse">
          <thead class="thead-sm bg-light/25 text-2xs uppercase"><tr><th>Product</th><th>Price</th><th>Quantity</th><th>Total</th><th></th></tr></thead>
          <tbody>
            <tr>                                                                                   <!-- line item, repeat -->
              <td class="flex items-center gap-base"><img src="assets/images/products/2.png" alt="" class="size-15 rounded" />
                <div><span class="badge bg-danger/15 text-danger mb-1.25">-10%</span>
                  <h6 class="mb-1.25">Tablet Apple iPad Pro M2</h6>
                  <small class="text-default-400 block">Color: Black</small><small class="text-default-400 block">Model: 256GB</small></div></td>
              <td><span class="font-semibold">$989.00</span><br /><small class="text-default-400 line-through">$1,099.00</small></td>
              <td><div class="input-group max-w-32.5" data-touchspin>
                <button type="button" class="btn bg-primary text-white hover:bg-primary-hover" data-minus><i class="iconify tabler--minus"></i></button>
                <input type="text" class="form-input" value="2" max="800000" />
                <button type="button" class="btn bg-primary text-white hover:bg-primary-hover" data-plus><i class="iconify tabler--plus"></i></button></div></td>
              <td class="font-semibold">$989.00</td>
              <td><a href="#" class="text-default-400"><i class="iconify tabler--x text-base"></i></a></td></tr>
          </tbody></table></div>
        <div class="border-default-300 border-t pt-7.5"><a href="apps-ecommerce-products-grid.html" class="text-primary inline-flex items-center gap-1.5 font-medium"><i class="iconify tabler--arrow-left"></i> Continue Shopping </a></div>
      </div>
    </div></div>
    <div><div class="flex gap-base flex-col">
      <div class="card">
        <div class="card-header"><h4 class="card-title">Order Summary</h4></div>
        <div class="card-body">
          <ul class="list-unstyled mb-6.5">
            <li class="mb-2.5 flex justify-between"><span class="text-default-400">Subtotal (3 items):</span><span>$2,427.00</span></li>
            <li class="mb-2.5 flex justify-between"><span class="text-default-400">Saving:</span><span class="text-danger">- $110.00</span></li>
            <li class="mb-2.5 flex justify-between"><span class="text-default-400">Tax collected:</span><span>$73.40</span></li>
            <li class="border-default-300 mb-5 flex justify-between border-b pb-base"><span class="text-default-400">Shipping:</span><span>Calculated at checkout</span></li>
            <li class="mb-2.5 flex justify-between"><h6 class="text-default-400 text-xs uppercase">Estimated total:</h6><h5 class="font-bold">$2,390.40</h5></li></ul>
          <a href="apps-ecommerce-checkout.html" class="mb-5 btn btn-lg bg-danger text-base w-full text-white hover:bg-danger-hover">Proceed to Checkout</a>
          <p class="text-default-400 text-center"><a href="#" class="text-primary font-semibold">Create an account</a> and get 239 bonuses </p></div>
      </div>
      <div class="card">
        <div class="card-header"><h4 class="card-title">Apply Coupon Code</h4></div>
        <div class="card-body">
          <div class="rounded bg-warning/15 text-warning mb-4 px-4 py-2.5 text-xs"> Use <span class="font-bold">ADMINPRO</span> to get 10% off. </div>
          <div class="input-group relative"><input type="text" class="form-input" placeholder="Enter code" />
            <button class="btn bg-primary absolute inset-y-0 end-0 rounded-s-none text-white hover:bg-primary-hover" type="button">Apply</button></div>
        </div>
      </div>
    </div></div>
  </div>
</div>
```

**Init / JS.** app.js `initTouchSpin()` wires every `[data-touchspin]`: click `[data-minus]`/`[data-plus]`
changes the inner `<input>` by ±1, clamped to the input's `min`/`max` attributes; a `readonly` input disables
both. No events are emitted — listen for clicks yourself to recompute totals.

**Gotchas.**
- `td.flex` on the product cell breaks table-cell semantics (the cell becomes a flex box); it works visually
  because the thumbnail defines height, but put the flex on an inner `<div>` if row heights misalign.
- The demo quantity input has no `min`, so it can go negative — add `min="1"`.

## Checkout

**What it is.** A four-step Preline stepper (`data-hs-stepper`) in a `lg:col-span-2` card — Billing Info
(6-col address form + "ship to different address" + notes), Shipping Info (saved-address radio cards, add
address form, shipping-method radio cards), Payment Info (PayPal / card / Payoneer / COD radio cards with
Inputmask card fields), Finish (thank-you summary, delivery + payment recap, download invoice, promo code
box) — plus a right column Order Summary (thumb + "1 x $1,199" rows, totals) and a bonus-points card.

**Use it when.**
- Checkout, subscription sign-up, onboarding wizard, multi-page application form, booking flow.
- The saved-address and payment-method *radio cards* are a reusable "pick one option with details" control;
  the Finish step is a reusable success screen.

**Source.** `references/sources/pages/apps-ecommerce-checkout.html` + `assets/js/pages/form-inputmask.js`
+ `assets/plugins/inputmask/inputmask.min.js`. Stepper = Preline `hs-stepper` (autoinit).

**Markup.** Stepper shell, a radio card, a masked field, nav buttons:

```html
<div data-hs-stepper>
  <ul class="relative grid grid-cols-1 gap-1.5 md:grid-cols-4">
    <li class="active" data-hs-stepper-nav-item='{"index": 1}'>
      <a href="#" class="hs-stepper-active:bg-light/50 hs-stepper-success:bg-success/10 hs-stepper-success:border-success hs-stepper-success:text-success px-4 py-2.5 flex items-center justify-center gap-2.5 rounded border border-dashed border-default-300">
        <i class="iconify tabler--user-circle text-2xl"></i><span class="text-md block font-semibold">Billing Info</span></a></li>
    <!-- items 2-4 use the same <a> classes as item 1 -->
    <li data-hs-stepper-nav-item='{"index": 2}'><a href="#"><i class="iconify tabler--truck text-2xl"></i><span class="text-md block font-semibold">Shipping Info</span></a></li>
    <li data-hs-stepper-nav-item='{"index": 3}'><a href="#"><i class="iconify tabler--credit-card text-2xl"></i><span class="text-md block font-semibold">Payment Info</span></a></li>
    <li data-hs-stepper-nav-item='{"index": 4}'><a href="#"><i class="iconify tabler--checks text-2xl"></i><span class="text-md block font-semibold">Finish</span></a></li>
  </ul>
  <div class="pt-base">
    <div data-hs-stepper-content-item='{"index": 1}' style="display: none">
      <h5 class="my-1.25 text-md">Billing Information</h5><p class="text-default-400 mb-7.5">Fill the form below in order to send you the order's invoice.</p>
      <div class="grid md:grid-cols-6 gap-x-base gap-y-5 pb-base">
        <div class="md:col-span-3"><label for="billing-first-name" class="form-label">First Name</label><input type="text" class="form-input" id="billing-first-name" placeholder="Enter your first name" /></div>
        <div class="md:col-span-6"><label for="billing-address" class="form-label">Address <span class="text-danger">*</span></label><textarea class="form-textarea" rows="2" id="billing-address"></textarea></div>
        <div class="md:col-span-2"><label for="billing-town-city" class="form-label">Town / City</label><input type="text" class="form-input" id="billing-town-city" /></div>
        <div class="md:col-span-6"><label class="form-label">Country</label><select class="form-select"><option value="0">Select Country</option><option value="US">United States</option></select></div>
        <div class="flex items-center gap-2 md:col-span-6"><input id="customCheck2" class="form-checkbox size-4.25" type="checkbox" /><label class="form-check-label" for="customCheck2">Ship to different address ?</label></div>
      </div>
    </div>
    <div data-hs-stepper-content-item='{"index": 2}' style="display: none">
      <h5 class="my-1.5 text-md">Saved Address</h5>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-base mb-base">
        <div class="border-default-300 peer-checked:border-primary relative rounded-md border p-5">                 <!-- saved-address radio card -->
          <input class="form-radio peer absolute end-2 bottom-2 rounded-full!" type="radio" name="deli-address" id="add-home" checked />
          <label class="form-check-label w-full" for="add-home"><span class="text-default-400 mb-1.25 block font-bold uppercase">Home</span>
            <span class="block font-semibold">Evelyn Carter</span> 2418 Maple Street, Apt 12B <br /> Brooklyn, NY 11215 <br /><abbr title="Phone">P:</abbr> (917) 432-7784 <br /></label></div>
      </div>
      <h5 class="my-1.5 text-md">Shipping Method</h5>
      <div class="grid grid-cols-1 md:grid-cols-2 gap-base mb-base">
        <div class="border-default-300 rounded border p-5">                                                        <!-- option radio card -->
          <div class="flex gap-2"><input type="radio" id="shippingMethodRadio1" name="shippingOptions" class="form-radio rounded-full!" checked />
            <label class="form-check-label font-bold" for="shippingMethodRadio1">Standard Delivery - FREE</label></div>
          <p class="text-default-400 ps-base pt-1.25">Estimated 5-7 days shipping (Duties and tax may be due upon delivery)</p></div>
      </div>
    </div>
    <div data-hs-stepper-content-item='{"index": 3}' style="display: none">
      <div class="border-default-300 mb-5 rounded border p-5">                                                      <!-- payment radio card with logos + fields -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-base">
          <div class="md:col-span-2"><div class="flex gap-1.5"><input type="radio" id="BillingOptRadio1" name="billingOptions" class="form-radio rounded-full!" checked />
            <label class="form-check-label font-bold" for="BillingOptRadio1">Credit / Debit Card</label></div>
            <p class="text-default-400 ps-base pt-1.25">Safe money transfer using your bank account.</p></div>
          <div class="flex md:col-span-1 md:ms-auto"><img src="assets/images/cards/mastercard.svg" class="size-8" alt="" /><img src="assets/images/cards/visa.svg" class="size-8" alt="" /></div></div>
        <div class="rounded bg-warning/10 text-warning text-xs py-2.5 px-4 mb-4 mt-5"> Enjoy an extra <span class="font-bold">10% discount</span> when you pay with your Credit Card. </div>
        <div class="mb-5"><label for="card-number" class="form-label">Card Number</label>
          <input type="text" id="card-number" class="form-input" data-toggle="input-mask" data-mask-format="0000 0000 0000 0000" placeholder="4242 4242 4242 4242" /></div>
        <div class="grid grid-cols-1 md:grid-cols-4 gap-base">
          <div class="md:col-span-2"><label for="card-name-on" class="form-label">Name on card</label><input type="text" id="card-name-on" class="form-input" /></div>
          <div><label for="card-expiry-date" class="form-label">Expiry date</label><input type="text" id="card-expiry-date" class="form-input" data-toggle="input-mask" data-mask-format="00/00" placeholder="MM/YY" /></div>
          <div><label for="card-cvv" class="form-label">CVV code</label><input type="text" id="card-cvv" class="form-input" data-toggle="input-mask" data-mask-format="000" placeholder="012" /></div></div>
      </div>
    </div>
    <div data-hs-stepper-content-item='{"index": 4}' style="display: none"><div class="md:p-7.5">
      <div class="mb-5 flex flex-wrap items-center gap-base">
        <div><div class="bg-success flex size-9 items-center justify-center rounded-full text-white"><i class="iconify tabler--check size-5.5"></i></div></div>
        <div><p class="text-default-400">Order #234000</p><h4 class="text-lg">Thank you for your order!</h4></div>
        <a href="#" class="hover:text-primary link-offset-2 ms-auto font-semibold underline">Track Order</a></div>
      <hr class="border-default-300 my-4 border-t border-dashed" />
      <div class="mt-9"><h6 class="text-default-400 text-xs mb-2 font-bold uppercase">Delivery Address</h6><span class="mb-1.25 block font-semibold">Marcus Reynolds</span> 500 Howard Street… </div>
      <div class="mt-9"><a href="#!" class="btn bg-success text-white hover:bg-success-hover"><i class="iconify tabler--download me-1"></i> Download Invoice </a>
        <a href="apps-ecommerce-products-grid.html" class="btn text-default-400 font-semibold"><i class="iconify tabler--arrow-left me-1"></i> Continue Shopping </a></div>
      <div class="rounded bg-info/15 text-info mt-9 p-7.5">
        <h4 class="text-dark mb-1.25 pb-3 text-center text-lg">🎁 Great News! You’ve unlocked 25% off your next order!</h4>
        <div class="mx-auto flex gap-3"><input type="text" class="form-input" value="SAVE25NOW" readonly /><button type="button" class="btn text-nowrap bg-dark text-white hover:bg-dark-hover">Copy Code</button></div></div>
    </div></div>
    <div class="mt-5 flex flex-wrap items-center justify-between">
      <button type="button" class="btn bg-secondary text-white hover:bg-secondary-hover" data-hs-stepper-back-btn><i class="iconify tabler--arrow-left"></i> Back </button>
      <button type="button" class="btn bg-primary text-white hover:bg-primary-hover" data-hs-stepper-next-btn> Next <i class="iconify tabler--arrow-right"></i></button></div>
  </div>
</div>
```

Right column summary row: `<div class="mb-5 flex items-center gap-base"><img src="…" class="me-1.25 rounded" width="42" /><div><p class="mb-1.25 font-semibold"><a href="#" class="hover:text-primary">Apple MacBook Air M3 13”</a></p><p class="text-default-400 block">1 x $1,199</p></div><h5 class="ms-auto">$1,199</h5></div>` then the same `<ul>` totals as Cart.

**Init / JS.** `assets/js/pages/form-inputmask.js`:

```js
document.querySelectorAll('[data-toggle="input-mask"]').forEach(el => {
  new Inputmask(el.getAttribute("data-mask-format").replace(/0/g, "9")).mask(el);  // "0000 0000" → "9999 9999"
});
```

**Gotchas.**
- Preline stepper: `li.active` + `data-hs-stepper-nav-item='{"index":n}'` and matching
  `data-hs-stepper-content-item='{"index":n}'` (content items start `display:none`; Preline shows the active
  one). `hs-stepper-active:` / `hs-stepper-success:` variants style current and completed steps. Default mode
  is linear (Next/Back only); add `data-hs-stepper='{"mode":"non-linear"}'` to allow clicking any step. The
  demo has no `data-hs-stepper-finish-btn`; add one on the last step or hide "Next" there.
- The saved-address card puts `peer-checked:border-primary` on the *parent* of the `peer` input; Tailwind's
  `peer-*` only targets later *siblings*, so the border highlight never fires as written. Move the highlight
  to the `<label>` (a sibling after the input), or use Tailwind v4's `has-checked:border-primary` on the
  wrapper — that variant is not in the demo's compiled CSS, so it only works in your own build.
- Inputmask runs on `DOMContentLoaded`; mask format uses `0` for digits (converted to Inputmask's `9`).
- The 200-option country `<select>` appears twice in the page — generate it, don't paste it.

## Sellers

**What it is.** Vendor directory (`container`): `[data-table]` with three *numeric range* filters (Orders,
Revenue, Ratings) and rows-per-page. Columns: seller (logo avatar + "Since 2005"), products, orders, rating
stars + `(4.5)`, location flag badge, balance, rank (`1st`), and a "Report" sparkline column rendered by
ApexCharts from `data-chart="apex" data-chart-type="bar|line"`.

**Use it when.**
- Marketplace vendors, affiliates, partners, sales reps, franchise branches, agents — any ranked party list
  with a trend column.
- The sparkline column pattern suits any table where a mini trend per row adds context (KPIs per team).

**Source.** `references/sources/pages/apps-ecommerce-sellers.html` + `custom-table.js` +
`assets/js/pages/ecommerce-product-views.js` + `assets/plugins/apexcharts/apexcharts.min.js`.

**Markup.**

```html
<div class="flex flex-wrap items-center gap-2.5 md:flex-nowrap"><span class="me-2.5 font-semibold text-nowrap">Filter By:</span>
  <div class="input-icon-group"><i class="iconify tabler--shopping-cart input-icon"></i>
    <select data-table-range-filter="orders" class="form-select"><option value="All">Orders</option><option value="20000+">Top Orders</option><option value="0-20000">Low Orders</option><option value="0">No Orders</option></select></div>
  <div class="input-icon-group"><i class="iconify tabler--currency-dollar input-icon"></i>
    <select data-table-range-filter="revenue" class="form-select"><option value="All">Revenue</option><option value="100k+">Top Revenue</option><option value="50k-100k">Low Revenue</option></select></div>
  <div class="input-icon-group"><i class="iconify tabler--star input-icon"></i>
    <select data-table-range-filter="rating" class="form-select"><option value="All">Ratings</option><option value="4-5">Top Rated</option><option value="1-3">Low Rated</option></select></div>
</div>

<thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
  <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
  <th data-table-sort>Seller</th><th data-table-sort>Products</th><th data-table-sort data-column="orders">Orders</th><th data-table-sort>Rating</th>
  <th data-table-sort>Location</th><th data-table-sort data-column="revenue">Balance</th><th data-table-sort>Rank</th><th class="w-[1%]">Report</th></tr></thead>
<tbody>
  <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
    <td><div class="flex items-center gap-base"><img src="assets/images/sellers/3.png" alt="" class="size-9 rounded-full" />
      <div><h5 class="mb-1.25"><a data-sort="seller" href="#!" class="hover:text-primary font-medium">GreenTech Solutions</a></h5><p class="text-default-400 text-2xs">Since 2005</p></div></div></td>
    <td>1,456</td><td>18,120</td>
    <td><div class="flex items-center gap-1"><i class="iconify tabler--star-filled text-warning"></i><!-- x4 --><i class="iconify tabler--star text-warning"></i>
      <span><a data-sort="rating" href="apps-ecommerce-reviews.html" class="hover:text-primary ms-1.25 font-semibold">(4.5)</a></span></div></td>
    <td><div class="badge p-1.25 text-sm bg-light"><img src="assets/images/flags/ca.svg" alt="" class="me-1.25 size-3 rounded-full" /> CA </div></td>
    <td>$92.5k</td><td>1st</td>
    <td><div class="flex justify-center" data-chart="apex" data-chart-type="bar"></div></td></tr>
</tbody>
```

**Init / JS.** `ecommerce-product-views.js` renders one random 15-point sparkline per `[data-chart="apex"]`
(see Product Views for the options). Replace `generateRandomData()` with real series, e.g. from
`data-series="12,18,9,…"`.

**Gotchas.**
- The Ratings filter has no `th[data-column="rating"]` in the demo, so it is ignored; add `data-column="rating"`
  to the Rating `<th>`. Range math strips units, so `100k+` vs `$92.5k` compares 100 vs 92.5 — consistent as long
  as every cell uses `k`.
- Rank cells like `1st` sort numerically (ordinal parsing).
- Charts render once at load; the engine moves `<tr>` nodes, so the SVGs survive paging and sorting.

## Seller Details

**What it is.** Vendor profile, `container-fluid` + `lg:grid-cols-4`: left sticky card (logo, name, "Since
2017", dots dropdown; info rows with `btn-icon bg-light` icon chips for owner, business type, founded,
location, support email, website; "Contact Seller" textarea + Send); right `lg:col-span-3`: four Tile-D KPIs,
"Seller Overview" mixed chart (`#seller-revenue`: Orders area, Earnings bar, Refunds dashed line) and a
"My Products" `[data-table]`.

**Use it when.**
- Vendor / partner / branch / agent / client-account profile with its own KPIs, trend and owned records.
- Non-shop: a team page (members table), a supplier page (POs table), a property owner page (listings table).

**Source.** `references/sources/pages/apps-ecommerce-seller-details.html` + `assets/js/pages/ecommerce-seller-details.js`
+ `apexcharts.min.js` + `custom-table.js`.

**Markup.** Profile card + chart card (KPIs = Tile D, table = Products list without filters):

```html
<div class="container-fluid"><div class="grid grid-cols-1 lg:grid-cols-4 gap-base">
  <div>
    <div class="card lg:sticky lg:top-22">
      <div class="card-body">
        <div class="bg-light/15 border-light flex items-center justify-between gap-2 rounded border p-2.5">
          <div class="md:flex items-center gap-base">
            <div class="size-12"><img src="assets/images/sellers/1.png" alt="" class="img-fluid rounded-full" /></div>
            <div><h4 class="font-bold whitespace-nowrap mb-1.25">MacHub Retailers</h4><p class="text-default-400 text-sm">Since 2017</p></div></div>
          <div class="relative ms-auto"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
            <button type="button" class="hs-dropdown-toggle btn btn-sm btn-icon bg-light text-dark" aria-haspopup="menu" aria-expanded="false"><i class="iconify tabler--dots text-2xl"></i></button>
            <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#">Edit profile</a><a class="dropdown-item text-danger" href="#">Report</a></div></div></div></div>
        </div>
        <div class="mt-5">
          <div class="mb-2.5 flex items-center gap-2.5"><div class="btn btn-icon bg-light size-8"><i class="iconify tabler--user text-default-400 text-lg"></i></div>
            <p class="text-sm"> Owner: <span class="font-semibold">Sophie Martinez</span></p></div>
          <!-- tabler--briefcase Business Type · tabler--calendar Founded · tabler--map-pin Location · tabler--mail Support (link text-primary) · tabler--world Website -->
        </div>
      </div>
      <div class="card-body border-default-300 border-t border-dashed">
        <h5 class="mb-5">Contact Seller</h5>
        <textarea class="form-textarea mb-base" rows="4" placeholder="Enter your messages..."></textarea>
        <div class="text-end"><button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Send Messages</button></div>
      </div>
    </div>
  </div>
  <div class="lg:col-span-3">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-base mb-base"><!-- 4 × Tile D: Orders bg-success tabler--shopping-cart, Revenue bg-warning tabler--currency-dollar, Ratings bg-info tabler--star, Products bg-secondary tabler--box --></div>
    <div class="card">
      <div class="card-header"><h4 class="card-title">Seller Overview</h4></div>
      <div class="card-body pb-0"><div id="seller-revenue"></div></div>
    </div>
    <h4 class="my-7.5 text-lg">My Products</h4>
    <div data-table data-table-rows-per-page="8" class="card"><!-- search, delete, rows-per-page, Add Product; columns Product | Category | Stock | Price | Orders | Status | Actions --></div>
  </div>
</div></div>
```

**Init / JS.** `assets/js/pages/ecommerce-seller-details.js`:

```js
new CustomApexChart({ selector: "#seller-revenue", options: () => ({
  series: [{ name: "Orders", type: "area", data: [/*12*/] }, { name: "Earnings", type: "bar", data: [/*12*/] }, { name: "Refunds", type: "line", data: [/*12*/] }],
  chart: { height: 370, type: "line", toolbar: { show: false } },
  stroke: { curve: "straight", dashArray: [0, 0, 8], width: [2, 0, 2.2] }, fill: { opacity: [0.1, 0.9, 1] },
  markers: { size: [0, 0, 0], strokeWidth: 2, hover: { size: 4 } },
  xaxis: { categories: ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"], axisTicks: { show: false }, axisBorder: { show: false } },
  grid: { show: true, xaxis: { lines: { show: true } }, yaxis: { lines: { show: false } }, padding: { top: 0, right: 0, bottom: 10, left: 0 } },
  legend: { show: true }, plotOptions: { bar: { columnWidth: "30%", barHeight: "70%", borderRadius: 5 } },
  colors: ["#1ab394", "#308fcb", "#f9b367"],
  tooltip: { shared: true, y: [{ formatter: v => v !== undefined ? v.toFixed(0) + " Sales" : v }, { formatter: v => v !== undefined ? "$" + v.toFixed(2) + "k" : v }, { formatter: v => v !== undefined ? v.toFixed(0) + " Sales" : v }] }
}) });
```

**Gotchas.**
- `CustomApexChart` (app.js) takes `options` as a *function* so it can re-render on theme/skin/RTL changes
  (a `MutationObserver` on `<html>` calls `rerenderAll()`); pass `colors` via `theme("primary")` or
  `data-colors="primary,secondary"` on the element to get token colours instead of hex.
- `lg:sticky lg:top-22` keeps the profile card pinned; the demo's "5k Reviewsk" is a typo, not a class.

## Refunds

**What it is.** Approval queue: five Tile-C KPIs (Total requests, Approved, Pending, Rejected, Fully
Refunded) and a `[data-table]` with a refund-status filter and a "Create Refund" modal (`#createRefundModal`).
Columns: order id, product (thumb + SKU), customer, reason, payment (card logo + last 4), amount, status
badge, requested, processed, and actions = approve ✓ / reject ✗ / delete + a "more" dropdown (View order,
Contact customer, Add note).

**Use it when.**
- Refunds, returns/RMAs, chargebacks, expense claims, leave requests, access requests, content moderation —
  any approve/reject queue with an audit of request vs. decision dates.
- The create modal (select the parent record → read-only derived field → reason → method → amount → date)
  is the pattern for "raise a request against an existing record".

**Source.** `references/sources/pages/apps-ecommerce-refunds.html` + `custom-table.js`.

**Markup.** Tile C, the row actions and the modal body:

```html
<div class="card"><div class="card-body">                                                   <!-- Tile C -->
  <div class="mb-5 flex items-center gap-2.5">
    <div class="size-9 flex items-center justify-center bg-primary rounded-full"><i class="iconify tabler--credit-card-refund size-5.5 text-white"></i></div>
    <h3 class="text-xl"><span data-target="2,310">0</span></h3></div>
  <div class="flex items-center justify-between"><div class="flex items-center gap-1"><span>Total Refund Requests</span></div>
    <span class="badge font-semibold bg-primary/15 text-primary">+5.42%</span></div>
</div></div>
<!-- bg-success tabler--check Approved · bg-warning tabler--alarm-snooze Pending · bg-danger tabler--x Rejected · bg-info tabler--bolt Fully Refunded -->

<select data-table-filter="refund-status" class="form-select"><option value="All">Refund Status</option><option value="Pending">Pending</option><option value="Approved">Approved</option><option value="Rejected">Rejected</option><option value="Refunded">Refunded</option></select>
<a href="#" class="btn bg-primary text-white hover:bg-primary-hover" data-hs-overlay="#createRefundModal"><i class="iconify tabler--plus"></i> Create Refund </a>

<tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
  <td><h5 class="text-sm"><a href="apps-ecommerce-order-details.html" class="hover:text-primary">#INV-10423</a></h5></td>
  <td><div class="flex items-center gap-2.5"><div><img src="assets/images/products/1.png" alt="" class="size-8 rounded-full" /></div>
    <div><p class="font-medium">NoiseCancel Headphones</p><p class="text-default-400 text-xs">SKU: NC-900</p></div></div></td>
  <td><div class="flex items-center gap-2.5"><div><img src="assets/images/users/user-2.jpg" alt="" class="size-8 rounded-full" /></div>
    <div><h5 data-sort="customer" class="font-medium">Mason Carter</h5><p class="text-default-400 text-xs">mason.carter@shopmail.com</p></div></div></td>
  <td>Damaged on arrival</td>
  <td><div class="flex items-center gap-3"><img src="assets/images/cards/visa.svg" alt="" class="h-7" /> xxxx 7832 </div></td>
  <td>$129.45</td><td><span class="badge font-semibold badge-label bg-warning/15 text-warning">Pending</span></td><td>08 Oct 2025</td><td>-</td>
  <td><div class="flex justify-center gap-1.5">
    <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--check text-base"></i></a>
    <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400"><i class="iconify tabler--x text-base"></i></a>
    <a href="#" class="btn btn-icon btn-sm border border-default-300 hover:border-default-400" data-table-delete-row><i class="iconify tabler--trash text-base"></i></a>
    <div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
      <button type="button" class="hs-dropdown-toggle btn btn-icon btn-sm border border-default-300 hover:border-default-400" aria-haspopup="menu" aria-expanded="false"><i class="iconify tabler--dots-vertical text-base"></i></button>
      <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#">View order</a><a class="dropdown-item" href="#">Contact customer</a><hr class="dropdown-divider" /><a class="dropdown-item" href="#">Add note</a></div></div>
    </div></div></td></tr>

<!-- #createRefundModal (md:max-w-lg) body -->
<div class="mb-5"><label for="refundOrderId" class="form-label"> Order ID </label>
  <select id="refundOrderId" class="form-select"><option selected disabled>Select Order</option><option>#INV-10423</option></select></div>
<div class="mb-5"><label for="refundCustomer" class="form-label"> Customer </label><input id="refundCustomer" type="text" class="form-input" value="Mason Carter" readonly /></div>
<div class="mb-5"><label for="refundReason" class="form-label"> Reason </label><textarea id="refundReason" class="form-textarea" rows="2" placeholder="Enter refund reason (e.g., damaged item, wrong product, etc.)"></textarea></div>
<div class="mb-5"><label for="refundMethod" class="form-label"> Refund Method </label>
  <select id="refundMethod" class="form-select"><option selected>Original Payment Method (Visa ****7832)</option><option>Store Credit</option><option>Bank Transfer</option></select></div>
<div class="mb-5"><label for="refundAmount" class="form-label"> Refund Amount </label>
  <div class="input-group"><span class="input-group-text"> $ </span><input id="refundAmount" type="number" class="form-input" value="129.45" /></div></div>
<div><label for="refundDate" class="form-label"> Refund Date </label><input id="refundDate" type="date" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" value="2025-10-08" /></div>
<!-- footer: btn bg-default-200 Close · btn bg-primary text-white "Confirm Refund" with tabler--check -->
```

Status vocabulary: `Pending` warning · `Approved` success · `Rejected` danger · `Refunded` secondary.

**Gotchas.**
- The ✓ / ✗ buttons are plain links in the demo — wire them to change the badge and move the row, or they
  do nothing. Only the trash icon on the first row carries `data-table-delete-row` (demo inconsistency).
- Row dropdowns are Preline `hs-dropdown`; because the table scrolls horizontally inside `.table-wrapper`,
  a menu near the right edge may clip — Preline positions with Floating UI, so it usually flips, but test.
- Requested/Processed columns are not sortable in the demo; add `data-table-sort` (dates parse fine).

## Reviews

**What it is.** Moderation page (`container`): one `[data-table]` card whose top band holds the rating
summary (4.92 score, "Based on 245 verified reviews", `+12 new this week` badge, 5→1-star distribution
bars) beside a 30-day ApexCharts area chart (`#reviews-30days-chart`); then a header with search, bulk
delete, rows-per-page, Export dropdown and a "View All" status dropdown; then rows: product (thumb + name),
reviewer (avatar + email), review (stars + title + quoted text), date, Published/Pending badge, actions.

**Use it when.**
- Product reviews, app-store ratings, seller feedback, course evaluations, NPS comments, testimonial approval.
- The summary band alone is a reusable "score + histogram + trend" header for any rated entity.

**Source.** `references/sources/pages/apps-ecommerce-reviews.html` + `assets/js/pages/ecommerce-reviews.js`
+ `apexcharts.min.js` + `custom-table.js`.

**Markup.** Summary band + one review row:

```html
<div data-table data-table-rows-per-page="5" class="card">
  <div class="border-default-300 border-b border-dashed">
    <div class="grid grid-cols-1 lg:grid-cols-2">
      <div class="border-default-300 grid grid-cols-12 border-e border-dashed">
        <div class="col-span-7">
          <div class="flex items-center gap-base p-7.5 md:gap-7.5"><img src="assets/images/ratings.svg" alt="" class="h-20" />
            <div class="flex flex-col gap-y-2.5">
              <h3 class="flex items-center gap-2.5 text-xl font-bold"> 4.92 <i class="iconify tabler--star-filled text-xl text-warning"></i></h3>
              <p>Based on 245 verified reviews</p>
              <p class="text-default-400 text-xs font-medium">Feedback collected from real customers who purchased our templates</p>
              <div><span class="badge badge-label bg-success/15 font-semibold text-success">+12 new this week</span></div></div></div>
        </div>
        <div class="col-span-5"><div class="space-y-2.5 mt-2 p-5">
          <div class="flex items-center gap-2.5">                                                             <!-- 5 Star … 1 Star -->
            <p class="text-sm text-nowrap min-w-12.5">5 Star</p>
            <div class="bg-default-100 flex h-2 w-full overflow-hidden rounded-full" role="progressbar" aria-valuenow="85" aria-valuemin="0" aria-valuemax="100">
              <div class="bg-primary flex flex-col justify-center overflow-hidden rounded-s-full text-center text-xs whitespace-nowrap text-white transition duration-500" style="width: 85%"></div></div>
            <div class="text-end"><span class="badge bg-light text-dark font-semibold">128</span></div></div>
        </div></div>
      </div>
      <div class="ps-1.5 pe-6"><div id="reviews-30days-chart"></div></div>
    </div>
  </div>
  <div class="card-header">
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search reviews..." class="form-input w-full ps-10" /></div>
      <button data-table-delete-selected class="btn bg-danger text-white hover:bg-danger-hover hidden">Delete</button></div>
    <div class="ms-auto"><div class="flex items-center gap-2.5">
      <select data-table-set-rows-per-page class="form-select"><option value="5">5</option><option value="10">10</option></select>
      <!-- Export hs-dropdown (as Customers) -->
      <div class="relative"><div class="hs-dropdown relative inline-flex [--placement:bottom-right]">
        <button type="button" class="hs-dropdown-toggle btn border-default-300 text-default-800 hover:bg-default-100 border text-nowrap" aria-haspopup="menu" aria-expanded="false"> View All <i class="iconify tabler--chevron-down text-sm"></i></button>
        <div class="hs-dropdown-menu" role="menu"><div class="space-y-0.5"><a class="dropdown-item" href="#">All</a><a class="dropdown-item" href="#">Pending</a><a class="dropdown-item" href="#">Approved</a><a class="dropdown-item" href="#">Disabled</a></div></div></div></div>
    </div></div>
  </div>
  <div class="table-wrapper"><table class="table table-hover">
    <thead class="border-default-300 bg-default-100/50 text-2xs text-default-700 border-b border-dashed font-medium uppercase">
      <tr><th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
        <th data-table-sort="product">Product</th><th data-table-sort="reviewer">Reviewer</th><th>Review</th><th data-table-sort>Date</th><th data-table-sort>Status</th><th>Actions</th></tr></thead>
    <tbody>
      <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
        <td><div class="flex items-center gap-base"><img src="assets/images/products/2.png" alt="" class="size-11 rounded" /><h5><a data-sort="product" href="#" class="hover:text-primary">Wireless Earbuds</a></h5></div></td>
        <td><div class="flex items-center gap-2.5"><div class="size-8"><img src="assets/images/users/user-8.jpg" alt="" class="h-full w-full rounded-full object-cover" /></div>
          <div><h5 data-sort="reviewer" class="text-sm leading-tight font-medium">Sophia Lee</h5><p class="text-default-400 text-xs">sophia.lee@digitalshop.com</p></div></div></td>
        <td><div class="text-warning flex items-center gap-1 text-base"><i class="iconify tabler--star-filled text-warning"></i><!-- x5 --></div>
          <h5 class="text-default-800 mt-2.5 mb-2 text-sm font-medium">Great product, would buy again!</h5>
          <p class="text-default-400 w-xs text-sm italic">"These earbuds are amazing, the sound quality is top-notch."</p></td>
        <td><span class="flex items-center gap-1"> 22 Apr, 2025 <span class="text-default-400 block text-xs">04:10 PM</span></span></td>
        <td><span class="badge text-2xs font-semibold bg-success/15 text-success">Published</span></td>
        <td><!-- action trio --></td></tr>
    </tbody></table></div>
  <div class="card-footer"><div data-table-pagination-info="reviews"></div><div data-table-pagination></div></div>
</div>
```

**Init / JS.** `assets/js/pages/ecommerce-reviews.js`:

```js
new CustomApexChart({ selector: "#reviews-30days-chart", options: () => ({
  chart: { type: "area", height: 185, toolbar: { show: false } }, grid: { padding: { top: 0, right: 0, bottom: 0, left: 0 } },
  series: [{ name: "Reviews", data: [5,8,6,7,10,12,9,14,11,15,17,19,14,13,16,18,22,20,19,17,15,18,20,23,21,22,24,26,25,28] }],
  xaxis: { categories: Array.from({ length: 30 }, (_, i) => "" + (i + 1)), labels: { rotate: -45, style: { fontSize: "10px" } } },
  colors: ["#1ab394"], fill: { opacity: 0.3 }, stroke: { curve: "smooth", width: 2 }, dataLabels: { enabled: false },
  tooltip: { y: { formatter: v => v + " Reviews" } } }) });
```

**Gotchas.**
- The "View All" dropdown is decorative — to actually filter, replace it with
  `<select data-table-filter="status">` and give the Status `<th>` `data-column="status"`.
- The review cell uses `w-xs` to cap quote width; the table header here is a custom `thead` style, not `thead-sm`.
- `aria-valuenow` is hard-coded to 25 in the demo bars; set it to the real percentage.

## Warehouse

**What it is.** Facility list (`container-fluid`, 10 rows/page): filters by warehouse status and location,
"Add New" opens `#addWarehouseModal` (ID, name, location, manager, email, phone, area, capacity, current
stock, asset value with `$` input-group, status). Columns: ID, name, location (pin icon), manager (avatar +
email), contact `tel:` link, capacity, available stock, stock shipping, revenue, Operational / Maintenance /
Closed badge, actions.

**Use it when.**
- Warehouses, stores, branches, data centres, clinics, depots, fleets — any multi-location registry with a
  responsible person and capacity figures.
- Non-shop: venues for an events app, classrooms for a school, sites for a construction firm.

**Source.** `references/sources/pages/apps-ecommerce-warehouse.html` + `custom-table.js`.

**Markup.**

```html
<div class="items-center gap-2.5 md:flex"><span class="text-default-800 font-semibold text-nowrap me-2.5">Filter By:</span>
  <div class="input-icon-group"><i class="iconify tabler--building input-icon"></i>
    <select data-table-filter="warehouse-status" class="form-select"><option value="All">Warehouse Status</option><option value="Operational">Operational</option><option value="Maintenance">Under Maintenance</option><option value="Closed">Closed</option></select></div></div>
<div class="input-icon-group"><i class="iconify tabler--map-pin input-icon"></i>
  <select data-table-filter="warehouse-location" class="form-select"><option value="All">Location</option><option value="New York, USA">New York</option><option value="Berlin, Germany">Berlin</option></select></div>
<a href="#addWarehouseModal" class="btn bg-danger text-white hover:bg-danger-hover" data-hs-overlay="#addWarehouseModal"><i class="iconify tabler--plus"></i> Add New </a>

<table class="table-custom table table-hover">
  <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
    <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
    <th data-table-sort>ID</th><th data-table-sort>Name</th><th data-table-sort data-column="warehouse-location">Location</th><th data-table-sort>Manager</th><th data-table-sort>Contact</th>
    <th data-table-sort>Capacity</th><th data-table-sort>Avai. Stock</th><th data-table-sort>Stock Shipping</th><th data-table-sort>Revenue</th><th data-table-sort data-column="warehouse-status">Status</th><th class="text-center w-[1%]">Actions</th></tr></thead>
  <tbody>
    <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
      <td><h5 class="text-sm">#WH-001</h5></td><td>Central Distribution Hub</td>
      <td><div class="flex items-center gap-2.5"><i class="iconify tabler--map-pin text-default-500"></i><span>New York, USA</span></div></td>
      <td><div class="flex items-center gap-2.5"><div class="size-8"><img src="assets/images/users/user-1.jpg" alt="" class="rounded-full" /></div>
        <div><h6 class="text-xs font-semibold">Olivia Brown</h6><p class="text-default-400 text-xs">olivia.brown@company.com</p></div></div></td>
      <td><a href="tel:+14165559876">+1 416 555 9876</a></td><td>95,000 sq.ft</td><td>38,240 units</td><td>12,680 units</td><td>$1.28M</td>
      <td><span class="badge text-2xs font-semibold bg-success/15 text-success">Operational</span></td>
      <td><!-- action trio --></td></tr>
  </tbody>
</table>

<!-- #addWarehouseModal body: md:grid-cols-2 gap-base of form-input fields; asset value uses -->
<div><label for="warehouseValue" class="form-label"> Asset Value </label>
  <div class="input-group"><span class="input-group-text"> $ </span><input type="number" id="warehouseValue" class="form-input" placeholder="1.25M" /></div></div>
<div><label for="warehouseStatus" class="form-label"> Status </label>
  <select id="warehouseStatus" class="form-input"><option selected>Operational</option><option>Under Maintenance</option><option>Closed</option></select></div>
<!-- header icon: <i class="iconify tabler--building text-danger me-2.5"></i>; footer: Close + btn bg-danger "Save Warehouse" with tabler--check -->
```

**Gotchas.**
- Filter values must equal cell text: the demo filter option `Maintenance` matches the badge text
  `Maintenance`, but the modal offers "Under Maintenance" — normalise one label.
- Location filter compares the whole cell (`New York, USA`), so option values carry the full string while
  labels stay short.
- Numeric columns with units (`95,000 sq.ft`, `$1.28M`) sort correctly thanks to the K/M/B parser.

## Product Stocks

**What it is.** Inventory levels (`container-fluid`, 10 rows/page): filters by category, stock status and
unit-price range; "Add Product" link. Columns: product (thumb + supplier), SKU, category, available stock
(green number), low-stock threshold (red/amber number), unit price, In Stock / Low Stock / Out of Stock
badge, last updated, actions.

**Use it when.**
- Stock levels, licence seats, consumables, spare parts, blood bank, library copies — anything with a
  quantity-on-hand and a reorder threshold.
- Use Warehouse for *where* stock is; use this for *how much* per SKU. Combine with Purchased Orders for
  replenishment.

**Source.** `references/sources/pages/apps-ecommerce-product-stocks.html` + `custom-table.js`.

**Markup.**

```html
<select data-table-filter="category" class="form-select"><option value="All">Category</option><option value="Electronics">Electronics</option><option value="Audio">Audio</option></select>
<select data-table-filter="status" class="form-select"><option value="All">Stock Status</option><option value="In Stock">In Stock</option><option value="Low Stock">Low Stock</option><option value="Out of Stock">Out of Stock</option></select>
<select data-table-range-filter="price" class="form-select"><option value="All">Price Range</option><option value="0-50">$0 - $50</option><option value="501-1000">$501 - $1,000</option><option value="1000+">$1,000+</option></select>

<table class="table-custom table table-hover">
  <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
    <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
    <th data-table-sort>Product</th><th>SKU</th><th data-table-sort data-column="category">Category</th><th data-table-sort>Available Stock</th><th data-table-sort>Low Stock</th>
    <th data-table-sort data-column="price">Unit Price</th><th data-table-sort data-column="status">Stock Status</th><th data-table-sort>Last Updated</th><th class="text-center w-[1%]">Actions</th></tr></thead>
  <tbody>
    <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
      <td><div class="flex items-center"><div class="me-base size-9"><img src="assets/images/products/1.png" alt="" class="rounded" /></div>
        <div><h5 class="mb-1.25"><a data-sort="product" href="apps-ecommerce-product-details.html" class="hover:text-primary">Smart LED TV 55"</a></h5>
          <p class="text-default-400 text-xs">Supplier: VisionTech</p></div></div></td>
      <td>STK-1001</td><td>Electronics</td>
      <td class="text-success px-2.25 py-3 font-semibold">320</td>          <!-- on hand -->
      <td class="text-danger px-2.25 py-3 font-semibold">24</td>            <!-- threshold; text-warning when close -->
      <td>$749.00</td>
      <td><span class="badge badge-label font-semibold text-2xs bg-success/15 text-success">In Stock</span></td>
      <td> 08 Oct, 2025 <small class="text-default-400 text-2xs">10:30 AM</small></td>
      <td><!-- action trio --></td></tr>
  </tbody>
</table>
```

If you want a visual fill level instead of coloured numbers, drop in the Reviews distribution bar
(`bg-default-100 h-2 rounded-full` track + `bg-primary` fill with `style="width: n%"`) and colour the fill
`bg-success` / `bg-warning` / `bg-danger` by threshold — the demo does not ship stock bars.

**Gotchas.**
- The "Product" header has `data-table-sort` without a key while the cell has `data-sort="product"`; that is
  fine — the first text node in the cell is the product name.
- `badge-label` makes the status square-cornered; mix it with the rounded `badge` elsewhere only on purpose.

## Purchased Orders

**What it is.** Procurement list (`container-fluid`, 10 rows/page): payment-status and order-status filters,
"Add New" opens `#addPurchaseOrderModal` (PO number, supplier name/email, items count, order & delivery date
flatpickrs, total amount `$` input-group, payment status, order status, notes). Columns: PO number, supplier
(name + email), items, order date, delivery date ("Expected"), total, payment badge, order-status badge, actions.

**Use it when.**
- Purchase orders, supplier invoices, incoming shipments, vendor contracts, grant disbursements — any record
  with a money state *and* a fulfilment state.
- Mirror of Orders for the buying side; same list engine, same badge vocabulary.

**Source.** `references/sources/pages/apps-ecommerce-purchased-orders.html` + `custom-table.js`.

**Markup.**

```html
<select data-table-filter="payment-status" class="form-select"><option value="All">Payment Status</option><option value="Paid">Paid</option><option value="Pending">Pending</option><option value="Unpaid">Unpaid</option><option value="Overdue">Overdue</option></select>
<select data-table-filter="order-status" class="form-select"><option value="All">Order Status</option><option value="Completed">Completed</option><option value="Processing">Processing</option><option value="Partially Received">Partially Received</option><option value="Pending Delivery">Pending Delivery</option><option value="Awaiting Shipment">Awaiting Shipment</option><option value="Cancelled">Cancelled</option><option value="In Progress">In Progress</option></select>
<a href="#addPurchaseOrderModal" class="btn bg-danger text-white hover:bg-danger-hover" data-hs-overlay="#addPurchaseOrderModal"><i class="iconify tabler--plus"></i> Add New </a>

<thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
  <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
  <th data-table-sort>PO Number</th><th data-table-sort>Supplier</th><th data-table-sort>Items</th><th data-table-sort>Order Date</th><th data-table-sort>Delivery Date</th><th data-table-sort>Total Amount</th>
  <th data-table-sort data-column="payment-status">Payment Status</th><th data-table-sort data-column="order-status">Order Status</th><th class="text-center w-[1%]">Actions</th></tr></thead>
<tbody>
  <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
    <td><a href="#!" class="hover:text-primary font-semibold">PO-2025-0148</a></td>
    <td><div><h6>TechVision Supplies</h6><p class="text-default-400 text-xs">techvision@email.com</p></div></td>
    <td>12 Items</td><td> 05 Oct, 2025 <small class="text-default-400 text-2xs">09:15 AM</small></td><td> 10 Oct, 2025 <small class="text-default-400 text-2xs">Expected</small></td>
    <td><h5>$3,480.00</h5></td>
    <td><span class="badge py-0.5 font-semibold text-2xs badge-label bg-success/15 text-success">Paid</span></td>
    <td><span class="badge py-0.5 font-semibold text-2xs badge-label bg-primary/15 text-primary">Received</span></td>
    <td><!-- action trio --></td></tr>
</tbody>

<!-- #addPurchaseOrderModal body (md:grid-cols-2): poNumber, supplierName, supplierEmail, poItems (number),
     orderDate / deliveryDate: <input type="date" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" value="2025-10-05" />
     totalAmount: input-group "$" + <input type="number" step="0.01">, paymentStatus select (Paid/Pending/Partially Paid/Unpaid),
     orderStatus select (Received/Processing/Dispatched/Cancelled), poNotes textarea (md:col-span-2) -->
```

Vocabulary used: payment `Paid` success · `Pending` warning · `Unpaid` / `Overdue` danger; order
`Completed` success · `Received` primary · `Processing` / `In Progress` / `Awaiting Delivery` info ·
`Partially Received` / `Pending Delivery` warning · `Awaiting Shipment` secondary · `Cancelled` danger.

**Gotchas.**
- The filter list and the modal's status options disagree (Received/Dispatched vs. Completed/Awaiting…);
  decide one enum and reuse it for badges, filter and form.
- "Items" cells read `12 Items` — numeric sort still works because the parser reads the leading number.

## Product Views (analytics table)

**What it is.** Per-product performance report (`container`): `[data-table]` with a "Sales Performance"
range filter on the Orders column; columns product, SKU, price, rating, views, orders, conversion %, and a
"Report" sparkline column (`data-chart="apex" data-chart-type="bar|line"`).

**Use it when.**
- Product/page/campaign/article analytics tables: views → conversions with a trend per row.
- Any leaderboard where a mini chart per row helps (agents, SKUs, ad sets, API endpoints).

**Source.** `references/sources/pages/apps-ecommerce-product-views.html` + `custom-table.js` +
`assets/js/pages/ecommerce-product-views.js` + `apexcharts.min.js`.

**Markup.**

```html
<select data-table-range-filter="performance" class="form-select"><option value="All">Sales Performance</option><option value="1000+">Top Selling</option><option value="1-1000">Low Selling</option><option value="0">No Sales</option></select>

<thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
  <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
  <th data-table-sort>Product</th><th data-table-sort>SKU</th><th data-table-sort>Price</th><th data-table-sort="rating">Rating</th><th data-table-sort>Views</th>
  <th data-table-sort data-column="performance">Orders</th><th data-table-sort>Conversation</th><th class="text-start">Report</th></tr></thead>
<tbody>
  <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" value="option" /></td>
    <td><div class="flex items-center gap-base w-full"><div><img src="assets/images/products/2.png" alt="" class="size-9 rounded" /></div><h5><a data-sort="product" href="#!" class="hover:text-primary">Smart Fitness Watch</a></h5></div></td>
    <td>FW-54201</td><td>$129.99</td>
    <td><div class="flex items-center gap-1"><i class="iconify tabler--star-filled text-warning"></i><!-- x4 --><i class="iconify tabler--star text-warning"></i><span><a data-sort="rating" href="#" class="hover:text-primary font-semibold ms-1">(54)</a></span></div></td>
    <td>45.2k</td><td>820</td><td>7.3%</td>
    <td><div data-chart="apex" data-chart-type="bar"></div></td></tr>
</tbody>
```

**Init / JS.** `assets/js/pages/ecommerce-product-views.js` (also loaded by Sellers):

```js
document.querySelectorAll('[data-chart="apex"]').forEach(el => {
  const type = el.getAttribute("data-chart-type") || "bar";
  new CustomApexChart({ selector: el, options: () => ({
    chart: { type, height: 30, width: 100, sparkline: { enabled: true } },
    stroke: { width: type === "line" ? 2 : 0, curve: "smooth" }, plotOptions: { bar: { columnWidth: "50%", borderRadius: 2 } },
    series: [{ data: generateRandomData() /* 15 ints 5..20 */ }], colors: ["#3b82f6"], tooltip: { enabled: false } }) });
});
```

**Gotchas.**
- Demo bug: `data-table-select-all` is on the `<th>`; move it to the checkbox `<input>`.
- `data-table-set-rows-per-page=""` (empty value) still works — the engine only checks presence.
- `45.2k` / `7.3%` sort numerically (k-suffix and percent parsing).
- The demo column is literally labelled "Conversation" — it means conversion.

## Sales Reports

**What it is.** Period report (`container`): a `[data-table]` card whose header holds the title
"Products - 2025", a search box, a flatpickr *range* input (`#dateRangePicker`) and an "Export Report"
button; `card-body` renders `#salesMixChart` (Orders + Refunds + Tax bars, Avg revenue line, Revenue area;
two y-axes); below it a daily table: Date, Orders, Refunds, Avg revenue/order, Tax, Revenue, Balance.

**Use it when.**
- Finance / sales / traffic reports with a chart over the same rows; monthly statement screens; payout
  reports for sellers.
- Non-shop: support volume vs. SLA breaches per day, ad spend vs. conversions, energy usage vs. cost.

**Source.** `references/sources/pages/apps-ecommerce-sales.html` + `assets/js/pages/ecommerce-sales.js`
+ `apexcharts.min.js` + `custom-table.js` (flatpickr from vendors.min.js).

**Markup.**

```html
<div data-table data-table-rows-per-page="8" class="card">
  <div class="card-header flex items-center justify-between">
    <h5 class="card-title">Products - 2025</h5>
    <div class="flex gap-2.5">
      <div class="input-icon-group"><i class="iconify tabler--search input-icon"></i><input data-table-search type="search" placeholder="Search reports..." class="form-input" /></div>
      <div class="input-icon-group"><i class="iconify tabler--calendar input-icon"></i><input type="date" class="form-input" id="dateRangePicker" /></div>
      <button type="submit" class="btn bg-secondary text-white hover:bg-secondary-hover"><i class="iconify tabler--download"></i> Export Report</button></div>
  </div>
  <div class="card-body"><div id="salesMixChart"></div></div>
  <div class="table-wrapper"><table class="table table-hover">
    <thead class="thead-sm"><tr class="bg-light/25 text-2xs uppercase">
      <th class="w-[1%]"><input data-table-select-all class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></th>
      <th data-table-sort>Date</th><th data-table-sort>Order</th><th data-table-sort>Refunds</th><th data-table-sort>Avr. Revenue per Order</th><th data-table-sort>Tax</th><th data-table-sort>Revenue</th><th data-table-sort>Balance</th></tr></thead>
    <tbody>
      <tr><td><input class="form-checkbox form-checkbox-light size-4.5" type="checkbox" /></td><td>10 July, 2025</td><td>68</td><td>4</td><td>$18.60</td><td>$25.78</td><td>$612.70</td><td>$6625.46</td></tr>
    </tbody></table></div>
  <div class="card-footer"><div data-table-pagination-info></div><div data-table-pagination></div></div>
</div>
```

**Init / JS.** `assets/js/pages/ecommerce-sales.js`:

```js
new CustomApexChart({ selector: "#salesMixChart", options: () => ({
  chart: { height: 400, type: "line", stacked: false, toolbar: { show: false } },
  stroke: { width: [0, 0, 2, 2, 2], curve: "smooth" }, plotOptions: { bar: { columnWidth: "40%" } },
  colors: [theme("chart-primary"), theme("chart-alpha"), theme("chart-secondary"), "#bbcae14d"],   // theme(name) → CSS var --color-<name>
  series: [{ name: "Orders", type: "bar", data: [320,402,391,334,390,330] }, { name: "Refunds", type: "bar", data: [20,30,28,22,35,25] },
           { name: "Avg. Revenue/Order", type: "line", data: [15.5,16.2,15.8,16,15.9,16.3] }, { name: "Revenue", type: "area", data: [4960,6512,6182,5344,6201,5379] },
           { name: "Tax", type: "bar", data: [496,651,618,534,620,537] }],
  xaxis: { categories: ["Jan","Feb","Mar","Apr","May","Jun"] },
  yaxis: [{ title: { text: "Orders / Refunds / Avg Revenue", style: { fontSize: "11px", fontWeight: 600 } } },
          { opposite: true, title: { text: "Revenue / Tax", style: { fontSize: "11px", fontWeight: 600 } } }],
  legend: { show: false } }) });

const picker = document.getElementById("dateRangePicker");
picker && flatpickr(picker, { mode: "range", dateFormat: "d M, Y", defaultDate: getCurrentMonthRange() /* [1st, last] of this month */ });
```

**Gotchas.**
- The range picker is initialised by the page script, *not* `data-provider` — do not add `data-provider`
  too or app.js will double-init. `type="date"` is overridden by flatpickr (keep `disableMobile` in mind).
- `theme("chart-primary")` reads `--color-chart-primary` from `:root`; it re-evaluates on theme change because
  `options` is a function.
- Two y-axes: ApexCharts pairs `yaxis[i]` with `series[i]` by index unless each axis names a `seriesName`;
  the demo passes five series and two axes and relies on that default. Set `seriesName` on each axis in
  production so Revenue/Tax reliably land on the right-hand axis.
- Pagination-info has no value here, so the engine prints "entries".

## Shop Settings

**What it is.** Settings hub (`container-fluid`): one card with a Preline stepper used as a *vertical
section nav* — 12 items (General Info, Store Details, Branding, Currency & Tax, Shipping, Payments,
Notifications, Invoices & Receipts, SEO & Legal, Integrations, Backup & Restore, Advanced), each an icon
chip + title + subtitle — and a dashed-border content panel (`md:col-span-2 lg:col-span-3`) holding one
form per section, with Back / Next at the bottom.

**Use it when.**
- Any settings area with many short forms: workspace settings, store config, integration keys, notification
  preferences, legal/SEO, backup.
- Also works as a long onboarding checklist (linear mode) — the same markup is the Checkout stepper turned sideways.
- For plain tabs without "completed" state, the `nav-tabs` pattern from the UI group is lighter.

**Source.** `references/sources/pages/apps-ecommerce-settings.html` (Preline `hs-stepper`, no page script).

**Markup.** Shell, one nav item, two content sections:

```html
<div class="container-fluid"><div class="card"><div class="card-body">
  <div data-hs-stepper='{"mode": "non-linear"}'>
    <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-base">
      <div>
        <ul class="relative flex flex-col gap-1.5">
          <li class="group active" data-hs-stepper-nav-item='{"index": 1}'>                                       <!-- repeat ×12 -->
            <span class="group inline-flex w-full"><span class="hs-stepper-active:bg-light/50 hs-stepper-success:border-s-3 hs-stepper-success:border-success hs-stepper-success:bg-success/10 hs-stepper-success:text-success w-full rounded-md">
              <button type="button" class="block w-full rounded px-4 py-2 disabled:pointer-events-none disabled:opacity-50">
                <span class="flex items-center">
                  <div class="avatar-md"><span class="btn btn-icon size-9 bg-light rounded hs-stepper-success:bg-success/10"><i class="iconify tabler--building-store text-2xl"></i></span></div>
                  <span class="ms-2.5"><span class="block text-start font-semibold mb-0.5">General Info</span>
                    <span class="text-default-400 hs-stepper-success:text-success block text-start text-xs font-semibold">Shop basics</span></span>
                </span></button></span></span></li>
          <!-- tabler--building Store Details · tabler--palette Branding · tabler--pig-money Currency & Tax · tabler--truck Shipping · tabler--credit-card Payments
               tabler--bell Notifications · tabler--file-text Invoices & Receipts · tabler--world SEO & Legal · tabler--plug Integrations · tabler--database Backup & Restore · tabler--settings Advanced -->
        </ul>
      </div>
      <div class="md:col-span-2 lg:col-span-3">
        <div class="md:p-7.5 p-4.5 border border-default-300 border-dashed">
          <div data-hs-stepper-content-item='{"index": 1}'>
            <div class="col-span-1 mb-5 grid lg:grid-cols-2 gap-base">
              <div><label class="form-label">Shop Name</label><input type="text" class="form-input" placeholder="e.g., Vona Store" required /></div>
              <div><label class="form-label">Support Email</label><input type="email" class="form-input" placeholder="support@vona.com" required /></div>
              <div><label class="form-label">Phone</label><input type="tel" class="form-input" placeholder="+1 234 567 8901" /></div>
              <div><label class="form-label">Business Hours</label><input type="text" class="form-input" placeholder="Mon-Fri, 9 AM - 6 PM" /></div>
            </div>
          </div>
          <div data-hs-stepper-content-item='{"index": 4}' style="display: none">
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-base mb-base">
              <div class="col-span-1"><label class="form-label">Default Currency</label><select class="form-select"><option>USD</option><option>EUR</option><option>GBP</option></select></div>
              <div class="col-span-1"><label class="form-label">Tax Rate (%)</label><input type="number" class="form-input" placeholder="e.g., 7.5" /></div>
              <div class="col-span-1 lg:col-span-2"><div class="flex items-center gap-1.5"><input class="form-switch" type="checkbox" checked /><label class="form-check-label">Enable Auto Tax Calculation</label></div></div>
            </div>
          </div>
          <!-- other sections: Branding (type=file ×2, type=color ×2) · Shipping (<select class="form-input h-auto!" multiple>) · Payments (switches + key inputs)
               · Notifications / Invoices (switch rows) · SEO & Legal (meta + url inputs) · Integrations (API ids) · Backup (btn border-primary text-primary w-full + file + switch) · Advanced (switches + script textarea) -->
          <div class="mt-10 flex flex-wrap items-center justify-between">
            <button type="button" class="btn bg-secondary text-white hover:bg-secondary-hover" data-hs-stepper-back-btn><i class="iconify tabler--arrow-left"></i> Back </button>
            <button type="button" class="btn bg-primary text-white hover:bg-primary-hover" data-hs-stepper-next-btn> Next <i class="iconify tabler--arrow-right"></i></button></div>
        </div>
      </div>
    </div>
  </div>
</div></div></div>
```

**Gotchas.**
- The demo nests two steppers: an outer `<div data-hs-stepper>` wrapping nav + content and an inner
  `data-hs-stepper='{"mode":"non-linear"}'` wrapping only the nav; its buttons also carry `data-hs-tab`
  pointing at ids that do not exist. Use the single wrapper shown above (non-linear so sections are clickable)
  and drop the `data-hs-tab`/`role="tab"` attributes.
- Vertical variant uses `hs-stepper-success:border-s-3 … border-success` for the completed-section accent;
  there is no "finish" button — add `data-hs-stepper-finish-btn` or a Save button per section.
- `avatar-md` is not in the CSS; the icon chip is just `btn btn-icon size-9 bg-light rounded`.
- `<select class="form-input h-auto!" multiple>` is how a multi-select keeps the template border while
  growing in height.

## Original sources

- `references/sources/pages/apps-ecommerce-marketplace.html`
- `references/sources/pages/apps-ecommerce-products.html`
- `references/sources/pages/apps-ecommerce-products-grid.html`
- `references/sources/pages/apps-ecommerce-product-details.html`
- `references/sources/pages/apps-ecommerce-product-add.html`
- `references/sources/pages/apps-ecommerce-categories.html`
- `references/sources/pages/apps-ecommerce-attributes.html`
- `references/sources/pages/apps-ecommerce-orders.html`
- `references/sources/pages/apps-ecommerce-order-details.html`
- `references/sources/pages/apps-ecommerce-order-add.html`
- `references/sources/pages/apps-ecommerce-customers.html`
- `references/sources/pages/apps-ecommerce-cart.html`
- `references/sources/pages/apps-ecommerce-checkout.html`
- `references/sources/pages/apps-ecommerce-sellers.html`
- `references/sources/pages/apps-ecommerce-seller-details.html`
- `references/sources/pages/apps-ecommerce-refunds.html`
- `references/sources/pages/apps-ecommerce-reviews.html`
- `references/sources/pages/apps-ecommerce-warehouse.html`
- `references/sources/pages/apps-ecommerce-product-stocks.html`
- `references/sources/pages/apps-ecommerce-purchased-orders.html`
- `references/sources/pages/apps-ecommerce-product-views.html`
- `references/sources/pages/apps-ecommerce-sales.html`
- `references/sources/pages/apps-ecommerce-settings.html`
- `references/sources/assets/js/pages/custom-table.js`
- `references/sources/assets/js/pages/ecommerce-product-add.js`
- `references/sources/assets/js/pages/ecommerce-products.js`
- `references/sources/assets/js/pages/ecommerce-product-views.js`
- `references/sources/assets/js/pages/ecommerce-reviews.js`
- `references/sources/assets/js/pages/ecommerce-sales.js`
- `references/sources/assets/js/pages/ecommerce-seller-details.js`
- `references/sources/assets/js/pages/form-inputmask.js`
- `references/sources/assets/js/app.js` (initTouchSpin, initFlatPicker, CustomApexChart, theme(), counters)
- `references/sources/assets/css/app.min.css` (class existence checks)
- `references/sources/MANIFEST-page-deps.txt`
