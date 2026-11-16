#!/bin/bash
#
# build-container.bash
# Docker and TML dashboard lab
#
# Builds your own TML container from the Dockerfile in the current
# directory and optionally pushes it to Docker Hub.
#
# Usage:  ./build-container.bash <dockerhub_user> [normal|fast] [push]
# Example: ./build-container.bash myuser fast push
#
#   normal  builds from scratch with --no-cache (about 20 minutes)
#   fast    reuses cached layers from an earlier build (about 5 minutes)
#   push    runs docker push after a successful build (log in first: docker login)
#
# Get the Dockerfile from:
#   https://github.com/smaurice101/raspberrypi/blob/main/docker/Dockerfile
#
# Written and tested by: Avraham Abel

USER_ID="${1:-}"
MODE="${2:-fast}"
PUSH="${3:-}"

if [ -z "$USER_ID" ]; then
    printf 'Usage: %s <dockerhub_user> [normal|fast] [push]\n' "$0" >&2
    exit 1
fi

IMAGE="$USER_ID/seneca-iot-tml-kafka-amd64"

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  Docker Lab - Build the TML Container\n'
printf '#%.0s' {1..50}; printf '\n\n'

if [ ! -f Dockerfile ]; then
    printf 'No Dockerfile in %s. Copy it from the link in this script header.\n' "$PWD" >&2
    exit 1
fi

printf '== Building %s (%s) ==\n' "$IMAGE" "$MODE"
if [ "$MODE" = "normal" ]; then
    docker build -t "$IMAGE" --build-arg CHIP=AMD64 --no-cache --network=host . || exit 1
else
    docker build -t "$IMAGE" --build-arg CHIP=AMD64 --build-arg CACHEBUST="$(date +%s)" --network=host . || exit 1
fi

if [ "$PUSH" = "push" ]; then
    printf '\n== Pushing %s:latest ==\n' "$IMAGE"
    docker push "$IMAGE:latest" || exit 1
fi

printf '\nDone. Run it with: docker run -p 9005:9005 %s\n' "$IMAGE"
