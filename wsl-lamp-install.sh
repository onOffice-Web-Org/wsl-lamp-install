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
echo "Updating Packages..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt update -y && sudo apt upgrade -y
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Installing Tasksel..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt install tasksel -y
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Install Lamp Server..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo tasksel install lamp-server
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Starting services..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo service mysql start
sudo service apache2 start
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Securing MySQL..."
echo "Choose the following answers: N, Y, N, Y, Y"
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo " "
sudo mysql_secure_installation
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Installing phpmyadmin..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt install unzip php-mbstring
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip
sudo unzip phpMyAdmin-5.0.2-all-languages.zip
sudo mv phpMyAdmin-5.0.2-all-languages /usr/share/phpmyadmin
sudo mkdir /usr/share/phpmyadmin/tmp
sudo chown -R www-data:www-data /usr/share/phpmyadmin
sudo chmod 777 /usr/share/phpmyadmin/tmp
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Add apache config..."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo touch /etc/apache2/conf-available/phpmyadmin.conf
sudo tee -a /etc/apache2/conf-available/phpmyadmin.conf <<EOT
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin
 
<Directory /usr/share/phpmyadmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
      <RequireAny>
      Require all granted
     </RequireAny>
   </IfModule>
</Directory>
 
<Directory /usr/share/phpmyadmin/setup/>
   <IfModule mod_authz_core.c>
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>
EOT
sudo a2enconf phpmyadmin
sudo service apache2 reload
sudo service mysql reload
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Installing composer, node etc."
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
sudo apt install composer nodejs npm -y
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
echo "Dev Environment successfully installed"
echo "\e[1;42m >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< >< ><\e[0m"
