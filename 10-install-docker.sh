#!/usr/bin/env bash

USERNAME=$(id -un)
GROUPNAME=$(id -gn)

echo "Preparing environment for ${USERNAME}:${GROUPNAME}"

# Uninstall old versions
echo -e "\nRemoving outdated docker related packages, if any"
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install prerequisites
echo -e "\nInstalling prerequisites"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --auto-remove \
  apt-transport-https \
  apt-utils \
  libnss3-tools \
  curl \
  gnupg-agent \
  ubuntu-fan \
  software-properties-common \
  dnsmasq \
  nano

# Register docker repository
echo -e "\nRegistering docker repository"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker Engine
echo -e "\nInstalling Docker Engine"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --auto-remove \
  docker-ce \
  docker-ce-cli \
  containerd.io

# Install docker-compose
echo -en "\nInstalling docker-compose ... "
curl -s https://api.github.com/repos/docker/compose/releases/latest |
  grep browser_download_url |
  grep docker-compose-Linux-x86_64 |
  cut -d '"' -f 4 |
  wget -qi -
chmod +x docker-compose-Linux-x86_64
sudo mv docker-compose-Linux-x86_64 /usr/local/bin/docker-compose
rm docker-compose-Linux-x86_64.sha256
echo "done"

# Use Docker as a non-root user
echo -e "\nAllowing user to run Docker as a non-root user"
sudo adduser "${USERNAME}" docker

echo -e "\nSuccessfully installed Docker.\n\nNow copy .env-dist to .env and edit .env to fit your needs.\nAfter that, run 20-prepare-host.sh to complete the installation.\n\n"
