#!/bin/bash

rm -rf /etc/pihole/regex_temp/
sudo git clone git@github.com:OlJohnny/DomainBlockList.git /etc/pihole/regex_temp/
rm -rf /etc/pihole/regex.list
mv -f /etc/pihole/regex_temp/blocklist /etc/pihole/regex.list
rm -rf /etc/pihole/regex_temp/
sudo chmod -Rf 775 /etc/pihole/regex.list && sudo chown -Rf pihole:www-data /etc/pihole/regex.list