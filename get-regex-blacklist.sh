#!/bin/bash

# check for root privilges
if [ "$EUID" -ne 0 ]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and edit files in /etc/pihole"
  exit
fi

sudo wget -O /etc/pihole/regex.list https://raw.githubusercontent.com/OlJohnny/DomainBlockList/master/regex-blacklist
sudo chmod -Rf 775 /etc/pihole/regex.list && sudo chown -Rf pihole:www-data /etc/pihole/regex.list
sudo service pihole-FTL reload