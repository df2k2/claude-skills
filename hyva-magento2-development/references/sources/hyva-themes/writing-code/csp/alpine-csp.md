<!-- source: https://docs.hyva.io/hyva-themes/writing-code/csp/alpine-csp.html -->

# Alpine.js CSP Build for Strict Content Security Policy

Alpine CSP is a special build of Alpine.js that works without the `unsafe-eval` CSP directive. Standard Alpine.js uses JavaScript's `new Function()` constructor to process expressions in HTML attributes (like `:class="{'hidden': !open}"`), which requires `unsafe-eval` in the Content Security Policy. The Alpine CSP build eliminates this requirement by restricting what can be written in HTML attributes.

This page explains the differences between standard Alpine.js and Alpine CSP, and provides guidance for writing CSP-compatible components.

## Alpine CSP Limitations

The [Alpine CSP build](https://alpinejs.dev/advanced/csp) supports a subset of standard Alpine features:

- **Read-only property access**: HTML attributes can only read component properties, not transform them
- **Method execution**: If a property is a function, it executes when referenced
- **No inline expressions**: Transformations like negation (`!open`) or ternaries must be written as methods

While this requires more verbose code with many small methods, it eliminates the `unsafe-eval` attack vector that enables JavaScript injection attacks.

Alpine v2 Not Supported

There is no CSP build of Alpine v2. Themes using Alpine v2 must upgrade to Alpine v3 before implementing CSP compatibility.

To check your Alpine version, open the browser developer console on any page and run `Alpine.version`. If the version starts with "2", upgrade using the [Hyvä Theme 1.2.0 upgrade notes](../../upgrading/upgrading-to-1-2-0.html#migration-scripts).

## Hyvä CSP Theme Versions

Hyvä provides both standard and CSP-compatible theme versions to accommodate different merchant needs:

- **Standard Hyvä Theme**: Uses regular Alpine.js with full expression support
- **Hyvä Theme CSP**: Uses Alpine CSP build, compatible with strict CSP

Both versions will be maintained for the foreseeable future, giving merchants and extension vendors time to migrate their code.

### CSP Requirements Timeline

Since April 1, 2025, PCI-DSS 4.0 requires strict CSP (without `unsafe-eval`) on payment-related pages. All checkout pages will require Alpine CSP compatibility.

Scope of CSP Requirements

The exact scope of "payment-related pages" in PCI-DSS remains ambiguous. Interpretation may depend on payment service provider requirements, merchant location, and whether in-context payment buttons (PayPal Express, Apple Pay) are used. Checkout pages definitively require strict CSP.

### Hyvä Checkout CSP Support

Hyvä Checkout fully supports CSP strict mode. See the [Hyvä Checkout CSP Documentation](../../../hyva-checkout/devdocs/csp/index.html) for configuration details.

## Writing Alpine CSP-Compatible Code

Alpine CSP-compatible code works in both standard Alpine and Alpine CSP builds. Writing CSP-compatible components from the start ensures future compatibility and simplifies migration.

### Key Differences from Standard Alpine

| Feature | Standard Alpine | Alpine CSP |
| --- | --- | --- |
| Property reads | `x-show="open"` | `x-show="open"` (same) |
| Negation | `x-show="!open"` | `x-show="isNotOpen"` (method required) |
| Expressions | `:class="{'hidden': !open}"` | `:class="isHiddenClass"` (method required) |
| Mutations | `@click="open = false"` | `@click="close"` (method required) |
| Method arguments | `@click="setTab('info')"` | `@click="setTab"` + `data-tab="info"` |
| `x-model` | Supported | **Not supported** |
| `x-for` | `x-for="item in getItems('category')"` | `x-for="item in items"` (no method args) |
| Component constructor function | `x-data="initCompoment()"` or `x-data="{open: false}"` | `x-data="initCompoment"` + constructor function registration with `Alpine.data()` |

### Migration Examples

#### Negation: Convert inline negation to methods

```
<!-- Standard Alpine -->
<div x-show="!open">Hidden when open</div>

<!-- Alpine CSP -->
<div x-show="isClosed">Hidden when open</div>
```

```
// Component method
isClosed() {
    return !this.open;
}
```

#### Mutations: Move state changes to methods

```
<!-- Standard Alpine -->
<button @click="open = false">Close</button>

<!-- Alpine CSP -->
<button @click="close">Close</button>
```

```
// Component method
close() {
    this.open = false;
}
```

#### Component Constructors: Register with Alpine.data()

In standard Alpine, component constructor functions can be called directly in `x-data` with parentheses. In Alpine CSP, constructor functions must be registered with `Alpine.data()` and referenced without parentheses:

```
<!-- Standard Alpine: constructor called with parentheses -->
<script>
    function initMyComponent() {
        return {
            open: false,
            toggle() { this.open = !this.open; }
        };
    }
</script>
<div x-data="initMyComponent()">

<!-- Alpine CSP: constructor registered and referenced without parentheses -->
<script>
    function initMyComponent() {
        return {
            open: false,
            toggle() { this.open = !this.open; }
        };
    }
    // Register the component constructor with Alpine
    window.addEventListener(
        'alpine:init',
        () => Alpine.data('initMyComponent', initMyComponent)
    );
</script>
<div x-data="initMyComponent">
```

See [Constructor Functions](alpine-csp-constructor-functions.html) for detailed registration patterns.

#### Method Arguments: Use data attributes

```
<!-- Standard Alpine -->
<button @click="setTab('shipping')">Shipping</button>

<!-- Alpine CSP -->
<button @click="setTab" data-tab="shipping">Shipping</button>
```

```
// Component method
setTab(event) {
    this.activeTab = event.target.dataset.tab;
}
```

### Features That Work Identically

Most Alpine features work the same in both builds:

- `x-for` iteration (without method arguments in the iterator expression)
- `x-if` and `x-show` with property references
- Event handling with `@click`, `@input`, etc.
- `x-ref` references
- `x-init` initialization
- Component lifecycle methods

## Migration Checklist

When converting a component from standard Alpine to Alpine CSP, check for the following patterns that require changes:

| Pattern to Find | Action Required |
| --- | --- |
| `x-data="functionName()"` with parentheses | Register with `Alpine.data()`, remove parentheses |
| `x-data="{...}"` inline object | Extract to named function, register with `Alpine.data()` |
| `x-show="!property"` or `x-if="!property"` | Create method returning negated value |
| `:class="{ 'name': condition }"` | Create method returning class object |
| `@click="property = value"` | Create method for state mutation |
| `@click="method('arg')"` with arguments | Use `data-*` attributes, read from `event.target.dataset` |
| `x-model="property"` | Replace with `:value` + `@input` handler (see [x-model Alternatives](alpine-csp-x-model.html)) |
| `x-for="item in method('arg')"` | Pre-compute array, use direct property reference |

For automated migration assistance, see the [Migration Tool](migration-tool.html).

## Related Documentation

- [Alpine CSP Example Component](alpine-csp-example-component.html): Complete working example
- [Constructor Functions](alpine-csp-constructor-functions.html): Registration patterns
- [Property Mutation](alpine-csp-property-mutation.html): State change patterns
- [x-model Alternatives](alpine-csp-x-model.html): Form input handling
