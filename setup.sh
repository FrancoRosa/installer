
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

install_dependency "picocom" "sudo apt install -y picocom"
install_dependency "curl" "sudo apt install -y curl"
install_dependency "node" "sudo apt install nodejs -y" "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - "
install_dependency "git" "sudo apt install -y git"
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

sudo pm2 delete mosaic
sudo pm2 start ~/pplacer/api.js --restart-delay 5000 --max-memory-restart 300M --name "mosaic"
sudo pm2 save

# tailscale installation

rm z
echo "${grn}... installation complete!${rst}"

echo "${grn}... don't forget to edit ${red}dips/settings.json ${rst}"
echo "${grn}... after any settings change run ${red}sudo pm2 restart dips${rst}"