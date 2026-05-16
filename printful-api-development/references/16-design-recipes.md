# 16 — Design recipes

End-to-end code recipes for the most common Printful integration flows. All examples use v2 unless noted; substitute your own token. Set `PF_TOKEN` to a Personal Access Token created at `https://developers.printful.com/tokens`.

## 1. Place a single-item order (T-shirt with front print)

### Node.js (fetch)

```javascript
const PF = "https://api.printful.com";
const token = process.env.PF_TOKEN;

async function pf(method, path, body) {
  const res = await fetch(`${PF}${path}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json"
    },
    body: body ? JSON.stringify(body) : undefined
  });
  const json = await res.json();
  if (!res.ok) throw new Error(`${res.status} ${json.title || json.result}: ${json.detail || ""}`);
  return json;
}

// 1. Find the variant ID for Bella+Canvas 3001 / White / M
const { data: variants } = await pf("GET", "/v2/catalog-products/71/catalog-variants?limit=200");
const target = variants.find(v => v.color === "White" && v.size === "M");
if (!target) throw new Error("Variant not found");

// 2. Create the order (draft + confirm in one shot)
const { data: order } = await pf("POST", "/v2/orders", {
  external_id: `order-${Date.now()}`,
  confirm: true,                              // skip draft, charge immediately
  recipient: {
    name: "Jane Doe",
    address1: "19749 Dearborn St",
    city: "Chatsworth",
    state_code: "CA",
    country_code: "US",
    zip: "91311",
    email: "jane@example.com"
  },
  shipping: "STANDARD",
  order_items: [{
    source: "catalog",
    catalog_variant_id: target.id,
    quantity: 1,
    placements: [{
      placement: "front",
      technique: "dtg",
      layers: [{
        type: "file",
        url:  "https://your-cdn.example.com/design.png"
      }]
    }]
  }]
});

console.log("Order ID:", order.id, "Status:", order.status, "Total:", order.costs.total);
```

### Python (httpx)

```python
import os, httpx, time

PF = "https://api.printful.com"
token = os.environ["PF_TOKEN"]

def pf(method, path, json=None):
    r = httpx.request(method, f"{PF}{path}",
                      headers={"Authorization": f"Bearer {token}"},
                      json=json, timeout=30)
    if r.status_code >= 400:
        raise RuntimeError(f"{r.status_code} {r.text}")
    return r.json()

variants = pf("GET", "/v2/catalog-products/71/catalog-variants?limit=200")["data"]
target = next(v for v in variants if v["color"] == "White" and v["size"] == "M")

order = pf("POST", "/v2/orders", {
    "external_id": f"order-{int(time.time())}",
    "confirm": True,
    "recipient": {
        "name": "Jane Doe",
        "address1": "19749 Dearborn St",
        "city": "Chatsworth",
        "state_code": "CA",
        "country_code": "US",
        "zip": "91311"
    },
    "shipping": "STANDARD",
    "order_items": [{
        "source": "catalog",
        "catalog_variant_id": target["id"],
        "quantity": 1,
        "placements": [{
            "placement": "front",
            "technique": "dtg",
            "layers": [{
                "type": "file",
                "url":  "https://your-cdn.example.com/design.png"
            }]
        }]
    }]
})["data"]
print("Order", order["id"], order["status"], order["costs"]["total"])
```

## 2. Build a draft order incrementally (cart pattern)

```javascript
// Create empty draft with just the address
let { data: order } = await pf("POST", "/v2/orders", {
  external_id: `cart-${shopperId}`,
  recipient: { /* …address… */ }
});

// As the shopper adds items, push them to the draft
await pf("POST", `/v2/orders/${order.id}/order-items`, {
  source: "catalog",
  catalog_variant_id: 4011,
  quantity: 1,
  placements: [{ placement: "front", technique: "dtg", layers: [{ type: "file", url: designUrl }] }]
});

// Show running costs (rolled up after each item add)
({ data: order } = await pf("GET", `/v2/orders/${order.id}`));
console.log("Subtotal:", order.costs.subtotal, "Shipping:", order.costs.shipping);

