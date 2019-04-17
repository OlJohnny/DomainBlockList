# DomainBlockList
## Intent
This ``Blocklist`` is intended to be used with PiHole or any other Domain Blocker, which is capable of using RegEx statements.


## Whitelisting
As this list aims to block most tracking and ad services you may need to specifically whitelist the following domains:
- ``www.facebook.com`` main Facebook page
- ``static.xx.fbcdn.net`` CSS source for main Facebook page
- ``www.pinterest.com`` main Pinterest page
- ``www.pinterest.de`` main Pinterest page
- ``www.instagram.com`` main Instagram page
- ``www.youtube-nocookie.com`` embedded Youtube Videos
- ``yt3.ggpht.com`` (some) Youtube Thumbnails
- ``cdn.syndication.twimg.com`` Embedded Twitter Posts
- ``platform.twitter.com`` Embedded Twitter Posts
- ``www.googleadservices.com`` Google Sponsored Search Results, Google Shopping
- ``asadcdn.com`` BILD.de AdBlock-Blocker*


## Explaining the files
### ``blocklist-fin``
This file contains every domain, which gets pulled from sources out of ``regex-blacklist`` and filtered with ``regex-blacklist`` & ``regex-whitelist``. It gets outputted by ``make-blocklist.sh``.


It can be pulled via (TBD)/blocklist-fin


### ``blocklist-links``
This file contains links to lists of to-be-blocked domains. It gets used by ``make-blocklist.sh``.


### ``get-regex-blacklist.sh``
You can download this script and put it into ``/etc/cron.daily`` (remove the '.sh' when doing so) or simply run it, to get the latest ``regex-blacklist`` and put into place (``/etc/pihole/regex.list``) for pi-hole to use.

You may need to run ``sudo dos2unix get-regex-blacklist.sh`` and ``sudo chmod +x get-regex-blacklist.sh`` for it being able to be executed.


It can be pulled via (TBD)/get-regex


### ``insert-blocklist.sh``
This script just references ``blocklist-fin`` as a Blocklist in Pi-Hole (is view- and switchable in 'Settings -> Blocklists'), so that you can use it locally .

You may need to run ``sudo dos2unix insert-blocklist.sh`` and ``sudo chmod +x insert-blocklist.sh`` for it being able to be executed.


It can be pulled via (TBD)/get-regex


### ``make-blocklist.sh``
This script pulls to-be-blocked lists of domains from ``blocklist-links`` and ``custom-links`` (You can suplly your own links to blocklists here, without them being overwritten from cloning this repo, as this file will NEVER be pushed by me).

It then removes any and all domains which match the RegEx statements provided in ```regex-blacklist`` & ``regex-whitelist`` out of the pulled lists.

Any remaining domains get put into ``blocklist-fin`` for you to use.

You may need to run ``sudo dos2unix make-blocklist.sh`` and ``sudo chmod +x make-blocklist.sh`` for it being able to be executed.


It can be pulled via (TBD)/make-blocklist


### ``regex-blacklist``
Any RegEx statements provided in this file are used by ``make-blocklist.sh`` to minimize and remove 'duplicates' from ``blocklist-fin``.

This RegEx list can also be used by pi-hole's built-in RegEx Domain Blocker. You can use ``get-regex-blacklist.sh`` to do this.


It can be pulled via (TBD)/regex-blacklist


### ``regex-blacklist``
Any RegEx statements provided in this file are used by ``make-blocklist.sh`` to minimize and remove 'duplicates' from ``blocklist-fin`` without being blocked by pi-hole's built-in RegEx Domain Blocker.