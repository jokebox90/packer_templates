#!/bin/sh -eux

# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

mkdir -p $HOME_DIR/.ssh;

pubkey_url="https://raw.githubusercontent.com/jokebox90/packer_templates/master/ssh/id_vagrant.pub";
curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;

chown -R vagrant $HOME_DIR/.ssh;
chmod -R go-rwsx $HOME_DIR/.ssh;
