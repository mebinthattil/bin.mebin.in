FROM rust:1-alpine AS builder
RUN apk add --no-cache musl-dev

COPY . /sources
WORKDIR /sources
RUN cargo build --release
RUN chown nobody:nogroup /sources/target/release/bin

FROM alpine:latest
RUN apk add --no-cache wget
COPY --from=builder /sources/target/release/bin /pastebin
COPY --from=builder /etc/passwd /etc/passwd

USER nobody
EXPOSE 8820
ENTRYPOINT ["/pastebin", "0.0.0.0:8820"]
