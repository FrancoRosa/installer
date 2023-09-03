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
install_dependency "node" "sudo apt install nodejs -y" "curl -sSL https://deb.nodesource.com/setup_18.x | sudo bash -"
install_dependency "pm2" "sudo npm i -g pm2"
sudo apt-get install -y openssh-server
sudo systemctl enable ssh --now
sudo npm install -g serialport
sudo pm2 startup
wget -O ~/api.js https://raw.githubusercontent.com/francorosa/installer/master/api.js
wget -O ~/settings.json https://raw.githubusercontent.com/francorosa/installer/master/settings.json


sudo pm2 start ~/api.js --name "rtk" 
sudo pm2 save
sudo sed -i '/.*WaylandEnable=.*/ s/.*/WaylandEnable=false/' "/etc/gdm3/custom.conf"
curl -fsSL https://tailscale.com/install.sh | sh

#TODO: EDIT FILE

# echo "${grn}... done${rst}"