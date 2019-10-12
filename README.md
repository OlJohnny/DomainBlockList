# DomainBlockList
## Intent
This ``Blocklist`` is intended to be used with PiHole or any other Domain Blocker, which is capable of using RegEx statements.


## Whitelisting
As this list aims to block most tracking and ad services you may need to specifically whitelist the following domains:
Akamai CDN (used by Origin, Adobe etc.) [whitelisted by default]:
- ``akamaihd.net``
- ``akamaized.net``
- ``akadns.net``
- ``edgekey.net``

YouTube [whitelisted by default]: 
- ``www.youtube-nocookie.com``
- ``yt3.ggpht.com``

Dominos Checkout [blacklisted by default]:
- ``live.adyen.com``

Sourceforge Download [blacklisted by default]:
- ``quantcast.mgr.consensu.org``
- ``static.quantcast.mgr.consensu.org``
- ``vendorlist.consensu.org``

Other sites:
- ``www.googleadservices.com`` [blacklisted by default] Google Sponsored Search Results, Google Shopping
- ``asadcdn.com`` [whitelisted by default] BILD.de AdBlock-Blocker*


## Explaining the files

### ``blocklist-fin``
This file contains every domain, which gets pulled from sources of ``blocklist-links`` and filtered with ``regex-blacklist`` & ``regex-whitelist``. It gets outputted by ``make-blocklist.sh``.



### ``blocklist-links``
This file contains links to lists of to-be-blocked domains. It gets used by ``make-blocklist.sh``.



### ``get-regex-blacklist.sh``
You can download this script and put it into ``/etc/cron.daily`` (remove the '.sh' when doing so) or simply run it, to get the latest ``regex-blacklist`` put into place (``/etc/pihole/regex.list``) for pi-hole to use.

You may need to run ``sudo dos2unix get-regex-blacklist.sh`` and ``sudo chmod +x get-regex-blacklist.sh`` for it being able to be executed.



### ``insert-blocklist.sh``
This script just references ``blocklist-fin`` as a local Blocklist in Pi-Hole (is view- and switchable in 'Settings -> Blocklists').

You may need to run ``sudo dos2unix insert-blocklist.sh`` and ``sudo chmod +x insert-blocklist.sh`` for it being able to be executed.



### ``make-blocklist.sh``
This script pulls to-be-blocked lists of domains from ``blocklist-links`` and ``custom-links`` (You can suplly your own links to blocklists here, without them being overwritten from cloning this repo).

All blocklists from the supplied sources get merged into one large list, sorted and then get all domains which match the RegEx statements provided in ``regex-blacklist`` & ``regex-whitelist`` removed.

Any remaining domains get put into ``blocklist-fin`` for you to use.

You may need to run ``sudo dos2unix make-blocklist.sh`` and ``sudo chmod +x make-blocklist.sh`` for it being able to be executed.



### ``regex-blacklist``
Any RegEx statements provided in this file are used by ``make-blocklist.sh`` to remove all matching lines from ``blocklist-fin``.

This RegEx list can also be used by pi-hole's built-in RegEx Domain Blocker. You can use ``get-regex-blacklist.sh`` to do this.



### ``regex-whitelist``
Any RegEx statements provided in this file are used by ``make-blocklist.sh`` to remove all matching lines from ``blocklist-fin`` without being blocked by pi-hole's built-in RegEx Domain Blocker, when using ``regex-blacklist``.



## analysis-tools
These tools are supposed to help with finding Domains, that use a large number of Sub-Domains and are thus effective to be blocked by ``regex-blacklist``

### ``indent-sort.sh``
Sorts ``blocklist-fin`` from the last character, removes any subdomains (xxx.domain.tld) and counts how often the main domain appears. The output gets put into ``blocklist-2dots``.

``2dots-whitelist`` contains country-specific tld that consist of two parts (e.g. co.uk) and some sites, whose subdomains can't all be blocked and would screw with the results. (e.g. blogs)