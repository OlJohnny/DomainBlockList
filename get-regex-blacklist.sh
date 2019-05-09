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
### download regex-blacklist ###
echo -e "<$(date +"%T")> Getting regex-blacklist...\e[90m"
wget --quiet --show-progress --output-document=/etc/pihole/regex.list https://raw.githubusercontent.com/OlJohnny/DomainBlockList/master/regex-blacklist
chmod 775 /etc/pihole/regex.list && chown pihole:www-data /etc/pihole/regex.list


### restarting pihole ###
echo -e "\e[0m\n<$(date +"%T")> Restarting PiHole..."
service pihole-FTL reload



##### FINISHING #####
echo -e "\n<$(date +"%T")> Finished\nExiting..."