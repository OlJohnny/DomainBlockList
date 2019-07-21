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
read -p $'\e[96mMake backwards sorted and indented blocklist (this can take up to an hour)? (y|n): \e[0m' var1
if [[ "${var1}" == "y" ]]
then
	echo -e "\n<$(date +"%T")> Sorting and Cleaning Blocklist..."
	rev ./blocklist-fin > ./.blocklist-fin0
	sort --unique ./.blocklist-fin0 --output=./.blocklist-fin1
	sed --in-place '/^[[:space:]]*$/d' ./.blocklist-fin1
	rev ./.blocklist-fin1 > ./.blocklist-fin2

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
fi


### find most common domain.tld ###
echo -e "\n<$(date +"%T")> Finding most common 'domain.tld'..."
rev ../blocklist-fin | sort --unique --output=./.blocklist-2dots0
awk -F "." '{ print $1,$2 }' ./.blocklist-2dots0 > ./.blocklist-2dots1
rev ./.blocklist-2dots1 > ./.blocklist-2dots2
sed --in-place 's/ /\./g' ./.blocklist-2dots2
uniq -c ./.blocklist-2dots2 | sort --ignore-leading-blanks --general-numeric-sort --reverse | grep --extended-regexp --invert-match --file=./2dots-whitelist > ./blocklist-2dots



##### FINISHING #####
### reset files ###
rm -f ./.blocklist-fin*
rm -f ./.blocklist-2dots*
echo -e "\n<$(date +"%T")> Finished\nExiting..."
