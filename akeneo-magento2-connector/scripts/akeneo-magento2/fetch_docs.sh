#!/usr/bin/env bash
#
# fetch_docs.sh — refresh the embedded Akeneo Connector for Magento 2 source-of-truth.
#
# Vendors the full official module into this skill's references/sources/ tree:
#
#   magento2-connector-source/   the akeneo/magento2-connector-community module, pinned at a tag
#                                (Api Block Console Controller Converter Cron Executor Helper Job
#                                 Logger Model Observer Setup Ui ViewModel etc i18n view
#                                 + README.md + CHANGELOG.md + composer.json + registration.php + LICENSE*)
#
# The module IS the source of truth for connector behavior — the curated references in this
# skill summarize it, but when in doubt, read the vendored source.
#
# The repo is public and clones over HTTPS with no auth. If your network proxies egress,
# export HTTPS_PROXY / ALL_PROXY and git will use it.
#
# Usage:
#   bash scripts/akeneo-magento2/fetch_docs.sh                 # pin to $CONNECTOR_TAG (default below)
#   CONNECTOR_TAG=v105.1.2 bash scripts/akeneo-magento2/fetch_docs.sh
#   CONNECTOR_TAG=latest   bash scripts/akeneo-magento2/fetch_docs.sh   # newest tag
#
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"          # .../akeneo-magento2-connector
DEST="$SKILL_ROOT/references/sources/magento2-connector-source"
REPO="https://github.com/akeneo/magento2-connector-community"
CONNECTOR_TAG="${CONNECTOR_TAG:-v105.1.2}"

# strip binaries/media we never want in the vendored copy
PRUNE_GLOBS=(-iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif'
             -o -iname '*.svg' -o -iname '*.woff*' -o -iname '*.ttf' -o -iname '*.eot'
             -o -iname '*.mp4' -o -iname '*.ico')

command -v git >/dev/null || { echo "git not available — cannot fetch"; exit 1; }
before_bytes="$(du -s "$DEST" 2>/dev/null | cut -f1)"

tmpd="$(mktemp -d)"; trap 'rm -rf "$tmpd"' EXIT

resolve_and_clone() {
  local tag="$1"
  if [ "$tag" = "latest" ]; then
    # newest tag by version sort via ls-remote
    tag="$(git ls-remote --tags --refs "$REPO" 2>/dev/null \
            | awk -F/ '{print $NF}' | sort -V | tail -1)"
    [ -n "$tag" ] || { echo "could not resolve latest tag"; return 1; }
    echo "  resolved latest tag: $tag"
  fi
  GIT_TERMINAL_PROMPT=0 git clone --depth 1 --branch "$tag" -q "$REPO" "$tmpd/c" 2>/dev/null \
    && { echo "$tag" > "$tmpd/.tag"; return 0; }
  return 1
}

echo "== clone $REPO @ $CONNECTOR_TAG =="
if ! resolve_and_clone "$CONNECTOR_TAG"; then
  echo "  tag '$CONNECTOR_TAG' clone failed — trying default branch (master)"
  GIT_TERMINAL_PROMPT=0 git clone --depth 1 -q "$REPO" "$tmpd/c" 2>/dev/null \
    || { echo "  clone FAILED (network/proxy?) — left existing snapshot untouched"; exit 1; }
  echo "master" > "$tmpd/.tag"
fi
RESOLVED="$(cat "$tmpd/.tag")"

# copy tree without .git, pruning media
rm -rf "$DEST"; mkdir -p "$DEST"
( cd "$tmpd/c" && rm -rf .git && find . \( "${PRUNE_GLOBS[@]}" \) -type f -delete 2>/dev/null; true )
cp -R "$tmpd/c/." "$DEST/"
echo "$RESOLVED" > "$DEST/.source-tag"

after_bytes="$(du -s "$DEST" 2>/dev/null | cut -f1)"
echo
echo "vendored connector @ $RESOLVED"
echo "  top-level: $(cd "$DEST" && ls -d */ 2>/dev/null | tr -d '/' | tr '\n' ' ')"
echo "  jobs:      $(cd "$DEST/Job" 2>/dev/null && ls *.php 2>/dev/null | tr '\n' ' ')"
echo "  size: ${before_bytes:-0}K -> ${after_bytes:-0}K (blocks)"
# sanity: confirm it is the connector
if grep -q 'akeneo/module-magento2-connector-community' "$DEST/composer.json" 2>/dev/null; then
  echo "✅ done — connector source refreshed."
else
  echo "⚠ composer.json identity check failed — verify the vendored source."; exit 1
fi
