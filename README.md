# Hello World — Pointiv Extension Template

A minimal Pointiv extension in Rust/WASM. Greets the user by name and tracks a persistent run counter.

Use this as a starting point for your own extension.

## Install

Paste your GitHub URL into the Pointiv Extensions panel — no CLI needed.

```
https://github.com/<your-username>/<your-repo>
```

## Build

Requires [Rust](https://rustup.rs). Outputs `extension.wasm` in the repo root — commit it so Pointiv can fetch it directly from GitHub.

```sh
./build.sh
```

## Fork

IDs must be globally unique: use `community.<your-name>.<extension-name>`.

1. Update `id`, `name`, `author`, and `description` in `pointiv-extension.json`
2. Edit `src/lib.rs` — the SDK is [`pointiv-extension-api`](https://crates.io/crates/pointiv-extension-api)
3. Run `./build.sh`, commit `extension.wasm`, push

## Permissions

Declare what your extension needs in `pointiv-extension.json`. Calling a function without its permission is safe — Pointiv returns empty silently.

```json
"permissions": ["storage", "clipboard_read"]
```

| Permission       | Grants                        |
|------------------|-------------------------------|
| `storage`        | Per-extension key/value store |
| `clipboard_read` | Read the system clipboard     |

## JavaScript alternative

No build step needed. Set `"runtime": "js"` and `"main": "index.js"` in the manifest. See `index.js` for an example.
