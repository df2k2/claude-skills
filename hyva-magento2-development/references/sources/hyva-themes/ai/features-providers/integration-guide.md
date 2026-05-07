<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/integration-guide.html -->

# Hyvä AI Providers Integration Guide

This guide covers how to integrate new AI providers and create custom AI-powered features using the Hyvä AI framework.

## Why This Architecture?

The Hyvä AI framework provides a clean, secure way to add AI features without reinventing the wheel every time.

### Single Secure Endpoint

All AI requests go through one admin controller:

```
POST /admin/hyva_ai/ai/process/handler/{your_handler}
```

You don't write controllers that call AI APIs directly. Instead, you register a handler and the framework does the rest:

- **ACL protected** - Uses Magento's `Magento_Backend::content` resource
- **Consistent error handling** - All errors logged, clean JSON responses
- **No API keys in frontend** - Keys stay server-side, never exposed to JavaScript

### Provider Agnostic

Your code doesn't care which AI provider is configured:

```
<?php
declare(strict_types=1);

// Your handler just specifies a model
public function getOptions(): array
{
    return ['model' => $this->config->getSelectedModel()]; // e.g., 'gpt-4o' or 'gemini-2.5-flash'
}
```

The framework automatically resolves `gpt-4o` → OpenAI provider, `gemini-2.5-flash` → Gemini provider. If the merchant switches providers, your code doesn't change.

### Clean Separation

| Layer | Responsibility |
| --- | --- |
| **Handler** | Prepare prompts, process responses |
| **Framework** | Route to provider, handle errors, manage config |
| **Provider** | Talk to external API |

You focus on your feature logic. The framework handles the plumbing.

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────┐
│                  Your Implementation                     │
│                     (Handler + UI)                       │
└──────────────────────────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────┐
│              Process Controller (built-in)               │
│   • Validates handler exists                             │
│   • Resolves provider from model                         │
│   • Checks provider is configured                        │
│   • Handles errors consistently                          │
└──────────────────────────────────────────────────────────┘
                           │
                           ▼
┌───────────────────────────────────────────────────────────┐
│                   Base Framework                          │
│   ProviderPool ─── ProviderResolver ─── OptionsSchemaPool │
└───────────────────────────────────────────────────────────┘
                           │
                           ▼
┌───────────────────────────────────────────────────┐
│                      Providers                    │
│        OpenAI    │    Gemini    │    DeepL        │
└───────────────────────────────────────────────────┘
```

---

## Part 1: Using AI in Your Feature

The simplest way to add AI to your module.

### Step 1: Create a Handler

```
<?php
declare(strict_types=1);

namespace Vendor\Module\Model\Handler;

use Hyva\Ai\Api\HandlerInterface;

class ProductDescriptionHandler implements HandlerInterface
{
    public function __construct(
        private readonly ScopeConfigInterface $config
    ) {}

    public function getName(): string
    {
        return 'product_description';
    }

    public function getOptions(): array
    {
        return [
            'model' => $this->config->getValue('vendor_module/ai/model') ?? 'gpt-4o',
            'temperature' => 0.7,
            'max_tokens' => 1000
        ];
    }

    public function getData(array $requestData): array
    {
        $productName = $requestData['product_name'] ?? '';
        $keywords = $requestData['keywords'] ?? '';

        return [
            'messages' => [[
                'messages' => [
                    ['role' => 'system', 'content' => 'You are a product copywriter.'],
                    ['role' => 'user', 'content' => "Write a description for: {$productName}. Keywords: {$keywords}"]
                ]
            ]]
        ];
    }

    // Optional: transform the response
    public function processResponse(array $response, array $originalData): array
    {
        return [
            'description' => $response['responses'][0] ?? '',
            'product_name' => $originalData['request_data']['product_name'] ?? ''
        ];
    }
}
```

### Step 2: Register the Handler

```
<!-- etc/di.xml -->
<type name="Hyva\Ai\Controller\Adminhtml\Ai\Process">
    <arguments>
        <argument name="handlers" xsi:type="array">
            <item name="product_description" xsi:type="object">Vendor\Module\Model\Handler\ProductDescriptionHandler</item>
        </argument>
    </arguments>
</type>
```

### Step 3: Call It From JavaScript

```
async function generateDescription(productName, keywords) {
    const response = await fetch('/admin/hyva_ai/ai/process/handler/product_description', {
        method: 'POST',
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: new URLSearchParams({
            form_key: window.FORM_KEY,
            data: JSON.stringify({ product_name: productName, keywords: keywords })
        })
    });

    const result = await response.json();

    if (result.success) {
        return result.data.description;
    } else {
        throw new Error(result.message);
    }
}
```

That's it. The framework handles provider resolution, API calls, and error handling.

### Response Format

The controller always returns:

```
{
    "success": true,
    "provider": "openai",
    "handler": "product_description",
    "data": { /* your processResponse output */ },
    "message": "AI processing completed successfully."
}
```

Or, on error:

```
{
    "success": false,
    "message": "OpenAI API key is not configured."
}
```

---

## Part 2: Adding a New AI Provider

To add a provider (e.g., Anthropic), you need:

| Component | Purpose |
| --- | --- |
| `ProviderConfig` | Default settings (model, temperature, max tokens) |
| `Client` | Makes API calls to the AI service |
| `Provider` | Implements `ProviderInterface` |
| `OptionsSchema` | Declares configurable options |
| `Model Source` | Lists available models |

### ProviderInterface

```
<?php
declare(strict_types=1);

