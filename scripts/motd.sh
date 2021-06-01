#!/bin/bash -eux

greeter="
        Ce système est maintenu pour le projet
        Packer Debian par PetitBoutDeCloud

        Plus de renseignements à l'adresse:

        https://github.com/jokebox90/packer-debian
"

if [ -d /etc/update-motd.d ]; then
    MOTD_CONFIG='/etc/update-motd.d/99-greeter'

    cat >> "$MOTD_CONFIG" <<GREETER
#!/bin/bash

cat <<'EOF'
$greeter
EOF
GREETER

    chmod 0755 "$MOTD_CONFIG"
else
    echo "$greeter" >> /etc/motd
fi
