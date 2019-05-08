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


### reset files ###
rm -rf ./.blocklist-work*
rm -rf ./blocklist-fin

touch ./.blocklist-work0
touch ./.blocklist-work1
touch ./.blocklist-work2
touch ./blocklist-fin

chmod -f 775 ./.blocklist-work*
chmod -f 775 ./blocklist-fin



##### DO STUFF #####
### get blocklists from 'blocklist-links' and 'custom-links' ###
echo "<$(date +"%T")> Getting Source Blocklists..."
wget --quiet --output-document=- --input-file=./blocklist-links > ./.blocklist-work0
wget --quiet --output-document=- --input-file=./custom-links >> ./.blocklist-work0


### remove comments, null ips and blank space. sort the list ###
now=$(date +"%T")
echo -e "\n<$now> Sorting and Cleaning Blocklist..."
sed --in-place 's/0\.0\.0\.0//g' ./.blocklist-work0
sed --in-place 's/127\.0\.0\.1//g' ./.blocklist-work0
sed --in-place 's/ //g' ./.blocklist-work0
sed --in-place 's/[[:blank:]]//g' ./.blocklist-work0
sed --in-place 's/[[:space:]]//g' ./.blocklist-work0
sed --in-place 's/#.*//g' ./.blocklist-work0
sort --unique ./.blocklist-work0 --output=./.blocklist-work1


### apply 'regex-blocklist' and 'regex-whitelist' ###
echo -e "\n<$(date +"%T")> Applying RegEx Blacklist..."
grep --extended-regexp --invert-match --file=./regex-blacklist ./.blocklist-work1 > ./.blocklist-work2
grep --extended-regexp --invert-match --file=./regex-whitelist ./.blocklist-work2 > ./blocklist-fin



##### FINISHING #####
### reset files ###
rm -rf ./.blocklist-work*