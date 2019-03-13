FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.3.5
ENV PARITY_CHECKSUM=df2c58f545da28a7b1839095ffb29c2b4481fa14c32b3353f0a45461a8a62708

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
