create_ap --stop wlan0
sleep 5
#systemctl start netctl-auto@wlan0
#sleep 1
netctl start wlan0-SSID
sleep 5
