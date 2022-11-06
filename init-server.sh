#!/usr/bin/env bash

# Nym Open Proxy server init script
# Made by Jiab77
#
# Read more about it here:
# - https://nymtech.net/docs/stable/quickstart/socks5
# - https://nymtech.net/docs/stable/integrations/socks5-client
#
# Version: 0.1.0

# Options
set +o xtrace

# Config
DEBUG_MODE=false
INSTALL_USER="nym"
INSTALL_PATH="/home/$INSTALL_USER"
CLIENT_ID="requester-client"
CLIENT_INIT_LOG="$INSTALL_PATH/nym-client-init.log"
PROVIDER_ADDRESS_FILE="$INSTALL_PATH/.nym-provider-address"

# Check if initializing for default user
[[ $# -eq 0 && ! $(id -u) -eq 0 ]] && echo -e "\nYou must run this script as 'root' or with 'sudo'.\n" && exit 1

# Check if initializing for given user
[[ $# -eq 2 && ! $(id -u) -eq 0 && ! $(id -u -n) == "$2" ]] && echo -e "\nYou must run this script as 'root' or with 'sudo'.\n" && exit 1

# Arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo -e "\nUsage: $0 [--user <username>]\n\nInit as given user or 'nym' user by default.\n"
            exit 1
        ;;
        -u|--user)
            if [[ $2 == "" ]]; then
                echo -e "\nError: You must specify an username when using '--user'.\n\nUsage: $0 [--user <username>]\n"
                exit 1
            else
                INSTALL_USER="$2"
                INSTALL_PATH="/home/$INSTALL_USER/nym-binaries"
                CLIENT_INIT_LOG="$INSTALL_PATH/nym-client-init.log"
                PROVIDER_ADDRESS_FILE="/home/$INSTALL_USER/.nym-provider-address"
                shift
            fi
        ;;
        *)
            echo -e "\nError: Unknown argument given.\n\nUsage: $0 [--user <username>]\n"
            exit 1
        ;;
    esac
    shift
done

# Fix run permission
if [[ $(id -u) -eq 0 ]]; then
    RUN_CMD="runuser -u $INSTALL_USER --"
fi

# Process
if [[ $DEBUG_MODE == true ]]; then
    echo -e "[Debug] Running: $RUN_CMD $INSTALL_PATH/nym-client init --id $CLIENT_ID &> $CLIENT_INIT_LOG &\n"
else
   if [[ -n "$RUN_CMD" ]]; then
       $RUN_CMD "$INSTALL_PATH/nym-client" init --id $CLIENT_ID &> "$CLIENT_INIT_LOG" &
   else
       "$INSTALL_PATH/nym-client" init --id $CLIENT_ID &> "$CLIENT_INIT_LOG" &
   fi
fi

# Result
if [[ $DEBUG_MODE == false ]]; then
    echo -e "\nFetching client address from log...\n"
    sleep 2
    echo -e "Fetched: $(grep 'The address of this client is:' "$CLIENT_INIT_LOG" | awk '{ print $7 }')\n"
    echo -e "\nPlease note this address to later initialize the socks5 client with the '--provider' argument.\n"
    echo -n "$(grep 'The address of this client is:' "$CLIENT_INIT_LOG" | awk '{ print $7 }')" > "$PROVIDER_ADDRESS_FILE"
fi

# Fix permissions
chown "$INSTALL_USER." "$CLIENT_INIT_LOG"
chown "$INSTALL_USER." "$PROVIDER_ADDRESS_FILE"
