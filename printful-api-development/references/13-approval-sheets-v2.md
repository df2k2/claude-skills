# 13 — Approval Sheets (v2)

Some Printful products — especially **embroidered apparel** and certain DTF/print products — require the merchant to **approve a proof** before fulfillment proceeds. The proof is called an **approval sheet**.

The flow:

1. Merchant submits an order. Item triggers approval (e.g. embroidered hat).
2. Printful generates the digitized embroidery file + a visual proof.
3. Printful sends an `approval_sheet_created` webhook to the merchant.
4. Merchant inspects the proof. If acceptable, approves in the dashboard. If not, rejects and provides feedback for revision.
5. Once approved, the order proceeds to fulfillment.

Approval is a manual step today — there is **no API endpoint to approve or reject** programmatically. The API only lets you **retrieve** the sheet so you can surface it in your own admin UI.

## Endpoint

| Method | Path | What |
|---|---|---|
| `GET` | `/v2/approval-sheets` | List approval sheets for the current store. |

There is no GET-by-ID endpoint; the sheets are listed and you filter client-side. (The webhook payload provides the same data inline — see [`14-webhooks.md`](14-webhooks.md).)

## Listing

```http
GET /v2/approval-sheets HTTP/1.1
Authorization: Bearer {token}
X-PF-Store-Id: {store_id}
```

Common query parameters:

- `offset`, `limit` — pagination.
- `status` — filter by status. Values: `pending`, `approved`, `rejected`, `expired`.
- `order_id` — filter to a specific order.

Response (`ApprovalSheet` schema):

```json
{
  "data": [
    {
      "id": 99001,
      "order_id": 12345678,
      "external_order_id": "shopify-1001",
      "status": "pending",
      "created_at": "2026-05-16T15:00:00Z",
      "expires_at": "2026-05-19T15:00:00Z",
      "files": [
        {
          "file_id": 800001,
          "filename": "proof_front.png",
          "url": "https://files.cdn.printful.com/.../proof_front.png",
          "thumbnail_url": "https://…",
          "type": "preview"
        },
        {
          "file_id": 800002,
          "filename": "embroidery.dst",
          "url": "https://files.cdn.printful.com/.../embroidery.dst",
          "type": "production_file"
        }
      ],
      "notes": "Please verify thread color #1 matches your brand red.",
      "items": [
        { "order_item_id": 55501, "catalog_variant_id": 9999 }
      ]
    }
  ]
}
```

Key fields:

- `status: pending` — waiting for merchant approval. `expires_at` is the deadline (typically 72 hours). If expired without action, the order moves to `failed`.
- `status: approved` — merchant approved; order resumes.
- `status: rejected` — merchant rejected with feedback; Printful redesigns and emits a new approval sheet.
- `files[]` — preview images and the production-ready file (e.g. a `.dst` embroidery file). Useful to show the merchant in your own UI.

## Webhook event

`approval_sheet_created` fires when a new sheet enters `pending` status. The payload **embeds the full approval sheet object**, so you can build a "needs approval" inbox in your admin without immediately polling `GET /v2/approval-sheets`. See [`14-webhooks.md`](14-webhooks.md).

## Surfacing in your admin

A typical pattern:

1. Subscribe to `approval_sheet_created` and `order_failed` webhooks.
2. On `approval_sheet_created`, store the sheet in your DB and email/notify the merchant with a link to the proof images.
3. The merchant opens your admin, reviews the proof, and clicks an "Open in Printful dashboard" link (Printful's URL: `https://www.printful.com/dashboard/orders/{order_id}/approval-sheets/{sheet_id}`).
4. They approve or reject inside the Printful dashboard.
5. On approval, the order resumes — you'll see new `package_shipped` / `package_returned` webhook events as fulfillment progresses.

## Original sources

- Endpoint: **Approval Sheets v2** section in [`sources/printful-v2-endpoints.md`](sources/printful-v2-endpoints.md).
- Schemas: `ApprovalSheet`, `ApprovalSheetWebhookFile` in [`sources/printful-v2-schemas.md`](sources/printful-v2-schemas.md).
