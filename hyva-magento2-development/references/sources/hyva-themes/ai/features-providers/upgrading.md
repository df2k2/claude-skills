<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/upgrading.html -->

# Upgrading the AI Packages

Update the base AI module and the providers you use together. Retain your normal database/configuration backup and deployment process, and check custom integrations against the [extension contracts](integration-guide.html).

## Settings and Credentials

Existing provider settings retain their `hyva_ai/...` storage paths. The general execution default is **Keep existing feature choices** when absent, so an update does not automatically reroute saved requests. Saved provider/model options remain supported. From Hyvä AI 1.3.1, **Stores → Configuration → Hyvä AI → Settings** and the provider connection test need **Hyvä AI Section** (`Hyva_Ai::config`) instead of Content, and existing roles are not migrated.

Choose models in each feature's settings; a provider's connection-test model does not set every feature's model. There is no general requirement to recreate AI settings. Re-enter and save a provider key only when it is missing, invalid or cannot be decrypted on this installation. An encrypted value copied from an installation with a different Magento encryption key is not a usable credential.

For DeepL, save the correct Free/Pro key and run its usage-based connection test. An update cannot repair an unreadable encrypted value automatically.

Retain older model selections only while the provider still accepts them. A saved model remaining visible does not guarantee upstream availability. See [Model Guidance](providers.html).

## Verify the Update

1. Complete `setup:upgrade`, configuration-cache refresh, DI generation and admin static deployment as appropriate for your environment. Restart long-running consumers.
2. Open **Hyvä AI → Settings** and confirm only the installed providers appear. Check saved credentials with each available provider test.
3. Check **Run requests using** globally and in each installed feature.
4. Test representative requests and review their results.

Direct requests use bounded deadlines and reject incomplete output. If a request exceeds its budget or is truncated, reduce its size or use a feature designed for longer work. The modules do not change your server's timeout configuration.

For Commerce integrations, also follow [AI Worker Operations](../../../hyva-commerce/features/ai-worker/operations.html) and [Feature Configuration](../../../hyva-commerce/features/ai-worker/configuration.html).