// On checkout, confirm:
await pf("POST", `/v2/orders/${order.id}/confirmation`);
```

## 3. Quote shipping before charging

```javascript
const { data: rates } = await pf("POST", "/v2/shipping-rates", {
  recipient: { country_code: "US", state_code: "CA", zip: "91311" },
  items: [{ source: "catalog", catalog_variant_id: 4011, quantity: 2 }],
  currency: "USD"
});

// rates: [{ id: "STANDARD", rate: "4.95", min_delivery_days: 3, max_delivery_days: 5 }, …]
const cheapest = rates.reduce((a, b) => Number(a.rate) < Number(b.rate) ? a : b);
console.log(`${cheapest.name}: $${cheapest.rate}`);
```

## 4. Render a mockup and wait for it

```javascript
// Submit the task
const { data: task } = await pf("POST", "/v2/mockup-tasks", {
  catalog_product_id: 71,
  catalog_variant_ids: [4011, 4012],
  mockup_style_ids: [1115],
  format: "jpg",
  placements: [{
    placement: "front",
    technique: "dtg",
    layers: [{ type: "file", url: "https://your-cdn.example.com/design.png" }]
  }]
});

// Poll every 3s, up to 60s
let finished;
for (let i = 0; i < 20; i++) {
  await new Promise(r => setTimeout(r, 3000));
  const resp = await pf("GET", `/v2/mockup-tasks?id=${task.id}`);
  if (resp.data.status !== "pending") { finished = resp.data; break; }
}

if (!finished) throw new Error("Mockup timed out");
if (finished.status === "failed") throw new Error(finished.error.message);

for (const m of finished.mockups) {
  console.log(m.placement, m.view_name, m.mockup_url);
}
```

## 5. Estimate order cost (no commitment)

```javascript
const { data: task } = await pf("POST", "/v2/order-estimation-tasks", {
  recipient: { country_code: "US", state_code: "CA", zip: "91311" },
  shipping: "STANDARD",
  currency: "USD",
  order_items: [{
    source: "catalog",
    catalog_variant_id: 4011,
    quantity: 1,
    placements: [{ placement: "front", technique: "dtg", layers: [{ type: "file", url: designUrl }] }]
  }]
});

let result;
for (let i = 0; i < 10; i++) {
  await new Promise(r => setTimeout(r, 2000));
  const resp = await pf("GET", `/v2/order-estimation-tasks?id=${task.id}`);
  if (resp.data.status === "completed") { result = resp.data.result; break; }
  if (resp.data.status === "failed")    throw new Error("Estimation failed");
}

console.log("Total:", result.costs.total, result.costs.currency);
```

## 6. Sync a custom product to Printful (v1 only)

```javascript
// Create the Sync Product with one variant
const { result: synced } = await pf("POST", "/store/products", {
  sync_product: {
    name: "My Brand Tee",
    external_id: "my-product-101",
    thumbnail: "https://your-cdn.example.com/thumb.png"
  },
  sync_variants: [{
    variant_id: 4011,                          // catalog variant
    external_id: "my-product-101-white-m",
    retail_price: "24.99",
    sku: "MBT-WHT-M",
    files: [{ type: "default", url: "https://your-cdn.example.com/design.png", placement: "front" }]
  }]
});

console.log("Sync product:", synced.sync_product.id, "first variant:", synced.sync_variants[0].id);
```

Note `result`, not `data` — v1 envelope.

## 7. Set up a v2 webhook with signing

```javascript
// 1) Configure the store-level URL + secret + expiration
const { data: wh } = await pf("POST", "/v2/webhooks", {
  url: "https://yourapp.example.com/printful/webhook",
  default_expires_at: "2027-05-16T00:00:00Z"
});

console.log("PUBLIC KEY:", wh.public_key);
console.log("SECRET KEY (save now):", wh.secret_key);

// 2) Enable the events you care about
for (const evt of ["package_shipped","order_failed","approval_sheet_created","mockup_task_finished"]) {
  await pf("POST", `/v2/webhooks/${evt}`, { expires_at: "2027-05-16T00:00:00Z" });
}
```

Verify in handler (see [`14-webhooks.md`](14-webhooks.md) for full code).

## 8. Verify a webhook signature (Express)

```javascript
import express from "express";
import crypto from "crypto";

