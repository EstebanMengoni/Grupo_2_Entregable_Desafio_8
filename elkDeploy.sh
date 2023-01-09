#!/bin/bash

function verificarInstalacion () {
    sudo apt list --installed | grep $1
        if [ $? != 0 ]
        then
            sudo apt install $1
        else
            sudo apt list --upgradable | grep $1
            if [ $? != 0 ]
            then
                sudo apt upgrade $1
            fi
        fi 
}

function habilitarServidor (){
    sudo systemctl enable $1
    sudo systemctl start $1
}

function main () {
    verificarInstalacion curl
	find /etc/apt/sources.list.d/elastic-7.x.list
	if [ $?  = 1 ] 
	then
                curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

                echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

                sudo apt update
	fi	

    verificarInstalacion elasticsearch
    verificarInstalacion kibana
    verificarInstalacion logstash
    verificarInstalacion filebeat 
    habilitarServidor elasticsearch
    habilitarServidor kibana 
    habilitarServidor logstash
    habilitarServidor filebeat
}
main