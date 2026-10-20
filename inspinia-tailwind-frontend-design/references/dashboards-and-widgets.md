# Dashboards, widgets and metric tiles

This file is the widget catalog for INSPINIA Tailwind: every distinct card type found on the three demo
dashboards (`index.html` Projects, `dashboard-analytics.html`, `dashboard-ecommerce.html`) and on the two
catalog pages (`widgets.html`, `metrics.html`), plus the grid recipes those dashboards use to compose them
and a short tour of the marketing `landing.html`. Reach for it when you are building an admin home page,
a KPI header row, an ops/NOC board, a sales or marketing overview, or any "card with a number and a chart".
Chart rendering is ECharts or ApexCharts wrapped by `CustomEChart` / `CustomApexChart` from `app.js`;
read the "Shared runtime" section first, every chart card below depends on it.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Any chart card, dark-mode-safe colours, animated numbers, card toggle/refresh/close | Shared runtime: `CustomEChart`, `CustomApexChart`, `theme()`, `data-target`, `data-action` | all | `assets/js/app.js` |
| KPI header row of an admin home ("124 tasks, +3 new, total 12,450") | Stat tile: icon + counter + delta badge + footer total | index.html, widgets.html | counters only (app.js) |
| Compact KPI column beside a big chart, trend arrow inline with the number | Stat tile: inline trend delta in dashed sub-panels | dashboard-analytics.html | counters only |
| KPI tile that also shows share-of-total at a glance | Stat tile: mini donut beside the number | dashboard-ecommerce.html, metrics.html | ECharts `.donut-chart` loop |
| Bold KPI tile with a big icon disc, no chart | Stat tile: large icon disc ("Monthly" row) | widgets.html | counters only |
| KPI tile with a tiny bar / area / pie sparkline | Stat tile: sparkline bar / area / pie | metrics.html | ECharts `.bar-chart` `.area-chart` `.pie-chart` loops |
| Six-up row of small counters (real-estate / inventory totals) | Counter tile: icon over number | widgets.html | counters only |
| "72.5% In progress" tiles for projects, SLAs, uptime | KPI progress tile: percentage + status + bar | widgets.html | counters only |
| 2x2 block of period stats with progress bars under a CTA header | Mini-stat panel grid with "full report" header | dashboard-ecommerce.html, widgets.html | none (Preline tooltip) |
| Greeting + today's numbered agenda on the home page | Welcome / today's agenda card | index.html | none |
| Main revenue/orders trend with totals strip and growth callout | Revenue area chart card with floating growth badge | index.html | ECharts `#revenue-chart` |
| Multi-project completion at a glance | Project progress rose chart card | index.html | ECharts `#project-progress-chart` |
| Orders over time with Today / Monthly / Annual switch | Orders statistics chart card with period tabs | dashboard-ecommerce.html | Preline `hs-tab` + ECharts `#orders-chart` |
| Sessions / page-views by hour with KPI column and Export button | Analytics overview area chart with KPI side column | dashboard-analytics.html | ApexCharts `#analytics-overview-chart` |
| Device split as a bubble plot plus a breakdown table | Sessions by device: bubble chart + table | dashboard-analytics.html | ApexCharts `#devices-chart` |
| Organic / direct / campaign share plus top URLs | Traffic sources: segmented bar + legend + URL table | dashboard-analytics.html, widgets.html | none |
| Ranked country (or region, store, rep) leaderboard | Top countries list: flag, count, delta badge | dashboard-analytics.html, widgets.html | none |
| Quarter-by-quarter P&L table with a tiny donut per row | Quarterly reports table with per-row donut | index.html, metrics.html | ECharts `.donut-chart` loop |
| Three labelled progress bars (completed / ongoing / pending) | Project performance progress list | index.html | none |
| Deploy log, audit trail, "what happened today" | Activity timeline card | index.html | none |
| Inbox preview, unread messages with Reply | Discussions / message list card | index.html | none |
| Threaded comments with view/like/reply counts | Comment thread card | widgets.html | none |
| Embedded support chat with composer | Chat widget card | widgets.html | SimpleBar `data-simplebar` |
| Phone / email contact blocks in solid colour | Contact info solid-colour cards | widgets.html | none |
| User header with cover photo and actions menu | Profile summary card with cover image | widgets.html | Preline `hs-dropdown` |
| Shared documents with collaborator avatars and download | File list card with avatar stack | widgets.html | none |
| Upcoming meetings with attendees and join button | Today's schedule / agenda card | widgets.html | none |
| Number + sentence + full-bleed chart at the card bottom | Summary cards with chart footer | metrics.html | ECharts `#orders-chart` `#product-chart` `#profit-chart` |
| Paginated product list with stock/price/rating/status and row menu | Product inventory table card (custom-table.js) | dashboard-ecommerce.html | `assets/js/pages/custom-table.js` |
| Paginated latest orders with customer avatar and status | Recent orders table card | dashboard-ecommerce.html | custom-table.js |
| Sortable, paginated campaign metrics table | Campaign performance sortable table card | dashboard-analytics.html | custom-table.js (`data-table-sort`) |
| Transactions list beside a world map with markers and routes | Transactions table + world vector map card | dashboard-ecommerce.html | jsVectorMap `#map_1` |
| Compose a projects/overview home page | Grid recipe: Projects dashboard | index.html | dashboard-projects.js |
| Compose a web-analytics page | Grid recipe: Analytics dashboard | dashboard-analytics.html | dashboard-analytics.js |
| Compose a store/orders page | Grid recipe: eCommerce dashboard | dashboard-ecommerce.html | dashboard-ecommerce.js |
| Lay out a mixed widget or metrics wall | Page composition: widgets.html and metrics.html | widgets.html, metrics.html | metrics.js |
| Public marketing / pricing page outside the admin shell | Landing page | landing.html | none (vendors + app.js only) |

## Shared runtime: chart wrappers, `theme()` tokens, counters, card actions

**What it is.** Everything the dashboard pages rely on that lives in `assets/js/app.js` rather than in the
page scripts: the two chart wrapper classes, the CSS-variable colour helper, the `data-target` counter and
the `data-action` card buttons.

**Use it when.** Every chart card below. Also whenever you build a new chart: wrap it in `CustomEChart` /
`CustomApexChart` so it survives a light/dark toggle and a sidebar collapse resize.

**Source.** `references/sources/assets/js/app.js` (minified; the relevant snippets are quoted below).

**Init / JS.**

```js
// Colour helper: reads --color-<name> from <html>, optional alpha.
// Names seen in the dashboards: primary secondary success info warning danger light dark purple white
// card body-color border-color default-100 default-200 default-300 default-600
// chart-primary chart-secondary chart-alpha chart-beta chart-border-color
// (also defined: chart-gamma chart-delta chart-zeta chart-gray chart-dark chart-title-color)
theme("primary");          // "#1ab394"-style string
theme("white", .5);        // "rgba(255, 255, 255, 0.5)"

// ECharts wrapper. `options` MUST be a function: it is re-invoked on theme change.
new CustomEChart({
  selector: "#revenue-chart",          // CSS selector or HTMLElement
  options: () => ({ /* echarts option, use theme() inside */ }),
  // theme: null, initOptions: {}      // passed straight to echarts.init
});
CustomEChart.instances;                // all live wrappers; .chart is the echarts instance
CustomEChart.rerenderAll(); CustomEChart.reSizeAll();

// ApexCharts wrapper. Colours resolve in this order:
//   options().colors  ->  data-colors="primary,secondary" on the element  ->  [primary, secondary, beta]
// and are auto-injected into fill.gradient.gradientToColors, markers.strokeColor, per-yaxis colours.
new CustomApexChart({
  selector: "#analytics-overview-chart",
  options: () => ({ chart: { height: 326, type: "area" }, series: [...], /* ... */ }),
});
CustomApexChart.rerenderAll();

// A MutationObserver on <html> attributes calls CustomApexChart.rerenderAll(),
// CustomEChart.rerenderAll(), CustomChartJs.rerenderAll() whenever data-theme / data-skin flips.
// window resize is debounced (debounce(fn, ms) is a global) and calls chart.resize().
```

Animated counters (`initCounter` in app.js):

```html
<h3 class="text-xl"><span data-target="69.5">0</span>k</h3>
<h3 class="text-xl"><span data-target="8,975">8,975</span></h3>
```

Card header action buttons (`data-action`, wired by app.js on DOMContentLoaded):

```html
<div class="card-header">
  <h4 class="card-title">Traffic Sources</h4>
  <div class="flex gap-1">
    <a href="#!" class="btn size-6 rounded-full bg-light text-dark hover:text-primary hover:bg-primary/15" data-action="card-toggle"><i class="iconify tabler--chevron-up"></i></a>
    <a href="#!" class="btn size-6 rounded-full bg-light text-dark hover:text-primary hover:bg-primary/15" data-action="card-refresh"><i class="iconify tabler--refresh"></i></a>
    <a href="#!" class="btn size-6 rounded-full bg-light text-dark hover:text-primary hover:bg-primary/15" data-action="card-close"><i class="iconify tabler--x"></i></a>
  </div>
</div>
```

**Gotchas.**
- The plugin libraries are NOT in the vendored sources: the demo pages reference
  `assets/plugins/echarts/echarts.min.js`, `assets/plugins/apexcharts/apexcharts.min.js`,
  `assets/plugins/jsvectormap/jsvectormap.min.js`, `assets/js/maps/world.js` and `world-merc.js`, but
  `references/sources/assets/` only contains `css/` and `js/{app.js,config.js,pages/}`. Supply them from npm
  (`echarts`, `apexcharts`, `jsvectormap`) or a CDN and load them AFTER `app.js`, BEFORE the page script.
- Pass `options` as a function and call `theme()` inside it. A static object captures light-mode hex values
  and the chart stays light after the user switches to dark.
- ECharts needs an explicit height: every container has inline `style="min-height: NNNpx"` (and often a
  `width`). ApexCharts takes `chart.height` in options; the demo also puts a slightly larger `min-height`
  on the div to reserve space for the legend and avoid layout shift.
- Wrap chart containers in `<div dir="ltr">` so an RTL layout does not mirror the canvas.
- `data-target` counters: commas are stripped, the IntersectionObserver uses `threshold: 1` (the span must
  be fully in view before it animates; a span inside a collapsed card never fires), the value is split into
  25 frames, and non-integers are printed with exactly two decimals (`69.5` renders `69.50`, `41.30`
  stays `41.30`). Keep units (`k`, `M`, `%`, `$`) OUTSIDE the span. The initial text can be `0` (animate
  from zero) or the final value (no visible jump if JS is slow): both appear in the demos.
