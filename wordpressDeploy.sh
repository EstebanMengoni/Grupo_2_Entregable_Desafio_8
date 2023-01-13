#!/bin/bash

function verificarInstalacion () {
    sudo apt list --installed | grep $1
        if [ $? != 0 ]
        then
            sudo apt-get -y install $1
        else
            sudo apt list --upgradable | grep $1
            if [ $? != 0 ]
            then
                sudo apt-get -y upgrade $1
            fi
        fi
}

function main () {
    verificarInstalacion default-mysql-server
    verificarInstalacion nginx
    verificarInstalacion wordpress
}
main