<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/integration-guide.html -->

# Hyvä AI Integration Guide

The base module defines feature handlers, providers, registries and execution routing. Provider packages own service-specific configuration. Worker and CMS modules consume those contracts without making every provider a dependency.

Update the base/provider packages together; see [Installation](installation.html) and [Upgrade Compatibility](upgrading.html).

## Add a Short Synchronous Feature

Implement `Hyva\Ai\Api\HandlerInterface` with:

| Method | Contract |
| --- | --- |
| `getName(): string` | Stable feature identifier, for example `product_description`. |
| `getOptions(): array` | Registered model ID and model options. |
| `getData(array $requestData): array` | Validated, server-prepared provider request. |

The framework resolves the provider from the model and calls its `process()` method. An optional handler `processResponse(array $response, array $originalData): array` transforms the result; it is not a required interface method.

A handler can look like this:

```
<?php
declare(strict_types=1);

namespace Vendor\Module\Model\Handler;

use Hyva\Ai\Api\HandlerInterface;
use Magento\Framework\App\Config\ScopeConfigInterface;
use Magento\Framework\Exception\LocalizedException;

class ProductDescription implements HandlerInterface
{
    public function __construct(private readonly ScopeConfigInterface $config)
    {
    }

    public function getName(): string
    {
        return 'product_description';
    }

    public function getOptions(): array
    {
        return [
            'model' => (string) $this->config->getValue('vendor_module/ai/model'),
            'max_tokens' => 1000,
        ];
    }

    public function getData(array $requestData): array
    {
        $name = trim((string) ($requestData['product_name'] ?? ''));
        if ($name === '' || strlen($name) > 500) {
            throw new LocalizedException(__('Enter a product name of at most 500 bytes.'));
        }

        return ['messages' => [[
            'messages' => [
                ['role' => 'system', 'content' => 'Write a short product description without inventing specifications.'],
                ['role' => 'user', 'content' => $name],
            ],
        ]]];
    }

    public function processResponse(array $response, array $originalData): array
    {
        return ['description' => $response['responses'][0] ?? ''];
    }
}
```

Register the handler in `etc/di.xml`:

```
<?xml version="1.0"?>
<config xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:noNamespaceSchemaLocation="urn:magento:framework:ObjectManager/etc/config.xsd">
    <type name="Hyva\Ai\Controller\Adminhtml\Ai\Process">
        <arguments>
            <argument name="handlers" xsi:type="array">
                <item name="product_description" xsi:type="object">Vendor\Module\Model\Handler\ProductDescription</item>
            </argument>
        </arguments>
    </type>
</config>
```

Generate the admin URL server-side with the route `hyva_ai/ai/process` and `handler=product_description`. Do not hard-code the admin front name or secret-key segment. Post `data` as JSON inside the form-encoded request, with the admin form key:

```
async function generateDescription(processUrl, formKey, productName) {
    const response = await fetch(processUrl, {
        method: 'POST',
        credentials: 'same-origin',
        body: new URLSearchParams({
            form_key: formKey,
            data: JSON.stringify({ product_name: productName }),
        }),
    });
    if (!response.ok) throw new Error('The AI request could not be completed.');
    const result = await response.json();
    if (!result.success) throw new Error(result.message);
    return result.data.description;
}
```

The built-in controller uses `Magento_Backend::content` ACL and returns a JSON envelope with `success`, `provider`, `handler`, `data`, `count` and `message` on success. Error envelopes contain `success: false` and a message. Feature-specific entity permissions and output validation remain your responsibility. Generating text is not authorisation to save or publish it.

The example returns a proposal.

Validate generated content before saving it

A saving controller must enforce its own form-key, ACL, entity and content validation. Do not render generated text as trusted HTML.

## Feature Execution Overrides

`Hyva\Ai\Model\ExecutionConfig::getMode($feature)` resolves:

1. `hyva_ai/<feature>/execution_mode` when present and not `default`.
2. `hyva_ai/execution/mode`.
3. `legacy` if the general value is absent.

Handler controller execution is scoped by the registered handler name, including the configured check and provider call. Handler options also gain `_execution_feature` for server-side calls. For a custom entry point, use `ExecutionConfig::withFeature()` around the complete configured-check/call operation; it restores the previous context even on failure.

A transport that does not support a provider leaves that provider on its direct route. A missing selected transport is an error. AI Worker handles its own runtime selection: configured Node/Cloudflare takes priority, with PHP worker backup when enabled. Provider failures are reported without switching providers or using the direct PHP adapter. Providers and transports must use bounded requests. The synchronous path still waits in PHP; use [worker sessions or jobs](../../../hyva-commerce/features/ai-worker/developer-integration.html) for longer work.

## Add a Provider Package

