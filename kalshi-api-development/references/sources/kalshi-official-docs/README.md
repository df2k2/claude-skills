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
