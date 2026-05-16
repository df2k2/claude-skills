#!/usr/bin/env bash
#
# fetch_docs.sh — refresh source documentation for the printful-api-development skill.
#
# Pulls the v2 OpenAPI spec (currently hosted in a community SDK repo since
# developers.printful.com is firewalled from this environment) and the official
# v1 PHP SDK files, then re-generates the auto-generated endpoint and schema
# catalogs.
#
# Run from the repo root, or from anywhere — paths are computed from this script's
# location.
#
# Output:
#   printful-api-development/references/sources/printful-v2-openapi.json
#   printful-api-development/references/sources/printful-v2-endpoints.md
#   printful-api-development/references/sources/printful-v2-schemas.md
#   printful-api-development/references/sources/Printful*.php

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DEST="$REPO_ROOT/printful-api-development/references/sources"

# Source URLs.
#
# The official Printful developer site (https://developers.printful.com/openapi.json)
# is the canonical source for the OpenAPI v2 spec. When this script is run from
# an environment with unrestricted network access, prefer that URL by setting:
#
#   PRINTFUL_OPENAPI_URL=https://developers.printful.com/openapi.json
#
# Otherwise we fall back to a community mirror that is kept reasonably current.
OPENAPI_URL="${PRINTFUL_OPENAPI_URL:-https://raw.githubusercontent.com/spencerlepine/printful-sdk-js-v2/main/openapi.json}"
PHP_SDK_BASE="${PRINTFUL_PHP_SDK_BASE:-https://raw.githubusercontent.com/printful/php-api-sdk/master/src}"

mkdir -p "$DEST"

echo "==> Fetching v2 OpenAPI spec"
echo "    from: $OPENAPI_URL"
curl -sSfL "$OPENAPI_URL" -o "$DEST/printful-v2-openapi.json"
ls -lh "$DEST/printful-v2-openapi.json"

echo ""
echo "==> Fetching official v1 PHP SDK class files"
for f in PrintfulApiClient.php PrintfulOrder.php PrintfulProducts.php \
         PrintfulMockupGenerator.php PrintfulTaxRates.php PrintfulWebhook.php; do
    echo "    $f"
    curl -sSfL "$PHP_SDK_BASE/$f" -o "$DEST/$f"
done

echo ""
echo "==> Regenerating auto-generated endpoint catalog"
python3 - <<PYEOF
import json
from collections import defaultdict

with open("$DEST/printful-v2-openapi.json") as f:
    spec = json.load(f)

paths = spec.get('paths', {})
by_tag = defaultdict(list)
for path, methods in paths.items():
    for method, op in methods.items():
        if method not in ('get','post','put','patch','delete'):
            continue
        tags = op.get('tags', ['untagged'])
        summary = op.get('summary', '')
        op_id = op.get('operationId', '')
        desc = op.get('description', '')
        params = []
        for p in op.get('parameters', []):
            if '\$ref' in p:
                continue
            params.append((p.get('in',''), p.get('name',''), p.get('required',False), (p.get('schema') or {}).get('type','')))
        req_body = ''
        rb = op.get('requestBody', {})
        if rb:
            for mt, ms in rb.get('content', {}).items():
                ref = (ms.get('schema') or {}).get('\$ref','')
                if ref:
                    req_body = f"\`{mt}\` → \`{ref.split('/')[-1]}\`"
                else:
                    req_body = mt
                break
        resp_schemas = []
        for code, rd in op.get('responses', {}).items():
            if not code.startswith('2'):
                continue
            for mt, ms in (rd.get('content') or {}).items():
                ref = (ms.get('schema') or {}).get('\$ref','')
                if ref:
                    resp_schemas.append((code, ref.split('/')[-1]))
        for t in tags:
            by_tag[t].append({'method': method.upper(),'path': path,'summary': summary,'op_id': op_id,'desc': desc,'params': params,'req_body': req_body,'resp_schemas': resp_schemas})

preferred = ['Catalog v2', 'Orders v2', 'Files v2', 'Mockup Generator v2', 'Shipping Rates v2', 'Countries v2', 'Warehouse Products v2', 'Approval Sheets v2', 'Stores v2', 'Webhook v2', 'OAuth Scopes v2', 'Localisation', 'Rate Limiting', 'Examples']
ordered_tags = [t for t in preferred if t in by_tag] + [t for t in by_tag if t not in preferred]

out = []
out.append("# Printful API v2 — Endpoint Catalog\n")
out.append("Auto-generated from \`printful-v2-openapi.json\` (OpenAPI " + spec['info']['version'] + ").\n")
out.append(f"Base URL: \`{spec['servers'][0]['url']}\`\n")
out.append("All paths are prefixed \`/v2\`. Authentication: OAuth Bearer token (\`Authorization: Bearer {token}\`).\n")
out.append("\n## Contents\n")
for tag in ordered_tags:
    anchor = tag.lower().replace(' ', '-')
    out.append(f"- [{tag}](#{anchor}) — {len(by_tag[tag])} endpoint(s)")
