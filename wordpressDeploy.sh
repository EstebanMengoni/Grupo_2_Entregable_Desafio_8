#!/bin/bash

function verificarInstalacion () {
    sudo apt list --installed | grep $1
        if [ $? != 0 ]
        then
            sudo apt install $1
            
        fi
    sudo apt list --upgradable | grep $1
        if [ $? != 0 ]

        then
            sudo apt upgrade $1
        fi
}

function main () {
    verificarInstalacion mysql-server
    verificarInstalacion nginx
    verificarInstalacion wordpress
}
main