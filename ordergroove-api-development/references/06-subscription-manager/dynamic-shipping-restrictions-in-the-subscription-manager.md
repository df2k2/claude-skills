# Dynamic Shipping Restrictions in the Subscription Manager

Your site may have certain products that cannot be shipped to certain states. If this is the case, you can change the state choices available when a customer edits their subscription address.

Below you will find a step-by-step guide to implementing these restrictions. This guide will show you how to do this based on a product ID, but you can target any identifier (i.e. subscription.extra\_data, product groups, order items, etc). Check out our full list of [Object References ](https://developer.ordergroove.com/docs/object-reference)to see what targets are available.

***

## Subscription Manager Version

The implementation of dynamic shipping restrictions depends on the version of the theme. Please pick the method based on the Subscription Manager version you have installed.

### How to tell what version you're on

Before the September 2024 release of v25, all Subscription Manager installations were on version 0, displayed in the Theme Designer as version 0.X.X. You can check which version you’re on by going to [Ordergroove](https://rc3.ordergroove.com/) > Subscription > Subscription Manager.

<Image align="center" width="50% " src="https://files.readme.io/0f5a3126136d00f63aed46b389aba7f3ac6835182c6447149a5bdd11d941341e-image2.png" />

***

## Current - smi-templates 25.0.0+

Log in to [Ordergroove](https://rc3.ordergroove.com/), and go to Subscriptions > Subscription Manager > Advanced. Make the following changes to your code:

### Views order-summary/change-shipping-dialog.liquid

Locate *\{% set localized\_countries = 'localized\_countries' | t %}* and add the following line of code. Change or add to Alaska and Hawaii, to the states you do not ship to:

```liquid
{% set excluded_states = setting('enabled_states_restricted', ['AK', 'HI']) %}
```

Locate the HTML tag `sm-country-state-dropdown` and add a new property `.excludedStates="{{ excluded_states }}"`. The full HTML tag should appear as follows:

```
<sm-country-state-dropdown
  .localizedCountries="{{ localized_countries }}"
  .enabledCountries="{{ enabled_countries }}"
  .excludedStates="{{ excluded_states }}"
>
```

### script.js

Locate the function `syncCountryAndStates`inside the `SMCountryStateDropdown` custom element definition. Inside the `states.forEach` loop, add the line `if (this.excludedStates.includes(code)) return;`before calling the `createOption` function. The updated function should appear similar to the following (depending on your Subscription Manager version, minor updates may have occurred to the base code):

```
  async syncCountryAndStates(countryValue) {
    const countriesByCode = await countriesDataPromise;
    const selectedCountry = countriesByCode[countryValue];
    const states = selectedCountry ? selectedCountry.regions : null;

    const currentOptions = this.stateSelect.querySelectorAll('option');
    currentOptions.forEach(option => {
      // Clear all options except default blank option
      if (option.value !== '') option.remove();
    });

    if (states && states.length) {
      states.forEach(({ code, name }) => {
        if (this.excludedStates.includes(code)) return; // this is the updated line
        createOption(code, name, this.stateSelect);
      });
    }
  }
```

***

## Subscription Manager 0.33.3 - 0.41.1

Log in to [Ordergroove](https://rc3.ordergroove.com/), and go to Subscriptions > Subscription Manager > Advanced. Make the following changes to your code:

### Views change-shipment-address.liquid

Locate *\{% set localized\_countries = 'localized\_countries' | t %}* and add the following line of code. Change or add to Alaska and Hawaii, to the states you do not ship to:

```liquid
{% set excluded_states = setting('enabled_states_restricted', ['AK', 'HI']) %}
```

Locate and replace *\<select id='state*\{\{ order.public*id }}' class='og-form-select' name='state\_province\_code' >* with the following code:

```
<select id='state_{{ order.public_id }}' class='og-form-select' name='state_province_code' required data-excluded_states='[{{ 'excluded_states.map(s=> `"${s}"`).join(",")' | js }}]'>
```

<Image align="center" width="600px" src="https://files.readme.io/4214022-change-shipment-address.png" />

### script.js

Locate *const stateSelectElement = ev.target.closest('form').querySelector('\[name="state\_province\_code"]')'* and add the following line of code.

```javascript
const excludedStates = JSON.parse(stateSelectElement.dataset.excluded_states || '');
```

Locate *states.forEach((\{ code, name }) =>* \{ and add the following line:

```javascript
if (excludedStates.includes(code)) return;
```

<Image align="center" width="600px" src="https://files.readme.io/0d49174-script.png" />

***

## Legacy - Subscription Manager 0.33.2 and earlier

### Step 1: Set all states for shipping dropdown

Set a list of all localized\_states you want available for selection for non-restricted products and put that in a JSON object in the en-US.json file.

<Image align="center" width="600px" src="https://files.readme.io/93f552a-Screen_Shot_2022-06-17_at_2.24.52_PM.png" />

### Step 2: Set the variables

In the change-shipment-address.liquid file you'll set the full list of enabled states (enabled\_states\_all) and the list of restricted states (enabled\_states\_restricted). These will be the two lists pulled into the select form based on the criteria. You'll also set the states object and point it to the localized\_states list that you defined in step 1.

Next you'll set a variable of restricted\_products to false and then run a for loop to iterate over all of the items in an order to evaluate the product group name or product id (or both). The restricted\_products statement will become true if the product or group is found.

```Text Product ID Example
{% set enabled_states_all = setting('enabled_states_all', ["AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MP", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]) %}
{% set enabled_states_restricted = setting('enabled_states_restricted', ["CO", "CT", "DC", "DE", "FL"]) %}
{% set states = 'localized_states' | t %}
{% set restricted_products = false %}
{% set current_order_items = order_items | select(order=order.public_id) %}
{% for order_item in current_order_items %}
  {% set restricted_products = (restricted_products or (order_item.product == "42328611848362")) %}
{% endfor%}
```

```Text Product Group Name Example
{% set enabled_states_all = setting('enabled_states_all', ["AK", "AL", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MP", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY"]) %}
{% set enabled_states_restricted = setting('enabled_states_restricted', ["CO", "CT", "DC", "DE", "FL"]) %}
{% set states = 'localized_states' | t %}
{% set restricted_products = false %}
{% set current_order_items = order_items | select(order=order.public_id) %}
{% for order_item in current_order_items %}
  {% set product = products | find(id=order_item.product) %}
  {% for group in product.groups %}
    {% if group.name === 'restricted' %}
      {% set restricted_products = true %}
    {% endif%}
  {% endfor %}
{% endfor%}
```

### Step 3: Adjust the state from an input to a select

Here you'll switch the form from being an input field to a select dropdown. Within the code, you can determine which list of states you want the customer to select from based on whether the order contains a restricted product or not.

```liquid
<div class='og-form-group og-col'>
  <label class='og-form-label {{ 'og-required' if 'required_fields.shipping_address.state_province_code' | setting }}' for='state_{{ order.public_id }}'>
    {{ 'form_address_state' | t }}
  </label>
  <select class='og-form-select' name='state_province_code' id='state_{{ order.public_id }}' ?required='{{ 'required_fields.shipping_address.state_province_code' | setting }}'>
    {% if restricted_products %}
      {% for state_province_code in enabled_states_restricted %}
        <option value='{{ state_province_code }}'>{{ states[state_province_code] }}</option>
      {% endfor %}
    {% else %}
      {% for state_province_code in enabled_states_all %}
        <option value='{{ state_province_code }}'>{{ states[state_province_code] }}</option>
      {% endfor %} 
    {% endif %}
  </select>
</div>
```

### Step 4: Disable Update All Checkbox

If a customer has products that are not shippable to certain states, you'll want to suppress their ability to use the update for all feature when changing their address. This ensures that other subscriptions and orders don't get updated to an unsupported state.

```liquid
<div class='og-input-group'>
  {% if restricted_products %}
    <input type='checkbox' class='og-check-radio' name='use_for_all' id='use_for_all_{{ order.public_id }}' />
    <label class='og-check-radio-label' for='use_for_all_{{ order.public_id }}'>Use for all shipments</label>
  {% else %}
    <input type='checkbox' disabled="disabled" class='og-check-radio' name='use_for_all' id='use_for_all_{{ order.public_id }}' />
    <label class='og-check-radio-label' for='use_for_all_{{ order.public_id }}'>Use for all shipments disabled due to product shipping restrictions</label>
  {% endif %}
</div>
```

**Example Result**

<Image align="center" src="https://files.readme.io/9fe4dbf-CleanShot_2024-01-27_at_17.38.222x.png" />