- `card-toggle` animates only the FIRST `.card-body` inside the card and adds `.card-collapsed` (CSS hides
  the header's bottom border). A card with two `.card-body` blocks (the Sessions Device card) keeps its
  second body visible. `card-close` fades the card out and removes it from the DOM; there is no undo.
  `card-refresh` only shows a `.card-overlay` spinner for 1.5 s: hook your fetch to the same click.
- The three action buttons are `a.btn.size-6.rounded-full.bg-light`; keep `href="#!"` or the page jumps.

## Stat tile: icon, animated counter, delta badge, footer total

**What it is.** The default INSPINIA KPI tile: title, a `size-9` round icon, the headline number
(animated), a soft "+3 New" badge pushed right, and a footer line "Total Tasks … 12,450" with a coloured
dot. An external-link icon floats top-right.

**Use it when.**
- KPI header row of any admin home: tasks, messages, approvals, clients, revenue.
- Ops NOC board: open incidents / on-call pages / failed jobs with "+N since last shift" badges.
- Sales leaderboard header: deals won, pipeline value, quota attainment.
- Use the "mini donut" or "sparkline" variants instead when the KPI needs a trend; use the "inline trend"
  variant when horizontal space is tight.

**Source.** `references/sources/pages/index.html` (5-up row), `references/sources/pages/widgets.html`
(tinted and solid variants). No page script: counters come from app.js.

**Markup.**

```html
<div class="grid xl:grid-cols-5 md:grid-cols-3 grid-cols-1 gap-base mb-5">
  <!-- repeat per KPI -->
  <div class="card">
    <div class="card-body">
      <a href="#!" class="text-default-400 float-end -mt-1.25 text-xl"><i class="iconify tabler--external-link"></i></a>
      <h5 title="Number of Tasks">My Tasks</h5>
      <div class="flex items-center gap-2.5 my-5">
        <div class="shrink-0"><span class="size-9 text-default-600 bg-light flex justify-center items-center rounded-full"><i class="iconify tabler--checklist size-6"></i></span></div>
        <h3 class="text-xl text-default-800"><span data-target="124">124</span></h3>
        <span class="badge bg-primary/10 text-primary font-medium text-xs! ms-auto">+3 New</span>
      </div>
      <p><span class="text-primary"><i class="iconify tabler--point-filled"></i></span><span class="text-nowrap text-default-400">Total Tasks</span><span class="float-end"><b>12,450</b></span></p>
    </div>
  </div>
  <!-- revenue tile: currency prefix outside the counter span -->
  <div class="card">
    <div class="card-body">
      <a href="#!" class="text-default-400 float-end -mt-1.25 text-xl"><i class="iconify tabler--external-link"></i></a>
      <h5 title="Revenue Generated">Revenue</h5>
      <div class="flex items-center gap-2.5 my-5">
        <div class="shrink-0"><span class="size-9 text-default-600 bg-light flex justify-center items-center rounded-full"><i class="iconify tabler--credit-card size-6"></i></span></div>
        <h3 class="text-xl">$<span data-target="125.5">0</span>k</h3>
        <span class="badge bg-danger/15 text-danger font-medium text-xs ms-auto">+1.5%</span>
      </div>
      <p><span class="text-primary"><i class="iconify tabler--point-filled"></i></span><span class="text-nowrap text-default-400">Total Revenue</span><span class="float-end"><b>$12.5M</b></span></p>
    </div>
  </div>
</div>
```

Variants (all from widgets.html):

| Variant | Card classes | Icon disc classes |
|---|---|---|
| Neutral (default) | `card` | `size-9 bg-light rounded-full` + `tabler--checklist size-5.5` |
| Tinted | `card border-0 bg-success/10 shadow-none` (also `warning/10`, `info/10`, `secondary/10`, `danger/10`) | `text-white bg-success/90 rounded-full size-9` |
| Solid | `card text-white bg-primary border-0` | `bg-white/20 rounded-full size-9`; footer text `text-white` |
| Coloured icon only | `card` | `text-white bg-purple rounded-full size-9`, `bg-info` |

Tinted tiles in the demo sit inside an outer `.card > .card-body > .grid xl:grid-cols-4 … gap-base` so the
four tinted panels read as one block.

**Gotchas.**
- The demo's tinted-tile grid has a typo `md:grids-cols-2`; write `md:grid-cols-2`.
- `text-xs!` (important modifier) on the badge is needed because `.badge` sets its own font size.
- Bootstrap leftovers in the solid variant (`text-white-50`, `mt-n1`, `text-opacity-75`, `text-muted`) have
  no rules in `app.min.css`; use `text-white/50`, `-mt-1.25`, `text-white/75`, `text-default-400`.
- Icon icons seen: `tabler--checklist`, `tabler--message-circle`, `tabler--file-check`, `tabler--users`,
  `tabler--credit-card`, `tabler--shopping-cart`, `tabler--currency-dollar`, `tabler--star`, `tabler--box`.

## Stat tile: inline trend delta in dashed sub-panels

**What it is.** A vertical stack of four KPI panels (not separate cards) drawn with a dashed border inside
one card, each with the number, a coloured `+5.2%` with trend icon on the same line, a grey label, and a
`size-12` icon disc on the right. Used as the left column of the Analytics overview card.

**Use it when.**
- Web analytics: views, sessions, bounce rate, active users beside the sessions chart.
- Any "chart + 3-4 supporting KPIs" card where you want the KPIs visually subordinate to the chart.
- Not for a standalone KPI row: use the icon/badge tile above.

**Source.** `references/sources/pages/dashboard-analytics.html`.

**Markup.**

```html
<div class="card mb-5">
  <div class="card-body p-0">
    <div class="grid xl:grid-cols-4 grid-cols-1 gap-0">
      <div class="flex flex-col xl:order-1 order-2">
        <!-- first panel has m-1.25, the rest mt-0 m-1.25 so the dashed boxes touch -->
        <div class="p-5 rounded m-1.25 border border-default-300 border-dashed">
          <div class="flex justify-between items-center">
            <div>
              <h3 class="mb-1.25 text-xl"><span data-target="14.59">14.59</span>M <span class="text-success text-sm">+5.2% <i class="iconify tabler--trending-up"></i></span></h3>
              <p class="text-default-400">Total Views</p>
            </div>
            <div><span class="size-12 flex justify-center items-center bg-light rounded-full"><i class="iconify tabler--eye text-2xl text-default-400"></i></span></div>
          </div>
        </div>
        <div class="p-5 rounded mt-0 m-1.25 border border-default-300 border-dashed">
          <div class="flex justify-between items-center">
            <div>
              <h3 class="mb-1.25 text-xl"><span data-target="41.30">41.30</span>% <span class="text-danger text-sm">-1.1% <i class="iconify tabler--arrow-down-left"></i></span></h3>
              <p class="text-default-400">Bounce Rate</p>
            </div>
            <div><span class="size-12 flex justify-center items-center bg-light rounded-full"><i class="iconify tabler--repeat-once text-2xl text-default-400"></i></span></div>
          </div>
        </div>
        <!-- … two more panels -->
      </div>
      <div class="xl:col-span-3 border-s border-default-300 border-dashed xl:order-2 order-1">
        <!-- chart card-header + card-body, see "Analytics overview area chart" -->
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- `xl:order-1 order-2` on the KPI column and `xl:order-2 order-1` on the chart put the chart FIRST on
  mobile; keep both or the mobile order is KPIs-then-chart.
- Trend icons used: `tabler--trending-up`, `tabler--activity`, `tabler--arrow-down-left`, `tabler--users`.

## Stat tile: mini donut beside the number

**What it is.** A card with a dashed-bottom header (title + soft "Monthly" badge) and a body that puts a
60x60 ECharts donut on the left and the right-aligned number + label on the right.

**Use it when.**
- eCommerce KPI row: total sales, orders, new customers, revenue, each with a channel/category split.
- Finance: revenue by product line, expenses by department, where share-of-total matters more than trend.
- If you only need the number, drop the donut and use the "large icon disc" tile.

**Source.** `references/sources/pages/dashboard-ecommerce.html`, `references/sources/pages/metrics.html`;
init in `assets/js/pages/dashboard-ecommerce.js` / `metrics.js` (ECharts).

**Markup.**

```html
<div class="grid xl:grid-cols-4 md:grid-cols-2 grid-cols-1 gap-base mb-5">
  <!-- repeat per KPI -->
  <div class="card">
    <div class="card-header flex border-dashed justify-between items-center">
      <h5 class="card-title">Total Sales</h5><span class="badge bg-success/15 text-success"> Monthly</span>
    </div>
    <div class="card-body">
      <div class="flex justify-between items-center">
        <div class="donut-chart" data-chart="donut" style="min-height: 60px; width: 60px"></div>
        <div class="text-end">
          <h3 class="mb-2.5 font-normal text-xl">$<span data-target="250">0</span>K</h3>
          <p class="text-default-400"><span>Monthly Total Sales</span></p>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/dashboard-ecommerce.js` (metrics.js is identical except it uses
`chart-primary` / `chart-secondary`):

```js
function initDonutChart(el) {
  const data = generateRandomData();           // [{name, value}] summing to 100 – replace with real shares
  new CustomEChart({
    selector: el,
    options: () => ({
      tooltip: { show: false },
      series: [{
        type: "pie", radius: ["65%", "100%"], hoverAnimation: false,
        label: { show: false }, labelLine: { show: false },
        data: data.map((d, i) => ({
          value: d.value,
          itemStyle: { color: i === 0 ? theme("primary") : i === 1 ? theme("secondary") : "#bbcae14d" },
        })),
      }],
    }),
  });
}
document.querySelectorAll(".donut-chart").forEach(initDonutChart);
```

**Gotchas.**
- The selector the script loops over is the CLASS `.donut-chart`; `data-chart="donut"` is decorative (no
  runtime reads it). Any element with `.donut-chart` on the page gets a random donut, including the per-row
  donuts in the Quarterly Reports table.
- The third slice colour `#bbcae14d` is a hard-coded translucent grey used across all page scripts as the
  "remainder" colour; it works in both themes because it is 30 % alpha.
- Both `width` and `min-height` are inline; the donut will not render at 0 width.

## Stat tile: large icon disc ("Monthly" row)

**What it is.** Same header/body skeleton as the donut tile, but the left slot holds a `size-15` dark disc
with a `size-8` Tabler icon instead of a chart.

**Use it when.**
- A KPI row on a page that already has plenty of charts and wants calmer tiles.
- Warehouse / fulfilment overview: sales, orders, customers, revenue with no breakdown available.

**Source.** `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header flex border-dashed justify-between items-center">
    <h5 class="card-title">Total Orders</h5><span class="badge bg-primary/15 text-primary"> Monthly</span>
  </div>
  <div class="card-body">
    <div class="flex justify-between items-center">
      <div><span class="size-15 flex justify-center items-center rounded-full bg-dark text-white"><i class="iconify tabler--package size-8"></i></span></div>
      <div class="text-end">
        <h3 class="mb-2.5 font-normal text-xl"><span data-target="245">245</span></h3>
        <p class="text-default-400">Monthly Total Orders</p>
      </div>
    </div>
  </div>
</div>
```

Icons used in the row: `tabler--credit-card`, `tabler--package`, `tabler--users`, `tabler--chart-bar`.
Badge colours cycle `success / primary / info / warning` at `/15` opacity.

## Stat tile: sparkline bar / area / pie

**What it is.** Three metrics.html rows of borderless-header tiles where a tiny ECharts chart sits beside
the number: a 7-bar column sparkline (80x40), a gradient area sparkline (140x60) or a 4-slice pie (70x70).
Left/right placement alternates tile by tile.

**Use it when.**
- Per-project or per-property KPI rows where each tile has its own 7-point history (bar / area).
- Finance quarter summary: revenue, expenses, net profit, cash flow with composition (pie).
- Use the mini-donut tile for a single share-of-total; use this when you want a trend.

**Source.** `references/sources/pages/metrics.html`; init in `assets/js/pages/metrics.js`.

**Markup.**

```html
<!-- bar sparkline, chart on the right -->
<div class="card">
  <div class="card-header flex justify-between items-center border-0">
    <h5 class="card-title">Project A - Sales</h5><span class="badge bg-success/15 text-success"> Monthly</span>
  </div>
  <div class="card-body">
    <div class="flex justify-between items-center">
      <div>
        <h3 class="mb-1.25 font-normal text-xl">$<span data-target="320">0</span>K</h3>
        <p class="text-default-400"><span>Monthly Sales for Project A</span></p>
      </div>
      <div class="bar-chart" style="min-height: 40px; width: 80px"></div>
    </div>
  </div>
</div>
<!-- area sparkline, chart on the left, header badge shows absolute change -->
<div class="card">
  <div class="card-header flex border-0 justify-between items-center">
    <h5 class="card-title">Greenfield Towers - Sales</h5><span class="badge bg-success/15 text-success"> +$40K</span>
  </div>
  <div class="card-body">
    <div class="flex justify-between align-center">
      <div class="area-chart" style="min-height: 60px; width: 140px"></div>
      <div class="text-end">
        <h3 class="mb-1.25 font-normal text-xl">$<span data-target="550">0</span>K</h3>
        <p class="text-default-400"><span>Sales Change (Prev.)</span></p>
      </div>
    </div>
  </div>
</div>
<!-- pie -->
<div class="card">
  <div class="card-header flex border-0 justify-between items-center">
    <h5 class="card-title mb-0">Total Revenue</h5><span class="badge bg-success/15 text-success">+8.2%</span>
  </div>
  <div class="card-body">
    <div class="flex justify-between items-center">
      <div>
        <h3 class="mb-1.25 font-normal text-xl">$<span data-target="1240">0</span>K</h3>
        <p class="text-default-400">This Quarter</p>
      </div>
      <div class="pie-chart" style="height: 70px; width: 70px"></div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/metrics.js` loops `.bar-chart`, `.area-chart`, `.pie-chart`:

```js
// bar sparkline: axes hidden, grid zeroed, rounded 50%-wide bars, per-bar colour
new CustomEChart({ selector: el, options: () => ({
  grid: { top: 0, bottom: 0, left: 0, right: 0 },
  xAxis: { type: "category", data: names, show: false },
  yAxis: { type: "value", show: false },
  tooltip: { show: false },
  series: [{ type: "bar", barWidth: "50%", itemStyle: { borderRadius: 3 },
             data: values.map((v, i) => ({ value: v, itemStyle: { color: palette[i % 4] } })) }],
})});
// palette = [theme("chart-primary"), theme("chart-secondary"), theme("chart-alpha"), "#bbcae14d"]

// area sparkline: smooth line, vertical gradient to transparent, no symbols
series: [{ type: "line", smooth: true, symbol: "none", data: values,
  lineStyle: { color: c, width: 2 },
  areaStyle: { color: new echarts.graphic.LinearGradient(0, 0, 0, 1,
    [{ offset: 0, color: c }, { offset: 1, color: "rgba(255, 255, 255, 0)" }]) } }]

// pie: radius "90%", labels off, 4 slices from the same palette
series: [{ type: "pie", radius: "90%", hoverAnimation: false, label: { show: false }, labelLine: { show: false }, data }]
```

**Gotchas.**
- `align-center` on the area tiles is not a Tailwind class (Bootstrap leftover); use `items-center`.
- The pie tile puts `height` (not `min-height`) inline; either works for ECharts as long as it is non-zero.

## Counter tile: icon over number

**What it is.** The smallest tile: a `size-12` soft icon disc, a counter and a grey caption stacked
vertically. Six across on xl.

**Use it when.**
- Real-estate / asset totals (property value, sold, listings, agents, viewings, constructions).
- Any "at a glance" strip of 5-6 plain counts under a page title, e.g. CRM contacts by stage.

**Source.** `references/sources/pages/widgets.html` (last row).

**Markup.**

```html
<div class="grid xl:grid-cols-6 md:grid-cols-3 grid-cols-1 gap-base">
  <!-- repeat -->
  <div class="card">
    <div class="card-body">
      <div class="mb-5"><span class="size-12 flex justify-center items-center bg-primary/15 text-primary rounded-full"><i class="iconify tabler--building-skyscraper text-2xl"></i></span></div>
      <h3 class="mb-1.25 text-xl">$<span data-target="150">0</span>M</h3>
      <p class="text-default-400">Total Property Value</p>
    </div>
  </div>
</div>
```

Disc colours cycle `primary / success / warning / info / danger / secondary` at `/15` with matching text.
Icons: `tabler--building-skyscraper`, `tabler--home-dollar`, `tabler--building-store`,
`tabler--users-group`, `tabler--calendar-time`, `tabler--building-warehouse`.

## KPI progress tile: percentage + status + progress bar

**What it is.** A card with an uppercase link title, a large animated percentage next to a status word, a
2px-tall progress bar and a one-line footnote.

**Use it when.**
- Project / epic completion tiles ("Backend API Integration 72.5 % In Progress, est. 2 days").
- SLA / uptime tiles ("Server Uptime 99.90 % Stable, last downtime 7 days ago").
- Storage / quota usage per tenant.

**Source.** `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="grid xl:grid-cols-4 md:grid-cols-2 grid-cols-1 gap-base mb-5">
  <div class="card">
    <div class="card-body">
      <div>
        <a href="#" class="hover:text-primary uppercase font-semibold">Backend API Integration</a>
        <div class="py-2"><span class="text-lg font-bold me-2.5"><span data-target="72.5">0</span>%</span><span class="font-semibold text-default-400 text-sm">In Progress</span></div>
      </div>
      <div class="w-full bg-success/25 rounded-full h-2">
        <div class="bg-success h-2 rounded-full" style="width: 72.5%"></div>
      </div>
      <div class="mt-2.5 text-default-400">Estimated completion: 2 days.</div>
    </div>
  </div>
</div>
```

**Gotchas.**
- The template's progress bar is plain utilities (`w-full bg-success/25 rounded-full h-2` + inner
  `bg-success h-2 rounded-full` with inline width); the `.progress` component class is not used here.
- `data-target="99.90"` renders "99.90" (two decimals); `data-target="100"` renders "100".

## Mini-stat panel grid with "full report" CTA header

**What it is.** A card whose top is a tinted strip with a question ("Would you like the full report?"),
a sub-line and a round Download button with a Preline tooltip, followed by a 2-column grid of borderless,
square-cornered sub-cards each holding a number, a percentage with arrow icon, a caption and a thin
progress bar, then a centred "View all" link. In the eCommerce dashboard it is the right third of the
Orders Statistics card; on widgets.html it is a standalone card with tinted sub-cards.

**Use it when.**
- Period summary beside a big chart: total sales, customers, products sold, average order value.
- Any "download the PDF report" affordance paired with 4-6 headline numbers.
- Marketing campaign summary panel (spend, leads, CPL, ROAS).

