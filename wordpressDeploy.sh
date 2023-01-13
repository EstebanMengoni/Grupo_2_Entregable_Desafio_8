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
    
    wget https://wordpress.org/latest.tar.gz
    tar vxf latest.tar.gz
    sudo mv /wordpress/* /var/www/html/ejemplo.com/
    rm wordpress
    sudo chown -R www-data: /var/www/html/ejemplo.com
}
main