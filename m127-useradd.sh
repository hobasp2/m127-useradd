#!/bin/bash
#############################
# Creator: holgerb
# Path: /home/holgerb/
# Script Name: m127-useradd.sh
# Creation Date: 2022-08-28

# Script liest aus einer csv-Datei Vor- und Nachnamen und setzt diese als Benutzernamen zusammen, legt den User (samt Homeverzeichnis, bashrc, usw.) mit einem "Einmalpasswort" aus der csv an.
# Das Script vergleicht Geburtsdatum des Users mit dem aktuellen Datum, bei mehr als 200 Jahren Differenz wird der Useraccount gelockt.
# Das Script selber fuehrt keine Befehle auf dem System aus, die Befehle werden in Execfiles geschrieben, die man root mit source starten kann.
# Vorteil der Execfiles ist, dass man sich die Befehle vorher nochmal anschauen kann und z.B. Probehalber einzeln ausfuehren kann. 
#
## Additional Packages: #####
# Fuer die Datumsberechnung mit "let" wurde das Packet "dateutils" installiert.
#
## Pitfalls and Issues #####
# Die Datumsberechnung beruecksichtigt keine Schaltjahre.
#
## Solved:
# Passwoerter aus der csv sollten nicht mit der -y Option fuer Sonderzeichen von pwgen erstellt werden, 
# weil die sonst als code interpretiert werden koennen, das quoting von zweiten  Echo in Zeile 36 habe ich noch nicht hingekriegt.
#
#############################

List1="/home/holgerb/m127-useradd/Fullnames.csv"
execfileadd="/home/holgerb/m127-useradd/execfile-add" 
execfiledel="/home/holgerb/m127-useradd/execfile-del"
execfilelock="/home/holgerb/m127-useradd/execfile-lock"

rm -f $execfileadd
rm -f $execfiledel
rm -f $execfilelock

while read -r line; do

  USERP1=$(echo "$line" | cut -f2 -d"," | cut -c1-2) # nimmt die ersten zwei Zeichen aus dem csv-Feld 2, also dem  Vornamen.
  USERP2=$(echo "$line" | cut -f1 -d",") # nimmt den kompletten Nachnamen aus Feld 1 (ein Wort ohne Umlaute etc. wurde vorher in einer Tabelle schon so vorbereitet).
  USER=$(echo "$USERP1$USERP2" | tr '[:upper:]' '[:lower:]' ) # Baut den Usernamen zusammen und sorgt fuer Kleinschreibung.
  PASSWTMP=$(echo "$line" | cut -f3 -d","{})@ # holt das Passwort aus Feld 3.
  BORN=$(echo "$line" | cut -f4 -d",") # holt das Geburtsdatum aus Feld 4.

  echo -e "useradd -m $USER -s /bin/bash; echo "$USER:$PASSWTMP" | chpasswd; chage -d 0 $USER" >> $execfileadd  # Schreibt die Commands zum Useraccounts erstellen in das Execfile. 

  echo -e "userdel -rf $USER" >> $execfiledel # Schreibt die Commands um die Accounts wieder zu loeschen in ein Execfile.

  let DIFF=(`date +%s -d $(date +%Y%m%d)`-`date +%s -d $BORN`)/31557600 # Berechnet Differenz von aktuellem Datum mit dem Geburtsdatum aus der csv-Datei.   
 
  if [ $DIFF -gt 200 ]; then # Bei mehr als 200 Jahren Differenz wird der Userlogin gelockt.
    	echo -e "usermod -L $USER" >> $execfilelock # Schreibt weiteres Execfile um die Accounts der alten Herrschaften zu locken.
  fi

done < $List1

exit 0


##############################################################################################
# SNIPPETS ###################################################################################
##############################################################################################

# sudo cat /etc/shadow | grep -i ":!"
# let DIFF=(`date +%s -d $(date +%+4Y%m%d)`-`date +%s -d 16771130`)/31557600
# shellcheck /home/holgerb/m127-useradd
# pwgen -Bnc 8 28 | xclip -selection c

# USER=$(echo "$line" | awk -F, '{ print $1 }')
# echo -e "useradd -m $USER -s /bin/bash; echo $USER:$PASSWTMP | chpasswd" >> $execfileadd 
# List1="/home/holgerb/m127-useradd/UserList1.csv"

####### sshConnection to ubuntuServerVM ########

# ssh holgerb@192.168.178.100

# ssh -p 1234 holgerb@localhost

# scp -P1234 /home/holgerb/Dokumente/wiss/Semester_03/m127-Server/m127-Stoff/Fullnames.csv holgerb@localhost:/home/holgerb/m127-useradd


