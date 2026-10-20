# Forms: elements, layouts, pickers, selects, uploads, editors, validation, wizard

Everything a builder needs to put data-entry UI into an INSPINIA Tailwind page: the template's own
form component classes (`form-input`, `form-select`, `form-checkbox`, `form-switch`, `input-group`,
`input-icon-group`, floating labels, sizes), the layout recipes (stacked, horizontal, inline, grid
"form row", form-in-modal), and the ten plugins the demo wires up (flatpickr, daterangepicker, Pickr,
Choices.js, Select2, Preline `hs-stepper`, Dropzone, FilePond, Quill, noUiSlider, Inputmask,
Typeahead/Bloodhound, plus the template's own touchspin). Reach for this file whenever a page needs
an input that is more than `<input class="form-input">`, or when a settings/CRUD/checkout screen has
to validate, step, upload or pick.

Two facts that save hours:

- **All plugin skins are compiled into `assets/css/app.min.css`.** flatpickr, Choices, Select2, Quill
  (snow + bubble, v2.0.3), daterangepicker, Pickr, noUiSlider, Dropzone, FilePond and typeahead
  `tt-menu` styles are already in the build, re-themed with `var(--color-*)` tokens so they follow
  dark mode. No demo page links any plugin `.css`. Do not add the libraries' own stylesheets; they
  would override the themed rules.
- **Script order is fixed:** `config.js` (head) -> `vendors.min.js` -> `app.js` -> `assets/plugins/<lib>/…`
  -> `assets/js/pages/<page>.js`. jQuery-based plugins (Select2, daterangepicker, Typeahead) explicitly
  load `assets/plugins/jquery/jquery.min.js` before themselves; their page scripts start with
  `window.jQuery = window.$ = $`. `form-wizard.js` is loaded with `type="module"`.

## Quick index

| Need | Use | Source page | Plugin / init script |
|---|---|---|---|
| Plain text / email / password / textarea / native select with label, help text, disabled, readonly, static, valid/invalid state | `form-input`, `form-textarea`, `form-select`, `form-label`, `input-icon-group` | form-elements | none (CSS only) |
| Show/hide password eye button | `data-hs-toggle-password` + `hs-password-active:` | form-elements | Preline autoinit |
| Native HTML5 types (time, number, range, month, week, color, file) | `form-input` on the typed input, `form-range` | form-elements | none |
| Prefix/suffix addon, input + button, dropdown + input, select inside group | `.input-group` + `.input-group-text` | form-elements | Preline `hs-dropdown` for the dropdown variant |
| Label that floats over the field (input, textarea, select) | `peer` + absolutely positioned `label` | form-elements, form-layout | none |
| Small / large inputs and selects | `form-input-sm`, `form-input-lg` | form-elements | none |
| Checkbox, radio, switch (inline, disabled, sizes, colours, reverse) | `form-checkbox`, `form-radio rounded-full!`, `form-switch`, `form-switch-lg` | form-elements | none |
| Segmented toggle buttons backed by checkbox / radio | hidden `peer` input + `label.btn peer-checked:*` | form-elements | none |
| Stacked, horizontal, inline, grid ("form row") and modal form layouts; split sign-in card | `space-y-6`, `grid md:grid-cols-4`, `grid md:grid-cols-6 gap-base`, `hs-overlay` | form-layout | Preline `hs-overlay` for the modal |
| Pick a date / datetime / range / multiple dates / inline calendar with no JS | `data-provider="flatpickr"` + `data-*` | form-pickers | app.js `Plugins.initFlatPicker()` |
| Pick a time (12h / 24h / limited / preset / inline) | `data-provider="timepickr"` + `data-*` | form-pickers | app.js `Plugins.initFlatPicker()` |
| Date range with presets ("Last 7 days") for a report filter; range with times; single date with dropdowns | `data-toggle="date-picker-range"` / `data-toggle="date-picker"` | form-pickers | jQuery + moment + daterangepicker, `form-date-range-picker.js` |
| Colour swatch picker (brand colour, label colour, chart series colour) | `.classic-colorpicker`, `.monolith-colorpicker`, `.nano-colorpicker`, … | form-pickers | Pickr, `form-colorpickr.js` |
| Searchable / grouped / multi / tag-style select without jQuery | `<select data-choices …>` / `<input data-choices>` | form-select | Choices.js (in vendors), `form-choice.js` |
| Select with jQuery ecosystem (remote data, legacy code) | `<select data-toggle="select2" class="form-select select2">` | form-select | jQuery + Select2, `form-select2.js` |
| Client-side validation with green/red borders, icons and messages | `.input-field` + `.valid-msg/.invalid-msg` + `#tailwindValidationForm` | form-validation | `form-validation.js` (HTML5 `checkValidity`) |
| Server-rendered validation state; browser-default validation | `border-success!` / `border-danger!` + `text-2xs` message | form-validation | none |
| Multi-step wizard (onboarding, checkout, enrolment) horizontal / linear with validation / progress bar / vertical | `data-hs-stepper` + `data-hs-stepper-nav-item` / `-content-item` | form-wizard | Preline `HSStepper`, `form-wizard.js` |
| Drag-and-drop multi-image upload with custom preview list | `form[data-plugin="dropzone"]` | form-fileuploads | Dropzone, `form-fileupload.js` |
| Multi-file upload with reorder, size limit, image preview, 1/2/3-column grid | `input.filepond.filepond-input-multiple` | form-fileuploads | FilePond + 4 plugins, `form-fileupload.js` |
| Avatar / profile picture single upload (circle or rounded square) | `input.filepond.filepond-input-circle` | form-fileuploads | FilePond, `form-fileupload.js` |
| Rich-text editor with full toolbar (blog post, product description, email body) | `#snow-editor` | form-text-editors | Quill 2 snow, `form-quilljs.js` |
| Minimal inline-formatting editor (comment, note) | `#bubble-editor` | form-text-editors | Quill 2 bubble, `form-quilljs.js` |
| Single-value slider with sizes, line handle, theme colours | `div[data-slider="default"][data-value]` | form-range-slider | noUiSlider, `form-range-slider.js` |
| Price-range / dual-handle, non-linear, locked pair, merged tooltips, soft limits, vertical sliders | `#rangeslider_multielement`, `#nonlinear`, `#slider1/#slider2`, `#slider-merging-tooltips`, `#soft`, `#slider-vertical…` | form-range-slider | noUiSlider + wNumb, `form-range-slider.js` |
| Masked input (date, time, phone, ZIP, tax id, IP) | `data-toggle="input-mask" data-mask-format="…"` | form-other-plugin | Inputmask, `form-inputmask.js` |
| Autocomplete text field (local list, prefetch JSON, templates, multiple datasets) | `.typeahead`, `.bloodhound-typeahead`, `.prefetch-typeahead`, … | form-other-plugin | jQuery + typeahead.bundle + Bloodhound, `form-typehead.js` |
| Quantity stepper (+ / −) for cart lines, seat counts | `.input-group[data-touchspin]` + `[data-minus]` / `[data-plus]` | form-other-plugin | app.js `Plugins.initTouchSpin()` |

## Basic text inputs and states

**What it is.** The template's base form controls: `form-input` (text-like inputs and plain selects),
`form-textarea`, `form-select` (adds the chevron background), `form-label`, and the `input-icon-group`
wrapper for a leading/trailing icon. Height is `9.25 * --spacing` (37px), text `text-sm`, border
`default-300`, background `bg-card`, so they flip in dark mode automatically.

**Use it when.**
- Any CRUD form: customer record, product attributes, settings page, ticket reply.
- Search boxes in a card header or table toolbar (`input-icon-group` + `tabler--search`).
- Read-only "static" fields in a details panel (`readonly` + `border-transparent! bg-transparent!`).
- Prefer `form-select` for native selects that must look like the rest of the form; reach for
  Choices.js / Select2 (below) only when you need search, tags or option groups with UI.

**Source.** `references/sources/pages/form-elements.html` (card "Input Textfield Type").

**Markup.**

```html
<!-- label + input (the demo's two-column label/field grid) -->
<div class="grid grid-cols-1 gap-1.5 lg:grid-cols-3 lg:gap-9">
  <div><label for="simpleinput" class="form-label py-2 mb-0!">Simple Input</label></div>
  <div class="lg:col-span-2"><input type="text" id="simpleinput" class="form-input" /></div>
</div>
<div class="border-default-300 my-5 border-t border-dashed"></div>   <!-- row separator -->

<!-- stacked label -->
<label for="labelInputInput1" class="form-label">Label Input</label>
<input type="email" class="form-input" id="labelInputInput1" placeholder="name@example.com" />

<!-- help text -->
<input type="text" class="form-input" placeholder="Helping text" />
<small class="text-default-400 mt-1 block text-xs">A block of help text that breaks onto a new line.</small>

<!-- textarea / native selects -->
<textarea rows="5" class="form-textarea"></textarea>
<select class="form-select"><option selected>Open this select menu</option><option>One</option></select>
<select multiple class="form-input h-auto!"><option>1</option><option>2</option></select>

<!-- leading icon (search) and icon + select -->
<div class="input-icon-group"><i class="iconify tabler--search input-icon"></i>
  <input type="search" placeholder="Search for something..." class="form-input" /></div>
<div class="input-icon-group"><i class="iconify tabler--discount input-icon"></i>
  <select class="form-input"><option selected>Choose Discount</option><option>No Discount</option></select></div>

<!-- trailing icon (invalid) -->
<div class="input-icon-group"><input type="text" class="form-input border-danger" required />
  <i class="iconify tabler--info-circle text-danger! input-icon text-base"></i></div>

<!-- valid state with absolute check icon -->
<div class="relative"><input type="text" class="form-input border-success!" required />
  <div class="pointer-events-none absolute inset-y-0 end-0 flex items-center pe-3">
    <i class="iconify tabler--check text-success text-base"></i></div></div>
```

| State / variant | Classes or attributes |
|---|---|
| Placeholder | `placeholder="…"` |
| Disabled | `disabled` (template dims it) |
| Readonly | `readonly class="form-input cursor-not-allowed"` |
| Static control (looks like text) | `readonly class="form-input border-transparent! bg-transparent!"` |
| Rounded pill | `class="form-input rounded-full!"` |
| Valid / invalid border | `border-success!` / `border-danger` (or `border-danger!`) |
| Icon on the left / right | `input-icon-group` with `<i class="… input-icon">` as first / last child; the CSS adds `padding-inline-start: 10*spacing` to the following `form-input`/`form-select` |

**Gotchas.**
- `input-icon-group` positions the icon by `:first-child` / `:last-child`: put the `<i>` before the
  input for a leading icon and after it for a trailing icon, nothing else inside the wrapper.
- Multiple selects need `h-auto!` because `form-input` fixes the height.
- `form-select` and `form-input` on a `<select>` both work; `form-select` adds the chevron
  background-image, `form-input` leaves the browser's native arrow.

## Input types (incl. show/hide password)

**What it is.** Native HTML5 inputs styled with `form-input`, plus the Preline toggle-password button.

**Use it when.**
- Account/security settings (password with reveal), scheduling (time, month, week), numeric
  quantities (number), simple opacity/volume controls (`form-range`), theme/brand colour (color).
- For masked phone/date entry use Inputmask (below); for a real date picker use flatpickr.

**Source.** `references/sources/pages/form-elements.html` (card "Input Types").

**Markup.**

```html
<input type="email" class="form-input" placeholder="Email" />
<input type="password" class="form-input" value="password" />
<input type="time" class="form-input" />
<input type="number" name="number" class="form-input" />
<input type="range" class="form-range" min="0" max="100" />
<input type="month" class="form-input" />
<input type="week" class="form-input" />
<input type="color" value="#2563eb" class="form-input h-10 p-1!" />
<input type="file" name="file-input" class="form-input" multiple />

<!-- show / hide password (Preline) -->
<div class="relative flex items-center">
  <input id="password" type="password" class="form-input w-full" placeholder="Enter password" />
  <button type="button" data-hs-toggle-password='{"target":"#password"}'
          class="bg-default-100 border-default-300 absolute inset-y-0 end-0 flex items-center rounded rounded-s-none! border px-3 py-1.75">
    <i class="iconify tabler--eye hs-password-active:hidden block text-sm"></i>
    <i class="iconify tabler--eye-off hs-password-active:block hidden text-sm"></i>
  </button>
</div>
```

**Gotchas.**
- `data-hs-toggle-password` is JSON: keep the double quotes inside single-quoted attribute.
  `hs-password-active:` is the only password variant compiled into this build.
- `<input type="color">` needs `h-10 p-1!` or the swatch collapses inside the fixed-height input.

## Input groups

**What it is.** `.input-group` is a flex row that glues `.input-group-text` addons, buttons, dropdowns
and `form-input`/`form-select`/`form-textarea` together (children get `flex:1 1 auto; width:1%`).

**Use it when.**
- Currency amounts (`$` … `.00`), usernames (`@`), vanity URLs, email + domain, API key + "Copy"
  button, unit suffixes (kg, %).
- A select whose options depend on a dropdown choice (dropdown + input).

**Source.** `references/sources/pages/form-elements.html` (card "Input Group").

**Markup.**

```html
<div class="input-group"><span class="input-group-text">@</span><input type="text" placeholder="Username" class="form-input" /></div>
<div class="input-group"><span class="input-group-text">$</span><input type="text" class="form-input" /><span class="input-group-text">.00</span></div>
<div class="input-group"><input type="text" placeholder="Recipient's username" class="form-input" /><span class="input-group-text">@example.com</span></div>
<div class="input-group"><input type="text" placeholder="Username" class="form-input" /><span class="input-group-text">@</span><input type="text" placeholder="Server" class="form-input" /></div>
<div class="input-group"><span class="input-group-text text-nowrap">https://example.com/users/</span><input type="text" class="form-input" /></div>
<div class="input-group"><span class="input-group-text">With textarea</span><textarea rows="2" class="form-textarea"></textarea></div>

<!-- input + button -->
<div class="input-group"><input type="text" placeholder="Recipient's username" class="form-input" />
  <button type="button" class="btn bg-dark text-white hover:bg-dark-hover">Button</button></div>

<!-- dropdown + input -->
<div class="input-group">
  <div class="hs-dropdown relative inline-flex">
    <button type="button" class="hs-dropdown-toggle btn bg-primary rounded-e-none text-white hover:bg-primary-hover" aria-haspopup="menu" aria-expanded="false">
      Dropdown <i class="iconify tabler--chevron-down text-base text-white"></i></button>
    <div class="hs-dropdown-menu" role="menu" aria-orientation="vertical">
      <div class="space-y-0.5"><a class="dropdown-item" href="#!">Action</a><a class="dropdown-item active" href="#!">Another action</a></div>
    </div>
  </div>
  <input type="text" class="form-input" />
</div>

<!-- addon + select -->
<div class="input-group"><span class="input-group-text">Options</span>
  <select class="form-input rounded-s-none!"><option selected>Choose...</option><option>One</option></select></div>
```

**Gotchas.**
- The CSS does not define `input-group-sm`/`input-group-lg`; size the inner control with
  `form-input-sm`/`form-input-lg` instead.
- Long addon text needs `text-nowrap` or it wraps inside the addon.
- The template rounds the inner corners automatically for `.input-group-text`, but a `select` or a
  button that is not first/last needs manual `rounded-s-none!` / `rounded-e-none`.

## Floating labels

**What it is.** A label absolutely positioned inside the field that shrinks and moves up on focus or
when the field has a value. Pure Tailwind `peer` variants, no JS. Two flavours exist in the demo.

**Use it when.**
- Compact sign-up / onboarding forms, dense "create account" grids where a separate label row costs
  too much vertical space.
- Not for forms with help text or validation messages under each field (use `form-label`).

**Source.** `references/sources/pages/form-elements.html` (cards "Input Textfield Type" > Floating
Input, "Floating Labels"); `references/sources/pages/form-layout.html` (card "Floating Labels").

**Markup.**

```html
<!-- Variant A (form-elements "Floating Labels"): Preline-style, scale/translate on focus or value -->
<div class="relative">
  <input type="email" id="hs-floating-input-email" placeholder="you@email.com"
         class="peer border-default-300 focus:border-default-500 block w-full rounded bg-transparent p-4 not-placeholder-shown:pt-6 not-placeholder-shown:pb-2 placeholder:text-transparent autofill:pt-6 autofill:pb-2 focus:pt-6 focus:pb-2 focus:ring-0 sm:text-sm" />
  <label for="hs-floating-input-email"
         class="peer-focus:text-default-500 peer-not-placeholder-shown:text-default-500 pointer-events-none absolute start-0 top-0 h-full origin-top-left truncate border border-transparent p-4 transition duration-100 ease-in-out peer-not-placeholder-shown:translate-x-0.5 peer-not-placeholder-shown:-translate-y-1.5 peer-not-placeholder-shown:scale-90 peer-focus:translate-x-0.5 peer-focus:-translate-y-1.5 peer-focus:scale-90 sm:text-sm">Email</label>
</div>
<!-- same classes work on <textarea rows="4" placeholder=""> and on <select placeholder=""> with a
     disabled empty first option -->

<!-- Variant B (form-layout "Floating Labels"): bg-card field, label jumps between top-3.5 and top-1.5 -->
<div class="relative">
  <input type="text" id="usernameInput" placeholder=""
         class="peer block bg-card w-full border border-default-300 rounded px-3 pt-5 pb-2 text-base focus:border-0 focus:ring focus:ring-default-300" />
  <label for="usernameInput"
         class="absolute left-3 top-2 text-default-500 text-sm transition-all peer-placeholder-shown:top-3.5 peer-placeholder-shown:text-default-400 peer-placeholder-shown:text-sm peer-focus:top-1.5 peer-focus:text-xs peer-focus:border-0 peer-focus:ring-0">Username</label>
</div>
<!-- textarea version adds h-25 to the field and bg-card to the label; select version drops placeholder -->
```

**Gotchas.**
- Both variants depend on `placeholder` being present (even `placeholder=""`): the
  `placeholder-shown` pseudo-class is what tells "empty" from "filled". Variant A hides the real
  placeholder with `placeholder:text-transparent`.
- Variant B uses physical `left-3`; switch to `start-3` for RTL layouts (variant A already uses `start-0`).
- `<select>` has no placeholder state; the demo gives it `placeholder=""` plus
  `<option value="" selected disabled>` so the label stays "up".

## Input sizes

**What it is.** `form-input-sm` (height 7.5 * spacing, `text-xs`) and `form-input-lg` (height 11.75 * spacing,
`text-base`) modifiers; also work on `<select>`.

**Use it when.** Table toolbars and filter bars (`-sm`), hero search / primary amount fields (`-lg`).

**Source.** `references/sources/pages/form-elements.html` (card "Input Sizes"); label sizing in
`form-layout.html` (card "Horizontal Form Label Sizing").

**Markup.**

```html
<input type="text" class="form-input form-input-sm" placeholder=".input-sm" />
<input type="text" class="form-input" placeholder="Normal" />
<input type="text" class="form-input form-input-lg" placeholder=".input-lg" />
<select class="form-input form-input-sm"><option selected>Open this select menu</option></select>
<select class="form-input form-input-lg"><option selected>Open this select menu</option></select>

<!-- matching label sizes (horizontal form) -->
<label class="text-xs block mb-2">Email</label>  <!-- with form-input-sm -->
<label class="form-label">Email</label>          <!-- default -->
<label class="text-base block mb-2">Email</label><!-- with form-input h-12! text-base! -->
```

## Checkboxes, radios and switches

**What it is.** `form-checkbox`, `form-radio` (add `rounded-full!` for the round look), `form-switch`
(toggle, 7.5 x 5 spacing) and `form-switch-lg` (8.5 x 5.5). Checked colour is overridden with
`checked:bg-<token>!`; size with `size-5!`, `size-6!`, `size-6.25!`.

**Use it when.**
- Permissions matrices, notification preferences (switches), billing cycle / shipping method choice
  (radios), bulk-select rows (checkbox; the table CSS highlights `tr:has(.form-checkbox:checked)`).
- "Reverse" layout (label first, control at the end) for settings lists.

**Source.** `references/sources/pages/form-elements.html` (card "Checks, Radios and Switches").

**Markup.**

```html
<!-- checkbox row (repeat) -->
<div class="flex items-center gap-2"><input type="checkbox" id="checkDefault" class="form-checkbox" />
  <label for="checkDefault">Default Checkbox</label></div>
<!-- inline pair -->
<div class="flex items-center gap-x-4">
  <div class="flex items-center gap-2"><input type="checkbox" id="checkInline1" class="form-checkbox" checked /><label for="checkInline1">Inline 1</label></div>
  <div class="flex items-center gap-2"><input type="checkbox" id="checkInline2" class="form-checkbox" /><label for="checkInline2">Inline 2</label></div>
</div>
<!-- disabled -->
<input type="checkbox" class="form-checkbox" checked disabled />

<!-- radio -->
<div class="flex items-center gap-2"><input type="radio" name="gridRadio" id="radio1" class="form-radio rounded-full!" checked /><label for="radio1">Option 1</label></div>

<!-- switch -->
<div class="flex items-center gap-2"><input type="checkbox" id="switch1" class="form-switch" checked /><label for="switch1">Enabled Switch</label></div>
<div class="flex items-center gap-2"><input type="checkbox" id="switch2" class="form-switch" disabled /><label for="switch2" class="text-default-400">Disabled Switch</label></div>

<!-- reverse (control on the right) -->
<div class="flex flex-row-reverse items-center gap-2"><input type="checkbox" id="reverseCheck1" class="form-checkbox" checked /><label for="reverseCheck1">Reverse checkbox</label></div>
```

| Variant | Classes |
|---|---|
| Light checkbox | `form-checkbox bg-default-200! checked:bg-primary!` |
| Coloured checkbox / switch / radio | `checked:bg-primary!` `checked:bg-secondary!` `checked:bg-success!` `checked:bg-info!` `checked:bg-warning!` `checked:bg-danger!` `checked:bg-dark!` |
| Checkbox sizes | `form-checkbox size-5!` (20px), `form-checkbox size-6.25!` |
| Radio sizes | `form-radio rounded-full! size-5!`, `… size-6!` |
| Switch sizes | `form-switch` (default), `form-switch form-switch-lg` |

**Gotchas.**
- The "Colored Radios" demo uses `type="checkbox"` with `form-radio` classes; for a real exclusive
  group use `type="radio"` with a shared `name`.
- `form-radio` alone renders with `--radius` corners; add `rounded-full!` for circles.
- Dark mode: `form-switch` track is `default-200` and flips automatically; a `[dir=rtl]` rule
  mirrors the knob.

## Checkbox / radio toggle buttons

**What it is.** A visually hidden `peer` checkbox/radio with a `label.btn` that fills on
`peer-checked:`. Groups are built by joining buttons with `rounded-e-none` / `rounded-none border-x-0` /
`rounded-s-none`.

**Use it when.** View switchers (list/grid), day-of-week pickers, multi-select filter chips, single
"Left / Middle / Right" alignment choice. For a non-form tab bar use `nav-tabs` instead.

**Source.** `references/sources/pages/form-elements.html` (rows "Checkbox Toggle", "Radio Toggle").

**Markup.**

```html
<!-- single toggle -->
<div><input type="checkbox" id="toggleSingle" class="peer hidden" />
  <label for="toggleSingle" class="btn border-primary text-primary peer-checked:bg-primary peer-checked:text-white">Single Toggle</label></div>

<!-- joined checkbox group -->
<div class="flex">
  <div><input type="checkbox" id="toggle1" class="peer hidden" />
    <label for="toggle1" class="btn rounded-e-none border-primary text-primary peer-checked:bg-primary peer-checked:text-white">One</label></div>
  <div><input type="checkbox" id="toggle2" class="peer hidden" />
    <label for="toggle2" class="btn rounded-none border-x-0 border-primary text-primary peer-checked:bg-primary peer-checked:text-white">Two</label></div>
  <div><input type="checkbox" id="toggle3" class="peer hidden" />
    <label for="toggle3" class="btn rounded-s-none border-primary text-primary peer-checked:bg-primary peer-checked:text-white">Three</label></div>
</div>

<!-- radio group (exclusive) -->
<div class="flex">
  <div><input type="radio" name="radiotoggle" id="radioLeft" class="peer hidden" checked />
    <label for="radioLeft" class="btn rounded-e-none border-secondary text-secondary peer-checked:bg-secondary peer-checked:text-white">Left</label></div>
  <!-- … Middle (rounded-none border-x-0), Right (rounded-s-none) -->
</div>
```

**Gotchas.** The input must be the immediate previous sibling of the label (`peer` only reaches forward
siblings), hence the per-button `<div>` wrapper.

## Form layouts

**What it is.** The layout recipes used across the demo: stacked (`space-y-6`), horizontal
(`grid md:grid-cols-4` label/field rows), horizontal with label sizes, inline (`flex flex-wrap gap-6`),
auto-sizing inline, "form row" grid (`grid md:grid-cols-6 gap-base` with `md:col-span-N`), a split
sign-in card and the same card inside a Preline modal.

**Use it when.**
- Stacked: short forms, modals, sidebars.
- Horizontal: settings pages where labels align in a column (profile, SMTP, tax settings).
- Inline: filter bars above tables, "confirm identity" rows, quick-add rows.
- Form row grid: address blocks, invoice header, product pricing (mixed column spans).
- Modal form: login/consent/"add item" dialogs launched from a table or a card header.

**Source.** `references/sources/pages/form-layout.html`.

**Markup.**

```html
<!-- Basic (stacked) -->
<form class="space-y-6">
  <div>
    <label for="exampleInputEmail1" class="form-label">Email address</label>
    <div><input type="email" class="form-input" id="exampleInputEmail1" placeholder="Enter email" required /></div>
    <small class="text-xs text-default-400">We'll never share your email with anyone else.</small>
  </div>
  <div class="flex items-center gap-2"><input class="form-checkbox border-0" type="checkbox" id="checkmeout0" />
    <label class="font-medium text-default-600" for="checkmeout0">Check me out !</label></div>
  <button class="btn bg-primary text-white hover:bg-primary-hover" type="submit"><strong>Submit</strong></button>
</form>

<!-- Horizontal: label column + 3-column field -->
<form class="space-y-6">
  <div class="grid md:grid-cols-4">
    <div><label for="inputEmail3" class="form-label">Email</label></div>
    <div class="md:col-span-3"><input type="email" class="form-input" id="inputEmail3" placeholder="Email" required /></div>
  </div>
  <div class="grid md:grid-cols-4">
    <div class="md:col-span-3 md:col-start-2">   <!-- offset row for checkbox / button -->
      <button class="btn bg-info text-white hover:bg-info-hover" type="submit"><strong>Sign in</strong></button></div>
  </div>
</form>
<!-- label sizing variant: grid md:grid-cols-6, field md:col-span-5, see "Input sizes" -->

<!-- Inline -->
<form class="grid lg:grid-cols-2 md:grid-cols-1 gap-3 items-center mb-5">
  <div class="flex flex-wrap items-center gap-6">
    <div><label for="staticEmail2" class="sr-only hidden">Email</label>
      <input type="text" id="staticEmail2" value="email@example.com" readonly class="bg-transparent border-0 text-default-700 text-sm focus:ring-0" /></div>
    <div><label for="inputPassword2" class="sr-only hidden">Password</label>
      <input type="password" id="inputPassword2" placeholder="Password" class="form-input" /></div>
    <div><button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Confirm identity</button></div>
  </div>
</form>

<!-- Auto-sizing inline with an addon -->
<div class="lg:col-span-2 flex flex-wrap items-center gap-4">
  <div><label class="hidden" for="inlineFormInput">Name</label><input type="text" class="form-input" id="inlineFormInput" placeholder="Jane Doe" /></div>
  <div><div class="flex"><span class="inline-flex items-center px-3 rounded-s-md border border-default-300 bg-default-100 text-default-600 text-sm">@</span>
    <input type="text" class="form-input rounded-s-none!" placeholder="Username" /></div></div>
  <div><div class="flex items-center gap-2"><input class="form-checkbox" type="checkbox" id="autoSizingCheck" /><label class="font-medium text-default-600" for="autoSizingCheck">Check me out !</label></div></div>
  <div><button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Submit</button></div>
</div>

<!-- Form row (6-column grid) -->
<form>
  <div class="grid md:grid-cols-6 gap-base">
    <div class="md:col-span-3"><label for="inputEmail4" class="form-label">Email</label><div><input type="email" class="form-input" id="inputEmail4" required /></div></div>
    <div class="md:col-span-3"><label for="inputPassword4" class="form-label">Password</label><div><input type="password" class="form-input" id="inputPassword4" required /></div></div>
    <div class="md:col-span-6"><label for="inputAddress" class="form-label">Address</label><div><input type="text" class="form-input" id="inputAddress" placeholder="1234 Main St" required /></div></div>
    <div class="md:col-span-3"><label for="inputCity" class="form-label">City</label><div><input type="text" class="form-input" id="inputCity" required /></div></div>
    <div class="md:col-span-2"><label for="inputState" class="form-label">State</label>
      <select id="inputState" class="form-input"><option>Choose</option><option>Option 1</option></select></div>
    <div class="md:col-span-1"><label for="inputZip" class="form-label">Zip</label><div><input type="text" class="form-input" id="inputZip" required /></div></div>
    <div class="md:col-span-6">
      <div class="flex items-center gap-2 mb-3"><input class="form-checkbox border-0" type="checkbox" id="customCheck11" /><label class="font-medium text-default-600" for="customCheck11">Check this custom checkbox</label></div>
      <button class="btn bg-primary text-white hover:bg-primary-hover" type="submit"><strong>Sign in</strong></button></div>
  </div>
</form>

<!-- Split sign-in card (also used inside the modal) -->
<div class="card"><div class="card-body">
  <div class="grid md:grid-cols-2 grid-cols-1 items-center gap-7.5">
    <div class="md:border-e md:border-0 border-b border-dashed border-default-300 md:pb-0 pb-4">
      <div class="md:p-7.5">
        <h4 class="text-lg uppercase font-bold mb-1.25">Sign in</h4>
        <p class="text-default-400 mb-7.5">Let's get you signed in. Enter your email and password to continue.</p>
        <form>
          <div class="mb-5"><label for="userEmail" class="form-label">Email address <span class="text-danger">*</span></label>
            <div><input type="email" class="form-input" id="userEmail" placeholder="you@example.com" required /></div></div>
          <div class="mb-5"><label for="userPassword" class="form-label">Password <span class="text-danger">*</span></label>
            <div><input type="password" class="form-input" id="userPassword" placeholder="••••••••" required /></div></div>
          <div class="flex flex-wrap justify-between items-start">
            <div class="flex items-center gap-2"><input class="form-checkbox border-0" type="checkbox" id="rememberMe2" /><label class="font-medium italic text-default-400" for="rememberMe2">Keep me signed in</label></div>
            <button class="btn bg-primary rounded-full text-white" type="submit"><strong>Log in</strong></button></div>
        </form>
      </div>
    </div>
    <div class="text-center">
      <div class="mb-5"><span class="btn btn-icon size-12 rounded-full bg-secondary/15"><i class="iconify tabler--user-hexagon text-secondary size-7"></i></span></div>
      <h4 class="mb-2 text-lg">Don't Have an Account Yet?</h4>
      <p class="text-default-400 mb-5">Join us today and unlock access to personalized features.</p>
      <a href="auth-sign-up.html" class="text-primary underline font-semibold">Create Your Account</a>
    </div>
  </div>
</div></div>

<!-- Modal form: trigger + hs-overlay wrapping the card above -->
<button type="button" class="btn bg-primary text-white hover:bg-primary-hover" aria-haspopup="dialog" aria-expanded="false" aria-controls="modal-form" data-hs-overlay="#modal-form">Form in simple modal box</button>
<div id="modal-form" class="hs-overlay hs-overlay-open:opacity-100 hs-overlay-open:duration-500 hidden size-full fixed top-8 start-0 z-80 opacity-0 overflow-x-hidden transition-all overflow-y-auto" role="dialog" tabindex="-1" aria-labelledby="modal-form-label">
  <div class="hs-overlay-animation-target lg:w-3xl md:w-2xl w-xs mx-auto">
    <div class="card"><div class="card-body"> <!-- split sign-in card, with text-start on the form column --> </div></div>
  </div>
</div>
```

**Gotchas.**
- Field wrappers in the demo are `<div><input …/></div>` inside the label's parent; keep that
  wrapper if you plan to append absolute validation icons (`relative` goes on it).
- The modal is plain Preline `hs-overlay` (no `.modal` class); the width lives on the
  `hs-overlay-animation-target` div. Inside the modal add `text-start` to the form column because the
  parent demo wrapper is `text-center`.
- The demo reuses ids (`userEmail`, `userPassword`) between the inline and modal copies; give yours
  unique ids or labels will focus the wrong field.

## Flatpickr date picker (`data-provider="flatpickr"`)

**What it is.** Declarative flatpickr: `app.js` (`Plugins.initFlatPicker()`, runs on
`DOMContentLoaded`) scans `[data-provider]` and builds the flatpickr options from `data-*`
attributes. No page script required; flatpickr itself is bundled in `vendors.min.js`.

**Use it when.**
- Due date / publish date on a form; booking start and end (`data-range-date`); multi-day event
  selection (`data-multiple-date`); embedded calendar widget on a dashboard card
  (`data-inline-date`); report filter with min/max bounds.
- For a picker with preset ranges ("Last 30 days") use the daterangepicker section instead.

**Source.** `references/sources/pages/form-pickers.html` (card "Flatpickr" > Datepicker);
`references/sources/assets/js/app.js` (`class Plugins`). Also used on apps-invoice-create,
apps-ecommerce-order-add, apps-clients, apps-api-keys, apps-blog-add and others.

**Markup.**

```html
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" placeholder="Select date" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d.m.y" data-enable-time placeholder="Select date & time" />
<input type="text" class="form-input" data-provider="flatpickr" data-altFormat="F j, Y" placeholder="Select date" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-minDate="25 12, 2021" data-maxDate="29 12,2021" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-default-date="25 12,2021" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-disable-date="15 12,2021" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-multiple-date="true" placeholder="Select multiple dates" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-range-date="true" placeholder="Select date range" />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-week-number />
<input type="text" class="form-input" data-provider="flatpickr" data-date-format="d M, Y" data-default-date="25 01,2021" data-inline-date="true" />
```

**Init / JS.** What `app.js` does for `data-provider="flatpickr"` (every supported attribute):

```js
// app.js — Plugins.initFlatPicker(), trimmed
const opts = { disableMobile: true, defaultDate: new Date() };   // base for every provider
if (a["data-date-format"])  opts.dateFormat = a["data-date-format"].value;
if (a["data-enable-time"])  { opts.enableTime = true; opts.dateFormat += " H:i"; }
if (a["data-altFormat"])    { opts.altInput = true; opts.altFormat = a["data-altFormat"].value; }
if (a["data-minDate"])      opts.minDate = a["data-minDate"].value;
if (a["data-maxDate"])      opts.maxDate = a["data-maxDate"].value;
if (a["data-default-date"]) opts.defaultDate = a["data-default-date"].value;
if (a["data-multiple-date"]) opts.mode = "multiple";
if (a["data-range-date"])    opts.mode = "range";
if (a["data-inline-date"])  { opts.inline = true; opts.defaultDate = a["data-default-date"].value; }
if (a["data-disable-date"]) opts.disable = a["data-disable-date"].value.split(",");
if (a["data-week-number"])  opts.weekNumbers = true;
flatpickr(el, opts);
```

| Attribute | flatpickr option | Notes |
|---|---|---|
| `data-provider="flatpickr"` | — | required hook |
| `data-date-format="d M, Y"` | `dateFormat` | flatpickr tokens |
| `data-enable-time` | `enableTime: true`, appends `" H:i"` to `dateFormat` | presence only |
| `data-altFormat="F j, Y"` | `altInput: true, altFormat` | human-friendly display, real value stays in `dateFormat` |
| `data-minDate` / `data-maxDate` | `minDate` / `maxDate` | string parsed by flatpickr |
| `data-default-date` | `defaultDate` | overrides the "today" default |
| `data-multiple-date` | `mode: "multiple"` | presence only (`="true"` in demo) |
| `data-range-date` | `mode: "range"` | presence only |
| `data-inline-date` | `inline: true` + `defaultDate` from `data-default-date` | **requires** `data-default-date` |
| `data-disable-date="a,b"` | `disable: [...]` | comma-separated list |
| `data-week-number` | `weekNumbers: true` | presence only |

**Gotchas.**
- `defaultDate: new Date()` is always set, so every declarative picker opens pre-filled with
  **today**. For an initially empty field call `flatpickr(el, {...})` yourself and omit
  `data-provider`, or clear it after init (`el._flatpickr.clear()`).
- `data-enable-time` does `dateFormat += " H:i"`; without `data-date-format` you get the literal
  string `"undefined H:i"`. Always pair them.
- `data-inline-date` reads `data-default-date` unconditionally; omitting it throws and stops the
  loop, breaking every later `[data-provider]` on the page.
- Attribute lookups are through `el.attributes[...]` which is case-insensitive in HTML, so
  `data-altformat` / `data-mindate` also work; keep the demo spelling for consistency.
- `disableMobile: true` forces the flatpickr UI on phones instead of the native picker.
- Markup injected after load is not initialised: call `new Plugins().init()`-equivalent yourself
  (`flatpickr(el, opts)`); `Plugins` is only run once on `DOMContentLoaded`.

## Flatpickr time picker (`data-provider="timepickr"`)

**What it is.** Same `app.js` loop, `timepickr` branch: flatpickr with `enableTime, noCalendar,
dateFormat "H:i"`.

**Use it when.** Opening hours, appointment slot, shift start/end, reminder time; `data-time-inline`
for an always-visible clock on a scheduling card.

**Source.** `references/sources/pages/form-pickers.html` (card "Flatpickr" > Timepicker); `app.js`.

**Markup.**

```html
<input type="text" class="form-input" data-provider="timepickr" data-time-basic="true" placeholder="Select Time" />
<input type="text" class="form-input" data-provider="timepickr" data-time-hrs="true" placeholder="Select Time" />
<input type="text" class="form-input" data-provider="timepickr" data-min-time="13:00" data-max-time="16:00" />
<input type="text" class="form-input" data-provider="timepickr" data-default-time="16:45" />
<input type="text" class="form-input" data-provider="timepickr" data-time-inline="11:42" />
```

**Init / JS.**

```js
// app.js — "timepickr" branch
let o = { enableTime: true, noCalendar: true, dateFormat: "H:i", defaultDate: new Date() };
if (a["data-time-hrs"])      o.time_24hr = true;
if (a["data-min-time"])      o.minTime = a["data-min-time"].value;
if (a["data-max-time"])      o.maxTime = a["data-max-time"].value;
if (a["data-default-time"])  o.defaultDate = a["data-default-time"].value;
if (a["data-time-inline"])   { o.inline = true; o.defaultDate = a["data-time-inline"].value; }
flatpickr(el, o);
```

**Gotchas.** `data-time-basic` is not read by the script (decorative). Default value is "now";
use `data-default-time` to preset.

## Date Range Picker (jQuery daterangepicker)

**What it is.** The jQuery `daterangepicker` plugin (needs moment.js), initialised by
`form-date-range-picker.js` on two hooks: `data-toggle="date-picker"` (single-date defaults, with
dropdown month/year) and `data-toggle="date-picker-range"` (range with preset list, writes the
selection into a display element).

**Use it when.**
- Dashboard / report date-range filter with "Today / Yesterday / Last 7 Days / Last 30 Days / This
  Month / Last Month" presets (`date-picker-range`, the "Predefined Date Ranges" demo).
- Booking with start and end *times* (`data-time-picker="true"`).
- Birthday or single date with fast year navigation (`data-single-date-picker="true"` +
  `showDropdowns`).
- If the page has no jQuery, use `data-provider="flatpickr" data-range-date` instead.

**Source.** `references/sources/pages/form-pickers.html` (card "Date Range Picker");
`references/sources/assets/js/pages/form-date-range-picker.js`; plugins `jquery`, `moment`,
`daterangepicker`.

**Markup.**

```html
<!-- single date (defaults of data-toggle="date-picker") -->
<input type="text" class="form-input date" id="singledaterange" data-toggle="date-picker" data-cancel-class="btn-warning" />
<!-- with times; locale passed as single-quoted JSON -->
<input type="text" class="form-input date" id="daterangetime" data-toggle="date-picker" data-time-picker="true" data-locale="{'format': 'DD/MM hh:mm A'}" />
<!-- explicit single date picker -->
<input type="text" class="form-input date" id="birthdatepicker" data-toggle="date-picker" data-single-date-picker="true" />

<!-- predefined ranges: a div styled like an input, result written into #selectedValue -->
<div class="relative">
  <div id="reportrange" class="form-input flex! items-center" data-toggle="date-picker-range" data-target-display="#selectedValue" data-cancel-class="btn-light">
    <i class="iconify tabler--calendar me-2"></i><span id="selectedValue"></span>
    <i class="iconify tabler--chevron-down absolute end-0 top-1/2 me-1 -translate-1/2"></i>
  </div>
</div>
```

**Init / JS.**

```js
// assets/js/pages/form-date-range-picker.js (trimmed)
window.jQuery = window.$ = $;
if (jQuery().daterangepicker) {
  const start = moment().subtract(29, "days"), end = moment();
  const rangeDefaults = {
    startDate: start, endDate: end,
    ranges: {
      Today: [moment(), moment()],
      Yesterday: [moment().subtract(1, "days"), moment().subtract(1, "days")],
      "Last 7 Days": [moment().subtract(6, "days"), moment()],
      "Last 30 Days": [moment().subtract(29, "days"), moment()],
      "This Month": [moment().startOf("month"), moment().endOf("month")],
      "Last Month": [moment().subtract(1, "month").startOf("month"), moment().subtract(1, "month").endOf("month")],
    },
    locale: { format: "MM/DD/YYYY" },
    cancelButtonClasses: "bg-default-100 text-default-700",
    applyButtonClasses: "bg-success text-white",
  };
  $('[data-toggle="date-picker-range"]').each(function () {
    const $el = $(this), opts = $.extend(true, {}, rangeDefaults, $el.data());
    const display = $el.attr("data-target-display");
    $el.daterangepicker(opts, (s, e) => { display && $(display).html(s.format("MMMM D, YYYY") + " - " + e.format("MMMM D, YYYY")); });
    display && $(display).html(start.format("MMMM D, YYYY") + " - " + end.format("MMMM D, YYYY"));
  });

  const singleDefaults = { singleDatePicker: true, showDropdowns: true, locale: { format: "MM/DD/YYYY" },
    cancelButtonClasses: "bg-default-100 text-default-700", applyButtonClasses: "bg-success text-white" };
  $('[data-toggle="date-picker"]').each(function () {
    const $el = $(this), opts = $.extend(true, {}, singleDefaults, $el.data());
    if (typeof opts.locale === "string") opts.locale = JSON.parse(opts.locale.replace(/'/g, '"'));
    $el.daterangepicker(opts);
  });
}
```

**Gotchas.**
- Every `data-*` on the element is merged into the options via jQuery `.data()` (camelCased):
  `data-time-picker="true"` -> `timePicker: true`, `data-single-date-picker` -> `singleDatePicker`,
  `data-auto-apply`, `data-max-span` etc. all work the same way.
- `data-toggle="date-picker"` defaults to **`singleDatePicker: true`**. The demo labelled "Date
  Range" is therefore a single-date picker; for a true range add `data-single-date-picker="false"`.
- `data-locale` must be JSON with single quotes (the script swaps them to double quotes).
- `data-cancel-class` is passed through as `cancelClass`, but the script already sets
  `cancelButtonClasses` / `applyButtonClasses` (Tailwind tokens), which is what styles the buttons.
- Requires jQuery + moment before `daterangepicker.js`; keep that order (see page script list).

## Pickr colour picker

**What it is.** Pickr (`Pickr.create({ el, ...opts })`) attached to empty `<div>`s by class via the
`initPickr(selector, opts)` helper in `form-colorpickr.js`. Themes `classic`, `monolith`, `nano`;
default colours pulled from CSS tokens with the `theme("primary")` helper exported by `app.js`.

**Use it when.** Brand/theme colour in settings, tag or label colour, calendar category colour,
chart series colour. For a basic native swatch use `<input type="color">` (see Input types).

**Source.** `references/sources/pages/form-pickers.html` (card "Colorpicker");
`references/sources/assets/js/pages/form-colorpickr.js`; plugin `pickr/pickr.min.js`.

**Markup.**

```html
<div class="classic-colorpicker"></div>   <!-- theme classic, full interaction -->
<div class="monolith-colorpicker"></div>  <!-- theme monolith, HEXA, input/clear/save -->
<div class="nano-colorpicker"></div>      <!-- theme nano -->
<div class="colorpicker-demo"></div>      <!-- monolith, preview + clear/save only -->
<div class="colorpicker-opacity-hue"></div>
<div class="colorpicker-switch"></div>
<div class="colorpicker-input"></div>
<div class="colorpicker-format"></div>    <!-- hex / rgba / hsva switcher -->
```

**Init / JS.**

```js
// assets/js/pages/form-colorpickr.js (trimmed)
function initPickr(selector, opts = {}) {
  document.querySelectorAll(selector).forEach(el => { Pickr.create({ el, ...opts }) || console.warn("Pickr not initialized for: " + selector); });
}
const swatches = ["rgba(244, 67, 54, 1)", "rgba(233, 30, 99, 0.95)", "rgba(156, 39, 176, 0.9)", "rgba(103, 58, 183, 0.85)", "rgba(63, 81, 181, 0.8)", "rgba(33, 150, 243, 0.75)", "rgba(3, 169, 244, 0.7)"];

initPickr(".classic-colorpicker", { theme: "classic", default: theme("primary"), swatches: [/* 14 rgba swatches */],
  components: { preview: true, opacity: true, hue: true, interaction: { hex: true, rgba: true, hsva: true, input: true, clear: true, save: true } } });
initPickr(".monolith-colorpicker", { theme: "monolith", default: theme("danger"), swatches, defaultRepresentation: "HEXA",
  components: { preview: true, opacity: true, hue: true, interaction: { hex: false, rgba: false, hsva: false, input: true, clear: true, save: true } } });
initPickr(".nano-colorpicker",     { theme: "nano", default: theme("info"), swatches, defaultRepresentation: "HEXA", components: { /* same as monolith */ } });
initPickr(".colorpicker-demo",     { theme: "monolith", default: theme("primary"), components: { preview: true, interaction: { clear: true, save: true } } });
initPickr(".colorpicker-opacity-hue", { theme: "monolith", default: theme("danger"), components: { preview: true, opacity: true, hue: true, interaction: { clear: true, save: true } } });
initPickr(".colorpicker-switch",   { theme: "monolith", default: theme("gamma"), swatches, components: { preview: true, opacity: true, hue: true, interaction: { clear: true, save: true } } });
initPickr(".colorpicker-input",    { theme: "monolith", default: "#f7b84b", swatches, components: { preview: true, opacity: true, hue: true, interaction: { input: true, clear: true, save: true } } });
initPickr(".colorpicker-format",   { theme: "monolith", default: "#f06548", swatches, components: { preview: true, opacity: true, hue: true, interaction: { hex: true, rgba: true, hsva: true, input: true, clear: true, save: true } } });
```

**Gotchas.**
- `theme(name)` (defined at the bottom of `app.js`) reads `--color-<name>` from `:root`; `theme("gamma")`
  in the switch demo resolves to an empty string unless you define `--color-gamma`. Use a real token.
- Pickr renders into a fixed `.pcr-app` popover (z-index 10000) re-skinned with `bg-card` /
  `border-default-300`; it works in dark mode. The trigger is the `.pcr-button` injected into your div.
- To read the value: `const p = Pickr.create(...)`, then `p.on("save", c => c.toHEXA().toString())`.
  `initPickr` discards the instance, so write your own call when you need events.

## Choices.js select (`data-choices`)

**What it is.** Choices.js (bundled in `vendors.min.js`) initialised by `form-choice.js` on every
`[data-choices]`; attribute flags map to Choices options. Works on `<select>` (single / multiple /
optgroup) and on `<input type="text">` (tag input, comma-delimited).

**Use it when.**
- Country / state / category pickers with groups; multi-select of tags, roles, categories
  (`multiple` + `data-choices-removeItem`); free-text tag entry (skills, recipient emails) with a
  maximum count (`data-choices-limit`) or uniqueness (`data-choices-text-unique-true`).
- Pick this over Select2 when the page has no jQuery (most of the template).

**Source.** `references/sources/pages/form-select.html` (card "Choices.Js");
`references/sources/assets/js/pages/form-choice.js`.

**Markup.**

```html
<!-- single, default -->
<select class="form-input" data-choices name="choices-single-default" id="choices-single-default">
  <option value="">This is a placeholder</option><option value="Choice 1">Choice 1</option><option value="Choice 2">Choice 2</option>
</select>

<!-- single with option groups -->
<select class="form-input" id="choices-single-groups" data-choices data-choices-groups data-placeholder="Select City">
  <option value="">Choose a city</option>
  <optgroup label="UK"><option value="London">London</option><option value="Manchester">Manchester</option></optgroup>
  <optgroup label="DE" disabled><option value="Hamburg">Hamburg</option></optgroup>
</select>

<!-- single, no search, removable -->
<select class="form-input" data-choices data-choices-search-false data-choices-removeItem><option value="Zero">Zero</option><option value="One">One</option></select>
<!-- keep source order -->
<select class="form-input" data-choices data-choices-sorting-false><option value="Madrid">Madrid</option><option value="Toronto">Toronto</option></select>

<!-- multiple -->
<select class="form-input" data-choices multiple><option value="Choice 1" selected>Choice 1</option><option value="Choice 2">Choice 2</option><option value="Choice 4" disabled>Choice 4</option></select>
<!-- multiple with remove button -->
<select class="form-input" data-choices data-choices-removeItem multiple>…</select>
<!-- multiple with groups -->
<select class="form-input" data-choices data-choices-multiple-groups="true" multiple><option value="">Choose a city</option><optgroup label="UK">…</optgroup></select>

<!-- tag inputs -->
<input class="form-input" data-choices data-choices-limit="3" data-choices-removeItem type="text" value="Task-1" />
<input class="form-input" data-choices data-choices-text-unique-true type="text" value="Project-A, Project-B" />
<input class="form-input" data-choices data-choices-text-disabled-true type="text" value="josh@joshuajohnson.co.uk, joe@bloggs.co.uk" />
```

**Init / JS.**

```js
// assets/js/pages/form-choice.js (trimmed)
document.querySelectorAll("[data-choices]").forEach(el => {
  const cfg = {
    placeholderValue: el.hasAttribute("data-choices-groups") ? "This is a placeholder set in the config" : undefined,
    searchEnabled:    el.hasAttribute("data-choices-search-true"),
    removeItemButton: el.hasAttribute("data-choices-removeItem") || el.hasAttribute("data-choices-multiple-remove"),
    shouldSort:      !el.hasAttribute("data-choices-sorting-false"),
    maxItemCount:     el.getAttribute("data-choices-limit") || undefined,
    duplicateItemsAllowed: !el.hasAttribute("data-choices-text-unique-true"),
    addItems:        !el.hasAttribute("data-choices-text-disabled-true"),
  };
  const inst = new Choices(el, cfg);
  if (el.hasAttribute("data-choices-text-disabled-true")) inst.disable();
});
```

| Attribute | Choices option |
|---|---|
| `data-choices` | hook (required) |
| `data-choices-search-true` | `searchEnabled: true` — **search is off unless this is present**; `data-choices-search-false` is a no-op |
| `data-choices-removeItem` or `data-choices-multiple-remove` | `removeItemButton: true` |
| `data-choices-sorting-false` | `shouldSort: false` |
| `data-choices-limit="3"` | `maxItemCount: 3` |
| `data-choices-text-unique-true` | `duplicateItemsAllowed: false` |
| `data-choices-text-disabled-true` | `addItems: false` + `instance.disable()` |
| `data-choices-groups` | only sets a placeholder string; optgroups work without it |
| `data-choices-multiple-groups`, `data-placeholder` | not read by the script (Choices takes the placeholder from the first empty `<option value="">`) |

**Gotchas.**
- The compiled CSS re-themes `.choices` (`bg-card`, `border-default-300`, dropdown with
  `DropDownSlideUp` animation, max-height 300px) and adds a `.is-invalid .choices__inner` red border.
- `.choices` has `margin-bottom: 24px` by default from the library CSS; wrap in a grid cell or reset
  with `[&_.choices]:mb-0` if it misaligns with siblings.
- The script keeps no reference; for programmatic `setChoices()` / remote data, create the instance
  yourself and drop `data-choices` to avoid double init.

## Select2 (jQuery)

**What it is.** Select2 initialised with zero options on `[data-toggle="select2"]`. The page loads
`jquery.min.js` and `select2.min.js` from `assets/plugins/` first.

**Use it when.** You already depend on jQuery (legacy admin), need Select2's AJAX / infinite scroll
adapters, or are porting an older INSPINIA (Bootstrap) screen. Otherwise prefer Choices.js.

**Source.** `references/sources/pages/form-select.html` (card "Select2");
`references/sources/assets/js/pages/form-select2.js`.

**Markup.**

```html
<select id="select2BasicExample" class="form-select select2" data-toggle="select2">
  <option value="AK">Alaska</option><option value="HI">Hawaii</option>
</select>

<select class="form-select select2" data-toggle="select2">
  <option>Select</option>
  <optgroup label="Alaskan/Hawaiian Time Zone"><option value="AK">Alaska</option><option value="HI">Hawaii</option></optgroup>
  <optgroup label="Pacific Time Zone"><option value="CA">California</option></optgroup>
</select>

<select class="select2 form-select select2-multiple" data-toggle="select2" multiple="multiple" data-placeholder="Choose ...">
  <optgroup label="Pacific Time Zone"><option value="CA">California</option><option value="NV">Nevada</option></optgroup>
</select>
```

**Init / JS.**

```js
// assets/js/pages/form-select2.js — the entire file
jQuery().select2 && $('[data-toggle="select2"]').select2();
```

**Gotchas.**
- Options are not read from `data-*` by the script, but Select2 itself honours `data-placeholder`
  (multiple) and any `data-*` matching its option names.
- Script order on the page: `vendors.min.js`, `app.js`, `plugins/jquery/jquery.min.js`,
  `plugins/select2/select2.min.js`, then the page script. jQuery must precede select2.
- `.select2-container` default skin is compiled into `app.min.css` (white/#aaa borders); it is less
  thoroughly re-themed than Choices, so check it in `[data-theme=dark]`.

## Client-side validation (custom styles)

**What it is.** A ~1 KB vanilla script (`form-validation.js`) that intercepts submit on
`#tailwindValidationForm`, runs HTML5 `checkValidity()` on every `.input-field`, toggles
`!border-success` / `!border-danger` on the field, shows the sibling `.valid-icon` / `.invalid-icon`
and the `.valid-msg` / `.invalid-msg` paragraphs, checks the `#terms` checkbox, and calls
`form.submit()` only when everything passes.

**Use it when.**
- Registration / profile / address forms that must show inline feedback before hitting the server.
- Pair with `required`, `type="email"`, `pattern`, `min`/`max` on the inputs; the browser's
  constraint API is the rule engine.
- For wizards use the stepper's per-step validation (next section); for server-side errors render
  the "Server-side" markup below.

**Source.** `references/sources/pages/form-validation.html`;
`references/sources/assets/js/pages/form-validation.js`.

**Markup.**

```html
<form id="tailwindValidationForm" class="grid md:grid-cols-12 grid-cols-1 gap-base" novalidate>
  <!-- repeat per field: wrapper > label + .relative(field + icons) + messages -->
  <div class="md:col-span-4">
    <label class="form-label">First Name</label>
    <div class="relative">
      <input type="text" id="firstName" value="John" required class="input-field form-input" />
      <i class="iconify tabler--check valid-icon absolute top-1/2 right-3 hidden -translate-y-1/2 text-success"></i>
      <i class="iconify tabler--alert-circle invalid-icon absolute top-1/2 right-3 hidden -translate-y-1/2 text-danger"></i>
    </div>
    <p class="valid-msg mt-1 hidden text-sm text-success">Looks great!</p>
    <p class="invalid-msg mt-1 hidden text-sm text-danger">Please provide your first name.</p>
  </div>

  <!-- input-group field -->
  <div class="md:col-span-4">
    <label class="form-label">Username</label>
    <div class="relative input-group"><span class="input-group-text">@</span>
      <input type="text" id="username" placeholder="johndoe123" required class="input-field form-input" />
      <i class="iconify tabler--check valid-icon absolute top-1/2 right-3 hidden -translate-y-1/2 text-success"></i>
      <i class="iconify tabler--alert-circle invalid-icon absolute top-1/2 right-3 hidden -translate-y-1/2 text-danger"></i>
    </div>
    <p class="invalid-msg mt-1 hidden text-sm text-danger">Please choose a valid username.</p>
  </div>

  <!-- select: icons sit at right-9 to clear the chevron -->
  <div class="md:col-span-3">
    <label class="form-label">State</label>
    <div class="relative">
      <select id="state" required class="input-field form-input"><option value="">Choose...</option><option>California</option></select>
      <i class="iconify tabler--check valid-icon absolute top-1/2 right-9 hidden -translate-y-1/2 text-success"></i>
      <i class="iconify tabler--alert-circle invalid-icon absolute top-1/2 right-9 hidden -translate-y-1/2 text-danger"></i>
    </div>
    <p class="invalid-msg mt-1 hidden text-sm text-danger">Please select your state.</p>
  </div>

  <!-- terms checkbox (handled separately by id) -->
  <div class="md:col-span-12">
    <div class="flex flex-wrap items-center"><input id="terms" type="checkbox" required class="form-checkbox" />
      <label for="terms" class="ms-2 text-sm text-default-700">I agree to the terms and conditions</label>
      <p class="invalid-msg mt-2 hidden w-full text-sm text-danger">You must agree before submitting.</p></div>
  </div>
  <div class="md:col-span-12"><button type="submit" class="btn bg-primary text-white hover:bg-primary-hover">Submit Form</button></div>
</form>
```

**Init / JS.**

```js
// assets/js/pages/form-validation.js (de-minified)
document.getElementById("tailwindValidationForm").addEventListener("submit", function (e) {
  e.preventDefault();
  let ok = true;
  this.querySelectorAll(".input-field").forEach(field => {
    const wrap = field.parentElement;
    const vIcon = wrap.querySelector(".valid-icon"), iIcon = wrap.querySelector(".invalid-icon");
    const vMsg = wrap.parentElement.querySelector(".valid-msg"), iMsg = wrap.parentElement.querySelector(".invalid-msg");
    if (field.checkValidity()) {
      field.classList.remove("!border-danger"); field.classList.add("!border-success");
      vIcon?.classList.remove("hidden"); iIcon?.classList.add("hidden"); iMsg?.classList.add("hidden"); vMsg?.classList.remove("hidden");
    } else {
      ok = false;
      field.classList.add("!border-danger"); field.classList.remove("!border-success");
      iIcon?.classList.remove("hidden"); vIcon?.classList.add("hidden"); iMsg?.classList.remove("hidden"); vMsg?.classList.add("hidden");
    }
  });
  const terms = document.getElementById("terms"), tMsg = terms.parentElement.querySelector(".invalid-msg");
  if (terms.checked) { tMsg.classList.add("hidden"); terms.classList.remove("!border-danger"); }
  else { ok = false; tMsg.classList.remove("hidden"); terms.classList.add("!border-danger"); }
  if (ok) this.submit();
});
```

**Server-side / supported elements / browser defaults** (same page, no JS):

```html
<!-- server-rendered state: fixed classes + message -->
<div class="relative"><input type="text" value="Mark" required class="form-input border-success!" />
  <div class="pointer-events-none absolute inset-y-0 end-0 flex items-center pe-3"><i class="iconify tabler--check text-success text-base"></i></div></div>
<p class="text-success mt-1 text-2xs">Looks good!</p>

<div class="relative"><input type="text" required placeholder="Enter city" class="form-input border-danger!" />
  <div class="pointer-events-none absolute inset-y-0 end-0 flex items-center pe-3"><span data-icon="info" class="text-danger text-base"></span></div></div>
<p class="text-danger mt-1 text-2xs">Please provide a valid city.</p>

<!-- invalid textarea / checkbox / radio / select / file -->
<textarea required class="form-textarea border-danger!"></textarea><p class="text-danger mt-1 text-2xs">Please enter a message in the textarea.</p>
<input type="checkbox" required class="form-checkbox checked:bg-danger! border-danger! mt-0.5" /><label class="text-danger">Check this checkbox</label>
<input type="radio" name="radio-stacked" required class="form-radio checked:bg-danger! border-danger!" />
<select required class="form-input border-success!">…</select>
<input type="file" required class="form-input block w-full text-sm" /><p class="text-danger mt-1 text-2xs">Example invalid form file feedback</p>
<button type="submit" disabled class="btn bg-primary hover:bg-primary-hover cursor-not-allowed text-white">Submit form</button>

<!-- browser defaults: no novalidate, let the UA show its bubbles -->
<form action=""><input type="text" class="form-input" required /> … <button class="btn bg-primary text-white hover:bg-primary-hover" type="submit">Submit form</button></form>
```

**Gotchas.**
- The DOM shape is load-bearing: field and its two icons share one parent (`.relative`), the
  messages are children of the grandparent. Keep the wrapper even when you have no icons.
- Only the form with id `tailwindValidationForm` and a checkbox with id `terms` are wired; copy the
  script and change selectors for a second form. The script throws if `#terms` is missing.
- Both `!border-danger` (used by JS) and `border-danger!` (used in markup) are compiled; mixing them
  is fine but `classList.remove` only removes the exact spelling.
- The form has `novalidate` so the browser bubbles don't fire; remove it to get the "Browser
  Defaults" behaviour.
- The "Server-side" demo uses `<span data-icon="info">` placeholders that render nothing; use
  `<i class="iconify tabler--info-circle">` as on form-elements.

## Form wizard (Preline `hs-stepper`)

**What it is.** Preline's `HSStepper`: a root `[data-hs-stepper]`, a `<ul>` of
`[data-hs-stepper-nav-item='{"index": N}']`, matching `[data-hs-stepper-content-item='{"index": N}']`
panels (all but the first `style="display: none"`), and `[data-hs-stepper-back-btn]` /
`[data-hs-stepper-next-btn]` buttons. `form-wizard.js` adds per-step validation (linear mode) and a
progress bar.

**Use it when.**
- Multi-step onboarding / sign-up, checkout (shipping -> payment -> review; the template's own
  apps-ecommerce-checkout uses it), student/employee enrolment, store setup
  (apps-ecommerce-settings), import wizard.
- Horizontal nav for 3-6 short steps; vertical layout when step titles are long or there are many steps.
- Not for simple tabbed content: use `hs-tab`.

**Source.** `references/sources/pages/form-wizard.html`;
`references/sources/assets/js/pages/form-wizard.js` (loaded as `type="module"`).

**Markup.**

```html
<!-- Basic (horizontal) -->
<div data-hs-stepper="">
  <ul class="relative flex flex-wrap gap-1.25">
    <!-- repeat per step; first has class "active" -->
    <li class="group active items-center gap-x-2" data-hs-stepper-nav-item='{"index": 1}'>
      <span class="group inline-flex items-center align-middle text-xs focus:outline-hidden disabled:pointer-events-none disabled:opacity-50">
        <span class="border-default-300 hs-stepper-active:bg-default-50 hs-stepper-active:text-default-700 hs-stepper-success:bg-success/10 hs-stepper-success:border-success hs-stepper-success:text-success flex shrink-0 items-center justify-center gap-3 rounded border border-dashed px-4 py-2 font-medium">
          <i class="iconify tabler--user-circle size-8"></i>
          <div><span class="block text-sm font-semibold">Student Info</span><span class="text-2xs">Personal details</span></div>
        </span>
      </span>
    </li>
    <li class="group items-center gap-x-2" data-hs-stepper-nav-item='{"index": 2}'> <!-- same inner, tabler--map-pin --> </li>
    <!-- demo icons: tabler--user-circle, tabler--map-pin, tabler--book, tabler--users, tabler--folder-open -->
  </ul>
  <div class="pt-6">
    <div data-hs-stepper-content-item='{"index": 1}'>
      <div class="grid md:grid-cols-2 gap-base pb-base">
        <div><label class="form-label">Full Name</label><input type="text" class="form-input" placeholder="Enter your full name" /></div>
        <div><label class="form-label">Email</label><input type="email" class="form-input" placeholder="Enter your email" /></div>
      </div>
    </div>
    <div data-hs-stepper-content-item='{"index": 2}' style="display: none"> … </div>
    <div class="mt-5 flex flex-wrap items-center justify-between gap-2">
      <button type="button" class="btn bg-secondary w-full text-white md:w-auto" data-hs-stepper-back-btn="">← Back</button>
      <button type="button" class="btn bg-primary w-full text-white md:w-auto" data-hs-stepper-next-btn="">Next →</button>
    </div>
  </div>
</div>

<!-- Validation support: linear mode + id, inputs carry required -->
<div id="hs-stepper-validation" data-hs-stepper='{"mode": "linear"}'> … <input type="email" class="form-input" required /> … </div>

<!-- Progressbar support: id + a bar element above the nav -->
<div id="hs-stepper-progress" data-hs-stepper="">
  <div class="mb-5">
    <div class="flex h-1.5 w-full overflow-hidden rounded-full bg-default-200 dark:bg-default-100">
      <div class="hs-stepper-progress-bar bg-primary flex flex-col justify-center overflow-hidden whitespace-nowrap text-center text-xs text-white transition duration-500" style="width: 0%"></div>
    </div>
  </div>
  <ul class="relative flex flex-wrap gap-1.25"> … </ul>
  <div class="pt-6"> … buttons: "← Back: Course Info" / "Next: Documents info →" … </div>
</div>

<!-- Vertical: nav column + content column -->
<div data-hs-stepper="">
  <div class="grid grid-cols-1 md:grid-cols-3 gap-base">
    <div>
      <ul class="relative flex flex-col gap-1.25">
        <li class="group active flex w-full flex-1 shrink basis-0 items-center gap-x-2" data-hs-stepper-nav-item='{"index": 1}'>
          <span class="group inline-flex w-full items-center align-middle text-xs focus:outline-hidden disabled:pointer-events-none disabled:opacity-50">
            <span class="hs-stepper-active:bg-default-50 hs-stepper-active:text-default-700 hs-stepper-success:bg-success/10 hs-stepper-success:border-success hs-stepper-success:text-success hs-stepper-success:border-s-3 flex w-full shrink-0 items-center gap-2 rounded px-4 py-3 font-medium">
              <i class="iconify tabler--user-circle size-8"></i>
              <div><span class="block text-sm font-semibold">Student Info</span><span class="text-2xs">Personal details</span></div>
            </span></span></li>
      </ul>
    </div>
    <div class="border-default-300 col-span-1 rounded border border-dashed p-7.5 md:col-span-2">
      <div> <div data-hs-stepper-content-item='{"index": 1}'>…</div> … buttons … </div>
    </div>
  </div>
</div>
```

**Init / JS.**

```js
// assets/js/pages/form-wizard.js (de-minified, trimmed)
window.$hsTabsCollection = window.$hsTabsCollection || [];
window.$hsStepperCollection = window.$hsStepperCollection || [];
document.addEventListener("DOMContentLoaded", () => {
  HSTabs.autoInit(); HSStepper.autoInit();

  // --- per-step validation (linear mode) ---
  const root = document.querySelector("#hs-stepper-validation");
  const st = root && HSStepper.getInstance(root);
  if (st) {
    const validate = () => {
      const idx = st.currentIndex;
      const panel = root.querySelector(`[data-hs-stepper-content-item*='"index": ${idx}']`);
      if (!panel) return true;
      let ok = true;
      panel.querySelectorAll("input, select, textarea").forEach(f => {
        f.classList.remove("is-invalid", "is-valid");
        f.checkValidity() ? f.classList.add("is-valid") : (f.classList.add("is-invalid"), ok = false);
      });
      const nav = st.getNavItem(idx);
      if (ok) { nav && (nav.isProcessed = false); root.querySelector(`[data-hs-stepper-nav-item*='"index": ${idx}']`)?.classList.remove("error", "hs-stepper-error"); }
      else    { nav && (nav.isProcessed = true); st.setErrorNavItem(idx); }
      return ok;
    };
    st.on("beforeNext", i => { const ok = validate(); const n = st.getNavItem(i); n && (n.isProcessed = !ok); });
    root.querySelectorAll("[data-hs-stepper-nav-item]").forEach(li => li.addEventListener("click", e => {
      const { index } = JSON.parse(li.getAttribute("data-hs-stepper-nav-item"));
      if (index > st.currentIndex && !validate()) { e.preventDefault(); e.stopImmediatePropagation(); return false; }
    }, true));
    root.addEventListener("input", () => { st.enableButtons(); const n = st.getNavItem(st.currentIndex); n && n.isProcessed && (n.isProcessed = false); });
    st.on("back", i => { const n = st.getNavItem(i); n && (n.isProcessed = false); root.querySelector(`[data-hs-stepper-nav-item*='"index": ${i}']`)?.classList.remove("error", "hs-stepper-error"); });
  }

  // --- progress bar ---
  const pr = document.querySelector("#hs-stepper-progress");
  const ps = pr && HSStepper.getInstance(pr);
  if (ps) {
    const bar = pr.querySelector(".hs-stepper-progress-bar"), total = ps.totalSteps;
    const set = i => { bar && (bar.style.width = (i / total) * 100 + "%"); };
    ps.on("active", set); set(ps.currentIndex);
  }
});
```

**Gotchas.**
- The index JSON must be spelled exactly `{"index": 1}` with the space: the validation script
  matches with `*='"index": 1'` substring selectors.
- Only `hs-stepper-active:` and `hs-stepper-success:` variants are compiled in this build. The
  script adds `error` / `hs-stepper-error` classes but no CSS targets them: invalid steps show
  through the red `is-invalid` field borders (`.is-invalid { border-color: var(--color-danger) !important }`).
  Add your own `.hs-stepper-error` rule if the nav item itself must turn red.
- `is-valid` / `is-invalid` are template classes (green/red border) usable anywhere, not only in the wizard.
- The script is an ES module (`type="module"`) and calls `HSStepper.autoInit()` itself; if you render
  a wizard dynamically, call `HSStepper.autoInit()` (or `window.HSStaticMethods.autoInit()`) again and
  re-attach the listeners.
- There is no finish button in the demo; the last "Next" simply does nothing. Preline supports
  `data-hs-stepper-finish-btn` / `data-hs-stepper-complete-step-btn` (not exercised on this page).

## Dropzone upload

**What it is.** Dropzone.js attached to any `form[data-plugin="dropzone"]` by `form-fileupload.js`:
`url` from the form's `action` (fallback `/`), `acceptedFiles: "image/*"`, previews rendered into
`data-previews-container` with the HTML of `data-upload-preview-template`. `Dropzone.autoDiscover`
is turned off.

**Use it when.**
- Product gallery upload (apps-ecommerce-product-add uses the same hook), bulk media import, drag
  and drop a batch of screenshots to a ticket.
- Use FilePond instead when you need per-file size limits, reordering or a single avatar.

**Source.** `references/sources/pages/form-fileuploads.html` (card "Dropzone");
`references/sources/assets/js/pages/form-fileupload.js`; plugin `dropzone/dropzone-min.js`.

**Markup.**

```html
<form action="/" method="post" class="min-h-37.5 border-2 border-default-300 border-dashed rounded-lg p-5"
      id="myAwesomeDropzone" data-plugin="dropzone" data-previews-container="#file-previews" data-upload-preview-template="#uploadPreviewTemplate">
  <div class="dz-message needsclick text-center my-8">
    <div class="size-11 mx-auto mb-base"><span class="btn btn-icon size-11 bg-info/15 text-info rounded-full"><i class="iconify tabler--cloud-upload text-2xl"></i></span></div>
    <h4 class="text-lg mb-3">Drop files here or click to upload.</h4>
    <p class="text-default-400 italic mb-5 text-center">You can drag images here, or browse files via the button below.</p>
    <div class="flex justify-center"><button type="button" class="btn btn-sm shadow border border-default-300">Browse Images</button></div>
  </div>
</form>
<div class="dropzone-previews mt-5" id="file-previews"></div>

<!-- preview template (hidden); Dropzone fills data-dz-* -->
<div class="hidden" id="uploadPreviewTemplate">
  <div class="card mt-1 border border-dashed border-default-300">
    <div class="p-3"><div class="flex items-center">
      <div class="px-3"><img data-dz-thumbnail src="#" class="size-8 rounded bg-light" alt="" /></div>
      <div><a href="javascript:void(0);" class="font-semibold text-primary" data-dz-name></a><p class="text-default-400" data-dz-size></p></div>
      <div class="ms-auto"><a href="#" class="btn btn-sm text-danger" data-dz-remove><i class="iconify tabler--x size-5 dropzone-close"></i></a></div>
    </div></div>
  </div>
</div>
```

**Init / JS.**

```js
// assets/js/pages/form-fileupload.js — Dropzone part
Dropzone.autoDiscover = false;
document.querySelectorAll('[data-plugin="dropzone"]').forEach(el => {
  const opts = { url: el.getAttribute("action") || "/", acceptedFiles: "image/*" };
  if (el.dataset.previewsContainer) opts.previewsContainer = el.dataset.previewsContainer;
  const tpl = el.dataset.uploadPreviewTemplate && document.querySelector(el.dataset.uploadPreviewTemplate);
  if (tpl) opts.previewTemplate = tpl.innerHTML;
  new Dropzone(el, opts);
});
```

**Gotchas.**
- The form does not carry the `dropzone` class; Dropzone adds it (and the compiled `.dropzone`
  skin) on init. The dashed border and padding come from the Tailwind classes on the form.
- `acceptedFiles` is hard-coded to images; copy the init and change it for documents.
- Without `data-previews-container` previews render inside the form; the demo keeps them in a
  separate list so the drop area stays clean.
- `data-dz-thumbnail`, `data-dz-name`, `data-dz-size`, `data-dz-remove` are the Dropzone template
  hooks; keep them when restyling the card.

## FilePond upload (multi-file and profile picture)

**What it is.** FilePond with four plugins registered (ImagePreview, ImageExifOrientation,
FileValidateSize, FileEncode). `input.filepond-input-multiple` gets a default `FilePond.create(el)`
(limits come from the input's own `data-*`); `input.filepond-input-circle` gets a compact circular
avatar variant. `.filepond-uploader.two-grid` / `.three-grid` lay items out in 2 / 3 columns.

**Use it when.**
- Attachments on a ticket/comment (basic), image gallery with reorder (`two-grid`/`three-grid`),
  avatar on a profile page (circle), company logo (rounded square).
- FileEncode means files are base64-encoded into a hidden input, so a normal form POST works
  without a `server` endpoint (fine for small files; set `server` for real uploads).

**Source.** `references/sources/pages/form-fileuploads.html` (cards "Filepond", "Profile Picture");
`references/sources/assets/js/pages/form-fileupload.js`; plugins `filepond/filepond.min.js`,
`filepond-plugin-image-preview`, `filepond-plugin-file-validate-size`,
`filepond-plugin-image-exif-orientation`, `filepond-plugin-file-encode`.

**Markup.**

```html
<!-- basic / 2-grid / 3-grid: same input, different wrapper class -->
<div class="filepond-uploader">
  <input type="file" class="filepond filepond-input-multiple" multiple name="filepond" data-allow-reorder="true" data-max-file-size="3MB" data-max-files="5" />
</div>
<div class="filepond-uploader two-grid"> <input type="file" class="filepond filepond-input-multiple" multiple name="filepond" data-allow-reorder="true" data-max-file-size="3MB" data-max-files="5" /> </div>
<div class="filepond-uploader three-grid"> <!-- same input --> </div>

<!-- profile picture: circle and rounded square -->
<div class="grid grid-cols-2 gap-base">
  <div class="col-span-1"><div class="size-19.5"><input type="file" class="filepond filepond-input-circle rounded-full!" name="filepond" accept="image/png, image/jpeg, image/gif" /></div></div>
  <div class="col-span-1"><div class="size-19.5"><input type="file" class="filepond filepond-input-circle rounded!" name="filepond" accept="image/png, image/jpeg, image/gif" /></div></div>
</div>
```

**Init / JS.**

```js
// assets/js/pages/form-fileupload.js — FilePond part
FilePond.registerPlugin(FilePondPluginImagePreview, FilePondPluginImageExifOrientation, FilePondPluginFileValidateSize, FilePondPluginFileEncode);
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("input.filepond-input-multiple").forEach(el => FilePond.create(el));
  document.querySelectorAll("input.filepond-input-circle").forEach(el => FilePond.create(el, {
    imageCropAspectRatio: "1:1", imageResizeTargetWidth: 200, imageResizeTargetHeight: 200,
    stylePanelLayout: "compact circle",
    styleLoadIndicatorPosition: "center bottom", styleProgressIndicatorPosition: "right bottom",
    styleButtonRemoveItemPosition: "left bottom", styleButtonProcessItemPosition: "right bottom",
    allowImagePreview: true, imagePreviewHeight: 100,
    labelIdle: '<svg … class="text-default-400">…camera icon…</svg>',   // inline Tabler camera SVG
  }));
});
```

**Gotchas.**
- `data-allow-reorder`, `data-max-file-size`, `data-max-files` are read natively by FilePond from
  the input; `accept` on the avatar input restricts types. Size validation only works because the
  FileValidateSize plugin is registered.
- The template skin: `.filepond--root` gets a dashed `default-300` border, `.filepond--panel-root`
  is `bg-card`, item panels are `bg-primary`. `two-grid`/`three-grid` only set `.filepond--item` widths.
- The circle variant needs a sized wrapper (`size-19.5`); `rounded-full!` vs `rounded!` on the input
  selects circle vs square (FilePond copies the class to its root).
- `imageCropAspectRatio` / `imageResizeTarget*` are options of the ImageCrop / ImageResize plugins,
  which are **not** loaded on this page; they are harmless but inert unless you add those plugins.

## Quill rich-text editor (snow and bubble)

**What it is.** Quill 2.0.3. `form-quilljs.js` first swaps every toolbar icon for an inline Tabler
SVG via `Quill.import("ui/icons")`, then creates a snow editor on `#snow-editor` with a full toolbar
and a bubble (inline tooltip) editor on `#bubble-editor`. The div's inner HTML is the initial content.

**Use it when.**
- Blog/article body (apps-blog-add reuses this exact script), product description
  (apps-ecommerce-product-add), email composer, CMS page content: `snow`.
- Comment box, note field, inline description editing where a permanent toolbar is noise: `bubble`.

**Source.** `references/sources/pages/form-text-editors.html`;
`references/sources/assets/js/pages/form-quilljs.js`; plugin `quill/quill.js`.

**Markup.**

```html
<div id="snow-editor" style="height: 300px">
  <h3>A powerful and responsive admin dashboard template built on Tailwind.</h3>
  <p><br /></p>
  <ul><li>Fully responsive layout with a sleek and modern design.</li></ul>
</div>

<div id="bubble-editor" style="height: 300px">
  <h3>…</h3><p>…</p>
</div>
```

**Init / JS.**

```js
// assets/js/pages/form-quilljs.js (trimmed)
if (typeof Quill !== "undefined") {
  const icons = Quill.import("ui/icons");
  icons.bold = '<svg … icon-tabler-bold …>'; icons.italic = '…'; icons.underline = '…'; icons.strike = '…';
  icons.list.ordered = '…'; icons.bullet = '…'; icons.indent["+1"] = '…'; icons.indent["-1"] = '…';
  icons.link = '…'; icons.image = '…'; icons.video = '…'; icons["code-block"] = '…'; icons.clean = '…';
  icons.color = '…'; icons.background = '…'; icons.script.super = '…'; icons.script.sub = '…';
  icons.blockquote = '…'; icons.align[""] = '…'; icons.align.center = '…'; icons.align.right = '…'; icons.align.justify = '…';
  icons.header[1] = '…'; icons.header[2] = '…'; icons.header[3] = '…'; icons.header[""] = '…';

  const snow = document.getElementById("snow-editor");
  snow && new Quill(snow, {
    theme: "snow",
    modules: { toolbar: [
      [{ font: [] }],
      ["bold", "italic", "underline", "strike"],
      [{ color: [] }, { background: [] }],
      [{ script: "super" }, { script: "sub" }],
      [{ header: [false, 1, 2, 3, 4, 5, 6] }],
      ["blockquote", "code-block"],
      [{ list: "ordered" }, { list: "bullet" }, { indent: "-1" }, { indent: "+1" }],
      [{ align: [] }],
      ["link", "image", "video"],
      ["clean"],
    ] },
  });
  document.getElementById("bubble-editor") && new Quill("#bubble-editor", { theme: "bubble" });
}
```

**Gotchas.**
- Set an explicit height on the editor div (`style="height: 300px"`); the compiled
  `.ql-container.ql-snow` also has `min-block-size: 12rem`, `border-default-300`, rounded bottom
  corners, and `.ql-editor` uses `--font-body` with loose line-height.
- To submit the content, read `quill.root.innerHTML` (or `quill.getSemanticHTML()`) into a hidden
  input on submit; the div is not a form control.
- `.email-editor` is a compiled modifier that removes the toolbar/container radius and keeps only a
  bottom border (used by the mail composer).
- The icon override is global: do it once per page before creating any editor.

## noUiSlider range slider

**What it is.** noUiSlider wired by `form-range-slider.js`. A declarative group
(`[data-slider="default"]` + `data-value`, single handle 0-255, `connect: "lower"`) styled by
`data-slider-size`, `data-slider-style`, `data-slider-color`; plus id-based advanced examples
(dual handle, non-linear, locked pair, merged tooltips, soft limits, vertical). wNumb is loaded for
number formatting but the demo script does not call it.

**Use it when.**
- Price / weight / discount range filters on a catalogue (`#rangeslider_multielement` dual handle).
- Budget selector with uneven steps (`#nonlinear`), threshold pair that must keep a fixed gap
  (`#slider1`/`#slider2` lock), volume/brightness (single `data-slider`), vertical level meters.
- For a plain accessible slider with no visuals, `<input type="range" class="form-range">` is enough.

**Source.** `references/sources/pages/form-range-slider.html`;
`references/sources/assets/js/pages/form-range-slider.js`; plugins `nouislider/nouislider.min.js`,
`wnumb/wNumb.min.js`.

**Markup.**

```html
<!-- declarative single sliders -->
<div data-slider="default" data-value="150"></div>
<div data-slider="default" data-slider-size="sm" data-value="180"></div>
<div data-slider="default" data-slider-size="lg" data-value="90" class="mt-7.5"></div>
<div data-slider="default" data-slider-style="line"></div>
<div data-slider="default" data-slider-style="line" data-slider-size="sm" data-value="180" class="mt-5"></div>
<div data-slider="default" data-slider-color="primary" data-value="240" class="mb-7.5"></div>
<div data-slider="default" data-slider-color="info" data-slider-style="line" data-value="125" class="mb-7.5"></div>

<!-- dual handle -->
<div id="rangeslider_multielement"></div>

<!-- non-linear with value readouts -->
<div id="nonlinear"></div>
<div class="flex justify-between mt-3"><div class="py-1 font-semibold" id="lower-value"></div><div class="py-1 font-semibold" id="upper-value"></div></div>

<!-- locked pair -->
<div id="slider1" class="slider mb-2"></div><span class="example-val block mb-2" id="slider1-span"></span>
<div id="slider2" class="slider mb-2"></div><span class="example-val block mb-2" id="slider2-span"></span>
<button id="lockbutton" class="btn btn-sm bg-primary text-white hover:bg-primary-hover">Lock</button>

<!-- merged tooltips / soft limits -->
<div class="slider mt-4" id="slider-merging-tooltips"></div>
<div class="slider mb-4" id="soft"></div>

<!-- vertical -->
<div class="flex gap-18 overflow-hidden p-5">
  <div id="slider-vertical"></div>
  <div id="slider-connect-upper" data-slider-color="warning" class="me-5"></div>
  <div id="slider-vertical-tooltip"></div>
</div>
```

**Init / JS.**

```js
// assets/js/pages/form-range-slider.js (trimmed)
function createSlider(el, opts, height) { if (el && typeof noUiSlider !== "undefined") { height && (el.style.height = height); noUiSlider.create(el, opts); } }
function createSliderGroup(sel, opts) { document.querySelectorAll(sel).forEach(el => createSlider(el, typeof opts === "function" ? opts(el) : opts)); }

createSliderGroup('[data-slider="default"]', el => ({ start: parseInt(el.getAttribute("data-value")) || 50, connect: "lower", range: { min: 0, max: 255 } }));
createSliderGroup("#rangeslider_multielement", { start: [20, 80], connect: true, range: { min: 0, max: 100 } });

// non-linear: percentage keys define the scale
createSlider(nonlinear, { connect: true, behaviour: "tap", start: [500, 4000], range: { min: [0], "10%": [500, 500], "50%": [4000, 1000], max: [10000] } });
nonlinear.noUiSlider.on("update", (values, h, u, t, positions) => { [lowerEl, upperEl][h].innerHTML = `${values[h]}, ${positions[h].toFixed(2)}%`; });

// locked pair: slide events cross-update when lockedState is true
createSlider(slider1, { start: 60, animate: false, range: { min: 50, max: 100 } });
createSlider(slider2, { start: 80, animate: false, range: { min: 50, max: 100 } });
slider1.noUiSlider.on("slide", (v, h) => crossUpdate(v[h], slider2)); // and vice versa; lockbutton toggles lockedState

// merged tooltips: tooltips closer than 5 units are joined with " - "
createSlider(merging, { start: [20, 75], connect: true, tooltips: [true, true], range: { min: 0, max: 100 } });
mergeTooltips(merging, 5, " - ");   // helper in the page script (RTL + vertical aware)

// soft limits: pips mark 20/80, value is clamped on change
createSlider(soft, { start: 50, range: { min: 0, max: 100 }, pips: { mode: "values", values: [20, 80], density: 4 } });
soft.noUiSlider.on("change", (v, h) => { v[h] < 20 ? soft.noUiSlider.set(20) : v[h] > 80 && soft.noUiSlider.set(80); });

// vertical (third arg sets element height)
createSliderGroup("#slider-vertical", { start: [40, 60], connect: true, behaviour: "drag", orientation: "vertical", range: { min: 0, max: 100 } });
createSlider(document.getElementById("slider-connect-upper"),   { start: 40, orientation: "vertical", behaviour: "drag", connect: "upper", range: { min: 0, max: 100 } }, "200px");
createSlider(document.getElementById("slider-vertical-tooltip"),{ start: 10, orientation: "vertical", behaviour: "drag", tooltips: true, range: { min: 0, max: 100 } }, "200px");
createSlider(document.getElementById("slider-vertical-limit"),  { start: [0, 40], orientation: "vertical", behaviour: "drag", limit: 60, connect: true, tooltips: true, range: { min: 0, max: 100 } }, "200px");
```

| Attribute | Effect (compiled CSS) |
|---|---|
| `data-slider-size="sm"` | track 4px, handle 16px |
| `data-slider-size="lg"` | track 12px, handle 24px |
| `data-slider-style="line"` | thin rectangular primary handle (width 8px; 6px with `sm`, 10px with `lg`) |
| `data-slider-color="primary|secondary|success|warning|danger"` | `.noUi-connect` background token. **Only these five have rules**; the demo's `info`, `purple`, `dark` fall back to the default (primary) connect colour |

**Gotchas.**
- `#slider-vertical` has no explicit height in the markup; the demo relies on noUiSlider's default
  vertical height. Pass the third `createSlider` argument (e.g. `"200px"`) as the other vertical
  examples do.
- `#slider-vertical-limit` is initialised in the script but has no element on the page (harmless).
- Default `.noUi-connect` is re-themed to `var(--color-primary)`; the target track keeps the
  library's light `#fafafa` background, so check contrast in dark mode.
- For formatted tooltips use the loaded wNumb: `tooltips: wNumb({ decimals: 0, prefix: "$" })`.

## Inputmask

**What it is.** `form-inputmask.js` finds `[data-toggle="input-mask"]`, converts the
`data-mask-format` string by replacing every `0` with Inputmask's digit token `9`, and calls
`new Inputmask(mask).mask(el)`.

**Use it when.** Phone numbers, dates/times typed by hand, ZIP/postal codes, tax ids (CPF/CNPJ),
IP addresses, card expiry — anywhere a fixed-shape string is typed. apps-ecommerce-checkout reuses
the same script for card fields.

**Source.** `references/sources/pages/form-other-plugin.html` (card "Form Inputmask");
`references/sources/assets/js/pages/form-inputmask.js`; plugin `inputmask/inputmask.min.js`.

**Markup.**

```html
<input type="text" class="form-input" data-toggle="input-mask" data-mask-format="00/00/0000" />
```

| Demo | `data-mask-format` |
|---|---|
| Date | `00/00/0000` |
| Hour | `00:00:00` |
| Date & Hour | `00/00/0000 00:00:00` |
| ZIP Code | `00000-000` |
| Crazy ZIP Code | `0-00-00-00` |
| Money | `000.000.000.000.000,00` (+ `data-reverse="true"`) |
| Money 2 | `#.##0,00` (+ `data-reverse="true"`) |
| Telephone | `0000-0000` |
| Telephone with Area Code | `(00) 0000-0000` |
| US Telephone | `(000) 000-0000` |
| São Paulo Cellphones | `(00) 00000-0000` |
| CPF | `000.000.000-00` (+ `data-reverse="true"`) |
| CNPJ | `00.000.000/0000-00` (+ `data-reverse="true"`) |
| IP Address | `099.099.099.099` (+ `data-reverse="true"`) |

**Init / JS.**

```js
// assets/js/pages/form-inputmask.js — the entire file
document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('[data-toggle="input-mask"]').forEach(el => {
    const mask = el.getAttribute("data-mask-format").replace(/0/g, "9");
    new Inputmask(mask).mask(el);
  });
});
```

**Gotchas.**
- `data-reverse="true"` is **not** read by the script (it is jQuery-Mask-Plugin vocabulary). The
  money masks therefore fill left-to-right; for real currency use Inputmask's `currency` alias
  manually: `new Inputmask("currency", { prefix: "$ " }).mask(el)`.
- `9` already in a format (IP address `099`) stays `9`; `#` is passed through literally.
- Masked inputs keep the literals in `value`; strip them server-side or use
  `Inputmask.unmask(value, { mask })`.

## Typeahead / Bloodhound autocomplete

**What it is.** twitter typeahead.js (jQuery) with the Bloodhound suggestion engine, six variants
selected by class in `form-typehead.js`. Handlebars is loaded on the page but the demo templates are
plain template literals.

**Use it when.**
- Customer / SKU / city lookup field with a local or prefetched list; "search with suggestions" in a
  topbar; assigning an owner from a user list; mixed-source suggestions (NBA + NHL style datasets).
- If you need a selected *value* rather than text, a Choices.js select with search is simpler.

**Source.** `references/sources/pages/form-other-plugin.html` (card "Typeahead");
`references/sources/assets/js/pages/form-typehead.js`; plugins `jquery`, `handlebars`,
`typeahead/typeahead.bundle.min.js`.

**Markup.**

```html
<input class="form-input typeahead" type="text" autocomplete="off" placeholder="Enter states from USA" />
<input class="form-input bloodhound-typeahead" type="text" autocomplete="off" placeholder="Enter states from USA" />
<input class="form-input prefetch-typeahead" type="text" autocomplete="off" placeholder="Enter states from USA" />
<input class="form-input default-suggestions-typeahead" type="text" autocomplete="off" placeholder="Default Suggestions" />
<input class="form-input custom-template-typeahead" type="text" autocomplete="off" placeholder="Search For Oscar Winner" />
<input class="form-input multi-datasets-typeahead" type="text" autocomplete="off" placeholder="NBA and NHL Teams" />
```

**Init / JS.**

```js
// assets/js/pages/form-typehead.js (trimmed; `states` = array of US state names, NBATeams/NHLTeams = [{team}])
window.jQuery = window.$ = $;
const base = { hint: true, highlight: true, minLength: 1 };

// 1. basic: synchronous source function
$(".typeahead").typeahead(base, { name: "states", source: (q, cb) => { const re = new RegExp(q, "i"); cb(states.filter(s => re.test(s))); } });

// 2. Bloodhound local
const bh = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace, local: states });
$(".bloodhound-typeahead").typeahead(base, { name: "states", source: bh });

// 3. prefetch JSON
const pre = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace, prefetch: "assets/data/typeahead.json" });
$(".prefetch-typeahead").typeahead(base, { name: "states", source: pre });

// 4. default suggestions when empty (minLength 0)
$(".default-suggestions-typeahead").typeahead({ hint: true, highlight: true, minLength: 0 },
  { name: "states", source: (q, cb) => q === "" ? cb(["Alaska", "New York", "Washington"]) : pre.search(q, cb) });

// 5. object data + custom templates
const movies = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.obj.whitespace("value"), queryTokenizer: Bloodhound.tokenizers.whitespace, prefetch: "assets/data/typeahead-data-2.json" });
$(".custom-template-typeahead").typeahead({ highlight: true, hint: true }, { name: "best-movies", display: "value", source: movies,
  templates: { empty: `<div class="empty-message px-3">Unable to find any Best Picture winners that match the current query</div>`,
               suggestion: d => `<div><span class="font-medium">${d.value}</span> – ${d.year}</div>` } });

// 6. multiple datasets with headers
const teams = list => new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.obj.whitespace("team"), queryTokenizer: Bloodhound.tokenizers.whitespace, local: list });
$(".multi-datasets-typeahead").typeahead({ hint: true, highlight: true, minLength: 0 },
  { name: "nba-teams", source: teams(NBATeams), display: "team", templates: { header: '<h5 class="league-name text-default-400 font-semibold border-bottom py-2">NBA Teams</h5>' } },
  { name: "nhl-teams", source: teams(NHLTeams), display: "team", templates: { header: '<h5 class="league-name text-default-400 font-semibold border-bottom py-2">NHL Teams</h5>' } });
```

**Gotchas.**
- `assets/data/typeahead.json` and `typeahead-data-2.json` are referenced but not vendored locally;
  prefetch variants need those endpoints to exist in your app.
- The compiled CSS styles `.tt-menu` (card background, `default-300` border, 200px scroll) and
  `.tt-suggestion:hover/.tt-cursor` (primary background); `.twitter-typeahead { display: inherit !important }`
  keeps the wrapper block-level so the input stays full width.
- `autocomplete="off"` on the input prevents the browser's own list from stacking on top.

## Touchspin quantity input (`data-touchspin`)

**What it is.** A template-exclusive stepper handled by `app.js` (`Plugins.initTouchSpin()`): a
wrapper `[data-touchspin]` containing an `<input>` and `[data-minus]` / `[data-plus]` buttons. Clicks
change the value by 1 and respect the input's `min` / `max`. The compiled
`.input-group[data-touchspin]` rule turns the group into a bordered pill with borderless centred input.

**Use it when.** Cart line quantity (apps-ecommerce-cart uses it), seats/guests count, order
quantity on a product page, number of licences in a plan picker. For decimal steps or keyboard
arrows wire `<input type="number" step>` yourself.

**Source.** `references/sources/pages/form-other-plugin.html` (card "Input Touchspin");
`references/sources/assets/js/app.js` (`initTouchSpin`).

**Markup.**

```html
<!-- default: minus | input | plus -->
<div class="input-group" data-touchspin>
  <button type="button" class="btn bg-light hover:text-primary" data-minus><i class="iconify tabler--minus"></i></button>
  <input type="text" class="form-input" value="100" max="800000" />
  <button type="button" class="btn bg-light hover:text-primary" data-plus><i class="iconify tabler--plus"></i></button>
</div>
<!-- buttons may sit on either side or both on one side; order is free -->
<div class="input-group" data-touchspin><input type="text" class="form-input" value="100" max="800000" />
  <button type="button" class="btn bg-light hover:text-primary" data-minus><i class="iconify tabler--minus"></i></button>
  <button type="button" class="btn bg-light hover:text-primary" data-plus><i class="iconify tabler--plus"></i></button></div>

<!-- readonly (buttons ignored) / disabled -->
<div class="input-group" data-touchspin> … <input type="text" class="form-input" value="100" max="800000" readonly /> … </div>
<div class="input-group" data-touchspin> … <input type="text" class="form-input" value="100" max="800000" disabled /> … </div>

<!-- pill styles -->
<div class="input-group rounded-full!" data-touchspin>
  <button type="button" class="btn rounded-full! bg-primary/15 text-primary hover:bg-primary hover:text-white" data-minus><i class="iconify tabler--minus"></i></button>
  <input type="text" class="form-input" value="100" max="800000" />
  <button type="button" class="btn rounded-full! bg-primary/15 text-primary hover:bg-primary hover:text-white" data-plus><i class="iconify tabler--plus"></i></button></div>
<div class="input-group p-0!" data-touchspin>
  <button type="button" class="btn rounded-e-none! bg-primary/15 text-primary hover:bg-primary hover:text-white" data-minus>…</button>
  <input type="text" class="form-input" value="100" max="800000" />
  <button type="button" class="btn rounded-s-none! bg-primary/15 text-primary hover:bg-primary hover:text-white" data-plus>…</button></div>

<!-- vertical: stacked buttons beside a number input (no input-group class) -->
<div class="flex items-center overflow-hidden" data-touchspin>
  <div class="flex-col flex">
    <button type="button" class="btn rounded-none rounded-s-sm btn-icon w-7 h-4.75 bg-success/15 text-success" data-plus><i class="iconify tabler--plus"></i></button>
    <button type="button" class="btn rounded-none rounded-e-sm btn-icon w-7 h-4.75 bg-danger/15 text-danger" data-minus><i class="iconify tabler--minus"></i></button>
  </div>
  <input type="number" class="form-input rounded-s-none! text-center w-full" value="1" min="0" max="10" />
</div>
<!-- dark stack variant: wrap the buttons in <div class="flex-col flex bg-dark rounded-s-sm"> with text-white buttons;
     mirror with input first + rounded-e-none! / rounded-e-sm for buttons on the right -->
```

| Variant | Button classes |
|---|---|
| Light (default) | `btn bg-light hover:text-primary` |
| Solid colours | `btn bg-primary text-white hover:bg-primary-hover` (also secondary, info, success, warning, danger; `bg-dark text-light hover:bg-dark-hover`) |
| Soft | `btn bg-primary/15 text-primary hover:bg-primary hover:text-white` |
| Pill | add `rounded-full!` to the buttons (and optionally the group) |

**Init / JS.**

```js
// app.js — Plugins.initTouchSpin()
document.querySelectorAll("[data-touchspin]").forEach(group => {
  const minus = group.querySelector("[data-minus]"), plus = group.querySelector("[data-plus]"), input = group.querySelector("input");
  if (!input) return;
  const min = Number(input.min), max = Number(input.max ?? 0), hasMin = Number.isFinite(min), hasMax = Number.isFinite(max);
  const cur = () => Number.parseInt(input.value) || 0;
  if (input.hasAttribute("readonly")) return;
  minus && minus.addEventListener("click", () => { const v = cur() - 1; (!hasMin || v >= min) && (input.value = String(v)); });
  plus  && plus.addEventListener("click",  () => { const v = cur() + 1; (!hasMax || v <= max) && (input.value = String(v)); });
});
```

**Gotchas.**
- Only `readonly` on the input stops the buttons; a `disabled` input still gets its value changed
  by clicks. Add `disabled` to the buttons as well.
- `Number("")` is `0`, so an input without `min` behaves as `min="0"` (values never go negative) and
  without `max` behaves as `max="0"` (plus does nothing). **Always set both `min` and `max`.**
- Step is fixed at 1 and the value is parsed with `parseInt`; decimals are truncated.
- The "Sizes" card on the demo page contains two groups with identical markup (no size classes);
  size with `form-input-sm`/`btn-sm` style utilities yourself.
- Changing the value does not dispatch `input`/`change` events; listen to the button clicks or
  dispatch your own event if other code must react.

## Original sources

- `references/sources/pages/form-elements.html`
- `references/sources/pages/form-layout.html`
- `references/sources/pages/form-pickers.html`
- `references/sources/pages/form-select.html`
- `references/sources/pages/form-validation.html`
- `references/sources/pages/form-wizard.html`
- `references/sources/pages/form-fileuploads.html`
- `references/sources/pages/form-text-editors.html`
- `references/sources/pages/form-range-slider.html`
- `references/sources/pages/form-other-plugin.html`
- `references/sources/assets/js/app.js` (`class Plugins`: `initFlatPicker`, `initTouchSpin`; `theme()` helper)
- `references/sources/assets/js/pages/form-choice.js`
- `references/sources/assets/js/pages/form-select2.js`
- `references/sources/assets/js/pages/form-colorpickr.js`
- `references/sources/assets/js/pages/form-date-range-picker.js`
- `references/sources/assets/js/pages/form-fileupload.js`
- `references/sources/assets/js/pages/form-inputmask.js`
- `references/sources/assets/js/pages/form-typehead.js`
- `references/sources/assets/js/pages/form-quilljs.js`
- `references/sources/assets/js/pages/form-range-slider.js`
- `references/sources/assets/js/pages/form-validation.js`
- `references/sources/assets/js/pages/form-wizard.js`
- `references/sources/assets/css/app.min.css` (grepped for `form-*`, `input-group`, `input-icon-group`, `is-valid/is-invalid`, `[data-slider-*]`, `[data-touchspin]`, `hs-stepper-*` variants, and the compiled plugin skins)
- `references/sources/MANIFEST-page-deps.txt`
