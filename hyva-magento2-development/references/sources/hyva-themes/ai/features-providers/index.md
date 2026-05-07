<!-- source: https://docs.hyva.io/hyva-themes/ai/features-providers/index.html -->

# Hyvä AI Providers & Framework

Hyvä's AI providers and framework offer a standardized way to implement AI-powered features in Hyvä projects.

This consists of three key parts:

- A base framework for standardizing AI feature implementations
- A set of AI providers that can be used out-of-the-box
- Features that implement our framework (but are provider-agnostic)

## Features

Our current features are:

- [AI-powered translations for Hyvä CMS](../../../hyva-commerce/features/cms/features/translations.html)

## Providers

Our current providers are:

- OpenAI
- Gemini
- DeepL

## Framework

For more information on the framework and how to integrate your own providers, see the [integration guide](integration-guide.html).

## Installation

These installation instructions are for installing the AI providers and framework separate from our feature implementations only, i.e. these steps do not need to be followed to use AI-powered features in our product offerings (such as AI-powered translations for Hyvä CMS).

### Install all providers (and base framework)

#### Installing from Packagist.com

Install the AI providers metapackage from Packagist.com using Composer:

```
composer require hyva-themes/magento2-ai-providers
```

Run:

```
bin/magento setup:upgrade
```

#### Installing for Development and Contributions

GitLab access is available only to tech partners

Direct access to the GitLab repository requires Hyvä tech partner status.

Install the AI providers and base framework module from GitLab for development purposes:

```
# Add the GitLab repositories to Composer
composer config repositories.hyva-themes/magento2-ai-providers git git@gitlab.hyva.io:hyva-themes/ai/metapackage-ai-providers.git
composer config repositories.hyva-themes/magento2-module-ai git git@gitlab.hyva.io:hyva-themes/ai/module-ai.git
composer config repositories.hyva-themes/magento2-module-ai-deep-l git git@gitlab.hyva.io:hyva-themes/ai/module-ai-deep-l.git
composer config repositories.hyva-themes/magento2-module-ai-gemini git git@gitlab.hyva.io:hyva-themes/ai/module-ai-gemini.git
composer config repositories.hyva-themes/magento2-module-ai-open-ai git git@gitlab.hyva.io:hyva-themes/ai/module-ai-open-ai.git

# Install the modules with source files for development
composer require hyva-themes/magento2-ai-providers:dev-main --prefer-source
```

Run:

```
bin/magento setup:upgrade
```

### Install base framework module only

#### Installing from Packagist.com

Install the AI module from Packagist.com using Composer:

```
composer require hyva-themes/magento2-module-ai
```

Run:

```
bin/magento setup:upgrade
```

#### Installing for Development and Contributions

GitLab access is available only to tech partners

Direct access to the GitLab repository requires Hyvä tech partner status.

Install the base AI framework module from GitLab for development purposes:

```
# Add the GitLab repositories to Composer
composer config repositories.hyva-themes/magento2-module-ai git git@gitlab.hyva.io:hyva-themes/ai/module-ai.git

# Install the modules with source files for development
composer require hyva-themes/magento2-module-ai:dev-main --prefer-source
```

Run:

```
bin/magento setup:upgrade
```
