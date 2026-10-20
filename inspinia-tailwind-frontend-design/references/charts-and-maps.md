# Charts (ApexCharts, ECharts) and maps (Leaflet, jsVectorMap, Google)

This group covers the 31 chart demo pages (20 ApexCharts, 11 ECharts) and the 3 map pages of the
INSPINIA Tailwind template. The important thing to learn here is not any single chart's options (the
page scripts have them, in full) but the template's **chart runtime in `app.js`**: every chart is
registered through `new CustomApexChart({...})` / `new CustomEChart({...})`, reads its colours from CSS
variables via `theme("chart-primary")`, and is re-rendered automatically when the user flips dark mode,
changes skin or switches to RTL. Follow that convention and new charts match the dashboards; bypass it
and they stay stuck in the light palette after a theme switch.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Decide which charting library to use | Which library when | – | – |
| Register a chart so it follows theme/skin/dark/RTL | Chart theming and registration convention | `assets/js/app.js` | `CustomApexChart`, `CustomEChart`, `theme()` |
| Trend over time; zoom, brush, synced panes, realtime feed | ApexCharts: Line | `charts-apex-line.html` | `apexcharts.min.js` + `chart-apex-line.js` |
| Filled trend, stacked share over time, negative areas, null gaps | ApexCharts: Area | `charts-apex-area.html` | `apexcharts.min.js`, `moment.min.js` + `chart-apex-area.js` |
| Horizontal category comparison, rankings, long labels | ApexCharts: Bar | `charts-apex-bar.html` | `chart-apex-bar.js` |
| Vertical comparison, grouped/stacked, dumbbell, drill-down | ApexCharts: Column | `charts-apex-column.html` | `chart-apex-column.js` (+ dayjs CDN) |
| Line + column + area on one chart, dual y-axes | ApexCharts: Mixed | `charts-apex-mixed.html` | `chart-apex-mixed.js` |
| Part-of-whole (share, budget split), donut with live update | ApexCharts: Pie / Donut | `charts-apex-pie.html` | `chart-apex-pie.js` |
| Goal completion %, circular progress, semi-circle gauge | ApexCharts: RadialBar | `charts-apex-radialbar.html` | `chart-apex-radialbar.js` |
| Multi-dimensional profile comparison (skills, scores) | ApexCharts: Radar | `charts-apex-radar.html` | `chart-apex-radar.js` |
| Polar category magnitudes | ApexCharts: Polar Area | `charts-apex-polar-area.html` | `chart-apex-polar-area.js` |
| Correlation of two measures | ApexCharts: Scatter | `charts-apex-scatter.html` | `chart-apex-scatter.js` |
| Three-variable correlation (size = third value) | ApexCharts: Bubble | `charts-apex-bubble.html` | `chart-apex-bubble.js` |
| Distribution, quartiles, outliers | ApexCharts: BoxPlot | `charts-apex-boxplot.html` | `chart-apex-boxplot.js` |
| OHLC price history | ApexCharts: Candlestick | `charts-apex-candlestick.html` | `chart-apex-candlestick.js` (+ dayjs, ohlc CDN) |
| Activity by hour x weekday, density grid | ApexCharts: Heatmap | `charts-apex-heatmap.html` | `chart-apex-heatmap.js` |
| Gantt-style schedule, deployment windows, shifts | ApexCharts: Timeline (rangeBar) | `charts-apex-timeline.html` | `chart-apex-timeline.js` (+ moment) |
| Min-max band with a forecast line | ApexCharts: Range Area | `charts-apex-range.html` | `chart-apex-range.js` (+ moment) |
| Conversion pipeline, pyramid | ApexCharts: Funnel | `charts-apex-funnel.html` | `chart-apex-funnel.js` (+ moment) |
| Before/after comparison of ranked items | ApexCharts: Slope | `charts-apex-slope.html` | `chart-apex-slope.js` (+ moment) |
| Hierarchical size (storage by folder, revenue by region) | ApexCharts: Treemap | `charts-apex-treemap.html` | `chart-apex-treemap.js` |
| Inline KPI trend in stat tiles and table cells | ApexCharts: Sparklines | `charts-apex-sparklines.html` | `chart-apex-sparklines.js` |
| ECharts trend lines (stacked, markers, dynamic, step, Y-category) | ECharts: Line | `charts-echart-line.html` | `echarts.min.js` + `chart-echart-line.js` |
| ECharts filled trend | ECharts: Area | `charts-echart-area.html` | `chart-echart-area.js` |
| ECharts bars: progress rows, race, gradient, timeline player | ECharts: Bar | `charts-echart-bar.html` | `chart-echart-bar.js` |
| ECharts pie, donut, rose, label layouts | ECharts: Pie | `charts-echart-pie.html` | `chart-echart-pie.js` |
| ECharts scatter / bubble / single-axis | ECharts: Scatter | `charts-echart-scatter.html` | `chart-echart-scatter.js` |
| ECharts radar | ECharts: Radar | `charts-echart-radar.html` | `chart-echart-radar.js` |
| ECharts OHLC with data zoom | ECharts: Candlestick | `charts-echart-candlestick.html` | `chart-echart-candlestick.js` |
| Gauge dials (speed, temperature, multi-ring) | ECharts: Gauge | `charts-echart-gauge.html` | `chart-echart-gauge.js` |
| Choropleth, geo scatter, map-to-bar morph, pies on a map | ECharts: Geo Map | `charts-echart-geo-map.html` | `chart-echart-geo-map.js` (+ world.js CDN, GeoJSON) |
| Dense heatmap (up to 20K cells) | ECharts: Heatmap | `charts-echart-heatmap.html` | `chart-echart-heatmap.js` |
| Sunburst, nested pie, pictorial bar | ECharts: Other | `charts-echart-other.html` | `chart-echart-other.js` |
| Scripts the demo pulls from CDNs | External dependencies to self-host | – | – |
| Interactive tile map: markers, drag, geolocation, custom icons, layers, GeoJSON | Maps: Leaflet | `maps-leaflet.html` | `leaflet.js` + `leaflet.css` + `maps-leaflet.js` |
| SVG vector map with markers/lines; world, US, India, Canada, Russia, Iraq, Spain | Maps: jsVectorMap | `maps-vector.html` | `jsvectormap.min.js` + map files + `maps-vector.js` |
| Embedded Google map (place, satellite, dark) | Maps: Google | `maps-google.html` | Google Maps Embed API (API key) |

## Which library when

**ApexCharts** is the template's default for dashboard charts: every dashboard page (`dashboard-*.js`)
and 20 demo pages use it. Reach for it for line/area/bar/column/pie/donut/radialbar/heatmap/timeline/
treemap/sparklines — anything that fits in a card and needs a toolbar, zoom, legend, annotations or
realtime `updateSeries`. SVG output, so it scales crisply and inherits the template's CSS overrides
(fonts, tooltip, grid colours).

**ECharts** when you need something Apex cannot do well: geographic maps (choropleth, geo scatter, SVG
maps), gauges, sunburst, pictorial bars, "bar race"/timeline players, canvas rendering for large data
(the 20K-cell heatmap), rich-text labels, or `universalTransition` morphing between chart types. The
dashboards also use `CustomEChart` for compact donuts and area lines, so both libraries can coexist on
a page.

**Chart.js** has a `CustomChartJs` wrapper in app.js too (with `getDefaultOptions()` that sets fonts,
`theme("default-400")` tick colour and `theme("chart-border-color")` grid), but no demo page uses it and
no Chart.js bundle is listed in the manifest — treat it as available-if-you-add-the-lib.

**Maps**: Leaflet for real tile maps (OpenStreetMap) with markers, popups, geolocation, GeoJSON overlays;
jsVectorMap for lightweight SVG country/region maps (sales by region, office locations) that recolour
with the theme; ECharts geo for data-driven choropleths with legends/visualMap; Google only when the
product already has a Maps API key and needs Street View/satellite.

## Chart theming and registration convention (app.js)

**What it is.** `assets/js/app.js` ends with three wrapper classes — `CustomApexChart`, `CustomEChart`,
`CustomChartJs` — and a `theme()` helper. Each wrapper keeps a static `instances` array, renders the
chart from an **options factory function**, and a `MutationObserver` on `<html>` calls
`rerenderAll()` for all three classes whenever `data-theme`, `data-skin` or `dir` changes. Because the
factory is re-invoked on every render, `theme("chart-primary")` is re-read from the *current* CSS
variables and the chart repaints in the new palette.

**Use it when.** Always, for every chart you add to a page built on this template. The only reason to
call `new ApexCharts()` / `echarts.init()` directly is a chart whose options need callbacks (see the
JSON-clone gotcha below) — and then you own the re-render on theme change.

**Source.** `references/sources/assets/js/app.js` (minified; `theme`, `debounce`, `CustomApexChart`,
`CustomEChart`, `CustomChartJs`, `themeObserver`, `menuObserver`), `assets/css/app.min.css` (`:root`
chart tokens, `[data-theme=dark]` overrides, per-skin overrides, `.apex-charts` + `.apexcharts-*` CSS).

### The `theme()` helper

```js
// app.js (de-minified). Reads a --color-<name> custom property off <html>.
let theme = (name, alpha = 1) => {
  const v = getComputedStyle(document.documentElement).getPropertyValue("--color-" + name).trim();
  if (alpha === 1) return v;                         // "#1ab394"
  if (v.startsWith("#"))  return `rgba(${hexToRgb(v)}, ${alpha})`;   // "#1ab394" -> "rgba(26, 179, 148, .25)"
  if (v.startsWith("rgb")) return `rgba(${v.match(/\d+,\s*\d+,\s*\d+/)?.[0] || v}, ${alpha})`;
  return v;
};
```

Any token in the design system works — `theme("primary")`, `theme("card")`, `theme("default-300")`,
`theme("body-color")` — not only the `chart-*` ones. A name that has no `--color-*` variable returns
`""` (empty string), which ApexCharts/ECharts silently treat as "use the library default".

### The chart colour tokens

All defined on `:root` in `app.min.css`; dark mode (`[data-theme=dark]`) only overrides the two
neutral ones; every skin (`html[data-skin=flat|galaxy|luxe|material|minimal|modern|neon|pixel|retro|saas]`)
redefines the whole hue set, which is why charts must re-render on skin change.

