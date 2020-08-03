#!/usr/bin/env bash
# github.com/OlJohnny | 2020
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace         # uncomment the previous statement for debugging


### reset files ###
rm -f ./.blocklist-fin*
rm -f ./.blocklist-2dots*


### reverse and sort the list ###
read -p $'\e[96mMake backwards sorted and indented blocklist (this can take up to an hour)? (y|n): \e[0m' var1
if [[ "${var1}" == "y" ]]
then
	echo -e "\n<$(date +"%T")> Sorting and Cleaning Blocklist..."
	rm -f ./.blocklist-rev.txt
	rev ./blocklist-fin.txt > ./.blocklist-fin0.txt
	sort --unique ./.blocklist-fin0.txt --output=./.blocklist-fin1.txt
	sed --in-place '/^[[:space:]]*$/d' ./.blocklist-fin1.txt
	rev ./.blocklist-fin1.txt > ./.blocklist-fin2.txt

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
		echo "$line" >> ./blocklist-rev.txt
	done < "./.blocklist-fin2"
fi


### find most common domain.tld ###
echo -e "\n<$(date +"%T")> Finding most common 'domain.tld'..."
rev ../blocklist-fin.txt | sort --unique --output=./.blocklist-2dots0.txt
awk -F "." '{ print $1,$2 }' ./.blocklist-2dots0.txt > ./.blocklist-2dots1.txt
rev ./.blocklist-2dots1.txt > ./.blocklist-2dots2.txt
sed --in-place 's/ /\./g' ./.blocklist-2dots2.txt
uniq -c ./.blocklist-2dots2.txt | sort --ignore-leading-blanks --general-numeric-sort --reverse | grep --extended-regexp --invert-match --file=./2dots-whitelist.txt > ./blocklist-2dots.txt



### reset files ###
rm -f ./.blocklist-fin*
rm -f ./.blocklist-2dots*
echo -e "\n<$(date +"%T")> Finished\nExiting..."
