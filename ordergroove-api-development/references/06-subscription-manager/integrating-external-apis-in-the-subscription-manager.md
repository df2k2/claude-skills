# Integrating External APIs in the Subscription Manager

This guide provides an approach for extending the functionality of the Subscription Manager by integrating external APIs. By following the steps outlined, you can dynamically pull in additional data and render them within your application.

> 🚧
>
> **Note**: The example code is abbreviated for ease of reading; please add appropriate error handling.

***

## Basic usage

### Step One – Add Function to script.js for API Request

First, add an asynchronous function to script.js that uses the [Fetch API](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API) to request data from an external API. In this example, we'll use a URL of a cat image.

```javascript File: script.js
async function get_cat_url() {
 const response = await fetch('https://api.thecatapi.com/v1/images/search');
 const [{ url: catUrl }] = await response.json();
 return catUrl;
}
```

### Step Two – Add Function to script.js to Render Dynamic Content

Next, add a function that returns a template literal with a value from the API response. Utilize the [html](https://static.ordergroove.com/@ordergroove/smi-core/0.32.5/docs/functions/api.html.html) function from [lit-html](https://lit.dev/docs/v1/lit-html/introduction/) to interpret and render the template literal efficiently.

```Text File: script.js
async function render_cat_image() {
  const catUrl = await get_cat_url();
  return window.og.smi.html`<img src="${catUrl}" alt="cat" />`;
}
```

### Step Three – Call the Render Function from Liquid Partial

Finally, call the function from the desired location in the liquid template. Chain a call to [until](https://static.ordergroove.com/@ordergroove/smi-core/0.32.5/docs/interfaces/filters.Filters.html#until) to ensure placeholder content is rendered until the asynchronous function resolves.

```Text File: <partial-name>.liquid
{{ 'render_cat_image()' | js | until }}
```

***

## Additional Usage

### Pass Arguments to Functions

**Static Argument**

```Text File: <partial-name>.liquid
{{ 'render_cat_image("tabby")' | js | until }}
```

**Dynamic Argument from Partial Scope**

In the below example, we assume `order` is in scope.

```Text File: <partial-name>.liquid
{{ 'render_cat_image(order.public_id)' | js | until }}
```

<br />

### Set API Response as Variable in Liquid Partial

```Text File: <partial-name>.liquid
{% set cat_url = 'get_cat_url()' | js %}
```

<br />

### Call API on Button Click

```Text File: <partial-name>.liquid
<button @click={{ 'get_cat_url' | js }}>
  Get Cat URL
</button>
```

<br />

### Update Application State on API Response

To gracefully update the application state upon receiving an API response, you can call one of the [og.smi API methods](https://developer.ordergroove.com/docs/refreshing-data-in-the-subscription-manager) to refresh the page state. The example below dispatches an action to request all processing and upcoming orders and updates the application state accordingly.

```Text File: script.js
async function get_cat_url() {
 const response = await fetch('https://api.thecatapi.com/v1/images/search');
 const [{ url: catUrl }] = await response.json();
 window.og.smi.api.refresh_page_state();
 return catUrl;
}
```

<br />

### Call an API Outside the Context of Partials

To make an API call independent of partials, such as a single call during application initialization, invoke the API request function directly from `script.js`. If the function relies on the presence of the SMI element, call the function from the bootstrap function. The example below fetches a cat URL and appends an image to the SMI element.

```Text File: script.js
function bootstrap(el) {
  smiElement = el;
  append_cat();
  ...rest of function
}

async function append_cat() {
 const catUrl = await get_cat_url();
 const catElement = document.createElement('img');
 catElement.setAttribute('src', catUrl);
 smiElement.appendChild(catElement);
}
```