out.append("")
for tag in ordered_tags:
    out.append(f"\n## {tag}\n")
    for op in by_tag[tag]:
        out.append(f"### \`{op['method']} {op['path']}\`\n")
        if op['summary']:
            out.append(f"**{op['summary']}**\n")
        if op['op_id']:
            out.append(f"- \`operationId\`: \`{op['op_id']}\`")
        if op['req_body']:
            out.append(f"- Request body: {op['req_body']}")
        for code, sname in op['resp_schemas']:
            out.append(f"- Response \`{code}\`: \`{sname}\`")
        if op['params']:
            out.append("- Parameters:")
            for loc, name, required, typ in op['params']:
                req = ' **required**' if required else ''
                t = f' ({typ})' if typ else ''
                out.append(f"  - \`{name}\` — {loc}{t}{req}")
        if op['desc']:
            d = op['desc'].strip().replace('\r','')
            if len(d) > 600:
                d = d[:600] + '…'
            out.append(f"\n{d}\n")
        else:
            out.append("")
with open("$DEST/printful-v2-endpoints.md","w") as f:
    f.write("\n".join(out) + "\n")
print("    wrote $DEST/printful-v2-endpoints.md")
PYEOF

echo ""
echo "==> Regenerating auto-generated schema catalog"
python3 - <<PYEOF
import json

with open("$DEST/printful-v2-openapi.json") as f:
    spec = json.load(f)

schemas = spec.get('components', {}).get('schemas', {})
out = []
out.append("# Printful API v2 — Schema Catalog\n")
out.append("Auto-generated from the OpenAPI spec. Lists every schema with its fields, types, and (when present) descriptions and enum values.\n")

def render(name, s):
    out.append(f"\n## \`{name}\`\n")
    if s.get('description'):
        out.append(s['description'].strip() + "\n")
    if s.get('type') == 'object' or 'properties' in s:
        props = s.get('properties', {}) or {}
        req = set(s.get('required', []) or [])
        if not props:
            out.append("_(no properties)_\n")
            return
        out.append("| Field | Type | Req | Description |")
        out.append("|---|---|---|---|")
        for fname, fdef in props.items():
            ftype = fdef.get('type','')
            ref = fdef.get('\$ref') or (fdef.get('items') or {}).get('\$ref','')
            if ref:
                refname = ref.split('/')[-1]
                if ftype == 'array' or (fdef.get('items') and not fdef.get('type') == 'object'):
                    ftype = f"array of [\`{refname}\`](#{refname.lower()})"
                else:
                    ftype = f"[\`{refname}\`](#{refname.lower()})"
            elif ftype == 'array':
                it = fdef.get('items') or {}
                inner = it.get('type', 'object')
                ftype = f"array of {inner}"
            enum = fdef.get('enum')
            desc_parts = []
            d = fdef.get('description', '')
            if d:
                desc_parts.append(d.strip().replace('\n',' '))
            if enum:
                desc_parts.append('Enum: ' + ', '.join(f'\`{e}\`' for e in enum))
            if 'example' in fdef:
                ex = fdef['example']
                if isinstance(ex, (str,int,float,bool)):
                    desc_parts.append(f'Example: \`{ex}\`')
            mark = '✓' if fname in req else ''
            desc = ' '.join(desc_parts).replace('|','\\\\|')
            if len(desc) > 240:
                desc = desc[:240] + '…'
            out.append(f"| \`{fname}\` | {ftype} | {mark} | {desc} |")
    elif 'enum' in s:
        out.append(f"Type: \`{s.get('type','')}\` — enum.\n")
        out.append("Values:")
        for v in s['enum']:
            out.append(f"- \`{v}\`")
        out.append("")
    elif 'oneOf' in s or 'anyOf' in s or 'allOf' in s:
        key = 'oneOf' if 'oneOf' in s else ('anyOf' if 'anyOf' in s else 'allOf')
        out.append(f"\`{key}\` of:")
        for v in s[key]:
            r = v.get('\$ref','')
            if r:
                out.append(f"- [\`{r.split('/')[-1]}\`](#{r.split('/')[-1].lower()})")
            else:
                out.append(f"- \`{v.get('type','(inline)')}\`")
        out.append("")
    else:
        out.append(f"Type: \`{s.get('type','')}\`\n")

for name in sorted(schemas.keys()):
    render(name, schemas[name])

with open("$DEST/printful-v2-schemas.md","w") as f:
    f.write("\n".join(out) + "\n")
print("    wrote $DEST/printful-v2-schemas.md")
PYEOF

echo ""
echo "===================="
echo "Source docs updated."
echo ""
du -sh "$DEST"/* | sort -hr
echo ""
echo "Next: review the diff, update curated references if endpoints changed, commit."
