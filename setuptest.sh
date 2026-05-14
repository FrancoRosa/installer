#!/bin/sh

echo "This will disable Wayland and reboot Ubuntu."
read -p "Continue? (y/n): " answer

if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
    echo "Disabling Wayland for GDM..."

    sudo sed -i 's/^#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
    sudo sed -i 's/^WaylandEnable=true/WaylandEnable=false/' /etc/gdm3/custom.conf

    echo ""
    echo "Wayland disabled."
    echo "Rebooting in 5 seconds..."
    sleep 5

    sudo reboot
else
    echo "Operation cancelled."
fi
rm z
