# Admin Area Development

The admin (`adminhtml`) area is its own world: separate routing, separate layout XML, an ACL-driven menu, a configuration tree at **Stores → Configuration**, and a UI-component-driven grid/form pattern for every admin page. The same module can serve both frontend and admin content; just keep the area-scoped files in their right folders.

## Admin routing

`etc/adminhtml/routes.xml`:
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:App/etc/routes.xsd">
    <router id="admin">
        <route id="acme_giftwrap" frontName="giftwrap">
            <module name="Acme_GiftWrap"/>
        </route>
    </router>
</config>
```

- `frontName` — the URL segment after the admin path. `<admin_url>/giftwrap/messages/index/` maps to controller `Controller/Adminhtml/Messages/Index`.
- `route id` — a logical name. Module references look up by this.
- `router id="admin"` (admin) vs `id="standard"` (frontend).

URL structure:
```
<admin_url>/<frontName>/<controller>/<action>/key/<form_key>/
```

Examples:
- `acme_giftwrap/messages/index` → `Acme\GiftWrap\Controller\Adminhtml\Messages\Index::execute()`
- `acme_giftwrap/messages/save` → `Acme\GiftWrap\Controller\Adminhtml\Messages\Save::execute()`

The admin URL has a randomized prefix (`admin_dr3kp_abc/...`) for security. Get it programmatically:
```php
$url = $this->urlBuilder->getUrl('acme_giftwrap/messages/index');
```

## Admin controllers

Each action is its own class extending `\Magento\Backend\App\Action`:

```php
<?php
declare(strict_types=1);

namespace Acme\GiftWrap\Controller\Adminhtml\Messages;

use Magento\Backend\App\Action;
use Magento\Backend\App\Action\Context;
use Magento\Framework\View\Result\PageFactory;
use Magento\Framework\Controller\ResultInterface;

class Index extends Action
{
    public const ADMIN_RESOURCE = 'Acme_GiftWrap::messages';

    public function __construct(
        Context $context,
        private readonly PageFactory $pageFactory
    ) {
        parent::__construct($context);
    }

    public function execute(): ResultInterface
    {
        $resultPage = $this->pageFactory->create();
        $resultPage->setActiveMenu('Acme_GiftWrap::messages');
        $resultPage->getConfig()->getTitle()->prepend(__('Gift Wrap Messages'));
        $resultPage->addBreadcrumb(__('Gift Wrap'), __('Gift Wrap'));
        $resultPage->addBreadcrumb(__('Messages'), __('Messages'));
        return $resultPage;
    }
}
```

The `ADMIN_RESOURCE` constant gates the action: the logged-in admin user must have permission to that ACL resource (defined in `acl.xml`).

For a save action:
```php
class Save extends Action implements HttpPostActionInterface
{
    public const ADMIN_RESOURCE = 'Acme_GiftWrap::messages_write';

    public function __construct(
        Context $context,
        private readonly MessageRepositoryInterface $messageRepository,
        private readonly MessageInterfaceFactory $messageFactory
    ) {
        parent::__construct($context);
    }

    public function execute(): ResultInterface
    {
        $data = $this->getRequest()->getPostValue();
        $resultRedirect = $this->resultRedirectFactory->create();
        try {
            $id = (int) ($data['entity_id'] ?? 0);
            $message = $id
                ? $this->messageRepository->getById($id)
                : $this->messageFactory->create();
            $message->setData($data);
            $this->messageRepository->save($message);
            $this->messageManager->addSuccessMessage(__('Saved.'));
            return $resultRedirect->setPath('*/*/index');
        } catch (\Throwable $e) {
            $this->messageManager->addErrorMessage($e->getMessage());
            return $resultRedirect->setPath('*/*/edit', ['id' => $data['entity_id'] ?? null]);
        }
    }
}
```

`HttpPostActionInterface` (and friends `HttpGetActionInterface`, `HttpPutActionInterface`, etc.) restrict the action to one HTTP verb. Always implement them for write actions to avoid CSRF surprises.

`$this->messageManager` is built into `Backend\App\Action`. Use `addSuccessMessage`, `addErrorMessage`, `addNoticeMessage`, `addWarningMessage` for flash messages.

## Admin menu — `etc/adminhtml/menu.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Backend:etc/menu.xsd">
    <menu>
        <add id="Acme_GiftWrap::root"
             title="Gift Wrap"
             module="Acme_GiftWrap"
             sortOrder="100"
             resource="Acme_GiftWrap::messages"/>
        <add id="Acme_GiftWrap::messages"
             title="Messages"
             module="Acme_GiftWrap"
             sortOrder="10"
             parent="Acme_GiftWrap::root"
             action="acme_giftwrap/messages/index"
             resource="Acme_GiftWrap::messages"/>
        <add id="Acme_GiftWrap::config"
             title="Configuration"
             module="Acme_GiftWrap"
             sortOrder="999"
             parent="Acme_GiftWrap::root"
             action="adminhtml/system_config/edit/section/acme_giftwrap"
             resource="Acme_GiftWrap::messages"/>
    </menu>