interface ProviderInterface
{
    public function process(array $data, array $options = []): array;
    public function isConfigured(): bool;
    public function getName(): string;
}
```

The `process()` method receives messages and returns responses:

```
<?php
declare(strict_types=1);

// Input
$data = [
    'messages' => [
        ['messages' => [
            ['role' => 'system', 'content' => '...'],
            ['role' => 'user', 'content' => '...']
        ]]
    ]
];

// Output - must have 'responses' key
return ['responses' => ['Generated text here']];
```

### ProviderConfigInterface

```
<?php
declare(strict_types=1);

interface ProviderConfigInterface
{
    public function getProviderName(): string;      // e.g., 'anthropic'
    public function getDefaultModel(): string;      // e.g., 'claude-sonnet-4-20250514'
    public function getDefaultTemperature(): float; // e.g., 0.3
    public function getDefaultMaxTokens(): int;     // e.g., 4000
}
```

### Registration

```
<!-- etc/di.xml -->

<!-- 1. Add to provider pool -->
<type name="Hyva\Ai\Model\ProviderPool">
    <arguments>
        <argument name="providers" xsi:type="array">
            <item name="anthropic" xsi:type="object">Vendor\AiAnthropic\Model\Provider\AnthropicProvider</item>
        </argument>
    </arguments>
</type>

<!-- 2. Register models so framework can resolve provider from model name -->
<type name="Hyva\Ai\Model\ProviderResolver">
    <arguments>
        <argument name="providerModels" xsi:type="array">
            <item name="anthropic" xsi:type="array">
                <item name="source_model" xsi:type="string">Vendor\AiAnthropic\Model\Config\Source\Model</item>
                <item name="label" xsi:type="string">Anthropic</item>
                <item name="options" xsi:type="array">
                    <item name="claude-sonnet-4-20250514" xsi:type="array">
                        <item name="value" xsi:type="string">claude-sonnet-4-20250514</item>
                        <item name="label" xsi:type="string">Claude Sonnet 4</item>
                    </item>
                </item>
            </item>
        </argument>
    </arguments>
</type>

<!-- 3. Register options schema (optional, for admin config UI) -->
<type name="Hyva\Ai\Model\Provider\OptionsSchemaPool">
    <arguments>
        <argument name="schemas" xsi:type="array">
            <item name="anthropic" xsi:type="object">Vendor\AiAnthropic\Model\Provider\OptionsSchema</item>
        </argument>
    </arguments>
</type>
```

### Admin Config

```
<!-- etc/adminhtml/system.xml -->
<section id="hyva_ai">
    <group id="anthropic" translate="label" sortOrder="30" showInDefault="1">
        <label>Anthropic Configuration</label>
        <field id="api_key" translate="label" type="obscure" sortOrder="10" showInDefault="1">
            <label>API Key</label>
            <backend_model>Magento\Config\Model\Config\Backend\Encrypted</backend_model>
        </field>
    </group>
</section>
```

---

## Message Format

All providers use OpenAI-compatible messages:

```
<?php
declare(strict_types=1);

$messages = [
    ['role' => 'system', 'content' => 'You are a helpful assistant.'],
    ['role' => 'user', 'content' => 'Hello!'],
    ['role' => 'assistant', 'content' => 'Hi there!'],
    ['role' => 'user', 'content' => 'How are you?']
];
```

Providers convert internally (e.g., Gemini maps `system` → `user`, `assistant` → `model`).

---

## Available Models

### OpenAI

`gpt-5`, `gpt-4o`, `gpt-4o-mini`, `gpt-4-turbo`, `gpt-4`, `gpt-3.5-turbo`

Config: `hyva_ai/openai/api_key`

### Gemini

`gemini-2.5-pro`, `gemini-2.5-flash`, `gemini-2.5-flash-lite`

Config: `hyva_ai/gemini/api_key`

### DeepL

`deepl-api`

Config: `hyva_ai/deepl/api_key`, `hyva_ai/deepl/api_type`

---

## Options Schema

For configurable provider options, extend `AbstractOptionsSchema`:

```
<?php
declare(strict_types=1);

class OptionsSchema extends AbstractOptionsSchema
{
    public function getProviderId(): string
    {
        return 'your_provider';
    }

    public function getFields(): array
    {
        return [
            [
                'id' => 'temperature',
                'type' => 'number',
                'label' => __('Temperature'),
                'default' => 0.3,  // float default = float type
            ],
            [
                'id' => 'max_tokens',
                'type' => 'number',
                'label' => __('Max Tokens'),
                'default' => 4000,  // int default = int type
            ]
        ];
    }
}
```

The base class normalizes config values to correct PHP types automatically.

---

## Dynamic Provider Options Block

For admin config that changes based on selected model:

```
<!-- etc/adminhtml/di.xml -->
<virtualType name="Vendor\Module\Block\ProviderOptions"
             type="Hyva\Ai\Block\Adminhtml\System\Config\ProviderOptions">
    <arguments>
        <argument name="modelFieldId" xsi:type="string">your_section_group_model</argument>
    </arguments>
</virtualType>
```

The block automatically shows relevant options when users change model selection.
