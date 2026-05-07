# Displaying store opening hours in the Hyvä footer

The Hyvä way to expose store-config values to a template is a **view model** — a tiny PHP class that lives in a module and is fetched in any `.phtml` via `$viewModels->require(...)`. No layout XML `<arguments>` block, no block-class subclass, no Knockout. Once the view model exists, any template (footer, contact page, account, an Alpine `x-data` blob, anywhere) can consume it.

Below is the complete, reusable solution, plus a "shortcut" version that skips the custom module entirely by reusing Hyvä's built-in `StoreConfig` view model.

---

## Recommended approach: a small `Acme_StoreInfo` module + view model

This is the most reusable shape: anyone on your team writing another `.phtml` (account dashboard, contact page, "About us" CMS block, an Alpine component) can pull the same view model with one line.

### 1. The module skeleton

`app/code/Acme/StoreInfo/registration.php`

```php
<?php
declare(strict_types=1);

\Magento\Framework\Component\ComponentRegistrar::register(
    \Magento\Framework\Component\ComponentRegistrar::MODULE,
    'Acme_StoreInfo',
    __DIR__
);
```

`app/code/Acme/StoreInfo/etc/module.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:Module/etc/module.xsd">
    <module name="Acme_StoreInfo" setup_version="1.0.0"/>
</config>
```

### 2. The view model

`app/code/Acme/StoreInfo/ViewModel/StoreHours.php`

```php
<?php
declare(strict_types=1);

namespace Acme\StoreInfo\ViewModel;

use Magento\Framework\App\Config\ScopeConfigInterface;
use Magento\Framework\View\Element\Block\ArgumentInterface;
use Magento\Store\Model\ScopeInterface;

class StoreHours implements ArgumentInterface
{
    public const XML_PATH_HOURS = 'general/store_information/hours';

    public function __construct(
        private readonly ScopeConfigInterface $scopeConfig
    ) {
    }

    /**
     * Raw value as configured in Stores > Configuration > General > Store Information > Hours of Operation.
     * May be empty, may contain newlines (textarea field).
     */
    public function getHours(): string
    {
        return trim((string) $this->scopeConfig->getValue(
            self::XML_PATH_HOURS,
            ScopeInterface::SCOPE_STORE
        ));
    }

    public function hasHours(): bool
    {
        return $this->getHours() !== '';
    }

    /**
     * Newline-separated lines (the admin textarea is multi-line) — handy for rendering
     * each line as its own row without HTML in config.
     *
     * @return string[]
     */
    public function getHoursLines(): array
    {
        $hours = $this->getHours();
        if ($hours === '') {
            return [];
        }
        // Split on any line ending, drop blank lines, trim whitespace.
        $lines = preg_split('/\R/u', $hours) ?: [];
        return array_values(array_filter(array_map('trim', $lines), static fn ($l) => $l !== ''));
    }
}
```

Why a custom view model when Hyvä already ships `Hyva\Theme\ViewModel\StoreConfig`? Two reasons:

1. **Reusability surface.** You get a typed `getHoursLines()` helper that any template (or test) can call without duplicating the `preg_split` logic.
2. **Domain naming.** `$storeHours->getHoursLines()` reads better in a template than `$storeConfig->getStoreConfig('general/store_information/hours')`.

