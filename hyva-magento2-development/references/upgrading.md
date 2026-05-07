# Upgrading Hyvä, Tailwind, and Alpine

## When to read this

You're moving a project from an older Hyvä release (1.2.x / 1.3.x) to 1.4.x, migrating Tailwind v3 → v4, Alpine v2 → v3, or just want to know how upgrades work in general.

## The big version map

| Hyvä Default Theme | Tailwind | Alpine.js | Notes |
| --- | --- | --- | --- |
| 1.0.x | v2 | v2 | Legacy, no longer security-supported in many cases |
| 1.1.x | v2 | v2 | Legacy |
| 1.2.x | v3 | v3 | LTS-style support continues |
| 1.3.x | v3 | v3 | Many shops still on this. Reset-theme parent removed at 1.3.18. |
| 1.4.x | **v4** | v3 | Current. CSS-first config, Oxide engine, CSS components. PHP 8.1+. |

The theme-module (the runtime part with view models and `window.hyva`) maintains backwards compatibility, so it's almost always safe to upgrade just the theme-module independently from the default theme.

## Two components, two upgrade rhythms

Hyvä has two key Composer packages:

- **`hyva-themes/magento2-theme-module`** — runtime infrastructure (view models, `$viewModels` registry, the `hyva.*` JS object, layout-handle prefixing). **Backward-compatible by policy** — almost always safe to upgrade independently.
- **`hyva-themes/magento2-default-theme`** — the templates, layout XML, and Tailwind source. Customizations in your child theme may need updates when this changes.

Recommendation: keep the theme-module on latest. Upgrade the default theme more deliberately when you have time to review each customized template against the new version.

## Upgrade process (general)

