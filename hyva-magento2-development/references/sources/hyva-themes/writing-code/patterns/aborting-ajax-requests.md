<!-- source: https://docs.hyva.io/hyva-themes/writing-code/patterns/aborting-ajax-requests.html -->

# Aborting Ajax requests

Some modules abort running Ajax requests when an event is dispatched again.

In a nutshell, this is the jQuery code:

```
var saveRequest = null;

function onUpdate() {
    if (saveRequest) {
        saveRequest.abort();
    }
    saveRequest = $.ajax(settings.submit_url, {
        success: function(data) {
            //do something
            saveRequest = null;
        }
    });
}
```

The same thing can be done with `fetch` using an `AbortController` signal:

```
let controller;

function onUpdate() {
    if (controller) {
        controller.abort();
    }
    // ensure a new controller is used for the new request
    controller = new AbortController();
    window.fetch(settings.submit_url, {
        signal: controller.signal,
        method: 'post',
        headers,
        body,
    })
    .then(response => {
        // do someThing
    });
}
```

Note

Be sure to instantiate a new controller instance after the previous one was aborted. It is not possible to reuse an aborted controller signal.