| CSS variable | `theme()` name | Default (light) | Dark override | Role in the demo scripts |
|---|---|---|---|---|
| `--color-chart-primary` | `chart-primary` | `#1ab394` | – | first series, main fill |
| `--color-chart-secondary` | `chart-secondary` | `#1c84c6` | – | second series |
| `--color-chart-alpha` | `chart-alpha` | `#23c6c8` | – | third series / "good" range |
| `--color-chart-beta` | `chart-beta` | `#ed5565` | – | negative / "bad" range, candlestick down |
| `--color-chart-gamma` | `chart-gamma` | `#7b70ef` | – | emphasis / hover area colour on maps |
| `--color-chart-delta` | `chart-delta` | `#f8ac59` | – | warm accent, "medium" range |
| `--color-chart-zeta` | `chart-zeta` | `#ff679b` | – | annotations, extra series |
| `--color-chart-dark` | `chart-dark` | `#1a57a1` | – | dense/high end of colour scales |
| `--color-chart-gray` | `chart-gray` | `#edeff3` | `#40424f` | tracks, muted series |
| `--color-chart-border-color` | `chart-border-color` | `#ecf4fc` | `#242c31` | `grid.borderColor`, ECharts split lines |
| `--color-chart-title-color` | `chart-title-color` | `#bbcae1` | – | defined but unused by the demo scripts |

Example skin values for `--color-chart-primary`: `#6c84e5`, `#3c7de1`, `#7754f6`, `#6575f5`, `#1c9390`,
`#2563eb`, `#4557a3`, `#8e7fe0` — never hard-code a hex for a series colour; it will clash under
another skin.

### `CustomApexChart` (ApexCharts wrapper)

```js
// app.js (de-minified, trimmed)
class CustomApexChart {
  static instances = [];
  constructor({ selector, series = [], options = {}, colors = [] }) {
    this.selector = selector;              // CSS selector string OR an HTMLElement
    this.series = series;                  // fallback if options() has no series
    this.getOptions = options;             // MUST be a function returning the options object
    this.colors = colors;
    this.element = selector instanceof HTMLElement ? selector : document.querySelector(selector);
    try { this.render(); CustomApexChart.instances.push(this); }
    catch (e) { console.error("CustomApexChart: Error during chart initialization:", e); }
  }
  getColors() {
    const o = this.getOptions();
    if (o?.colors?.length) return o.colors;                       // 1. options().colors wins
    const attr = this.element?.getAttribute("data-colors");       // 2. data-colors="primary,#ff0000,rgb(…)"
    if (attr) return attr.split(",").map(s => s.trim())
                         .map(s => s.startsWith("#") || s.includes("rgb") ? s : theme(s));
    return [theme("primary"), theme("secondary"), theme("beta")]; // 3. default trio
  }
  render() {
    if (this.chart) this.chart.destroy();
    let opts = JSON.parse(JSON.stringify(this.getOptions()));    // <-- deep clone: FUNCTIONS ARE DROPPED
    opts.colors = this.getColors();
    opts = this.injectDynamicColors(opts, opts.colors);
    if (!opts.series) opts.series = this.series;
    this.chart = new ApexCharts(this.element, opts);
    this.chart.render();
  }
  injectDynamicColors(opts, colors) {
    // boxplot: plotOptions.boxPlot.colors.upper/lower default to colors[0]/colors[1]
    // multi yaxis[]: axisBorder.color + labels.style.color default to colors[i]
    // markers.strokeColor defaults to colors; fill.gradient.gradientToColors defaults to colors
    // treemap colorScale.ranges[0..1].color default to colors[0..1]
    return opts;
  }
  static rerenderAll() { for (const c of CustomApexChart.instances) c.render(); }
}
```

### `CustomEChart` (ECharts wrapper)

```js
class CustomEChart {
  static instances = [];
  constructor({ selector, options = {}, theme = null, initOptions = {} }) {
    // selector: string or HTMLElement; options: factory function; theme/initOptions passed to echarts.init
    try { this.render(); CustomEChart.instances.push(this); } catch (e) { console.error(...); }
  }
  render() {
    this.element = this.selector instanceof HTMLElement ? this.selector : document.querySelector(this.selector);
    if (this.chart) this.chart.dispose();
    this.chart = echarts.init(this.element, this.theme, this.initOptions);
    this.chart.setOption(this.getOptions());                      // no clone: callbacks survive
    window.addEventListener("resize", debounce(() => this.chart.resize(), 200));
  }
  static reSizeAll()  { /* resize every visible instance after a "finished" frame */ }
  static rerenderAll() { for (const c of CustomEChart.instances) c.render(); }
}

// Observers wired at the bottom of app.js:
new MutationObserver(() => { CustomApexChart.rerenderAll(); CustomEChart.rerenderAll(); CustomChartJs.rerenderAll(); })
  .observe(document.documentElement, { attributes: true, attributeFilter: ["data-skin", "data-theme", "dir"] });
new MutationObserver(() => requestAnimationFrame(() => CustomEChart.reSizeAll()))
  .observe(document.documentElement, { attributes: true, attributeFilter: ["data-sidenav-size"] });
```

### Canonical "register a chart" snippets (copied from page scripts)

ApexCharts — `assets/js/pages/chart-apex-line.js`, first chart:

```js
new CustomApexChart({
  selector: "#line-chart",
  options: () => ({                                     // factory: re-run on every theme change
    chart: { height: 380, type: "line", zoom: { enabled: false } },
    dataLabels: { enabled: false },
    colors: [theme("chart-primary")],                   // theme() tokens, never hex
    stroke: { width: [2], curve: "smooth" },
    series: [{ name: "Revenue", data: [12, 28, 18, 34, 42, 39, 48, 55, 63] }],
    grid: {
      row: { colors: ["transparent", "transparent"], opacity: .2 },
      borderColor: [theme("chart-border-color")],       // demo scripts typo this as "chart-order-color"
    },
    xaxis: { categories: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep"] },
    responsive: [{ breakpoint: 600, options: { chart: { toolbar: { show: false } }, legend: { show: false } } }],
  }),
});
```

ECharts — `assets/js/pages/chart-echart-bar.js`, first chart (this tooltip block is the house style,
repeated verbatim in every ECharts page script and in `dashboard-projects.js`):

```js
new CustomEChart({
  selector: "#chart-basic-bar",
  options: () => ({
    tooltip: {
      trigger: "axis", padding: [5, 0],
      backgroundColor: theme("card"), borderColor: theme("default-300"),
      textStyle: { color: theme("default-600") }, borderWidth: 1, transitionDuration: .125,
      axisPointer: { type: "none" },
      shadowBlur: 2, shadowColor: "rgba(76, 76, 92, 0.15)", shadowOffsetX: 0, shadowOffsetY: 1,
      formatter: function (params) {                    // custom HTML tooltip (callbacks are fine in ECharts)
        let html = `<div style="font-size:14px;font-weight:600;text-transform:uppercase;border-bottom:1px solid ${theme("default-300")};margin-bottom:8px;padding:3px 10px 8px;">${params[0].name}</div>`;
        params.forEach(p => { html += `<div style="margin-top:4px;padding:3px 15px;"><span style="display:inline-block;margin-right:5px;border-radius:50%;width:10px;height:10px;background-color:${p.color};"></span>${p.seriesName} : <strong>${p.value}</strong></div>`; });
        return html;
      },
    },
    textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },   // match the skin's font
    xAxis: { type: "category", data: ["January", "February", "March", /* … */],
      axisLine: { lineStyle: { color: theme("light"), type: "dashed" } }, axisTick: { show: false },
      axisLabel: { color: theme("body-color"), formatter: v => v.substring(0, 3), margin: 15 }, splitLine: { show: false } },
    yAxis: { type: "value", boundaryGap: ["20%", "20%"], axisLabel: { show: true, color: theme("body-color"), margin: 15 },
      splitLine: { show: true, lineStyle: { color: theme("light") } }, axisTick: { show: false }, axisLine: { show: false }, min: 600 },
    series: [{ type: "bar", name: "Total", data: [820, 950, 1100 /* … */],
      itemStyle: { color: theme("primary", 1), barBorderRadius: [3, 3, 0, 0] } }],
    grid: { right: "2%", left: "7%", bottom: "10%", top: "5%" },
  }),
});
```

Dashboard usage — `assets/js/pages/dashboard-projects.js` registers one chart per `.donut-chart`
element by passing the element itself as `selector`:

```js
function initDonutChart(el) {
  const data = generateRandomData();
  new CustomEChart({
    selector: el,
    options: () => ({
      tooltip: { show: false },
      series: [{ type: "pie", radius: ["60%", "100%"], hoverAnimation: false,
        label: { show: false }, labelLine: { show: false },
        data: data.map((d, i) => ({ value: d.value,
          itemStyle: { color: i === 0 ? theme("primary") : i === 1 ? theme("secondary") : "#bbcae14d" } })) }],
    }),
  });
}
document.querySelectorAll(".donut-chart").forEach(initDonutChart);
```

### Updating an existing chart

Keep the wrapper instance; the live library object is `instance.chart`.

```js
// ApexCharts (chart-apex-pie.js "Donut Update")
const updateChart = new CustomApexChart({ selector: "#update-donut", options: getOptions });
document.querySelector("#randomize").addEventListener("click", () =>
  updateChart.chart.updateSeries(updateChart.chart.w.globals.series.map(() => Math.floor(100 * Math.random()) + 1)));
document.querySelector("#reset").addEventListener("click", () => updateChart.chart.updateSeries(getOptions().series));

// ApexCharts by chart.id (chart-apex-column.js "Dynamic Loaded Chart")
ApexCharts.exec("barQuarter", "updateOptions", { series, colors, fill: { colors } });

// ECharts (chart-echart-line.js "Dynamic Line")
setInterval(() => { data.shift(); data.push(randomData()); dynamicLineChart.chart.setOption({ series: [{ data }] }); }, 1000);
```

Note that a theme change calls `render()` which rebuilds from the factory — data pushed via
`updateSeries` / `setOption` is lost unless the factory reads from the same mutable array (the demo's
realtime charts do exactly that: `data` is module-level and the factory references it).

### Page markup for a chart card

```html
<div class="card">
  <div class="card-header">
    <h4 class="card-title">Simple line chart</h4>
  </div>
  <div class="card-body">
    <div dir="ltr">                                   <!-- Apex charts are always wrapped dir="ltr" (RTL-safe) -->
      <div id="line-chart" class="apex-charts"></div>  <!-- height comes from options.chart.height -->
    </div>
  </div>
</div>

<!-- ECharts: no .apex-charts, give the container an explicit min-height instead -->
<div class="card">
  <div class="card-header"><h4 class="card-title">Basic Bar Chart</h4></div>
  <div class="card-body">
    <div id="chart-basic-bar" style="min-height: 300px"></div>
  </div>
</div>
```

`.apex-charts` in `app.min.css` = `min-height:10px!important; .apexcharts-canvas{margin:0 auto}`. The
same stylesheet restyles `.apexcharts-tooltip` (`var(--color-card)` background, `--color-default-300`
border, `--shadow`), sets `font-family: var(--font-secondary)` on all Apex text, dashes grid lines
(`stroke-dasharray:3`, `stroke: var(--color-default-300)`) and sets legend text to `--color-default-600`
— so Apex charts already look right in dark mode without any options; you only need `theme()` for
series/fill colours. ECharts has no such CSS: pass `theme("card")`, `theme("default-300")`,
`theme("body-color")` etc. in the options as the house-style snippet above does.

