#!/bin/bash
#
# run-tml-dashboard.bash
# Docker and TML dashboard lab
#
# Pulls and runs the TML container, forwarding host port 9005 to
# container port 9005, then prints the dashboard URL.
#
# Usage:  ./run-tml-dashboard.bash [dockerhub_user] [port]
# Example: ./run-tml-dashboard.bash maadsdocker 9005
#
# Use maadsdocker for the pre-built image, or your own Docker Hub ID
# for the image you built and pushed.
#
# Written and tested by: Avraham Abel

USER_ID="${1:-maadsdocker}"
PORT="${2:-9005}"
IMAGE="$USER_ID/seneca-iot-tml-kafka-amd64"
URL="http://localhost:$PORT/iot-failure-seneca.html?topic=iot-preprocess2,iotpreprocess&offset=-1&groupid=&rollbackoffset=500&topictype=prediction&append=0&secure=1"

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  Docker Lab - Run the TML Dashboard\n'
printf '#%.0s' {1..50}; printf '\n\n'

if ! command -v docker >/dev/null 2>&1; then
    printf 'Docker is not installed. Run ./install-docker.bash first.\n' >&2
    exit 1
fi

printf '== Pulling %s ==\n' "$IMAGE"
docker pull "$IMAGE" || exit 1

printf '\n== Dashboard URL (open it in a browser, then press START STREAMING) ==\n'
printf '%s\n' "$URL"
printf 'Data can take a few minutes to appear.\n\n'

printf '== Running the container (Ctrl+C stops it) ==\n'
docker run -p "$PORT:9005" "$IMAGE"
