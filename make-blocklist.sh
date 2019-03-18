#!/bin/bash

rm -rf ./blocklist-work


wget -q -i ./blocklists-source -O "-" >> ./blocklist-work
#-q			 --quiet				Verhindert dass wget Informationen auf der Konsole ausgibt.
# -i DATEI	--input-file=DATEI		Liest URLs aus einer Text- oder HTML-Datei aus.
# -O DATEI	--output-document=DATEI	Schreibe in DATEI. Diese Option kann nicht mit der Option -N zusammen verwendet werden. Gibt man -O "-" an, so schreibt wget den Inhalt der heruntergeladenen Datei direkt auf die Standardausgabe (stdout) des Terminals.


grep -v -f ./RegEx-Blacklist ./blocklist-work
# -v		--invert-match			Invertiert die Suche und liefert alle Zeilen die nicht auf das gesuchte Muster passen.
# -f Datei	--file=Datei			beziehe die Muster aus Datei, eines je Zeile. Eine leere Datei enthält keine Muster und passt somit auf keinen String.