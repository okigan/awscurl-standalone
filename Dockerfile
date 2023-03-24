ARG BUILDER_VERSION=python:3.9-alpine3.16
ARG INSTALL_VERSION=alpine:3.16


FROM ${BUILDER_VERSION} AS builder

RUN set -ex; \
    apk add --no-cache \
    git \
    unzip \
    groff \
    curl \
    build-base \
    libffi-dev \
    cmake \
    bash


ARG AWSCURL_VERSION=0.26
RUN set -eux \
    \
    && cd / \
    && git clone --recursive  --depth 1 --branch v${AWSCURL_VERSION} --single-branch https://github.com/okigan/awscurl

COPY cli.py /awscurl/awscurl/awscurl-cli.py

RUN set -eux \
    && cd /awscurl \
    && pip install -r requirements.txt \
    && pip install pyinstaller==4.10
    
RUN set -eux \
    && cd /awscurl \
    && pyinstaller /awscurl/awscurl/awscurl-cli.py --onefile --hidden-import=configargparser --hidden-import=requests --name awscurl 


FROM ${INSTALL_VERSION} as install

# uncomment for debugging the image
# RUN set -eux \
#     && apk update && apk add bash

COPY --from=builder /awscurl/dist/awscurl /usr/local/bin/awscurl
