<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/formats.html -->

# Token File Formats

The `hyva-tokens` command supports three token file formats: the default DTCG format, the legacy Tokens Studio format, and the Google Stitch Markdown format.
A fourth format based on the DTCG 2025.10 specification is planned for a future release.

You set the format via the `format` key in `hyva.config.json`. The Google Stitch format is detected automatically from the `.md` file extension and requires no `format` key.

## Default Format (DTCG)

The default token format follows the [Design Tokens Community Group (DTCG)](https://design-tokens.github.io/community-group/format/) draft specification.
This is the widely adopted standard in use today - an earlier draft than the 2025.10 spec, but still the one most tools support.

Each token uses dollar-prefixed `$value` and `$type` keys:

tailwind/design.tokens.json

```
{
    "color": {
        "primary-lighter": {
            "$value": "oklch(62.3% 0.214 259.815)",
            "$type": "color"
        },
        "primary": {
            "$value": "oklch(54.6% 0.245 262.881)",
            "$type": "color"
        },
        "primary-darker": {
            "$value": "oklch(37.9% 0.146 265.522)",
            "$type": "color"
        }
    },
    "sizing": {
        "size-2": {
            "$value": "0.5rem",
            "$type": "sizing"
        },
        "size-4": {
            "$value": "1rem",
            "$type": "sizing"
        }
    }
}
```

### How CSS Variable Names Are Generated

The CSS variable name comes from the token's key path, with dots replaced by dashes:

```
@theme {
    --color-primary-lighter: oklch(62.3% 0.214 259.815);
    --color-primary: oklch(54.6% 0.245 262.881);
    --color-primary-darker: oklch(37.9% 0.146 265.522);
    --sizing-size-2: 0.5rem;
    --sizing-size-4: 1rem;
}
```

Naming your tokens

Keep your key hierarchy shallow and avoid redundant prefixes to get clean CSS variable names.
For example, use `color.primary` rather than `theme.color.primary` to generate `--color-primary`.

## Legacy Tokens Studio Format (`format: "figma"`)

The `"figma"` format handles the older export format from early versions of [Tokens Studio](https://tokens.studio/).
In this format, token keys do **not** use a dollar prefix - just `value` and `type`:

tailwind/figma.tokens.json

```
{
    "color": {
        "primary-lighter": {
            "value": "oklch(62.3% 0.214 259.815)",
            "type": "color"
        },
        "primary": {
            "value": "oklch(54.6% 0.245 262.881)",
            "type": "color"
        }
    },
    "sizing": {
        "size-2": {
            "value": "0.5rem",
            "type": "sizing"
        }
    }
}
```

To use the legacy Tokens Studio format, set `format` to `"figma"` in your `hyva.config.json`:

tailwind/hyva.config.json

```
{
    "tokens": {
        "src": "figma.tokens.json",
        "format": "figma"
    }
}
```

Tokens Studio now exports the DTCG format

Current versions of Tokens Studio export the DTCG format (`$value`/`$type`) by default.
You only need `format: "figma"` for older exports.

For details on wrapper key and token reference limitations, see the [Using Tokens Studio](figma.html) page.

## Google Stitch Markdown Format

[Google Stitch](https://stitch.withgoogle.com) exports tokens as a Markdown file with YAML frontmatter. The `hyva-tokens` command detects this format automatically when `tokens.src` points at a `.md` file, so no `format` key is needed.

Only the YAML frontmatter block is read. The rest of the document (brand descriptions, component guidelines, and so on) is ignored. The `colors` group is automatically renamed to `color` to match Hyvä's naming convention.

tailwind/DESIGN.md

```
---
name: My Theme
colors:
  primary: oklch(54.6% 0.245 262.881)
  secondary: oklch(45% 0.18 200)
  surface: oklch(97% 0 0)
  ink: oklch(13% 0 0)
---

## Brand Voice
...
```

For a full guide on working with Stitch exports, including tint variants and using an AI agent to generate a Hyvä-compatible structure, see the [Using Google Stitch](google-stitch.html) page.

## DTCG 2025.10 (Coming Soon)

The [Design Tokens Community Group (DTCG)](https://www.designtokens.org/tr/2025.10/format/) has published an updated specification.
Support for the DTCG 2025.10 format is planned for a future version of `hyva-tokens`.

The 2025.10 format keeps `$value` and `$type`, but adds support for structured values.
Colors can carry color space information and dimensions can include a unit field.
Plain string values remain valid as well, and `hyva-tokens` will continue to support them.

Open discussion on plain string values

The DTCG spec itself has an open discussion on whether plain strings should remain valid in 2025.10.

Here's what the 2025.10 format looks like with structured token values:

```
{
    "version": "2025.10",
    "name": "My Theme",
    "resolutionOrder": [
        {
            "type": "set",
            "name": "Default Theme",
            "sources": [
                {
                    "color": {
                        "$type": "color",
                        "primary": {
                            "$value": {
                                "colorSpace": "srgb",
                                "components": [0, 0.4, 0.8]
                            }
                        }
                    },
                    "spacing": {
                        "$type": "dimension",
                        "sm": {
                            "$value": { "value": 8, "unit": "px" }
                        },
                        "lg": {
                            "$value": { "value": 32, "unit": "px" }
                        }
                    }
                }
            ]
        }
    ]
}
```

A notable improvement in 2025.10 is that `$type` can be declared on a group and inherited by all tokens inside it, reducing repetition. You can see this in the example above where `"$type": "color"` is set once on the `color` group rather than on each individual token.

Not yet supported

`hyva-tokens` does not currently parse the 2025.10 format.
Use the default (older) DTCG format in the meantime.

## Simple Tokens

If you're not working with an external design tool, you can skip token files entirely and define tokens directly in `hyva.config.json` using plain key/value pairs.
This format mirrors a Tailwind CSS theme object and also supports inline dark mode via the `@media:dark-` key prefix.

For full details, see the [Simple Tokens](simple-tokens.html) page.

## Format Comparison

|  | Default (DTCG) | Legacy Tokens Studio | Google Stitch | DTCG 2025.10 | Simple Tokens |
| --- | --- | --- | --- | --- | --- |
| `format` setting | *(omit)* | `"figma"` | *(auto-detected)* | *(planned)* | *(omit)* |
| Source file | `.json` | `.json` | `.md` | `.json` | `hyva.config.json` |
| Value key | `"$value"` | `"value"` | *(plain YAML values)* | `"$value"` | *(none - plain values)* |
| Type key | `"$type"` | `"type"` | *(none)* | `"$type"` | *(none)* |
| Value structure | Plain string | Plain string | Plain key/value pairs | Structured object | Plain key/value pairs |
| `$type` inheritance | No | No | N/A | Yes (from group) | N/A |
| Supported | Yes | Yes | Yes | No (coming soon) | Yes |

[Style Dictionary](https://styledictionary.com/) previously used its own format but adopted the DTCG format as of v4, so token files generated by Style Dictionary v4+ are compatible with `hyva-tokens`.