If you want the zero-module shortcut, see ["Even shorter: skip the module"](#even-shorter-skip-the-module-and-use-hyvas-storeconfig) at the end.

### 3. The footer template

Put the partial in your **child theme** (never edit `vendor/hyva-themes/...`). Mirror the Magento module path inside the theme.

`app/design/frontend/Acme/default/Magento_Theme/templates/html/footer/store-hours.phtml`

```php
<?php
declare(strict_types=1);

use Acme\StoreInfo\ViewModel\StoreHours;
use Hyva\Theme\Model\ViewModelRegistry;

/** @var \Magento\Framework\View\Element\Template $block */
/** @var \Magento\Framework\Escaper $escaper */
/** @var ViewModelRegistry $viewModels */

/** @var StoreHours $storeHours */
$storeHours = $viewModels->require(StoreHours::class);

if (!$storeHours->hasHours()) {
    return;
}

$lines = $storeHours->getHoursLines();
?>
<section
    class="text-sm text-gray-600 leading-relaxed"
    aria-labelledby="footer-store-hours-heading"
>
    <h3 id="footer-store-hours-heading" class="font-semibold text-gray-800 mb-2">
        <?= $escaper->escapeHtml(__('Opening hours')) ?>
    </h3>
    <ul class="space-y-1">
        <?php foreach ($lines as $line): ?>
            <li><?= $escaper->escapeHtml($line) ?></li>
        <?php endforeach; ?>
    </ul>
</section>
```

A couple of points to notice:

- `$viewModels`, `$block`, and `$escaper` are always in scope in a Hyvä `.phtml`. The `/** @var */` annotations buy you IDE type-checking — keep them.
- The template is **defensive** about empty config (`return` early). Otherwise an empty footer column with just a heading shows up.
- Always `escapeHtml` user-controlled text (the admin field counts).
- Tailwind utility classes (`text-sm`, `text-gray-600`, `space-y-1`, etc.) — no Luma `_module.less` partials.

### 4. Wire it into the footer via `hyva_default.xml`

Use the **`hyva_*` prefixed handle** so this only applies to Hyvä storefronts (a future Luma store view will not see it).

`app/design/frontend/Acme/default/Magento_Theme/layout/hyva_default.xml`

```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <body>
        <referenceContainer name="footer">
            <block name="footer.store.hours"
                   template="Magento_Theme::html/footer/store-hours.phtml"/>
        </referenceContainer>
    </body>
</page>
```

Notes:

- Container `footer` is the Hyvä default footer container. If you have a custom footer with its own containers (e.g. `footer.column.contact`) point `referenceContainer` there instead.
- No `<arguments><argument name="view_model" xsi:type="object">...</argument></arguments>` block. Hyvä's `$viewModels->require()` makes that XML noise unnecessary for 99% of view models — and avoiding it means the next dev who reads the file doesn't have to chase across XML to find which class is in play.

### 5. Activate

```bash
bin/magento module:enable Acme_StoreInfo
bin/magento setup:upgrade
bin/magento cache:flush
# Production only:
bin/magento setup:di:compile
bin/magento setup:static-content:deploy -f Acme/default
```

If you added new Tailwind utility classes that weren't already in scanned templates, rebuild from the child theme:

```bash
npm --prefix app/design/frontend/Acme/default/web/tailwind run build
# or during development:
npm --prefix app/design/frontend/Acme/default/web/tailwind run watch
```

(Tailwind v4 in Hyvä 1.4 only emits classes it can statically discover. Since the classes here are written literally in the `.phtml`, they'll be picked up — no safelist needed.)

---

## Why this is "the Hyvä way"

| Concern | What we did | Why |
| --- | --- | --- |
| Where does the data come from? | A view model (`ArgumentInterface`) in a module | Reusable in any `.phtml` via `$viewModels->require(...)`. No template subclassing, no `Block\Template` boilerplate. |
| Where does the markup live? | Child theme `Magento_Theme/templates/html/footer/store-hours.phtml` | Customizations belong in the child theme, never in `vendor/hyva-themes/...`. |
| Where is it wired into the page? | `hyva_default.xml` (the Hyvä-only handle) | Won't accidentally affect a Luma store view that shares the install. |
| Are FPC cache tags needed? | No | The data comes from `core_config_data`. Magento invalidates the FPC `CONFIG` tag automatically when an admin saves system config — no `IdentityInterface` needed on the view model. |
| Does the block need to be uncacheable? | No | This is the same value for every visitor on a given store; let it be cached with the rest of the footer. |
| Translations? | `__('Opening hours')` | Same as Luma. The configured hours value itself is admin-edited per store view, so it's already store-localized. |
| Escaping? | `escapeHtml()` everywhere | Always. The hours field is admin-controlled but escape anyway. |

---

## Reusing the same view model elsewhere

Because it's a view model, any other template can pull it in one line — that's the payoff.

### In the contact page CMS block

If you render a CMS-block-driven contact page through a `.phtml`:

```php
<?php
$storeHours = $viewModels->require(\Acme\StoreInfo\ViewModel\StoreHours::class);
?>
<dl class="contact-meta">
    <dt><?= $escaper->escapeHtml(__('Hours')) ?></dt>
    <dd><?= nl2br($escaper->escapeHtml($storeHours->getHours())) ?></dd>
</dl>
```

### Passing the data into an Alpine component

If the footer needs an interactive "Open now / Closed" badge driven by the same hours, hand the lines to Alpine via JSON in `x-data`:

```php
<?php
$storeHours = $viewModels->require(\Acme\StoreInfo\ViewModel\StoreHours::class);
$payload = ['lines' => $storeHours->getHoursLines()];
?>
<div x-data='<?= $escaper->escapeHtmlAttr(json_encode($payload, JSON_THROW_ON_ERROR)) ?>'>
    <ul>
        <template x-for="(line, i) in lines" :key="i">
            <li x-text="line"></li>
        </template>
    </ul>
</div>
```

(Single quotes around `x-data` so the JSON's double quotes don't conflict; `JSON_THROW_ON_ERROR` so encoding failures aren't silent.)

### From a custom block class

```php
$storeHours = $this->_viewModelRegistry->require(\Acme\StoreInfo\ViewModel\StoreHours::class);
```

…where `_viewModelRegistry` is `\Hyva\Theme\Model\ViewModelRegistry` injected via constructor.

---

## Even shorter: skip the module and use Hyvä's `StoreConfig`

If you genuinely don't want a custom module, Hyvä already ships `Hyva\Theme\ViewModel\StoreConfig`. The footer template becomes:

`app/design/frontend/Acme/default/Magento_Theme/templates/html/footer/store-hours.phtml`

```php
<?php
declare(strict_types=1);

use Hyva\Theme\Model\ViewModelRegistry;
use Hyva\Theme\ViewModel\StoreConfig;

/** @var \Magento\Framework\Escaper $escaper */
/** @var ViewModelRegistry $viewModels */

/** @var StoreConfig $storeConfig */
$storeConfig = $viewModels->require(StoreConfig::class);

$hours = trim((string) $storeConfig->getStoreConfig('general/store_information/hours'));
if ($hours === '') {
    return;
}

$lines = array_values(array_filter(array_map('trim', preg_split('/\R/u', $hours) ?: [])));
?>
<section class="text-sm text-gray-600 leading-relaxed">
    <h3 class="font-semibold text-gray-800 mb-2">
        <?= $escaper->escapeHtml(__('Opening hours')) ?></h3>
    <ul class="space-y-1">
        <?php foreach ($lines as $line): ?>
            <li><?= $escaper->escapeHtml($line) ?></li>
        <?php endforeach; ?>
    </ul>
</section>
```

Layout XML is the same as above.

The trade-off: every place that wants the same data has to repeat the `preg_split`/`trim` line-splitting logic, and the path string `general/store_information/hours` is duplicated in every consumer. If only the footer ever needs the value, that's fine. As soon as you have a second consumer (contact page, header, account dashboard, an email template adapter, an Alpine component), promote it to the named `StoreHours` view model in the recommended approach above.

---

## File checklist

```
app/code/Acme/StoreInfo/
  registration.php
  etc/module.xml
  ViewModel/StoreHours.php

app/design/frontend/Acme/default/
  Magento_Theme/
    layout/hyva_default.xml
    templates/html/footer/store-hours.phtml
```

After the files are in place:

```bash
bin/magento module:enable Acme_StoreInfo
bin/magento setup:upgrade
bin/magento cache:flush
```

Then load any storefront page and the hours appear in the footer. Edit them at **Stores > Configuration > General > General > Store Information > Hours of Operation** — the FPC's `CONFIG` tag invalidates on save, so the change shows on the next request.
