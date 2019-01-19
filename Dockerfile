FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.3.0
ENV PARITY_CHECKSUM=c55c0c1ee397c7a1999ff8e19f9f91caf1b93e239a2a4fc85f57d18eb934f63b

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
