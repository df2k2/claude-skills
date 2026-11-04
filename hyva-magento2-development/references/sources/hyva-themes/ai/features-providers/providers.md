<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/providers.html -->

# Provider and Model Guidance

Choose a model that is registered by the installed provider package, available to your API account and supported by the feature's transport. These are separate checks. A saved model can remain selectable for compatibility after a provider changes its availability.

The examples below were checked against official provider documentation on **28 September 2026** and the provider package registrations. They are starting points for testing, not a guarantee of account access or a quality benchmark. Provider pricing, limits and retirement dates can change independently of Hyvä packages.

## Text and Translation

| Provider | Registered examples confirmed in official documentation | Considerations |
| --- | --- | --- |
| Anthropic | `claude-sonnet-5`, `claude-haiku-4-5`, `claude-opus-5-5`, `claude-fable-5-1` | Test a smaller model for routine copy and a more capable one for complex requests. The [Claude model overview](https://platform.claude.com/docs/en/models/overview) lists IDs and capabilities. |
| OpenAI | `gpt-6-sol`, `gpt-6-astra` | The shared Chat Completions protocol has tool restrictions: Sol tool requests disable reasoning; Astra tool requests are rejected because tool use requires Responses. Listing Astra does not make it suitable for every tool workflow. See [Sol](https://developers.openai.com/api/docs/models/gpt-6-sol) and [Astra](https://developers.openai.com/api/docs/models/gpt-6-astra). |
| Gemini | `gemini-3.8-flash`, `gemini-3.5-flash-lite`, `gemini-3.1-pro-preview` | Flash/Flash-Lite offer different speed/cost tradeoffs; the Pro choice is explicitly a preview. See the [Gemini catalog](https://ai.google.dev/gemini-api/docs/models). |
| DeepL | `deepl-api` | A Hyvä translation adapter identifier, not a general text-generation model. Configure the correct Free or Pro API type. It runs directly in PHP. |

For a new configuration, start with a current model you can test against representative requests. Inspect completeness, accuracy, latency and provider usage. Larger token limits do not extend PHP's time budget.

For Commerce image generation and worker-specific capabilities, see [AI Worker Configuration](../../../hyva-commerce/features/ai-worker/configuration.html#image-generation).

## Older and Custom Models

**Show older models** reveals compatibility choices. Existing selections are preserved, but Hyvä cannot keep a retired upstream model operational. If a request reports an unknown or unavailable model, check the provider's documentation and account access, then deliberately select and save an alternative.

Third-party packages can register models and optional shortlist metadata through the [extension contracts](integration-guide.html#register-models-and-options). Unknown third-party models are visible by default. Do not add an arbitrary model name to configuration and assume the matching worker protocol or feature capability exists.
