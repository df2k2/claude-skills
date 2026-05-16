# Layout XML, Blocks, Templates, and View Models

Magento's rendering pipeline is **layout-driven**, not template-driven. A controller doesn't render a template directly — it returns a layout, which references blocks, which render their templates. You compose pages by adding, removing, and rearranging blocks in **layout XML files**.

This reference is for the classic stack (Luma/Blank). For Hyvä, see the `hyva-magento2-development` skill — most of this still applies on the PHP side, but Hyvä swaps out the Knockout/RequireJS bits.

## The flow

1. Browser → Magento controller (e.g. `catalog/product/view`).
2. Controller resolves to a **layout handle** (e.g. `catalog_product_view`).
3. Magento merges all `*.xml` files under `view/frontend/layout/` (and `view/base/layout/`) whose name matches the active handles.
4. The merged XML describes a tree of **containers** and **blocks**.
5. Each block is instantiated, given its template, and rendered. The tree's HTML is concatenated.

## Layout handles

A handle is a string like `default`, `catalog_product_view`, `catalog_category_view`, `customer_account`, `checkout_cart_index`. Multiple handles apply to a single page — there's a stack:

- `default` — every page.
- `<area>_<routename>_<controller>_<action>` — the controller's full handle: `catalog_product_view`.
- Page-type handles: `catalogsearch_result_index`, `cms_index_index` (homepage), `cms_page_view`.
- Conditional / parameterized handles added by code: `catalog_product_view_type_simple`, `catalog_product_view_type_configurable`, `catalog_product_view_id_42`.
- Custom handles: any module can add a handle via `<update handle="my_custom_handle"/>`.

To override a Magento page, drop a file named after the handle into your module:

```
app/code/Acme/Hello/view/frontend/layout/catalog_product_view.xml
```

Magento merges this with vendor's `catalog_product_view.xml`. Your changes win (assuming module sequence is right).

## Layout XML structure

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd"
      layout="2columns-left">
    <update handle="some_other_handle"/>

    <head>
        <css src="Acme_Hello::css/style.css"/>
        <script src="Acme_Hello::js/inline-script.js"/>
        <title>Hello world</title>
        <meta name="description" content="…"/>
    </head>

    <body>
        <attribute name="class" value="page-hello"/>

        <referenceContainer name="content">
            <block class="Magento\Framework\View\Element\Template"
                   name="acme.hello.greeting"
                   template="Acme_Hello::greeting.phtml"
                   before="-">
                <arguments>
                    <argument name="greeting_text" xsi:type="string">Hello!</argument>
                    <argument name="view_model" xsi:type="object">Acme\Hello\ViewModel\Greeting</argument>
                </arguments>
            </block>
        </referenceContainer>

        <referenceBlock name="page.main.title">
            <action method="setPageTitle">
                <argument name="title" xsi:type="string">Custom title</argument>
            </action>
        </referenceBlock>

        <move element="checkout.cart.summary" destination="checkout.cart.aside" as="cart_summary_top"/>
        <remove name="catalog.compare.sidebar"/>
    </body>
</page>
```

### Containers vs blocks

- **Container** — a wrapper. Renders no HTML of its own except optional `htmlTag`, `htmlClass`, `htmlId`. Has children. Use when you want a structural slot multiple blocks can drop into.
- **Block** — a renderable unit backed by a PHP class. Optionally has a template.

Both are nodes in the layout tree. Both have a unique `name`.

### Common directives

- `<block name="x" class="..." template="...">` — declare a block.
- `<container name="x" htmlTag="div" htmlClass="foo">` — declare a container.
- `<referenceBlock name="x">` — modify an existing block (inherited from another file).
- `<referenceContainer name="x">` — modify an existing container.
- `<remove name="x"/>` — remove a block/container from the tree.
- `<move element="x" destination="y" before="..." after="..."/>` — relocate a block.
- `<update handle="h"/>` — include another handle's layout.
- `<action method="setFoo">` — call a method on a block at render-prep time. Brittle — prefer `<arguments>`.

### Positioning

- `before="-"` — position at the very top of the parent.
- `before="some.block"` — before a specific sibling.
- `after="-"` / `after="some.block"` — at bottom / after a sibling.
- No position → appended.

## Block classes

A block is a PHP class extending `\Magento\Framework\View\Element\Template` (most common) or `\Magento\Framework\View\Element\AbstractBlock`. You write a block when you need PHP logic backing a template.

```php
namespace Acme\Hello\Block;

use Magento\Framework\View\Element\Template;
use Magento\Framework\View\Element\Template\Context;

class Greeting extends Template
{
    public function __construct(
        Context $context,
        private readonly \Acme\Hello\Model\GreetingProvider $provider,
        array $data = []
    ) {
        parent::__construct($context, $data);
    }

