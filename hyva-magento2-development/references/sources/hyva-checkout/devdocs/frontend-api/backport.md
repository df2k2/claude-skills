<!-- source: https://docs.hyva.io/hyva-checkout/devdocs/frontend-api/backport.html -->

# Hyva Checkout Frontend API Backport Module

Checkout 1.x only

This page applies to Hyvä Checkout 1.x (Magewire 1), and only to versions `1.3.1` through `1.3.7`. From `1.3.8`, the Frontend API is part of the checkout itself, and that includes Checkout 3.x. The module's README says not to install it on `1.3.8` or newer, so don't install it on Checkout 3.x.

The Frontend API backport is unrelated to the `hyva-themes/magento2-hyva-checkout-v1bc` module, which lets Magewire 1 components run on Checkout 3.x. See [The Magewire 1 Backward Compatibility Module (v1bc)](../../magewire/v1bc.html).

The **Hyva Checkout Frontend API Backport module** (`hyva-themes/magento2-hyva-checkout-frontend-api`) brings the latest payment integration features and security improvements to older Hyva Checkout versions. Payment service providers (PSPs), agencies, and integrators can build against current API capabilities while supporting merchants who haven't yet upgraded their checkout installation.

## Why Use the Hyva Checkout Backport Module?

Payment integrators need access to the latest Hyva Checkout Frontend API features, but merchants may be running older checkout versions. The Hyva Checkout Backport module solves this mismatch without forcing upgrades or requiring multiple integration versions.

The backport module provides:

- **Latest payment API features** on older Hyva Checkout installations
- **Security improvements** without full checkout upgrades
- **Forward compatibility** so integrations built with current API patterns work on older versions
- **Reduced maintenance burden** for PSPs and agencies supporting multiple merchants

Hyva maintains backwards compatibility wherever possible, so upgrading the backport module is safe and recommended whenever a new version is released.

## When to Install the Hyva Checkout Backport

Install the Hyva Checkout Backport module when:

- A payment integration requires Frontend API features not present in the merchant's Hyva Checkout version
- Security fixes from newer Hyva Checkout versions are needed without a full upgrade
- Multiple modules require different Frontend API versions - use the latest backport to satisfy all requirements

Backport version releases

A new Hyva Checkout Backport version is released whenever the main Hyva Checkout package includes changes to backport-related files. Backport releases may not occur on the same day as the main checkout release.

## Installing the Hyva Checkout Backport Module

Any customer with a Hyva Checkout license can install the backport module. The installation uses Composer, just like other Hyva packages.

**Step 1:** Configure the Hyva packagist.com repository (if not already configured).

This step is usually already completed during Hyva Checkout installation.

Configure Composer authentication

```
# Add your license authentication key to auth.json
# Replace yourLicenseAuthenticationKey with your actual key
composer config --auth http-basic.hyva-themes.repo.packagist.com token yourLicenseAuthenticationKey

# Add the private packagist repository
# Replace yourProjectName with your project name
composer config repositories.private-packagist composer https://hyva-themes.repo.packagist.com/yourProjectName/
```

**Step 2:** Require the backport package via Composer.

Install the backport module

```
composer require 'hyva-themes/magento2-hyva-checkout-frontend-api'
```

## Future Development of the Backport Module

The Hyva Checkout Backport module initially focused on payment and security improvements. Expansion to include additional JavaScript-specific upgrades is under consideration, though no specific roadmap exists at this time.

## Hyva Checkout Backport Module Structure

Understanding the backport module's internal organization helps when troubleshooting or reviewing customizations. The Hyva Checkout Backport module maintains a clear directory structure to ensure compatibility while minimizing conflicts with the core checkout package.

### Template Overrides in `view/`

The backport module overrides only templates directly related to the Hyva Checkout Frontend API, particularly payment-related templates. These templates are referenced via layout XML and given new template paths to replace the originals from the core checkout.

### PHP Preferences in `Preference/`

The `Preference/` directory contains DI preferences for PHP classes that exist in supported Hyva Checkout versions but require additional methods from newer versions. These preferences restore compatibility by adding missing method implementations.

### Origin Classes in `Origin/`

The `Origin/` directory contains classes that are completely missing from older Hyva Checkout versions. The folder structure inside `Origin/` mirrors the main Hyva Checkout package structure for easy maintenance and traceability.

Origin classes are deprecated on purpose

Origin classes are marked as `@deprecated` to signal that they are temporary backports. Once the merchant upgrades their Hyva Checkout installation, these origin classes become redundant and the deprecation notice serves as a reminder.

### Forward-Compatibility Classes in the Backport Module

Additional classes throughout the backport module provide forward-compatibility for features like frontend configuration during page loads and Magewire subsequent requests. These classes ensure that newer API patterns work correctly on older Hyva Checkout versions.

## Frequently Asked Questions About the Backport

Can the Hyva Checkout Backport be installed alongside the latest checkout version?

No. From Hyva Checkout `1.3.8`, including Checkout 3.x, the Frontend API ships with the checkout and the module's README says not to install the backport. The backport's template overrides take priority over core files, so on a newer checkout they would replace the core Frontend API templates with older copies.


When do I need the Hyva Checkout Backport module?

Install the Hyva Checkout Backport when Frontend API features are needed that don't exist in the merchant's checkout version. The backport module focuses on features commonly required by PSP and shipping integrators, with an emphasis on payment-related functionality.

If multiple modules in the project require the backport, always use the latest version. Vendors requiring the backport should use a flexible Composer version constraint (such as `*`) or implement a strategy that ensures the latest backport version is installed.


What happens when the merchant upgrades Hyva Checkout?

Once the merchant upgrades to a Hyva Checkout version that includes the backported features natively, the backport module becomes redundant. The backport can remain installed without causing issues, but the module is no longer providing additional functionality. Consider removing the backport module to reduce project complexity.
