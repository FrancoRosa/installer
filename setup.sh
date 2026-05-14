#!/bin/sh

# colors
red='\e[1;31m'
grn='\e[1;32m' 
org='\e[1;93m' 
rst='\e[0m'
    
#banner
echo "${grn}       
    ____  _ __     ____  __                         
   / __ \(_) /__  / __ \/ /___ _________  __________
  / /_/ / / / _ \/ /_/ / / __ ,/ ___/ _ \/ ___/ ___/
 / ____/ / /  __/ ____/ / /_/ / /__/  __/ /  (__  ) 
/_/   /_/_/\___/_/   /_/\__,_/\___/\___/_/  /____/  
${rst}"

# ask to install
while true; do
    read -p "Do you wish to install PilePlacer and dependencies? (y/n) " yn
    case $yn in
        [Yy]* ) echo "${grn}... installing${rst}"; break;;
        [Nn]* ) echo "${red}... installation canceled${rst}";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


# installation process
install_dependency () {
    name=$1
    install_command=$2
    if eval "$name --version"
    then
        echo "${grn} ... $name already installed, skipping${rst}"
    else
        echo "${grn} ... install $name ${rst}"
        eval $3
        eval $install_command
    fi
}

# installation process
install_dependency2 () {
    name=$1
    install_command=$2

    if command -v "$name" >/dev/null 2>&1
    then
        echo "${grn} ... $name already installed, skipping${rst}"
    else
        echo "${grn} ... install $name ${rst}"
        eval "$install_command"
    fi
}

install_dependency2 "picocom" "sudo apt install -y picocom"
install_dependency "curl" "sudo apt install -y curl"
install_dependency "node" "sudo apt install nodejs -y" "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - "
install_dependency "anydesk" "sudo apt install anydesk -y" "sudo apt install ca-certificates curl apt-transport-https && sudo install -m 0755 -d /etc/apt/keyrings && sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc && sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc && echo 'deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main' | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null"
install_dependency "git" "sudo apt install -y git"
install_dependency "brave-browser" "curl -fsS https://dl.brave.com/install.sh | sh"
install_dependency "pm2" "sudo npm i -g pm2"
sudo pm2 startup
mkdir ~/pplacer
cd ~/pplacer
npm init -y
npm i serialport


# donwload settings if the file does not exists
if test -f ~/pplacer/settings.json; then
    echo "${org}... settings file found skipping download.${rst}"
else
    echo "${org}... downloading settings file.${rst}"
    wget -O ~/pplacer/settings.json https://raw.githubusercontent.com/francorosa/installer/master/settings.json
fi

# donwload main process

echo "${org}... downloading usb tool.${rst}"
wget -O ~/pplacer/api.js https://raw.githubusercontent.com/francorosa/installer/master/api.js
wget -O ~/pplacer/inclination.cjs https://raw.githubusercontent.com/francorosa/installer/master/inclination.cjs
wget -O ~/pplacer/diagnosis.sh https://raw.githubusercontent.com/francorosa/installer/master/diagnosis.sh
wget -O ~/Desktop/diagnosis.desktop https://raw.githubusercontent.com/francorosa/installer/master/diagnosis.desktop

chmod +x ~/pplacer/diagnosis.sh
chmod +x ~/Desktop/diagnosis.desktop

sudo pm2 delete tilt
sudo pm2 delete mosaic
sudo pm2 start ~/pplacer/api.js --restart-delay 5000 --max-memory-restart 300M --name "mosaic"
sudo pm2 start ~/pplacer/inclination.cjs --restart-delay 5000 --max-memory-restart 300M --name "tilt"
sudo pm2 save

# tailscale installation


sudo bash -c 'echo "Mortenson123" | anydesk --set-password _full_access'

echo "${grn}... installation complete!${rst}"

echo "${grn}... don't forget to edit ${red}pplacer/settings.json ${rst}"
echo "${grn}... after any settings change run ${red}sudo pm2 restart mosaic${rst}"


echo "This will disable Wayland and reboot Ubuntu."
read -p "Continue? (y/n): " answer


gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.session idle-delay 0
xdg-settings set default-web-browser brave-browser.desktop

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
