#!/usr/bin/env bash

# Nym binaries download script
# Made by Jiab77
#
# Read more about it here:
# - https://github.com/nymtech/nym/releases
# - https://github.com/nymtech/nym/releases/tag/nym-binaries-1.0.2
#
# Version: 0.1.0

# Options
set +o xtrace

# Config
NYM_FOLDER="$HOME/nym-binaries"
BACKUP_FOLDER="$NYM_FOLDER/backup"
DOWNLOAD_VERSION="1.0.2"
DOWNLOAD_URL="https://github.com/nymtech/nym/releases/download/nym-binaries-$DOWNLOAD_VERSION"
BINARIES=(nym-client nym-gateway nym-mixnode nym-network-requester nym-network-statistics nym-socks5-client nym-validator-api)

# Keep only one past version
mkdir -p "$BACKUP_FOLDER"
mv "$NYM_FOLDER/nym-*" "$BACKUP_FOLDER/" 2>/dev/null

# Download all binaries
for BIN in "${BINARIES[@]}" ; do
    wget "$DOWNLOAD_URL/$BIN" -O "$NYM_FOLDER/$BIN" 2>/dev/null
    chmod -v +x "$NYM_FOLDER/$BIN"
done

# Show downloaded binaries
ls -halF --color=always "$NYM_FOLDER"
