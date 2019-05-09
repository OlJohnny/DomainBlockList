#!/usr/bin/env bash
# github.com/OlJohnny | 2019
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace         # uncomment the previous statement for debugging


### reset files ###
rm -f ./.blocklist-fin*
rm -f ./blocklist-rev
touch ./blocklist-rev


### reverse and sort the list ###
echo -e "\n<$(date +"%T")> Sorting and Cleaning Blocklist..."
rev ./blocklist-fin > ./.blocklist-fin0
sort --unique ./.blocklist-fin0 --output=./.blocklist-fin1
sed --in-place '/^[[:space:]]*$/d' ./.blocklist-fin1
rev ./.blocklist-fin1 > ./.blocklist-fin2


### indent the list ###
echo -e "\n<$(date +"%T")> Indenting Blocklist..."
while read -r line
do
        if [ $(($(echo -n "$line" | wc -c)%2)) -eq 0 ]
        then
                line=$(sed 's/^/ /' <<< $line)
        fi

        while [ $(echo -n "$line" | wc -c) -le 31 ]
        do
                line=$(sed 's/^/  /' <<< $line)
        done
		echo "$line" >> ./blocklist-rev
done < "./.blocklist-fin2"



##### FINISHING #####
### reset files ###
rm -f ./.blocklist-fin*
echo -e "\n<$(date +"%T")> Finished\nExiting..."