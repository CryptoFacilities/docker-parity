FROM centos:7

RUN useradd -m ethereum \
  && set -ex

ENV PARITY_VERSION=1.11.11
ENV PARITY_CHECKSUM=0c7698bcb92b5cf66980898db4bb03ca8ec2a6d01845a8db82777870e1cb201a
ENV PARITY_DATA=/home/ethereum/.ethereum

RUN curl -o parity.rpm "https://releases.parity.io/v${PARITY_VERSION}/x86_64-unknown-centos-gnu/parity_${PARITY_VERSION}_centos_x86_64.rpm" \
  && echo "$PARITY_CHECKSUM *parity.rpm" | sha256sum -c - | grep OK \
  && yum -y localinstall parity.rpm

USER ethereum
RUN mkdir -p /home/ethereum/.ethereum && touch /home/ethereum/.ethereum/config.toml
CMD ["parity","--config","/home/ethereum/.ethereum/config.toml"]
