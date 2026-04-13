//! Hello World — sample Pointiv community extension (Rust/WASM).
//!
//! Greets the user using selected text (if any) and tracks a persistent run
//! counter stored in the extension's isolated storage directory.
//!
//! # Build
//! ```sh
//! ./build.sh
//! ```

use pointiv_extension_api::prelude::*;

#[plugin_fn]
pub fn execute(Json(input): Json<Input>) -> FnResult<Json<Output>> {
    let count: u64 = storage::read("run_count")
        .and_then(|s| s.parse().ok())
        .unwrap_or(0) + 1;
    storage::write("run_count", &count.to_string());

    log::info(&format!(
        "execute: count={count}, text_len={}, cmd={:?}",
        input.text.len(),
        input.command,
    ));

    let name = input.text.trim();
    let greeting = if name.is_empty() {
        "Hello, World!".to_string()
    } else {
        format!("Hello, {name}!")
    };

    Ok(Json(Output::text(format!(
        "{greeting} 👋\n\nRun #{count} — this counter is persisted in your extension's storage folder."
    ))))
}
