#!/usr/bin/env bash
# build.sh — compile the Rust extension to extension.wasm
#
# Requirements:
#   • Rust toolchain (https://rustup.rs/)
#   • wasm32-wasip1 target (installed automatically below)
#
# Usage:
#   ./build.sh            # builds release binary and copies it to extension.wasm
#   ./build.sh --check    # just verify the toolchain is present, don't build
set -euo pipefail

CRATE_LIB_NAME="extension"          # must match [lib] name in Cargo.toml (WASM: no lib prefix)
OUTPUT="extension.wasm"             # what Pointiv downloads from your repo
TARGET="wasm32-wasip1"

# ── Toolchain check ────────────────────────────────────────────────────────────

if ! command -v rustup &>/dev/null; then
    echo "✗  rustup not found."
    echo "   Install from: https://rustup.rs/"
    exit 1
fi

if ! command -v cargo &>/dev/null; then
    echo "✗  cargo not found. Re-install rustup."
    exit 1
fi

if [[ "${1:-}" == "--check" ]]; then
    echo "✓  Toolchain OK (rustup + cargo found)"
    exit 0
fi

# ── Add the WASM target (no-op if already installed) ─────────────────────────

echo "→  Ensuring $TARGET target is installed..."
rustup target add "$TARGET"

# ── Build ──────────────────────────────────────────────────────────────────────

echo "→  Building release binary..."
cargo build --release --target "$TARGET"

# ── Copy to repo root ──────────────────────────────────────────────────────────
# Cargo names cdylib outputs lib<name>.wasm on WASM targets.

# WASM cdylib outputs do NOT get the "lib" prefix — it's just {name}.wasm
SRC="target/$TARGET/release/${CRATE_LIB_NAME}.wasm"

if [[ ! -f "$SRC" ]]; then
    echo "✗  Expected binary not found at: $SRC"
    echo "   Check [lib] name = \"$CRATE_LIB_NAME\" in Cargo.toml"
    exit 1
fi

cp "$SRC" "$OUTPUT"

# ── Print summary ──────────────────────────────────────────────────────────────

SIZE_KB=$(( $(wc -c < "$OUTPUT") / 1024 ))
SHA=$(shasum -a 256 "$OUTPUT" | awk '{print $1}')

echo ""
echo "✓  Built $OUTPUT  (${SIZE_KB} KB)"
echo "   SHA-256: $SHA"
echo ""
echo "Next steps:"
echo "  git add $OUTPUT"
echo "  git commit -m 'build: update extension.wasm'"
echo "  git push"
echo ""
echo "Users can then install your extension from:"
echo "  https://github.com/<your-username>/<your-repo>"
