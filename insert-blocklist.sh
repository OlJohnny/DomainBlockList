#!/bin/bash

# check for root privilges
if [ "$EUID" -ne 0 ]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and edit files in /etc/pihole"
  exit
fi

# get location of script/blocklist-fin
location=$( cd "$(dirname "$0")" ; pwd -P )"/blocklist-fin"

# add file location of 'blocklist-fin' into pi-hole
echo "file://$location" >> /etc/pihole/adlists.list
# if this list was previously added, just keep one
sudo uniq /etc/pihole/adlists.list > /etc/pihole/.adlist
sudo mv /etc/pihole/.adlist /etc/pihole/adlists.list

echo -e "Added reference to '\e[90m$location\e[39m' into the Domain Blocklist in Pi-Hole"