# Authentication — RSA-PSS Request Signing

Every authenticated Kalshi request carries three headers. Each request is signed independently — there is no session, no Bearer token, no refresh-token flow. This reference is the precise spec plus copy-paste recipes in Python, Node, Go, Rust, and curl.

## The three headers

```
KALSHI-ACCESS-KEY:       <key_id>
KALSHI-ACCESS-TIMESTAMP: <unix_epoch_milliseconds_as_string>
KALSHI-ACCESS-SIGNATURE: <base64_rsa_pss_signature>
```

| Header | Value | Notes |
| --- | --- | --- |
| `KALSHI-ACCESS-KEY` | Your key ID | The visible string from the UI. ~20 chars. **Not** the private key. |
| `KALSHI-ACCESS-TIMESTAMP` | Unix epoch in **milliseconds**, as a string | Must be within ~5 seconds of server time. Seconds (10 digits) instead of ms (13 digits) is the most common bug. |
| `KALSHI-ACCESS-SIGNATURE` | Base64-encoded RSA-PSS signature | See below. |

## The signed payload

```
signing_input = timestamp_ms + http_method + path
```

Where:

- `timestamp_ms` is the **same string** value as the `KALSHI-ACCESS-TIMESTAMP` header.
- `http_method` is uppercase: `"GET"`, `"POST"`, `"PUT"`, `"DELETE"`.
- `path` is the URL path beginning with `/trade-api/v2/...`. **No host, no scheme, no query string, no body.**

There are no separators between the three parts. Concatenation only.

Examples of the exact string being signed:

| Endpoint | signing_input |
| --- | --- |
| GET `/trade-api/v2/portfolio/balance` | `1714659392123GET/trade-api/v2/portfolio/balance` |
| POST `/trade-api/v2/portfolio/orders` | `1714659392123POST/trade-api/v2/portfolio/orders` |
| DELETE `/trade-api/v2/portfolio/orders/{id}` | `1714659392123DELETE/trade-api/v2/portfolio/orders/<id>` |
| GET `/trade-api/v2/markets?limit=10` | `1714659392123GET/trade-api/v2/markets` *(no query string)* |
| GET `/trade-api/ws/v2` (WebSocket upgrade) | `1714659392123GET/trade-api/ws/v2` |

## The signature algorithm

**RSA-PSS** with:

- **Hash**: SHA-256 (both for the message digest and MGF1).
- **MGF**: MGF1 with SHA-256.
- **Salt length**: equal to the digest length (32 bytes for SHA-256).
- **Padding**: PSS.

This is **not** RSA-PKCS1-v1.5. PKCS1-v1.5 produces a deterministic signature; PSS produces a different signature each time (because of the salt). If your server-side mock or test is comparing signatures byte-for-byte, it's wrong.

## Recipes

### Python (cryptography)

```python
import base64, time
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding

def load_private_key(path: str):
    with open(path, "rb") as f:
        return serialization.load_pem_private_key(f.read(), password=None)

def sign(private_key, method: str, path: str, timestamp_ms: str | None = None) -> tuple[str, str]:
    if timestamp_ms is None:
        timestamp_ms = str(int(time.time() * 1000))
    message = (timestamp_ms + method.upper() + path).encode("utf-8")
    sig = private_key.sign(
        message,
        padding.PSS(
            mgf=padding.MGF1(hashes.SHA256()),
            salt_length=padding.PSS.DIGEST_LENGTH,
        ),
        hashes.SHA256(),
    )
    return timestamp_ms, base64.b64encode(sig).decode("ascii")

# Usage:
pk = load_private_key("~/.kalshi/private_key.pem")
ts, sig = sign(pk, "GET", "/trade-api/v2/portfolio/balance")
print({"KALSHI-ACCESS-KEY": "<key_id>",
       "KALSHI-ACCESS-TIMESTAMP": ts,
       "KALSHI-ACCESS-SIGNATURE": sig})
```

### Node.js (built-in `crypto`)

