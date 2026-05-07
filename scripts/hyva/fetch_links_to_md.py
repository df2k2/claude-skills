"""
fetch_links_to_md.py

Read a list of URLs from a text file, fetch each page, extract its main content,
convert it to Markdown, and save under a directory tree mirroring the URL path.

URL -> output mapping:
    https://docs.hyva.io/hyva-admin/index.html
    -> <out_root>/hyva-admin/index.md

Usage:
    python fetch_links_to_md.py [links_file] [--out OUT_DIR] [--limit N]
                                [--skip-existing] [--include-host]
                                [--timeout SECS] [--delay SECS]

Defaults:
    links_file      ./hyvalinks.txt
    --out           ./md_out
    --timeout       20
    --delay         0.3   (polite pause between requests)
"""

from __future__ import annotations

import argparse
import sys
import time
from pathlib import Path
from urllib.parse import urlparse

import requests
from bs4 import BeautifulSoup
from markdownify import markdownify as md

USER_AGENT = (
    "Mozilla/5.0 (compatible; LinksToMarkdown/1.0; "
    "+https://example.local/bot) Python-requests"
)

# Selectors tried in order to locate the main article body.
MAIN_SELECTORS = [
    "article.md-content__inner",   # MkDocs Material
    "main article",
    "article[role='main']",
    "main",
    "article",
    "[role='main']",
    "div#content",
    "div.content",
    "div.markdown-body",
]

# Tags inside the chosen main region that are removed before conversion.
NOISE_SELECTORS = [
    "nav",
    "header",
    "footer",
    "aside",
    "script",
    "style",
    "noscript",
    "form.md-search",
    ".md-source-file",
    ".md-content__button",
    ".md-feedback",
    ".md-skip",
]


def url_to_output_path(url: str, out_root: Path, include_host: bool) -> Path:
    """Map a URL to a local .md file path under out_root."""
    parsed = urlparse(url)
    path = parsed.path.lstrip("/")
    if not path or path.endswith("/"):
        path = path + "index.html"

    # Replace .html / .htm with .md, leave other extensions alone.
    lower = path.lower()
    if lower.endswith(".html"):
        path = path[:-5] + ".md"
    elif lower.endswith(".htm"):
        path = path[:-4] + ".md"
    else:
        path = path + ".md"

    parts = [p for p in path.split("/") if p not in ("", ".", "..")]
    if include_host and parsed.netloc:
        parts.insert(0, parsed.netloc)
    return out_root.joinpath(*parts)


def extract_main_html(soup: BeautifulSoup) -> str:
    """Return the inner HTML of the best main-content element, with noise stripped."""
    main = None
    for selector in MAIN_SELECTORS:
        main = soup.select_one(selector)
        if main is not None:
            break
    if main is None:
        main = soup.body or soup

    for selector in NOISE_SELECTORS:
        for tag in main.select(selector):
            tag.decompose()

    return main.decode_contents()


def fetch_and_convert(url: str, session: requests.Session, timeout: int) -> tuple[str, str]:
    """Fetch URL and return (page_title, markdown_body)."""
    resp = session.get(url, timeout=timeout, headers={"User-Agent": USER_AGENT})
    resp.raise_for_status()
    if not resp.encoding or resp.encoding.lower() == "iso-8859-1":
        resp.encoding = resp.apparent_encoding or "utf-8"

    soup = BeautifulSoup(resp.text, "html.parser")
    title_tag = soup.find("title")
    title = title_tag.get_text(strip=True) if title_tag else url

    inner_html = extract_main_html(soup)
    markdown = md(
        inner_html,
        heading_style="ATX",
        bullets="-",
        code_language="",
        strip=["script", "style"],
    ).strip()
    # Collapse runs of 3+ blank lines that markdownify can produce.
    cleaned_lines: list[str] = []
    blank_run = 0
    for line in markdown.splitlines():
        if line.strip() == "":
            blank_run += 1
            if blank_run <= 2:
                cleaned_lines.append("")
        else:
            blank_run = 0
            cleaned_lines.append(line.rstrip())
    return title, "\n".join(cleaned_lines).strip() + "\n"


def read_links(links_file: Path) -> list[str]:
    urls: list[str] = []
    for raw in links_file.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        urls.append(line)
    return urls


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("links_file", nargs="?", default="hyvalinks.txt",
                        help="Text file with one URL per line (default: hyvalinks.txt)")
    parser.add_argument("--out", default="md_out",
                        help="Output root directory (default: md_out)")
    parser.add_argument("--limit", type=int, default=0,
                        help="Process only the first N URLs (0 = all)")
    parser.add_argument("--skip-existing", action="store_true",
                        help="Skip URLs whose target .md file already exists")
    parser.add_argument("--include-host", action="store_true",
                        help="Include the URL host as the top-level directory")
    parser.add_argument("--timeout", type=int, default=20,
                        help="HTTP timeout in seconds (default: 20)")
    parser.add_argument("--delay", type=float, default=0.3,
                        help="Seconds to sleep between requests (default: 0.3)")
    args = parser.parse_args()

    links_file = Path(args.links_file)
    if not links_file.is_file():
        print(f"ERROR: links file not found: {links_file}", file=sys.stderr)
        return 2

    out_root = Path(args.out)
    out_root.mkdir(parents=True, exist_ok=True)

    urls = read_links(links_file)
    if args.limit > 0:
        urls = urls[: args.limit]
    if not urls:
        print("No URLs to process.")
        return 0

    print(f"Processing {len(urls)} URL(s) -> {out_root.resolve()}")
    session = requests.Session()
    ok = 0
    skipped = 0
    failed: list[tuple[str, str]] = []

    for idx, url in enumerate(urls, 1):
        target = url_to_output_path(url, out_root, args.include_host)
        rel = target.relative_to(out_root)
        prefix = f"[{idx}/{len(urls)}]"

        if args.skip_existing and target.exists():
            print(f"{prefix} skip (exists): {rel}")
            skipped += 1
            continue

        try:
            title, body = fetch_and_convert(url, session, args.timeout)
        except Exception as exc:
            print(f"{prefix} FAIL  {url}\n        {exc}", file=sys.stderr)
            failed.append((url, str(exc)))
            continue

        target.parent.mkdir(parents=True, exist_ok=True)
        # Only inject a title heading if the article body does not already start with one.
        first_line = body.lstrip().splitlines()[0] if body.strip() else ""
        if first_line.startswith("#"):
            front = f"<!-- source: {url} -->\n\n"
        else:
            front = f"<!-- source: {url} -->\n\n# {title}\n\n"
        target.write_text(front + body, encoding="utf-8")
        print(f"{prefix} ok    {rel}")
        ok += 1

        if args.delay > 0 and idx < len(urls):
            time.sleep(args.delay)

    print()
    print(f"Done. ok={ok}  skipped={skipped}  failed={len(failed)}")
    if failed:
        print("Failures:")
        for url, msg in failed:
            print(f"  - {url}  ({msg})")
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
