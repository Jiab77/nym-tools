#!/usr/bin/env bash

# Nym Open Proxy client init script
# Made by Jiab77
#
# Read more about it here:
# - https://nymtech.net/docs/stable/quickstart/socks5
# - https://nymtech.net/docs/stable/integrations/socks5-client
#
# Version: 0.1.0

# Options
set -o xtrace

# Config
DEBUG_MODE=true
INSTALL_USER="nym"
INSTALL_PATH="/home/$INSTALL_USER"
CLIENT_ID="local-proxy-client"
CLIENT_SRV_ADDRESS=""

# Arguments
[[ $# -eq 0 ]] && echo -e "\nUsage: $0 --provider <client-address-from-server> [--user <username>]\n\nInit with given provider as given user or 'nym' user by default.\n" && exit 1
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo -e "\nUsage: $0 --provider <client-address-from-server> [--user <username>]\n\nInit with given provider as given user or 'nym' user by default.\n"
            exit 1
        ;;
        -p|--provider)
            if [[ $2 == "" ]]; then
                echo -e "\nError: You must specify the server client address when using '--provider'.\n\nUsage: $0 --provider <client-address-from-server> [--user <username>]\n"
                exit 1
            else
                CLIENT_SRV_ADDRESS="$2"
                shift
            fi
        ;;
        -u|--user)
            if [[ $2 == "" ]]; then
                echo -e "\nError: You must specify an username when using '--user'.\n\nUsage: $0 --provider <client-address-from-server> [--user <username>]\n"
                exit 1
            else
                INSTALL_USER="$2"
                INSTALL_PATH="/home/$INSTALL_USER/nym-binaries"
                shift
            fi
        ;;
        *)
            echo -e "\nError: Unknown argument given.\n\nUsage: $0 --provider <client-address-from-server> [--user <username>]\n"
            exit 1
        ;;
    esac
    shift
done

# Process
if [[ $DEBUG_MODE == true ]]; then
    echo -e "[Debug] Running: $INSTALL_PATH/nym-socks5-client init --id $CLIENT_ID --provider $CLIENT_SRV_ADDRESS\n"
else
    "$INSTALL_PATH/nym-socks5-client" init --id "$CLIENT_ID" --provider "$CLIENT_SRV_ADDRESS"
fi