```javascript
import crypto from "node:crypto";
import fs from "node:fs";

const privateKeyPem = fs.readFileSync("/home/user/.kalshi/private_key.pem", "utf8");
const keyObject = crypto.createPrivateKey({
  key: privateKeyPem,
  format: "pem",
});

function sign(method, path) {
  const timestamp = Date.now().toString();
  const message = timestamp + method.toUpperCase() + path;
  const signer = crypto.createSign("SHA256");
  signer.update(message, "utf8");
  signer.end();
  const signature = signer.sign({
    key: keyObject,
    padding: crypto.constants.RSA_PKCS1_PSS_PADDING,
    saltLength: crypto.constants.RSA_PSS_SALTLEN_DIGEST,
  });
  return { timestamp, signature: signature.toString("base64") };
}

const { timestamp, signature } = sign("GET", "/trade-api/v2/portfolio/balance");
console.log({
  "KALSHI-ACCESS-KEY": process.env.KALSHI_KEY_ID,
  "KALSHI-ACCESS-TIMESTAMP": timestamp,
  "KALSHI-ACCESS-SIGNATURE": signature,
});
```

### Go (`crypto/rsa`)

```go
package main

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"os"
	"strconv"
	"time"
)

func loadPrivateKey(path string) (*rsa.PrivateKey, error) {
	data, err := os.ReadFile(path)
	if err != nil { return nil, err }
	block, _ := pem.Decode(data)
	if block == nil { return nil, fmt.Errorf("bad PEM") }
	k, err := x509.ParsePKCS8PrivateKey(block.Bytes)
	if err != nil {
		k, err = x509.ParsePKCS1PrivateKey(block.Bytes)
		if err != nil { return nil, err }
	}
	return k.(*rsa.PrivateKey), nil
}

func sign(key *rsa.PrivateKey, method, path string) (timestamp, signature string, err error) {
	timestamp = strconv.FormatInt(time.Now().UnixMilli(), 10)
	msg := timestamp + method + path
	h := sha256.Sum256([]byte(msg))
	sig, err := rsa.SignPSS(rand.Reader, key, crypto.SHA256, h[:], &rsa.PSSOptions{
		SaltLength: rsa.PSSSaltLengthEqualsHash,
		Hash:       crypto.SHA256,
	})
	if err != nil { return "", "", err }
	return timestamp, base64.StdEncoding.EncodeToString(sig), nil
}
```

### Rust (`rsa` + `sha2`)

```rust
use rsa::{RsaPrivateKey, pkcs8::DecodePrivateKey, pss::SigningKey};
use rsa::signature::{RandomizedSigner, SignatureEncoding};
use sha2::Sha256;
use base64::{Engine as _, engine::general_purpose::STANDARD as B64};
use std::{fs, time::{SystemTime, UNIX_EPOCH}};

fn sign(method: &str, path: &str) -> (String, String) {
    let pem = fs::read_to_string("private_key.pem").unwrap();
    let pk = RsaPrivateKey::from_pkcs8_pem(&pem).unwrap();
    let signing_key = SigningKey::<Sha256>::new(pk);

    let ts = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_millis().to_string();
    let msg = format!("{ts}{method}{path}");

    let mut rng = rand::thread_rng();
    let sig = signing_key.sign_with_rng(&mut rng, msg.as_bytes());
    (ts, B64.encode(sig.to_bytes()))
}
```

### Bash (with python3)

```bash
sign() {
  local method="$1" path="$2"
  python3 - <<EOF
import base64, time
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
with open("${KALSHI_PRIVATE_KEY_PATH}", "rb") as f:
    pk = serialization.load_pem_private_key(f.read(), password=None)
ts = str(int(time.time() * 1000))
sig = base64.b64encode(pk.sign(
    (ts + "$method" + "$path").encode(),
    padding.PSS(mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.DIGEST_LENGTH),
    hashes.SHA256(),
)).decode()
print(ts, sig)
EOF
}

read TS SIG < <(sign GET /trade-api/v2/portfolio/balance)
curl -H "KALSHI-ACCESS-KEY: $KALSHI_KEY_ID" \
     -H "KALSHI-ACCESS-TIMESTAMP: $TS" \
     -H "KALSHI-ACCESS-SIGNATURE: $SIG" \
     https://demo-api.kalshi.co/trade-api/v2/portfolio/balance
```

