# Apple Silicon Native Build

This guide is for building and running `codex` and `codex-exec` natively on an
Apple Silicon Mac.

It assumes:

- you are building on the same Mac where you will run the binary
- you do not need packaging, notarization, or distribution
- your auth setup is handled separately

## Prerequisites

Install Xcode Command Line Tools:

```bash
xcode-select --install
```

Install Rust:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

Install the helper used by this repo:

```bash
cargo install --locked just
```

Useful optional helpers:

```bash
cargo install --locked cargo-nextest
cargo install --locked cargo-insta
```

## Build

From the repository root:

```bash
cd codex-rs
cargo build -p codex-cli -p codex-exec --release
```

The binaries will be at:

```bash
codex-rs/target/release/codex
codex-rs/target/release/codex-exec
```

If you want a debug build instead:

```bash
cd codex-rs
cargo build -p codex-cli -p codex-exec
```

## Run

From `codex-rs`:

```bash
./target/release/codex --help
./target/release/codex
./target/release/codex-exec --help
```

Run a one-off command:

```bash
./target/release/codex exec "print the current working directory"
```

Run `codex-exec` directly:

```bash
./target/release/codex-exec --help
```

Use the debug binary while iterating:

```bash
./target/debug/codex
./target/debug/codex-exec
```

## Flex Tier

If you want Flex enabled by default, put this in `~/.codex/config.toml`:

```toml
model = "gpt-5.4"
service_tier = "flex"
```

## Useful Commands

Format:

```bash
cd codex-rs
just fmt
```

Run a targeted CLI test:

```bash
cd codex-rs
cargo test -p codex-cli
```

Run a targeted `codex-exec` test:

```bash
cd codex-rs
cargo test -p codex-exec
```
