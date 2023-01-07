#!/bin/bash

function verificarInstalacion () {
    sudo apt list --installed | grep $1
        if [ $? !=0 ]
        then
            sudo apt install $1
        fi
    sudo apt list --upgradable | grep $1
        if [ $? !=0 ]

        then
            sudo apt upgrade $1
        fi
}



function main () {
	find /etc/apt/sources.list.d/elastic-7.x.list | grep $?
	if [ $?  = 1]
	then
                curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

                echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

                sudo apt update
	fi	

    verificarInstalacion elasticsearch
    verificarInstalacion kibana
    verificarInstalacion logstash
}
main