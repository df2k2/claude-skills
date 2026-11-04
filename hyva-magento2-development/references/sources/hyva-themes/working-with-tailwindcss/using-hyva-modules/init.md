<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/using-hyva-modules/init.html -->

# The hyva-init command

This command creates a `hyva.config.json` in the theme folder next to `package.json`.
This file is used to configure the other `hyva-*` commands.

To run it, use: `npx hyva-init`.

## What can you configure

The configuration is explained in more details in the pages dedicated to each command, but in short, we provide a top level key for each option.

For `hyva-tokens` the script will look for the key `tokens`, from here each config has its own keys.

If you add unsupported keys they will be ignored. This allows you to use the config for custom options.
If you do add more options please try to avoid naming conflicts with the keys used by Hyvä.

## Example Config

This a full config using the latest options as of `v1.1` of the [hyva-modules](https://github.com/hyva-themes/hyva-modules-tailwind-js) package.

hyva.config.json

```
{
  "tailwind": {
    "include": [
      { "src": "<PATH>" }
    ],
    "exclude": [
      { "src": "<PATH>" }
    ]
  },
  "tokens": {
    "src": "acme-hyva.design.tokens.json",
    "values": {
        "color": {
            "hyva-blue": "oklch(0.38 0.23 265.33)",
        }
    },
    "format": "default",
    "cssSelector": ":root"
  }
}
```

*Note: the valid values for the `token.format` key are `"default"` or `"figma"`.*
