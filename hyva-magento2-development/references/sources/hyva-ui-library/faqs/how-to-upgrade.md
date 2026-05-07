<!-- source: https://docs.hyva.io/hyva-ui-library/faqs/how-to-upgrade.html -->

# How to Upgrade Hyvä UI Components

Hyvä UI components are different from other Hyvä modules. They don't require automatic updates with new UI library releases. Once you integrate a Hyvä UI component, you manage and customize its code as needed.

However, you might still need to update a component for bug fixes or the latest features. This guide provides tips on how to achieve that.

## When Updates Are Optional

If you use a UI component and only customize it with XML arguments, you can simply replace the existing file with the new one.

Note

This approach works because XML arguments override default behavior without modifying the core code.

## Updating Specific Parts

Similar to any Magento 2 update, consider the following steps for a more controlled update process:

1. **Compare Files:** Compare your current component version with the latest version. Identify the specific changes made in the updated files.
2. **Update Code Selectively:** If your goal is to modify styles only, replace just the PHP and Javascript code with the newer versions. Ensure any Alpine.js tags in your HTML haven't changed.
3. **Maintain Custom Styles:** You can typically keep your custom styles intact, even after code updates.

Important

This selective update approach requires caution. Double-check that your customizations don't conflict with new functionalities in the updated code.

By following these steps, you can effectively update Hyvä UI components while maintaining your existing customizations.
