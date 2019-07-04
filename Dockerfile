FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.4.8
ENV PARITY_CHECKSUM=03cfeff55d3ae0a1c12c0df0a5643b12fe5c5cc7b9a0989d94a1bb764dad5e9d

RUN curl -o parity "https://releases.parity.io/ethereum/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/parity" \
  && echo "$PARITY_CHECKSUM *parity" | sha256sum -c - | grep OK \
  && chmod +x parity

FROM bitnami/minideb:stretch
RUN useradd -m ethereum
RUN apt-get remove -y --allow-remove-essential --purge adduser gpgv mount hostname gzip login sed
USER ethereum
COPY --from=builder /parity /bin/parity
RUN mkdir -p /home/ethereum/.ethereum && touch /home/ethereum/.ethereum/config.toml
CMD ["parity","--config","/home/ethereum/.ethereum/config.toml"]
