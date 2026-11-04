<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/faq.html -->

# What Are Design Tokens?

Design tokens are the single source of truth for the design properties of a product.
They are named entities that store design-related values, such as colors, typography, spacing, and shadows.
Think of them as variables for your design system.

Instead of hardcoding values like `#4F46E5` for your primary color,
you define a token called `color.primary.DEFAULT` and assign it that value.
Then, you use this token throughout your designs and code.

This approach creates a shared language between designers and developers,
ensuring consistency and scalability across all platforms and products.

## Why Are Design Tokens Useful?

Using design tokens offers several significant advantages:

- **Consistency:**
  Design tokens ensure that all design elements are consistent across your entire application.
  When everyone uses the same tokens, you eliminate inconsistencies and create a more cohesive user experience.
- **Scalability:**
  As your project grows, managing design properties can become complex.
  Design tokens make it easy to scale your design system.
  Need to update a color?
  Just change the token's value, and the change will propagate everywhere it's used.
- **Maintainability:**
  When design decisions are stored as tokens, your codebase becomes easier to maintain.
  You no longer need to hunt down and replace hardcoded values.
  This saves time and reduces the risk of errors.
- **Bridging the Gap Between Design and Development:**
  Design tokens create a shared language that both designers and developers can understand and use.
  Designers can create and manage tokens in their design tools (like Figma), and developers can use those same tokens in their code.
  This streamlines the handoff process and improves collaboration.
- **Theming:**
  Design tokens are essential for implementing themes, such as a dark mode.
  You can create different sets of tokens for each theme, and then switch between them to change the appearance of your entire application.

## How Do They Work in Practice?

Design tokens are typically stored in a structured format like JSON.
Here is a simple example of what a design token file might look like:

```
{
  "other": {
    "layer-1": {
      "$value": 1,
      "$type": "other"
    }
  },
  "sizing": {
    "size-2": {
      "$value": "0.5em",
      "$type": "sizing"
    },
    "size-4": {
      "$value": "4em",
      "$type": "sizing"
    }
  },
  "color": {
    "color-primary-lighter": {
      "$value": "oklch(62.3% 0.214 259.815)",
      "$type": "color"
    },
    "color-primary": {
      "$value": "oklch(54.6% 0.245 262.881)",
      "$type": "color"
    },
    "color-primary-darker": {
      "$value": "oklch(37.9% 0.146 265.522)",
      "$type": "color"
    }
  },
  "borderWidth": {
    "border-size-2": {
      "$value": "0.5em",
      "$type": "borderWidth"
    },
    "border-size-4": {
      "$value": "4em",
      "$type": "borderWidth"
    }
  },
  "boxShadow": {
    "shadow-1": {
      "$value": "0 2px 1px -1px hsl({shadow-color} / calc({shadow-weight} + 18%)),0 1px 1px hsl({shadow-color} / calc({shadow-weight} + 12%)),0 1px 3px hsl({shadow-color} / calc({shadow-weight} + 10%))",
      "$type": "boxShadow"
    },
    "shadow-color": {
      "$value": "gray",
      "$type": "boxShadow"
    },
    "shadow-weight": {
      "$value": "1%",
      "$type": "boxShadow"
    }
  }
}
```

This file defines tokens for colors and spacing.
These tokens can then be consumed by various tools and platforms, including CSS preprocessors, JavaScript frameworks, and native mobile applications.

## Design Tokens and Tailwind CSS

If you've used Tailwind CSS, you're already familiar with the concept of design tokens, even if you didn't call them that.
The `theme` object in your `tailwind.config.js` file is essentially a set of design tokens.

```
module.exports = {
    theme: {
        colors: {
            primary: {
                lighter: 'oklch(62.3% 0.214 259.815)',
                DEFAULT: 'oklch(54.6% 0.245 262.881)',
                darker: 'oklch(37.9% 0.146 265.522)',
            },
            // ...
        },
        spacing: {
            xs: '0.5rem',
            sm: '0.75rem',
            // ...
        },
    },
};
```

The keys in the `theme` object (like `colors.primary.DEFAULT` and `spacing.sm`) are the design tokens
and the values are their corresponding design properties.

## Design Tokens in Hyvä

Hyvä provides the [`hyva-tokens`](../using-hyva-modules/tokens.html) tool to make it even easier to work with design tokens.
This tool allows you to use a dedicated design token file (e.g., exported from Tokens Studio for Figma or Penpot) as the single source of truth for your theme's styling.

`hyva-tokens` reads your design token file and generates a CSS file with CSS custom properties (variables).
You can then use these variables in your theme, ensuring that your design system remains consistent and easy to maintain.
