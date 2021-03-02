#!/bin/bash

printf '

__  __                  _        __ __
\ \/ /___ _____  ____  (_)____  / //_/
 \  / __ `/ __ \/ __ \/ / ___/ / ,<
 / / /_/ / / / / / / / (__  ) / /| |
/_/\__,_/_/ /_/_/ /_/_/____(_)_/ |_|

'
read -p $"Please enter your hash : " hash
if [[ ${#hash} -eq 128 ]] ; then
	echo ""
	echo "SHA512 hashtype detected"
        read -p  $"Do you want to use the default wordlist (y/n) ? " choice
                if [[ "$choice" = "n" ]] || [[ "$choice" = "no" ]] ;then
                echo ""
                read -p $"Please enter you're wordlist's name : " wordlist
                        if [ -f "$wordlist" ]; then
                        hashcat -m 0 $hash -o result.txt $wordlist --force --potfile-disable
                        else
                        echo "Error file"
                        fi
                elif [[ "$choice" = "y" ]] || [[ "$choice" = "yes" ]] ;then
                hashcat -m 1700 $hash -o result.txt rockyou.txt --force --potfile-disable
                fi

	elif [[ ${#hash} -eq 64 ]] ; then
	echo ""
	echo "SHA256 hashtype detected"
        read -p  $"Do you want to use the default wordlist (y/n) ? " choice
                if [[ "$choice" = "n" ]] || [[ "$choice" = "no" ]] ;then
                echo ""
                read -p $"Please enter you're wordlist's name : " wordlist
                        if [ -f "$wordlist" ]; then
                        hashcat -m 0 $hash -o result.txt $wordlist --force --potfile-disable
                        else
                        echo "Error file"
                        fi
                elif [[ "$choice" = "y" ]] || [[ "$choice" = "yes" ]] ;then
                hashcat -m 1400 $hash -o result.txt rockyou.txt --force --potfile-disable
                fi

	elif [[ ${#hash} -eq 40 ]] ; then
	echo ""
	echo "SHA1 hashtype detected"
        read -p  $"Do you want to use the default wordlist (y/n) ? " choice
                if [[ "$choice" = "n" ]] || [[ "$choice" = "no" ]] ;then
                echo ""
                read -p $"Please enter you're wordlist's name : " wordlist
                        if [ -f "$wordlist" ]; then
                        hashcat -m 0 $hash -o result.txt $wordlist --force --potfile-disable
                        else
                        echo "Error file"
                        fi
                elif [[ "$choice" = "y" ]] || [[ "$choice" = "yes" ]] ;then
                hashcat -m 100 $hash -o result.txt rockyou.txt --force --potfile-disable
                fi

	elif [[ ${#hash} -eq 32 ]] && [[ $hash =~ [A-Z] ]]; then
	echo ""
	echo "NTLM hashtype detected"
        read -p  $"Do you want to use the default wordlist (y/n) ? " choice
                if [[ "$choice" = "n" ]] || [[ "$choice" = "no" ]] ;then
                echo ""
                read -p $"Please enter you're wordlist's name : " wordlist
                        if [ -f "$wordlist" ]; then
                        hashcat -m 0 $hash -o result.txt $wordlist --force --potfile-disable
                        else
                        echo "Error file"
                        fi
                elif [[ "$choice" = "y" ]] || [[ "$choice" = "yes" ]] ;then
                hashcat -m 1000 $hash -o result.txt rockyou.txt --force --potfile-disable
                fi

	elif [[ ${#hash} -eq 32 ]] && [[ $hash =~ [a-z] ]]; then
	echo ""
	echo "MD5 hashtype detected"
	read -p  $"Do you want to use the default wordlist (y/n) ? " choice
		if [[ "$choice" = "n" ]] || [[ "$choice" = "no" ]] ;then
		echo ""
		read -p $"Please enter you're wordlist's name : " wordlist
			if [ -f "$wordlist" ]; then
			hashcat -m 0 $hash -o result.txt $wordlist --force --potfile-disable
			else
			echo "Error file"
			fi
		elif [[ "$choice" = "y" ]] || [[ "$choice" = "yes" ]] ;then
		hashcat -m 0 $hash -o result.txt rockyou.txt --force --potfile-disable
		fi

	elif [[ "${hash: -1}" == "=" ]]; then
	echo ""
	echo "Base64 hashtype detected"
	echo ""
	sleep 1
	echo "Password Found : "
	echo $hash | base64 -d

	# Potentiellement changer le sens et dire : si la variable ne contient pas : abcdef et 0-9 alors ; A REVOIR
	elif [[ $hash == *[abcdef]* ]] && [[ $hash =~ [0-9] ]] || [[ "${hash:0:1}" == "x"  ]]; then
	echo ""
	echo "Hexa hashtype detected"
        read -p  $"Do you want to use the default wordlist (y/n) ? " choice
                if [[ "$choice" = "n" ]] || [[ "$choice" = "no" ]] ;then
                echo ""
                read -p $"Please enter you're wordlist's name : " wordlist
                        if [ -f "$wordlist" ]; then
                        hashcat -m 0 $hash -o result.txt $wordlist --force --potfile-disable
                        else
                        echo "Error file"
                        fi
                elif [[ "$choice" = "y" ]] || [[ "$choice" = "yes" ]] ;then
                hashcat -m 0 $hash -o result.txt rockyou.txt --force --potfile-disable
                fi

	else
	echo "no hash detected"

fi

#si la variable contient le mot windows ...
#if [[ $variable =~ windows ]]
