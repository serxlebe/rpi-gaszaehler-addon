# syntax=docker/dockerfile:1

# Muss vor der ersten FROM-Zeile stehen (globaler Scope), damit der vom
# Supervisor übergebene --build-arg BUILD_FROM=... auch in der zweiten
# FROM-Zeile unten ankommt.
ARG BUILD_FROM

# --- Build-Stage ---------------------------------------------------------
# Kompiliert die Rust-App. Läuft unabhängig von BUILD_FROM, der Supervisor
# baut das Add-on je Zielarchitektur (ggf. via QEMU-Emulation).
FROM rust:1-slim-bookworm AS builder

WORKDIR /usr/src/rpi-gaszaehler

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/serxlebe/rpi-gaszaehler.git . \
    && cargo build --release

# --- Runtime-Stage (HA Add-on Base-Image) --------------------------------
FROM $BUILD_FROM

# bashio ist im HA-Base-Image (base-debian) bereits enthalten
# (für run.sh / Config-Zugriff). Da Builder- und Runtime-Image beide
# auf Debian Bookworm basieren, sind keine zusätzlichen Runtime-Libs nötig.

COPY --from=builder /usr/src/rpi-gaszaehler/target/release/rpi-gaszaehler /usr/bin/rpi-gaszaehler
COPY run.sh /
RUN chmod a+x /run.sh /usr/bin/rpi-gaszaehler

CMD [ "/run.sh" ]
