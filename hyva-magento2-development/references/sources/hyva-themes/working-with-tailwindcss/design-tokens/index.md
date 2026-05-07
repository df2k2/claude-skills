<!-- source: https://docs.hyva.io/hyva-themes/working-with-tailwindcss/design-tokens/index.html -->

# Design Tokens

Design tokens are named design decisions - colors, spacing, typography, shadows -
stored in a structured format that both designers and developers can share.

In Hyvä, the `hyva-tokens` command converts a design token file into CSS custom properties,
making it the single source of truth for your theme's visual style.

Quick Reference

For command options and configuration details,
see the [`hyva-tokens` command reference](../using-hyva-modules/tokens.html).

## [What Are Design Tokens?](faq.html)

A conceptual overview of design tokens: what they are, why they matter,
and how they connect Tailwind CSS and Hyvä into a shared design language.

## [Token Formats](formats.html)

The token file formats supported by `hyva-tokens`: the default DTCG format,
the legacy Tokens Studio format, and the upcoming DTCG 2025.10 format.
Includes guidance on choosing the right format for your project.

## [Using Tokens Studio](figma.html)

How to use the legacy Tokens Studio export format (from Figma and Penpot plugins) with `hyva-tokens`,
including handling wrapper keys and known limitations.

## [Simple Tokens](simple-tokens.html)

How to define design tokens directly in `hyva.config.json` without an external token file.
Covers inline definitions and dark mode support for straightforward setups.
