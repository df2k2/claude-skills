<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/installation.html -->

# Installing Hyvä AI

Install the base AI module and the providers you need. The feature that uses them is configured separately.

## Selective Installation

For base AI and one provider, for example Anthropic:

```
composer require hyva-themes/magento2-module-ai hyva-themes/magento2-module-ai-anthropic
```

| Provider | Composer package |
| --- | --- |
| Anthropic | `hyva-themes/magento2-module-ai-anthropic` |
| Google Gemini | `hyva-themes/magento2-module-ai-gemini` |
| OpenAI | `hyva-themes/magento2-module-ai-open-ai` |
| DeepL | `hyva-themes/magento2-module-ai-deep-l` |

Each provider depends on the base module, independently of the other providers. DeepL is a translation provider; Anthropic, Gemini and OpenAI support general text requests.

To install all four providers, use the optional metapackage:

```
composer require hyva-themes/magento2-ai-providers
```

## Complete the Magento Deployment

Run the normal deployment steps for your environment, including:

```
bin/magento setup:upgrade
bin/magento cache:clean config
```

Regenerate dependency injection code and deploy admin static content where your deployment mode requires them. Restart long-running consumers after module updates. The Settings overview uses the standard admin LESS build.

Save provider credentials under **Stores → Configuration → Hyvä AI → Settings**, then continue with [Configuration](configuration.html). For an existing installation, review [Upgrading](upgrading.html).

## Hyvä Commerce Features

If you have a **Hyvä Commerce subscription**, follow [AI Worker Setup](../../../hyva-commerce/features/ai-worker/installation.html) to install and configure the Commerce integrations. Their package requirements and worker deployment instructions are documented there.
