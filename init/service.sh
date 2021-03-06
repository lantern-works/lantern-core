#!/bin/bash

echo "#############################################"
echo "## Add Services "
echo "#############################################"

function addService() {
    local svc=$1
    local label=$2
    local timer=$3

    # http service    
    echo "installing ${svc} service..."
    touch /etc/systemd/system/${svc}.service

    if [[ $timer ]]; then
        cat <<EOF >"/etc/systemd/system/${svc}.service"
[Unit]
Description=Lantern ${label} Service

[Service]
Type=simple
ExecStart=/lantern/system/${svc}
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    else
        cat <<EOF >"/etc/systemd/system/${svc}.service"
[Unit]
Description=Lantern ${label} Service

[Service]
ExecStart=/lantern/system/${svc}

[Install]
WantedBy=multi-user.target
EOF
    fi

    cat "/etc/systemd/system/${svc}.service"

    systemctl enable ${svc}.service


    if [[ $timer ]]; then

        cat <<EOF >"/etc/systemd/system/${svc}.timer"

[Unit]
Description=Run ${svc} every ${timer} seconds

[Timer]
OnBootSec=10sec
OnUnitInactiveSec=${timer}sec


[Install]
WantedBy=multi-user.target

EOF
        cat "/etc/systemd/system/${svc}.timer"
    fi

}

# run these all the time
addService http "Web & Database"
addService ap "Access Point / Hotspot"
addService lora "LoRa Radio"
# bring these up on a timer
addService test "Test Battery Power and Antenna" 10




echo "#############################################"
echo "## Adjust File System "
echo "#############################################"

# create admin user
useradd -m -g wheel -s /usr/bin/zsh admin
echo '%wheel ALL=(ALL) NOPASSWD:ALL' | EDITOR='tee -a' visudo

# set zsh as the default shell
chsh -s /usr/bin/zsh root && chsh -s /usr/bin/zsh admin
chown admin. /home/admin/.zshrc
echo 'cd /lantern/' >> /home/admin/.zshrc
echo 'alias rl="sudo systemctl restart lora"' >> /home/admin/.zshrc
echo 'export PATH=/lantern/bin/:/lantern/system:$PATH' >> /home/admin/.zshrc
sync