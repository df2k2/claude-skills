#!/usr/bin/env bash
# Re-vendors the INSPINIA Tailwind demo (https://webapplayers.com/inspinia/tailwind/)
# into references/sources/ so the skill can be refreshed when WebAppLayers ships a new build.
#
# What it fetches:
#   pages/*.html          every HTML page linked from index.html (+ index.html itself)
#   assets/js/config.js   theme/layout config (data-* attributes on <html>)
#   assets/js/app.js      template runtime (layout switcher, theme customizer, card actions, ...)
#   assets/css/app.min.css compiled Tailwind build (used to recover design tokens)
#   assets/js/pages/*.js  per-page init scripts referenced by the pages (how each plugin is wired up)
#   MANIFEST-*.txt        inventories of pages, page scripts, and third-party plugin assets
#
# It does NOT download third-party vendor libraries under assets/plugins/ (ApexCharts, ECharts,
# DataTables, ...). Those are recorded in MANIFEST-plugins.txt and are all available from npm/CDN.
#
# Usage:  bash inspinia-tailwind-frontend-design/scripts/inspinia/fetch_pages.sh
#         INSPINIA_OUT_DIR=/tmp/x bash …/fetch_pages.sh   # dry run into another directory
#         PARALLEL=4 bash …/fetch_pages.sh                 # fewer concurrent downloads
set -euo pipefail

BASE_URL="${INSPINIA_BASE_URL:-https://webapplayers.com/inspinia/tailwind}"
UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUT="${INSPINIA_OUT_DIR:-$SKILL_DIR/references/sources}"   # override to test into a scratch dir
PAGES="$OUT/pages"
ASSETS="$OUT/assets"
PARALLEL="${PARALLEL:-8}"

mkdir -p "$PAGES" "$ASSETS/js/pages" "$ASSETS/css"

before_size=$(du -sk "$OUT" | cut -f1)

fetch() { # fetch <relative-path> <dest-file>   (returns 1 and removes the file on a non-200 response)
  local code
  code=$(curl -sSL --retry 3 --retry-delay 2 -A "$UA" -o "$2" -w '%{http_code}' "$BASE_URL/$1") || { rm -f "$2"; return 1; }
  [ "$code" = "200" ] || { rm -f "$2"; echo "    !! $1 -> HTTP $code (skipped)" >&2; return 1; }
}
export -f fetch
export BASE_URL UA

echo "==> index.html"
fetch index.html "$PAGES/index.html"

echo "==> collecting page list"
grep -oE 'href="[^"#?]+\.html[^"]*"' "$PAGES/index.html" \
  | sed -E 's/^href="//; s/"$//; s/[?#].*$//' \
  | grep -vE '^(https?:)?//' \
  | sort -u > "$OUT/MANIFEST-pages.txt"
echo "    $(wc -l < "$OUT/MANIFEST-pages.txt") pages"

echo "==> downloading pages ($PARALLEL parallel)"
xargs -P "$PARALLEL" -I{} bash -c 'fetch "{}" "'"$PAGES"'/{}" && echo "    {}" || true' < "$OUT/MANIFEST-pages.txt" | sort

# Second pass: pages linked only from sub-pages (sidebar is identical everywhere, but be safe)
cat "$PAGES"/*.html | grep -oE 'href="[^"#?]+\.html[^"]*"' \
  | sed -E 's/^href="//; s/"$//; s/[?#].*$//' | grep -vE '^(https?:)?//' | sort -u > "$OUT/.all-links.txt"
comm -13 "$OUT/MANIFEST-pages.txt" "$OUT/.all-links.txt" > "$OUT/.missing.txt" || true
if [ -s "$OUT/.missing.txt" ]; then
  echo "==> second pass: $(wc -l < "$OUT/.missing.txt") pages linked only from sub-pages"
  while read -r p; do
    if fetch "$p" "$PAGES/$p"; then echo "    $p"; fi   # dead links in the demo sidebar (404) are skipped
  done < "$OUT/.missing.txt"
  ls "$PAGES" | sort > "$OUT/MANIFEST-pages.txt"
fi
rm -f "$OUT/.all-links.txt" "$OUT/.missing.txt"

echo "==> template assets"
fetch assets/js/config.js   "$ASSETS/js/config.js"
fetch assets/js/app.js      "$ASSETS/js/app.js"
fetch assets/css/app.min.css "$ASSETS/css/app.min.css"

echo "==> per-page scripts"
cat "$PAGES"/*.html | grep -oE 'src="assets/js/pages/[^"]+"' | sed -E 's/^src="//; s/"$//' | sort -u > "$OUT/MANIFEST-page-scripts.txt"
while read -r s; do fetch "$s" "$ASSETS/${s#assets/}"; done < "$OUT/MANIFEST-page-scripts.txt"
echo "    $(wc -l < "$OUT/MANIFEST-page-scripts.txt") scripts"

echo "==> plugin manifest (third-party libs, not downloaded)"
cat "$PAGES"/*.html | grep -oE '(src|href)="assets/plugins/[^"]+"' | sed -E 's/^(src|href)="//; s/"$//' | sort -u > "$OUT/MANIFEST-plugins.txt"
echo "    $(wc -l < "$OUT/MANIFEST-plugins.txt") plugin assets referenced"

echo "==> page -> scripts/plugins map"
{
  echo "# page | page-script | plugin assets"
  for f in "$PAGES"/*.html; do
    p=$(basename "$f")
    ps=$( (grep -oE 'src="assets/js/pages/[^"]+"' "$f" || true) | sed -E 's/^src="assets\/js\/pages\///; s/"$//' | tr '\n' ' ')
    pl=$( (grep -oE '(src|href)="assets/plugins/[^"]+"' "$f" || true) | sed -E 's/^(src|href)="assets\/plugins\///; s/"$//' | tr '\n' ' ')
    echo "$p | ${ps:-–} | ${pl:-–}"
  done
} > "$OUT/MANIFEST-page-deps.txt"

date -u +"fetched: %Y-%m-%dT%H:%M:%SZ from $BASE_URL" > "$OUT/FETCHED.txt"

after_size=$(du -sk "$OUT" | cut -f1)
echo "==> done. sources/: ${before_size}K -> ${after_size}K"
