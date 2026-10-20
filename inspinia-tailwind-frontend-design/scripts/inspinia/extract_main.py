#!/usr/bin/env python3
"""Print the page-specific content of a vendored INSPINIA page without the ~130 KB of shared
chrome (sidebar, topbar, theme customizer, footer).

Every demo page is 180-300 KB, but only the <main> element differs between pages. Use this
instead of reading a whole file.

Usage:
  python3 -I scripts/inspinia/extract_main.py references/sources/pages/ui-buttons.html
  python3 -I scripts/inspinia/extract_main.py references/sources/pages/ui-buttons.html --list
  python3 -I scripts/inspinia/extract_main.py references/sources/pages/ui-buttons.html --card "Soft Buttons"
  python3 -I scripts/inspinia/extract_main.py references/sources/pages/auth-sign-in.html --body
  python3 -I scripts/inspinia/extract_main.py references/sources/pages/widgets.html --raw   # keep whitespace

Options:
  --list          only list the card titles / section headings found in <main>
  --card TITLE    print just the .card whose .card-title (or first heading) contains TITLE (case-insensitive)
  --body          use <body> instead of <main> (auth/error pages have no <main>; also strips the
                  theme customizer and <script> blocks)
  --id ID         print just the element with id="ID" (e.g. a modal that lives outside <main>)
  --overlays      print every Preline overlay (.hs-overlay: modals/offcanvas) found in <body>, except
                  the theme customizer — app pages keep their add/edit modals outside <main>
  --raw           do not collapse whitespace
  --keep-svg      keep inline <svg> markup (stripped by default — flags/logos are huge)
  --max N         truncate output to N characters (default: no limit)
"""
import argparse, html, re, sys

ap = argparse.ArgumentParser()
ap.add_argument("file")
ap.add_argument("--list", action="store_true")
ap.add_argument("--card")
ap.add_argument("--body", action="store_true")
ap.add_argument("--id")
ap.add_argument("--overlays", action="store_true")
ap.add_argument("--raw", action="store_true")
ap.add_argument("--keep-svg", action="store_true")
ap.add_argument("--max", type=int, default=0)
a = ap.parse_args()

src = open(a.file, encoding="utf-8", errors="replace").read()

def element_by_start(html_src, start):
    """Return the balanced element starting at html_src[start] (naive tag-depth walk)."""
    depth = 0
    for m in re.finditer(r"<(/?)([a-zA-Z][a-zA-Z0-9-]*)\b[^>]*?(/?)>", html_src[start:]):
        close, tag, selfclose = m.group(1), m.group(2).lower(), m.group(3)
        if selfclose or tag in ("br", "img", "input", "hr", "meta", "link", "path", "source"):
            continue
        depth += -1 if close else 1
        if depth == 0:
            return html_src[start : start + m.end()]
    return html_src[start:]

if a.id:
    m = re.search(r'<[a-zA-Z][^>]*\bid="%s"' % re.escape(a.id), src)
    if not m:
        sys.exit(f"no element with id={a.id!r}")
    part = element_by_start(src, m.start())
elif a.overlays:
    parts = []
    for m in re.finditer(r'<div[^>]*class="[^"]*\bhs-overlay\b[^"]*"', src):
        if 'id="theme-customization"' in m.group(0):
            continue
        parts.append(element_by_start(src, m.start()))
    if not parts:
        sys.exit("no .hs-overlay elements found")
    part = "\n\n<!-- ======== -->\n\n".join(parts)
elif a.body:
    m = re.search(r"<body\b.*?</body>", src, re.S)
    part = m.group(0) if m else src
    part = re.sub(r'<div id="theme-customization".*?(?=<!-- (?:end customizer|Vendor|Theme Config)|<script)', "", part, flags=re.S)
    part = re.sub(r"<script\b.*?</script>", "", part, flags=re.S)
else:
    m = re.search(r"<main\b.*?</main>", src, re.S)
    if not m:
        sys.exit("no <main> element — try --body (auth/error/landing pages)")
    part = m.group(0)

if not a.keep_svg:
    part = re.sub(r"<svg\b.*?</svg>", "<svg…/>", part, flags=re.S)
part = re.sub(r"<!--.*?-->", "", part, flags=re.S)

def text(x):
    return html.unescape(re.sub(r"\s+", " ", re.sub(r"<[^>]+>", "", x))).strip()

if a.list:
    for h in re.finditer(r"<h[1-6][^>]*>(.*?)</h[1-6]>", part, re.S):
        t = text(h.group(1))
        if t and len(t) < 90:
            print(t)
    sys.exit()

if a.card:
    cards = re.split(r'(?=<div class="card[ "])', part)
    def card_title(c):
        h = re.search(r'<h[1-6][^>]*class="[^"]*card-title[^"]*"[^>]*>(.*?)</h[1-6]>', c, re.S)
        return text(h.group(1)) if h else text(c[:4000])
    hits = [c for c in cards[1:] if a.card.lower() in card_title(c).lower()]
    if not hits:
        sys.exit(f"no card matching {a.card!r}; try --list")
    part = "\n\n<!-- ======== -->\n\n".join(hits)

if not a.raw:
    part = re.sub(r"\s+", " ", part)
    part = re.sub(r"> <", "><", part)
    # one element per line for readability
    part = re.sub(r"(<(?:div|section|form|ul|ol|li|table|thead|tbody|tr|h[1-6]|p|nav|header|footer|main|article|aside|button|select|textarea|label)\b)", r"\n\1", part)
    part = re.sub(r"(</(?:div|section|form|ul|ol|table|tbody|thead|tr|nav|header|footer|main|article|aside)>)", r"\1\n", part)
    part = re.sub(r"\n\s*\n+", "\n", part).strip()

if a.max and len(part) > a.max:
    part = part[: a.max] + f"\n…[truncated at {a.max} of {len(part)} chars]"
print(part)
