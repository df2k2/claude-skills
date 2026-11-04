<!-- source: https://docs.hyva.io/hyva-themes/cms/tailwind-jit/alpine-js.html -->

# Alpine.js and Single-Quoted Tailwind Classes

This is a narrow edge case. You only need this page if you use Tailwind classes that contain single quotes (for example `content` strings in `after:` / `before:` pseudo-elements) inside Alpine.js `:class` bindings in CMS content. Otherwise you can skip it.

When Tailwind utility classes contain single quotes (such as `content` strings in `after:` or `before:` pseudo-elements) and you use them inside Alpine.js `:class` bindings, the quotes must be escaped because they appear within a JavaScript string context.

Not recommended on CSP pages

Using Alpine.js class bindings on pages with a strict Content Security Policy is not recommended. Alpine expressions are evaluated as inline JavaScript and will be blocked by CSP. Avoid the approaches on this page for any CMS content that is rendered on CSP-protected pages.

Consider Tailwind data attribute variants instead

Tailwind's data attribute variant syntax is a cleaner alternative to `:class` bindings. Set a data attribute with a simple Alpine binding and apply conditional styles using the `data-[key=value]:` prefix on a static class:

```
<div :data-open="activeTab === 0" class="data-[open=true]:rotate-90"></div>
```

The Alpine binding only sets a plain value on the element - no JavaScript string escaping needed. The conditional styling logic lives entirely in the Tailwind class, which avoids both the quote-escaping problem and the Tailwind JIT compiler bug described below.

## Escaping Single Quotes in Alpine.js Class Bindings

Use backslash-escaped single quotes when referencing Tailwind classes that contain single quotes inside an Alpine.js `:class` binding:

```
<div :class="{'after:content-[\'bar\']': activeTab === 0}"></div>
```

## Workaround for Tailwind JIT Quote-Escaping Bug

A bug in the Tailwind JIT compiler causes escaped quotes in dynamic class bindings to be included literally in the generated CSS, breaking the styles. To work around this, add an HTML comment containing the unquoted version of the class name immediately before the element:

```
<!-- after:content-['bar'] -->
<div :class="{'after:content-[\'bar\']': activeTab === 0}"></div>
```

The CMS Tailwind JIT compiler processes both the commented unquoted version and the escaped version in the binding, generating CSS for both. The browser applies the correct unquoted version, making the styling work as expected.
