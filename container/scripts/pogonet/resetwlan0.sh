echo "Starting crazy reset of wlan0..."
systemctl stop netctl-auto@wlan0
sleep 1
ifconfig wlan0 down
sleep 1
rfkill block wlan
sleep 1
rfkill unblock wlan
sleep 1
ifconfig wlan0 up
sleep 1