**Gotchas.**
- `options` must be a **function** (`options: () => ({...})`). An object literal throws inside
  `render()`; the constructor catches it, logs `console.error`, and the chart never appears.
- **`CustomApexChart` JSON-clones the options**, so `formatter`, `events`, `tooltip.custom`,
  `chart.events.*` and any other function property is dropped. The demo page scripts still pass
  formatters (they silently fall back to defaults). If a chart needs callbacks, do what
  `chart-apex-column.js` "Dynamic Loaded Chart" does — `new ApexCharts(el, opts).render()` directly —
  and add your own `MutationObserver` on `data-theme/data-skin/dir` to `destroy()` + re-create it.
  `CustomEChart` does **not** clone, so ECharts formatters/handlers work.
- Typos in the demo scripts that resolve to `""`: `theme("chart-order-color")` (meant
  `chart-border-color`), `theme("bg-card")` (meant `card`), `theme("border-bg")`,
  `theme("body-secondary-color")`. Use the real token names listed above.
- `getColors()` precedence is `options().colors` > `data-colors="…"` attribute > `[primary, secondary,
  beta]`. No demo page uses `data-colors`, but it is the right hook for charts whose markup is generated
  server-side: `<div class="apex-charts" data-colors="chart-primary,chart-delta"></div>`.
- Hidden containers (inactive tab, collapsed card) render at 0 width. For ECharts call
  `instance.chart.resize()` when the pane becomes visible (`CustomEChart.reSizeAll()` is only wired to
  sidebar size changes); for Apex, create the chart after the tab is shown or call
  `instance.chart.windowResizeHandler?.()` / re-`render()`.
- Only one `themeObserver` exists; it re-renders *all* registered charts on every attribute change, so
  avoid registering hundreds of sparklines on one page — the sparklines demo has 11.
- `Apex.grid = {...}` / `Apex.dataLabels = {...}` (ApexCharts global defaults) are set at the top of
  `chart-apex-sparklines.js`; globals affect every chart on that page.

## ApexCharts: Line

**What it is.** Eleven line-chart variants from `chart.type: "line"` (and two `"area"` for zoom/brush).
**Use it when.**
- Revenue / users / visitors over time; "Zoomable Timeseries" for long date ranges with toolbar zoom.
- "Line Chart with Annotations" — mark a launch, a campaign start, a support level or a peak on a trend.
- "Syncing charts" (`chart.group`) — two metrics whose tooltips/crosshairs should move together.
- "Brush Chart" — a small navigator chart (`chart.brush`) selecting the window of a detail chart.
- "Realtime Chart" — live telemetry, an orders-per-minute feed (`setInterval` + `updateSeries`).
- Not for only two x-points per series — that is the Slope chart; not for filled totals — use Area.
**Source.** `references/sources/pages/charts-apex-line.html`, `assets/js/pages/chart-apex-line.js`.

| Card | Container id(s) | Distinctive option | Use it for |
|---|---|---|---|
| Simple line chart | `#line-chart` | `zoom.enabled:false` | one KPI trend |
| Line with Data Labels | `#line-chart-datalabel` | `dataLabels.enabled`, `background` | small series where values matter |
| Zoomable Timeseries | `#line-chart-zoomable` | `type:"area"`, `xaxis.type:"datetime"`, toolbar on | month+ ranges |
| Line Chart with Annotations | `#line-chart-annotations` | `annotations.yaxis/xaxis/points` | events on a trend |
| Syncing charts | `#line-chart-syncing`, `#line-chart-syncing2` | `chart.group:"social"`, `chart.id` | compare two metrics in lockstep |
| Gradient Line Chart | `#line-chart-gradient` | `fill.type:"gradient"` | marketing-style hero chart |
| Missing / Null values | `#line-chart-missing` | `null` points | sensor gaps |
| Dashed Line Chart | `#line-chart-dashed` | `stroke.dashArray` | target vs actual |
| Stepline Chart | `#line-chart-stepline` | `stroke.curve:"stepline"` | price tiers, state changes |
| Brush Chart | `#chart-line` (detail), `#chart-line2` (brush) | `chart.brush.target`, `chart.selection` | navigator + detail |
| Realtime Chart | `#line-chart-realtime` | `setInterval` + `chart.updateSeries` | live feed |

**Markup.** Standard chart card (see convention). Brush = two containers in one `.card-body`.
**Init / JS.** See the canonical Apex snippet above (it *is* `#line-chart`). Realtime pattern:

```js
const realtimeChart = new CustomApexChart({ selector: "#line-chart-realtime", options: () => ({
  chart: { height: 350, type: "line", animations: { enabled: true, easing: "linear", dynamicAnimation: { speed: 2000 } },
    toolbar: { show: false }, zoom: { enabled: false } },
  dataLabels: { enabled: false }, stroke: { curve: "smooth", width: [3] },
  colors: [theme("chart-primary")], series: [{ data }],        // `data` is a module-level array the factory re-reads
  markers: { size: 0 }, xaxis: { type: "datetime", range: 777600000 }, yaxis: { max: 100 }, legend: { show: false },
  grid: { borderColor: [theme("chart-border-color")] },
}) });
window.setInterval(() => { getNewSeries(lastDate, { min: 10, max: 90 }); realtimeChart.chart.updateSeries([{ data }]); }, 2000);
window.setInterval(() => { resetData(); realtimeChart.chart.updateSeries([{ data }], false, true); }, 60000);
```

## ApexCharts: Area

**What it is.** Nine area variants; the GitHub-style one uses a brush selection.
**Use it when.**
- Cumulative or volume-like trends (sessions, bandwidth, revenue) where the fill communicates magnitude.
- "Stacked Area" — composition over time (traffic by channel).
- "Area with Negative Values" — cash flow / profit-loss; "Null values" — gaps in telemetry.
- "Selection - Github Style" — commit-activity style overview + detail.
**Source.** `references/sources/pages/charts-apex-area.html`, `assets/js/pages/chart-apex-area.js`;
needs `assets/plugins/moment/moment.min.js`; the demo also loads
`https://apexcharts.com/samples/assets/github-data.js` and `…/irregular-data-series.js` (sample data —
self-host or replace with your own).

| Card | Container id | Note |
|---|---|---|
| Basic Area Chart | `#basic-area` | |
| Spline Area | `#spline-area` | selector passed as an element (`document.querySelector("#spline-area")`), `curve:"smooth"` |
| Area Chart - Datetime X-axis | `#area-chart-datetime` | `xaxis.type:"datetime"` |
| Area with Negative Values | `#area-chart-negative` | |
| Selection - Github Style | `#area-chart-github`, `#area-chart-github2` | `chart.brush`, `chart.selection`, external `githubdata` |
| Stacked Area | `#stacked-area` | `chart.stacked:true` |
| Irregular TimeSeries | `#area-timeSeries` | per-series timestamps |
| Area Chart with Null values | `#area-chart-nullvalues` | `null` points, `fill.type:"solid"` |

**Markup.** Standard chart card. **Init / JS.** Same as Line with `chart.type:"area"` and
`fill: { gradient: { opacityFrom: .5, opacityTo: .1 } }`.

## ApexCharts: Bar

**What it is.** Horizontal bars (`plotOptions.bar.horizontal:true`), eleven variants.
**Use it when.**
- Ranking categories with long labels (top products, countries, campaigns).
- "Grouped"/"Stacked"/"100% Stacked" — budget vs actual, status mix per team.
- "Bar with Negative Values" — population pyramid, net promoter split.
- "Custom DataLabels" / "Bar with Markers" — show the value and a target marker per row.
**Source.** `references/sources/pages/charts-apex-bar.html`, `assets/js/pages/chart-apex-bar.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Bar Charts | `#basic-bar` | `horizontal:true` |
| Grouped Bar Chart | `#grouped-bar` | two series |
| Stacked Bar Chart | `#stacked-bar` | `chart.stacked:true` |
| 100% Stacked Bar Chart | `#full-stacked-bar` | `stackType:"100%"` |
| Grouped Stacked Bars | `#grouped-stacked-bar` | `series[].group:"budget"/"actual"` |
| Bar with Negative Values | `#negative-bar` | negative data, `xaxis.labels.formatter` |
| Reversed Bar Chart | `#reversed-bar` | `yaxis.reversed`, `xaxis.position` |
| Bar with Image Fill | `#image-fill-bar` | `fill.type:"image"` |
| Custom DataLabels Bar | `#datalables-bar` | `dataLabels.textAnchor:"start"` |
| Patterned Bar Chart | `#pattern-bar` | `fill.type:"pattern"` |
| Bar with Markers | `#bar-markers` | `plotOptions.bar.distributed`, discrete markers |

**Markup.** Standard chart card. **Init / JS.** `chart.type:"bar"` + `plotOptions.bar.horizontal:true`.

## ApexCharts: Column

**What it is.** Vertical bars, thirteen variants including a two-chart drill-down.
**Use it when.**
- Monthly totals, comparisons across a short category list; "with Datalabels" when values must be read.
- "Dumbbell Chart" — min/max spread per category (salary bands, temperature ranges).
- "Range Column" — start/end per category (`type:"rangeBar"` vertical).
- "Dynamic Loaded Chart" — click a year bar to load its quarters (master/detail with `ApexCharts.exec`).
- "Distributed Column" — one colour per bar when categories are unrelated.
**Source.** `references/sources/pages/charts-apex-column.html`, `assets/js/pages/chart-apex-column.js`;
the demo also loads dayjs 1.11.0 + `plugin/quarterOfYear` from cdnjs (for the dynamic chart's labels).

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Column Charts | `#basic-column` | |
| Column Chart with Datalabels | `#datalabels-column` | `dataLabels`, `plotOptions.bar.dataLabels.position:"top"` |
| Stacked Column Charts | `#stacked-column` | `chart.stacked` |
| 100% Stacked Column Chart | `#full-stacked-column` | `stackType:"100%"` |
| Grouped Stacked Columns Chart | `#grouped-stacked-column` | `series[].group` |
| Dumbbell Chart | `#dumbbell-chart` | `type:"rangeBar"`, `plotOptions.bar.isDumbbell:true` |
| Column with Markers | `#column-with-markers` | discrete markers |
| Column with Group Label | `#column-with-group-label` | `xaxis.group.groups` |
| Column Chart with rotated labels & Annotations | `#rotate-labels-column` | `xaxis.labels.rotate`, `annotations` |
| Column Chart with negative values | `#negative-value-column` | `plotOptions.bar.colors.ranges` |
| Distributed Column Charts | `#distributed-column` | `plotOptions.bar.distributed:true` |
| Range Column Charts | `#range-column` | `type:"rangeBar"` |
| Dynamic Loaded Chart | `#chart-year`, `#chart-quarter` + `<select id="model" class="form-select">` | `new ApexCharts` directly, `chart.id:"barYear"/"barQuarter"`, `dataPointSelection` event, `ApexCharts.exec` |

**Markup.** Drill-down card:

```html
<div class="card">
  <div class="card-header flex justify-between">
    <h4 class="card-title">Dynamic Loaded Chart</h4>
    <div class="shrink-0">
      <select id="model" class="form-select"><option value="iphone5">iPhone 5</option><!-- … --></select>
    </div>
  </div>
  <div class="card-body">
    <div dir="ltr">
      <div class="grid grid-cols-2 gap-base">
        <div id="chart-year"></div>
        <div id="chart-quarter"></div>
      </div>
    </div>
  </div>
</div>
```

**Gotchas.** The drill-down bypasses `CustomApexChart` because it needs `chart.events` — so it does not
re-theme on dark-mode toggle. The demo's `data.colorToken` pattern (store a token name per datum, map
with `theme()` at render time) is the right way to keep per-bar colours theme-aware.

