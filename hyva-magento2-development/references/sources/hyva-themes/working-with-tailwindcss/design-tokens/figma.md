<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/figma.html -->

# Using Tokens Studio (Figma / Penpot)

[Tokens Studio](https://tokens.studio/) is a plugin for Figma and Penpot that lets you manage design tokens right inside your design tool and export them as JSON.

The `hyva-tokens` CLI supports the legacy Tokens Studio export format via the `format: "figma"` setting.

Which format is your export?

Tokens Studio has two export formats:

- **Legacy format** (older exports):
  uses `"value"` and `"type"` keys (no `$` prefix). Use `format: "figma"`.
- **DTCG format** (current default export):
  uses `"$value"` and `"$type"` keys. This is the default `hyva-tokens` format; no `format` setting needed.

Not sure which one you have? Open your exported JSON file and check whether the keys use a `$` prefix or not.

## Identifying the Legacy Tokens Studio Format

The legacy Tokens Studio format uses `"value"` and `"type"` keys without a dollar sign prefix. Here's what it looks like:

```
{
    "core": {
        "colors": {
            "black": {
                "value": "#000000",
                "type": "color"
            },
        },
        "dimension": {
            "scale": {
                "value": "2",
                "type": "dimension"
            },
            "xs": {
                "value": "4",
                "type": "dimension"
            },
            "sm": {
                "value": "8",
                "type": "dimension"
            }
        }
    }
}
```

## Configuring `hyva-tokens` for Legacy Tokens Studio Exports

To use a legacy Tokens Studio export, set `format` to `"figma"` in your `hyva.config.json`:

tailwind/hyva.config.json

```
{
    "tokens": {
        "src": "acme.tokens.json",
        "format": "figma"
    }
}
```

Then run the conversion:

```
npx hyva-tokens
```

## How Wrapper Keys Affect CSS Variable Names

Non-type wrapper keys in your token hierarchy end up in the generated CSS variable names. This applies to all formats, not just the legacy format.

For example, the `core` key in the JSON above is not a token type name, so `hyva-tokens` includes it in every variable name:

```
@theme {
    --core-black: #000000;
    --core-scale: 2;
    --core-xs: 4;
    --core-sm: 8;
}
```

Cleaner variable names

Want shorter, cleaner variable names? Remove non-type wrapper keys (like `core`) from your exported JSON before running `hyva-tokens`.

## How Token References Are Resolved

Token references like `{dimension.xs}` are translated directly to CSS variable references during conversion. This works across all formats.

The translation is a direct key-path mapping - `{dimension.xs}` becomes `var(--dimension-xs)` - rather than a logical resolution that looks up and inlines the referenced value.

Make sure the referenced token exists in the same file so the generated CSS variable is valid.

## Legacy Format Limitation: Type Group Stripping

In older Tokens Studio exports, the token type doubled as a group key. Colors, for example, were typically structured as `colors` > `color` > `primary`, with the type name appearing as a wrapper in the hierarchy.

The `hyva-tokens` CLI tries to strip this type-based group from the variable name based on that older convention. However, the format was later updated so that the type group is simply `color` (without the extra nesting), which means the stripping logic can break variable names for many current Tokens Studio exports.

Changing in Hyvä Themes Tailwind Utilities 1.4

The automatic type group stripping will be removed in version 1.4 of the Hyvä Themes Tailwind Utilities and replaced with an explicit opt-in option.
In the meantime, if your variable names look incorrect due to over-stripping, add the type wrapper group back to your token file manually.

## Related Topics

- **[Token Formats](formats.html)** - Comparison of all supported token formats
- **[`hyva-tokens` Command Reference](../using-hyva-modules/tokens.html)** - Full configuration options for the `hyva-tokens` CLI