    public function getGreeting(): string
    {
        return $this->provider->forCustomer(
            $this->getCustomerId() ?: 0
        );
    }
}
```

In the layout:
```xml
<block class="Acme\Hello\Block\Greeting"
       name="acme.hello.greeting"
       template="Acme_Hello::greeting.phtml"/>
```

In `view/frontend/templates/greeting.phtml`:
```php
<?php
/** @var \Acme\Hello\Block\Greeting $block */
/** @var \Magento\Framework\Escaper $escaper */
?>
<div class="greeting">
    <?= $escaper->escapeHtml($block->getGreeting()) ?>
</div>
```

## View Models — the modern preferred approach

Blocks are heavy: they extend a base class, are constructed once and cached, and historically people put untestable logic in them. Magento 2.2 introduced **view models**: plain PHP classes implementing `\Magento\Framework\View\Element\Block\ArgumentInterface`, injectable via layout XML, no inheritance.

```php
namespace Acme\Hello\ViewModel;

use Magento\Framework\View\Element\Block\ArgumentInterface;

class Greeting implements ArgumentInterface
{
    public function __construct(
        private readonly \Acme\Hello\Model\GreetingProvider $provider
    ) {}

    public function getGreeting(int $customerId): string
    {
        return $this->provider->forCustomer($customerId);
    }
}
```

In the layout:
```xml
<block class="Magento\Framework\View\Element\Template"
       name="acme.hello.greeting"
       template="Acme_Hello::greeting.phtml">
    <arguments>
        <argument name="view_model" xsi:type="object">Acme\Hello\ViewModel\Greeting</argument>
    </arguments>
</block>
```

In the template:
```php
<?php
/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var \Acme\Hello\ViewModel\Greeting $viewModel */
$viewModel = $block->getData('view_model');
?>
<div class="greeting">
    <?= $escaper->escapeHtml($viewModel->getGreeting((int) $block->getRequest()->getParam('customer_id', 0))) ?>
</div>
```

**Why view models > custom blocks**:
- No `extends Template`, so DI is clean.
- Easy to unit test (no Magento context dependency).
- Can be reused across templates.
- Multiple view models per block via multiple arguments.

**When you still need a custom block**: when you need to use methods Magento expects on blocks (e.g. `getChildHtml`, layout-aware logic, caching of HTML output by cache key, child block rendering). Otherwise default to a generic `Template` block + view model.

## Templates (.phtml)

Templates live under `view/<area>/templates/<path>.phtml` in a **module**, or `<area>/<Vendor_Module>/templates/<path>.phtml` in a **theme** (overriding the module).

In every `.phtml` you always have these in scope:
- `$block` — the block instance (a `Template` subclass).
- `$escaper` — `\Magento\Framework\Escaper`. Use it for **every** output.
- `$secureRenderer` — `\Magento\Framework\View\Helper\SecureHtmlRenderer`. For CSP-compliant inline styles/scripts.

Other implicit variables depend on the block. Some blocks expose helpers via `$block->getX()`.

### Escaping (critical for security)

- **HTML text content**: `$escaper->escapeHtml($value)` — escapes `< > & ' "`.
- **HTML attribute values**: `$escaper->escapeHtmlAttr($value)` — same but stricter for attribute contexts.
- **URLs**: `$escaper->escapeUrl($url)` — also strips `javascript:` etc.
- **JS context** (inline `<script>` tag with PHP-interpolated values): `$escaper->escapeJs($value)`. Use sparingly. Prefer `json_encode($value)` for data passed to JS.
- **CSS context** (inline `<style>` or `style=""`): `$escaper->escapeCss($value)`.
- **Inside an HTML attribute that holds JS** (`onclick="..."`): don't. Magento's CSP forbids inline JS in production. Use a separate `<script type="text/x-magento-init">` block or a Knockout binding.

`Magento\Framework\Escaper::escapeHtml()` accepts an optional second arg `array $allowedTags` if you want to permit `<b>`, `<a>`, etc.

### Translation
```php
<?= $escaper->escapeHtml(__('Hello world')) ?>
```
`__()` is `\Magento\Framework\Phrase::__()` (provided by `app/etc/registration_globlist.php`). Translatable strings go in `i18n/en_US.csv`:
```csv
"Hello world","Hello world"
```

For parameters:
```php
<?= $escaper->escapeHtml(__('Hello, %1', $customerName)) ?>
```

`%1`, `%2`, … positional. The CSV value can rearrange them per language.

### Including a sub-template
```php
<?= $block->getChildHtml('child.block.name') ?>
```
Or call into a registered child block defined in layout. Many sites use this to compose pages from atomic templates.

### Custom data passed via `<arguments>`
```xml
<block ...>
    <arguments>
        <argument name="title" xsi:type="string">Welcome</argument>
        <argument name="count" xsi:type="number">5</argument>
        <argument name="items" xsi:type="array">
            <item name="0" xsi:type="string">apple</item>
            <item name="1" xsi:type="string">banana</item>
        </argument>
    </arguments>
</block>
```