## ApexCharts: Mixed

**What it is.** Combined series types on one chart (`series[].type: "line" | "column" | "area"`).
**Use it when.** Revenue columns with a margin line; sessions area with conversion-rate line; anything
with two units (use "Multiple Y-Axis Chart", `yaxis: [{...},{opposite:true}]` — the wrapper's
`injectDynamicColors` colours each axis border/labels to match its series).
**Source.** `references/sources/pages/charts-apex-mixed.html`, `assets/js/pages/chart-apex-mixed.js`.

| Card | Container id |
|---|---|
| Line & Column Chart | `#line-column-mixed` |
| Multiple Y-Axis Chart | `#multiple-yaxis-mixed` |
| Line & Area Chart | `#line-area-mixed` |
| Line, Column & Area Chart | `#all-mixed` |

**Init / JS.** `chart.type:"line"` at the top level, then `series:[{name,type:"column",data},{name,type:"line",data}]`,
`stroke.width:[0,2]`, `fill.type:["solid","gradient"]` as needed.

## ApexCharts: Pie / Donut

**What it is.** `type:"pie"` and `type:"donut"` variants plus an interactive update demo.
**Use it when.** Share of revenue by channel, ticket status split, storage by type (keep to <= 6 slices);
"Donut Update" pattern for a live breakdown that changes with filters. For many categories or exact
comparison prefer a bar chart.
**Source.** `references/sources/pages/charts-apex-pie.html`, `assets/js/pages/chart-apex-pie.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Simple Pie Chart | `#simple-pie` | |
| Simple Donut Chart | `#simple-donut` | `type:"donut"` |
| Monochrome Pie Chart | `#monochrome-pie` | `theme.monochrome.enabled`, `color: theme("chart-primary")` |
| Gradient Donut Chart | `#gradient-donut` | `fill.type:"gradient"` |
| Patterned Donut Chart | `#patterned-donut` | `fill.type:"pattern"` |
| Pie Chart with Image fill | `#image-pie` | `fill.type:"image"` |
| Donut Update | `#update-donut` + buttons `#randomize #add #remove #reset` | `chart.updateSeries` |

**Markup.** Chart card plus a button row:

```html
<div class="card-body">
  <div dir="ltr"><div id="update-donut" class="apex-charts"></div></div>
  <div class="mt-2 text-center">
    <button class="btn btn-sm bg-primary text-white hover:bg-primary-hover" id="randomize">RANDOMIZE</button>
    <button class="btn btn-sm bg-primary text-white hover:bg-primary-hover" id="add">ADD</button>
    <button class="btn btn-sm bg-primary text-white hover:bg-primary-hover" id="remove">REMOVE</button>
    <button class="btn btn-sm bg-primary text-white hover:bg-primary-hover" id="reset">RESET</button>
  </div>
</div>
```

**Init / JS.** See "Updating an existing chart" in the convention section.

## ApexCharts: RadialBar

**What it is.** Circular progress (`type:"radialBar"`), seven variants.
**Use it when.** Goal completion % in a stat tile, task progress, disk usage, NPS; "Semi Circle Gauge"
for a speedometer-style KPI; "Multiple RadialBars" for 3-4 KPIs in one widget. For true dial gauges with
bands use ECharts Gauge.
**Source.** `references/sources/pages/charts-apex-radialbar.html`, `assets/js/pages/chart-apex-radialbar.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic RadialBar Chart | `#basic-radialbar` | |
| Multiple RadialBars | `#multiple-radialbar` | `series:[75,60,85]`, `track.margin:20`, `hollow.size:"5%"`, `stroke.lineCap:"round"` |
| Circle Chart - Custom Angle | `#circle-angle-radial` | `startAngle/endAngle`, `hollow` |
| Circle Chart with Image | `#image-radial` | `fill.type:"image"` in the hollow |
| Stroked Circular Guage | `#stroked-guage-radial` | `track.strokeWidth`, `dropShadow` |
| Gradient Circular Chart | `#gradient-chart` | `fill.type:"gradient"` |
| Semi Circle Gauge | `#semi-circle-gauge` | `startAngle:-90,endAngle:90`, `sparkline.enabled` |

**Init / JS.** Semi-circle gauge (fits a stat tile):

```js
new CustomApexChart({ selector: "#semi-circle-gauge", options: () => ({
  series: [80],
  chart: { type: "radialBar", offsetY: -20, sparkline: { enabled: true } },
  plotOptions: { radialBar: { startAngle: -90, endAngle: 90,
    track: { background: "rgba(170,184,197, 0.2)", strokeWidth: "97%", margin: 5 },
    dataLabels: { name: { show: false }, value: { offsetY: -2, fontSize: "22px" } } } },
  grid: { padding: { top: -10 } }, labels: ["Average Results"], colors: [theme("chart-beta")],
}) });
```

## ApexCharts: Radar

**What it is.** `type:"radar"`, three variants, one with an update button.
**Use it when.** Skill / competency profiles, product feature scoring, comparing 2-3 entities across 5-8
dimensions. Not for time series.
**Source.** `references/sources/pages/charts-apex-radar.html`, `assets/js/pages/chart-apex-radar.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Radar Chart | `#basic-radar` | |
| Radar with Polygon-fill | `#radar-polygon` | `plotOptions.radar.size:120`, `markers:{size:4,colors:[theme("chart-alpha")]}` (no explicit polygon fill in the demo) |
| Radar – Multiple Series | `#radar-multiple-series` + `#update-radar` button | `chart.updateSeries` |

## ApexCharts: Polar Area

**What it is.** `type:"polarArea"` — pie slices whose radius encodes the value.
**Use it when.** Category magnitudes where you want a "rose" look (seasonal sales by month, requests by
weekday). Prefer a bar chart when precision matters.
**Source.** `references/sources/pages/charts-apex-polar-area.html`, `assets/js/pages/chart-apex-polar-area.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Polar Area Chart | `#basic-polar-area` | `stroke.colors`, `fill.opacity` |
| Monochrome Polar Area | `#monochrome-polar-area` | `theme.monochrome` on `theme("chart-primary")` |

## ApexCharts: Scatter

**What it is.** `type:"scatter"` with numeric, datetime and image markers.
**Use it when.** Price vs rating, load vs latency, any two-measure correlation; "Datetime" variant for
event timestamps; "Images" variant for avatars as points (team performance map).
**Source.** `references/sources/pages/charts-apex-scatter.html`, `assets/js/pages/chart-apex-scatter.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Scatter (XY) Chart | `#basic-scatter` | `xaxis.type:"numeric"`, `zoom.type:"xy"` |
| Scatter Chart - Datetime | `#datetime-scatter` | `xaxis.type:"datetime"` |
| Scatter - Images | `#scatter-images` | `fill.type:"image"`, `markers.size` |

## ApexCharts: Bubble

**What it is.** `type:"bubble"` — x, y plus a z value that sizes the bubble.
**Use it when.** Portfolio views (risk x return x size), campaigns (spend x conversions x revenue),
product matrices. Limit to a few series.
**Source.** `references/sources/pages/charts-apex-bubble.html`, `assets/js/pages/chart-apex-bubble.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Simple Bubble Charts | `#simple-bubble` | `fill.opacity:.8` |
| 3D Bubble Charts | `#threed-bubble` | `fill.type:"gradient"` |
| Bubble Charts | `#three-bubble` | `xaxis.type:"datetime"`/`"category"` |

## ApexCharts: BoxPlot

**What it is.** `type:"boxPlot"` — min / q1 / median / q3 / max per category; optional scatter outliers.
**Use it when.** Response-time distribution per endpoint, salary bands per role, test-score spread.
**Source.** `references/sources/pages/charts-apex-boxplot.html`, `assets/js/pages/chart-apex-boxplot.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Boxplot | `#basic-boxplot` | `plotOptions.boxPlot.colors.upper/lower` |
| Scatter Boxplot | `#scatter-boxplot` | second series `type:"scatter"` for outliers |
| Horizontal BoxPlot | `#horizontal-boxplot` | `plotOptions.bar.horizontal:true` |

**Gotchas.** `injectDynamicColors` fills `plotOptions.boxPlot.colors.upper/lower` from `colors[0]/[1]`
if you omit them — pass `colors:[theme("chart-alpha"), theme("chart-beta")]` for an up/down pair.

## ApexCharts: Candlestick

**What it is.** `type:"candlestick"` OHLC charts, with combo bar volume and a line overlay.
**Use it when.** Stock/crypto price history, FX rates, any open-high-low-close series; "Combo" adds a
volume bar pane whose `chart.selection` drives the candlestick's x-range (note: that `events.selection`
callback is stripped by the wrapper's JSON clone — see the convention gotchas); "Candlestick with Line"
overlays a moving average.
**Source.** `references/sources/pages/charts-apex-candlestick.html`, `assets/js/pages/chart-apex-candlestick.js`;
the demo also loads `https://apexcharts.com/samples/assets/ohlc.js` (sample `seriesData`/`seriesDataLinear`)
and dayjs 1.8.17 from cdnjs.

| Card | Container id(s) | Distinctive option |
|---|---|---|
| Simple Candlestick Charts | `#simple-candlestick` | `plotOptions.candlestick.colors.upward/downward` |
| Combo Candlestick Charts | `#combo-candlestick`, `#combo-bar-candlestick` | volume `type:"bar"` with `chart.selection` + `events.selection` -> `updateOptions({xaxis:{min,max}})` on the candlestick; `plotOptions.bar.colors.ranges` |
| Category X-Axis | `#x-axis-candlestick` | `xaxis.type:"category"`, `labels.formatter` via dayjs |
| Candlestick with Line | `#candlestick-with-line` | second series `type:"line"` |

**Init / JS.** Up/down colours: `plotOptions: { candlestick: { colors: { upward: theme("chart-alpha"), downward: theme("chart-beta") } } }`.

## ApexCharts: Heatmap

