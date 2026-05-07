<!-- source: https://docs.hyva.io/hyva-themes/performance/measuring-performance.html -->

# Measuring Performance

Before making any changes, measure first. The tools below fall into two categories: lab tools run in a controlled environment and give you instant, reproducible data during development. Field tools collect data from real users on real devices and networks, and are what Google uses for ranking signals.

## Lab tools

Use lab tools during development to get fast, repeatable feedback. Because they run in your browser, results depend on your machine and network, so they should be treated as directional rather than definitive.

### Google Lighthouse and PageSpeed Insights

Lighthouse runs a series of automated tests against a URL and produces a scored report with actionable recommendations. You can run it directly in Chrome DevTools (open a private browsing window, press `F12`, go to the Lighthouse panel, select Mobile device, and click Analyze page load) or through [PageSpeed Insights](https://pagespeed.web.dev/).

PageSpeed Insights runs the same Lighthouse tests but also layers in real-world CrUX field data for that URL. When enough field data is available, it shows lab and field results side by side, which makes it easy to see whether your scores in the browser reflect what actual visitors experience. Prefer PageSpeed Insights over the DevTools panel when the site is publicly accessible.

Each item in the report links to documentation explaining the issue and how to address it.

[developer.chrome.com/docs/lighthouse/overview](https://developer.chrome.com/docs/lighthouse/overview/)

Not every Lighthouse warning is a real problem

Lighthouse flags CSS as a render-blocking resource, but this is expected and correct behavior. Browsers must parse CSS before rendering the page to avoid displaying unstyled content, which would cause significant layout shift and hurt your CLS score.

When you see the "Eliminate render-blocking resources" warning for CSS, the actual problem is almost always one of two things: the CSS file is too large, or it contains a large amount of unused styles. Attempting to load CSS asynchronously or inline only "critical" styles to work around this warning will cause a flash of unstyled content and make CLS worse, not better.

With Hyvä using Tailwind CSS, the generated stylesheet only includes styles that are actually used in your templates, so the file is already small by default. If you still see this warning, make sure you are running a production Tailwind build and not the development watch mode, as the development output includes all utilities and is much larger.

### Chrome Performance Panel

Lighthouse gives you a quick scored report, but it does not always tell you precisely what is causing an issue. When you need a more accurate picture of what is actually happening in the browser, use the Performance Panel. It records a full trace of everything the browser does during a session: script execution, rendering, layout, and painting, and presents the result as a detailed flame chart you can inspect at any level of detail.

This makes it the right tool when Lighthouse flags a problem but the cause is not obvious, when you want to confirm that a fix actually reduced main thread work, or when you need to trace a specific interaction rather than a full page load.

To use it, open Chrome DevTools, go to the Performance tab, click the Record button, reload the page or interact with it, then click Stop. Start by looking for long tasks (highlighted in red) and layout shifts, as these are the most common causes of poor Core Web Vitals scores.

[developer.chrome.com/docs/devtools/performance](https://developer.chrome.com/docs/devtools/performance)

## Field data tools

Field data comes from real users. It reflects actual devices, networks, and usage patterns, which often differ significantly from a developer's machine. Use field data to validate that lab improvements are translating into real improvements.

### Chrome User Experience Report (CrUX)

CrUX is a public dataset of real-world performance metrics collected anonymously from Chrome browsers. The data is aggregated over a 28-day rolling window, so changes take time to appear.

You can access CrUX data through PageSpeed Insights, the [CrUX Dashboard](https://httparchive.org/reports/techreport/landing) via HTTP Archive, or directly via the [CrUX API](https://developer.chrome.com/docs/crux/api).

Pages with low traffic may not have enough data to appear in the dataset.

### Real User Monitoring tools

Third-party RUM tools collect performance data from every user session and give you richer segmentation than CrUX, including breakdowns by country, device type, and page template. They also provide alerting when metrics degrade.

A few solutions that work well with Hyvä:

- [RumVision](https://www.rumvision.com/)
- [Debugbear](https://www.debugbear.com/)
- [JaJuMa RUM Extension for Hyvä](https://www.jajuma.de/en/jajuma-develop/magento-extensions/real-user-monitoring-rum-extension-for-magento-2)

## Measuring specific elements

Sometimes you need to instrument a specific element rather than run a full-page audit. The browser provides two native mechanisms for this.

### The `elementtiming` attribute

Adding `elementtiming="identifier"` to an HTML element tells the browser to track when that element becomes visible to the user. This is useful for identifying which image or text block is your LCP candidate.

```
<img src="hero.jpg" elementtiming="hero-image" alt="Hero image">
```

### PerformanceObserver API

The `PerformanceObserver` API lets you listen for performance entries directly in the browser console or in custom monitoring scripts.

```
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log('LCP candidate:', entry.startTime, entry.element);
  }
});

observer.observe({ type: 'largest-contentful-paint', buffered: true });
```

Combine it with `elementtiming` to track specific elements by identifier:

```
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.identifier === 'hero-image') {
      console.log('Hero image loaded at:', entry.startTime);
    }
  }
});

observer.observe({ type: 'element', buffered: true });
```

[MDN: PerformanceObserver](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver)

## Choosing the right tool

| Goal | Tool |
| --- | --- |
| Fast feedback during development | Lighthouse (DevTools) |
| Comparing lab scores to real users | PageSpeed Insights |
| Diagnosing the root cause of an issue | Performance Panel |
| Monitoring real users over time | CrUX or a RUM tool |
| Tracking a specific element | `elementtiming` + PerformanceObserver |
