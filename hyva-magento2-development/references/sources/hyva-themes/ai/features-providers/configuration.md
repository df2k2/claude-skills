<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/configuration.html -->

# Configuring Providers, Models and Execution

Open **Stores → Configuration → Hyvä AI → Settings** for provider connections, the shared execution default and runtime safeguards. Feature-specific settings are supplied by the feature package you install.

## Connect a Provider

1. Install the provider package. Its configuration group and model choices come from that package.
2. Enter the API key in its provider group and **Save Config**.
3. Where available, choose a registered model for the connection test and run **Test Connection**. Tests use the saved credential, not an unsaved value in the form.
4. Choose the model in each feature that will use it. A connection-test model does not set the model for every feature.

| Test | What it proves |
| --- | --- |
| Anthropic, Gemini or OpenAI provider test | A small direct provider request works with the saved credential and selected text model. It can incur provider usage charges, even if the global execution setting is AI Worker. |
| DeepL provider test | The saved Free/Pro credential can access the usage endpoint. It sends no translation text and consumes no translation characters. See [DeepL usage checks](https://developers.deepl.com/api-reference/usage-and-quota/check-usage-and-limits). |

Keys are stored encrypted in Magento. The shared credential resolver also supports provider-specific environment variables for OpenAI, Gemini and Anthropic: `HYVA_AI_OPENAI_API_KEY`, `HYVA_AI_GEMINI_API_KEY` and `HYVA_AI_ANTHROPIC_API_KEY`. They take precedence for shared credential resolution. The current direct OpenAI, Gemini and Anthropic clients and their connection tests read the encrypted saved configuration, so an environment-only worker credential does not configure those direct tests. Save a usable key for direct execution and test each route you use. Do not put provider keys in browser code.

## Choose a Provider, Then a Model

Feature pickers guide you through the provider, model and relevant options. Search and **Show older models** keep longer lists usable. A saved older selection remains visible: hiding it from the initial shortlist does not migrate it or delete its options. The shortlist is curated package metadata, not a live query of your provider account.

Use the feature's capabilities to narrow the choice. A translation-only model cannot handle general text generation. Consult [Provider and Model Guidance](providers.html), then test representative content with your own account.

## Execution and Inheritance

The general **Run requests using** setting establishes the default for feature requests:

| Choice | Behaviour |
| --- | --- |
| Keep existing feature choices | Preserve each feature's existing routing. This is the default when no value is saved. |
| Direct PHP (short requests) | Call the provider through its direct PHP adapter, within the application request budget. |
| AI Worker | Use the separately installed Commerce worker for supported providers. A provider without a worker adapter, such as DeepL, continues directly. |

A feature's explicit setting takes precedence; **Use default** inherits Settings. The general value is stored at `hyva_ai/execution/mode` as `legacy`, `php` or `worker` respectively.

AI Worker execution requires the Commerce integration. With a **Hyvä Commerce subscription**, see [feature configuration and inheritance](../../../hyva-commerce/features/ai-worker/configuration.html) and [worker setup](../../../hyva-commerce/features/ai-worker/installation.html). Direct PHP is a direct provider call; it does not use the worker's PHP runtime or backup settings.

## Runtime Safeguards

Direct requests and the synchronous worker bridge share the application request budget. The default is 25 seconds; a configured value of zero uses that default. Web requests also account for elapsed request time and reserve five seconds against PHP's configured execution limit. Configure the budget below known hosting limits. No PHP, PHP-FPM, Nginx or Redis configuration is changed by the modules.

The direct implementations release active session locks before provider I/O. OpenAI and Gemini retry selected transient HTTP responses at most once when the delay fits the remaining budget; ambiguous network failures are not automatically retried. Anthropic uses a bounded request deadline with SDK retries disabled. Incomplete or truncated provider output is rejected instead of accepted as finished content.

**Max Concurrent AI Requests** defaults to two for guarded synchronous requests; zero disables that limit. Worker stream duration, Node concurrency and background delivery concurrency are separate controls. See [Worker Operations](../../../hyva-commerce/features/ai-worker/operations.html).