**Source.** `references/sources/pages/dashboard-ecommerce.html`, `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="card">
  <div class="p-5 bg-light/20 border-b border-dashed border-default-300">
    <div class="flex justify-between items-center">
      <div class="col">
        <h4 class="text-sm mb-1.25">Would you like the full report?</h4>
        <small class="text-default-400 text-xs"> All 120 orders have been successfully delivered </small>
      </div>
      <div class="ms-auto">
        <div class="hs-tooltip [--placement:top] inline-block">
          <button type="button" class="hs-tooltip-toggle size-7.75 flex justify-center items-center rounded-full border border-default-300 text-default-700 hover:bg-default-50 hover:border-default-400 focus:outline-hidden">
            <i class="iconify tabler--download text-xl"></i>
            <span class="hs-tooltip-content hs-tooltip-shown:opacity-100 hs-tooltip-shown:visible opacity-0 transition-opacity inline-block absolute invisible z-10 py-1 px-2 bg-default-800 text-xs font-medium text-body-bg rounded-md shadow-2xs" role="tooltip"> Download </span>
          </button>
        </div>
      </div>
    </div>
  </div>
  <div class="p-1.25 grid md:grid-cols-2 grid-cols-1 gap-1.25">
    <!-- neutral sub-card; repeat -->
    <div class="card rounded-none border shadow-none border-dashed border-default-300 mb-0">
      <div class="card-body">
        <div class="mb-5 flex justify-between items-center">
          <h5 class="text-lg">$24,500</h5><span>18.45% <i class="iconify tabler--arrow-up text-success"></i></span>
        </div>
        <p class="text-default-400 mb-2.5"><span>Total sales in period</span></p>
        <div class="w-full bg-default-200 rounded-full h-1.25 mb-1.25">
          <div class="bg-secondary h-1.25 rounded-full" role="progressbar" style="width: 18.45%"></div>
        </div>
      </div>
    </div>
    <!-- tinted sub-card variant (widgets.html) -->
    <div class="card rounded-none border shadow-none border-dashed border-primary bg-primary/10 mb-0">
      <div class="card-body">
        <div class="mb-5 flex justify-between items-center">
          <h5 class="text-lg">3,750</h5><span>22.61% <i class="iconify tabler--bolt text-primary"></i></span>
        </div>
        <p class="text-default-400 mb-2.5 truncate"><span>Products sold in the period</span></p>
        <div class="w-full bg-primary/25 rounded-full h-1.25 mb-1.25">
          <div class="bg-primary h-1.25 rounded-full" role="progressbar" style="width: 22.61%"></div>
        </div>
      </div>
    </div>
  </div>
  <div class="text-center my-5"><a href="#!" class="underline font-semibold flex gap-1 justify-center items-center hover:text-primary"> View all Reports <i class="iconify tabler--send-2"></i></a></div>
</div>
```

**Gotchas.**
- Delta arrows: `tabler--arrow-up text-success`, `tabler--arrow-down text-danger`, `tabler--bolt text-primary`.
- The sub-cards are `.card` inside `.card`; `rounded-none border shadow-none mb-0` strips the outer card
  look so they tile edge-to-edge in the `p-1.25 … gap-1.25` grid.
- `<small class="fs-6">USD</small>` in the eCommerce copy is a Bootstrap leftover; widgets.html uses
  `text-2xs`.

## Welcome / today's agenda card

**What it is.** The first column of the Projects dashboard hero card: a greeting headline, "You have 42
messages and 6 notifications", a numbered list of today's items with time stamps (each number is a
`badge size-6` disc) and a pill button.

**Use it when.**
- Admin home / "my day" panel: today's meetings, approvals waiting, invoices to send.
- Onboarding checklist for a new tenant (step badges coloured by state).
- Pair it with the Revenue chart and Project progress card in one `grid xl:grid-cols-4` hero card (see
  grid recipe) or drop it into any 1-column slot.

**Source.** `references/sources/pages/index.html`.

**Markup.**

```html
<div class="col-span-1">
  <div class="p-7.5 border-e border-dashed border-default-300">
    <h4 class="text-base mb-1.25">Welcome to INSPINIA+ Admin Theme.</h4>
    <span class="text-default-400">You have <span class="text-primary font-semibold">42</span> messages and 6 notifications.</span>
    <ul class="mt-5">
      <!-- repeat per item; badge colours: bg-primary bg-info bg-secondary bg-light(text-black) bg-warning -->
      <li class="flex justify-between items-center py-2.5">
        <div><span class="badge size-6 text-white bg-primary me-2.5"><span class="font-medium text-sm">1</span></span> Reviewed project proposal </div>
        <span class="text-default-400">09:30 AM</span>
      </li>
      <li class="flex justify-between items-center py-2.5">
        <div><span class="badge size-6 text-black bg-light me-2.5"><span class="font-medium text-sm">4</span></span> Responded to support tickets </div>
        <span class="text-default-400">03:40 PM</span>
      </li>
    </ul>
    <div class="text-center mt-2.5"><a href="#!" class="btn bg-secondary text-white rounded-full hover:bg-secondary-hover">View Messages</a></div>
  </div>
</div>
```

**Gotchas.**
- This block is NOT a `.card-body`; it is a padded `div` inside a shared `.card` whose columns are divided
  by `border-e border-dashed border-default-300`. If you use it standalone, wrap it in `.card > .card-body`.

## Revenue area chart card with floating growth badge

**What it is.** The centre (2-column) section of the Projects hero card: title with a "View Reports"
link, a 2-up strip of totals in `bg-light/50` boxes, and a stacked two-series smooth area chart with a
"Growth Rate 89.24 %" callout absolutely positioned over the chart's top-left.

**Use it when.**
- Primary revenue vs orders trend on an executive overview.
- Any two-series cumulative trend (signups vs activations, requests vs errors) with a headline rate.
- For hourly session traffic with a legend use the ApexCharts "Analytics overview" card instead.

**Source.** `references/sources/pages/index.html`; init in `assets/js/pages/dashboard-projects.js`
(ECharts).

**Markup.**

```html
<div class="col-span-2">
  <div class="py-5 px-7.5 border-e border-dashed border-default-300">
    <div class="flex justify-between mb-5">
      <h4 class="card-title">Revenue</h4>
      <a href="#!" class="hover:text-primary underline font-semibold flex gap-1 items-center">View Reports <i class="iconify tabler--arrow-right"></i></a>
    </div>
    <div class="grid grid-cols-2 gap-base text-center mb-5">
      <div class="col"><div class="bg-light/50 p-2.5"><h5><span class="text-default-400">Total Revenue:</span>$ <span data-target="40">40</span>M</h5></div></div>
      <div class="col"><div class="bg-light/50 p-2.5"><h5><span class="text-default-400">Total Orders:</span><span data-target="50.9">50.90</span>k</h5></div></div>
    </div>
    <div dir="ltr" class="relative">
      <div class="py-2.5 px-5 rounded bg-light/30 border-dashed border border-default-300 text-primary z-10 absolute" style="top: 4.5%; left: 12%">
        <p class="mb-2 uppercase text-2xs font-semibold">Growth Rate</p>
        <h4 class="text-lg font-bold text-primary">89.24% <i class="iconify tabler--trending-up"></i></h4>
      </div>
      <div id="revenue-chart" style="min-height: 252px"></div>
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/dashboard-projects.js`:

```js
const xLabels = Array.from({ length: 15 }, (_, i) => "Day " + (i + 1));
new CustomEChart({
  selector: "#revenue-chart",
  options: () => ({
    textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },
    tooltip: {
      trigger: "axis", padding: [5, 0], backgroundColor: theme("card"), borderColor: theme("default-200"),
      textStyle: { color: theme("default-600") }, borderWidth: 1, transitionDuration: .125,
      axisPointer: { type: "none" }, shadowBlur: 2, shadowColor: "rgba(76, 76, 92, 0.15)", shadowOffsetX: 0, shadowOffsetY: 1,
      formatter: (params) => { /* builds an HTML header + one dot-row per series, see source */ },
    },
    xAxis: { type: "category", data: xLabels, boundaryGap: false,
             axisLine: { lineStyle: { color: theme("default-100"), type: "dashed" } }, axisTick: { show: false },
             axisLabel: { color: theme("body-color"), margin: 15 }, splitLine: { show: false } },
    yAxis: { type: "value", splitLine: { lineStyle: { color: theme("default-200"), type: "dashed" } },
             axisLabel: { show: true, color: theme("body-color"), margin: 15 }, axisTick: { show: false }, axisLine: { show: false } },
    series: [
      { name: "Total Revenue", type: "line", smooth: true, symbol: "circle", symbolSize: 2, stack: "data",
        itemStyle: { color: theme("primary"), borderColor: theme("primary"), borderWidth: 2 },
        areaStyle: { opacity: .2, color: theme("primary") }, lineStyle: { color: theme("primary") },
        data: [45, 88, 120, 160, 210, 240, 350, 420, 380, 500, 640, 710, 890, 1150, 1200] },
      { name: "Orders", type: "line", smooth: true, symbol: "circle", symbolSize: 2, stack: "data",
        itemStyle: { color: theme("secondary"), borderColor: theme("secondary"), borderWidth: 2 },
        areaStyle: { opacity: .2, color: theme("secondary") }, lineStyle: { color: theme("secondary") },
        data: [15, 30, 35, 50, 55, 75, 95, 120, 135, 160, 180, 210, 250, 390, 450] },
    ],
    grid: { right: 20, left: 5, bottom: 5, top: 8, containLabel: true },
  }),
});
```

**Gotchas.**
- The tooltip block (card background, `default-200` border, 1px, soft shadow, `axisPointer: none`) is the
  house style; copy it verbatim for every ECharts axis chart in the template.
- `stack: "data"` makes the areas cumulative; remove it for independent series.
- The growth callout uses percentage `top/left`; it sits over the chart and does not move with data.

## Project progress rose chart card

**What it is.** A `.card-body` column with a title, a one-line summary and a six-slice ECharts "rose"
(Nightingale) pie whose slice radius encodes each project's completion.

**Use it when.**
- Portfolio view: completion of 4-8 parallel projects or workstreams.
- Team capacity split; budget consumed per department. Not for time series.

**Source.** `references/sources/pages/index.html`; init in `assets/js/pages/dashboard-projects.js`.

**Markup.**

```html
<div class="col-span-1">
  <div class="card-body">
    <h4 class="card-title mb-1.25">Project Progress</h4>
    <p class="text-default-400 text-xs">You have 21 projects with not completed task.</p>
    <div class="mt-7.5">
      <div dir="ltr"><div id="project-progress-chart" style="min-height: 278px"></div></div>
    </div>
  </div>
</div>
```

**Init / JS.**

```js
new CustomEChart({
  selector: "#project-progress-chart",
  options: () => ({
    tooltip: { trigger: "item", padding: [8, 15], backgroundColor: theme("card"), borderColor: theme("default-200"),
               textStyle: { color: theme("default-600") }, borderWidth: 1, transitionDuration: .125,
               axisPointer: { type: "none" }, shadowBlur: 2, shadowColor: "rgba(76, 76, 92, 0.15)", shadowOffsetX: 0, shadowOffsetY: 1 },
    textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },
    series: [{
      name: "Project Progress", type: "pie", radius: [60, 100], center: ["50%", "50%"], roseType: "area",
      itemStyle: { borderRadius: 8 }, label: { color: theme("body-color") },
      data: [
        { value: 85, name: "Website Redesign", itemStyle: { color: theme("chart-primary") } },
        { value: 70, name: "Mobile App",       itemStyle: { color: theme("secondary") } },
        { value: 55, name: "CRM Integration",  itemStyle: { color: theme("info") } },
        { value: 60, name: "Product Launch",   itemStyle: { color: theme("success") } },
        { value: 75, name: "Backend Refactor", itemStyle: { color: theme("light") } },
        { value: 50, name: "Client Dashboard", itemStyle: { color: theme("warning") } },
      ],
    }],
  }),
});
```

**Gotchas.**
- Labels are outside the pie; with 6+ long names the 278px container clips them on narrow columns. Shorten
  names or raise `min-height`.

## Orders statistics chart card with period tabs

**What it is.** A full-width card whose header holds the title and a Preline tab strip (Today / Monthly /
Annual, icons only on mobile), and whose body is a 3-column grid: a 2-column ECharts combo chart (smooth
line for Completed, two rounded bars for Processing and Cancelled, legend on top) plus the mini-stat panel
grid (above) in the third column.

**Use it when.**
- Orders / tickets / shipments over the last N days with a status breakdown and a period switch.
- Support dashboard: resolved vs open vs escalated per day.
- Any combo chart that needs a period selector in the header.

**Source.** `references/sources/pages/dashboard-ecommerce.html`; init in
`assets/js/pages/dashboard-ecommerce.js`.

**Markup.**

```html
<div class="card mb-5">
  <div class="card-header py-0 border-dashed card-tabs flex items-center">
    <div class="grow"><h4 class="card-title">Orders Statics</h4></div>
    <nav id="hs-tabs" class="flex gap-x-1" aria-label="Tabs" role="tablist" aria-orientation="horizontal">
      <!-- repeat per period; the `active` class marks the initial tab -->
      <button type="button" class="hs-tab-active:text-primary hs-tab-active:border-b py-4.25 font-medium hs-tab-active:border-primary relative px-4 text-sm whitespace-nowrap hover:text-primary focus:outline-hidden focus:text-primary disabled:opacity-50 disabled:pointer-events-none" id="today" data-hs-tab="#today-tab" aria-controls="today-tab" role="tab"><i class="iconify tabler--home md:hidden block"></i> Today </button>
      <button type="button" class="hs-tab-active:text-primary hs-tab-active:border-b py-4.25 font-medium hs-tab-active:border-primary relative px-4 text-sm whitespace-nowrap hover:text-primary focus:outline-hidden focus:text-primary disabled:opacity-50 disabled:pointer-events-none active" id="monthly" data-hs-tab="#monthly-tab" aria-controls="monthly-tab" role="tab"><i class="iconify tabler--user-circle md:hidden block"></i> Monthly </button>
      <button type="button" class="hs-tab-active:text-primary hs-tab-active:border-b py-4.25 font-medium hs-tab-active:border-primary relative px-4 text-sm whitespace-nowrap hover:text-primary focus:outline-hidden focus:text-primary disabled:opacity-50 disabled:pointer-events-none" id="annual" data-hs-tab="#annual-tab" aria-controls="annual-tab" role="tab"><i class="iconify tabler--settings md:hidden block"></i> Annual </button>
    </nav>
  </div>
  <div class="grid xl:grid-cols-3 grid-cols-1">
    <div class="xl:col-span-2 border-e border-dashed border-default-300">
      <div id="orders-chart" style="min-height: 405px"></div>
    </div>
    <div class="col-span-1">
      <!-- mini-stat panel grid with "full report" header, see that section -->
    </div>
  </div>
</div>
```

**Init / JS.** `assets/js/pages/dashboard-ecommerce.js` builds 15 day labels ending today with
`toLocaleDateString("en-GB", {day:"2-digit", month:"short", year:"2-digit"})` and random series:

```js
new CustomEChart({
  selector: "#orders-chart",
  options: () => ({
    tooltip: { trigger: "axis", padding: [8, 15], backgroundColor: theme("card"), borderColor: theme("default-200"),
               textStyle: { color: theme("default-600") }, borderWidth: 1, transitionDuration: .125, axisPointer: { type: "none" },
               shadowBlur: 2, shadowColor: "rgba(76, 76, 92, 0.15)", shadowOffsetX: 0, shadowOffsetY: 1,
               formatter: (p) => `<div class="mb-1 text-body">${dateFor(p[0].dataIndex)}</div>` +
                 p.map(s => s.marker + ` ${s.seriesName}: <span class="fw-bold">${s.value}</span> Orders`).join("<br/>") },
    legend: { data: ["Completed", "Processing", "Cancelled"], top: 15, textStyle: { color: theme("body-color") } },
    textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },
    xAxis: { data: category, axisLine: { lineStyle: { type: "dashed", color: theme("chart-border-color") } },
             axisLabel: { show: true, color: theme("body-color") }, splitLine: { lineStyle: { color: theme("chart-border-color"), type: "dashed" } } },
    yAxis: { axisLine: { lineStyle: { type: "dashed", color: theme("chart-border-color") } },
             axisLabel: { show: true, color: theme("body-color") }, splitLine: { show: false } },
    grid: { left: 25, right: 25, bottom: 25, top: 60, containLabel: true },
    series: [
      { name: "Completed",  type: "line", smooth: true, itemStyle: { color: theme("success") }, showAllSymbol: true, symbol: "emptyCircle", symbolSize: 5, data: completedOrders },
      { name: "Processing", type: "bar", barWidth: 14, itemStyle: { borderRadius: [5, 5, 0, 0], color: theme("secondary") }, data: processingOrders },
      { name: "Cancelled",  type: "bar", barWidth: 14, itemStyle: { borderRadius: [5, 5, 0, 0], color: "#bbcae14d" }, data: cancelledOrders },
    ],
  }),
});
```

**Gotchas.**
- The tabs point at `#today-tab`, `#monthly-tab`, `#annual-tab` but NO such panels exist in the demo;
  the chart is a single `#orders-chart`. The tabs are purely visual. To make them work either add three
  panel divs with those IDs (Preline toggles `hidden`) or listen for clicks on the buttons and call
  `CustomEChart.instances.find(i => i.selector === "#orders-chart").chart.setOption({...})`.
- The source marks `aria-selected="true"` on Today but puts the `active` class on Monthly; Preline follows
  the `active` class. Keep both on the same button.
- `card-tabs` has no rule in `app.min.css`; the look comes from `py-0` on the header and `py-4.25` on the
  buttons so the active underline sits on the header's dashed border.

## Analytics overview area chart with KPI side column

**What it is.** The right 3/4 of the Analytics hero card: a `card-header` with the title and an
"Export CSV" button, and a two-series ApexCharts gradient area chart (Sessions / Page Views by hour).

**Use it when.**
- Site / app traffic by hour with a secondary metric.
- API request volume vs error count, with an export button.
- Use the ECharts revenue card when you need the floating callout and totals strip instead.

**Source.** `references/sources/pages/dashboard-analytics.html`; init in
`assets/js/pages/dashboard-analytics.js` (ApexCharts).

**Markup.**

```html
<div class="xl:col-span-3 border-s border-default-300 border-dashed xl:order-2 order-1">
  <div class="card-header">
    <h4 class="card-title">Analytics Overview</h4>
    <div><a href="javascript:void(0);" class="btn btn-sm bg-primary text-white"><i class="iconify tabler--download me-1"></i> Export CSV </a></div>
  </div>
  <div class="card-body">
    <div dir="ltr"><div id="analytics-overview-chart" class="apex-charts" style="min-height: 341px"></div></div>
  </div>
</div>
```

**Init / JS.**

```js
new CustomApexChart({
  selector: "#analytics-overview-chart",
  options: () => ({
    chart: { height: 326, type: "area", toolbar: { show: false } },
    dataLabels: { enabled: false },
    stroke: { width: 2, curve: "smooth" },
    colors: [theme("chart-primary"), theme("chart-secondary")],
    series: [{ name: "Sessions", data: sessions }, { name: "Page Views", data: pageViews }],
    legend: { offsetY: 5 },
    xaxis: { categories: ["", "8 AM", "9 AM", /* … */ "12 AM", ""], axisBorder: { show: false }, axisTicks: { show: false },
             tickAmount: 6, labels: { style: { fontSize: "12px" } } },
    tooltip: { shared: true, y: { formatter: (v, { seriesIndex }) => seriesIndex === 0 ? v + " Sessions" : v + " Page Views" } },
    fill: { type: "gradient", gradient: { shadeIntensity: 1, opacityFrom: .4, opacityTo: .2, stops: [15, 120, 100] } },
    grid: { borderColor: [theme("border-color")], padding: { bottom: 5 } },
  }),
});
```

**Gotchas.**
- `.apex-charts` is a real class (`min-height: 10px !important` + centres the canvas); keep it on Apex
  containers. The sibling bubble chart uses `apex-chart` (singular) which has no rule.
- Leading/trailing empty categories pad the area so the first/last points are not cut off.

## Sessions by device: bubble chart + breakdown table

**What it is.** A card with the standard action buttons, an ApexCharts bubble plot (three device series,
axes hidden, legend on top) in a `card-body pb-0`, and a second `card-body p-0` holding a compact
`table-hover` with Device / Sessions / Change / Traffic %.

**Use it when.**
- Device, browser or OS split with a numeric table under a playful chart.
- Regional sales split with a table of change-vs-last-period.
- Prefer the Traffic Sources segmented bar when you just need shares.

**Source.** `references/sources/pages/dashboard-analytics.html`; init in
`assets/js/pages/dashboard-analytics.js`.

**Markup.**

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Sessions Device</h4>
    <div class="flex gap-1"><!-- card-toggle / card-refresh / card-close buttons --></div>
  </div>
  <div class="card-body pb-0">
    <div id="devices-chart" class="apex-chart" style="min-height: 223px"></div>
  </div>
  <div class="card-body p-0">
    <div class="table-wrapper whitespace-nowrap">
      <table class="table table-hover mb-0">
        <thead class="bg-light/25 thead-sm">
          <tr class="uppercase text-2xs"><th class="text-default-400">Device</th><th class="text-default-400">Sessions</th><th class="text-default-400">Change</th><th class="text-default-400 text-end">Traffic %</th></tr>
        </thead>
        <tbody>
          <!-- repeat -->
          <tr><td><h5 class="text-sm">Mobile</h5><p class="text-2xs text-default-400">- Android / iOS</p></td><td>4620</td><td class="text-success">+3.4%</td><td class="text-end">58%</td></tr>
          <tr><td><h5 class="text-sm">Tablet</h5><p class="text-2xs text-default-400">- iPad / Android Tabs</p></td><td>820</td><td class="text-danger">-0.8%</td><td class="text-end">10%</td></tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
```

**Init / JS.**

```js
// series: [{ name: "Desktop", data: [{x, y, z}, …] }, …]  (z = bubble size 15-35)
new CustomApexChart({
  selector: "#devices-chart",
  options: () => ({
    chart: { height: 208, type: "bubble", toolbar: { show: false } },
    dataLabels: { enabled: false },
    series: [desktop, mobile, tablet],
    fill: { opacity: .8, gradient: { enabled: false } },
    colors: [theme("chart-primary"), theme("chart-secondary"), theme("chart-beta")],
    xaxis: { min: 0, max: 11, show: false, labels: { show: false }, axisBorder: { show: false }, axisTicks: { show: false } },
    yaxis: { min: 0, max: 170, show: false, labels: { show: false }, axisBorder: { show: false }, axisTicks: { show: false } },
    grid: { padding: { top: -20, right: 20, bottom: 0, left: 20 }, borderColor: theme("border-color") },
    legend: { show: true, position: "top", horizontalAlign: "center" },
  }),
});
```

**Gotchas.**
- Two `.card-body` elements: `card-toggle` collapses only the first (the chart), the table stays.
- `thead-sm` is real (`th { padding: 8px }`); `table-wrapper` is real (`overflow:auto; position:relative`).
  Always wrap `.table` in `.table-wrapper.whitespace-nowrap` inside a `card-body p-0`.

## Traffic sources: segmented bar + legend + URL table

**What it is.** A card with a big "8,975 Right Now" counter and a three-item caret legend side by side, a
20px-tall segmented progress bar (three coloured segments in one rounded track), a compact URL / Views /
Uniques table and a right-aligned "View all Links" link. Pure markup, no chart library.

**Use it when.**
- Traffic sources (organic / direct / campaign), lead sources, payment methods split.
- Storage breakdown (documents / media / other) with the top consumers listed below.
- Any share-of-total where a chart library would be overkill.

**Source.** `references/sources/pages/dashboard-analytics.html`, `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Traffic Sources</h4>
    <div class="flex gap-1"><!-- card action buttons --></div>
  </div>
  <div class="card-body">
    <div class="flex justify-between gap-base mb-2.5">
      <div>
        <h3 class="mb-2.5 text-xl font-bold"><span data-target="8,975">8,975</span></h3>
        <p class="mb-2.5 text-default-400 font-semibold">Right Now</p>
      </div>
      <div class="self-center">
        <ul class="leading-6">
          <li class="flex items-center gap-1.25"><i class="iconify tabler--caret-right-filled text-lg align-middle text-primary"></i><span class="text-default-400">Organic</span></li>
          <li class="flex items-center gap-1.25"><i class="iconify tabler--caret-right-filled text-lg align-middle text-success"></i><span class="text-default-400">Direct</span></li>
          <li class="flex items-center gap-1.25"><i class="iconify tabler--caret-right-filled text-lg align-middle"></i><span class="text-default-400">Campaign</span></li>
        </ul>
      </div>
    </div>
    <div class="mb-5 h-5 w-full overflow-hidden rounded bg-default-200 flex">
      <div class="h-full bg-primary" style="width: 25%" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
      <div class="h-full bg-success" style="width: 50%" role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
      <div class="h-full bg-info" style="width: 15%" role="progressbar" aria-valuenow="15" aria-valuemin="0" aria-valuemax="100"></div>
    </div>
    <div class="table-wrapper whitespace-nowrap">
      <table class="table table-sm table-hover mb-0">
        <thead class="bg-light/25 thead-sm">
          <tr class="uppercase text-2xs"><th class="text-default-400">URL</th><th class="text-default-400 text-end">Views</th><th class="text-default-400 text-end">Uniques</th></tr>
        </thead>
        <tbody class="border-b border-default-300">
          <!-- repeat -->
          <tr><td class="underline">/dashboard</td><td class="text-end">9.8k</td><td class="text-end">8.5k</td></tr>
        </tbody>
      </table>
    </div>
    <div class="text-center mt-5"><a href="#!" class="hover:text-primary underline underline-offset-4 font-semibold flex items-center gap-1.25 justify-end"> View all Links<i class="iconify tabler--link"></i></a></div>
  </div>
</div>
```

**Gotchas.**
- The third legend caret has no colour class in the demo (inherits body colour) while the bar segment is
  `bg-info`; add `text-info` to match.
- The demo's third segment carries `aria-valuenow="25" aria-valuemin="100"` (wrong); corrected above.

## Top countries list: flag, count, delta badge

**What it is.** Ten flex rows: an italic rank number, a `size-4` flag SVG, the country name link, then
(pushed right) the count and a `badge-label` delta badge coloured by sign. Ends with a "View all
Countries" link.

**Use it when.**
- Top countries / cities / regions by visitors or revenue.
- Any ranked leaderboard with a change indicator: top sales reps (avatar instead of flag), top products,
  top referrers.
- For long lists with sorting use a `data-table` card instead.

**Source.** `references/sources/pages/dashboard-analytics.html`, `references/sources/pages/widgets.html`.
Flags: `assets/images/flags/<iso2>.svg`.

**Markup.**

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Top 10 Countries</h4>
    <div class="flex gap-1"><!-- card action buttons --></div>
  </div>
  <div class="card-body">
    <!-- repeat; last row drops mb-5 -->
    <div class="flex items-center gap-2.5 mb-5">
      <span class="text-sm font-medium italic text-default-400">01.</span>
      <img src="assets/images/flags/de.svg" alt="Germany" class="size-4 rounded" />
      <h5 class="font-medium"><a href="#!" class="hover:text-primary">Germany</a></h5>
      <div class="ms-auto">
        <div class="flex items-center gap-5">
          <p class="font-medium">10,412</p>
          <p class="badge badge-label text-2xs bg-success/15 text-success mb-0">+1.5%</p>
        </div>
      </div>
    </div>
    <div class="flex items-center gap-2.5 mb-5">
      <span class="text-sm font-medium italic text-default-400">02.</span>
      <img src="assets/images/flags/fr.svg" alt="France" class="size-4 rounded" />
      <h5 class="font-medium"><a href="#!" class="hover:text-primary">France</a></h5>
      <div class="ms-auto">
        <div class="flex items-center gap-5">
          <p class="font-medium">8,934</p>
          <p class="badge badge-label text-2xs bg-danger/15 text-danger mb-0">-0.8%</p>
        </div>
      </div>
    </div>
    <div class="text-center mt-2.5"><a href="#!" class="hover:text-primary underline font-semibold"> View all Countries <i class="iconify tabler--world"></i></a></div>
  </div>
</div>
```

Delta badge colours: `bg-success/15 text-success` (up), `bg-danger/15 text-danger` (down),
`bg-warning/15 text-warning` (0.0 %). `badge-label` = square corners, `.8em` horizontal padding.

**Gotchas.**
- `link-offset-3` on the footer link is a Bootstrap leftover; use `underline-offset-4`.

## Quarterly reports table with per-row donut

**What it is.** A `card-body p-0` table (Quarter / Revenue / Expense / Margin / •••) where the first cell
stacks a title and a date-range sub-line, and the last cell is a 60px-wide 30px-tall ECharts donut.

**Use it when.**
- Quarterly or monthly P&L summary with a margin visual per row.
- Per-campaign spend/return rows, per-store revenue/cost rows, anywhere a tiny composition chart per row
  beats a numeric column.

**Source.** `references/sources/pages/index.html`, `references/sources/pages/metrics.html`; donut init in
`dashboard-projects.js` (radius 60-100 %) / `metrics.js` (65-100 %).

**Markup.**

