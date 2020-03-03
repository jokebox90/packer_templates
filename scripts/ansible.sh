#!/bin/sh -eux

ANSIBLE_DISABLED=${ANSIBLE_DISABLED:-no};
case "$ANSIBLE_DISABLED" in
  true|yes|y|1) exit 0; ;;
esac

case `uname -m` in
  x86_64) arch="amd64"; ;;
  armv7l) arch="armhf"; ;;
  *) echo "Architecture not support, aborting !"; exit 1; ;;
esac

debian_version="`lsb_release -r | awk '{print $2}'`";
major_version="`echo $debian_version | awk -F. '{print $1}'`";

HOME_DIR="${HOME_DIR:-/var/lib/ansible}";

adduser --system --group --home $HOME_DIR --shell /bin/bash ansible;
echo "ansible:4Ns1Bl3!" | chpasswd -

apt-get -y install git;

if [ "$major_version" -ge "9" ]; then
  apt-get -y install python3-pip;
  su -l ansible -c 'bash -c "pip3 install --user ansible cryptography"';
else
  apt-get -y install python-pip;
  su -l ansible -c 'bash -c "pip install --user ansible cryptography"';
fi

echo "export PATH=$HOME_DIR/.local/bin:\$PATH" >>$HOME_DIR/.profile

mkdir -p $HOME_DIR/.ssh;

chown -v ansible:ansible $HOME_DIR/.ssh;
chmod -v go-rwsx $HOME_DIR/.ssh;

mkdir -p $HOME_DIR/library;
mkdir -p $HOME_DIR/roles;

chown -v ansible:ansible $HOME_DIR/library;
chmod -v 0750 $HOME_DIR/library;

chown -v ansible:ansible $HOME_DIR/roles;
chmod -v 0750 $HOME_DIR/roles;

mkdir -p /etc/ansible/group_vars;
mkdir -p /etc/ansible/host_vars;

tee /etc/ansible/ansible.cfg <<ANSIBLE
[defaults]
inventory  = /etc/ansible/hosts
library    = $HOME_DIR/library
log_path   = /var/log/ansible/ansible.log
roles_path = $HOME_DIR/roles
ANSIBLE

tee /etc/ansible/hosts <<INVENTORY
[all]
localhost
INVENTORY

tee /etc/ansible/host_vars/localhost.yml <<LOCALHOST
ansible_connection: local
ansible_python_interpreter: /usr/bin/python3
LOCALHOST

find /etc/ansible -type d -exec chown -v ansible:ansible '{}' \;;
find /etc/ansible -type f -exec chown -v ansible:ansible '{}' \;;

find /etc/ansible -type d -exec chmod -v 0750 '{}' \;;
find /etc/ansible -type f -exec chmod -v 0640 '{}' \;;

mkdir -p /var/log/ansible;
touch /var/log/ansible/ansible.log;

find /var/log/ansible -type d -exec chown -v ansible:ansible '{}' \;;
find /var/log/ansible -type f -exec chown -v ansible:ansible '{}' \;;

find /var/log/ansible -type d -exec chmod -v 0770 '{}' \;;
find /var/log/ansible -type f -exec chmod -v 0660 '{}' \;;
