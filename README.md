# DomainBlockList
## Usage
This ``Blocklist`` is intended to be used with PiHole or any other Domain Blocker, which is capable of using RegEx statements.
``git-get-domainblockList-regex.sh`` is a script which clones the latest version of the ``Blocklist`` and replaces the existing ``/etc/pihole/regex.list`` from pihole.
It is recommended to put this script into ``cron.daily`` to keep the ``Blocklist`` up-to-date.

## Whitelisting
As this list aims to block most tracking and ad services you may need to specifically whitelist the following domains, as they may :
- (www.)facebook.com *to use Facebook*
- (www.)instagram.com *to use Instagram*
- www.youtube-nocookie.com *embedded Youtube Videos*
- yt3.ggpht.com *Youtube Thumbnails*
- asadcdn.com *to undergo the BILD.de AdBlock-Blocker*