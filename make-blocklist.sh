#!/usr/bin/env bash
# github.com/OlJohnny | 2020

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace		# uncomment the previous statement for debugging



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


### reset files ###
rm -rf ./.blocklist-work*
rm -rf ./blocklist-fin.txt

touch ./.blocklist-work0.txt
touch ./.blocklist-work1.txt
touch ./.blocklist-work2.txt
touch ./blocklist-fin.txt

chmod -f 775 ./.blocklist-work*
chmod -f 775 ./blocklist-fin.txt

dos2unix --quiet ./blocklist-links.txt
dos2unix --quiet ./regex-denylist.txt
dos2unix --quiet ./regex-allowlist.txt



### get blocklists from 'blocklist-links' and 'custom-links' ###
echo -e "\n<$(date +"%T")> Downloading Source Blocklists...\e[90m"
wget --quiet --show-progress --output-document=- --input-file=./blocklist-links.txt > ./.blocklist-work0.txt
wget --quiet --show-progress --output-document=- --input-file=./custom-links.txt >> ./.blocklist-work0.txt


### remove comments, null ips and blank space. sort the list ###
echo -e "\e[0m\n<$(date +"%T")> Sorting and Cleaning Blocklist..."
sed --in-place 's/0\.0\.0\.0//g' ./.blocklist-work0.txt
sed --in-place 's/127\.0\.0\.1//g' ./.blocklist-work0.txt
sed --in-place 's/ //g' ./.blocklist-work0.txt
sed --in-place 's/:://g' ./.blocklist-work0.txt				# ipv6
sed --in-place 's/localhost$//g' ./.blocklist-work0.txt		# localhost
sed --in-place 's/#.*//g' ./.blocklist-work0.txt			# comments
sed --in-place '/</d' ./.blocklist-work0.txt				# remove stray html
sed --in-place 's/[[:blank:]]//g' ./.blocklist-work0.txt	# horizontal space
sed --in-place 's/[[:space:]]//g' ./.blocklist-work0.txt	# whitespace with newlines
grep --extended-regexp "\." ./.blocklist-work0.txt > ./.blocklist-work1.txt
sort --unique ./.blocklist-work1.txt --output=./.blocklist-work2.txt


### apply 'regex-denylist' and 'regex-allowlist' ###
echo -e "\n<$(date +"%T")> Applying RegEx Black- and Whitelist..."
grep --extended-regexp --invert-match --file=./regex-denylist.txt ./.blocklist-work2.txt > ./.blocklist-work3.txt
grep --extended-regexp --invert-match --file=./regex-allowlist.txt ./.blocklist-work3.txt > ./blocklist-fin.txt



### reset files ###
rm -rf ./.blocklist-work*
echo -e "\n<$(date +"%T")> Finished\nExiting..."
