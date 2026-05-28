#!/usr/bin/env bash
#
# fetch_docs.sh — re-clone community Gelato SDKs and copy their source into
# gelato-api-development/references/sources/.
#
# The official Gelato API documentation (dashboard.gelato.com/docs) is gated
# behind a SaaS portal that returns HTTP 403 to unauthenticated GETs, so it
# cannot be bundled here directly. The two community SDKs below are the best
# publicly-redistributable source-of-truth for endpoint shapes, base URLs, and
# request/response type definitions.
#
# Output: gelato-api-development/references/sources/
#   - gelato-admin-node/     (ekkolon/gelato-admin-node, Apache-2.0; v3/v4 endpoints)
#   - npm-gelato-api/        (gelato-api/npm-gelato-api, MIT; legacy v2 endpoints; kept
#                            for historical context — do not use for new code)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEST="$REPO_ROOT/gelato-api-development/references/sources"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Repo root: $REPO_ROOT"
echo "Dest:      $DEST"
echo "Tmp:       $TMP"
echo ""

mkdir -p "$DEST"

clone_shallow() {
    local repo_url="$1"
    local target="$2"
    echo "==> Cloning $repo_url"
    git clone --depth 1 "$repo_url" "$TMP/$target"
}

clone_shallow https://github.com/ekkolon/gelato-admin-node.git gelato-admin-node
clone_shallow https://github.com/gelato-api/npm-gelato-api.git  npm-gelato-api

# ekkolon/gelato-admin-node — copy README, LICENSE, and the entire src/ tree
echo ""
echo "==> Copying gelato-admin-node (Apache-2.0, current v3/v4 endpoints)"
rm -rf "$DEST/gelato-admin-node"
mkdir -p "$DEST/gelato-admin-node"
cp "$TMP/gelato-admin-node/README.md"   "$DEST/gelato-admin-node/README.md"
cp "$TMP/gelato-admin-node/LICENSE"     "$DEST/gelato-admin-node/LICENSE"
cp "$TMP/gelato-admin-node/package.json" "$DEST/gelato-admin-node/package.json"
cp -r "$TMP/gelato-admin-node/src"      "$DEST/gelato-admin-node/src"

# npm-gelato-api — kept for legacy v2 reference only
echo ""
echo "==> Copying npm-gelato-api (MIT, legacy v2 endpoints — historical)"
rm -rf "$DEST/npm-gelato-api"
mkdir -p "$DEST/npm-gelato-api"
cp "$TMP/npm-gelato-api/README.md"     "$DEST/npm-gelato-api/README.md"
cp "$TMP/npm-gelato-api/main.js"       "$DEST/npm-gelato-api/main.js"
cp "$TMP/npm-gelato-api/package.json"  "$DEST/npm-gelato-api/package.json"

echo ""
echo "===================="
echo "Sources updated."
echo ""
du -sh "$DEST"/* | sort -hr
echo ""
echo "Now: review the diff, regenerate INDEX.md if structure changed, commit."