## Verifying a signature locally (sanity)

You can verify your own signing code by using the public key derived from your private key:

```python
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding

pub = private_key.public_key()
pub.verify(
    base64.b64decode(sig_b64),
    (timestamp_ms + method + path).encode(),
    padding.PSS(mgf=padding.MGF1(hashes.SHA256()),
                salt_length=padding.PSS.DIGEST_LENGTH),
    hashes.SHA256(),
)
```

If `verify` raises `InvalidSignature`, your own signing code is wrong (not a Kalshi issue).

## Why RSA-PSS?

- **Forward-secrecy-ish.** Each signature has a random salt, so signatures don't compress and can't be replayed without a fresh timestamp.
- **Standard.** RFC 8017 PSS is well-supported across crypto libraries (`cryptography`, `node:crypto`, `crypto/rsa`, `rsa` crate, `BCRSAPrivateKey` in .NET).
- **Provably secure.** Stronger formal security than PKCS1-v1.5.

## Common signature failures

| Error | Cause | Fix |
| --- | --- | --- |
| `401 Unauthorized` immediately | Wrong signed payload (e.g., included query string or body) | Sign exactly `timestamp + method + path` — nothing else. |
| `401 Unauthorized` only after the request runs a second | Clock skew | Sync clocks (NTP). Tolerance is small (~5 s). |
| `401 Unauthorized` on POST only | Forgot to include the body or hashed it into the signature | The body is **not** part of the signed payload. Don't include it. |
| `401 Unauthorized` randomly (~50% of requests) | Sending signature as hex instead of base64, or padded base64 mismatch | Standard base64 (`+/=`), not URL-safe (`-_`); no whitespace. |
| `401 Unauthorized` on WebSocket only | Signed `/trade-api/ws/v2/` (trailing slash) | Use `/trade-api/ws/v2` exactly. |
| `401 Unauthorized` after deploying | Key revoked / replaced in UI | Generate new pair; update secrets. |
| `403 Forbidden` | Key for wrong product (event-contracts vs. perps) | Use the right key for the right host. |
| Signature works locally but fails in CI | Clock skew in CI runner | Ensure CI has NTP / accurate system clock. |
| Signature works for a few requests then fails | Signed timestamps reused | Generate fresh timestamp on every request. |
| `Invalid algorithm` server error | Used RSA-PKCS1-v1.5 instead of PSS | Switch padding. |

## Algorithm parameter reference

For implementations from scratch:

```
Algorithm:      RSASSA-PSS
Hash:           SHA-256
MGF:            MGF1 with SHA-256
Salt length:    32 bytes (= SHA-256 digest length)
Signature size: 256 bytes (for 2048-bit RSA keys; varies with key size)
Encoding:       Standard base64 (RFC 4648 §4), no URL-safe substitution, with `=` padding
```

The salt is a random per-signature input — this is why two signatures of the same message differ. Don't write tests that expect a deterministic signature.

## Demo vs production key isolation

- Demo keys never validate against production URLs (and vice versa).
- Event-contracts keys never validate against perps hosts (and vice versa).
- This is a feature: it means accidentally pointing dev code at production won't silently work.

## Klear settlement API auth — different scheme

The Klear (Self-Clearing-Member settlement) API does **not** use RSA-PSS. It uses **HTTP Bearer-token** authentication:

```
Authorization: Bearer <access_token>
```

Klear access tokens are issued separately by Kalshi to SCMs. Don't conflate Klear auth with the main trading API auth.

## Original sources

- Official quick-start (gated): https://docs.kalshi.com/getting_started/quick_start_authenticated_requests
- `references/sources/sdk-snippets/kalshi-python-sdk/README.md` — covers the same scheme.
- `references/sources/sdk-snippets/kalshi-client/README.md` — minimal Python implementation reference.
