# Base image ships a stale Yarn apt source whose signing key (62D54FD4003F6525)
# is no longer trusted, which breaks apt-get update inside downstream features.
FROM mcr.microsoft.com/devcontainers/dotnet:1-8.0-bookworm

RUN rm -f /etc/apt/sources.list.d/yarn.list /etc/apt/trusted.gpg.d/yarn.gpg \
 && rm -f /usr/share/keyrings/yarn-archive-keyring.gpg \
 && apt-get update \
 && rm -rf /var/lib/apt/lists/*