**What it is.** `type:"heatmap"` — one series per row, one cell per category.
**Use it when.** Activity by hour x weekday, error rate per service x day, seat/room occupancy,
A/B matrix. "Color Range" variant for named bands (Low/Medium/High), "Range without Shades" for flat
rounded tiles (`enableShades:false`, `radius:30`).
**Source.** `references/sources/pages/charts-apex-heatmap.html`, `assets/js/pages/chart-apex-heatmap.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Heatmap - Single Series | `#basic-heatmap` | one colour, intensity by value |
| Multiple Series | `#multiple-series-heatmap` | one colour per row series |
| Heatmap - Color Range | `#color-range-heatmap` | `plotOptions.heatmap.colorScale.ranges` |
| Heatmap - Range without Shades | `#rounded-heatmap` | `plotOptions.heatmap.radius:30`, `enableShades:false`, two-band `colorScale.ranges`, `stroke.width:0` |

**Init / JS.** Named bands:

```js
plotOptions: { heatmap: { shadeIntensity: .5, colorScale: { ranges: [
  { from: -30, to: 5,  name: "Low",     color: theme("chart-alpha") },
  { from: 6,   to: 20, name: "Medium",  color: theme("chart-delta") },
  { from: 21,  to: 45, name: "High",    color: theme("chart-beta") },
  { from: 46,  to: 55, name: "Extreme", color: theme("chart-alpha") } ] } } }
```

## ApexCharts: Timeline (rangeBar)

**What it is.** Horizontal `type:"rangeBar"` with `[start, end]` timestamps per row — a Gantt.
**Use it when.** Project phases, deployment/maintenance windows, shift rosters, booking calendars,
sprint timelines; "Multiple Series - Group Rows" (`rangeBarGroupRows`) for several tasks per person.
**Source.** `references/sources/pages/charts-apex-timeline.html`, `assets/js/pages/chart-apex-timeline.js`;
needs `moment.min.js` (duration labels).

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Timeline | `#basic-timeline` | `horizontal:true`, `xaxis.type:"datetime"` |
| Distributed Timeline | `#distributed-timeline` | `distributed:true`, duration `dataLabels.formatter` (moment) |
| Multi Series Timeline | `#multi-series-timeline` | one series per owner |
| Advanced Timeline | `#advanced-timeline` | three team series, milestone markers via `goals:[{name,value,strokeColor:theme("chart-alpha")}]`, `barHeight:"80%"` |
| Multiple Series - Group Rows | `#group-rows-timeline` | `plotOptions.bar.rangeBarGroupRows:true` |

**Init / JS.**

```js
new CustomApexChart({ selector: "#basic-timeline", options: () => ({
  series: [{ data: [
    { x: "Venue Booking",       y: [new Date("2024-06-01").getTime(), new Date("2024-06-03").getTime()] },
    { x: "Vendor Coordination", y: [new Date("2024-06-04").getTime(), new Date("2024-06-07").getTime()] },
    /* … */ ] }],
  colors: [theme("chart-primary")],
  chart: { height: 350, type: "rangeBar", toolbar: { show: false } },
  plotOptions: { bar: { horizontal: true } },
  xaxis: { type: "datetime", axisBorder: { show: false } },
}) });
```

**Gotchas.** The duration `dataLabels.formatter` is a function and is stripped by the wrapper's JSON
clone — labels fall back to the raw range. Use `new ApexCharts` directly if you need the "3 days" text.

## ApexCharts: Range Area

**What it is.** `type:"rangeArea"` — a band between a low and a high series, optionally with a line.
**Use it when.** Forecast confidence intervals, min/max temperature, SLA envelope vs actual latency.
**Source.** `references/sources/pages/charts-apex-range.html`, `assets/js/pages/chart-apex-range.js` (+ moment).

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Range Area | `#basic-range` | data `{x, y:[low, high]}` |
| Range Area With Line | `#combo-range` | band series + `type:"line"` actual |

## ApexCharts: Funnel

**What it is.** Horizontal bar with `plotOptions.bar.isFunnel:true` (ApexCharts has no funnel type).
**Use it when.** Conversion pipeline (visit -> cart -> checkout -> paid), hiring funnel; "Pyramid
Funnel" (ascending data) for org/tier breakdowns.
**Source.** `references/sources/pages/charts-apex-funnel.html`, `assets/js/pages/chart-apex-funnel.js` (+ moment, unused by the chart).

| Card | Container id | Note |
|---|---|---|
| Basic Funnel | `#basic-funnel` | descending data, `colors:[theme("chart-primary")]` |
| Pyramid Funnel | `#pyramid-funnel` | ascending data, `distributed:true` |

**Init / JS.**

```js
new CustomApexChart({ selector: "#basic-funnel", options: () => ({
  series: [{ name: "E-commerce Sales", data: [2000, 1700, 1250, 980, 750, 500, 300, 120] }],
  chart: { type: "bar", height: 350, dropShadow: { enabled: false }, toolbar: { show: false } },
  colors: [theme("chart-primary")],
  plotOptions: { bar: { borderRadius: 0, horizontal: true, barHeight: "80%", isFunnel: true } },
  dataLabels: { enabled: true, dropShadow: { enabled: true } },   // demo formatter (label + value) is stripped by the wrapper
  xaxis: { categories: ["Visited Website", "Viewed Product", "Added to Cart", "Initiated Checkout", "Entered Info", "Payment Started", "Payment Completed", "Order Delivered"] },
  legend: { show: false }, grid: { padding: { top: -20, bottom: 0 } },
}) });
```

## ApexCharts: Slope

**What it is.** `type:"line"` with `plotOptions.line.isSlopeChart:true` — two (or a few) x-points per
series joined by straight lines.
**Use it when.** Before/after comparison (Jan vs Feb per product, pre/post campaign per channel), rank
changes between two periods; "Multi Slope" for 3+ stages (page views -> visitors -> conversions).
**Source.** `references/sources/pages/charts-apex-slope.html`, `assets/js/pages/chart-apex-slope.js` (+ moment, unused).

| Card | Container id |
|---|---|
| Basic Slope | `#basic-slope` |
| Multi Slope | `#multi-slope` |

**Init / JS.** `series:[{name:"Product A",data:[{x:"Jan",y:120},{x:"Feb",y:160}]}, …]`,
`chart:{type:"line",height:350,width:"100%",toolbar:{show:false}}`, `plotOptions:{line:{isSlopeChart:true}}`.

## ApexCharts: Treemap

**What it is.** `type:"treemap"`, rectangles sized by value, optionally colour-scaled.
**Use it when.** Storage usage by folder, revenue by region/product, traffic by page; "Color Range
Treemap" for signed metrics (growth %: negative red, positive green).
**Source.** `references/sources/pages/charts-apex-treemap.html`, `assets/js/pages/chart-apex-treemap.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Treemap | `#basic-treemap` | |
| Treemap Multiple Series | `#multiple-treemap` | one series per group |
| Distributed Treemap | `#distributed-treemap` | `plotOptions.treemap.distributed:true`, `enableShades:false` |
| Color Range Treemap | `#color-range-treemap` | `plotOptions.treemap.colorScale.ranges` (wrapper fills missing `color` from `colors[0..1]`) |

## ApexCharts: Sparklines

**What it is.** Tiny charts with `chart.sparkline.enabled:true` (no axes/grid/legend) — three stat
tiles with `title`/`subtitle` and eight 140x60 line/bar sparklines inside table cells.
**Use it when.** KPI stat tiles ("12,520 Visitors" with a trend behind it), "last 10 days" columns in a
portfolio/products table, compact widgets in a sidebar. Not for anything needing axes.
**Source.** `references/sources/pages/charts-apex-sparklines.html`, `assets/js/pages/chart-apex-sparklines.js`.

**Markup.**

```html
<div class="card">
  <div class="card-body">
    <div dir="ltr">
      <div class="grid grid-cols-1 md:grid-cols-3 gap-base">
        <div id="spark1" class="apex-charts"></div>
        <div id="spark2" class="apex-charts"></div>
        <div id="spark3" class="apex-charts"></div>
      </div>
    </div>
  </div>
  <div class="table-wrapper">
    <table class="table">
      <thead class="thead-sm bg-light/25 text-xs uppercase">
        <tr><th>Total Value</th><th>Percentage of Portfolio</th><th>Last 10 days</th><th>Volume</th></tr>
      </thead>
      <tbody>
        <tr><td>$32,554</td><td>15%</td><td><div id="chart1"></div></td><td><div id="chart5"></div></td></tr>
        <!-- repeat per row: chart2/chart6, chart3/chart7, chart4/chart8 -->
      </tbody>
    </table>
  </div>
</div>
```

**Init / JS.**

```js
Apex.grid = { padding: { right: 0, left: 0 } };   // ApexCharts globals for every chart on the page
Apex.dataLabels = { enabled: false };

new CustomApexChart({ selector: "#spark1", options: () => ({        // stat tile
  chart: { type: "area", height: 160, sparkline: { enabled: true } },
  stroke: { width: 2, curve: "straight" }, fill: { opacity: .2 },
  series: [{ name: "Unique Visitors", data: sparkDataVisits }], colors: [theme("chart-primary")],
  yaxis: { min: 0 },
  title:    { text: "12,520",   offsetX: 0, style: { fontSize: "20px", fontWeight: 600 } },
  subtitle: { text: "Visitors", offsetX: 0, style: { fontSize: "14px", fontWeight: 500 } },
}) });

new CustomApexChart({ selector: "#chart1", options: () => ({        // table-cell sparkline
  chart: { type: "line", width: 140, height: 60, sparkline: { enabled: true } },
  series: [{ data: [10, 30, 50, 25, 60, 70, 55, 35, 45, 20, 65] }], colors: [theme("chart-zeta")],
  stroke: { width: 2, curve: "smooth" }, markers: { size: 0 },
  tooltip: { fixed: { enabled: false }, x: { show: false }, marker: { show: false } },
}) });
```

**Gotchas.** The `tooltip.y.title.formatter: () => ""` in the demo is stripped by the wrapper, so the
tooltip shows "series-1:"; give the series a `name` instead. Table-cell sparklines have fixed
`width:140` — set `width:"100%"` only if the cell has a stable width.

## ECharts: Line

**What it is.** ECharts `series.type:"line"` variants with the house-style tooltip.
**Use it when.** Same jobs as Apex Line but when you want ECharts' richer `markPoint`/`markLine`
(max/min/average markers), a Y-category "swimlane" line, or `setOption` streaming at high rate.
**Source.** `references/sources/pages/charts-echart-line.html`, `assets/js/pages/chart-echart-line.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Line Chart | `#chart-line` | `smooth`, `areaStyle` optional |
| Line Stacked Chart | `#chart-line-stacked` | `stack:"Total"` |
| Line Marker | `#chart-line-marker` | `markPoint` max/min, `markLine` average |
| Dynamic Line | `#chart-dynamic-line` | `setInterval` + `chart.setOption({series:[{data}]})` |
| Step Line | `#chart-step-line` | `step:"start"/"middle"/"end"` |
| Line Y Category | `#chart-line-y-category` | `yAxis.type:"category"`, `xAxis.type:"value"` |

