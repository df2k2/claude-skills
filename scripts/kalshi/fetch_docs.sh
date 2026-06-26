#!/usr/bin/env bash
#
# fetch_docs.sh — refresh Kalshi API source documentation bundled with this skill.
#
# The skill bundles three trees in references/sources/:
#
#   1. openapi-specs/         REST OpenAPI + WebSocket AsyncAPI + Perps OpenAPI YAML
#                              files from docs.kalshi.com
#   2. sdk-snippets/          README + selected source from community/official
#                              Python and TypeScript SDKs
#   3. kalshi-official-docs/  Markdown snapshot of docs.kalshi.com pages
#
# DOCS HOSTING NOTE
# -----------------
# https://docs.kalshi.com/ is fronted by Cloudflare. Plain curl / WebFetch
# requests return HTTP 403 ("Just a moment…") until the Cloudflare challenge
# is solved by a real browser. To refresh the *kalshi-official-docs/* tree
# you need a headless browser (Playwright, Puppeteer, undetected-chromedriver)
# that can clear the interstitial — see the "headless harvest" section below.
#
# However, the YAML/JSON spec files at:
#   https://docs.kalshi.com/openapi.yaml
#   https://docs.kalshi.com/asyncapi.yaml
#   https://docs.kalshi.com/perps_openapi.yaml
# are sometimes served as static assets without the challenge — this script
# tries to fetch them. If they 403, the fetched files will be empty and the
# script will emit a warning; in that case use a headless capture too.
#
# Run from anywhere — paths are computed from this script's location.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEST="$REPO_ROOT/kalshi-api-development/references/sources"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Repo root: $REPO_ROOT"
echo "Dest:      $DEST"
echo "Tmp:       $TMP"
echo ""

mkdir -p "$DEST/openapi-specs" "$DEST/sdk-snippets" "$DEST/kalshi-official-docs"

# ----------------------------------------------------------------------------
# 1. OpenAPI / AsyncAPI / Perps OpenAPI spec files
# ----------------------------------------------------------------------------

echo "==> Fetching OpenAPI / AsyncAPI specs"

UA='Mozilla/5.0 (Macintosh; Intel Mac OS X 14_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.5 Safari/605.1.15'

for f in openapi.yaml asyncapi.yaml perps_openapi.yaml; do
    out="$DEST/openapi-specs/$f"
    echo "  -> https://docs.kalshi.com/$f"
    if curl -fsSL -A "$UA" "https://docs.kalshi.com/$f" -o "$out.tmp" 2>/dev/null; then
        # Cloudflare returns an HTML interstitial body with 200 in some cases —
        # detect that and reject.
        if head -1 "$out.tmp" | grep -qiE '<!doctype|<html|<head'; then
            echo "     WARN: response is HTML (Cloudflare challenge). Need headless capture." >&2
            rm -f "$out.tmp"
        else
            mv "$out.tmp" "$out"
            echo "     OK ($(wc -c <"$out") bytes)"
        fi
    else
        echo "     WARN: fetch failed (likely Cloudflare 403). Use headless capture." >&2
        rm -f "$out.tmp"
    fi
done

# ----------------------------------------------------------------------------
# 2. SDK snippets — clone community Python + TypeScript SDKs and copy snippets
# ----------------------------------------------------------------------------

echo ""
echo "==> Cloning SDK repos for source-of-truth READMEs and selected source"

clone_shallow() {
    local repo_url="$1"
    local target="$2"
    if git clone --depth 1 "$repo_url" "$TMP/$target" 2>/dev/null; then
        echo "  cloned $repo_url"
    else
        echo "  WARN: failed to clone $repo_url" >&2
        return 1
    fi
}

# kalshi-python-sdk (TexasCoding) — comprehensive, MIT, current
clone_shallow https://github.com/TexasCoding/kalshi-python-sdk.git kalshi-python-sdk || true
if [[ -d "$TMP/kalshi-python-sdk" ]]; then
    rm -rf "$DEST/sdk-snippets/kalshi-python-sdk"
    mkdir -p "$DEST/sdk-snippets/kalshi-python-sdk"
    for f in README.md LICENSE CHANGELOG.md pyproject.toml; do
        if [[ -f "$TMP/kalshi-python-sdk/$f" ]]; then
            cp "$TMP/kalshi-python-sdk/$f" "$DEST/sdk-snippets/kalshi-python-sdk/$f"
        fi
    done
    # Selected docs subdirs (markdown only)
    for sub in docs; do
        if [[ -d "$TMP/kalshi-python-sdk/$sub" ]]; then
            mkdir -p "$DEST/sdk-snippets/kalshi-python-sdk/$sub"
            find "$TMP/kalshi-python-sdk/$sub" -type f -name '*.md' | while read -r mf; do
                rel="${mf#$TMP/kalshi-python-sdk/$sub/}"
                mkdir -p "$DEST/sdk-snippets/kalshi-python-sdk/$sub/$(dirname "$rel")"
                cp "$mf" "$DEST/sdk-snippets/kalshi-python-sdk/$sub/$rel"
            done
        fi
    done
