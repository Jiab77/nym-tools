#!/usr/bin/env bash

# nym-network-requester service install script
# Made by Jiab77
#
# Read more about it here:
# - https://nymtech.net/docs/stable/run-nym-nodes/nodes/requester/
# - https://nymtech.net/docs/stable/integrations/websocket-client/
#
# Version: 0.1.0

# Options
[[ -r $HOME/.debug ]] && set -o xtrace || set +o xtrace

# Config
DEBUG_MODE=false
INSTALL_USER="nym"
INSTALL_SERVICE="nym-network-requester.service"
INSTALL_PATH="/home/$INSTALL_USER"
INSTALL_FILE="/etc/systemd/system/$INSTALL_SERVICE"

# Check
[[ $(id -u) -ne 0 ]] && echo -e "\nYou must run this script as 'root' or with 'sudo'.\n" && exit 1

# Arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo -e "\nUsage: $0 [--user <username>]\n\nInstall service as given user or 'nym' user by default.\n"
            exit 1
        ;;
        -u|--user)
            if [[ $2 == "" ]]; then
                echo -e "\nError: You must specify an username when using '--user'.\n\nUsage: $0 [--user <username>]\n"
                exit 1
            else
                INSTALL_USER="$2"
                INSTALL_PATH="/home/$INSTALL_USER/nym-binaries"
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

# Process
if [[ $DEBUG_MODE == true ]]; then
    # Print service file to install
    echo -e "[Debug] $INSTALL_SERVICE:\n"
    cat <<EOF
[Unit]
Description=Nym Network Requester (1.0.2)
StartLimitInterval=350
StartLimitBurst=10

[Service]
User=$INSTALL_USER
LimitNOFILE=65536
ExecStart=$INSTALL_PATH/nym-network-requester --open-proxy
KillSignal=SIGINT
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF
else
    # Create service file
    cat <<EOF >$INSTALL_FILE
[Unit]
Description=Nym Network Requester (1.0.2)
StartLimitInterval=350
StartLimitBurst=10

[Service]
User=$INSTALL_USER
LimitNOFILE=65536
ExecStart=$INSTALL_PATH/nym-network-requester --open-proxy
KillSignal=SIGINT
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOF

    # Reload systemd
    systemctl daemon-reload

    # Enable and start new service
    systemctl enable --now $INSTALL_SERVICE

    # Show service status
    systemctl status $INSTALL_SERVICE -l

    # Install firewall rules
    if [[ $(ufw status verbose | grep -c "# Nym Client traffic") -eq 0 ]]; then
        # Add required firewall rules
        ufw allow 1789 comment "Nym Mixnet traffic"
        ufw allow 9000 comment "Nym Client traffic"

        # Show added 'nym' related rules
        ufw status verbose | grep "Nym"
    fi
fi