**Markup.** `<div id="chart-line" style="min-height: 300px"></div>` inside `.card-body`.

## ECharts: Area

**What it is.** The Line page's siblings with `areaStyle` — note the page reuses the same container ids
(`#chart-line`, `#chart-line-stacked`, `#chart-line-marker`, `#chart-dynamic-line`, `#chart-step-line`).
**Use it when.** Stacked traffic composition, filled KPIs, a live "Dynamic Area" feed.
**Source.** `references/sources/pages/charts-echart-area.html`, `assets/js/pages/chart-echart-area.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Area Chart | `#chart-line` | `areaStyle:{opacity:.2,color:theme("chart-primary")}` |
| Stacked Area Chart | `#chart-line-stacked` | `stack` + `areaStyle` per series |
| Area with Marker | `#chart-line-marker` | `markPoint`/`markLine` |
| Dynamic Area | `#chart-dynamic-line` | `xAxis.type:"time"`, `setInterval` |
| Step Area | `#chart-step-line` | `step` + `areaStyle` |

## ECharts: Bar

**What it is.** Twelve bar variants including animated and player-driven ones.
**Use it when.**
- "Progress Bar Chart" — horizontal per-row progress with labels at left (task completion list).
- "Bar Race Chart" — animated ranking over time (`realtimeSort`, `setInterval`), leaderboard screens.
- "Timeline Bar Chart" — ECharts `timeline` component with a play button to step through years.
- "Bar Gradient" / "Negative" / "Two Bar" (actual vs projected with top labels) for marketing dashboards.
**Source.** `references/sources/pages/charts-echart-bar.html`, `assets/js/pages/chart-echart-bar.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Bar Chart | `#chart-basic-bar` | (canonical snippet above) |
| Two Bar Chart | `#two-bar` | `label.position:"top"`, `barGap` |
| Progress Bar Chart | `#progress-bar` | `xAxis.inverse`, `yAxis.axisLabel.align:"left"`, `showBackground` |
| Horizontal Bar Chart | `#chart-hori-bar` | `yAxis.type:"category"` |
| Negative Chart | `#chart-negative` | signed data, `label.position` per sign |
| Bar Chart with Series | `#chart-series-bar` | multi series |
| Stacked Bar | `#chart-stacked-bar` | `stack` |
| Horizontal Stacked Bar | `#chart-horizontal-stacked-bar` | `stack` + category y |
| Bar Race Chart | `#chart-bar-race-chart` | `realtimeSort:true`, `yAxis.inverse`, `animationDurationUpdate:3000`, `setInterval` |
| Bar Gradient Chart | `#chart-bar-gradient` | `echarts.graphic.LinearGradient` |
| Mixded Bar Chart | `#chart-mixed-bar` | bar + line series |
| Timeline Bar Chart | `#chart-timeline-bar` | `timeline:{autoPlay,…}` + `options[]`, `dataZoom` |

**Init / JS.** Bar race core:

```js
const barRaceChart = new CustomEChart({ selector: "#chart-bar-race-chart", options: () => ({
  xAxis: { max: "dataMax", axisLabel: { show: true, color: theme("body-color") } },
  yAxis: { type: "category", data: ["A", "B", "C", "D", "E", "F"], inverse: true, max: 3,
    animationDuration: 300, animationDurationUpdate: 300, axisLabel: { color: theme("body-color") } },
  textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },
  grid: { right: "10%", left: 5, bottom: 5, top: 5, containLabel: true },
  animationDuration: 0, animationDurationUpdate: 3000, animationEasing: "linear", animationEasingUpdate: "linear",
  series: [{ type: "bar", name: "X", realtimeSort: true, data,
    label: { show: true, position: "right", color: theme("body-color"), fontWeight: 500, valueAnimation: true } }],
}) });
// then setInterval(() => { mutate(data); barRaceChart.chart.setOption({ series: [{ data }] }); }, 3000)
```

## ECharts: Pie

**What it is.** Eight pie layouts (basic, doughnut, rounded doughnut, multiple, label-align, rose, edge-align).
**Use it when.** Donut KPIs in dashboard cards (the dashboards use `radius:["60%","100%"]` + hidden
labels), "Nightingale" rose for ranked categories, "Doughnut Rounded" (`itemStyle.borderRadius`) for a
modern segmented ring.
**Source.** `references/sources/pages/charts-echart-pie.html`, `assets/js/pages/chart-echart-pie.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Pie Chart | `#echart-pie-basic` | |
| Doughnut Pie Chart | `#echart-doughnut-pie-basic` | `radius:["40%","70%"]` |
| Doughnut Rounded Pie Chart | `#echart-doughnut-rounded-pie-basic` | `itemStyle.borderRadius`, `borderColor: theme("card")` |
| Multiple Pie Chart | `#echart-pie-multiple-chart` | several series with `center` offsets |
| Pie Label Align Chart | `#echart-pie-label-align-chart` | `label.alignTo:"labelLine"` |
| Nightingale Map | `#echart-pie-nightingale-chart` | `roseType:"area"` |
| Pie Edge Align Chart | `#echart-pie-edge-align-chart` | `label:{position:"outer",alignTo:"edge",margin:20}`, `radius` switched on `window.innerWidth<530` |

## ECharts: Scatter

**What it is.** Scatter, bubble (symbolSize function), quartet (Anscombe, 4 grids) and single-axis scatter.
**Use it when.** Correlation with many points (canvas handles thousands), bubble maps of
segments, "Single Axis Scatter" is really a punch card (hour x weekday, category axes) despite its name.
**Source.** `references/sources/pages/charts-echart-scatter.html`, `assets/js/pages/chart-echart-scatter.js`.

| Card | Container id | Height | Distinctive option |
|---|---|---|---|
| Scatter Chart | `#echart-scatter-basic` | 300px | |
| Bubble Chart | `#echart-bubble-chart` | 300px | `symbolSize: e => Math.sqrt(e[2]) / 500`, `emphasis.focus:"series"` + label, `title`/`legend` |
| Quartet Scatter Chart | `#echart-quartet-scatter` | 600px | `grid[]`, `xAxis[]`, `yAxis[]`, `markLine` regression |
| Single Axis Scatter chart | `#echart-single-axis-scatter` | 450px | punch card: `xAxis`/`yAxis` both `type:"category"` (hours x days), scatter sized by value, `tooltip.position:"top"` |

## ECharts: Radar

**What it is.** Four radar variants with `radar.indicator`, split areas and a `visualMap` one.
**Use it when.** Browser-share style proportions, customised multi-axis comparisons, several small
radars in one card.
**Source.** `references/sources/pages/charts-echart-radar.html`, `assets/js/pages/chart-echart-radar.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Radar Chart | `#chart-basic-radar` | `radar.indicator[{name,max}]`, `splitArea` via `theme("light",.5)` |
| Proportion of Browsers | `#chart-radar1` | `visualMap`, scroll legend |
| Customized Radar Chart | `#chart-radar2` | `shape:"circle"`, custom `axisName` |
| Multiple Radar Chart | `#chart-radar3` | `radar[]` with `center` offsets |

## ECharts: Candlestick

**What it is.** `series.type:"candlestick"` with `dataZoom` (inside + slider) and MA lines.
**Use it when.** Trading-style OHLC with a draggable range slider and moving averages (the "Mixed"
variant); when you need `dataZoom` prefer this over Apex candlestick.
**Source.** `references/sources/pages/charts-echart-candlestick.html`, `assets/js/pages/chart-echart-candlestick.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Candlestick Chart | `#chart-basic-candlestick` | `itemStyle.color/color0/borderColor/borderColor0` from `chart-primary`/`chart-beta` |
| Mixed Candlestick Chart | `#chart-mixed-candlestick` | `dataZoom:[{type:"inside"},{type:"slider"}]`, MA `line` series, `markPoint` |

## ECharts: Gauge

**What it is.** Six `series.type:"gauge"` dials.
**Use it when.** Server load, pressure/temperature readings, speed-stage KPIs with colour bands, "Ring
Gauge" for a progress ring with a big number, "Multi Gauge" for several needles on one dial. The demo
animates three of them with `setInterval` + `setOption`.
**Source.** `references/sources/pages/charts-echart-gauge.html`, `assets/js/pages/chart-echart-gauge.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Basic Gauge Chart | `#chart-basic-gauge` | `progress.show`, `detail.rich` value/name |
| Speed Stage Gauge Chart | `#chart-speed-stage-gauge` | `axisLine.lineStyle.color:[[.3,c1],[.7,c2],[1,c3]]`, `pointer.itemStyle.color:"auto"` |
| Ring Gauge Chart | `#chart-ring-gauge` | `startAngle:90,endAngle:-270`, thick `progress` |
| Temperature Chart | `#chart-temperature-gauge` | `min/max`, `splitNumber`, degree formatter |
| Multi Ring Gauge Chart | `#chart-multiring-gauge` | several `data` items with `title`/`detail` offsets |
| Multi Gauge Chart | `#chart-multi-gauge` | several gauge series with `center` offsets |

**Init / JS.**

```js
new CustomEChart({ selector: "#chart-basic-gauge", options: () => ({
  tooltip: { formatter: "{a} <br/>{b} : {c}%", padding: [7, 15], backgroundColor: theme("card"),
    borderColor: theme("default-300"), textStyle: { color: theme("default-600") }, borderWidth: 1 },
  textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },
  series: [{ name: "Pressure", type: "gauge", radius: "95%",
    progress: { show: true, itemStyle: { color: theme("chart-primary") } },
    pointer: { itemStyle: { color: theme("chart-primary") } },
    axisLine: { lineStyle: { color: [[1, theme("light")]] } },
    axisLabel: { color: theme("default-400"), fontSize: 12 },
    detail: { valueAnimation: true, formatter: v => `{value|${v}}\n{name|SCORE}`,
      rich: { value: { fontSize: 24, fontWeight: "bold", lineHeight: 30, color: theme("body-color") },
              name: { fontSize: 14, color: theme("default-400"), padding: [8, 0, 0, 0] } } },
    data: [{ value: 50 }] }],
}) });
```

## ECharts: Geo Map

**What it is.** Five geographic charts: a world choropleth, a USA map, map<->bar morphing,
pies positioned on a map, and an `effectScatter` over a custom SVG map.
**Use it when.** Sales/users by country or state, regional comparisons with a `visualMap` legend,
"where are our customers" widgets, custom floor-plan/venue SVGs with hotspots.
**Source.** `references/sources/pages/charts-echart-geo-map.html`, `assets/js/pages/chart-echart-geo-map.js`.
External data: `https://cdn.jsdelivr.net/npm/echarts/map/js/world.js` (registers the `"world"` map —
loaded after `echarts.min.js`, before the page script), `fetch("/assets/data/usa_geo.json")` (GeoJSON
registered as `"USA"` with `Alaska/Hawaii/Puerto Rico` insets), `fetch("/assets/images/svg/iceland.svg")`
(SVG registered as `"iceland"`). None of those three are vendored in `references/sources` — supply your
own copies (self-host `world.js`; use a GeoJSON for your region).

