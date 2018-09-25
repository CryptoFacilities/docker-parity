FROM debian:sid as builder

RUN apt-get update && apt-get install -y curl

ENV PARITY_VERSION=2.0.6
ENV PARITY_CHECKSUM=65c7f5c2bc8e4e7829d6eae99372f4cfef7149d4353712906ec3bfe039529621
ENV PARITY_DATA=/home/ethereum/.ethereum

RUN curl -o parity "https://releases.parity.io/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/parity" \
  && echo "$PARITY_CHECKSUM *parity" | sha256sum -c - | grep OK \
  && chmod +x parity

FROM debian:sid
RUN useradd -m ethereum
USER ethereum
COPY --from=builder /parity /bin/parity
RUN mkdir -p /home/ethereum/.ethereum && touch /home/ethereum/.ethereum/config.toml
CMD ["parity","--config","/home/ethereum/.ethereum/config.toml"]
