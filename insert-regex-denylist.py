#!./env/bin/python

import time
import sqlite3

# step 0: create a sql connection to sqlite db from file
db_file = '/etc/pihole/gravity.db'
db_connector = None
try:
    db_connector = sqlite3.connect(db_file)
except Error as error:
    print(error)
db_cursor = db_connector.cursor()

# step 1: delete old "regex-denylist" entries
db_cursor.execute("DELETE FROM domainlist WHERE comment LIKE 'oljohnny_domainblocklist'")

# step 2: get highest line number in use + 1 from gravity.db
db_cursor.execute("SELECT MAX(id) FROM domainlist")
line_number_list = db_cursor.fetchall()
for line_number_tuple in line_number_list:
    line_number_last = line_number_tuple[0]
    line_number = line_number_last + 1
unix_time = int(time.time())

# step 3: add regex-denylist entries
regex_denylist = open('regex-denylist.txt', 'r').read().splitlines()    # open regex denylist file, but *not* in memory; strip newlines
for line in regex_denylist:     # load lines of file one-by-one into memory
    if line.startswith("()"):   # disable "()...()" entries
        enable_bit = 0
    else:
        enable_bit = 1
    db_cursor.execute("INSERT INTO domainlist VALUES ('%s', '3', '%s', '%s', '%s', '%s', 'oljohnny_domainblocklist')" % (line_number, line, enable_bit, unix_time, unix_time))   # id, type, domain, enabled, date_added, date_modified, comment
    line_number += 1            # iterate unique line number

# step 4: commit changes & close db connection
db_connector.commit()
db_connector.close()

# step 5: print changed entries
new_entries = line_number - line_number_last
print(f"Added {new_entries} new entries.")
