<!-- source: https://docs.hyva.io/hyva-checkout/magewire/component-lifecycle.html -->

# Magewire Component Lifecycle

The Magewire component lifecycle describes how a Magewire component lives from the moment it first renders until the visitor navigates away from the page. Understanding the Magewire component lifecycle is key to choosing the right [lifecycle hook method](lifecycle-hook-methods.html) for your code.

## How the Magewire Component Lifecycle Works

A Magewire component's lifecycle begins with the initial page render and continues across multiple requests - from the first page request through any number of Ajax requests triggered by user interaction. The lifecycle ends when the visitor leaves the page.

Under the hood, PHP instantiates the Magewire component once per request. But because Magewire synchronizes component property values between the JavaScript front end and the PHP backend on every request, the lifecycle effectively extends beyond a single PHP request. The component "remembers" its state across requests.

## Request Types in the Magewire Component Lifecycle

Every Magewire component encounters two types of requests during its lifecycle:

- **Preceding request (initial render)** - The first time the page loads. Magewire renders the component with its default property values.
- **Subsequent requests (Ajax requests)** - Any request after the initial render, triggered by user interaction. Magewire restores the component's previous state before processing updates.

## Magewire Hydration and Dehydration

Magewire uses **hydration** and **dehydration** to maintain component state between requests. These are the core mechanisms that make the Magewire component lifecycle work.

### Hydration - Restoring Component State

**Hydration** is the process where Magewire restores a component's property values from the previous request. Hydration only happens on subsequent (Ajax) requests - during the preceding request, properties keep their default values since there is no previous state to restore.

### Property Updates - Applying New Values

After hydration, Magewire **updates** the component properties to their new values based on the user's interaction. This gives each subsequent request two distinct phases:

1. **Before property updates** - Properties hold their previous (hydrated) values
2. **After property updates** - Properties hold their new values

### Dehydration - Saving Component State

**Dehydration** is the process where Magewire serializes the component's current property values and sends them to the front end. The front end stores these values so they can be used for hydration during the next subsequent request. After dehydration, the component is inert until the next request arrives.

## Lifecycle Phases at a Glance

Each request passes through these phases in order:

1. **Before hydration** - Component has default values (preceding request) or is about to be hydrated (subsequent request)
2. **After hydration** - Component state is restored from the previous request (subsequent requests only)
3. **Before property updates** - Hydrated values are in place, new values have not yet been applied (subsequent requests only)
4. **After property updates** - New property values are applied (subsequent requests only)
5. **Dehydration** - Component properties are serialized and sent to the front end

Choosing the Right Lifecycle Hook

Each of these phases maps to a specific [lifecycle hook method](lifecycle-hook-methods.html). For example, use `mount()` to run code only during the preceding request, or `updated()` to react after a property has changed.

## Related Topics

- **[Lifecycle Hook Methods](lifecycle-hook-methods.html)** - The hook methods you can implement to run code at each phase of the Magewire component lifecycle
- **[Running PHP Code After Property Updates](running-php-code-after-property-updates.html)** - How to execute logic when Magewire component properties change
- **[Magewire Component Introduction](component-intro.html)** - The basics of creating and configuring Magewire components
