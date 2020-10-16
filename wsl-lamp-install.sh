#!/bin/bash

cat << "EOF"

#                 ____  _________               _       __     __  
#    ____  ____  / __ \/ __/ __(_)_______      | |     / /__  / /_ 
#   / __ \/ __ \/ / / / /_/ /_/ / ___/ _ \_____| | /| / / _ \/ __ \
#  / /_/ / / / / /_/ / __/ __/ / /__/  __/_____/ |/ |/ /  __/ /_/ /
#  \____/_/ /_/\____/_/ /_/ /_/\___/\___/      |__/|__/\___/_.___/ 
#                                                                  

EOF
echo "Installations Script for the WP Dev Lamp Stack"
echo "Should the installation begin? y/n"
read shouldinstall
# check if user said no to the question, if so abort the installation
if test "$shouldinstall" != "y"

  then
    echo "Installation aborted!"
    exit

fi

echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Adding PHP Repositories..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo add-apt-repository ppa:ondrej/php
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Adding Webmin Repositories..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo nano /etc/apt/sources.list
sudo tee -a /etc/apt/sources.list <<< "deb http://download.webmin.com/download/repository sarge contrib"
wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Updating Packages..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt update -y && sudo apt upgrade -y
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Install Lamp Server..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt install apache2 mysql-server php7.3 php7.3-xml php7.3-zip php7.3-mbstring php7.3-curl php7.3-mysql php7.3-gd php7.3-imagick curl webmin
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Starting services..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo service apache2 start
sudo service mysql start
sudo service webmin start
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Securing MySQL..."
echo "Choose the following answers: N, Y, N, Y, Y"
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo " "
sudo mysql_secure_installation
sudo a2enmod rewrite
sudo service apache2 reload
sudo service mysql reload
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Installing composer, node etc."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt install composer nodejs npm -y
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Dev Environment successfully installed"
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Now execute the following commands in a mysql shell"
echo "CREATE USER 'WUNSCHUSERNAME'@'localhost' IDENTIFIED WITH mysql_native_password BY 'WUNSCHPASSWORT';"
echo "GRANT ALL PRIVILEGES ON *.* TO 'WUNSCHUSERNAME'@'localhost';"
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"