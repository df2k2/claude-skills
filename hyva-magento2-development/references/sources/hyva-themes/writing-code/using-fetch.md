<!-- source: https://docs.hyva.io/hyva-themes/writing-code/using-fetch.html -->

# Using fetch()

In Luma the jQuery functions `$.ajax`, `$.get` and `$.post` are often used to exchange data with server side Magento. In Hyvä, the native browser function `window.fetch` is used instead.

`fetch()` is [well documented](https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch), but here are some simple examples for reference or to get you started.

## A simple fetch GET request

A simple request to a controller returning JSON content might look like like this:

```
fetch(url)
  .then(response => {
    if (! response.ok) console.warn('GET request failed');
    return response.json()
  })
  .then(data => {
    // do something with `data`
  })
  .catch(error => {
    // optionally catch errors and display them
  })
  .finally(() => {
    // optionally run some code that is always executed when done.
    // for example, hiding a loading indicator
  })
```

As quick reminder, GET requests do not have request bodies, so any parameters need to be added to the requested URL before calling fetch.

The `response` object has many other properties and methods. Please refer to the browser [API documentation](https://developer.mozilla.org/en-US/docs/Web/API/Response) for details.

## Sending an Accept header

If we need to tell the server we expect a JSON response, we can pass an Accept header:

```
fetch(url, {headers: {accept: 'application/json'}})
```

HTTP Headers

With `fetch()` HTTP Header names can be specified in `camelCase` or `'Kebab-Case'` notation.

For example:

```
{
  "Content-Type": "application/json", // Kebab-Case
   contentType: "application/json"    // camelCase
}
```

## A simple Ajax POST fetch request with JSON data

For POST requests we can specify a request body.

Because we send a body, we also need to set the `Content-Type` header.

```
fetch(
  url + '?form_key=' + hyva.getFormKey(),
  {
    method: 'post',
    body: JSON.stringify(data),
    headers: {contentType: 'application/json'}
  }
)
```

## A simple Ajax form POST request

In this example the form key is added as a parameter to the POST body.

```
const body = new URLSearchParams({form_key: hyva.getFormKey(), foo: 'bar'});
const contentType = 'application/x-www-form-urlencoded; charset=UTF-8';
fetch(url, {method: 'post', body, headers: {'Content-Type': contentType}})
```

## Simulating a XMLHttpRequest Ajax request with fetch

This example uses the fetch API to simulate an Ajax request with the [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) object.

```
<script>
  function doAjaxCall(sections) {
    fetch(`${BASE_URL}path/to/ajax/call`, {
      method: "GET",
      headers: {
        "X-Requested-With": "XMLHttpRequest",
      },
    })
      .then(response => {
        if (response.ok) {
          return response.json();
        } else {
          console.warn("GET request failed", response);
        }
      })
      .then(data => {
        if (data) {
          //do something
        }
      });
  }
  window.addEventListener("load", doAjaxCall);
</script>
```

## Form Ajax POST Ajax request with AlpineJS

This example showcases an Ajax POST request that is triggered from Alpine.js.

The result is displayed in a message.

```
<div x-data="initSomeComponent()">
    <button @click="doPostRequest(1)">Do POST</button>
</div>

<script>
  function initSomeComponent() {
    return {
      dispatchMessage(type, message, timeout) {
        typeof window.dispatchMessages && window.dispatchMessages(
          [{
              type: type,
              text: message,
          }],
          timeout
        );
      },
      doPostRequest(someId) {
        const postUrl = `${BASE_URL}path/to/ajax/call/`;
        fetch(postUrl, {
          headers: {
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
          },
          body: new URLSearchParams({
            form_key: hyva.getFormKey(),
            someId: someId,
            uenc: btoa(window.location.href)
          }),
          method: "POST",
          mode: "cors",
          credentials: "include",
        })
          .then(response => {
            if (response.redirected) {
              window.location.href = response.url;
            } else if (response.ok) {
              return response.json();
            } else {
              this.dispatchMessage("warning", "Post request failed", 5000);
            }
          })
          .then(response => {
            if (!response) {
              return;
            }
            this.dispatchMessage(
              response.success ? "success" : "error",
              response.success
                ? "Post request was successful."
                : response.error_message,
              5000
            );

            // uncomment to reload customer section data
            /*
            const reloadCustomerDataEvent = new CustomEvent(
              "reload-customer-section-data"
            );
            window.dispatchEvent(reloadCustomerDataEvent);
            */
          })
          .catch(error => {
            this.dispatchMessage("error", error, 5000);
          });
      }
   };
  }
</script>
```

## GraphQL POST mutation request with AlpineJS

This example shows how to send a create guest cart mutation request to the Magento GraphQL API with fetch.

```
<div x-data="initSomeComponent()">
    <button @click="doGQLPostRequest(1)">Create guest cart</button>
    <div>
        Guest cart id: <span x-text="guestCartId || 'not set yet'"></span>
    </div>
</div>

<script>
  function initSomeComponent() {
    return {
      guestCartId: "",
      createGuestCartQuery: `mutation {
  createEmptyCart
}`,
      doGQLPostRequest() {
        fetch(BASE_URL + "graphql", {
          method: "POST",
          headers: {
            contentType: "application/json;charset=utf-8",
            store: "default",
          },
          body: JSON.stringify({ query: this.createGuestCartQuery }),
        })
          .then(response => response.json())
          .then(data => {
            this.guestCartId = (data && data.data && data.data.createEmptyCart) || "";
          });
        },
      };
    }
</script>
```

## GraphQL GET query request with AlpineJS

This example shows how to send a GraphQL query with a GET request

```
<script>
  function graphqlViewModelTest() {
    return {
      result: '',
      query: `{
  products(
    filter: {
      name: {
        match: "Tank"
      }
    }
    pageSize: 1
  ) {
    total_count
    items {
      name
      small_image {
        url
        label
      }
    }
  }
}`,
      run() {
        this.result = 'Loading...';

        window.fetch('/graphql?' + new URLSearchParams({query: this.query}))
          .then(response => response.json())
          .then(result => {
            this.result = result.errors && result.errors.length > 0
              ? result.errors.map(e => e.message).join("n")
              : JSON.stringify(result.data, null, 2);
            });
      }
    };
  }
</script>
<div x-data="graphqlViewModelTest()">
    <label><strong>GrahpQL:</strong>
    <textarea x-model="query" class="w-full h-80"></textarea>
    </label>
    <button class="btn" @click="run">Run</button>
    <template x-if="result !== ''">
        <div class="mt-4">
            <strong>Result:</strong>
            <pre x-text="result"></pre>
        </div>
    </template>
</div>
```
