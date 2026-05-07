<!-- source: https://docs.hyva.io/hyva-themes/faqs/moving-over-from-pwa.html -->

# Moving over from PWA

If you have been working with a SPA or PWA, be aware things will be different when building a Hyvä project.

## Unregister Service Workers

Hyvä currently doesn't use service workers, so you need to make sure to unregister the service workers.

```
navigator.serviceWorker && navigator.serviceWorker.getRegistrations()
    .then(registrations => {
        for (let registration of registrations) {
            registration.unregister();
        }
    })
```
