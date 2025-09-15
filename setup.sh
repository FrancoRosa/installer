# colors
red='\e[1;31m'
grn='\e[1;32m' 
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
    read -p "Do you wish to install? (y/n) " yn
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

install_dependency "curl" "sudo apt-get install -y curl "
install_dependency "git" "sudo apt-get install  -y git"
install_dependency "node" "sudo apt install nodejs -y" "curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - "
install_dependency "pm2" "sudo npm i -g pm2"
install_dependency "tailscale" "curl -fsSL https://tailscale.com/install.sh | sh"
install_dependency "brave-browser" "curl -fsS https://dl.brave.com/install.sh | sh"
install_dependency "anydesk" "sudo apt install ca-certificates curl apt-transport-https \
sudo install -m 0755 -d /etc/apt/keyrings \
sudo curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc \
sudo chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc \
echo 'deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main' | sudo tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null \
sudo apt update \
sudo apt install anydesk" 

npm i serialport
sudo apt-get install -y openssh-server
sudo systemctl enable ssh --now
sudo pm2 startup
wget -O ~/api.js https://raw.githubusercontent.com/francorosa/installer/master/api.js
wget -O ~/mosaic.js https://raw.githubusercontent.com/francorosa/installer/master/mosaic.js
wget -O ~/settings.json https://raw.githubusercontent.com/francorosa/installer/master/settings.json


sudo pm2 start ~/api.js --restart-delay 5000 --max-memory-restart 300M --name "rtk"
sudo pm2 start ~/mosaic.js --restart-delay 5000 --max-memory-restart 300M --name "mosaic"
sudo pm2 stop rtk
sudo pm2 save



# gnome settings
gsettings set org.gnome.shell favorite-apps "['org.gnome.Terminal.desktop', 'anydesk.desktop', 'brave-browser.desktop']"
gsettings set org.gnome.desktop.interface enable-animations false


# brave settings
jq '.homepage = "https://tt--pile-placer.netlify.app" 
    | .homepage_is_newtabpage = false
    | .session.startup_urls = ["https://tt--pile-placer.netlify.app"]
    | .session.restore_on_startup = 4' \
~/.config/BraveSoftware/Brave-Browser/Default/Preferences \
> /tmp/prefs && mv /tmp/prefs ~/.config/BraveSoftware/Brave-Browser/Default/Preferences


# set unattended password
echo -n "Mortenson123" | sudo anydesk --set-password

# disable wayland on ubuntu for anydesk
sudo sed -i '/.*WaylandEnable=.*/ s/.*/WaylandEnable=false/' "/etc/gdm3/custom.conf"
sudo systemctl restart gdm3

rm z
echo "${grn}... done${rst}"