In the template:
```php
<?= $escaper->escapeHtml($block->getData('title')) ?>
<?php foreach ($block->getData('items') as $item): ?>
    <li><?= $escaper->escapeHtml($item) ?></li>
<?php endforeach; ?>
```

## Layout merge order

1. Magento loads ALL `layout/<handle>.xml` files across all enabled modules AND the active theme + its parents (theme inheritance).
2. Each file's `<head>`, `<body>` contents are merged together. Within `<body>`, blocks are added in order; `<referenceBlock>`/`<referenceContainer>` modify existing nodes; `<remove>` deletes them.
3. Module sequence determines load order. Theme overrides come last and win.

When you want to ADD to a block, use `<referenceBlock>`. When you want to REPLACE its template, do it from within `<referenceBlock>`:

```xml
<referenceBlock name="product.info.price">
    <action method="setTemplate">
        <argument name="template" xsi:type="string">Acme_Hello::price.phtml</argument>
    </action>
</referenceBlock>
```

Better still, override the template by path:
```
app/design/frontend/Acme/default/Magento_Catalog/templates/product/price/amount/default.phtml
```
The theme-level path mirrors the module-level path; Magento's fallback picks the theme's file first.

## Common block classes worth knowing

| Class | Use |
| --- | --- |
| `Magento\Framework\View\Element\Template` | Generic template renderer. The default. |
| `Magento\Framework\View\Element\Text` | Plain text content (no template). |
| `Magento\Framework\View\Element\Text\ListText` | Renders concatenated text of all children. |
| `Magento\Framework\View\Element\Html\Link` | `<a href="">` link. |
| `Magento\Framework\View\Element\Html\Links` | Container for `Link` children (e.g. account nav). |
| `Magento\Theme\Block\Html\Pager` | Pagination. |
| `Magento\Catalog\Block\Product\ListProduct` | Product list (category page). |
| `Magento\Catalog\Block\Product\View` | Product detail page. |
| `Magento\Cms\Block\Block` | Renders a CMS static block by identifier. |
| `Magento\Cms\Block\Widget\Block` | Same, but as a widget. |
| `Magento\Theme\Block\Html\Topmenu` | Navigation menu. |

For inserting a CMS static block from layout:
```xml
<block class="Magento\Cms\Block\Block" name="footer.legal">
    <arguments>
        <argument name="block_id" xsi:type="string">legal_links</argument>
    </arguments>
</block>
```

## Container HTML wrappers

```xml
<container name="page.main" as="main" label="Main Content Area" htmlTag="main" htmlClass="page-main" htmlId="maincontent"/>
```

Renders `<main id="maincontent" class="page-main">...</main>` around its children. Without `htmlTag`, the container is invisible (no wrapper HTML at all).

## Common gotchas

### `cache:clean layout block_html full_page` is required after layout XML changes
Even in developer mode. The layout merge cache is stickier than people expect.

### `<arguments>` types must match XSD
The XSD allows: `string`, `boolean`, `number`, `null`, `const`, `array`, `object`, `init_parameter`, `helper`. Anything else throws on `cache:clean`.

### Block name collisions silently break layout
Two blocks with the same `name` in different modules: the second one is silently ignored (or the layout merge throws, depending on the area). Always namespace block names: `acme.hello.greeting`, not `greeting`.

### `class="Magento\Framework\View\Element\Template"` is implicit
If you omit `class=""` on a `<block>`, Magento falls back to `Magento\Framework\View\Element\Template` in some contexts but errors in others. Always specify the class for explicitness.

### Templates aren't auto-reloaded in production
Editing a `.phtml` in production with `block_html` cache enabled does nothing until `cache:clean block_html` (and FPC). In developer mode, you can disable `block_html` so each request reads from disk.

### `$block->getData('foo')` vs `$block->getFoo()`
Magento magic methods auto-convert: `getData('foo_bar')` ↔ `getFooBar()`. Use whichever — both work. The string form is safer for IDE/grep ability.

### Don't put DB queries in templates
Every method called in a template runs on every render. Pre-aggregate in the block/view model. Cache results in private properties if called multiple times.

### Don't write inline `<script>` blocks for logic
Production mode often runs strict CSP that forbids inline scripts. Use:
- A `<script src="Acme_Hello::js/foo.js">` in layout `<head>`, OR
- A `<script type="text/x-magento-init">` JSON block (Magento parses it server-side and wires up modules), OR
- Knockout bindings (`data-bind="..."`) via UI components.

## Original sources

- `references/sources/commerce-frontend-core/guide/layouts/` — layout XML guide.
- `references/sources/commerce-frontend-core/guide/templates/` — templates.
- `references/sources/commerce-php/development/components/view-models.md` — view models.
- `references/sources/devdocs-v2.4/frontend-dev-guide/layouts/` — older layout guide (more examples).
- `references/sources/devdocs-v2.4/frontend-dev-guide/templates/template-walkthrough.md`