fi

# pykalshi (arshka) — unofficial, MIT, real-time focus
clone_shallow https://github.com/arshka/pykalshi.git pykalshi || true
if [[ -d "$TMP/pykalshi" ]]; then
    rm -rf "$DEST/sdk-snippets/pykalshi"
    mkdir -p "$DEST/sdk-snippets/pykalshi"
    for f in README.md LICENSE pyproject.toml setup.py; do
        if [[ -f "$TMP/pykalshi/$f" ]]; then cp "$TMP/pykalshi/$f" "$DEST/sdk-snippets/pykalshi/$f"; fi
    done
fi

# kalshi-client (vaguenebula) — unofficial, MIT, lightweight
clone_shallow https://github.com/vaguenebula/kalshi-client.git kalshi-client || true
if [[ -d "$TMP/kalshi-client" ]]; then
    rm -rf "$DEST/sdk-snippets/kalshi-client"
    mkdir -p "$DEST/sdk-snippets/kalshi-client"
    for f in README.md LICENSE setup.py pyproject.toml; do
        if [[ -f "$TMP/kalshi-client/$f" ]]; then cp "$TMP/kalshi-client/$f" "$DEST/sdk-snippets/kalshi-client/$f"; fi
    done
    if [[ -d "$TMP/kalshi-client/kalshi_client" ]]; then
        cp -r "$TMP/kalshi-client/kalshi_client" "$DEST/sdk-snippets/kalshi-client/kalshi_client"
    fi
fi

# kalshi-python (lowgrind) — legacy "official" v1/v2 swagger-generated
clone_shallow https://github.com/lowgrind/kalshi-python.git kalshi-python-legacy || true
if [[ -d "$TMP/kalshi-python-legacy" ]]; then
    rm -rf "$DEST/sdk-snippets/kalshi-python-legacy"
    mkdir -p "$DEST/sdk-snippets/kalshi-python-legacy"
    for f in README.md LICENSE setup.py; do
        if [[ -f "$TMP/kalshi-python-legacy/$f" ]]; then cp "$TMP/kalshi-python-legacy/$f" "$DEST/sdk-snippets/kalshi-python-legacy/$f"; fi
    done
fi

# ----------------------------------------------------------------------------
# 3. Headless capture of docs.kalshi.com — instructions only
# ----------------------------------------------------------------------------

cat > "$DEST/kalshi-official-docs/README.md" <<'EOF'
# Captured docs.kalshi.com snapshot

This directory holds a markdown snapshot of `https://docs.kalshi.com/`. Because
the site is fronted by Cloudflare, plain `curl` / `WebFetch` requests return
HTTP 403 ("Just a moment…"). To refresh:

## Headless capture recipe

1. **Enumerate the page set** without hitting Cloudflare via the Wayback CDX
   API:

   ```bash
   curl -s "http://web.archive.org/cdx/search/cdx?url=docs.kalshi.com/*&output=text&fl=original&collapse=urlkey&limit=2000" \
     | grep -E '^https://docs\.kalshi\.com/' \
     | grep -vE '/(assets|_next|favicon)|\.(js|css|woff|png|jpg|svg)' \
     > urls.txt
   ```

2. **Render each page** with a headless Chromium that clears the Cloudflare
   challenge. Playwright + a real User-Agent + persistent context to reuse the
   `cf_clearance` cookie is the standard pattern:

   ```python
   from playwright.sync_api import sync_playwright

   urls = open("urls.txt").read().splitlines()
   with sync_playwright() as p:
       browser = p.chromium.launch(headless=True)
       ctx = browser.new_context(user_agent="Mozilla/5.0 (Macintosh; ...)")
       page = ctx.new_page()
       for url in urls:
           page.goto(url, wait_until="networkidle")
           # Wait for the Cloudflare interstitial to clear
           page.wait_for_selector("article, main, .content", timeout=30_000)
           html = page.content()
           # save html to disk, keyed by URL path
   ```

3. **Convert HTML to markdown** with turndown (Node) or markdownify (Python),
   keying each output file by URL path so it mirrors the live site layout.

The captured tree should mirror these top-level sections from docs.kalshi.com:

```
welcome.md
changelog.md
getting_started/
   quick_start_authenticated_requests.md
   quick_start_market_data.md
   historical_data.md
sdks/
   overview.md
api-reference/
   exchange/...
   events/...
   market/...
   orders/...
   portfolio/...
   live-data/...
   ...
```

Until a real capture is bundled, prefer:

- `references/sources/openapi-specs/openapi.yaml` (canonical request/response shape)
- `references/sources/openapi-specs/asyncapi.yaml` (WebSocket channels)
- `references/sources/sdk-snippets/kalshi-python-sdk/` (well-documented community SDK)
EOF

# ----------------------------------------------------------------------------
echo ""
echo "===================="
echo "Sources updated."
echo ""
du -sh "$DEST"/* 2>/dev/null | sort -hr
echo ""
echo "Now: review the diff, regenerate INDEX.md if structure changed, commit."
