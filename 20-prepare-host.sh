#!/usr/bin/env bash

# Load environment
source .env

# Check and update /etc/hosts
GREP=$(grep -F "${DOMAIN}" /etc/hosts)
if [ "$GREP" == "" ]; then
  echo "127.0.0.1  ${DOMAIN}" | sudo tee -a /etc/hosts
else
  sudo sed -i "s/${GREP}/127.0.0.1  ${DOMAIN}/" /etc/hosts
fi

echo "address=/${DOMAIN}/127.0.0.1" | sudo tee "/etc/dnsmasq.d/${DOMAIN}.conf"

# Create local authority; requires browser's master password
echo "${BROWSER_PASSWORD}\n" | ./bin/mkcert -install

# Generate certificates
./bin/mkcert -cert-file "certificates/${DOMAIN}.pem" -key-file "certificates/${DOMAIN}-key.pem" ${DOMAIN} "*.${DOMAIN}" localhost 127.0.0.1 ::1

# Update the certificates
sudo update-ca-certificates

# Prepare certification store for LetsEncrypt
echo "" >certificates/acme.json
chmod 0600 certificates/acme.json