```html
<div class="card">
  <div class="card-header justify-between items-center">
    <h5 class="card-title">Quarterly Reports <span class="badge text-white bg-primary">IN+</span></h5>
    <div class="flex gap-1"><!-- card action buttons --></div>
  </div>
  <div class="card-body p-0">
    <div class="table-wrapper whitespace-nowrap">
      <table class="table table-hover">
        <thead class="bg-light/25 thead-sm">
          <tr class="uppercase text-2xs"><th class="text-default-400">Quarter</th><th class="text-default-400">Revenue</th><th class="text-default-400">Expense</th><th class="text-default-400">Margin</th><th class="text-default-400">•••</th></tr>
        </thead>
        <tbody>
          <!-- repeat per quarter -->
          <tr>
            <td><h5 class="text-sm mb-1.25 font-normal">Quarter 1</h5><span class="text-default-400 text-xs">January - March 2024</span></td>
            <td>$210k</td><td>$165k</td><td>$45k</td>
            <td style="width: 60px"><div dir="ltr"><div class="donut-chart" data-chart="donut" style="min-height: 30px"></div></div></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
```

**Gotchas.**
- Rendered by the same `.donut-chart` loop as the KPI donuts, so the per-row donuts get random data in the
  demo; feed real `[revenue, expense, margin]` shares.
- Width comes from the `<td style="width: 60px">`; the donut div itself only sets `min-height`.

## Project performance progress list

**What it is.** Three stacked rows, each a label on the left and "+ 180 • 54.20 %" on the right, above a
`h-1.25` progress bar. Pure markup.

**Use it when.**
- Completed / ongoing / pending breakdown of projects, tickets, campaigns.
- Goal attainment per team; disk usage per volume; anything with 3-6 labelled bars.

**Source.** `references/sources/pages/index.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header justify-between items-center">
    <h5 class="card-title">Project Performance</h5>
    <div class="flex gap-1"><!-- card action buttons --></div>
  </div>
  <div class="card-body">
    <!-- first row has no mt; following rows use mt-7.5 -->
    <div>
      <div class="flex justify-between">
        <h5 class="text-sm mb-2.5">Completed Projects</h5>
        <div class="flex gap-8"><span>+ 180</span><span><i class="iconify tabler--circle-filled text-light mx-5 text-[10px]"></i>54.20%</span></div>
      </div>
      <div class="w-full bg-default-200 rounded-full h-1.25 mb-1.25">
        <div class="bg-secondary h-1.25 rounded-full" style="width: 54.2%"></div>
      </div>
    </div>
    <div class="mt-7.5">
      <div class="flex justify-between">
        <h5 class="text-sm mb-2.5">Ongoing Projects</h5>
        <div class="flex gap-8"><span>+ 120</span><span><i class="iconify tabler--circle-filled text-light mx-5 text-[10px]"></i>36.15%</span></div>
      </div>
      <div class="w-full bg-default-200 rounded-full h-1.25 mb-1.25">
        <div class="bg-info h-1.25 rounded-full" style="width: 36.15%"></div>
      </div>
    </div>
  </div>
</div>
```

## Activity timeline card

**What it is.** A vertical timeline: each entry is a flex row with a dashed-bordered `size-7.75` icon
circle on the left (connected to the next by a dashed `after:` pseudo-line), and on the right a title with
a `badge-label` tag, a timestamp, a description, the actor's `size-4` avatar and name, and a dashed `hr`.

**Use it when.**
- "Latest project updates", deploy log, audit trail on an admin home.
- Ticket / order history on a detail page; CRM activity feed.
- For a chat-style two-sided layout use the Chat widget instead.

**Source.** `references/sources/pages/index.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header justify-between items-center">
    <h5 class="card-title">Latest Project Updates</h5><span class="badge text-white bg-warning text-2xs"> 8 Notifications</span>
  </div>
  <div class="card-body">
    <!-- repeat per event; omit the trailing <hr> on the last one -->
    <div class="flex gap-x-base">
      <div class="after:border-default-300 relative after:absolute after:start-1/2 after:top-8 after:bottom-0 after:w-px after:border-e -ms-px after:border-dashed last:after:hidden">
        <div class="relative z-10 flex items-center justify-center">
          <div class="border-default-300 flex size-7.75 items-center justify-center rounded-full border border-dashed"><i class="iconify tabler--rocket text-xl text-primary"></i></div>
        </div>
      </div>
      <div class="flex-1">
        <div class="flex justify-between">
          <h5 class="mb-1.25 text-sm">New Feature Released <span class="badge badge-label bg-info/15 text-info text-[10px] ms-2.5">Deploy</span></h5>
          <span class="text-default-400 text-2xs">Today at 3:45 PM</span>
        </div>
        <p class="mb-1.25 text-default-400">Launched the real-time chat feature across all user accounts.</p>
        <div class="flex items-center gap-2.5"><img src="assets/images/users/user-6.jpg" alt="Natalie Brooks" class="rounded-full size-4" /><a href="#!" class="font-medium text-default-400">Natalie Brooks</a></div>
        <hr class="border-dashed border-t border-default-300 my-3" />
      </div>
    </div>
  </div>
</div>
```

Icon / tag pairs used: `tabler--rocket text-primary` + Deploy (`bg-info/15 text-info`),
`tabler--calendar-event text-warning` + Meeting (`secondary`), `tabler--palette text-success` + Design
(`success`), `tabler--database text-danger` + Backend (`danger`), `tabler--shield-check text-info` + Audit
(`warning`), `tabler--user-plus text-success` + Onboarding (`primary`).

**Gotchas.**
- The connector is drawn by the `after:` utilities on the icon column; `last:after:hidden` only works if
  the entries are direct siblings. The `hr` inside each right column is a separate visual separator.

## Discussions / message list card

**What it is.** A card with a "Mark all as read" badge-link in the header, a tinted intro `card-body`
("You have 22 new messages…" with a `message-mail.png` illustration), then a list of messages: `size-9`
avatar (or initials disc), name + relative time, one-line text and a soft "Reply" badge. Ends with a
"Go to Chat Room" link.

**Use it when.**
- Inbox / notification preview on a home page.
- Recent support tickets, recent reviews, latest comments on a CMS dashboard.

**Source.** `references/sources/pages/index.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header justify-between items-center">
    <h5 class="card-title"> Discussions <span class="badge bg-primary/15 text-2xs text-primary">Pro+</span></h5>
    <a href="#!" class="badge text-default-800 bg-light text-xs font-semibold">Mark all as read</a>
  </div>
  <div class="card-body bg-light/15! border-b border-default-300 border-dashed">
    <div class="flex gap-2.5">
      <div class="me-2.5 shrink-0"><img src="assets/images/message-mail.png" class="h-9" alt="message img" /></div>
      <div class="grow">
        <h4 class="text-sm mb-1.25">New messages</h4>
        <p class="text-xs text-default-400">You have <span class="text-default-700 font-semibold">22</span> new messages and <span class="text-default-700 font-semibold">16</span> waiting in draft folder.</p>
      </div>
    </div>
  </div>
  <div class="card-body pt-1.25!">
    <ul class="mb-5">
      <!-- repeat; last li drops border-b -->
      <li class="py-2.5 border-b border-light">
        <div class="flex gap-2.5">
          <div class="me-2.5 shrink-0"><img src="assets/images/users/user-8.jpg" class="size-9 rounded-full" alt="user-8" /></div>
          <div class="grow text-default-400">
            <h6 class="text-default-800 mb-1.25 text-sm flex justify-between"> Alex Johnson <small class="text-xs text-default-500">10m ago</small></h6>
            <p class="mb-1.25">Excited to share our latest project update with everyone!</p>
            <a href="#!" class="badge bg-primary/15 text-primary text-[10px]">Reply</a>
          </div>
        </div>
      </li>
      <!-- initials avatar variant -->
      <li class="py-2.5 border-b border-light">
        <div class="flex gap-2.5">
          <div class="me-2.5 shrink-0"><div class="size-9 flex justify-center items-center bg-purple/15 text-purple rounded-full"><span class="font-bold">DN</span></div></div>
          <div class="grow text-default-400">
            <h6 class="text-default-800 mb-1.25 text-sm flex justify-between"> Den Nowdya <small class="text-xs text-default-500">1h ago</small></h6>
            <p class="mb-1.25">Looking forward to the upcoming team meeting.</p>
            <a href="#!" class="badge bg-primary/15 text-primary text-[10px]">Reply</a>
          </div>
        </div>
      </li>
    </ul>
    <div class="text-center mt-5"><a href="#!" class="underline flex gap-1 items-center justify-center font-semibold hover:text-primary"> Go to Chat Room <i class="iconify tabler--send-2"></i></a></div>
  </div>
</div>
```

**Gotchas.**
- `bg-light/15!` and `pt-1.25!` use the `!` important suffix to beat `.card-body` defaults.
- Again two `.card-body` blocks: `card-toggle` would collapse only the intro strip.

## Comment thread card

**What it is.** A card body containing one dashed-bordered box with a root comment (avatar, name + date,
text, eye/heart/comment counters, Reply link) and nested replies indented by repeating the same flex
structure inside the parent's `grow` column.

**Use it when.**
- Comments on a blog post / product / ticket, with one level of nesting.
- Review feed with engagement counters.
- For a live two-party conversation use the Chat widget.

**Source.** `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="card">
  <div class="card-body">
    <div class="flex border border-dashed rounded p-5 border-default-300">
      <div class="shrink-0"><img src="assets/images/users/user-8.jpg" alt="" class="size-8 rounded-full shadow-sm" /></div>
      <div class="grow ms-2.5">
        <h5 class="mb-1.25">Liam Carter <small class="text-default-400">15 Apr 2025 · 09:20AM</small></h5>
        <p class="mb-2.5">Loving the new dashboard update! The UI feels much smoother and more intuitive now. Great job!</p>
        <div class="flex justify-between mt-2.5 text-default-400">
          <div class="flex gap-5"><span class="inline-flex items-center gap-1.25"><i class="iconify tabler--eye"></i> 1.2K</span><span class="inline-flex items-center gap-1.25"><i class="iconify tabler--heart"></i> 320</span><span class="inline-flex items-center gap-1.25"><i class="iconify tabler--message-circle-2"></i> 14</span></div>
          <a href="javascript:void(0);" class="text-primary hover:text-primary-hover font-semibold inline-flex items-center gap-1.25"><i class="iconify tabler--arrow-back-up"></i> Reply </a>
        </div>
        <!-- nested reply: same structure, mt-7.5 -->
        <div class="flex mt-7.5">
          <div class="shrink-0"><img src="assets/images/users/user-10.jpg" alt="" class="size-8 rounded-full shadow-sm" /></div>
          <div class="grow ms-2.5">
            <h5 class="mb-1.25">Nina Bryant <small class="text-default-400">15 Apr 2025 · 10:00AM</small></h5>
            <p class="mb-2.5">Totally agree! The load speed is noticeably faster too.</p>
            <div class="flex justify-between text-default-400">
              <div class="flex gap-5"><span class="inline-flex items-center gap-1.25"><i class="iconify tabler--eye"></i> 860</span><span class="inline-flex items-center gap-1.25"><i class="iconify tabler--heart"></i> 150</span><span class="inline-flex items-center gap-1.25"><i class="iconify tabler--message-circle-2"></i> 6</span></div>
              <a href="javascript:void(0);" class="text-primary hover:text-primary-hover font-semibold inline-flex items-center gap-1.25"><i class="iconify tabler--arrow-back-up"></i> Reply </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

## Chat widget card

**What it is.** A card with a fixed-height (`h-95`) SimpleBar-scrolled body of message bubbles
(incoming: avatar left, `bg-warning/15`; outgoing: `justify-end`, `bg-info/15`, avatar right) and a
footer composer with an icon input and a round send button.

**Use it when.**
- Embedded support chat / team chat panel on a dashboard.
- Order or ticket conversation on a detail page.
- For the full-page messenger use the Chat app page, not this widget.

**Source.** `references/sources/pages/widgets.html`. SimpleBar via `data-simplebar` (bundled in
`vendors.min.js`).

**Markup.**

```html
<div class="card">
  <div class="card-header"><h4 class="card-title">Chat</h4></div>
  <div class="card-body h-95 py-0" data-simplebar>
    <!-- incoming -->
    <div class="my-5 flex items-start gap-2.5">
      <img src="assets/images/users/user-5.jpg" class="size-9 rounded-full" alt="User" />
      <div>
        <div class="bg-warning/15 font-medium rounded px-5 py-2.5">Hey! Are you available for a quick call?</div>
        <div class="text-default-400 mt-1.25 flex items-center gap-1 text-xs"><i class="iconify tabler--clock"></i> 08:55 am </div>
      </div>
    </div>
    <!-- outgoing -->
    <div class="my-5 flex items-start justify-end gap-2.5">
      <div>
        <div class="bg-info/15 font-medium rounded px-5 py-2.5">Sure, give me 5 minutes. Just wrapping something up.</div>
        <div class="text-default-400 mt-1.5 flex items-center justify-end gap-1 text-xs"><i class="iconify tabler--clock"></i> 08:57 am </div>
      </div>
      <img src="assets/images/users/user-2.jpg" class="size-9 rounded-full" alt="User" />
    </div>
  </div>
  <div class="border-default-300 border-t border-dashed px-5 py-3.75">
    <div class="flex gap-2.5">
      <div class="input-icon-group grow"><i class="iconify tabler--message-dots input-icon text-default-400"></i><input type="text" class="form-input border-light bg-light/20" placeholder="Enter message..." /></div>
      <a data-send href="#!" class="btn btn-icon bg-primary size-9.5 text-white"><i class="iconify tabler--send-2 text-xl"></i></a>
    </div>
  </div>
</div>
```

**Gotchas.**
- `data-send` has no handler in app.js or the page; wire your own submit.
- `h-95` (23.75rem) is a real utility; SimpleBar needs a bounded height to scroll.

## Contact info solid-colour cards

**What it is.** Two small solid-colour cards (`bg-purple`, `bg-success`) with a translucent icon disc,
an uppercase label and two lines of contact text at 75 % white.

**Use it when.**
- Support contact block on a dashboard or help page; office phone/email on a company profile.
- Any pair of "quick facts" cards that should pop against the neutral grid.

**Source.** `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="grid md:grid-cols-2 grid-cols-1 gap-base">
  <div>
    <div class="card text-white bg-purple border-0">
      <div class="card-body">
        <div class="flex items-center mb-5 gap-2.5">
          <div><span class="flex justify-center items-center size-9 bg-light/20 text-white rounded-full"><i class="iconify tabler--phone text-xl"></i></span></div>
          <p class="font-semibold">PHONE</p>
        </div>
        <h5 class="mb-1.25 text-white/75">+1 800 123 4567</h5>
        <h5 class="mb-0 text-white/75">+1 800 765 4321</h5>
      </div>
    </div>
  </div>
  <div>
    <div class="card text-white bg-success border-0">
      <div class="card-body">
        <div class="flex items-center mb-5 gap-2.5">
          <div><span class="flex justify-center items-center size-9 bg-light/20 text-white rounded-full"><i class="iconify tabler--mail text-xl"></i></span></div>
          <p class="font-semibold">EMAIL</p>
        </div>
        <h5 class="mb-1.25 text-white/75">support@example.com</h5>
        <h5 class="mb-0 text-white/75">sales@example.com</h5>
      </div>
    </div>
  </div>
