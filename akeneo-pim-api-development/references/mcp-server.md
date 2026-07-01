# MCP Server

The **Akeneo MCP Server** is a bridge between an Akeneo PIM instance and AI tools that speak the **Model Context Protocol (MCP)**. It lets a person (or an agent) work the catalog in natural language — "show me all disabled products", "add my `description` attribute to every family", "check FIC compliance on the dairy family" — from inside an MCP-compatible client, without hand-writing REST or GraphQL calls. Under the hood the server translates those requests into the PIM's REST API (`/api/rest/v1/*`).

It is one of the **newer SaaS/Serenity surfaces** (like the GraphQL API, graphql.md, and the Event Platform). Importantly, **there is no standalone open-source MCP repo to run yourself** — this is Akeneo's **hosted** MCP server. You point your client at Akeneo's URL; "No installation needed." (The MCP *clients* and inspector tooling below are third-party/open-source; the Akeneo server itself is the hosted service.)

## Availability & activation

- **SaaS only**, and it may need commercial activation: *"Akeneo MCP may require additional commercial activation depending on your package. Contact your Akeneo Customer Success Manager (CSM)."*
- **Hosted endpoint:** `https://server.mcp.akeneo.cloud/mcp` — the single URL every client connects to (also what MCP Inspector / Postman point at to list tools).
- **Transport:** MCP over **HTTP**.

## Supported clients

Any MCP-compatible client works; the docs call out:

- **Claude Desktop** and **Claude CLI**
- **Cursor**
- **VS Code** (with MCP extensions)
- **Google Antigravity**
- **Custom clients** — anything that supports MCP over HTTP

## Capabilities — what it exposes

When you talk to the server in natural language, the client (LLM) picks and fills **MCP tools** behind the scenes. The docs **name only four tools explicitly**, then say "And more…":

- `get_products` — retrieve one or multiple products
- `get_families` — list product families
- `get_attributes` — list attributes (with filtering)
- `upsert_products` — update or create several products

> **Flag:** the **complete tool list is not enumerated** in the Akeneo docs. Discover the full set at runtime (names, schemas, prompts) using **MCP Inspector** (`github.com/modelcontextprotocol/inspector`) or **Postman's MCP collection** — connect either to `https://server.mcp.akeneo.cloud/mcp` and list tools. The docs also mention "specialized prompts" the client may invoke for multi-step analyses (e.g. compliance checks), distinct from the basic tools.

What the server can read vs. write is defined per PIM data concept (the authoritative capability matrix from the docs):

| PIM data concept | Read | Create / update |
| --- | --- | --- |
| product | ✅ | ✅ |
| product model | ✅ | ✅ |
| product media file | ❌ | ❌ |
| jobs | ❌ | ❌ |
| family | ✅ | ✅ |
| family variant | ✅ | ✅ |
| attribute | ✅ | ✅ |
| attribute option | ✅ | ✅ |
| attribute group | ✅ | ✅ |
| association type | ✅ | ✅ |
| category | ✅ | ✅ |
| channel | ✅ | ✅ |
| locale | ✅ | ❌ |
| currency | ✅ | ❌ |
| measurement family | ✅ | ✅ |
| reference entity | ✅ | ✅ |
| reference entity attribute | ✅ | ✅ |
| reference entity attribute option | ✅ | ✅ |
| reference entity record | ✅ | ✅ |
| reference entity media file | ❌ | ❌ |
| asset family | ✅ | ✅ |
| asset attribute | ✅ | ✅ |
| asset attribute option | ✅ | ✅ |
| asset | ✅ | ✅ |
| asset media file | ❌ | ❌ |
| catalog | ❌ | ❌ |
| catalog product | ❌ | ❌ |
| mapping schema for product | ❌ | ❌ |
| ui extension | ❌ | ❌ |
| workflow | ✅ | ✅ |
| workflow execution | ❌ | ❌ |
| workflow task | ✅ | ✅ |

Note this is a **read *and* write** surface (unlike GraphQL, which is read-only), but media-file binaries, jobs, catalogs/mapping schemas, and UI extensions are out of scope.

### Tool response envelope

When a tool is called directly, its result is wrapped in the standard MCP structure:

- **`structuredContent`** — structured JSON (e.g. `get_products` returns a `product` object plus `endpoint_used`; search tools also return `parameters_used`).
- **`content[]`** — the same data as raw text for the LLM to render.
- **`isError`** — boolean, whether the call failed.

The `endpoint_used` field is a useful debugging signal — it shows the exact REST path the server hit (e.g. `/api/rest/v1/products-uuid/{uuid}`), which ties MCP behavior back to the REST surface in rest-api-overview.md.

## Getting started (connect & configure)

### 1. Get credentials

You need a PIM SaaS URL plus **Connection** credentials (this is the classic client-id/secret + API user identity, not an App token):

- PIM SaaS instance URL (e.g. `https://yourcompany.akeneo.com`)
- **Client ID**, **Client secret**, **Username**, **Password**

Create them in the PIM: **Connect → Connection settings → Create**, then save the credentials. (See authentication.md for the underlying Connection model.)

### 2. Point your client at the hosted URL

The server is `https://server.mcp.akeneo.cloud/mcp`; credentials travel as `X-Akeneo-*` **headers**:

