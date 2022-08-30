# m127-useradd
bashscript for automation to add users with homedirectory and initalpassword from a csv to an UbuntuServer, 
also there is a Lock Option depending on a Timedifferenz to a date in the csv-list

Script liest aus einer csv-Datei Vor- und Nachnamen und setzt diese als Benutzernamen zusammen, legt den User (samt Homeverzeichnis, bashrc, usw.) mit einem "Einmalpasswort" aus der csv an.

Das Script vergleicht Geburtsdatum des Users mit dem aktuellen Datum, bei mehr als 200 Jahren Differenz wird der Useraccount gelockt.

Das Script selber fuehrt keine Befehle auf dem System aus, die Befehle werden in Execfiles geschrieben, die man root mit source starten kann.

Vorteil der Execfiles ist, dass man sich die Befehle vorher nochmal anschauen kann und z.B. Probehalber einzeln ausfuehren kann. 