</div>
```

## Profile summary card with cover image

**What it is.** A card whose top is a 180px cover photo with a dark gradient overlay and an italic
"Welcome!" caption; the body overlaps it with a `size-20` avatar pulled up by `-60px`, the name, "Member
since", and a round primary dots-menu (`hs-dropdown`) pulled up with `-mt-10`.

**Use it when.**
- Current-user header on a profile/settings page or a "my account" dashboard column.
- Team member / customer header on a detail page; the dropdown holds Edit / Report actions.

**Source.** `references/sources/pages/widgets.html`. Cover image `assets/images/profile-bg.jpg`.

**Markup.**

```html
<div class="card">
  <div class="relative overflow-hidden rounded-t-sm bg-center bg-no-repeat bg-cover bg-[url('../images/profile-bg.jpg')]" style="height: 180px">
    <div class="h-full p-7.5 bg-linear-to-t from-[#313a46] via-[rgba(49,58,70,0.8)] to-[rgba(49,58,70,0.5)] inset-0 absolute rounded-s-sm flex rounded-t-sm items-center justify-center">
      <h5 class="text-white italic">"Welcome!"</h5>
    </div>
  </div>
  <div class="card-body relative">
    <div class="flex justify-start gap-5">
      <div class="size-20" style="margin-top: -60px"><a href="#!"><img src="assets/images/users/user-2.jpg" alt="User Profile" class="p-1 bg-body-bg border border-default-300 rounded-full" /></a></div>
      <div>
        <h4 class="text-nowrap font-bold mb-1.25"><a href="#!" class="text-lg">Damian D.</a></h4>
        <p class="text-default-400 mb-0">Member since Jan 2021</p>
      </div>
      <div class="relative -mt-10 ms-auto">
        <div class="hs-dropdown inline-flex [--placement:bottom-right]">
          <button type="button" class="hs-dropdown-toggle size-9.5 bg-primary text-white btn btn-icon rounded-full" aria-haspopup="menu" aria-expanded="false" aria-label="Dropdown"><i class="iconify tabler--dots text-2xl"></i></button>
          <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical" tabindex="-1">
            <div class="space-y-0.5"><a href="#" class="dropdown-item"> Edit Profile </a><a href="#" class="dropdown-item text-danger"> Report </a></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- The `bg-[url('../images/profile-bg.jpg')]` path is relative to the CSS file, not the page; keep images
  under `assets/images/` or the arbitrary value breaks.
- `card-side-img` and `auth-overlay` in the source have no CSS rules (removed above).

## File list card with avatar stack

**What it is.** A header with a round "+" button, then rows of: a `size-9` file-type icon tile, file name
link + size, a `-space-x-2` avatar stack of collaborators that lift on hover, and a square bordered
download button.

**Use it when.**
- "Recent files" / "Shared with me" panel on a dashboard or project page.
- Attachments list on a ticket, deal or order with who has access.
- For a full browser with folders use the File Manager app page.

**Source.** `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header justify-between">
    <h4 class="card-title">File Manage</h4>
    <a href="javascript: void(0);" class="btn bg-light btn-sm btn-icon rounded-full hover:text-primary hover:bg-primary/15"><i class="iconify tabler--plus"></i></a>
  </div>
  <div class="card-body">
    <!-- repeat; last row drops pb-2.5 -->
    <div class="flex justify-between items-center pb-2.5">
      <div class="flex items-center py-1.25 gap-2.5">
        <div class="size-9 bg-light/50 text-default-400 rounded-md flex justify-center items-center"><i class="iconify tabler--file-text text-xl"></i></div>
        <div class="grow">
          <h5 class="mb-1.25 text-sm"><a href="#!">Meeting-Notes.docx</a></h5>
          <p class="text-default-400 text-xs">1.2MB</p>
        </div>
      </div>
      <div class="flex items-center -space-x-2 transition-all duration-300">
        <div><img src="assets/images/users/user-4.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-1" alt="" /></div>
        <div><img src="assets/images/users/user-7.jpg" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-1" alt="" /></div>
      </div>
      <div><a href="#" class="btn btn-sm size-8 border border-default-300 hover:border-default-400 hover:bg-default-50 transition-all duration-400" title="Download"><i class="iconify tabler--download text-lg"></i></a></div>
    </div>
  </div>
</div>
```

File icons used: `tabler--file-text`, `tabler--file-type-pdf`, `tabler--file-type-zip`,
`tabler--file-type-ppt`, `tabler--photo`.

**Gotchas.**
- Source has `transitio-all` (typo) on the avatars and `link-reset` on the name; neither exists. Use
  `transition-all`; the link needs no reset class.

## Today's schedule / agenda card

**What it is.** A header with an "Invite" link, then dashed-separated blocks: event title, a coloured
one-line description, and a row with an attendee avatar stack (plus an initials disc) and a round soft
action button (Figma / calendar icon).

**Use it when.**
- Today's meetings on a home page; upcoming interviews on an HR board.
- Shift roster / on-call schedule widget with "join" or "open doc" actions.

**Source.** `references/sources/pages/widgets.html`.

**Markup.**

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Today's Schedule</h4>
    <a href="javascript: void(0);" class="text-primary font-semibold hover:text-primary-hover"><i class="iconify tabler--calendar me-1"></i><span>Invite</span></a>
  </div>
  <div class="card-body">
    <!-- first block pb-2.5, following blocks py-2.5 -->
    <div class="pb-2.5 border-b border-light border-dashed">
      <div class="mb-2.5">
        <p class="mb-1.25 truncate text-sm font-medium">Design Review Meeting</p><span class="text-warning text-xs">30 minute session with UI/UX team</span>
      </div>
      <div class="flex justify-between items-center">
        <div class="flex items-center -space-x-2 transition-all duration-300">
          <div><img src="assets/images/users/user-5.jpg" alt="Liam Carter" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-1" /></div>
          <div><img src="assets/images/users/user-6.jpg" alt="Zoe Miles" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-1" /></div>
          <div><span class="size-6 flex justify-center items-center rounded-full bg-primary/15 text-primary font-bold"> D </span></div>
        </div>
        <button type="button" class="btn size-8 bg-secondary/15 text-secondary hover:bg-secondary hover:text-white rounded-full"><i class="iconify tabler--brand-figma text-lg"></i></button>
      </div>
    </div>
    <div class="py-2.5 border-b border-light border-dashed">
      <div class="mb-2.5">
        <p class="mb-1.25 truncate text-sm font-medium">Sprint Planning Session</p><span class="text-success text-xs">1 hour agile team meeting</span>
      </div>
      <div class="flex justify-between items-center">
        <div class="flex items-center -space-x-2 transition-all duration-300">
          <div><img src="assets/images/users/user-7.jpg" alt="Ava Lee" class="size-6 rounded-full transition-all duration-200 hover:-translate-y-1" /></div>
        </div>
        <button type="button" class="btn size-8 bg-secondary/15 text-secondary hover:bg-secondary hover:text-white rounded-full"><i class="iconify tabler--calendar-event text-lg"></i></button>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.**
- Source uses `justify-content-between` on the header (Bootstrap) and `text-truncate`; `.card-header` is
  already `display:flex; justify-content:space-between`, so drop it; use `truncate`.

## Summary cards with chart footer

**What it is.** Three metrics.html cards with a padded top (`p-5`, big counter + unit word + sentence)
and a full-bleed 120px ECharts chart at the bottom: a stacked bar chart (Orders), a white-on-secondary
stacked area (Products, card is `bg-secondary`) and a single primary line (Profit).

**Use it when.**
- Three "hero numbers with context" at the bottom of a metrics wall: orders, products, profit.
- Marketing: subscribers, open rate, revenue with 7-day shape.

**Source.** `references/sources/pages/metrics.html`; init in `assets/js/pages/metrics.js`.

**Markup.**

```html
<div class="grid xl:grid-cols-3 grid-cols-1 gap-base">
  <div class="card">
    <div class="p-5">
      <h3 class="mb-5 text-xl font-bold"><span data-target="421">421</span><span class="text-default-400 ms-1.25 text-sm">Orders</span></h3>
      <p class="mb-0">You have received 421 new orders, indicating a healthy sales trend over the past period.</p>
    </div>
    <div id="orders-chart" style="min-height: 120px" class="mb-5"></div>
  </div>
  <div class="card bg-secondary">
    <div class="p-5 mb-5">
      <h3 class="mb-5 text-xl font-bold text-white"><span data-target="185">185</span><span class="text-white/50 ms-1.25 text-sm">Products</span></h3>
      <p class="text-white/50">You currently have 185 active products available across your store inventory.</p>
    </div>
    <div id="product-chart" style="min-height: 120px"></div>
  </div>
  <div class="card">
    <div class="card-body">
      <h3 class="mb-5 font-bold text-xl">$<span data-target="12.5">0</span>k<span class="text-default-400 ms-1.25 text-sm">Profit</span></h3>
      <p class="mb-5">Your total profit reached $12,500 this month, showing stable and positive business growth.</p>
      <div id="profit-chart" style="min-height: 120px"></div>
    </div>
  </div>
</div>
```

**Init / JS.** (metrics.js; all three share the house tooltip block shown in the Revenue card)

```js
// #orders-chart: 3 stacked bar series, axes/legend hidden, grid pulled to the edges
new CustomEChart({ selector: "#orders-chart", options: () => ({
  legend: { show: false }, tooltip: { /* house style, borderColor theme("default-300") */ },
  grid: { left: "-6%", right: "2%", bottom: "2%", top: "0%", containLabel: true },
  xAxis: { type: "category", data: ["Q1","Q2","Q3","Q4","Q5","Q6","Q7"], axisLine: { show: false }, axisTick: { show: false } },
  yAxis: { show: false },
  series: [
    { name: "Product A", type: "bar", stack: "total", barWidth: "40%", itemStyle: { color: theme("primary") },  data: [120,132,101,134,98,145,160] },
    { name: "Product B", type: "bar", stack: "total", itemStyle: { color: theme("secondary") },               data: [220,182,191,234,210,198,176] },
    { name: "Product C", type: "bar", stack: "total", itemStyle: { color: "#bbcae14d" },                      data: [150,232,201,154,189,165,140] },
  ] }) });

// #product-chart: two translucent-white smooth areas on a bg-secondary card
series: [{ type: "line", smooth: true, symbol: "none", lineStyle: { width: 0 }, areaStyle: { color: theme("white", .5) }, data: [...] }, { /* same */ }]
grid: { left: 0, right: 0, top: 10, bottom: 0, containLabel: false }, xAxis: { boundaryGap: ["0%","0%"], axisLabel: { show: false }, ... }, yAxis: { show: false }

// #profit-chart: single primary line, no area
series: [{ name: "Data", type: "line", smooth: true, symbol: "none", lineStyle: { color: theme("primary"), width: 2 }, data: [4,8,5,10,4,16,5,11,6,11,30,10,13,4,6,3,6] }]
```

**Gotchas.**
- metrics.js and dashboard-ecommerce.js both register `#orders-chart`; they are never loaded on the same
  page, but rename one if you merge pages.
- The Orders and Products charts sit outside `.card-body` so the canvas runs to the card edge; the
  `boundaryGap: ["0%","0%"]` / `grid` zeroing is what makes the area flush.

## Product inventory table card (custom-table.js runtime)

**What it is.** A `.card` carrying `data-table data-table-rows-per-page="5"`, a header with
"Add Product" (soft secondary) and "Export CSV" (primary) small buttons, a `thead`-less
`table table-sm table-hover` where every cell carries its own small grey label above the value
(product thumbnail + name + category, Stock, Price, star Ratings with count, Status with a coloured dot,
and a `hs-dropdown` kebab), and a `card-footer` with pagination info + page links generated by
`assets/js/pages/custom-table.js`.

**Use it when.**
- Inventory, catalogue, SKU lists on a store dashboard.
- Any compact paginated list in a half-width card where column headers would waste space (labelled cells).
- For sortable / filterable / searchable full tables with a `<thead>`, see the Campaign table below; for
  heavy grids use the DataTables pages instead.

**Source.** `references/sources/pages/dashboard-ecommerce.html`; runtime
`references/sources/assets/js/pages/custom-table.js` (auto-instantiates `new CustomTable()` on
DOMContentLoaded; no page code needed).

**Markup.**

```html
<div data-table data-table-rows-per-page="5" class="card">
  <div class="card-header justify-between items-center border-dashed">
    <h4 class="card-title mb-0">Product Inventory</h4>
    <div class="flex gap-2.5">
      <a href="#!" class="btn btn-sm text-sm bg-secondary/15 text-secondary hover:text-white hover:bg-secondary"><i class="iconify tabler--plus me-1"></i> Add Product </a>
      <a href="javascript:void(0);" class="btn btn-sm text-sm bg-primary text-white hover:bg-primary-hover"><i class="iconify tabler--file-export"></i> Export CSV </a>
    </div>
  </div>
  <div class="table-wrapper whitespace-nowrap">
    <table class="table table-sm table-hover">
      <tbody>
        <!-- repeat per product -->
        <tr>
          <td class="ps-4">
            <div class="flex items-center"><img src="assets/images/products/1.png" alt="" class="size-8 rounded-full me-2.5" />
              <div><h5 class="text-sm my-1.25"><a href="#!" class="text-default-800">Smart Watch</a></h5><span class="text-default-400 text-xs">Wearables</span></div>
            </div>
          </td>
          <td><span class="text-default-400 text-xs">Stock</span><h5 class="text-sm mt-1.25 mb-2 font-normal">120 units</h5></td>
          <td><span class="text-default-400 text-xs">Price</span><h5 class="text-sm mt-1.25 mb-2 font-normal">$89.99</h5></td>
          <td><span class="text-default-400 text-xs">Ratings</span>
            <h5 class="text-sm mt-1.25 mb-2 font-normal"><span class="text-warning"><span class="iconify tabler--star-filled"></span><span class="iconify tabler--star-filled"></span><span class="iconify tabler--star-filled"></span><span class="iconify tabler--star-filled"></span><span class="iconify tabler--star"></span></span><span class="ms-1.25"><a href="#!" class="font-semibold hover:text-primary">(45)</a></span></h5></td>
          <td><span class="text-default-400 text-xs">Status</span><h5 class="text-sm mt-1.25 mb-2 font-normal"><i class="iconify tabler--circle-filled text-success"></i> Active</h5></td>
          <td style="width: 30px" class="text-end pe-4.5">
            <div class="relative ms-auto">
              <div class="hs-dropdown inline-flex [--placement:bottom-right]">
                <button type="button" class="hs-dropdown-toggle" aria-haspopup="menu" aria-expanded="false" aria-label="Dropdown"><i class="iconify tabler--dots-vertical text-lg text-default-400"></i></button>
                <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical">
                  <div class="space-y-0.5"><a href="#" class="dropdown-item"> Edit Product </a><a href="#" class="dropdown-item"> Remove </a></div>
                </div>
              </div>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  <div class="card-footer">
    <div class="items-center justify-between flex text-center w-full md:text-start">
      <div><div data-table-pagination-info="products"></div></div>
      <div class="mt-5 sm:mt-0"><div data-table-pagination></div></div>
    </div>
  </div>
</div>
```

