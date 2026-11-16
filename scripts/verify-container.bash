#!/bin/bash
#
# verify-container.bash
# Docker and TML dashboard lab
#
# Runs the checks for the lab on the VM that hosts the container:
#   1. Docker is installed and the daemon is reachable
#   2. The TML container is running and port 9005 is published
#   3. The dashboard page answers on the forwarded port
#   4. The expected tmux sessions exist inside the container
#
# Usage:  ./verify-container.bash [dockerhub_user] [port]
# Example: ./verify-container.bash maadsdocker 9005
#
# Written and tested by: Avraham Abel

USER_ID="${1:-maadsdocker}"
PORT="${2:-9005}"
IMAGE="$USER_ID/seneca-iot-tml-kafka-amd64"
SESSIONS="kafka zookeeper preprocess-data-python-8001 preprocess-data-viper-8001 preprocess2-data-python-8002 preprocess2-data-viper-8002 produce-iot-data-python-8000 produce-iot-data-viper-8000 visualization-viperviz-9005"

# Welcome splash screen
printf '#%.0s' {1..50}; printf '\n'
printf '  Docker Lab - Container Check\n'
printf '#%.0s' {1..50}; printf '\n\n'

PASS=0
FAIL=0

check() {
    # check "description" command...
    local desc="$1"; shift
    if "$@" >/dev/null 2>&1; then
        printf '[ OK ]   %s\n' "$desc"
        PASS=$((PASS + 1))
    else
        printf '[FAIL]   %s\n' "$desc" >&2
        FAIL=$((FAIL + 1))
    fi
}

check "Docker is installed" command -v docker
check "Docker daemon is reachable" docker info

CID="$(docker ps --filter "ancestor=$IMAGE" --format '{{.ID}}' 2>/dev/null | head -n 1)"

printf '\n== Container ==\n'
if [ -n "$CID" ]; then
    docker ps --filter "id=$CID"
else
    printf 'No running container found for %s\n' "$IMAGE" >&2
fi
printf '\n'

printf '== Checks ==\n'
check "Container for $IMAGE is running" test -n "$CID"
check "Host port $PORT is published to 9005" \
    bash -c "docker port '$CID' 9005/tcp 2>/dev/null | grep -q ':$PORT'"

if command -v curl >/dev/null 2>&1; then
    check "HTTP 200 from the dashboard page on port $PORT" \
        bash -c "[ \"\$(curl -s -o /dev/null -m 5 -w '%{http_code}' http://localhost:$PORT/iot-failure-seneca.html)\" = 200 ]"
else
    printf '[SKIP]   curl not installed, dashboard check skipped\n'
fi

if [ -n "$CID" ]; then
    TMUX_LIST="$(docker exec "$CID" tmux ls 2>/dev/null)"
    for s in $SESSIONS; do
        check "tmux session $s" bash -c "printf '%s' \"\$1\" | grep -q \"^$s:\"" _ "$TMUX_LIST"
    done
fi

printf '\nResult: %d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
