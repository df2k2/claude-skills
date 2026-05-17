#!/usr/bin/env bash
#
# fetch_docs.sh — re-clone Adobe Commerce Marketplace EQP documentation
# and copy the markdown content into magento2-marketplace-development/references/sources/.
#
# Drops images and build artifacts to keep the skill lean. Run from anywhere —
# paths are computed from this script's location.
#
# Output: magento2-marketplace-development/references/sources/
#   - commerce-marketplace/        (AdobeDocs/commerce-marketplace)
#   - magento-coding-standard/     (magento/magento-coding-standard rulesets, docs, sniff list)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEST="$REPO_ROOT/magento2-marketplace-development/references/sources"
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

clone_shallow https://github.com/AdobeDocs/commerce-marketplace.git commerce-marketplace
clone_shallow https://github.com/magento/magento-coding-standard.git magento-coding-standard

echo ""
echo "==> Copying commerce-marketplace"
rm -rf "$DEST/commerce-marketplace"
copy_markdown_tree "$TMP/commerce-marketplace/src/pages" "$DEST/commerce-marketplace" "_images images"

echo ""
echo "==> Copying magento-coding-standard rulesets and READMEs"
rm -rf "$DEST/magento-coding-standard"
mkdir -p "$DEST/magento-coding-standard"
# Top-level docs
cp "$TMP/magento-coding-standard/README.md"        "$DEST/magento-coding-standard/README.md"
cp "$TMP/magento-coding-standard/LICENSE.txt"      "$DEST/magento-coding-standard/LICENSE.txt"  2>/dev/null || true
cp "$TMP/magento-coding-standard/composer.json"    "$DEST/magento-coding-standard/composer.json"
# Rulesets
cp "$TMP/magento-coding-standard/Magento2/ruleset.xml"          "$DEST/magento-coding-standard/Magento2-ruleset.xml"
cp "$TMP/magento-coding-standard/Magento2Framework/ruleset.xml" "$DEST/magento-coding-standard/Magento2Framework-ruleset.xml"
# Sniff inventory — produce a flat list of sniff classes
mkdir -p "$DEST/magento-coding-standard/Sniffs"
{
    echo "# Magento2 PHP_CodeSniffer sniffs (inventory)"
    echo ""
    echo "Each row is a sniff class shipped by magento/magento-coding-standard."
    echo "Reference name is the short form used in ruleset.xml \`<rule ref=\"...\">\`."
    echo ""
    echo "| Reference name | File |"
    echo "| --- | --- |"
    find "$TMP/magento-coding-standard/Magento2/Sniffs" -name '*Sniff.php' | sort | while read -r f; do
        rel="${f#$TMP/magento-coding-standard/}"
        # Build short ref name: Magento2.Category.SniffName
        cat=$(echo "$rel" | sed -E 's|Magento2/Sniffs/([^/]+)/(.+)Sniff\.php|\1|')
        name=$(echo "$rel" | sed -E 's|Magento2/Sniffs/([^/]+)/(.+)Sniff\.php|\2|')
        echo "| Magento2.${cat}.${name} | ${rel} |"
    done
} > "$DEST/magento-coding-standard/Sniffs/INDEX.md"
# Per-sniff documentation that ships in repo (if any)
if [[ -d "$TMP/magento-coding-standard/Magento2/Docs" ]]; then
    cp -r "$TMP/magento-coding-standard/Magento2/Docs" "$DEST/magento-coding-standard/Magento2-Docs"
fi

echo ""
echo "===================="
echo "Sources updated."
echo ""
du -sh "$DEST"/* | sort -hr
echo ""
echo "Now: review the diff, regenerate INDEX.md if structure changed, commit."
