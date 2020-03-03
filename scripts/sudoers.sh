#!/bin/sh -eux

# Only add the secure path line if it is not already present
grep -q 'secure_path' /etc/sudoers \
  || sed -i -e '/Defaults\s\+env_reset/a Defaults\tsecure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' /etc/sudoers;

# Set up password-less sudo for the vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_vagrant;
chmod 440 /etc/sudoers.d/99_vagrant;

# Set up password-less sudo for the vagrant user
ANSIBLE_DISABLED=${ANSIBLE_DISABLED:-no}
case "$ANSIBLE_DISABLED" in
  true|yes|y|1) echo 'Ansible installation is disabled, continuing with next step !'; ;;
  *)
    echo 'ansible ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/99_ansible;
    chmod 440 /etc/sudoers.d/99_ansible;
      ;;
esac