</config>
```

- `id` matches the ACL resource ID.
- `parent` references a parent menu's `id`. Top-level items omit `parent` (or, to nest under an existing top item, set `parent` to that one).
- `action` is the controller path. Top-level placeholder items (`Acme_GiftWrap::root`) omit `action` — clicking them just expands the submenu.
- `sortOrder` controls ordering within the parent.
- `resource` is the ACL resource required to see the menu item.

Common parent menu IDs to nest under:
- `Magento_Catalog::catalog` — Catalog menu.
- `Magento_Sales::sales` — Sales menu.
- `Magento_Customer::customer` — Customers menu.
- `Magento_Backend::content` — Content menu.
- `Magento_Backend::stores` — Stores menu.
- `Magento_Backend::system` — System menu.
- `Magento_Reports::report` — Reports menu.

## ACL — `etc/acl.xml`

Already covered in `rest-graphql-webapi.md`. To recap:

```xml
<config>
    <acl>
        <resources>
            <resource id="Magento_Backend::admin">
                <resource id="Acme_GiftWrap::root" title="Gift Wrap" sortOrder="100">
                    <resource id="Acme_GiftWrap::messages" title="View Messages"/>
                    <resource id="Acme_GiftWrap::messages_write" title="Edit Messages"/>
                </resource>
            </resource>
        </resources>
    </acl>
</config>
```

These resource IDs appear in **System → Permissions → User Roles** for the admin to assign to roles.

## System Configuration — `etc/adminhtml/system.xml`

Defines the **Stores → Configuration → [your section]** tree.

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Config:etc/system_file.xsd">
    <system>
        <tab id="acme" translate="label" sortOrder="100">
            <label>Acme</label>
        </tab>
        <section id="acme_giftwrap"
                 translate="label"
                 type="text"
                 sortOrder="10"
                 showInDefault="1"
                 showInWebsite="1"
                 showInStore="1">
            <label>Gift Wrap</label>
            <tab>acme</tab>
            <resource>Acme_GiftWrap::messages</resource>

            <group id="general"
                   translate="label"
                   type="text"
                   sortOrder="10"
                   showInDefault="1"
                   showInWebsite="1"
                   showInStore="1">
                <label>General</label>

                <field id="enabled"
                       translate="label comment"
                       type="select"
                       sortOrder="10"
                       showInDefault="1"
                       showInWebsite="1"
                       showInStore="1">
                    <label>Enabled</label>
                    <source_model>Magento\Config\Model\Config\Source\Yesno</source_model>
                    <comment>Turn on gift wrap.</comment>
                </field>

                <field id="api_key"
                       translate="label comment"
                       type="obscure"
                       sortOrder="20"
                       showInDefault="1"
                       showInWebsite="0"
                       showInStore="0">
                    <label>API Key</label>
                    <backend_model>Magento\Config\Model\Config\Backend\Encrypted</backend_model>
                    <comment>Stored encrypted.</comment>
                </field>

                <field id="default_message"
                       translate="label"
                       type="text"
                       sortOrder="30"
                       showInDefault="1"
                       showInWebsite="1"
                       showInStore="1">
                    <label>Default Message</label>
                </field>
            </group>
        </section>
    </system>
</config>
```

Pair with `etc/config.xml` for defaults:
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Store:etc/config.xsd">
    <default>
        <acme_giftwrap>
            <general>
                <enabled>1</enabled>
                <default_message>Happy Birthday</default_message>
            </general>
        </acme_giftwrap>
    </default>
</config>
```

### Reading config values from PHP
```php
public function __construct(
    private readonly \Magento\Framework\App\Config\ScopeConfigInterface $scopeConfig,
    private readonly \Magento\Framework\Encryption\EncryptorInterface $encryptor
) {}

public function isEnabled(?int $storeId = null): bool
{
    return $this->scopeConfig->isSetFlag(
        'acme_giftwrap/general/enabled',
        \Magento\Store\Model\ScopeInterface::SCOPE_STORE,
        $storeId
    );
}

