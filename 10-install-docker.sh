#!/usr/bin/env bash

# Uninstall old versions
apt remove docker docker-engine docker.io containerd runc

# Install using the repository
apt update
apt install -y --auto-remove \
  apt-transport-https \
  ca-certificates \
  libnss3-tools \
  curl \
  gnupg-agent \
  ubuntu-fan \
  software-properties-common \
  dnsmasq
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker Engine
apt update
apt install -y --auto-remove \
  docker-ce \
  docker-ce-cli \
  containerd.io

# Create the docker group
groupadd docker

# Activate the group without restart
newgrp docker

# Use Docker as a non-root user
usermod -aG docker "$(id -un)"