| Card | Container id | Distinctive option |
|---|---|---|
| World Map | `#world-map` | `series.type:"map", map:"world", roam:true, scaleLimit`, `areaColor: theme("chart-primary")`, emphasis `theme("chart-gamma")`; click on the card -> `dispatchAction({type:"restore"})` |
| USA Map | `#usa-map` | `geo:{map:"USA"}` + `series.type:"map", geoIndex:0`; `echarts.registerMap("USA", geojson, insets)` |
| Morphing between Map and Bar Chart | `#map-bar-morphing` | `visualMap` population scale, `universalTransition`, `setInterval` toggling map/bar options |
| Pie Chart on Geo Map | `#pie-chart-on-map` | `geo:{map:"USA"}` + several `pie` series with `coordinateSystem:"geo"`, `center:[lng,lat]`, `radius` per pie |
| GEO SVG Scatter | `#geo-svg-scatter-map` | `registerMap("iceland", {svg})`, `effectScatter`, `coordinateSystem:"geo"`, `geoSelect` actions |

**Markup.** `<div id="world-map" style="min-height: 400px"></div>` in a `.card-body`.
**Init / JS.** World choropleth:

```js
const worldMap = new CustomEChart({ selector: "#world-map", options: () => ({
  tooltip: { trigger: "item", padding: [7, 10], backgroundColor: theme("card"), borderColor: theme("default-300"),
    textStyle: { color: theme("default-600") }, borderWidth: 1, transitionDuration: 0, formatter: "{b}" },
  textStyle: { fontFamily: getComputedStyle(document.body).fontFamily },
  series: [{ type: "map", map: "world", roam: true, scaleLimit: { min: 1, max: 5 }, left: 0, right: 0,
    label: { show: false },
    itemStyle: { borderColor: theme("default-300"), areaColor: theme("chart-primary") },
    emphasis: { label: { show: false }, itemStyle: { areaColor: theme("chart-gamma") } } }],
}) });
worldMap.element.addEventListener("click", () => worldMap.chart.dispatchAction({ type: "restore" }));

// Custom GeoJSON region
fetch("/assets/data/usa_geo.json").then(r => r.json()).then(geo => {
  echarts.registerMap("USA", geo, { Alaska: { left: -131, top: 25, width: 15 }, Hawaii: { left: -112, top: 25, width: 5 }, "Puerto Rico": { left: -76, top: 26, width: 2 } });
  new CustomEChart({ selector: document.getElementById("usa-map"), options: () => ({ /* geo:{map:"USA",…}, series:[{type:"map",map:"USA",geoIndex:0}] */ }) });
});
```

**Gotchas.** Register maps *before* constructing the `CustomEChart` (the demo wraps construction in the
`fetch().then()`); the demo's `theme("bg-card")` tooltip background resolves to `""` — use `theme("card")`.
The fetch paths are root-absolute (`/assets/...`), so they break when the app is served from a subfolder.

## ECharts: Heatmap

**What it is.** Cartesian heatmaps with `visualMap`; the third one renders 20K cells with
`progressive:0, animation:false` (canvas).
**Use it when.** Hour x weekday activity with a continuous legend; large matrices (correlation of 100+
features, per-minute telemetry) that would choke an SVG chart.
**Source.** `references/sources/pages/charts-echart-heatmap.html`, `assets/js/pages/chart-echart-heatmap.js`.

| Card | Container id | Distinctive option |
|---|---|---|
| Heatmap Echart | `#chart-heatmap` | `visualMap` piecewise/continuous, `splitArea` via `theme("chart-border-color")` |
| Heatmap Chart | `#chart-heatmap3` | labelled cells, `emphasis.itemStyle.shadowBlur` |
| Heatmap - 20K Data Chart | `#chart-heatmap4` | `visualMap.inRange.color:[theme("chart-primary"), …8 tokens]`, `progressive:0`, `animation:false` |

## ECharts: Other

**What it is.** Pictorial bar (dotted), sunburst, nested pie.
**Use it when.** Sunburst for hierarchical share (org -> team -> person, category -> subcategory);
nested pie for two-level breakdown with an inner/outer ring; pictorial bar for infographic-style KPI
walls.
**Source.** `references/sources/pages/charts-echart-other.html`, `assets/js/pages/chart-echart-other.js`.

| Card | Container id | Height | Distinctive option |
|---|---|---|---|
| Pictorialbar Dotted Chart | `#echart-pictorialbar-dotted` (`class="rounded-md overflow-hidden"`) | 400px | `type:"pictorialBar"`, `symbolRepeat` |
| Basic Sunburst Chart | `#echar-basic-sunburst` (sic) | 399px | `type:"sunburst"`, nested `data.children`, `radius:[0,"90%"]` |
| Nested Pie Chart | `#chart-pie-nest` | 600px | two `pie` series, `radius:[0,"30%"]` + `["45%","60%"]` |

## External dependencies to self-host

Besides the local `assets/plugins/*` bundles, the demo pages pull these from the network. Replace or
self-host them before shipping (they are not in `references/sources`):

| Page | URL | Purpose |
|---|---|---|
| charts-apex-area | `https://apexcharts.com/samples/assets/github-data.js` | sample `githubdata` for "Selection - Github Style" |
| charts-apex-area | `https://apexcharts.com/samples/assets/irregular-data-series.js` | sample series for "Irregular TimeSeries" |
| charts-apex-candlestick | `https://apexcharts.com/samples/assets/ohlc.js` | sample OHLC `seriesData` |
| charts-apex-candlestick | `https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.8.17/dayjs.min.js` | date formatting |
| charts-apex-column | `https://cdnjs.cloudflare.com/ajax/libs/dayjs/1.11.0/dayjs.min.js` + `plugin/quarterOfYear.min.js` | quarter labels in the drill-down |
| charts-echart-geo-map | `https://cdn.jsdelivr.net/npm/echarts/map/js/world.js` | registers the `"world"` map |
| charts-echart-geo-map | `/assets/data/usa_geo.json`, `/assets/images/svg/iceland.svg` | fetched at runtime; not vendored |
| maps-leaflet | `https://{s}.tile.osm.org/{z}/{x}/{y}.png` | OSM tiles (check OSM tile usage policy for production) |
| maps-leaflet | `http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg` | "Watercolor" base layer — Stamen's tile host is discontinued and it is plain http; swap for another provider |
| maps-leaflet | `assets/js/maps/leaflet-data.js` | `statesData` GeoJSON for the choropleth; not vendored |
| maps-vector | `assets/js/maps/*.js` (world-merc, world, in-mill-en, canada, iraq, russia, spain, us-aea-en, us-lcc-en, us-mill-en) | jsVectorMap map definitions; not vendored |
| maps-google | `https://www.google.com/maps/embed/v1/place?…&key=…` | Maps Embed API — needs your own key |

Local plugin bundles used (paths from the manifest): `assets/plugins/apexcharts/apexcharts.min.js`,
`assets/plugins/moment/moment.min.js`, `assets/plugins/echarts/echarts.min.js`,
`assets/plugins/leaflet/leaflet.js` + `leaflet.css`, `assets/plugins/jsvectormap/jsvectormap.min.js`.

## Maps: Leaflet

**What it is.** Seven Leaflet maps on OpenStreetMap tiles, initialised by a `LeafletMap` class in
`maps-leaflet.js` (one `init*()` per card, each guarded by `getElementById`).
**Use it when.**
- Store/branch locator, delivery tracking, asset locations — "Basic Map" + markers.
- "Draggable Marker With Popup" — let the user pin an address in a form.
- "User Location" — "near me" features (`map.locate`, needs HTTPS + permission).
- "Custom Icons" — categorised pins (warehouse / shop / incident).
- "Layer Control" — toggle base layers and overlay groups (cities, routes).
- "Interactive Choropleth Map" — region shading from GeoJSON properties (density, sales).
- For data-driven country maps with legends use ECharts Geo; for lightweight SVG maps use jsVectorMap.
**Source.** `references/sources/pages/maps-leaflet.html`, `assets/js/pages/maps-leaflet.js`,
`assets/plugins/leaflet/leaflet.css` (in `<head>`), `assets/plugins/leaflet/leaflet.js`, `assets/js/maps/leaflet-data.js`.

| Card | Container id | Leaflet API used |
|---|---|---|
| Basic Map | `#basicMap` | `L.map().setView([42.35,-71.08],10)`, `L.tileLayer` |
| Marker Circle & Polygon | `#shapeMap` | `L.marker` (custom `L.icon` from `assets/images/leaflet/marker-icon.png`), `L.circle`, `L.polygon` |
| Draggable Marker With Popup | `#dragMap` | `L.marker(latlng,{draggable:true}).bindPopup().openPopup()` |
| User Location | `#userLocation` | `map.locate({setView:true,maxZoom:16})`, `locationfound` -> marker + accuracy circle |
| Custom Icons | `#customIcons` | `L.icon({iconUrl:"assets/images/leaflet/leaf-red.png", shadowUrl, iconSize:[38,95], iconAnchor, popupAnchor})` |
| Layer Control | `#layerControl` | `L.layerGroup`, two `L.tileLayer`s, `L.control.layers({Street, Watercolor},{Cities})` |
| Interactive Choropleth Map | `#geoJson` | `L.geoJson(statesData,{style: f => ({fillColor: getColor(f.properties.density), weight:2, color:"white", dashArray:"3", fillOpacity:.7})})` |

**Markup.**

```html
<div class="card">
  <div class="card-header block">
    <h4 class="card-title mb-1.25">Basic Map</h4>
    <p class="text-default-400">A simple Leaflet map centered with default tile layer and controls.</p>
  </div>
  <div class="card-body">
    <div class="leaflet-map z-30 h-75" id="basicMap"></div>   <!-- h-75 = 300px; z-30 keeps it under topbar/offcanvas -->
  </div>
</div>
```

**Init / JS.**

