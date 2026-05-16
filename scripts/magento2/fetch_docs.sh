#!/usr/bin/env bash
#
# fetch_docs.sh — re-clone Adobe Commerce / Magento 2 documentation repos
# and copy the markdown content into magento2-development/references/sources/.
#
# Drops images, build artifacts, and the older v2.3 tree to keep the skill lean.
# Run from the repo root, or from anywhere — paths are computed from this script's
# location.
#
# Output: magento2-development/references/sources/
#   - commerce-php/                 (AdobeDocs/commerce-php)
#   - commerce-webapi/              (AdobeDocs/commerce-webapi)
#   - commerce-webapi-openapi/      (OpenAPI YAML schemas from commerce-webapi)
#   - commerce-frontend-core/       (AdobeDocs/commerce-frontend-core)
#   - devdocs-v2.4/                 (magento/devdocs, v2.4 tree only)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEST="$REPO_ROOT/magento2-development/references/sources"
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

copy_markdown_tree() {
    # Copy every .md/.mdx file under $src, excluding image dirs, into $dest.
    local src="$1"
    local dest="$2"
    local exclude_dirs="${3:-}"   # space-separated path patterns

    mkdir -p "$dest"
    pushd "$src" > /dev/null

    local find_args=( . -type f \( -name '*.md' -o -name '*.mdx' \) )
    # Build exclusion args
    if [[ -n "$exclude_dirs" ]]; then
        for pat in $exclude_dirs; do
            find_args+=( -not -path "./$pat/*" )
        done
    fi

    find "${find_args[@]}" | while read -r f; do
        mkdir -p "$dest/$(dirname "$f")"
        cp "$f" "$dest/$f"
    done

    popd > /dev/null
}

clone_shallow https://github.com/AdobeDocs/commerce-php.git commerce-php
clone_shallow https://github.com/AdobeDocs/commerce-webapi.git commerce-webapi
clone_shallow https://github.com/AdobeDocs/commerce-frontend-core.git commerce-frontend-core
clone_shallow https://github.com/magento/devdocs.git devdocs

echo ""
echo "==> Copying commerce-php"
rm -rf "$DEST/commerce-php"
copy_markdown_tree "$TMP/commerce-php/src/pages" "$DEST/commerce-php" "images _data"

echo ""
echo "==> Copying commerce-webapi"
rm -rf "$DEST/commerce-webapi"
copy_markdown_tree "$TMP/commerce-webapi/src/pages" "$DEST/commerce-webapi" "_images images"

echo ""
echo "==> Copying commerce-webapi OpenAPI schemas"
rm -rf "$DEST/commerce-webapi-openapi"
mkdir -p "$DEST/commerce-webapi-openapi"
if [[ -d "$TMP/commerce-webapi/src/openapi" ]]; then
    cp -r "$TMP/commerce-webapi/src/openapi/"* "$DEST/commerce-webapi-openapi/"
fi

echo ""
echo "==> Copying commerce-frontend-core"
rm -rf "$DEST/commerce-frontend-core"
copy_markdown_tree "$TMP/commerce-frontend-core/src/pages" "$DEST/commerce-frontend-core" "images"

echo ""
echo "==> Copying devdocs v2.4"
rm -rf "$DEST/devdocs-v2.4"
copy_markdown_tree "$TMP/devdocs/src/guides/v2.4" "$DEST/devdocs-v2.4" "images _images"

echo ""
echo "===================="
echo "Sources updated."
echo ""
du -sh "$DEST"/* | sort -hr
echo ""
echo "Now: review the diff, regenerate INDEX.md if structure changed, commit."
