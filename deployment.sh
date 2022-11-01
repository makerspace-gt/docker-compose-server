#!/bin/bash

export storageboxuser=u290442-sub2
export ghusers="igami stikkx leon2225 mattn81 mneuhaus"
export fqdn=igami.makerspace-gt.de

export storagebox=//$storageboxuser.your-storagebox.de/$storageboxuser
export storageboxmount=/mnt/storagebox
export storageboxcredentials=/etc/storageboxcredentials.txt
export gitdir=/var/docker
export DEBIAN_FRONTEND=noninteractive

# check for mount password
if ! [ -f $storageboxcredentials ]; then
    read -sp 'enter the storage-box password: ' storageboxpassword
    echo username=$storageboxuser > $storageboxcredentials
    echo password=$storageboxpassword >> $storageboxcredentials
    chmod 0600 $storageboxcredentials
fi

# import ssh keys
ssh-import-id-gh $ghusers

# set hostname
hostnamectl set-hostname $fqdn

# update system
apt update
apt -y dist-upgrade
apt -y autoremove
apt clean

# cgroups v2 user namespace remapping for FreeIPA server container
# https://hub.docker.com/r/freeipa/freeipa-server
echo '{ "userns-remap": "default" }' > /etc/docker/daemon.json  

# install requirements
apt -y install \
  git \
  docker \
  docker-compose \
  make

# mount storagebox
if [[ $(findmnt $storageboxmount | wc -c) == 0 ]]; then
    apt -y install cifs-utils
    mkdir $storageboxmount
    echo "$storagebox  $storageboxmount  cifs  rw,credentials=$storageboxcredentials,_netdev,uid=1000,gid=1000,dir_mode=0750  0 0" >> /etc/fstab
    mount -a
fi

# clone repository
if ! [ -d $gitdir ]; then
    git clone https://github.com/makerspace-gt/docker-compose-server.git $gitdir
    cd $gitdir
else
    cd $gitdir
    git pull
fi

# create docker network
docker network create web

# start services
make start

# reboot mashine
# reboot
