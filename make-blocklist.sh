#!/bin/bash

sudo rm -rf ./blocklist-work
sudo rm -rf ./blocklist-fin

sudo touch ./blocklist-work
sudo touch ./blocklist-fin

sudo chmod -f 775 ./blocklist-work
sudo chmod -f 775 ./blocklist-fin

sudo wget -i ./blocklist-links -O - >> ./blocklist-work
#-q             --quiet                 Verhindert dass wget Informationen auf der Konsole ausgibt.
# -i DATEI      --input-file=DATEI      Liest URLs aus einer Text- oder HTML-Datei aus.
# -O DATEI      --output-document=DATEI Schreibe in DATEI. Kann nicht mit -N verwendet werden. Mit "-O -" schreibt wget den Inhalt der heruntergeladenen Datei in die StdOut.

sudo sed -i 's/0.0.0.0//' ./blocklist-work
sudo sed -i 's/127.0.0.1//' ./blocklist-work
sudo sed -i 's/ //g' ./blocklist-work
sudo sed -i 's/[[:blank:]]//g' ./blocklist-work
sudo sed -i 's/[[:space:]]//g' ./blocklist-work
#-i             --in-place              Die Textdatei wird verändert, anstatt das Ergebnis auf Standardausgabe auszugeben.

sudo sort -u ./blocklist-work -o ./blocklist-work1
#-u             --unique                Sortierung ohne doppelte Zeilen

sudo mv ./blocklist-work1 ./blocklist-work

sudo grep -E -v -f ./regex-blacklist ./blocklist-work > ./blocklist-fin
# -v            --invert-match          Invertiert die Suche und liefert alle Zeilen die nicht auf das gesuchte Muster passen.
# -f Datei      --file=Datei            beziehe die Muster aus Datei, eines je Zeile. Eine leere Datei enthält keine Muster und passt somit auf keinen String.

sudo rm -rf ./blocklist-work