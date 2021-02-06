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
