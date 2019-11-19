FROM debian:stretch as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.5.10
ENV PARITY_CHECKSUM=9a746fa8a480e8c8828f7b9f54b74e102db5624f121a3b4f7329a380382cf032

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
