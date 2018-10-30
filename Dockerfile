FROM debian:sid as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.0.9
ENV PARITY_CHECKSUM=5343ce4b9096b0527a67e743f054607d689211ffa68c27527b71382426857d6a

RUN curl -o parity "https://releases.parity.io/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/parity" \
  && echo "$PARITY_CHECKSUM *parity" | sha256sum -c - | grep OK \
  && chmod +x parity

FROM debian:sid-slim
RUN useradd -m ethereum
USER ethereum
COPY --from=builder /parity /bin/parity
RUN mkdir -p /home/ethereum/.ethereum && touch /home/ethereum/.ethereum/config.toml
CMD ["parity","--config","/home/ethereum/.ethereum/config.toml"]