public function getApiKey(?int $storeId = null): string
{
    $encrypted = (string) $this->scopeConfig->getValue(
        'acme_giftwrap/general/api_key',
        \Magento\Store\Model\ScopeInterface::SCOPE_STORE,
        $storeId
    );
    return $this->encryptor->decrypt($encrypted);
}
```

`isSetFlag` returns bool. `getValue` returns string|null. Always pass `SCOPE_STORE` (or `SCOPE_WEBSITE`/`default`) for proper inheritance.

### `system.xml` field types
- `text`, `textarea`, `select`, `multiselect`, `password`, `obscure` (masked), `image`, `file`, `date`, `time`, `note` (read-only label), `button`.
- For `select`/`multiselect`, set `<source_model>` to a class implementing `\Magento\Framework\Option\ArrayInterface` with a `toOptionArray()` returning `[['value' => 'x', 'label' => 'X']]`.

### `<show_in_*>` matters
- `showInDefault="1"` — visible at Default scope.
- `showInWebsite="1"` — visible at Website scope.
- `showInStore="1"` — visible at Store View scope.

For website-wide secrets (API keys), set `showInWebsite="0" showInStore="0"`. Encrypted fields should usually only show at default scope.

### Sensitive config — `config:sensitive:set`
For values you DON'T want in `config.php` (committed), mark them in `etc/config.xml`:
```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Store:etc/config.xsd">
    <sensitive>
        <acme_giftwrap>
            <general>
                <api_key>1</api_key>
            </general>
        </acme_giftwrap>
    </sensitive>
</config>
```

The value will be stored in `env.php` (NOT committed) and exposed via `bin/magento config:sensitive:set acme_giftwrap/general/api_key xxx`.

## Admin UI components — Grids and Forms

Already covered structurally in `frontend-js-and-ui.md`. The admin-specific parts:

### File locations
```
view/adminhtml/ui_component/acme_giftwrap_message_listing.xml
view/adminhtml/ui_component/acme_giftwrap_message_form.xml
view/adminhtml/layout/acme_giftwrap_messages_index.xml          ← listing layout
view/adminhtml/layout/acme_giftwrap_messages_edit.xml           ← form layout
view/adminhtml/layout/acme_giftwrap_messages_new.xml            ← new entity layout (often a 1-line include)
```

### Layout: listing page
```xml
<?xml version="1.0"?>
<page xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:noNamespaceSchemaLocation="urn:magento:framework:View/Layout/etc/page_configuration.xsd">
    <update handle="styles"/>
    <body>
        <referenceContainer name="content">
            <uiComponent name="acme_giftwrap_message_listing"/>
        </referenceContainer>
    </body>
</page>
```

### Layout: edit page
```xml
<page>
    <update handle="styles"/>
    <body>
        <referenceContainer name="content">
            <uiComponent name="acme_giftwrap_message_form"/>
        </referenceContainer>
    </body>
</page>
```

### Layout: new page (reuse edit handle)
```xml
<page>
    <update handle="acme_giftwrap_messages_edit"/>
</page>
```

### DataProvider for the form
The form's `<dataSource>` calls a DataProvider class:

```php
namespace Acme\GiftWrap\Model\Message;

use Magento\Ui\DataProvider\AbstractDataProvider;

class DataProvider extends AbstractDataProvider
{
    public function __construct(
        $name,
        $primaryFieldName,
        $requestFieldName,
        \Acme\GiftWrap\Model\ResourceModel\Message\CollectionFactory $collectionFactory,
        array $meta = [],
        array $data = []
    ) {
        $this->collection = $collectionFactory->create();
        parent::__construct($name, $primaryFieldName, $requestFieldName, $meta, $data);
    }

    public function getData(): array
    {
        if (!empty($this->loadedData)) {
            return $this->loadedData;
        }
        foreach ($this->collection->getItems() as $item) {
            $this->loadedData[$item->getEntityId()] = $item->getData();
        }
        return $this->loadedData ?: [];
    }
}
```

The grid's `<dataProvider>` uses the generic Magento DataProvider; the form's uses your custom one to load a single record.

### Save/Delete/Back buttons
Buttons in the form are implementations of `\Magento\Framework\View\Element\UiComponent\Control\ButtonProviderInterface`:

```php
namespace Acme\GiftWrap\Block\Adminhtml\Edit;

use Magento\Framework\View\Element\UiComponent\Control\ButtonProviderInterface;