```js
class LeafletMap {
  constructor() {
    this.tileLayerUrl = "https://{s}.tile.osm.org/{z}/{x}/{y}.png";
    this.tileLayerOptions = { attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a>', maxZoom: 18 };
  }
  addTileLayer(map) { L.tileLayer(this.tileLayerUrl, this.tileLayerOptions).addTo(map); }
  initBasicMap() {
    const el = document.getElementById("basicMap");
    if (el) { const map = L.map(el).setView([42.35, -71.08], 10); this.addTileLayer(map); }
  }
  initDraggableMap() {
    const el = document.getElementById("dragMap"); if (!el) return;
    const map = L.map(el).setView([48.817152, 2.455], 12);
    const icon = L.icon({ iconUrl: "assets/images/leaflet/marker-icon.png", shadowUrl: "assets/images/leaflet/marker-shadow.png" });
    L.marker([48.817152, 2.455], { draggable: true, icon }).addTo(map).bindPopup("<b>You're here!</b>").openPopup();
    this.addTileLayer(map);
  }
  initLayerControl() {
    const el = document.getElementById("layerControl"); if (!el) return;
    const icon = L.icon({ iconUrl: "assets/images/leaflet/marker-icon.png", shadowUrl: "assets/images/leaflet/marker-shadow.png" });
    const cities = L.layerGroup([L.marker([39.61, -105.02], { icon }).bindPopup("This is Littleton, CO."), /* … */]);
    const street = L.tileLayer(this.tileLayerUrl, this.tileLayerOptions);
    const watercolor = L.tileLayer("http://tile.stamen.com/watercolor/{z}/{x}/{y}.jpg", { attribution: this.tileLayerOptions.attribution, maxZoom: 18 });
    const map = L.map(el, { center: [39.73, -104.99], zoom: 10, layers: [street, cities] });
    L.control.layers({ Street: street, Watercolor: watercolor }, { Cities: cities }).addTo(map);
  }
  init() { this.initBasicMap(); /* …initShapeMap, initDraggableMap, initUserLocation, initCustomIcons, initLayerControl, initGeoJsonMap */ }
}
document.addEventListener("DOMContentLoaded", () => new LeafletMap().init());
```

**Gotchas.**
- Marker icons are set explicitly (`iconUrl: "assets/images/leaflet/marker-icon.png"`) because the
  bundled Leaflet cannot resolve its default image path; keep the `assets/images/leaflet/` folder or
  set `L.Icon.Default.imagePath`.
- A map inside a hidden tab/collapsed card renders grey tiles — call `map.invalidateSize()` once it is shown.
- Leaflet is not theme-aware: tiles stay light in dark mode (apply `filter: invert(100%) hue-rotate(180deg)`
  to the tile pane, as the Google page does, or use a dark tile provider).
- `map.locate` requires a secure origin; the choropleth needs `statesData` (`assets/js/maps/leaflet-data.js`)
  loaded before `maps-leaflet.js`.

## Maps: jsVectorMap

**What it is.** SVG vector maps rendered by jsVectorMap, one `initVectorMap(selector, options)` per card
inside a `VectorMap` class; maps re-init on skin change.
**Use it when.** "Sales by country/state" widgets, office/customer location dots with labels, animated
connection lines (shipping routes, data-centre links), a single highlighted region (`selectedRegions`).
Themeable through `theme()` fills, unlike tile maps.
**Source.** `references/sources/pages/maps-vector.html`, `assets/js/pages/maps-vector.js`,
`assets/plugins/jsvectormap/jsvectormap.min.js` plus map files `assets/js/maps/world-merc.js`, `world.js`,
`in-mill-en.js`, `canada.js`, `iraq.js`, `russia.js`, `spain.js`, `us-aea-en.js`, `us-lcc-en.js`, `us-mill-en.js`
(load only the ones you use).

| Card | Container id | `map:` | Distinctive option |
|---|---|---|---|
| World Vector Map (markers) | `#world-map-markers` | `"world"` | `markers[{name,coords}]`, `markersSelectable`, `zoomButtons`, `labels.markers.render` |
| World Vector Map (lines) | `#world-map-markers-line` | `"world_merc"` | `lines[{from,to}]`, `lineStyle:{animation:true,strokeDasharray:"6 3 6"}` |
| India Vector Map | `#india-vector-map` | `"in_mill"` | `selectedRegions:["IN-GJ"]`, `regionStyle.selected.fill` |
| Canada Vector Map | `#canada-vector-map` | `"canada"` | `zoomOnScroll:false` |
| Russia Vector Map | `#russia-vector-map` | `"russia"` | |
| US Vector Map | `#usa-vector-map` | `"us_aea_en"` | (`us_lcc_en`, `us_mill_en` also bundled) |
| Iraq Vector Map | `#iraq-vector-map` | `"iraq"` | |
| Spain Vector Map | `#spain-vector-map` | `"spain"` | |

**Markup.** `<div id="world-map-markers" style="height: 360px"></div>` in a `.card-body` (same
`.card-header.block` + `p.text-default-400` header as Leaflet).
**Init / JS.**

```js
class VectorMap {
  currentResizeHandler = null;
  initVectorMap(selector, options = {}) {
    const el = selector instanceof Element ? selector : document.querySelector(selector);
    if (!el) return;
    if (el.querySelector("svg")) { el.jsVectorMap?.destroy ? el.jsVectorMap.destroy() : (el.innerHTML = ""); }   // re-init safe
    const map = new jsVectorMap({ selector: el, ...options });
    this.currentResizeHandler = debounce(() => map.updateSize(), 200);
    window.addEventListener("resize", this.currentResizeHandler);
  }
  initWorldMapMarker() {
    this.initVectorMap("#world-map-markers", {
      map: "world", zoomOnScroll: false, zoomButtons: true, markersSelectable: true,
      markers: [{ name: "Greenland", coords: [72, -42] }, { name: "Canada", coords: [56.1304, -106.3468] } /* … */],
      markerStyle: { initial: { fill: theme("primary") }, selected: { fill: theme("primary") } },
      regionStyle: { initial: { stroke: "#aab9d14d", strokeWidth: .25, fill: "#aab9d14d", fillOpacity: 1 } },
      labels: { markers: { render: m => m.name } },
    });
  }
  initUsMap() { this.initVectorMap("#usa-vector-map", { map: "us_aea_en", regionStyle: { initial: { fill: theme("primary") } } }); }
  init() { this.initWorldMapMarker(); /* …initWorldMarkerLine, initIndiaMap, initCanadaMap, initRussiaMap, initUsMap, initIraqMap, initSpainMap */ }
}
document.addEventListener("DOMContentLoaded", () => new VectorMap().init());
new MutationObserver(() => new VectorMap().init())
  .observe(document.documentElement, { attributes: true, attributeFilter: ["data-skin", "data-bs-theme"] });
```

**Gotchas.**
- The page's own observer watches `data-skin` and `data-bs-theme` (a Bootstrap leftover) — **not**
  `data-theme`, so vector maps do not re-colour on the dark-mode toggle. Add `"data-theme"` to the
  `attributeFilter` when you copy it.
- `initVectorMap` keeps only one `currentResizeHandler`; with several maps on a page only the last one
  gets its resize listener removed on re-init (minor leak). Prefer one map per page or track handlers per map.
- Region fills use the literal `#aab9d14d` (8-digit hex with alpha) for the muted base; keep it or use
  `theme("default-300")`.

## Maps: Google

**What it is.** Three `<iframe>` embeds of the Google Maps **Embed API** (`place` mode) — no JS, no
page script.
**Use it when.** A contact/office page, a venue card in an event app, a "directions" tile. Only when the
product already has a Google Cloud project; Leaflet covers the same basic cases without a key.
**Source.** `references/sources/pages/maps-google.html` (no page script; manifest lists `–`).

| Card | Query | Extra params |
|---|---|---|
| Basic Google Map | `q=Eiffel+Tower` | – |
| Street View Google Map | `q=Statue+of+Liberty` | `&zoom=18&maptype=satellite` (satellite, not actual Street View) |
| Dark Google Map | `q=Sydney+Opera+House` | CSS `filter: invert(100%) hue-rotate(180deg)` on the iframe |

**Markup.**

```html
<div class="card">
  <div class="card-header block">
    <h5 class="card-title mb-1.25">Basic Google Map</h5>
    <p class="text-default-400">Displays a basic embedded Google Map.</p>
  </div>
  <div class="card-body">
    <iframe src="https://www.google.com/maps/embed/v1/place?q=Eiffel+Tower&key=YOUR_API_KEY"
            style="width: 100%; height: 360px; overflow: hidden; border: 0"></iframe>
  </div>
</div>
<!-- dark variant: add  filter: invert(100%) hue-rotate(180deg)  to the iframe style -->
```

**Gotchas.**
- The demo hard-codes a Google API key in the `src`; it is the template author's key — replace it with
  your own (Maps Embed API enabled, HTTP-referrer restricted). Without a key the iframe shows an error.
- The "dark" map is a CSS filter, not a styled map: it inverts labels and imagery too. Tie it to
  `[data-theme=dark] iframe { filter: … }` if you want it to follow the theme.
- For markers, clustering or data layers use the Maps JavaScript API instead of the Embed API, or use Leaflet.

## Original sources

- `references/sources/MANIFEST-page-deps.txt` (rows for `charts-apex-*`, `charts-echart-*`, `maps-*`)
- `references/sources/assets/js/app.js` (`theme`, `debounce`, `CustomApexChart`, `CustomEChart`, `CustomChartJs`, `themeObserver`, `menuObserver`)
- `references/sources/assets/css/app.min.css` (`--color-chart-*` tokens, `[data-theme=dark]`, `html[data-skin=*]`, `.apex-charts`, `.apexcharts-*`, `.jvm-*`, `.h-75`)
- `references/sources/pages/charts-apex-area.html`, `-bar`, `-boxplot`, `-bubble`, `-candlestick`, `-column`, `-funnel`, `-heatmap`, `-line`, `-mixed`, `-pie`, `-polar-area`, `-radar`, `-radialbar`, `-range`, `-scatter`, `-slope`, `-sparklines`, `-timeline`, `-treemap`
- `references/sources/pages/charts-echart-area.html`, `-bar`, `-candlestick`, `-gauge`, `-geo-map`, `-heatmap`, `-line`, `-other`, `-pie`, `-radar`, `-scatter`
- `references/sources/pages/maps-google.html`, `maps-leaflet.html`, `maps-vector.html`
- `references/sources/assets/js/pages/chart-apex-area.js`, `chart-apex-bar.js`, `chart-apex-boxplot.js`, `chart-apex-bubble.js`, `chart-apex-candlestick.js`, `chart-apex-column.js`, `chart-apex-funnel.js`, `chart-apex-heatmap.js`, `chart-apex-line.js`, `chart-apex-mixed.js`, `chart-apex-pie.js`, `chart-apex-polar-area.js`, `chart-apex-radar.js`, `chart-apex-radialbar.js`, `chart-apex-range.js`, `chart-apex-scatter.js`, `chart-apex-slope.js`, `chart-apex-sparklines.js`, `chart-apex-timeline.js`, `chart-apex-treemap.js`
- `references/sources/assets/js/pages/chart-echart-area.js`, `chart-echart-bar.js`, `chart-echart-candlestick.js`, `chart-echart-gauge.js`, `chart-echart-geo-map.js`, `chart-echart-heatmap.js`, `chart-echart-line.js`, `chart-echart-other.js`, `chart-echart-pie.js`, `chart-echart-radar.js`, `chart-echart-scatter.js`
- `references/sources/assets/js/pages/maps-leaflet.js`, `maps-vector.js`, `dashboard-projects.js`
