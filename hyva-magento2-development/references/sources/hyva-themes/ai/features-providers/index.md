<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/index.html -->

# Hyvä AI

Hyvä AI is the open-source foundation for connecting Magento features to AI providers. The base module supplies shared contracts, configuration and request handling. Separate provider packages supply credentials, models and provider-specific options. Install only the providers you use.

## What Is Included?

| Package | Responsibility |
| --- | --- |
| `hyva-themes/magento2-module-ai` | Feature and provider contracts, model and credential registries, execution routing, configuration UI and runtime safeguards. |
| Individual provider packages | Anthropic, Google Gemini, OpenAI and DeepL connections, models, options and supported connection tests. |
| `hyva-themes/magento2-ai-providers` | An optional bundle that installs all four provider packages. |

The base module and providers give developers a shared API for building AI features. They do not install the Commerce editing tools. For example, base AI plus Anthropic can be installed without the other providers, CMS or AI Worker.

## Get Started

1. [Install the base module and your chosen providers](installation.html).
2. Open **Stores → Configuration → Hyvä AI → Settings**, save your provider credentials and [test the connection](configuration.html).
3. Configure the installed feature that will use the provider, or build your own using the [Integration Guide](integration-guide.html).

You need your own provider account. Provider API usage is billed separately.

## Advanced Features with Hyvä Commerce

If you have a **Hyvä Commerce subscription**, continue to [AI Worker](../../../hyva-commerce/features/ai-worker/index.html) for advanced AI features and the Commerce integrations. That section covers [available features](../../../hyva-commerce/features/ai-worker/features.html), [package installation](../../../hyva-commerce/features/ai-worker/installation.html), configuration and running the worker.

The open-source base module and providers remain the foundation used by those integrations.