const app = express();
const SECRET = Buffer.from(process.env.PF_WEBHOOK_SECRET, "hex");

app.post("/printful/webhook",
  express.raw({ type: "application/json" }),                    // raw body needed for HMAC
  (req, res) => {
    const sig = req.header("X-PF-Signature") || "";
    if (!sig.startsWith("sha256=")) return res.sendStatus(401);
    const provided = sig.slice(7);
    const expected = crypto.createHmac("sha256", SECRET).update(req.body).digest("hex");
    if (!crypto.timingSafeEqual(Buffer.from(provided, "hex"), Buffer.from(expected, "hex"))) {
      return res.sendStatus(401);
    }
    const event = JSON.parse(req.body.toString("utf8"));
    // dedupe + enqueue
    res.sendStatus(200);
  }
);
```

## 9. Multi-store: pick the active store

```javascript
async function pfForStore(storeId, method, path, body) {
  const res = await fetch(`${PF}${path}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      "X-PF-Store-Id": String(storeId),
      "Content-Type": "application/json"
    },
    body: body ? JSON.stringify(body) : undefined
  });
  return res.json();
}

const { data: stores } = await pfForStore(0, "GET", "/v2/stores");  // 0 ignored when listing
for (const s of stores) {
  const { data: orders } = await pfForStore(s.id, "GET", "/v2/orders?status=pending");
  console.log(s.name, "has", orders.length, "pending orders");
}
```

## 10. Handle rate limits (token-bucket backoff)

```javascript
async function pfWithBackoff(method, path, body) {
  while (true) {
    const res = await fetch(`${PF}${path}`, { method, headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" }, body: body ? JSON.stringify(body) : undefined });
    if (res.status !== 429) {
      const json = await res.json();
      if (!res.ok) throw new Error(`${res.status}: ${json.title || json.result || JSON.stringify(json)}`);
      return json;
    }
    const retryAfter = Number(res.headers.get("Retry-After") || res.headers.get("X-Ratelimit-Reset") || 1);
    await new Promise(r => setTimeout(r, retryAfter * 1000 + 100));
  }
}
```

## 11. OAuth Authorization Code exchange (public app, server-side)

```javascript
import express from "express";

const app = express();

app.get("/connect", (req, res) => {
  const url = new URL("https://www.printful.com/oauth/authorize");
  url.searchParams.set("client_id", process.env.PF_CLIENT_ID);
  url.searchParams.set("redirect_uri", "https://yourapp.example.com/oauth/printful/callback");
  url.searchParams.set("response_type", "code");
  url.searchParams.set("scope", "orders webhooks file_library");
  url.searchParams.set("state", crypto.randomBytes(16).toString("hex"));
  res.redirect(url.toString());
});

app.get("/oauth/printful/callback", async (req, res) => {
  const { code, state } = req.query;
  // verify `state` matches the one you stored in the session

  const tokenRes = await fetch("https://www.printful.com/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type:    "authorization_code",
      code:          code,
      redirect_uri:  "https://yourapp.example.com/oauth/printful/callback",
      client_id:     process.env.PF_CLIENT_ID,
      client_secret: process.env.PF_CLIENT_SECRET
    })
  });
  const { access_token, refresh_token, expires_in, scope } = await tokenRes.json();
  // store these against the merchant's account record
  res.send("Connected");
});
```

## 12. Refresh an OAuth access token

```javascript
async function refreshToken(refreshToken) {
  const res = await fetch("https://www.printful.com/oauth/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type:    "refresh_token",
      refresh_token: refreshToken,
      client_id:     process.env.PF_CLIENT_ID,
      client_secret: process.env.PF_CLIENT_SECRET
    })
  });
  return res.json();   // { access_token, refresh_token, expires_in, scope, token_type }
}
```

## Original sources

- Auth flow URLs: `components.securitySchemes.OAuth.flows.authorizationCode` in [`sources/printful-v2-openapi.json`](sources/printful-v2-openapi.json).
- Order/cost/shipping schemas: [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
- Transport reference (auth + envelope): [`sources/PrintfulApiClient.php`](sources/PrintfulApiClient.php).
