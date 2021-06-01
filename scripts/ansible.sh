#!/bin/bash -eux

ANSIBLE_PATH="${ANSIBLE_PATH:-/var/lib/ansible}"
ANSIBLE_CONF_PATH="/etc/ansible"
ANSIBLE_LOG_PATH="/var/log/ansible"

GOSU="gosu ansible:ansible"
PIP="$GOSU $ANSIBLE_PATH/env/bin/pip"
PYTHON="$GOSU $ANSIBLE_PATH/env/bin/python3"
TEE="$GOSU tee"
CURL="$GOSU curl"

apt-get install -y --no-install-recommends --no-install-suggests \
  python3-venv \
  gosu

mkdir -p \
  $ANSIBLE_CONF_PATH/group_vars \
  $ANSIBLE_CONF_PATH/host_vars \
  $ANSIBLE_LOG_PATH \
  $ANSIBLE_PATH

chown ansible:ansible \
  $ANSIBLE_CONF_PATH \
  $ANSIBLE_CONF_PATH/group_vars \
  $ANSIBLE_CONF_PATH/host_vars \
  $ANSIBLE_LOG_PATH \
  $ANSIBLE_PATH

$GOSU mkdir -p \
  $ANSIBLE_PATH/.ssh \
  $ANSIBLE_PATH/library \
  $ANSIBLE_PATH/roles

$GOSU touch $ANSIBLE_LOG_PATH/ansible.log
$GOSU /usr/bin/env python3 -m venv $ANSIBLE_PATH/env

$PIP install --upgrade pip setuptools
$PIP install \
  ansible \
  cryptography \
  pyopenssl \
  prettytable \
  netaddr \
  passlib

echo "export PATH=$ANSIBLE_PATH/env/bin:\$PATH" | $TEE -a $ANSIBLE_PATH/.profile

privkey_url="https://gitlab.com/petitboutdecloud/packer-templates/-/raw/master/ssh/id_ansible"
$CURL --insecure --location "$privkey_url" | $TEE $ANSIBLE_PATH/.ssh/id_rsa

pubkey_url="https://gitlab.com/petitboutdecloud/packer-templates/-/raw/master/ssh/id_ansible.pub"
$CURL --insecure --location "$pubkey_url" | $TEE $ANSIBLE_PATH/.ssh/authorized_keys
cp $ANSIBLE_PATH/.ssh/authorized_keys $ANSIBLE_PATH/.ssh/id_rsa.pub

$TEE $ANSIBLE_CONF_PATH/ansible.cfg <<ANSIBLE
[defaults]

# - Paths
inventory  = $ANSIBLE_CONF_PATH/hosts
library    = $ANSIBLE_PATH/library
log_path   = $ANSIBLE_LOG_PATH/ansible.log
roles_path = $ANSIBLE_PATH/roles

# - Behavior
deprecation_warnings = False
host_key_checking = False
gathering = explicit

# - Reporting
callback_whitelist = timer, debug, profile_tasks, skippy, counter_enabled, yaml, slack
stdout_callback = yaml
bin_ansible_callbacks = True
ANSIBLE

$TEE $ANSIBLE_CONF_PATH/hosts <<INVENTORY
[all]
localhost
INVENTORY

$TEE $ANSIBLE_CONF_PATH/host_vars/localhost.yml <<LOCALHOST
ansible_connection: local
ansible_python_interpreter: $ANSIBLE_PATH/env/bin/python3
LOCALHOST
