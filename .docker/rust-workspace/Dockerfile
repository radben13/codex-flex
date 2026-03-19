FROM rust:1.93.0-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    libcap-dev \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN rustup component add clippy rustfmt rust-src
RUN cargo install --locked just cargo-nextest cargo-insta

COPY .docker/rust-workspace/entrypoint.sh /usr/local/bin/codex-docker-entrypoint
RUN chmod 755 /usr/local/bin/codex-docker-entrypoint

WORKDIR /workspace/codex-rs
ENTRYPOINT ["codex-docker-entrypoint"]
CMD ["bash"]