1. Read the version-specific upgrade notes in the [Hyvä docs](https://docs.hyva.io/hyva-themes/upgrading/).
2. Read the changelog for both `magento2-theme-module` and `magento2-default-theme`.
3. Upgrade the theme-module first, deploy, smoke-test.
4. List the templates you've customized in your child theme (anything in `app/design/frontend/Vendor/Theme/Magento_*/templates/...` that exists in the parent theme).
5. For each customized template, diff the new parent version against the old one to see what changed. Apply those changes to your customized version.
6. Upgrade the default theme.
7. Test thoroughly — at minimum: PDP, PLP, cart, checkout, customer account.

### Tooling for diffing customizations

Quick `git`-based diff (Peter Jaap Blaakmeer's trick):
```bash
# In a temp folder, capture old vendor:
cp -r vendor/hyva-themes/magento2-default-theme /tmp/old-theme
git -C /tmp/old-theme init && git -C /tmp/old-theme add . && git -C /tmp/old-theme commit -m "old"

# Update Composer:
composer update hyva-themes/magento2-default-theme

# Copy new files in and diff:
cp -r vendor/hyva-themes/magento2-default-theme/* /tmp/old-theme/
git -C /tmp/old-theme diff
```

Or use:
- [Hyvä Upgrade Helper Tools](https://github.com/hyva-themes/upgrade-helper-tools) — Composer dev-dependency
- [Ampersand Magento2 Upgrade Patch Helper](https://github.com/AmpersandHQ/ampersand-magento2-upgrade-patch-helper)
- [Elgentos Magento2 Upgrade GUI](https://github.com/elgentos/magento2-upgrade-gui)

## Upgrading 1.3.x → 1.4.x (the big one)

This involves:
- Tailwind v3 → v4 migration
- Removing the reset-theme parent (already removed in 1.3.18+, but if you skipped that)
- New `hyva.config.json` + `tailwind-source.css` instead of `tailwind.config.js`
- PHP 8.1+ requirement (drop 7.4)
- Node 20+ required for the build
- Some deprecated Tailwind utilities renamed (`bg-opacity-*` → slash syntax, `flex-grow` → `grow`, etc.)

### Step-by-step: Tailwind v3 → v4

Install the upgrade helpers:
```bash
composer require --dev hyva-themes/upgrade-helper-tools:dev-main
```

Run the wrapper:
```bash
./vendor/bin/update-to-tailwind-v4.js app/design/frontend/Acme/default/
```

This runs three sub-helpers in order:

#### 1. `convert-to-tailwind-v4.js`
- Backs up `web/tailwind/` to `web/tailwind.backup.YYYYMMDD/`.
- Copies the new v4 source structure from `vendor/hyva-themes/magento2-default-theme/web/tailwind` into your child theme.

After this you'll have a fresh v4 setup. **Custom files from the backup don't carry over** — you have to manually port them.

#### 2. `convert-tailwind-config.js`
Reads your old `tailwind.config.js` and writes `web/tailwind/generated/tailwind.config.css` with `@theme` blocks for theme values:

Old:
```js
// tailwind.config.js
module.exports = {
    theme: { extend: {
        colors: {
            primary: {
                lighter: '#93c5fd',
                'DEFAULT': '#1e40af',
                darker: '#1e3a8a'
            }
        }
    }}
};
```

New:
```css
/* generated/tailwind.config.css */
@theme {
    --colors-primary-lighter: #93c5fd;
    --colors-primary-default: #1e40af;
    --colors-primary-darker: #1e3a8a;
}
```

Add the import to `tailwind-source.css`:
```css
@import "./generated/hyva-source.css";
@import "./generated/hyva-tokens.css";
@import "./generated/tailwind.config.css";  /* ← add this */
```

#### 3. `find-deprecated-classes.js`
Scans `.phtml` and `.xml` files for deprecated Tailwind utility classes and outputs `tailwind-deprecated-report.md` with:
- File path, line, column
- The deprecated class
- A recommended fix (often a renamed class or a slash-syntax opacity value)

Run with:
```bash
./vendor/bin/find-deprecated-classes.js app/design/frontend/Acme/default/
```

Options:
- `--console` — print to stdout instead of writing a file
- `--config <path>` — custom JSON config of patterns

##### Deprecations to know

- `bg-opacity-*`, `text-opacity-*`, `border-opacity-*`, `ring-opacity-*` → use slash syntax: `bg-black/50` instead of `bg-black bg-opacity-50`
- `flex-grow`, `flex-grow-0` → `grow`, `grow-0`
- `flex-shrink`, `flex-shrink-0` → `shrink`, `shrink-0`
- `overflow-ellipsis` → `text-ellipsis`
- `decoration-slice` → `box-decoration-slice`
- `decoration-clone` → `box-decoration-clone`

##### Automating the fix with an AI assistant

After generating the report, you can hand it to an AI assistant with a prompt like the one in the upgrade docs (`hyva-themes/upgrading/upgrade-helper.md`), which walks through reading each entry and applying the right replacement based on neighboring classes (especially for opacity → slash syntax, which needs to look up the corresponding color class).

### Step-by-step: Alpine v2 → v3 (Hyvä 1.1.x → 1.2.x+)

Less common nowadays, but if you're upgrading from a really old version:

```bash
./vendor/bin/hyva-1.2.0-tailwind-and-alpine.js app/design/frontend/Acme/default/
```

Major Alpine v3 changes:
- `x-data` syntax tightened — single object literal or function call.
- `x-spread` removed → use object spreads inside `x-data`.
- `x-on:click` short form is `@click` (already worked in v2 too).
- `Alpine.start()` is automatic — don't call it manually.
- New magic helpers like `$watch` work differently in some edge cases.

### Step-by-step: 1.3.10 / 1.3.11 CSP migration

Hyvä 1.3.11 introduced the strict CSP option for the default theme. To check your existing Alpine code for CSP-incompatibility:
```bash
./bin/hyva-csp-helper app/design/frontend/Acme/default/ | tee CSP-migration.md
```

The output lists every `x-data`, `@click`, etc. that uses inline expressions and would need to move to a registered `Alpine.data(...)` component. See `alpine-csp.md` for the conversion patterns.

## After any upgrade: build, deploy, test

```bash
bin/magento cache:flush
bin/magento setup:upgrade
bin/magento setup:di:compile

# Build CSS in your child theme
cd app/design/frontend/Acme/default/web/tailwind
npm ci
npm run build

# Production deploy
bin/magento setup:static-content:deploy -f
```

Test:
- Homepage, CMS pages
- Category listing
- Product page (with options if applicable)
- Cart and minicart
- Checkout (especially if you migrated the checkout module)
- Customer account
- Search
- Forms (contact, newsletter, login, register)

Check the browser console on each page — look for missing JS, broken Alpine expressions, or 404s.

## When NOT to upgrade

- **Tight production deadline.** A point-release upgrade is usually safe; a major upgrade (1.3.x → 1.4.x) is not a same-day operation.
- **Custom checkout integrations not yet ready for the new version.** Test in staging first.
- **Heavy template customizations.** Read the changelog carefully and budget time per customized file.

For security patches only, Hyvä provides patch-only releases on older branches — check the release notes.

## Long-term support

Hyvä commits to security releases on older branches when ecosystem changes (new Tailwind, new Magento) require breaking changes in the latest. The duration is unspecified — when in doubt, check the [Hyvä changelogs](https://docs.hyva.io/hyva-themes/upgrading/) or ask in the Hyvä Slack.

## Common pitfalls during upgrade

- **Forgot to copy parent-theme path** in the new `hyva.config.json` after the v4 migration → all parent classes get purged. Symptom: most styles missing.
- **Old `tailwind.config.js` left in place** while v4 also has `hyva.config.json` → confusing build behavior. Delete the old file once migration is verified.
- **Custom utilities/components in the old `tailwind/` folder** weren't ported. Symptom: custom buttons or layouts look unstyled.
- **PHP 7.4 still in CI** → 1.4.x requires 8.1+. Update the CI image.
- **Node < 20** → Tailwind v4 build fails with cryptic errors. `node --version` and update.
- **`bin/magento setup:upgrade` skipped** after a theme-module bump → new view models or schema not registered.

## Original sources

- `references/sources/hyva-themes/upgrading/index.md` — overview, philosophy, process
- `references/sources/hyva-themes/upgrading/upgrade-helper.md` — the `upgrade-helper-tools` package and migration scripts
- `references/sources/hyva-themes/upgrading/changelog-default-theme.md` — release-by-release changes to the default theme
- `references/sources/hyva-themes/upgrading/changelog-theme-module.md` — theme-module changelog
- `references/sources/hyva-themes/upgrading/security-changelog.md` — security-relevant updates
- `references/sources/hyva-themes/upgrading/updating-tailwindcss.md` — Tailwind upgrade philosophy
- `references/sources/hyva-themes/upgrading/upgrading-to-1-1-26.md` through `upgrading-to-1-4-0.md` — version-specific upgrade notes
- `references/sources/hyva-themes/working-with-tailwindcss/updating-to-tailwind-3.md` — earlier v2→v3 migration doc
- `references/sources/hyva-checkout/upgrading/index.md` — Hyvä Checkout upgrade notes
