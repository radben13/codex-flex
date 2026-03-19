#!/usr/bin/env bash
set -euo pipefail

export PATH="/usr/local/cargo/bin:${PATH}"

mkdir -p "${HOME}" "${CARGO_HOME}" "${RUSTUP_HOME}" "${CODEX_HOME}"
git config --global --add safe.directory /workspace >/dev/null 2>&1 || true
git config --global --add safe.directory /workspace/codex-rs >/dev/null 2>&1 || true

exec "$@"
