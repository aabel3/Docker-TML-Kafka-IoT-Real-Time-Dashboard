#!/bin/bash
#
# install-docker.bash
# Docker and TML dashboard lab
#
# Installs Docker on the Ubuntu VM and confirms it works:
#   1. Install docker.io and docker-compose
#   2. Allow the current user to reach the Docker socket
#   3. Run the hello-world test container
#
# Usage:  ./install-docker.bash
#
# Written and tested by: Avraham Abel

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  Docker Lab - Install Docker\n'
printf '#%.0s' {1..50}; printf '\n\n'

printf '== Installing Docker ==\n'
sudo apt-get update
sudo apt-get install -y docker.io docker-compose || exit 1

printf '\n== Starting the Docker service ==\n'
sudo systemctl enable --now docker

# Lets docker run without sudo (lab convenience; it opens the socket to every user)
printf '\n== Allowing access to the Docker socket ==\n'
sudo chmod 666 /var/run/docker.sock

printf '\n== Testing with hello-world ==\n'
if docker run hello-world; then
    printf '\n[ OK ]   Docker is set up correctly\n'
else
    printf '\n[FAIL]   hello-world did not run. If a pull failed with "no such file or directory",\n' >&2
    printf '         run: sudo systemctl restart docker\n' >&2
    exit 1
fi