Keep service-specific classes, encrypted credential fields, model lists, schemas and tests in that provider's module. Require the base AI module, not other providers or CMS. Add worker/CMS dependencies only when the package actually needs those APIs.

Implement `Hyva\Ai\Api\ProviderInterface`:

```
interface ProviderInterface
{
    public function process(array $data, array $options = []): array;
    public function isConfigured(): bool;
    public function getName(): string;
}
```

Register the implementation in `Hyva\Ai\Model\ProviderPool.providers`, keyed by provider ID. The standard message shape is an array of batches, each containing `messages`; return `['responses' => ['text for batch one', 'text for batch two']]` in the same order.

Use `ProviderConfigInterface` for provider defaults: `getProviderName()`, `getDefaultModel()`, `getDefaultTemperature()` and `getDefaultMaxTokens()`. Register the config in `RouteProviderRequests.providerConfigs` so routed calls that omit options retain the provider's defaults.

A direct adapter should use the shared request budget, close active sessions before network I/O, bound connection/read time and retries, and reject incomplete responses. Do not extend PHP/server execution limits in a provider implementation.

## Register Models and Options

Merge entries into `Hyva\Ai\Model\ProviderResolver.providerModels` under your provider ID:

| Entry | Meaning |
| --- | --- |
| `source_model` | Existing provider model-source class implementing `OptionSourceInterface`. It must accept the configured options in its constructor for the resolver's source path. |
| `options` | Model entries with `value` and `label`. |
| `display_label` | Label used by the guided provider picker. |
| `direct` | Whether the catalog should expose direct execution; defaults to true. |
| `worker_adapter` | Declare true only when the deployed worker supports this provider protocol. |

`ModelCatalog` consumes these registrations. Its optional `metadata` argument is keyed by model ID with `current`, `capabilities` (such as `text` and `translation`) and `hidden_options`. Unannotated third-party models are visible by default. Metadata changes the picker; it does not prove account availability or implement an adapter.

Implement `Hyva\Ai\Api\Provider\OptionsSchemaInterface` and register in `Hyva\Ai\Model\Provider\OptionsSchemaPool.schemas`. Extending `AbstractOptionsSchema` supplies type normalization based on field definitions; an integer default keeps a numeric option integer-valued. Schemas provide `getProviderId()`, `getFields()` and `normalizeOptions()`.

The existing `ProviderOptions` block constructor/virtual-type configuration remains supported. Optional `capability` and `workerOnly` arguments narrow the picker for a feature.

## Credentials, Images and Connection Tests

| Contract/registry | Registration and responsibility |
| --- | --- |
| `Hyva\Ai\Api\ProviderApiKeyResolverInterface` | Implement `getApiKey($store = null): string` and `isConfigured($store = null): bool`. Register in `Hyva\Ai\Model\ApiKeyResolverPool.resolvers`. |
| `ConfigPathApiKeyResolver` | Base virtual-type implementation in `Hyva\Ai\Model\ApiKeyResolver`, configured with `configPath` and `envVar` (pass an empty string when no environment override is needed). Keeps provider ownership separate from the worker. |
| `Hyva\Ai\Model\Provider\StreamDialectPool.dialects` | Provider-owned PHP request encoding, model validation and SSE parsing through `StreamDialectInterface`. |
| `Hyva\Ai\Model\Provider\ImageDialectPool.dialects` | Provider-owned PHP image request/response handling through `ImageDialectInterface`. Neither registration requires the worker package. |
| `Hyva\Ai\Model\ImageModelRegistry.models` | Entries keyed by model ID with `provider`, `label` and optional `current`. A runtime image adapter is separately required. |
| `Hyva\Ai\Api\ConnectionTesterInterface` | Implement `test(string $model): void`, returning normally on success or throwing an appropriate localized failure. Register in `ConnectionTesterPool.testers`. |

Connection tests belong to the provider package and use its saved credential. The shared connection-test controller checks a registered model and configuration ACL. Test with the least expensive operation that proves the intended capability. DeepL checks usage without sending translation text; the text providers make a small direct model request.

## Extend Execution or Tools

Implement `RequestTransportInterface` with `supports(string $provider): bool` and `process(string $provider, array $data, array $options = []): array`. Register it in `Hyva\Ai\Plugin\RouteProviderRequests.transports` and label it in `Hyva\Ai\Model\Config\Source\ExecutionMode.transports`.

For tool routing, implement `ToolTransportInterface`, which adds `chatWithTools(string $provider, array $messages, array $tools, array $options = []): array`. Providers that expose native tools implement `ToolCapableProviderInterface`. Its return shape is text, tool calls and an optional stop reason; tool-call arguments must be validated by the feature before any execution.

The legacy `worker` provider and its saved underlying provider/model selections remain supported. New transport integrations should keep the real provider/model choice separate from the execution method.
