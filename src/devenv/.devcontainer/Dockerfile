# [Choice] Ubuntu version (use noble on local arm64/Apple Silicon)
FROM mcr.microsoft.com/devcontainers/base:${templateOption:imageVariant} AS base

ARG devcontainercli
RUN if [[ -z "$devcontainercli" ]] ; then printf "\nERROR: This Dockerfile needs to be built with VS Code !" && exit 1; else printf "VS Code is detected: $devcontainercli"; fi

RUN apt-get update && apt-get upgrade -y && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    curl \
    git \
    wget \
    gcc \
    make \
    pkg-config \
    zlib1g-dev \
    build-essential \
    checkinstall \
    gdb \
    libreadline-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    tk-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    liblzma-dev \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Development Container
FROM base AS devcontainer

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY --from=golang:1.24 /usr/local/go /usr/local/go

COPY --from=node:24 /usr/local/bin /usr/local/bin

ENV UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=0 \
    PYTHONPATH="/usr/local/bin"

ENV PATH="${PYTHONPATH}:${PATH}"

COPY install-python.sh /tmp/install-python.sh

RUN chmod +x /tmp/install-python.sh \
    && /tmp/install-python.sh

RUN uv venv \
    && uv pip install marimo \
    && uv pip install jupyterlab



RUN wget -qO- https://bootstrap.pypa.io/get-pip.py | python3

ENV GOPATH="/go"

ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PATH}"

RUN go install github.com/melkeydev/go-blueprint@latest


RUN wget https://github.com/digitalocean/doctl/releases/download/v1.124.0/doctl-1.124.0-linux-amd64.tar.gz \
    && tar -xzf doctl-1.124.0-linux-amd64.tar.gz \
    && mv doctl /usr/local/bin/doctl \
    && rm doctl-1.124.0-linux-amd64.tar.gz

# Development Environment
FROM mcr.microsoft.com/devcontainers/base:${templateOption:imageVariant} AS devenv

ENV GOPATH="/go"

ENV PYTHONPATH="/usr/local/bin"

ENV PATH="/usr/local/go/bin:${GOPATH}/bin:${PYTHONPATH}:${PATH}"

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY --from=devcontainer /usr/local/go /usr/local/go

COPY --from=devcontainer /usr/local/bin /usr/local/bin

COPY --from=devcontainer /go/bin/go-blueprint /go/bin/go-blueprint

COPY --from=devcontainer /.venv /.venv

RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python3.13 0 \
    && update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.13 0

RUN apt update -y && apt install -y --no-install-recommends pipx \
    && pipx ensurepath \
    && pipx install linode-cli \
    && SHELL=/bin/bash pipx completions \
    && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]