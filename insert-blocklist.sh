#!/usr/bin/env bash
# github.com/OlJohnny | 2019

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace		# uncomment the previous statement for debugging



##### PREPARATION #####
### check for root privilges ###
if [[ "${EUID}" -ne 0 ]]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and delete files"
  exit
fi

##### DO STUFF #####
### get location of script/blocklist-fin ###
location=$( cd "$(dirname "$0")" ; pwd -P )"/blocklist-fin"


### add file location of 'blocklist-fin' into pi-hole ###
echo "<$(date +"%T")> Inserting local blocklist into PiHole..."
echo "file://$location" >> /etc/pihole/adlists.list
uniq /etc/pihole/adlists.list > /etc/pihole/.adlist
mv /etc/pihole/.adlist /etc/pihole/adlists.list
echo -e "\n<$(date +"%T")>Added reference to '\e[90m$location\e[39m' into the Domain Blocklist in Pi-Hole"



##### FINISHING #####
echo -e "\n<$(date +"%T")> Finished\nExiting..."