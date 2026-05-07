# Implementing Country & State Dropdown in Subscription Manager Themes

Rather than asking a customer to manually type the state or province of their shipping address, and risking typos or formatting issues, we now provide a list of states and provinces based on the country selected. If your subscription manager doesn't have this feature, you can add it through the advanced editor.

***

## Technical Details

The list of states/provinces is being grabbed in script.js by making a call to:

[https://static.ordergroove.com/@ordergroove/i18n-data/latest/i18n\_country\_data.json](https://static.ordergroove.com/@ordergroove/i18n-data/latest/i18n_country_data.json)

Country names are pulled from locale files first (i.e. en-US.json). If no translation is provided, default from *i18n\_country\_data.json* is used (English.)

<Image align="center" width="450px" src="https://files.readme.io/52067f7-Untitled.png" />

***

## Accessing the Advanced Editor

We'll be using the advanced editor to modify the Subscription Manager. You can access it through your Ordergroove Admin:

1. Log in to [Ordergroove](https://rc3.ordergroove.com/).
2. Go to **Subscriptions** on the top toolbar, and select **Subscription Manager**.
3. Toggle **Advanced** on the top left.

> 🚧 Support
>
> Some aspects of this article require technical expertise with coding languages. This is self-serve and outside of the normal support policy.

***

## Including Changes without Overwriting Customizations

To include this functionality without losing customizations to the theme, we have to edit some code in *script.js*.

### 1. Add the following lines

The code changes required in *change-shipment-address.liquid* are as follows (as noted in [Github](https://github.com/ordergroove/plush-toys/pull/708/files)):

```Text Liquid
const countriesPromise = fetch(
'https://static.ordergroove.com/@ordergroove/i18n-data/latest/i18n_country_data.json'
).then(res => res.json());

async function render_countries_options(enabled_countries, localized_countries) {
const html = ((window.og || {}).smi || {}).html;
const countriesByCode = await countriesPromise;
const enabledCountries = Object.entries(countriesByCode).filter(([code]) => enabled_countries.includes(code));
const countriesHtml = enabledCountries
.sort((a, b) => (a[1].name > b[1].name ? 1 : -1))
.reduce((acc, [code, { name }]) => {
const label = localized_countries[code] || name;
acc.push(html`
<option value="${code}">${label}</option>
`);
return acc;
}, []);
return countriesHtml;
}

function toggleStateSelect(stateSelectElement, show) {
const stateSelectLabelElement = stateSelectElement.parentNode.querySelector('label');
stateSelectElement.style.display = show ? 'block' : 'none';
stateSelectElement.required = show;
stateSelectLabelElement.style.display = show ? 'inline' : 'none';
}

async function handle_country_change(ev) {
const countriesByCode = await countriesPromise;
const selectedCountry = countriesByCode[ev.target.value];
const states = selectedCountry ? selectedCountry.regions : null;
const stateSelectElement = ev.target.closest('form').querySelector('[name="state_province_code"]');
const selectLabel = stateSelectElement.querySelector('option').innerText;

stateSelectElement.innerHTML = '';
const nullOption = document.createElement('option');
nullOption.value = '';
nullOption.innerText = selectLabel;
stateSelectElement.appendChild(nullOption);

if (selectedCountry) {
// Valid country selected
if (states) {
 // Country has list of states/regions

 // Show state select field
 toggleStateSelect(stateSelectElement, true);

// Append all states to select
states.forEach(({ code, name }) => {
const option = document.createElement('option');
option.value = code;
option.innerText = name;
stateSelectElement.appendChild(option);
});
} else {
// Country has no array of states/regions, e.g. France
// Hide state select field
toggleStateSelect(stateSelectElement, false);
}
} else {
// Country un-selected
// Show state select field
toggleStateSelect(stateSelectElement, true);
}
}

function reset_state_options(element) {
element.innerHTML = '';
const option = document.createElement('option');
option.value = '';
option.innerText = 'Select a State/Province';
element.appendChild(option);
element.parentNode.querySelector('label').innerText = 'State/Province/Region ';
}

function close_address_modal(ev) {
close_closest_modal(ev);
const $stateSelect = ev.target.querySelector('[name="state_province_code"]');
reset_state_options($stateSelect);
}
```

### 2. Rename Variable

On line 5, we recommend renaming the variable for clarity.

```liquid
{% set localized_countries = 'localized_countries' | t %}
```

### 3. Replace Lines 54 to 86

Replace lines 54 to 86 with the following:

```liquid
<div class='og-row'>
<div class='og-form-group og-col'>
<label class='og-form-label {{ 'og-required' if 'required_fields.shipping_address.country_code' | setting }}' for='country_{{ order.public_id }}'>
{{ 'form_address_country' | t }}
</label>
<select class='og-form-select' name='country_code' id='country_code_{{ order.public_id }}' required @change={{ 'handle_country_change' | js }}>
<option value="">{{ 'country_select_text' | t }}</option>
{{ 'render_countries_options(enabled_countries, localized_countries)' | js | until }}
</select>
</div>
<div class='og-form-group og-col'>
<label class='og-form-label {{ 'og-required' if 'required_fields.shipping_address.state_province_code' | setting }}' for='state_{{ order.public_id }}'>
{{ 'form_address_state' | t }}
</label>
<select id='state_{{ order.public_id }}' class='og-form-select' name='state_province_code' required>
<option value="">{{ 'state_select_text' | t }}</option>
</select>
</div>
</div>
<div class='og-row'>
<div class='og-form-group og-col'>
<label class='og-form-label {{ 'og-required' if 'required_fields.shipping_address.city' | setting }}' for='city_{{ order.public_id }}'>
{{ 'form_address_city' | t }}
</label>
<input type='text' id='city_{{ order.public_id }}' class='og-form-control' name='city' ?required='{{ 'required_fields.shipping_address.city' | setting }}'/>
</div>
<div class='og-form-group og-col'>
<label class='og-form-label {{ 'og-required' if 'required_fields.shipping_address.zip_postal_code' | setting }}' for='zip_{{ order.public_id }}'>
{{ 'form_address_zip' | t }} 
</label>
<input type='text' id='zip_{{ order.public_id }}' class='og-form-control' name='zip_postal_code' ?required='{{ 'required_fields.shipping_address.zip_postal_code' | setting }}'/>
</div>
</div>
```

And you’re all set. No changes were made to *smi-core*.