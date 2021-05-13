#!/bin/bash

set -e

#This script is for creating an sftp user account.

password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
expire=$(date -d "90 days" +"%Y-%m-%d")

if [ $# -eq 0 ]  #check for user argument and prompt if not found
  then
    echo Please input desired user name.
    read user
    echo Creating user account and setting permissions for user: $user
    useradd -g sftponly -e $expire $user
    chown -R root /home/sftponly/$user/
    chmod -R 700 /home/sftponly/$user/
    mkdir /home/sftponly/$user/dropbox
    chown $user /home/sftponly/$user/dropbox/

    echo $password |passwd $user --stdin
else
    echo Creating user account and setting permissions for user: $1
    useradd -g sftponly -e $expire $1
    chown -R root /home/sftponly/$1/
    chmod -R 700 /home/sftponly/$1/
    mkdir /home/sftponly/$1/dropbox
    chown $1 /home/sftponly/$1/dropbox/
    echo $password |passwd $1 --stdin
fi

echo ""
echo Script complete. Account will expire:
echo ""
echo $expire
echo ""
echo Account password is: $password
echo ""
echo NOTE: Please document this password as this is the only time it will be visible.
