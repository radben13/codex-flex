## Installing & building

### System requirements

| Requirement                 | Details                                                         |
| --------------------------- | --------------------------------------------------------------- |
| Operating systems           | macOS 12+, Ubuntu 20.04+/Debian 10+, or Windows 11 **via WSL2** |
| Git (optional, recommended) | 2.23+ for built-in PR helpers                                   |
| RAM                         | 4-GB minimum (8-GB recommended)                                 |

### DotSlash

The GitHub Release also contains a [DotSlash](https://dotslash-cli.com/) file for the Codex CLI named `codex`. Using a DotSlash file makes it possible to make a lightweight commit to source control to ensure all contributors use the same version of an executable, regardless of what platform they use for development.

### Build from source

```bash
# Clone the repository and navigate to the root of the Cargo workspace.
git clone https://github.com/openai/codex.git
cd codex/codex-rs

# Install the Rust toolchain, if necessary.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup component add rustfmt
rustup component add clippy
# Install helper tools used by the workspace justfile:
cargo install just
# Optional: install nextest for the `just test` helper
cargo install --locked cargo-nextest

# Build Codex.
cargo build

# Launch the TUI with a sample prompt.
cargo run --bin codex -- "explain this codebase to me"

# After making changes, use the root justfile helpers (they default to codex-rs):
just fmt
just fix -p <crate-you-touched>

# Run the relevant tests (project-specific is fastest), for example:
cargo test -p codex-tui
# If you have cargo-nextest installed, `just test` runs the test suite via nextest:
just test
# Avoid `--all-features` for routine local runs because it increases build
# time and `target/` disk usage by compiling additional feature combinations.
# If you specifically want full feature coverage, use:
cargo test --all-features
```

### Build from source with Docker Compose profiles

If you do not want to install the pinned Rust toolchain on your host, the repo
now includes a Compose service named `rust-workspace` that builds against the
workspace's pinned `1.93.0` toolchain inside Docker.

```bash
# From the repository root.
docker compose --profile build run --rm rust-workspace cargo build -p codex-cli

# Launch the locally built binary through cargo.
docker compose --profile run run --rm rust-workspace \
  cargo run --bin codex -- --help

# Or run the compiled binary directly after the first build.
docker compose --profile run run --rm rust-workspace \
  ./target-docker/debug/codex --help

# Format and test from the same containerized toolchain.
docker compose --profile build run --rm rust-workspace just fmt
docker compose --profile test run --rm rust-workspace cargo test -p codex-cli
```

The Compose workflow keeps Rust caches under `./.docker/` and build artifacts
under `codex-rs/target-docker/` so repeated runs are faster and do not depend on
host-level Rust configuration.

For OpenAI experimentation from a local build, the current config surface already
supports:

```toml
service_tier = "flex"

[features]
runtime_metrics = true
```

`service_tier = "flex"` sends the Responses API `service_tier` field, and
`runtime_metrics = true` enables the `x-responsesapi-include-timing-metrics`
header used by the OpenAI timing metrics path.

## Tracing / verbose logging

Codex is written in Rust, so it honors the `RUST_LOG` environment variable to configure its logging behavior.

The TUI defaults to `RUST_LOG=codex_core=info,codex_tui=info,codex_rmcp_client=info` and log messages are written to `~/.codex/log/codex-tui.log` by default. For a single run, you can override the log directory with `-c log_dir=...` (for example, `-c log_dir=./.codex-log`).

```bash
tail -F ~/.codex/log/codex-tui.log
```

By comparison, the non-interactive mode (`codex exec`) defaults to `RUST_LOG=error`, but messages are printed inline, so there is no need to monitor a separate file.

See the Rust documentation on [`RUST_LOG`](https://docs.rs/env_logger/latest/env_logger/#enabling-logging) for more information on the configuration options.