Status dot colours: `text-success` Active, `text-warning` Low Stock, `text-danger` Out of Stock.

**Init / JS.** Nothing to write; include the script. The runtime's hooks (all looked up INSIDE the
`[data-table]` element):

| Attribute | Where | Effect |
|---|---|---|
| `data-table` | the card (or any wrapper containing one `table`) | marks a table instance |
| `data-table-rows-per-page="5"` | same element | page size (default 10) |
| `data-table-pagination` | footer div | receives `ul.pagination > li.page-item > a.page-link` (prev / 1..n / next) |
| `data-table-pagination-info="products"` | footer div | "Showing 1 to 5 of 12 products" (value = noun, default "entries") |
| `data-table-sort` | `<th>` | click-to-sort that column; needs a `<thead>` |
| `data-table-search` | `<input>` | keyup filter over all cell text |
| `data-table-filter="<col>"` on a `select`/`input` + `data-column="<col>"` on the matching `<th>` | exact-match filter ("All" = no filter) |
| `data-table-range-filter="<col>"` | `select` | numeric ranges `0-100`, `500+`; for columns whose name contains "date": Today / Last 7 Days / Last 30 Days / This Year |
| `data-table-set-rows-per-page` | `select` | page-size switcher (options rebuilt from existing values) |
| `data-table-select-all` in `thead` + `input[type=checkbox]` per row | bulk select; shows `[data-table-delete-selected]` |
| `data-table-delete-selected`, `data-table-delete-row` | buttons | open an injected Preline confirm modal (`#confirm-delete-modal`) then remove rows |

Sorting parses `1,234`, `$3.64M` (K/M/B suffix), `18.22%`, `(45)` counts, ordinals, numbers and dates;
a `data-sort="<key>"` child element can supply the sort text for a cell.

**Gotchas.**
- The card is `data-table`, not the `<table>`; the footer hooks must be inside the same card.
- No `<thead>` here, so sorting/filters are unavailable; only pagination works. Add a `thead` with
  `data-table-sort` headers if you need sorting.
- The demo's second "Product Inventory" card is actually the Recent Orders table (copy-paste title).
- The `fs-xs` class on the status dot is a Bootstrap leftover (removed above).
- Dropdown items in the source carry a duplicated `href` attribute; harmless, cleaned above.

## Recent orders table card

**What it is.** The same `data-table` card as the inventory table with different columns: customer
avatar + order number + name, Product, Date, Amount, Status (Delivered / Pending / Completed /
Cancelled dots) and a kebab with View Details / Cancel Order. Header buttons "Add Order" / "Export CSV".

**Use it when.**
- Latest orders on a store home, latest bookings, latest invoices.
- Pair it side by side with the inventory card in `grid xl:grid-cols-2`.

**Source.** `references/sources/pages/dashboard-ecommerce.html`; runtime `custom-table.js`.

**Markup.** (one row; wrapper, header, footer identical to the inventory card with
`data-table-pagination-info="orders"`)

```html
<tr>
  <td class="ps-4">
    <div class="flex items-center"><img src="assets/images/users/user-1.jpg" alt="" class="size-8 rounded-full me-2.5" />
      <div><h5 class="text-sm my-1.25"><a href="#!" class="text-body">#ORD-1001</a></h5><span class="text-default-400 text-xs">John Doe</span></div>
    </div>
  </td>
  <td><span class="text-default-400 text-xs">Product</span><h5 class="text-sm mt-1.25 mb-2 font-normal">Smart Watch</h5></td>
  <td><span class="text-default-400 text-xs">Date</span><h5 class="text-sm mt-1.25 mb-2 font-normal">2025-04-29</h5></td>
  <td><span class="text-default-400 text-xs">Amount</span><h5 class="text-sm mt-1.25 mb-2 font-normal">$89.99</h5></td>
  <td><span class="text-default-400 text-xs">Status</span><h5 class="text-sm mt-1.25 mb-2 font-normal"><i class="iconify tabler--circle-filled text-success"></i> Delivered</h5></td>
  <td style="width: 30px" class="text-end pe-4.5"><!-- hs-dropdown kebab: View Details / Cancel Order --></td>
</tr>
```

Status dots: `text-success` Delivered / Completed, `text-warning` Pending, `text-danger` Cancelled.

## Campaign performance sortable table card

**What it is.** A full-width `data-table` card with a proper `<thead>` (Campaign + nine numeric columns,
all but the first `data-table-sort`), rows that start with a coloured Tabler icon, green/orange highlights
on notable cells, and the standard pagination footer.

**Use it when.**
- Campaign / channel performance, ad-set metrics, A/B test results.
- Any wide numeric table that needs click-to-sort without DataTables.

**Source.** `references/sources/pages/dashboard-analytics.html`; runtime `custom-table.js`.

**Markup.**

```html
<div data-table data-table-rows-per-page="5" class="card">
  <div class="card-header">
    <h5 class="card-title">Top Campaign Performance</h5>
    <div class="flex gap-1"><!-- card action buttons --></div>
  </div>
  <div class="card-body p-0">
    <div class="table-wrapper whitespace-nowrap">
      <table class="table table-hover mb-0">
        <thead class="bg-light/25 thead-sm">
          <tr class="uppercase text-2xs">
            <th class="text-default-400">Campaign</th>
            <th data-table-sort class="text-default-400">Visitors</th>
            <th data-table-sort class="text-default-400">New Users</th>
            <th data-table-sort class="text-default-400">Sessions</th>
            <th data-table-sort class="text-default-400">Bounce Rate</th>
            <th data-table-sort class="text-default-400">Pages/Visit</th>
            <th data-table-sort class="text-default-400">Avg. Duration</th>
            <th data-table-sort class="text-default-400">Leads</th>
            <th data-table-sort class="text-default-400">Revenue</th>
            <th data-table-sort class="text-default-400">Conversion</th>
          </tr>
        </thead>
        <tbody class="text-sm">
          <!-- repeat -->
          <tr><td><i class="iconify tabler--rocket text-primary me-1 text-base"></i> Spring Launch</td><td>502</td><td>260</td><td>6,845</td><td><span class="text-success">18.22%</span></td><td>3.15</td><td>01:40</td><td>432</td><td><span class="text-success">$3.64M</span></td><td>6.15%</td></tr>
          <tr><td><i class="iconify tabler--brand-facebook text-info text-base me-1"></i> Facebook Push</td><td>478</td><td>245</td><td>6,120</td><td><span class="text-warning">21.03%</span></td><td>2.87</td><td>01:28</td><td>398</td><td>$3.10M</td><td>5.65%</td></tr>
        </tbody>
      </table>
    </div>
  </div>
  <div class="card-footer">
    <div data-table-pagination-info></div>
    <div data-table-pagination></div>
  </div>
</div>
```

**Gotchas.**
- The runtime appends an up/down arrow SVG to each sortable `th` and flips `data-direction`; do not put
  an `<i>` inside the `th` unless you want it reused as the indicator.
- `01:40` durations are compared as strings (`localeCompare`), which happens to sort correctly for
  zero-padded mm:ss.

## Transactions table + world vector map card

**What it is.** A card whose body is a 2-column grid: left a `table-custom` transactions table
(Tran. No. link, order, date + time, amount, soft status badge with a dot, card-brand image + last 4) with
a "View All Transactions" link; right a 297px jsVectorMap world map with selected regions, four markers,
animated dashed route lines and a custom pin image.

**Use it when.**
- Payments / transactions by geography on a store or fintech dashboard.
- Shipment tracking: markers for hubs, lines for lanes.
- Logistics NOC board: region selection + marker tooltips.

**Source.** `references/sources/pages/dashboard-ecommerce.html`; init in
`assets/js/pages/dashboard-ecommerce.js`; libs `assets/plugins/jsvectormap/jsvectormap.min.js`,
`assets/js/maps/world-merc.js`, `assets/js/maps/world.js` (not vendored, see Shared runtime). Card
images `assets/images/cards/{mastercard,visa,american-express}.svg`; pin `assets/images/location-pin.png`.

**Markup.**

```html
<div class="card">
  <div class="card-header justify-between items-center">
    <h5 class="card-title">Transactions Worldwide</h5>
    <div class="flex gap-1"><!-- card action buttons --></div>
  </div>
  <div class="card-body">
    <div class="grid xl:grid-cols-2 grid-cols-1 gap-base">
      <div>
        <div class="overflow-x-auto">
          <table class="table table-custom table-nowrap table-hover table-centered whitespace-nowrap min-w-full">
            <thead class="bg-light/25 align-middle thead-sm">
              <tr class="uppercase text-2xs"><th class="text-default-400">Tran. No.</th><th class="text-default-400">Order</th><th class="text-default-400">Date</th><th class="text-default-400">Amount</th><th class="text-default-400">Status</th><th class="text-default-400">Payment Method</th></tr>
            </thead>
            <tbody class="border-b border-default-300">
              <!-- repeat -->
              <tr><td><a href="#!" class="hover:text-primary font-semibold">#TR-3468</a></td><td>#ORD-1003 - Smart Watch</td><td>27 Apr 2025 <small class="text-default-400">02:15 PM</small></td><td class="font-semibold">$89.99</td><td><span class="badge bg-success/15 text-success text-2xs"><i class="iconify tabler--point-filled"></i> Paid</span></td><td class="flex items-center"><img src="assets/images/cards/mastercard.svg" alt="" class="me-2.5 h-7" /> xxxx 1123</td></tr>
              <tr><td><a href="#!" class="hover:text-primary font-semibold">#TR-3469</a></td><td>#ORD-1004 - Gaming Mouse</td><td>26 Apr 2025 <small class="text-default-400">09:42 AM</small></td><td class="font-semibold">$24.99</td><td><span class="badge bg-danger/15 text-danger text-2xs"><i class="iconify tabler--point-filled"></i> Failed</span></td><td class="flex items-center"><img src="assets/images/cards/visa.svg" alt="" class="me-2.5 h-7" /> xxxx 3490</td></tr>
            </tbody>
          </table>
        </div>
        <div class="text-center mt-5"><a href="#!" class="underline font-semibold hover:text-primary flex gap-1 items-center justify-center"> View All Transactions <i class="iconify tabler--send-2"></i></a></div>
      </div>
      <div>
        <div id="map_1" class="w-full mt-7.5 xl:mt-0" style="height: 297px"></div>
      </div>
    </div>
  </div>
</div>
```

**Init / JS.**

```js
const map = new jsVectorMap({
  map: "world", selector: "#map_1",
  zoomOnScroll: true, zoomButtons: false,
  selectedRegions: ["CA", "US", "AU"], selectedMarkers: [1, 1], markersSelectable: true,
  regionStyle: { initial: { stroke: "#a2abbd", strokeWidth: .5, fillOpacity: .1 }, selected: { fill: theme("primary") } },
  markers: [
    { name: "Russia",    coords: [61.524, 105.3188] },
    { name: "Canada",    coords: [56.1304, -106.3468], style: { initial: { image: "assets/images/location-pin.png" } } },
    { name: "Australia", coords: [-25.2744, 133.7751] },
    { name: "Greenland", coords: [71.7069, -42.6043] },
  ],
  lines: [{ from: "Russia", to: "Canada" }, { from: "Australia", to: "Canada" }, { from: "Greenland", to: "Canada" }, { from: "Brazil", to: "Canada" }],
  markerStyle: { initial: { fill: theme("primary"), stroke: theme("primary"), fillOpacity: .3, strokeWidth: 2, r: 2 },
                 selected: { fill: theme("primary"), stroke: theme("primary"), strokeWidth: 1 } },
  labels: { markers: { render: (m) => m.name } },
  lineStyle: { animation: true, strokeDasharray: "6 3 6" },
});
window.addEventListener("resize", debounce(() => map.updateSize(), 200));
```

**Gotchas.**
- jsVectorMap is NOT wrapped by a Custom* class, so it does not re-colour on theme change; re-create it
  (or call `map.destroy()` and rebuild) inside your own `MutationObserver` on `<html>` if dark mode matters.
- `lines` reference markers by `name`; "Brazil" has no marker, so that line silently does nothing.
- `table-custom`, `table-nowrap`, `table-centered` come from the table component CSS; `whitespace-nowrap`
  and `min-w-full` do the actual work here.

## Grid recipe: Projects dashboard (index.html)

**What it is.** The default landing page of the admin. Three bands, no `.page-title-head`.

**Composition.**

```html
<main>
  <div class="container-fluid">
    <!-- Band 1: one hero card split into 4 columns by dashed borders (no inner .card) -->
    <div class="card my-5">
      <div class="grid xl:grid-cols-4 grid-cols-1">
        <div class="col-span-1"><div class="p-7.5 border-e border-dashed border-default-300">Welcome / agenda</div></div>
        <div class="col-span-2"><div class="py-5 px-7.5 border-e border-dashed border-default-300">Revenue chart (252px)</div></div>
        <div class="col-span-1"><div class="card-body">Project progress rose (278px)</div></div>
      </div>
    </div>
    <!-- Band 2: five stat tiles -->
    <div class="grid xl:grid-cols-5 md:grid-cols-3 grid-cols-1 gap-base mb-5"> …5 × .card… </div>
    <!-- Band 3: three equal columns; the first column stacks two cards -->
    <div class="grid xl:grid-cols-3 grid-cols-1 gap-base">
      <div class="flex flex-col gap-base">
        <div class="card">Quarterly Reports table</div>
        <div class="card">Project Performance bars</div>
      </div>
      <div class="card">Latest Project Updates timeline</div>
      <div class="card">Discussions list</div>
    </div>
  </div>
</main>
```

Notes: `gap-base` is 20px (`--spacing-base`), the same as `.card-body` padding (`spacing*5`), so the
gutters match the card padding. Column stacking inside a grid cell is done with `flex flex-col gap-base`,
not nested grids. The hero card uses `my-5` instead of `page-title-head` spacing. Cards in a grid row
stretch to equal height automatically (grid items), so the timeline and discussion cards match the
stacked pair on the left.

Scripts: `vendors.min.js`, `app.js`, `assets/plugins/echarts/echarts.min.js`,
`assets/js/pages/dashboard-projects.js`.

## Grid recipe: Analytics dashboard (dashboard-analytics.html)

**Composition.**

