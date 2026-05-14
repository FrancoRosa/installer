#!/usr/bin/env bash

grn='\033[0;32m'
ylw='\033[1;33m'
red='\033[0;31m'
blu='\033[0;34m'
rst='\033[0m'

clear

echo -e "${grn}=============================="
echo " SYSTEM STATUS"
echo -e "==============================${rst}"

# Uptime
echo -e "\n${blu}Uptime:${rst}"
uptime -p | sed "s/.*/${grn}&${rst}/"

# USB Devices
echo -e "\n${blu}Connected USB Devices:${rst}"
lsusb

# Septentrio GPS Detection
echo -e "\n${blu}GPS Detection:${rst}"

if lsusb | grep -i "septentrio" >/dev/null 2>&1
then
    echo -e "${grn}✔ Septentrio GPS found${rst}"
else
    echo -e "${red}✘ Septentrio GPS NOT found${rst}"
fi

# Chicony Tilt Sensor Detection
echo -e "\n${blu}Tilt Sensor Detection:${rst}"

if lsusb | grep -i "chicony" >/dev/null 2>&1
then
    echo -e "${grn}✔ Chicony tilt sensor found${rst}"
else
    echo -e "${red}✘ Chicony tilt sensor NOT found${rst}"
fi

# PM2 Logs - Mosaic
echo -e "\n${ylw}========== PM2 MOSAIC LOGS ==========${rst}"
sudo pm2 logs mosaic --lines 10 --nostream

# PM2 Logs - Tilt
echo -e "\n${ylw}=========== PM2 TILT LOGS ===========${rst}"
sudo pm2 logs tilt --lines 10 --nostream

echo ""