class SaveButton implements ButtonProviderInterface
{
    public function getButtonData(): array
    {
        return [
            'label' => __('Save'),
            'class' => 'save primary',
            'data_attribute' => [
                'mage-init' => ['button' => ['event' => 'save']],
                'form-role' => 'save'
            ],
            'sort_order' => 90
        ];
    }
}
```

The `data_attribute mage-init button event=save` triggers the form's save event, which posts to the URL specified in `<submitUrl>` of the form's dataSource (typically `*/*/save`).

### Grid actions column
Renders inline action links in the grid:

```php
namespace Acme\GiftWrap\Ui\Component\Listing\Column;

use Magento\Ui\Component\Listing\Columns\Column;

class Actions extends Column
{
    public function __construct(
        \Magento\Framework\View\Element\UiComponent\ContextInterface $context,
        \Magento\Framework\View\Element\UiComponentFactory $uiComponentFactory,
        private readonly \Magento\Framework\UrlInterface $urlBuilder,
        array $components = [],
        array $data = []
    ) {
        parent::__construct($context, $uiComponentFactory, $components, $data);
    }

    public function prepareDataSource(array $dataSource): array
    {
        if (isset($dataSource['data']['items'])) {
            foreach ($dataSource['data']['items'] as &$item) {
                $name = $this->getData('name');
                if (isset($item['entity_id'])) {
                    $item[$name]['edit'] = [
                        'href' => $this->urlBuilder->getUrl('*/*/edit', ['id' => $item['entity_id']]),
                        'label' => __('Edit')
                    ];
                    $item[$name]['delete'] = [
                        'href' => $this->urlBuilder->getUrl('*/*/delete', ['id' => $item['entity_id']]),
                        'label' => __('Delete'),
                        'confirm' => [
                            'title' => __('Delete?'),
                            'message' => __('Are you sure?')
                        ]
                    ];
                }
            }
        }
        return $dataSource;
    }
}
```

## Form keys and CSRF

Admin POSTs are CSRF-protected via a session form key. UI components add it automatically. If you write a raw form, include:
```html
<input type="hidden" name="form_key" value="<?= $block->getFormKey() ?>"/>
```

For admin AJAX, send `Mage-Form-Key` header or `?form_key=...` query. URL helper auto-adds `/key/<form_key>/` when building admin URLs.

## CSRF and the `_isAllowed` legacy

Old admin controllers extended `Magento\Backend\App\Action` and overrode `_isAllowed()`:
```php
protected function _isAllowed(): bool
{
    return $this->_authorization->isAllowed('Acme_GiftWrap::messages');
}
```

Modern controllers use the `ADMIN_RESOURCE` constant. Both work; the constant is cleaner.

## Email templates — `etc/email_templates.xml`

```xml
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:module:Magento_Email:etc/email_templates.xsd">
    <template id="acme_giftwrap_email_admin_alert"
              label="Gift Wrap Admin Alert"
              file="admin_alert.html"
              type="html"
              module="Acme_GiftWrap"
              area="adminhtml"/>
</config>
```

Template file at `view/adminhtml/email/admin_alert.html`:
```html
<!--@subject Gift wrap added: {{var order_id}} @-->
<!--@vars {
"var order_id":"Order ID",
"var message":"Message text"
} @-->
{{template config_path="design/email/header_template"}}

<p>Order {{var order_id}} included a gift wrap message:</p>
<blockquote>{{var message}}</blockquote>

{{template config_path="design/email/footer_template"}}
```

Send via `\Magento\Framework\Mail\Template\TransportBuilder` (inject and use `setTemplateIdentifier('acme_giftwrap_email_admin_alert')->setTemplateVars(['order_id' => ...])->addTo(...)` etc.).

## Common gotchas

### Menu item doesn't show
- ACL `<resource>` doesn't exist in `acl.xml`.
- Admin user's role doesn't have the resource enabled — check **System → User Roles**.
- Wrong `parent` ID — typo silently fails.
- Cache: `bin/magento cache:flush`.

### Save action throws CSRF / form key error
- The form didn't include the form_key (UI components add it; raw forms must).
- `<route id>` doesn't match the URL frontName.
- Old session, hard refresh, log in again.

### Grid is empty even though data exists
- The collection registered in `di.xml` doesn't exist or doesn't extend the right base.
- `<dataProvider>` class path is wrong.
- The collection's `_idFieldName` doesn't match `primaryFieldName` in XML.

### "Resource not found" 404 after adding controller
- `routes.xml` is in `etc/` not `etc/adminhtml/` — wrong area.
- `cache:clean config` not run.
- Controller class file is named wrong / wrong namespace.

### System config field invisible
- `<resource>` on the section doesn't match the admin user's permissions.
- `showInDefault="0"` and you're at default scope.
- The field's parent group has `showInDefault="0"`.

### Encrypted config value returns garbage / errors
- Encryption key changed (`app/etc/env.php` `crypt/key` rotated). Encrypted values become unreadable. Either keep the old key or re-set the values.

### `setActiveMenu` doesn't highlight the right item
The ID must match the menu's full ID, including parent path. `setActiveMenu('Acme_GiftWrap::messages')` not `'messages'`.

### Form "back" button leaves the form via JS
The "back" button uses `data-attribute mage-init button event=back`. The form catches this and redirects. If the form is dirty, the user gets an "unsaved changes" prompt.

## Original sources

- `references/sources/commerce-frontend-core/ui-components/` — UI components.
- `references/sources/commerce-php/development/components/add-admin-grid.md` — admin grid walkthrough.
- `references/sources/commerce-php/development/components/routing.md` — routing internals.
- `references/sources/devdocs-v2.4/ui_comp_guide/` — extensive admin UI component reference.
- `references/sources/devdocs-v2.4/config-guide/` — `system.xml` and config tree.
