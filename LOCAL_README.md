# Local Codex Build

This repo can build and run a local Codex binary in two ways:

- native Rust on the host
- Docker Compose via the `rust-workspace` service

The Docker path is the most reproducible one because it uses the pinned Rust
toolchain from `codex-rs/rust-toolchain.toml`.

## Prerequisites

- Docker + Docker Compose, or
- Rust `1.93.0`, Cargo, and `just`

## Build With Docker Compose

From the repo root:

```bash
docker compose build rust-workspace
docker compose --profile build run --rm rust-workspace cargo build -p codex-cli
```

The compiled binary will be available at:

```bash
codex-rs/target-docker/debug/codex
```

## Run With Docker Compose

Show help:

```bash
docker compose --profile run run --rm rust-workspace ./target-docker/debug/codex --help
```

Start the interactive CLI:

```bash
docker compose --profile run run --rm rust-workspace ./target-docker/debug/codex
```

Run a one-off prompt:

```bash
docker compose --profile run run --rm rust-workspace \
  ./target-docker/debug/codex "summarize this repository"
```

## Build Natively

From `codex-rs`:

```bash
cargo build -p codex-cli
```

The compiled binary will be available at:

```bash
codex-rs/target/debug/codex
```

## Run Natively

From `codex-rs`:

```bash
./target/debug/codex --help
./target/debug/codex
```

Or use the `just` helper:

```bash
just codex
```

## Install Helper Tools Natively

If you want the host workflow:

```bash
cargo install --locked just
```

## Useful Local Config

`~/.codex/config.toml`

```toml
model = "gpt-5.4"
service_tier = "flex"

[features]
runtime_metrics = true
```

Notes:

- `service_tier = "flex"` makes Codex request Flex processing.
- `runtime_metrics = true` enables timing metrics collection and the
  `x-responsesapi-include-timing-metrics` header.
- Flex turns now allow up to 10 minutes of stream idleness before Codex treats
  the stream as lost.

## Tests

Run a targeted crate test in Docker:

```bash
docker compose --profile test run --rm rust-workspace cargo test -p codex-core
```

Run formatting in Docker:

```bash
docker compose --profile build run --rm rust-workspace just fmt
```

## Current Verified Commands

These commands were verified in this workspace:

```bash
docker compose build rust-workspace
docker compose --profile build run --rm rust-workspace cargo build -p codex-cli
docker compose --profile run run --rm rust-workspace ./target-docker/debug/codex --help
docker compose --profile test run --rm rust-workspace cargo test -p codex-core flex_service_tier_extends_idle_timeout_to_ten_minutes
```
