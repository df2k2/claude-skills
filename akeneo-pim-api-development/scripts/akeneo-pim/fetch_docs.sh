#!/usr/bin/env bash
#
# fetch_docs.sh — refresh the embedded Akeneo PIM API source-of-truth files.
#
# Vendors, into this skill's references/sources/ tree:
#
#   openapi-specs/
#     saas-openapi.json          SaaS/Serenity Web API   (OpenAPI 3.1.0)  — the modern surface
#     classic-web-api.json/.yaml Classic CE/EE REST      (Swagger)        — on-prem/PaaS surface
#     classic-swagger-src/       the split swagger source (definitions/parameters/paths/responses + resources)
#   postman/
#     akeneo-postman-collection.json   152 example requests (Postman v2.1)
#   api-php-client-source/       vendored akeneo/api-php-client (src + README + CHANGELOG + composer.json + LICENCE)
#   akeneo-official-docs/        curated prose from akeneo/pim-api-docs content/ (allow-list below)
#
# All Akeneo sources are PUBLIC and return HTTP 200 to any normal client — there is NO
# Cloudflare/JS challenge and (unlike some other providers) no known DNS/category filtering.
# If your corporate network proxies egress, export HTTPS_PROXY / ALL_PROXY and this script
# will pass it through to curl and git.
#
# Usage:
#   bash scripts/akeneo-pim/fetch_docs.sh
#   HTTPS_PROXY=http://proxy:3128 bash scripts/akeneo-pim/fetch_docs.sh
#
# After running, regenerate the flat catalog:
#   python3 scripts/akeneo-pim/gen_spec_summary.py
#
set -uo pipefail

# --- resolve paths relative to this script ----------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"          # .../akeneo-pim-api-development
SRC="$SKILL_ROOT/references/sources"
SPECS_DIR="$SRC/openapi-specs"
POSTMAN_DIR="$SRC/postman"
PHPCLIENT_DIR="$SRC/api-php-client-source"
DOCS_DIR="$SRC/akeneo-official-docs"
UA="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36"

# --- upstream coordinates (pin here) ----------------------------------------
SAAS_OPENAPI_URL="https://storage.googleapis.com/akecld-prd-pim-saas-shared-openapi-spec/openapi.json"
POSTMAN_URL="https://api.akeneo.com/files/akeneo-postman-collection.json"
PIM_API_DOCS_REPO="https://github.com/akeneo/pim-api-docs"
PHP_CLIENT_REPO="https://github.com/akeneo/api-php-client"
PHP_CLIENT_TAG="${PHP_CLIENT_TAG:-11.4.0}"            # connector pins 11.4.0; falls back to default branch
# content/ subdirs to vendor (prose). fonts/img/files/news deliberately excluded.
DOCS_ALLOW=(rest-api concepts getting-started guides tutorials \
            event-platform events-api events-reference \
            apps app-portal graphql php-client mapping mcp \
            extensions advanced-extensions px-insights supplier-data-manager misc)

mkdir -p "$SPECS_DIR" "$POSTMAN_DIR" "$PHPCLIENT_DIR" "$DOCS_DIR"

before_bytes="$(du -s "$SRC" 2>/dev/null | cut -f1)"
FAILS=0

# fetch_url URL OUTFILE
fetch_url() {
  local url="$1" out="$2" tmp rc
  tmp="$(mktemp)"
  curl -fsSL -A "$UA" --max-time 180 --retry 3 --retry-delay 2 -o "$tmp" "$url"; rc=$?
  if [ $rc -ne 0 ]; then rm -f "$tmp"; echo "FAIL curl_rc=$rc"; return 1; fi
  if [ ! -s "$tmp" ]; then rm -f "$tmp"; echo "FAIL empty"; return 1; fi
  mv "$tmp" "$out"; echo "OK $(wc -c <"$out")"
}

echo "== direct downloads =="
printf '  %-28s ' "saas-openapi.json"
res="$(fetch_url "$SAAS_OPENAPI_URL" "$SPECS_DIR/saas-openapi.json")"; echo "$res"; [[ "$res" == OK* ]] || FAILS=$((FAILS+1))
printf '  %-28s ' "akeneo-postman-collection.json"
res="$(fetch_url "$POSTMAN_URL" "$POSTMAN_DIR/akeneo-postman-collection.json")"; echo "$res"; [[ "$res" == OK* ]] || FAILS=$((FAILS+1))

# --- pim-api-docs: sparse clone content/, copy allow-listed prose + swagger --
echo; echo "== pim-api-docs (prose + classic swagger) =="
if command -v git >/dev/null; then
  tmpd="$(mktemp -d)"
  if GIT_TERMINAL_PROMPT=0 git clone --depth 1 --filter=blob:none --sparse -q "$PIM_API_DOCS_REPO" "$tmpd/repo" 2>/dev/null; then
    ( cd "$tmpd/repo" && git sparse-checkout set content >/dev/null 2>&1 )
    C="$tmpd/repo/content"
    # prose allow-list
    for d in "${DOCS_ALLOW[@]}"; do
      if [ -d "$C/$d" ]; then
        rm -rf "$DOCS_DIR/$d"; mkdir -p "$DOCS_DIR/$d"
        cp -R "$C/$d/." "$DOCS_DIR/$d/" 2>/dev/null && printf '  prose %-22s copied\n' "$d" || printf '  prose %-22s COPY FAILED\n' "$d"
      fi
    done
    # classic swagger spec
    if [ -d "$C/swagger" ]; then
      cp -f "$C/swagger/akeneo-web-api.json" "$SPECS_DIR/classic-web-api.json" 2>/dev/null && echo "  classic-web-api.json          copied"
      cp -f "$C/swagger/akeneo-web-api.yaml" "$SPECS_DIR/classic-web-api.yaml" 2>/dev/null && echo "  classic-web-api.yaml          copied"
      rm -rf "$SPECS_DIR/classic-swagger-src"; mkdir -p "$SPECS_DIR/classic-swagger-src"
      cp -R "$C/swagger/." "$SPECS_DIR/classic-swagger-src/" 2>/dev/null && echo "  classic-swagger-src/          copied"
      rm -f "$SPECS_DIR/classic-swagger-src/akeneo-web-api.json" "$SPECS_DIR/classic-swagger-src/akeneo-web-api.yaml"
    fi
    # record provenance
    ( cd "$tmpd/repo" && git rev-parse HEAD 2>/dev/null > "$DOCS_DIR/.source-commit" )
  else
    echo "  clone FAILED (network/proxy?) — left existing snapshot untouched"; FAILS=$((FAILS+1))
  fi
  rm -rf "$tmpd"
