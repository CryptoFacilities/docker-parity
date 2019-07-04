FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.4.9
ENV PARITY_CHECKSUM=0d60bc6aea55619268c597049ebae404e4da6263f5eb465b53b56ca73bf46c00

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
