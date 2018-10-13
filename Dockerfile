FROM debian:sid as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.0.7
ENV PARITY_CHECKSUM=217943ff1829768c7ed1421a3c9ed88e3d23de8924663b181be753814b8cf2e3

RUN curl -o parity "https://releases.parity.io/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/parity" \
  && echo "$PARITY_CHECKSUM *parity" | sha256sum -c - | grep OK \
  && chmod +x parity

FROM debian:sid-slim
RUN useradd -m ethereum
USER ethereum
COPY --from=builder /parity /bin/parity
RUN mkdir -p /home/ethereum/.ethereum && touch /home/ethereum/.ethereum/config.toml
CMD ["parity","--config","/home/ethereum/.ethereum/config.toml"]