else
  echo "  git not available — skipping"; FAILS=$((FAILS+1))
fi

# --- api-php-client: shallow clone at tag, copy src + meta -------------------
echo; echo "== api-php-client (source) =="
if command -v git >/dev/null; then
  tmpd="$(mktemp -d)"
  cloned=0
  if GIT_TERMINAL_PROMPT=0 git clone --depth 1 --branch "v$PHP_CLIENT_TAG" -q "$PHP_CLIENT_REPO" "$tmpd/c" 2>/dev/null; then
    cloned=1; resolved="v$PHP_CLIENT_TAG"
  elif GIT_TERMINAL_PROMPT=0 git clone --depth 1 --branch "$PHP_CLIENT_TAG" -q "$PHP_CLIENT_REPO" "$tmpd/c" 2>/dev/null; then
    cloned=1; resolved="$PHP_CLIENT_TAG"
  elif GIT_TERMINAL_PROMPT=0 git clone --depth 1 -q "$PHP_CLIENT_REPO" "$tmpd/c" 2>/dev/null; then
    cloned=1; resolved="$(cd "$tmpd/c" && git describe --tags 2>/dev/null || echo master)"
    echo "  (tag v$PHP_CLIENT_TAG not found — vendored default branch: $resolved)"
  fi
  if [ "$cloned" = 1 ]; then
    rm -rf "$PHPCLIENT_DIR"; mkdir -p "$PHPCLIENT_DIR"
    cp -R "$tmpd/c/src" "$PHPCLIENT_DIR/" 2>/dev/null
    for f in README.md CHANGELOG.md composer.json LICENCE.txt LICENSE.txt LICENSE.md; do
      [ -f "$tmpd/c/$f" ] && cp -f "$tmpd/c/$f" "$PHPCLIENT_DIR/$f"
    done
    echo "$resolved" > "$PHPCLIENT_DIR/.source-tag"
    echo "  api-php-client vendored @ $resolved"
  else
    echo "  clone FAILED — left existing snapshot untouched"; FAILS=$((FAILS+1))
  fi
  rm -rf "$tmpd"
else
  echo "  git not available — skipping"; FAILS=$((FAILS+1))
fi

# --- validation -------------------------------------------------------------
echo; echo "== validation =="
if command -v python3 >/dev/null; then
  python3 - "$SPECS_DIR/saas-openapi.json" <<'PY' 2>/dev/null || { echo "  !! saas-openapi.json invalid JSON"; FAILS=$((FAILS+1)); }
import sys, json
d=json.load(open(sys.argv[1]))
paths=d.get("paths",{})
ops=sum(1 for p in paths.values() for m in p if m in ("get","post","put","patch","delete"))
print("  saas-openapi.json  openapi=%s  paths=%d  ops=%d  schemas=%d  tags=%d" % (
    d.get("openapi"), len(paths), ops, len(d.get("components",{}).get("schemas",{})), len(d.get("tags",[]))))
PY
  [ -s "$POSTMAN_DIR/akeneo-postman-collection.json" ] && python3 -c "import json,sys; json.load(open(sys.argv[1])); print('  postman collection    valid JSON')" "$POSTMAN_DIR/akeneo-postman-collection.json" 2>/dev/null || { echo "  !! postman invalid"; FAILS=$((FAILS+1)); }
  if [ -s "$SPECS_DIR/classic-web-api.json" ]; then
    python3 -c "import json,sys; d=json.load(open(sys.argv[1])); print('  classic-web-api.json  swagger=%s paths=%d' % (d.get('swagger') or d.get('openapi'), len(d.get('paths',{}))))" "$SPECS_DIR/classic-web-api.json" 2>/dev/null || echo "  (classic-web-api.json present, non-fatal parse note)"
  fi
else
  echo "  (python3 not available — skipping JSON validation)"
fi

# --- summary ----------------------------------------------------------------
after_bytes="$(du -s "$SRC" 2>/dev/null | cut -f1)"
echo; echo "sources size: ${before_bytes:-0}K -> ${after_bytes:-0}K  (blocks)"
if [ "$FAILS" -eq 0 ]; then
  echo "✅ done — all Akeneo PIM artifacts refreshed."
  echo "   next: python3 scripts/akeneo-pim/gen_spec_summary.py"
else
  echo "⚠ $FAILS artifact(s) failed. If curl_rc in {6,7,35,60} you have a DNS/proxy/TLS issue —"
  echo "  set HTTPS_PROXY/ALL_PROXY to a working egress and re-run."
  exit 1
fi
