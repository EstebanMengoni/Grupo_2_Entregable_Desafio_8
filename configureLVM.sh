#!/bin/bash

function tamanoLogicas () {

echo "Escriba el tamano de la particion logica para $1 (Ej. 5G)"

read tamano

sudo lvcreate -L $tamano -n $1Logs $2

}

function montar () {
    sudo mkfs.ext4 /dev/$1/$2

    sudo mount /dev/$1/$2 /var/log/$3
}

function main () {

echo "Escriba el disco en el cual quiere implementar LVM"

read disco

sudo pvcreate /dev/$disco

echo "Escriba el nombre del grupo LVM"

read grupo

sudo vgcreate $grupo /dev/$disco

tamanoLogicas mysql $grupo
tamanoLogicas elasticsearch $grupo

sudo vgchange -ay $grupo

montar $grupo mysqlLogs mysql
montar $grupo elasticsearchLogs elasticsearch

df
} 
main