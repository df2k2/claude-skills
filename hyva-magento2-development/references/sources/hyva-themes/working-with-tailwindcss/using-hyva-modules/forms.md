<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/forms.html -->

# Hyvä CSS - Forms

The `@hyva-themes/hyva-modules` package includes form styles in `css/forms.css`. These are a port of [`@tailwindcss/forms`](https://github.com/tailwindlabs/tailwindcss-forms) optimized for Tailwind v4, with improvements from [Fylgja Base](https://fylgja.dev/library/base/) to reduce the footprint and make the styles easier to override.

## What It Does

The forms CSS applies base styles to standard form elements: text inputs, email, password, number, date and time inputs, textareas, selects, checkboxes, and radio buttons. All values are driven by CSS custom properties, so you can retheme the entire form layer by overriding a handful of variables.

Because Tailwind v4's preflight already handles many form resets, `forms.css` does not re-declare what preflight covers. The result is a smaller stylesheet than `@tailwindcss/forms`.

## CSS Variables

All form styles are controlled by these CSS custom properties, defined under `@theme`:

| Variable | Default | Controls |
| --- | --- | --- |
| `--form-py` | `spacing(2)` | Vertical padding for inputs |
| `--form-px` | `spacing(3)` | Horizontal padding for inputs |
| `--form-radius` | `var(--radius-sm)` | Border radius |
| `--form-stroke` | `currentcolor` | Border color |
| `--form-bg` | `#fff` | Background color |
| `--form-color` | `currentcolor` | Text color |
| `--form-active-color` | `var(--color-blue-600)` | Focus and checked state color |
| `--select-icon` | Chevron SVG | Dropdown arrow image |
| `--select-icon-size` | `1.25em` | Dropdown arrow size |
| `--select-icon-offset` | `0.8rem` | Dropdown arrow position from edge |

Override any of these in your theme CSS to restyle form elements globally without touching the form styles directly:

web/tailwind/tailwind-source.css

```
@theme {
    --form-active-color: var(--color-primary);
    --form-radius: var(--radius-md);
    --form-stroke: var(--color-gray-300);
}
```

## Why Hyvä Replaced @tailwindcss/forms

Hyvä 1.4 added Tailwind v4 support. The `@tailwindcss/forms` plugin was designed around a JavaScript plugin API, and while plugins still work in v4, a CSS-native implementation is simpler: one `@import` line, no plugin registration, and all customization done directly in CSS.

The Tailwind v4 preflight already handles many of the form resets that `@tailwindcss/forms` had to declare explicitly. By building on top of preflight rather than re-declaring what it covers, `forms.css` ends up smaller and easier to reason about.

CSS custom properties replace the strategy/class configuration options from `@tailwindcss/forms`. Instead of choosing between `base` and `class` strategies, you have one stylesheet that supports both element selectors and explicit class names out of the box.

## Reverting to @tailwindcss/forms

If you prefer the official plugin, you can swap back. The Hyvä form styles are bundled into the `@import "@hyva-themes/hyva-modules/css"` line in your `tailwind-source.css`. To exclude them, replace that single import with the individual package imports. The full list of individual imports is documented in the [hyva-modules-tailwind-js README](https://github.com/hyva-themes/hyva-modules-tailwind-js).

Once the Hyvä form styles are removed, install `@tailwindcss/forms` and follow the [official plugin documentation](https://github.com/tailwindlabs/tailwindcss-forms) to register it in your Tailwind setup.

## Explicit Class Selectors

In addition to element selectors, `forms.css` also styles these explicit class names. Use them on custom elements that need form styles but don't match the default element selectors:

| Class | Equivalent element |
| --- | --- |
| `.form-input` | `<input type="text">` and similar |
| `.form-textarea` | `<textarea>` |
| `.form-select` | `<select>` |
| `.form-multiselect` | `<select multiple>` |
| `.form-checkbox` | `<input type="checkbox">` |
| `.form-radio` | `<input type="radio">` |
