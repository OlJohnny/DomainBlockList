#!/usr/bin/env bash
# github.com/OlJohnny | 2019

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace		# uncomment the previous statement for debugging



##### FUNCTIONS #####
### install dos2unix function ###
_var1func(){
read --prompt $'\e[96mDo you want to install dos2unix? (Errors can occur, when files are in the wrong format) (y|n): \e[0m' var1
if [[ "${var1}" -eq "y" ]]
then
	echo -e "\e[92mInstalling dos2unix...\e[0m"
	apt-get --yes install dos2unix
elif [[ "${var1}" -eq "n" ]]
then
	echo -e "\e[91mPackage is needed to complete the run of this script.\e[0m"
	echo "Exiting..."
	exit
else
	_var1func
fi
}



##### PREPARATION #####
### check for root privilges ###
if [[ "${EUID}" -ne 0 ]]
then
  echo -e "\e[91mPlease run as root.\e[39m Root privileges are needed to move and delete files"
  exit
fi


### install dos2unix ###
echo "Checking if dos2unix is installed..."

if [[ $(dpkg-query --show --showformat='${Status}' dos2unix 2>/dev/null | grep --count "ok installed") -eq 0 ]];
then
	_var1func
else
	echo -e "\e[92mPackage dos2unix is already installed\e[0m"
fi


### data warning ###
echo "Please note that this script will overwrite '/etc/pihole/regex.list', which means that any existing RegEx rules will be deleted."
echo -n "Continuing in 5 seconds"
for i in 1 1 1 1 1
do
	echo -n "."
	sleep 1s
done
echo ""


### reset files ###
rm -rf ./.blocklist-work*
rm -rf ./blocklist-fin

touch ./.blocklist-work0
touch ./.blocklist-work1
touch ./.blocklist-work2
touch ./blocklist-fin

chmod -f 775 ./.blocklist-work*
chmod -f 775 ./blocklist-fin

dos2unix /blocklist-links
dos2unix /custom-links
dos2unix /regex-blacklist
dos2unix /regex-whitelist



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