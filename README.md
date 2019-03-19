# DomainBlockList
## Usage
This ``Blocklist`` is intended to be used with PiHole or any other Domain Blocker, which is capable of using RegEx statements.
``git-get-domainblockList-regex.sh`` is a script which clones the latest version of the ``Blocklist`` and replaces the existing ``/etc/pihole/regex.list`` from pihole.
It is recommended to put this script into ``cron.daily`` to keep the ``Blocklist`` up-to-date.


## How To Use The Scripts
### git-get-domainblockList-regex.sh
Run ``chmod +x git-get-domainblockList-regex.sh`` to make it executeable and ``dos2unix git-get-domainblockList-regex.sh`` to convert any Windows specific symbols, line breaks, etc.
This script will automatically get the current ``regex-blacklist`` and put it in place for pihole to use.

### make-blocklist.sh
Run ``chmod +x make-blocklist.sh`` to make it executeable and ``dos2unix make-blocklist.sh`` to convert any Windows specific symbols, line breaks, etc.
You may also add write permissions for ``blocklist-fin``, ``blocklist-links`` or ``regex-blacklist``.
This script will get blocklists (the links of which can be added in ``blocklist-links``) and give out all Domains, which do NOT match a given set of RegEx statements (can be edited in ``regex-blacklist``)

## Whitelisting
As this list aims to block most tracking and ad services you may need to specifically whitelist the following domains, as they may :
- (www.)facebook.com *to use Facebook*
- (www.)instagram.com *to use Instagram*
- www.youtube-nocookie.com *embedded Youtube Videos*
- yt3.ggpht.com *Youtube Thumbnails*
- asadcdn.com *to undergo the BILD.de AdBlock-Blocker*