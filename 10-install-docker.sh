#!/usr/bin/env bash

# Uninstall old versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install using the repository
sudo apt-get update
sudo apt-get install -y --auto-remove \
  apt-transport-https \
  ca-certificates \
  libnss3-tools \
  curl \
  gnupg-agent \
  ubuntu-fan \
  software-properties-common \
  dnsmasq
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y --auto-remove \
  docker-ce \
  docker-ce-cli \
  containerd.io

# Use Docker as a non-root user
sudo usermod -aG docker "$(id -un)"