```html
<main>
  <div class="page-title-head">
    <h4 class="page-main-title">Analytics</h4>
    <div class="hidden items-center gap-1.25 text-sm md:flex"><a href="#" class="text-sm">Inspinia</a><i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i><a href="#" class="text-sm">Dashboard</a><i class="iconify tabler--chevron-right text-sm rtl:rotate-180"></i><a href="#" class="text-default-400 text-sm" aria-current="page">Analytics</a></div>
  </div>
  <div class="container-fluid">
    <!-- Band 1: hero card, 1/4 KPI column + 3/4 chart, zero gap, dashed divider -->
    <div class="card mb-5"><div class="card-body p-0">
      <div class="grid xl:grid-cols-4 grid-cols-1 gap-0">
        <div class="flex flex-col xl:order-1 order-2">4 dashed KPI panels</div>
        <div class="xl:col-span-3 border-s border-default-300 border-dashed xl:order-2 order-1">card-header + area chart (341px)</div>
      </div>
    </div></div>
    <!-- Band 2: three equal cards -->
    <div class="grid xl:grid-cols-3 grid-cols-1 gap-base mb-5">
      <div class="card">Sessions Device (bubble 223px + table)</div>
      <div class="card">Traffic Sources</div>
      <div class="card">Top 10 Countries</div>
    </div>
    <!-- Band 3: full-width sortable table -->
    <div data-table data-table-rows-per-page="5" class="card">Top Campaign Performance</div>
  </div>
</main>
```

Notes: the hero uses `card-body p-0` + `gap-0` so the KPI boxes draw their own dashed borders with
`m-1.25`. Each band ends with `mb-5` except the last. The page also includes a fixed `lg:hidden` danger
button that opens the aside offcanvas (`data-hs-overlay="#asidebar-offcanvas"`), part of the shared chrome.

Scripts: `vendors.min.js`, `app.js`, `assets/js/pages/custom-table.js`,
`assets/plugins/apexcharts/apexcharts.min.js`, `assets/js/pages/dashboard-analytics.js`.

## Grid recipe: eCommerce dashboard (dashboard-ecommerce.html)

**Composition.**

```html
<main>
  <div class="page-title-head">…eCommerce breadcrumb…</div>
  <div class="container-fluid">
    <!-- Band 1: four donut KPI tiles -->
    <div class="grid xl:grid-cols-4 md:grid-cols-2 grid-cols-1 gap-base mb-5"> …4 × .card… </div>
    <!-- Band 2: Orders Statistics card: header with tabs; body = 2/3 chart (405px) + 1/3 mini-stat panel -->
    <div class="card mb-5">
      <div class="card-header py-0 border-dashed flex items-center">title + hs-tab nav</div>
      <div class="grid xl:grid-cols-3 grid-cols-1">
        <div class="xl:col-span-2 border-e border-dashed border-default-300"><div id="orders-chart" style="min-height: 405px"></div></div>
        <div class="col-span-1">CTA strip + 2×2 sub-cards + link</div>
      </div>
    </div>
    <!-- Band 3: two half-width paginated tables -->
    <div class="grid xl:grid-cols-2 grid-cols-1 gap-base mb-5">
      <div data-table data-table-rows-per-page="5" class="card">Product Inventory</div>
      <div data-table data-table-rows-per-page="5" class="card">Recent Orders</div>
    </div>
    <!-- Band 4: full-width card, body split 50/50 -->
    <div class="card">
      <div class="card-body"><div class="grid xl:grid-cols-2 grid-cols-1 gap-base">
        <div>transactions table</div>
        <div><div id="map_1" style="height: 297px"></div></div>
      </div></div>
    </div>
  </div>
</main>
```

Notes: half-width tables use the labelled-cell pattern (no `thead`) so six columns fit at xl/2. The map
column gets `mt-7.5 xl:mt-0` so it separates from the table when stacked.

Scripts: `vendors.min.js`, `app.js`, `assets/plugins/echarts/echarts.min.js`,
`assets/js/pages/custom-table.js`, `assets/plugins/jsvectormap/jsvectormap.min.js`,
`assets/js/maps/world-merc.js`, `assets/js/maps/world.js`, `assets/js/pages/dashboard-ecommerce.js`.

## Page composition: widgets.html and metrics.html

**widgets.html** (no page script; counters only): `page-title-head` then, in order,
1. `.card > .card-body > grid xl:grid-cols-4 … gap-base` of four tinted stat tiles (one block);
2. `grid xl:grid-cols-3 gap-base mb-5`: mini-stat panel card / Traffic Sources / Top 10 Countries;
3. `grid xl:grid-cols-3 gap-base mb-5` with three `flex flex-col gap-base` columns: [profile card,
   comment thread], [chat card, `grid md:grid-cols-2` of two contact cards], [file list, today's schedule];
4. `grid xl:grid-cols-5 md:grid-cols-3` five stat tiles (neutral / coloured-icon / solid / tinted mix);
5. `grid xl:grid-cols-4 md:grid-cols-2` four large-icon-disc tiles;
6. `grid xl:grid-cols-4 md:grid-cols-2` four KPI progress tiles;
7. `grid xl:grid-cols-6 md:grid-cols-3` six icon-over-number counters.

**metrics.html** (`metrics.js` + ECharts): `page-title-head` then five `grid xl:grid-cols-4 md:grid-cols-2
grid-cols-1 gap-base mb-5` rows of four tiles (donut, bar sparkline, area sparkline, pie), then a
`grid xl:grid-cols-3` whose first cell is the Quarterly Reports card and whose `xl:col-span-2` cell nests
another `grid xl:grid-cols-3 gap-base` with the three summary-with-chart-footer cards.

Tile alternation on metrics.html: odd tiles put text left / chart right, even tiles chart left /
`text-end` right, which keeps a row visually balanced.

## Landing page (landing.html)

**What it is.** A one-page marketing site for the product, rendered OUTSIDE the admin shell: `<body
class="bg-card">`, a bare `div.wrapper`, no `.app-menu`/sidebar/topbar. It still loads `config.js`,
`vendors.min.js` and `app.js` (so Preline, `data-target` counters and the theme customizer offcanvas
work) and the same `assets/css/app.min.css`.

**Use it when.**
- Public home / pricing / contact page for a SaaS that uses INSPINIA for its app.
- Internal product launch page; agency portfolio page. Not for anything behind login.

**Source.** `references/sources/pages/landing.html` (read with `--body`). No page script.

**Sections in order.**

| # | id | Wrapper | Content |
|---|---|---|---|
| 0 | `#alert` | `div.relative.bg-[#1E1F27].dark:bg-primary.text-white` | announcement bar with `hs-removing:` transition classes |
| 1 | header | `header.dark:bg-body-bg.bg-card > nav.container.py-5` | logo pair (`dark:hidden` / `dark:block`), `hs-collapse` hamburger, 7 anchor links, Sign In / Sign Up |
| 2 | `#hero` | `section.bg-light/50.border-t.border-light.relative` | avatar stack "Trusted by 50k+", h1 with `text-primary` + italic spans, two CTA buttons, product screenshot `md:w-5/6 mx-auto rounded-t-md shadow-lg mt-15` |
| 3 | `#services` | `section.lg:pt-26.pt-12.pb-15` | kicker + h2 with `<mark>`, `grid xl:grid-cols-4 md:grid-cols-2` of 8 `card border-0 p-2 h-full` feature cards (icon disc `bg-secondary text-white`, "Know more" footer) |
| 4 | `#features` | `section.lg:py-26.py-12.bg-light/30.border-t.border-b.border-default-300` | three `grid xl:grid-cols-12 … items-center` rows alternating image (`xl:col-span-5`) and copy (`xl:col-span-7 lg:w-132.5 lg:ms-auto`) with three `data-target` stats each |
| 5 | `#plans` | `section.lg:py-26.py-12` | `lg:w-5/6 mx-auto > grid xl:grid-cols-3` pricing tiles |
| 6 | CTA | `section.min-h-87.5.relative.overflow-hidden.bg-cover.bg-[url('../images/landing-cta.jpg')]` | gradient overlay `bg-linear-to-t from-[#313a46] …`, white h3, `btn bg-light rounded-full` |
| 7 | `#reviews` | `section.lg:py-26.py-12.relative.overflow-hidden` | three testimonial `card border-light rounded-xl p-5 h-full` (avatar, 5 `tabler--star-filled`, quote), client-logo row `flex gap-12 flex-wrap justify-center` |
| 8 | `#blog` | `section … bg-light/30 border-t border-b` | three `article.card.rounded-md.border-0.shadow-sm` with absolute `badge bg-dark badge-label` category, image, meta row, author footer |
| 9 | `#contact` | `section.lg:py-26.py-12` | `grid xl:grid-cols-3`: contact blocks (`size-12 bg-secondary/15` icon discs) + `xl:col-span-2` form in a dashed rounded box (`form-input bg-transparent! py-2.5`, `form-textarea`) |
| 10 | footer | `footer.lg:pt-26.pt-12.pb-2.5.bg-[#1e1f27]` | `grid xl:grid-cols-12`: brand column (`xl:col-span-3`, social `btn btn-sm btn-icon rounded-full bg-dark`) + `xl:col-span-9` three link columns; copyright with `<span data-current-year>` |

**Markup conventions.**

```html
<!-- section heading block, reused by services / plans / reviews / blog / contact -->
<div class="text-center">
  <span class="text-default-400 rounded-xl inline-block">💰 Transparent and flexible pricing</span>
  <h2 class="mt-5 font-bold md:text-2xl text-xl mb-15">Choose the <mark class="italic bg-warning/20 text-default-800">License</mark> That Fits Your Needs</h2>
</div>

<!-- nav: plain anchors + Preline collapse for the hamburger -->
<button type="button" class="hs-collapse-toggle relative btn btn-icon py-1 border border-default-300" id="hs-navbar-alignment-collapse" aria-expanded="false" aria-controls="hs-navbar-alignment" aria-label="Toggle navigation" data-hs-collapse="#hs-navbar-alignment"><!-- svg burger --></button>
<div id="hs-navbar-alignment" class="hs-collapse hidden w-full overflow-hidden transition-all duration-300 lg:block lg:w-auto" aria-labelledby="hs-navbar-alignment-collapse" role="region">
  <div class="flex flex-col lg:gap-1.25 gap-y-2 lg:flex-row lg:items-center lg:mt-0 mt-2.5">
    <a class="lg:p-2 py-2 text-sm text-default-700 hover:text-primary" href="#hero">Home</a>
    <a class="lg:p-2 py-2 text-sm text-default-700 hover:text-primary" href="#services">Services</a>
    <!-- … #features #plans #reviews #blog #contact -->
  </div>
</div>

<!-- pricing tile (featured variant) -->
<div class="card h-full bg-light/10 border-dashed border-default-300 border my-7.5 lg:my-0 rounded-xl">
  <div class="card-body lg:px-7.5 p-15 pb-2.5 text-center">
    <div class="text-center"><h3 class="font-bold mb-1.25 text-xl">Multiple License</h3><p class="text-default-400">For developers or agencies working with multiple clients</p></div>
    <div class="my-7.5"><h1 class="font-bold lg:text-[40px] md:text-[33px] text-[27px]">$249</h1><small class="block text-default-400 text-sm font-medium">One-time payment</small><small class="block text-default-400 font-medium">Up to 5 projects</small></div>
    <ul class="text-start text-sm font-medium">
      <li class="mb-2.5"><i class="iconify tabler--check text-success me-2.5"></i> Use in up to 5 projects</li>
      <li class="mb-2.5"><i class="iconify tabler--x text-danger me-2.5"></i> No resale/SaaS rights</li>
    </ul>
  </div>
  <div class="card-footer bg-transparent border-0 px-15 pb-7.5"><a href="#!" class="btn bg-primary text-white w-full py-2.5 font-semibold rounded-full hover:bg-primary-hover">Buy Multiple License</a></div>
  <span class="absolute top-0 start-1/2 -translate-x-1/2 badge bg-primary/15 text-primary rounded-full px-5 py-1.25 mt-5"> Best Value </span>
</div>
```

Non-featured tiles: `card h-full bg-light/10 border-light rounded-xl`, outline button
`btn border border-primary text-primary hover:text-white hover:bg-primary rounded-full w-full py-2.5`,
dark button `btn bg-dark text-white … hover:bg-dark-hover`.

**Nav / scrolling.** There is NO `hs-scrollspy` on the demo landing page and no `scroll-smooth` on
`<html>`: the nav links are ordinary `href="#section"` anchors that jump. Mobile nav is Preline
`hs-collapse` (`data-hs-collapse="#hs-navbar-alignment"`, `lg:block` keeps it open on desktop). To get
highlighted links while scrolling, add `data-hs-scrollspy="#content"` to the link wrapper and
`data-hs-scrollspy-scrollable-parent="window"`-style attributes per Preline's scrollspy docs (not shown in
this template); for smooth jumps add `scroll-smooth` to `<html>`.

**Gotchas.**
- `data-current-year` is stamped by `app.js` (end of file: `querySelectorAll("[data-current-year]")`), which landing.html
  does load — so it works here. Pages that omit `app.js` (auth/error) must fill it themselves.
- The `#alert` bar has `hs-removing:` classes but no dismiss button; add
  `<button data-hs-remove-element="#alert">` if you want it closable.
- `body.bg-card` + `header.bg-card` make the page white on light and `dark:bg-body-bg` on dark; sections
  alternate `bg-light/50` (hero), `bg-light/30` (features, blog) to create bands.
- Bootstrap leftovers present in the source: `lead`, `fs-base`, `fw-semibold`, `rounded-pill`,
  `card-img-top` (none exist in `app.min.css`); replace with `font-semibold`, `rounded-full`,
  `rounded-t-md`. `text-md` IS a real utility in this build.
- The theme customizer offcanvas (`data-hs-overlay="#theme-customization"`) is still in the page; remove
  it for a production marketing page.

## Original sources

- `references/sources/pages/index.html`
- `references/sources/pages/dashboard-analytics.html`
- `references/sources/pages/dashboard-ecommerce.html`
- `references/sources/pages/widgets.html`
- `references/sources/pages/metrics.html`
- `references/sources/pages/landing.html`
- `references/sources/assets/js/pages/dashboard-projects.js`
- `references/sources/assets/js/pages/dashboard-analytics.js`
- `references/sources/assets/js/pages/dashboard-ecommerce.js`
- `references/sources/assets/js/pages/metrics.js`
- `references/sources/assets/js/pages/custom-table.js`
- `references/sources/assets/js/app.js` (theme(), debounce(), CustomEChart, CustomApexChart, initCounter, card actions, themeObserver)
- `references/sources/assets/css/app.min.css` (class existence checks: `.card-header`, `.card-body`, `.thead-sm`, `.table-wrapper`, `.apex-charts`, `.card-collapsed`, `.card-overlay`, `.badge-label`, `.gap-base`, `--color-chart-*` tokens)
- `references/sources/MANIFEST-page-deps.txt`
