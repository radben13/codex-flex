# Apple Silicon Native Build

This guide is for building and running Codex natively on an Apple Silicon Mac.

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

## Build

From the repository root:

```bash
cd codex-rs
cargo build -p codex-cli --release
```

The binary will be at:

```bash
codex-rs/target/release/codex
```

If you want a debug build instead:

```bash
cd codex-rs
cargo build -p codex-cli
```

## Run

From `codex-rs`:

```bash
./target/release/codex --help
./target/release/codex
```

Run a one-off command:

```bash
./target/release/codex exec "print the current working directory"
```

Use the debug binary while iterating:

```bash
./target/debug/codex
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