| Header | Value |
| --- | --- |
| `X-Akeneo-API-URL` | Your PIM URL |
| `X-Akeneo-Client-ID` | Your client ID |
| `X-Akeneo-Client-Secret` | Your client secret |
| `X-Akeneo-Username` | Your username |
| `X-Akeneo-Password` | Your password |

**Claude CLI:**

```bash
claude mcp add --transport http akeneo-mcp https://server.mcp.akeneo.cloud/mcp \
  -H "X-Akeneo-API-URL: https://yourcompany.akeneo.com" \
  -H "X-Akeneo-Client-ID: your_client_id" \
  -H "X-Akeneo-Client-Secret: your_client_secret" \
  -H "X-Akeneo-Username: your_username" \
  -H "X-Akeneo-Password: your_password"
```

**Claude Desktop** (`claude_desktop_config.json`) — uses `npx mcp-remote` (install Node.js first, `brew install node` on macOS):

```json
{
  "mcpServers": {
    "akeneo-mcp": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://server.mcp.akeneo.cloud/mcp",
        "--header", "X-Akeneo-API-URL:https://yourcompany.akeneo.com",
        "--header", "X-Akeneo-Client-ID:your_client_id",
        "--header", "X-Akeneo-Client-Secret:your_client_secret",
        "--header", "X-Akeneo-Username:your_username",
        "--header", "X-Akeneo-Password:your_password"
      ]
    }
  }
}
```

**VS Code / Cursor / Google Antigravity** (HTTP transport) — add to the IDE's MCP settings:

```json
{
  "mcpServers": {
    "akeneo-mcp": {
      "type": "http",
      "url": "https://server.mcp.akeneo.cloud/mcp",
      "headers": {
        "X-Akeneo-API-URL": "https://yourcompany.akeneo.com",
        "X-Akeneo-Client-ID": "your_client_id",
        "X-Akeneo-Client-Secret": "your_client_secret",
        "X-Akeneo-Username": "your_username",
        "X-Akeneo-Password": "your_password"
      }
    }
  }
}
```

The config *location* varies: Cursor → Settings → Tools & MCP; Google Antigravity → `…` menu → MCP Servers → Manage → View raw config; VS Code → per the official VS Code MCP docs.

### 3. Test the connection

Once configured, try: `"Show me the sku of my first 10 products"`, `"List all product families"`, `"How many attributes are available?"`. If it fails, re-check the credentials and that the PIM instance is reachable.

## Permissions & governance (read this before enabling writes)

MCP access is governed by the **API key configured in the MCP connection settings — not by an individual named user's PIM permissions**. Consequences:

- Every MCP action runs at the **permission level of that configured API key**.
- Anyone who can use the MCP connection (i.e. anyone using the AI tool wired to that key) can do **anything the key allows, including writes/edits if enabled**.
- **Best practice:** create a **dedicated API user for MCP** and apply **least privilege** — grant only the scopes your use case needs, and, where the client supports it, enable only the specific tools/actions you want. Because credentials are passed straight to the AI agent, keep those permissions tight, especially for data edition.

## Use cases

Natural-language requests the docs highlight (the client selects tools/prompts automatically):

- **Search & browse** — "Show me all enabled products", "Which products are deactivated on my ecommerce channel?", "Show me the products that need improvement on my ecommerce channel".
- **Update** — "Update product 'Super T-shirt' with description 'Premium quality fabric'", "Add my 'description' attribute to all my families", "Complete the missing labels for the options in my 'color' attribute".
- **Create** — "Create a 'tshirt' family with variations on two axes: size and color", "Create a new 'Color' reference entity with all the colors for our collection".
- **Check compliance** — "Analyze all products in the 'dairy' family for FIC compliance", "Check if allergens are properly listed on my 'snack' products".
- **Discover structure** — "What attributes exist for color?", "Get options for the size attribute".

Tip from the docs: reference products/attributes/families by **code, SKU, or UUID** rather than by label, to avoid extra lookups and trial-and-error tool calls.

## How it relates to REST / GraphQL and to auth

- **It wraps the REST API.** Tool responses carry an `endpoint_used` like `/api/rest/v1/products-uuid/…`, confirming the server calls the same REST surface documented in rest-api-overview.md; it validates inputs, authenticates, and executes on your behalf.
- **Auth = a Connection, not a bearer token.** You hand the server the raw **Connection** credentials (client id/secret + username/password) as `X-Akeneo-*` headers; the server does the token exchange internally. Contrast GraphQL (graphql.md), which takes an already-minted REST token in `X-PIM-TOKEN`.
- **It can write.** Unlike GraphQL's read-only surface, MCP supports create/update on most catalog entities (see the matrix) — which is exactly why the least-privilege guidance above matters.

## Original sources

- `references/sources/akeneo-official-docs/mcp/overview.md` — purpose, supported clients, data-concept read/write matrix, example prompts
- `references/sources/akeneo-official-docs/mcp/capabilities.md` — named tools (`get_products`, `get_families`, `get_attributes`, `upsert_products`), Inspector/Postman discovery, response envelope
- `references/sources/akeneo-official-docs/mcp/getting-started.md` — activation, credentials, hosted URL, Claude CLI / Claude Desktop / VS Code configs, permissions & governance
- `references/sources/akeneo-official-docs/mcp/use-cases.md` — worked natural-language examples with `endpoint_used` REST paths
- Hosted MCP server: `https://server.mcp.akeneo.cloud/mcp` — no standalone open-source repo; connect a client to this URL
