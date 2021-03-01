#!/bin/bash

echo "
######################
###\ \##/ /#| |#/ /###
####\ \/ /##| |/ /####
#####\  /###| |\ \####
#####/ /####| |#\ \###
####/_/#####|_|##\_\##
######################

"

trap 'printf "\n";stop;exit 1' 2

menu() {

printf "    \e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;91m Pentest d'un hôte \e[0m    \n"
printf "    \e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;91m Pentest d'un sous-réseau \e[0m   \n"
printf "    \e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;91m Intrusion Global \e[0m \n"

read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Choose an option: \e[0m\en' option


if [[ $option == 1 ]]; then
gnome-terminal -- bash -c /root/Partage/OTHER/script/ms17-010/pentest-hote.sh

elif [[ $option == 2 ]]; then
gnome-terminal -- bash -c /root/Partage/OTHER/script/ms17-010/pentest-sousreseau.sh

elif [[ $option == 3 ]]; then
gnome-terminal -- bash -c /root/Partage/OTHER/script/ms17-010/pentest-global.sh

else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
menu
fi
}

menu
