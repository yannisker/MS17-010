#!/bin/bash

printf '
__  __                  _        __ __
\ \/ /___ _____  ____  (_)____  / //_/
 \  / __ `/ __ \/ __ \/ / ___/ / ,<
 / / /_/ / / / / / / / (__  ) / /| |
/_/\__,_/_/ /_/_/ /_/_/____(_)_/ |_|


'
trap 'printf "\n";stop;exit 1' 2

menu() {

printf "    \e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;91m Pentest d'un hôte \e[0m    \n"
printf "    \e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;91m Pentest d'un sous-réseau \e[0m   \n"
printf "    \e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;91m Intrusion Global \e[0m \n"

read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose an option: \e[0m\en' option


if [[ $option == 1 ]]; then
gnome-terminal -- bash -c /root/Partage/OTHER/script/ms17-010/final_01/intrusion/pentest-hote.sh

elif [[ $option == 2 ]]; then
gnome-terminal -- bash -c /root/Partage/OTHER/script/ms17-010/final_01/intrusion/pentest-sousreseau.sh

elif [[ $option == 3 ]]; then
gnome-terminal -- bash -c /root/Partage/OTHER/script/ms17-010/final_01/intrusion/pentest-global.sh

else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
menu
fi
}

menu
